/*
  # Add Profile Context to Conversations

  ## Overview
  Adds support for tracking which family member or business location initiated a conversation.
  This allows filtering messages by specific family members or business locations.

  ## Changes
  1. Add `participant1_family_member_id` - Which family member is participant 1 (nullable)
  2. Add `participant2_family_member_id` - Which family member is participant 2 (nullable)
  3. Add `participant1_location_id` - Which business location is participant 1 (nullable)
  4. Add `participant2_location_id` - Which business location is participant 2 (nullable)

  ## Usage
  - For private users: use family_member_id if conversation is from a family member
  - For businesses: use location_id to specify which location the conversation is for
  - If both are NULL, it's the main account/user
  - When viewing messages, filter by the active profile (family member or location)

  ## Examples
  - Private user (main account) contacts another user: both family_member_id are NULL
  - Family member contacts someone: their family_member_id is set
  - Business location contacts someone: their location_id is set
  - Business "All Locations" view: show all conversations regardless of location_id
*/

-- Add columns to track which profile/location initiated the conversation
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'participant1_family_member_id'
  ) THEN
    ALTER TABLE conversations ADD COLUMN participant1_family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'participant2_family_member_id'
  ) THEN
    ALTER TABLE conversations ADD COLUMN participant2_family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'participant1_location_id'
  ) THEN
    ALTER TABLE conversations ADD COLUMN participant1_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'participant2_location_id'
  ) THEN
    ALTER TABLE conversations ADD COLUMN participant2_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Create indexes for filtering
CREATE INDEX IF NOT EXISTS idx_conversations_p1_family_member ON conversations(participant1_family_member_id);
CREATE INDEX IF NOT EXISTS idx_conversations_p2_family_member ON conversations(participant2_family_member_id);
CREATE INDEX IF NOT EXISTS idx_conversations_p1_location ON conversations(participant1_location_id);
CREATE INDEX IF NOT EXISTS idx_conversations_p2_location ON conversations(participant2_location_id);

-- Update the get_or_create_conversation function to support family members and locations
CREATE OR REPLACE FUNCTION get_or_create_conversation(
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

  -- Try to find existing conversation
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id
    AND (participant1_family_member_id IS NOT DISTINCT FROM v_p1_family_member_id)
    AND (participant2_family_member_id IS NOT DISTINCT FROM v_p2_family_member_id)
    AND (participant1_location_id IS NOT DISTINCT FROM v_p1_location_id)
    AND (participant2_location_id IS NOT DISTINCT FROM v_p2_location_id);

  -- Create if doesn't exist
  IF v_conversation_id IS NULL THEN
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
    RETURNING id INTO v_conversation_id;
  END IF;

  RETURN v_conversation_id;
END;
$$;

-- Update unique constraint to include profile context
DO $$
BEGIN
  -- Drop old constraint if exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'unique_conversation_unified' AND table_name = 'conversations'
  ) THEN
    ALTER TABLE conversations DROP CONSTRAINT unique_conversation_unified;
  END IF;
  
  -- Add new unique constraint that includes family member and location IDs
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'unique_conversation_with_context' AND table_name = 'conversations'
  ) THEN
    ALTER TABLE conversations 
    ADD CONSTRAINT unique_conversation_with_context 
    UNIQUE(
      participant1_id, 
      participant2_id, 
      conversation_type, 
      reference_id,
      participant1_family_member_id,
      participant2_family_member_id,
      participant1_location_id,
      participant2_location_id
    );
  END IF;
END $$;

-- Add comment explaining the profile context system
COMMENT ON COLUMN conversations.participant1_family_member_id IS 'If participant 1 is a family member, their ID. NULL means main account holder.';
COMMENT ON COLUMN conversations.participant2_family_member_id IS 'If participant 2 is a family member, their ID. NULL means main account holder.';
COMMENT ON COLUMN conversations.participant1_location_id IS 'If participant 1 is a business location, the location ID. NULL means main business or not applicable.';
COMMENT ON COLUMN conversations.participant2_location_id IS 'If participant 2 is a business location, the location ID. NULL means main business or not applicable.';
