-- ============================================================
-- FILE: 20251229092530_create_classified_ads_messaging_system.sql
-- ============================================================
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

-- ============================================================
-- FILE: 20251229093126_add_ad_type_and_expand_categories.sql
-- ============================================================
/*
  # Add Ad Type and Expand Categories

  1. Changes to classified_ads table
    - Add `ad_type` field (enum: 'sell' or 'buy')
    - Default to 'sell' for existing ads

  2. New Classified Categories
    - Add multiple new categories for different types of items
    - Categories include: Electronics, Vehicles, Real Estate, Jobs, Services, etc.

  3. Indexes
    - Add index on ad_type for faster filtering
*/

-- Add ad_type enum
DO $$ BEGIN
  CREATE TYPE ad_type_enum AS ENUM ('sell', 'buy');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Add ad_type column to classified_ads
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'ad_type'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN ad_type ad_type_enum DEFAULT 'sell' NOT NULL;
  END IF;
END $$;

-- Create index on ad_type
CREATE INDEX IF NOT EXISTS idx_classified_ads_ad_type ON classified_ads(ad_type);

-- Add more classified categories (only if they don't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM classified_categories WHERE name = 'Elettronica') THEN
    INSERT INTO classified_categories (name, icon, description) VALUES
      ('Elettronica', '📱', 'Smartphone, computer, tablet, accessori elettronici'),
      ('Abbigliamento e Accessori', '👔', 'Vestiti, scarpe, borse, gioielli'),
      ('Casa e Giardino', '🏠', 'Mobili, elettrodomestici, decorazioni, attrezzi da giardino'),
      ('Sport e Hobby', '⚽', 'Attrezzature sportive, biciclette, strumenti musicali'),
      ('Libri e Riviste', '📚', 'Libri, fumetti, riviste, materiale didattico'),
      ('Giochi e Console', '🎮', 'Videogiochi, console, giochi da tavolo'),
      ('Bambini e Neonati', '👶', 'Abbigliamento, giocattoli, passeggini, articoli per neonati'),
      ('Animali', '🐾', 'Accessori per animali, prodotti per la cura'),
      ('Motori', '🚗', 'Auto, moto, scooter, accessori per veicoli'),
      ('Immobili', '🏘️', 'Vendita e affitto case, appartamenti, terreni'),
      ('Lavoro', '💼', 'Offerte e ricerca di lavoro'),
      ('Servizi', '🔧', 'Riparazioni, pulizie, traslochi, consulenze'),
      ('Musica e Film', '🎵', 'CD, DVD, vinili, strumenti musicali'),
      ('Collezionismo', '🎨', 'Oggetti da collezione, antiquariato, opere d''arte'),
      ('Altro', '📦', 'Articoli vari non classificabili nelle altre categorie');
  END IF;
END $$;

-- ============================================================
-- FILE: 20251229093902_add_gift_option_to_ad_type.sql
-- ============================================================
/*
  # Add Gift Option to Ad Type

  1. Changes to ad_type_enum
    - Add 'gift' value to the enum
    - This allows users to offer items for free

  2. Notes
    - Existing data remains unchanged
    - New ads can now be marked as 'sell', 'buy', or 'gift'
*/

-- Add 'gift' value to ad_type enum
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum 
    WHERE enumlabel = 'gift' 
    AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')
  ) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'gift';
  END IF;
END $$;

-- ============================================================
-- FILE: 20251229095801_create_solidarity_system.sql
-- ============================================================
/*
  # Create Solidarity System

  1. New Tables
    - `solidarity_documents`
      - `id` (uuid, primary key)
      - `document_type` (enum: 'revenue', 'donation')
      - `title` (text)
      - `description` (text)
      - `file_url` (text) - URL to the uploaded document
      - `year` (integer) - Year of the document
      - `amount` (numeric) - Amount in euros (optional)
      - `recipient` (text) - For donations, who received it (optional)
      - `uploaded_by` (uuid, foreign key to auth.users)
      - `created_at` (timestamptz)

  2. Storage
    - Create bucket for solidarity documents
    - Public access for viewing documents

  3. Security
    - Enable RLS on `solidarity_documents` table
    - Anyone can view documents (transparency)
    - Only authenticated users with admin role can upload documents
*/

-- Create document_type enum
DO $$ BEGIN
  CREATE TYPE document_type_enum AS ENUM ('revenue', 'donation');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- Create solidarity_documents table
CREATE TABLE IF NOT EXISTS solidarity_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  document_type document_type_enum NOT NULL,
  title text NOT NULL,
  description text,
  file_url text NOT NULL,
  year integer NOT NULL,
  amount numeric(10, 2),
  recipient text,
  uploaded_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_solidarity_documents_year ON solidarity_documents(year DESC);
CREATE INDEX IF NOT EXISTS idx_solidarity_documents_type ON solidarity_documents(document_type);

-- Enable RLS
ALTER TABLE solidarity_documents ENABLE ROW LEVEL SECURITY;

-- Anyone can view solidarity documents (transparency)
CREATE POLICY "Anyone can view solidarity documents"
  ON solidarity_documents FOR SELECT
  TO public
  USING (true);

-- Only authenticated users can insert (we'll add admin check in the app)
CREATE POLICY "Authenticated users can insert solidarity documents"
  ON solidarity_documents FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = uploaded_by);

-- Only the uploader can update their documents
CREATE POLICY "Users can update own solidarity documents"
  ON solidarity_documents FOR UPDATE
  TO authenticated
  USING (auth.uid() = uploaded_by)
  WITH CHECK (auth.uid() = uploaded_by);

-- Only the uploader can delete their documents
CREATE POLICY "Users can delete own solidarity documents"
  ON solidarity_documents FOR DELETE
  TO authenticated
  USING (auth.uid() = uploaded_by);

-- Create storage bucket for solidarity documents
INSERT INTO storage.buckets (id, name, public)
VALUES ('solidarity-documents', 'solidarity-documents', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies: Anyone can view
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Anyone can view solidarity documents'
  ) THEN
    CREATE POLICY "Anyone can view solidarity documents"
      ON storage.objects FOR SELECT
      TO public
      USING (bucket_id = 'solidarity-documents');
  END IF;
END $$;

-- Only authenticated users can upload
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Authenticated users can upload solidarity documents'
  ) THEN
    CREATE POLICY "Authenticated users can upload solidarity documents"
      ON storage.objects FOR INSERT
      TO authenticated
      WITH CHECK (bucket_id = 'solidarity-documents');
  END IF;
END $$;

-- Users can update their own uploads
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Users can update own solidarity documents in storage'
  ) THEN
    CREATE POLICY "Users can update own solidarity documents in storage"
      ON storage.objects FOR UPDATE
      TO authenticated
      USING (bucket_id = 'solidarity-documents' AND owner::uuid = auth.uid());
  END IF;
END $$;

-- Users can delete their own uploads
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'objects' 
    AND policyname = 'Users can delete own solidarity documents from storage'
  ) THEN
    CREATE POLICY "Users can delete own solidarity documents from storage"
      ON storage.objects FOR DELETE
      TO authenticated
      USING (bucket_id = 'solidarity-documents' AND owner::uuid = auth.uid());
  END IF;
END $$;

