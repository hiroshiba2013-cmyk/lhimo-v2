/*
  # Add Phone and Office Address Fields

  ## Overview
  This migration adds new fields to support customer phone numbers and business office addresses.

  ## Changes

  ### Modified Tables
  - `profiles` - Add phone field for customer profiles
  - `businesses` - Add office_address field for business locations

  ## New Columns

  ### profiles table
  - `phone` (text) - Customer phone number

  ### businesses table
  - `office_address` (text) - Office/headquarters address (if different from billing)

  ## Notes
  These fields are optional and can be left empty if not applicable.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'phone'
  ) THEN
    ALTER TABLE profiles ADD COLUMN phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'office_address'
  ) THEN
    ALTER TABLE businesses ADD COLUMN office_address text;
  END IF;
END $$;