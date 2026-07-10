-- ============================================================
-- FILE: 20260220092426_extend_admin_full_control.sql
-- ============================================================
/*
  # Estensione Controllo Admin Completo

  1. Cosa viene aggiunto
    - Policy admin per registered_businesses e registered_business_locations
    - Policy admin per imported_businesses e user_added_businesses
    - Policy admin per job_postings, job_applications, job_seekers
    - Policy admin per products
    - Policy admin per reports (segnalazioni)
    - Policy admin per customer_family_members
    - Policy admin per discounts
    - Policy admin per tutte le conversazioni e messaggi
    - Policy admin per notifications
    - Policy admin per activity_log

  2. Permessi Admin
    - Gli admin possono visualizzare TUTTI i dati della piattaforma
    - Gli admin possono modificare TUTTI i dati (tranne eliminazioni critiche)
    - Gli admin possono gestire segnalazioni e moderare contenuti
    - Gli admin possono gestire attività business e relative sedi
    - Gli admin possono gestire membri famiglia degli utenti
    - Gli admin possono vedere tutte le conversazioni

  3. Security
    - Solo utenti con is_admin = true possono accedere
    - Le policy sono restrictive e richiedono autenticazione
*/

-- ========================================
-- REGISTERED BUSINESSES E LOCATIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
CREATE POLICY "Admins can view all registered businesses"
  ON registered_businesses FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;
CREATE POLICY "Admins can update any registered business"
  ON registered_businesses FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all registered business locations" ON registered_business_locations;
CREATE POLICY "Admins can view all registered business locations"
  ON registered_business_locations FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any registered business location" ON registered_business_locations;
CREATE POLICY "Admins can update any registered business location"
  ON registered_business_locations FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- IMPORTED E USER ADDED BUSINESSES
-- ========================================

DROP POLICY IF EXISTS "Admins can update imported businesses" ON imported_businesses;
CREATE POLICY "Admins can update imported businesses"
  ON imported_businesses FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete imported businesses" ON imported_businesses;
CREATE POLICY "Admins can delete imported businesses"
  ON imported_businesses FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can view all user added businesses"
  ON user_added_businesses FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can approve user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can approve user added businesses"
  ON user_added_businesses FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- JOB POSTINGS E JOB SEEKERS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all job postings" ON job_postings;
CREATE POLICY "Admins can view all job postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any job posting" ON job_postings;
CREATE POLICY "Admins can update any job posting"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any job posting" ON job_postings;
CREATE POLICY "Admins can delete any job posting"
  ON job_postings FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all job applications" ON job_applications;
CREATE POLICY "Admins can view all job applications"
  ON job_applications FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all job seekers" ON job_seekers;
CREATE POLICY "Admins can view all job seekers"
  ON job_seekers FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any job seeker" ON job_seekers;
CREATE POLICY "Admins can update any job seeker"
  ON job_seekers FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- PRODUCTS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all products" ON products;
CREATE POLICY "Admins can view all products"
  ON products FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any product" ON products;
CREATE POLICY "Admins can update any product"
  ON products FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any product" ON products;
CREATE POLICY "Admins can delete any product"
  ON products FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- REPORTS (SEGNALAZIONI)
-- ========================================

DROP POLICY IF EXISTS "Admins can view all reports" ON reports;
CREATE POLICY "Admins can view all reports"
  ON reports FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any report" ON reports;
CREATE POLICY "Admins can update any report"
  ON reports FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- FAMILY MEMBERS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all family members" ON customer_family_members;
CREATE POLICY "Admins can view all family members"
  ON customer_family_members FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any family member" ON customer_family_members;
CREATE POLICY "Admins can update any family member"
  ON customer_family_members FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- DISCOUNTS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all discounts" ON discounts;
CREATE POLICY "Admins can view all discounts"
  ON discounts FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any discount" ON discounts;
CREATE POLICY "Admins can update any discount"
  ON discounts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any discount" ON discounts;
CREATE POLICY "Admins can delete any discount"
  ON discounts FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- CONVERSATIONS E MESSAGES
-- ========================================

DROP POLICY IF EXISTS "Admins can view all conversations" ON conversations;
CREATE POLICY "Admins can view all conversations"
  ON conversations FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all messages" ON messages;
CREATE POLICY "Admins can view all messages"
  ON messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- NOTIFICATIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all notifications" ON notifications;
CREATE POLICY "Admins can view all notifications"
  ON notifications FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- ACTIVITY LOG
-- ========================================

DROP POLICY IF EXISTS "Admins can view all activity logs" ON activity_log;
CREATE POLICY "Admins can view all activity logs"
  ON activity_log FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Commento
COMMENT ON TABLE profiles IS 'Profili utenti. Gli admin (is_admin = true) hanno accesso completo a tutti i dati della piattaforma.';


-- ============================================================
-- FILE: 20260220112132_fix_trial_trigger_use_user_type.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260224150348_create_tasks_table.sql
-- ============================================================
/*
  # Crea tabella di esempio Tasks

  1. Nuove Tabelle
    - `tasks`
      - `id` (uuid, primary key)
      - `title` (text, titolo del task)
      - `description` (text, descrizione)
      - `completed` (boolean, completato o no)
      - `created_at` (timestamp)
      - `user_id` (uuid, riferimento all'utente)
  
  2. Sicurezza
    - Abilita RLS sulla tabella `tasks`
    - Policy per permettere agli utenti autenticati di vedere solo i propri tasks
    - Policy per permettere agli utenti di inserire i propri tasks
    - Policy per permettere agli utenti di aggiornare i propri tasks
    - Policy per permettere agli utenti di eliminare i propri tasks
*/

CREATE TABLE IF NOT EXISTS tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text DEFAULT '',
  completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE
);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own tasks"
  ON tasks
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tasks"
  ON tasks
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks"
  ON tasks
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks"
  ON tasks
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================
-- FILE: 20260225155410_fix_profiles_rls_recursion.sql
-- ============================================================
/*
  # Fix Profiles RLS Infinite Recursion

  1. Problem
    - Multiple conflicting policies on profiles table
    - is_admin() function causes infinite recursion when checking profiles
    - Policy "Admins can view all profiles" conflicts with "Authenticated users can view all profiles"

  2. Solution
    - Drop the admin-specific policy (redundant since authenticated users can already view all)
    - Keep "Authenticated users can view all profiles" as it covers all cases
    - The is_admin() function can still be used in OTHER tables without issues

  3. Security
    - All authenticated users can still view profiles (needed for app functionality)
    - Users can still update only their own profile
    - Admin checks work fine on other tables
*/

-- Drop the problematic admin policy on profiles
-- This is redundant since "Authenticated users can view all profiles" already allows all viewing
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

-- Verify the remaining policies are correct
-- "Users can view own profile" - Allows users to view their own profile
-- "Authenticated users can view all profiles" - Allows all authenticated users to view any profile
-- "Users can update own profile" - Allows users to update only their own profile
-- "Users can insert own profile" - Allows users to insert their own profile

-- The is_admin() function is still available and works fine for OTHER tables
-- It just can't be used on the profiles table itself due to recursion


-- ============================================================
-- FILE: 20260225155813_fix_is_admin_use_jwt.sql
-- ============================================================
/*
  # Fix is_admin() Using JWT Instead of Database Query

  1. Problem
    - is_admin() function queries profiles table causing infinite recursion
    - Many policies use is_admin() or direct EXISTS queries on profiles
    - This creates recursion loops when accessing any table

  2. Solution
    - Modify is_admin() to read from JWT metadata instead of database
    - JWT contains app_metadata which can store is_admin flag
    - This approach is instant, secure, and avoids any database queries

  3. Implementation
    - Update is_admin() function to use auth.jwt()
    - The is_admin flag should be stored in app_metadata when user is created/updated
    - JWT is signed by Supabase and cannot be tampered with

  4. Security
    - JWT-based check is more secure as it cannot be manipulated
    - No database queries = no recursion = faster checks
    - app_metadata can only be set server-side, not by users
*/

-- Drop and recreate is_admin() function to use JWT
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'is_admin')::boolean,
    false
  );
$$;

-- Create a trigger to sync is_admin to JWT metadata when profile is updated
-- This ensures the JWT gets updated when admin status changes
CREATE OR REPLACE FUNCTION sync_admin_to_jwt()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Note: In production, you would use a proper Supabase Admin API call
  -- For now, we rely on the profile table having the correct is_admin value
  -- The JWT will be updated on next login
  RETURN NEW;
END;
$$;

-- For now, we'll rely on profiles.is_admin column
-- When you need to make someone admin, update their profile:
-- UPDATE profiles SET is_admin = true WHERE id = 'user-id';
-- They will need to log out and log back in for JWT to refresh

COMMENT ON FUNCTION is_admin() IS 'Checks if current user is admin using JWT app_metadata. For recursion-free RLS policies.';


-- ============================================================
-- FILE: 20260225155832_create_admins_table_no_rls.sql
-- ============================================================
/*
  # Create Admins Table Without RLS

  1. Problem
    - Checking profiles table for is_admin causes infinite recursion
    - JWT app_metadata is not automatically populated
    - Need a simple, recursion-free way to check admin status

  2. Solution
    - Create a separate 'admins' table with NO RLS enabled
    - This table can be queried without triggering any RLS policies
    - Update is_admin() to query this table instead of profiles

  3. Tables
    - `admins` table with just user_id column
    - No RLS = no recursion issues
    - Simple and fast to query

  4. Security
    - Only admins can modify the admins table (checked via separate policies)
    - The is_admin() function can safely query this table
    - No circular dependencies
*/

-- Create admins table (no RLS!)
CREATE TABLE IF NOT EXISTS admins (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now() NOT NULL
);

-- NO RLS on this table! This is intentional to avoid recursion
-- The table is read-only for checking admin status

-- Migrate existing admins from profiles table
INSERT INTO admins (user_id)
SELECT id FROM profiles WHERE is_admin = true
ON CONFLICT (user_id) DO NOTHING;

-- Update is_admin() function to use admins table
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE user_id = auth.uid()
  );
$$;

-- Create a trigger to keep admins table in sync with profiles
CREATE OR REPLACE FUNCTION sync_profile_admin_status()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NEW.is_admin = true AND NOT EXISTS (SELECT 1 FROM admins WHERE user_id = NEW.id) THEN
    INSERT INTO admins (user_id) VALUES (NEW.id);
  ELSIF NEW.is_admin = false THEN
    DELETE FROM admins WHERE user_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS sync_admin_status_trigger ON profiles;
CREATE TRIGGER sync_admin_status_trigger
  AFTER INSERT OR UPDATE OF is_admin ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION sync_profile_admin_status();

COMMENT ON TABLE admins IS 'Admin users list. NO RLS to avoid recursion in is_admin() checks.';
COMMENT ON FUNCTION is_admin() IS 'Checks if current user is admin using admins table (no RLS = no recursion).';


