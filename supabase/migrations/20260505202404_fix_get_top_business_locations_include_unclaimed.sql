/*
  # Fix get_top_business_locations to include unclaimed businesses

  The function previously only returned claimed business_locations joined with reviews
  via business_location_id. However, all current approved reviews are linked to
  unclaimed_business_locations via unclaimed_business_location_id.

  This fix rebuilds the function as a UNION of:
  1. Claimed business_locations with reviews on business_location_id
  2. Unclaimed business_locations with reviews on unclaimed_business_location_id
*/

CREATE OR REPLACE FUNCTION public.get_top_business_locations(limit_count integer DEFAULT 10)
RETURNS TABLE(
  id uuid,
  name text,
  internal_name text,
  city text,
  province text,
  avg_rating numeric,
  review_count bigint,
  business jsonb
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    src.id,
    src.name,
    src.internal_name,
    src.city,
    src.province,
    COALESCE(AVG(r.overall_rating), 0)::numeric AS avg_rating,
    COUNT(r.id) AS review_count,
    src.business
  FROM (
    -- Claimed business locations
    SELECT
      bl.id,
      bl.name,
      bl.internal_name,
      bl.city,
      bl.province,
      jsonb_build_object('name', b.name) AS business,
      'claimed' AS source_type
    FROM business_locations bl
    LEFT JOIN businesses b ON bl.business_id = b.id
    WHERE bl.is_claimed = true

    UNION ALL

    -- Unclaimed business locations
    SELECT
      ubl.id,
      ubl.name,
      NULL AS internal_name,
      ubl.city,
      ubl.province,
      jsonb_build_object('name', ubl.name) AS business,
      'unclaimed' AS source_type
    FROM unclaimed_business_locations ubl
  ) src
  LEFT JOIN reviews r ON (
    (src.source_type = 'claimed' AND r.business_location_id = src.id)
    OR
    (src.source_type = 'unclaimed' AND r.unclaimed_business_location_id = src.id)
  )
  AND r.review_status = 'approved'
  GROUP BY src.id, src.name, src.internal_name, src.city, src.province, src.business
  HAVING COUNT(r.id) > 0
  ORDER BY avg_rating DESC, review_count DESC
  LIMIT limit_count;
END;
$$;
