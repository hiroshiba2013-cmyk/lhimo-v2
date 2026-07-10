/*
  # Add Business Fields to Profiles

  1. Changes
    - Add company_name field to profiles
    - Add vat_number field to profiles  
    - Add unique_code field to profiles
    - Add pec_email field to profiles

  2. Purpose
    - Store business information directly in profiles table for business accounts
    - Allow business users to manage their company data in the personal information section
*/

-- Add business fields to profiles table
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'company_name'
  ) THEN
    ALTER TABLE profiles ADD COLUMN company_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'vat_number'
  ) THEN
    ALTER TABLE profiles ADD COLUMN vat_number text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'unique_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN unique_code text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'pec_email'
  ) THEN
    ALTER TABLE profiles ADD COLUMN pec_email text;
  END IF;
END $$;