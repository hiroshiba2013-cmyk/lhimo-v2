/*
  # Fix Job Seekers - Aggiungi Foreign Key per user_id

  1. Problema
    - La tabella job_seekers ha una colonna user_id ma manca la foreign key constraint
    - Questo impedisce le query con join usando la sintassi profiles:user_id(...)
    - Errore: "Could not find a relationship between 'job_seekers' and 'user_id'"

  2. Soluzione
    - Aggiungi la foreign key constraint su user_id -> profiles(id)
    - Mantieni ON DELETE CASCADE per pulizia automatica
*/

-- Aggiungi la foreign key constraint se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE constraint_name = 'job_seekers_user_id_fkey'
      AND table_name = 'job_seekers'
  ) THEN
    ALTER TABLE job_seekers
      ADD CONSTRAINT job_seekers_user_id_fkey
      FOREIGN KEY (user_id)
      REFERENCES profiles(id)
      ON DELETE CASCADE;
  END IF;
END $$;

-- Aggiungi indice per performance
CREATE INDEX IF NOT EXISTS idx_job_seekers_user_id ON job_seekers(user_id);
