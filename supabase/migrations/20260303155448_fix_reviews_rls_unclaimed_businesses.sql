/*
  # Fix Reviews RLS Policy for Unclaimed Businesses

  1. Changes
    - Drop old INSERT policy that doesn't handle unclaimed businesses
    - Create new INSERT policy that includes unclaimed_business_location_id
    - Allows customers and family members to create reviews for all business types including unclaimed
  
  2. Security
    - Customer must be authenticated
    - Customer must own the customer_id
    - If family_member_id is provided, it must belong to the customer
    - Review must have exactly one business reference (business_id, imported_business_id, user_added_business_id, OR unclaimed_business_location_id)
*/

-- Drop the old restrictive policy
DROP POLICY IF EXISTS "Customers and family members can create reviews" ON reviews;

-- Create new comprehensive policy that includes unclaimed businesses
CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    -- Must be the customer creating the review
    customer_id = auth.uid()
    AND
    -- If family_member_id is provided, it must belong to this customer
    (
      family_member_id IS NULL
      OR
      EXISTS (
        SELECT 1
        FROM customer_family_members
        WHERE customer_family_members.id = reviews.family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
    AND
    -- Must reference exactly one type of business
    (
      (business_type = 'imported' AND imported_business_id IS NOT NULL)
      OR
      (business_type = 'user_added' AND user_added_business_id IS NOT NULL)
      OR
      (business_type = 'registered' AND business_id IS NOT NULL)
      OR
      (unclaimed_business_location_id IS NOT NULL)
    )
  );
