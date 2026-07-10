/*
  # Add Business Website Field

  ## Overview
  This migration adds a website URL field to businesses table to allow
  businesses to showcase their website on their profile.

  ## Changes

  ### Modified Tables
  - `businesses` - Add website_url field

  ## New Columns

  ### businesses table
  - `website_url` (text) - Company website URL (optional)

  ## Notes
  - This field is optional and can be left empty if the business doesn't have a website
  - The URL should be a valid HTTP/HTTPS URL
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'website_url'
  ) THEN
    ALTER TABLE businesses ADD COLUMN website_url text;
  END IF;
END $$;