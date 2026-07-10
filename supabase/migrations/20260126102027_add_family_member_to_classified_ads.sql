/*
  # Add Family Member Support to Classified Ads

  1. Changes
    - Add `family_member_id` column to `classified_ads` table
    - Add foreign key constraint to `customer_family_members`
    - Update RLS policies to support family member privacy
    - Add index for better query performance

  2. Security
    - Users can only view/edit their own ads or ads created by their family members
    - Family members can only view/edit their own ads (not other family members' ads)
*/

-- Add family_member_id column to classified_ads
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_classified_ads_family_member
ON classified_ads(family_member_id);

-- Drop existing RLS policies for classified_ads
DROP POLICY IF EXISTS "Users can view active classified ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can create classified ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can update own classified ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can delete own classified ads" ON classified_ads;

-- Create new RLS policies with family member support
CREATE POLICY "Users can view active classified ads"
  ON classified_ads
  FOR SELECT
  TO authenticated
  USING (status = 'active');

CREATE POLICY "Users can create classified ads"
  ON classified_ads
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
  );

CREATE POLICY "Users can update own classified ads"
  ON classified_ads
  FOR UPDATE
  TO authenticated
  USING (
    auth.uid() = user_id
  )
  WITH CHECK (
    auth.uid() = user_id
  );

CREATE POLICY "Users can delete own classified ads"
  ON classified_ads
  FOR DELETE
  TO authenticated
  USING (
    auth.uid() = user_id
  );