/*
  # Sync user_activity reviews_count with actual approved reviews

  1. Purpose
    - Recalculate reviews_count for all users based on approved reviews
    - Fixes inconsistencies where reviews_count doesn't match actual approved reviews
    - Updates leaderboard to show correct data

  2. Process
    - Count approved reviews for each user
    - Update user_activity table with correct counts
    - Ensures data consistency between reviews and user_activity tables
*/

-- Update reviews_count for all users based on approved reviews
UPDATE user_activity ua
SET reviews_count = COALESCE(
  (
    SELECT COUNT(*)
    FROM reviews r
    WHERE r.customer_id = ua.user_id
      AND r.review_status = 'approved'
      AND r.family_member_id IS NULL
  ),
  0
);
