/*
  # Include attività registrate senza sedi nella ricerca
  
  1. Problema
    - Alcune attività in registered_businesses non hanno ancora sedi
    - Devono comunque apparire nella ricerca
  
  2. Soluzione temporanea
    - Include registered_businesses che non hanno sedi in business_locations
    - Quando creeranno le sedi, queste appariranno invece del record principale
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
  source text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
RETURN QUERY

SELECT * FROM (
  -- Sedi non rivendicate da database importato (unclaimed_business_locations)
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
    (ubl.verification_badge = 'verified') as is_verified,
    NULL::uuid as business_id,
    ubl.claimed_by as owner_id,
    ubl.added_by,
    ubl.added_by_family_member_id,
    CASE
      WHEN ubl.added_by IS NOT NULL THEN 'user_added'
      ELSE 'imported'
    END::text as result_source,
    ubl.created_at
  FROM unclaimed_business_locations ubl
  WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
    AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
    AND (search_province IS NULL OR ubl.province = search_province)
    AND (search_region IS NULL OR ubl.region ILIKE search_region)
    AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
    AND (ubl.added_by IS NULL OR ubl.verification_badge = 'verified')
    AND NOT verified_only

  UNION ALL

  -- Sedi di attività registrate (business_locations)
  SELECT
    bl.id,
    COALESCE(bl.internal_name, b.name) as name,
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
    'registered'::text as location_type,
    true as is_claimed,
    true as is_verified,
    b.id as business_id,
    b.owner_id,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    'registered'::text as result_source,
    bl.created_at
  FROM business_locations bl
  INNER JOIN businesses b ON b.id = bl.business_id
  WHERE b.owner_id IS NOT NULL
    AND (search_query = '' OR COALESCE(bl.internal_name, b.name) ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)
  
  UNION ALL
  
  -- Attività registrate senza sedi (fallback temporaneo)
  -- Queste appariranno SOLO se non hanno ancora creato sedi in business_locations
  SELECT
    rb.id,
    rb.name,
    rb.category_id,
    COALESCE(rb.description, ''),
    COALESCE(rb.office_address, 
             NULLIF(TRIM(COALESCE(rb.office_street, '') || ' ' || COALESCE(rb.office_street_number, '')), ''),
             'Da completare'),
    COALESCE(rb.office_city, rb.billing_city, 'Da completare'),
    COALESCE(rb.office_province, rb.billing_province, ''),
    ''::text as region,
    COALESCE(rb.office_postal_code, rb.billing_postal_code, ''),
    rb.phone,
    rb.pec_email,
    rb.website,
    NULL::text as business_hours,
    NULL::numeric as latitude,
    NULL::numeric as longitude,
    'registered_no_location'::text as location_type,
    true as is_claimed,
    true as is_verified,
    NULL::uuid as business_id,
    rb.owner_id,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    'registered'::text as result_source,
    rb.created_at
  FROM registered_businesses rb
  WHERE rb.owner_id IS NOT NULL
    -- Mostra solo se NON ha sedi in business_locations
    AND NOT EXISTS (
      SELECT 1 FROM business_locations bl
      INNER JOIN businesses b ON b.id = bl.business_id
      WHERE b.owner_id = rb.owner_id
      AND b.name = rb.name
    )
    AND (search_query = '' OR rb.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR 
         LOWER(COALESCE(rb.office_city, rb.billing_city, '')) = LOWER(search_city))
    AND (search_province IS NULL OR 
         COALESCE(rb.office_province, rb.billing_province) = search_province)
    AND (search_region IS NULL)
    AND (search_category_id IS NULL OR rb.category_id = search_category_id)
) all_results
ORDER BY
  CASE
    WHEN all_results.result_source = 'registered' THEN 1
    WHEN all_results.result_source = 'imported' THEN 2
    WHEN all_results.result_source = 'user_added' THEN 3
    ELSE 4
  END,
  all_results.name
LIMIT limit_count;
END;
$$;
