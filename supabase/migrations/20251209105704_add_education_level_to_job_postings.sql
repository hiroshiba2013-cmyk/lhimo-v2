/*
  # Aggiunta Titolo di Studio agli Annunci di Lavoro

  1. Modifiche
    - Aggiunta colonna `education_level` alla tabella `job_postings`
    - Il campo memorizza il titolo di studio richiesto per la posizione
  
  2. Dettagli Campo
    - `education_level` (text, nullable)
    - Valori comuni: 'Nessuno', 'Licenza Media', 'Diploma', 'Laurea Triennale', 'Laurea Magistrale', 'Master/Dottorato'
    - Campo opzionale per permettere flessibilità negli annunci
  
  3. Note Importanti
    - Il campo è nullable per retrocompatibilità con annunci esistenti
    - Non viene impostato un valore di default per permettere la scelta esplicita
*/

-- Add education_level column to job_postings if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'education_level'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN education_level TEXT;
  END IF;
END $$;
