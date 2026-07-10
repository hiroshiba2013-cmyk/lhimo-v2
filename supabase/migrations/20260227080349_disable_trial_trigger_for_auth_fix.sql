/*
  # Disable Trial Trigger Temporarily

  1. Changes
    - Drop the trial trigger that might cause auth issues
    - We'll re-enable it later with proper error handling

  2. Reason
    - The trigger might be causing database errors during auth
*/

DROP TRIGGER IF EXISTS trigger_update_trial_on_family_insert ON customer_family_members;
DROP TRIGGER IF EXISTS trigger_update_trial_on_family_delete ON customer_family_members;
DROP FUNCTION IF EXISTS update_trial_plan_on_family_change();