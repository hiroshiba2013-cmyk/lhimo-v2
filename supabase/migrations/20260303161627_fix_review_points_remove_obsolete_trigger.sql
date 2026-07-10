/*
  # Fix Review Points System - Remove Obsolete Trigger

  1. Changes
    - Remove obsolete trigger that assigns points on review INSERT
    - Points should only be awarded when review is APPROVED by staff
    - This ensures correct point values: 25 for basic, 50 with proof

  2. Notes
    - The old trigger awarded 10 points immediately on insert
    - This conflicted with the approval system that awards 25-50 points
    - After this fix, all points are awarded during review approval only
*/

-- Drop the obsolete trigger that awards points on review insert
DROP TRIGGER IF EXISTS trigger_update_user_activity_on_review ON reviews;

-- Drop the obsolete function
DROP FUNCTION IF EXISTS update_user_activity();

-- Sync existing user activity to fix any incorrect point values
-- This recalculates points based on approved reviews only
UPDATE user_activity ua
SET 
  total_points = COALESCE((
    SELECT SUM(r.points_awarded)
    FROM reviews r
    WHERE r.customer_id = ua.user_id 
      AND r.review_status = 'approved'
  ), 0),
  reviews_count = COALESCE((
    SELECT COUNT(*)
    FROM reviews r
    WHERE r.customer_id = ua.user_id 
      AND r.review_status = 'approved'
  ), 0);
