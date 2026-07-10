/*
  # Aggiunta valutazioni dettagliate alle recensioni

  ## Modifiche
  
  1. Aggiunte nuove colonne alla tabella reviews:
    - `price_rating` (integer, 1-5): Valutazione del prezzo
    - `service_rating` (integer, 1-5): Valutazione del servizio
    - `quality_rating` (integer, 1-5): Valutazione della qualità
    - `overall_rating` (integer, 1-5): Voto finale complessivo
  
  2. Note:
    - Il campo `rating` esistente viene mantenuto per compatibilità con recensioni esistenti
    - I nuovi campi sono NOT NULL per garantire valutazioni complete
    - Viene aggiunto un constraint per verificare che i voti siano tra 1 e 5
    - Per le recensioni esistenti, impostiamo i nuovi campi uguali al rating esistente
  
  ## Scala valutazioni
  - 1 stella = Pessimo
  - 2 stelle = Discreto
  - 3 stelle = Buono
  - 4 stelle = Eccellente
  - 5 stelle = Ottimo
*/

-- Aggiungi i nuovi campi per le valutazioni dettagliate
DO $$
BEGIN
  -- Price rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'price_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN price_rating integer;
  END IF;

  -- Service rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'service_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN service_rating integer;
  END IF;

  -- Quality rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'quality_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN quality_rating integer;
  END IF;

  -- Overall rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'overall_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN overall_rating integer;
  END IF;
END $$;

-- Imposta i valori per le recensioni esistenti (usa il rating esistente)
UPDATE reviews 
SET 
  price_rating = rating,
  service_rating = rating,
  quality_rating = rating,
  overall_rating = rating
WHERE price_rating IS NULL;

-- Rendi i campi NOT NULL
ALTER TABLE reviews 
  ALTER COLUMN price_rating SET NOT NULL,
  ALTER COLUMN service_rating SET NOT NULL,
  ALTER COLUMN quality_rating SET NOT NULL,
  ALTER COLUMN overall_rating SET NOT NULL;

-- Aggiungi constraint per verificare che i voti siano tra 1 e 5
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_price_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_price_rating_check 
      CHECK (price_rating >= 1 AND price_rating <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_service_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_service_rating_check 
      CHECK (service_rating >= 1 AND service_rating <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_quality_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_quality_rating_check 
      CHECK (quality_rating >= 1 AND quality_rating <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_overall_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_overall_rating_check 
      CHECK (overall_rating >= 1 AND overall_rating <= 5);
  END IF;
END $$;
