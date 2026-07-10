/*
  # Add Gift Option to Ad Type

  1. Changes to ad_type_enum
    - Add 'gift' value to the enum
    - This allows users to offer items for free

  2. Notes
    - Existing data remains unchanged
    - New ads can now be marked as 'sell', 'buy', or 'gift'
*/

-- Add 'gift' value to ad_type enum
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum 
    WHERE enumlabel = 'gift' 
    AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')
  ) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'gift';
  END IF;
END $$;