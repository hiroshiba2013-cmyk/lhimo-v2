/*
  # Fix Delete Account - Rimuovi riferimenti a colonne inesistenti
  
  1. Problema
    - La funzione cerca `participant1_type` e `participant2_type` che non esistono
    - La tabella `conversations` usa solo `participant1_id` e `participant2_id`
  
  2. Soluzione
    - Elimina le conversazioni basandosi solo sugli ID dei partecipanti
    - Considera anche family_member_id e location_id
*/

CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
  user_fiscal_code text;
  family_fiscal_codes text[];
  family_member_ids uuid[];
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID del business se l'utente è un business (cerca tramite owner_id)
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- Ottieni il codice fiscale dell'utente
  SELECT fiscal_code INTO user_fiscal_code
  FROM profiles
  WHERE id = user_profile_id;

  -- Ottieni i codici fiscali dei membri della famiglia
  SELECT array_agg(fiscal_code)
  INTO family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = user_profile_id
    AND fiscal_code IS NOT NULL
    AND fiscal_code != '';

  -- Ottieni gli ID dei membri della famiglia
  SELECT array_agg(id)
  INTO family_member_ids
  FROM customer_family_members
  WHERE customer_id = user_profile_id;

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

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le redemptions degli sconti dell'utente
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina TUTTE le recensioni dell'utente (proprie e dei membri della famiglia)
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM reviews WHERE family_member_id = ANY(family_member_ids);
  END IF;

  -- Elimina TUTTI gli annunci classificati (propri e dei membri della famiglia)
  DELETE FROM classified_ads WHERE user_id = user_profile_id;
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM classified_ads WHERE family_member_id = ANY(family_member_ids);
  END IF;

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

  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni del business
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina le visualizzazioni degli annunci di lavoro
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le application agli annunci di lavoro
    DELETE FROM job_applications WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina i prodotti dell'azienda
    DELETE FROM products WHERE business_id = user_business_id;
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina il business
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le attività aggiunte dall'utente (ma non ancora registrate)
  DELETE FROM unclaimed_business_locations WHERE added_by = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE JOB SEEKING
  -- ========================================

  -- Elimina le richieste di lavoro (proprie e dei membri della famiglia)
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina gli annunci job seeker dell'utente E dei membri della famiglia
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  IF family_member_ids IS NOT NULL AND array_length(family_member_ids, 1) > 0 THEN
    DELETE FROM job_seekers WHERE family_member_id = ANY(family_member_ids);
  END IF;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE MESSAGGI (SISTEMA UNIFICATO)
  -- ========================================

  -- Elimina i messaggi inviati dall'utente
  DELETE FROM messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dove l'utente è partecipante (o i suoi familiari)
  DELETE FROM conversations WHERE 
    participant1_id = user_profile_id
    OR participant2_id = user_profile_id;
  
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
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;

  RAISE NOTICE 'Account eliminato completamente: %', user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- Commento sulla funzione
COMMENT ON FUNCTION delete_user_account() IS 'Elimina completamente l''account utente e TUTTI i contenuti associati. Eliminazione PERMANENTE e IRREVERSIBILE.';
