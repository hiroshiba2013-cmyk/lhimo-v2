/*
  # Fix Profiles RLS Recursion Issue

  1. Problem
    - Policy "Public can view profiles with active job seeker ads" causes recursion
    - This policy queries job_seekers which may query back to profiles
    - Creating a circular dependency causing infinite recursion

  2. Solution
    - Remove the problematic policy
    - Keep only simple, direct policies without subqueries on other tables
    - Allow authenticated users to view profiles (safe and simple)
    - Public access can be handled at application level if needed

  3. Changes
    - Drop "Public can view profiles with active job seeker ads" policy
    - Keep "Users can view own profile" for owner access
    - Keep "Authenticated users can view all profiles" for logged-in users
    - No more circular dependencies
*/

-- Drop the problematic policy that causes recursion
DROP POLICY IF EXISTS "Public can view profiles with active job seeker ads" ON profiles;

-- Verify remaining policies are safe (no subqueries to other tables)
-- "Users can view own profile" - safe, only checks auth.uid()
-- "Authenticated users can view all profiles" - safe, no subqueries
-- "Users can update own profile" - safe, only checks auth.uid()
-- "Users can insert own profile" - safe, no conditions

COMMENT ON TABLE profiles IS 'User profiles with safe RLS policies that avoid recursion.';
