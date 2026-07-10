/*
  # Fix award_points function to use user_activity table

  1. Changes
    - Update award_points function to use user_activity table instead of user_points
    - Maintain backward compatibility with existing code
    - Ensure points are tracked correctly in user_activity

  2. Notes
    - The user_points table doesn't exist, but user_activity does
    - Points are stored in user_activity.total_points
    - Activity logs are stored in activity_log table
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
  INSERT INTO user_activity (user_id, total_points, last_activity_at)
  VALUES (p_user_id, p_points, now())
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    total_points = user_activity.total_points + p_points,
    last_activity_at = now();

  -- Get the new total
  SELECT total_points INTO v_new_total
  FROM user_activity
  WHERE user_id = p_user_id;

  -- Return the new total
  RETURN v_new_total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION award_points TO authenticated;
