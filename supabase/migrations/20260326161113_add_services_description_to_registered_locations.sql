/*
  # Add services_description to registered_business_locations

  1. Changes
    - Add `services_description` text field to `registered_business_locations` table
    - This field stores a free-form text description of services offered at each location
    - Similar to the description field, but specifically for services

  2. Notes
    - Field is nullable to support existing locations
    - Stored as plain text for maximum flexibility
    - Can be edited by business owners and admins
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_business_locations' AND column_name = 'services_description'
  ) THEN
    ALTER TABLE registered_business_locations 
    ADD COLUMN services_description text;
  END IF;
END $$;

COMMENT ON COLUMN registered_business_locations.services_description IS 'Free-form text description of services offered at this location';
