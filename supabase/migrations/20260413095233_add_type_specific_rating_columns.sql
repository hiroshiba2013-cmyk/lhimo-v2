/*
  # Add type-specific rating columns to reviews table

  ## Summary
  Adds granular rating columns to the reviews table for each review type:

  - booking_not_completed: gestione_prenotazione, affidabilita, organizzazione, comunicazione
  - quote_request: chiarezza, trasparenza, tempistiche_risposta, disponibilita
  - customer_service: cortesia, competenza, rapidita, risoluzione_problema
  - problem_before_service: affidabilita, organizzazione, gestione_problema, comunicazione

  Each column stores a 1-5 star rating.
*/

DO $$
BEGIN
  -- booking_not_completed ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_gestione_prenotazione') THEN
    ALTER TABLE reviews ADD COLUMN booking_gestione_prenotazione smallint CHECK (booking_gestione_prenotazione BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_affidabilita') THEN
    ALTER TABLE reviews ADD COLUMN booking_affidabilita smallint CHECK (booking_affidabilita BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_organizzazione') THEN
    ALTER TABLE reviews ADD COLUMN booking_organizzazione smallint CHECK (booking_organizzazione BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_comunicazione') THEN
    ALTER TABLE reviews ADD COLUMN booking_comunicazione smallint CHECK (booking_comunicazione BETWEEN 1 AND 5);
  END IF;

  -- quote_request ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_chiarezza') THEN
    ALTER TABLE reviews ADD COLUMN quote_chiarezza smallint CHECK (quote_chiarezza BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_trasparenza') THEN
    ALTER TABLE reviews ADD COLUMN quote_trasparenza smallint CHECK (quote_trasparenza BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_tempistiche_risposta') THEN
    ALTER TABLE reviews ADD COLUMN quote_tempistiche_risposta smallint CHECK (quote_tempistiche_risposta BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_disponibilita') THEN
    ALTER TABLE reviews ADD COLUMN quote_disponibilita smallint CHECK (quote_disponibilita BETWEEN 1 AND 5);
  END IF;

  -- customer_service ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_cortesia') THEN
    ALTER TABLE reviews ADD COLUMN cs_cortesia smallint CHECK (cs_cortesia BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_competenza') THEN
    ALTER TABLE reviews ADD COLUMN cs_competenza smallint CHECK (cs_competenza BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_rapidita') THEN
    ALTER TABLE reviews ADD COLUMN cs_rapidita smallint CHECK (cs_rapidita BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_risoluzione_problema') THEN
    ALTER TABLE reviews ADD COLUMN cs_risoluzione_problema smallint CHECK (cs_risoluzione_problema BETWEEN 1 AND 5);
  END IF;

  -- problem_before_service ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_affidabilita') THEN
    ALTER TABLE reviews ADD COLUMN problem_affidabilita smallint CHECK (problem_affidabilita BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_organizzazione') THEN
    ALTER TABLE reviews ADD COLUMN problem_organizzazione smallint CHECK (problem_organizzazione BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_gestione_problema') THEN
    ALTER TABLE reviews ADD COLUMN problem_gestione_problema smallint CHECK (problem_gestione_problema BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_comunicazione') THEN
    ALTER TABLE reviews ADD COLUMN problem_comunicazione smallint CHECK (problem_comunicazione BETWEEN 1 AND 5);
  END IF;
END $$;
