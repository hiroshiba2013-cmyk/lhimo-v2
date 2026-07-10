/*
  # Update Points System and Remove Badges

  ## Changes
  
  1. **Remove badges column from user_activity**
     - Badges are no longer used in the system
  
  2. **Update points system**
     - Base reviews: 15 points (updated from 10)
     - Reviews with proof (receipt/invoice): 25 points (to be implemented)
     - New business added: 10 points (to be implemented)
  
  3. **Update trigger**
     - Update the automatic trigger to award 15 points per review

  ## Notes
  - The trigger currently handles basic reviews (15 points)
  - Future enhancements will handle:
    * Reviews with proof documents (25 points)
    * New business submissions (10 points)
*/

-- Remove badges column from user_activity
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'badges'
  ) THEN
    ALTER TABLE user_activity DROP COLUMN badges;
  END IF;
END $$;

-- Update the trigger function to use 15 points instead of 10
CREATE OR REPLACE FUNCTION update_user_activity()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  VALUES (
    NEW.customer_id,
    15,
    1,
    now(),
    now()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    total_points = user_activity.total_points + 15,
    reviews_count = user_activity.reviews_count + 1,
    last_activity_at = now(),
    updated_at = now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
