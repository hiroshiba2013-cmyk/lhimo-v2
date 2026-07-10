/*
  # Add support for reviews on unclaimed business locations

  1. Changes
    - Add `unclaimed_business_location_id` column to `reviews` table
    - Add foreign key constraint to `unclaimed_business_locations` table
    - Update RLS policies to support reviews on unclaimed businesses

  2. Security
    - Maintains existing RLS policies
    - Allows public to view approved reviews on unclaimed businesses
*/

-- Add unclaimed_business_location_id column to reviews
ALTER TABLE reviews 
ADD COLUMN IF NOT EXISTS unclaimed_business_location_id uuid REFERENCES unclaimed_business_locations(id) ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_reviews_unclaimed_business_location 
ON reviews(unclaimed_business_location_id) 
WHERE unclaimed_business_location_id IS NOT NULL;

-- Update the existing RLS policy for viewing reviews to include unclaimed businesses
DROP POLICY IF EXISTS "Anyone can view approved reviews" ON reviews;

CREATE POLICY "Anyone can view approved reviews"
  ON reviews FOR SELECT
  TO public
  USING (
    review_status = 'approved' 
    AND (
      business_id IS NOT NULL 
      OR imported_business_id IS NOT NULL 
      OR user_added_business_id IS NOT NULL 
      OR unclaimed_business_location_id IS NOT NULL
    )
  );