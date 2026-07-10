/*
  # Create helper function for fill-empty-comuni edge function

  Returns comuni that have fewer than p_max_count businesses in unclaimed_business_locations,
  ordered by business count ascending so the emptiest comuni come first.
*/

CREATE OR REPLACE FUNCTION get_comuni_with_few_businesses(
  p_max_count integer DEFAULT 5,
  p_limit integer DEFAULT 100
)
RETURNS TABLE(city text, province text, region text, business_count bigint)
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT city, province, region, COUNT(*) as business_count
  FROM unclaimed_business_locations
  WHERE added_by IS NULL AND city IS NOT NULL AND province IS NOT NULL
  GROUP BY city, province, region
  HAVING COUNT(*) < p_max_count
  ORDER BY business_count ASC, city ASC
  LIMIT p_limit;
$$;
