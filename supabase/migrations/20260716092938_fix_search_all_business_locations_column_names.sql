-- Fix search_all_business_locations: column names were wrong
-- rb.business_name → rb.name
-- rbl.address → rbl.street
-- Also fix the reviews join: r.status should be r.review_status

CREATE OR REPLACE FUNCTION public.search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false
)
RETURNS TABLE(
  id uuid,
  name text,
  business_name text,
  category_id uuid,
  category_name text,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  latitude numeric,
  longitude numeric,
  avg_rating numeric,
  review_count bigint,
  is_claimed boolean,
  is_verified boolean,
  result_source text,
  added_by uuid,
  added_by_family_member_id uuid,
  owner_id uuid,
  avatar_url text,
  location_type text,
  created_at timestamp with time zone
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
RETURN QUERY
WITH all_results AS (
-- Attività non rivendicate (importate o aggiunte da utenti approvate)
SELECT
ubl.id,
ubl.name,
NULL::text as business_name,
COALESCE(ubl.category_id, fm.category_id, p.category_id) as category_id,
COALESCE(bc.name, bc_fm.name, bc_p.name) as category_name,
COALESCE(ubl.description, '') as description,
COALESCE(ubl.street, '') as address,
ubl.city,
ubl.province,
ubl.region,
ubl.postal_code,
ubl.phone,
ubl.email,
ubl.website,
ubl.latitude,
ubl.longitude,
ubl.added_by,
ubl.added_by_family_member_id,
NULL::uuid as owner_id,
NULL::text as avatar_url,
'unclaimed'::text as location_type,
CASE
WHEN ubl.added_by IS NOT NULL THEN 'user_added'
ELSE 'imported'
END::text as result_source,
ubl.created_at
FROM unclaimed_business_locations ubl
LEFT JOIN business_categories bc ON bc.id = ubl.category_id
LEFT JOIN customer_family_members fm ON fm.id = ubl.added_by_family_member_id
LEFT JOIN business_categories bc_fm ON bc_fm.id = fm.category_id
LEFT JOIN profiles p ON p.id = ubl.added_by
LEFT JOIN business_categories bc_p ON bc_p.id = p.category_id
WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
AND (search_province IS NULL OR ubl.province = search_province)
AND (search_region IS NULL OR ubl.region ILIKE search_region)
AND (search_category_id IS NULL OR COALESCE(ubl.category_id, fm.category_id, p.category_id) = search_category_id)
AND (
ubl.added_by IS NULL
OR ubl.verification_badge = 'verified'
OR ubl.approval_status = 'approved'
)
AND NOT verified_only

UNION ALL

-- Sedi di attività registrate (business_locations - vecchio sistema)
SELECT
bl.id,
COALESCE(bl.internal_name, b.name) as name,
b.name as business_name,
b.category_id,
bc.name as category_name,
COALESCE(bl.description, b.description, ''),
bl.address,
bl.city,
bl.province,
bl.region,
bl.postal_code,
bl.phone,
bl.email,
bl.website,
bl.latitude,
bl.longitude,
NULL::uuid as added_by,
NULL::uuid as added_by_family_member_id,
b.owner_id,
bl.avatar_url,
CASE WHEN b.is_claimed THEN 'claimed' ELSE 'registered' END::text as location_type,
'registered'::text as result_source,
bl.created_at
FROM business_locations bl
JOIN businesses b ON b.id = bl.business_id
LEFT JOIN business_categories bc ON bc.id = b.category_id
WHERE (search_query = '' OR b.name ILIKE '%' || search_query || '%' OR bl.internal_name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
AND (search_province IS NULL OR bl.province = search_province)
AND (search_region IS NULL OR bl.region ILIKE search_region)
AND (search_category_id IS NULL OR b.category_id = search_category_id)
AND (NOT verified_only OR b.is_claimed = true)

UNION ALL

-- Sedi di attività registrate (registered_business_locations - nuovo sistema)
SELECT
rbl.id,
COALESCE(rbl.name, rb.name) as name,
rb.name as business_name,
rbl.category_id,
bc.name as category_name,
COALESCE(rbl.description, '') as description,
COALESCE(rbl.street, '') as address,
COALESCE(rbl.city, '') as city,
COALESCE(rbl.province, '') as province,
COALESCE(rbl.region, '') as region,
rbl.postal_code,
COALESCE(rbl.phone, rb.phone) as phone,
COALESCE(rbl.email, '') as email,
COALESCE(rbl.website, rb.website) as website,
rbl.latitude,
rbl.longitude,
NULL::uuid as added_by,
NULL::uuid as added_by_family_member_id,
rb.owner_id,
rbl.avatar_url,
'registered'::text as location_type,
'registered'::text as result_source,
rbl.created_at
FROM registered_business_locations rbl
JOIN registered_businesses rb ON rb.id = rbl.business_id
LEFT JOIN business_categories bc ON bc.id = rbl.category_id
WHERE (search_query = '' OR rb.name ILIKE '%' || search_query || '%' OR rbl.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(COALESCE(rbl.city, '')) = LOWER(search_city))
AND (search_province IS NULL OR rbl.province = search_province)
AND (search_region IS NULL OR rbl.region ILIKE search_region)
AND (search_category_id IS NULL OR rbl.category_id = search_category_id)
AND (NOT verified_only OR rb.verified = true)
)
SELECT
ar.id,
ar.name,
ar.business_name,
ar.category_id,
ar.category_name,
ar.description,
ar.address,
ar.city,
ar.province,
ar.region,
ar.postal_code,
ar.phone,
ar.email,
ar.website,
ar.latitude,
ar.longitude,
COALESCE(ratings.avg_rating, 0) as avg_rating,
COALESCE(ratings.review_count, 0) as review_count,
CASE WHEN ar.location_type = 'claimed' THEN true ELSE false END as is_claimed,
CASE WHEN ar.location_type IN ('claimed', 'registered') THEN true ELSE false END as is_verified,
ar.result_source,
ar.added_by,
ar.added_by_family_member_id,
ar.owner_id,
ar.avatar_url,
ar.location_type,
ar.created_at
FROM all_results ar
LEFT JOIN LATERAL (
SELECT
ROUND(AVG(r.overall_rating)::numeric, 1) as avg_rating,
COUNT(r.id)::bigint as review_count
FROM reviews r
WHERE r.review_status = 'approved'
AND (
(ar.result_source IN ('imported', 'user_added') AND r.unclaimed_business_location_id = ar.id)
OR (ar.result_source = 'registered' AND ar.location_type = 'claimed' AND r.unclaimed_business_location_id = ar.id)
OR (ar.result_source = 'registered' AND ar.location_type IN ('registered') AND r.registered_business_location_id = ar.id)
)
) ratings ON true
ORDER BY
CASE
WHEN ar.result_source = 'registered' AND ar.location_type = 'claimed' THEN 1
WHEN ar.result_source = 'registered' THEN 2
WHEN ar.result_source = 'user_added' THEN 3
ELSE 4
END,
COALESCE(ratings.review_count, 0) DESC,
ar.created_at DESC;
END;
$function$;
