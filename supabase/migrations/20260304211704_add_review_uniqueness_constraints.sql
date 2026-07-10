/*
  # Add Review Uniqueness Constraints

  1. Overview
    - Prevents duplicate reviews for the same business by the same profile
    - Each user (owner or family member) can review a business only once per 365 days
    - Multiple family members can review the same business independently

  2. Changes
    - Add unique partial indexes for each business type (registered, imported, user_added, unclaimed)
    - Each index ensures customer_id + family_member_id + business_id combination is unique
    - Separate indexes for owner reviews (family_member_id IS NULL) and family member reviews

  3. Notes
    - After 365 days, the frontend will delete the old review before creating a new one
    - This constraint prevents accidental duplicates at the database level
*/

-- Unique constraint for registered businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_registered_owner_unique
ON reviews (customer_id, business_id)
WHERE business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for registered businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_registered_family_unique
ON reviews (customer_id, family_member_id, business_id)
WHERE business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique constraint for imported businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_imported_owner_unique
ON reviews (customer_id, imported_business_id)
WHERE imported_business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for imported businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_imported_family_unique
ON reviews (customer_id, family_member_id, imported_business_id)
WHERE imported_business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique constraint for user_added businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_user_added_owner_unique
ON reviews (customer_id, user_added_business_id)
WHERE user_added_business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for user_added businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_user_added_family_unique
ON reviews (customer_id, family_member_id, user_added_business_id)
WHERE user_added_business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique constraint for unclaimed businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_unclaimed_owner_unique
ON reviews (customer_id, unclaimed_business_location_id)
WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for unclaimed businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_unclaimed_family_unique
ON reviews (customer_id, family_member_id, unclaimed_business_location_id)
WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;
