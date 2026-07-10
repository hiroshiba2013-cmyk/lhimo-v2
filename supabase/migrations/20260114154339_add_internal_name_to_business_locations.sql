/*
  # Add internal name field to business locations

  1. Changes
    - Add `internal_name` column to `business_locations` table
      - This is a private label/nickname that only the business owner sees
      - Used to easily identify locations in their dashboard (e.g., "Sede 1", "Sede 2", "Filiale Milano")
      - The `name` field remains the official business name shown to users in search results
    
  2. Notes
    - This field is optional and defaults to NULL
    - If not set, the system can fall back to showing "Sede 1", "Sede 2", etc.
*/

-- Add internal_name column for private location identification
ALTER TABLE business_locations 
ADD COLUMN IF NOT EXISTS internal_name TEXT;

COMMENT ON COLUMN business_locations.internal_name IS 'Private label/nickname for the location, visible only to the business owner for easy identification in their dashboard';
