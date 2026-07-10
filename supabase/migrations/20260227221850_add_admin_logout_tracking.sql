/*
  # Add Admin Logout Tracking

  1. Changes
    - Create function to log admin logout
    - Update the last login session with logout time

  2. Security
    - Only authenticated admins can log logout
*/

-- Function to log admin logout
CREATE OR REPLACE FUNCTION log_admin_logout()
RETURNS void AS $$
BEGIN
  -- Update the most recent login log for this admin with logout time
  UPDATE admin_login_logs
  SET logout_time = now()
  WHERE admin_id = auth.uid()
    AND logout_time IS NULL
    AND login_time = (
      SELECT MAX(login_time)
      FROM admin_login_logs
      WHERE admin_id = auth.uid()
        AND logout_time IS NULL
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION log_admin_logout() TO authenticated;

-- Comment
COMMENT ON FUNCTION log_admin_logout() IS 'Logs the logout time for the current admin session';
