/*
  # Add unique constraints to favorite_businesses table

  ## Problem
  The favorite_businesses table has no unique constraints, allowing the same
  business to be saved multiple times by the same user/family member.

  ## Changes
  - Remove duplicate rows first
  - Add partial unique indexes for each FK column (unclaimed, registered location,
    registered business, legacy location, legacy business), scoped by user_id
    and family_member_id (NULL-safe via WHERE clauses)
*/

-- Remove exact duplicates first, keeping the oldest record
DELETE FROM favorite_businesses a
USING favorite_businesses b
WHERE a.id > b.id
  AND a.user_id = b.user_id
  AND (a.family_member_id = b.family_member_id OR (a.family_member_id IS NULL AND b.family_member_id IS NULL))
  AND (a.unclaimed_business_location_id = b.unclaimed_business_location_id OR (a.unclaimed_business_location_id IS NULL AND b.unclaimed_business_location_id IS NULL))
  AND (a.registered_business_location_id = b.registered_business_location_id OR (a.registered_business_location_id IS NULL AND b.registered_business_location_id IS NULL))
  AND (a.registered_business_id = b.registered_business_id OR (a.registered_business_id IS NULL AND b.registered_business_id IS NULL))
  AND (a.business_location_id = b.business_location_id OR (a.business_location_id IS NULL AND b.business_location_id IS NULL))
  AND (a.business_id = b.business_id OR (a.business_id IS NULL AND b.business_id IS NULL));

-- Unique index for unclaimed businesses (owner, no family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_unclaimed_owner_unique
  ON favorite_businesses (user_id, unclaimed_business_location_id)
  WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NULL;

-- Unique index for unclaimed businesses (owner + family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_unclaimed_family_unique
  ON favorite_businesses (user_id, unclaimed_business_location_id, family_member_id)
  WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique index for registered business locations (owner, no family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rbl_owner_unique
  ON favorite_businesses (user_id, registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NULL;

-- Unique index for registered business locations (owner + family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rbl_family_unique
  ON favorite_businesses (user_id, registered_business_location_id, family_member_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique index for registered businesses without location (owner, no family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rb_owner_unique
  ON favorite_businesses (user_id, registered_business_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique index for registered businesses without location (owner + family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rb_family_unique
  ON favorite_businesses (user_id, registered_business_id, family_member_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NOT NULL;
