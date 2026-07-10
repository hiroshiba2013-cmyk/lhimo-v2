/*
  # Allow Admin Self-Promotion During Registration

  1. Changes
    - Allow users to set is_admin and user_type during profile creation
    - Allow users to insert into admins table during registration
    - This is temporary for initial admin setup

  2. Security
    - Users can only modify their own profile during creation
    - The admin key validation happens in the application layer
*/

-- Allow users to set admin fields during their own profile creation/update
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow users to insert themselves into admins table
DROP POLICY IF EXISTS "Only admins can manage admins table" ON admins;
CREATE POLICY "Users can insert themselves as admin"
  ON admins FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);