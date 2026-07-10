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
