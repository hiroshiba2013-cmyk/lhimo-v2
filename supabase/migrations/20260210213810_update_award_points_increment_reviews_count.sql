/*
  # Update award_points function to increment reviews_count

  1. Changes
    - Update award_points function to increment reviews_count when activity_type is 'review'
    - This ensures user_activity table tracks both points and review count correctly
    - Fixes leaderboard display issues where review count was not updated

  2. Notes
    - Function is called when reviews are approved
    - Reviews count is incremented only for 'review' activity type
    - Other activity types (referral, product, etc.) only update points
*/

CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT NULL
) RETURNS integer AS $$
DECLARE
  v_new_total integer;
BEGIN
  -- Insert or update user_activity
  IF p_activity_type = 'review' THEN
    -- For reviews, increment both points and reviews_count
    INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at)
    VALUES (p_user_id, p_points, 1, now())
    ON CONFLICT (user_id) 
    DO UPDATE SET 
      total_points = user_activity.total_points + p_points,
      reviews_count = user_activity.reviews_count + 1,
      last_activity_at = now();
  ELSE
    -- For other activities, only increment points
    INSERT INTO user_activity (user_id, total_points, last_activity_at)
    VALUES (p_user_id, p_points, now())
    ON CONFLICT (user_id) 
    DO UPDATE SET 
      total_points = user_activity.total_points + p_points,
      last_activity_at = now();
  END IF;

  -- Get the new total
  SELECT total_points INTO v_new_total
  FROM user_activity
  WHERE user_id = p_user_id;

  -- Return the new total
  RETURN v_new_total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION award_points TO authenticated;
