/*
  # Add Family Member Support to Job Requests

  ## Overview
  This migration adds support for family members to create their own job requests
  separately from the main account holder.

  ## Changes

  ### Modified Tables
  - `job_requests`
    - Add `family_member_id` (uuid, nullable) - Foreign key to customer_family_members
    - This allows both the main account holder and family members to create job requests
    - When NULL, the job request belongs to the main account holder
    - When set, the job request belongs to the specified family member

  ## Security
  - Update RLS policies to allow family members' job requests to be managed
  - Maintain existing security for customer-owned requests

  ## Notes
  - Existing job requests will have NULL family_member_id (belonging to main account holder)
  - New job requests can optionally specify a family_member_id
*/

-- Add family_member_id to job_requests table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_requests' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE job_requests 
    ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_job_requests_family_member_id 
ON job_requests(family_member_id);

-- Update policies to support family member job requests

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own job requests" ON job_requests;
DROP POLICY IF EXISTS "Customers can create job requests" ON job_requests;
DROP POLICY IF EXISTS "Users can update own job requests" ON job_requests;
DROP POLICY IF EXISTS "Users can delete own job requests" ON job_requests;

-- Policy: Authenticated users can view their own job requests (including family members)
CREATE POLICY "Users can view own job requests"
  ON job_requests
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() = customer_id
  );

-- Policy: Authenticated customers can create job requests for themselves or their family members
CREATE POLICY "Customers can create job requests"
  ON job_requests
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = customer_id
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.user_type = 'customer'
    )
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- Policy: Users can update their own job requests (including family members)
CREATE POLICY "Users can update own job requests"
  ON job_requests
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id)
  WITH CHECK (
    auth.uid() = customer_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- Policy: Users can delete their own job requests (including family members)
CREATE POLICY "Users can delete own job requests"
  ON job_requests
  FOR DELETE
  TO authenticated
  USING (auth.uid() = customer_id);