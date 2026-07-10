/*
  # Add Automatic Trial Creation for Business Registration

  ## Changes
  Creates a trigger that automatically:
  1. Sets trial status and trial_end_date (30 days from registration) for business profiles
  2. Creates a trial subscription entry linked to the basic business plan
  3. Ensures all business users start with 1 month free trial automatically

  ## Tables Affected
  - profiles: Updates subscription_status and trial_end_date on INSERT
  - subscriptions: Creates a trial subscription entry for business users

  ## Security
  - Function runs with SECURITY DEFINER to allow creating subscriptions
  - Only affects business profile types
  - Automatically grants 30 days trial period
*/

-- Function to create trial subscription for new business profiles
CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles
  IF NEW.profile_type = 'business' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';
    
    -- Update profile with trial status and trial_end_date
    UPDATE profiles
    SET 
      subscription_status = 'trial',
      trial_end_date = trial_end,
      subscription_type = 'monthly',
      subscription_expires_at = trial_end
    WHERE id = NEW.id;
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%'
    AND max_persons = 1
    AND billing_period = 'monthly'
    LIMIT 1;
    
    -- Create trial subscription if plan exists
    IF basic_plan_id IS NOT NULL THEN
      INSERT INTO subscriptions (
        customer_id,
        plan_id,
        status,
        start_date,
        end_date,
        trial_end_date,
        payment_method_added
      ) VALUES (
        NEW.id,
        basic_plan_id,
        'trial',
        now(),
        trial_end,
        trial_end,
        false
      );
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;

-- Create trigger that fires after insert on profiles
CREATE TRIGGER trigger_create_trial_for_business
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_business_profile();

-- Grant execute permission
GRANT EXECUTE ON FUNCTION create_trial_for_business_profile() TO authenticated;