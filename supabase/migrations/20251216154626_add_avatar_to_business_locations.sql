/*
  # Aggiungi campo avatar alle sedi aziendali

  1. Modifiche
    - Aggiunge il campo `avatar_url` alla tabella `business_locations`
      - Tipo: text, nullable
      - Memorizza l'URL dell'immagine avatar della sede

  2. Note
    - Il campo è opzionale (nullable)
    - Sarà utilizzato per mostrare l'immagine di ogni sede aziendale
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'avatar_url'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN avatar_url text;
  END IF;
END $$;