/*
  # Allow Public Access to Claimed Businesses
  
  This migration updates the RLS policies to allow public and authenticated users
  to view businesses that have been claimed, even if they are not yet verified.
  
  This ensures that when business owners claim their businesses and add locations,
  those businesses appear in search results for all users.
  
  Changes:
  - Update "Public can view verified businesses" policy to include claimed businesses
  - Update "Anyone can view verified businesses" policy to include claimed businesses
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Public can view verified businesses" ON businesses;
DROP POLICY IF EXISTS "Anyone can view verified businesses" ON businesses;

-- Create new policy for public users to view verified OR claimed businesses
CREATE POLICY "Public can view verified or claimed businesses"
  ON businesses
  FOR SELECT
  TO public
  USING (
    verified = true 
    OR is_claimed = true
  );

-- Create new policy for authenticated users to view verified, claimed, or own businesses
CREATE POLICY "Authenticated users can view verified, claimed or own businesses"
  ON businesses
  FOR SELECT
  TO authenticated
  USING (
    verified = true 
    OR is_claimed = true 
    OR owner_id = auth.uid()
  );
