/*
  # Fix Trial Creation Trigger - Use user_type Instead of profile_type

  ## Changes
  Updates the trigger function to use the correct column name 'user_type' instead of 'profile_type'
  
  ## Tables Affected
  - profiles: trigger function updated
*/

-- Update function to use user_type instead of profile_type
CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles (using user_type instead of profile_type)
  IF NEW.user_type = 'business' THEN
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
