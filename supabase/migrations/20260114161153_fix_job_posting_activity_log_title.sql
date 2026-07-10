/*
  # Fix Job Posting Activity Log - Add Missing Title Field

  1. Problema
    - Il trigger per i job postings non inserisce il campo `title` nella tabella activity_log
    - Questo causa un errore di constraint violation quando si crea un annuncio di lavoro
    
  2. Soluzione
    - Aggiorna il trigger per includere tutti i campi obbligatori: title, icon, color, metadata
    - Usa valori appropriati per ogni campo
    
  3. Dettagli
    - title: "Annuncio di lavoro pubblicato"
    - description: Include il titolo dell'annuncio
    - icon: 'briefcase'
    - color: 'text-blue-600'
    - metadata: Include job_posting_id e business_id
*/

-- Ricrea la funzione corretta per assegnare punti quando viene creato un annuncio di lavoro
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

    -- Registra l'attività nel log con TUTTI i campi obbligatori
    INSERT INTO activity_log (
      user_id, 
      activity_type, 
      title, 
      description, 
      points_earned, 
      metadata,
      icon,
      color,
      created_at
    )
    VALUES (
      v_owner_id,
      'job_posting_created',
      'Annuncio di lavoro pubblicato',
      'Annuncio di lavoro pubblicato: ' || NEW.title,
      30,
      jsonb_build_object('job_posting_id', NEW.id, 'business_id', NEW.business_id),
      'briefcase',
      'text-blue-600',
      now()
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
