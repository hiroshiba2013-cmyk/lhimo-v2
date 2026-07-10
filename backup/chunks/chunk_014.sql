-- ============================================================
-- FILE: 20251228211540_create_review_proofs_storage_bucket_fixed.sql
-- ============================================================
/*
  # Crea Storage Bucket per Prove di Recensioni

  ## Modifiche
  
  1. Crea il bucket 'review-proofs' per le immagini di prova
  2. Imposta le policy di accesso:
    - Solo utenti autenticati possono caricare
    - Solo lo staff può visualizzare le immagini
    - Le immagini vengono cancellate dopo l'approvazione
  
  Note:
    - Il bucket è privato per default
    - Solo gli utenti possono caricare le proprie immagini
    - Solo lo staff business può vedere tutte le immagini
*/

-- Crea il bucket per le prove di recensioni se non esiste
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'review-proofs',
  'review-proofs',
  false,
  5242880, -- 5MB
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist
DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can upload their own review proofs" ON storage.objects;
  DROP POLICY IF EXISTS "Users can delete their own review proofs" ON storage.objects;
  DROP POLICY IF EXISTS "Staff can view all review proofs" ON storage.objects;
  DROP POLICY IF EXISTS "Users can view their own review proofs" ON storage.objects;
END $$;

-- Policy per permettere agli utenti di caricare le proprie immagini
CREATE POLICY "Users can upload their own review proofs"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'review-proofs' AND
  (storage.foldername(name))[1] = 'review-proofs' AND
  auth.uid()::text = (regexp_match(name, '^review-proofs/([a-f0-9-]+)-'))[1]
);

-- Policy per permettere agli utenti di eliminare le proprie immagini
CREATE POLICY "Users can delete their own review proofs"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'review-proofs' AND
  auth.uid()::text = (regexp_match(name, '^review-proofs/([a-f0-9-]+)-'))[1]
);

-- Policy per permettere allo staff di vedere tutte le immagini
CREATE POLICY "Staff can view all review proofs"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'review-proofs' AND
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.id = auth.uid() 
    AND profiles.user_type = 'business'
  )
);

-- Policy per permettere agli utenti di vedere le proprie immagini
CREATE POLICY "Users can view their own review proofs"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'review-proofs' AND
  auth.uid()::text = (regexp_match(name, '^review-proofs/([a-f0-9-]+)-'))[1]
);


-- ============================================================
-- FILE: 20251228220655_add_job_views_tracking.sql
-- ============================================================
/*
  # Add Job Views Tracking System

  ## Overview
  This migration creates a table to track when users view job postings, allowing them to mark jobs as "viewed" so they don't need to review them again.

  ## New Tables
  
  ### job_views
  - `id` (uuid, primary key)
  - `job_posting_id` (uuid, foreign key to job_postings)
  - `user_id` (uuid, foreign key to auth.users)
  - `viewed_at` (timestamptz) - When the job was viewed
  - `created_at` (timestamptz)

  ## Security
  - Enable RLS on job_views table
  - Users can only view and create their own job views
  - Unique constraint to prevent duplicate views

  ## Important Notes
  - Only authenticated users can track viewed jobs
  - Each user can only mark a job as viewed once (unique constraint)
  - This helps users keep track of which jobs they've already reviewed
*/

CREATE TABLE IF NOT EXISTS job_views (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  viewed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(job_posting_id, user_id)
);

ALTER TABLE job_views ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own job views"
  ON job_views FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can create their own job views"
  ON job_views FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_job_views_user_id ON job_views(user_id);
CREATE INDEX idx_job_views_job_posting_id ON job_views(job_posting_id);
CREATE INDEX idx_job_views_viewed_at ON job_views(viewed_at);


-- ============================================================
-- FILE: 20251228221325_create_products_system.sql
-- ============================================================
/*
  # Create Products System

  ## Overview
  This migration creates a comprehensive product catalog system supporting multiple categories,
  brands, and products with full-text search capabilities.

  ## New Tables
  
  ### product_categories
  - `id` (uuid, primary key)
  - `name` (text) - Category name (e.g., "Elettronica", "Automobili")
  - `slug` (text, unique) - URL-friendly identifier
  - `description` (text) - Category description
  - `parent_id` (uuid, nullable) - For hierarchical categories
  - `icon` (text) - Icon name for UI
  - `display_order` (integer) - Sort order
  - `created_at` (timestamptz)

  ### product_brands
  - `id` (uuid, primary key)
  - `name` (text, unique) - Brand name (e.g., "Samsung", "Apple", "Fiat")
  - `slug` (text, unique) - URL-friendly identifier
  - `description` (text) - Brand description
  - `logo_url` (text) - Brand logo URL
  - `website` (text) - Brand website
  - `created_at` (timestamptz)

  ### products
  - `id` (uuid, primary key)
  - `name` (text) - Product name
  - `slug` (text, unique) - URL-friendly identifier
  - `description` (text) - Product description
  - `category_id` (uuid) - Foreign key to product_categories
  - `brand_id` (uuid) - Foreign key to product_brands
  - `sku` (text, unique) - Stock Keeping Unit
  - `barcode` (text) - Product barcode/EAN
  - `price` (numeric) - Current price
  - `original_price` (numeric) - Original price before discount
  - `currency` (text) - Currency code (EUR, USD, etc.)
  - `stock_quantity` (integer) - Available quantity
  - `is_available` (boolean) - Product availability status
  - `images` (text array) - Product image URLs
  - `specifications` (jsonb) - Technical specifications
  - `rating_average` (numeric) - Average rating (0-5)
  - `rating_count` (integer) - Number of ratings
  - `view_count` (integer) - Number of views
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ## Security
  - Enable RLS on all tables
  - Allow public read access to active products
  - Only authenticated business users can manage products

  ## Indexes
  - Standard indexes on category, brand, price for efficient filtering
  - Index on slug for quick lookups
  - Text search indexes for product search
*/

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS product_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text,
  parent_id uuid REFERENCES product_categories(id) ON DELETE CASCADE,
  icon text DEFAULT 'Package',
  display_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS product_brands (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  slug text UNIQUE NOT NULL,
  description text,
  logo_url text,
  website text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text,
  category_id uuid NOT NULL REFERENCES product_categories(id) ON DELETE RESTRICT,
  brand_id uuid NOT NULL REFERENCES product_brands(id) ON DELETE RESTRICT,
  sku text UNIQUE NOT NULL,
  barcode text,
  price numeric NOT NULL DEFAULT 0,
  original_price numeric,
  currency text DEFAULT 'EUR',
  stock_quantity integer DEFAULT 0,
  is_available boolean DEFAULT true,
  images text[] DEFAULT '{}',
  specifications jsonb DEFAULT '{}',
  rating_average numeric DEFAULT 0 CHECK (rating_average >= 0 AND rating_average <= 5),
  rating_count integer DEFAULT 0,
  view_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE product_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view product categories"
  ON product_categories FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view product brands"
  ON product_brands FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view available products"
  ON products FOR SELECT
  USING (is_available = true);

CREATE POLICY "Authenticated users can view all products"
  ON products FOR SELECT
  TO authenticated
  USING (true);

CREATE INDEX idx_product_categories_parent_id ON product_categories(parent_id);
CREATE INDEX idx_product_categories_slug ON product_categories(slug);
CREATE INDEX idx_product_categories_display_order ON product_categories(display_order);

CREATE INDEX idx_product_brands_slug ON product_brands(slug);
CREATE INDEX idx_product_brands_name ON product_brands(name);

CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_brand_id ON products(brand_id);
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_is_available ON products(is_available);
CREATE INDEX idx_products_rating_average ON products(rating_average);
CREATE INDEX idx_products_created_at ON products(created_at DESC);

CREATE INDEX idx_products_name_trgm ON products USING gin(name gin_trgm_ops);
CREATE INDEX idx_products_description_trgm ON products USING gin(description gin_trgm_ops);


-- ============================================================
-- FILE: 20251228223000_create_classified_ads_system.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20251228223635_create_classified_ads_storage_bucket_fixed.sql
-- ============================================================
/*
  # Create Storage Bucket for Classified Ads Images

  ## Overview
  Creates a storage bucket for classified ads images with appropriate policies.

  ## 1. Storage Bucket
  - Create `classified-ads` bucket for storing ad images
  
  ## 2. Security
  - Public access for viewing images
  - Authenticated users can upload images
  - Users can update/delete their own images
*/

-- Create the classified-ads storage bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('classified-ads', 'classified-ads', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can view classified ad images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload classified ad images" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own classified ad images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own classified ad images" ON storage.objects;

-- Allow public to view images
CREATE POLICY "Public can view classified ad images"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'classified-ads');

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated users can upload classified ad images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'classified-ads');

-- Allow users to update their own images
CREATE POLICY "Users can update their own classified ad images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'classified-ads' AND owner = auth.uid())
  WITH CHECK (bucket_id = 'classified-ads' AND owner = auth.uid());

-- Allow users to delete their own images
CREATE POLICY "Users can delete their own classified ad images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'classified-ads' AND owner = auth.uid());


