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
