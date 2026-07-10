/*
  # Fix reviews insert RLS policy for all business types

  1. Changes
    - Drop and recreate the reviews insert policy to support all business reference patterns
    - Allow reviews when any valid business reference is set (business_id, imported_business_id,
      user_added_business_id, unclaimed_business_location_id, or business_location_id)

  2. Security
    - Still requires customer_id = auth.uid()
    - Still validates family_member ownership
    - Ensures at least one business reference is provided
*/

DO $$ BEGIN
  DROP POLICY IF EXISTS "Customers and family members can create reviews" ON reviews;
END $$;

CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid()
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = reviews.family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
    AND (
      business_id IS NOT NULL
      OR imported_business_id IS NOT NULL
      OR user_added_business_id IS NOT NULL
      OR unclaimed_business_location_id IS NOT NULL
      OR business_location_id IS NOT NULL
    )
  );
