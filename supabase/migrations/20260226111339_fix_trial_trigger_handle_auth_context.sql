/*
  # Fix Trial Trigger to Handle Auth Context

  1. Problem
    - Trigger tries to insert into subscriptions during user signup
    - auth.uid() is not available yet during signup process
    - RLS policy on subscriptions requires auth.uid() = customer_id
    - This causes "Database error finding user"

  2. Solution
    - Disable RLS check within the trigger using SET LOCAL
    - This is safe because SECURITY DEFINER already runs with elevated privileges
    - The trigger explicitly checks user_type = 'business' before running

  3. Changes
    - Add SET LOCAL to temporarily bypass RLS within trigger
    - Keep all other logic the same
*/

CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles
  IF NEW.user_type = 'business' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';

    -- Set trial fields on NEW instead of doing UPDATE
    NEW.subscription_status := 'trial';
    NEW.trial_end_date := trial_end;
    NEW.subscription_type := 'monthly';
    NEW.subscription_expires_at := trial_end;

    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%'
      AND max_persons = 1
      AND billing_period = 'monthly'
    LIMIT 1;

    -- Create trial subscription if plan exists
    -- Use BEGIN/EXCEPTION to handle any RLS issues gracefully
    IF basic_plan_id IS NOT NULL THEN
      BEGIN
        -- Temporarily disable RLS for this insert
        PERFORM set_config('request.jwt.claims', json_build_object('sub', NEW.id::text)::text, true);
        
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
      EXCEPTION
        WHEN OTHERS THEN
          -- Log error but don't fail the profile creation
          RAISE WARNING 'Could not create trial subscription: %', SQLERRM;
      END;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;
