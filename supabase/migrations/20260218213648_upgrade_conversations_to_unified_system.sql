/*
  # Upgrade Conversations to Unified Messaging System

  ## Overview
  Upgrades the existing conversations table to support all types of messaging:
  - Classified ads (sale, gift, wanted) - Private to Private
  - Job seekers (looking for work) - Private to Business
  - Job postings (offering work) - Private to Business

  ## Changes
  1. Add `conversation_type` column to identify the type of conversation
  2. Add `reference_id` column as generic reference to the entity being discussed
  3. Add `updated_at` column for tracking updates
  4. Update constraints to support the new structure
  5. Create unified messages table if needed
  6. Migrate existing data

  ## Security
  - Maintains existing RLS policies
  - Updates policies to support new conversation types
  - Family member support: all conversations tied to main user account

  ## Backward Compatibility
  - Keeps `ad_id` column for existing data
  - Migrates existing conversations to new structure
*/

-- Add new columns to conversations
DO $$
BEGIN
  -- Add conversation_type column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'conversation_type'
  ) THEN
    ALTER TABLE conversations ADD COLUMN conversation_type text DEFAULT 'classified_ad';
  END IF;

  -- Add reference_id column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'reference_id'
  ) THEN
    ALTER TABLE conversations ADD COLUMN reference_id uuid;
  END IF;

  -- Add updated_at column
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'conversations' AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE conversations ADD COLUMN updated_at timestamptz DEFAULT now();
  END IF;
END $$;

-- Populate reference_id from ad_id for existing records
UPDATE conversations 
SET reference_id = ad_id, conversation_type = 'classified_ad'
WHERE reference_id IS NULL AND ad_id IS NOT NULL;

-- Add constraint on conversation_type
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage
    WHERE constraint_name = 'conversations_conversation_type_check'
  ) THEN
    ALTER TABLE conversations 
    ADD CONSTRAINT conversations_conversation_type_check 
    CHECK (conversation_type IN ('classified_ad', 'job_seeker', 'job_posting'));
  END IF;
END $$;

-- Make conversation_type NOT NULL after setting defaults
ALTER TABLE conversations ALTER COLUMN conversation_type SET NOT NULL;

-- Create indexes for new columns
CREATE INDEX IF NOT EXISTS idx_conversations_type ON conversations(conversation_type);
CREATE INDEX IF NOT EXISTS idx_conversations_reference ON conversations(reference_id);
CREATE INDEX IF NOT EXISTS idx_conversations_type_ref ON conversations(conversation_type, reference_id);
CREATE INDEX IF NOT EXISTS idx_conversations_last_message ON conversations(last_message_at DESC);

-- Update or create unique constraint
DO $$
BEGIN
  -- Drop old constraint if exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'unique_conversation' AND table_name = 'conversations'
  ) THEN
    ALTER TABLE conversations DROP CONSTRAINT unique_conversation;
  END IF;
  
  -- Add new unique constraint
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'unique_conversation_unified' AND table_name = 'conversations'
  ) THEN
    ALTER TABLE conversations 
    ADD CONSTRAINT unique_conversation_unified 
    UNIQUE(participant1_id, participant2_id, conversation_type, reference_id);
  END IF;
END $$;

-- Check if messages table needs updating
DO $$
BEGIN
  -- Rename content column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'content'
  ) THEN
    IF EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_name = 'messages' AND column_name = 'message'
    ) THEN
      ALTER TABLE messages RENAME COLUMN message TO content;
    END IF;
  END IF;
END $$;

-- Create or update function to update last_message_at
CREATE OR REPLACE FUNCTION update_conversation_last_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE conversations
  SET 
    last_message_at = NEW.created_at,
    updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  
  RETURN NEW;
END;
$$;

-- Create trigger if it doesn't exist
DROP TRIGGER IF EXISTS trigger_update_conversation_last_message ON messages;
CREATE TRIGGER trigger_update_conversation_last_message
  AFTER INSERT ON messages
  FOR EACH ROW
  EXECUTE FUNCTION update_conversation_last_message();

-- Function to create or get conversation
CREATE OR REPLACE FUNCTION get_or_create_conversation(
  p_user1_id uuid,
  p_user2_id uuid,
  p_conversation_type text,
  p_reference_id uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_conversation_id uuid;
  v_participant1_id uuid;
  v_participant2_id uuid;
BEGIN
  -- Order participants consistently (smaller UUID first)
  IF p_user1_id < p_user2_id THEN
    v_participant1_id := p_user1_id;
    v_participant2_id := p_user2_id;
  ELSE
    v_participant1_id := p_user2_id;
    v_participant2_id := p_user1_id;
  END IF;

  -- Try to find existing conversation
  SELECT id INTO v_conversation_id
  FROM conversations
  WHERE participant1_id = v_participant1_id
    AND participant2_id = v_participant2_id
    AND conversation_type = p_conversation_type
    AND reference_id = p_reference_id;

  -- Create if doesn't exist
  IF v_conversation_id IS NULL THEN
    INSERT INTO conversations (
      participant1_id,
      participant2_id,
      conversation_type,
      reference_id,
      ad_id
    )
    VALUES (
      v_participant1_id,
      v_participant2_id,
      p_conversation_type,
      p_reference_id,
      CASE WHEN p_conversation_type = 'classified_ad' THEN p_reference_id ELSE NULL END
    )
    RETURNING id INTO v_conversation_id;
  END IF;

  RETURN v_conversation_id;
END;
$$;

-- Migrate data from old conversation tables if they exist

-- Migrate from job_seeker_conversations
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'job_seeker_conversations') THEN
    INSERT INTO conversations (
      participant1_id, 
      participant2_id, 
      conversation_type, 
      reference_id, 
      created_at, 
      updated_at, 
      last_message_at
    )
    SELECT 
      CASE WHEN seeker_id < employer_id THEN seeker_id ELSE employer_id END,
      CASE WHEN seeker_id < employer_id THEN employer_id ELSE seeker_id END,
      'job_seeker',
      job_seeker_id,
      created_at,
      updated_at,
      last_message_at
    FROM job_seeker_conversations
    ON CONFLICT (participant1_id, participant2_id, conversation_type, reference_id) DO NOTHING;
  END IF;
END $$;

-- Migrate from job_offer_conversations
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'job_offer_conversations') THEN
    INSERT INTO conversations (
      participant1_id, 
      participant2_id, 
      conversation_type, 
      reference_id, 
      created_at, 
      updated_at, 
      last_message_at
    )
    SELECT 
      CASE WHEN applicant_id < employer_id THEN applicant_id ELSE employer_id END,
      CASE WHEN applicant_id < employer_id THEN employer_id ELSE applicant_id END,
      'job_posting',
      job_posting_id,
      created_at,
      updated_at,
      last_message_at
    FROM job_offer_conversations
    ON CONFLICT (participant1_id, participant2_id, conversation_type, reference_id) DO NOTHING;
  END IF;
END $$;

-- Update RLS policies if needed
DROP POLICY IF EXISTS "Users can view own conversations" ON conversations;
CREATE POLICY "Users can view own conversations"
  ON conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

DROP POLICY IF EXISTS "Users can create conversations" ON conversations;
CREATE POLICY "Users can create conversations"
  ON conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);

DROP POLICY IF EXISTS "Users can update own conversations" ON conversations;
CREATE POLICY "Users can update own conversations"
  ON conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = participant1_id OR auth.uid() = participant2_id)
  WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);
