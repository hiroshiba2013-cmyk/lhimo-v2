/*
  # Add registered_business_location_id and registered_business_id to reviews

  ## Problem
  The reviews table only has FK columns for the old system (business_id → businesses,
  business_location_id → business_locations). The new system uses registered_businesses
  and registered_business_locations, so reviews for those businesses fail with 403 (RLS)
  because no recognized FK column is populated.

  ## Changes
  1. Add `registered_business_location_id` FK → registered_business_locations
  2. Add `registered_business_id` FK → registered_businesses (for businesses without locations)
  3. Update the INSERT RLS policy to accept these new columns
  4. Add unique indexes to prevent duplicate reviews
  5. Add regular indexes for query performance
*/

-- Add new columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE CASCADE;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'registered_business_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN registered_business_id uuid REFERENCES registered_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Drop and recreate INSERT policy to include new columns
DROP POLICY IF EXISTS "Customers and family members can create reviews" ON reviews;

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
      OR registered_business_location_id IS NOT NULL
      OR registered_business_id IS NOT NULL
    )
  );

-- Unique indexes for new columns
CREATE UNIQUE INDEX IF NOT EXISTS reviews_rbl_owner_unique
  ON reviews (customer_id, registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_rbl_family_unique
  ON reviews (customer_id, family_member_id, registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_rb_owner_unique
  ON reviews (customer_id, registered_business_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_rb_family_unique
  ON reviews (customer_id, family_member_id, registered_business_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_reviews_registered_business_location
  ON reviews (registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_reviews_registered_business
  ON reviews (registered_business_id)
  WHERE registered_business_id IS NOT NULL;
