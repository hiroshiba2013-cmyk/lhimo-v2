/*
  # Fix trial subscription trigger

  The trigger create_trial_for_customer was always assigning the 1-person plan,
  ignoring what the user selected in the registration form. The frontend then
  tried to INSERT a second subscription which was silently ignored by ON CONFLICT DO NOTHING.

  Fix: Disable the trigger entirely. The frontend (RegisterForm.tsx) already
  correctly creates the subscription with the plan the user selected.
  The trigger was redundant and caused the wrong plan to be assigned.
*/

DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;
