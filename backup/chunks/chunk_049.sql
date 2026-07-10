-- ============================================================
-- FILE: 20260413093102_fix_search_show_business_name_drop_recreate.sql
-- ============================================================
/*
  # Fix search function to include business_name for registered locations

  ## Problem
  Registered business locations show "Sede 1", "Sede 2" as display name instead
  of the parent business name (e.g. "Farmacia Carso").

  ## Solution
  Drop and recreate both search functions adding a `business_name` column so the
  frontend can display it alongside the location name.
*/

DROP FUNCTION IF EXISTS public.search_all_businesses(text, text, text, text, uuid, boolean, integer);
DROP FUNCTION IF EXISTS public.search_all_business_locations(text, text, text, text, uuid, boolean, integer);

CREATE OR REPLACE FUNCTION public.search_all_business_locations(
  search_query text DEFAULT ''::text,
  search_city text DEFAULT NULL::text,
  search_province text DEFAULT NULL::text,
  search_region text DEFAULT NULL::text,
  search_category_id uuid DEFAULT NULL::uuid,
  verified_only boolean DEFAULT false,
  limit_count integer DEFAULT 50
)
RETURNS TABLE(
  id uuid,
  name text,
  business_name text,
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
  added_by uuid,
  added_by_family_member_id uuid,
  source text,
  created_at timestamp with time zone
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
RETURN QUERY

SELECT * FROM (
-- Sedi non rivendicate da database importato (unclaimed_business_locations)
SELECT
ubl.id,
ubl.name,
NULL::text as business_name,
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
(ubl.verification_badge = 'verified') as is_verified,
NULL::uuid as business_id,
ubl.claimed_by as owner_id,
ubl.added_by,
ubl.added_by_family_member_id,
CASE
WHEN ubl.added_by IS NOT NULL THEN 'user_added'
ELSE 'imported'
END::text as result_source,
ubl.created_at
FROM unclaimed_business_locations ubl
WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
AND (search_province IS NULL OR ubl.province = search_province)
AND (search_region IS NULL OR ubl.region ILIKE search_region)
AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
AND (ubl.added_by IS NULL OR ubl.verification_badge = 'verified')
AND NOT verified_only

UNION ALL

-- Sedi di attività registrate (business_locations)
SELECT
bl.id,
COALESCE(bl.internal_name, b.name) as name,
b.name as business_name,
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
'registered'::text as location_type,
true as is_claimed,
true as is_verified,
b.id as business_id,
b.owner_id,
NULL::uuid as added_by,
NULL::uuid as added_by_family_member_id,
'registered'::text as result_source,
bl.created_at
FROM business_locations bl
INNER JOIN businesses b ON b.id = bl.business_id
WHERE b.owner_id IS NOT NULL
AND (search_query = '' OR COALESCE(bl.internal_name, b.name) ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
AND (search_province IS NULL OR bl.province = search_province)
AND (search_region IS NULL OR bl.region ILIKE search_region)
AND (search_category_id IS NULL OR b.category_id = search_category_id)

UNION ALL

-- Sedi di attività registrate (registered_business_locations)
SELECT
rbl.id,
COALESCE(rbl.name, rbl.internal_name, rb.name) as name,
rb.name as business_name,
rb.category_id,
COALESCE(rbl.description, rb.description, ''),
COALESCE(rbl.street, '') as address,
rbl.city,
rbl.province,
''::text as region,
COALESCE(rbl.postal_code, '') as postal_code,
rbl.phone,
rbl.email,
rb.website,
rbl.business_hours::text,
NULL::numeric as latitude,
NULL::numeric as longitude,
'registered'::text as location_type,
true as is_claimed,
true as is_verified,
rb.id as business_id,
rb.owner_id,
NULL::uuid as added_by,
NULL::uuid as added_by_family_member_id,
'registered'::text as result_source,
rbl.created_at
FROM registered_business_locations rbl
INNER JOIN registered_businesses rb ON rb.id = rbl.business_id
WHERE rb.owner_id IS NOT NULL
AND (search_query = '' OR 
COALESCE(rbl.name, rbl.internal_name, rb.name) ILIKE '%' || search_query || '%' OR
rb.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(rbl.city) = LOWER(search_city))
AND (search_province IS NULL OR rbl.province = search_province)
AND (search_region IS NULL)
AND (search_category_id IS NULL OR rb.category_id = search_category_id)

UNION ALL

-- Attività registrate senza sedi (fallback temporaneo)
SELECT
rb.id,
rb.name,
NULL::text as business_name,
rb.category_id,
COALESCE(rb.description, ''),
COALESCE(rb.office_address, 
NULLIF(TRIM(COALESCE(rb.office_street, '') || ' ' || COALESCE(rb.office_street_number, '')), ''),
'Da completare'),
COALESCE(rb.office_city, rb.billing_city, 'Da completare'),
COALESCE(rb.office_province, rb.billing_province, ''),
''::text as region,
COALESCE(rb.office_postal_code, rb.billing_postal_code, ''),
rb.phone,
rb.pec_email,
rb.website,
NULL::text as business_hours,
NULL::numeric as latitude,
NULL::numeric as longitude,
'registered_no_location'::text as location_type,
true as is_claimed,
true as is_verified,
NULL::uuid as business_id,
rb.owner_id,
NULL::uuid as added_by,
NULL::uuid as added_by_family_member_id,
'registered'::text as result_source,
rb.created_at
FROM registered_businesses rb
WHERE rb.owner_id IS NOT NULL
AND NOT EXISTS (
SELECT 1 FROM registered_business_locations rbl
WHERE rbl.business_id = rb.id
)
AND (search_query = '' OR rb.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR 
LOWER(COALESCE(rb.office_city, rb.billing_city, '')) = LOWER(search_city))
AND (search_province IS NULL OR 
COALESCE(rb.office_province, rb.billing_province) = search_province)
AND (search_region IS NULL)
AND (search_category_id IS NULL OR rb.category_id = search_category_id)
) all_results
ORDER BY
CASE
WHEN all_results.result_source = 'registered' THEN 1
WHEN all_results.result_source = 'imported' THEN 2
WHEN all_results.result_source = 'user_added' THEN 3
ELSE 4
END,
all_results.name
LIMIT limit_count;
END;
$function$;

CREATE OR REPLACE FUNCTION public.search_all_businesses(
  search_query text DEFAULT ''::text,
  search_city text DEFAULT NULL::text,
  search_province text DEFAULT NULL::text,
  search_region text DEFAULT NULL::text,
  search_category_id uuid DEFAULT NULL::uuid,
  verified_only boolean DEFAULT false,
  limit_count integer DEFAULT 50
)
RETURNS TABLE(
  id uuid,
  name text,
  business_name text,
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
  added_by uuid,
  added_by_family_member_id uuid,
  source text,
  created_at timestamp with time zone
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
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
$function$;


-- ============================================================
-- FILE: 20260413095233_add_type_specific_rating_columns.sql
-- ============================================================
/*
  # Add type-specific rating columns to reviews table

  ## Summary
  Adds granular rating columns to the reviews table for each review type:

  - booking_not_completed: gestione_prenotazione, affidabilita, organizzazione, comunicazione
  - quote_request: chiarezza, trasparenza, tempistiche_risposta, disponibilita
  - customer_service: cortesia, competenza, rapidita, risoluzione_problema
  - problem_before_service: affidabilita, organizzazione, gestione_problema, comunicazione

  Each column stores a 1-5 star rating.
*/

DO $$
BEGIN
  -- booking_not_completed ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_gestione_prenotazione') THEN
    ALTER TABLE reviews ADD COLUMN booking_gestione_prenotazione smallint CHECK (booking_gestione_prenotazione BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_affidabilita') THEN
    ALTER TABLE reviews ADD COLUMN booking_affidabilita smallint CHECK (booking_affidabilita BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_organizzazione') THEN
    ALTER TABLE reviews ADD COLUMN booking_organizzazione smallint CHECK (booking_organizzazione BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'booking_comunicazione') THEN
    ALTER TABLE reviews ADD COLUMN booking_comunicazione smallint CHECK (booking_comunicazione BETWEEN 1 AND 5);
  END IF;

  -- quote_request ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_chiarezza') THEN
    ALTER TABLE reviews ADD COLUMN quote_chiarezza smallint CHECK (quote_chiarezza BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_trasparenza') THEN
    ALTER TABLE reviews ADD COLUMN quote_trasparenza smallint CHECK (quote_trasparenza BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_tempistiche_risposta') THEN
    ALTER TABLE reviews ADD COLUMN quote_tempistiche_risposta smallint CHECK (quote_tempistiche_risposta BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'quote_disponibilita') THEN
    ALTER TABLE reviews ADD COLUMN quote_disponibilita smallint CHECK (quote_disponibilita BETWEEN 1 AND 5);
  END IF;

  -- customer_service ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_cortesia') THEN
    ALTER TABLE reviews ADD COLUMN cs_cortesia smallint CHECK (cs_cortesia BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_competenza') THEN
    ALTER TABLE reviews ADD COLUMN cs_competenza smallint CHECK (cs_competenza BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_rapidita') THEN
    ALTER TABLE reviews ADD COLUMN cs_rapidita smallint CHECK (cs_rapidita BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'cs_risoluzione_problema') THEN
    ALTER TABLE reviews ADD COLUMN cs_risoluzione_problema smallint CHECK (cs_risoluzione_problema BETWEEN 1 AND 5);
  END IF;

  -- problem_before_service ratings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_affidabilita') THEN
    ALTER TABLE reviews ADD COLUMN problem_affidabilita smallint CHECK (problem_affidabilita BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_organizzazione') THEN
    ALTER TABLE reviews ADD COLUMN problem_organizzazione smallint CHECK (problem_organizzazione BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_gestione_problema') THEN
    ALTER TABLE reviews ADD COLUMN problem_gestione_problema smallint CHECK (problem_gestione_problema BETWEEN 1 AND 5);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'problem_comunicazione') THEN
    ALTER TABLE reviews ADD COLUMN problem_comunicazione smallint CHECK (problem_comunicazione BETWEEN 1 AND 5);
  END IF;
END $$;


-- ============================================================
-- FILE: 20260413100653_create_get_business_ratings_by_type_function.sql
-- ============================================================
/*
  # Create function to get business ratings broken down by review type

  ## Summary
  Creates a function `get_business_ratings_by_type` that returns:
  - Per review-type averages (service_used, booking_not_completed, quote_request, customer_service, problem_before_service)
  - Each type has its own criteria averages
  - An overall `total_avg` across all types
  - Count per type

  This supports the new filtering system where users can filter by any specific rating dimension.
*/

CREATE OR REPLACE FUNCTION get_business_ratings_by_type(p_business_id uuid, p_business_type text DEFAULT 'registered')
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result jsonb;
  v_total_sum numeric := 0;
  v_total_count integer := 0;
BEGIN
  SELECT jsonb_build_object(
    'total_avg', CASE WHEN COUNT(*) > 0 THEN ROUND(AVG(overall_rating)::numeric, 1) ELSE 0 END,
    'total_count', COUNT(*),

    -- service_used
    'service_used', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'service_used'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1)
        ELSE 0 END,
      'gestione_prenotazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND booking_management_rating IS NOT NULL) > 0
        THEN ROUND(AVG(booking_management_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND reliability_rating IS NOT NULL) > 0
        THEN ROUND(AVG(reliability_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND organization_rating IS NOT NULL) > 0
        THEN ROUND(AVG(organization_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'esperienza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND experience_rating IS NOT NULL) > 0
        THEN ROUND(AVG(experience_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'prezzo', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND price_rating IS NOT NULL) > 0
        THEN ROUND(AVG(price_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END
    ),

    -- booking_not_completed
    'booking_not_completed', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'booking_not_completed'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1)
        ELSE 0 END,
      'gestione_prenotazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_gestione_prenotazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_gestione_prenotazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_affidabilita IS NOT NULL) > 0
        THEN ROUND(AVG(booking_affidabilita) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_organizzazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_organizzazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'comunicazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_comunicazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_comunicazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END
    ),

    -- quote_request
    'quote_request', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'quote_request'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'quote_request')::numeric, 1)
        ELSE 0 END,
      'chiarezza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_chiarezza IS NOT NULL) > 0
        THEN ROUND(AVG(quote_chiarezza) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'trasparenza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_trasparenza IS NOT NULL) > 0
        THEN ROUND(AVG(quote_trasparenza) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'tempistiche_risposta', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_tempistiche_risposta IS NOT NULL) > 0
        THEN ROUND(AVG(quote_tempistiche_risposta) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'disponibilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_disponibilita IS NOT NULL) > 0
        THEN ROUND(AVG(quote_disponibilita) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END
    ),

    -- customer_service
    'customer_service', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'customer_service'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'customer_service')::numeric, 1)
        ELSE 0 END,
      'cortesia', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_cortesia IS NOT NULL) > 0
        THEN ROUND(AVG(cs_cortesia) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'competenza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_competenza IS NOT NULL) > 0
        THEN ROUND(AVG(cs_competenza) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'rapidita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_rapidita IS NOT NULL) > 0
        THEN ROUND(AVG(cs_rapidita) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'risoluzione_problema', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_risoluzione_problema IS NOT NULL) > 0
        THEN ROUND(AVG(cs_risoluzione_problema) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END
    ),

    -- problem_before_service
    'problem_before_service', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'problem_before_service'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1)
        ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_affidabilita IS NOT NULL) > 0
        THEN ROUND(AVG(problem_affidabilita) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_organizzazione IS NOT NULL) > 0
        THEN ROUND(AVG(problem_organizzazione) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'gestione_problema', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_gestione_problema IS NOT NULL) > 0
        THEN ROUND(AVG(problem_gestione_problema) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'comunicazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_comunicazione IS NOT NULL) > 0
        THEN ROUND(AVG(problem_comunicazione) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END
    )
  ) INTO v_result
  FROM reviews
  WHERE review_status = 'approved'
    AND (
      (p_business_type = 'registered' AND (business_id = p_business_id OR registered_business_id = p_business_id))
      OR (p_business_type = 'imported' AND (imported_business_id = p_business_id OR unclaimed_business_location_id = p_business_id))
      OR (p_business_type = 'user_added' AND user_added_business_id = p_business_id)
    );

  RETURN COALESCE(v_result, '{}'::jsonb);
END;
$$;


-- ============================================================
-- FILE: 20260414092637_fix_job_seekers_user_id_fk_to_profiles.sql
-- ============================================================
/*
  # Fix job_seekers user_id foreign key to profiles

  ## Problem
  The job_seekers.user_id column references auth.users(id), but the frontend
  queries use `profiles:user_id(...)` which requires a foreign key to profiles(id).

  ## Fix
  Add an additional foreign key constraint from job_seekers.user_id to profiles(id)
  so that Supabase PostgREST can resolve the join relationship.
*/

ALTER TABLE job_seekers
  DROP CONSTRAINT IF EXISTS job_seekers_user_id_fkey_profiles;

ALTER TABLE job_seekers
  ADD CONSTRAINT job_seekers_user_id_fkey_profiles
  FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;


-- ============================================================
-- FILE: 20260414095034_add_business_approval_system.sql
-- ============================================================
/*
  # Add Approval System for User-Added Businesses

  ## Summary
  This migration adds a proper approval workflow for businesses added by users,
  mirroring the review approval system. Businesses now start as "pending" and
  must be approved by admins before points are awarded and the business is visible.

  ## Changes

  ### Modified Tables
  - `unclaimed_business_locations`
    - Add `approval_status` column: 'pending' | 'approved' | 'rejected' (default 'pending' for user-added, null for imported)
    - Add `approved_at` timestamp
    - Add `approved_by` uuid (admin who approved)
    - Add `rejection_reason` text
    - Add `points_awarded` boolean to track if points have been given

  ## Notes
  - Imported businesses (added_by IS NULL) keep approval_status NULL (not subject to approval)
  - User-added businesses (added_by IS NOT NULL) start as 'pending'
  - Points are only awarded when admin approves (not on submission)
  - Already verified businesses are set to 'approved'
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'unclaimed_business_locations' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE unclaimed_business_locations ADD COLUMN approval_status text;
    ALTER TABLE unclaimed_business_locations ADD COLUMN approved_at timestamptz;
    ALTER TABLE unclaimed_business_locations ADD COLUMN approved_by uuid;
    ALTER TABLE unclaimed_business_locations ADD COLUMN rejection_reason text;
    ALTER TABLE unclaimed_business_locations ADD COLUMN points_awarded boolean DEFAULT false;
  END IF;
END $$;

UPDATE unclaimed_business_locations
SET approval_status = 'approved', points_awarded = true
WHERE added_by IS NOT NULL AND verification_badge = 'verified';

UPDATE unclaimed_business_locations
SET approval_status = 'pending', points_awarded = false
WHERE added_by IS NOT NULL AND verification_badge IS NULL AND approval_status IS NULL;


-- ============================================================
-- FILE: 20260420092534_fix_notifications_rls_strict_isolation.sql
-- ============================================================
/*
  # Fix Notifications RLS - Strict User Isolation

  ## Summary
  Enforces strict isolation so each user sees ONLY their own notifications.
  Family members share the main account's auth.uid(), so notifications for the
  main user correctly appear for all family member sessions on the same account.

  ## Changes
  1. Drops the overly permissive INSERT policy `WITH CHECK (true)` that allowed
     any authenticated user to insert notifications for any user_id
  2. Replaces it with a SECURITY DEFINER insert function accessible to service role
  3. Adds a strict service-role-only INSERT policy (frontend inserts go via the
     existing admin/service path)

  ## Security
  - SELECT: users see only their own (auth.uid() = user_id) - unchanged
  - INSERT: only service_role (edge functions, triggers, SECURITY DEFINER functions)
  - UPDATE: users update only their own - unchanged
  - DELETE: users delete only their own - unchanged
*/

-- Drop the overly permissive INSERT policy
DROP POLICY IF EXISTS "System can create notifications" ON notifications;

-- Re-create INSERT policy: only service_role or internal functions can insert
-- Regular users cannot insert notifications for arbitrary user_ids
CREATE POLICY "Service role can insert notifications"
  ON notifications FOR INSERT
  TO service_role
  WITH CHECK (true);

-- Also allow authenticated users to insert notifications ONLY for themselves
-- (needed if any frontend code creates self-notifications)
CREATE POLICY "Users can insert own notifications"
  ON notifications FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);


-- ============================================================
-- FILE: 20260420092548_create_send_notification_function.sql
-- ============================================================
/*
  # Create send_notification function for admin use

  ## Summary
  Creates a SECURITY DEFINER function that allows admins to send notifications
  to any user. This is needed because admin frontend code inserts notifications
  for other users (e.g., review approval notifications).

  ## Function
  - `send_notification(target_user_id, type, title, message, data)` - inserts a
    notification bypassing RLS, only callable by admins or service role

  ## Security
  - Checks that the caller is an admin via is_admin() before inserting
  - Uses SECURITY DEFINER to bypass RLS for the insert
*/

CREATE OR REPLACE FUNCTION send_notification(
  target_user_id uuid,
  notif_type text,
  notif_title text,
  notif_message text,
  notif_data jsonb DEFAULT '{}'
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT (is_admin() OR auth.uid() = target_user_id) THEN
    RAISE EXCEPTION 'Non autorizzato a inviare notifiche ad altri utenti';
  END IF;

  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (target_user_id, notif_type, notif_title, notif_message, notif_data);
END;
$$;

GRANT EXECUTE ON FUNCTION send_notification TO authenticated;


