/*
  # Fix Subscriptions Count for Admin

  1. Problem
    - Admin users cannot perform COUNT operations on subscriptions table
    - The RLS policies are blocking head-only queries (count operations)
  
  2. Solution
    - Simplify admin SELECT policy to allow all operations including COUNT
    - Remove complex EXISTS subqueries that might interfere with head-only queries
    
  3. Security
    - Admin access remains secure through direct admins table lookup
    - Regular users can still only see their own subscriptions
*/

-- Drop existing admin view policy
DROP POLICY IF EXISTS "Admin can view all subscriptions" ON subscriptions;

-- Create simplified admin view policy that works with COUNT operations
CREATE POLICY "Admin can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    -- Check if user is admin directly in admins table
    auth.uid() IN (SELECT user_id FROM admins)
  );

-- Ensure the user policy remains unchanged
-- (Users can view their own subscription)
-- This policy already exists from previous migration
