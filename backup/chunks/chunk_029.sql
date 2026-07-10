-- ============================================================
-- FILE: 20260218213648_upgrade_conversations_to_unified_system.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260218214009_update_delete_account_unified_messaging.sql
-- ============================================================
/*
  # Update Delete Account Function for Unified Messaging

  ## Changes
  Updates the delete_user_account function to use the unified messaging system.
  Removes references to old messaging tables (ad_conversations, job_seeker_conversations, job_offer_conversations)
  and uses the new unified conversations and messages tables.

  ## Compatibility
  - Maintains all existing functionality
  - Works with the new unified messaging system
  - Cleans up all user data properly
*/

CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- Gestisci riferimenti che devono restare
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina preferiti
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_seekers WHERE user_id = user_profile_id;

  -- Elimina redemptions sconti
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina recensioni (proprie e dei membri famiglia)
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- NUOVO: Elimina messaggi e conversazioni dal sistema unificato
  DELETE FROM messages WHERE sender_id = user_profile_id;
  DELETE FROM messages WHERE conversation_id IN (
    SELECT id FROM conversations 
    WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id
  );
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;

  -- VECCHIO: Elimina da tabelle vecchie se esistono ancora (per compatibilità)
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT id FROM ad_conversations 
    WHERE buyer_id = user_profile_id OR seller_id = user_profile_id
  );
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;

  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  DELETE FROM job_seeker_messages WHERE conversation_id IN (
    SELECT id FROM job_seeker_conversations 
    WHERE employer_id = user_profile_id OR seeker_id = user_profile_id
  );
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;

  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  DELETE FROM job_offer_messages WHERE conversation_id IN (
    SELECT id FROM job_offer_conversations 
    WHERE applicant_id = user_profile_id OR employer_id = user_profile_id
  );
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;

  -- Elimina annunci classificati (propri e dei membri famiglia)
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina visualizzazioni annunci
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;

  -- Elimina job seekers (cerco lavoro)
  DELETE FROM job_seekers WHERE user_id = user_profile_id;

  -- Elimina attività e log
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Elimina notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- CONTENUTI BUSINESS
  IF user_business_id IS NOT NULL THEN
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    DELETE FROM products WHERE business_id = user_business_id;
    
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    DELETE FROM business_subscriptions WHERE business_id = user_business_id;
    
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    DELETE FROM businesses WHERE id = user_business_id;
    
    DELETE FROM unclaimed_business_locations WHERE added_by_user_id = user_profile_id;
  END IF;

  -- Elimina report fatti dall'utente
  DELETE FROM reports WHERE reported_by = user_profile_id;

  -- Elimina membri famiglia (CASCADE eliminerà i loro contenuti)
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina profilo
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;
  
  RAISE NOTICE 'Account eliminato con successo';
END;
$$;


-- ============================================================
-- FILE: 20260218214424_add_profile_context_to_conversations.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260219094514_create_featured_ads_function.sql
-- ============================================================
/*
  # Create Featured Classified Ads Function

  1. New Functions
    - `get_featured_classified_ads` - Returns classified ads sorted by user activity points
      - Takes ad_type parameter ('sell', 'buy', 'gift', 'all')
      - Returns ads from most active users first
      - Includes user information and activity points
      - Limits to top ads

  2. Changes
    - Ads from users with higher total_points are prioritized
    - Only returns active ads
    - Sorted by user points DESC, then by created_at DESC
*/

CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count integer DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ca.id,
    ca.title,
    ca.description,
    ca.price,
    ca.ad_type,
    ca.category,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;


