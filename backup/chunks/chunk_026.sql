-- ============================================================
-- FILE: 20260211111426_add_unclaimed_business_location_reviews_support.sql
-- ============================================================
/*
  # Add support for reviews on unclaimed business locations

  1. Changes
    - Add `unclaimed_business_location_id` column to `reviews` table
    - Add foreign key constraint to `unclaimed_business_locations` table
    - Update RLS policies to support reviews on unclaimed businesses

  2. Security
    - Maintains existing RLS policies
    - Allows public to view approved reviews on unclaimed businesses
*/

-- Add unclaimed_business_location_id column to reviews
ALTER TABLE reviews 
ADD COLUMN IF NOT EXISTS unclaimed_business_location_id uuid REFERENCES unclaimed_business_locations(id) ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_reviews_unclaimed_business_location 
ON reviews(unclaimed_business_location_id) 
WHERE unclaimed_business_location_id IS NOT NULL;

-- Update the existing RLS policy for viewing reviews to include unclaimed businesses
DROP POLICY IF EXISTS "Anyone can view approved reviews" ON reviews;

CREATE POLICY "Anyone can view approved reviews"
  ON reviews FOR SELECT
  TO public
  USING (
    review_status = 'approved' 
    AND (
      business_id IS NOT NULL 
      OR imported_business_id IS NOT NULL 
      OR user_added_business_id IS NOT NULL 
      OR unclaimed_business_location_id IS NOT NULL
    )
  );

-- ============================================================
-- FILE: 20260212144406_fix_favorite_ads_visibility.sql
-- ============================================================
/*
  # Fix Favorite Ads Visibility
  
  ## Problem
  Users cannot see classified ads in their favorites section if the ad status is not 'active'.
  The existing RLS policy only allows viewing ads with status = 'active', which prevents users
  from viewing ads they have favorited if the ad was sold, expired, or deleted.
  
  ## Solution
  Add a new RLS policy that allows authenticated users to view ads they have favorited,
  regardless of the ad's status. This ensures users can always see their favorite ads.
  
  ## Changes
  1. Add new SELECT policy for authenticated users to view their favorited ads
  
  ## Important Notes
  - Users will be able to see ads they favorited even if the status changed
  - This only applies to ads the user has explicitly favorited
  - Public users still only see active ads
*/

-- Add policy to allow users to view ads they have favorited
CREATE POLICY "Users can view their favorited ads"
  ON classified_ads FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM favorite_classified_ads
      WHERE favorite_classified_ads.ad_id = classified_ads.id
      AND favorite_classified_ads.user_id = auth.uid()
    )
  );


-- ============================================================
-- FILE: 20260212150852_add_nickname_to_profiles.sql
-- ============================================================
/*
  # Add nickname to profiles table

  1. Changes
    - Add `nickname` column to `profiles` table
    - Make it nullable to allow gradual adoption
    - Users can optionally set a nickname to be displayed instead of their full name
  
  2. Security
    - No changes to RLS policies needed
    - Users can update their own nickname through existing update policy
*/

-- Add nickname column to profiles
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'nickname'
  ) THEN
    ALTER TABLE profiles ADD COLUMN nickname text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20260212155102_fix_reviews_insert_policy_family_members.sql
-- ============================================================
/*
  # Fix Reviews INSERT Policy for Family Members

  1. Changes
    - Drop old INSERT policy that only checks customer_id
    - Create new INSERT policy that allows:
      * Titolare (owner) to create reviews with family_member_id = NULL
      * Family members to create reviews with their family_member_id
    - Verify that family_member_id (if present) belongs to the authenticated user

  2. Security
    - Ensures customer_id matches auth.uid()
    - Verifies family_member_id belongs to the authenticated user
    - Maintains business_type validation
*/

-- Drop old restrictive policy
DROP POLICY IF EXISTS "Customers can create reviews for all types" ON reviews;

-- Create new policy that supports family members
CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid()
    AND (
      -- Se family_member_id è NULL, è il titolare che recensisce
      family_member_id IS NULL
      OR
      -- Se family_member_id è presente, verifica che appartenga all'utente
      EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE id = family_member_id
        AND customer_id = auth.uid()
      )
    )
    AND (
      (business_type = 'imported' AND imported_business_id IS NOT NULL)
      OR (business_type = 'user_added' AND user_added_business_id IS NOT NULL)
      OR (business_type = 'registered' AND business_id IS NOT NULL)
    )
  );


-- ============================================================
-- FILE: 20260212162000_update_search_function_include_added_by.sql
-- ============================================================
/*
  # Aggiorna funzione di ricerca per includere added_by

  1. Modifiche
    - Modifica la funzione search_all_business_locations per includere il campo added_by
    - Questo permette di mostrare il badge "Attività aggiunta da utente" nelle card
*/

DROP FUNCTION IF EXISTS search_all_business_locations(text, text, text, text, uuid, boolean, integer);

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
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
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
  ubl.added_by,
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
  NULL::uuid as added_by,
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
  uab.added_by,
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
$$;


-- ============================================================
-- FILE: 20260212162455_add_family_member_to_unclaimed_businesses.sql
-- ============================================================
/*
  # Aggiungi supporto family member per attività non rivendicate

  1. Modifiche
    - Aggiunge colonna added_by_family_member_id a unclaimed_business_locations
    - Permette di tracciare quale membro della famiglia ha aggiunto l'attività
    - Aggiorna RLS policy per permettere visualizzazione delle proprie attività

  2. Security
    - I membri della famiglia possono vedere le attività che hanno aggiunto loro
    - Il proprietario dell'account può vedere tutte le attività aggiunte dai family members
*/

-- Aggiungi colonna per tracciare quale family member ha aggiunto l'attività
ALTER TABLE unclaimed_business_locations
ADD COLUMN IF NOT EXISTS added_by_family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;

-- Crea indice per performance
CREATE INDEX IF NOT EXISTS idx_unclaimed_businesses_family_member 
ON unclaimed_business_locations(added_by_family_member_id);

-- Aggiorna policy per permettere ai family members di vedere le proprie attività
DROP POLICY IF EXISTS "Users can view own added businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can view own added businesses"
ON unclaimed_business_locations
FOR SELECT
TO authenticated
USING (
  added_by = auth.uid() 
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
);

-- Policy per inserimento con family member
DROP POLICY IF EXISTS "Users can add unclaimed businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can add unclaimed businesses"
ON unclaimed_business_locations
FOR INSERT
TO authenticated
WITH CHECK (
  added_by = auth.uid()
  OR (
    added_by_family_member_id IN (
      SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
    )
    AND added_by = auth.uid()
  )
);

-- Policy per aggiornamento
DROP POLICY IF EXISTS "Users can update own added businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can update own added businesses"
ON unclaimed_business_locations
FOR UPDATE
TO authenticated
USING (
  added_by = auth.uid()
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
)
WITH CHECK (
  added_by = auth.uid()
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
);

-- Policy per eliminazione
DROP POLICY IF EXISTS "Users can delete own added businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can delete own added businesses"
ON unclaimed_business_locations
FOR DELETE
TO authenticated
USING (
  added_by = auth.uid()
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
);


-- ============================================================
-- FILE: 20260212162630_update_search_function_include_family_member.sql
-- ============================================================
/*
  # Aggiorna funzione di ricerca per includere family_member_id

  1. Modifiche
    - Modifica la funzione search_all_business_locations per includere added_by_family_member_id
    - Permette di mostrare chi (profilo principale o family member) ha aggiunto l'attività
*/

DROP FUNCTION IF EXISTS search_all_business_locations(text, text, text, text, uuid, boolean, integer);

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
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
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
  ubl.added_by,
  ubl.added_by_family_member_id,
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
  NULL::uuid as added_by,
  NULL::uuid as added_by_family_member_id,
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
  uab.added_by,
  NULL::uuid as added_by_family_member_id,
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
$$;


-- ============================================================
-- FILE: 20260212165335_fix_user_activity_sync.sql
-- ============================================================
/*
  # Fix User Activity Synchronization

  1. Changes
    - Creates a function to sync user_activity with actual approved reviews
    - Recalculates total_points based on approved reviews only
    - Updates reviews_count to reflect only approved reviews
  
  2. Security
    - Function runs with security definer for proper access
*/

-- Function to sync user activity with approved reviews
CREATE OR REPLACE FUNCTION sync_user_activity()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update or insert user activity based on approved reviews
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  SELECT 
    p.id as user_id,
    COALESCE(SUM(CASE 
      WHEN r.proof_image_url IS NOT NULL THEN 50 
      ELSE 25 
    END), 0) as total_points,
    COUNT(r.id) as reviews_count,
    NOW() as last_activity_at,
    NOW() as updated_at
  FROM profiles p
  LEFT JOIN reviews r ON r.customer_id = p.id 
    AND r.family_member_id IS NULL 
    AND r.review_status = 'approved'
  WHERE p.user_type = 'customer'
  GROUP BY p.id
  ON CONFLICT (user_id) 
  DO UPDATE SET
    total_points = EXCLUDED.total_points,
    reviews_count = EXCLUDED.reviews_count,
    updated_at = NOW();
END;
$$;

-- Execute the sync function
SELECT sync_user_activity();


-- ============================================================
-- FILE: 20260212214043_add_unclaimed_business_support_to_favorites.sql
-- ============================================================
/*
  # Add Unclaimed Business Support to Favorites

  1. Changes
    - Add `unclaimed_business_location_id` column to `favorite_businesses`
    - Make `business_id` nullable
    - Add CHECK constraint to ensure only one ID is populated
    - Update RLS policies to support both types

  2. Security
    - Maintain existing RLS policies
    - Users can only manage their own favorites
*/

-- Add support for unclaimed businesses in favorites
ALTER TABLE favorite_businesses
  ALTER COLUMN business_id DROP NOT NULL,
  ADD COLUMN IF NOT EXISTS unclaimed_business_location_id uuid REFERENCES unclaimed_business_locations(id) ON DELETE CASCADE;

-- Add constraint to ensure only one business type is specified
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'favorite_businesses_one_business_type'
  ) THEN
    ALTER TABLE favorite_businesses
    ADD CONSTRAINT favorite_businesses_one_business_type
    CHECK (
      (business_id IS NOT NULL AND unclaimed_business_location_id IS NULL) OR
      (business_id IS NULL AND unclaimed_business_location_id IS NOT NULL)
    );
  END IF;
END $$;

-- Create index for unclaimed business favorites
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_unclaimed_location
  ON favorite_businesses(unclaimed_business_location_id);

-- Update INSERT policy to check WITH CHECK properly
DROP POLICY IF EXISTS "Users can add their own favorite businesses" ON favorite_businesses;
CREATE POLICY "Users can add their own favorite businesses"
  ON favorite_businesses
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);


-- ============================================================
-- FILE: 20260213092428_add_business_location_id_to_favorites.sql
-- ============================================================
/*
  # Add business_location_id to favorite_businesses
  
  1. Changes
    - Add business_location_id column to favorite_businesses table
    - Add foreign key constraint to business_locations
    - Add check constraint to ensure either business_id OR business_location_id OR unclaimed_business_location_id is set
  
  2. Notes
    - business_id: Legacy field for favoriting entire businesses (can be deprecated)
    - business_location_id: For favoriting specific claimed business locations
    - unclaimed_business_location_id: For favoriting unclaimed businesses
*/

-- Add business_location_id column
ALTER TABLE favorite_businesses 
ADD COLUMN IF NOT EXISTS business_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;

-- Add check constraint to ensure at least one ID is provided
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'favorite_businesses_valid_reference'
  ) THEN
    ALTER TABLE favorite_businesses
    ADD CONSTRAINT favorite_businesses_valid_reference
    CHECK (
      (business_id IS NOT NULL)::int + 
      (business_location_id IS NOT NULL)::int + 
      (unclaimed_business_location_id IS NOT NULL)::int = 1
    );
  END IF;
END $$;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_location_id 
ON favorite_businesses(business_location_id);


-- ============================================================
-- FILE: 20260213093009_create_get_location_ratings_function.sql
-- ============================================================
/*
  # Create get_location_ratings function
  
  1. New Function
    - get_location_ratings: Returns ratings for business locations or unclaimed business locations
  
  2. Purpose
    - Handles both claimed business locations and unclaimed business locations
    - Returns aggregated ratings from reviews table
  
  3. Notes
    - For claimed business locations: joins using business_location_id in reviews
    - For unclaimed business locations: joins using unclaimed_business_id in reviews
*/

CREATE OR REPLACE FUNCTION get_location_ratings(location_ids uuid[])
RETURNS TABLE (
  id uuid,
  avg_rating numeric,
  review_count bigint
)
AS $$
BEGIN
  RETURN QUERY
  WITH location_reviews AS (
    -- Get reviews for business locations
    SELECT
      bl.id as location_id,
      r.overall_rating
    FROM unnest(location_ids) AS loc(id)
    LEFT JOIN business_locations bl ON bl.id = loc.id
    LEFT JOIN reviews r ON r.business_location_id = bl.id AND r.review_status = 'approved'
    
    UNION ALL
    
    -- Get reviews for unclaimed business locations
    SELECT
      ubl.id as location_id,
      r.overall_rating
    FROM unnest(location_ids) AS loc(id)
    LEFT JOIN unclaimed_business_locations ubl ON ubl.id = loc.id
    LEFT JOIN reviews r ON r.unclaimed_business_id = ubl.id AND r.review_status = 'approved'
  )
  SELECT
    location_id as id,
    COALESCE(AVG(overall_rating), 0)::numeric as avg_rating,
    COUNT(overall_rating) as review_count
  FROM location_reviews
  GROUP BY location_id;
END;
$$ LANGUAGE plpgsql STABLE;


-- ============================================================
-- FILE: 20260213094313_fix_favorite_businesses_constraint.sql
-- ============================================================
/*
  # Fix favorite_businesses constraints

  1. Changes
    - Remove obsolete constraint `favorite_businesses_one_business_type`
    - Keep `favorite_businesses_valid_reference` which correctly allows business_id, business_location_id, or unclaimed_business_location_id
  
  2. Notes
    - The old constraint prevented using business_location_id
    - This fix allows users to favorite claimed business locations
*/

-- Remove the obsolete constraint that only allowed business_id or unclaimed_business_location_id
ALTER TABLE favorite_businesses 
DROP CONSTRAINT IF EXISTS favorite_businesses_one_business_type;


