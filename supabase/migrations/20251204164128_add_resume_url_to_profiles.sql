/*
  # Add resume URL field to profiles table

  1. Changes
    - Add `resume_url` column to `profiles` table
      - `resume_url` (text, nullable) - URL path to the uploaded resume PDF in Supabase Storage
  
  2. Notes
    - This field will store the path to the resume PDF file in Supabase Storage
    - Only relevant for customer profiles
    - Nullable field as not all customers may want to upload a resume
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'resume_url'
  ) THEN
    ALTER TABLE profiles ADD COLUMN resume_url text;
  END IF;
END $$;