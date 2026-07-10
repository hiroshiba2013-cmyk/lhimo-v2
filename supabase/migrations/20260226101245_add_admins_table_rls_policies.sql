/*
  # Add RLS Policies to Admins Table

  1. Security
    - Enable RLS on admins table for better security
    - Allow public read access (needed for is_admin() function to work)
    - Only allow inserts/updates/deletes from the trigger (SECURITY DEFINER)
    - No direct user modifications allowed
  
  2. Changes
    - Enable RLS on admins table
    - Add policy for public SELECT (read-only)
    - Inserts/updates/deletes only via trigger
*/

-- Enable RLS on admins table
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read from admins table (needed for is_admin() checks and admin login)
CREATE POLICY "Anyone can read admins table"
  ON admins
  FOR SELECT
  USING (true);

-- No policies for INSERT/UPDATE/DELETE
-- These operations should only happen via the trigger which uses SECURITY DEFINER
-- This prevents users from directly modifying the admins table

COMMENT ON TABLE admins IS 'Admin users list. Public read access for is_admin() checks. Modifications only via trigger.';
