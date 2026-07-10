/*
  # Aggiorna funzione get_business_ratings per usare overall_rating

  ## Modifiche
  
  1. Aggiorna la funzione get_business_ratings per:
    - Usare overall_rating invece di rating
    - Calcolare la media basata sul voto finale complessivo
  
  Note:
    - Questo garantisce che il rating medio mostrato corrisponda al voto finale dato dagli utenti
    - Mantiene la retrocompatibilità con recensioni esistenti
*/

-- Aggiorna la funzione per usare overall_rating
CREATE OR REPLACE FUNCTION get_business_ratings(business_ids uuid[])
RETURNS TABLE (
  business_id uuid,
  avg_rating numeric,
  review_count bigint
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    b.id as business_id,
    COALESCE(AVG(r.overall_rating), 0)::numeric as avg_rating,
    COUNT(r.id) as review_count
  FROM unnest(business_ids) AS b(id)
  LEFT JOIN reviews r ON r.business_id = b.id
  GROUP BY b.id;
END;
$$ LANGUAGE plpgsql STABLE;
