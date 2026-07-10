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
