/*
  # Add is_claimed tracking to imported_businesses and user_added_businesses

  ## Changes
  - Add `is_claimed` boolean column to `imported_businesses` (default false)
  - Add `claimed_at` timestamp to `imported_businesses`
  - Add `claimed_by_business_id` uuid to `imported_businesses` (FK to registered_businesses)
  - Add `is_claimed` boolean column to `user_added_businesses` (default false)
  - Add `claimed_at` timestamp to `user_added_businesses`
  - Add `claimed_by_business_id` uuid to `user_added_businesses` (FK to registered_businesses)

  ## Purpose
  When a business owner claims their location through the registration flow,
  the original source record gets marked as claimed so it no longer appears
  as "available" in search results on the ClaimBusinessPage.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'imported_businesses' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE imported_businesses ADD COLUMN is_claimed boolean NOT NULL DEFAULT false;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'imported_businesses' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE imported_businesses ADD COLUMN claimed_at timestamptz;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'imported_businesses' AND column_name = 'claimed_by_business_id'
  ) THEN
    ALTER TABLE imported_businesses ADD COLUMN claimed_by_business_id uuid REFERENCES registered_businesses(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_added_businesses' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE user_added_businesses ADD COLUMN is_claimed boolean NOT NULL DEFAULT false;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_added_businesses' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE user_added_businesses ADD COLUMN claimed_at timestamptz;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_added_businesses' AND column_name = 'claimed_by_business_id'
  ) THEN
    ALTER TABLE user_added_businesses ADD COLUMN claimed_by_business_id uuid REFERENCES registered_businesses(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Index for fast filtering of unclaimed businesses
CREATE INDEX IF NOT EXISTS idx_imported_businesses_is_claimed ON imported_businesses(is_claimed);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_is_claimed ON user_added_businesses(is_claimed);
