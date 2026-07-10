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