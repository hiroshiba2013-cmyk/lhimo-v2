/*
  # Fix: business users must not have points and must be excluded from leaderboard

  1. Reset all user_activity records belonging to business users to zero points
  2. Remove activity_log entries that assigned points to business users
  3. Any future call to award_points() already returns 0 for business users (guard already in place)
*/

-- Zero out points and counters for all business users in user_activity
UPDATE user_activity ua
SET
  total_points      = 0,
  reviews_count     = 0,
  ads_posted_count  = 0,
  job_postings_count = 0,
  auctions_count    = 0,
  referrals_count   = 0,
  last_activity_at  = now(),
  updated_at        = now()
WHERE user_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND family_member_id IS NULL;

-- Remove activity_log rows where points were awarded to business users
UPDATE activity_log al
SET points_earned = 0
WHERE user_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND points_earned > 0;
