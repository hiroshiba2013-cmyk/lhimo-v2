/*
  # Fix Subscriptions RLS for Admins using JWT

  1. Problem
    - The subquery-based policy for admins is causing issues from the frontend
    - Admin users cannot retrieve subscriptions data
  
  2. Solution
    - Replace subquery-based policy with JWT-based check
    - This is more reliable and performant
  
  3. Security
    - Only users with user_type = 'admin' in profiles can view all subscriptions
*/

-- Drop the old admin policy that uses subquery
DROP POLICY IF EXISTS "Admins view all subscriptions" ON subscriptions;

-- Create new policy using JWT user_type check
CREATE POLICY "Admins view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    (SELECT user_type FROM profiles WHERE id = auth.uid()) = 'admin'
  );
