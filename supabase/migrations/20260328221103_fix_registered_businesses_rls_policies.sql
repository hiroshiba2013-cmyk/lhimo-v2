/*
  # Fix Registered Businesses RLS Policies

  1. Changes
    - Drop and recreate policies for registered_businesses with separate SELECT, INSERT, UPDATE, DELETE
    - Ensure business owners can update their own businesses
    - Ensure admins can manage all businesses

  2. Security
    - Business owners can only modify their own businesses
    - Admins can modify any business
    - Anyone can view registered businesses
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Business owners can manage their businesses" ON registered_businesses;
DROP POLICY IF EXISTS "Anyone can view registered businesses" ON registered_businesses;
DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;

-- Create separate policies for better clarity and control
CREATE POLICY "Anyone can view registered businesses"
  ON registered_businesses FOR SELECT
  USING (true);

CREATE POLICY "Business owners can insert their businesses"
  ON registered_businesses FOR INSERT TO authenticated
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Business owners can update their businesses"
  ON registered_businesses FOR UPDATE TO authenticated
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Business owners can delete their businesses"
  ON registered_businesses FOR DELETE TO authenticated
  USING (owner_id = auth.uid());

-- Admin policies
CREATE POLICY "Admins can insert any business"
  ON registered_businesses FOR INSERT TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update any business"
  ON registered_businesses FOR UPDATE TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete any business"
  ON registered_businesses FOR DELETE TO authenticated
  USING (is_admin());
