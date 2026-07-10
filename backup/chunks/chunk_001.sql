-- TROVAFACILE - BACKUP SCHEMA COMPLETO
-- Generato il: Fri May 22 15:43:27 UTC 2026
-- Contiene: 426 migrazioni in ordine cronologico

-- IMPORTANTE: eseguire PRIMA di 02_data.sql
-- Eseguire nel Query Editor di Supabase oppure via psql


-- ============================================================
-- FILE: 20251125215918_create_review_platform_schema.sql
-- ============================================================
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

-- ============================================================
-- FILE: 20251128215932_add_customer_business_fields.sql
-- ============================================================
/*
  # Add Customer and Business Profile Fields

  ## Overview
  This migration adds extended fields for customer and business profiles to support 
  Italian tax and registration requirements.

  ## Changes
  
  ### Modified Tables
  - `profiles` - Add customer-specific fields
  - `businesses` - Add business-specific fields

  ## New Columns

  ### profiles table (customers)
  - `first_name` (text) - Customer first name
  - `last_name` (text) - Customer last name
  - `nickname` (text UNIQUE) - Customer's chosen nickname
  - `date_of_birth` (date) - Customer birth date
  - `tax_code` (text) - Italian fiscal code (Codice Fiscale)
  - `billing_address` (text) - Complete billing address

  ### businesses table
  - `vat_number` (text UNIQUE) - P.IVA number
  - `unique_code` (text UNIQUE) - Codice Univoco
  - `pec_email` (text) - PEC email for business
  - `phone` (text) - Business phone number
  - `billing_address` (text) - Complete billing address
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'first_name'
  ) THEN
    ALTER TABLE profiles ADD COLUMN first_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'last_name'
  ) THEN
    ALTER TABLE profiles ADD COLUMN last_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'nickname'
  ) THEN
    ALTER TABLE profiles ADD COLUMN nickname text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'date_of_birth'
  ) THEN
    ALTER TABLE profiles ADD COLUMN date_of_birth date;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'tax_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN tax_code text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'billing_address'
  ) THEN
    ALTER TABLE profiles ADD COLUMN billing_address text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'vat_number'
  ) THEN
    ALTER TABLE businesses ADD COLUMN vat_number text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'unique_code'
  ) THEN
    ALTER TABLE businesses ADD COLUMN unique_code text UNIQUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'pec_email'
  ) THEN
    ALTER TABLE businesses ADD COLUMN pec_email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'phone'
  ) THEN
    ALTER TABLE businesses ADD COLUMN phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'billing_address'
  ) THEN
    ALTER TABLE businesses ADD COLUMN billing_address text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251203102838_create_job_postings_tables.sql
-- ============================================================
/*
  # Create Job Postings and Applications Tables

  ## Overview
  This migration creates tables for job postings from businesses and job applications from users.

  ## New Tables
  
  ### job_postings
  - `id` (uuid, primary key)
  - `business_id` (uuid, foreign key to businesses)
  - `title` (text) - Job title
  - `description` (text) - Job description and requirements
  - `position_type` (text) - Full-time, Part-time, Contract, etc.
  - `salary_min` (numeric) - Minimum salary
  - `salary_max` (numeric) - Maximum salary
  - `salary_currency` (text) - Currency (EUR, USD, etc.)
  - `location` (text) - Job location/city
  - `required_skills` (text array) - Skills required
  - `experience_level` (text) - Junior, Mid, Senior
  - `published_at` (timestamptz)
  - `expires_at` (timestamptz) - Job posting expiration date
  - `status` (text) - active, closed, expired
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### job_applications
  - `id` (uuid, primary key)
  - `job_posting_id` (uuid, foreign key to job_postings)
  - `user_id` (uuid, foreign key to auth.users)
  - `status` (text) - pending, reviewed, accepted, rejected
  - `cover_letter` (text) - Applicant cover letter
  - `resume_url` (text) - URL to applicant resume
  - `applied_at` (timestamptz)
  - `reviewed_at` (timestamptz)
  - `created_at` (timestamptz)

  ## Security
  - Enable RLS on both tables
  - Add policies for businesses to manage their postings
  - Add policies for users to view postings and submit applications
  - Add policies for businesses to view applications to their postings
*/

CREATE TABLE IF NOT EXISTS job_postings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  position_type text NOT NULL DEFAULT 'Full-time',
  salary_min numeric,
  salary_max numeric,
  salary_currency text DEFAULT 'EUR',
  location text NOT NULL,
  required_skills text[] DEFAULT '{}',
  experience_level text DEFAULT 'Mid',
  published_at timestamptz DEFAULT now(),
  expires_at timestamptz NOT NULL,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS job_applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status text DEFAULT 'pending',
  cover_letter text,
  resume_url text,
  applied_at timestamptz DEFAULT now(),
  reviewed_at timestamptz,
  created_at timestamptz DEFAULT now(),
  UNIQUE(job_posting_id, user_id)
);

ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active job postings"
  ON job_postings FOR SELECT
  USING (status = 'active' AND expires_at > now());

CREATE POLICY "Businesses can view their own postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()));

CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
  );

CREATE POLICY "Businesses can update their own postings"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()))
  WITH CHECK (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()));

CREATE POLICY "Businesses can delete their own postings"
  ON job_postings FOR DELETE
  TO authenticated
  USING (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()));

CREATE POLICY "Users can view applications they submitted"
  ON job_applications FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Businesses can view applications to their postings"
  ON job_applications FOR SELECT
  TO authenticated
  USING (
    job_posting_id IN (
      SELECT id FROM job_postings 
      WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    )
  );

CREATE POLICY "Authenticated users can apply to jobs"
  ON job_applications FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own applications"
  ON job_applications FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_job_postings_business_id ON job_postings(business_id);
CREATE INDEX idx_job_postings_status ON job_postings(status);
CREATE INDEX idx_job_postings_expires_at ON job_postings(expires_at);
CREATE INDEX idx_job_applications_job_posting_id ON job_applications(job_posting_id);
CREATE INDEX idx_job_applications_user_id ON job_applications(user_id);
CREATE INDEX idx_job_applications_status ON job_applications(status);

-- ============================================================
-- FILE: 20251204100856_add_phone_and_office_address_fields.sql
-- ============================================================
/*
  # Add Phone and Office Address Fields

  ## Overview
  This migration adds new fields to support customer phone numbers and business office addresses.

  ## Changes

  ### Modified Tables
  - `profiles` - Add phone field for customer profiles
  - `businesses` - Add office_address field for business locations

  ## New Columns

  ### profiles table
  - `phone` (text) - Customer phone number

  ### businesses table
  - `office_address` (text) - Office/headquarters address (if different from billing)

  ## Notes
  These fields are optional and can be left empty if not applicable.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'phone'
  ) THEN
    ALTER TABLE profiles ADD COLUMN phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'office_address'
  ) THEN
    ALTER TABLE businesses ADD COLUMN office_address text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251204101951_add_ateco_code_to_businesses.sql
-- ============================================================
/*
  # Add ATECO Code to Businesses Table

  ## Overview
  This migration adds the ATECO code field to the businesses table to support
  Italian business classification requirements.

  ## Changes

  ### Modified Tables
  - `businesses` - Add ateco_code field

  ## New Columns

  ### businesses table
  - `ateco_code` (text) - Italian ATECO classification code for the business activity

  ## Notes
  The ATECO code is required for Italian businesses to classify their economic activity.
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'ateco_code'
  ) THEN
    ALTER TABLE businesses ADD COLUMN ateco_code text;
  END IF;
END $$;

