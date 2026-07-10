/*
  # Create Charity Organizations Table

  1. New Tables
    - `charity_organizations`
      - `id` (uuid, primary key)
      - `name` (text) - Nome dell'organizzazione
      - `description` (text) - Descrizione dell'organizzazione
      - `category` (text) - Categoria (no-profit, beneficenza, sociale, etc)
      - `website` (text) - Sito web
      - `logo_url` (text) - Logo dell'organizzazione
      - `contact_email` (text) - Email di contatto
      - `contact_phone` (text) - Telefono di contatto
      - `address` (text) - Indirizzo
      - `is_active` (boolean) - Attiva o meno
      - `total_received` (numeric) - Totale ricevuto
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS
    - Public can view active organizations
    - Only admins can manage organizations
*/

-- Create charity_organizations table
CREATE TABLE IF NOT EXISTS charity_organizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  category text NOT NULL DEFAULT 'no-profit',
  website text,
  logo_url text,
  contact_email text,
  contact_phone text,
  address text,
  is_active boolean DEFAULT true,
  total_received numeric(10, 2) DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_charity_organizations_active ON charity_organizations(is_active);
CREATE INDEX IF NOT EXISTS idx_charity_organizations_category ON charity_organizations(category);

-- Enable RLS
ALTER TABLE charity_organizations ENABLE ROW LEVEL SECURITY;

-- Public can view active organizations
CREATE POLICY "Public can view active charity organizations"
  ON charity_organizations
  FOR SELECT
  TO public
  USING (is_active = true);

-- Admins can insert organizations
CREATE POLICY "Admins can insert charity organizations"
  ON charity_organizations
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );

-- Admins can update organizations
CREATE POLICY "Admins can update charity organizations"
  ON charity_organizations
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );

-- Admins can delete organizations
CREATE POLICY "Admins can delete charity organizations"
  ON charity_organizations
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_charity_organizations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER charity_organizations_updated_at
  BEFORE UPDATE ON charity_organizations
  FOR EACH ROW
  EXECUTE FUNCTION update_charity_organizations_updated_at();
