/*
  # Aggiungi campi e RLS a job_seekers

  1. Modifiche alla tabella job_seekers
    - Aggiunge campo `phone` (text, opzionale) - numero di telefono del candidato
    - Aggiunge campo `email` (text, opzionale) - email di contatto del candidato
    - Aggiunge campo `category_id` (uuid, opzionale) - riferimento a business_categories per la categoria lavorativa

  2. Sicurezza
    - Abilita RLS sulla tabella job_seekers
    - Policy per visualizzazione pubblica degli annunci attivi
    - Policy per permettere agli utenti autenticati di creare annunci
    - Policy per permettere agli utenti di modificare/eliminare i propri annunci

  3. Note importanti
    - I campi phone ed email sono facoltativi per privacy
    - La categoria aiuta a filtrare gli annunci per settore lavorativo
*/

-- Add new columns to job_seekers
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'phone'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'email'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN category_id uuid REFERENCES business_categories(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Create index for category lookups
CREATE INDEX IF NOT EXISTS idx_job_seekers_category ON job_seekers(category_id);

-- Enable RLS
ALTER TABLE job_seekers ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Public can view active job seeker ads" ON job_seekers;
DROP POLICY IF EXISTS "Authenticated users can create job seeker ads" ON job_seekers;
DROP POLICY IF EXISTS "Users can update own job seeker ads" ON job_seekers;
DROP POLICY IF EXISTS "Users can delete own job seeker ads" ON job_seekers;

-- Policy: Everyone can view active job seeker ads
CREATE POLICY "Public can view active job seeker ads"
  ON job_seekers
  FOR SELECT
  TO public
  USING (status = 'active');

-- Policy: Authenticated users can create their own job seeker ads
CREATE POLICY "Authenticated users can create job seeker ads"
  ON job_seekers
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own job seeker ads
CREATE POLICY "Users can update own job seeker ads"
  ON job_seekers
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own job seeker ads
CREATE POLICY "Users can delete own job seeker ads"
  ON job_seekers
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
