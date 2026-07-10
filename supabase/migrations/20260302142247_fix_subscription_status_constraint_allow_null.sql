/*
  # Fix subscription_status constraint to allow NULL

  1. Changes
    - Drop existing constraint that doesn't allow NULL
    - Add new constraint that allows NULL OR valid values
    - This enables admin accounts to have NULL subscription_status
  
  2. Security
    - No changes to RLS policies
*/

-- Drop the existing constraint
ALTER TABLE profiles 
  DROP CONSTRAINT IF EXISTS profiles_subscription_status_check;

-- Add new constraint that allows NULL
ALTER TABLE profiles 
  ADD CONSTRAINT profiles_subscription_status_check 
  CHECK (
    subscription_status IS NULL OR 
    subscription_status IN ('trial', 'active', 'expired', 'cancelled')
  );
