/*
  # Delete user stefanomancini@gmail.com completely

  Complete removal bypassing trial protection trigger.
  User ID: 4e405f1b-33d1-4012-ae38-e6186b5639af
*/

ALTER TABLE subscriptions DISABLE TRIGGER enforce_trial_plan_restrictions;

DELETE FROM subscriptions WHERE customer_id = '4e405f1b-33d1-4012-ae38-e6186b5639af';

ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;

DELETE FROM profiles WHERE id = '4e405f1b-33d1-4012-ae38-e6186b5639af';

DELETE FROM auth.users WHERE id = '4e405f1b-33d1-4012-ae38-e6186b5639af';
