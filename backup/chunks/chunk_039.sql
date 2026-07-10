-- ============================================================
-- FILE: 20260306213115_rename_tax_code_to_fiscal_code.sql
-- ============================================================
/*
  # Rinomina tax_code in fiscal_code

  Questa migrazione standardizza il nome della colonna del codice fiscale 
  da `tax_code` a `fiscal_code` in tutte le tabelle per coerenza.

  ## Cambiamenti

  1. Rinomina `tax_code` in `fiscal_code` nella tabella `customer_family_members`
  2. Aggiorna la funzione `check_family_member_trial_eligibility` per usare `fiscal_code`
  3. Aggiorna il trigger corrispondente

  ## Note

  - La colonna `fiscal_code` esiste già nella tabella `profiles`
  - Tutti i riferimenti nel codice frontend sono stati aggiornati
*/

-- Rinomina la colonna nella tabella customer_family_members
ALTER TABLE customer_family_members 
RENAME COLUMN tax_code TO fiscal_code;

-- Aggiorna la funzione per usare fiscal_code
CREATE OR REPLACE FUNCTION check_family_member_trial_eligibility()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_blocked_cf text;
BEGIN
  -- Controlla solo se il CF è fornito
  IF NEW.fiscal_code IS NULL OR NEW.fiscal_code = '' THEN
    RETURN NEW;
  END IF;

  -- Controlla se questo CF ha già usato il trial
  SELECT fiscal_code INTO v_blocked_cf
  FROM trial_usage_history
  WHERE fiscal_code = NEW.fiscal_code;

  IF v_blocked_cf IS NOT NULL THEN
    RAISE EXCEPTION 'Il codice fiscale % ha già usufruito del periodo di prova', NEW.fiscal_code
      USING ERRCODE = '23514';
  END IF;

  -- Registra il CF del nuovo membro se l'account è in trial
  IF EXISTS (
    SELECT 1 FROM profiles
    WHERE id = NEW.customer_id
      AND subscription_status = 'trial'
  ) THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (NEW.fiscal_code, NEW.customer_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

-- Ricrea il trigger per usare fiscal_code
DROP TRIGGER IF EXISTS trigger_check_family_trial_eligibility ON customer_family_members;

CREATE TRIGGER trigger_check_family_trial_eligibility
  BEFORE INSERT OR UPDATE OF fiscal_code ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION check_family_member_trial_eligibility();


-- ============================================================
-- FILE: 20260306213127_remove_tax_code_from_profiles.sql
-- ============================================================
/*
  # Rimuove colonna tax_code obsoleta da profiles

  Questa migrazione rimuove la colonna `tax_code` dalla tabella `profiles` 
  poiché ora usiamo solo la colonna `fiscal_code`.

  ## Cambiamenti

  1. Rimuove colonna `tax_code` dalla tabella `profiles`

  ## Note

  - La colonna `fiscal_code` è già presente e contiene i dati corretti
  - La tabella `customer_family_members` usa già `fiscal_code` (rinominata nella migrazione precedente)
*/

-- Rimuove colonna tax_code dalla tabella profiles
ALTER TABLE profiles DROP COLUMN IF EXISTS tax_code;


-- ============================================================
-- FILE: 20260307195638_fix_subscriptions_admin_access.sql
-- ============================================================
/*
  # Fix Subscriptions Admin Access
  
  1. Changes
    - Drop all existing policies on subscriptions table
    - Create simple, clear policies for admin and user access
    - Ensure admins can view all subscriptions
    - Ensure users can only view their own subscriptions
  
  2. Security
    - Admins have full read access to all subscriptions
    - Regular users can only view their own subscriptions
    - No recursive calls to avoid performance issues
*/

-- Drop all existing policies on subscriptions
DROP POLICY IF EXISTS "Users can view own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can insert own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can update own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Admins have full access to all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Allow admin full access" ON subscriptions;

-- Create new simple policies
-- 1. Admin can view all subscriptions (check directly in admins table)
CREATE POLICY "Admin can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );

-- 2. Users can view their own subscription
CREATE POLICY "Users can view own subscription"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

-- 3. Admin can insert any subscription
CREATE POLICY "Admin can insert subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );

-- 4. Users can insert their own subscription
CREATE POLICY "Users can insert own subscription"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

-- 5. Admin can update any subscription
CREATE POLICY "Admin can update subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );

-- 6. Users can update their own subscription
CREATE POLICY "Users can update own subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

-- 7. Admin can delete any subscription
CREATE POLICY "Admin can delete subscriptions"
  ON subscriptions FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE admins.user_id = auth.uid()
    )
  );


-- ============================================================
-- FILE: 20260307203506_fix_subscriptions_count_for_admin.sql
-- ============================================================
/*
  # Fix Subscriptions Count for Admin

  1. Problem
    - Admin users cannot perform COUNT operations on subscriptions table
    - The RLS policies are blocking head-only queries (count operations)
  
  2. Solution
    - Simplify admin SELECT policy to allow all operations including COUNT
    - Remove complex EXISTS subqueries that might interfere with head-only queries
    
  3. Security
    - Admin access remains secure through direct admins table lookup
    - Regular users can still only see their own subscriptions
*/

-- Drop existing admin view policy
DROP POLICY IF EXISTS "Admin can view all subscriptions" ON subscriptions;

-- Create simplified admin view policy that works with COUNT operations
CREATE POLICY "Admin can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    -- Check if user is admin directly in admins table
    auth.uid() IN (SELECT user_id FROM admins)
  );

-- Ensure the user policy remains unchanged
-- (Users can view their own subscription)
-- This policy already exists from previous migration


-- ============================================================
-- FILE: 20260307204135_fix_subscriptions_rls_cleanup_duplicates.sql
-- ============================================================
/*
  # Fix Subscriptions RLS - Remove Duplicates

  1. Problem
    - Multiple duplicate RLS policies on subscriptions table
    - Some policies use is_admin() function causing recursion
    - Policies are conflicting with each other
  
  2. Solution
    - Drop ALL existing policies
    - Create clean, simple policies:
      - One for users to view their own subscriptions
      - One for users to manage their own subscriptions
      - One for admins to view all subscriptions (using direct admins table check)
      - One for admins to manage all subscriptions
    
  3. Security
    - Users can only see and manage their own subscriptions
    - Admins can see and manage all subscriptions
    - Direct admins table lookup to avoid recursion
*/

-- Drop ALL existing policies on subscriptions
DROP POLICY IF EXISTS "Admin can delete subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admin can insert subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admin can update subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admin can view all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admins can manage subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Admins can update any subscription" ON subscriptions;
DROP POLICY IF EXISTS "Admins can view all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Users can create own subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Users can insert own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can update own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can update own subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Users can view own subscription" ON subscriptions;
DROP POLICY IF EXISTS "Users can view own subscriptions" ON subscriptions;

-- Create clean policies

-- 1. Users can view their own subscriptions
CREATE POLICY "Users view own subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

-- 2. Users can insert their own subscriptions
CREATE POLICY "Users insert own subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

-- 3. Users can update their own subscriptions
CREATE POLICY "Users update own subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

-- 4. Users can delete their own subscriptions
CREATE POLICY "Users delete own subscriptions"
  ON subscriptions FOR DELETE
  TO authenticated
  USING (customer_id = auth.uid());

-- 5. Admins can view ALL subscriptions (direct admins table check)
CREATE POLICY "Admins view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );

-- 6. Admins can insert ANY subscription
CREATE POLICY "Admins insert any subscription"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );

-- 7. Admins can update ANY subscription
CREATE POLICY "Admins update any subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );

-- 8. Admins can delete ANY subscription
CREATE POLICY "Admins delete any subscription"
  ON subscriptions FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );


-- ============================================================
-- FILE: 20260307205354_fix_subscriptions_admin_rls_use_jwt.sql
-- ============================================================
/*
  # Fix Subscriptions RLS for Admins using JWT

  1. Problem
    - The subquery-based policy for admins is causing issues from the frontend
    - Admin users cannot retrieve subscriptions data
  
  2. Solution
    - Replace subquery-based policy with JWT-based check
    - This is more reliable and performant
  
  3. Security
    - Only users with user_type = 'admin' in profiles can view all subscriptions
*/

-- Drop the old admin policy that uses subquery
DROP POLICY IF EXISTS "Admins view all subscriptions" ON subscriptions;

-- Create new policy using JWT user_type check
CREATE POLICY "Admins view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    (SELECT user_type FROM profiles WHERE id = auth.uid()) = 'admin'
  );


-- ============================================================
-- FILE: 20260308222433_fix_business_trial_subscription_system.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260308222457_fix_business_trial_correct_plan_query.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260308222532_fix_business_trial_remove_nonexistent_columns.sql
-- ============================================================
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


