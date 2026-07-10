/*
  # Add Logout Time to Admin Login Logs

  1. Changes
    - Add logout_time column to admin_login_logs table
    - Allow tracking both login and logout events

  2. Security
    - Column is nullable to allow tracking of open sessions
*/

-- Add logout_time column
ALTER TABLE admin_login_logs
ADD COLUMN IF NOT EXISTS logout_time timestamptz;

-- Create index for logout queries
CREATE INDEX IF NOT EXISTS idx_admin_login_logs_logout_time 
ON admin_login_logs(logout_time);

-- Comment
COMMENT ON COLUMN admin_login_logs.logout_time IS 'Timestamp of when the admin logged out from this session';
