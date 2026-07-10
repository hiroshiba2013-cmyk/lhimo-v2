/*
  # Allow public access to subscription plans

  1. Changes
    - Update RLS policy on subscription_plans table to allow anonymous users to view plans
    - This enables the subscription page to show all available plans to non-logged-in users

  2. Security
    - Only SELECT operations are allowed
    - Users still cannot modify subscription plans
*/

DROP POLICY IF EXISTS "Anyone can view subscription plans" ON subscription_plans;

CREATE POLICY "Public can view subscription plans"
  ON subscription_plans
  FOR SELECT
  TO public
  USING (true);
