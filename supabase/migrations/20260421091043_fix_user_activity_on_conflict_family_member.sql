/*
  # Fix user_activity ON CONFLICT clauses for family member support

  ## Problem
  Multiple trigger/utility functions reference `ON CONFLICT (user_id)` on the
  `user_activity` table, but the unique constraint is now
  `(user_id, family_member_id)`. This causes ERROR 42P10 on any insert that
  fires these triggers.

  ## Affected functions
  1. `increment_ads_posted_count` - triggered on classified_ads insert
  2. `increment_user_added_business_count` - triggered on unclaimed_business insert
  3. `sync_user_activity` - bulk sync utility
  4. `populate_user_activity` - bulk populate utility

  ## Fix
  Update all four functions to use `ON CONFLICT (user_id, family_member_id)`.
  For trigger functions that have access to `family_member_id` via NEW, pass it through.
*/

-- 1. Fix increment_ads_posted_count (classified_ads has family_member_id)
CREATE OR REPLACE FUNCTION increment_ads_posted_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
  VALUES (NEW.user_id, NEW.family_member_id, 1, now(), now(), now())
  ON CONFLICT (user_id, family_member_id)
  DO UPDATE SET
    ads_posted_count = user_activity.ads_posted_count + 1,
    last_activity_at = now(),
    updated_at = now();

  RETURN NEW;
END;
$$;

-- 2. Fix increment_user_added_business_count (unclaimed_business_locations has added_by_family_member_id)
CREATE OR REPLACE FUNCTION increment_user_added_business_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
  VALUES (NEW.added_by, NEW.added_by_family_member_id, 1, now(), now(), now())
  ON CONFLICT (user_id, family_member_id)
  DO UPDATE SET
    businesses_added_count = user_activity.businesses_added_count + 1,
    last_activity_at = now(),
    updated_at = now();

  RETURN NEW;
END;
$$;

-- 3. Fix sync_user_activity
CREATE OR REPLACE FUNCTION sync_user_activity()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, updated_at)
  SELECT
    p.id as user_id,
    NULL as family_member_id,
    COALESCE(SUM(CASE
      WHEN r.proof_image_url IS NOT NULL THEN 50
      ELSE 25
    END), 0) as total_points,
    COUNT(r.id) as reviews_count,
    NOW() as last_activity_at,
    NOW() as updated_at
  FROM profiles p
  LEFT JOIN reviews r ON r.customer_id = p.id
    AND r.family_member_id IS NULL
    AND r.review_status = 'approved'
  WHERE p.user_type = 'customer'
  GROUP BY p.id
  ON CONFLICT (user_id, family_member_id)
  DO UPDATE SET
    total_points = EXCLUDED.total_points,
    reviews_count = EXCLUDED.reviews_count,
    updated_at = NOW();
END;
$$;

-- 4. Fix populate_user_activity
CREATE OR REPLACE FUNCTION populate_user_activity()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_record RECORD;
  reviews_cnt INTEGER;
  ads_cnt INTEGER;
  jobs_cnt INTEGER;
  referrals_cnt INTEGER;
  points INTEGER;
BEGIN
  FOR user_record IN
    SELECT id, referral_count FROM profiles WHERE user_type IN ('customer', 'business')
  LOOP
    SELECT COUNT(*) INTO reviews_cnt
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    SELECT COUNT(*) INTO ads_cnt
    FROM classified_ads
    WHERE user_id = user_record.id AND status = 'active';

    SELECT COUNT(*) INTO jobs_cnt
    FROM job_seekers
    WHERE user_id = user_record.id AND status = 'active';

    referrals_cnt := COALESCE(user_record.referral_count, 0);

    SELECT
      COALESCE(SUM(
        CASE
          WHEN proof_image_url IS NOT NULL THEN 50
          ELSE 25
        END
      ), 0) INTO points
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    points := points + (ads_cnt * 10);
    points := points + (referrals_cnt * 100);

    INSERT INTO user_activity (
      user_id,
      family_member_id,
      total_points,
      reviews_count,
      ads_count,
      job_postings_count,
      referrals_count,
      last_activity_at,
      updated_at
    )
    VALUES (
      user_record.id,
      NULL,
      points,
      reviews_cnt,
      ads_cnt,
      jobs_cnt,
      referrals_cnt,
      now(),
      now()
    )
    ON CONFLICT (user_id, family_member_id) DO UPDATE SET
      total_points = EXCLUDED.total_points,
      reviews_count = EXCLUDED.reviews_count,
      ads_count = EXCLUDED.ads_count,
      job_postings_count = EXCLUDED.job_postings_count,
      referrals_count = EXCLUDED.referrals_count,
      last_activity_at = now(),
      updated_at = now();
  END LOOP;
END;
$$;
