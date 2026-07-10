-- ============================================================
-- FILE: 20260114100545_add_claimed_status_to_businesses_fixed.sql
-- ============================================================
/*
  # Add Claimed Status to Business Locations

  1. Changes to Tables
    - `business_locations`
      - Add `is_claimed` (boolean, default false) - indica se l'azienda è stata rivendicata
      - Add `claimed_at` (timestamptz) - quando è stata rivendicata
      - Add `claimed_by` (uuid) - chi ha rivendicato (riferimento a profiles)
      - Add `verification_badge` (text) - tipo di badge: 'claimed', 'verified', 'premium'

  2. Search Priority
    - Le aziende rivendicate (is_claimed=true) appaiono prima nei risultati
    - Ordine: verified > claimed > unclaimed

  3. Automatic Updates
    - Marca automaticamente come "claimed" le business_locations che hanno un business_id valido
    - Aggiorna claimed_by con l'owner del business

  4. Indexes
    - Aggiungi indice su is_claimed per query veloci
    - Aggiungi indice composito per ordinamento prioritario
*/

-- Add new columns to business_locations
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN is_claimed boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN claimed_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'claimed_by'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN claimed_by uuid REFERENCES profiles(id) ON DELETE SET NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'verification_badge'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN verification_badge text CHECK (verification_badge IN ('claimed', 'verified', 'premium'));
  END IF;
END $$;

-- Mark existing business_locations with business_id as claimed
UPDATE business_locations bl
SET 
  is_claimed = true,
  claimed_at = bl.created_at,
  claimed_by = b.owner_id,
  verification_badge = 'claimed'
FROM businesses b
WHERE bl.business_id = b.id
  AND bl.is_claimed = false;

-- Create function to automatically mark as claimed when business_id is set
CREATE OR REPLACE FUNCTION mark_business_location_as_claimed()
RETURNS TRIGGER AS $$
BEGIN
  -- Se viene impostato un business_id e non è ancora claimed
  IF NEW.business_id IS NOT NULL AND (OLD.business_id IS NULL OR NOT OLD.is_claimed) THEN
    NEW.is_claimed := true;
    NEW.claimed_at := COALESCE(NEW.claimed_at, now());
    NEW.verification_badge := COALESCE(NEW.verification_badge, 'claimed');
    
    -- Imposta claimed_by dall'owner del business
    SELECT owner_id INTO NEW.claimed_by
    FROM businesses
    WHERE id = NEW.business_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS trigger_mark_business_location_claimed ON business_locations;
CREATE TRIGGER trigger_mark_business_location_claimed
  BEFORE INSERT OR UPDATE ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION mark_business_location_as_claimed();

-- Create indexes for fast queries
CREATE INDEX IF NOT EXISTS idx_business_locations_is_claimed ON business_locations(is_claimed);
CREATE INDEX IF NOT EXISTS idx_business_locations_verification_badge ON business_locations(verification_badge);
CREATE INDEX IF NOT EXISTS idx_business_locations_claimed_priority 
  ON business_locations(is_claimed DESC, verification_badge DESC, name);
CREATE INDEX IF NOT EXISTS idx_business_locations_claimed_by ON business_locations(claimed_by);

-- Function to search businesses with claimed priority
CREATE OR REPLACE FUNCTION search_businesses_with_priority(
  search_term text DEFAULT NULL,
  p_category_id uuid DEFAULT NULL,
  p_region text DEFAULT NULL,
  p_province text DEFAULT NULL,
  p_city text DEFAULT NULL,
  p_limit integer DEFAULT 50,
  p_offset integer DEFAULT 0
)
RETURNS TABLE (
  id uuid,
  business_id uuid,
  name text,
  category_id uuid,
  address text,
  city text,
  province text,
  region text,
  latitude numeric,
  longitude numeric,
  phone text,
  email text,
  website text,
  business_hours jsonb,
  avatar_url text,
  is_claimed boolean,
  claimed_at timestamptz,
  verification_badge text,
  rating numeric,
  review_count bigint
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    bl.id,
    bl.business_id,
    bl.name,
    bl.category_id,
    bl.address,
    bl.city,
    bl.province,
    bl.region,
    bl.latitude,
    bl.longitude,
    bl.phone,
    bl.email,
    bl.website,
    bl.business_hours,
    bl.avatar_url,
    bl.is_claimed,
    bl.claimed_at,
    bl.verification_badge,
    COALESCE(
      (SELECT AVG(r.overall_rating)::numeric(3,2)
       FROM reviews r
       WHERE r.business_location_id = bl.id AND r.approved = true),
      0
    ) as rating,
    COALESCE(
      (SELECT COUNT(*)
       FROM reviews r
       WHERE r.business_location_id = bl.id AND r.approved = true),
      0
    ) as review_count
  FROM business_locations bl
  WHERE 
    (search_term IS NULL OR bl.name ILIKE '%' || search_term || '%')
    AND (p_category_id IS NULL OR bl.category_id = p_category_id)
    AND (p_region IS NULL OR bl.region = p_region)
    AND (p_province IS NULL OR bl.province = p_province)
    AND (p_city IS NULL OR bl.city = p_city)
  ORDER BY
    -- Prima le aziende rivendicate
    bl.is_claimed DESC,
    -- Poi per badge (premium > verified > claimed > null)
    CASE 
      WHEN bl.verification_badge = 'premium' THEN 3
      WHEN bl.verification_badge = 'verified' THEN 2
      WHEN bl.verification_badge = 'claimed' THEN 1
      ELSE 0
    END DESC,
    -- Poi per rating
    (SELECT COALESCE(AVG(r.overall_rating), 0)
     FROM reviews r
     WHERE r.business_location_id = bl.id AND r.approved = true) DESC,
    -- Infine alfabetico
    bl.name ASC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$ LANGUAGE plpgsql STABLE;

-- Add same structure to unclaimed_business_locations for consistency
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'unclaimed_business_locations' AND column_name = 'is_claimed'
  ) THEN
    ALTER TABLE unclaimed_business_locations ADD COLUMN is_claimed boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'unclaimed_business_locations' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE unclaimed_business_locations ADD COLUMN claimed_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'unclaimed_business_locations' AND column_name = 'claimed_by'
  ) THEN
    ALTER TABLE unclaimed_business_locations ADD COLUMN claimed_by uuid REFERENCES profiles(id) ON DELETE SET NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'unclaimed_business_locations' AND column_name = 'verification_badge'
  ) THEN
    ALTER TABLE unclaimed_business_locations ADD COLUMN verification_badge text CHECK (verification_badge IN ('claimed', 'verified', 'premium'));
  END IF;
END $$;

-- Create indexes on unclaimed_business_locations
CREATE INDEX IF NOT EXISTS idx_unclaimed_locations_is_claimed ON unclaimed_business_locations(is_claimed);
CREATE INDEX IF NOT EXISTS idx_unclaimed_locations_verification_badge ON unclaimed_business_locations(verification_badge);

-- Add RLS policies for claimed_by field
CREATE POLICY "Users can see who claimed businesses"
  ON business_locations
  FOR SELECT
  TO authenticated
  USING (true);

-- Comment on new columns
COMMENT ON COLUMN business_locations.is_claimed IS 'Indica se questa azienda è stata rivendicata da un utente';
COMMENT ON COLUMN business_locations.claimed_at IS 'Data e ora in cui l''azienda è stata rivendicata';
COMMENT ON COLUMN business_locations.claimed_by IS 'ID del profilo che ha rivendicato l''azienda';
COMMENT ON COLUMN business_locations.verification_badge IS 'Tipo di badge di verifica: claimed (rivendicata), verified (verificata), premium (premium)';


-- ============================================================
-- FILE: 20260114100608_add_claimed_fields_to_businesses_table.sql
-- ============================================================
/*
  # Add Claimed Fields to Businesses Table

  1. Changes to Tables
    - `businesses`
      - Add `claimed_at` (timestamptz) - quando è stata rivendicata
      - Add `verification_badge` (text) - tipo di badge: 'claimed', 'verified', 'premium'
      - Update existing is_claimed to true for all businesses (sono tutte rivendicate)

  2. Updates
    - Segna tutte le businesses esistenti come claimed
    - Imposta claimed_at con created_at
    - Imposta verification_badge based on verified status
*/

-- Add new columns to businesses
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'claimed_at'
  ) THEN
    ALTER TABLE businesses ADD COLUMN claimed_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'verification_badge'
  ) THEN
    ALTER TABLE businesses ADD COLUMN verification_badge text CHECK (verification_badge IN ('claimed', 'verified', 'premium'));
  END IF;
END $$;

-- Update existing businesses to be marked as claimed
UPDATE businesses
SET 
  is_claimed = true,
  claimed_at = COALESCE(claimed_at, created_at),
  verification_badge = CASE 
    WHEN verified = true THEN 'verified'
    ELSE 'claimed'
  END
WHERE is_claimed IS NULL OR is_claimed = false OR verification_badge IS NULL;

-- Create trigger to set claimed_at automatically
CREATE OR REPLACE FUNCTION set_business_claimed_at()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_claimed = true AND NEW.claimed_at IS NULL THEN
    NEW.claimed_at := now();
  END IF;
  
  IF NEW.is_claimed = true AND NEW.verification_badge IS NULL THEN
    NEW.verification_badge := CASE 
      WHEN NEW.verified = true THEN 'verified'
      ELSE 'claimed'
    END;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_business_claimed_at ON businesses;
CREATE TRIGGER trigger_set_business_claimed_at
  BEFORE INSERT OR UPDATE ON businesses
  FOR EACH ROW
  EXECUTE FUNCTION set_business_claimed_at();

-- Create index on verification_badge
CREATE INDEX IF NOT EXISTS idx_businesses_verification_badge ON businesses(verification_badge);
CREATE INDEX IF NOT EXISTS idx_businesses_claimed_priority 
  ON businesses(is_claimed DESC, verification_badge DESC, name);


-- ============================================================
-- FILE: 20260114102410_add_location_to_discounts_and_jobs.sql
-- ============================================================
/*
  # Add Location Association to Discounts and Job Postings

  1. Changes
    - Add `business_location_id` to `discounts` table
      - Optional foreign key to `business_locations`
      - If null, discount applies to all locations
      - If set, discount applies only to that specific location
    
    - Add `business_location_id` to `job_postings` table
      - Optional foreign key to `business_locations`
      - If null, job posting is for the main business
      - If set, job posting is for that specific location

  2. Indexes
    - Add indexes on `business_location_id` for better query performance

  3. Notes
    - NULL values mean the discount/job applies to all locations or the main business
    - This allows businesses to manage location-specific discounts and job postings
*/

-- Add business_location_id to discounts
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discounts' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE discounts ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_discounts_location_id ON discounts(business_location_id);
  END IF;
END $$;

-- Add business_location_id to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_job_postings_location_id ON job_postings(business_location_id);
  END IF;
END $$;

-- ============================================================
-- FILE: 20260114105223_add_description_to_business_locations.sql
-- ============================================================
/*
  # Add description field to business_locations
  
  1. Changes
    - Add `description` text field to `business_locations` table
    - This field will store a brief description of the specific location
    - Useful for distinguishing between multiple locations of the same business
  
  2. Notes
    - Field is nullable to support existing locations
    - Can be used to provide location-specific details
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'description'
  ) THEN
    ALTER TABLE business_locations 
    ADD COLUMN description text;
  END IF;
END $$;


-- ============================================================
-- FILE: 20260114154339_add_internal_name_to_business_locations.sql
-- ============================================================
/*
  # Add internal name field to business locations

  1. Changes
    - Add `internal_name` column to `business_locations` table
      - This is a private label/nickname that only the business owner sees
      - Used to easily identify locations in their dashboard (e.g., "Sede 1", "Sede 2", "Filiale Milano")
      - The `name` field remains the official business name shown to users in search results
    
  2. Notes
    - This field is optional and defaults to NULL
    - If not set, the system can fall back to showing "Sede 1", "Sede 2", etc.
*/

-- Add internal_name column for private location identification
ALTER TABLE business_locations 
ADD COLUMN IF NOT EXISTS internal_name TEXT;

COMMENT ON COLUMN business_locations.internal_name IS 'Private label/nickname for the location, visible only to the business owner for easy identification in their dashboard';


-- ============================================================
-- FILE: 20260114161153_fix_job_posting_activity_log_title.sql
-- ============================================================
/*
  # Fix Job Posting Activity Log - Add Missing Title Field

  1. Problema
    - Il trigger per i job postings non inserisce il campo `title` nella tabella activity_log
    - Questo causa un errore di constraint violation quando si crea un annuncio di lavoro
    
  2. Soluzione
    - Aggiorna il trigger per includere tutti i campi obbligatori: title, icon, color, metadata
    - Usa valori appropriati per ogni campo
    
  3. Dettagli
    - title: "Annuncio di lavoro pubblicato"
    - description: Include il titolo dell'annuncio
    - icon: 'briefcase'
    - color: 'text-blue-600'
    - metadata: Include job_posting_id e business_id
*/

-- Ricrea la funzione corretta per assegnare punti quando viene creato un annuncio di lavoro
CREATE OR REPLACE FUNCTION award_points_for_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'owner_id dell'azienda
  SELECT owner_id INTO v_owner_id
  FROM businesses
  WHERE id = NEW.business_id;

  -- Se l'owner esiste, assegna i punti
  IF v_owner_id IS NOT NULL THEN
    -- Inserisci o aggiorna l'attività dell'utente
    INSERT INTO user_activity (user_id, total_points, last_activity_at, updated_at)
    VALUES (v_owner_id, 30, now(), now())
    ON CONFLICT (user_id) DO UPDATE SET
      total_points = user_activity.total_points + 30,
      last_activity_at = now(),
      updated_at = now();

    -- Registra l'attività nel log con TUTTI i campi obbligatori
    INSERT INTO activity_log (
      user_id, 
      activity_type, 
      title, 
      description, 
      points_earned, 
      metadata,
      icon,
      color,
      created_at
    )
    VALUES (
      v_owner_id,
      'job_posting_created',
      'Annuncio di lavoro pubblicato',
      'Annuncio di lavoro pubblicato: ' || NEW.title,
      30,
      jsonb_build_object('job_posting_id', NEW.id, 'business_id', NEW.business_id),
      'briefcase',
      'text-blue-600',
      now()
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260126102027_add_family_member_to_classified_ads.sql
-- ============================================================
/*
  # Add Family Member Support to Classified Ads

  1. Changes
    - Add `family_member_id` column to `classified_ads` table
    - Add foreign key constraint to `customer_family_members`
    - Update RLS policies to support family member privacy
    - Add index for better query performance

  2. Security
    - Users can only view/edit their own ads or ads created by their family members
    - Family members can only view/edit their own ads (not other family members' ads)
*/

-- Add family_member_id column to classified_ads
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_classified_ads_family_member
ON classified_ads(family_member_id);

-- Drop existing RLS policies for classified_ads
DROP POLICY IF EXISTS "Users can view active classified ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can create classified ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can update own classified ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can delete own classified ads" ON classified_ads;

-- Create new RLS policies with family member support
CREATE POLICY "Users can view active classified ads"
  ON classified_ads
  FOR SELECT
  TO authenticated
  USING (status = 'active');

CREATE POLICY "Users can create classified ads"
  ON classified_ads
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
  );

CREATE POLICY "Users can update own classified ads"
  ON classified_ads
  FOR UPDATE
  TO authenticated
  USING (
    auth.uid() = user_id
  )
  WITH CHECK (
    auth.uid() = user_id
  );

CREATE POLICY "Users can delete own classified ads"
  ON classified_ads
  FOR DELETE
  TO authenticated
  USING (
    auth.uid() = user_id
  );

-- ============================================================
-- FILE: 20260127220459_add_services_to_business_locations.sql
-- ============================================================
/*
  # Add services field to business_locations

  1. Changes
    - Add `services` text array field to `business_locations` table
    - This field will store a list of services available at each location
    - Examples: "WiFi gratuito", "Parcheggio", "Consegna a domicilio", etc.

  2. Notes
    - Field is nullable to support existing locations
    - Services are stored as an array of text strings for flexibility
    - Each location can have its own unique set of services
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'services'
  ) THEN
    ALTER TABLE business_locations 
    ADD COLUMN services text[] DEFAULT '{}';
  END IF;
END $$;


-- ============================================================
-- FILE: 20260204104207_add_auto_update_subscription_status_trigger.sql
-- ============================================================
/*
  # Add Automatic Subscription Status Update Trigger

  1. Changes
    - Create function to automatically update profile subscription_status when subscription is created or updated
    - Add trigger to subscriptions table to call this function

  2. Security
    - Function runs with SECURITY DEFINER to allow updating profiles table
    - Only updates the specific user's profile based on customer_id
*/

-- Function to update profile subscription status based on subscription
CREATE OR REPLACE FUNCTION update_profile_subscription_status()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update the profile subscription_status based on the subscription status
  UPDATE profiles
  SET subscription_status = NEW.status
  WHERE id = NEW.customer_id;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;

-- Create trigger that fires after insert or update on subscriptions
CREATE TRIGGER trigger_update_profile_subscription_status
  AFTER INSERT OR UPDATE OF status ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_profile_subscription_status();

-- ============================================================
-- FILE: 20260204110120_update_auto_subscription_sync_trigger.sql
-- ============================================================
/*
  # Update Automatic Subscription Status Sync Trigger

  1. Changes
    - Enhance function to sync subscription_status, subscription_type, and subscription_expires_at from subscriptions to profiles
    - Update trigger to fire on any relevant field change

  2. Security
    - Function runs with SECURITY DEFINER to allow updating profiles table
    - Only updates the specific user's profile based on customer_id
*/

-- Function to update profile subscription fields based on subscription
CREATE OR REPLACE FUNCTION update_profile_subscription_status()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  subscription_type_value text;
  plan_billing_period text;
BEGIN
  -- Get the billing period from the subscription plan
  SELECT billing_period INTO plan_billing_period
  FROM subscription_plans
  WHERE id = NEW.plan_id;
  
  -- Map billing_period to subscription_type
  subscription_type_value := CASE 
    WHEN plan_billing_period = 'monthly' THEN 'monthly'
    WHEN plan_billing_period = 'yearly' THEN 'annual'
    ELSE 'monthly'
  END;
  
  -- Update the profile with subscription info
  UPDATE profiles
  SET 
    subscription_status = NEW.status,
    subscription_type = subscription_type_value,
    subscription_expires_at = NEW.end_date
  WHERE id = NEW.customer_id;
  
  RETURN NEW;
END;
$$;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;

-- Create trigger that fires after insert or update on subscriptions
CREATE TRIGGER trigger_update_profile_subscription_status
  AFTER INSERT OR UPDATE OF status, plan_id, end_date ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_profile_subscription_status();

-- ============================================================
-- FILE: 20260204110202_add_trial_to_profiles_subscription_status.sql
-- ============================================================
/*
  # Add 'trial' to profiles subscription_status constraint

  1. Changes
    - Update check constraint on profiles.subscription_status to include 'trial'
    - This allows profiles to have subscription_status = 'trial'

  2. Security
    - No RLS changes needed
*/

-- Drop existing check constraint
ALTER TABLE profiles 
DROP CONSTRAINT IF EXISTS profiles_subscription_status_check;

-- Add updated check constraint including 'trial'
ALTER TABLE profiles 
ADD CONSTRAINT profiles_subscription_status_check 
CHECK (subscription_status IN ('trial', 'active', 'expired', 'cancelled'));

