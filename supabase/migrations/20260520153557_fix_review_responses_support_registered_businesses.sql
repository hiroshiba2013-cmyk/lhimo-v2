/*
  # Fix review_responses to support registered businesses

  The current INSERT policy only allows owners of legacy `businesses` table entries
  to respond to reviews. This migration:

  1. Makes `business_id` nullable (registered business owners have no entry there)
  2. Adds `business_owner_id` column to track who responded
  3. Drops the old restrictive INSERT policy
  4. Adds a new INSERT policy that allows:
     - Owners of legacy businesses (via businesses table)
     - Owners of registered businesses (via registered_businesses table)
     - Any authenticated user who is the business owner (via business_owner_id match)
*/

-- Make business_id nullable
DO $$
BEGIN
  ALTER TABLE review_responses ALTER COLUMN business_id DROP NOT NULL;
EXCEPTION WHEN others THEN NULL;
END $$;

-- Add business_owner_id column if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'review_responses' AND column_name = 'business_owner_id'
  ) THEN
    ALTER TABLE review_responses ADD COLUMN business_owner_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Drop old INSERT policy
DROP POLICY IF EXISTS "Business owners can respond to reviews" ON review_responses;

-- New INSERT policy: allows legacy business owners AND registered business owners
CREATE POLICY "Business owners can respond to reviews"
  ON review_responses
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = business_owner_id
    AND (
      -- legacy businesses owner
      business_id IN (
        SELECT id FROM businesses WHERE owner_id = auth.uid()
      )
      OR
      -- registered businesses owner
      EXISTS (
        SELECT 1 FROM registered_businesses rb
        JOIN registered_business_locations rbl ON rbl.business_id = rb.id
        JOIN reviews r ON r.registered_business_location_id = rbl.id
        WHERE rb.owner_id = auth.uid()
          AND r.id = review_responses.review_id
      )
      OR
      -- business_id is null (registered business path)
      business_id IS NULL
    )
  );
