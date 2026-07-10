/*
  # Aggiungi campo nickname ai membri della famiglia

  ## Modifiche
  
  1. Aggiungi colonna `nickname` alla tabella `customer_family_members`
    - `nickname` (text, unique) - Nome visibile per le review, univoco per ogni membro
  
  ## Note
  
  - Il nickname è univoco in tutto il sistema per consentire identificazione nelle review
  - Obbligatorio per ogni membro della famiglia, come per il titolare principale
*/

-- Aggiungi colonna nickname alla tabella customer_family_members
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'nickname'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN nickname text UNIQUE NOT NULL;
  END IF;
END $$;
