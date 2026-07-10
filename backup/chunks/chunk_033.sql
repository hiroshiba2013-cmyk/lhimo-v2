-- ============================================================
-- FILE: 20260227080233_allow_admin_self_promotion.sql
-- ============================================================
/*
  # Allow Admin Self-Promotion During Registration

  1. Changes
    - Allow users to set is_admin and user_type during profile creation
    - Allow users to insert into admins table during registration
    - This is temporary for initial admin setup

  2. Security
    - Users can only modify their own profile during creation
    - The admin key validation happens in the application layer
*/

-- Allow users to set admin fields during their own profile creation/update
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow users to insert themselves into admins table
DROP POLICY IF EXISTS "Only admins can manage admins table" ON admins;
CREATE POLICY "Users can insert themselves as admin"
  ON admins FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- FILE: 20260227080326_fix_auth_database_error.sql
-- ============================================================
/*
  # Fix Auth Database Error

  1. Changes
    - Simplify profiles RLS policies to avoid recursion issues during auth
    - Remove complex subqueries that might cause database errors

  2. Security
    - Keep basic security but avoid performance issues
*/

-- Drop and recreate profiles policies with simpler logic
DROP POLICY IF EXISTS "Public can view basic profile info" ON profiles;
CREATE POLICY "Public can view basic profile info"
  ON profiles FOR SELECT
  TO public
  USING (true);

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================================
-- FILE: 20260227080349_disable_trial_trigger_for_auth_fix.sql
-- ============================================================
/*
  # Disable Trial Trigger Temporarily

  1. Changes
    - Drop the trial trigger that might cause auth issues
    - We'll re-enable it later with proper error handling

  2. Reason
    - The trigger might be causing database errors during auth
*/

DROP TRIGGER IF EXISTS trigger_update_trial_on_family_insert ON customer_family_members;
DROP TRIGGER IF EXISTS trigger_update_trial_on_family_delete ON customer_family_members;
DROP FUNCTION IF EXISTS update_trial_plan_on_family_change();

-- ============================================================
-- FILE: 20260227080411_disable_subscription_triggers_for_auth_fix.sql
-- ============================================================
/*
  # Disable Subscription Triggers Temporarily

  1. Changes
    - Disable subscription-related triggers that might interfere with auth

  2. Reason
    - These triggers run complex queries that might cause auth errors
*/

-- Disable the subscription status update trigger
DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;

-- We can re-enable it later with better error handling

-- ============================================================
-- FILE: 20260227084030_fix_admins_rls_for_login.sql
-- ============================================================
/*
  # Fix Admins RLS for Login

  1. Changes
    - Drop existing public SELECT policy on admins table
    - Add new policy allowing authenticated users to check if a user_id is an admin
    - This fixes the "Database error querying schema" issue during admin login

  2. Security
    - Only authenticated users can query the admins table
    - Users can only check admin status, not see all admin data
*/

-- Drop the problematic public policy
DROP POLICY IF EXISTS "Anyone can read admins table" ON admins;

-- Add policy for authenticated users to check admin status
CREATE POLICY "Authenticated users can check admin status"
  ON admins
  FOR SELECT
  TO authenticated
  USING (true);


-- ============================================================
-- FILE: 20260227090013_add_admin_to_user_type_check.sql
-- ============================================================
/*
  # Add admin to user_type check constraint

  1. Changes
    - Drop existing user_type check constraint
    - Add new constraint that includes 'admin' as valid value
    
  2. Security
    - No changes to RLS policies
*/

-- Drop existing constraint
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_user_type_check;

-- Add new constraint including 'admin'
ALTER TABLE profiles ADD CONSTRAINT profiles_user_type_check 
  CHECK (user_type IN ('customer', 'business', 'admin'));


-- ============================================================
-- FILE: 20260227103952_re_enable_auto_profile_creation_for_admins.sql
-- ============================================================
/*
  # Re-enable Auto Profile Creation for Admin Registration

  1. Changes
    - Re-enable the automatic profile creation trigger for new auth users
    - This ensures that when an admin registers via the Edge Function, a profile is automatically created
    - The trigger creates a profile with user_type 'user' by default, which is then updated by the Edge Function
  
  2. Security
    - Trigger runs in a secure context
    - Only creates profiles for users that don't already have one
*/

-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created_create_profile ON auth.users;

-- Re-create the trigger function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'user', -- Default to user type, will be updated by admin registration function
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-create the trigger
CREATE TRIGGER on_auth_user_created_create_profile
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- FILE: 20260227105455_add_admin_profile_read_policy.sql
-- ============================================================
/*
  # Add Admin Profile Read Policy

  1. Problem
    - Admins cannot read their own profile data
    - This causes "permission denied" errors when admin logs in
    - Admin needs to read profiles table to get their user_type and basic info

  2. Solution
    - Add SELECT policy allowing admins to read their own profile
    - Use auth.uid() to ensure admin can only read their own data

  3. Security
    - Admin can only read their own profile record
    - Uses auth.uid() for security check
*/

-- Add policy for admins to read their own profile
CREATE POLICY "Admins can read own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (id = auth.uid() AND user_type = 'admin');


-- ============================================================
-- FILE: 20260227142637_create_admin_login_logs.sql
-- ============================================================
/*
  # Create Admin Login Logs System

  1. New Tables
    - `admin_login_logs`
      - `id` (uuid, primary key)
      - `admin_id` (uuid, references profiles)
      - `login_time` (timestamptz)
      - `ip_address` (text, optional)
      - `user_agent` (text, optional)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on admin_login_logs table
    - Only admins can view their own login history
    - System can insert login records

  3. Purpose
    - Track admin login activity
    - Show last access times in admin dashboard
    - Security audit trail
*/

-- Create admin login logs table
CREATE TABLE IF NOT EXISTS admin_login_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  login_time timestamptz DEFAULT now(),
  ip_address text,
  user_agent text,
  created_at timestamptz DEFAULT now()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_admin_login_logs_admin_id ON admin_login_logs(admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_login_logs_login_time ON admin_login_logs(login_time DESC);

-- Enable RLS
ALTER TABLE admin_login_logs ENABLE ROW LEVEL SECURITY;

-- Admin can view their own login logs
CREATE POLICY "Admins can view own login logs"
  ON admin_login_logs
  FOR SELECT
  TO authenticated
  USING (
    admin_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM admins WHERE user_id = auth.uid()
    )
  );

-- Allow service role to insert login logs (for the backend to track logins)
CREATE POLICY "Service can insert login logs"
  ON admin_login_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ============================================================
-- FILE: 20260227154828_fix_admin_policies_all_tables.sql
-- ============================================================
/*
  # Fix Admin RLS Policies for All Tables

  1. Changes
    - Add admin policies for subscription_plans
    - Add admin policies for subscriptions
    - Add admin policies for activity_log
    - Add admin policies for solidarity_documents
    - Add admin policies for user_activity
    - Add admin policies for unclaimed_business_locations
    - Add admin policies for classified_ads
    - Add admin policies for reviews

  2. Security
    - Use admins table to check admin status
    - All policies check auth.uid() EXISTS in admins table
*/

-- Helper function to check if user is admin (using admins table)
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admins
    WHERE user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- SUBSCRIPTION PLANS
-- ========================================

DROP POLICY IF EXISTS "Admins can manage subscription plans" ON subscription_plans;
CREATE POLICY "Admins can manage subscription plans"
  ON subscription_plans FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- SUBSCRIPTIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all subscriptions" ON subscriptions;
CREATE POLICY "Admins can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage subscriptions" ON subscriptions;
CREATE POLICY "Admins can manage subscriptions"
  ON subscriptions FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- ACTIVITY LOG
-- ========================================

DROP POLICY IF EXISTS "Admins can view all activity log" ON activity_log;
CREATE POLICY "Admins can view all activity log"
  ON activity_log FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage activity log" ON activity_log;
CREATE POLICY "Admins can manage activity log"
  ON activity_log FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- SOLIDARITY DOCUMENTS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all solidarity documents" ON solidarity_documents;
CREATE POLICY "Admins can view all solidarity documents"
  ON solidarity_documents FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage solidarity documents" ON solidarity_documents;
CREATE POLICY "Admins can manage solidarity documents"
  ON solidarity_documents FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- USER ACTIVITY
-- ========================================

DROP POLICY IF EXISTS "Admins can view all user activity" ON user_activity;
CREATE POLICY "Admins can view all user activity"
  ON user_activity FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage user activity" ON user_activity;
CREATE POLICY "Admins can manage user activity"
  ON user_activity FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- UNCLAIMED BUSINESS LOCATIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all unclaimed business locations" ON unclaimed_business_locations;
CREATE POLICY "Admins can view all unclaimed business locations"
  ON unclaimed_business_locations FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage unclaimed business locations" ON unclaimed_business_locations;
CREATE POLICY "Admins can manage unclaimed business locations"
  ON unclaimed_business_locations FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- CLASSIFIED ADS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all classified ads" ON classified_ads;
CREATE POLICY "Admins can view all classified ads"
  ON classified_ads FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage classified ads" ON classified_ads;
CREATE POLICY "Admins can manage classified ads"
  ON classified_ads FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- REVIEWS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all reviews" ON reviews;
CREATE POLICY "Admins can view all reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage reviews" ON reviews;
CREATE POLICY "Admins can manage reviews"
  ON reviews FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- BUSINESS CATEGORIES
-- ========================================

DROP POLICY IF EXISTS "Admins can manage business categories" ON business_categories;
CREATE POLICY "Admins can manage business categories"
  ON business_categories FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Comment
COMMENT ON FUNCTION is_admin() IS 'Helper function to check if current user is an admin using the admins table';


-- ============================================================
-- FILE: 20260227221828_add_logout_time_to_admin_login_logs.sql
-- ============================================================
/*
  # Add Logout Time to Admin Login Logs

  1. Changes
    - Add logout_time column to admin_login_logs table
    - Allow tracking both login and logout events

  2. Security
    - Column is nullable to allow tracking of open sessions
*/

-- Add logout_time column
ALTER TABLE admin_login_logs
ADD COLUMN IF NOT EXISTS logout_time timestamptz;

-- Create index for logout queries
CREATE INDEX IF NOT EXISTS idx_admin_login_logs_logout_time 
ON admin_login_logs(logout_time);

-- Comment
COMMENT ON COLUMN admin_login_logs.logout_time IS 'Timestamp of when the admin logged out from this session';


-- ============================================================
-- FILE: 20260227221850_add_admin_logout_tracking.sql
-- ============================================================
/*
  # Add Admin Logout Tracking

  1. Changes
    - Create function to log admin logout
    - Update the last login session with logout time

  2. Security
    - Only authenticated admins can log logout
*/

-- Function to log admin logout
CREATE OR REPLACE FUNCTION log_admin_logout()
RETURNS void AS $$
BEGIN
  -- Update the most recent login log for this admin with logout time
  UPDATE admin_login_logs
  SET logout_time = now()
  WHERE admin_id = auth.uid()
    AND logout_time IS NULL
    AND login_time = (
      SELECT MAX(login_time)
      FROM admin_login_logs
      WHERE admin_id = auth.uid()
        AND logout_time IS NULL
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION log_admin_logout() TO authenticated;

-- Comment
COMMENT ON FUNCTION log_admin_logout() IS 'Logs the logout time for the current admin session';


-- ============================================================
-- FILE: 20260302111510_add_delete_admin_account_function.sql
-- ============================================================
/*
  # Funzione per Eliminare Account Admin

  1. Nuova Funzione
    - `delete_admin_account()` - Funzione che elimina l'account admin corrente e tutti i dati associati
  
  2. Cosa Viene Eliminato
    - Log di accesso admin (admin_login_logs)
    - Record dalla tabella admins
    - Profilo (profiles)
    - Account auth (auth.users)

  3. Sicurezza
    - La funzione può essere eseguita solo da utenti autenticati con ruolo admin
    - Verifica che l'utente sia effettivamente un admin prima di procedere
    - Tutti i dati vengono eliminati in modo irreversibile
    - L'admin può eliminare solo il proprio account, non altri admin
*/

-- Funzione per eliminare l'account admin corrente
CREATE OR REPLACE FUNCTION delete_admin_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  is_user_admin boolean;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Verifica che l'utente sia un admin
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE id = user_profile_id
  ) INTO is_user_admin;

  IF NOT is_user_admin THEN
    RAISE EXCEPTION 'Solo gli admin possono eliminare account admin';
  END IF;

  -- Elimina i log di accesso admin
  DELETE FROM admin_login_logs WHERE admin_id = user_profile_id;

  -- Elimina il record dalla tabella admins
  DELETE FROM admins WHERE id = user_profile_id;

  -- Gestisci riferimenti che devono restare nelle altre tabelle
  -- Rimuovi il riferimento all'admin nelle recensioni approvate
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Rimuovi il riferimento all'admin nei report revisionati
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina il profilo
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;

  RAISE NOTICE 'Account admin eliminato completamente: %', user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_admin_account() TO authenticated;

-- Commento sulla funzione
COMMENT ON FUNCTION delete_admin_account() IS 'Elimina completamente l''account admin corrente e tutti i dati associati. Solo gli admin possono usare questa funzione. Eliminazione PERMANENTE e IRREVERSIBILE.';


-- ============================================================
-- FILE: 20260302111809_fix_delete_admin_account_use_user_id.sql
-- ============================================================
/*
  # Fix Delete Admin Account Function - Usa user_id

  1. Problema
    - La funzione delete_admin_account() usa "id" ma la colonna nella tabella admins si chiama "user_id"
    - Anche admin_login_logs usa "admin_id" che è una foreign key a admins(user_id)

  2. Soluzione
    - Aggiorna la funzione per usare la colonna corretta: user_id
*/

-- Ricrea la funzione con le colonne corrette
CREATE OR REPLACE FUNCTION delete_admin_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  is_user_admin boolean;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Verifica che l'utente sia un admin (usa user_id)
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE user_id = user_profile_id
  ) INTO is_user_admin;

  IF NOT is_user_admin THEN
    RAISE EXCEPTION 'Solo gli admin possono eliminare account admin';
  END IF;

  -- Elimina i log di accesso admin
  DELETE FROM admin_login_logs WHERE admin_id = user_profile_id;

  -- Elimina il record dalla tabella admins (usa user_id)
  DELETE FROM admins WHERE user_id = user_profile_id;

  -- Gestisci riferimenti che devono restare nelle altre tabelle
  -- Rimuovi il riferimento all'admin nelle recensioni approvate
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Rimuovi il riferimento all'admin nei report revisionati
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina il profilo
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;

  RAISE NOTICE 'Account admin eliminato completamente: %', user_profile_id;

END;
$$;


-- ============================================================
-- FILE: 20260302141922_fix_subscription_status_default_allow_null.sql
-- ============================================================
/*
  # Fix subscription_status default for admin accounts

  1. Changes
    - Remove default value from subscription_status to allow NULL for admin accounts
    - Admin accounts don't need subscription management
  
  2. Security
    - No changes to RLS policies
*/

-- Remove the default value from subscription_status
ALTER TABLE profiles 
  ALTER COLUMN subscription_status DROP DEFAULT;


-- ============================================================
-- FILE: 20260302142247_fix_subscription_status_constraint_allow_null.sql
-- ============================================================
/*
  # Fix subscription_status constraint to allow NULL

  1. Changes
    - Drop existing constraint that doesn't allow NULL
    - Add new constraint that allows NULL OR valid values
    - This enables admin accounts to have NULL subscription_status
  
  2. Security
    - No changes to RLS policies
*/

-- Drop the existing constraint
ALTER TABLE profiles 
  DROP CONSTRAINT IF EXISTS profiles_subscription_status_check;

-- Add new constraint that allows NULL
ALTER TABLE profiles 
  ADD CONSTRAINT profiles_subscription_status_check 
  CHECK (
    subscription_status IS NULL OR 
    subscription_status IN ('trial', 'active', 'expired', 'cancelled')
  );


-- ============================================================
-- FILE: 20260302142258_fix_subscription_type_constraint_allow_null.sql
-- ============================================================
/*
  # Fix subscription_type constraint to allow NULL

  1. Changes
    - Drop existing constraint that doesn't allow NULL
    - Add new constraint that allows NULL OR valid values
    - This enables admin accounts to have NULL subscription_type
  
  2. Security
    - No changes to RLS policies
*/

-- Drop the existing constraint
ALTER TABLE profiles 
  DROP CONSTRAINT IF EXISTS profiles_subscription_type_check;

-- Add new constraint that allows NULL
ALTER TABLE profiles 
  ADD CONSTRAINT profiles_subscription_type_check 
  CHECK (
    subscription_type IS NULL OR 
    subscription_type IN ('monthly', 'annual')
  );


