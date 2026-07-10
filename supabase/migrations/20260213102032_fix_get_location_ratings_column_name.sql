/*
  # Fix get_location_ratings function column name
  
  1. Changes
    - Update get_location_ratings function to use correct column name
    - Change `r.unclaimed_business_id` to `r.unclaimed_business_location_id`
  
  2. Notes
    - The reviews table uses `unclaimed_business_location_id` not `unclaimed_business_id`
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
    LEFT JOIN reviews r ON r.unclaimed_business_location_id = ubl.id AND r.review_status = 'approved'
  )
  SELECT
    location_id as id,
    COALESCE(AVG(overall_rating), 0)::numeric as avg_rating,
    COUNT(overall_rating) as review_count
  FROM location_reviews
  GROUP BY location_id;
END;
$$ LANGUAGE plpgsql STABLE;
