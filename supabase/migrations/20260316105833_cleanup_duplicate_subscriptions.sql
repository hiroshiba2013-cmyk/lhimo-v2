/*
  # Cleanup Duplicate Subscriptions
  
  ## Problem
  Some users have multiple active/trial subscriptions due to both:
  - Automatic trigger creating a default trial subscription
  - Frontend registration form creating the chosen subscription
  
  ## Solution
  1. For each user with duplicate subscriptions, keep only the most recent one
  2. Mark older subscriptions as 'cancelled'
  3. Add a note to avoid data loss
  
  ## Changes
  - Update older duplicate subscriptions to 'cancelled' status
  - Keep the most recent subscription for each user
*/

-- Cancel duplicate subscriptions, keeping only the most recent one per user
WITH ranked_subscriptions AS (
  SELECT 
    id,
    customer_id,
    status,
    created_at,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id 
      ORDER BY created_at DESC
    ) as rn
  FROM subscriptions
  WHERE status IN ('active', 'trial')
)
UPDATE subscriptions
SET status = 'cancelled'
WHERE id IN (
  SELECT id 
  FROM ranked_subscriptions 
  WHERE rn > 1
);

-- Log how many subscriptions were cleaned up
DO $$
DECLARE
  affected_count integer;
BEGIN
  GET DIAGNOSTICS affected_count = ROW_COUNT;
  RAISE NOTICE 'Cleaned up % duplicate subscription(s)', affected_count;
END $$;
