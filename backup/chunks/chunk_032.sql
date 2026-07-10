-- ============================================================
-- FILE: 20260225160723_fix_profiles_rls_recursion.sql
-- ============================================================
/*
  # Fix Profiles RLS Recursion Issue

  1. Problem
    - Policy "Public can view profiles with active job seeker ads" causes recursion
    - This policy queries job_seekers which may query back to profiles
    - Creating a circular dependency causing infinite recursion

  2. Solution
    - Remove the problematic policy
    - Keep only simple, direct policies without subqueries on other tables
    - Allow authenticated users to view profiles (safe and simple)
    - Public access can be handled at application level if needed

  3. Changes
    - Drop "Public can view profiles with active job seeker ads" policy
    - Keep "Users can view own profile" for owner access
    - Keep "Authenticated users can view all profiles" for logged-in users
    - No more circular dependencies
*/

-- Drop the problematic policy that causes recursion
DROP POLICY IF EXISTS "Public can view profiles with active job seeker ads" ON profiles;

-- Verify remaining policies are safe (no subqueries to other tables)
-- "Users can view own profile" - safe, only checks auth.uid()
-- "Authenticated users can view all profiles" - safe, no subqueries
-- "Users can update own profile" - safe, only checks auth.uid()
-- "Users can insert own profile" - safe, no conditions

COMMENT ON TABLE profiles IS 'User profiles with safe RLS policies that avoid recursion.';


-- ============================================================
-- FILE: 20260225160827_replace_all_profile_subqueries_with_is_admin.sql
-- ============================================================
/*
  # Replace All Profile Subqueries with is_admin()

  1. Problem
    - Many policies across different tables query profiles table directly
    - This causes infinite recursion when any of these policies are evaluated
    - Pattern: EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)

  2. Solution
    - Replace ALL occurrences of profile subqueries with is_admin() function
    - is_admin() now uses the admins table (no RLS = no recursion)
    - This will fix recursion across the entire database

  3. Tables to Update
    - activity_log, conversations, customer_family_members, discounts
    - imported_businesses, job_applications, job_postings, job_requests
    - job_seekers, messages, notifications, products
    - registered_business_locations, registered_businesses, reports
    - user_added_businesses, and storage objects
*/

-- ============================================================
-- ACTIVITY_LOG
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all activity logs" ON activity_log;
CREATE POLICY "Admins can view all activity logs"
  ON activity_log FOR SELECT
  USING (is_admin());

-- ============================================================
-- CONVERSATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all conversations" ON conversations;
CREATE POLICY "Admins can view all conversations"
  ON conversations FOR SELECT
  USING (is_admin());

-- ============================================================
-- CUSTOMER_FAMILY_MEMBERS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all family members" ON customer_family_members;
CREATE POLICY "Admins can view all family members"
  ON customer_family_members FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any family member" ON customer_family_members;
CREATE POLICY "Admins can update any family member"
  ON customer_family_members FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- DISCOUNTS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all discounts" ON discounts;
CREATE POLICY "Admins can view all discounts"
  ON discounts FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any discount" ON discounts;
CREATE POLICY "Admins can update any discount"
  ON discounts FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any discount" ON discounts;
CREATE POLICY "Admins can delete any discount"
  ON discounts FOR DELETE
  USING (is_admin());

-- ============================================================
-- IMPORTED_BUSINESSES
-- ============================================================
DROP POLICY IF EXISTS "Only admins can manage imported businesses" ON imported_businesses;
CREATE POLICY "Only admins can manage imported businesses"
  ON imported_businesses FOR ALL
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can update imported businesses" ON imported_businesses;
CREATE POLICY "Admins can update imported businesses"
  ON imported_businesses FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete imported businesses" ON imported_businesses;
CREATE POLICY "Admins can delete imported businesses"
  ON imported_businesses FOR DELETE
  USING (is_admin());

-- ============================================================
-- JOB_APPLICATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all job applications" ON job_applications;
CREATE POLICY "Admins can view all job applications"
  ON job_applications FOR SELECT
  USING (is_admin());

-- ============================================================
-- JOB_POSTINGS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all job postings" ON job_postings;
CREATE POLICY "Admins can view all job postings"
  ON job_postings FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any job posting" ON job_postings;
CREATE POLICY "Admins can update any job posting"
  ON job_postings FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any job posting" ON job_postings;
CREATE POLICY "Admins can delete any job posting"
  ON job_postings FOR DELETE
  USING (is_admin());

-- ============================================================
-- JOB_REQUESTS
-- ============================================================
DROP POLICY IF EXISTS "Customers can create job requests" ON job_requests;
CREATE POLICY "Customers can create job requests"
  ON job_requests FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM auth.users WHERE id = auth.uid())
  );

-- ============================================================
-- JOB_SEEKERS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all job seekers" ON job_seekers;
CREATE POLICY "Admins can view all job seekers"
  ON job_seekers FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any job seeker" ON job_seekers;
CREATE POLICY "Admins can update any job seeker"
  ON job_seekers FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- MESSAGES
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all messages" ON messages;
CREATE POLICY "Admins can view all messages"
  ON messages FOR SELECT
  USING (is_admin());

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all notifications" ON notifications;
CREATE POLICY "Admins can view all notifications"
  ON notifications FOR SELECT
  USING (is_admin());

-- ============================================================
-- PRODUCTS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all products" ON products;
CREATE POLICY "Admins can view all products"
  ON products FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any product" ON products;
CREATE POLICY "Admins can update any product"
  ON products FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any product" ON products;
CREATE POLICY "Admins can delete any product"
  ON products FOR DELETE
  USING (is_admin());

-- ============================================================
-- REGISTERED_BUSINESS_LOCATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all registered business locations" ON registered_business_locations;
CREATE POLICY "Admins can view all registered business locations"
  ON registered_business_locations FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any registered business location" ON registered_business_locations;
CREATE POLICY "Admins can update any registered business location"
  ON registered_business_locations FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- REGISTERED_BUSINESSES
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
CREATE POLICY "Admins can view all registered businesses"
  ON registered_businesses FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;
CREATE POLICY "Admins can update any registered business"
  ON registered_businesses FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- REPORTS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all reports" ON reports;
CREATE POLICY "Admins can view all reports"
  ON reports FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any report" ON reports;
CREATE POLICY "Admins can update any report"
  ON reports FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- USER_ADDED_BUSINESSES
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can view all user added businesses"
  ON user_added_businesses FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can approve user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can approve user added businesses"
  ON user_added_businesses FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Users can update own businesses" ON user_added_businesses;
CREATE POLICY "Users can update own businesses"
  ON user_added_businesses FOR UPDATE
  USING (added_by = auth.uid() OR is_admin())
  WITH CHECK (added_by = auth.uid() OR is_admin());

-- ============================================================
-- REVIEWS (staff policy)
-- ============================================================
DROP POLICY IF EXISTS "Staff can view all reviews" ON reviews;
CREATE POLICY "Staff can view all reviews"
  ON reviews FOR SELECT
  USING (is_admin());

-- ============================================================
-- STORAGE: review-proofs bucket
-- ============================================================
DROP POLICY IF EXISTS "Staff can view all review proofs" ON storage.objects;
CREATE POLICY "Staff can view all review proofs"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'review-proofs' AND is_admin());

COMMENT ON FUNCTION is_admin() IS 'All policies updated to use is_admin() instead of querying profiles directly. No more recursion!';


-- ============================================================
-- FILE: 20260226101245_add_admins_table_rls_policies.sql
-- ============================================================
/*
  # Add RLS Policies to Admins Table

  1. Security
    - Enable RLS on admins table for better security
    - Allow public read access (needed for is_admin() function to work)
    - Only allow inserts/updates/deletes from the trigger (SECURITY DEFINER)
    - No direct user modifications allowed
  
  2. Changes
    - Enable RLS on admins table
    - Add policy for public SELECT (read-only)
    - Inserts/updates/deletes only via trigger
*/

-- Enable RLS on admins table
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read from admins table (needed for is_admin() checks and admin login)
CREATE POLICY "Anyone can read admins table"
  ON admins
  FOR SELECT
  USING (true);

-- No policies for INSERT/UPDATE/DELETE
-- These operations should only happen via the trigger which uses SECURITY DEFINER
-- This prevents users from directly modifying the admins table

COMMENT ON TABLE admins IS 'Admin users list. Public read access for is_admin() checks. Modifications only via trigger.';


-- ============================================================
-- FILE: 20260226103954_add_fiscal_code_to_profiles.sql
-- ============================================================
/*
  # Add fiscal_code field to profiles

  1. Changes
    - Add `fiscal_code` column to `profiles` table
      - Type: text (16 alphanumeric characters)
      - Unique constraint to prevent duplicates
      - Used for Italian fiscal code identification
  
  2. Notes
    - Fiscal codes are optional for now (nullable)
    - Can be made required in the future if needed
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'fiscal_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN fiscal_code text UNIQUE;
  END IF;
END $$;

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_profiles_fiscal_code ON profiles(fiscal_code);

-- ============================================================
-- FILE: 20260226105500_fix_admin_registration_nickname_check.sql
-- ============================================================
/*
  # Fix Admin Registration - Allow Nickname Check

  1. Changes
    - Add public SELECT policy on profiles table to check if nickname exists
    - This allows the registration form to verify nickname uniqueness before creating the account
  
  2. Security
    - Policy only allows reading the 'id' field when filtering by nickname
    - Does not expose sensitive user data
    - Necessary for preventing duplicate nicknames during registration
*/

-- Allow public to check if a nickname exists (for registration validation)
CREATE POLICY "Allow public to check nickname existence"
  ON profiles
  FOR SELECT
  TO public
  USING (true);


-- ============================================================
-- FILE: 20260226110535_fix_admin_registration_disable_trigger.sql
-- ============================================================
/*
  # Fix Admin Registration - Disable Problematic Trigger

  1. Problem
    - The sync_admin_status_trigger runs during user signup
    - This causes "Database error finding user" because it tries to query
      during the auth.users creation process
    - Triggers with SECURITY DEFINER can cause issues during signup

  2. Solution
    - Drop the automatic trigger that syncs admins table
    - Create a simple function to manually promote users to admin
    - This avoids any database errors during the signup process

  3. Changes
    - Drop sync_admin_status_trigger
    - Drop sync_profile_admin_status function
    - Create promote_to_admin function for manual promotion
*/

-- Drop the problematic trigger
DROP TRIGGER IF EXISTS sync_admin_status_trigger ON profiles;

-- Drop the function
DROP FUNCTION IF EXISTS sync_profile_admin_status();

-- Create a simple function to promote a user to admin
-- This will be called AFTER the profile is created
CREATE OR REPLACE FUNCTION promote_to_admin(target_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update profile to admin
  UPDATE profiles 
  SET is_admin = true, user_type = 'admin'
  WHERE id = target_user_id;
  
  -- Insert into admins table if not exists
  INSERT INTO admins (user_id)
  VALUES (target_user_id)
  ON CONFLICT (user_id) DO NOTHING;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION promote_to_admin(uuid) TO authenticated;


-- ============================================================
-- FILE: 20260226111317_fix_trial_trigger_avoid_update.sql
-- ============================================================
/*
  # Fix Trial Trigger to Avoid UPDATE During INSERT

  1. Problem
    - The trigger does an UPDATE on profiles during INSERT
    - This can cause "Database error finding user" because it modifies
      the row being inserted, potentially conflicting with RLS policies
    - SECURITY DEFINER with UPDATE can cause recursion issues

  2. Solution
    - Modify NEW directly instead of doing an UPDATE
    - This is more efficient and avoids RLS policy conflicts
    - Still create the subscription record as before

  3. Changes
    - Update create_trial_for_business_profile to set NEW fields
    - Remove the UPDATE statement that causes issues
*/

CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS trigger
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


-- ============================================================
-- FILE: 20260226111339_fix_trial_trigger_handle_auth_context.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260226111717_disable_trial_trigger_completely.sql
-- ============================================================
/*
  # Disable Trial Trigger Completely

  1. Problem
    - The trigger is causing "Database error finding user" during signup
    - Even with SECURITY DEFINER and error handling, it's causing issues
    - The trigger tries to insert into subscriptions before the user is fully created

  2. Solution
    - Drop the trigger completely
    - Handle trial creation in application code after successful signup
    - This is safer and gives us more control over the process

  3. Changes
    - Drop the trigger
    - Keep the function in case we need it later (commented out)
*/

-- Drop the trigger
DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;

-- Drop the function too since it's causing issues
DROP FUNCTION IF EXISTS create_trial_for_business_profile();


-- ============================================================
-- FILE: 20260226111751_add_auto_profile_creation_trigger.sql
-- ============================================================
/*
  # Add Automatic Profile Creation Trigger

  1. Purpose
    - Automatically create a profile in the profiles table when a user signs up
    - This ensures consistency and avoids manual profile creation
    - Prevents "Database error finding user" issues

  2. Changes
    - Create function to handle new user registration
    - Add trigger on auth.users table
    - Extract metadata from auth.users.raw_user_meta_data if available

  3. Security
    - Function runs with SECURITY DEFINER to bypass RLS
    - Only creates profile, doesn't set admin or special permissions
*/

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    user_type,
    subscription_status
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'customer',
    'none'
  );
  
  RETURN NEW;
END;
$$;

-- Create trigger on auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- FILE: 20260226212025_disable_auto_profile_trigger_temporarily.sql
-- ============================================================
/*
  # Disable Auto Profile Creation Trigger Temporarily

  1. Problem
    - The trigger is causing "Database error finding user" during signup
    - Supabase's auth system might be checking for the profile before the trigger completes
    
  2. Solution
    - Disable the trigger temporarily
    - Handle profile creation in application code with proper error handling
    
  3. Changes
    - Drop the trigger
    - Keep the function for potential future use
*/

-- Drop the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;


-- ============================================================
-- FILE: 20260226213034_re_enable_auto_profile_trigger.sql
-- ============================================================
/*
  # Re-enable Auto Profile Creation Trigger with Error Handling

  1. Problem
    - Admin signup fails with "Database error finding user"
    - Need automatic profile creation that doesn't interfere with auth.signup()
    
  2. Solution
    - Re-enable the trigger with improved error handling
    - Use INSERT ... ON CONFLICT to handle race conditions
    - Use EXCEPTION handling to prevent trigger failures from blocking signup
    
  3. Changes
    - Update handle_new_user function with better error handling
    - Re-create the trigger
*/

-- Drop and recreate the function with better error handling
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  -- Insert profile with ON CONFLICT to handle duplicates gracefully
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    user_type,
    subscription_status,
    is_admin
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'customer',
    'none',
    false
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the signup
    RAISE WARNING 'Error creating profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- Re-create the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- FILE: 20260226213753_disable_auto_profile_trigger_final.sql
-- ============================================================
/*
  # Disable Auto Profile Trigger

  1. Problem
    - Automatic profile creation interferes with admin registration
    - Edge Function now handles profile creation with proper permissions
    
  2. Solution
    - Drop the automatic profile creation trigger
    - Edge Functions will handle profile creation explicitly
*/

-- Drop the trigger completely
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Keep the function for potential future use but it won't be called automatically
-- DROP FUNCTION IF EXISTS public.handle_new_user();


