/*
  # Add admin to user_type check constraint

  1. Changes
    - Drop existing user_type check constraint
    - Add new constraint that includes 'admin' as valid value
    
  2. Security
    - No changes to RLS policies
*/

-- Drop existing constraint
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_user_type_check;

-- Add new constraint including 'admin'
ALTER TABLE profiles ADD CONSTRAINT profiles_user_type_check 
  CHECK (user_type IN ('customer', 'business', 'admin'));
