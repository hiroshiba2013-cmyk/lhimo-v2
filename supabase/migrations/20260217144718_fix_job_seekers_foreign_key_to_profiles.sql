/*
  # Fix job_seekers foreign key to profiles

  1. Changes
    - Add foreign key constraint from job_seekers.user_id to profiles.id
    - This enables Supabase queries to properly join job_seekers with profiles data
  
  2. Security
    - No RLS changes needed - existing policies remain unchanged
*/

-- Add foreign key constraint if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'job_seekers_user_id_fkey' 
    AND table_name = 'job_seekers'
  ) THEN
    ALTER TABLE job_seekers 
    ADD CONSTRAINT job_seekers_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
  END IF;
END $$;
