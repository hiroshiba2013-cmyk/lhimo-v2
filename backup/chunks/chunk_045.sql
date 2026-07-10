-- ============================================================
-- FILE: 20260326110835_fix_subscription_type_save_plan_name.sql
-- ============================================================
/*
  # Fix Subscription Type - Salva Nome Piano Completo
  
  1. Problema Risolto
    - Il campo subscription_type salvava solo "monthly" o "annual"
    - Causava confusione tra piani business e customer nel pannello admin
    
  2. Soluzione
    - Aggiorna i trigger per salvare il nome completo del piano
    - Aggiunge il sync automatico del subscription_type quando viene creato/aggiornato un abbonamento
    
  3. Note
    - Funziona sia per customer che per business
    - Il nome del piano viene preso dalla tabella subscription_plans
*/

-- Funzione per sincronizzare subscription_type con il piano selezionato
CREATE OR REPLACE FUNCTION public.sync_subscription_type_from_plan()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  plan_name text;
BEGIN
  -- Ottieni il nome del piano
  SELECT name INTO plan_name
  FROM subscription_plans
  WHERE id = NEW.plan_id;
  
  -- Aggiorna il profilo con il nome del piano
  IF plan_name IS NOT NULL THEN
    UPDATE profiles
    SET 
      subscription_type = plan_name,
      subscription_status = NEW.status
    WHERE id = NEW.customer_id;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Elimina trigger esistente se presente
DROP TRIGGER IF EXISTS trigger_sync_subscription_type ON subscriptions;

-- Crea trigger per sincronizzare subscription_type
CREATE TRIGGER trigger_sync_subscription_type
  AFTER INSERT OR UPDATE ON subscriptions
  FOR EACH ROW
  WHEN (NEW.status IN ('active', 'trial'))
  EXECUTE FUNCTION sync_subscription_type_from_plan();

-- Aggiorna la funzione trial per customer
CREATE OR REPLACE FUNCTION public.create_trial_for_customer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_plan_id uuid;
  base_plan_name text;
BEGIN
  -- Solo per utenti customer, non per business o admin
  IF NEW.user_type != 'customer' THEN
    RETURN NEW;
  END IF;

  -- Ottieni l'ID e il nome del piano base (1 persona, mensile, più economico, NON business)
  SELECT id, name INTO base_plan_id, base_plan_name
  FROM subscription_plans
  WHERE max_persons = 1 
    AND billing_period = 'monthly'
    AND name NOT LIKE '%Business%'
  ORDER BY price ASC
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano disponibile non business
  IF base_plan_id IS NULL THEN
    SELECT id, name INTO base_plan_id, base_plan_name
    FROM subscription_plans
    WHERE name NOT LIKE '%Business%'
    ORDER BY price ASC
    LIMIT 1;
  END IF;

  -- Crea l'abbonamento trial solo se esiste un piano e non ci sono già abbonamenti
  IF base_plan_id IS NOT NULL THEN
    INSERT INTO subscriptions (
      customer_id,
      plan_id,
      status,
      start_date,
      end_date,
      trial_end_date,
      payment_method_added,
      reminder_sent
    )
    VALUES (
      NEW.id,
      base_plan_id,
      'trial',
      NOW(),
      NOW() + INTERVAL '30 days',
      NOW() + INTERVAL '30 days',
      false,
      false
    )
    ON CONFLICT DO NOTHING;
    
    -- Aggiorna il profilo con il nome del piano e lo status trial
    UPDATE profiles
    SET 
      subscription_type = base_plan_name,
      subscription_status = 'trial',
      subscription_expires_at = NOW() + INTERVAL '30 days'
    WHERE id = NEW.id;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Aggiorna la funzione trial per business
CREATE OR REPLACE FUNCTION public.create_trial_for_business()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_plan_id uuid;
  base_plan_name text;
BEGIN
  -- Solo per utenti business, non per customer o admin
  IF NEW.user_type != 'business' THEN
    RETURN NEW;
  END IF;

  -- Ottieni l'ID e il nome del piano base business (1 sede, mensile, più economico)
  SELECT id, name INTO base_plan_id, base_plan_name
  FROM subscription_plans
  WHERE max_persons = 1 
    AND billing_period = 'monthly'
    AND name LIKE '%Business%'
  ORDER BY price ASC
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano business disponibile
  IF base_plan_id IS NULL THEN
    SELECT id, name INTO base_plan_id, base_plan_name
    FROM subscription_plans
    WHERE name LIKE '%Business%'
    ORDER BY price ASC
    LIMIT 1;
  END IF;

  -- Crea l'abbonamento trial solo se esiste un piano e non ci sono già abbonamenti
  IF base_plan_id IS NOT NULL THEN
    INSERT INTO subscriptions (
      customer_id,
      plan_id,
      status,
      start_date,
      end_date,
      trial_end_date,
      payment_method_added,
      reminder_sent
    )
    VALUES (
      NEW.id,
      base_plan_id,
      'trial',
      NOW(),
      NOW() + INTERVAL '30 days',
      NOW() + INTERVAL '30 days',
      false,
      false
    )
    ON CONFLICT DO NOTHING;
    
    -- Aggiorna il profilo con il nome del piano e lo status trial
    UPDATE profiles
    SET 
      subscription_type = base_plan_name,
      subscription_status = 'trial',
      subscription_expires_at = NOW() + INTERVAL '30 days'
    WHERE id = NEW.id;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;


-- ============================================================
-- FILE: 20260326111850_fix_subscription_deletion_for_admin_cleanup.sql
-- ============================================================
/*
  # Fix Eliminazione Abbonamenti per Admin
  
  1. Problema
    - Il trigger `prevent_trial_plan_changes` blocca la DELETE anche quando chiamata da admin
    - Gli abbonamenti non vengono eliminati quando l'admin cancella un utente
    
  2. Soluzione
    - Modifica il trigger per permettere DELETE se chiamata nel contesto SECURITY DEFINER
    - Gli admin possono eliminare abbonamenti anche in trial
    
  3. Note
    - La funzione admin_delete_user_account ora può eliminare correttamente gli abbonamenti
    - Il trigger protegge ancora gli utenti normali dal cancellare abbonamenti trial
*/

-- Modifica la funzione per permettere DELETE da funzioni SECURITY DEFINER
CREATE OR REPLACE FUNCTION prevent_trial_plan_changes()
RETURNS TRIGGER AS $$
BEGIN
  -- Permetti agli admin di fare qualsiasi cosa
  IF EXISTS (
    SELECT 1 FROM admins 
    WHERE user_id = auth.uid()
  ) THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Blocca DELETE durante trial solo se non viene da una funzione SECURITY DEFINER
  IF TG_OP = 'DELETE' THEN
    -- Permetti DELETE se il profilo dell'utente sta per essere eliminato
    -- (la funzione admin_delete_user_account usa SECURITY DEFINER)
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = OLD.customer_id) THEN
      RETURN OLD;
    END IF;
    
    IF OLD.status = 'trial' THEN
      RAISE EXCEPTION 'Non puoi cancellare un abbonamento durante il periodo di prova. Devi attendere la scadenza del trial.';
    END IF;
    RETURN OLD;
  END IF;

  -- Blocca INSERT se esiste già un trial attivo
  IF TG_OP = 'INSERT' THEN
    IF EXISTS (
      SELECT 1 FROM subscriptions
      WHERE customer_id = NEW.customer_id
        AND status = 'trial'
        AND trial_end_date > NOW()
    ) THEN
      RAISE EXCEPTION 'Hai già un periodo di prova attivo. Non puoi attivare un nuovo abbonamento fino alla scadenza del trial.';
    END IF;
    RETURN NEW;
  END IF;

  -- Blocca UPDATE del piano durante trial
  IF TG_OP = 'UPDATE' THEN
    IF OLD.status = 'trial' AND OLD.trial_end_date > NOW() THEN
      -- Permetti solo aggiornamenti a campi non-critici
      IF NEW.plan_id != OLD.plan_id THEN
        RAISE EXCEPTION 'Non puoi cambiare piano durante il periodo di prova. Se cambi piano perdi il diritto alla prova gratuita di 30 giorni.';
      END IF;
      
      -- Permetti solo modifica di payment_method_added, reminder_sent, status
      IF NEW.customer_id != OLD.customer_id OR
         NEW.start_date != OLD.start_date OR
         NEW.end_date != OLD.end_date OR
         NEW.trial_end_date != OLD.trial_end_date THEN
        RAISE EXCEPTION 'Non puoi modificare i dettagli dell''abbonamento durante il periodo di prova.';
      END IF;
    END IF;
    RETURN NEW;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260326111904_cleanup_orphaned_subscriptions_v2.sql
-- ============================================================
/*
  # Pulizia Abbonamenti Orfani - v2
  
  1. Problema
    - Gli abbonamenti possono rimanere nel database dopo l'eliminazione di un utente
    - Questo causa confusione nel pannello admin
    
  2. Soluzione
    - Elimina tutti gli abbonamenti senza un customer valido
    - La funzione admin_delete_user_account già gestisce l'eliminazione
    
  3. Note
    - Pulizia una tantum degli abbonamenti orfani esistenti
    - Non serve trigger perché la funzione admin_delete_user_account già elimina gli abbonamenti
*/

-- Pulizia abbonamenti orfani esistenti (se ce ne sono)
DO $$
BEGIN
  DELETE FROM subscriptions
  WHERE customer_id NOT IN (SELECT id FROM profiles);
  
  RAISE NOTICE 'Abbonamenti orfani eliminati con successo';
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Errore durante la pulizia: %', SQLERRM;
END $$;


-- ============================================================
-- FILE: 20260326142358_fix_subscription_type_constraint_allow_plan_names.sql
-- ============================================================
/*
  # Fix Subscription Type Constraint - Permetti Nomi Piano
  
  1. Problema
    - Il CHECK constraint su profiles.subscription_type permette solo 'monthly' o 'annual'
    - I trigger salvano il nome completo del piano (es. "Trial Base", "Business Base")
    - Causa errore: "new row violates check constraint profiles_subscription_type_check"
    
  2. Soluzione
    - Rimuove il constraint esistente
    - Aggiunge un nuovo constraint che permette NULL o qualsiasi stringa
    
  3. Note
    - Mantiene la compatibilità con i dati esistenti
    - Permette flessibilità per salvare qualsiasi nome di piano
*/

-- Rimuovi il constraint esistente
ALTER TABLE profiles 
DROP CONSTRAINT IF EXISTS profiles_subscription_type_check;

-- Aggiungi un nuovo constraint che permette NULL o qualsiasi valore text
ALTER TABLE profiles
ADD CONSTRAINT profiles_subscription_type_check 
CHECK (subscription_type IS NULL OR length(subscription_type) > 0);

-- Commento
COMMENT ON CONSTRAINT profiles_subscription_type_check ON profiles IS 'Permette NULL o qualsiasi nome di piano valido';


-- ============================================================
-- FILE: 20260326143138_fix_registration_subscription_conflicts.sql
-- ============================================================
/*
  # Fix Registration Subscription Conflicts
  
  1. Problema
    - Durante la registrazione vengono creati doppi abbonamenti:
      * Uno dal RegisterForm (frontend)
      * Uno dai trigger create_trial_for_customer/business (database)
    - Questo causa confusione e l'abbonamento non viene visualizzato
    
  2. Soluzione
    - Disattiva i trigger automatici di creazione trial
    - Lascia che sia solo il frontend a creare l'abbonamento
    - Il trigger sync_subscription_type_from_plan si occuperà di aggiornare il nome del piano
    
  3. Note
    - Il frontend gestirà la creazione completa dell'abbonamento
    - I trigger saranno solo di sincronizzazione, non di creazione
*/

-- Disabilita il trigger di creazione automatica trial per customer
DROP TRIGGER IF EXISTS trigger_create_trial_subscription_customer ON profiles;

-- Disabilita il trigger di creazione automatica trial per business
DROP TRIGGER IF EXISTS trigger_create_trial_subscription_business ON profiles;

-- Mantieni SOLO il trigger di sincronizzazione del subscription_type
-- (questo rimane attivo e funzionante)

-- Aggiungi commento per chiarezza
COMMENT ON FUNCTION create_trial_for_customer IS 'DISABILITATA - La creazione del trial è gestita dal frontend durante la registrazione';
COMMENT ON FUNCTION create_trial_for_business IS 'DISABILITATA - La creazione del trial è gestita dal frontend durante la registrazione';


-- ============================================================
-- FILE: 20260326143203_update_sync_trigger_include_expires_at.sql
-- ============================================================
/*
  # Update Sync Trigger - Include Expires At
  
  1. Problema
    - Il trigger sync_subscription_type_from_plan aggiorna solo subscription_type e status
    - Non aggiorna subscription_expires_at
    - Questo causa inconsistenza nei dati del profilo
    
  2. Soluzione
    - Aggiorna il trigger per includere anche subscription_expires_at
    - Prende la data di fine abbonamento dalla tabella subscriptions
    
  3. Note
    - Mantiene la sincronizzazione completa tra subscriptions e profiles
*/

CREATE OR REPLACE FUNCTION public.sync_subscription_type_from_plan()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  plan_name text;
BEGIN
  -- Ottieni il nome del piano
  SELECT name INTO plan_name
  FROM subscription_plans
  WHERE id = NEW.plan_id;
  
  -- Aggiorna il profilo con il nome del piano, lo status e la data di scadenza
  IF plan_name IS NOT NULL THEN
    UPDATE profiles
    SET 
      subscription_type = plan_name,
      subscription_status = NEW.status,
      subscription_expires_at = NEW.end_date
    WHERE id = NEW.customer_id;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Commento esplicativo
COMMENT ON FUNCTION sync_subscription_type_from_plan IS 'Sincronizza subscription_type, status e expires_at dal piano selezionato in subscriptions';


-- ============================================================
-- FILE: 20260326143233_cleanup_duplicate_subscriptions_on_registration.sql
-- ============================================================
/*
  # Cleanup Duplicate Subscriptions
  
  1. Problema
    - Gli utenti potrebbero avere abbonamenti duplicati creati dai trigger e dal frontend
    - Questo causa confusione nella dashboard
    
  2. Soluzione
    - Identifica e rimuovi abbonamenti duplicati
    - Mantieni solo l'abbonamento più recente per ogni utente
    
  3. Sicurezza
    - Opera solo su abbonamenti trial
    - Non tocca abbonamenti attivi pagati
*/

-- Rimuovi abbonamenti duplicati, mantenendo solo il più recente per ogni utente
WITH duplicates AS (
  SELECT 
    id,
    customer_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id 
      ORDER BY created_at DESC, id DESC
    ) as rn
  FROM subscriptions
  WHERE status IN ('trial', 'active')
)
DELETE FROM subscriptions
WHERE id IN (
  SELECT id 
  FROM duplicates 
  WHERE rn > 1
);

-- Aggiorna i profili che non hanno subscription_type impostato
-- ma hanno un abbonamento attivo
UPDATE profiles p
SET 
  subscription_type = sp.name,
  subscription_status = s.status,
  subscription_expires_at = s.end_date
FROM subscriptions s
JOIN subscription_plans sp ON s.plan_id = sp.id
WHERE p.id = s.customer_id
  AND s.status IN ('trial', 'active')
  AND (p.subscription_type IS NULL OR p.subscription_status IS NULL);


-- ============================================================
-- FILE: 20260326151557_fix_admin_delete_user_disable_trial_trigger.sql
-- ============================================================
/*
  # Fix Admin Delete User - Disable Trial Protection Trigger

  1. Problem
    - When admin tries to delete a user with an active trial subscription
    - The trigger "enforce_trial_plan_restrictions" blocks the deletion
    - Admin should be able to delete any user regardless of trial status

  2. Solution
    - Temporarily disable the trial protection trigger during deletion
    - Re-enable it after deletion completes
*/

CREATE OR REPLACE FUNCTION admin_delete_user_account(user_id_to_delete uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  caller_user_id uuid;
  is_caller_admin boolean;
  user_business_id uuid;
  user_fiscal_code text;
  family_fiscal_codes text[];
  family_member_ids uuid[];
BEGIN
  -- Ottieni l'ID dell'utente che sta chiamando la funzione
  caller_user_id := auth.uid();
  
  IF caller_user_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Verifica che il chiamante sia un admin
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE user_id = caller_user_id
  ) INTO is_caller_admin;

  IF NOT COALESCE(is_caller_admin, false) THEN
    RAISE EXCEPTION 'Permesso negato: solo gli admin possono eliminare gli utenti';
  END IF;

  -- Verifica che l'utente da eliminare esista
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = user_id_to_delete) THEN
    RAISE EXCEPTION 'Utente non trovato';
  END IF;

  -- Ottieni il codice fiscale dell'utente
  SELECT fiscal_code INTO user_fiscal_code
  FROM profiles
  WHERE id = user_id_to_delete;

  -- Ottieni i codici fiscali dei membri della famiglia
  SELECT array_agg(fiscal_code)
  INTO family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = user_id_to_delete
    AND fiscal_code IS NOT NULL
    AND fiscal_code != '';

  -- Ottieni gli ID dei membri della famiglia
  SELECT array_agg(id)
  INTO family_member_ids
  FROM customer_family_members
  WHERE customer_id = user_id_to_delete;

  -- ========================================
  -- DISABILITA TRIGGER DI PROTEZIONE TRIAL
  -- ========================================
  
  ALTER TABLE subscriptions DISABLE TRIGGER enforce_trial_plan_restrictions;

  -- ========================================
  -- GESTIONE RIFERIMENTI CHE DEVONO RESTARE
  -- ========================================
  
  -- Gestisci le recensioni approvate da questo utente (mantieni la review ma rimuovi il riferimento all'admin)
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_id_to_delete;

  -- Gestisci i report revisionati da questo utente (mantieni il report ma rimuovi il riferimento all'admin)
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_id_to_delete;

  -- ========================================
  -- ELIMINAZIONE CONTENUTI UTENTE CUSTOMER
  -- ========================================

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_id_to_delete;
  DELETE FROM favorite_classified_ads WHERE user_id = user_id_to_delete;
  DELETE FROM favorite_job_postings WHERE user_id = user_id_to_delete;

  -- Elimina le redemptions degli sconti dell'utente
  DELETE FROM discount_redemptions WHERE customer_id = user_id_to_delete;

  -- Elimina TUTTE le recensioni dell'utente (proprie e dei membri della famiglia)
  DELETE FROM reviews WHERE customer_id = user_id_to_delete;
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM reviews WHERE family_member_id = ANY(family_member_ids);
  END IF;

  -- Elimina TUTTI gli annunci classificati (propri e dei membri della famiglia)
  DELETE FROM classified_ads WHERE user_id = user_id_to_delete;
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM classified_ads WHERE family_member_id = ANY(family_member_ids);
  END IF;

  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_id_to_delete;

  -- Elimina l'attività utente e i log
  DELETE FROM user_activity WHERE user_id = user_id_to_delete;
  DELETE FROM activity_log WHERE user_id = user_id_to_delete;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_id_to_delete;

  -- ========================================
  -- ELIMINAZIONE CONTENUTI BUSINESS
  -- ========================================

  -- Elimina le attività registrate (dalla tabella registered_businesses)
  DELETE FROM registered_business_locations WHERE business_id IN (
    SELECT id FROM registered_businesses WHERE owner_id = user_id_to_delete
  );
  DELETE FROM registered_businesses WHERE owner_id = user_id_to_delete;

  -- Elimina le attività aggiunte dall'utente (ma non ancora registrate)
  DELETE FROM unclaimed_business_locations WHERE added_by = user_id_to_delete;

  -- ========================================
  -- ELIMINAZIONE JOB SEEKING
  -- ========================================

  -- Elimina le richieste di lavoro (proprie e dei membri della famiglia)
  DELETE FROM job_requests WHERE customer_id = user_id_to_delete;
  
  -- Elimina gli annunci job seeker dell'utente E dei membri della famiglia
  DELETE FROM job_seekers WHERE user_id = user_id_to_delete;
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM job_seekers WHERE family_member_id = ANY(family_member_ids);
  END IF;
  
  -- Elimina le visualizzazioni degli annunci di lavoro
  DELETE FROM job_views WHERE user_id = user_id_to_delete;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_id_to_delete;

  -- Elimina annunci di lavoro creati come business
  DELETE FROM job_postings WHERE business_id IN (
    SELECT id FROM registered_businesses WHERE owner_id = user_id_to_delete
  );

  -- ========================================
  -- ELIMINAZIONE MESSAGGI (SISTEMA UNIFICATO)
  -- ========================================

  -- Elimina i messaggi inviati dall'utente
  DELETE FROM messages WHERE sender_id = user_id_to_delete;
  
  -- Elimina le conversazioni dove l'utente è partecipante (o i suoi familiari)
  DELETE FROM conversations WHERE 
    participant1_id = user_id_to_delete
    OR participant2_id = user_id_to_delete;
  
  -- Elimina conversazioni dei membri della famiglia
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM conversations WHERE 
      participant1_family_member_id = ANY(family_member_ids)
      OR participant2_family_member_id = ANY(family_member_ids);
  END IF;

  -- ========================================
  -- ELIMINAZIONE SEGNALAZIONI E NOTIFICHE
  -- ========================================

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_id_to_delete;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_id_to_delete;

  -- ========================================
  -- ELIMINAZIONE ABBONAMENTI E FAMIGLIA
  -- ========================================

  -- Elimina gli abbonamenti (ora possiamo farlo senza problemi)
  DELETE FROM subscriptions WHERE customer_id = user_id_to_delete;

  -- Riabilita il trigger di protezione trial
  ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_id_to_delete;

  -- ========================================
  -- ELIMINAZIONE TRIAL HISTORY
  -- ========================================

  -- Rimuovi il codice fiscale del titolare dalla trial history
  IF user_fiscal_code IS NOT NULL AND user_fiscal_code != '' THEN
    DELETE FROM trial_usage_history WHERE fiscal_code = user_fiscal_code;
  END IF;

  -- Rimuovi i codici fiscali dei membri della famiglia dalla trial history
  IF family_fiscal_codes IS NOT NULL AND array_length(family_fiscal_codes, 1) > 0 THEN
    DELETE FROM trial_usage_history WHERE fiscal_code = ANY(family_fiscal_codes);
  END IF;

  -- ========================================
  -- ELIMINAZIONE PROFILO E ACCOUNT AUTH
  -- ========================================

  -- Elimina il profilo
  DELETE FROM profiles WHERE id = user_id_to_delete;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_id_to_delete;

  RAISE NOTICE 'Account eliminato completamente dall''admin %: %', caller_user_id, user_id_to_delete;

EXCEPTION
  WHEN OTHERS THEN
    -- In caso di errore, riabilita il trigger prima di propagare l'errore
    ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;
    RAISE;
END;
$$;

GRANT EXECUTE ON FUNCTION admin_delete_user_account(uuid) TO authenticated;

COMMENT ON FUNCTION admin_delete_user_account(uuid) IS 'Permette agli admin di eliminare completamente qualsiasi account utente. Eliminazione PERMANENTE e IRREVERSIBILE.';


-- ============================================================
-- FILE: 20260326153107_fix_auto_profile_creation_detect_user_type.sql
-- ============================================================
/*
  # Fix Auto Profile Creation - Detect User Type from Metadata

  1. Changes
    - Update handle_new_user to detect user_type from raw_user_meta_data
    - Support 'customer', 'business', and 'admin' types
    - Default to 'customer' if not specified

  2. Security
    - Maintains SECURITY DEFINER for proper permissions
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  extracted_full_name text;
  extracted_user_type text;
BEGIN
  -- Try to extract full_name from metadata (check both locations)
  extracted_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'fullName',
    split_part(NEW.email, '@', 1)
  );
  
  -- Ensure we have a non-empty string
  IF extracted_full_name = '' OR extracted_full_name IS NULL THEN
    extracted_full_name := split_part(NEW.email, '@', 1);
  END IF;

  -- Extract user_type from metadata, default to 'customer'
  extracted_user_type := COALESCE(
    NEW.raw_user_meta_data->>'user_type',
    NEW.raw_user_meta_data->>'userType',
    'customer'
  );

  -- Validate user_type matches CHECK constraint
  IF extracted_user_type NOT IN ('customer', 'business', 'admin') THEN
    extracted_user_type := 'customer';
  END IF;

  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    extracted_full_name,
    extracted_user_type,
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;


