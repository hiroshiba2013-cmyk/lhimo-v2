/*
  # Add missing columns to user_activity table

  1. Changes
    - Add ads_count column to track classified ads
    - Add job_postings_count column to track job postings
    - Add referrals_count column to track referrals
    - Add function to populate existing user data
    - Add admin access policy for user_activity

  2. Notes
    - Populates data for existing users based on their activities
    - Creates indexes for performance
*/

-- Add missing columns to user_activity
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'ads_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN ads_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'job_postings_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN job_postings_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'referrals_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN referrals_count integer DEFAULT 0;
  END IF;
END $$;

-- Add admin policy for user_activity
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'user_activity' 
    AND policyname = 'Admins can view all user activity'
  ) THEN
    CREATE POLICY "Admins can view all user activity"
      ON user_activity FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admins
          WHERE admins.user_id = auth.uid()
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'user_activity' 
    AND policyname = 'Admins can update all user activity'
  ) THEN
    CREATE POLICY "Admins can update all user activity"
      ON user_activity FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admins
          WHERE admins.user_id = auth.uid()
        )
      )
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM admins
          WHERE admins.user_id = auth.uid()
        )
      );
  END IF;
END $$;

-- Function to populate user_activity for existing users
CREATE OR REPLACE FUNCTION populate_user_activity()
RETURNS void AS $$
DECLARE
  user_record RECORD;
  reviews_cnt INTEGER;
  ads_cnt INTEGER;
  jobs_cnt INTEGER;
  referrals_cnt INTEGER;
  points INTEGER;
BEGIN
  -- Iterate through all profiles
  FOR user_record IN
    SELECT id, referral_count FROM profiles WHERE user_type IN ('customer', 'business')
  LOOP
    -- Count reviews
    SELECT COUNT(*) INTO reviews_cnt
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    -- Count classified ads
    SELECT COUNT(*) INTO ads_cnt
    FROM classified_ads
    WHERE user_id = user_record.id AND status = 'active';

    -- Count job seekers
    SELECT COUNT(*) INTO jobs_cnt
    FROM job_seekers
    WHERE user_id = user_record.id AND status = 'active';

    -- Get referrals from profile
    referrals_cnt := COALESCE(user_record.referral_count, 0);

    -- Calculate points:
    -- Reviews with proof = 50 points
    -- Reviews without proof = 25 points
    -- Classified ads = 10 points
    -- Referrals = 100 points (from referral_count in profiles)
    SELECT
      COALESCE(SUM(
        CASE
          WHEN proof_image_url IS NOT NULL THEN 50
          ELSE 25
        END
      ), 0) INTO points
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    -- Add points for ads
    points := points + (ads_cnt * 10);

    -- Add points for referrals
    points := points + (referrals_cnt * 100);

    -- Insert or update user_activity
    INSERT INTO user_activity (
      user_id,
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
      points,
      reviews_cnt,
      ads_cnt,
      jobs_cnt,
      referrals_cnt,
      now(),
      now()
    )
    ON CONFLICT (user_id) DO UPDATE SET
      total_points = EXCLUDED.total_points,
      reviews_count = EXCLUDED.reviews_count,
      ads_count = EXCLUDED.ads_count,
      job_postings_count = EXCLUDED.job_postings_count,
      referrals_count = EXCLUDED.referrals_count,
      last_activity_at = now(),
      updated_at = now();
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Execute the population function
SELECT populate_user_activity();

-- Create indexes for new columns
CREATE INDEX IF NOT EXISTS idx_user_activity_ads ON user_activity(ads_count DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_jobs ON user_activity(job_postings_count DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_referrals ON user_activity(referrals_count DESC);
