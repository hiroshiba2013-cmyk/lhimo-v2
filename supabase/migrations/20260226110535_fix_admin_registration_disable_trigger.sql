/*
  # Fix Admin Registration - Disable Problematic Trigger

  1. Problem
    - The sync_admin_status_trigger runs during user signup
    - This causes "Database error finding user" because it tries to query
      during the auth.users creation process
    - Triggers with SECURITY DEFINER can cause issues during signup

  2. Solution
    - Drop the automatic trigger that syncs admins table
    - Create a simple function to manually promote users to admin
    - This avoids any database errors during the signup process

  3. Changes
    - Drop sync_admin_status_trigger
    - Drop sync_profile_admin_status function
    - Create promote_to_admin function for manual promotion
*/

-- Drop the problematic trigger
DROP TRIGGER IF EXISTS sync_admin_status_trigger ON profiles;

-- Drop the function
DROP FUNCTION IF EXISTS sync_profile_admin_status();

-- Create a simple function to promote a user to admin
-- This will be called AFTER the profile is created
CREATE OR REPLACE FUNCTION promote_to_admin(target_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update profile to admin
  UPDATE profiles 
  SET is_admin = true, user_type = 'admin'
  WHERE id = target_user_id;
  
  -- Insert into admins table if not exists
  INSERT INTO admins (user_id)
  VALUES (target_user_id)
  ON CONFLICT (user_id) DO NOTHING;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION promote_to_admin(uuid) TO authenticated;
