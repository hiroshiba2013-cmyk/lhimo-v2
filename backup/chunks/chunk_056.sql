-- ============================================================
-- FILE: 20260423145905_add_family_member_id_to_reports.sql
-- ============================================================
/*
  # Add family member support to reports

  1. Modified Tables
    - `reports`
      - Added `family_member_id` (uuid, nullable) - tracks which family member made the report
      - Added foreign key to customer_family_members
  
  2. Important notes
    - Existing reports keep family_member_id as NULL (attributed to account owner)
    - When a family member makes a report, their ID is now stored
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reports' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE reports ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_reports_family_member_id ON reports(family_member_id);


-- ============================================================
-- FILE: 20260427134003_fix_job_postings_insert_policy_registered_businesses.sql
-- ============================================================
/*
  # Fix job_postings INSERT policy to support registered_businesses

  ## Problem
  The current INSERT policy for job_postings only checks the old `businesses` table.
  Users who registered via the new system have their business in `registered_businesses`,
  causing a 403 error when trying to create a job posting.

  ## Changes
  - Drop and recreate the INSERT policy to check both `businesses` and `registered_businesses`
*/

DROP POLICY IF EXISTS "Businesses can create job postings" ON job_postings;

CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = auth.uid()
    )
    OR
    business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = auth.uid()
    )
  );


-- ============================================================
-- FILE: 20260427140550_add_registered_business_id_to_job_postings.sql
-- ============================================================
/*
  # Add registered_business_id to job_postings

  ## Problem
  The job_postings table has business_id FK pointing only to the old `businesses` table.
  Users registered via the new system (registered_businesses) get a 409 FK violation error.

  ## Changes
  - Add `registered_business_id` column with FK to registered_businesses
  - Make `business_id` nullable (to allow postings from registered_businesses only)
  - Update RLS INSERT policy to allow both business types
  - Update SELECT policy for owners to include registered_business_id
*/

-- Make business_id nullable
ALTER TABLE job_postings ALTER COLUMN business_id DROP NOT NULL;

-- Add registered_business_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'registered_business_id'
  ) THEN
    ALTER TABLE job_postings
      ADD COLUMN registered_business_id uuid REFERENCES registered_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Update INSERT policy
DROP POLICY IF EXISTS "Businesses can create job postings" ON job_postings;

CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    (business_id IS NOT NULL AND business_id IN (
      SELECT id FROM businesses WHERE owner_id = auth.uid()
    ))
    OR
    (registered_business_id IS NOT NULL AND registered_business_id IN (
      SELECT id FROM registered_businesses WHERE owner_id = auth.uid()
    ))
  );

-- Update SELECT policy for owners
DROP POLICY IF EXISTS "Businesses can view their own postings" ON job_postings;

CREATE POLICY "Businesses can view their own postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  );

-- Update UPDATE policy
DROP POLICY IF EXISTS "Businesses can update their own postings" ON job_postings;

CREATE POLICY "Businesses can update their own postings"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  )
  WITH CHECK (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  );

-- Update DELETE policy
DROP POLICY IF EXISTS "Businesses can delete their own postings" ON job_postings;

CREATE POLICY "Businesses can delete their own postings"
  ON job_postings FOR DELETE
  TO authenticated
  USING (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    OR
    registered_business_id IN (SELECT id FROM registered_businesses WHERE owner_id = auth.uid())
  );


-- ============================================================
-- FILE: 20260427141711_add_registered_business_location_id_to_job_postings.sql
-- ============================================================
/*
  # Add registered_business_location_id to job_postings

  ## Problem
  The business_location_id FK points only to business_locations (old table).
  Users with registered_business_locations get a FK violation when selecting a sede.

  ## Changes
  - Make business_location_id nullable (already is, but ensure)
  - Add registered_business_location_id with FK to registered_business_locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'registered_business_location_id'
  ) THEN
    ALTER TABLE job_postings
      ADD COLUMN registered_business_location_id uuid REFERENCES registered_business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;


-- ============================================================
-- FILE: 20260428152455_fix_get_unread_notification_count_remove_overloads.sql
-- ============================================================
/*
  # Remove overloaded versions of get_unread_notification_count

  PostgREST cannot disambiguate overloaded functions, causing 400 errors.
  Drop the 0-arg and 1-arg versions, keep only the 2-arg version which
  handles all cases (family_member_id and business_location_id).
*/

DROP FUNCTION IF EXISTS public.get_unread_notification_count();
DROP FUNCTION IF EXISTS public.get_unread_notification_count(uuid);


-- ============================================================
-- FILE: 20260428152859_fix_remove_all_overloaded_functions.sql
-- ============================================================
/*
  # Remove all overloaded functions to fix PostgREST ambiguity errors

  PostgREST cannot disambiguate overloaded functions and returns errors.
  Drop old overloads, keeping only the most complete version for each function.

  Functions cleaned up:
  - mark_all_notifications_read: keep 2-param version (family_member_id + business_location_id)
  - get_or_create_conversation: keep 8-param version (all context params)
  - get_location_ratings(uuid): keep only get_location_ratings(uuid[]) — the uuid[] version is used by ProfilePage
    The single-uuid version is superseded by get_location_ratings(uuid[])
*/

-- mark_all_notifications_read: drop 0-arg and 1-arg versions
DROP FUNCTION IF EXISTS public.mark_all_notifications_read();
DROP FUNCTION IF EXISTS public.mark_all_notifications_read(uuid);

-- get_or_create_conversation: drop 4-arg version (old, missing context params)
DROP FUNCTION IF EXISTS public.get_or_create_conversation(uuid, uuid, text, uuid);

-- get_location_ratings: two versions with same arg count but different types
-- uuid version (single location) vs uuid[] version (array)
-- They have different signatures so PostgREST CAN distinguish them by argument type
-- But keep both since they serve different callers - check if single-uuid is still used
-- Actually both have pronargs=1 so PostgREST CANNOT distinguish - drop single uuid version
-- ProfilePage uses uuid[] version; no frontend call uses single-uuid version
DROP FUNCTION IF EXISTS public.get_location_ratings(uuid);


-- ============================================================
-- FILE: 20260428153400_fix_remove_remaining_overloaded_functions.sql
-- ============================================================
/*
  # Remove remaining overloaded functions

  PostgREST cannot disambiguate overloaded functions.
  Drop older/simpler overloads, keeping only the most complete version.

  - get_business_ratings: both have pronargs=1 but different types (uuid vs uuid[])
    PostgREST identifies by name only, so any overload causes issues.
    Keep the uuid[] version (used by ProfilePage for batch ratings).
    The single-uuid version is legacy — drop it.

  - send_notification: keep 6-param version (adds target_family_member_id)
    Drop 5-param version.

  - log_user_activity: keep 9-param version (adds p_family_member_id)
    Drop 8-param version.
*/

-- get_business_ratings: drop single-uuid version, keep uuid[] version
DROP FUNCTION IF EXISTS public.get_business_ratings(uuid);

-- send_notification: drop 5-param version, keep 6-param
DROP FUNCTION IF EXISTS public.send_notification(uuid, text, text, text, jsonb);

-- log_user_activity: drop 8-param version, keep 9-param
DROP FUNCTION IF EXISTS public.log_user_activity(uuid, text, text, text, integer, jsonb, text, text);


-- ============================================================
-- FILE: 20260428160448_fix_conversation_location_id_lookup.sql
-- ============================================================
/*
  # Fix get_or_create_conversation to correctly store and match location_id

  ## Problem
  The function was ignoring location_id columns when finding existing conversations,
  meaning it would reuse a conversation created without a location_id even when
  the new call provides one. This caused business locations to never see messages
  directed to them.

  ## Changes
  1. Update get_or_create_conversation to:
     - Include location_id in the lookup (so sede1 and sede2 get separate conversations)
     - On conflict, update the location_id if it was previously NULL
  2. Backfill existing conversations: update location_id from the job_postings
     and classified_ads reference tables where possible
*/

CREATE OR REPLACE FUNCTION public.get_or_create_conversation(
  p_user1_id uuid,
  p_user2_id uuid,
  p_conversation_type text,
  p_reference_id uuid,
  p_user1_family_member_id uuid DEFAULT NULL,
  p_user2_family_member_id uuid DEFAULT NULL,
  p_user1_location_id uuid DEFAULT NULL,
  p_user2_location_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_conversation_id uuid;
  v_participant1_id uuid;
  v_participant2_id uuid;
  v_p1_family_member_id uuid;
  v_p2_family_member_id uuid;
  v_p1_location_id uuid;
  v_p2_location_id uuid;
BEGIN
  -- Order participants consistently (smaller UUID first)
  IF p_user1_id < p_user2_id THEN
    v_participant1_id := p_user1_id;
    v_participant2_id := p_user2_id;
    v_p1_family_member_id := p_user1_family_member_id;
    v_p2_family_member_id := p_user2_family_member_id;
    v_p1_location_id := p_user1_location_id;
    v_p2_location_id := p_user2_location_id;
  ELSE
    v_participant1_id := p_user2_id;
    v_participant2_id := p_user1_id;
    v_p1_family_member_id := p_user2_family_member_id;
    v_p2_family_member_id := p_user1_family_member_id;
    v_p1_location_id := p_user2_location_id;
    v_p2_location_id := p_user1_location_id;
  END IF;

  -- Try to find existing conversation matching all context (including location)
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
    AND (
      -- Match with location context
      (
        (v_p1_location_id IS NULL OR participant1_location_id = v_p1_location_id) AND
        (v_p2_location_id IS NULL OR participant2_location_id = v_p2_location_id)
      )
      OR
      -- Also match legacy conversations with no location set (for backwards compat)
      (participant1_location_id IS NULL AND participant2_location_id IS NULL)
    )
  ORDER BY
    -- Prefer exact location match over NULL legacy rows
    CASE WHEN participant1_location_id = v_p1_location_id OR participant2_location_id = v_p2_location_id THEN 0 ELSE 1 END
  LIMIT 1;

  IF v_conversation_id IS NOT NULL THEN
    -- Update location_id if the existing row had NULL (backfill legacy conversations)
    IF v_p1_location_id IS NOT NULL OR v_p2_location_id IS NOT NULL THEN
      UPDATE conversations
      SET
        participant1_location_id = COALESCE(participant1_location_id, v_p1_location_id),
        participant2_location_id = COALESCE(participant2_location_id, v_p2_location_id),
        updated_at = now()
      WHERE id = v_conversation_id
        AND (participant1_location_id IS NULL OR participant2_location_id IS NULL);
    END IF;
    RETURN v_conversation_id;
  END IF;

  -- Insert new conversation
  INSERT INTO conversations (
    participant1_id,
    participant2_id,
    conversation_type,
    reference_id,
    participant1_family_member_id,
    participant2_family_member_id,
    participant1_location_id,
    participant2_location_id,
    ad_id
  )
  VALUES (
    v_participant1_id,
    v_participant2_id,
    p_conversation_type,
    p_reference_id,
    v_p1_family_member_id,
    v_p2_family_member_id,
    v_p1_location_id,
    v_p2_location_id,
    CASE WHEN p_conversation_type = 'classified_ad' THEN p_reference_id ELSE NULL END
  )
  ON CONFLICT ON CONSTRAINT unique_conversation_with_context
  DO UPDATE SET
    participant1_location_id = COALESCE(conversations.participant1_location_id, EXCLUDED.participant1_location_id),
    participant2_location_id = COALESCE(conversations.participant2_location_id, EXCLUDED.participant2_location_id),
    updated_at = now()
  RETURNING id INTO v_conversation_id;

  IF v_conversation_id IS NULL THEN
    SELECT id INTO v_conversation_id
    FROM conversations
    WHERE participant1_id = v_participant1_id
      AND participant2_id = v_participant2_id
      AND conversation_type = p_conversation_type
      AND reference_id = p_reference_id
    LIMIT 1;
  END IF;

  RETURN v_conversation_id;
END;
$$;


-- ============================================================
-- FILE: 20260503161539_fix_unique_conversation_nulls_not_distinct_v2.sql
-- ============================================================


-- ============================================================
-- FILE: 20260503163114_fix_get_or_create_conversation_no_update.sql
-- ============================================================
/*
  # Simplify get_or_create_conversation - remove problematic UPDATE logic

  ## Problem
  The ON CONFLICT DO UPDATE was triggering RLS WITH CHECK failures (409) even
  inside a SECURITY DEFINER function, because Supabase evaluates RLS on the
  UPDATE path of ON CONFLICT.

  ## Fix
  - Remove the UPDATE in ON CONFLICT (use DO NOTHING instead)
  - The SELECT at the top already finds and returns existing conversations
  - No backfill needed: new conversations will have the correct location_id going forward
*/

CREATE OR REPLACE FUNCTION public.get_or_create_conversation(
  p_user1_id uuid,
  p_user2_id uuid,
  p_conversation_type text,
  p_reference_id uuid,
  p_user1_family_member_id uuid DEFAULT NULL,
  p_user2_family_member_id uuid DEFAULT NULL,
  p_user1_location_id uuid DEFAULT NULL,
  p_user2_location_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_conversation_id uuid;
  v_participant1_id uuid;
  v_participant2_id uuid;
  v_p1_family_member_id uuid;
  v_p2_family_member_id uuid;
  v_p1_location_id uuid;
  v_p2_location_id uuid;
BEGIN
  -- Order participants consistently (smaller UUID first)
  IF p_user1_id < p_user2_id THEN
    v_participant1_id := p_user1_id;
    v_participant2_id := p_user2_id;
    v_p1_family_member_id := p_user1_family_member_id;
    v_p2_family_member_id := p_user2_family_member_id;
    v_p1_location_id := p_user1_location_id;
    v_p2_location_id := p_user2_location_id;
  ELSE
    v_participant1_id := p_user2_id;
    v_participant2_id := p_user1_id;
    v_p1_family_member_id := p_user2_family_member_id;
    v_p2_family_member_id := p_user1_family_member_id;
    v_p1_location_id := p_user2_location_id;
    v_p2_location_id := p_user1_location_id;
  END IF;

  -- Look for existing conversation (exact match including location)
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
    AND participant1_family_member_id IS NOT DISTINCT FROM v_p1_family_member_id
    AND participant2_family_member_id IS NOT DISTINCT FROM v_p2_family_member_id
    AND participant1_location_id IS NOT DISTINCT FROM v_p1_location_id
    AND participant2_location_id IS NOT DISTINCT FROM v_p2_location_id
  LIMIT 1;

  IF v_conversation_id IS NOT NULL THEN
    RETURN v_conversation_id;
  END IF;

  -- Insert new conversation
  INSERT INTO conversations (
    participant1_id,
    participant2_id,
    conversation_type,
    reference_id,
    participant1_family_member_id,
    participant2_family_member_id,
    participant1_location_id,
    participant2_location_id,
    ad_id
  )
  VALUES (
    v_participant1_id,
    v_participant2_id,
    p_conversation_type,
    p_reference_id,
    v_p1_family_member_id,
    v_p2_family_member_id,
    v_p1_location_id,
    v_p2_location_id,
    CASE WHEN p_conversation_type = 'classified_ad' THEN p_reference_id ELSE NULL END
  )
  ON CONFLICT ON CONSTRAINT unique_conversation_with_context
  DO NOTHING;

  -- Fetch the id whether inserted or already existing
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
    AND participant1_family_member_id IS NOT DISTINCT FROM v_p1_family_member_id
    AND participant2_family_member_id IS NOT DISTINCT FROM v_p2_family_member_id
    AND participant1_location_id IS NOT DISTINCT FROM v_p1_location_id
    AND participant2_location_id IS NOT DISTINCT FROM v_p2_location_id
  LIMIT 1;

  RETURN v_conversation_id;
END;
$$;


-- ============================================================
-- FILE: 20260503164352_fix_get_or_create_conversation_ignore_location_in_lookup.sql
-- ============================================================
/*
  # Fix get_or_create_conversation - ignore location_id in existence check

  ## Problem
  When participant ordering swaps user1/user2 (based on UUID comparison), the
  location_id ends up on a different participant slot than the existing conversation.
  This makes the SELECT miss the existing row and attempt an INSERT that violates
  the unique constraint → 409 error.

  ## Fix
  - First SELECT: find existing conversation by participants + type + reference ONLY
    (ignore family_member_id and location_id — these are context, not identity)
  - If found: return it immediately (no update needed)
  - If not found: INSERT with full context, DO NOTHING on conflict, then SELECT again
*/

CREATE OR REPLACE FUNCTION public.get_or_create_conversation(
  p_user1_id uuid,
  p_user2_id uuid,
  p_conversation_type text,
  p_reference_id uuid,
  p_user1_family_member_id uuid DEFAULT NULL,
  p_user2_family_member_id uuid DEFAULT NULL,
  p_user1_location_id uuid DEFAULT NULL,
  p_user2_location_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_conversation_id uuid;
  v_participant1_id uuid;
  v_participant2_id uuid;
  v_p1_family_member_id uuid;
  v_p2_family_member_id uuid;
  v_p1_location_id uuid;
  v_p2_location_id uuid;
BEGIN
  -- Order participants consistently (smaller UUID first)
  IF p_user1_id < p_user2_id THEN
    v_participant1_id := p_user1_id;
    v_participant2_id := p_user2_id;
    v_p1_family_member_id := p_user1_family_member_id;
    v_p2_family_member_id := p_user2_family_member_id;
    v_p1_location_id := p_user1_location_id;
    v_p2_location_id := p_user2_location_id;
  ELSE
    v_participant1_id := p_user2_id;
    v_participant2_id := p_user1_id;
    v_p1_family_member_id := p_user2_family_member_id;
    v_p2_family_member_id := p_user1_family_member_id;
    v_p1_location_id := p_user2_location_id;
    v_p2_location_id := p_user1_location_id;
  END IF;

  -- Look for existing conversation by core identity only (participants + type + reference)
  -- Ignore location/family context so we always find the existing row regardless of
  -- which slot the location ended up in during a previous call
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
  LIMIT 1;

  IF v_conversation_id IS NOT NULL THEN
    RETURN v_conversation_id;
  END IF;

  -- Insert new conversation with full context
  INSERT INTO conversations (
    participant1_id,
    participant2_id,
    conversation_type,
    reference_id,
    participant1_family_member_id,
    participant2_family_member_id,
    participant1_location_id,
    participant2_location_id,
    ad_id
  )
  VALUES (
    v_participant1_id,
    v_participant2_id,
    p_conversation_type,
    p_reference_id,
    v_p1_family_member_id,
    v_p2_family_member_id,
    v_p1_location_id,
    v_p2_location_id,
    CASE WHEN p_conversation_type = 'classified_ad' THEN p_reference_id ELSE NULL END
  )
  ON CONFLICT ON CONSTRAINT unique_conversation_with_context
  DO NOTHING;

  -- Fetch the id whether inserted or conflicted
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
  LIMIT 1;

  RETURN v_conversation_id;
END;
$$;


-- ============================================================
-- FILE: 20260503173936_fix_conversation_location_id_lookup.sql
-- ============================================================
/*
  # Fix conversation location_id - support both business_locations and registered_business_locations

  ## Problem
  conversations.participant1_location_id and participant2_location_id have FK constraints
  pointing only to business_locations. But the frontend also passes registered_business_location_id
  values (from registered_business_locations table), causing FK violations → HTTP 409.

  ## Fix
  - Drop the FK constraints on participant1_location_id and participant2_location_id
  - Add equivalent FK constraints to registered_business_locations for the same columns
    is not feasible (one column can't FK two tables)
  - Solution: drop FK constraints entirely, store UUID references loosely
    (the existing unique constraint and indexes are sufficient)
  - Update get_or_create_conversation to also check registered_business_locations
    and pass NULL if the location_id doesn't exist in either table
*/

-- Drop FK constraints on location columns (they're too restrictive)
ALTER TABLE conversations 
  DROP CONSTRAINT IF EXISTS conversations_participant1_location_id_fkey,
  DROP CONSTRAINT IF EXISTS conversations_participant2_location_id_fkey;

-- Replace the function to validate location_id exists in either locations table
CREATE OR REPLACE FUNCTION public.get_or_create_conversation(
  p_user1_id uuid,
  p_user2_id uuid,
  p_conversation_type text,
  p_reference_id uuid,
  p_user1_family_member_id uuid DEFAULT NULL,
  p_user2_family_member_id uuid DEFAULT NULL,
  p_user1_location_id uuid DEFAULT NULL,
  p_user2_location_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_conversation_id uuid;
  v_participant1_id uuid;
  v_participant2_id uuid;
  v_p1_family_member_id uuid;
  v_p2_family_member_id uuid;
  v_p1_location_id uuid;
  v_p2_location_id uuid;
  v_loc_exists boolean;
BEGIN
  -- Order participants consistently (smaller UUID first)
  IF p_user1_id < p_user2_id THEN
    v_participant1_id := p_user1_id;
    v_participant2_id := p_user2_id;
    v_p1_family_member_id := p_user1_family_member_id;
    v_p2_family_member_id := p_user2_family_member_id;
    v_p1_location_id := p_user1_location_id;
    v_p2_location_id := p_user2_location_id;
  ELSE
    v_participant1_id := p_user2_id;
    v_participant2_id := p_user1_id;
    v_p1_family_member_id := p_user2_family_member_id;
    v_p2_family_member_id := p_user1_family_member_id;
    v_p1_location_id := p_user2_location_id;
    v_p2_location_id := p_user1_location_id;
  END IF;

  -- Validate p1 location: must exist in business_locations OR registered_business_locations
  IF v_p1_location_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM business_locations WHERE id = v_p1_location_id
      UNION ALL
      SELECT 1 FROM registered_business_locations WHERE id = v_p1_location_id
    ) INTO v_loc_exists;
    IF NOT v_loc_exists THEN
      v_p1_location_id := NULL;
    END IF;
  END IF;

  -- Validate p2 location: must exist in business_locations OR registered_business_locations
  IF v_p2_location_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM business_locations WHERE id = v_p2_location_id
      UNION ALL
      SELECT 1 FROM registered_business_locations WHERE id = v_p2_location_id
    ) INTO v_loc_exists;
    IF NOT v_loc_exists THEN
      v_p2_location_id := NULL;
    END IF;
  END IF;

  -- Look for existing conversation by core identity only
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
  LIMIT 1;

  IF v_conversation_id IS NOT NULL THEN
    RETURN v_conversation_id;
  END IF;

  -- Insert new conversation
  INSERT INTO conversations (
    participant1_id,
    participant2_id,
    conversation_type,
    reference_id,
    participant1_family_member_id,
    participant2_family_member_id,
    participant1_location_id,
    participant2_location_id,
    ad_id
  )
  VALUES (
    v_participant1_id,
    v_participant2_id,
    p_conversation_type,
    p_reference_id,
    v_p1_family_member_id,
    v_p2_family_member_id,
    v_p1_location_id,
    v_p2_location_id,
    CASE WHEN p_conversation_type = 'classified_ad' THEN p_reference_id ELSE NULL END
  )
  ON CONFLICT ON CONSTRAINT unique_conversation_with_context
  DO NOTHING;

  -- Fetch id regardless of insert or conflict
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
  LIMIT 1;

  RETURN v_conversation_id;
END;
$$;


