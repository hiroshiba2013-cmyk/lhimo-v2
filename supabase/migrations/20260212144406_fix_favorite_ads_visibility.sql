/*
  # Fix Favorite Ads Visibility
  
  ## Problem
  Users cannot see classified ads in their favorites section if the ad status is not 'active'.
  The existing RLS policy only allows viewing ads with status = 'active', which prevents users
  from viewing ads they have favorited if the ad was sold, expired, or deleted.
  
  ## Solution
  Add a new RLS policy that allows authenticated users to view ads they have favorited,
  regardless of the ad's status. This ensures users can always see their favorite ads.
  
  ## Changes
  1. Add new SELECT policy for authenticated users to view their favorited ads
  
  ## Important Notes
  - Users will be able to see ads they favorited even if the status changed
  - This only applies to ads the user has explicitly favorited
  - Public users still only see active ads
*/

-- Add policy to allow users to view ads they have favorited
CREATE POLICY "Users can view their favorited ads"
  ON classified_ads FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM favorite_classified_ads
      WHERE favorite_classified_ads.ad_id = classified_ads.id
      AND favorite_classified_ads.user_id = auth.uid()
    )
  );
