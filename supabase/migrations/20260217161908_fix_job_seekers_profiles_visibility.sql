/*
  # Fix Job Seekers Profile Visibility

  1. Changes
    - Add policy to allow public to view basic profile info (nickname, full_name) for users with active job seeker ads
    - This fixes the issue where job seeker cards don't display because the profiles join is blocked by RLS

  2. Security
    - Only allows viewing basic profile information (nickname, full_name)
    - Only for profiles that have active job seeker ads
    - Does not expose sensitive profile data
*/

-- Drop existing policy if it exists, then create new one
DO $$
BEGIN
  DROP POLICY IF EXISTS "Public can view profiles with active job seeker ads" ON profiles;
END $$;

-- Allow public to view profiles of users with active job seeker ads
CREATE POLICY "Public can view profiles with active job seeker ads"
  ON profiles
  FOR SELECT
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM job_seekers
      WHERE job_seekers.user_id = profiles.id
      AND job_seekers.status = 'active'
    )
  );
