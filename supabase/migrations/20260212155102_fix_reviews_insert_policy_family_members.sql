/*
  # Fix Reviews INSERT Policy for Family Members

  1. Changes
    - Drop old INSERT policy that only checks customer_id
    - Create new INSERT policy that allows:
      * Titolare (owner) to create reviews with family_member_id = NULL
      * Family members to create reviews with their family_member_id
    - Verify that family_member_id (if present) belongs to the authenticated user

  2. Security
    - Ensures customer_id matches auth.uid()
    - Verifies family_member_id belongs to the authenticated user
    - Maintains business_type validation
*/

-- Drop old restrictive policy
DROP POLICY IF EXISTS "Customers can create reviews for all types" ON reviews;

-- Create new policy that supports family members
CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid()
    AND (
      -- Se family_member_id è NULL, è il titolare che recensisce
      family_member_id IS NULL
      OR
      -- Se family_member_id è presente, verifica che appartenga all'utente
      EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE id = family_member_id
        AND customer_id = auth.uid()
      )
    )
    AND (
      (business_type = 'imported' AND imported_business_id IS NOT NULL)
      OR (business_type = 'user_added' AND user_added_business_id IS NOT NULL)
      OR (business_type = 'registered' AND business_id IS NOT NULL)
    )
  );
