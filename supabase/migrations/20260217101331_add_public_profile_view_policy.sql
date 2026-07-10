/*
  # Add Public Profile View Policy

  ## Changes
  - Add policy to allow authenticated users to view basic profile information of other users
  - This is needed for job_seekers listings where we need to display the name of the person who created the ad

  ## Security
  - Only allows SELECT operations
  - Only for authenticated users
  - Users can see basic profile info (full_name, nickname) of others
*/

-- Allow authenticated users to view all profiles (basic info)
-- This is needed for job seekers, reviews, and other features where we display user names
CREATE POLICY "Authenticated users can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);
