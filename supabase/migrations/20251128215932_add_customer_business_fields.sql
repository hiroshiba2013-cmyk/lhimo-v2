/*
  # Add Customer and Business Profile Fields

  ## Overview
  This migration adds extended fields for customer and business profiles to support 
  Italian tax and registration requirements.

  ## Changes
  
  ### Modified Tables
  - `profiles` - Add customer-specific fields
  - `businesses` - Add business-specific fields

  ## New Columns

  ### profiles table (customers)
  - `first_name` (text) - Customer first name
  - `last_name` (text) - Customer last name
  - `nickname` (text UNIQUE) - Customer's chosen nickname
  - `date_of_birth` (date) - Customer birth date
  - `tax_code` (text) - Italian fiscal code (Codice Fiscale)
  - `billing_address` (text) - Complete billing address

  ### businesses table
  - `vat_number` (text UNIQUE) - P.IVA number
  - `unique_code` (text UNIQUE) - Codice Univoco
  - `pec_email` (text) - PEC email for business
  - `phone` (text) - Business phone number
  - `billing_address` (text) - Complete billing address
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'first_name'
  ) THEN
    ALTER TABLE profiles ADD COLUMN first_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'last_name'
  ) THEN
    ALTER TABLE profiles ADD COLUMN last_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'nickname'
  ) THEN
    ALTER TABLE profiles ADD COLUMN nickname text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'date_of_birth'
  ) THEN
    ALTER TABLE profiles ADD COLUMN date_of_birth date;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'tax_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN tax_code text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'billing_address'
  ) THEN
    ALTER TABLE profiles ADD COLUMN billing_address text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'vat_number'
  ) THEN
    ALTER TABLE businesses ADD COLUMN vat_number text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'unique_code'
  ) THEN
    ALTER TABLE businesses ADD COLUMN unique_code text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'pec_email'
  ) THEN
    ALTER TABLE businesses ADD COLUMN pec_email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'phone'
  ) THEN
    ALTER TABLE businesses ADD COLUMN phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'billing_address'
  ) THEN
    ALTER TABLE businesses ADD COLUMN billing_address text;
  END IF;
END $$;