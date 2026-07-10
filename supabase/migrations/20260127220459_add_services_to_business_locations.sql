/*
  # Add services field to business_locations

  1. Changes
    - Add `services` text array field to `business_locations` table
    - This field will store a list of services available at each location
    - Examples: "WiFi gratuito", "Parcheggio", "Consegna a domicilio", etc.

  2. Notes
    - Field is nullable to support existing locations
    - Services are stored as an array of text strings for flexibility
    - Each location can have its own unique set of services
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'services'
  ) THEN
    ALTER TABLE business_locations 
    ADD COLUMN services text[] DEFAULT '{}';
  END IF;
END $$;
