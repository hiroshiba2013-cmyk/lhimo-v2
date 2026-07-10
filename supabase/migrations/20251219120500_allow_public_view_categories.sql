/*
  # Allow Public Access to Business Categories

  1. Overview
    Updates RLS policy to allow public (anonymous) users to view business categories.
    This is necessary for the search functionality to work for non-authenticated users.

  2. Changes
    - Drop existing "Anyone can view categories" policy (restricted to authenticated)
    - Create new public read policy for business_categories

  3. Security
    - Public read access for categories is safe as they contain no sensitive data
    - Only SELECT operations are allowed
    - Users cannot modify categories
*/

DROP POLICY IF EXISTS "Anyone can view categories" ON business_categories;

CREATE POLICY "Public can view all categories"
  ON business_categories
  FOR SELECT
  TO public
  USING (true);
