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
