/*
  # Add registered_business_location_id to job_postings

  ## Problem
  The business_location_id FK points only to business_locations (old table).
  Users with registered_business_locations get a FK violation when selecting a sede.

  ## Changes
  - Make business_location_id nullable (already is, but ensure)
  - Add registered_business_location_id with FK to registered_business_locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE job_postings
      ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;
