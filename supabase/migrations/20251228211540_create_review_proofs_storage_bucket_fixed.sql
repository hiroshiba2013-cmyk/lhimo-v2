/*
  # Crea Storage Bucket per Prove di Recensioni

  ## Modifiche
  
  1. Crea il bucket 'review-proofs' per le immagini di prova
  2. Imposta le policy di accesso:
    - Solo utenti autenticati possono caricare
    - Solo lo staff può visualizzare le immagini
    - Le immagini vengono cancellate dopo l'approvazione
  
  Note:
    - Il bucket è privato per default
    - Solo gli utenti possono caricare le proprie immagini
    - Solo lo staff business può vedere tutte le immagini
*/

-- Crea il bucket per le prove di recensioni se non esiste
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'review-proofs',
  'review-proofs',
  false,
  5242880, -- 5MB
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist
DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can upload their own review proofs" ON storage.objects;
  DROP POLICY IF EXISTS "Users can delete their own review proofs" ON storage.objects;
  DROP POLICY IF EXISTS "Staff can view all review proofs" ON storage.objects;
  DROP POLICY IF EXISTS "Users can view their own review proofs" ON storage.objects;
END $$;

-- Policy per permettere agli utenti di caricare le proprie immagini
CREATE POLICY "Users can upload their own review proofs"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'review-proofs' AND
  (storage.foldername(name))[1] = 'review-proofs' AND
  auth.uid()::text = (regexp_match(name, '^review-proofs/([a-f0-9-]+)-'))[1]
);

-- Policy per permettere agli utenti di eliminare le proprie immagini
CREATE POLICY "Users can delete their own review proofs"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'review-proofs' AND
  auth.uid()::text = (regexp_match(name, '^review-proofs/([a-f0-9-]+)-'))[1]
);

-- Policy per permettere allo staff di vedere tutte le immagini
CREATE POLICY "Staff can view all review proofs"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'review-proofs' AND
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.id = auth.uid() 
    AND profiles.user_type = 'business'
  )
);

-- Policy per permettere agli utenti di vedere le proprie immagini
CREATE POLICY "Users can view their own review proofs"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'review-proofs' AND
  auth.uid()::text = (regexp_match(name, '^review-proofs/([a-f0-9-]+)-'))[1]
);
