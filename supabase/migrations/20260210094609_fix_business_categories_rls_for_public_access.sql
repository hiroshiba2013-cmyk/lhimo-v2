/*
  # Fix Business Categories RLS for Public Access

  1. Changes
    - Drop existing restrictive RLS policy
    - Create new policy allowing public (unauthenticated) access to business categories
    
  2. Security
    - Allow everyone (including unauthenticated users) to view business categories
    - This is safe as categories are reference data that should be publicly visible
*/

-- Drop existing policy
DROP POLICY IF EXISTS "Public can view categories" ON business_categories;

-- Create new policy for public access (including unauthenticated)
CREATE POLICY "Anyone can view categories"
  ON business_categories
  FOR SELECT
  TO public
  USING (true);