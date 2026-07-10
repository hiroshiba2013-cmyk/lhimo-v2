-- ============================================================
-- FILE: 20260318104109_create_cleanup_non_admin_users_function.sql
-- ============================================================
/*
  # Funzione per eliminare tutti gli utenti non-admin

  1. Scopo
    - Elimina tutti gli utenti customer e business (ma NON gli admin)
    - Elimina tutti i dati correlati agli utenti
    - Mantiene la possibilità di re-registrazione
    
  2. Cosa elimina
    - Profili e utenti auth (eccetto admin)
    - Subscription e subscription history
    - Family members
    - Businesses e business locations
    - Reviews, job postings, classified ads
    - Attività utente, notifiche, conversazioni
    - Favoriti, referral, trial history
    - Tutti i dati correlati
    
  3. Sicurezza
    - Solo gli admin possono eseguire questa funzione
    - NON elimina mai gli account admin
*/

CREATE OR REPLACE FUNCTION cleanup_non_admin_users()
RETURNS TABLE (
  deleted_users_count integer,
  deleted_profiles_count integer,
  message text
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_deleted_users integer := 0;
  v_deleted_profiles integer := 0;
  v_user_ids uuid[];
  v_admin_id uuid;
BEGIN
  -- Verifica che chi esegue sia un admin
  SELECT id INTO v_admin_id
  FROM admins
  WHERE user_id = auth.uid();
  
  IF v_admin_id IS NULL THEN
    RAISE EXCEPTION 'Solo gli amministratori possono eseguire questa funzione';
  END IF;

  -- Ottieni l'elenco di tutti gli utenti non-admin da eliminare
  SELECT ARRAY_AGG(p.id)
  INTO v_user_ids
  FROM profiles p
  WHERE p.user_type != 'admin' OR p.user_type IS NULL;

  -- Se non ci sono utenti da eliminare, ritorna subito
  IF v_user_ids IS NULL OR array_length(v_user_ids, 1) = 0 THEN
    RETURN QUERY SELECT 0, 0, 'Nessun utente non-admin da eliminare'::text;
    RETURN;
  END IF;

  -- Elimina dati correlati nell'ordine corretto
  
  -- 1. Elimina conversazioni e messaggi
  DELETE FROM conversation_messages 
  WHERE conversation_id IN (
    SELECT id FROM conversations WHERE user_id = ANY(v_user_ids) OR other_user_id = ANY(v_user_ids)
  );
  
  DELETE FROM conversations 
  WHERE user_id = ANY(v_user_ids) OR other_user_id = ANY(v_user_ids);

  -- 2. Elimina notifiche
  DELETE FROM notifications WHERE user_id = ANY(v_user_ids);

  -- 3. Elimina report
  DELETE FROM reports WHERE reporter_id = ANY(v_user_ids);

  -- 4. Elimina favoriti
  DELETE FROM favorite_classified_ads WHERE user_id = ANY(v_user_ids);
  DELETE FROM favorite_businesses WHERE user_id = ANY(v_user_ids);

  -- 5. Elimina classified ads e correlati
  DELETE FROM classified_ad_views WHERE ad_id IN (SELECT id FROM classified_ads WHERE user_id = ANY(v_user_ids));
  DELETE FROM classified_ads WHERE user_id = ANY(v_user_ids);

  -- 6. Elimina solidarity requests
  DELETE FROM solidarity_requests WHERE user_id = ANY(v_user_ids);

  -- 7. Elimina job seekers e job postings
  DELETE FROM job_requests WHERE job_seeker_id IN (SELECT id FROM job_seekers WHERE user_id = ANY(v_user_ids));
  DELETE FROM job_seekers WHERE user_id = ANY(v_user_ids);
  
  DELETE FROM job_views WHERE job_id IN (SELECT id FROM job_postings WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM job_requests WHERE job_id IN (SELECT id FROM job_postings WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM job_postings WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids));

  -- 8. Elimina products
  DELETE FROM products WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids));

  -- 9. Elimina discount redemptions
  DELETE FROM discount_redemptions WHERE customer_id = ANY(v_user_ids);
  DELETE FROM discount_redemptions WHERE discount_id IN (SELECT id FROM discounts WHERE location_id IN (SELECT id FROM business_locations WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids))));

  -- 10. Elimina discounts
  DELETE FROM discounts WHERE location_id IN (SELECT id FROM business_locations WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids)));

  -- 11. Elimina review proofs e reviews
  DELETE FROM review_proofs WHERE review_id IN (SELECT id FROM reviews WHERE user_id = ANY(v_user_ids));
  DELETE FROM reviews WHERE user_id = ANY(v_user_ids);
  DELETE FROM reviews WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids));
  DELETE FROM reviews WHERE business_location_id IN (SELECT id FROM business_locations WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids)));

  -- 12. Elimina business locations e businesses
  DELETE FROM business_locations WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = ANY(v_user_ids));
  DELETE FROM businesses WHERE owner_id = ANY(v_user_ids);

  -- 13. Elimina unclaimed businesses aggiunti dagli utenti
  DELETE FROM unclaimed_businesses WHERE added_by = ANY(v_user_ids);

  -- 14. Elimina family members
  DELETE FROM customer_family_members WHERE customer_id = ANY(v_user_ids);

  -- 15. Elimina referral
  DELETE FROM referrals WHERE referrer_id = ANY(v_user_ids) OR referred_id = ANY(v_user_ids);

  -- 16. Elimina user activity e activity logs
  DELETE FROM activity_logs WHERE user_id = ANY(v_user_ids);
  DELETE FROM user_activity WHERE user_id = ANY(v_user_ids);

  -- 17. Elimina trial history
  DELETE FROM trial_prevention WHERE user_id = ANY(v_user_ids);

  -- 18. Elimina subscriptions
  DELETE FROM subscriptions WHERE customer_id = ANY(v_user_ids);

  -- 19. Elimina profili
  DELETE FROM profiles WHERE id = ANY(v_user_ids);
  GET DIAGNOSTICS v_deleted_profiles = ROW_COUNT;

  -- 20. Elimina utenti da auth.users
  DELETE FROM auth.users WHERE id = ANY(v_user_ids);
  GET DIAGNOSTICS v_deleted_users = ROW_COUNT;

  RETURN QUERY SELECT 
    v_deleted_users, 
    v_deleted_profiles,
    format('Eliminati %s utenti e %s profili non-admin', v_deleted_users, v_deleted_profiles)::text;
END;
$$;

-- Permetti solo agli admin di eseguire questa funzione
REVOKE ALL ON FUNCTION cleanup_non_admin_users() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION cleanup_non_admin_users() TO authenticated;


-- ============================================================
-- FILE: 20260318110712_fix_auto_trial_subscription_for_customers.sql
-- ============================================================
/*
  # Fix Creazione Automatica Trial per Nuovi Utenti Customer

  1. Problema Risolto
    - Il trigger per creare trial automatici non era attivo
    - I nomi delle colonne erano errati (user_id invece di customer_id, max_people invece di max_persons)
    
  2. Soluzione
    - Ricrea la funzione con i nomi di colonna corretti
    - Ricrea il trigger per attivarla automaticamente alla registrazione
    - Aggiunge trial di 30 giorni per ogni nuovo utente customer
    
  3. Note
    - Funziona solo per user_type = 'customer'
    - Seleziona il piano più economico con 1 persona
    - Non blocca la registrazione se ci sono errori
*/

-- Ricrea la funzione con i nomi di colonna corretti
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

  -- Ottieni l'ID del piano base (1 persona, mensile, più economico)
  SELECT id INTO base_plan_id
  FROM subscription_plans
  WHERE max_persons = 1 
    AND billing_period = 'monthly'
  ORDER BY price ASC
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano disponibile
  IF base_plan_id IS NULL THEN
    SELECT id INTO base_plan_id
    FROM subscription_plans
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
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Elimina il trigger esistente se presente
DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;

-- Ricrea il trigger
CREATE TRIGGER trigger_create_trial_for_customer
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_customer();


-- ============================================================
-- FILE: 20260318145847_auto_update_plan_on_family_size_change.sql
-- ============================================================
/*
  # Auto-aggiornamento piano abbonamento in base a membri famiglia

  1. Funzione
    - `update_subscription_plan_on_family_change`: Aggiorna automaticamente il piano quando cambiano i membri della famiglia
    - Conta i membri + 1 (utente principale) e seleziona il piano adatto

  2. Trigger
    - Si attiva quando viene aggiunto/rimosso un membro della famiglia
    - Aggiorna sia la subscription che il profilo utente

  3. Logica
    - 1 persona = Piano da 1 persona
    - 2 persone = Piano da 2 persone
    - 3 persone = Piano da 3 persone
    - 4+ persone = Piano da 4 persone
*/

-- Funzione per aggiornare il piano quando cambiano i membri della famiglia
CREATE OR REPLACE FUNCTION update_subscription_plan_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  v_customer_id uuid;
  v_family_count integer;
  v_total_persons integer;
  v_current_subscription record;
  v_new_plan_id uuid;
  v_user_type text;
BEGIN
  -- Determina l'ID del customer e il tipo di operazione
  IF (TG_OP = 'DELETE') THEN
    v_customer_id := OLD.customer_id;
  ELSE
    v_customer_id := NEW.customer_id;
  END IF;

  -- Verifica il tipo di utente
  SELECT user_type INTO v_user_type
  FROM profiles
  WHERE id = v_customer_id;

  -- Procedi solo se è un customer
  IF v_user_type != 'customer' THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Conta i membri della famiglia dopo l'operazione
  SELECT COUNT(*) INTO v_family_count
  FROM customer_family_members
  WHERE customer_id = v_customer_id;

  -- Totale persone = utente principale + membri famiglia
  v_total_persons := v_family_count + 1;

  -- Ottieni la subscription attuale
  SELECT * INTO v_current_subscription
  FROM subscriptions
  WHERE customer_id = v_customer_id
  AND status IN ('active', 'trial')
  ORDER BY created_at DESC
  LIMIT 1;

  -- Se non c'è subscription, esci
  IF v_current_subscription.id IS NULL THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Trova il piano corretto basato sul numero di persone
  -- Mantieni lo stesso periodo di fatturazione (mensile o annuale)
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_total_persons
  AND billing_period = (
    SELECT billing_period
    FROM subscription_plans
    WHERE id = v_current_subscription.plan_id
  )
  AND name NOT LIKE '%Business%'
  LIMIT 1;

  -- Se non esiste un piano esatto, prendi quello più grande disponibile
  IF v_new_plan_id IS NULL THEN
    SELECT id INTO v_new_plan_id
    FROM subscription_plans
    WHERE max_persons >= v_total_persons
    AND billing_period = (
      SELECT billing_period
      FROM subscription_plans
      WHERE id = v_current_subscription.plan_id
    )
    AND name NOT LIKE '%Business%'
    ORDER BY max_persons ASC
    LIMIT 1;
  END IF;

  -- Aggiorna la subscription solo se il piano è diverso
  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;

    RAISE NOTICE 'Piano aggiornato per customer % da % a % persone', v_customer_id, v_family_count, v_total_persons;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per INSERT di nuovi membri
DROP TRIGGER IF EXISTS trigger_update_plan_on_family_insert ON customer_family_members;
CREATE TRIGGER trigger_update_plan_on_family_insert
  AFTER INSERT ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_family_change();

-- Trigger per DELETE di membri
DROP TRIGGER IF EXISTS trigger_update_plan_on_family_delete ON customer_family_members;
CREATE TRIGGER trigger_update_plan_on_family_delete
  AFTER DELETE ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_family_change();


-- ============================================================
-- FILE: 20260318150545_fix_subscription_plans_sync_all_users.sql
-- ============================================================
/*
  # Sincronizza tutti gli abbonamenti con il numero corretto di persone
  
  1. Funzione
    - `sync_all_subscription_plans`: Corregge tutti gli abbonamenti esistenti
    - `get_correct_plan_for_customer`: Ottiene il piano corretto basato sui membri
  
  2. Correzioni
    - Aggiorna tutti gli abbonamenti customer con il piano corretto
    - Aggiorna tutti gli abbonamenti business con il piano corretto
    - Aggiorna anche il trigger per essere più robusto
  
  3. Esecuzione
    - Esegue automaticamente la sincronizzazione di tutti gli utenti
*/

-- Funzione per ottenere il piano corretto per un customer
CREATE OR REPLACE FUNCTION get_correct_plan_for_customer(
  p_customer_id uuid,
  p_current_plan_id uuid
)
RETURNS uuid AS $$
DECLARE
  v_family_count integer;
  v_total_persons integer;
  v_billing_period text;
  v_new_plan_id uuid;
BEGIN
  -- Conta i membri della famiglia
  SELECT COUNT(*) INTO v_family_count
  FROM customer_family_members
  WHERE customer_id = p_customer_id;
  
  -- Totale persone = utente principale + membri famiglia
  v_total_persons := v_family_count + 1;
  
  -- Ottieni il periodo di fatturazione attuale
  SELECT billing_period INTO v_billing_period
  FROM subscription_plans
  WHERE id = p_current_plan_id;
  
  -- Se non trovato, usa mensile come default
  IF v_billing_period IS NULL THEN
    v_billing_period := 'monthly';
  END IF;
  
  -- Trova il piano corretto
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_total_persons
  AND billing_period = v_billing_period
  AND name NOT LIKE '%Business%'
  LIMIT 1;
  
  -- Se non esiste un piano esatto, prendi quello più grande disponibile
  IF v_new_plan_id IS NULL THEN
    SELECT id INTO v_new_plan_id
    FROM subscription_plans
    WHERE max_persons >= v_total_persons
    AND billing_period = v_billing_period
    AND name NOT LIKE '%Business%'
    ORDER BY max_persons ASC
    LIMIT 1;
  END IF;
  
  RETURN v_new_plan_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per ottenere il piano corretto per un business
CREATE OR REPLACE FUNCTION get_correct_plan_for_business(
  p_business_id uuid,
  p_current_plan_id uuid
)
RETURNS uuid AS $$
DECLARE
  v_locations_count integer;
  v_billing_period text;
  v_new_plan_id uuid;
BEGIN
  -- Conta le sedi business
  SELECT COUNT(*) INTO v_locations_count
  FROM business_locations
  WHERE business_id = p_business_id;
  
  -- Se nessuna sede, almeno 1
  IF v_locations_count = 0 THEN
    v_locations_count := 1;
  END IF;
  
  -- Ottieni il periodo di fatturazione attuale
  SELECT billing_period INTO v_billing_period
  FROM subscription_plans
  WHERE id = p_current_plan_id;
  
  -- Se non trovato, usa mensile come default
  IF v_billing_period IS NULL THEN
    v_billing_period := 'monthly';
  END IF;
  
  -- Trova il piano corretto
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_locations_count
  AND billing_period = v_billing_period
  AND name LIKE '%Business%'
  LIMIT 1;
  
  -- Se non esiste un piano esatto, prendi quello più grande disponibile
  IF v_new_plan_id IS NULL THEN
    SELECT id INTO v_new_plan_id
    FROM subscription_plans
    WHERE max_persons >= v_locations_count
    AND billing_period = v_billing_period
    AND name LIKE '%Business%'
    ORDER BY max_persons ASC
    LIMIT 1;
  END IF;
  
  RETURN v_new_plan_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per sincronizzare tutti gli abbonamenti
CREATE OR REPLACE FUNCTION sync_all_subscription_plans()
RETURNS TABLE(
  customer_email text,
  old_plan text,
  new_plan text,
  updated boolean
) AS $$
DECLARE
  v_subscription record;
  v_new_plan_id uuid;
  v_old_plan_name text;
  v_new_plan_name text;
  v_profile record;
BEGIN
  -- Loop attraverso tutte le subscriptions attive o trial
  FOR v_subscription IN 
    SELECT s.*, p.email, p.user_type
    FROM subscriptions s
    JOIN profiles p ON p.id = s.customer_id
    WHERE s.status IN ('active', 'trial')
  LOOP
    -- Ottieni il nome del piano attuale
    SELECT name INTO v_old_plan_name
    FROM subscription_plans
    WHERE id = v_subscription.plan_id;
    
    -- Determina il piano corretto in base al tipo di utente
    IF v_subscription.user_type = 'customer' THEN
      v_new_plan_id := get_correct_plan_for_customer(
        v_subscription.customer_id,
        v_subscription.plan_id
      );
    ELSIF v_subscription.user_type = 'business' THEN
      v_new_plan_id := get_correct_plan_for_business(
        v_subscription.customer_id,
        v_subscription.plan_id
      );
    ELSE
      v_new_plan_id := v_subscription.plan_id;
    END IF;
    
    -- Ottieni il nome del nuovo piano
    SELECT name INTO v_new_plan_name
    FROM subscription_plans
    WHERE id = v_new_plan_id;
    
    -- Se il piano è diverso, aggiorna
    IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_subscription.plan_id THEN
      UPDATE subscriptions
      SET plan_id = v_new_plan_id,
          updated_at = now()
      WHERE id = v_subscription.id;
      
      RETURN QUERY SELECT 
        v_subscription.email::text,
        v_old_plan_name::text,
        v_new_plan_name::text,
        true;
    ELSE
      RETURN QUERY SELECT 
        v_subscription.email::text,
        v_old_plan_name::text,
        v_new_plan_name::text,
        false;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aggiorna la funzione del trigger per essere più robusta
CREATE OR REPLACE FUNCTION update_subscription_plan_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  v_customer_id uuid;
  v_new_plan_id uuid;
  v_current_subscription record;
BEGIN
  -- Determina l'ID del customer
  IF (TG_OP = 'DELETE') THEN
    v_customer_id := OLD.customer_id;
  ELSE
    v_customer_id := NEW.customer_id;
  END IF;

  -- Ottieni la subscription attuale
  SELECT * INTO v_current_subscription
  FROM subscriptions
  WHERE customer_id = v_customer_id
  AND status IN ('active', 'trial')
  ORDER BY created_at DESC
  LIMIT 1;

  -- Se non c'è subscription, esci
  IF v_current_subscription.id IS NULL THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Ottieni il piano corretto usando la funzione helper
  v_new_plan_id := get_correct_plan_for_customer(
    v_customer_id,
    v_current_subscription.plan_id
  );

  -- Aggiorna la subscription solo se il piano è diverso
  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per business locations (INSERT/DELETE)
CREATE OR REPLACE FUNCTION update_subscription_plan_on_location_change()
RETURNS TRIGGER AS $$
DECLARE
  v_business_id uuid;
  v_new_plan_id uuid;
  v_current_subscription record;
BEGIN
  -- Determina l'ID del business
  IF (TG_OP = 'DELETE') THEN
    v_business_id := OLD.business_id;
  ELSE
    v_business_id := NEW.business_id;
  END IF;

  -- Ottieni la subscription attuale
  SELECT * INTO v_current_subscription
  FROM subscriptions
  WHERE customer_id = v_business_id
  AND status IN ('active', 'trial')
  ORDER BY created_at DESC
  LIMIT 1;

  -- Se non c'è subscription, esci
  IF v_current_subscription.id IS NULL THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Ottieni il piano corretto usando la funzione helper
  v_new_plan_id := get_correct_plan_for_business(
    v_business_id,
    v_current_subscription.plan_id
  );

  -- Aggiorna la subscription solo se il piano è diverso
  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per business locations INSERT
DROP TRIGGER IF EXISTS trigger_update_plan_on_location_insert ON business_locations;
CREATE TRIGGER trigger_update_plan_on_location_insert
  AFTER INSERT ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_location_change();

-- Trigger per business locations DELETE
DROP TRIGGER IF EXISTS trigger_update_plan_on_location_delete ON business_locations;
CREATE TRIGGER trigger_update_plan_on_location_delete
  AFTER DELETE ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_location_change();

-- Esegui la sincronizzazione di tutti gli abbonamenti esistenti
SELECT * FROM sync_all_subscription_plans();


