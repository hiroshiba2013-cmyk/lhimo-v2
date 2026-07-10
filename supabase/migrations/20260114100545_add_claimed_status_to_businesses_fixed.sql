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
