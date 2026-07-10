/*
  # Create search_business_tracking function

  Single server-side function for the admin "Verifica Attività" section.
  Accepts filters: type, province_code, city, region, name_search.
  Returns unified results from unclaimed_business_locations + registered_businesses.
  Runs as SECURITY DEFINER so admin RLS is bypassed cleanly.
*/

CREATE OR REPLACE FUNCTION search_business_tracking(
  p_type text DEFAULT 'all',           -- 'all','claimed','user_added','imported','registered'
  p_province text DEFAULT NULL,        -- sigla es. 'VA'
  p_city text DEFAULT NULL,            -- partial match
  p_region text DEFAULT NULL,
  p_name text DEFAULT NULL,            -- partial match
  p_limit int DEFAULT 300
)
RETURNS TABLE (
  id uuid,
  name text,
  city text,
  province text,
  region text,
  street text,
  type text,
  created_at timestamptz,
  verified boolean,
  approval_status text,
  category_name text,
  owner_name text,
  owner_email text,
  added_by_name text,
  added_by_email text
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  -- unclaimed: user_added
  SELECT
    u.id,
    u.name,
    u.city,
    u.province,
    u.region,
    u.street,
    'user_added'::text AS type,
    u.created_at,
    NULL::boolean AS verified,
    u.approval_status,
    bc.name AS category_name,
    p.full_name AS owner_name,
    p.email AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM unclaimed_business_locations u
  LEFT JOIN business_categories bc ON bc.id = u.category_id
  LEFT JOIN profiles p ON p.id = u.added_by
  WHERE
    (p_type = 'all' OR p_type = 'user_added')
    AND u.added_by IS NOT NULL
    AND u.claimed_by IS NULL
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_region IS NULL OR p_region = '' OR u.region = p_region)
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')

  UNION ALL

  -- unclaimed: imported
  SELECT
    u.id,
    u.name,
    u.city,
    u.province,
    u.region,
    u.street,
    'imported'::text AS type,
    u.created_at,
    NULL::boolean AS verified,
    u.approval_status,
    bc.name AS category_name,
    NULL::text AS owner_name,
    NULL::text AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM unclaimed_business_locations u
  LEFT JOIN business_categories bc ON bc.id = u.category_id
  WHERE
    (p_type = 'all' OR p_type = 'imported')
    AND u.added_by IS NULL
    AND u.claimed_by IS NULL
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_region IS NULL OR p_region = '' OR u.region = p_region)
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')

  UNION ALL

  -- unclaimed: claimed
  SELECT
    u.id,
    u.name,
    u.city,
    u.province,
    u.region,
    u.street,
    'claimed'::text AS type,
    u.created_at,
    NULL::boolean AS verified,
    u.approval_status,
    bc.name AS category_name,
    p.full_name AS owner_name,
    p.email AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM unclaimed_business_locations u
  LEFT JOIN business_categories bc ON bc.id = u.category_id
  LEFT JOIN profiles p ON p.id = u.claimed_by
  WHERE
    (p_type = 'all' OR p_type = 'claimed')
    AND u.claimed_by IS NOT NULL
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_region IS NULL OR p_region = '' OR u.region = p_region)
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')

  UNION ALL

  -- registered businesses
  SELECT
    rb.id,
    rb.name,
    COALESCE(rb.office_city, rb.billing_city, '') AS city,
    COALESCE(rb.office_province, rb.billing_province, '') AS province,
    NULL::text AS region,
    COALESCE(rb.office_street, rb.billing_street, '') AS street,
    'registered'::text AS type,
    rb.created_at,
    rb.verified,
    NULL::text AS approval_status,
    bc.name AS category_name,
    p.full_name AS owner_name,
    p.email AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM registered_businesses rb
  LEFT JOIN business_categories bc ON bc.id = rb.category_id
  LEFT JOIN profiles p ON p.id = rb.owner_id
  WHERE
    (p_type = 'all' OR p_type = 'registered')
    AND (p_province IS NULL OR p_province = '' OR rb.office_province = p_province OR rb.billing_province = p_province)
    AND (p_city IS NULL OR p_city = '' OR rb.office_city ILIKE '%' || p_city || '%' OR rb.billing_city ILIKE '%' || p_city || '%')
    AND (p_name IS NULL OR p_name = '' OR rb.name ILIKE '%' || p_name || '%')

  ORDER BY created_at DESC
  LIMIT p_limit;
END;
$$;
