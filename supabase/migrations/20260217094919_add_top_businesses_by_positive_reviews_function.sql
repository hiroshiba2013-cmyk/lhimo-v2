/*
  # Funzione per Recuperare Attività con Più Recensioni Positive

  1. Nuova Funzione
    - `get_top_businesses_by_positive_reviews(limit_count)` ritorna le attività con più recensioni positive
    - Considera "positive" le recensioni con overall_rating >= 4
    - Ordina per numero di recensioni positive (discendente)
    - Include anche il rating medio e il totale recensioni
  
  2. Utilizzo
    - Nella homepage per mostrare "Attività in Evidenza"
    - Mostra le attività locali che hanno ricevuto più feedback positivi
  
  3. Performance
    - Utilizza indici esistenti su reviews(business_location_id, overall_rating)
    - Filtra solo recensioni approvate
*/

-- Crea la funzione per ottenere le attività con più recensioni positive
CREATE OR REPLACE FUNCTION get_top_businesses_by_positive_reviews(
  limit_count INTEGER DEFAULT 8
)
RETURNS TABLE (
  business_id uuid,
  business_name text,
  category_id uuid,
  category_name text,
  city text,
  province text,
  region text,
  address text,
  avatar_url text,
  positive_review_count bigint,
  total_review_count bigint,
  avg_rating numeric
)
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
  RETURN QUERY
  WITH positive_reviews AS (
    -- Conta le recensioni positive (rating >= 4) per ogni business_location_id
    SELECT 
      COALESCE(r.business_location_id, r.unclaimed_business_location_id) as location_id,
      COUNT(*) FILTER (WHERE r.overall_rating >= 4) as positive_count,
      COUNT(*) as total_count,
      AVG(r.overall_rating) as avg_rating
    FROM reviews r
    WHERE r.review_status = 'approved'
    GROUP BY COALESCE(r.business_location_id, r.unclaimed_business_location_id)
    HAVING COUNT(*) FILTER (WHERE r.overall_rating >= 4) > 0
  ),
  -- Prendi dalle business_locations (attività verificate)
  verified_businesses AS (
    SELECT 
      bl.business_id,
      b.name as business_name,
      b.category_id,
      bc.name as category_name,
      bl.city,
      bl.province,
      bl.region,
      bl.address,
      bl.avatar_url,
      pr.positive_count,
      pr.total_count,
      pr.avg_rating
    FROM business_locations bl
    JOIN businesses b ON b.id = bl.business_id
    LEFT JOIN business_categories bc ON bc.id = b.category_id
    JOIN positive_reviews pr ON pr.location_id = bl.id
    WHERE b.is_claimed = true
  ),
  -- Prendi dalle unclaimed_business_locations (attività non verificate)
  unverified_businesses AS (
    SELECT 
      ubl.id as business_id,
      ubl.name as business_name,
      ubl.category_id,
      bc.name as category_name,
      ubl.city,
      ubl.province,
      ubl.region,
      ubl.address,
      ubl.avatar_url,
      pr.positive_count,
      pr.total_count,
      pr.avg_rating
    FROM unclaimed_business_locations ubl
    LEFT JOIN business_categories bc ON bc.id = ubl.category_id
    JOIN positive_reviews pr ON pr.location_id = ubl.id
  ),
  -- Unisci entrambe le fonti
  all_businesses AS (
    SELECT * FROM verified_businesses
    UNION ALL
    SELECT * FROM unverified_businesses
  )
  -- Seleziona e ordina per recensioni positive
  SELECT 
    ab.business_id,
    ab.business_name,
    ab.category_id,
    ab.category_name,
    ab.city,
    ab.province,
    ab.region,
    ab.address,
    ab.avatar_url,
    ab.positive_count as positive_review_count,
    ab.total_count as total_review_count,
    ROUND(ab.avg_rating, 1) as avg_rating
  FROM all_businesses ab
  ORDER BY ab.positive_count DESC, ab.avg_rating DESC
  LIMIT limit_count;
END;
$$;

-- Permetti l'esecuzione pubblica (dati già filtrati)
GRANT EXECUTE ON FUNCTION get_top_businesses_by_positive_reviews TO authenticated, anon;

COMMENT ON FUNCTION get_top_businesses_by_positive_reviews IS 
'Ritorna le attività (verificate e non) con il maggior numero di recensioni positive (rating >= 4). 
Include sia business_locations che unclaimed_business_locations.';
