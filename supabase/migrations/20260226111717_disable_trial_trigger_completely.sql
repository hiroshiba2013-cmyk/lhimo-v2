/*
  # Disable Trial Trigger Completely

  1. Problem
    - The trigger is causing "Database error finding user" during signup
    - Even with SECURITY DEFINER and error handling, it's causing issues
    - The trigger tries to insert into subscriptions before the user is fully created

  2. Solution
    - Drop the trigger completely
    - Handle trial creation in application code after successful signup
    - This is safer and gives us more control over the process

  3. Changes
    - Drop the trigger
    - Keep the function in case we need it later (commented out)
*/

-- Drop the trigger
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;

-- Drop the function too since it's causing issues
DROP FUNCTION IF EXISTS create_trial_for_business_profile();
