/*
  # Sottrai Punti quando Annunci di Lavoro vengono Eliminati

  ## Panoramica
  Aggiunge trigger per sottrarre automaticamente i punti dalla classifica quando un annuncio di lavoro viene eliminato.
  Gli annunci di lavoro assegnano 3 punti alla creazione.

  ## Modifiche
  1. Crea funzione per sottrarre punti quando un annuncio di lavoro viene eliminato
  2. Crea trigger per annunci di lavoro eliminati

  ## Note
  - I punti vengono sottratti automaticamente per mantenere la classifica accurata
  - Gli annunci di lavoro danno 3 punti, quindi vengono sottratti 3 punti
*/

-- Funzione per sottrarre punti quando viene eliminato un annuncio di lavoro
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'ID del proprietario dalla business location
  SELECT owner_id INTO v_owner_id
  FROM business_locations
  WHERE id = OLD.business_location_id;

  -- Sottrai 3 punti al proprietario dell'attività
  IF v_owner_id IS NOT NULL THEN
    PERFORM award_points(v_owner_id, -3, 'job_posting_deleted', OLD.id::text);
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per annunci di lavoro eliminati
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_job_posting ON job_postings;
CREATE TRIGGER trigger_subtract_points_deleted_job_posting
  BEFORE DELETE ON job_postings
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_job_posting();

-- Grant necessari
GRANT EXECUTE ON FUNCTION subtract_points_for_deleted_job_posting() TO authenticated;
