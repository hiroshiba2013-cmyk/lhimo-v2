-- ============================================================
-- FILE: 20260210110649_update_search_function_include_old_tables.sql
-- ============================================================
/*
  # Aggiorna funzione di ricerca per includere vecchie tabelle

  1. Modifiche
    - Aggiorna `search_all_businesses` per cercare anche in `business_locations` rivendicate
    - Aggiunge supporto per filtro `verified_only`
    - Le attività importate non sono considerate verificate
  
  2. Struttura risultati
    - registered_businesses: verificate se verified=true
    - business_locations (vecchie): verificate se is_claimed=true
    - imported_businesses: mai verificate
    - user_added_businesses: verificate se verification_status='verified'
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
    AND (search_city IS NULL OR rbl.city ILIKE search_city)
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
    AND (search_city IS NULL OR bl.city ILIKE search_city)
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
    AND (search_city IS NULL OR ib.city ILIKE search_city)
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
    AND (search_query = '' OR uab.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR uab.city ILIKE search_city)
    AND (search_province IS NULL OR uab.province = search_province)
    AND (search_region IS NULL OR uab.region ILIKE search_region)
    AND (search_category_id IS NULL OR uab.category_id = search_category_id)
    AND (NOT verified_only OR uab.verification_status = 'verified')
  
  ORDER BY name
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ============================================================
-- FILE: 20260210110744_fix_city_search_case_insensitive.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260210110839_update_search_order_verified_first.sql
-- ============================================================
/*
  # Aggiorna ordinamento ricerca - verificate prima

  1. Modifiche
    - Ordina risultati con attività verificate/rivendicate PRIMA
    - Poi ordina per nome alfabetico
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
  SELECT * FROM (
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
  ) combined_results
  ORDER BY is_verified DESC, name
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ============================================================
-- FILE: 20260210110922_fix_search_function_remove_wrapper.sql
-- ============================================================
/*
  # Fix funzione ricerca - rimuove wrapper subquery

  1. Modifiche
    - Rimuove subquery wrapper che potrebbe causare problemi
    - Applica ORDER BY direttamente sui risultati UNION
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
    'registered'::text as business_type,
    (SELECT COUNT(*) > 1 FROM registered_business_locations WHERE business_id = rb.id) as has_multiple_locations,
    rb.verified as is_verified,
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
    AND (search_query = '' OR uab.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(uab.city) = LOWER(search_city))
    AND (search_province IS NULL OR uab.province = search_province)
    AND (search_region IS NULL OR uab.region ILIKE search_region)
    AND (search_category_id IS NULL OR uab.category_id = search_category_id)
    AND (NOT verified_only OR uab.verification_status = 'verified')
  
  ORDER BY is_verified DESC, name
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ============================================================
-- FILE: 20260210142120_fix_incorrect_claimed_businesses.sql
-- ============================================================
/*
  # Fix Incorrect Claimed Businesses
  
  ## Problema Risolto
  Una migrazione precedente aveva erroneamente marcato tutte le businesses come rivendicate (is_claimed = true),
  anche se non avevano un proprietario (owner_id = NULL). Questo ha causato confusione nel sistema.
  
  ## Modifiche
  1. Correzione Dati
    - Imposta is_claimed = false per tutte le businesses senza owner_id
    - Rimuove claimed_at per businesses non rivendicate
    - Rimuove verification_badge per businesses non rivendicate
  
  2. Regola di Integrità
    - Una business può essere is_claimed = true SOLO se ha un owner_id
    - Aggiunge un constraint per garantire questa regola
  
  ## Nota di Sicurezza
  Questo fix garantisce che solo le attività effettivamente rivendicate da un utente
  siano marcate come tali nel sistema.
*/

-- Correggi le businesses erroneamente marcate come rivendicate
UPDATE businesses
SET 
  is_claimed = false,
  claimed_at = NULL,
  verification_badge = NULL
WHERE owner_id IS NULL AND is_claimed = true;

-- Aggiungi un constraint per garantire l'integrità dei dati
-- Una business può essere claimed solo se ha un owner_id
ALTER TABLE businesses
DROP CONSTRAINT IF EXISTS check_claimed_requires_owner;

ALTER TABLE businesses
ADD CONSTRAINT check_claimed_requires_owner 
CHECK (
  (is_claimed = false OR is_claimed IS NULL) OR 
  (is_claimed = true AND owner_id IS NOT NULL)
);

-- Aggiorna il trigger per rispettare questa regola
CREATE OR REPLACE FUNCTION set_business_claimed_at()
RETURNS TRIGGER AS $$
BEGIN
  -- Imposta claimed_at solo se is_claimed = true E owner_id non è NULL
  IF NEW.is_claimed = true AND NEW.owner_id IS NOT NULL AND NEW.claimed_at IS NULL THEN
    NEW.claimed_at := now();
  END IF;
  
  -- Rimuovi claimed_at se is_claimed = false o owner_id è NULL
  IF NEW.is_claimed = false OR NEW.owner_id IS NULL THEN
    NEW.claimed_at := NULL;
    NEW.verification_badge := NULL;
  END IF;
  
  -- Imposta verification_badge solo se is_claimed = true E owner_id non è NULL
  IF NEW.is_claimed = true AND NEW.owner_id IS NOT NULL AND NEW.verification_badge IS NULL THEN
    NEW.verification_badge := CASE 
      WHEN NEW.verified = true THEN 'verified'
      ELSE 'claimed'
    END;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crea un indice per velocizzare le query sulle businesses rivendicate
CREATE INDEX IF NOT EXISTS idx_businesses_owner_claimed 
ON businesses(owner_id, is_claimed) 
WHERE owner_id IS NOT NULL AND is_claimed = true;

-- Commento sulla tabella per documentare la regola
COMMENT ON CONSTRAINT check_claimed_requires_owner ON businesses IS 
'Garantisce che una business possa essere marcata come rivendicata (is_claimed=true) solo se ha un proprietario (owner_id NOT NULL)';


