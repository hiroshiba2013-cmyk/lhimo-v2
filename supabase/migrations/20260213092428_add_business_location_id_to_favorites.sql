/*
  # Add business_location_id to favorite_businesses
  
  1. Changes
    - Add business_location_id column to favorite_businesses table
    - Add foreign key constraint to business_locations
    - Add check constraint to ensure either business_id OR business_location_id OR unclaimed_business_location_id is set
  
  2. Notes
    - business_id: Legacy field for favoriting entire businesses (can be deprecated)
    - business_location_id: For favoriting specific claimed business locations
    - unclaimed_business_location_id: For favoriting unclaimed businesses
*/

-- Add business_location_id column
ALTER TABLE favorite_businesses 
ADD COLUMN IF NOT EXISTS business_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;

-- Add check constraint to ensure at least one ID is provided
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'favorite_businesses_valid_reference'
  ) THEN
    ALTER TABLE favorite_businesses
    ADD CONSTRAINT favorite_businesses_valid_reference
    CHECK (
      (business_id IS NOT NULL)::int + 
      (business_location_id IS NOT NULL)::int + 
      (unclaimed_business_location_id IS NOT NULL)::int = 1
    );
  END IF;
END $$;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_location_id 
ON favorite_businesses(business_location_id);
