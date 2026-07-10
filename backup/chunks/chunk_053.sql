-- ============================================================
-- FILE: 20260421141350_fix_featured_ads_duplicate_from_user_activity_join.sql
-- ============================================================
/*
  # Fix featured ads duplicates from user_activity JOIN

  ## Problem
  The `get_featured_classified_ads` function joins `user_activity` on
  `user_id` only. When a user has multiple rows in `user_activity`
  (one per family member + one with NULL family_member_id), the JOIN
  produces duplicate rows for the same ad.

  ## Fix
  Filter the JOIN to only match the main user row (family_member_id IS NULL)
  so each ad appears exactly once.
*/

CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count integer DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  category_id uuid,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ca.id,
    ca.title,
    ca.description,
    ca.price,
    ca.ad_type::text,
    COALESCE(cat.name, '') as category,
    ca.category_id,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status::text,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id AND ua.family_member_id IS NULL
  LEFT JOIN classified_categories cat ON ca.category_id = cat.id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type::text = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;


-- ============================================================
-- FILE: 20260421142645_add_notifications_on_ad_approval_and_rejection.sql
-- ============================================================
/*
  # Add notifications when classified ads are approved or rejected

  1. Changes
    - `approve_classified_ad`: adds INSERT into notifications table
      so the ad owner gets notified their ad was approved
    - `reject_classified_ad`: fixes broken activity_log INSERT (was using
      wrong column names) and adds INSERT into notifications table
      so the ad owner gets notified their ad was rejected

  2. Notification details
    - Approval: type='classified_ad_approved', green positive message
    - Rejection: type='classified_ad_rejected', informative message
    - Both include family_member_id if the ad was posted by a family member
*/

-- Update approve function to include notification
CREATE OR REPLACE FUNCTION approve_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
  points_to_award integer := 5;
  v_exists boolean;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  UPDATE classified_ads
  SET approval_status = 'approved',
      status = 'active',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award
  WHERE id = ad_id_param;

  PERFORM award_points(
    ad_record.user_id,
    points_to_award,
    'classified_ad',
    'Annuncio approvato',
    ad_record.family_member_id
  );

  IF ad_record.family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (ad_record.user_id, ad_record.family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = ad_record.user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = ad_record.user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (ad_record.user_id, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato',
    points_to_award,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'approved_by', staff_id_param),
    'check-circle',
    'green'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato. Hai guadagnato ' || points_to_award || ' punti!',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title)
  );
END;
$$;

-- Update reject function to fix activity_log columns and add notification
CREATE OR REPLACE FUNCTION reject_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  UPDATE classified_ads
  SET approval_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = 0
  WHERE id = ad_id_param;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_rejected',
    'Annuncio Rifiutato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato rifiutato',
    0,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'rejected_by', staff_id_param),
    'x-circle',
    'red'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_rejected',
    'Annuncio Rifiutato',
    'Il tuo annuncio "' || ad_record.title || '" non e'' stato approvato. Verifica che rispetti le linee guida e riprova.',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title)
  );
END;
$$;


-- ============================================================
-- FILE: 20260421143310_fix_ad_notifications_only_to_account_owner.sql
-- ============================================================
/*
  # Fix ad notifications - send only to account owner

  ## Problem
  Notifications were being sent with family_member_id, but the user
  wants notifications to always go to the main account owner only,
  even if a family member posted the ad.

  ## Fix
  Set family_member_id to NULL in the notification INSERT for both
  approve and reject functions.
*/

CREATE OR REPLACE FUNCTION approve_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
  points_to_award integer := 5;
  v_exists boolean;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  UPDATE classified_ads
  SET approval_status = 'approved',
      status = 'active',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award
  WHERE id = ad_id_param;

  PERFORM award_points(
    ad_record.user_id,
    points_to_award,
    'classified_ad',
    'Annuncio approvato',
    ad_record.family_member_id
  );

  IF ad_record.family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (ad_record.user_id, ad_record.family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = ad_record.user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = ad_record.user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (ad_record.user_id, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato',
    points_to_award,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'approved_by', staff_id_param),
    'check-circle',
    'green'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    NULL,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato. Hai guadagnato ' || points_to_award || ' punti!',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title)
  );
END;
$$;

CREATE OR REPLACE FUNCTION reject_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  UPDATE classified_ads
  SET approval_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = 0
  WHERE id = ad_id_param;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_rejected',
    'Annuncio Rifiutato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato rifiutato',
    0,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'rejected_by', staff_id_param),
    'x-circle',
    'red'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    NULL,
    'classified_ad_rejected',
    'Annuncio Rifiutato',
    'Il tuo annuncio "' || ad_record.title || '" non e'' stato approvato. Verifica che rispetti le linee guida e riprova.',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title)
  );
END;
$$;


