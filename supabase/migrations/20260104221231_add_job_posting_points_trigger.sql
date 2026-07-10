/*
  # Trigger per Assegnare Punti alla Pubblicazione di Annunci di Lavoro

  1. Trigger
    - Quando un professionista pubblica un annuncio di lavoro, riceve automaticamente 30 punti
    - Il trigger si attiva dopo l'inserimento di un nuovo record nella tabella job_postings
    - Usa la funzione award_points esistente per assegnare i punti

  2. Dettagli
    - Punti assegnati: 30
    - Tipo attività: 'job_posting_created'
    - I punti vengono assegnati al proprietario dell'azienda (owner_id)

  3. Sicurezza
    - Il trigger è SECURITY DEFINER per accedere alle tabelle necessarie
    - I punti vengono assegnati solo per nuovi annunci (non per aggiornamenti)
*/

-- Funzione trigger per assegnare punti quando viene creato un annuncio di lavoro
CREATE OR REPLACE FUNCTION award_points_for_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'owner_id dell'azienda
  SELECT owner_id INTO v_owner_id
  FROM businesses
  WHERE id = NEW.business_id;

  -- Se l'owner esiste, assegna i punti
  IF v_owner_id IS NOT NULL THEN
    PERFORM award_points(
      v_owner_id,
      30,
      'job_posting_created',
      'Annuncio di lavoro pubblicato: ' || NEW.title
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crea il trigger sulla tabella job_postings
DROP TRIGGER IF EXISTS trigger_award_points_job_posting ON job_postings;

CREATE TRIGGER trigger_award_points_job_posting
AFTER INSERT ON job_postings
FOR EACH ROW
EXECUTE FUNCTION award_points_for_job_posting();

-- Grant necessari
GRANT EXECUTE ON FUNCTION award_points_for_job_posting() TO authenticated;