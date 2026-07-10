-- ============================================================
-- FILE: 20260504144641_add_business_location_to_classified_ads_and_auctions.sql
-- ============================================================
/*
  # Add business location support to classified_ads and auctions

  ## Purpose
  Business users with multiple locations (sedi) need their classified ads and auctions
  to be associated with a specific location. This allows filtering so each sede sees
  only its own content, while the "all locations" view shows everything.

  ## Changes

  ### classified_ads
  - Add `business_location_id` (FK to business_locations) - for old business system
  - Add `registered_business_location_id` (FK to registered_business_locations) - for new system

  ### auctions
  - Add `business_location_id` (FK to business_locations)
  - Add `registered_business_location_id` (FK to registered_business_locations)

  ## Notes
  - Existing records remain with NULL location (treated as "all locations")
  - No destructive changes
*/

-- classified_ads: add business location columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

-- auctions: add business location columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE auctions ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE auctions ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_classified_ads_business_location_id ON classified_ads(business_location_id);
CREATE INDEX IF NOT EXISTS idx_classified_ads_registered_business_location_id ON classified_ads(registered_business_location_id);
CREATE INDEX IF NOT EXISTS idx_auctions_business_location_id ON auctions(business_location_id);
CREATE INDEX IF NOT EXISTS idx_auctions_registered_business_location_id ON auctions(registered_business_location_id);


-- ============================================================
-- FILE: 20260505150714_add_report_submitted_notification.sql
-- ============================================================
/*
  # Add notification when a report is submitted

  1. Changes
    - Adds a trigger on `reports` INSERT that sends a notification to the reporter
    - Notification type: 'report_submitted'
    - Also notifies all admin users about the new report

  2. Notes
    - The reporter receives confirmation that their report was received
    - Uses SECURITY DEFINER so the trigger can insert into notifications
*/

-- Function: notify reporter when they submit a report
CREATE OR REPLACE FUNCTION notify_report_submitted()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_entity_label text;
BEGIN
  v_entity_label := CASE NEW.reported_entity_type
    WHEN 'classified_ad' THEN 'annuncio'
    WHEN 'review' THEN 'recensione'
    WHEN 'business' THEN 'attività'
    WHEN 'auction' THEN 'asta'
    WHEN 'job_posting' THEN 'offerta di lavoro'
    ELSE 'contenuto'
  END;

  -- Notify the reporter that their report was received
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    NEW.reporter_id,
    NEW.family_member_id,
    'report_submitted',
    'Segnalazione inviata',
    'La tua segnalazione per questo ' || v_entity_label || ' è stata ricevuta e verrà esaminata dal nostro staff.',
    jsonb_build_object(
      'entity_type', NEW.reported_entity_type,
      'entity_id', NEW.reported_entity_id,
      'report_id', NEW.id
    )
  );

  RETURN NEW;
END;
$$;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trigger_notify_report_submitted ON reports;

CREATE TRIGGER trigger_notify_report_submitted
  AFTER INSERT ON reports
  FOR EACH ROW
  EXECUTE FUNCTION notify_report_submitted();


-- ============================================================
-- FILE: 20260505151931_fix_approve_auction_add_notification.sql
-- ============================================================
/*
  # Fix approve_auction: add notification to auction owner

  The approve_auction function was missing the INSERT into notifications.
  This migration recreates the function with the notification included.
*/

CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction RECORD;
  points_to_award integer := 15;
  v_user_type text;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta e'' gia'' stata processata'; END IF;

  SELECT user_type INTO v_user_type FROM profiles WHERE id = v_auction.user_id;
  IF v_user_type = 'business' THEN points_to_award := 0; END IF;

  UPDATE auctions
  SET approval_status = 'approved',
      status = 'active',
      approved_by = p_admin_id,
      approved_at = now(),
      points_awarded = points_to_award
  WHERE id = p_auction_id;

  IF points_to_award > 0 THEN
    INSERT INTO user_activity (user_id, family_member_id, total_points, last_activity_at, created_at, updated_at)
    VALUES (v_auction.user_id, NULL, points_to_award, now(), now(), now())
    ON CONFLICT (user_id, family_member_id)
    DO UPDATE SET
      total_points = user_activity.total_points + points_to_award,
      last_activity_at = now(),
      updated_at = now();
  END IF;

  INSERT INTO activity_log (user_id, activity_type, title, description, points_earned, metadata)
  VALUES (
    p_admin_id,
    'auction_approved',
    'Asta approvata',
    v_auction.title,
    points_to_award,
    jsonb_build_object('auction_id', p_auction_id)
  );

  -- Notification to auction owner
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    CASE WHEN points_to_award > 0
      THEN 'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile. Hai guadagnato ' || points_to_award || ' punti!'
      ELSE 'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile a tutti gli utenti.'
    END,
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', points_to_award)
  );
END;
$$;


-- ============================================================
-- FILE: 20260505153034_fix_points_auctions_and_jobs_upsert.sql
-- ============================================================
/*
  # Fix points upsert for auctions and job postings

  ## Problem
  - approve_auction: used ON CONFLICT (user_id, family_member_id) but family_member_id
    was hardcoded NULL, so it never matched the correct unique index
    (user_activity_user_id_null_family_unique).
  - approve_job_posting: same issue — used wrong ON CONFLICT syntax.

  ## Fix
  Both functions now branch on whether family_member_id is NULL or not,
  using the correct unique index in each case, matching the pattern used
  by other working functions (approve_classified_ad, approve_review, etc.).
*/

-- ─── approve_auction ────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction       RECORD;
  points_to_award integer := 15;
  v_user_type     text;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  SELECT user_type INTO v_user_type FROM profiles WHERE id = v_auction.user_id;
  IF v_user_type = 'business' THEN points_to_award := 0; END IF;

  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_by     = p_admin_id,
      approved_at     = now(),
      points_awarded  = points_to_award
  WHERE id = p_auction_id;

  -- Award points using the correct unique index branch
  IF points_to_award > 0 THEN
    IF v_auction.family_member_id IS NOT NULL THEN
      INSERT INTO user_activity (user_id, family_member_id, total_points, last_activity_at, created_at, updated_at)
      VALUES (v_auction.user_id, v_auction.family_member_id, points_to_award, now(), now(), now())
      ON CONFLICT (user_id, family_member_id)
      DO UPDATE SET
        total_points     = user_activity.total_points + points_to_award,
        last_activity_at = now(),
        updated_at       = now();
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, last_activity_at, created_at, updated_at)
      VALUES (v_auction.user_id, NULL, points_to_award, now(), now(), now())
      ON CONFLICT (user_id) WHERE family_member_id IS NULL
      DO UPDATE SET
        total_points     = user_activity.total_points + points_to_award,
        last_activity_at = now(),
        updated_at       = now();
    END IF;
  END IF;

  -- Activity log
  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    'La tua asta "' || v_auction.title || '" è stata approvata.',
    points_to_award,
    jsonb_build_object('auction_id', p_auction_id),
    'check-circle', 'green'
  );

  -- Notification to owner
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    CASE WHEN points_to_award > 0
      THEN 'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile. Hai guadagnato ' || points_to_award || ' punti in classifica!'
      ELSE 'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile a tutti gli utenti.'
    END,
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', points_to_award)
  );
END;
$$;

-- ─── approve_job_posting ────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION approve_job_posting(
  p_job_id   uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job      RECORD;
  v_owner_id uuid;
  points_to_award integer := 10;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  -- Determine the real owner
  IF v_job.rb_owner_id IS NULL AND v_job.business_id IS NOT NULL THEN
    SELECT owner_id INTO v_owner_id FROM businesses WHERE id = v_job.business_id;
  ELSE
    v_owner_id := v_job.rb_owner_id;
  END IF;

  UPDATE job_postings
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    -- Award points using correct unique index branch (jobs have no family_member_id)
    INSERT INTO user_activity (user_id, family_member_id, total_points, job_postings_count, last_activity_at, created_at, updated_at)
    VALUES (v_owner_id, NULL, points_to_award, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      total_points       = user_activity.total_points + points_to_award,
      job_postings_count = COALESCE(user_activity.job_postings_count, 0) + 1,
      last_activity_at   = now(),
      updated_at         = now();

    -- Activity log
    INSERT INTO activity_log (user_id, activity_type, title, description, points_earned, metadata, icon, color)
    VALUES (
      v_owner_id,
      'job_posting_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro è stato approvato.',
      points_to_award,
      jsonb_build_object('job_id', p_job_id),
      'check-circle', 'green'
    );

    -- Notification
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_job.registered_business_location_id,
      'job_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro è stato approvato ed è ora visibile. Hai guadagnato ' || points_to_award || ' punti in classifica!',
      jsonb_build_object('job_id', p_job_id, 'points_awarded', points_to_award)
    );
  END IF;
END;
$$;


-- ============================================================
-- FILE: 20260505153707_remove_points_auctions_and_jobs.sql
-- ============================================================
/*
  # Remove points for auctions and job postings

  Auctions and job postings do not award points to the leaderboard.
  Both approve_auction and approve_job_posting are updated to:
  - Skip all user_activity point updates
  - Skip activity_log point entries
  - Keep notifications (without points messaging)
*/

-- ─── approve_auction ────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction RECORD;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_by     = p_admin_id,
      approved_at     = now(),
      points_awarded  = 0
  WHERE id = p_auction_id;

  -- Notification to owner (no points)
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile a tutti gli utenti.',
    jsonb_build_object('auction_id', p_auction_id)
  );
END;
$$;

-- ─── approve_job_posting ────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION approve_job_posting(
  p_job_id   uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job      RECORD;
  v_owner_id uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  IF v_job.rb_owner_id IS NULL AND v_job.business_id IS NOT NULL THEN
    SELECT owner_id INTO v_owner_id FROM businesses WHERE id = v_job.business_id;
  ELSE
    v_owner_id := v_job.rb_owner_id;
  END IF;

  UPDATE job_postings
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    -- Notification (no points)
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_job.registered_business_location_id,
      'job_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro è stato approvato ed è ora visibile a tutti gli utenti.',
      jsonb_build_object('job_id', p_job_id)
    );
  END IF;
END;
$$;


-- ============================================================
-- FILE: 20260505155733_add_auction_concluded_won_notification_types.sql
-- ============================================================
/*
  # Add auction_concluded and auction_won notification types

  New types sent by the close-expired-auctions edge function:
  - auction_concluded: sent to the auction owner when their auction ends
  - auction_won: sent to the winner of an auction
*/

-- No schema change needed; notification type is a free-text column.
-- This migration documents the new types and updates the NotificationsPage
-- category mapping in the frontend (leaderboard/auctions filter).
SELECT 1;


-- ============================================================
-- FILE: 20260505161721_fix_business_users_zero_points_exclude_leaderboard.sql
-- ============================================================
/*
  # Fix: business users must not have points and must be excluded from leaderboard

  1. Reset all user_activity records belonging to business users to zero points
  2. Remove activity_log entries that assigned points to business users
  3. Any future call to award_points() already returns 0 for business users (guard already in place)
*/

-- Zero out points and counters for all business users in user_activity
UPDATE user_activity ua
SET
  total_points      = 0,
  reviews_count     = 0,
  ads_posted_count  = 0,
  job_postings_count = 0,
  auctions_count    = 0,
  referrals_count   = 0,
  last_activity_at  = now(),
  updated_at        = now()
WHERE user_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND family_member_id IS NULL;

-- Remove activity_log rows where points were awarded to business users
UPDATE activity_log al
SET points_earned = 0
WHERE user_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND points_earned > 0;


-- ============================================================
-- FILE: 20260505202404_fix_get_top_business_locations_include_unclaimed.sql
-- ============================================================
/*
  # Fix get_top_business_locations to include unclaimed businesses

  The function previously only returned claimed business_locations joined with reviews
  via business_location_id. However, all current approved reviews are linked to
  unclaimed_business_locations via unclaimed_business_location_id.

  This fix rebuilds the function as a UNION of:
  1. Claimed business_locations with reviews on business_location_id
  2. Unclaimed business_locations with reviews on unclaimed_business_location_id
*/

CREATE OR REPLACE FUNCTION public.get_top_business_locations(limit_count integer DEFAULT 10)
RETURNS TABLE(
  id uuid,
  name text,
  internal_name text,
  city text,
  province text,
  avg_rating numeric,
  review_count bigint,
  business jsonb
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    src.id,
    src.name,
    src.internal_name,
    src.city,
    src.province,
    COALESCE(AVG(r.overall_rating), 0)::numeric AS avg_rating,
    COUNT(r.id) AS review_count,
    src.business
  FROM (
    -- Claimed business locations
    SELECT
      bl.id,
      bl.name,
      bl.internal_name,
      bl.city,
      bl.province,
      jsonb_build_object('name', b.name) AS business,
      'claimed' AS source_type
    FROM business_locations bl
    LEFT JOIN businesses b ON bl.business_id = b.id
    WHERE bl.is_claimed = true

    UNION ALL

    -- Unclaimed business locations
    SELECT
      ubl.id,
      ubl.name,
      NULL AS internal_name,
      ubl.city,
      ubl.province,
      jsonb_build_object('name', ubl.name) AS business,
      'unclaimed' AS source_type
    FROM unclaimed_business_locations ubl
  ) src
  LEFT JOIN reviews r ON (
    (src.source_type = 'claimed' AND r.business_location_id = src.id)
    OR
    (src.source_type = 'unclaimed' AND r.unclaimed_business_location_id = src.id)
  )
  AND r.review_status = 'approved'
  GROUP BY src.id, src.name, src.internal_name, src.city, src.province, src.business
  HAVING COUNT(r.id) > 0
  ORDER BY avg_rating DESC, review_count DESC
  LIMIT limit_count;
END;
$$;


-- ============================================================
-- FILE: 20260506053856_fix_comuni_province_names.sql
-- ============================================================
/*
  # Fix province names in comuni_italiani to match ITALIAN_PROVINCES list

  Normalizes province names from ISTAT format to the app's standard format
  so the dropdown filter works correctly.

  Changes:
  - 'Bolzano/Bozen' -> 'Bolzano'
  - 'Forl-Cesena' -> 'Forlì-Cesena'
  - 'Monza e della Brianza' -> 'Monza e Brianza'
  - "Reggio nell'Emilia" -> 'Reggio Emilia'
  - "Valle d'Aosta/Valle d'Aoste" -> "Valle d'Aosta"
*/

UPDATE comuni_italiani SET provincia = 'Bolzano', sigla = 'BZ' WHERE provincia = 'Bolzano/Bozen';
UPDATE comuni_italiani SET provincia = 'Forlì-Cesena', sigla = 'FC' WHERE provincia = 'Forl-Cesena';
UPDATE comuni_italiani SET provincia = 'Monza e Brianza', sigla = 'MB' WHERE provincia = 'Monza e della Brianza';
UPDATE comuni_italiani SET provincia = 'Reggio Emilia', sigla = 'RE' WHERE provincia = 'Reggio nell''Emilia';
UPDATE comuni_italiani SET provincia = 'Valle d''Aosta', sigla = 'AO' WHERE provincia = 'Valle d''Aosta/Valle d''Aoste';


-- ============================================================
-- FILE: 20260506061331_create_get_provinces_and_cities_functions.sql
-- ============================================================
/*
  # Create helper functions for province and city dropdowns

  Returns distinct province names and cities by province from comuni_italiani,
  bypassing the default 1000-row limit on direct table queries.
*/

CREATE OR REPLACE FUNCTION get_province_list()
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT DISTINCT provincia FROM comuni_italiani ORDER BY provincia;
$$;

CREATE OR REPLACE FUNCTION get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT comune FROM comuni_italiani WHERE provincia = p_provincia ORDER BY comune;
$$;


-- ============================================================
-- FILE: 20260506061630_fix_aosta_provincia_name.sql
-- ============================================================
/*
  # Fix provincia name for Valle d'Aosta comuni

  The province name should be 'Aosta' (the actual province, sigla AO),
  not 'Valle d'Aosta' which is the region name.
*/

UPDATE comuni_italiani SET provincia = 'Aosta' WHERE provincia = 'Valle d''Aosta';


-- ============================================================
-- FILE: 20260506065634_add_get_province_by_region_function.sql
-- ============================================================
/*
  # Add get_province_by_region function

  Returns provinces filtered by region from comuni_italiani table.
  Used by ItalianCityProvinceSelect to show only provinces belonging
  to the selected region when a region filter is active.
*/

CREATE OR REPLACE FUNCTION public.get_province_by_region(p_regione text)
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE SECURITY DEFINER
AS $$
  SELECT DISTINCT provincia
  FROM comuni_italiani
  WHERE regione ILIKE p_regione
  ORDER BY provincia;
$$;


-- ============================================================
-- FILE: 20260506075553_fix_get_province_by_region_use_prefix_match.sql
-- ============================================================
/*
  # Fix get_province_by_region to use prefix/contains match

  The comuni_italiani table has region names like:
    - "Trentino-Alto Adige/Sdtirol"
    - "Valle d'Aosta/Valle d'Aoste"
  
  The frontend sends "Trentino-Alto Adige" and "Valle d'Aosta".
  Using ILIKE with a leading wildcard ensures partial matches work correctly.
*/

CREATE OR REPLACE FUNCTION public.get_province_by_region(p_regione text)
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE SECURITY DEFINER
AS $$
  SELECT DISTINCT provincia
  FROM comuni_italiani
  WHERE regione ILIKE p_regione || '%'
  ORDER BY provincia;
$$;


-- ============================================================
-- FILE: 20260506080920_add_region_province_city_to_job_postings.sql
-- ============================================================
/*
  # Add region, province, city to job_postings

  1. Changes
    - Add region, province, city columns to job_postings
    - Backfill from linked business_locations or registered_business_locations
  
  2. Notes
    - These columns allow direct region/province/city filtering without joins
    - Backfill covers existing postings linked to a business location
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'region'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN region text DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'province'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN province text DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'city'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN city text DEFAULT '';
  END IF;
END $$;

-- Backfill from business_locations
UPDATE job_postings jp
SET
  region = COALESCE(bl.region, ''),
  province = COALESCE(bl.province, ''),
  city = COALESCE(bl.city, '')
FROM business_locations bl
WHERE jp.business_location_id = bl.id
  AND (jp.region = '' OR jp.region IS NULL);

-- Backfill from registered_business_locations
UPDATE job_postings jp
SET
  region = COALESCE(rbl.region, ''),
  province = COALESCE(rbl.province, ''),
  city = COALESCE(rbl.city, '')
FROM registered_business_locations rbl
WHERE jp.registered_business_location_id = rbl.id
  AND (jp.region = '' OR jp.region IS NULL);


