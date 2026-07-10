/*
  # Sottrai Punti quando Recensioni vengono Eliminate

  ## Panoramica
  Aggiunge trigger per sottrarre automaticamente i punti dalla classifica quando una recensione viene eliminata.
  - Recensione con prova: 50 punti
  - Recensione senza prova: 25 punti

  ## Modifiche
  1. Crea funzione per sottrarre punti quando una recensione viene eliminata
  2. Crea trigger per recensioni eliminate

  ## Note
  - I punti vengono sottratti automaticamente per mantenere la classifica accurata
  - Controlla se la recensione aveva una prova (proof_url) per determinare i punti da sottrarre
*/

-- Funzione per sottrarre punti quando viene eliminata una recensione
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_review()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
BEGIN
  -- Calcola i punti in base alla presenza di prova
  IF OLD.proof_url IS NOT NULL AND OLD.proof_url != '' THEN
    points_to_subtract := 50;
  ELSE
    points_to_subtract := 25;
  END IF;

  -- Sottrai i punti all'utente che ha scritto la recensione
  PERFORM award_points(OLD.customer_id, -points_to_subtract, 'review_deleted', OLD.id::text);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per recensioni eliminate
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_review ON reviews;
CREATE TRIGGER trigger_subtract_points_deleted_review
  BEFORE DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_review();
