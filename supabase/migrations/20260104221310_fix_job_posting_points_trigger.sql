/*
  # Fix Trigger per Assegnare Punti alla Pubblicazione di Annunci di Lavoro

  1. Correzione
    - Rimosso il riferimento alla funzione award_points che usa tabelle inesistenti
    - Aggiorna direttamente la tabella user_activity esistente
    - Assegna 30 punti al proprietario dell'azienda quando pubblica un annuncio di lavoro

  2. Dettagli
    - Punti assegnati: 30
    - Aggiorna total_points e last_activity_at nella tabella user_activity
    - Crea il record se non esiste (INSERT ... ON CONFLICT)

  3. Sicurezza
    - Il trigger è SECURITY DEFINER per accedere alle tabelle necessarie
    - I punti vengono assegnati solo per nuovi annunci (non per aggiornamenti)
*/

-- Elimina il trigger precedente
DROP TRIGGER IF EXISTS trigger_award_points_job_posting ON job_postings;
DROP FUNCTION IF EXISTS award_points_for_job_posting();

-- Crea la funzione corretta per assegnare punti quando viene creato un annuncio di lavoro
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
    -- Inserisci o aggiorna l'attività dell'utente
    INSERT INTO user_activity (user_id, total_points, last_activity_at, updated_at)
    VALUES (v_owner_id, 30, now(), now())
    ON CONFLICT (user_id) DO UPDATE SET
      total_points = user_activity.total_points + 30,
      last_activity_at = now(),
      updated_at = now();

    -- Registra l'attività nel log
    INSERT INTO activity_log (user_id, activity_type, points_earned, description, created_at)
    VALUES (
      v_owner_id,
      'job_posting_created',
      30,
      'Annuncio di lavoro pubblicato: ' || NEW.title,
      now()
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crea il trigger sulla tabella job_postings
CREATE TRIGGER trigger_award_points_job_posting
AFTER INSERT ON job_postings
FOR EACH ROW
EXECUTE FUNCTION award_points_for_job_posting();

-- Grant necessari
GRANT EXECUTE ON FUNCTION award_points_for_job_posting() TO authenticated;