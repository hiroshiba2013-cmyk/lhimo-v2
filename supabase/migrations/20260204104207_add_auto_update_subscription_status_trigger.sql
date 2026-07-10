/*
  # Add Automatic Subscription Status Update Trigger

  1. Changes
    - Create function to automatically update profile subscription_status when subscription is created or updated
    - Add trigger to subscriptions table to call this function

  2. Security
    - Function runs with SECURITY DEFINER to allow updating profiles table
    - Only updates the specific user's profile based on customer_id
*/

-- Function to update profile subscription status based on subscription
CREATE OR REPLACE FUNCTION update_profile_subscription_status()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update the profile subscription_status based on the subscription status
  UPDATE profiles
  SET subscription_status = NEW.status
  WHERE id = NEW.customer_id;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;

-- Create trigger that fires after insert or update on subscriptions
CREATE TRIGGER trigger_update_profile_subscription_status
  AFTER INSERT OR UPDATE OF status ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_profile_subscription_status();