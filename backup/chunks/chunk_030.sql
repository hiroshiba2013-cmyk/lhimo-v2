-- ============================================================
-- FILE: 20260219103324_fix_delete_account_remove_nonexistent_table.sql
-- ============================================================
/*
  # Fix Delete Account Function - Remove Non-existent Table Reference

  ## Changes
  Removes the reference to `favorite_job_seekers` table which does not exist in the database.
  This was causing errors when users tried to delete their accounts.

  ## Tables Affected
  - None (only updates function)

  ## Functions Updated
  - delete_user_account: Removes DELETE statement for non-existent favorite_job_seekers table
*/

CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- Gestisci riferimenti che devono restare
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina preferiti (RIMOSSA favorite_job_seekers che non esiste)
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina redemptions sconti
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina recensioni (proprie e dei membri famiglia)
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- NUOVO: Elimina messaggi e conversazioni dal sistema unificato
  DELETE FROM messages WHERE sender_id = user_profile_id;
  DELETE FROM messages WHERE conversation_id IN (
    SELECT id FROM conversations 
    WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id
  );
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;

  -- VECCHIO: Elimina da tabelle vecchie se esistono ancora (per compatibilità)
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT id FROM ad_conversations 
    WHERE buyer_id = user_profile_id OR seller_id = user_profile_id
  );
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;

  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  DELETE FROM job_seeker_messages WHERE conversation_id IN (
    SELECT id FROM job_seeker_conversations 
    WHERE employer_id = user_profile_id OR seeker_id = user_profile_id
  );
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;

  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  DELETE FROM job_offer_messages WHERE conversation_id IN (
    SELECT id FROM job_offer_conversations 
    WHERE applicant_id = user_profile_id OR employer_id = user_profile_id
  );
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;

  -- Elimina annunci classificati (propri e dei membri famiglia)
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina visualizzazioni annunci
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;

  -- Elimina job seekers (cerco lavoro)
  DELETE FROM job_seekers WHERE user_id = user_profile_id;

  -- Elimina attività e log
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Elimina notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- CONTENUTI BUSINESS
  IF user_business_id IS NOT NULL THEN
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    DELETE FROM products WHERE business_id = user_business_id;
    
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    DELETE FROM business_subscriptions WHERE business_id = user_business_id;
    
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    DELETE FROM businesses WHERE id = user_business_id;
    
    DELETE FROM unclaimed_business_locations WHERE added_by_user_id = user_profile_id;
  END IF;

  -- Elimina report fatti dall'utente
  DELETE FROM reports WHERE reported_by = user_profile_id;

  -- Elimina membri famiglia (CASCADE eliminerà i loro contenuti)
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina profilo
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;
  
  RAISE NOTICE 'Account eliminato con successo';
END;
$$;

-- ============================================================
-- FILE: 20260219103742_fix_delete_account_correct_reporter_column.sql
-- ============================================================
/*
  # Fix Delete Account Function - Correct Reporter Column Name

  ## Changes
  Fixes the column name for reports table from `reported_by` to `reporter_id`.
  This was causing errors when users tried to delete their accounts.

  ## Tables Affected
  - None (only updates function)

  ## Functions Updated
  - delete_user_account: Uses correct column name `reporter_id` instead of `reported_by`
*/

CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- Gestisci riferimenti che devono restare
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina preferiti
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina redemptions sconti
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina recensioni (proprie e dei membri famiglia)
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- NUOVO: Elimina messaggi e conversazioni dal sistema unificato
  DELETE FROM messages WHERE sender_id = user_profile_id;
  DELETE FROM messages WHERE conversation_id IN (
    SELECT id FROM conversations 
    WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id
  );
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;

  -- VECCHIO: Elimina da tabelle vecchie se esistono ancora (per compatibilità)
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT id FROM ad_conversations 
    WHERE buyer_id = user_profile_id OR seller_id = user_profile_id
  );
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;

  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  DELETE FROM job_seeker_messages WHERE conversation_id IN (
    SELECT id FROM job_seeker_conversations 
    WHERE employer_id = user_profile_id OR seeker_id = user_profile_id
  );
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;

  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  DELETE FROM job_offer_messages WHERE conversation_id IN (
    SELECT id FROM job_offer_conversations 
    WHERE applicant_id = user_profile_id OR employer_id = user_profile_id
  );
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;

  -- Elimina annunci classificati (propri e dei membri famiglia)
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina visualizzazioni annunci
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;

  -- Elimina job seekers (cerco lavoro)
  DELETE FROM job_seekers WHERE user_id = user_profile_id;

  -- Elimina attività e log
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Elimina notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- CONTENUTI BUSINESS
  IF user_business_id IS NOT NULL THEN
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    DELETE FROM products WHERE business_id = user_business_id;
    
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    DELETE FROM business_subscriptions WHERE business_id = user_business_id;
    
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    DELETE FROM businesses WHERE id = user_business_id;
    
    DELETE FROM unclaimed_business_locations WHERE added_by_user_id = user_profile_id;
  END IF;

  -- Elimina report fatti dall'utente (CORRETTO: usa reporter_id invece di reported_by)
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina membri famiglia (CASCADE eliminerà i loro contenuti)
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina profilo
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;
  
  RAISE NOTICE 'Account eliminato con successo';
END;
$$;

-- ============================================================
-- FILE: 20260219104932_add_auto_trial_for_business_registration.sql
-- ============================================================
/*
  # Add Automatic Trial Creation for Business Registration

  ## Changes
  Creates a trigger that automatically:
  1. Sets trial status and trial_end_date (30 days from registration) for business profiles
  2. Creates a trial subscription entry linked to the basic business plan
  3. Ensures all business users start with 1 month free trial automatically

  ## Tables Affected
  - profiles: Updates subscription_status and trial_end_date on INSERT
  - subscriptions: Creates a trial subscription entry for business users

  ## Security
  - Function runs with SECURITY DEFINER to allow creating subscriptions
  - Only affects business profile types
  - Automatically grants 30 days trial period
*/

-- Function to create trial subscription for new business profiles
CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles
  IF NEW.profile_type = 'business' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';
    
    -- Update profile with trial status and trial_end_date
    UPDATE profiles
    SET 
      subscription_status = 'trial',
      trial_end_date = trial_end,
      subscription_type = 'monthly',
      subscription_expires_at = trial_end
    WHERE id = NEW.id;
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%'
    AND max_persons = 1
    AND billing_period = 'monthly'
    LIMIT 1;
    
    -- Create trial subscription if plan exists
    IF basic_plan_id IS NOT NULL THEN
      INSERT INTO subscriptions (
        customer_id,
        plan_id,
        status,
        start_date,
        end_date,
        trial_end_date,
        payment_method_added
      ) VALUES (
        NEW.id,
        basic_plan_id,
        'trial',
        now(),
        trial_end,
        trial_end,
        false
      );
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;

-- Create trigger that fires after insert on profiles
CREATE TRIGGER trigger_create_trial_for_business
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_business_profile();

-- Grant execute permission
GRANT EXECUTE ON FUNCTION create_trial_for_business_profile() TO authenticated;

-- ============================================================
-- FILE: 20260220091432_fix_delete_account_new_business_structure.sql
-- ============================================================
/*
  # Fix Delete Account Function - Nuova Struttura Business

  1. Problema
    - La funzione delete_user_account() fa ancora riferimento alla vecchia tabella "businesses"
    - Dopo la ristrutturazione, ora abbiamo: registered_businesses e registered_business_locations
    - L'errore "column business_id does not exist" viene causato da riferimenti obsoleti

  2. Soluzione
    - Aggiorna la funzione per utilizzare la nuova struttura con registered_businesses
    - Gestisce correttamente l'eliminazione di:
      - registered_businesses (attività registrate)
      - registered_business_locations (sedi delle attività)
      - user_added_businesses (attività aggiunte dall'utente ma non ancora registrate)
    - Aggiorna tutti i riferimenti da business_id a registered_businesses

  3. Cosa viene eliminato per utenti business
    - Risposte alle recensioni
    - Conversazioni e messaggi relativi agli annunci di lavoro
    - Visualizzazioni degli annunci di lavoro
    - Application agli annunci di lavoro
    - Prodotti dell'azienda
    - Annunci di lavoro
    - Sconti creati
    - Sedi aziendali (registered_business_locations)
    - L'azienda registrata (registered_businesses)
    - Attività aggiunte dall'utente (user_added_businesses)
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione aggiornata con la nuova struttura
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_registered_business_id uuid;
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
  DELETE FROM user_added_businesses WHERE added_by = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE JOB SEEKING
  -- ========================================

  -- Elimina le richieste di lavoro (proprie e dei membri della famiglia)
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
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
COMMENT ON FUNCTION delete_user_account() IS 'Elimina completamente l''account utente e TUTTI i contenuti associati, inclusi membri della famiglia, recensioni, annunci, messaggi, preferiti, e tutto il resto. Eliminazione PERMANENTE e IRREVERSIBILE. Aggiornato per la nuova struttura business.';


