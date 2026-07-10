-- ============================================================
-- FILE: 20260326161113_add_services_description_to_registered_locations.sql
-- ============================================================
/*
  # Add services_description to registered_business_locations

  1. Changes
    - Add `services_description` text field to `registered_business_locations` table
    - This field stores a free-form text description of services offered at each location
    - Similar to the description field, but specifically for services

  2. Notes
    - Field is nullable to support existing locations
    - Stored as plain text for maximum flexibility
    - Can be edited by business owners and admins
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_business_locations' AND column_name = 'services_description'
  ) THEN
    ALTER TABLE registered_business_locations 
    ADD COLUMN services_description text;
  END IF;
END $$;

COMMENT ON COLUMN registered_business_locations.services_description IS 'Free-form text description of services offered at this location';


-- ============================================================
-- FILE: 20260328221103_fix_registered_businesses_rls_policies.sql
-- ============================================================
/*
  # Fix Registered Businesses RLS Policies

  1. Changes
    - Drop and recreate policies for registered_businesses with separate SELECT, INSERT, UPDATE, DELETE
    - Ensure business owners can update their own businesses
    - Ensure admins can manage all businesses

  2. Security
    - Business owners can only modify their own businesses
    - Admins can modify any business
    - Anyone can view registered businesses
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Business owners can manage their businesses" ON registered_businesses;
DROP POLICY IF EXISTS "Anyone can view registered businesses" ON registered_businesses;
DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;

-- Create separate policies for better clarity and control
CREATE POLICY "Anyone can view registered businesses"
  ON registered_businesses FOR SELECT
  USING (true);

CREATE POLICY "Business owners can insert their businesses"
  ON registered_businesses FOR INSERT TO authenticated
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Business owners can update their businesses"
  ON registered_businesses FOR UPDATE TO authenticated
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Business owners can delete their businesses"
  ON registered_businesses FOR DELETE TO authenticated
  USING (owner_id = auth.uid());

-- Admin policies
CREATE POLICY "Admins can insert any business"
  ON registered_businesses FOR INSERT TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update any business"
  ON registered_businesses FOR UPDATE TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete any business"
  ON registered_businesses FOR DELETE TO authenticated
  USING (is_admin());


-- ============================================================
-- FILE: 20260328223444_add_billing_address_to_registered_businesses.sql
-- ============================================================
/*
  # Add billing_address column to registered_businesses

  1. Changes
    - Add `billing_address` column (text, nullable)
    - Add trigger to auto-update when billing address fields change
    
  2. Notes
    - billing_address = concatenation of billing street + number + postal code + city + province
    - Auto-updates via trigger on INSERT/UPDATE
*/

-- Add column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'billing_address'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN billing_address text;
  END IF;
END $$;

-- Create function to update billing_address
CREATE OR REPLACE FUNCTION update_registered_business_billing_address()
RETURNS TRIGGER AS $$
BEGIN
  NEW.billing_address := CASE 
    WHEN NEW.billing_street IS NOT NULL THEN
      CONCAT_WS(', ',
        CONCAT_WS(' ', NEW.billing_street, NEW.billing_street_number),
        NEW.billing_postal_code,
        NEW.billing_city,
        UPPER(NEW.billing_province)
      )
    ELSE NULL
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS update_registered_business_billing_address_trigger ON registered_businesses;
CREATE TRIGGER update_registered_business_billing_address_trigger
  BEFORE INSERT OR UPDATE ON registered_businesses
  FOR EACH ROW
  EXECUTE FUNCTION update_registered_business_billing_address();

-- Update existing rows
UPDATE registered_businesses
SET billing_street = billing_street
WHERE billing_street IS NOT NULL;


-- ============================================================
-- FILE: 20260328223508_add_missing_fields_to_registered_businesses.sql
-- ============================================================
/*
  # Add missing fields to registered_businesses

  1. Changes
    - Add `phone` column (business phone number)
    - Add `office_street`, `office_street_number`, `office_postal_code`, `office_city`, `office_province` columns
    - Add `office_address` column (concatenated office address)
    - Add trigger to auto-update office_address
    
  2. Notes
    - These fields match the business registration form
    - office_address is auto-generated from office address components
*/

-- Add phone column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'phone'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN phone text;
  END IF;
END $$;

-- Add office address columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_street'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_street text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_street_number'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_street_number text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_postal_code'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_postal_code text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_city'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_city text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_province'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_province text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_address'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_address text;
  END IF;
END $$;

-- Update trigger function to include office_address
CREATE OR REPLACE FUNCTION update_registered_business_billing_address()
RETURNS TRIGGER AS $$
BEGIN
  -- Update billing_address
  NEW.billing_address := CASE 
    WHEN NEW.billing_street IS NOT NULL THEN
      CONCAT_WS(', ',
        CONCAT_WS(' ', NEW.billing_street, NEW.billing_street_number),
        NEW.billing_postal_code,
        NEW.billing_city,
        UPPER(NEW.billing_province)
      )
    ELSE NULL
  END;

  -- Update office_address
  NEW.office_address := CASE 
    WHEN NEW.office_street IS NOT NULL THEN
      CONCAT_WS(', ',
        CONCAT_WS(' ', NEW.office_street, NEW.office_street_number),
        NEW.office_postal_code,
        NEW.office_city,
        UPPER(NEW.office_province)
      )
    ELSE NULL
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger already exists, no need to recreate


-- ============================================================
-- FILE: 20260403152627_update_search_add_source_field.sql
-- ============================================================
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

-- ============================================================
-- FILE: 20260404212143_update_search_all_businesses_wrapper.sql
-- ============================================================
/*
  # Aggiorna la funzione wrapper search_all_businesses
  
  1. Modifiche
    - Aggiorna search_all_businesses per chiamare la nuova versione di search_all_business_locations
    - Include il nuovo campo 'source' nel tipo di ritorno
    - Include i campi added_by e added_by_family_member_id
  
  2. Dettagli
    - Questa funzione è un wrapper che chiama search_all_business_locations
    - Deve avere la stessa firma della funzione principale
    - Include tutte le tre fonti: unclaimed, registered, claimed
*/

DROP FUNCTION IF EXISTS search_all_businesses(text, text, text, text, uuid, boolean, integer);

CREATE OR REPLACE FUNCTION search_all_businesses(
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
$$;


-- ============================================================
-- FILE: 20260404212716_fix_search_function_registered_businesses_columns.sql
-- ============================================================
/*
  # Fix funzione di ricerca per registered_businesses
  
  1. Problema
    - La tabella registered_businesses ha colonne diverse dalle altre
    - Usa office_* invece di address, city, province, region
    - Usa billing_city invece di city per la ricerca
  
  2. Soluzione
    - Aggiorna la funzione search_all_business_locations per usare le colonne corrette
    - Usa office_city e billing_city per la ricerca geografica
    - Combina office_street e office_street_number per l'address
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
  COALESCE(rb.office_address, rb.office_street || ' ' || COALESCE(rb.office_street_number, ''), ''),
  COALESCE(rb.office_city, rb.billing_city, ''),
  COALESCE(rb.office_province, rb.billing_province, ''),
  ''::text as region, -- Non abbiamo region in registered_businesses
  COALESCE(rb.office_postal_code, rb.billing_postal_code, ''),
  rb.phone,
  rb.pec_email,
  rb.website,
  NULL::text as business_hours,
  NULL::numeric as latitude,
  NULL::numeric as longitude,
  'self_registered'::text as location_type,
  false as is_claimed,
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
  AND (search_city IS NULL OR 
       LOWER(COALESCE(rb.office_city, rb.billing_city, '')) = LOWER(search_city))
  AND (search_province IS NULL OR 
       COALESCE(rb.office_province, rb.billing_province) = search_province)
  AND (search_region IS NULL) -- Non possiamo filtrare per region
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


