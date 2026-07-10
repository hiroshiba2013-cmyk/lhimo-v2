-- ============================================================
-- FILE: 20260308222615_fix_trial_prevention_fiscal_code_column.sql
-- ============================================================
/*
  # Fix Trial Prevention - Correct Column Name

  ## Problem
  The trial prevention system references 'tax_code' which doesn't exist.
  The correct column name is 'fiscal_code'.
  
  ## Solution
  Replace all references to 'tax_code' with 'fiscal_code' in the prevention functions.
*/

-- Fix check_trial_eligibility function
CREATE OR REPLACE FUNCTION check_trial_eligibility(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_fiscal_codes text[];
  v_used_fiscal_codes text[];
  v_is_eligible boolean := true;
  v_reason text := null;
BEGIN
  -- Ottieni il CF del profilo
  SELECT fiscal_code INTO v_profile_fiscal_code
  FROM profiles
  WHERE id = p_user_id;

  -- Controlla se il CF del titolare è già stato usato per un trial
  IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
    IF EXISTS (
      SELECT 1 FROM trial_usage_history
      WHERE fiscal_code = v_profile_fiscal_code
    ) THEN
      v_is_eligible := false;
      v_reason := 'Codice fiscale già utilizzato per un periodo di prova';
    END IF;
  END IF;

  -- Ottieni tutti i CF dei membri della famiglia
  SELECT array_agg(fiscal_code)
  INTO v_family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = p_user_id
    AND fiscal_code IS NOT NULL
    AND fiscal_code != '';

  -- Controlla se qualche CF della famiglia è già stato usato
  IF v_family_fiscal_codes IS NOT NULL THEN
    SELECT array_agg(fiscal_code)
    INTO v_used_fiscal_codes
    FROM trial_usage_history
    WHERE fiscal_code = ANY(v_family_fiscal_codes);

    IF v_used_fiscal_codes IS NOT NULL AND array_length(v_used_fiscal_codes, 1) > 0 THEN
      v_is_eligible := false;
      v_reason := 'Uno o più codici fiscali dei membri della famiglia sono già stati utilizzati per un periodo di prova';
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'eligible', v_is_eligible,
    'reason', v_reason
  );
END;
$$;

-- Fix register_trial_usage function
CREATE OR REPLACE FUNCTION register_trial_usage(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_member RECORD;
BEGIN
  -- Registra il CF del titolare
  SELECT fiscal_code INTO v_profile_fiscal_code
  FROM profiles
  WHERE id = p_user_id;

  IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_profile_fiscal_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  -- Registra i CF di tutti i membri della famiglia
  FOR v_family_member IN
    SELECT fiscal_code
    FROM customer_family_members
    WHERE customer_id = p_user_id
      AND fiscal_code IS NOT NULL
      AND fiscal_code != ''
  LOOP
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_family_member.fiscal_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END LOOP;
END;
$$;

-- Fix prevent_trial_abuse function
CREATE OR REPLACE FUNCTION prevent_trial_abuse()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_fiscal_codes text[];
  v_existing_count int;
BEGIN
  -- Solo per nuove sottoscrizioni trial
  IF NEW.status = 'trial' AND (OLD IS NULL OR OLD.status != 'trial') THEN
    
    -- Ottieni il CF del profilo
    SELECT fiscal_code INTO v_profile_fiscal_code
    FROM profiles
    WHERE id = NEW.customer_id;

    -- Verifica se questo CF ha già avuto un trial
    IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
      SELECT COUNT(*) INTO v_existing_count
      FROM trial_usage_history
      WHERE fiscal_code = v_profile_fiscal_code;

      IF v_existing_count > 0 THEN
        RAISE EXCEPTION 'Questo codice fiscale è già stato utilizzato per un periodo di prova';
      END IF;
    END IF;

    -- Controlla anche i CF della famiglia
    SELECT array_agg(fiscal_code)
    INTO v_family_fiscal_codes
    FROM customer_family_members
    WHERE customer_id = NEW.customer_id
      AND fiscal_code IS NOT NULL;

    IF v_family_fiscal_codes IS NOT NULL THEN
      UPDATE trial_usage_history
      SET subsequent_attempts = array_append(subsequent_attempts, NEW.customer_id)
      WHERE fiscal_code = ANY(v_family_fiscal_codes);

      SELECT COUNT(*) INTO v_existing_count
      FROM trial_usage_history
      WHERE fiscal_code = ANY(v_family_fiscal_codes);

      IF v_existing_count > 0 THEN
        RAISE EXCEPTION 'Uno o più codici fiscali dei membri della famiglia sono già stati utilizzati per un periodo di prova';
      END IF;
    END IF;

    -- Registra l'uso del trial
    PERFORM register_trial_usage(NEW.customer_id);
  END IF;

  RETURN NEW;
END;
$$;


-- ============================================================
-- FILE: 20260311202227_add_get_top_business_locations_function.sql
-- ============================================================
/*
  # Add function to get top business locations
  
  1. New Functions
    - `get_top_business_locations`: Returns the top rated business locations with their average rating and review count
  
  2. Purpose
    - Allows businesses to see the best performing locations on the platform
    - Used in business dashboard to show leaderboard of locations
*/

CREATE OR REPLACE FUNCTION get_top_business_locations(limit_count INT DEFAULT 10)
RETURNS TABLE (
  id uuid,
  name text,
  internal_name text,
  city text,
  province text,
  avg_rating numeric,
  review_count bigint,
  business jsonb
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    bl.id,
    bl.name,
    bl.internal_name,
    bl.city,
    bl.province,
    COALESCE(AVG(r.overall_rating), 0)::numeric AS avg_rating,
    COUNT(r.id) AS review_count,
    jsonb_build_object('name', b.name) AS business
  FROM business_locations bl
  LEFT JOIN businesses b ON bl.business_id = b.id
  LEFT JOIN reviews r ON r.business_location_id = bl.id AND r.review_status = 'approved'
  WHERE bl.is_claimed = true
  GROUP BY bl.id, bl.name, bl.internal_name, bl.city, bl.province, b.name
  HAVING COUNT(r.id) > 0
  ORDER BY avg_rating DESC, review_count DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- FILE: 20260316105802_fix_business_registration_disable_auto_trial.sql
-- ============================================================
/*
  # Fix Business Registration - Disable Auto Trial Creation
  
  ## Problem
  When a business user registers, there are TWO subscription records being created:
  1. One from the automatic trigger (basic monthly plan)
  2. One from the frontend registration form (chosen plan)
  
  This causes confusion and the wrong subscription to be displayed.
  
  ## Solution
  Disable the automatic trigger that creates trial subscriptions for business users.
  The frontend handles subscription creation with the user's chosen plan.
  
  ## Changes
  - Drop the BEFORE INSERT trigger that auto-sets trial status
  - Drop the AFTER INSERT trigger that auto-creates subscription
  - Keep the functions for potential future use but disable triggers
*/

-- Disable the automatic trial creation triggers for business users
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;
DROP TRIGGER IF EXISTS trigger_insert_business_trial_subscription ON profiles;

-- Comment: The functions create_trial_for_business_profile() and 
-- insert_business_trial_subscription() are kept in the database but not used.
-- The frontend registration form now handles all subscription creation.


-- ============================================================
-- FILE: 20260316105833_cleanup_duplicate_subscriptions.sql
-- ============================================================
/*
  # Cleanup Duplicate Subscriptions
  
  ## Problem
  Some users have multiple active/trial subscriptions due to both:
  - Automatic trigger creating a default trial subscription
  - Frontend registration form creating the chosen subscription
  
  ## Solution
  1. For each user with duplicate subscriptions, keep only the most recent one
  2. Mark older subscriptions as 'cancelled'
  3. Add a note to avoid data loss
  
  ## Changes
  - Update older duplicate subscriptions to 'cancelled' status
  - Keep the most recent subscription for each user
*/

-- Cancel duplicate subscriptions, keeping only the most recent one per user
WITH ranked_subscriptions AS (
  SELECT 
    id,
    customer_id,
    status,
    created_at,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id 
      ORDER BY created_at DESC
    ) as rn
  FROM subscriptions
  WHERE status IN ('active', 'trial')
)
UPDATE subscriptions
SET status = 'cancelled'
WHERE id IN (
  SELECT id 
  FROM ranked_subscriptions 
  WHERE rn > 1
);

-- Log how many subscriptions were cleaned up
DO $$
DECLARE
  affected_count integer;
BEGIN
  GET DIAGNOSTICS affected_count = ROW_COUNT;
  RAISE NOTICE 'Cleaned up % duplicate subscription(s)', affected_count;
END $$;


-- ============================================================
-- FILE: 20260316110615_fix_get_trial_status_use_correct_field.sql
-- ============================================================
/*
  # Fix get_trial_status Function - Use Correct Trial End Date
  
  ## Problem
  The function `get_trial_status()` was reading `trial_end_date` from the profiles table,
  but this column doesn't exist. The correct field is `subscription_expires_at`.
  
  This was causing incorrect calculation of remaining trial days (showing 365 days instead of 30).
  
  ## Solution
  Update the function to:
  1. Use `subscription_expires_at` from profiles table
  2. Only consider users with status = 'trial'
  3. Calculate days remaining based on subscription_expires_at
  
  ## Changes
  - Replace `trial_end_date` with `subscription_expires_at` in the function
  - Fix the days_remaining calculation
  - Fix the is_expired check
*/

-- Function to get trial status for a user
CREATE OR REPLACE FUNCTION get_trial_status(user_id_param uuid)
RETURNS TABLE(
  is_trial boolean,
  days_remaining integer,
  trial_end_date timestamptz,
  is_expired boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    (subscription_status = 'trial') as is_trial,
    CASE
      WHEN subscription_status = 'trial' AND subscription_expires_at IS NOT NULL
      THEN GREATEST(0, EXTRACT(day FROM (subscription_expires_at - now()))::integer)
      ELSE 0
    END as days_remaining,
    profiles.subscription_expires_at as trial_end_date,
    (subscription_status = 'expired' AND subscription_expires_at < now()) as is_expired
  FROM profiles
  WHERE id = user_id_param;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION get_trial_status(uuid) TO authenticated;


-- ============================================================
-- FILE: 20260317221050_fix_delete_account_cascade_job_seekers.sql
-- ============================================================
/*
  # Fix Delete Account - Migliore Gestione Job Seekers Orfani

  1. Problema
    - Quando un utente viene cancellato, alcuni annunci job_seekers possono rimanere orfani
    - La funzione elimina correttamente gli annunci, ma se qualcosa va storto possono rimanere records
    
  2. Soluzione
    - Aggiorna la funzione per eliminare esplicitamente anche gli annunci dei membri della famiglia
    - Assicura che l'ordine di eliminazione sia corretto
*/

-- Ricrea la funzione con migliore gestione degli annunci cerco lavoro
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
COMMENT ON FUNCTION delete_user_account() IS 'Elimina completamente l''account utente e TUTTI i contenuti associati, inclusi membri della famiglia, recensioni, annunci job seeker, annunci classificati, messaggi, preferiti, e tutto il resto. Eliminazione PERMANENTE e IRREVERSIBILE.';


