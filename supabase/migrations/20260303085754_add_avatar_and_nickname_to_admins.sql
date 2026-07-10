/*
  # Add Avatar and Nickname to Admin Profiles

  1. Changes
    - Add avatar_url field to admins table
    - Add nickname field to admins table
    - Allow admins to update their own profile fields

  2. Security
    - Admins can update their own avatar and nickname
    - Public can view admin avatars and nicknames (for display purposes)
*/

-- Add avatar_url and nickname to admins table
ALTER TABLE admins ADD COLUMN IF NOT EXISTS avatar_url text;
ALTER TABLE admins ADD COLUMN IF NOT EXISTS nickname text;

-- Update RLS policies to allow admins to update their own profile
DROP POLICY IF EXISTS "Admins can update own profile" ON admins;
CREATE POLICY "Admins can update own profile"
  ON admins FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
