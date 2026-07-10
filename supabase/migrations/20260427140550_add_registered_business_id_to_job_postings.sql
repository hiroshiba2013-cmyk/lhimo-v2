/*
  # Add registered_business_id to job_postings

  ## Problem
  The job_postings table has business_id FK pointing only to the old `businesses` table.
  Users registered via the new system (registered_businesses) get a 409 FK violation error.

  ## Changes
  - Add `registered_business_id` column with FK to registered_businesses
  - Make `business_id` nullable (to allow postings from registered_businesses only)
  - Update RLS INSERT policy to allow both business types
  - Update SELECT policy for owners to include registered_business_id
*/

-- Make business_id nullable
ALTER TABLE job_postings ALTER COLUMN business_id DROP NOT NULL;

-- Add registered_business_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'registered_business_id'
  ) THEN
    ALTER TABLE job_postings
      ADD COLUMN registered_business_id uuid REFERENCES registered_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Update INSERT policy
DROP POLICY IF EXISTS "Businesses can create job postings" ON job_postings;

CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    (business_id IS NOT NULL AND business_id IN (
      SELECT id FROM businesses WHERE owner_id = auth.uid()
    ))
    OR
    (registered_business_id IS NOT NULL AND registered_business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = auth.uid()
    ))
  );

-- Update SELECT policy for owners
DROP POLICY IF EXISTS "Businesses can view their own postings" ON job_postings;

CREATE POLICY "Businesses can view their own postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  );

-- Update UPDATE policy
DROP POLICY IF EXISTS "Businesses can update their own postings" ON job_postings;

CREATE POLICY "Businesses can update their own postings"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  )
  WITH CHECK (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  );

-- Update DELETE policy
DROP POLICY IF EXISTS "Businesses can delete their own postings" ON job_postings;

CREATE POLICY "Businesses can delete their own postings"
  ON job_postings FOR DELETE
  TO authenticated
  USING (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  );
