/*
  # Aggiorna funzione di ricerca per includere family_member_id

  1. Modifiche
    - Modifica la funzione search_all_business_locations per includere added_by_family_member_id
    - Permette di mostrare chi (profilo principale o family member) ha aggiunto l'attività
*/

DROP FUNCTION IF EXISTS search_all_business_locations(text, text, text, text, uuid, boolean, integer);

CREATE OR REPLACE FUNCTION search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count integer DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  category_id uuid,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  added_by uuid,
  added_by_family_member_id uuid,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
RETURN QUERY

-- Sedi non rivendicate (unclaimed_business_locations)
SELECT 
  ubl.id,
  ubl.name,
  ubl.category_id,
  COALESCE(ubl.description, ''),
  ubl.street,
  ubl.city,
  ubl.province,
  ubl.region,
  ubl.postal_code,
  ubl.phone,
  ubl.email,
  ubl.website,
  ubl.business_hours,
  ubl.latitude,
  ubl.longitude,
  'unclaimed'::text as location_type,
  COALESCE(ubl.is_claimed, false) as is_claimed,
  false as is_verified,
  NULL::uuid as business_id,
  ubl.claimed_by as owner_id,
  ubl.added_by,
  ubl.added_by_family_member_id,
  ubl.created_at
FROM unclaimed_business_locations ubl
WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
  AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
  AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
  AND (search_province IS NULL OR ubl.province = search_province)
  AND (search_region IS NULL OR ubl.region ILIKE search_region)
  AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
  AND NOT verified_only

UNION ALL

-- Sedi rivendicate (business_locations)
SELECT 
  bl.id,
  b.name,
  b.category_id,
  COALESCE(bl.description, b.description, ''),
  bl.address,
  bl.city,
  bl.province,
  bl.region,
  bl.postal_code,
  bl.phone,
  bl.email,
  bl.website,
  bl.business_hours::text,
  bl.latitude,
  bl.longitude,
  'claimed'::text as location_type,
  true as is_claimed,
  COALESCE(b.verification_badge IN ('verified', 'claimed'), false) as is_verified,
  b.id as business_id,
  b.owner_id,
  NULL::uuid as added_by,
  NULL::uuid as added_by_family_member_id,
  bl.created_at
FROM business_locations bl
INNER JOIN businesses b ON b.id = bl.business_id
WHERE b.owner_id IS NOT NULL
  AND (search_query = '' OR b.name ILIKE '%' || search_query || '%')
  AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
  AND (search_province IS NULL OR bl.province = search_province)
  AND (search_region IS NULL OR bl.region ILIKE search_region)
  AND (search_category_id IS NULL OR b.category_id = search_category_id)
  AND (NOT verified_only OR b.verification_badge IN ('verified', 'claimed'))

UNION ALL

-- Sedi aggiunte dagli utenti (user_added_businesses)
SELECT 
  uab.id,
  uab.name,
  uab.category_id,
  COALESCE(uab.description, ''),
  uab.street,
  uab.city,
  uab.province,
  uab.region,
  uab.postal_code,
  uab.phone,
  uab.email,
  uab.website,
  NULL::text as business_hours,
  uab.latitude,
  uab.longitude,
  'user_added'::text as location_type,
  false as is_claimed,
  (uab.verification_status = 'verified') as is_verified,
  NULL::uuid as business_id,
  uab.added_by as owner_id,
  uab.added_by,
  NULL::uuid as added_by_family_member_id,
  uab.created_at
FROM user_added_businesses uab
WHERE (search_query = '' OR uab.name ILIKE '%' || search_query || '%')
  AND (search_city IS NULL OR LOWER(uab.city) = LOWER(search_city))
  AND (search_province IS NULL OR uab.province = search_province)
  AND (search_region IS NULL OR uab.region ILIKE search_region)
  AND (search_category_id IS NULL OR uab.category_id = search_category_id)
  AND (NOT verified_only OR uab.verification_status = 'verified')

ORDER BY is_verified DESC, is_claimed DESC, name
LIMIT limit_count;
END;
$$;
