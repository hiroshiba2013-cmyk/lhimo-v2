/*
  # Add Location Association to Discounts and Job Postings

  1. Changes
    - Add `business_location_id` to `discounts` table
      - Optional foreign key to `business_locations`
      - If null, discount applies to all locations
      - If set, discount applies only to that specific location
    
    - Add `business_location_id` to `job_postings` table
      - Optional foreign key to `business_locations`
      - If null, job posting is for the main business
      - If set, job posting is for that specific location

  2. Indexes
    - Add indexes on `business_location_id` for better query performance

  3. Notes
    - NULL values mean the discount/job applies to all locations or the main business
    - This allows businesses to manage location-specific discounts and job postings
*/

-- Add business_location_id to discounts
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discounts' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE discounts ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_discounts_location_id ON discounts(business_location_id);
  END IF;
END $$;

-- Add business_location_id to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_job_postings_location_id ON job_postings(business_location_id);
  END IF;
END $$;