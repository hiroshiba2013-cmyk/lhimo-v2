/*
  # Aggiungi campo avatar ai membri della famiglia

  ## Modifiche
  
  1. Aggiungi campo `avatar_url` alla tabella `customer_family_members`
    - `avatar_url` (text, nullable) - URL dell'avatar del membro della famiglia
  
  ## Note
  
  - Il campo è nullable perché i membri esistenti potrebbero non avere un avatar
  - Gli avatar saranno caricati nel bucket Supabase Storage
*/

-- Aggiungi campo avatar_url se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'avatar_url'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN avatar_url text;
  END IF;
END $$;