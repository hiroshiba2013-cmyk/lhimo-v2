/*
  # Add description field to business_locations
  
  1. Changes
    - Add `description` text field to `business_locations` table
    - This field will store a brief description of the specific location
    - Useful for distinguishing between multiple locations of the same business
  
  2. Notes
    - Field is nullable to support existing locations
    - Can be used to provide location-specific details
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'description'
  ) THEN
    ALTER TABLE business_locations 
    ADD COLUMN description text;
  END IF;
END $$;
