/*
  # Disable Subscription Triggers Temporarily

  1. Changes
    - Disable subscription-related triggers that might interfere with auth

  2. Reason
    - These triggers run complex queries that might cause auth errors
*/

-- Disable the subscription status update trigger
DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;

-- We can re-enable it later with better error handling