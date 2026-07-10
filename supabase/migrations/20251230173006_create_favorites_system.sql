/*
  # Create Favorites System

  1. New Tables
    - `favorite_businesses`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `business_id` (uuid, references business_locations)
      - `created_at` (timestamptz)
      - Unique constraint on (user_id, family_member_id, business_id)
    
    - `favorite_classified_ads`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `ad_id` (uuid, references classified_ads)
      - `created_at` (timestamptz)
      - Unique constraint on (user_id, family_member_id, ad_id)
    
    - `favorite_job_postings`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `job_id` (uuid, references job_postings)
      - `created_at` (timestamptz)
      - Unique constraint on (user_id, family_member_id, job_id)

  2. Security
    - Enable RLS on all tables
    - Users can manage their own favorites
    - Users can view favorites count for businesses/ads/jobs

  3. Important Notes
    - Each user can favorite the same item once (as themselves)
    - Each family member can favorite the same item once (separately from main user)
    - The combination of user_id + family_member_id + item_id must be unique
*/

-- Create favorite_businesses table
CREATE TABLE IF NOT EXISTS favorite_businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  business_id uuid NOT NULL REFERENCES business_locations(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create unique constraint that treats NULL family_member_id properly
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_business_user 
  ON favorite_businesses(user_id, business_id) 
  WHERE family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_business_family 
  ON favorite_businesses(user_id, family_member_id, business_id) 
  WHERE family_member_id IS NOT NULL;

-- Create favorite_classified_ads table
CREATE TABLE IF NOT EXISTS favorite_classified_ads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  ad_id uuid NOT NULL REFERENCES classified_ads(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create unique constraint for ads
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_ad_user 
  ON favorite_classified_ads(user_id, ad_id) 
  WHERE family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_ad_family 
  ON favorite_classified_ads(user_id, family_member_id, ad_id) 
  WHERE family_member_id IS NOT NULL;

-- Create favorite_job_postings table
CREATE TABLE IF NOT EXISTS favorite_job_postings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  job_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create unique constraint for jobs
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_job_user 
  ON favorite_job_postings(user_id, job_id) 
  WHERE family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_job_family 
  ON favorite_job_postings(user_id, family_member_id, job_id) 
  WHERE family_member_id IS NOT NULL;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_user ON favorite_businesses(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_family ON favorite_businesses(family_member_id);
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_business ON favorite_businesses(business_id);

CREATE INDEX IF NOT EXISTS idx_favorite_ads_user ON favorite_classified_ads(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_ads_family ON favorite_classified_ads(family_member_id);
CREATE INDEX IF NOT EXISTS idx_favorite_ads_ad ON favorite_classified_ads(ad_id);

CREATE INDEX IF NOT EXISTS idx_favorite_jobs_user ON favorite_job_postings(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_jobs_family ON favorite_job_postings(family_member_id);
CREATE INDEX IF NOT EXISTS idx_favorite_jobs_job ON favorite_job_postings(job_id);

-- Enable RLS
ALTER TABLE favorite_businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_classified_ads ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_job_postings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for favorite_businesses

CREATE POLICY "Users can view their own favorite businesses"
  ON favorite_businesses FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorite businesses"
  ON favorite_businesses FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id 
    AND (
      family_member_id IS NULL 
      OR EXISTS (
        SELECT 1 FROM customer_family_members 
        WHERE id = family_member_id 
        AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can remove their own favorite businesses"
  ON favorite_businesses FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies for favorite_classified_ads

CREATE POLICY "Users can view their own favorite ads"
  ON favorite_classified_ads FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorite ads"
  ON favorite_classified_ads FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id 
    AND (
      family_member_id IS NULL 
      OR EXISTS (
        SELECT 1 FROM customer_family_members 
        WHERE id = family_member_id 
        AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can remove their own favorite ads"
  ON favorite_classified_ads FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies for favorite_job_postings

CREATE POLICY "Users can view their own favorite jobs"
  ON favorite_job_postings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorite jobs"
  ON favorite_job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id 
    AND (
      family_member_id IS NULL 
      OR EXISTS (
        SELECT 1 FROM customer_family_members 
        WHERE id = family_member_id 
        AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can remove their own favorite jobs"
  ON favorite_job_postings FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
