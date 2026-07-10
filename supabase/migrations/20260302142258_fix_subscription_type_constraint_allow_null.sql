/*
  # Fix subscription_type constraint to allow NULL

  1. Changes
    - Drop existing constraint that doesn't allow NULL
    - Add new constraint that allows NULL OR valid values
    - This enables admin accounts to have NULL subscription_type
  
  2. Security
    - No changes to RLS policies
*/

-- Drop the existing constraint
ALTER TABLE profiles 
  DROP CONSTRAINT IF EXISTS profiles_subscription_type_check;

-- Add new constraint that allows NULL
ALTER TABLE profiles 
  ADD CONSTRAINT profiles_subscription_type_check 
  CHECK (
    subscription_type IS NULL OR 
    subscription_type IN ('monthly', 'annual')
  );
