/*
  # Add email field to business locations

  1. Changes
    - Add `email` column to `business_locations` table
      - Type: text
      - Nullable: true
      - Default: empty string
    
  2. Purpose
    - Allow each business location to have its own email address
    - Enable better communication with different business locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'email'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN email text DEFAULT '' NULL;
  END IF;
END $$;