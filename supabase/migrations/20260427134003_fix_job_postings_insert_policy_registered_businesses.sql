/*
  # Fix job_postings INSERT policy to support registered_businesses

  ## Problem
  The current INSERT policy for job_postings only checks the old `businesses` table.
  Users who registered via the new system have their business in `registered_businesses`,
  causing a 403 error when trying to create a job posting.

  ## Changes
  - Drop and recreate the INSERT policy to check both `businesses` and `registered_businesses`
*/

DROP POLICY IF EXISTS "Businesses can create job postings" ON job_postings;

CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = auth.uid()
    )
    OR
    business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = auth.uid()
    )
  );
