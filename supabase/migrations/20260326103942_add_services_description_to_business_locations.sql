/*
  # Add services_description field to business_locations

  1. Changes
    - Add `services_description` text field to `business_locations` table
    - This field will store a free-form text description of services offered at each location
    - Similar to the description field, but specifically for services
    - No formatting constraints - users can write services however they want

  2. Notes
    - Field is nullable to support existing locations
    - Stored as plain text for maximum flexibility
    - Can be edited by business owners and admins
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'services_description'
  ) THEN
    ALTER TABLE business_locations 
    ADD COLUMN services_description text;
  END IF;
END $$;
