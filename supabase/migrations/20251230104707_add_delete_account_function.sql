/*
  # Funzione per Eliminare Account Utente

  1. Nuove Funzioni
    - `delete_user_account()` - Funzione che elimina l'account utente e tutti i dati associati
  
  2. Cosa Viene Eliminato
    - Recensioni dell'utente (reviews)
    - Annunci classificati (classified_ads)
    - Membri della famiglia (customer_family_members)
    - Attività utente (user_activity)
    - Sconti creati dall'azienda (discounts)
    - Annunci di lavoro dell'azienda (job_postings)
    - Azienda e sedi (businesses, business_locations)
    - Richieste di lavoro (job_requests)
    - Messaggi (classified_ad_messages, job_seeker_messages)
    - Segnalazioni (content_reports)
    - Notifiche (notifications)
    - Referral (referrals come referrer e come referee)
    - Abbonamenti (business_subscriptions, user_subscriptions)
    - Profilo (profiles)
    - Account auth (auth.users)

  3. Sicurezza
    - La funzione può essere eseguita solo dall'utente proprietario dell'account
    - Tutti i dati vengono eliminati in modo irreversibile
*/

-- Funzione per eliminare l'account utente e tutti i dati associati
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

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina gli annunci classificati e i messaggi associati
  DELETE FROM classified_ad_messages WHERE ad_id IN (
    SELECT id FROM classified_ads WHERE user_id = user_profile_id
  );
  DELETE FROM classified_ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_seeker_messages WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina i job seekers
    DELETE FROM job_seekers WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina gli abbonamenti business
    DELETE FROM business_subscriptions WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM content_reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina i referral (sia come referrer che come referee)
  DELETE FROM referrals WHERE referrer_id = user_profile_id OR referee_id = user_profile_id;

  -- Elimina gli abbonamenti utente
  DELETE FROM user_subscriptions WHERE user_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;