/*
  # Create Admin Delete User Function

  1. Changes
    - Create function `admin_delete_user_account(user_id_to_delete uuid)` that allows admins to delete any user
    - Similar to `delete_user_account()` but accepts a user ID parameter
    - Only executable by admins (checked via RLS and is_admin field)

  2. Security
    - Function checks if caller is admin before proceeding
    - SECURITY DEFINER to allow deletion of data
    - Comprehensive cleanup of all user data and relationships
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
  SELECT is_admin INTO is_caller_admin
  FROM profiles
  WHERE id = caller_user_id;

  IF NOT COALESCE(is_caller_admin, false) THEN
    RAISE EXCEPTION 'Permesso negato: solo gli admin possono eliminare gli utenti';
  END IF;

  -- Verifica che l'utente da eliminare esista
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = user_id_to_delete) THEN
    RAISE EXCEPTION 'Utente non trovato';
  END IF;

  -- Ottieni l'ID del business se l'utente è un business (cerca tramite owner_id)
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_id_to_delete;

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
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_id_to_delete;

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

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_id_to_delete;

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

END;
$$;

-- Permetti solo agli admin di eseguire questa funzione
GRANT EXECUTE ON FUNCTION admin_delete_user_account(uuid) TO authenticated;

-- Commento sulla funzione
COMMENT ON FUNCTION admin_delete_user_account(uuid) IS 'Permette agli admin di eliminare completamente qualsiasi account utente. Eliminazione PERMANENTE e IRREVERSIBILE.';
