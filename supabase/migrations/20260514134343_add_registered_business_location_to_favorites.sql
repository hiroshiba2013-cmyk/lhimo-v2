/*
  # Add registered_business_location_id to favorite_businesses

  ## Problem
  The favorite_businesses table has a business_location_id column that references
  business_locations (old/empty table), but registered businesses now use
  registered_business_locations. Saving favorites for registered businesses fails
  with a FK violation.

  ## Changes
  1. Add new column `registered_business_location_id` with FK to registered_business_locations
  2. Also add `registered_business_id` for businesses without locations
  3. Update the CHECK constraint to allow exactly one of the 4 reference columns to be set
  4. Add unique indexes for the new columns
*/

-- Add new column for registered business locations (new system)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'favorite_businesses' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE favorite_businesses ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Add new column for registered businesses without locations
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'favorite_businesses' AND column_name = 'registered_business_id'
  ) THEN
    ALTER TABLE favorite_businesses ADD COLUMN registered_business_id uuid REFERENCES registered_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Drop old CHECK constraint
ALTER TABLE favorite_businesses DROP CONSTRAINT IF EXISTS favorite_businesses_valid_reference;

-- Add updated CHECK constraint allowing exactly one of 5 columns
ALTER TABLE favorite_businesses ADD CONSTRAINT favorite_businesses_valid_reference CHECK (
  (
    (business_id IS NOT NULL)::integer +
    (business_location_id IS NOT NULL)::integer +
    (unclaimed_business_location_id IS NOT NULL)::integer +
    (registered_business_location_id IS NOT NULL)::integer +
    (registered_business_id IS NOT NULL)::integer
  ) = 1
);

-- Unique index for registered_business_location_id (no family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rbl_user
  ON favorite_businesses (user_id, registered_business_location_id)
  WHERE family_member_id IS NULL AND registered_business_location_id IS NOT NULL;

-- Unique index for registered_business_location_id (with family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rbl_family
  ON favorite_businesses (user_id, family_member_id, registered_business_location_id)
  WHERE family_member_id IS NOT NULL AND registered_business_location_id IS NOT NULL;

-- Unique index for registered_business_id (no family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rb_user
  ON favorite_businesses (user_id, registered_business_id)
  WHERE family_member_id IS NULL AND registered_business_id IS NOT NULL;

-- Unique index for registered_business_id (with family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rb_family
  ON favorite_businesses (user_id, family_member_id, registered_business_id)
  WHERE family_member_id IS NOT NULL AND registered_business_id IS NOT NULL;
