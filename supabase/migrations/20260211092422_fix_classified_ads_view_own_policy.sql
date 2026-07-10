/*
  # Fix Classified Ads - Allow users to view their own ads

  1. Changes
    - Add policy to allow users to view ALL their own classified ads (regardless of status)
    - This is needed for the profile page where users should see their own ads even if not active

  2. Security
    - Users can only see their own ads
    - Public users can still only see active ads
*/

-- Drop policy if exists and recreate
DO $$ 
BEGIN
  DROP POLICY IF EXISTS "Users can view own classified ads regardless of status" ON classified_ads;
END $$;

-- Add policy for users to view their own ads regardless of status
CREATE POLICY "Users can view own classified ads regardless of status"
  ON classified_ads
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);
