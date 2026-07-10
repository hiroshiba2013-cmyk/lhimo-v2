/*
  # Fix favorite_businesses constraints

  1. Changes
    - Remove obsolete constraint `favorite_businesses_one_business_type`
    - Keep `favorite_businesses_valid_reference` which correctly allows business_id, business_location_id, or unclaimed_business_location_id
  
  2. Notes
    - The old constraint prevented using business_location_id
    - This fix allows users to favorite claimed business locations
*/

-- Remove the obsolete constraint that only allowed business_id or unclaimed_business_location_id
ALTER TABLE favorite_businesses 
DROP CONSTRAINT IF EXISTS favorite_businesses_one_business_type;
