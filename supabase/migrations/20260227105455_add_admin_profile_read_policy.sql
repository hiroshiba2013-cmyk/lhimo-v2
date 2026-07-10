/*
  # Add Admin Profile Read Policy

  1. Problem
    - Admins cannot read their own profile data
    - This causes "permission denied" errors when admin logs in
    - Admin needs to read profiles table to get their user_type and basic info

  2. Solution
    - Add SELECT policy allowing admins to read their own profile
    - Use auth.uid() to ensure admin can only read their own data

  3. Security
    - Admin can only read their own profile record
    - Uses auth.uid() for security check
*/

-- Add policy for admins to read their own profile
CREATE POLICY "Admins can read own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (id = auth.uid() AND user_type = 'admin');
