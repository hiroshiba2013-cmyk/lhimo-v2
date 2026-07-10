-- ============================================================
-- FILE: 20260511210626_add_family_member_to_professional_profiles.sql
-- ============================================================
/*
  # Add family_member_id to professional_profiles

  ## Summary
  Allows each family member to have their own professional profile.
  Previously, professional_profiles had a UNIQUE constraint on user_id (one per account).
  Now a profile can belong to either the account owner (family_member_id IS NULL)
  or to a specific family member (family_member_id = some UUID).

  ## Changes
  - `professional_profiles`
    - Add column `family_member_id` (uuid, nullable, FK → customer_family_members.id ON DELETE CASCADE)
    - Drop old UNIQUE constraint on user_id alone
    - Add new UNIQUE constraint on (user_id, family_member_id) NULLS NOT DISTINCT

  ## Security
  - Owner can manage profiles for themselves and their family members
  - Business users and admins can read all profiles
*/

-- 1. Add the column
ALTER TABLE professional_profiles
  ADD COLUMN IF NOT EXISTS family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;

-- 2. Drop old unique constraint and add the composite one
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name = 'professional_profiles'
      AND constraint_name = 'professional_profiles_user_id_unique'
  ) THEN
    ALTER TABLE professional_profiles DROP CONSTRAINT professional_profiles_user_id_unique;
  END IF;
END $$;

ALTER TABLE professional_profiles
  ADD CONSTRAINT professional_profiles_user_family_unique
  UNIQUE NULLS NOT DISTINCT (user_id, family_member_id);

-- 3. Index
CREATE INDEX IF NOT EXISTS professional_profiles_family_member_id_idx
  ON professional_profiles(family_member_id);

-- 4. Update RLS policies

DROP POLICY IF EXISTS "Owner can insert own professional profile" ON professional_profiles;
DROP POLICY IF EXISTS "Owner can update own professional profile" ON professional_profiles;
DROP POLICY IF EXISTS "Owner can delete own professional profile" ON professional_profiles;
DROP POLICY IF EXISTS "Owner can view own professional profile" ON professional_profiles;

-- SELECT: owner sees own + family; business users and admins see all
CREATE POLICY "Owner or business can view professional profiles"
  ON professional_profiles FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.user_type = 'business'
    )
    OR is_admin()
  );

-- INSERT: account owner can create profiles for themselves or their family members
CREATE POLICY "Owner can insert professional profile"
  ON professional_profiles FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- UPDATE: account owner can update their own or family members' profiles
CREATE POLICY "Owner can update professional profile"
  ON professional_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (
    auth.uid() = user_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- DELETE: account owner can delete their own or family members' profiles
CREATE POLICY "Owner can delete professional profile"
  ON professional_profiles FOR DELETE
  TO authenticated
  USING (
    auth.uid() = user_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
  );


-- ============================================================
-- FILE: 20260512061748_create_admin_tab_seen_timestamps.sql
-- ============================================================
/*
  # Create admin_tab_seen table

  ## Summary
  Stores per-admin, per-tab "last seen" timestamps so that informational badges
  (new users, new subscriptions) reflect items created AFTER the admin last
  visited that tab — persisted in the DB so it survives browser changes.

  ## New Table
  - `admin_tab_seen`
    - `admin_id` (uuid, FK → admins.user_id)
    - `tab` (text) — tab key e.g. 'users', 'subscriptions'
    - `seen_at` (timestamptz) — when the admin last opened this tab
    - Primary key: (admin_id, tab)

  ## Security
  - RLS enabled
  - Admins can only read/write their own rows
*/

CREATE TABLE IF NOT EXISTS admin_tab_seen (
  admin_id uuid NOT NULL REFERENCES admins(user_id) ON DELETE CASCADE,
  tab text NOT NULL,
  seen_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (admin_id, tab)
);

ALTER TABLE admin_tab_seen ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can read own tab seen"
  ON admin_tab_seen FOR SELECT
  TO authenticated
  USING (admin_id = auth.uid());

CREATE POLICY "Admin can insert own tab seen"
  ON admin_tab_seen FOR INSERT
  TO authenticated
  WITH CHECK (admin_id = auth.uid());

CREATE POLICY "Admin can update own tab seen"
  ON admin_tab_seen FOR UPDATE
  TO authenticated
  USING (admin_id = auth.uid())
  WITH CHECK (admin_id = auth.uid());


-- ============================================================
-- FILE: 20260512063813_create_get_comuni_with_few_businesses_function.sql
-- ============================================================
/*
  # Create helper function for fill-empty-comuni edge function

  Returns comuni that have fewer than p_max_count businesses in unclaimed_business_locations,
  ordered by business count ascending so the emptiest comuni come first.
*/

CREATE OR REPLACE FUNCTION get_comuni_with_few_businesses(
  p_max_count integer DEFAULT 5,
  p_limit integer DEFAULT 100
)
RETURNS TABLE(city text, province text, region text, business_count bigint)
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT city, province, region, COUNT(*) as business_count
  FROM unclaimed_business_locations
  WHERE added_by IS NULL AND city IS NOT NULL AND province IS NOT NULL
  GROUP BY city, province, region
  HAVING COUNT(*) < p_max_count
  ORDER BY business_count ASC, city ASC
  LIMIT p_limit;
$$;


-- ============================================================
-- FILE: 20260512100200_add_location_avatar_storage_policies.sql
-- ============================================================
/*
  # Add storage policies for business location avatars

  Adds INSERT, UPDATE, DELETE policies on the avatars bucket
  for files under the locations/ prefix, matching the pattern
  used by family member avatar policies.
*/

CREATE POLICY "Users can upload location avatars"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'locations'
  );

CREATE POLICY "Users can update location avatars"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'locations'
  );

CREATE POLICY "Users can delete location avatars"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'locations'
  );


-- ============================================================
-- FILE: 20260513100131_fix_search_rbl_phone_email_fallback_drop_recreate.sql
-- ============================================================
/*
  # Fix search function: use registered_business phone/email as fallback for locations

  Drop and recreate the function so COALESCE fallbacks for phone/email are applied.
  For registered_business_locations with null phone/email, falls back to parent
  registered_businesses phone/pec_email fields.
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
SELECT
ubl.id,
ubl.name,
NULL::text as business_name,
ubl.category_id,
bc.name as category_name,
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
WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
AND (search_province IS NULL OR ubl.province = search_province)
AND (search_region IS NULL OR ubl.region ILIKE search_region)
AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
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
rb.category_id,
bc.name as category_name,
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
AND (search_category_id IS NULL OR rb.category_id = search_category_id)

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
-- FILE: 20260513101231_add_category_id_to_registered_business_locations.sql
-- ============================================================
/*
  # Add category_id to registered_business_locations

  Each business location can optionally have its own category,
  allowing different branches to be categorized differently from the parent business.

  Changes:
  - Add `category_id` (uuid, nullable, FK to business_categories) to registered_business_locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_business_locations' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE registered_business_locations
      ADD COLUMN category_id uuid REFERENCES business_categories(id);
  END IF;
END $$;


-- ============================================================
-- FILE: 20260513150101_add_category_id_to_profiles_and_family_members.sql
-- ============================================================
/*
  # Add category_id to profiles (customer users) and customer_family_members

  Customer users and their family members can now select a personal category
  (e.g., their profession or area of interest). This category will be shown
  on user-added business locations in search results.

  Changes:
  - Add `category_id` (uuid, nullable, FK to business_categories) to profiles
  - Add `category_id` (uuid, nullable, FK to business_categories) to customer_family_members
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE profiles
      ADD COLUMN category_id uuid REFERENCES business_categories(id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE customer_family_members
      ADD COLUMN category_id uuid REFERENCES business_categories(id);
  END IF;
END $$;


