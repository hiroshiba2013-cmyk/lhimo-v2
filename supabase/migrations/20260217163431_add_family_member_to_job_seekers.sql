/*
  # Add Family Member Support to Job Seekers

  1. Changes
    - Add family_member_id column to job_seekers table
    - Add foreign key constraint to customer_family_members
    - Create index for performance

  2. Security
    - No RLS changes needed, inherits existing policies
*/

-- Add family_member_id to job_seekers
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_job_seekers_family_member_id ON job_seekers(family_member_id);
  END IF;
END $$;
