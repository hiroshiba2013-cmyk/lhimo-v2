/*
  # Sync is_claimed Status Between Businesses and Locations
  
  This migration creates a trigger to automatically sync the is_claimed status
  from business_locations to businesses. When any location of a business is claimed,
  the business itself is marked as claimed.
  
  Changes:
  - Create function to sync is_claimed status
  - Create trigger on business_locations to update businesses.is_claimed
*/

-- Function to sync is_claimed status from locations to business
CREATE OR REPLACE FUNCTION sync_business_claimed_status()
RETURNS TRIGGER AS $$
BEGIN
  -- If any location is claimed, mark the business as claimed
  UPDATE businesses
  SET is_claimed = true
  WHERE id = NEW.business_id
    AND is_claimed = false;
  
  -- If all locations are unclaimed, mark the business as unclaimed
  IF NEW.is_claimed = false THEN
    UPDATE businesses
    SET is_claimed = false
    WHERE id = NEW.business_id
      AND NOT EXISTS (
        SELECT 1 FROM business_locations
        WHERE business_id = NEW.business_id
          AND is_claimed = true
      );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to sync on INSERT or UPDATE
DROP TRIGGER IF EXISTS sync_business_claimed_on_location_change ON business_locations;
CREATE TRIGGER sync_business_claimed_on_location_change
  AFTER INSERT OR UPDATE OF is_claimed ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION sync_business_claimed_status();
