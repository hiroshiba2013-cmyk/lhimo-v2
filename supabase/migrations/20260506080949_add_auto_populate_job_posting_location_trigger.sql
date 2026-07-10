/*
  # Auto-populate region/province/city on job_postings from linked location

  When a job posting is inserted or updated with a business_location_id or
  registered_business_location_id, automatically copy region/province/city
  from the linked location if they are not already set.
*/

CREATE OR REPLACE FUNCTION sync_job_posting_location()
RETURNS TRIGGER AS $$
BEGIN
  -- Try registered_business_locations first
  IF NEW.registered_business_location_id IS NOT NULL AND (NEW.region IS NULL OR NEW.region = '') THEN
    SELECT region, province, city
    INTO NEW.region, NEW.province, NEW.city
    FROM registered_business_locations
    WHERE id = NEW.registered_business_location_id;
  END IF;

  -- Try business_locations if still empty
  IF NEW.business_location_id IS NOT NULL AND (NEW.region IS NULL OR NEW.region = '') THEN
    SELECT region, province, city
    INTO NEW.region, NEW.province, NEW.city
    FROM business_locations
    WHERE id = NEW.business_location_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_job_posting_location ON job_postings;

CREATE TRIGGER trg_sync_job_posting_location
  BEFORE INSERT OR UPDATE ON job_postings
  FOR EACH ROW
  EXECUTE FUNCTION sync_job_posting_location();
