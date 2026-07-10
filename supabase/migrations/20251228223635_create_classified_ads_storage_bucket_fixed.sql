/*
  # Create Storage Bucket for Classified Ads Images

  ## Overview
  Creates a storage bucket for classified ads images with appropriate policies.

  ## 1. Storage Bucket
  - Create `classified-ads` bucket for storing ad images
  
  ## 2. Security
  - Public access for viewing images
  - Authenticated users can upload images
  - Users can update/delete their own images
*/

-- Create the classified-ads storage bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('classified-ads', 'classified-ads', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can view classified ad images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload classified ad images" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own classified ad images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own classified ad images" ON storage.objects;

-- Allow public to view images
CREATE POLICY "Public can view classified ad images"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'classified-ads');

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated users can upload classified ad images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'classified-ads');

-- Allow users to update their own images
CREATE POLICY "Users can update their own classified ad images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'classified-ads' AND owner = auth.uid())
  WITH CHECK (bucket_id = 'classified-ads' AND owner = auth.uid());

-- Allow users to delete their own images
CREATE POLICY "Users can delete their own classified ad images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'classified-ads' AND owner = auth.uid());
