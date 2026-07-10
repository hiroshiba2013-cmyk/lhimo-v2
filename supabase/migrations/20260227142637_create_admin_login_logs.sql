/*
  # Create Admin Login Logs System

  1. New Tables
    - `admin_login_logs`
      - `id` (uuid, primary key)
      - `admin_id` (uuid, references profiles)
      - `login_time` (timestamptz)
      - `ip_address` (text, optional)
      - `user_agent` (text, optional)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on admin_login_logs table
    - Only admins can view their own login history
    - System can insert login records

  3. Purpose
    - Track admin login activity
    - Show last access times in admin dashboard
    - Security audit trail
*/

-- Create admin login logs table
CREATE TABLE IF NOT EXISTS admin_login_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  login_time timestamptz DEFAULT now(),
  ip_address text,
  user_agent text,
  created_at timestamptz DEFAULT now()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_admin_login_logs_admin_id ON admin_login_logs(admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_login_logs_login_time ON admin_login_logs(login_time DESC);

-- Enable RLS
ALTER TABLE admin_login_logs ENABLE ROW LEVEL SECURITY;

-- Admin can view their own login logs
CREATE POLICY "Admins can view own login logs"
  ON admin_login_logs
  FOR SELECT
  TO authenticated
  USING (
    admin_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM admins WHERE user_id = auth.uid()
    )
  );

-- Allow service role to insert login logs (for the backend to track logins)
CREATE POLICY "Service can insert login logs"
  ON admin_login_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (true);