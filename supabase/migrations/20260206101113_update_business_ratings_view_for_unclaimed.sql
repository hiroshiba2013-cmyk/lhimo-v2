/*
  # Update business_ratings materialized view for unclaimed businesses

  1. Changes
    - Update the materialized view to include unclaimed businesses
    - Use UNION to combine both claimed and unclaimed businesses
    - Calculate ratings from both business_id and unclaimed_business_id in reviews

  2. Notes
    - The view now includes both types of businesses
    - Unclaimed businesses will have owner_id = NULL
*/

-- Drop existing materialized view
DROP MATERIALIZED VIEW IF EXISTS business_ratings;

-- Create updated materialized view
CREATE MATERIALIZED VIEW business_ratings AS
-- Claimed businesses
SELECT
  b.id,
  COALESCE(AVG(r.rating), 0) as avg_rating,
  COUNT(r.id) as review_count
FROM businesses b
LEFT JOIN reviews r ON r.business_id = b.id AND r.review_status = 'approved'
GROUP BY b.id

UNION ALL

-- Unclaimed businesses
SELECT
  ubl.id,
  COALESCE(AVG(r.rating), 0) as avg_rating,
  COUNT(r.id) as review_count
FROM unclaimed_business_locations ubl
LEFT JOIN reviews r ON r.unclaimed_business_id = ubl.id AND r.review_status = 'approved'
GROUP BY ubl.id;

-- Create index on the materialized view
CREATE INDEX IF NOT EXISTS idx_business_ratings_id ON business_ratings(id);
CREATE INDEX IF NOT EXISTS idx_business_ratings_avg_rating ON business_ratings(avg_rating);

-- Add comment
COMMENT ON MATERIALIZED VIEW business_ratings IS 'Precalculated ratings for both claimed and unclaimed businesses';
