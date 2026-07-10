/*
  # Funzione RPC per Recupero Rating Veloce

  1. Nuova Funzione
    - `get_business_ratings` - Recupera rating e conteggio recensioni per una lista di business
    - Usa query aggregata ottimizzata invece di loop separati
    - Restituisce avg_rating e review_count per ogni business_id
    
  2. Performance
    - Una singola query invece di N query separate
    - Usa gli indici esistenti su reviews(business_id)
    - Riduce drasticamente il tempo di risposta (da secondi a millisecondi)
    
  Note:
    - La funzione è pubblica e accessibile da applicazioni frontend
    - Restituisce risultati anche per business senza recensioni (rating = 0)
*/

-- Funzione per ottenere rating di più business in una singola query
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
    COALESCE(AVG(r.rating), 0)::numeric as avg_rating,
    COUNT(r.id) as review_count
  FROM unnest(business_ids) AS b(id)
  LEFT JOIN reviews r ON r.business_id = b.id
  GROUP BY b.id;
END;
$$ LANGUAGE plpgsql STABLE;

-- Permetti l'accesso pubblico alla funzione (necessario per RLS)
GRANT EXECUTE ON FUNCTION get_business_ratings TO anon, authenticated;