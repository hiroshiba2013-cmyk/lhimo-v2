/*
  # Fix Business Trial Subscription System

  ## Problem
  Business users are not getting trial subscriptions upon registration, unlike customer users.

  ## Solution
  1. Create trigger function to automatically assign trial subscription to business users
  2. Set subscription_status to 'trial'
  3. Create subscription entry with basic business plan (1 location)
  4. Set trial period to 30 days

  ## Changes
  - Creates/replaces trigger function for business trial creation
  - Ensures business users get same trial treatment as customers
  - Links to appropriate business subscription plan
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
  IF NEW.user_type = 'business' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';
    
    -- Set trial fields on NEW instead of doing UPDATE to avoid recursion
    NEW.subscription_status := 'trial';
    NEW.trial_end_date := trial_end;
    NEW.subscription_type := 'monthly';
    NEW.subscription_expires_at := trial_end;
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE user_type = 'business'
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
      )
      ON CONFLICT (customer_id) DO NOTHING;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;

-- Create trigger that fires BEFORE insert on profiles
CREATE TRIGGER trigger_create_trial_for_business
  BEFORE INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_business_profile();

-- Grant execute permission
GRANT EXECUTE ON FUNCTION create_trial_for_business_profile() TO authenticated;
