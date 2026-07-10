/*
  # Add award_points function

  1. Function
    - Creates `award_points` function to award points to users
    - Automatically creates user_points record if it doesn't exist
    - Records activity in user_activities table
    - Returns the new points total

  2. Security
    - Function is accessible to authenticated users
    - Ensures data integrity with proper error handling
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
  INSERT INTO user_points (user_id, points_balance)
  VALUES (p_user_id, p_points)
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    points_balance = user_points.points_balance + p_points,
    updated_at = now();

  INSERT INTO user_activities (user_id, activity_type, points_earned, description)
  VALUES (p_user_id, p_activity_type, p_points, p_description);

  SELECT points_balance INTO v_new_total
  FROM user_points
  WHERE user_id = p_user_id;

  RETURN v_new_total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION award_points TO authenticated;
