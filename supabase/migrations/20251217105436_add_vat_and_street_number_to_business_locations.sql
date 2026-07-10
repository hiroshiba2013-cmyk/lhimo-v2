/*
  # Add VAT number and street number to business locations

  1. Changes
    - Add `street_number` field to business_locations table
    - Add `vat_number` field to business_locations table (optional for individual locations)
    - Add constraint to ensure province is exactly 2 uppercase characters
    
  2. Notes
    - street_number is required to separate it from the street name
    - vat_number is optional as not all locations may have separate VAT numbers
    - province must be 2 uppercase characters (e.g., 'MI', 'RM')
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'street_number'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN street_number text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'vat_number'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN vat_number text;
  END IF;
END $$;

ALTER TABLE business_locations 
  ADD CONSTRAINT business_locations_province_format 
  CHECK (province ~ '^[A-Z]{2}$');
