/*
  # Fix Subscriptions RLS - Remove Duplicates

  1. Problem
    - Multiple duplicate RLS policies on subscriptions table
    - Some policies use is_admin() function causing recursion
    - Policies are conflicting with each other
  
  2. Solution
    - Drop ALL existing policies
    - Create clean, simple policies:
      - One for users to view their own subscriptions
      - One for users to manage their own subscriptions
      - One for admins to view all subscriptions (using direct admins table check)
      - One for admins to manage all subscriptions
    
  3. Security
    - Users can only see and manage their own subscriptions
    - Admins can see and manage all subscriptions
    - Direct admins table lookup to avoid recursion
*/

-- Drop ALL existing policies on subscriptions
DROP POLICY IF EXISTS "Admin can delete subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admin can insert subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admin can update subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admin can view all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admins can manage subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admins can update any subscription" ON subscriptions;
DROP POLICY IF EXISTS "Admins can view all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Users can create own subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Users can insert own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can update own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can update own subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Users can view own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can view own subscriptions" ON subscriptions;

-- Create clean policies

-- 1. Users can view their own subscriptions
CREATE POLICY "Users view own subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

-- 2. Users can insert their own subscriptions
CREATE POLICY "Users insert own subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

-- 3. Users can update their own subscriptions
CREATE POLICY "Users update own subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

-- 4. Users can delete their own subscriptions
CREATE POLICY "Users delete own subscriptions"
  ON subscriptions FOR DELETE
  TO authenticated
  USING (customer_id = auth.uid());

-- 5. Admins can view ALL subscriptions (direct admins table check)
CREATE POLICY "Admins view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );

-- 6. Admins can insert ANY subscription
CREATE POLICY "Admins insert any subscription"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );

-- 7. Admins can update ANY subscription
CREATE POLICY "Admins update any subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );

-- 8. Admins can delete ANY subscription
CREATE POLICY "Admins delete any subscription"
  ON subscriptions FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );
