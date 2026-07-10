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
