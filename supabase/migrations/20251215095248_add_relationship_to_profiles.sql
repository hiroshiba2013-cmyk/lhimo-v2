/*
  # Add relationship field to profiles table

  1. Changes
    - Add `relationship` column to `profiles` table
    - The column is optional (nullable) and stores the relationship type
    - Default value is 'Titolare' for existing profiles

  2. Purpose
    - Allow the primary account holder (Person 1) to specify their relationship type
    - This aligns with family members who already have this field
*/

-- Add relationship column to profiles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'relationship'
  ) THEN
    ALTER TABLE profiles ADD COLUMN relationship text DEFAULT 'Titolare';
  END IF;
END $$;