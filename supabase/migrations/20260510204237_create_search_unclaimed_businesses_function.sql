/*
  # Create search_unclaimed_businesses function

  Server-side search for ClaimBusinessPage with proper pagination.
  Searches unclaimed_business_locations by name, province (sigla), city, address.
  Returns total count + paginated results so the frontend can paginate properly.
  SECURITY DEFINER to bypass RLS cleanly for public searches.
*/

-- Returns paginated results
CREATE OR REPLACE FUNCTION search_unclaimed_businesses(
  p_name text DEFAULT NULL,
  p_province text DEFAULT NULL,   -- sigla es. 'VA'
  p_city text DEFAULT NULL,
  p_address text DEFAULT NULL,
  p_page int DEFAULT 1,
  p_page_size int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  street text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  category_id uuid,
  is_claimed boolean,
  added_by uuid,
  total_count bigint
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_offset int := (p_page - 1) * p_page_size;
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    u.name,
    u.street,
    u.city,
    u.province,
    u.region,
    u.postal_code,
    u.phone,
    u.email,
    u.website,
    u.category_id,
    u.is_claimed,
    u.added_by,
    COUNT(*) OVER() AS total_count
  FROM unclaimed_business_locations u
  WHERE
    u.is_claimed = false
    AND u.approval_status = 'approved'
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')
    AND (p_address IS NULL OR p_address = '' OR u.street ILIKE '%' || p_address || '%')
  ORDER BY
    CASE WHEN p_name IS NOT NULL AND p_name != '' THEN
      similarity(u.name, p_name)
    ELSE 0 END DESC,
    u.name ASC
  LIMIT p_page_size
  OFFSET v_offset;
END;
$$;

-- Returns distinct cities for a given province from actual data
CREATE OR REPLACE FUNCTION get_cities_by_province(p_province text)
RETURNS TABLE(city text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT u.city
  FROM unclaimed_business_locations u
  WHERE u.province = p_province
    AND u.is_claimed = false
    AND u.approval_status = 'approved'
    AND u.city IS NOT NULL
    AND u.city != ''
  ORDER BY u.city;
$$;
