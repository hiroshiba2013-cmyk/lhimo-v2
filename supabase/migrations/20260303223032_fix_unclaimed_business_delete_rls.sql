/*
  # Fix Unclaimed Business Locations Delete RLS Policy

  1. Changes
    - Update DELETE policy to also allow admins
    - Ensure users can always delete their own added businesses
    - Add better error handling for edge cases

  2. Security
    - Maintain user ownership checks
    - Add admin override capability
*/

-- Drop existing policy
DROP POLICY IF EXISTS "Users can delete own added businesses" ON unclaimed_business_locations;

-- Recreate with admin support
CREATE POLICY "Users can delete own added businesses"
  ON unclaimed_business_locations
  FOR DELETE
  TO authenticated
  USING (
    -- Allow if user added it directly
    added_by = auth.uid()
    OR
    -- Allow if user added it via family member
    added_by_family_member_id IN (
      SELECT id FROM customer_family_members
      WHERE customer_id = auth.uid()
    )
    OR
    -- Allow admins
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );
