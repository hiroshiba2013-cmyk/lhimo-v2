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
