/*
  # Add business location support to classified_ads and auctions

  ## Purpose
  Business users with multiple locations (sedi) need their classified ads and auctions
  to be associated with a specific location. This allows filtering so each sede sees
  only its own content, while the "all locations" view shows everything.

  ## Changes

  ### classified_ads
  - Add `business_location_id` (FK to business_locations) - for old business system
  - Add `registered_business_location_id` (FK to registered_business_locations) - for new system

  ### auctions
  - Add `business_location_id` (FK to business_locations)
  - Add `registered_business_location_id` (FK to registered_business_locations)

  ## Notes
  - Existing records remain with NULL location (treated as "all locations")
  - No destructive changes
*/

-- classified_ads: add business location columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

-- auctions: add business location columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE auctions ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE auctions ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_classified_ads_business_location_id ON classified_ads(business_location_id);
CREATE INDEX IF NOT EXISTS idx_classified_ads_registered_business_location_id ON classified_ads(registered_business_location_id);
CREATE INDEX IF NOT EXISTS idx_auctions_business_location_id ON auctions(business_location_id);
CREATE INDEX IF NOT EXISTS idx_auctions_registered_business_location_id ON auctions(registered_business_location_id);
