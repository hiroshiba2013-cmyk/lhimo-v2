/*
  # Aggiorna Eliminazione Account - Aggiungi Discount Redemptions

  1. Problema Risolto
    - Aggiungi eliminazione delle discount_redemptions quando si elimina l'account
  
  2. Sicurezza
    - Mantiene SECURITY DEFINER per accesso completo
    - Verifica autenticazione utente
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione aggiornata
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- IMPORTANTE: Gestisci le recensioni approvate da questo utente
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le redemptions degli sconti
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina i messaggi degli annunci classificati dell'utente
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT c.id FROM ad_conversations c
    JOIN classified_ads ca ON c.ad_id = ca.id
    WHERE ca.user_id = user_profile_id
  );
  
  -- Elimina i messaggi inviati dall'utente negli annunci
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni degli annunci
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;
  
  -- Elimina i messaggi generici dell'utente
  DELETE FROM messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni generiche
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;
  
  -- Elimina gli annunci classificati
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_offer_messages WHERE conversation_id IN (
      SELECT id FROM job_offer_conversations WHERE job_posting_id IN (
        SELECT id FROM job_postings WHERE business_id = user_business_id
      )
    );
    
    -- Elimina le conversazioni degli annunci di lavoro
    DELETE FROM job_offer_conversations WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le visualizzazioni degli annunci di lavoro
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le application agli annunci di lavoro
    DELETE FROM job_applications WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker (come employer o seeker)
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;
  
  -- Elimina i messaggi nelle conversazioni di job offer
  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni di job offer
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;