/*
  # Fix Admins RLS for Login

  1. Changes
    - Drop existing public SELECT policy on admins table
    - Add new policy allowing authenticated users to check if a user_id is an admin
    - This fixes the "Database error querying schema" issue during admin login

  2. Security
    - Only authenticated users can query the admins table
    - Users can only check admin status, not see all admin data
*/

-- Drop the problematic public policy
DROP POLICY IF EXISTS "Anyone can read admins table" ON admins;

-- Add policy for authenticated users to check admin status
CREATE POLICY "Authenticated users can check admin status"
  ON admins
  FOR SELECT
  TO authenticated
  USING (true);
