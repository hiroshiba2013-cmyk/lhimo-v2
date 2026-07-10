/*
  # Create Messaging System for Classified Ads

  1. New Tables
    - `ad_conversations`
      - `id` (uuid, primary key)
      - `ad_id` (uuid, references classified_ads)
      - `buyer_id` (uuid, references auth.users)
      - `seller_id` (uuid, references auth.users)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
      - `last_message_at` (timestamp)
      
    - `ad_messages`
      - `id` (uuid, primary key)
      - `conversation_id` (uuid, references ad_conversations)
      - `sender_id` (uuid, references auth.users)
      - `message` (text)
      - `is_read` (boolean)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on both tables
    - Users can only see conversations they are part of
    - Users can only read messages from their conversations
    - Users can only send messages to their conversations

  3. Indexes
    - Index on ad_id for quick conversation lookup
    - Index on conversation_id for quick message lookup
    - Index on buyer_id and seller_id for user conversation lookup
*/

-- Create ad_conversations table
CREATE TABLE IF NOT EXISTS ad_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id uuid NOT NULL REFERENCES classified_ads(id) ON DELETE CASCADE,
  buyer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  seller_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  last_message_at timestamptz DEFAULT now(),
  UNIQUE(ad_id, buyer_id, seller_id)
);

-- Create ad_messages table
CREATE TABLE IF NOT EXISTS ad_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES ad_conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_ad_conversations_ad_id ON ad_conversations(ad_id);
CREATE INDEX IF NOT EXISTS idx_ad_conversations_buyer_id ON ad_conversations(buyer_id);
CREATE INDEX IF NOT EXISTS idx_ad_conversations_seller_id ON ad_conversations(seller_id);
CREATE INDEX IF NOT EXISTS idx_ad_messages_conversation_id ON ad_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_ad_messages_sender_id ON ad_messages(sender_id);

-- Enable RLS
ALTER TABLE ad_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ad_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for ad_conversations

-- Users can view conversations they are part of
CREATE POLICY "Users can view own conversations"
  ON ad_conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = buyer_id OR auth.uid() = seller_id);

-- Users can create conversations when buying
CREATE POLICY "Buyers can create conversations"
  ON ad_conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = buyer_id);

-- Users can update conversations they are part of
CREATE POLICY "Users can update own conversations"
  ON ad_conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = buyer_id OR auth.uid() = seller_id)
  WITH CHECK (auth.uid() = buyer_id OR auth.uid() = seller_id);

-- RLS Policies for ad_messages

-- Users can view messages from their conversations
CREATE POLICY "Users can view messages from own conversations"
  ON ad_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM ad_conversations
      WHERE ad_conversations.id = ad_messages.conversation_id
      AND (ad_conversations.buyer_id = auth.uid() OR ad_conversations.seller_id = auth.uid())
    )
  );

-- Users can send messages to their conversations
CREATE POLICY "Users can send messages to own conversations"
  ON ad_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM ad_conversations
      WHERE ad_conversations.id = conversation_id
      AND (ad_conversations.buyer_id = auth.uid() OR ad_conversations.seller_id = auth.uid())
    )
  );

-- Users can update their own messages (for marking as read)
CREATE POLICY "Users can update messages in own conversations"
  ON ad_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM ad_conversations
      WHERE ad_conversations.id = ad_messages.conversation_id
      AND (ad_conversations.buyer_id = auth.uid() OR ad_conversations.seller_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM ad_conversations
      WHERE ad_conversations.id = ad_messages.conversation_id
      AND (ad_conversations.buyer_id = auth.uid() OR ad_conversations.seller_id = auth.uid())
    )
  );

-- Create function to update conversation last_message_at
CREATE OR REPLACE FUNCTION update_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE ad_conversations
  SET last_message_at = NEW.created_at,
      updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for updating last_message_at
DROP TRIGGER IF EXISTS update_conversation_last_message_trigger ON ad_messages;
CREATE TRIGGER update_conversation_last_message_trigger
  AFTER INSERT ON ad_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_conversation_last_message();