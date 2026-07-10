/*
  # Fix Subscriptions Admin Access
  
  1. Changes
    - Drop all existing policies on subscriptions table
    - Create simple, clear policies for admin and user access
    - Ensure admins can view all subscriptions
    - Ensure users can only view their own subscriptions
  
  2. Security
    - Admins have full read access to all subscriptions
    - Regular users can only view their own subscriptions
    - No recursive calls to avoid performance issues
*/

-- Drop all existing policies on subscriptions
DROP POLICY IF EXISTS "Users can view own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can insert own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can update own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Admins have full access to all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Allow admin full access" ON subscriptions;

-- Create new simple policies
-- 1. Admin can view all subscriptions (check directly in admins table)
CREATE POLICY "Admin can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );

-- 2. Users can view their own subscription
CREATE POLICY "Users can view own subscription"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

-- 3. Admin can insert any subscription
CREATE POLICY "Admin can insert subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );

-- 4. Users can insert their own subscription
CREATE POLICY "Users can insert own subscription"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

-- 5. Admin can update any subscription
CREATE POLICY "Admin can update subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );

-- 6. Users can update their own subscription
CREATE POLICY "Users can update own subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

-- 7. Admin can delete any subscription
CREATE POLICY "Admin can delete subscriptions"
  ON subscriptions FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );
