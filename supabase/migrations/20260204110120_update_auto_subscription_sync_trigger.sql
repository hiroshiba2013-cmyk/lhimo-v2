/*
  # Update Automatic Subscription Status Sync Trigger

  1. Changes
    - Enhance function to sync subscription_status, subscription_type, and subscription_expires_at from subscriptions to profiles
    - Update trigger to fire on any relevant field change

  2. Security
    - Function runs with SECURITY DEFINER to allow updating profiles table
    - Only updates the specific user's profile based on customer_id
*/

-- Function to update profile subscription fields based on subscription
CREATE OR REPLACE FUNCTION update_profile_subscription_status()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  subscription_type_value text;
  plan_billing_period text;
BEGIN
  -- Get the billing period from the subscription plan
  SELECT billing_period INTO plan_billing_period
  FROM subscription_plans
  WHERE id = NEW.plan_id;
  
  -- Map billing_period to subscription_type
  subscription_type_value := CASE 
    WHEN plan_billing_period = 'monthly' THEN 'monthly'
    WHEN plan_billing_period = 'yearly' THEN 'annual'
    ELSE 'monthly'
  END;
  
  -- Update the profile with subscription info
  UPDATE profiles
  SET 
    subscription_status = NEW.status,
    subscription_type = subscription_type_value,
    subscription_expires_at = NEW.end_date
  WHERE id = NEW.customer_id;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;

-- Create trigger that fires after insert or update on subscriptions
CREATE TRIGGER trigger_update_profile_subscription_status
  AFTER INSERT OR UPDATE OF status, plan_id, end_date ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_profile_subscription_status();