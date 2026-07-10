/*
  # Fix get_trial_status Function - Use Correct Trial End Date
  
  ## Problem
  The function `get_trial_status()` was reading `trial_end_date` from the profiles table,
  but this column doesn't exist. The correct field is `subscription_expires_at`.
  
  This was causing incorrect calculation of remaining trial days (showing 365 days instead of 30).
  
  ## Solution
  Update the function to:
  1. Use `subscription_expires_at` from profiles table
  2. Only consider users with status = 'trial'
  3. Calculate days remaining based on subscription_expires_at
  
  ## Changes
  - Replace `trial_end_date` with `subscription_expires_at` in the function
  - Fix the days_remaining calculation
  - Fix the is_expired check
*/

-- Function to get trial status for a user
CREATE OR REPLACE FUNCTION get_trial_status(user_id_param uuid)
RETURNS TABLE(
  is_trial boolean,
  days_remaining integer,
  trial_end_date timestamptz,
  is_expired boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    (subscription_status = 'trial') as is_trial,
    CASE
      WHEN subscription_status = 'trial' AND subscription_expires_at IS NOT NULL
      THEN GREATEST(0, EXTRACT(day FROM (subscription_expires_at - now()))::integer)
      ELSE 0
    END as days_remaining,
    profiles.subscription_expires_at as trial_end_date,
    (subscription_status = 'expired' AND subscription_expires_at < now()) as is_expired
  FROM profiles
  WHERE id = user_id_param;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION get_trial_status(uuid) TO authenticated;
