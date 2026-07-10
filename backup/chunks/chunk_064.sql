-- ============================================================
-- FILE: 20260515150024_fix_approve_auction_no_id_column.sql
-- ============================================================
/*
  # Fix approve_auction: user_activity non ha colonna id

  La tabella user_activity ha PK composta (user_id, family_member_id).
  Uso EXISTS booleano invece di selezionare per id.
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
  v_exists boolean;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at dal momento dell'approvazione
  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id,
      ends_at         = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Aggiorna punti con UPDATE/INSERT manuale (no COALESCE in ON CONFLICT)
  IF v_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = v_user_id AND family_member_id = v_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points   = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at     = now()
      WHERE user_id = v_user_id AND family_member_id = v_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
      VALUES (v_user_id, v_family_member_id, 15, 1);
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = v_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points   = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at     = now()
      WHERE user_id = v_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
      VALUES (v_user_id, NULL, 15, 1);
    END IF;
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

  -- Notifica punti (sezione "Classifica")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'points_earned',
    'Punti guadagnati',
    'Hai guadagnato 15 punti per la pubblicazione della tua asta! Controlla la tua posizione in classifica.',
    jsonb_build_object('points_awarded', 15, 'reason', 'auction_approved', 'auction_id', p_auction_id));
END;
$$;


-- ============================================================
-- FILE: 20260515150058_fix_approve_auction_correct_activity_log_columns.sql
-- ============================================================
/*
  # Fix approve_auction: colonne corrette di activity_log

  activity_log ha: activity_type, title, description, points_earned, metadata
  (non action, details, points_awarded)
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
  v_exists boolean;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at dal momento dell'approvazione
  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id,
      ends_at         = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Aggiorna punti con logica UPDATE/INSERT (user_activity ha PK composta, no id)
  IF v_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = v_user_id AND family_member_id = v_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points   = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at     = now()
      WHERE user_id = v_user_id AND family_member_id = v_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
      VALUES (v_user_id, v_family_member_id, 15, 1);
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = v_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points   = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at     = now()
      WHERE user_id = v_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
      VALUES (v_user_id, NULL, 15, 1);
    END IF;
  END IF;

  -- Log attività (colonne reali: activity_type, title, description, points_earned, metadata)
  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata)
  VALUES (
    v_user_id,
    v_family_member_id,
    'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata e pubblicata.',
    15,
    jsonb_build_object('auction_id', p_auction_id)
  );

  -- Notifica approvazione (sezione "Aste")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_user_id,
    v_family_member_id,
    'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', 15)
  );

  -- Notifica punti (sezione "Classifica")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_user_id,
    v_family_member_id,
    'points_earned',
    'Punti guadagnati',
    'Hai guadagnato 15 punti per la pubblicazione della tua asta! Controlla la tua posizione in classifica.',
    jsonb_build_object('points_awarded', 15, 'reason', 'auction_approved', 'auction_id', p_auction_id)
  );
END;
$$;


-- ============================================================
-- FILE: 20260518204211_fix_search_include_approved_user_added_businesses.sql
-- ============================================================
/*
  # Fix search function to include user-added businesses with approval_status = 'approved'

  ## Changes
  - Updates the WHERE clause in search_all_business_locations() for unclaimed_business_locations
  - Previously excluded all user-added businesses (added_by IS NOT NULL) unless verification_badge = 'verified'
  - Now also shows user-added businesses where approval_status = 'approved'
  - Pending/rejected user-added businesses remain hidden from search results
*/

CREATE OR REPLACE FUNCTION search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false
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
  latitude numeric,
  longitude numeric,
  avg_rating numeric,
  review_count bigint,
  is_claimed boolean,
  is_verified boolean,
  result_source text,
  added_by uuid,
  added_by_family_member_id uuid,
  owner_id uuid,
  avatar_url text,
  location_type text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  WITH all_results AS (
    -- Attività non rivendicate (importate o aggiunte da utenti approvate)
    SELECT
    ubl.id,
    ubl.name,
    NULL::text as business_name,
    COALESCE(ubl.category_id, fm.category_id, p.category_id) as category_id,
    COALESCE(bc.name, bc_fm.name, bc_p.name) as category_name,
    COALESCE(ubl.description, '') as description,
    COALESCE(ubl.street, '') as address,
    ubl.city,
    ubl.province,
    ubl.region,
    ubl.postal_code,
    ubl.phone,
    ubl.email,
    ubl.website,
    ubl.latitude,
    ubl.longitude,
    ubl.added_by,
    ubl.added_by_family_member_id,
    NULL::uuid as owner_id,
    NULL::text as avatar_url,
    'unclaimed'::text as location_type,
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
    AND (
      ubl.added_by IS NULL
      OR ubl.verification_badge = 'verified'
      OR ubl.approval_status = 'approved'
    )
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
    bl.latitude,
    bl.longitude,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    b.owner_id,
    bl.avatar_url,
    CASE WHEN b.is_claimed THEN 'claimed' ELSE 'registered' END::text as location_type,
    'registered'::text as result_source,
    bl.created_at
    FROM business_locations bl
    JOIN businesses b ON b.id = bl.business_id
    LEFT JOIN business_categories bc ON bc.id = b.category_id
    WHERE (search_query = '' OR b.name ILIKE '%' || search_query || '%' OR bl.internal_name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)
    AND (NOT verified_only OR b.is_claimed = true)

    UNION ALL

    -- Attività registrate senza sedi (registered_businesses / registered_business_locations)
    SELECT
    rbl.id,
    COALESCE(rbl.name, rb.business_name) as name,
    rb.business_name as business_name,
    rbl.category_id,
    bc.name as category_name,
    COALESCE(rbl.description, '') as description,
    COALESCE(rbl.address, '') as address,
    COALESCE(rbl.city, '') as city,
    COALESCE(rbl.province, '') as province,
    COALESCE(rbl.region, '') as region,
    rbl.postal_code,
    COALESCE(rbl.phone, rb.phone) as phone,
    COALESCE(rbl.email, rb.email) as email,
    COALESCE(rbl.website, rb.website) as website,
    NULL::numeric as latitude,
    NULL::numeric as longitude,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    rb.owner_id,
    rbl.avatar_url,
    'registered'::text as location_type,
    'registered'::text as result_source,
    rbl.created_at
    FROM registered_business_locations rbl
    JOIN registered_businesses rb ON rb.id = rbl.business_id
    LEFT JOIN business_categories bc ON bc.id = rbl.category_id
    WHERE (search_query = '' OR rb.business_name ILIKE '%' || search_query || '%' OR rbl.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(COALESCE(rbl.city, '')) = LOWER(search_city))
    AND (search_province IS NULL OR rbl.province = search_province)
    AND (search_region IS NULL OR rbl.region ILIKE search_region)
    AND (search_category_id IS NULL OR rbl.category_id = search_category_id)
    AND (NOT verified_only OR rb.is_verified = true)
  )
  SELECT
    ar.id,
    ar.name,
    ar.business_name,
    ar.category_id,
    ar.category_name,
    ar.description,
    ar.address,
    ar.city,
    ar.province,
    ar.region,
    ar.postal_code,
    ar.phone,
    ar.email,
    ar.website,
    ar.latitude,
    ar.longitude,
    COALESCE(ratings.avg_rating, 0) as avg_rating,
    COALESCE(ratings.review_count, 0) as review_count,
    CASE WHEN ar.location_type = 'claimed' THEN true ELSE false END as is_claimed,
    CASE WHEN ar.location_type IN ('claimed', 'registered') THEN true ELSE false END as is_verified,
    ar.result_source,
    ar.added_by,
    ar.added_by_family_member_id,
    ar.owner_id,
    ar.avatar_url,
    ar.location_type,
    ar.created_at
  FROM all_results ar
  LEFT JOIN LATERAL (
    SELECT
      ROUND(AVG(r.overall_rating)::numeric, 1) as avg_rating,
      COUNT(r.id)::bigint as review_count
    FROM reviews r
    WHERE r.status = 'approved'
    AND (
      (ar.result_source IN ('imported', 'user_added') AND r.unclaimed_business_id = ar.id)
      OR (ar.result_source = 'registered' AND ar.location_type = 'claimed' AND r.unclaimed_business_id = ar.id)
      OR (ar.result_source = 'registered' AND ar.location_type IN ('registered') AND r.registered_business_location_id = ar.id)
    )
  ) ratings ON true
  ORDER BY
    CASE
      WHEN ar.result_source = 'registered' AND ar.location_type = 'claimed' THEN 1
      WHEN ar.result_source = 'registered' THEN 2
      WHEN ar.result_source = 'user_added' THEN 3
      ELSE 4
    END,
    COALESCE(ratings.review_count, 0) DESC,
    ar.created_at DESC;
END;
$$;


-- ============================================================
-- FILE: 20260519211836_add_unique_constraints_favorite_businesses.sql
-- ============================================================
/*
  # Add unique constraints to favorite_businesses table

  ## Problem
  The favorite_businesses table has no unique constraints, allowing the same
  business to be saved multiple times by the same user/family member.

  ## Changes
  - Remove duplicate rows first
  - Add partial unique indexes for each FK column (unclaimed, registered location,
    registered business, legacy location, legacy business), scoped by user_id
    and family_member_id (NULL-safe via WHERE clauses)
*/

-- Remove exact duplicates first, keeping the oldest record
DELETE FROM favorite_businesses a
USING favorite_businesses b
WHERE a.id > b.id
  AND a.user_id = b.user_id
  AND (a.family_member_id = b.family_member_id OR (a.family_member_id IS NULL AND b.family_member_id IS NULL))
  AND (a.unclaimed_business_location_id = b.unclaimed_business_location_id OR (a.unclaimed_business_location_id IS NULL AND b.unclaimed_business_location_id IS NULL))
  AND (a.registered_business_location_id = b.registered_business_location_id OR (a.registered_business_location_id IS NULL AND b.registered_business_location_id IS NULL))
  AND (a.registered_business_id = b.registered_business_id OR (a.registered_business_id IS NULL AND b.registered_business_id IS NULL))
  AND (a.business_location_id = b.business_location_id OR (a.business_location_id IS NULL AND b.business_location_id IS NULL))
  AND (a.business_id = b.business_id OR (a.business_id IS NULL AND b.business_id IS NULL));

-- Unique index for unclaimed businesses (owner, no family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_unclaimed_owner_unique
  ON favorite_businesses (user_id, unclaimed_business_location_id)
  WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NULL;

-- Unique index for unclaimed businesses (owner + family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_unclaimed_family_unique
  ON favorite_businesses (user_id, unclaimed_business_location_id, family_member_id)
  WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique index for registered business locations (owner, no family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rbl_owner_unique
  ON favorite_businesses (user_id, registered_business_location_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NULL;

-- Unique index for registered business locations (owner + family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rbl_family_unique
  ON favorite_businesses (user_id, registered_business_location_id, family_member_id)
  WHERE registered_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique index for registered businesses without location (owner, no family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rb_owner_unique
  ON favorite_businesses (user_id, registered_business_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique index for registered businesses without location (owner + family member)
CREATE UNIQUE INDEX IF NOT EXISTS favorite_businesses_rb_family_unique
  ON favorite_businesses (user_id, registered_business_id, family_member_id)
  WHERE registered_business_id IS NOT NULL AND family_member_id IS NOT NULL;


-- ============================================================
-- FILE: 20260520145850_add_professional_profile_conversation_type.sql
-- ============================================================
/*
  # Add professional_profile conversation type

  Adds 'professional_profile' to the allowed conversation_type values in the
  conversations table so that business users can start a chat from a
  professional profile page.
*/

ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_conversation_type_check;

ALTER TABLE conversations ADD CONSTRAINT conversations_conversation_type_check
  CHECK (conversation_type = ANY (ARRAY[
    'classified_ad'::text,
    'job_seeker'::text,
    'job_posting'::text,
    'auction'::text,
    'professional_profile'::text
  ]));


-- ============================================================
-- FILE: 20260520153557_fix_review_responses_support_registered_businesses.sql
-- ============================================================
/*
  # Fix review_responses to support registered businesses

  The current INSERT policy only allows owners of legacy `businesses` table entries
  to respond to reviews. This migration:

  1. Makes `business_id` nullable (registered business owners have no entry there)
  2. Adds `business_owner_id` column to track who responded
  3. Drops the old restrictive INSERT policy
  4. Adds a new INSERT policy that allows:
     - Owners of legacy businesses (via businesses table)
     - Owners of registered businesses (via registered_businesses table)
     - Any authenticated user who is the business owner (via business_owner_id match)
*/

-- Make business_id nullable
DO $$
BEGIN
  ALTER TABLE review_responses ALTER COLUMN business_id DROP NOT NULL;
EXCEPTION WHEN others THEN NULL;
END $$;

-- Add business_owner_id column if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'review_responses' AND column_name = 'business_owner_id'
  ) THEN
    ALTER TABLE review_responses ADD COLUMN business_owner_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Drop old INSERT policy
DROP POLICY IF EXISTS "Business owners can respond to reviews" ON review_responses;

-- New INSERT policy: allows legacy business owners AND registered business owners
CREATE POLICY "Business owners can respond to reviews"
  ON review_responses
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = business_owner_id
    AND (
      -- legacy businesses owner
      business_id IN (
        SELECT id FROM businesses WHERE owner_id = auth.uid()
      )
      OR
      -- registered businesses owner
      EXISTS (
        SELECT 1 FROM registered_businesses rb
        JOIN registered_business_locations rbl ON rbl.business_id = rb.id
        JOIN reviews r ON r.registered_business_location_id = rbl.id
        WHERE rb.owner_id = auth.uid()
          AND r.id = review_responses.review_id
      )
      OR
      -- business_id is null (registered business path)
      business_id IS NULL
    )
  );


-- ============================================================
-- FILE: 20260521164404_cleanup_duplicates_batch1_names_az.sql
-- ============================================================
/*
  # Cleanup duplicate unclaimed_business_locations - batch A-M

  Deletes duplicate rows (keeping oldest per name+city) for businesses
  whose name starts with A through M. Split into batches to avoid timeout.
*/

DELETE FROM unclaimed_business_locations
WHERE id IN (
  SELECT id FROM unclaimed_business_locations
  WHERE upper(left(name, 1)) BETWEEN 'A' AND 'M'
  AND id NOT IN (
    SELECT DISTINCT ON (name, city) id
    FROM unclaimed_business_locations
    WHERE upper(left(name, 1)) BETWEEN 'A' AND 'M'
    ORDER BY name, city, created_at ASC
  )
);


-- ============================================================
-- FILE: 20260521164422_cleanup_duplicates_batch2_names_nz.sql
-- ============================================================
/*
  # Cleanup duplicate unclaimed_business_locations - batch N-Z

  Deletes duplicate rows (keeping oldest per name+city) for businesses
  whose name starts with N through Z.
*/

DELETE FROM unclaimed_business_locations
WHERE id IN (
  SELECT id FROM unclaimed_business_locations
  WHERE upper(left(name, 1)) > 'M'
  AND id NOT IN (
    SELECT DISTINCT ON (name, city) id
    FROM unclaimed_business_locations
    WHERE upper(left(name, 1)) > 'M'
    ORDER BY name, city, created_at ASC
  )
);


-- ============================================================
-- FILE: 20260521164436_cleanup_duplicates_non_alpha_names.sql
-- ============================================================
/*
  # Cleanup duplicate unclaimed_business_locations - non-alphabetic names

  Handles entries whose name starts with numbers, symbols, spaces, etc.
  Also removes placeholder names like '-' or empty.
*/

-- Remove placeholder names
DELETE FROM unclaimed_business_locations
WHERE name = '-' OR TRIM(name) = '' OR name IS NULL;

-- Remove duplicates for non-alpha names
DELETE FROM unclaimed_business_locations
WHERE id IN (
  SELECT id FROM unclaimed_business_locations
  WHERE upper(left(name, 1)) < 'A' OR upper(left(name, 1)) > 'Z'
  AND id NOT IN (
    SELECT DISTINCT ON (name, city) id
    FROM unclaimed_business_locations
    WHERE upper(left(name, 1)) < 'A' OR upper(left(name, 1)) > 'Z'
    ORDER BY name, city, created_at ASC
  )
);


-- ============================================================
-- FILE: 20260521173355_fix_approve_classified_ad_no_points_for_business.sql
-- ============================================================
/*
  # Fix approve_classified_ad: no points for business users

  Business users do not participate in the leaderboard and must not receive
  points when their classified ad is approved.

  Changes:
  - `approve_classified_ad`: check the user's user_type; if 'business', skip
    award_points, skip user_activity update, and send a notification without
    the points message.
*/

CREATE OR REPLACE FUNCTION approve_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
  points_to_award integer := 5;
  v_exists boolean;
  v_user_type text;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  -- Check if the owner is a business user (no points for business accounts)
  SELECT user_type INTO v_user_type
  FROM profiles
  WHERE id = ad_record.user_id;

  UPDATE classified_ads
  SET approval_status = 'approved',
      status = 'active',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = CASE WHEN v_user_type = 'business' THEN 0 ELSE points_to_award END
  WHERE id = ad_id_param;

  -- Only award points and update leaderboard for non-business users
  IF v_user_type != 'business' THEN
    PERFORM award_points(
      ad_record.user_id,
      points_to_award,
      'classified_ad',
      'Annuncio approvato',
      ad_record.family_member_id
    );

    IF ad_record.family_member_id IS NOT NULL THEN
      SELECT EXISTS(
        SELECT 1 FROM user_activity
        WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id
      ) INTO v_exists;

      IF v_exists THEN
        UPDATE user_activity SET
          ads_posted_count = ads_posted_count + 1,
          last_activity_at = now(),
          updated_at = now()
        WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id;
      ELSE
        INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
        VALUES (ad_record.user_id, ad_record.family_member_id, 1, now(), now(), now());
      END IF;
    ELSE
      SELECT EXISTS(
        SELECT 1 FROM user_activity
        WHERE user_id = ad_record.user_id AND family_member_id IS NULL
      ) INTO v_exists;

      IF v_exists THEN
        UPDATE user_activity SET
          ads_posted_count = ads_posted_count + 1,
          last_activity_at = now(),
          updated_at = now()
        WHERE user_id = ad_record.user_id AND family_member_id IS NULL;
      ELSE
        INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
        VALUES (ad_record.user_id, NULL, 1, now(), now(), now());
      END IF;
    END IF;
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato',
    CASE WHEN v_user_type = 'business' THEN 0 ELSE points_to_award END,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'approved_by', staff_id_param),
    'check-circle',
    'green'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    CASE
      WHEN v_user_type = 'business'
        THEN 'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato.'
      ELSE 'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato. Hai guadagnato ' || points_to_award || ' punti in classifica!'
    END,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'points_awarded', CASE WHEN v_user_type = 'business' THEN 0 ELSE points_to_award END)
  );
END;
$$;


