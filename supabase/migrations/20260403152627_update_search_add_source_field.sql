/*
  # Aggiorna funzione di ricerca per includere campo source

  1. Modifiche
    - Aggiunge il campo source alla funzione search_all_business_locations
    - Permette di identificare la provenienza dell'attività (imported, user_added, claimed, self_registered)
    - Questo campo serve per mostrare i badge corretti nel frontend

  2. Badge per tipo
    - imported = Badge viola "Importata"
    - user_added (verificata) = Badge blu "Aggiunta da Utente"
    - claimed = Badge verde "Attività Verificata"
    - self_registered = Badge verde "Attività Iscritta"
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

-- Sedi non rivendicate da database importato (unclaimed_business_locations con source='imported')
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
  END::text as source,
  ubl.created_at
FROM unclaimed_business_locations ubl
WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
  AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
  AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
  AND (search_province IS NULL OR ubl.province = search_province)
  AND (search_region IS NULL OR ubl.region ILIKE search_region)
  AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
  -- Mostra solo le attività importate (senza added_by) o quelle aggiunte da utenti E verificate
  AND (ubl.added_by IS NULL OR ubl.verification_badge = 'verified')
  AND NOT verified_only

UNION ALL

-- Attività registrate da sole (registered_businesses)
SELECT
  rb.id,
  rb.name,
  rb.category_id,
  COALESCE(rb.description, ''),
  rb.address,
  rb.city,
  rb.province,
  rb.region,
  rb.postal_code,
  rb.phone,
  rb.email,
  rb.website,
  rb.business_hours::text,
  rb.latitude,
  rb.longitude,
  'self_registered'::text as location_type,
  COALESCE(rb.is_claimed, false) as is_claimed,
  true as is_verified,
  NULL::uuid as business_id,
  rb.owner_id,
  NULL::uuid as added_by,
  NULL::uuid as added_by_family_member_id,
  'self_registered'::text as source,
  rb.created_at
FROM registered_businesses rb
WHERE rb.owner_id IS NOT NULL
  AND (search_query = '' OR rb.name ILIKE '%' || search_query || '%')
  AND (search_city IS NULL OR LOWER(rb.city) = LOWER(search_city))
  AND (search_province IS NULL OR rb.province = search_province)
  AND (search_region IS NULL OR rb.region ILIKE search_region)
  AND (search_category_id IS NULL OR rb.category_id = search_category_id)

UNION ALL

-- Sedi rivendicate (business_locations) - attività che erano unclaimed e ora sono rivendicate
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
  true as is_verified,
  b.id as business_id,
  b.owner_id,
  NULL::uuid as added_by,
  NULL::uuid as added_by_family_member_id,
  'claimed'::text as source,
  bl.created_at
FROM business_locations bl
INNER JOIN businesses b ON b.id = bl.business_id
WHERE b.owner_id IS NOT NULL
  AND (search_query = '' OR b.name ILIKE '%' || search_query || '%')
  AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
  AND (search_province IS NULL OR bl.province = search_province)
  AND (search_region IS NULL OR bl.region ILIKE search_region)
  AND (search_category_id IS NULL OR b.category_id = search_category_id)

ORDER BY
  -- Prima le attività verificate (iscritte o rivendicate)
  CASE
    WHEN source IN ('self_registered', 'claimed') THEN 1
    WHEN source = 'imported' THEN 2
    WHEN source = 'user_added' THEN 3
    ELSE 4
  END,
  name
LIMIT limit_count;
END;
$$;