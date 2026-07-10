/*
  # Fix Business Trial - Correct Plan Query

  ## Problem
  The previous migration used a non-existent column 'user_type' in subscription_plans.
  
  ## Solution
  Use the plan name to identify business plans instead.
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
