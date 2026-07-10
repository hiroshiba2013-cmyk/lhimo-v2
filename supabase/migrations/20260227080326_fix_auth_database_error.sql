/*
  # Fix Auth Database Error

  1. Changes
    - Simplify profiles RLS policies to avoid recursion issues during auth
    - Remove complex subqueries that might cause database errors

  2. Security
    - Keep basic security but avoid performance issues
*/

-- Drop and recreate profiles policies with simpler logic
DROP POLICY IF EXISTS "Public can view basic profile info" ON profiles;
CREATE POLICY "Public can view basic profile info"
  ON profiles FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
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