/*
  # Review Platform Database Schema

  ## Overview
  This migration creates a comprehensive review platform for businesses, shops, and professionals.
  
  ## 1. New Tables
  
  ### `profiles`
  - `id` (uuid, primary key) - Links to auth.users
  - `email` (text) - User email
  - `full_name` (text) - User's full name
  - `user_type` (text) - 'customer' or 'business'
  - `subscription_type` (text) - 'monthly' or 'annual'
  - `subscription_status` (text) - 'active', 'expired', 'cancelled'
  - `subscription_expires_at` (timestamptz) - Expiration date
  - `created_at` (timestamptz) - Account creation date
  
  ### `business_categories`
  - `id` (uuid, primary key)
  - `name` (text) - Category name (e.g., 'Ristoranti', 'Negozi', 'Professionisti')
  - `slug` (text) - URL-friendly identifier
  - `description` (text) - Category description
  - `created_at` (timestamptz)
  
  ### `businesses`
  - `id` (uuid, primary key)
  - `owner_id` (uuid) - Links to profiles
  - `category_id` (uuid) - Links to business_categories
  - `name` (text) - Business name
  - `description` (text) - Business description
  - `address` (text) - Physical address
  - `city` (text) - City
  - `phone` (text) - Contact phone
  - `email` (text) - Contact email
  - `website` (text) - Website URL
  - `logo_url` (text) - Logo image URL
  - `verified` (boolean) - Verification status
  - `created_at` (timestamptz)
  
  ### `reviews`
  - `id` (uuid, primary key)
  - `business_id` (uuid) - Links to businesses
  - `customer_id` (uuid) - Links to profiles
  - `rating` (integer) - 1-5 stars
  - `title` (text) - Review title
  - `content` (text) - Review content
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)
  
  ### `review_responses`
  - `id` (uuid, primary key)
  - `review_id` (uuid) - Links to reviews
  - `business_id` (uuid) - Links to businesses
  - `content` (text) - Response content
  - `created_at` (timestamptz)
  
  ### `discounts`
  - `id` (uuid, primary key)
  - `business_id` (uuid) - Links to businesses
  - `title` (text) - Discount title
  - `description` (text) - Discount description
  - `discount_percentage` (integer) - Percentage off
  - `code` (text) - Discount code
  - `valid_from` (timestamptz) - Start date
  - `valid_until` (timestamptz) - End date
  - `active` (boolean) - Active status
  - `created_at` (timestamptz)
  
  ## 2. Security
  
  - Enable RLS on all tables
  - Customers can view all businesses and reviews
  - Customers can create reviews only for businesses
  - Business owners can view reviews about their business
  - Business owners can respond to reviews
  - Business owners can manage their own discounts
  - Users can only update their own profiles
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL,
  full_name text NOT NULL,
  user_type text NOT NULL CHECK (user_type IN ('customer', 'business')),
  subscription_type text CHECK (subscription_type IN ('monthly', 'annual')),
  subscription_status text DEFAULT 'expired' CHECK (subscription_status IN ('active', 'expired', 'cancelled')),
  subscription_expires_at timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Create business_categories table
CREATE TABLE IF NOT EXISTS business_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  slug text NOT NULL UNIQUE,
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE business_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view categories"
  ON business_categories FOR SELECT
  TO authenticated
  USING (true);

-- Create businesses table
CREATE TABLE IF NOT EXISTS businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES business_categories(id) ON DELETE RESTRICT,
  name text NOT NULL,
  description text DEFAULT '',
  address text DEFAULT '',
  city text DEFAULT '',
  phone text DEFAULT '',
  email text DEFAULT '',
  website text DEFAULT '',
  logo_url text DEFAULT '',
  verified boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE businesses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view verified businesses"
  ON businesses FOR SELECT
  TO authenticated
  USING (verified = true OR owner_id = auth.uid());

CREATE POLICY "Business owners can insert own business"
  ON businesses FOR INSERT
  TO authenticated
  WITH CHECK (
    owner_id = auth.uid() AND
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND user_type = 'business')
  );

CREATE POLICY "Business owners can update own business"
  ON businesses FOR UPDATE
  TO authenticated
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Business owners can delete own business"
  ON businesses FOR DELETE
  TO authenticated
  USING (owner_id = auth.uid());

-- Create reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  customer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title text NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Customers can create reviews"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid() AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND user_type = 'customer' 
      AND subscription_status = 'active'
    )
  );

CREATE POLICY "Customers can update own reviews"
  ON reviews FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers can delete own reviews"
  ON reviews FOR DELETE
  TO authenticated
  USING (customer_id = auth.uid());

-- Create review_responses table
CREATE TABLE IF NOT EXISTS review_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id uuid NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
  business_id uuid NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE review_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view review responses"
  ON review_responses FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Business owners can respond to reviews"
  ON review_responses FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses 
      WHERE id = business_id 
      AND owner_id = auth.uid()
    ) AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND subscription_status = 'active'
    )
  );

-- Create discounts table
CREATE TABLE IF NOT EXISTS discounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  discount_percentage integer NOT NULL CHECK (discount_percentage >= 1 AND discount_percentage <= 100),
  code text NOT NULL,
  valid_from timestamptz DEFAULT now(),
  valid_until timestamptz NOT NULL,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE discounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active discounts"
  ON discounts FOR SELECT
  TO authenticated
  USING (active = true AND valid_until > now());

CREATE POLICY "Business owners can create discounts"
  ON discounts FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses 
      WHERE id = business_id 
      AND owner_id = auth.uid()
    ) AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND subscription_status = 'active'
    )
  );

CREATE POLICY "Business owners can update own discounts"
  ON discounts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses 
      WHERE id = business_id 
      AND owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses 
      WHERE id = business_id 
      AND owner_id = auth.uid()
    )
  );

CREATE POLICY "Business owners can delete own discounts"
  ON discounts FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses 
      WHERE id = business_id 
      AND owner_id = auth.uid()
    )
  );

-- Insert default categories
INSERT INTO business_categories (name, slug, description) VALUES
  ('Ristoranti e Bar', 'ristoranti-bar', 'Ristoranti, bar, pizzerie e locali'),
  ('Negozi e Retail', 'negozi-retail', 'Negozi, boutique e punti vendita'),
  ('Professionisti', 'professionisti', 'Avvocati, commercialisti, consulenti'),
  ('Salute e Benessere', 'salute-benessere', 'Medici, dentisti, centri benessere'),
  ('Servizi', 'servizi', 'Idraulici, elettricisti, artigiani'),
  ('Bellezza', 'bellezza', 'Parrucchieri, estetisti, barbieri')
ON CONFLICT (slug) DO NOTHING;