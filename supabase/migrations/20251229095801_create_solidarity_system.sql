/*
  # Create Solidarity System

  1. New Tables
    - `solidarity_documents`
      - `id` (uuid, primary key)
      - `document_type` (enum: 'revenue', 'donation')
      - `title` (text)
      - `description` (text)
      - `file_url` (text) - URL to the uploaded document
      - `year` (integer) - Year of the document
      - `amount` (numeric) - Amount in euros (optional)
      - `recipient` (text) - For donations, who received it (optional)
      - `uploaded_by` (uuid, foreign key to auth.users)
      - `created_at` (timestamptz)

  2. Storage
    - Create bucket for solidarity documents
    - Public access for viewing documents

  3. Security
    - Enable RLS on `solidarity_documents` table
    - Anyone can view documents (transparency)
    - Only authenticated users with admin role can upload documents
*/

-- Create document_type enum
DO $$ BEGIN
  CREATE TYPE document_type_enum AS ENUM ('revenue', 'donation');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- Create solidarity_documents table
CREATE TABLE IF NOT EXISTS solidarity_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  document_type document_type_enum NOT NULL,
  title text NOT NULL,
  description text,
  file_url text NOT NULL,
  year integer NOT NULL,
  amount numeric(10, 2),
  recipient text,
  uploaded_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_solidarity_documents_year ON solidarity_documents(year DESC);
CREATE INDEX IF NOT EXISTS idx_solidarity_documents_type ON solidarity_documents(document_type);

-- Enable RLS
ALTER TABLE solidarity_documents ENABLE ROW LEVEL SECURITY;

-- Anyone can view solidarity documents (transparency)
CREATE POLICY "Anyone can view solidarity documents"
  ON solidarity_documents FOR SELECT
  TO public
  USING (true);

-- Only authenticated users can insert (we'll add admin check in the app)
CREATE POLICY "Authenticated users can insert solidarity documents"
  ON solidarity_documents FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = uploaded_by);

-- Only the uploader can update their documents
CREATE POLICY "Users can update own solidarity documents"
  ON solidarity_documents FOR UPDATE
  TO authenticated
  USING (auth.uid() = uploaded_by)
  WITH CHECK (auth.uid() = uploaded_by);

-- Only the uploader can delete their documents
CREATE POLICY "Users can delete own solidarity documents"
  ON solidarity_documents FOR DELETE
  TO authenticated
  USING (auth.uid() = uploaded_by);

-- Create storage bucket for solidarity documents
INSERT INTO storage.buckets (id, name, public)
VALUES ('solidarity-documents', 'solidarity-documents', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies: Anyone can view
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Anyone can view solidarity documents'
  ) THEN
    CREATE POLICY "Anyone can view solidarity documents"
      ON storage.objects FOR SELECT
      TO public
      USING (bucket_id = 'solidarity-documents');
  END IF;
END $$;

-- Only authenticated users can upload
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Authenticated users can upload solidarity documents'
  ) THEN
    CREATE POLICY "Authenticated users can upload solidarity documents"
      ON storage.objects FOR INSERT
      TO authenticated
      WITH CHECK (bucket_id = 'solidarity-documents');
  END IF;
END $$;

-- Users can update their own uploads
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Users can update own solidarity documents in storage'
  ) THEN
    CREATE POLICY "Users can update own solidarity documents in storage"
      ON storage.objects FOR UPDATE
      TO authenticated
      USING (bucket_id = 'solidarity-documents' AND owner::uuid = auth.uid());
  END IF;
END $$;

-- Users can delete their own uploads
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Users can delete own solidarity documents from storage'
  ) THEN
    CREATE POLICY "Users can delete own solidarity documents from storage"
      ON storage.objects FOR DELETE
      TO authenticated
      USING (bucket_id = 'solidarity-documents' AND owner::uuid = auth.uid());
  END IF;
END $$;