/*
  # Fix award_points and approve_classified_ad for NULL family_member_id

  ## Problem
  PostgreSQL treats NULL as unknown in unique constraints. The constraint
  `UNIQUE (user_id, family_member_id)` does not match ON CONFLICT when
  family_member_id is NULL. A separate partial unique index
  `user_activity_user_id_null_family_unique` exists for the NULL case,
  but ON CONFLICT (user_id, family_member_id) cannot target it.

  This causes HTTP 409 errors when approving classified ads (or awarding
  points) for users whose family_member_id is NULL.

  ## Fix
  1. Rewrite `award_points` to use explicit UPDATE-or-INSERT logic instead
     of ON CONFLICT, handling both NULL and non-NULL family_member_id correctly.
  2. Rewrite `approve_classified_ad` similarly for its direct user_activity insert.
*/

-- 1. Fix award_points function
CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT '',
  p_family_member_id uuid DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_new_total integer;
  v_exists boolean;
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (
        p_user_id,
        p_family_member_id,
        p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now()
      );
    END IF;

    SELECT total_points INTO v_new_total
    FROM user_activity
    WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = p_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (
        p_user_id,
        NULL,
        p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now()
      );
    END IF;

    SELECT total_points INTO v_new_total
    FROM user_activity
    WHERE user_id = p_user_id AND family_member_id IS NULL;
  END IF;

  RETURN v_new_total;
END;
$$;

-- 2. Fix approve_classified_ad function
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

  -- Award points
  PERFORM award_points(
    ad_record.user_id,
    points_to_award,
    'classified_ad',
    'Annuncio approvato',
    ad_record.family_member_id
  );

  -- Increment ads_posted_count using explicit UPDATE-or-INSERT
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

  -- Log the activity
  INSERT INTO activity_log (user_id, family_member_id, action, details)
  VALUES (
    staff_id_param,
    NULL,
    'classified_ad_approved',
    jsonb_build_object(
      'ad_id', ad_id_param,
      'ad_title', ad_record.title,
      'points_awarded', points_to_award,
      'family_member_id', ad_record.family_member_id
    )
  );
END;
$$;

-- 3. Fix other trigger functions that use ON CONFLICT with potential NULL family_member_id

CREATE OR REPLACE FUNCTION increment_ads_posted_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF NEW.family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.user_id AND family_member_id = NEW.family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.user_id AND family_member_id = NEW.family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.user_id, NEW.family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.user_id, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION increment_user_added_business_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF NEW.added_by_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.added_by AND family_member_id = NEW.added_by_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        businesses_added_count = businesses_added_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.added_by AND family_member_id = NEW.added_by_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.added_by, NEW.added_by_family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.added_by AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        businesses_added_count = businesses_added_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.added_by AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.added_by, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;
