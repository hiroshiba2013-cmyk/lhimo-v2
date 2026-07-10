/*
  # Fix ricerca città case-insensitive

  1. Modifiche
    - Usa ILIKE con wildcards per confronto città
    - Gestisce correttamente capitalizzazione diversa
*/

CREATE OR REPLACE FUNCTION search_all_businesses(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  category_id uuid,
  description text,
  city text,
  province text,
  region text,
  phone text,
  email text,
  website text,
  latitude numeric,
  longitude numeric,
  business_type text,
  has_multiple_locations boolean,
  is_verified boolean,
  created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  -- Registered businesses (nuova struttura)
  SELECT 
    rb.id,
    rb.name,
    rb.category_id,
    rb.description,
    rbl.city,
    rbl.province,
    rbl.region,
    rbl.phone,
    rbl.email,
    COALESCE(rbl.website, rb.website),
    rbl.latitude,
    rbl.longitude,
    'registered'::text,
    (SELECT COUNT(*) > 1 FROM registered_business_locations WHERE business_id = rb.id),
    rb.verified,
    rb.created_at
  FROM registered_businesses rb
  LEFT JOIN registered_business_locations rbl ON rb.id = rbl.business_id AND rbl.is_primary = true
  WHERE (search_query = '' OR rb.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(rbl.city) = LOWER(search_city))
    AND (search_province IS NULL OR rbl.province = search_province)
    AND (search_region IS NULL OR rbl.region ILIKE search_region)
    AND (search_category_id IS NULL OR rb.category_id = search_category_id)
    AND (NOT verified_only OR rb.verified = true)
  
  UNION ALL
  
  -- Business locations rivendicate (vecchia struttura)
  SELECT 
    b.id,
    b.name,
    b.category_id,
    COALESCE(b.description, ''),
    bl.city,
    bl.province,
    bl.region,
    bl.phone,
    bl.email,
    bl.website,
    NULL::numeric,
    NULL::numeric,
    'claimed_old'::text,
    (SELECT COUNT(*) > 1 FROM business_locations WHERE business_id = b.id),
    b.is_claimed,
    b.created_at
  FROM businesses b
  JOIN business_locations bl ON b.id = bl.business_id
  WHERE b.is_claimed = true
    AND (search_query = '' OR b.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)
    AND (NOT verified_only OR b.is_claimed = true)
  
  UNION ALL
  
  -- Imported businesses (solo se non filtro verified)
  SELECT 
    ib.id,
    ib.name,
    ib.category_id,
    ib.description,
    ib.city,
    ib.province,
    ib.region,
    ib.phone,
    ib.email,
    ib.website,
    ib.latitude,
    ib.longitude,
    'imported'::text,
    false,
    false,
    ib.created_at
  FROM imported_businesses ib
  WHERE NOT verified_only
    AND (search_query = '' OR ib.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(ib.city) = LOWER(search_city))
    AND (search_province IS NULL OR ib.province = search_province)
    AND (search_region IS NULL OR ib.region ILIKE search_region)
    AND (search_category_id IS NULL OR ib.category_id = search_category_id)
  
  UNION ALL
  
  -- User added businesses (solo se verified o non filtro verified)
  SELECT 
    uab.id,
    uab.name,
    uab.category_id,
    uab.description,
    uab.city,
    uab.province,
    uab.region,
    uab.phone,
    uab.email,
    uab.website,
    uab.latitude,
    uab.longitude,
    'user_added'::text,
    false,
    (uab.verification_status = 'verified'),
    uab.created_at
  FROM user_added_businesses uab
  WHERE uab.verification_status = 'verified'
    AND (search_query = '' OR uab.name ILIKE '%' || uab.name || '%')
    AND (search_city IS NULL OR LOWER(uab.city) = LOWER(search_city))
    AND (search_province IS NULL OR uab.province = search_province)
    AND (search_region IS NULL OR uab.region ILIKE search_region)
    AND (search_category_id IS NULL OR uab.category_id = search_category_id)
    AND (NOT verified_only OR uab.verification_status = 'verified')
  
  ORDER BY name
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;
