/*
  # Update get_business_ratings function for unclaimed businesses

  1. Changes
    - Update the function to calculate ratings for unclaimed businesses
    - Join reviews using both business_id and unclaimed_business_id

  2. Notes
    - For unclaimed businesses, we need to look at unclaimed_business_id in reviews table
*/

-- Drop existing function
DROP FUNCTION IF EXISTS get_business_ratings(uuid[]);

-- Create updated function that handles both business types
CREATE OR REPLACE FUNCTION get_business_ratings(business_ids uuid[])
RETURNS TABLE (
  id uuid,
  avg_rating numeric,
  review_count bigint
)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    b.id,
    COALESCE(AVG(r.overall_rating), 0)::numeric as avg_rating,
    COUNT(r.id) as review_count
  FROM unnest(business_ids) AS b(id)
  LEFT JOIN reviews r ON (r.business_id = b.id OR r.unclaimed_business_id = b.id)
  WHERE r.review_status = 'approved' OR r.id IS NULL
  GROUP BY b.id;
END;
$$ LANGUAGE plpgsql STABLE;
