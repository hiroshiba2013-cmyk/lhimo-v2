-- ============================================================
-- FILE: 20260513150436_fix_search_user_added_category_fallback_from_profile.sql
-- ============================================================
/*
  # Fix search: use profile/family member category as fallback for user-added businesses

  When a user-added unclaimed_business_location has no category_id set,
  fall back to the category_id from the adding user's profile or family member.

  Changes:
  - Drop and recreate search_all_business_locations to add category fallback
    for user-added locations: COALESCE(ubl.category_id, fm.category_id, p.category_id)
*/

DROP FUNCTION IF EXISTS search_all_business_locations(text,text,text,text,uuid,boolean,integer);

CREATE OR REPLACE FUNCTION search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count integer DEFAULT 50
)
RETURNS TABLE (
  id uuid,
  name text,
  business_name text,
  category_id uuid,
  category_name text,
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
  result_source text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
RETURN QUERY

SELECT * FROM (

-- Sedi non rivendicate da database importato (unclaimed_business_locations)
-- For user-added locations, fall back to family member or profile category if location has none
SELECT
ubl.id,
ubl.name,
NULL::text as business_name,
COALESCE(ubl.category_id, fm.category_id, p.category_id) as category_id,
COALESCE(bc.name, bc_fm.name, bc_p.name) as category_name,
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
LEFT JOIN business_categories bc ON bc.id = ubl.category_id
LEFT JOIN customer_family_members fm ON fm.id = ubl.added_by_family_member_id
LEFT JOIN business_categories bc_fm ON bc_fm.id = fm.category_id
LEFT JOIN profiles p ON p.id = ubl.added_by
LEFT JOIN business_categories bc_p ON bc_p.id = p.category_id
WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
AND (search_province IS NULL OR ubl.province = search_province)
AND (search_region IS NULL OR ubl.region ILIKE search_region)
AND (search_category_id IS NULL OR COALESCE(ubl.category_id, fm.category_id, p.category_id) = search_category_id)
AND (ubl.added_by IS NULL OR ubl.verification_badge = 'verified')
AND NOT verified_only

UNION ALL

-- Sedi di attività registrate (business_locations - vecchio sistema)
SELECT
bl.id,
COALESCE(bl.internal_name, b.name) as name,
b.name as business_name,
b.category_id,
bc.name as category_name,
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
LEFT JOIN business_categories bc ON bc.id = b.category_id
WHERE b.owner_id IS NOT NULL
AND (search_query = '' OR COALESCE(bl.internal_name, b.name) ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
AND (search_province IS NULL OR bl.province = search_province)
AND (search_region IS NULL OR bl.region ILIKE search_region)
AND (search_category_id IS NULL OR b.category_id = search_category_id)

UNION ALL

-- Sedi di attività registrate (registered_business_locations - nuovo sistema)
SELECT
rbl.id,
COALESCE(rbl.name, rbl.internal_name, rb.name) as name,
rb.name as business_name,
COALESCE(rbl.category_id, rb.category_id) as category_id,
COALESCE(bc_rbl.name, bc.name) as category_name,
COALESCE(rbl.description, rb.description, ''),
COALESCE(rbl.street, '') as address,
rbl.city,
rbl.province,
COALESCE(
NULLIF(rbl.region, ''),
(SELECT DISTINCT ubl2.region FROM unclaimed_business_locations ubl2
WHERE ubl2.province = rbl.province AND ubl2.region != '' LIMIT 1),
''
) as region,
COALESCE(rbl.postal_code, '') as postal_code,
COALESCE(rbl.phone, rb.phone) as phone,
COALESCE(rbl.email, rb.pec_email) as email,
COALESCE(rbl.website, rb.website) as website,
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
LEFT JOIN business_categories bc ON bc.id = rb.category_id
LEFT JOIN business_categories bc_rbl ON bc_rbl.id = rbl.category_id
WHERE rb.owner_id IS NOT NULL
AND (search_query = '' OR
COALESCE(rbl.name, rbl.internal_name, rb.name) ILIKE '%' || search_query || '%' OR
rb.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(rbl.city) = LOWER(search_city))
AND (search_province IS NULL OR rbl.province = search_province)
AND (
search_region IS NULL OR
COALESCE(
NULLIF(rbl.region, ''),
(SELECT DISTINCT ubl3.region FROM unclaimed_business_locations ubl3
WHERE ubl3.province = rbl.province AND ubl3.region != '' LIMIT 1),
''
) ILIKE search_region
)
AND (search_category_id IS NULL OR COALESCE(rbl.category_id, rb.category_id) = search_category_id)

UNION ALL

-- Attività registrate senza sedi (fallback temporaneo)
SELECT
rb.id,
rb.name,
NULL::text as business_name,
rb.category_id,
bc.name as category_name,
COALESCE(rb.description, ''),
COALESCE(rb.office_address,
NULLIF(TRIM(COALESCE(rb.office_street, '') || ' ' || COALESCE(rb.office_street_number, '')), ''),
'Da completare'),
COALESCE(rb.office_city, rb.billing_city, 'Da completare'),
COALESCE(rb.office_province, rb.billing_province, ''),
COALESCE(
(SELECT DISTINCT ubl4.region FROM unclaimed_business_locations ubl4
WHERE ubl4.province = COALESCE(rb.office_province, rb.billing_province)
AND ubl4.region != '' LIMIT 1),
''
) as region,
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
LEFT JOIN business_categories bc ON bc.id = rb.category_id
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
AND (
search_region IS NULL OR
COALESCE(
(SELECT DISTINCT ubl5.region FROM unclaimed_business_locations ubl5
WHERE ubl5.province = COALESCE(rb.office_province, rb.billing_province)
AND ubl5.region != '' LIMIT 1),
''
) ILIKE search_region
)
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
$$;


-- ============================================================
-- FILE: 20260513164229_add_reviews_registered_business_location_fk.sql
-- ============================================================
/*
  # Add FK from reviews to registered_business_locations

  The reviews.business_location_id column currently only has a FK to business_locations.
  Business users who registered directly use registered_business_locations instead.
  This adds a second FK so PostgREST can join reviews to registered_business_locations.

  Since reviews.business_location_id can reference either table (legacy or registered),
  we drop the existing FK constraint and store the relationship at the application level.
  The join in queries is done without a FK hint — we simply remove the broken join from
  queries and fetch location data separately.

  No schema changes needed here — the fix is in the application queries.
  This migration is a no-op placeholder to document the architectural decision.
*/

-- No DDL changes: the fix is in application code (removed invalid FK join from queries).
SELECT 1;


-- ============================================================
-- FILE: 20260513203031_add_vat_number_to_registered_business_locations.sql
-- ============================================================
/*
  # Add vat_number to registered_business_locations

  Adds the vat_number column to registered_business_locations so each
  registered location can store its own VAT number, matching the existing
  column already present on business_locations.
*/

ALTER TABLE registered_business_locations
  ADD COLUMN IF NOT EXISTS vat_number text;


-- ============================================================
-- FILE: 20260514134343_add_registered_business_location_to_favorites.sql
-- ============================================================
/*
  # Add registered_business_location_id to favorite_businesses

  ## Problem
  The favorite_businesses table has a business_location_id column that references
  business_locations (old/empty table), but registered businesses now use
  registered_business_locations. Saving favorites for registered businesses fails
  with a FK violation.

  ## Changes
  1. Add new column `registered_business_location_id` with FK to registered_business_locations
  2. Also add `registered_business_id` for businesses without locations
  3. Update the CHECK constraint to allow exactly one of the 4 reference columns to be set
  4. Add unique indexes for the new columns
*/

-- Add new column for registered business locations (new system)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'favorite_businesses' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE favorite_businesses ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Add new column for registered businesses without locations
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'favorite_businesses' AND column_name = 'registered_business_id'
  ) THEN
    ALTER TABLE favorite_businesses ADD COLUMN registered_business_id uuid REFERENCES registered_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Drop old CHECK constraint
ALTER TABLE favorite_businesses DROP CONSTRAINT IF EXISTS favorite_businesses_valid_reference;

-- Add updated CHECK constraint allowing exactly one of 5 columns
ALTER TABLE favorite_businesses ADD CONSTRAINT favorite_businesses_valid_reference CHECK (
  (
    (business_id IS NOT NULL)::integer +
    (business_location_id IS NOT NULL)::integer +
    (unclaimed_business_location_id IS NOT NULL)::integer +
    (registered_business_location_id IS NOT NULL)::integer +
    (registered_business_id IS NOT NULL)::integer
  ) = 1
);

-- Unique index for registered_business_location_id (no family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rbl_user
  ON favorite_businesses (user_id, registered_business_location_id)
  WHERE family_member_id IS NULL AND registered_business_location_id IS NOT NULL;

-- Unique index for registered_business_location_id (with family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rbl_family
  ON favorite_businesses (user_id, family_member_id, registered_business_location_id)
  WHERE family_member_id IS NOT NULL AND registered_business_location_id IS NOT NULL;

-- Unique index for registered_business_id (no family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rb_user
  ON favorite_businesses (user_id, registered_business_id)
  WHERE family_member_id IS NULL AND registered_business_id IS NOT NULL;

-- Unique index for registered_business_id (with family member)
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_rb_family
  ON favorite_businesses (user_id, family_member_id, registered_business_id)
  WHERE family_member_id IS NOT NULL AND registered_business_id IS NOT NULL;


-- ============================================================
-- FILE: 20260514135346_add_registered_business_columns_to_reviews.sql
-- ============================================================
/*
  # Add registered_business_location_id and registered_business_id to reviews

  ## Problem
  The reviews table only has FK columns for the old system (business_id → businesses,
  business_location_id → business_locations). The new system uses registered_businesses
  and registered_business_locations, so reviews for those businesses fail with 403 (RLS)
  because no recognized FK column is populated.

  ## Changes
  1. Add `registered_business_location_id` FK → registered_business_locations
  2. Add `registered_business_id` FK → registered_businesses (for businesses without locations)
  3. Update the INSERT RLS policy to accept these new columns
  4. Add unique indexes to prevent duplicate reviews
  5. Add regular indexes for query performance
*/

-- Add new columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE CASCADE;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'registered_business_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN registered_business_id uuid REFERENCES registered_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Drop and recreate INSERT policy to include new columns
DROP POLICY IF EXISTS "Customers and family members can create reviews" ON reviews;

CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid()
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = reviews.family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
    AND (
      business_id IS NOT NULL
      OR imported_business_id IS NOT NULL
      OR user_added_business_id IS NOT NULL
      OR unclaimed_business_location_id IS NOT NULL
      OR business_location_id IS NOT NULL
      OR registered_business_location_id IS NOT NULL
      OR registered_business_id IS NOT NULL
    )
  );

-- Unique indexes for new columns
CREATE UNIQUE INDEX IF NOT EXISTS reviews_rbl_owner_unique
  ON reviews (customer_id, registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_rbl_family_unique
  ON reviews (customer_id, family_member_id, registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_rb_owner_unique
  ON reviews (customer_id, registered_business_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_rb_family_unique
  ON reviews (customer_id, family_member_id, registered_business_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_reviews_registered_business_location
  ON reviews (registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_reviews_registered_business
  ON reviews (registered_business_id)
  WHERE registered_business_id IS NOT NULL;


-- ============================================================
-- FILE: 20260515102231_fix_approve_auction_reset_timer_on_approval.sql
-- ============================================================
/*
  # Fix approve_auction: timer starts at approval time

  ## Problem
  When an auction is created, ends_at is set immediately (e.g. now() + duration_days).
  But if the admin approves it days later, the timer has already partially (or fully) elapsed.

  ## Fix
  Update approve_auction to recalculate ends_at = now() + duration_days at approval time,
  so the auction's full duration starts from the moment it is approved and made public.
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
  v_user_id uuid;
  v_family_member_id uuid;
  v_duration_days integer;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at from now so the full duration runs after approval
  UPDATE auctions
  SET approval_status = 'approved',
      status = 'active',
      approved_at = now(),
      approved_by = p_admin_id,
      ends_at = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Award 15 points for auction creation
  INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
  VALUES (v_user_id, v_family_member_id, 15, 1)
  ON CONFLICT (user_id, COALESCE(family_member_id, '00000000-0000-0000-0000-000000000000'))
  DO UPDATE SET
    total_points = user_activity.total_points + 15,
    auctions_count = COALESCE(user_activity.auctions_count, 0) + 1;

  INSERT INTO activity_log (user_id, family_member_id, action, details, points_awarded)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    jsonb_build_object('auction_id', p_auction_id), 15);

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', 15));
END;
$$;


-- ============================================================
-- FILE: 20260515145913_fix_approve_auction_upsert_and_points_notification.sql
-- ============================================================
/*
  # Fix approve_auction: corretto upsert user_activity e notifica punti separata

  ## Problemi risolti

  1. ON CONFLICT con COALESCE non funziona — sostituito con logica UPDATE/INSERT
     manuale (come fa award_points) compatibile con i constraint esistenti:
     - user_activity_user_id_null_family_unique (family_member_id IS NULL)
     - user_activity_user_family_unique (user_id, family_member_id)

  2. Aggiunta notifica separata di tipo 'points_earned' dopo l'approvazione,
     visibile nella sezione "Classifica" della pagina notifiche.
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
  v_user_id uuid;
  v_family_member_id uuid;
  v_duration_days integer;
  v_existing_activity uuid;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at from now so the full duration runs after approval
  UPDATE auctions
  SET approval_status = 'approved',
      status = 'active',
      approved_at = now(),
      approved_by = p_admin_id,
      ends_at = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Award 15 points: UPDATE esistente oppure INSERT nuovo
  IF v_family_member_id IS NULL THEN
    SELECT id INTO v_existing_activity FROM user_activity
    WHERE user_id = v_user_id AND family_member_id IS NULL;
  ELSE
    SELECT id INTO v_existing_activity FROM user_activity
    WHERE user_id = v_user_id AND family_member_id = v_family_member_id;
  END IF;

  IF v_existing_activity IS NOT NULL THEN
    UPDATE user_activity
    SET total_points  = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at    = now()
    WHERE id = v_existing_activity;
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
    VALUES (v_user_id, v_family_member_id, 15, 1);
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, action, details, points_awarded)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    jsonb_build_object('auction_id', p_auction_id), 15);

  -- Notifica approvazione asta (sezione "Aste")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', 15));

  -- Notifica punti guadagnati (sezione "Classifica")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'points_earned',
    'Punti guadagnati',
    'Hai guadagnato 15 punti per la pubblicazione della tua asta!',
    jsonb_build_object('points_awarded', 15, 'reason', 'auction_approved', 'auction_id', p_auction_id));
END;
$$;


-- ============================================================
-- FILE: 20260515145945_add_points_earned_notification_to_award_points.sql
-- ============================================================
/*
  # Aggiungi notifica 'points_earned' nella funzione award_points

  ## Scopo
  Ogni volta che vengono assegnati punti (recensione approvata, annuncio approvato, ecc.)
  l'utente riceve una notifica di tipo 'points_earned' visibile nella sezione
  "Classifica" della pagina notifiche.

  ## Nota
  La notifica specifica dell'azione (es. 'review_approved', 'auction_approved')
  rimane separata nella sua sezione. Questa notifica aggiuntiva appare solo in "Classifica".
*/

CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT '',
  p_family_member_id uuid DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_new_total integer;
  v_exists boolean;
  v_user_type text;
  v_notification_title text;
  v_notification_message text;
BEGIN
  -- Business users do not participate in the points system
  SELECT user_type INTO v_user_type FROM profiles WHERE id = p_user_id;
  IF v_user_type = 'business' THEN
    RETURN 0;
  END IF;

  IF p_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points  = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at    = now()
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (p_user_id, p_family_member_id, p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now());
    END IF;

    SELECT total_points INTO v_new_total FROM user_activity
    WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points  = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at    = now()
      WHERE user_id = p_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (p_user_id, NULL, p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now());
    END IF;

    SELECT total_points INTO v_new_total FROM user_activity
    WHERE user_id = p_user_id AND family_member_id IS NULL;
  END IF;

  -- Costruisci titolo e messaggio in base al tipo di attività
  v_notification_title := 'Punti guadagnati';
  v_notification_message := CASE p_activity_type
    WHEN 'review'            THEN 'Hai guadagnato ' || p_points || ' punti per la tua recensione approvata! Totale: ' || v_new_total || ' punti.'
    WHEN 'classified_ad'     THEN 'Hai guadagnato ' || p_points || ' punti per il tuo annuncio approvato! Totale: ' || v_new_total || ' punti.'
    WHEN 'business'          THEN 'Hai guadagnato ' || p_points || ' punti per aver aggiunto un''attività! Totale: ' || v_new_total || ' punti.'
    ELSE 'Hai guadagnato ' || p_points || ' punti. Totale: ' || v_new_total || ' punti.'
  END;

  -- Notifica punti in sezione "Classifica"
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    p_user_id,
    p_family_member_id,
    'points_earned',
    v_notification_title,
    v_notification_message,
    jsonb_build_object(
      'points_awarded', p_points,
      'total_points',   v_new_total,
      'reason',         p_activity_type
    )
  );

  RETURN v_new_total;
END;
$$;


