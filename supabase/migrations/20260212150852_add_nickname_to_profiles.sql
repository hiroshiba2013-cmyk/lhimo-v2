/*
  # Add nickname to profiles table

  1. Changes
    - Add `nickname` column to `profiles` table
    - Make it nullable to allow gradual adoption
    - Users can optionally set a nickname to be displayed instead of their full name
  
  2. Security
    - No changes to RLS policies needed
    - Users can update their own nickname through existing update policy
*/

-- Add nickname column to profiles
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'nickname'
  ) THEN
    ALTER TABLE profiles ADD COLUMN nickname text;
  END IF;
END $$;