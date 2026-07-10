/*
  # Fix job_seekers user_id foreign key to profiles

  ## Problem
  The job_seekers.user_id column references auth.users(id), but the frontend
  queries use `profiles:user_id(...)` which requires a foreign key to profiles(id).

  ## Fix
  Add an additional foreign key constraint from job_seekers.user_id to profiles(id)
  so that Supabase PostgREST can resolve the join relationship.
*/

ALTER TABLE job_seekers
  DROP CONSTRAINT IF EXISTS job_seekers_user_id_fkey_profiles;

ALTER TABLE job_seekers
  ADD CONSTRAINT job_seekers_user_id_fkey_profiles
  FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
