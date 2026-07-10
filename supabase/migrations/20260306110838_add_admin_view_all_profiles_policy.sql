/*
  # Allow admins to view all profiles

  1. Changes
    - Add RLS policy to allow admin users to view all profiles in the system
    - This enables the admin dashboard to display all users for management purposes
  
  2. Security
    - Only users in the admins table can view all profiles
    - Regular users can still only view their own profile or public profile info
*/

-- Allow admins to view all profiles
CREATE POLICY "Admins can view all profiles"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );
