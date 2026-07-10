/*
  # Fix user_activity RLS policies for leaderboard

  1. Changes
    - Drop conflicting policies
    - Create single policy that allows all authenticated users to view all activity
    - Maintain admin update permissions

  2. Security
    - All authenticated users can view leaderboard data
    - Only admins can update any activity
    - Users can still update their own activity
*/

-- Drop ALL existing policies for user_activity
DROP POLICY IF EXISTS "Users can view their own activity" ON user_activity;
DROP POLICY IF EXISTS "Users can view all activity for leaderboard" ON user_activity;
DROP POLICY IF EXISTS "Admins can view all user activity" ON user_activity;
DROP POLICY IF EXISTS "System can insert user activity" ON user_activity;
DROP POLICY IF EXISTS "Users can update their own activity" ON user_activity;
DROP POLICY IF EXISTS "Admins can update all user activity" ON user_activity;
DROP POLICY IF EXISTS "Users can insert their own activity" ON user_activity;

-- Create new clear policies
CREATE POLICY "All authenticated users can view leaderboard"
  ON user_activity FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert their own activity"
  ON user_activity FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own activity"
  ON user_activity FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can update any activity"
  ON user_activity FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );
