/*
  # Add 'trial' to profiles subscription_status constraint

  1. Changes
    - Update check constraint on profiles.subscription_status to include 'trial'
    - This allows profiles to have subscription_status = 'trial'

  2. Security
    - No RLS changes needed
*/

-- Drop existing check constraint
ALTER TABLE profiles 
DROP CONSTRAINT IF EXISTS profiles_subscription_status_check;

-- Add updated check constraint including 'trial'
ALTER TABLE profiles 
ADD CONSTRAINT profiles_subscription_status_check 
CHECK (subscription_status IN ('trial', 'active', 'expired', 'cancelled'));