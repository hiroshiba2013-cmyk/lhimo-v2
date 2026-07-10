/*
  # Add billing_address column to registered_businesses

  1. Changes
    - Add `billing_address` column (text, nullable)
    - Add trigger to auto-update when billing address fields change
    
  2. Notes
    - billing_address = concatenation of billing street + number + postal code + city + province
    - Auto-updates via trigger on INSERT/UPDATE
*/

-- Add column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_businesses' AND column_name = 'billing_address'
  ) THEN
    ALTER TABLE registered_businesses ADD COLUMN billing_address text;
  END IF;
END $$;

-- Create function to update billing_address
CREATE OR REPLACE FUNCTION update_registered_business_billing_address()
RETURNS TRIGGER AS $$
BEGIN
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

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS update_registered_business_billing_address_trigger ON registered_businesses;
CREATE TRIGGER update_registered_business_billing_address_trigger
  BEFORE INSERT OR UPDATE ON registered_businesses
  FOR EACH ROW
  EXECUTE FUNCTION update_registered_business_billing_address();

-- Update existing rows
UPDATE registered_businesses
SET billing_street = billing_street
WHERE billing_street IS NOT NULL;
