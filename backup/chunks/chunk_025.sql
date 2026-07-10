-- ============================================================
-- FILE: 20260210143142_update_search_to_locations_based.sql
-- ============================================================
/*
  # Aggiorna ricerca per cercare nelle sedi invece che nelle attività
  
  ## Modifica Principale
  La funzione di ricerca ora cerca nelle SEDI (locations) invece che nelle attività (businesses).
  Questo significa che se un'attività ha più sedi, ogni sede apparirà separatamente nei risultati.
  
  ## Tabelle Cercate
  1. `unclaimed_business_locations` - Sedi non rivendicate (29018 sedi)
  2. `business_locations` - Sedi rivendicate (2 sedi)
  3. `user_added_businesses` - Sedi aggiunte dagli utenti (0 attualmente)
  
  ## Return Type
  Ogni risultato rappresenta una SEDE specifica, non un'attività.
  Se un'attività ha 5 sedi, appariranno 5 risultati separati.
*/

-- Drop della vecchia funzione
DROP FUNCTION IF EXISTS search_all_businesses(text, text, text, text, uuid, boolean, int);

-- Nuova funzione che cerca nelle sedi
CREATE OR REPLACE FUNCTION search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  category_id uuid,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  
  -- Sedi non rivendicate (unclaimed_business_locations)
  SELECT 
    ubl.id,
    ubl.name,
    ubl.category_id,
    COALESCE(ubl.description, ''),
    ubl.street,
    ubl.city,
    ubl.province,
    ubl.region,
    ubl.postal_code,
    ubl.phone,
    ubl.email,
    ubl.website,
    ubl.business_hours,
    ubl.latitude,
    ubl.longitude,
    'unclaimed'::text as location_type,
    COALESCE(ubl.is_claimed, false) as is_claimed,
    false as is_verified,
    NULL::uuid as business_id,
    ubl.claimed_by as owner_id,
    ubl.created_at
  FROM unclaimed_business_locations ubl
  WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
    AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
    AND (search_province IS NULL OR ubl.province = search_province)
    AND (search_region IS NULL OR ubl.region ILIKE search_region)
    AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
    AND NOT verified_only
  
  UNION ALL
  
  -- Sedi rivendicate (business_locations)
  SELECT 
    bl.id,
    b.name,
    b.category_id,
    COALESCE(bl.description, b.description, ''),
    bl.address,
    bl.city,
    bl.province,
    bl.region,
    bl.postal_code,
    bl.phone,
    bl.email,
    bl.website,
    bl.business_hours::text,
    bl.latitude,
    bl.longitude,
    'claimed'::text as location_type,
    true as is_claimed,
    COALESCE(b.verification_badge = 'verified', false) as is_verified,
    b.id as business_id,
    b.owner_id,
    bl.created_at
  FROM business_locations bl
  INNER JOIN businesses b ON b.id = bl.business_id
  WHERE b.owner_id IS NOT NULL
    AND (search_query = '' OR b.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)
    AND (NOT verified_only OR b.verification_badge = 'verified')
  
  UNION ALL
  
  -- Sedi aggiunte dagli utenti (user_added_businesses)
  SELECT 
    uab.id,
    uab.name,
    uab.category_id,
    COALESCE(uab.description, ''),
    uab.street,
    uab.city,
    uab.province,
    uab.region,
    uab.postal_code,
    uab.phone,
    uab.email,
    uab.website,
    NULL::text as business_hours,
    uab.latitude,
    uab.longitude,
    'user_added'::text as location_type,
    false as is_claimed,
    (uab.verification_status = 'verified') as is_verified,
    NULL::uuid as business_id,
    uab.added_by as owner_id,
    uab.created_at
  FROM user_added_businesses uab
  WHERE (search_query = '' OR uab.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(uab.city) = LOWER(search_city))
    AND (search_province IS NULL OR uab.province = search_province)
    AND (search_region IS NULL OR uab.region ILIKE search_region)
    AND (search_category_id IS NULL OR uab.category_id = search_category_id)
    AND (NOT verified_only OR uab.verification_status = 'verified')
  
  ORDER BY is_verified DESC, is_claimed DESC, name
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Aggiungi commento sulla funzione
COMMENT ON FUNCTION search_all_business_locations IS 
'Cerca nelle SEDI (locations) invece che nelle attività. Ogni sede appare come risultato separato.';

-- Crea alias per retrocompatibilità
CREATE OR REPLACE FUNCTION search_all_businesses(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  category_id uuid,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM search_all_business_locations(
    search_query,
    search_city,
    search_province,
    search_region,
    search_category_id,
    verified_only,
    limit_count
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ============================================================
-- FILE: 20260210145457_fix_verified_filter_include_claimed.sql
-- ============================================================
/*
  # Fix filtro "Solo verificate" per includere attività rivendicate

  1. Modifiche
    - Aggiorna la funzione search_all_business_locations per includere attività con verification_badge = 'claimed' oltre a 'verified'
    - Questo permette al filtro "Solo verificate" di mostrare anche le attività rivendicate dagli utenti

  2. Dettagli
    - Prima: filtra solo businesses con verification_badge = 'verified'
    - Ora: filtra businesses con verification_badge IN ('verified', 'claimed')
*/

-- Drop e ricrea la funzione search_all_business_locations con il fix
DROP FUNCTION IF EXISTS search_all_business_locations(text, text, text, text, uuid, boolean, int);

CREATE OR REPLACE FUNCTION search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  category_id uuid,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  
  -- Sedi non rivendicate (unclaimed_business_locations)
  SELECT 
    ubl.id,
    ubl.name,
    ubl.category_id,
    COALESCE(ubl.description, ''),
    ubl.street,
    ubl.city,
    ubl.province,
    ubl.region,
    ubl.postal_code,
    ubl.phone,
    ubl.email,
    ubl.website,
    ubl.business_hours,
    ubl.latitude,
    ubl.longitude,
    'unclaimed'::text as location_type,
    COALESCE(ubl.is_claimed, false) as is_claimed,
    false as is_verified,
    NULL::uuid as business_id,
    ubl.claimed_by as owner_id,
    ubl.created_at
  FROM unclaimed_business_locations ubl
  WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
    AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
    AND (search_province IS NULL OR ubl.province = search_province)
    AND (search_region IS NULL OR ubl.region ILIKE search_region)
    AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
    AND NOT verified_only
  
  UNION ALL
  
  -- Sedi rivendicate (business_locations)
  SELECT 
    bl.id,
    b.name,
    b.category_id,
    COALESCE(bl.description, b.description, ''),
    bl.address,
    bl.city,
    bl.province,
    bl.region,
    bl.postal_code,
    bl.phone,
    bl.email,
    bl.website,
    bl.business_hours::text,
    bl.latitude,
    bl.longitude,
    'claimed'::text as location_type,
    true as is_claimed,
    COALESCE(b.verification_badge IN ('verified', 'claimed'), false) as is_verified,
    b.id as business_id,
    b.owner_id,
    bl.created_at
  FROM business_locations bl
  INNER JOIN businesses b ON b.id = bl.business_id
  WHERE b.owner_id IS NOT NULL
    AND (search_query = '' OR b.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)
    AND (NOT verified_only OR b.verification_badge IN ('verified', 'claimed'))
  
  UNION ALL
  
  -- Sedi aggiunte dagli utenti (user_added_businesses)
  SELECT 
    uab.id,
    uab.name,
    uab.category_id,
    COALESCE(uab.description, ''),
    uab.street,
    uab.city,
    uab.province,
    uab.region,
    uab.postal_code,
    uab.phone,
    uab.email,
    uab.website,
    NULL::text as business_hours,
    uab.latitude,
    uab.longitude,
    'user_added'::text as location_type,
    false as is_claimed,
    (uab.verification_status = 'verified') as is_verified,
    NULL::uuid as business_id,
    uab.added_by as owner_id,
    uab.created_at
  FROM user_added_businesses uab
  WHERE (search_query = '' OR uab.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(uab.city) = LOWER(search_city))
    AND (search_province IS NULL OR uab.province = search_province)
    AND (search_region IS NULL OR uab.region ILIKE search_region)
    AND (search_category_id IS NULL OR uab.category_id = search_category_id)
    AND (NOT verified_only OR uab.verification_status = 'verified')
  
  ORDER BY is_verified DESC, is_claimed DESC, name
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Aggiorna anche l'alias search_all_businesses
DROP FUNCTION IF EXISTS search_all_businesses(text, text, text, text, uuid, boolean, int);

CREATE OR REPLACE FUNCTION search_all_businesses(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  category_id uuid,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM search_all_business_locations(
    search_query,
    search_city,
    search_province,
    search_region,
    search_category_id,
    verified_only,
    limit_count
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ============================================================
-- FILE: 20260210213810_update_award_points_increment_reviews_count.sql
-- ============================================================
/*
  # Update award_points function to increment reviews_count

  1. Changes
    - Update award_points function to increment reviews_count when activity_type is 'review'
    - This ensures user_activity table tracks both points and review count correctly
    - Fixes leaderboard display issues where review count was not updated

  2. Notes
    - Function is called when reviews are approved
    - Reviews count is incremented only for 'review' activity type
    - Other activity types (referral, product, etc.) only update points
*/

CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT NULL
) RETURNS integer AS $$
DECLARE
  v_new_total integer;
BEGIN
  -- Insert or update user_activity
  IF p_activity_type = 'review' THEN
    -- For reviews, increment both points and reviews_count
    INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at)
    VALUES (p_user_id, p_points, 1, now())
    ON CONFLICT (user_id) 
    DO UPDATE SET 
      total_points = user_activity.total_points + p_points,
      reviews_count = user_activity.reviews_count + 1,
      last_activity_at = now();
  ELSE
    -- For other activities, only increment points
    INSERT INTO user_activity (user_id, total_points, last_activity_at)
    VALUES (p_user_id, p_points, now())
    ON CONFLICT (user_id) 
    DO UPDATE SET 
      total_points = user_activity.total_points + p_points,
      last_activity_at = now();
  END IF;

  -- Get the new total
  SELECT total_points INTO v_new_total
  FROM user_activity
  WHERE user_id = p_user_id;

  -- Return the new total
  RETURN v_new_total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION award_points TO authenticated;


-- ============================================================
-- FILE: 20260210213824_sync_user_activity_reviews_count.sql
-- ============================================================
/*
  # Sync user_activity reviews_count with actual approved reviews

  1. Purpose
    - Recalculate reviews_count for all users based on approved reviews
    - Fixes inconsistencies where reviews_count doesn't match actual approved reviews
    - Updates leaderboard to show correct data

  2. Process
    - Count approved reviews for each user
    - Update user_activity table with correct counts
    - Ensures data consistency between reviews and user_activity tables
*/

-- Update reviews_count for all users based on approved reviews
UPDATE user_activity ua
SET reviews_count = COALESCE(
  (
    SELECT COUNT(*)
    FROM reviews r
    WHERE r.customer_id = ua.user_id
      AND r.review_status = 'approved'
      AND r.family_member_id IS NULL
  ),
  0
);


-- ============================================================
-- FILE: 20260210220536_fix_classified_ads_points_trigger.sql
-- ============================================================
/*
  # Fix Classified Ads Points Trigger

  ## Overview
  Fixes the award_points_for_classified_ad function to use the correct column name user_id instead of owner_id.

  ## Changes
  1. Update the function award_points_for_classified_ad to use NEW.user_id instead of NEW.owner_id
  
  ## Notes
  - The classified_ads table uses user_id, not owner_id
  - This was causing an error when users tried to publish classified ads
*/

-- Fix the function to use the correct column name
CREATE OR REPLACE FUNCTION award_points_for_classified_ad()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 5 punti al proprietario dell'annuncio usando user_id
  PERFORM award_points(NEW.user_id, 5, 'classified_ad', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260211092422_fix_classified_ads_view_own_policy.sql
-- ============================================================
/*
  # Fix Classified Ads - Allow users to view their own ads

  1. Changes
    - Add policy to allow users to view ALL their own classified ads (regardless of status)
    - This is needed for the profile page where users should see their own ads even if not active

  2. Security
    - Users can only see their own ads
    - Public users can still only see active ads
*/

-- Drop policy if exists and recreate
DO $$ 
BEGIN
  DROP POLICY IF EXISTS "Users can view own classified ads regardless of status" ON classified_ads;
END $$;

-- Add policy for users to view their own ads regardless of status
CREATE POLICY "Users can view own classified ads regardless of status"
  ON classified_ads
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);


-- ============================================================
-- FILE: 20260211092827_add_classified_ads_auto_expiration_system.sql
-- ============================================================
/*
  # Add Auto-Expiration System for Classified Ads

  1. New Features
    - Automatic expiration date (30 days) on ad creation
    - Auto-deletion of expired ads with notification
    - Function to clean up expired ads and notify users

  2. Changes
    - Add trigger to set expires_at automatically on insert
    - Add function to delete expired ads and create notifications
    - Add scheduled job support (to be called by edge function)

  3. Security
    - Only system can delete expired ads
    - Notifications are created for affected users
*/

-- Function to set expiration date automatically (30 days from creation)
CREATE OR REPLACE FUNCTION set_classified_ad_expiration()
RETURNS TRIGGER AS $$
BEGIN
  -- Set expiration to 30 days from now if not already set
  IF NEW.expires_at IS NULL THEN
    NEW.expires_at := NOW() + INTERVAL '30 days';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to set expiration on insert
DROP TRIGGER IF EXISTS set_classified_ad_expiration_trigger ON classified_ads;
CREATE TRIGGER set_classified_ad_expiration_trigger
  BEFORE INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION set_classified_ad_expiration();

-- Function to clean up expired ads and notify users
CREATE OR REPLACE FUNCTION delete_expired_classified_ads()
RETURNS TABLE (
  deleted_count INTEGER,
  notified_users UUID[]
) AS $$
DECLARE
  v_deleted_count INTEGER;
  v_notified_users UUID[];
BEGIN
  -- Get list of users with expired ads
  SELECT ARRAY_AGG(DISTINCT user_id)
  INTO v_notified_users
  FROM classified_ads
  WHERE expires_at < NOW() AND status = 'active';

  -- Create notifications for users with expired ads
  INSERT INTO notifications (user_id, title, message, type, link)
  SELECT 
    user_id,
    'Annuncio scaduto',
    'Il tuo annuncio "' || title || '" è scaduto ed è stato rimosso automaticamente dopo 30 giorni.',
    'ad_expired',
    '/profile'
  FROM classified_ads
  WHERE expires_at < NOW() AND status = 'active';

  -- Delete expired ads
  WITH deleted AS (
    DELETE FROM classified_ads
    WHERE expires_at < NOW() AND status = 'active'
    RETURNING id
  )
  SELECT COUNT(*)::INTEGER INTO v_deleted_count FROM deleted;

  RETURN QUERY SELECT v_deleted_count, v_notified_users;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users (will be called by edge function)
GRANT EXECUTE ON FUNCTION delete_expired_classified_ads() TO authenticated;
GRANT EXECUTE ON FUNCTION delete_expired_classified_ads() TO anon;


-- ============================================================
-- FILE: 20260211103632_fix_classified_ads_user_id_foreign_key.sql
-- ============================================================
/*
  # Fix Foreign Key for User Profile in Classified Ads

  1. Changes
    - Drop corrupted foreign key constraint
    - Recreate foreign key constraint between classified_ads.user_id and profiles.id
    - This enables automatic joins in Supabase queries
  
  2. Security
    - All existing ads reference valid user IDs in profiles table
    - Foreign key set to CASCADE on delete for automatic cleanup
*/

-- Drop the corrupted constraint if it exists
DO $$ 
BEGIN
    ALTER TABLE classified_ads DROP CONSTRAINT IF EXISTS classified_ads_user_id_fkey;
EXCEPTION
    WHEN undefined_object THEN NULL;
END $$;

-- Add foreign key constraint from classified_ads to profiles
ALTER TABLE classified_ads
ADD CONSTRAINT classified_ads_user_id_fkey 
FOREIGN KEY (user_id) 
REFERENCES profiles(id) 
ON DELETE CASCADE;


-- ============================================================
-- FILE: 20260211105424_add_job_seekers_fields_and_rls.sql
-- ============================================================
/*
  # Aggiungi campi e RLS a job_seekers

  1. Modifiche alla tabella job_seekers
    - Aggiunge campo `phone` (text, opzionale) - numero di telefono del candidato
    - Aggiunge campo `email` (text, opzionale) - email di contatto del candidato
    - Aggiunge campo `category_id` (uuid, opzionale) - riferimento a business_categories per la categoria lavorativa

  2. Sicurezza
    - Abilita RLS sulla tabella job_seekers
    - Policy per visualizzazione pubblica degli annunci attivi
    - Policy per permettere agli utenti autenticati di creare annunci
    - Policy per permettere agli utenti di modificare/eliminare i propri annunci

  3. Note importanti
    - I campi phone ed email sono facoltativi per privacy
    - La categoria aiuta a filtrare gli annunci per settore lavorativo
*/

-- Add new columns to job_seekers
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'phone'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'email'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE job_seekers ADD COLUMN category_id uuid REFERENCES business_categories(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Create index for category lookups
CREATE INDEX IF NOT EXISTS idx_job_seekers_category ON job_seekers(category_id);

-- Enable RLS
ALTER TABLE job_seekers ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Public can view active job seeker ads" ON job_seekers;
DROP POLICY IF EXISTS "Authenticated users can create job seeker ads" ON job_seekers;
DROP POLICY IF EXISTS "Users can update own job seeker ads" ON job_seekers;
DROP POLICY IF EXISTS "Users can delete own job seeker ads" ON job_seekers;

-- Policy: Everyone can view active job seeker ads
CREATE POLICY "Public can view active job seeker ads"
  ON job_seekers
  FOR SELECT
  TO public
  USING (status = 'active');

-- Policy: Authenticated users can create their own job seeker ads
CREATE POLICY "Authenticated users can create job seeker ads"
  ON job_seekers
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own job seeker ads
CREATE POLICY "Users can update own job seeker ads"
  ON job_seekers
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own job seeker ads
CREATE POLICY "Users can delete own job seeker ads"
  ON job_seekers
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);


