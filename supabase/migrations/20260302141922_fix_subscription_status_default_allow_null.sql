/*
  # Fix subscription_status default for admin accounts

  1. Changes
    - Remove default value from subscription_status to allow NULL for admin accounts
    - Admin accounts don't need subscription management
  
  2. Security
    - No changes to RLS policies
*/

-- Remove the default value from subscription_status
ALTER TABLE profiles 
  ALTER COLUMN subscription_status DROP DEFAULT;
