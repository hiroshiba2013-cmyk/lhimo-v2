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
