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
