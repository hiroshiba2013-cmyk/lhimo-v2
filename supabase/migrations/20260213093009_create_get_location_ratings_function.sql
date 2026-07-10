/*
  # Create get_location_ratings function
  
  1. New Function
    - get_location_ratings: Returns ratings for business locations or unclaimed business locations
  
  2. Purpose
    - Handles both claimed business locations and unclaimed business locations
    - Returns aggregated ratings from reviews table
  
  3. Notes
    - For claimed business locations: joins using business_location_id in reviews
    - For unclaimed business locations: joins using unclaimed_business_id in reviews
*/

CREATE OR REPLACE FUNCTION get_location_ratings(location_ids uuid[])
RETURNS TABLE (
  id uuid,
  avg_rating numeric,
  review_count bigint
)
AS $$
BEGIN
  RETURN QUERY
  WITH location_reviews AS (
    -- Get reviews for business locations
    SELECT
      bl.id as location_id,
      r.overall_rating
    FROM unnest(location_ids) AS loc(id)
    LEFT JOIN business_locations bl ON bl.id = loc.id
    LEFT JOIN reviews r ON r.business_location_id = bl.id AND r.review_status = 'approved'
    
    UNION ALL
    
    -- Get reviews for unclaimed business locations
    SELECT
      ubl.id as location_id,
      r.overall_rating
    FROM unnest(location_ids) AS loc(id)
    LEFT JOIN unclaimed_business_locations ubl ON ubl.id = loc.id
    LEFT JOIN reviews r ON r.unclaimed_business_id = ubl.id AND r.review_status = 'approved'
  )
  SELECT
    location_id as id,
    COALESCE(AVG(overall_rating), 0)::numeric as avg_rating,
    COUNT(overall_rating) as review_count
  FROM location_reviews
  GROUP BY location_id;
END;
$$ LANGUAGE plpgsql STABLE;
