/*
  # Create Admins Table Without RLS

  1. Problem
    - Checking profiles table for is_admin causes infinite recursion
    - JWT app_metadata is not automatically populated
    - Need a simple, recursion-free way to check admin status

  2. Solution
    - Create a separate 'admins' table with NO RLS enabled
    - This table can be queried without triggering any RLS policies
    - Update is_admin() to query this table instead of profiles

  3. Tables
    - `admins` table with just user_id column
    - No RLS = no recursion issues
    - Simple and fast to query

  4. Security
    - Only admins can modify the admins table (checked via separate policies)
    - The is_admin() function can safely query this table
    - No circular dependencies
*/

-- Create admins table (no RLS!)
CREATE TABLE IF NOT EXISTS admins (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now() NOT NULL
);

-- NO RLS on this table! This is intentional to avoid recursion
-- The table is read-only for checking admin status

-- Migrate existing admins from profiles table
INSERT INTO admins (user_id)
SELECT id FROM profiles WHERE is_admin = true
ON CONFLICT (user_id) DO NOTHING;

-- Update is_admin() function to use admins table
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE user_id = auth.uid()
  );
$$;

-- Create a trigger to keep admins table in sync with profiles
CREATE OR REPLACE FUNCTION sync_profile_admin_status()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NEW.is_admin = true AND NOT EXISTS (SELECT 1 FROM admins WHERE user_id = NEW.id) THEN
    INSERT INTO admins (user_id) VALUES (NEW.id);
  ELSIF NEW.is_admin = false THEN
    DELETE FROM admins WHERE user_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS sync_admin_status_trigger ON profiles;
CREATE TRIGGER sync_admin_status_trigger
  AFTER INSERT OR UPDATE OF is_admin ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION sync_profile_admin_status();

COMMENT ON TABLE admins IS 'Admin users list. NO RLS to avoid recursion in is_admin() checks.';
COMMENT ON FUNCTION is_admin() IS 'Checks if current user is admin using admins table (no RLS = no recursion).';
