/*
  # Add Complete Business Fields to Profiles

  1. Changes
    - Add ateco_code field to profiles
    - Add website_url field to profiles
    - Add office_street field to profiles
    - Add office_street_number field to profiles
    - Add office_postal_code field to profiles
    - Add office_city field to profiles
    - Add office_province field to profiles
    - Add office_address field to profiles
    - Add business_category_id field to profiles with foreign key to business_categories
    - Add description field to profiles

  2. Purpose
    - Store all business information in profiles table for business accounts
    - Allow business users to manage complete company data including addresses and category
*/

-- Add additional business fields to profiles table
DO $$ 
BEGIN
  -- ateco_code
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'ateco_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN ateco_code text;
  END IF;

  -- website_url
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'website_url'
  ) THEN
    ALTER TABLE profiles ADD COLUMN website_url text;
  END IF;

  -- office_street
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_street'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_street text;
  END IF;

  -- office_street_number
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_street_number'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_street_number text;
  END IF;

  -- office_postal_code
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_postal_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_postal_code text;
  END IF;

  -- office_city
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_city'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_city text;
  END IF;

  -- office_province
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_province'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_province text;
  END IF;

  -- office_address (complete formatted address)
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_address'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_address text;
  END IF;

  -- business_category_id with foreign key
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'business_category_id'
  ) THEN
    ALTER TABLE profiles ADD COLUMN business_category_id uuid REFERENCES business_categories(id);
  END IF;

  -- description
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'description'
  ) THEN
    ALTER TABLE profiles ADD COLUMN description text;
  END IF;
END $$;