-- ============================================================
-- FILE: 20260508055303_add_is_claimed_to_source_tables.sql
-- ============================================================
/*
  # Add is_claimed tracking to imported_businesses and user_added_businesses

  ## Changes
  - Add `is_claimed` boolean column to `imported_businesses` (default false)
  - Add `claimed_at` timestamp to `imported_businesses`
  - Add `claimed_by_business_id` uuid to `imported_businesses` (FK to registered_businesses)
  - Add `is_claimed` boolean column to `user_added_businesses` (default false)
  - Add `claimed_at` timestamp to `user_added_businesses`
  - Add `claimed_by_business_id` uuid to `user_added_businesses` (FK to registered_businesses)

  ## Purpose
  When a business owner claims their location through the registration flow,
  the original source record gets marked as claimed so it no longer appears
  as "available" in search results on the ClaimBusinessPage.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'imported_businesses' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE imported_businesses ADD COLUMN is_claimed boolean NOT NULL DEFAULT false;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'imported_businesses' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE imported_businesses ADD COLUMN claimed_at timestamptz;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'imported_businesses' AND column_name = 'claimed_by_business_id'
  ) THEN
    ALTER TABLE imported_businesses ADD COLUMN claimed_by_business_id uuid REFERENCES registered_businesses(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_added_businesses' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE user_added_businesses ADD COLUMN is_claimed boolean NOT NULL DEFAULT false;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_added_businesses' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE user_added_businesses ADD COLUMN claimed_at timestamptz;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_added_businesses' AND column_name = 'claimed_by_business_id'
  ) THEN
    ALTER TABLE user_added_businesses ADD COLUMN claimed_by_business_id uuid REFERENCES registered_businesses(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Index for fast filtering of unclaimed businesses
CREATE INDEX IF NOT EXISTS idx_imported_businesses_is_claimed ON imported_businesses(is_claimed);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_is_claimed ON user_added_businesses(is_claimed);


-- ============================================================
-- FILE: 20260508122517_fix_get_comuni_by_provincia_use_sigla.sql
-- ============================================================
/*
  # Fix get_comuni_by_provincia function

  The function was querying `WHERE provincia = p_provincia` but the table uses
  `sigla` for the province code (e.g. 'VA') and `provincia` for the full name
  (e.g. 'Varese'). The admin filter passes the sigla code, so we fix the
  function to match on `sigla`.

  Also adds a secondary function to get comuni by full province name for flexibility.
*/

CREATE OR REPLACE FUNCTION get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text)
LANGUAGE sql
STABLE
AS $$
  SELECT ci.comune
  FROM comuni_italiani ci
  WHERE ci.sigla = p_provincia
  ORDER BY ci.comune;
$$;

-- Also expose by region for the region filter
CREATE OR REPLACE FUNCTION get_province_by_regione(p_regione text)
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  WHERE ci.regione = p_regione
  ORDER BY ci.provincia;
$$;


-- ============================================================
-- FILE: 20260508205842_add_get_all_province_function.sql
-- ============================================================
/*
  # Add get_all_province function

  Returns all distinct provinces (with sigla) from comuni_italiani,
  used by AdminLocationFilter to allow filtering by province without
  requiring a region to be selected first.
*/

CREATE OR REPLACE FUNCTION get_all_province()
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  ORDER BY ci.provincia;
$$;


-- ============================================================
-- FILE: 20260510202526_fix_location_functions_security_definer.sql
-- ============================================================
/*
  # Fix location RPC functions - add SECURITY DEFINER

  The functions get_all_province, get_province_by_regione, get_comuni_by_provincia
  run as SECURITY INVOKER which can cause issues with RLS even when the table
  has a public read policy. Recreate them as SECURITY DEFINER so they always
  have access to comuni_italiani regardless of the calling user's context.
*/

CREATE OR REPLACE FUNCTION get_all_province()
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  ORDER BY ci.provincia;
$$;

CREATE OR REPLACE FUNCTION get_province_by_regione(p_regione text)
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  WHERE ci.regione = p_regione
  ORDER BY ci.provincia;
$$;

CREATE OR REPLACE FUNCTION get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT ci.comune
  FROM comuni_italiani ci
  WHERE ci.sigla = p_provincia
  ORDER BY ci.comune;
$$;


-- ============================================================
-- FILE: 20260510202659_create_search_business_tracking_function.sql
-- ============================================================
/*
  # Create search_business_tracking function

  Single server-side function for the admin "Verifica Attività" section.
  Accepts filters: type, province_code, city, region, name_search.
  Returns unified results from unclaimed_business_locations + registered_businesses.
  Runs as SECURITY DEFINER so admin RLS is bypassed cleanly.
*/

CREATE OR REPLACE FUNCTION search_business_tracking(
  p_type text DEFAULT 'all',           -- 'all','claimed','user_added','imported','registered'
  p_province text DEFAULT NULL,        -- sigla es. 'VA'
  p_city text DEFAULT NULL,            -- partial match
  p_region text DEFAULT NULL,
  p_name text DEFAULT NULL,            -- partial match
  p_limit int DEFAULT 300
)
RETURNS TABLE (
  id uuid,
  name text,
  city text,
  province text,
  region text,
  street text,
  type text,
  created_at timestamptz,
  verified boolean,
  approval_status text,
  category_name text,
  owner_name text,
  owner_email text,
  added_by_name text,
  added_by_email text
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  -- unclaimed: user_added
  SELECT
    u.id,
    u.name,
    u.city,
    u.province,
    u.region,
    u.street,
    'user_added'::text AS type,
    u.created_at,
    NULL::boolean AS verified,
    u.approval_status,
    bc.name AS category_name,
    p.full_name AS owner_name,
    p.email AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM unclaimed_business_locations u
  LEFT JOIN business_categories bc ON bc.id = u.category_id
  LEFT JOIN profiles p ON p.id = u.added_by
  WHERE
    (p_type = 'all' OR p_type = 'user_added')
    AND u.added_by IS NOT NULL
    AND u.claimed_by IS NULL
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_region IS NULL OR p_region = '' OR u.region = p_region)
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')

  UNION ALL

  -- unclaimed: imported
  SELECT
    u.id,
    u.name,
    u.city,
    u.province,
    u.region,
    u.street,
    'imported'::text AS type,
    u.created_at,
    NULL::boolean AS verified,
    u.approval_status,
    bc.name AS category_name,
    NULL::text AS owner_name,
    NULL::text AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM unclaimed_business_locations u
  LEFT JOIN business_categories bc ON bc.id = u.category_id
  WHERE
    (p_type = 'all' OR p_type = 'imported')
    AND u.added_by IS NULL
    AND u.claimed_by IS NULL
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_region IS NULL OR p_region = '' OR u.region = p_region)
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')

  UNION ALL

  -- unclaimed: claimed
  SELECT
    u.id,
    u.name,
    u.city,
    u.province,
    u.region,
    u.street,
    'claimed'::text AS type,
    u.created_at,
    NULL::boolean AS verified,
    u.approval_status,
    bc.name AS category_name,
    p.full_name AS owner_name,
    p.email AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM unclaimed_business_locations u
  LEFT JOIN business_categories bc ON bc.id = u.category_id
  LEFT JOIN profiles p ON p.id = u.claimed_by
  WHERE
    (p_type = 'all' OR p_type = 'claimed')
    AND u.claimed_by IS NOT NULL
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_region IS NULL OR p_region = '' OR u.region = p_region)
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')

  UNION ALL

  -- registered businesses
  SELECT
    rb.id,
    rb.name,
    COALESCE(rb.office_city, rb.billing_city, '') AS city,
    COALESCE(rb.office_province, rb.billing_province, '') AS province,
    NULL::text AS region,
    COALESCE(rb.office_street, rb.billing_street, '') AS street,
    'registered'::text AS type,
    rb.created_at,
    rb.verified,
    NULL::text AS approval_status,
    bc.name AS category_name,
    p.full_name AS owner_name,
    p.email AS owner_email,
    NULL::text AS added_by_name,
    NULL::text AS added_by_email
  FROM registered_businesses rb
  LEFT JOIN business_categories bc ON bc.id = rb.category_id
  LEFT JOIN profiles p ON p.id = rb.owner_id
  WHERE
    (p_type = 'all' OR p_type = 'registered')
    AND (p_province IS NULL OR p_province = '' OR rb.office_province = p_province OR rb.billing_province = p_province)
    AND (p_city IS NULL OR p_city = '' OR rb.office_city ILIKE '%' || p_city || '%' OR rb.billing_city ILIKE '%' || p_city || '%')
    AND (p_name IS NULL OR p_name = '' OR rb.name ILIKE '%' || p_name || '%')

  ORDER BY created_at DESC
  LIMIT p_limit;
END;
$$;


-- ============================================================
-- FILE: 20260510204237_create_search_unclaimed_businesses_function.sql
-- ============================================================
/*
  # Create search_unclaimed_businesses function

  Server-side search for ClaimBusinessPage with proper pagination.
  Searches unclaimed_business_locations by name, province (sigla), city, address.
  Returns total count + paginated results so the frontend can paginate properly.
  SECURITY DEFINER to bypass RLS cleanly for public searches.
*/

-- Returns paginated results
CREATE OR REPLACE FUNCTION search_unclaimed_businesses(
  p_name text DEFAULT NULL,
  p_province text DEFAULT NULL,   -- sigla es. 'VA'
  p_city text DEFAULT NULL,
  p_address text DEFAULT NULL,
  p_page int DEFAULT 1,
  p_page_size int DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  street text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  category_id uuid,
  is_claimed boolean,
  added_by uuid,
  total_count bigint
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_offset int := (p_page - 1) * p_page_size;
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    u.name,
    u.street,
    u.city,
    u.province,
    u.region,
    u.postal_code,
    u.phone,
    u.email,
    u.website,
    u.category_id,
    u.is_claimed,
    u.added_by,
    COUNT(*) OVER() AS total_count
  FROM unclaimed_business_locations u
  WHERE
    u.is_claimed = false
    AND u.approval_status = 'approved'
    AND (p_province IS NULL OR p_province = '' OR u.province = p_province)
    AND (p_city IS NULL OR p_city = '' OR u.city ILIKE '%' || p_city || '%')
    AND (p_name IS NULL OR p_name = '' OR u.name ILIKE '%' || p_name || '%')
    AND (p_address IS NULL OR p_address = '' OR u.street ILIKE '%' || p_address || '%')
  ORDER BY
    CASE WHEN p_name IS NOT NULL AND p_name != '' THEN
      similarity(u.name, p_name)
    ELSE 0 END DESC,
    u.name ASC
  LIMIT p_page_size
  OFFSET v_offset;
END;
$$;

-- Returns distinct cities for a given province from actual data
CREATE OR REPLACE FUNCTION get_cities_by_province(p_province text)
RETURNS TABLE(city text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT u.city
  FROM unclaimed_business_locations u
  WHERE u.province = p_province
    AND u.is_claimed = false
    AND u.approval_status = 'approved'
    AND u.city IS NOT NULL
    AND u.city != ''
  ORDER BY u.city;
$$;


-- ============================================================
-- FILE: 20260510210115_add_attachments_to_messages.sql
-- ============================================================
/*
  # Add attachment support to messages

  1. Changes
    - `messages` table: add `attachment_url` (text, nullable) — public URL of the uploaded file
    - `messages` table: add `attachment_type` (text, nullable) — 'cv' | 'image'
    - `messages` table: add `attachment_name` (text, nullable) — original filename for display

  2. Storage buckets
    - `chat-cvs` — for CV files sent in job conversations (private, signed URLs)
    - `chat-images` — for images sent in classified ad conversations (public)

  3. RLS on storage
    - Authenticated users can upload to their own folder
    - Authenticated users can read files in conversations they belong to (via signed URL for cv, public for images)
*/

-- Add attachment columns to messages
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'attachment_url'
  ) THEN
    ALTER TABLE messages ADD COLUMN attachment_url text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'attachment_type'
  ) THEN
    ALTER TABLE messages ADD COLUMN attachment_type text CHECK (attachment_type IN ('cv', 'image'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'attachment_name'
  ) THEN
    ALTER TABLE messages ADD COLUMN attachment_name text;
  END IF;
END $$;


-- ============================================================
-- FILE: 20260510213542_configure_cron_jobs_edge_functions.sql
-- ============================================================
/*
  # Configurazione cron job per edge functions

  Attiva l'estensione pg_cron e configura i job pianificati per:
  1. close-expired-auctions: ogni ora, chiude le aste scadute
  2. cleanup-expired-ads: ogni giorno a mezzanotte, elimina annunci scaduti
  3. check-subscription-expiration: ogni giorno alle 3:00, controlla abbonamenti scaduti
  4. send-trial-reminders: ogni giorno alle 9:00, invia promemoria trial
*/

-- Abilita pg_cron se non già attivo
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Rimuovi job esistenti per evitare duplicati
SELECT cron.unschedule('close-expired-auctions') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'close-expired-auctions'
);
SELECT cron.unschedule('cleanup-expired-ads') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'cleanup-expired-ads'
);
SELECT cron.unschedule('check-subscription-expiration') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'check-subscription-expiration'
);
SELECT cron.unschedule('send-trial-reminders') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'send-trial-reminders'
);

-- Asta scaduta: ogni ora
SELECT cron.schedule(
  'close-expired-auctions',
  '0 * * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/close-expired-auctions',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Annunci scaduti: ogni giorno a mezzanotte
SELECT cron.schedule(
  'cleanup-expired-ads',
  '0 0 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/cleanup-expired-ads',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Abbonamenti scaduti: ogni giorno alle 3:00
SELECT cron.schedule(
  'check-subscription-expiration',
  '0 3 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/check-subscription-expiration',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Promemoria trial: ogni giorno alle 9:00
SELECT cron.schedule(
  'send-trial-reminders',
  '0 9 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/send-trial-reminders',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);


-- ============================================================
-- FILE: 20260511072322_create_professional_profiles_table.sql
-- ============================================================
/*
  # Create professional_profiles table

  ## Summary
  Adds a `professional_profiles` table linked to the `profiles` table (customer accounts).
  This is the "professional profile" feature for private users (user_type = 'customer').

  ## New Tables
  - `professional_profiles`
    - `id` (uuid, PK)
    - `user_id` (uuid, FK → profiles.id, unique — one profile per user)
    - `profession` (text) - job title / profession
    - `city` (text) - city of residence/work
    - `province` (text)
    - `region` (text)
    - `experience_years` (integer) - years of professional experience
    - `summary` (text) - short bio / description
    - `skills` (text[]) - list of skills
    - `created_at`, `updated_at` (timestamptz)

  ## Security
  - RLS enabled
  - Owners can SELECT/INSERT/UPDATE/DELETE their own row
  - Business users can SELECT all profiles (they need to view candidates)
  - Public cannot read — visibility is restricted to authenticated business users
*/

CREATE TABLE IF NOT EXISTS professional_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  profession text NOT NULL DEFAULT '',
  city text NOT NULL DEFAULT '',
  province text NOT NULL DEFAULT '',
  region text NOT NULL DEFAULT '',
  experience_years integer NOT NULL DEFAULT 0,
  summary text NOT NULL DEFAULT '',
  skills text[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT professional_profiles_user_id_unique UNIQUE (user_id)
);

ALTER TABLE professional_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owner can view own professional profile"
  ON professional_profiles FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.user_type = 'business'
    )
  );

CREATE POLICY "Owner can insert own professional profile"
  ON professional_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Owner can update own professional profile"
  ON professional_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Owner can delete own professional profile"
  ON professional_profiles FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS professional_profiles_user_id_idx ON professional_profiles(user_id);

CREATE OR REPLACE FUNCTION update_professional_profile_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER professional_profiles_updated_at
  BEFORE UPDATE ON professional_profiles
  FOR EACH ROW EXECUTE FUNCTION update_professional_profile_updated_at();


-- ============================================================
-- FILE: 20260511075135_add_admin_policies_professional_profiles.sql
-- ============================================================
/*
  # Add admin access policies for professional_profiles

  ## Changes
  - Add SELECT policy: admins (is_admin = true in profiles) can view all professional profiles
  - Add UPDATE policy: admins can update any professional profile
  - Add DELETE policy: admins can delete any professional profile

  ## Notes
  Uses the is_admin flag on profiles table, consistent with how other admin policies work in this project.
*/

CREATE POLICY "Admins can view all professional profiles"
  ON professional_profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
  );

CREATE POLICY "Admins can update any professional profile"
  ON professional_profiles FOR UPDATE
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

CREATE POLICY "Admins can delete any professional profile"
  ON professional_profiles FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
  );


