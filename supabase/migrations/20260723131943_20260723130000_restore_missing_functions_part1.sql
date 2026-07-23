-- ============================================================
-- MIGRAZIONE: Ripristina funzioni RPC mancanti dal vecchio progetto
-- Adattato allo schema del nuovo progetto
-- ============================================================

-- Add missing columns to auctions table
ALTER TABLE auctions ADD COLUMN IF NOT EXISTS winner_index integer DEFAULT 0;
ALTER TABLE auctions ADD COLUMN IF NOT EXISTS current_completion_deadline timestamptz;

-- ============================================================
-- FUNCTION: advance_to_next_winner
-- ============================================================
CREATE OR REPLACE FUNCTION advance_to_next_winner(p_auction_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction record;
  v_current_winner_index integer;
  v_next_bid record;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Asta non trovata');
  END IF;

  v_current_winner_index := COALESCE(v_auction.winner_index, 0);

  UPDATE auction_deposits
  SET forfeited = true, forfeited_at = now()
  WHERE auction_id = p_auction_id
    AND user_id = v_auction.winner_id
    AND forfeited = false
    AND refunded = false;

  SELECT
    ab.user_id, ab.family_member_id, ab.bid_amount, p.nickname, p.full_name
  INTO v_next_bid
  FROM auction_bids ab
  JOIN profiles p ON p.id = ab.user_id
  WHERE ab.auction_id = p_auction_id
    AND ab.user_id != v_auction.winner_id
    AND ab.user_id NOT IN (
      SELECT user_id FROM auction_deposits
      WHERE auction_id = p_auction_id AND forfeited = true
    )
  ORDER BY ab.bid_amount DESC, ab.created_at ASC
  LIMIT 1;

  IF NOT FOUND THEN
    UPDATE auctions SET status = 'expired', updated_at = now() WHERE id = p_auction_id;

    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    SELECT a.user_id, a.family_member_id, 'auction_concluded',
      'Asta Terminata Senza Conclusione',
      'Nessun acquirente ha confermato l''affare per la tua asta "' || a.title || '". L''asta è stata chiusa.',
      json_build_object('auction_id', p_auction_id)
    FROM auctions a WHERE a.id = p_auction_id;

    RETURN json_build_object('success', true, 'status', 'no_more_bidders');
  END IF;

  UPDATE auctions
  SET winner_id = v_next_bid.user_id,
      winner_family_member_id = v_next_bid.family_member_id,
      winner_index = v_current_winner_index + 1,
      current_completion_deadline = now() + interval '48 hours',
      status = 'completed', updated_at = now()
  WHERE id = p_auction_id;

  DELETE FROM auction_completions WHERE auction_id = p_auction_id;

  INSERT INTO auction_completions (auction_id, winner_user_id, winner_family_member_id_completion, completion_deadline, attempt_number)
  VALUES (p_auction_id, v_next_bid.user_id, v_next_bid.family_member_id, now() + interval '48 hours', v_current_winner_index + 2);

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_next_bid.user_id, v_next_bid.family_member_id, 'auction_won',
    'Sei il Nuovo Vincitore!',
    'Il vincitore precedente non ha confermato l''affare. Ora sei il vincitore dell''asta "' || v_auction.title || '" con un''offerta di ' || v_next_bid.bid_amount || ' EUR. Hai 48 ore per confermare.',
    json_build_object('auction_id', p_auction_id, 'bid_amount', v_next_bid.bid_amount));

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  SELECT a.user_id, a.family_member_id, 'auction_concluded',
    'Nuovo Acquirente per la Tua Asta',
    'Il vincitore precedente non ha confermato. Il nuovo acquirente è ' || COALESCE(v_next_bid.nickname, v_next_bid.full_name) || ' per la tua asta "' || a.title || '". Hai 48 ore per confermare.',
    json_build_object('auction_id', p_auction_id)
  FROM auctions a WHERE a.id = p_auction_id;

  RETURN json_build_object('success', true, 'status', 'advanced', 'new_winner_id', v_next_bid.user_id);
END;
$$;

-- ============================================================
-- FUNCTION: check_auction_completion_deadlines
-- ============================================================
CREATE OR REPLACE FUNCTION check_auction_completion_deadlines()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_completion record;
BEGIN
  FOR v_completion IN
    SELECT ac.*, a.user_id AS seller_id, a.winner_id, a.title, a.family_member_id AS seller_family_member_id
    FROM auction_completions ac
    JOIN auctions a ON a.id = ac.auction_id
    WHERE ac.completion_deadline < now()
      AND ac.buyer_confirmed = false
      AND a.status = 'completed'
  LOOP
    PERFORM advance_to_next_winner(v_completion.auction_id);
  END LOOP;
END;
$$;

-- ============================================================
-- FUNCTION: check_fiscal_code_trial_eligibility
-- ============================================================
CREATE OR REPLACE FUNCTION check_fiscal_code_trial_eligibility(p_fiscal_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF p_fiscal_code IS NULL OR p_fiscal_code = '' THEN
    RETURN jsonb_build_object('eligible', false, 'message', 'Il codice fiscale è obbligatorio');
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM trial_usage_history WHERE fiscal_code = UPPER(TRIM(p_fiscal_code))
  ) INTO v_exists;

  IF v_exists THEN
    RETURN jsonb_build_object('eligible', false, 'message', 'Questo codice fiscale ha già usufruito del periodo di prova');
  END IF;

  RETURN jsonb_build_object('eligible', true, 'message', 'Codice fiscale idoneo per il periodo di prova');
END;
$$;

-- ============================================================
-- FUNCTION: check_subscription_expiration
-- ADAPTED: business_subscriptions -> subscriptions table
-- ============================================================
CREATE OR REPLACE FUNCTION check_subscription_expiration()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_subscription RECORD;
  v_days_until_expiry integer;
  v_notification_exists boolean;
BEGIN
  FOR v_subscription IN
    SELECT s.id, s.customer_id, s.end_date, p.full_name
    FROM subscriptions s
    JOIN profiles p ON p.id = s.customer_id
    WHERE s.status = 'active'
      AND s.end_date IS NOT NULL
      AND s.end_date > now()
      AND s.end_date <= now() + interval '7 days'
  LOOP
    v_days_until_expiry := EXTRACT(DAY FROM (v_subscription.end_date - now()))::integer;
    
    IF v_days_until_expiry IN (7, 3, 1) THEN
      SELECT EXISTS (
        SELECT 1 FROM notifications
        WHERE user_id = v_subscription.customer_id
          AND type = 'subscription_expiring'
          AND data->>'subscription_id' = v_subscription.id::text
          AND created_at >= now() - interval '1 day'
      ) INTO v_notification_exists;
      
      IF NOT v_notification_exists THEN
        INSERT INTO notifications (user_id, type, title, message, data)
        VALUES (
          v_subscription.customer_id,
          'subscription_expiring',
          'Abbonamento in scadenza',
          format('Il tuo abbonamento scadrà tra %s %s. Rinnova ora per non perdere i vantaggi!',
            v_days_until_expiry,
            CASE WHEN v_days_until_expiry = 1 THEN 'giorno' ELSE 'giorni' END),
          jsonb_build_object('subscription_id', v_subscription.id, 'days_until_expiry', v_days_until_expiry, 'end_date', v_subscription.end_date, 'url', '/subscription')
        );
      END IF;
    END IF;
  END LOOP;
END;
$$;

-- ============================================================
-- FUNCTION: check_trial_eligibility
-- ============================================================
CREATE OR REPLACE FUNCTION check_trial_eligibility(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_fiscal_code text;
  v_family_fiscal_codes text[];
  v_blocked_cf text;
BEGIN
  SELECT fiscal_code INTO v_fiscal_code FROM profiles WHERE id = p_user_id;

  IF v_fiscal_code IS NULL OR v_fiscal_code = '' THEN
    RETURN jsonb_build_object('eligible', false, 'reason', 'fiscal_code_required', 'message', 'Il codice fiscale è obbligatorio per attivare il periodo di prova');
  END IF;

  SELECT fiscal_code INTO v_blocked_cf FROM trial_usage_history WHERE fiscal_code = v_fiscal_code;

  IF v_blocked_cf IS NOT NULL THEN
    RETURN jsonb_build_object('eligible', false, 'reason', 'trial_already_used', 'message', 'Questo codice fiscale ha già usufruito del periodo di prova');
  END IF;

  SELECT array_agg(tax_code) INTO v_family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = p_user_id AND tax_code IS NOT NULL AND tax_code != '';

  IF v_family_fiscal_codes IS NOT NULL THEN
    SELECT fiscal_code INTO v_blocked_cf FROM trial_usage_history WHERE fiscal_code = ANY(v_family_fiscal_codes) LIMIT 1;

    IF v_blocked_cf IS NOT NULL THEN
      RETURN jsonb_build_object('eligible', false, 'reason', 'family_member_trial_used', 'message', 'Un membro della famiglia ha già usufruito del periodo di prova');
    END IF;
  END IF;

  RETURN jsonb_build_object('eligible', true, 'reason', 'eligible', 'message', 'Idoneo al periodo di prova');
END;
$$;

-- ============================================================
-- FUNCTION: check_trial_expiration
-- ADAPTED: profile_type -> user_type, language hardcoded Italian, metadata -> data
-- ============================================================
CREATE OR REPLACE FUNCTION check_trial_expiration()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE profiles
  SET subscription_status = 'expired', updated_at = now()
  WHERE subscription_status = 'trial'
    AND trial_end_date IS NOT NULL
    AND trial_end_date < now()
    AND user_type = 'business';

  INSERT INTO notifications (user_id, type, title, message, data)
  SELECT id, 'subscription', 'Prova gratuita terminata',
    'La tua prova gratuita è terminata. Sottoscrivi un piano per continuare ad accedere alle funzionalità premium.',
    jsonb_build_object('trial_expired', true)
  FROM profiles
  WHERE subscription_status = 'expired'
    AND trial_end_date IS NOT NULL
    AND trial_end_date < now()
    AND user_type = 'business'
    AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.user_id = profiles.id
        AND n.type = 'subscription'
        AND n.data->>'trial_expired' = 'true'
        AND n.created_at > now() - interval '1 day'
    );
END;
$$;

-- ============================================================
-- FUNCTION: cleanup_non_admin_users
-- ADAPTED: conversation_messages -> messages, activity_logs -> activity_log,
-- unclaimed_businesses -> unclaimed_business_locations, trial_prevention removed
-- ============================================================
CREATE OR REPLACE FUNCTION cleanup_non_admin_users()
RETURNS TABLE (deleted_users_count integer, deleted_profiles_count integer, message text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_deleted_users integer := 0;
  v_deleted_profiles integer := 0;
  v_user_ids uuid[];
  v_admin_id uuid;
BEGIN
  SELECT id INTO v_admin_id FROM admins WHERE user_id = auth.uid();
  
  IF v_admin_id IS NULL THEN
    RAISE EXCEPTION 'Solo gli amministratori possono eseguire questa funzione';
  END IF;

  SELECT ARRAY_AGG(p.id) INTO v_user_ids
  FROM profiles p WHERE p.user_type != 'admin' OR p.user_type IS NULL;

  IF v_user_ids IS NULL OR array_length(v_user_ids, 1) = 0 THEN
    RETURN QUERY SELECT 0, 0, 'Nessun utente non-admin da eliminare'::text;
    RETURN;
  END IF;

  DELETE FROM messages WHERE conversation_id IN (
    SELECT id FROM conversations WHERE participant1_id = ANY(v_user_ids) OR participant2_id = ANY(v_user_ids)
  );
  DELETE FROM conversations WHERE participant1_id = ANY(v_user_ids) OR participant2_id = ANY(v_user_ids);
  DELETE FROM notifications WHERE user_id = ANY(v_user_ids);
  DELETE FROM reports WHERE reporter_id = ANY(v_user_ids);
  DELETE FROM favorite_classified_ads WHERE user_id = ANY(v_user_ids);
  DELETE FROM favorite_businesses WHERE user_id = ANY(v_user_ids);
  DELETE FROM classified_ad_views WHERE ad_id IN (SELECT id FROM classified_ads WHERE user_id = ANY(v_user_ids));
  DELETE FROM classified_ads WHERE user_id = ANY(v_user_ids);
  DELETE FROM solidarity_requests WHERE user_id = ANY(v_user_ids);
  DELETE FROM job_requests WHERE job_seeker_id IN (SELECT id FROM job_seekers WHERE user_id = ANY(v_user_ids));
  DELETE FROM job_seekers WHERE user_id = ANY(v_user_ids);
  DELETE FROM job_views WHERE job_id IN (SELECT id FROM job_postings WHERE business_location_id IN (SELECT id FROM business_locations WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM job_requests WHERE job_id IN (SELECT id FROM job_postings WHERE business_location_id IN (SELECT id FROM business_locations WHERE owner_id = ANY(v_user_ids)));
  DELETE FROM job_postings WHERE business_location_id IN (SELECT id FROM business_locations WHERE owner_id = ANY(v_user_ids));
  DELETE FROM products WHERE owner_id = ANY(v_user_ids);
  DELETE FROM discount_redemptions WHERE customer_id = ANY(v_user_ids);
  DELETE FROM review_proofs WHERE review_id IN (SELECT id FROM reviews WHERE customer_id = ANY(v_user_ids));
  DELETE FROM reviews WHERE customer_id = ANY(v_user_ids);
  DELETE FROM reviews WHERE business_location_id IN (SELECT id FROM business_locations WHERE owner_id = ANY(v_user_ids));
  DELETE FROM business_locations WHERE owner_id = ANY(v_user_ids);
  DELETE FROM unclaimed_business_locations WHERE added_by = ANY(v_user_ids);
  DELETE FROM user_added_businesses WHERE added_by = ANY(v_user_ids);
  DELETE FROM customer_family_members WHERE customer_id = ANY(v_user_ids);
  DELETE FROM referrals WHERE referrer_id = ANY(v_user_ids) OR referred_id = ANY(v_user_ids);
  DELETE FROM activity_log WHERE user_id = ANY(v_user_ids);
  DELETE FROM user_activity WHERE user_id = ANY(v_user_ids);
  DELETE FROM subscriptions WHERE customer_id = ANY(v_user_ids);
  DELETE FROM profiles WHERE id = ANY(v_user_ids);
  GET DIAGNOSTICS v_deleted_profiles = ROW_COUNT;
  DELETE FROM auth.users WHERE id = ANY(v_user_ids);
  GET DIAGNOSTICS v_deleted_users = ROW_COUNT;

  RETURN QUERY SELECT v_deleted_users, v_deleted_profiles,
    format('Eliminati %s utenti e %s profili non-admin', v_deleted_users, v_deleted_profiles)::text;
END;
$$;

-- ============================================================
-- FUNCTION: delete_admin_account
-- ============================================================
CREATE OR REPLACE FUNCTION delete_admin_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  is_user_admin boolean;
BEGIN
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  SELECT EXISTS (SELECT 1 FROM admins WHERE id = user_profile_id) INTO is_user_admin;

  IF NOT is_user_admin THEN
    RAISE EXCEPTION 'Solo gli admin possono eliminare account admin';
  END IF;

  DELETE FROM admin_login_logs WHERE admin_id = user_profile_id;
  DELETE FROM admins WHERE id = user_profile_id;
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;
  DELETE FROM notifications WHERE user_id = user_profile_id;
  DELETE FROM profiles WHERE id = user_profile_id;
  DELETE FROM auth.users WHERE id = user_profile_id;
END;
$$;

-- ============================================================
-- FUNCTION: delete_expired_classified_ads
-- ADAPTED: notifications.link -> notifications.data
-- ============================================================
CREATE OR REPLACE FUNCTION delete_expired_classified_ads()
RETURNS TABLE (deleted_count INTEGER, notified_users UUID[]) AS $$
DECLARE
  v_deleted_count INTEGER;
  v_notified_users UUID[];
BEGIN
  SELECT ARRAY_AGG(DISTINCT user_id) INTO v_notified_users
  FROM classified_ads WHERE expires_at < NOW() AND status = 'active';

  INSERT INTO notifications (user_id, title, message, type, data)
  SELECT user_id, 'Annuncio scaduto',
    'Il tuo annuncio "' || title || '" è scaduto ed è stato rimosso automaticamente dopo 30 giorni.',
    'ad_expired', jsonb_build_object('url', '/profile')
  FROM classified_ads WHERE expires_at < NOW() AND status = 'active';

  WITH deleted AS (
    DELETE FROM classified_ads WHERE expires_at < NOW() AND status = 'active' RETURNING id
  )
  SELECT COUNT(*)::INTEGER INTO v_deleted_count FROM deleted;

  RETURN QUERY SELECT v_deleted_count, v_notified_users;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- FUNCTION: expire_auctions
-- ============================================================
CREATE OR REPLACE FUNCTION expire_auctions()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE auctions SET status = 'expired', updated_at = now()
  WHERE status = 'active' AND ends_at < now() AND winner_id IS NULL;

  UPDATE auctions
  SET status = 'completed',
    winner_id = (SELECT user_id FROM auction_bids WHERE auction_id = auctions.id ORDER BY bid_amount DESC, created_at ASC LIMIT 1),
    winner_family_member_id = (SELECT family_member_id FROM auction_bids WHERE auction_id = auctions.id ORDER BY bid_amount DESC, created_at ASC LIMIT 1),
    completed_at = now(), updated_at = now()
  WHERE status = 'active' AND ends_at < now() AND current_price > 0;

  INSERT INTO auction_completions (auction_id, completion_deadline)
  SELECT id, now() + interval '48 hours'
  FROM auctions
  WHERE status = 'completed' AND completed_at > now() - interval '1 minute'
    AND NOT EXISTS (SELECT 1 FROM auction_completions WHERE auction_id = auctions.id);

  UPDATE auction_deposits SET refunded = true, refunded_at = now()
  WHERE auction_id IN (SELECT id FROM auctions WHERE status = 'expired') AND refunded = false;
END;
$$;
