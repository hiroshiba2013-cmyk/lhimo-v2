/*
  # Fix Business Trial - Remove Non-Existent Columns

  ## Problem
  The trigger was trying to set trial_end_date which doesn't exist in profiles table.
  
  ## Solution
  1. Only set subscription_status, subscription_type, and subscription_expires_at
  2. Create the subscription record in subscriptions table
  3. Remove references to non-existent trial_end_date column
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
    NEW.subscription_type := 'monthly';
    NEW.subscription_expires_at := trial_end;
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%Mensile%1 Sede%'
    LIMIT 1;
    
    -- Create trial subscription if plan exists
    -- This happens in AFTER INSERT trigger, not in BEFORE INSERT
    -- We'll create a separate AFTER INSERT trigger for this
  END IF;
  
  RETURN NEW;
END;
$$;

-- Create function to insert subscription record AFTER profile is created
CREATE OR REPLACE FUNCTION insert_business_trial_subscription()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles with trial status
  IF NEW.user_type = 'business' AND NEW.subscription_status = 'trial' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%Mensile%1 Sede%'
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

-- Drop and recreate triggers
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;
DROP TRIGGER IF EXISTS trigger_insert_business_trial_subscription ON profiles;

-- BEFORE INSERT trigger to set trial status
CREATE TRIGGER trigger_create_trial_for_business
  BEFORE INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_business_profile();

-- AFTER INSERT trigger to create subscription record
CREATE TRIGGER trigger_insert_business_trial_subscription
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION insert_business_trial_subscription();

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION create_trial_for_business_profile() TO authenticated;
GRANT EXECUTE ON FUNCTION insert_business_trial_subscription() TO authenticated;
