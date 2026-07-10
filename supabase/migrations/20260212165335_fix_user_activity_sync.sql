/*
  # Fix User Activity Synchronization

  1. Changes
    - Creates a function to sync user_activity with actual approved reviews
    - Recalculates total_points based on approved reviews only
    - Updates reviews_count to reflect only approved reviews
  
  2. Security
    - Function runs with security definer for proper access
*/

-- Function to sync user activity with approved reviews
CREATE OR REPLACE FUNCTION sync_user_activity()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update or insert user activity based on approved reviews
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  SELECT 
    p.id as user_id,
    COALESCE(SUM(CASE 
      WHEN r.proof_image_url IS NOT NULL THEN 50 
      ELSE 25 
    END), 0) as total_points,
    COUNT(r.id) as reviews_count,
    NOW() as last_activity_at,
    NOW() as updated_at
  FROM profiles p
  LEFT JOIN reviews r ON r.customer_id = p.id 
    AND r.family_member_id IS NULL 
    AND r.review_status = 'approved'
  WHERE p.user_type = 'customer'
  GROUP BY p.id
  ON CONFLICT (user_id) 
  DO UPDATE SET
    total_points = EXCLUDED.total_points,
    reviews_count = EXCLUDED.reviews_count,
    updated_at = NOW();
END;
$$;

-- Execute the sync function
SELECT sync_user_activity();
