/*
  # Fix Stefano Mancini subscription plan

  Correct the subscription for stefanomancini@gmail.com from 1-person plan
  to the 2-person plan he actually selected during registration.
  This was caused by the now-disabled trigger that always assigned 1-person plan.
*/

ALTER TABLE subscriptions DISABLE TRIGGER enforce_trial_plan_restrictions;

UPDATE subscriptions
SET plan_id = '91907577-c01b-4a3d-99b7-f90c13587064'
WHERE id = 'c0ad9066-6d90-4454-b558-28020868d40e';

ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;

-- Also sync the profile subscription_type
UPDATE profiles
SET subscription_type = 'Piano Mensile - 2 Persone'
WHERE id = '4e405f1b-33d1-4012-ae38-e6186b5639af';
