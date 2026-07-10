/*
  # Add region, province, city to job_postings

  1. Changes
    - Add region, province, city columns to job_postings
    - Backfill from linked business_locations or registered_business_locations
  
  2. Notes
    - These columns allow direct region/province/city filtering without joins
    - Backfill covers existing postings linked to a business location
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'region'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN region text DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'province'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN province text DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'city'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN city text DEFAULT '';
  END IF;
END $$;

-- Backfill from business_locations
UPDATE job_postings jp
SET
  region = COALESCE(bl.region, ''),
  province = COALESCE(bl.province, ''),
  city = COALESCE(bl.city, '')
FROM business_locations bl
WHERE jp.business_location_id = bl.id
  AND (jp.region = '' OR jp.region IS NULL);

-- Backfill from registered_business_locations
UPDATE job_postings jp
SET
  region = COALESCE(rbl.region, ''),
  province = COALESCE(rbl.province, ''),
  city = COALESCE(rbl.city, '')
FROM registered_business_locations rbl
WHERE jp.registered_business_location_id = rbl.id
  AND (jp.region = '' OR jp.region IS NULL);
