/*
  # Add Italian values to ad_type_enum

  1. Changes
    - Add 'vendita', 'acquisto', 'regalo' as valid values for the ad_type_enum
    - This ensures both English and Italian labels are accepted by the database

  2. Important Notes
    - Existing values (sell, buy, gift) remain unchanged
    - This is a non-destructive change that only adds new accepted values
*/

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'vendita' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'vendita';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'acquisto' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'acquisto';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'regalo_it' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'regalo';
  END IF;
END $$;
