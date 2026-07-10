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
