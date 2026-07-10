/*
  # Sistema di Approvazione Recensioni con Prove

  ## Modifiche
  
  1. Aggiunte colonne alla tabella reviews:
    - `proof_image_url` (text): URL dell'immagine di prova (scontrino/fattura)
    - `review_status` (text): Stato della recensione (pending, approved, rejected)
    - `approved_by` (uuid): ID dello staff che ha approvato
    - `approved_at` (timestamp): Data/ora approvazione
    - `points_awarded` (integer): Punti assegnati per questa recensione
  
  2. Rende opzionali i campi price_rating, service_rating, quality_rating
  
  3. Note:
    - Le immagini di prova sono visibili solo allo staff
    - Dopo l'approvazione, le immagini vengono cancellate
    - Sistema di punti:
      * Recensione completa con prova: 25 punti
      * Recensione completa senza prova: 15 punti
      * Recensione solo voto finale: 5 punti
*/

-- Aggiungi nuove colonne per il sistema di approvazione
DO $$
BEGIN
  -- Proof image URL
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'proof_image_url'
  ) THEN
    ALTER TABLE reviews ADD COLUMN proof_image_url text;
  END IF;

  -- Review status
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'review_status'
  ) THEN
    ALTER TABLE reviews ADD COLUMN review_status text DEFAULT 'approved' NOT NULL;
  END IF;

  -- Approved by
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'approved_by'
  ) THEN
    ALTER TABLE reviews ADD COLUMN approved_by uuid REFERENCES profiles(id);
  END IF;

  -- Approved at
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'approved_at'
  ) THEN
    ALTER TABLE reviews ADD COLUMN approved_at timestamptz;
  END IF;

  -- Points awarded
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'points_awarded'
  ) THEN
    ALTER TABLE reviews ADD COLUMN points_awarded integer DEFAULT 0 NOT NULL;
  END IF;
END $$;

-- Rendi opzionali price_rating, service_rating, quality_rating
ALTER TABLE reviews 
  ALTER COLUMN price_rating DROP NOT NULL,
  ALTER COLUMN service_rating DROP NOT NULL,
  ALTER COLUMN quality_rating DROP NOT NULL;

-- Aggiungi constraint per review_status
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_status_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_status_check 
      CHECK (review_status IN ('pending', 'approved', 'rejected'));
  END IF;
END $$;

-- Crea indice per le recensioni in attesa di approvazione
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(review_status) 
  WHERE review_status = 'pending';

-- Aggiorna le recensioni esistenti come approvate
UPDATE reviews 
SET review_status = 'approved', 
    points_awarded = CASE 
      WHEN price_rating IS NOT NULL AND service_rating IS NOT NULL AND quality_rating IS NOT NULL THEN 15
      ELSE 5
    END
WHERE review_status = 'approved' AND points_awarded = 0;

-- Funzione per approvare una recensione
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Ottieni i dettagli della recensione
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Calcola i punti da assegnare
  IF review_record.proof_image_url IS NOT NULL THEN
    -- Con prova
    IF review_record.price_rating IS NOT NULL AND 
       review_record.service_rating IS NOT NULL AND 
       review_record.quality_rating IS NOT NULL THEN
      points_to_award := 25; -- Recensione completa con prova
    ELSE
      points_to_award := 10; -- Solo voto finale con prova
    END IF;
  ELSE
    -- Senza prova
    IF review_record.price_rating IS NOT NULL AND 
       review_record.service_rating IS NOT NULL AND 
       review_record.quality_rating IS NOT NULL THEN
      points_to_award := 15; -- Recensione completa senza prova
    ELSE
      points_to_award := 5; -- Solo voto finale senza prova
    END IF;
  END IF;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Cancella l'immagine dopo l'approvazione
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', review_id_param);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per rifiutare una recensione
CREATE OR REPLACE FUNCTION reject_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
BEGIN
  UPDATE reviews 
  SET review_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      proof_image_url = NULL -- Cancella l'immagine
  WHERE id = review_id_param AND review_status = 'pending';
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata o già processata';
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Permetti accesso alle funzioni
GRANT EXECUTE ON FUNCTION approve_review TO authenticated;
GRANT EXECUTE ON FUNCTION reject_review TO authenticated;

-- Aggiorna la policy per permettere agli utenti di vedere solo le recensioni approvate
-- (eccetto le proprie)
DROP POLICY IF EXISTS "Reviews are viewable by everyone" ON reviews;

CREATE POLICY "Approved reviews are viewable by everyone"
  ON reviews FOR SELECT
  USING (
    review_status = 'approved' OR 
    customer_id = auth.uid()
  );

-- Policy per permettere allo staff di vedere tutte le recensioni
CREATE POLICY "Staff can view all reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.user_type = 'business'
    )
  );
