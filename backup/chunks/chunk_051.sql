-- ============================================================
-- FILE: 20260421090937_fix_award_points_ambiguous_function.sql
-- ============================================================
/*
  # Fix ambiguous award_points function

  ## Problem
  There are two versions of `award_points` with overlapping signatures:
  1. `award_points(uuid, integer, text, text DEFAULT NULL)` - old version without family member support
  2. `award_points(uuid, integer, text, text DEFAULT '', uuid DEFAULT NULL)` - new version with family member support

  When triggers call `award_points(uuid, integer, text, text)` with 4 arguments,
  Postgres cannot determine which function to use, causing ERROR 42725.

  This breaks classified_ads inserts (and any other trigger using award_points).

  ## Fix
  Drop the old function signature so only the new complete version remains.
*/

-- Drop the old version (without family_member_id parameter)
DROP FUNCTION IF EXISTS award_points(uuid, integer, text, text);


-- ============================================================
-- FILE: 20260421091043_fix_user_activity_on_conflict_family_member.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260421094304_fix_user_activity_duplicates_and_unique_constraint.sql
-- ============================================================
/*
  # Fix duplicate user_activity rows and add proper unique constraint

  ## Problem
  The unique constraint on `(user_id, family_member_id)` does not prevent
  duplicate rows when `family_member_id IS NULL`, because in SQL NULL != NULL.
  This causes `maybeSingle()` queries to fail and leaderboard data to not load.

  ## Fix
  1. Consolidate duplicate rows by summing up points and counts, keeping one row per user
  2. Add a unique index on `user_id` WHERE `family_member_id IS NULL` to prevent future duplicates
  3. Update the `award_points` function to use the correct ON CONFLICT target
*/

-- Step 1: Consolidate duplicates for rows where family_member_id IS NULL
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT user_id
    FROM user_activity
    WHERE family_member_id IS NULL
    GROUP BY user_id
    HAVING COUNT(*) > 1
  LOOP
    -- Sum up all the values into one row
    WITH agg AS (
      SELECT
        user_id,
        SUM(total_points) as total_points,
        SUM(reviews_count) as reviews_count,
        SUM(photos_count) as photos_count,
        SUM(businesses_added_count) as businesses_added_count,
        SUM(ads_posted_count) as ads_posted_count,
        SUM(COALESCE(ads_count, 0)) as ads_count,
        SUM(COALESCE(job_postings_count, 0)) as job_postings_count,
        SUM(COALESCE(referrals_count, 0)) as referrals_count,
        MAX(last_activity_at) as last_activity_at,
        MIN(created_at) as created_at
      FROM user_activity
      WHERE user_id = r.user_id AND family_member_id IS NULL
      GROUP BY user_id
    ),
    keep_one AS (
      SELECT ctid FROM user_activity
      WHERE user_id = r.user_id AND family_member_id IS NULL
      ORDER BY created_at ASC
      LIMIT 1
    )
    UPDATE user_activity
    SET
      total_points = agg.total_points,
      reviews_count = agg.reviews_count,
      photos_count = agg.photos_count,
      businesses_added_count = agg.businesses_added_count,
      ads_posted_count = agg.ads_posted_count,
      ads_count = agg.ads_count,
      job_postings_count = agg.job_postings_count,
      referrals_count = agg.referrals_count,
      last_activity_at = agg.last_activity_at,
      updated_at = now()
    FROM agg
    WHERE user_activity.ctid = (SELECT ctid FROM keep_one)
      AND user_activity.user_id = r.user_id;

    -- Delete all other duplicate rows
    DELETE FROM user_activity
    WHERE user_id = r.user_id
      AND family_member_id IS NULL
      AND ctid NOT IN (
        SELECT ctid FROM user_activity
        WHERE user_id = r.user_id AND family_member_id IS NULL
        ORDER BY created_at ASC
        LIMIT 1
      );
  END LOOP;
END $$;

-- Step 2: Create a unique partial index to prevent future duplicates
-- when family_member_id IS NULL
CREATE UNIQUE INDEX IF NOT EXISTS user_activity_user_id_null_family_unique
  ON user_activity (user_id)
  WHERE family_member_id IS NULL;


-- ============================================================
-- FILE: 20260421095511_add_classified_ads_approval_system_v2.sql
-- ============================================================
/*
  # Add approval system for classified ads

  Similar to the review approval system, classified ads now require admin
  approval before being visible and before points are awarded.

  ## Changes
  1. Add 'pending' to the status check constraint
  2. Add approval columns to `classified_ads`:
     - `approval_status` (text): 'pending', 'approved', 'rejected'
     - `approved_by` (uuid): admin who approved
     - `approved_at` (timestamptz): when approved
     - `points_awarded` (integer): points given after approval
  3. Set all existing active ads to 'approved' (grandfathered in)
  4. New ads default to 'pending' status
  5. Remove the automatic points trigger on INSERT
  6. Create `approve_classified_ad` and `reject_classified_ad` functions
  7. Update RLS: only approved+active ads visible publicly
  8. Fix Stefmanc's points to reflect actual approved activities
*/

-- Step 1: Update status check to include 'pending'
ALTER TABLE classified_ads DROP CONSTRAINT IF EXISTS classified_ads_status_check;
ALTER TABLE classified_ads ADD CONSTRAINT classified_ads_status_check
  CHECK (status IN ('pending', 'active', 'sold', 'expired', 'deleted'));

-- Step 2: Add approval columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN approval_status text DEFAULT 'pending'
      CHECK (approval_status IN ('pending', 'approved', 'rejected'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'approved_by'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN approved_by uuid REFERENCES profiles(id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'approved_at'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN approved_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'points_awarded'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN points_awarded integer DEFAULT 0;
  END IF;
END $$;

-- Step 3: Grandfather existing active ads as approved
UPDATE classified_ads
SET approval_status = 'approved', approved_at = created_at
WHERE status = 'active' AND approval_status = 'pending';

-- Step 4: Remove the automatic points trigger on INSERT
DROP TRIGGER IF EXISTS trigger_award_points_classified_ad ON classified_ads;

-- Step 5: New ads default to 'pending' status
ALTER TABLE classified_ads ALTER COLUMN status SET DEFAULT 'pending';

-- Step 6: Create approve_classified_ad function
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

  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
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

-- Step 7: Create reject_classified_ad function
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

  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'classified_ad_rejected',
    jsonb_build_object(
      'ad_id', ad_id_param,
      'ad_title', ad_record.title,
      'family_member_id', ad_record.family_member_id
    )
  );
END;
$$;

-- Step 8: Update RLS - public can only see approved+active ads
DROP POLICY IF EXISTS "Anyone can view active ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can view active classified ads" ON classified_ads;

CREATE POLICY "Anyone can view approved active ads"
  ON classified_ads FOR SELECT
  USING (status = 'active' AND approval_status = 'approved');

-- Step 9: Set Stefmanc's unapproved ad to pending
UPDATE classified_ads
SET status = 'pending', approval_status = 'pending'
WHERE id = '11e72704-13df-4551-ace9-f9f40a6e159d';

-- Step 10: Fix Stefmanc's main user points
-- Actual approved activities: 1 business approved = 25 pts, 0 ads approved = 0 pts
-- Total should be 25, not 30
UPDATE user_activity
SET total_points = 25,
    ads_posted_count = 0,
    updated_at = now()
WHERE user_id = '4ed5c590-7e6c-42f1-925b-2161dc7ad2be'
  AND family_member_id IS NULL;


-- ============================================================
-- FILE: 20260421095822_fix_ads_posted_count_on_approval_only.sql
-- ============================================================
/*
  # Fix ads posted count to only increment on approval

  ## Changes
  1. Remove the INSERT trigger that increments ads_posted_count immediately
  2. The approve_classified_ad function now handles counting via award_points
  3. Update approve function to also increment ads_posted_count

  ## Notes
  - ads_posted_count should reflect only approved ads
  - Points are already handled by the approve function
*/

-- Remove the old INSERT trigger
DROP TRIGGER IF EXISTS trigger_increment_ads_posted_count ON classified_ads;

-- Update approve function to also increment ads_posted_count
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

  -- Increment ads_posted_count
  INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at)
  VALUES (ad_record.user_id, ad_record.family_member_id, 1, now())
  ON CONFLICT (user_id, family_member_id)
  DO UPDATE SET
    ads_posted_count = user_activity.ads_posted_count + 1,
    last_activity_at = now(),
    updated_at = now();

  -- Log the activity
  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
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


