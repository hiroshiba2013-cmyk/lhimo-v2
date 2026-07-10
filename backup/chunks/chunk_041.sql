-- ============================================================
-- FILE: 20260318100754_fix_delete_account_clear_trial_history.sql
-- ============================================================
/*
  # Fix Delete Account - Pulisce Trial History per Permettere Ri-registrazione

  1. Problema
    - Quando un utente viene cancellato, il suo codice fiscale rimane in `trial_usage_history`
    - Questo impedisce la ri-registrazione con lo stesso codice fiscale
    - L'utente riceve errore 422 durante la registrazione perché non può attivare il trial

  2. Soluzione
    - Aggiorna la funzione `delete_user_account()` per rimuovere anche i record da `trial_usage_history`
    - Rimuove sia il CF del titolare che quelli dei membri della famiglia

  3. Note
    - Questo permette agli utenti di ri-registrarsi dopo aver cancellato l'account
    - Il sistema di prevenzione trial rimane attivo per altri casi d'abuso
*/

-- Aggiorna la funzione per pulire anche trial_usage_history
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_registered_business_id uuid;
  user_fiscal_code text;
  family_fiscal_codes text[];
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda registrata se l'utente è un business
  SELECT id INTO user_registered_business_id
  FROM registered_businesses
  WHERE owner_id = user_profile_id;

  -- Ottieni il codice fiscale dell'utente
  SELECT fiscal_code INTO user_fiscal_code
  FROM profiles
  WHERE id = user_profile_id;

  -- Ottieni i codici fiscali dei membri della famiglia
  SELECT array_agg(tax_code)
  INTO family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = user_profile_id
    AND tax_code IS NOT NULL
    AND tax_code != '';

  -- ========================================
  -- GESTIONE RIFERIMENTI CHE DEVONO RESTARE
  -- ========================================
  
  -- Gestisci le recensioni approvate da questo utente (mantieni la review ma rimuovi il riferimento all'admin)
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente (mantieni il report ma rimuovi il riferimento all'admin)
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE CONTENUTI UTENTE CUSTOMER
  -- ========================================

  -- Elimina i preferiti dell'utente E dei membri della famiglia
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le redemptions degli sconti dell'utente E dei membri della famiglia
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina TUTTE le recensioni dell'utente (proprie e dei membri della famiglia)
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina tutti i messaggi degli annunci classificati
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT c.id FROM ad_conversations c
    JOIN classified_ads ca ON c.ad_id = ca.id
    WHERE ca.user_id = user_profile_id
  );
  
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;
  
  -- Elimina i messaggi generici
  DELETE FROM messages WHERE sender_id = user_profile_id;
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;
  
  -- Elimina TUTTI gli annunci classificati (propri e dei membri della famiglia)
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;

  -- Elimina l'attività utente e i log
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE CONTENUTI BUSINESS
  -- ========================================

  IF user_registered_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni (usando la nuova colonna registered_business_id)
    DELETE FROM review_responses WHERE registered_business_id = user_registered_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro
    DELETE FROM job_offer_messages WHERE conversation_id IN (
      SELECT id FROM job_offer_conversations WHERE job_posting_id IN (
        SELECT id FROM job_postings WHERE registered_business_id = user_registered_business_id
      )
    );
    
    DELETE FROM job_offer_conversations WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE registered_business_id = user_registered_business_id
    );
    
    -- Elimina le visualizzazioni degli annunci di lavoro
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE registered_business_id = user_registered_business_id
    );
    
    -- Elimina le application agli annunci di lavoro
    DELETE FROM job_applications WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE registered_business_id = user_registered_business_id
    );
    
    -- Elimina i prodotti dell'azienda
    DELETE FROM products WHERE registered_business_id = user_registered_business_id;
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE registered_business_id = user_registered_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE registered_business_id = user_registered_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM registered_business_locations WHERE business_id = user_registered_business_id;
    
    -- Elimina l'azienda registrata
    DELETE FROM registered_businesses WHERE id = user_registered_business_id;
  END IF;

  -- Elimina le attività aggiunte dall'utente (ma non ancora registrate)
  DELETE FROM unclaimed_business_locations WHERE added_by = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE JOB SEEKING
  -- ========================================

  -- Elimina le richieste di lavoro (proprie e dei membri della famiglia)
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker dell'utente E dei membri della famiglia
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  DELETE FROM job_seekers WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );
  
  -- Elimina i messaggi nelle conversazioni di job offer
  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni di job offer
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE SEGNALAZIONI E NOTIFICHE
  -- ========================================

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE ABBONAMENTI E FAMIGLIA
  -- ========================================

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE TRIAL HISTORY (NUOVO)
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
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;

  RAISE NOTICE 'Account eliminato completamente: %', user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- Commento sulla funzione
COMMENT ON FUNCTION delete_user_account() IS 'Elimina completamente l''account utente e TUTTI i contenuti associati, inclusi trial history, membri della famiglia, recensioni, annunci job seeker, annunci classificati, messaggi, preferiti, e tutto il resto. Eliminazione PERMANENTE e IRREVERSIBILE che permette la ri-registrazione.';


-- ============================================================
-- FILE: 20260318100823_fix_trial_trigger_use_customer_id_column.sql
-- ============================================================
/*
  # Fix Trial Trigger - Usa customer_id invece di user_id

  1. Problema
    - Il trigger create_trial_for_customer() usa user_id invece di customer_id
    - La tabella subscriptions usa customer_id come colonna
    - Questo causa un errore durante la registrazione

  2. Soluzione
    - Aggiorna il trigger per usare customer_id
    - Mantieni il constraint ON CONFLICT per gestire duplicati
*/

CREATE OR REPLACE FUNCTION public.create_trial_for_customer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_plan_id uuid;
BEGIN
  -- Solo per utenti customer, non per business o admin
  IF NEW.user_type != 'customer' THEN
    RETURN NEW;
  END IF;

  -- Ottieni l'ID del piano base (1 persona)
  SELECT id INTO base_plan_id
  FROM subscription_plans
  WHERE max_people = 1
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano disponibile
  IF base_plan_id IS NULL THEN
    SELECT id INTO base_plan_id
    FROM subscription_plans
    ORDER BY price_monthly ASC
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
    ON CONFLICT (customer_id) DO NOTHING;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Commento
COMMENT ON FUNCTION create_trial_for_customer() IS 'Crea automaticamente un abbonamento trial di 30 giorni per i nuovi utenti customer alla registrazione';


-- ============================================================
-- FILE: 20260318100924_fix_trial_system_allow_null_fiscal_code_temporarily.sql
-- ============================================================
/*
  # Fix Trial System - Permetti Fiscal Code NULL Temporaneamente

  1. Problema
    - Durante la registrazione, il profilo viene creato SENZA fiscal_code
    - Il trigger create_trial_for_customer() cerca di creare il trial subito
    - Il trigger prevent_trial_abuse() blocca perché fiscal_code è NULL
    - Il frontend aggiorna il fiscal_code DOPO, ma è troppo tardi
    - Questo causa errore 422 durante la registrazione

  2. Soluzione Opzione A (scelta)
    - Disabilita completamente il trigger create_trial_for_customer()
    - Il trial viene creato SOLO dal frontend dopo aver aggiunto il fiscal_code
    - Questo garantisce che prevent_trial_abuse abbia sempre il fiscal_code disponibile

  3. Perché questa soluzione
    - Il frontend già gestisce la creazione del trial manualmente
    - Evita problemi di sincronizzazione
    - Il fiscal_code sarà sempre presente quando il trial viene creato
*/

-- Rimuovi il trigger automatico per creare trial
DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;

-- Commenta la funzione per indicare che non è più usata
COMMENT ON FUNCTION create_trial_for_customer() IS 'DEPRECATA: Il trial viene ora creato manualmente dal frontend dopo aver impostato il fiscal_code';


-- ============================================================
-- FILE: 20260318101731_fix_job_seekers_user_id_foreign_key.sql
-- ============================================================
/*
  # Fix Job Seekers - Aggiungi Foreign Key per user_id

  1. Problema
    - La tabella job_seekers ha una colonna user_id ma manca la foreign key constraint
    - Questo impedisce le query con join usando la sintassi profiles:user_id(...)
    - Errore: "Could not find a relationship between 'job_seekers' and 'user_id'"

  2. Soluzione
    - Aggiungi la foreign key constraint su user_id -> profiles(id)
    - Mantieni ON DELETE CASCADE per pulizia automatica
*/

-- Aggiungi la foreign key constraint se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE constraint_name = 'job_seekers_user_id_fkey'
      AND table_name = 'job_seekers'
  ) THEN
    ALTER TABLE job_seekers
      ADD CONSTRAINT job_seekers_user_id_fkey
      FOREIGN KEY (user_id)
      REFERENCES profiles(id)
      ON DELETE CASCADE;
  END IF;
END $$;

-- Aggiungi indice per performance
CREATE INDEX IF NOT EXISTS idx_job_seekers_user_id ON job_seekers(user_id);


-- ============================================================
-- FILE: 20260318101803_fix_featured_ads_function_use_category_id.sql
-- ============================================================
/*
  # Fix Featured Ads Function - Usa category_id invece di category

  1. Problema
    - La funzione get_featured_classified_ads usa ca.category
    - La tabella classified_ads ha category_id (uuid), non category (text)
    - Errore: "column ca.category does not exist"

  2. Soluzione
    - Drop e ricrea la funzione per usare category_id
    - Fai join con classified_ad_categories per ottenere il nome
*/

-- Drop della vecchia funzione
DROP FUNCTION IF EXISTS get_featured_classified_ads(text, integer);

-- Ricrea la funzione con la struttura corretta
CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count integer DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  category_id uuid,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ca.id,
    ca.title,
    ca.description,
    ca.price,
    ca.ad_type,
    COALESCE(cat.name, '') as category,
    ca.category_id,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id
  LEFT JOIN classified_ad_categories cat ON ca.category_id = cat.id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;

COMMENT ON FUNCTION get_featured_classified_ads(text, integer) IS 'Restituisce annunci classificati in evidenza ordinati per punti utente';


-- ============================================================
-- FILE: 20260318103109_fix_featured_ads_function_correct_table_name.sql
-- ============================================================
/*
  # Fix Featured Ads Function - Correggi nome tabella

  1. Problema
    - La funzione usa classified_ad_categories ma la tabella si chiama classified_categories
    
  2. Soluzione
    - Aggiorna la funzione con il nome corretto
*/

DROP FUNCTION IF EXISTS get_featured_classified_ads(text, integer);

CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count integer DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  category_id uuid,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ca.id,
    ca.title,
    ca.description,
    ca.price,
    ca.ad_type,
    COALESCE(cat.name, '') as category,
    ca.category_id,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id
  LEFT JOIN classified_categories cat ON ca.category_id = cat.id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;


-- ============================================================
-- FILE: 20260318103130_fix_featured_ads_function_cast_ad_type.sql
-- ============================================================
/*
  # Fix Featured Ads Function - Cast ad_type enum

  1. Problema
    - ad_type è un enum (ad_type_enum), non text
    - Il confronto richiede un cast esplicito
    
  2. Soluzione
    - Cast ad_type_filter::ad_type_enum per il confronto
    - Oppure cast ca.ad_type::text
*/

DROP FUNCTION IF EXISTS get_featured_classified_ads(text, integer);

CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count integer DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  category_id uuid,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ca.id,
    ca.title,
    ca.description,
    ca.price,
    ca.ad_type::text,
    COALESCE(cat.name, '') as category,
    ca.category_id,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status::text,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id
  LEFT JOIN classified_categories cat ON ca.category_id = cat.id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type::text = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;


