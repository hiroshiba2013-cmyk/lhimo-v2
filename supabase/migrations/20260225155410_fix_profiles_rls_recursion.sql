/*
  # Fix Profiles RLS Infinite Recursion

  1. Problem
    - Multiple conflicting policies on profiles table
    - is_admin() function causes infinite recursion when checking profiles
    - Policy "Admins can view all profiles" conflicts with "Authenticated users can view all profiles"

  2. Solution
    - Drop the admin-specific policy (redundant since authenticated users can already view all)
    - Keep "Authenticated users can view all profiles" as it covers all cases
    - The is_admin() function can still be used in OTHER tables without issues

  3. Security
    - All authenticated users can still view profiles (needed for app functionality)
    - Users can still update only their own profile
    - Admin checks work fine on other tables
*/

-- Drop the problematic admin policy on profiles
-- This is redundant since "Authenticated users can view all profiles" already allows all viewing
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

-- Verify the remaining policies are correct
-- "Users can view own profile" - Allows users to view their own profile
-- "Authenticated users can view all profiles" - Allows all authenticated users to view any profile
-- "Users can update own profile" - Allows users to update only their own profile
-- "Users can insert own profile" - Allows users to insert their own profile

-- The is_admin() function is still available and works fine for OTHER tables
-- It just can't be used on the profiles table itself due to recursion
