/*
  # Fix job_seekers foreign key to profiles

  1. Changes
    - Add missing foreign key constraint from job_seekers.user_id to profiles.id
    - This allows Supabase to properly join job_seekers with profiles table
  
  2. Security
    - No changes to RLS policies
*/

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE constraint_name = 'job_seekers_user_id_fkey'
    AND table_name = 'job_seekers'
  ) THEN
    ALTER TABLE job_seekers
    ADD CONSTRAINT job_seekers_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES profiles(id)
    ON DELETE CASCADE;
  END IF;
END $$;

-- Add index for better performance
CREATE INDEX IF NOT EXISTS idx_job_seekers_user_id ON job_seekers(user_id);
