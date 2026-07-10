/*
  # Allow reviews for unclaimed businesses

  1. Changes
    - Make `business_id` in reviews nullable
    - Add `unclaimed_business_id` field to reviews table
    - Add constraint to ensure exactly one of business_id or unclaimed_business_id is set
    - Update RLS policies to handle both business types

  2. Security
    - Maintain existing RLS policies
    - Ensure users can review both claimed and unclaimed businesses
*/

-- Make business_id nullable and add unclaimed_business_id
ALTER TABLE reviews
  ALTER COLUMN business_id DROP NOT NULL;

-- Add unclaimed_business_id column
ALTER TABLE reviews
  ADD COLUMN IF NOT EXISTS unclaimed_business_id uuid REFERENCES unclaimed_business_locations(id) ON DELETE CASCADE;

-- Add constraint to ensure exactly one of business_id or unclaimed_business_id is set
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_business_xor'
  ) THEN
    ALTER TABLE reviews
      ADD CONSTRAINT reviews_business_xor
      CHECK (
        (business_id IS NOT NULL AND unclaimed_business_id IS NULL) OR
        (business_id IS NULL AND unclaimed_business_id IS NOT NULL)
      );
  END IF;
END $$;

-- Drop old policies
DROP POLICY IF EXISTS "Anyone can view reviews" ON reviews;
DROP POLICY IF EXISTS "Customers can create reviews" ON reviews;

-- Recreate policies to handle both business types
CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Customers can create reviews for businesses"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid() AND
    business_id IS NOT NULL AND
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND user_type = 'customer'
      AND (subscription_status = 'active' OR subscription_status = 'trial')
    )
  );

CREATE POLICY "Customers can create reviews for unclaimed businesses"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid() AND
    unclaimed_business_id IS NOT NULL AND
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND user_type = 'customer'
      AND (subscription_status = 'active' OR subscription_status = 'trial')
    )
  );

-- Create index for unclaimed_business_id
CREATE INDEX IF NOT EXISTS idx_reviews_unclaimed_business_id ON reviews(unclaimed_business_id);
