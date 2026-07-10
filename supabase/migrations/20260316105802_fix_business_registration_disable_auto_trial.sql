/*
  # Fix Business Registration - Disable Auto Trial Creation
  
  ## Problem
  When a business user registers, there are TWO subscription records being created:
  1. One from the automatic trigger (basic monthly plan)
  2. One from the frontend registration form (chosen plan)
  
  This causes confusion and the wrong subscription to be displayed.
  
  ## Solution
  Disable the automatic trigger that creates trial subscriptions for business users.
  The frontend handles subscription creation with the user's chosen plan.
  
  ## Changes
  - Drop the BEFORE INSERT trigger that auto-sets trial status
  - Drop the AFTER INSERT trigger that auto-creates subscription
  - Keep the functions for potential future use but disable triggers
*/

-- Disable the automatic trial creation triggers for business users
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;
DROP TRIGGER IF EXISTS trigger_insert_business_trial_subscription ON profiles;

-- Comment: The functions create_trial_for_business_profile() and 
-- insert_business_trial_subscription() are kept in the database but not used.
-- The frontend registration form now handles all subscription creation.
