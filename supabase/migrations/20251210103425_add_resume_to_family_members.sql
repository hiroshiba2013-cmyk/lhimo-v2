/*
  # Aggiungi campo curriculum ai membri della famiglia

  ## Modifiche
  
  1. Aggiungi campo `resume_url` alla tabella `customer_family_members`
    - `resume_url` (text, nullable) - URL del curriculum del membro della famiglia
  
  ## Note
  
  - Il campo è nullable perché i membri esistenti potrebbero non avere un curriculum
  - I curriculum saranno caricati nel bucket Supabase Storage
*/

-- Aggiungi campo resume_url se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'resume_url'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN resume_url text;
  END IF;
END $$;