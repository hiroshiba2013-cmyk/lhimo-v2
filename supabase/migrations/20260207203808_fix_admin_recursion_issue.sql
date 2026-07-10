/*
  # Fix Admin RLS Recursion Issue

  1. Problem
    - Policy "Admins can view all profiles" causes infinite recursion
    - When reading profiles, the policy checks profiles table, creating a loop

  2. Solution
    - Create a SECURITY DEFINER function to check admin status
    - This function bypasses RLS and prevents recursion
    - Update all admin policies to use this function

  3. Security
    - Function is secure and only checks admin status
    - No data exposure, just returns true/false
*/

-- Drop the problematic policy first
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

-- Create a security definer function to check admin status
-- This function bypasses RLS to prevent recursion
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(
    (SELECT is_admin FROM profiles WHERE id = auth.uid()),
    false
  );
$$;

-- Recreate the admin profile viewing policy using the function
CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (is_admin());

-- Update all other admin policies to use the function
DROP POLICY IF EXISTS "Admins can view all reviews" ON reviews;
CREATE POLICY "Admins can view all reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any review" ON reviews;
CREATE POLICY "Admins can update any review"
  ON reviews FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all classified ads" ON classified_ads;
CREATE POLICY "Admins can view all classified ads"
  ON classified_ads FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any classified ad" ON classified_ads;
CREATE POLICY "Admins can update any classified ad"
  ON classified_ads FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any classified ad" ON classified_ads;
CREATE POLICY "Admins can delete any classified ad"
  ON classified_ads FOR DELETE
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all subscriptions" ON subscriptions;
CREATE POLICY "Admins can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any subscription" ON subscriptions;
CREATE POLICY "Admins can update any subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all user activity" ON user_activity;
CREATE POLICY "Admins can view all user activity"
  ON user_activity FOR SELECT
  TO authenticated
  USING (is_admin());
