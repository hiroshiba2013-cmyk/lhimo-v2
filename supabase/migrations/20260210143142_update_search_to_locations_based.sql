/*
  # Aggiorna ricerca per cercare nelle sedi invece che nelle attività
  
  ## Modifica Principale
  La funzione di ricerca ora cerca nelle SEDI (locations) invece che nelle attività (businesses).
  Questo significa che se un'attività ha più sedi, ogni sede apparirà separatamente nei risultati.
  
  ## Tabelle Cercate
  1. `unclaimed_business_locations` - Sedi non rivendicate (29018 sedi)
  2. `business_locations` - Sedi rivendicate (2 sedi)
  3. `user_added_businesses` - Sedi aggiunte dagli utenti (0 attualmente)
  
  ## Return Type
  Ogni risultato rappresenta una SEDE specifica, non un'attività.
  Se un'attività ha 5 sedi, appariranno 5 risultati separati.
*/

-- Drop della vecchia funzione
DROP FUNCTION IF EXISTS search_all_businesses(text, text, text, text, uuid, boolean, int);

-- Nuova funzione che cerca nelle sedi
CREATE OR REPLACE FUNCTION search_all_business_locations(
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
  created_at timestamptz
) AS $$
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
    COALESCE(b.verification_badge = 'verified', false) as is_verified,
    b.id as business_id,
    b.owner_id,
    bl.created_at
  FROM business_locations bl
  INNER JOIN businesses b ON b.id = bl.business_id
  WHERE b.owner_id IS NOT NULL
    AND (search_query = '' OR b.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)
    AND (NOT verified_only OR b.verification_badge = 'verified')
  
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
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Aggiungi commento sulla funzione
COMMENT ON FUNCTION search_all_business_locations IS 
'Cerca nelle SEDI (locations) invece che nelle attività. Ogni sede appare come risultato separato.';

-- Crea alias per retrocompatibilità
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
  created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM search_all_business_locations(
    search_query,
    search_city,
    search_province,
    search_region,
    search_category_id,
    verified_only,
    limit_count
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;
