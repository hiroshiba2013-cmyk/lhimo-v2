/*
  # Add function to get top business locations
  
  1. New Functions
    - `get_top_business_locations`: Returns the top rated business locations with their average rating and review count
  
  2. Purpose
    - Allows businesses to see the best performing locations on the platform
    - Used in business dashboard to show leaderboard of locations
*/

CREATE OR REPLACE FUNCTION get_top_business_locations(limit_count INT DEFAULT 10)
RETURNS TABLE (
  id uuid,
  name text,
  internal_name text,
  city text,
  province text,
  avg_rating numeric,
  review_count bigint,
  business jsonb
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    bl.id,
    bl.name,
    bl.internal_name,
    bl.city,
    bl.province,
    COALESCE(AVG(r.overall_rating), 0)::numeric AS avg_rating,
    COUNT(r.id) AS review_count,
    jsonb_build_object('name', b.name) AS business
  FROM business_locations bl
  LEFT JOIN businesses b ON bl.business_id = b.id
  LEFT JOIN reviews r ON r.business_location_id = bl.id AND r.review_status = 'approved'
  WHERE bl.is_claimed = true
  GROUP BY bl.id, bl.name, bl.internal_name, bl.city, bl.province, b.name
  HAVING COUNT(r.id) > 0
  ORDER BY avg_rating DESC, review_count DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;