-- ============================================================
-- MIGRAZIONE: Ripristina funzioni RPC mancanti - Parte 2
-- ============================================================

-- ============================================================
-- FUNCTION: get_business_ratings_by_type
-- ============================================================
CREATE OR REPLACE FUNCTION get_business_ratings_by_type(p_business_id uuid, p_business_type text DEFAULT 'registered')
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'total_avg', CASE WHEN COUNT(*) > 0 THEN ROUND(AVG(overall_rating)::numeric, 1) ELSE 0 END,
    'total_count', COUNT(*),

    'service_used', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'service_used'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'gestione_prenotazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND booking_management_rating IS NOT NULL) > 0
        THEN ROUND(AVG(booking_management_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND reliability_rating IS NOT NULL) > 0
        THEN ROUND(AVG(reliability_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND organization_rating IS NOT NULL) > 0
        THEN ROUND(AVG(organization_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'esperienza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND experience_rating IS NOT NULL) > 0
        THEN ROUND(AVG(experience_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'prezzo', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND price_rating IS NOT NULL) > 0
        THEN ROUND(AVG(price_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END
    ),

    'booking_not_completed', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'booking_not_completed'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'gestione_prenotazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_gestione_prenotazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_gestione_prenotazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_affidabilita IS NOT NULL) > 0
        THEN ROUND(AVG(booking_affidabilita) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_organizzazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_organizzazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'comunicazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_comunicazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_comunicazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END
    ),

    'quote_request', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'quote_request'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'chiarezza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_chiarezza IS NOT NULL) > 0
        THEN ROUND(AVG(quote_chiarezza) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'trasparenza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_trasparenza IS NOT NULL) > 0
        THEN ROUND(AVG(quote_trasparenza) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'tempistiche_risposta', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_tempistiche_risposta IS NOT NULL) > 0
        THEN ROUND(AVG(quote_tempistiche_risposta) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'disponibilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_disponibilita IS NOT NULL) > 0
        THEN ROUND(AVG(quote_disponibilita) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END
    ),

    'customer_service', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'customer_service'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'cortesia', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_cortesia IS NOT NULL) > 0
        THEN ROUND(AVG(cs_cortesia) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'competenza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_competenza IS NOT NULL) > 0
        THEN ROUND(AVG(cs_competenza) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'rapidita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_rapidita IS NOT NULL) > 0
        THEN ROUND(AVG(cs_rapidita) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'risoluzione_problema', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_risoluzione_problema IS NOT NULL) > 0
        THEN ROUND(AVG(cs_risoluzione_problema) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END
    ),

    'problem_before_service', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'problem_before_service'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_affidabilita IS NOT NULL) > 0
        THEN ROUND(AVG(problem_affidabilita) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_organizzazione IS NOT NULL) > 0
        THEN ROUND(AVG(problem_organizzazione) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'gestione_problema', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_gestione_problema IS NOT NULL) > 0
        THEN ROUND(AVG(problem_gestione_problema) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'comunicazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_comunicazione IS NOT NULL) > 0
        THEN ROUND(AVG(problem_comunicazione) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END
    )
  ) INTO v_result
  FROM reviews
  WHERE review_status = 'approved'
    AND (
      (p_business_type = 'registered' AND (business_id = p_business_id OR registered_business_id = p_business_id))
      OR (p_business_type = 'imported' AND (imported_business_id = p_business_id OR unclaimed_business_location_id = p_business_id))
      OR (p_business_type = 'user_added' AND user_added_business_id = p_business_id)
    );

  RETURN COALESCE(v_result, '{}'::jsonb);
END;
$$;

-- ============================================================
-- FUNCTION: get_cities_by_province
-- ============================================================
CREATE OR REPLACE FUNCTION get_cities_by_province(p_province text)
RETURNS TABLE(city text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT u.city
  FROM unclaimed_business_locations u
  WHERE u.province = p_province
    AND u.is_claimed = false
    AND u.approval_status = 'approved'
    AND u.city IS NOT NULL
    AND u.city != ''
  ORDER BY u.city;
$$;

-- ============================================================
-- FUNCTION: get_province_list
-- ADAPTED: provincia -> nome_provincia
-- ============================================================
CREATE OR REPLACE FUNCTION get_province_list()
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT DISTINCT nome_provincia FROM comuni_italiani ORDER BY nome_provincia;
$$;

-- ============================================================
-- FUNCTION: get_trial_statistics
-- ============================================================
CREATE OR REPLACE FUNCTION get_trial_statistics()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total_registered bigint;
  v_total_blocked bigint;
  v_active_trials bigint;
  v_recent_blocks jsonb;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()) THEN
    RAISE EXCEPTION 'Accesso negato: solo admin' USING ERRCODE = '42501';
  END IF;

  SELECT COUNT(*) INTO v_total_registered FROM trial_usage_history;
  SELECT COALESCE(SUM(attempts_blocked), 0) INTO v_total_blocked FROM trial_usage_history;
  SELECT COUNT(*) INTO v_active_trials FROM subscriptions WHERE status = 'trial' AND end_date > now();

  SELECT jsonb_agg(
    jsonb_build_object(
      'fiscal_code', SUBSTRING(fiscal_code, 1, 6) || '***',
      'attempts', attempts_blocked,
      'last_attempt', last_attempt_date
    )
  ) INTO v_recent_blocks
  FROM (
    SELECT fiscal_code, attempts_blocked, last_attempt_date
    FROM trial_usage_history
    WHERE attempts_blocked > 0
    ORDER BY last_attempt_date DESC NULLS LAST
    LIMIT 10
  ) recent;

  RETURN jsonb_build_object(
    'total_registered_fiscal_codes', v_total_registered,
    'total_attempts_blocked', v_total_blocked,
    'active_trials', v_active_trials,
    'recent_blocked_attempts', COALESCE(v_recent_blocks, '[]'::jsonb)
  );
END;
$$;

-- ============================================================
-- FUNCTION: get_user_trial_details
-- ============================================================
CREATE OR REPLACE FUNCTION get_user_trial_details(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_cf text;
  v_family_cfs text[];
  v_blocked_cfs text[];
BEGIN
  IF NOT EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()) THEN
    RAISE EXCEPTION 'Accesso negato: solo admin' USING ERRCODE = '42501';
  END IF;

  SELECT fiscal_code INTO v_user_cf FROM profiles WHERE id = p_user_id;

  SELECT array_agg(tax_code) INTO v_family_cfs
  FROM customer_family_members
  WHERE customer_id = p_user_id AND tax_code IS NOT NULL;

  IF v_family_cfs IS NOT NULL THEN
    SELECT array_agg(fiscal_code) INTO v_blocked_cfs
    FROM trial_usage_history
    WHERE fiscal_code = ANY(v_family_cfs) OR fiscal_code = v_user_cf;
  ELSE
    SELECT array_agg(fiscal_code) INTO v_blocked_cfs
    FROM trial_usage_history
    WHERE fiscal_code = v_user_cf;
  END IF;

  RETURN jsonb_build_object(
    'user_id', p_user_id,
    'user_fiscal_code', v_user_cf,
    'family_fiscal_codes', COALESCE(v_family_cfs, ARRAY[]::text[]),
    'blocked_fiscal_codes', COALESCE(v_blocked_cfs, ARRAY[]::text[]),
    'is_eligible', (v_blocked_cfs IS NULL OR array_length(v_blocked_cfs, 1) IS NULL),
    'eligibility_check', check_trial_eligibility(p_user_id)
  );
END;
$$;

-- ============================================================
-- FUNCTION: log_admin_logout
-- ============================================================
CREATE OR REPLACE FUNCTION log_admin_logout()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE admin_login_logs
  SET logout_time = now()
  WHERE admin_id = auth.uid()
    AND logout_time IS NULL
    AND login_time = (
      SELECT MAX(login_time) FROM admin_login_logs
      WHERE admin_id = auth.uid() AND logout_time IS NULL
    );
END;
$$;

-- ============================================================
-- FUNCTION: notify_admins_new_unclaimed_business
-- ADAPTED: added_by_family_member_id -> added_by_family_member
-- ============================================================
CREATE OR REPLACE FUNCTION notify_admins_new_unclaimed_business()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_admin RECORD;
  v_author_name text;
BEGIN
  IF NEW.added_by IS NULL OR NEW.osm_id IS NOT NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.added_by_family_member IS NOT NULL THEN
    SELECT COALESCE(nickname, first_name || ' ' || last_name)
    INTO v_author_name
    FROM customer_family_members WHERE id = NEW.added_by_family_member;
  ELSE
    SELECT COALESCE(nickname, full_name, email)
    INTO v_author_name
    FROM profiles WHERE id = NEW.added_by;
  END IF;

  FOR v_admin IN SELECT user_id FROM admins LOOP
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      v_admin.user_id, NULL, 'admin_new_business',
      'Nuova Attivita''',
      'Una nuova attivita'' "' || NEW.name || '" e'' stata aggiunta da ' || COALESCE(v_author_name, 'un utente') || ' ed e'' in attesa di approvazione.',
      jsonb_build_object('business_id', NEW.id, 'url', '/admin')
    );
  END LOOP;

  RETURN NEW;
END;
$$;

-- ============================================================
-- FUNCTION: notify_trial_expiring_soon
-- ADAPTED: profile_type -> user_type, language hardcoded Italian, metadata -> data
-- ============================================================
CREATE OR REPLACE FUNCTION notify_trial_expiring_soon()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO notifications (user_id, type, title, message, data)
  SELECT id, 'subscription', 'La tua prova gratuita sta per scadere',
    'La tua prova gratuita terminerà tra 7 giorni. Sottoscrivi un piano per continuare ad accedere alle funzionalità premium senza interruzioni.',
    jsonb_build_object('trial_expiring_soon', true, 'days_remaining', 7, 'trial_end_date', trial_end_date)
  FROM profiles
  WHERE subscription_status = 'trial'
    AND trial_end_date IS NOT NULL
    AND trial_end_date BETWEEN now() + interval '6 days 23 hours' AND now() + interval '7 days 1 hour'
    AND user_type = 'business'
    AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.user_id = profiles.id
        AND n.type = 'subscription'
        AND n.data->>'trial_expiring_soon' = 'true'
        AND n.created_at > now() - interval '2 days'
    );
END;
$$;

-- ============================================================
-- FUNCTION: populate_user_activity
-- ADAPTED: ads_count -> ads_posted_count, job_postings_count removed, referrals_count removed
-- ============================================================
CREATE OR REPLACE FUNCTION populate_user_activity()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_record RECORD;
  reviews_cnt INTEGER;
  ads_cnt INTEGER;
  points INTEGER;
BEGIN
  FOR user_record IN
    SELECT id, referral_count FROM profiles WHERE user_type IN ('customer', 'business')
  LOOP
    SELECT COUNT(*) INTO reviews_cnt
    FROM reviews WHERE customer_id = user_record.id AND review_status = 'approved';

    SELECT COUNT(*) INTO ads_cnt
    FROM classified_ads WHERE user_id = user_record.id AND status = 'active';

    SELECT COALESCE(SUM(CASE WHEN proof_image_url IS NOT NULL THEN 50 ELSE 25 END), 0)
    INTO points
    FROM reviews WHERE customer_id = user_record.id AND review_status = 'approved';

    points := points + (ads_cnt * 10);
    points := points + (COALESCE(user_record.referral_count, 0) * 100);

    INSERT INTO user_activity (user_id, total_points, reviews_count, ads_posted_count, last_activity_at, updated_at)
    VALUES (user_record.id, points, reviews_cnt, ads_cnt, now(), now())
    ON CONFLICT (user_id) DO UPDATE SET
      total_points = EXCLUDED.total_points,
      reviews_count = EXCLUDED.reviews_count,
      ads_posted_count = EXCLUDED.ads_posted_count,
      last_activity_at = now(),
      updated_at = now();
  END LOOP;
END;
$$;

-- ============================================================
-- FUNCTION: refresh_business_ratings
-- NOTE: business_ratings materialized view doesn't exist in new schema - no-op
-- ============================================================
CREATE OR REPLACE FUNCTION refresh_business_ratings()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE NOTICE 'refresh_business_ratings: business_ratings materialized view does not exist in current schema';
END;
$$;

-- ============================================================
-- FUNCTION: register_trial_usage
-- ============================================================
CREATE OR REPLACE FUNCTION register_trial_usage(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_fiscal_code text;
  v_family_member record;
BEGIN
  SELECT fiscal_code INTO v_fiscal_code FROM profiles WHERE id = p_user_id;

  IF v_fiscal_code IS NOT NULL AND v_fiscal_code != '' THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_fiscal_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  FOR v_family_member IN
    SELECT tax_code FROM customer_family_members
    WHERE customer_id = p_user_id AND tax_code IS NOT NULL AND tax_code != ''
  LOOP
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_family_member.tax_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END LOOP;
END;
$$;

-- ============================================================
-- FUNCTION: sync_user_activity
-- ============================================================
CREATE OR REPLACE FUNCTION sync_user_activity()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  SELECT 
    p.id as user_id,
    COALESCE(SUM(CASE WHEN r.proof_image_url IS NOT NULL THEN 50 ELSE 25 END), 0) as total_points,
    COUNT(r.id) as reviews_count,
    NOW() as last_activity_at,
    NOW() as updated_at
  FROM profiles p
  LEFT JOIN reviews r ON r.customer_id = p.id 
    AND r.family_member_id IS NULL 
    AND r.review_status = 'approved'
  WHERE p.user_type = 'customer'
  GROUP BY p.id
  ON CONFLICT (user_id) 
  DO UPDATE SET
    total_points = EXCLUDED.total_points,
    reviews_count = EXCLUDED.reviews_count,
    updated_at = NOW();
END;
$$;
