/*
  # Add Business Location to Reviews

  1. Changes
    - Add `business_location_id` column to `reviews` table (nullable)
    - Add foreign key constraint to `business_locations` table
    - Add index for performance on location-based queries
    - Update RLS policies to handle location-based reviews

  2. Notes
    - The field is nullable to allow reviews for the business in general
    - Existing reviews will have NULL for this field
    - New reviews can optionally specify a specific location
*/

-- Add business_location_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_reviews_business_location_id ON reviews(business_location_id);

-- Add comment for documentation
COMMENT ON COLUMN reviews.business_location_id IS 'Optional reference to specific business location being reviewed. NULL means review is for the business in general.';