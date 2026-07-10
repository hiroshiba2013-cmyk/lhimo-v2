/*
  # Add ATECO Code to Businesses Table

  ## Overview
  This migration adds the ATECO code field to the businesses table to support
  Italian business classification requirements.

  ## Changes

  ### Modified Tables
  - `businesses` - Add ateco_code field

  ## New Columns

  ### businesses table
  - `ateco_code` (text) - Italian ATECO classification code for the business activity

  ## Notes
  The ATECO code is required for Italian businesses to classify their economic activity.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'ateco_code'
  ) THEN
    ALTER TABLE businesses ADD COLUMN ateco_code text;
  END IF;
END $$;