/*
  # Add Claimed Fields to Businesses Table

  1. Changes to Tables
    - `businesses`
      - Add `claimed_at` (timestamptz) - quando è stata rivendicata
      - Add `verification_badge` (text) - tipo di badge: 'claimed', 'verified', 'premium'
      - Update existing is_claimed to true for all businesses (sono tutte rivendicate)

  2. Updates
    - Segna tutte le businesses esistenti come claimed
    - Imposta claimed_at con created_at
    - Imposta verification_badge based on verified status
*/

-- Add new columns to businesses
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE businesses ADD COLUMN claimed_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'verification_badge'
  ) THEN
    ALTER TABLE businesses ADD COLUMN verification_badge text CHECK (verification_badge IN ('claimed', 'verified', 'premium'));
  END IF;
END $$;

-- Update existing businesses to be marked as claimed
UPDATE businesses
SET 
  is_claimed = true,
  claimed_at = COALESCE(claimed_at, created_at),
  verification_badge = CASE 
    WHEN verified = true THEN 'verified'
    ELSE 'claimed'
  END
WHERE is_claimed IS NULL OR is_claimed = false OR verification_badge IS NULL;

-- Create trigger to set claimed_at automatically
CREATE OR REPLACE FUNCTION set_business_claimed_at()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_claimed = true AND NEW.claimed_at IS NULL THEN
    NEW.claimed_at := now();
  END IF;
  
  IF NEW.is_claimed = true AND NEW.verification_badge IS NULL THEN
    NEW.verification_badge := CASE 
      WHEN NEW.verified = true THEN 'verified'
      ELSE 'claimed'
    END;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_business_claimed_at ON businesses;
CREATE TRIGGER trigger_set_business_claimed_at
  BEFORE INSERT OR UPDATE ON businesses
  FOR EACH ROW
  EXECUTE FUNCTION set_business_claimed_at();

-- Create index on verification_badge
CREATE INDEX IF NOT EXISTS idx_businesses_verification_badge ON businesses(verification_badge);
CREATE INDEX IF NOT EXISTS idx_businesses_claimed_priority 
  ON businesses(is_claimed DESC, verification_badge DESC, name);
