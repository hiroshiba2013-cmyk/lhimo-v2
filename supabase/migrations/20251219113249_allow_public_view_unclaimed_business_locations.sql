/*
  # Allow public access to unclaimed business locations

  1. Changes
    - Add policy to allow anyone (authenticated and anonymous) to view locations of unclaimed businesses
    - This ensures that when users browse unclaimed businesses, they can see contact information

  2. Security
    - Only SELECT access is granted for unclaimed businesses
    - Claimed business locations remain private to their owners
*/

CREATE POLICY "Anyone can view locations of unclaimed businesses"
  ON business_locations
  FOR SELECT
  TO public
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE is_claimed = false
    )
  );
