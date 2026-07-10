/*
  # Add missing fields to registered_businesses

  1. Changes
    - Add `phone` column (business phone number)
    - Add `office_street`, `office_street_number`, `office_postal_code`, `office_city`, `office_province` columns
    - Add `office_address` column (concatenated office address)
    - Add trigger to auto-update office_address
    
  2. Notes
    - These fields match the business registration form
    - office_address is auto-generated from office address components
*/

-- Add phone column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'phone'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN phone text;
  END IF;
END $$;

-- Add office address columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_street'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_street text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_street_number'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_street_number text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_postal_code'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_postal_code text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_city'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_city text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_province'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_province text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'office_address'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN office_address text;
  END IF;
END $$;

-- Update trigger function to include office_address
CREATE OR REPLACE FUNCTION update_registered_business_billing_address()
RETURNS TRIGGER AS $$
BEGIN
  -- Update billing_address
  NEW.billing_address := CASE 
    WHEN NEW.billing_street IS NOT NULL THEN
      CONCAT_WS(', ',
        CONCAT_WS(' ', NEW.billing_street, NEW.billing_street_number),
        NEW.billing_postal_code,
        NEW.billing_city,
        UPPER(NEW.billing_province)
      )
    ELSE NULL
  END;

  -- Update office_address
  NEW.office_address := CASE 
    WHEN NEW.office_street IS NOT NULL THEN
      CONCAT_WS(', ',
        CONCAT_WS(' ', NEW.office_street, NEW.office_street_number),
        NEW.office_postal_code,
        NEW.office_city,
        UPPER(NEW.office_province)
      )
    ELSE NULL
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger already exists, no need to recreate
