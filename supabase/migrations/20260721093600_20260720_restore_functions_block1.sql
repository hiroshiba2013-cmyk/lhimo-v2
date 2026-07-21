
-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION generate_slug(text_input text)
RETURNS text AS $$
BEGIN
  RETURN lower(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
    text_input,
    '[àáâãäå]', 'a', 'g'),
    '[èéêë]', 'e', 'g'),
    '[ìíîï]', 'i', 'g'),
    '[òóôõö]', 'o', 'g'),
    '[ùúûü]', 'u', 'g'),
    '[^a-z0-9]+', '-', 'g'));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_reports_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

CREATE OR REPLACE FUNCTION update_platform_settings_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

CREATE OR REPLACE FUNCTION update_professional_profile_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

CREATE OR REPLACE FUNCTION update_charity_organizations_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

CREATE OR REPLACE FUNCTION update_registered_business_billing_address()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- ============================================================
-- CONVERSATION HELPERS
-- ============================================================

CREATE OR REPLACE FUNCTION update_conversation_last_message()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE conversations
  SET last_message_at = NEW.created_at, updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION update_job_seeker_conversation_last_message()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE job_seeker_conversations
  SET last_message_at = NEW.created_at, updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION update_job_offer_conversation_last_message()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE job_offer_conversations
  SET last_message_at = NEW.created_at, updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END; $$;

-- ============================================================
-- UNREAD MESSAGES COUNT
-- ============================================================

CREATE OR REPLACE FUNCTION get_unread_messages_count(user_uuid uuid)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE unread_count integer;
BEGIN
  SELECT COUNT(*)::integer INTO unread_count
  FROM messages m
  JOIN conversations c ON m.conversation_id = c.id
  WHERE (c.participant1_id = user_uuid OR c.participant2_id = user_uuid)
    AND m.sender_id != user_uuid
    AND m.is_read = false;
  RETURN COALESCE(unread_count, 0);
END; $$;

-- ============================================================
-- ACTIVITY LOGGING
-- ============================================================

CREATE OR REPLACE FUNCTION log_user_activity(
  p_user_id uuid,
  p_activity_type text,
  p_title text,
  p_description text,
  p_points_earned integer DEFAULT 0,
  p_metadata jsonb DEFAULT '{}',
  p_icon text DEFAULT 'activity',
  p_color text DEFAULT 'text-blue-600'
)
RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_activity_id uuid;
BEGIN
  INSERT INTO activity_log (user_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (p_user_id, p_activity_type, p_title, p_description, p_points_earned, p_metadata, p_icon, p_color)
  RETURNING id INTO v_activity_id;
  RETURN v_activity_id;
END; $$;

CREATE OR REPLACE FUNCTION log_ad_creation()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  PERFORM log_user_activity(NEW.user_id, 'ad_created', 'Annuncio pubblicato',
    'Hai pubblicato l''annuncio "' || NEW.title || '"',
    5, jsonb_build_object('ad_id', NEW.id), 'file-text', 'text-blue-600');
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION log_ad_view_milestone()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_ad classified_ads%ROWTYPE; v_total_views integer;
BEGIN
  SELECT * INTO v_ad FROM classified_ads WHERE id = NEW.ad_id;
  SELECT COUNT(*) INTO v_total_views FROM classified_ad_views WHERE ad_id = NEW.ad_id;
  IF v_total_views % 10 = 0 THEN
    PERFORM log_user_activity(v_ad.user_id, 'ad_viewed',
      'Il tuo annuncio ha raggiunto ' || v_total_views || ' visualizzazioni!',
      'L''annuncio "' || v_ad.title || '" continua a ricevere attenzione.',
      0, jsonb_build_object('ad_id', v_ad.id, 'total_views', v_total_views), 'eye', 'text-green-600');
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION log_review_submission()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_business_name text;
BEGIN
  SELECT name INTO v_business_name FROM business_locations WHERE business_id = NEW.business_id LIMIT 1;
  PERFORM log_user_activity(NEW.customer_id, 'review_created', 'Recensione inviata',
    'Hai recensito "' || COALESCE(v_business_name, 'un''attività') || '". In attesa di approvazione.',
    0, jsonb_build_object('review_id', NEW.id, 'business_id', NEW.business_id), 'star', 'text-yellow-600');
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION log_subscription_start()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_plan_name text;
BEGIN
  SELECT name INTO v_plan_name FROM subscription_plans WHERE id = NEW.plan_id;
  PERFORM log_user_activity(NEW.customer_id, 'subscription_started', 'Abbonamento attivato',
    'Hai attivato l''abbonamento "' || COALESCE(v_plan_name, 'Premium') || '"',
    0, jsonb_build_object('subscription_id', NEW.id, 'plan_id', NEW.plan_id), 'credit-card', 'text-purple-600');
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION log_review_approval()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_business_name text; v_points integer;
BEGIN
  IF NEW.review_status = 'approved' AND OLD.review_status != 'approved' THEN
    SELECT name INTO v_business_name FROM business_locations WHERE business_id = NEW.business_id LIMIT 1;
    v_points := CASE WHEN NEW.proof_image_url IS NOT NULL AND NEW.proof_image_url != '' THEN 50 ELSE 25 END;
    PERFORM log_user_activity(NEW.customer_id, 'review_approved', 'Recensione approvata!',
      'La tua recensione per "' || COALESCE(v_business_name, 'un''attività') || '" è stata approvata',
      v_points,
      jsonb_build_object('review_id', NEW.id, 'business_id', NEW.business_id,
        'has_proof', NEW.proof_image_url IS NOT NULL),
      'star', 'text-green-600');
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION log_referral_reward()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_referrer_id uuid; v_referrer_name text;
BEGIN
  IF NEW.status = 'active' AND OLD.status IS DISTINCT FROM 'active' THEN
    SELECT p.id, p.full_name INTO v_referrer_id, v_referrer_name
    FROM profiles p
    WHERE p.nickname = (SELECT referred_by_nickname FROM profiles WHERE id = NEW.customer_id);
    IF v_referrer_id IS NOT NULL THEN
      PERFORM log_user_activity(v_referrer_id, 'referral_reward', 'Bonus Amico Ricevuto!',
        'Hai guadagnato 30 punti grazie all''abbonamento del tuo amico',
        30, jsonb_build_object('referred_user_id', NEW.customer_id, 'subscription_id', NEW.id),
        'gift', 'text-yellow-600');
      UPDATE profiles SET referral_count = COALESCE(referral_count, 0) + 1 WHERE id = v_referrer_id;
    END IF;
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION get_user_activity_summary(p_user_id uuid)
RETURNS TABLE(total_activities bigint, total_points_earned bigint,
  activities_this_week bigint, activities_this_month bigint)
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN QUERY SELECT
    COUNT(*)::bigint,
    COALESCE(SUM(points_earned), 0)::bigint,
    COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '7 days')::bigint,
    COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '30 days')::bigint
  FROM activity_log WHERE user_id = p_user_id;
END; $$;

-- ============================================================
-- NOTIFICATION FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION create_notification(
  p_user_id uuid, p_type text, p_title text, p_message text, p_data jsonb DEFAULT '{}'
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (p_user_id, p_type, p_title, p_message, p_data);
END; $$;

CREATE OR REPLACE FUNCTION notify_ad_favorited()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_ad_title text; v_ad_owner_id uuid; v_favoriter_name text;
BEGIN
  SELECT ca.title, ca.user_id INTO v_ad_title, v_ad_owner_id
  FROM classified_ads ca WHERE ca.id = NEW.ad_id;
  SELECT COALESCE(p.full_name, p.email) INTO v_favoriter_name
  FROM profiles p WHERE p.id = NEW.user_id;
  IF v_ad_owner_id IS NOT NULL AND v_ad_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, message, data) VALUES (
      v_ad_owner_id, 'ad_favorited', 'Annuncio aggiunto ai preferiti',
      format('Il tuo annuncio "%s" è stato aggiunto ai preferiti da %s', v_ad_title, v_favoriter_name),
      jsonb_build_object('ad_id', NEW.ad_id, 'favorited_by', NEW.user_id));
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION notify_favorite_created()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_business_name text; v_business_owner_id uuid; v_favoriter_name text;
BEGIN
  SELECT COALESCE(p.full_name, p.email) INTO v_favoriter_name
  FROM profiles p WHERE p.id = NEW.user_id;
  IF NEW.business_id IS NOT NULL THEN
    SELECT b.name, b.owner_id INTO v_business_name, v_business_owner_id
    FROM businesses b WHERE b.id = NEW.business_id;
    IF v_business_owner_id IS NOT NULL AND v_business_owner_id != NEW.user_id THEN
      INSERT INTO notifications (user_id, type, title, message, data) VALUES (
        v_business_owner_id, 'business_favorited', 'Attività aggiunta ai preferiti',
        format('La tua attività "%s" è stata aggiunta ai preferiti da %s', v_business_name, v_favoriter_name),
        jsonb_build_object('business_id', NEW.business_id, 'favorited_by', NEW.user_id));
    END IF;
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION notify_job_seeker_favorited()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_job_title text; v_job_owner_id uuid; v_favoriter_name text;
BEGIN
  SELECT js.title, js.user_id INTO v_job_title, v_job_owner_id
  FROM job_seekers js WHERE js.id = NEW.job_seeker_id;
  SELECT COALESCE(p.full_name, p.email) INTO v_favoriter_name
  FROM profiles p WHERE p.id = NEW.user_id;
  IF v_job_owner_id IS NOT NULL AND v_job_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, message, data) VALUES (
      v_job_owner_id, 'job_favorited', 'Annuncio lavoro nei preferiti',
      format('Il tuo annuncio "%s" è stato aggiunto ai preferiti da %s', v_job_title, v_favoriter_name),
      jsonb_build_object('job_seeker_id', NEW.job_seeker_id, 'favorited_by', NEW.user_id));
  END IF;
  RETURN NEW;
END; $$;

-- ============================================================
-- CLASSIFIED ADS FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION set_classified_ad_expiration()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.expires_at IS NULL THEN NEW.expires_at := NOW() + INTERVAL '30 days'; END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION award_points_for_classified_ad()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  PERFORM award_points(NEW.user_id, 5, 'classified_ad', NEW.id::text);
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION award_points_for_product()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  PERFORM award_points(NEW.owner_id, 10, 'product', NEW.id::text);
  RETURN NEW;
END; $$;

-- ============================================================
-- BUSINESS FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION mark_business_location_as_claimed()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.business_id IS NOT NULL AND (OLD.business_id IS NULL OR NOT COALESCE(OLD.is_claimed, false)) THEN
    NEW.is_claimed := true;
    NEW.claimed_at := COALESCE(NEW.claimed_at, now());
    NEW.verification_badge := COALESCE(NEW.verification_badge, 'claimed');
    SELECT owner_id INTO NEW.claimed_by FROM businesses WHERE id = NEW.business_id;
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION sync_profile_admin_status()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NEW.is_admin = true AND NOT EXISTS (SELECT 1 FROM admins WHERE user_id = NEW.id) THEN
    INSERT INTO admins (user_id) VALUES (NEW.id);
  ELSIF NEW.is_admin = false THEN
    DELETE FROM admins WHERE user_id = NEW.id;
  END IF;
  RETURN NEW;
END; $$;

-- ============================================================
-- TRIAL FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION update_trial_plan_on_family_change()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_customer_id uuid;
  v_family_count integer;
  v_total_persons integer;
  v_new_plan_id uuid;
  v_current_subscription_id uuid;
  v_billing_period text;
BEGIN
  IF TG_OP = 'DELETE' THEN v_customer_id := OLD.customer_id;
  ELSE v_customer_id := NEW.customer_id;
  END IF;
  SELECT COUNT(*) INTO v_family_count FROM customer_family_members WHERE customer_id = v_customer_id;
  v_total_persons := 1 + v_family_count;
  SELECT s.id, sp.billing_period INTO v_current_subscription_id, v_billing_period
  FROM subscriptions s JOIN subscription_plans sp ON sp.id = s.plan_id
  WHERE s.customer_id = v_customer_id AND s.status = 'trial' LIMIT 1;
  IF v_current_subscription_id IS NULL THEN
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
  END IF;
  SELECT id INTO v_new_plan_id FROM subscription_plans
  WHERE max_persons = v_total_persons AND billing_period = v_billing_period
    AND name NOT LIKE '%Business%' LIMIT 1;
  IF v_new_plan_id IS NOT NULL THEN
    UPDATE subscriptions SET plan_id = v_new_plan_id, updated_at = now()
    WHERE id = v_current_subscription_id;
  END IF;
  IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END; $$;

-- ============================================================
-- PROCESS REFERRAL
-- ============================================================

CREATE OR REPLACE FUNCTION process_referral(p_new_user_id uuid, p_referrer_nickname text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_referrer_id uuid;
BEGIN
  SELECT id INTO v_referrer_id FROM profiles WHERE nickname = p_referrer_nickname LIMIT 1;
  IF v_referrer_id IS NOT NULL THEN
    UPDATE profiles SET referred_by_nickname = p_referrer_nickname WHERE id = p_new_user_id;
    UPDATE profiles SET referral_count = COALESCE(referral_count, 0) + 1 WHERE id = v_referrer_id;
    PERFORM award_points(v_referrer_id, 30, 'referral',
      'Nuovo amico registrato: ' || (SELECT nickname FROM profiles WHERE id = p_new_user_id));
  END IF;
END; $$;

-- ============================================================
-- SEARCH FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION search_businesses_with_priority(
  search_term text DEFAULT NULL,
  p_category_id uuid DEFAULT NULL,
  p_region text DEFAULT NULL,
  p_province text DEFAULT NULL,
  p_city text DEFAULT NULL,
  p_limit integer DEFAULT 50,
  p_offset integer DEFAULT 0
)
RETURNS TABLE(id uuid, business_id uuid, name text, category_id uuid, address text,
  city text, province text, region text, latitude numeric, longitude numeric,
  phone text, email text, website text, business_hours jsonb, avatar_url text,
  is_claimed boolean, claimed_at timestamptz, verification_badge text,
  rating numeric, review_count bigint)
LANGUAGE plpgsql STABLE AS $$
BEGIN
  RETURN QUERY
  SELECT bl.id, bl.business_id, bl.name, bl.category_id, bl.address, bl.city,
    bl.province, bl.region, bl.latitude, bl.longitude, bl.phone, bl.email,
    bl.website, bl.business_hours, bl.avatar_url, bl.is_claimed, bl.claimed_at,
    bl.verification_badge,
    COALESCE((SELECT AVG(r.overall_rating)::numeric(3,2) FROM reviews r
      WHERE r.business_location_id = bl.id AND r.approved = true), 0),
    COALESCE((SELECT COUNT(*) FROM reviews r
      WHERE r.business_location_id = bl.id AND r.approved = true), 0)
  FROM business_locations bl
  WHERE (search_term IS NULL OR bl.name ILIKE '%' || search_term || '%')
    AND (p_category_id IS NULL OR bl.category_id = p_category_id)
    AND (p_region IS NULL OR bl.region = p_region)
    AND (p_province IS NULL OR bl.province = p_province)
    AND (p_city IS NULL OR bl.city = p_city)
  ORDER BY bl.is_claimed DESC,
    CASE WHEN bl.verification_badge = 'premium' THEN 3
         WHEN bl.verification_badge = 'verified' THEN 2
         WHEN bl.verification_badge = 'claimed' THEN 1 ELSE 0 END DESC,
    bl.name ASC
  LIMIT p_limit OFFSET p_offset;
END; $$;
