/*
  # Create Classified Ads System

  ## Overview
  Complete classified ads system with categories, ads, views tracking, conversations, and private messaging.

  ## 1. New Tables
  
  ### `classified_categories`
  - `id` (uuid, primary key) - Unique category identifier
  - `name` (text) - Category name
  - `slug` (text, unique) - URL-friendly slug
  - `icon` (text) - Icon name for UI
  - `description` (text, nullable) - Category description
  - `created_at` (timestamptz) - Creation timestamp

  ### `classified_ads`
  - `id` (uuid, primary key) - Unique ad identifier
  - `user_id` (uuid, foreign key) - Ad owner
  - `category_id` (uuid, foreign key) - Ad category
  - `title` (text) - Ad title
  - `description` (text) - Full ad description
  - `price` (numeric, nullable) - Price if applicable
  - `location` (text) - Location/address
  - `city` (text) - City name
  - `province` (text) - Province code
  - `region` (text) - Region name
  - `images` (text[], nullable) - Array of image URLs
  - `contact_phone` (text, nullable) - Contact phone number
  - `contact_email` (text, nullable) - Contact email
  - `status` (text) - Ad status (active, sold, expired, deleted)
  - `views_count` (integer) - Total views count
  - `expires_at` (timestamptz, nullable) - Expiration date
  - `created_at` (timestamptz) - Creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### `classified_ad_views`
  - `id` (uuid, primary key) - Unique view identifier
  - `ad_id` (uuid, foreign key) - Viewed ad
  - `user_id` (uuid, foreign key, nullable) - Viewer (null if anonymous)
  - `viewed_at` (timestamptz) - View timestamp
  - `ip_address` (text, nullable) - Viewer IP for anonymous tracking

  ### `conversations`
  - `id` (uuid, primary key) - Unique conversation identifier
  - `ad_id` (uuid, foreign key, nullable) - Related ad (nullable for general conversations)
  - `participant1_id` (uuid, foreign key) - First participant
  - `participant2_id` (uuid, foreign key) - Second participant
  - `last_message_at` (timestamptz) - Last message timestamp
  - `created_at` (timestamptz) - Creation timestamp

  ### `messages`
  - `id` (uuid, primary key) - Unique message identifier
  - `conversation_id` (uuid, foreign key) - Parent conversation
  - `sender_id` (uuid, foreign key) - Message sender
  - `content` (text) - Message content
  - `is_read` (boolean) - Read status
  - `created_at` (timestamptz) - Creation timestamp

  ## 2. Indexes
  - Index on classified_ads for fast filtering by category, status, location
  - Index on conversations for participant lookups
  - Index on messages for conversation retrieval
  - Index on ad_views for analytics

  ## 3. Security
  - Enable RLS on all tables
  - Public can view active ads
  - Users can create/edit/delete their own ads
  - Users can view their own conversations and messages
  - Users can create messages in their conversations
  - Ad views tracking allowed for all users

  ## 4. Functions
  - Function to increment views count
  - Function to get unread message count
*/

-- Create classified_categories table
CREATE TABLE IF NOT EXISTS classified_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  icon text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now()
);

-- Create classified_ads table
CREATE TABLE IF NOT EXISTS classified_ads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category_id uuid REFERENCES classified_categories(id) ON DELETE RESTRICT NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  price numeric(10, 2),
  location text NOT NULL,
  city text NOT NULL,
  province text NOT NULL,
  region text NOT NULL,
  images text[],
  contact_phone text,
  contact_email text,
  status text DEFAULT 'active' CHECK (status IN ('active', 'sold', 'expired', 'deleted')),
  views_count integer DEFAULT 0,
  expires_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create classified_ad_views table
CREATE TABLE IF NOT EXISTS classified_ad_views (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id uuid REFERENCES classified_ads(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  viewed_at timestamptz DEFAULT now(),
  ip_address text
);

-- Create conversations table
CREATE TABLE IF NOT EXISTS conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ad_id uuid REFERENCES classified_ads(id) ON DELETE SET NULL,
  participant1_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  participant2_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  last_message_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  CONSTRAINT different_participants CHECK (participant1_id != participant2_id),
  CONSTRAINT unique_conversation UNIQUE (participant1_id, participant2_id, ad_id)
);

-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid REFERENCES conversations(id) ON DELETE CASCADE NOT NULL,
  sender_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  content text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_classified_ads_category ON classified_ads(category_id) WHERE status = 'active';
CREATE INDEX IF NOT EXISTS idx_classified_ads_user ON classified_ads(user_id);
CREATE INDEX IF NOT EXISTS idx_classified_ads_status ON classified_ads(status);
CREATE INDEX IF NOT EXISTS idx_classified_ads_location ON classified_ads(city, province, region);
CREATE INDEX IF NOT EXISTS idx_classified_ads_created ON classified_ads(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_classified_ad_views_ad ON classified_ad_views(ad_id);
CREATE INDEX IF NOT EXISTS idx_conversations_participants ON conversations(participant1_id, participant2_id);
CREATE INDEX IF NOT EXISTS idx_conversations_ad ON conversations(ad_id);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_unread ON messages(conversation_id) WHERE is_read = false;

-- Enable Row Level Security
ALTER TABLE classified_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE classified_ads ENABLE ROW LEVEL SECURITY;
ALTER TABLE classified_ad_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for classified_categories
CREATE POLICY "Anyone can view categories"
  ON classified_categories FOR SELECT
  TO public
  USING (true);

-- RLS Policies for classified_ads
CREATE POLICY "Anyone can view active ads"
  ON classified_ads FOR SELECT
  TO public
  USING (status = 'active');

CREATE POLICY "Users can create their own ads"
  ON classified_ads FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ads"
  ON classified_ads FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own ads"
  ON classified_ads FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies for classified_ad_views
CREATE POLICY "Anyone can create ad views"
  ON classified_ad_views FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Users can view their own ad views"
  ON classified_ad_views FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM classified_ads
      WHERE classified_ads.id = ad_id
      AND classified_ads.user_id = auth.uid()
    )
  );

-- RLS Policies for conversations
CREATE POLICY "Users can view their own conversations"
  ON conversations FOR SELECT
  TO authenticated
  USING (
    participant1_id = auth.uid() OR
    participant2_id = auth.uid()
  );

CREATE POLICY "Users can create conversations"
  ON conversations FOR INSERT
  TO authenticated
  WITH CHECK (
    participant1_id = auth.uid() OR
    participant2_id = auth.uid()
  );

CREATE POLICY "Users can update their own conversations"
  ON conversations FOR UPDATE
  TO authenticated
  USING (
    participant1_id = auth.uid() OR
    participant2_id = auth.uid()
  )
  WITH CHECK (
    participant1_id = auth.uid() OR
    participant2_id = auth.uid()
  );

-- RLS Policies for messages
CREATE POLICY "Users can view messages in their conversations"
  ON messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM conversations
      WHERE conversations.id = conversation_id
      AND (conversations.participant1_id = auth.uid() OR conversations.participant2_id = auth.uid())
    )
  );

CREATE POLICY "Users can create messages in their conversations"
  ON messages FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id = auth.uid() AND
    EXISTS (
      SELECT 1 FROM conversations
      WHERE conversations.id = conversation_id
      AND (conversations.participant1_id = auth.uid() OR conversations.participant2_id = auth.uid())
    )
  );

CREATE POLICY "Users can update their own messages"
  ON messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM conversations
      WHERE conversations.id = conversation_id
      AND (conversations.participant1_id = auth.uid() OR conversations.participant2_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM conversations
      WHERE conversations.id = conversation_id
      AND (conversations.participant1_id = auth.uid() OR conversations.participant2_id = auth.uid())
    )
  );

-- Function to increment ad views
CREATE OR REPLACE FUNCTION increment_ad_views(ad_uuid uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE classified_ads
  SET views_count = views_count + 1
  WHERE id = ad_uuid;
END;
$$;

-- Function to get unread message count for a user
CREATE OR REPLACE FUNCTION get_unread_messages_count(user_uuid uuid)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  unread_count integer;
BEGIN
  SELECT COUNT(*)::integer INTO unread_count
  FROM messages m
  JOIN conversations c ON m.conversation_id = c.id
  WHERE (c.participant1_id = user_uuid OR c.participant2_id = user_uuid)
  AND m.sender_id != user_uuid
  AND m.is_read = false;
  
  RETURN COALESCE(unread_count, 0);
END;
$$;

-- Seed default categories
INSERT INTO classified_categories (name, slug, icon, description) VALUES
  ('Vendita Auto', 'auto', 'Car', 'Compra e vendi auto, moto e veicoli'),
  ('Immobili', 'immobili', 'Home', 'Affitti, vendite e ricerche immobiliari'),
  ('Lavoro', 'lavoro', 'Briefcase', 'Offerte di lavoro e ricerche personale'),
  ('Elettronica', 'elettronica', 'Smartphone', 'Smartphone, computer, console e accessori'),
  ('Arredamento', 'arredamento', 'Armchair', 'Mobili e complementi d''arredo'),
  ('Abbigliamento', 'abbigliamento', 'Shirt', 'Vestiti, scarpe e accessori'),
  ('Sport e Hobby', 'sport-hobby', 'Dumbbell', 'Attrezzature sportive e hobby'),
  ('Animali', 'animali', 'Dog', 'Animali domestici e accessori'),
  ('Servizi', 'servizi', 'Wrench', 'Servizi professionali e lavoretti'),
  ('Altro', 'altro', 'Package', 'Tutto il resto')
ON CONFLICT (slug) DO NOTHING;
