
/*
  # Pulizia completa utenti di prova - v7
*/
DO $$
DECLARE
  v_user_ids uuid[];
  v_family_member_ids uuid[];
BEGIN
  SELECT ARRAY_AGG(id) INTO v_user_ids
  FROM profiles WHERE user_type != 'admin';

  IF v_user_ids IS NULL OR array_length(v_user_ids, 1) = 0 THEN
    RAISE NOTICE 'Nessun utente non-admin trovato.'; RETURN;
  END IF;

  SELECT ARRAY_AGG(id) INTO v_family_member_ids
  FROM customer_family_members WHERE customer_id = ANY(v_user_ids);

  -- Messaggistica
  DELETE FROM messages WHERE conversation_id IN (
    SELECT id FROM conversations WHERE participant1_id = ANY(v_user_ids) OR participant2_id = ANY(v_user_ids));
  DELETE FROM conversations WHERE participant1_id = ANY(v_user_ids) OR participant2_id = ANY(v_user_ids);

  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT id FROM ad_conversations WHERE buyer_id = ANY(v_user_ids) OR seller_id = ANY(v_user_ids));
  DELETE FROM ad_conversations WHERE buyer_id = ANY(v_user_ids) OR seller_id = ANY(v_user_ids);

  DELETE FROM job_offer_messages WHERE conversation_id IN (
    SELECT id FROM job_offer_conversations WHERE applicant_id = ANY(v_user_ids) OR employer_id = ANY(v_user_ids));
  DELETE FROM job_offer_conversations WHERE applicant_id = ANY(v_user_ids) OR employer_id = ANY(v_user_ids);

  DELETE FROM job_seeker_messages WHERE conversation_id IN (
    SELECT id FROM job_seeker_conversations WHERE seeker_id = ANY(v_user_ids) OR employer_id = ANY(v_user_ids));
  DELETE FROM job_seeker_conversations WHERE seeker_id = ANY(v_user_ids) OR employer_id = ANY(v_user_ids);

  -- Notifiche, segnalazioni, preferiti
  DELETE FROM notifications WHERE user_id = ANY(v_user_ids);
  DELETE FROM reports WHERE reporter_id = ANY(v_user_ids);
  DELETE FROM favorite_classified_ads WHERE user_id = ANY(v_user_ids);
  DELETE FROM favorite_businesses WHERE user_id = ANY(v_user_ids);
  DELETE FROM favorite_job_postings WHERE user_id = ANY(v_user_ids);

  -- Annunci
  DELETE FROM classified_ad_views WHERE ad_id IN (SELECT id FROM classified_ads WHERE user_id = ANY(v_user_ids));
  DELETE FROM classified_ads WHERE user_id = ANY(v_user_ids);

  -- Aste
  DELETE FROM auction_bids WHERE auction_id IN (SELECT id FROM auctions WHERE user_id = ANY(v_user_ids));
  DELETE FROM auctions WHERE user_id = ANY(v_user_ids);

  -- Lavoro
  DELETE FROM job_requests WHERE customer_id = ANY(v_user_ids);
  DELETE FROM job_seekers WHERE user_id = ANY(v_user_ids);
  DELETE FROM job_views WHERE job_posting_id IN (
    SELECT id FROM job_postings WHERE registered_business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM job_postings WHERE registered_business_id IN (
    SELECT id FROM registered_businesses WHERE owner_id = ANY(v_user_ids));

  DELETE FROM professional_profiles WHERE user_id = ANY(v_user_ids);

  -- Recensioni
  DELETE FROM review_responses WHERE review_id IN (SELECT id FROM reviews WHERE customer_id = ANY(v_user_ids));
  DELETE FROM reviews WHERE customer_id = ANY(v_user_ids);
  DELETE FROM review_responses WHERE review_id IN (
    SELECT id FROM reviews WHERE registered_business_location_id IN (
      SELECT id FROM registered_business_locations WHERE business_id IN (
        SELECT id FROM registered_businesses WHERE owner_id = ANY(v_user_ids))));
  DELETE FROM reviews WHERE registered_business_location_id IN (
    SELECT id FROM registered_business_locations WHERE business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM review_responses WHERE business_owner_id = ANY(v_user_ids);
  DELETE FROM review_responses WHERE review_id IN (
    SELECT id FROM reviews
    WHERE user_added_business_id IN (SELECT id FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids))
       OR unclaimed_business_location_id IN (SELECT id FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids)));
  DELETE FROM reviews WHERE user_added_business_id IN (SELECT id FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids));
  DELETE FROM reviews WHERE unclaimed_business_location_id IN (SELECT id FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids));

  -- Sedi non reclamate
  DELETE FROM favorite_businesses WHERE unclaimed_business_location_id IN (
    SELECT id FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids));
  DELETE FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids);

  -- Attività registrate
  DELETE FROM favorite_businesses WHERE registered_business_location_id IN (
    SELECT id FROM registered_business_locations WHERE business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM registered_business_locations WHERE business_id IN (
    SELECT id FROM registered_businesses WHERE owner_id = ANY(v_user_ids));
  DELETE FROM registered_businesses WHERE owner_id = ANY(v_user_ids);

  -- Prodotti, sconti
  DELETE FROM products WHERE owner_id = ANY(v_user_ids);
  DELETE FROM discount_redemptions WHERE customer_id = ANY(v_user_ids);

  -- Family members (prima user_activity correlata)
  IF v_family_member_ids IS NOT NULL AND array_length(v_family_member_ids, 1) > 0 THEN
    DELETE FROM notifications WHERE family_member_id = ANY(v_family_member_ids);
    DELETE FROM user_activity WHERE family_member_id = ANY(v_family_member_ids);
    DELETE FROM activity_log WHERE family_member_id = ANY(v_family_member_ids);
  END IF;
  DELETE FROM customer_family_members WHERE customer_id = ANY(v_user_ids);

  -- Activity log e punti
  DELETE FROM activity_log WHERE user_id = ANY(v_user_ids);
  DELETE FROM user_activity WHERE user_id = ANY(v_user_ids);

  -- Abbonamenti: disabilita solo trigger utente (non system triggers)
  ALTER TABLE subscriptions DISABLE TRIGGER USER;
  DELETE FROM subscriptions WHERE customer_id = ANY(v_user_ids);
  ALTER TABLE subscriptions ENABLE TRIGGER USER;

  -- Profili e auth
  DELETE FROM profiles WHERE id = ANY(v_user_ids);
  DELETE FROM auth.users WHERE id = ANY(v_user_ids);

  RAISE NOTICE 'Eliminati % utenti non-admin con tutti i loro dati.', array_length(v_user_ids, 1);
END;
$$;
