/*
  # Add fiscal_code field to profiles

  1. Changes
    - Add `fiscal_code` column to `profiles` table
      - Type: text (16 alphanumeric characters)
      - Unique constraint to prevent duplicates
      - Used for Italian fiscal code identification
  
  2. Notes
    - Fiscal codes are optional for now (nullable)
    - Can be made required in the future if needed
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'fiscal_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN fiscal_code text UNIQUE;
  END IF;
END $$;

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_profiles_fiscal_code ON profiles(fiscal_code);