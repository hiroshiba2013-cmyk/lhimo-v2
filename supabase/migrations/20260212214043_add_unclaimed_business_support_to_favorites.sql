/*
  # Add Unclaimed Business Support to Favorites

  1. Changes
    - Add `unclaimed_business_location_id` column to `favorite_businesses`
    - Make `business_id` nullable
    - Add CHECK constraint to ensure only one ID is populated
    - Update RLS policies to support both types

  2. Security
    - Maintain existing RLS policies
    - Users can only manage their own favorites
*/

-- Add support for unclaimed businesses in favorites
ALTER TABLE favorite_businesses
  ALTER COLUMN business_id DROP NOT NULL,
  ADD COLUMN IF NOT EXISTS unclaimed_business_location_id uuid REFERENCES unclaimed_business_locations(id) ON DELETE CASCADE;

-- Add constraint to ensure only one business type is specified
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'favorite_businesses_one_business_type'
  ) THEN
    ALTER TABLE favorite_businesses
    ADD CONSTRAINT favorite_businesses_one_business_type
    CHECK (
      (business_id IS NOT NULL AND unclaimed_business_location_id IS NULL) OR
      (business_id IS NULL AND unclaimed_business_location_id IS NOT NULL)
    );
  END IF;
END $$;

-- Create index for unclaimed business favorites
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_unclaimed_location
  ON favorite_businesses(unclaimed_business_location_id);

-- Update INSERT policy to check WITH CHECK properly
DROP POLICY IF EXISTS "Users can add their own favorite businesses" ON favorite_businesses;
CREATE POLICY "Users can add their own favorite businesses"
  ON favorite_businesses
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);
