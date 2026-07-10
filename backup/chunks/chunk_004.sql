-- ============================================================
-- FILE: 20251215215240_update_subscription_prices.sql
-- ============================================================
/*
  # Aggiornamento Prezzi Abbonamenti

  1. Modifiche ai Piani
    - Aggiorna i prezzi per i piani cliente (1-4 persone)
    - Nuovi prezzi mensili: €0.49, €0.79, €1.09, €1.49
    - Nuovi prezzi annuali: €4.90, €7.90, €10.90, €14.90
*/

-- Aggiorna i prezzi dei piani mensili per clienti
UPDATE subscription_plans
SET price = 0.49
WHERE max_persons = 1 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 0.79
WHERE max_persons = 2 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 1.09
WHERE max_persons = 3 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 1.49
WHERE max_persons = 4 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

-- Aggiorna i prezzi dei piani annuali per clienti
UPDATE subscription_plans
SET price = 4.90
WHERE max_persons = 1 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 7.90
WHERE max_persons = 2 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 10.90
WHERE max_persons = 3 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 14.90
WHERE max_persons = 4 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

-- ============================================================
-- FILE: 20251215220103_fix_subscription_prices_correct.sql
-- ============================================================
/*
  # Correzione Prezzi Abbonamenti

  1. Modifica
    - Aggiorna correttamente i prezzi per tutti i piani cliente usando gli ID
    - Nuovi prezzi mensili: €0.49, €0.79, €1.09, €1.49
    - Nuovi prezzi annuali: €4.90, €7.90, €10.90, €14.90
*/

-- Aggiorna Piano Mensile - 1 Persona
UPDATE subscription_plans
SET price = 0.49
WHERE id = 'a3fbba4c-29e4-4bb7-8316-7387547cfb68';

-- Aggiorna Piano Annuale - 1 Persona
UPDATE subscription_plans
SET price = 4.90
WHERE id = 'cb8bad67-1ffa-4c81-bace-76322ead3165';

-- Aggiorna Piano Mensile - 2 Persone
UPDATE subscription_plans
SET price = 0.79
WHERE id = '91907577-c01b-4a3d-99b7-f90c13587064';

-- Aggiorna Piano Annuale - 2 Persone
UPDATE subscription_plans
SET price = 7.90
WHERE id = '6bb74deb-e3e6-44ca-a242-2e301e5d69bf';

-- Aggiorna Piano Mensile - 3 Persone
UPDATE subscription_plans
SET price = 1.09
WHERE id = '3fa50626-3457-4a6e-85aa-9d635e6a6fdb';

-- Aggiorna Piano Annuale - 3 Persone
UPDATE subscription_plans
SET price = 10.90
WHERE id = '175a7837-f5bf-4df2-ac27-103ec0c5d25d';

-- Aggiorna Piano Mensile - 4+ Persone
UPDATE subscription_plans
SET price = 1.49
WHERE id = 'f326f222-f3c1-40c7-b3e1-2afea5bc17ac';

-- Aggiorna Piano Annuale - 4+ Persone
UPDATE subscription_plans
SET price = 14.90
WHERE id = 'a88a0e2b-968f-4e79-8e6e-53bf0994ad69';

-- ============================================================
-- FILE: 20251216093508_add_family_member_to_job_requests.sql
-- ============================================================
/*
  # Add Family Member Support to Job Requests

  ## Overview
  This migration adds support for family members to create their own job requests
  separately from the main account holder.

  ## Changes

  ### Modified Tables
  - `job_requests`
    - Add `family_member_id` (uuid, nullable) - Foreign key to customer_family_members
    - This allows both the main account holder and family members to create job requests
    - When NULL, the job request belongs to the main account holder
    - When set, the job request belongs to the specified family member

  ## Security
  - Update RLS policies to allow family members' job requests to be managed
  - Maintain existing security for customer-owned requests

  ## Notes
  - Existing job requests will have NULL family_member_id (belonging to main account holder)
  - New job requests can optionally specify a family_member_id
*/

-- Add family_member_id to job_requests table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_requests' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE job_requests 
    ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_job_requests_family_member_id 
ON job_requests(family_member_id);

-- Update policies to support family member job requests

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own job requests" ON job_requests;
DROP POLICY IF EXISTS "Customers can create job requests" ON job_requests;
DROP POLICY IF EXISTS "Users can update own job requests" ON job_requests;
DROP POLICY IF EXISTS "Users can delete own job requests" ON job_requests;

-- Policy: Authenticated users can view their own job requests (including family members)
CREATE POLICY "Users can view own job requests"
  ON job_requests
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() = customer_id
  );

-- Policy: Authenticated customers can create job requests for themselves or their family members
CREATE POLICY "Customers can create job requests"
  ON job_requests
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = customer_id
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.user_type = 'customer'
    )
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- Policy: Users can update their own job requests (including family members)
CREATE POLICY "Users can update own job requests"
  ON job_requests
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id)
  WITH CHECK (
    auth.uid() = customer_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- Policy: Users can delete their own job requests (including family members)
CREATE POLICY "Users can delete own job requests"
  ON job_requests
  FOR DELETE
  TO authenticated
  USING (auth.uid() = customer_id);

-- ============================================================
-- FILE: 20251216102610_add_email_to_business_locations.sql
-- ============================================================
/*
  # Add email field to business locations

  1. Changes
    - Add `email` column to `business_locations` table
      - Type: text
      - Nullable: true
      - Default: empty string
    
  2. Purpose
    - Allow each business location to have its own email address
    - Enable better communication with different business locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'email'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN email text DEFAULT '' NULL;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251216103131_add_business_hours_to_locations.sql
-- ============================================================
/*
  # Add business hours and opening days to business locations

  1. Changes
    - Add `business_hours` column to `business_locations` table
      - Type: jsonb
      - Nullable: true
      - Stores opening hours for each day of the week
      - Format: { "monday": { "open": "09:00", "close": "18:00", "closed": false }, ... }
    - Add `notes` column for additional information about the location
      - Type: text
      - Nullable: true
  
  2. Purpose
    - Allow each business location to specify its opening hours
    - Enable customers to see when each location is open
    - Support different schedules for different locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'business_hours'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN business_hours jsonb DEFAULT NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'notes'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN notes text DEFAULT NULL;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251216104900_update_business_subscription_plans_new_pricing.sql
-- ============================================================
/*
  # Aggiorna prezzi abbonamenti Business
  
  1. Modifiche
    - Elimina i vecchi piani Business
    - Crea nuovi piani Business con la nuova struttura prezzi:
      - 1 sede: €2,49/mese, €24,90/anno
      - 2 sedi: €3,99/mese, €39,90/anno
      - 3 sedi: €5,49/mese, €54,90/anno
      - 4 sedi: €7,99/mese, €79,90/anno
      - 5 sedi: €9,99/mese, €99,90/anno
      - 6-10 sedi: €12,99/mese, €129,90/anno
      - 10+ sedi: €14,99/mese, €149,90/anno
  
  2. Note
    - I prezzi sono esclusi IVA
    - max_persons rappresenta il numero di sedi per i piani Business
    - Il piano viene selezionato automaticamente in base al numero di sedi durante la registrazione
*/

-- Elimina i vecchi piani Business
DELETE FROM subscription_plans 
WHERE name LIKE 'Piano Business%';

-- Crea i nuovi piani Business
INSERT INTO subscription_plans (name, price, billing_period, max_persons) VALUES
  -- 1 sede
  ('Piano Business Mensile - 1 Sede', 2.49, 'monthly', 1),
  ('Piano Business Annuale - 1 Sede', 24.90, 'yearly', 1),
  
  -- 2 sedi
  ('Piano Business Mensile - 2 Sedi', 3.99, 'monthly', 2),
  ('Piano Business Annuale - 2 Sedi', 39.90, 'yearly', 2),
  
  -- 3 sedi
  ('Piano Business Mensile - 3 Sedi', 5.49, 'monthly', 3),
  ('Piano Business Annuale - 3 Sedi', 54.90, 'yearly', 3),
  
  -- 4 sedi
  ('Piano Business Mensile - 4 Sedi', 7.99, 'monthly', 4),
  ('Piano Business Annuale - 4 Sedi', 79.90, 'yearly', 4),
  
  -- 5 sedi
  ('Piano Business Mensile - 5 Sedi', 9.99, 'monthly', 5),
  ('Piano Business Annuale - 5 Sedi', 99.90, 'yearly', 5),
  
  -- 6-10 sedi
  ('Piano Business Mensile - 6-10 Sedi', 12.99, 'monthly', 10),
  ('Piano Business Annuale - 6-10 Sedi', 129.90, 'yearly', 10),
  
  -- 10+ sedi
  ('Piano Business Mensile - Oltre 10 Sedi', 14.99, 'monthly', 999),
  ('Piano Business Annuale - Oltre 10 Sedi', 149.90, 'yearly', 999);


-- ============================================================
-- FILE: 20251216111610_allow_public_view_subscription_plans.sql
-- ============================================================
/*
  # Allow public access to subscription plans

  1. Changes
    - Update RLS policy on subscription_plans table to allow anonymous users to view plans
    - This enables the subscription page to show all available plans to non-logged-in users

  2. Security
    - Only SELECT operations are allowed
    - Users still cannot modify subscription plans
*/

DROP POLICY IF EXISTS "Anyone can view subscription plans" ON subscription_plans;

CREATE POLICY "Public can view subscription plans"
  ON subscription_plans
  FOR SELECT
  TO public
  USING (true);


-- ============================================================
-- FILE: 20251216154626_add_avatar_to_business_locations.sql
-- ============================================================
/*
  # Aggiungi campo avatar alle sedi aziendali

  1. Modifiche
    - Aggiunge il campo `avatar_url` alla tabella `business_locations`
      - Tipo: text, nullable
      - Memorizza l'URL dell'immagine avatar della sede

  2. Note
    - Il campo è opzionale (nullable)
    - Sarà utilizzato per mostrare l'immagine di ogni sede aziendale
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'avatar_url'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN avatar_url text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251216215928_add_family_member_to_reviews.sql
-- ============================================================
/*
  # Add family member association to reviews

  1. Changes
    - Add `family_member_id` column to `reviews` table to track which family member wrote the review
    - Add foreign key constraint to `customer_family_members` table
    - Add index for performance

  2. Notes
    - Column is nullable to support reviews written by the main profile
    - Existing reviews will have NULL family_member_id (written by main profile)
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;
    CREATE INDEX IF NOT EXISTS idx_reviews_family_member_id ON reviews(family_member_id);
  END IF;
END $$;


-- ============================================================
-- FILE: 20251216221514_make_business_category_optional.sql
-- ============================================================
/*
  # Make business category_id optional

  1. Changes
    - Alter `businesses` table to make `category_id` nullable
    - This allows businesses to be created without immediately selecting a category
    
  2. Notes
    - Category can be updated later through the profile/business settings
    - Existing data is preserved
*/

ALTER TABLE businesses ALTER COLUMN category_id DROP NOT NULL;


-- ============================================================
-- FILE: 20251217105436_add_vat_and_street_number_to_business_locations.sql
-- ============================================================
/*
  # Add VAT number and street number to business locations

  1. Changes
    - Add `street_number` field to business_locations table
    - Add `vat_number` field to business_locations table (optional for individual locations)
    - Add constraint to ensure province is exactly 2 uppercase characters
    
  2. Notes
    - street_number is required to separate it from the street name
    - vat_number is optional as not all locations may have separate VAT numbers
    - province must be 2 uppercase characters (e.g., 'MI', 'RM')
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'street_number'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN street_number text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'vat_number'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN vat_number text;
  END IF;
END $$;

ALTER TABLE business_locations 
  ADD CONSTRAINT business_locations_province_format 
  CHECK (province ~ '^[A-Z]{2}$');


-- ============================================================
-- FILE: 20251217162723_add_user_activity_and_rewards_tables.sql
-- ============================================================
/*
  # Add User Activity Tracking and Rewards System

  ## New Tables
  
  1. **user_activity**
     - Tracks user engagement and points
     - Columns:
       - `user_id` (uuid, foreign key to profiles)
       - `total_points` (integer) - Total points earned
       - `reviews_count` (integer) - Number of reviews written
       - `photos_count` (integer) - Number of photos uploaded
       - `badges` (text[]) - Array of earned badges
       - `last_activity_at` (timestamptz) - Last activity timestamp
       - `created_at` (timestamptz)
       - `updated_at` (timestamptz)
  
  2. **rewards**
     - Stores available rewards for users
     - Columns:
       - `id` (uuid, primary key)
       - `title` (text) - Reward title
       - `description` (text) - Reward description
       - `points_required` (integer) - Points needed to unlock
       - `icon` (text) - Icon name
       - `color` (text) - Color class for styling
       - `is_active` (boolean) - Whether reward is currently available
       - `created_at` (timestamptz)
  
  3. **user_rewards**
     - Tracks which rewards users have claimed
     - Columns:
       - `id` (uuid, primary key)
       - `user_id` (uuid, foreign key to profiles)
       - `reward_id` (uuid, foreign key to rewards)
       - `claimed_at` (timestamptz)
  
  ## Security
  - Enable RLS on all tables
  - Users can view their own activity and all rewards
  - Only authenticated users can view leaderboard
*/

-- Create user_activity table
CREATE TABLE IF NOT EXISTS user_activity (
  user_id uuid PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  total_points integer DEFAULT 0,
  reviews_count integer DEFAULT 0,
  photos_count integer DEFAULT 0,
  badges text[] DEFAULT '{}',
  last_activity_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create rewards table
CREATE TABLE IF NOT EXISTS rewards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  points_required integer NOT NULL DEFAULT 0,
  icon text DEFAULT 'gift',
  color text DEFAULT 'bg-blue-100 text-blue-600',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Create user_rewards table
CREATE TABLE IF NOT EXISTS user_rewards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reward_id uuid NOT NULL REFERENCES rewards(id) ON DELETE CASCADE,
  claimed_at timestamptz DEFAULT now(),
  UNIQUE(user_id, reward_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_activity_points ON user_activity(total_points DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_reviews ON user_activity(reviews_count DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_last_activity ON user_activity(last_activity_at DESC);
CREATE INDEX IF NOT EXISTS idx_rewards_points ON rewards(points_required);
CREATE INDEX IF NOT EXISTS idx_user_rewards_user ON user_rewards(user_id);
CREATE INDEX IF NOT EXISTS idx_user_rewards_reward ON user_rewards(reward_id);

-- Enable RLS
ALTER TABLE user_activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_rewards ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_activity
CREATE POLICY "Users can view their own activity"
  ON user_activity FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view all activity for leaderboard"
  ON user_activity FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "System can insert user activity"
  ON user_activity FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own activity"
  ON user_activity FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- RLS Policies for rewards
CREATE POLICY "Anyone can view active rewards"
  ON rewards FOR SELECT
  TO authenticated
  USING (is_active = true);

-- RLS Policies for user_rewards
CREATE POLICY "Users can view their own claimed rewards"
  ON user_rewards FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can claim rewards"
  ON user_rewards FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Function to update user activity
CREATE OR REPLACE FUNCTION update_user_activity()
RETURNS TRIGGER AS $$
BEGIN
  -- Insert or update user activity when a review is created
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  VALUES (
    NEW.customer_id,
    10,
    1,
    now(),
    now()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    total_points = user_activity.total_points + 10,
    reviews_count = user_activity.reviews_count + 1,
    last_activity_at = now(),
    updated_at = now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically update user activity when review is created
DROP TRIGGER IF EXISTS trigger_update_user_activity_on_review ON reviews;
CREATE TRIGGER trigger_update_user_activity_on_review
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_user_activity();

-- Insert some default rewards
INSERT INTO rewards (title, description, points_required, icon, color) VALUES
  ('Nuovo Arrivato', 'Benvenuto nella community! Inizia a guadagnare punti.', 0, 'star', 'bg-gray-100 text-gray-600'),
  ('Principiante', 'Hai raggiunto i tuoi primi 100 punti!', 100, 'award', 'bg-green-100 text-green-600'),
  ('Esploratore', 'Ben fatto! 500 punti guadagnati.', 500, 'medal', 'bg-blue-100 text-blue-600'),
  ('Veterano', 'Impressionante! 1000 punti raggiunti.', 1000, 'trophy', 'bg-purple-100 text-purple-600'),
  ('Maestro', 'Eccellente lavoro! 5000 punti.', 5000, 'trophy', 'bg-orange-100 text-orange-600'),
  ('Leggenda', 'Sei una leggenda! 10000 punti raggiunti!', 10000, 'trophy', 'bg-yellow-100 text-yellow-600')
ON CONFLICT DO NOTHING;


-- ============================================================
-- FILE: 20251217164422_update_points_system_remove_badges.sql
-- ============================================================
/*
  # Update Points System and Remove Badges

  ## Changes
  
  1. **Remove badges column from user_activity**
     - Badges are no longer used in the system
  
  2. **Update points system**
     - Base reviews: 15 points (updated from 10)
     - Reviews with proof (receipt/invoice): 25 points (to be implemented)
     - New business added: 10 points (to be implemented)
  
  3. **Update trigger**
     - Update the automatic trigger to award 15 points per review

  ## Notes
  - The trigger currently handles basic reviews (15 points)
  - Future enhancements will handle:
    * Reviews with proof documents (25 points)
    * New business submissions (10 points)
*/

-- Remove badges column from user_activity
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'badges'
  ) THEN
    ALTER TABLE user_activity DROP COLUMN badges;
  END IF;
END $$;

-- Update the trigger function to use 15 points instead of 10
CREATE OR REPLACE FUNCTION update_user_activity()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  VALUES (
    NEW.customer_id,
    15,
    1,
    now(),
    now()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    total_points = user_activity.total_points + 15,
    reviews_count = user_activity.reviews_count + 1,
    last_activity_at = now(),
    updated_at = now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20251217214619_add_unclaimed_businesses_support.sql
-- ============================================================
/*
  # Support for Unclaimed Businesses

  1. Changes
    - Make owner_id nullable in businesses table
    - Add is_claimed boolean field to track claimed status
    - Update RLS policies to allow public viewing of verified businesses
    - Keep existing policies for business owners to manage their claimed businesses

  2. Security
    - Public can view all verified businesses (claimed or unclaimed)
    - Only authenticated business users can claim unclaimed businesses
    - Only owners can update their claimed businesses
*/

-- Make owner_id nullable to support unclaimed businesses
ALTER TABLE businesses ALTER COLUMN owner_id DROP NOT NULL;

-- Add is_claimed field to track if business has been claimed by an owner
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE businesses ADD COLUMN is_claimed BOOLEAN DEFAULT false;
  END IF;
END $$;

-- Update existing businesses with owners as claimed
UPDATE businesses SET is_claimed = true WHERE owner_id IS NOT NULL;

-- Update RLS policies for businesses table
DROP POLICY IF EXISTS "Public can view verified businesses" ON businesses;
DROP POLICY IF EXISTS "Business owners can view own businesses" ON businesses;
DROP POLICY IF EXISTS "Business owners can insert own businesses" ON businesses;
DROP POLICY IF EXISTS "Business owners can update own businesses" ON businesses;

-- Allow public to view all verified businesses (claimed or unclaimed)
CREATE POLICY "Public can view verified businesses"
  ON businesses FOR SELECT
  TO public
  USING (verified = true);

-- Allow authenticated users to view their own businesses and unclaimed businesses
CREATE POLICY "Business owners can view own and unclaimed businesses"
  ON businesses FOR SELECT
  TO authenticated
  USING (
    owner_id = auth.uid() OR 
    (verified = true) OR 
    (owner_id IS NULL)
  );

-- Allow business owners to claim unclaimed businesses
CREATE POLICY "Business owners can claim unclaimed businesses"
  ON businesses FOR UPDATE
  TO authenticated
  USING (
    (owner_id IS NULL AND is_claimed = false) OR
    (owner_id = auth.uid())
  )
  WITH CHECK (
    (owner_id = auth.uid())
  );

-- Allow business owners to insert new businesses
CREATE POLICY "Business owners can insert own businesses"
  ON businesses FOR INSERT
  TO authenticated
  WITH CHECK (
    owner_id = auth.uid() OR owner_id IS NULL
  );

-- Allow business owners to delete only their own businesses
CREATE POLICY "Business owners can delete own businesses"
  ON businesses FOR DELETE
  TO authenticated
  USING (owner_id = auth.uid());

