/*
  # Support for Unclaimed Businesses

  1. Changes
    - Make owner_id nullable in businesses table
    - Add is_claimed boolean field to track claimed status
    - Update RLS policies to allow public viewing of verified businesses
    - Keep existing policies for business owners to manage their claimed businesses

  2. Security
    - Public can view all verified businesses (claimed or unclaimed)
    - Only authenticated business users can claim unclaimed businesses
    - Only owners can update their claimed businesses
*/

-- Make owner_id nullable to support unclaimed businesses
ALTER TABLE businesses ALTER COLUMN owner_id DROP NOT NULL;

-- Add is_claimed field to track if business has been claimed by an owner
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE businesses ADD COLUMN is_claimed BOOLEAN DEFAULT false;
  END IF;
END $$;

-- Update existing businesses with owners as claimed
UPDATE businesses SET is_claimed = true WHERE owner_id IS NOT NULL;

-- Update RLS policies for businesses table
DROP POLICY IF EXISTS "Public can view verified businesses" ON businesses;
DROP POLICY IF EXISTS "Business owners can view own businesses" ON businesses;
DROP POLICY IF EXISTS "Business owners can insert own businesses" ON businesses;
DROP POLICY IF EXISTS "Business owners can update own businesses" ON businesses;

-- Allow public to view all verified businesses (claimed or unclaimed)
CREATE POLICY "Public can view verified businesses"
  ON businesses FOR SELECT
  TO public
  USING (verified = true);

-- Allow authenticated users to view their own businesses and unclaimed businesses
CREATE POLICY "Business owners can view own and unclaimed businesses"
  ON businesses FOR SELECT
  TO authenticated
  USING (
    owner_id = auth.uid() OR 
    (verified = true) OR 
    (owner_id IS NULL)
  );

-- Allow business owners to claim unclaimed businesses
CREATE POLICY "Business owners can claim unclaimed businesses"
  ON businesses FOR UPDATE
  TO authenticated
  USING (
    (owner_id IS NULL AND is_claimed = false) OR
    (owner_id = auth.uid())
  )
  WITH CHECK (
    (owner_id = auth.uid())
  );

-- Allow business owners to insert new businesses
CREATE POLICY "Business owners can insert own businesses"
  ON businesses FOR INSERT
  TO authenticated
  WITH CHECK (
    owner_id = auth.uid() OR owner_id IS NULL
  );

-- Allow business owners to delete only their own businesses
CREATE POLICY "Business owners can delete own businesses"
  ON businesses FOR DELETE
  TO authenticated
  USING (owner_id = auth.uid());