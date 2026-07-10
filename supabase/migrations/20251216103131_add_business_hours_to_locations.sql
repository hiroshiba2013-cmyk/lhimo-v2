/*
  # Add business hours and opening days to business locations

  1. Changes
    - Add `business_hours` column to `business_locations` table
      - Type: jsonb
      - Nullable: true
      - Stores opening hours for each day of the week
      - Format: { "monday": { "open": "09:00", "close": "18:00", "closed": false }, ... }
    - Add `notes` column for additional information about the location
      - Type: text
      - Nullable: true
  
  2. Purpose
    - Allow each business location to specify its opening hours
    - Enable customers to see when each location is open
    - Support different schedules for different locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'business_hours'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN business_hours jsonb DEFAULT NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'notes'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN notes text DEFAULT NULL;
  END IF;
END $$;