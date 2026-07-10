/*
  # Ristrutturazione completa delle tabelle attività - V3

  Rimuove constraint province per permettere migrazione di dati incompleti
*/

-- Drop materialized view e policy che potrebbero causare problemi
DROP MATERIALIZED VIEW IF EXISTS business_ratings CASCADE;
DROP POLICY IF EXISTS "Customers can create reviews for unclaimed businesses" ON reviews;
DROP POLICY IF EXISTS "Public can view approved reviews for unclaimed businesses" ON reviews;
DROP POLICY IF EXISTS "Anyone can view approved reviews" ON reviews CASCADE;

-- Crea tabelle senza constraint troppo restrittivi
CREATE TABLE IF NOT EXISTS imported_businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category_id uuid REFERENCES business_categories(id),
  description text DEFAULT '',
  street text,
  street_number text,
  city text NOT NULL,
  province text,
  region text,
  postal_code text,
  country text DEFAULT 'Italia',
  phone text,
  email text,
  website text,
  business_hours jsonb,
  latitude numeric,
  longitude numeric,
  source text DEFAULT 'osm' CHECK (source IN ('osm', 'geofabrik')),
  source_id text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_imported_businesses_city ON imported_businesses(city);
CREATE INDEX IF NOT EXISTS idx_imported_businesses_province ON imported_businesses(province) WHERE province IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_imported_businesses_region ON imported_businesses(region);
CREATE INDEX IF NOT EXISTS idx_imported_businesses_category ON imported_businesses(category_id);
CREATE INDEX IF NOT EXISTS idx_imported_businesses_location ON imported_businesses(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_imported_businesses_source_id ON imported_businesses(source, source_id);
CREATE INDEX IF NOT EXISTS idx_imported_businesses_name ON imported_businesses USING gin(to_tsvector('italian', name));

CREATE TABLE IF NOT EXISTS user_added_businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category_id uuid REFERENCES business_categories(id),
  description text DEFAULT '',
  street text,
  street_number text,
  city text NOT NULL,
  province text,
  region text,
  postal_code text,
  country text DEFAULT 'Italia',
  phone text,
  email text,
  website text,
  latitude numeric,
  longitude numeric,
  added_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  verification_status text DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_user_added_businesses_city ON user_added_businesses(city);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_province ON user_added_businesses(province) WHERE province IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_region ON user_added_businesses(region);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_category ON user_added_businesses(category_id);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_added_by ON user_added_businesses(added_by);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_status ON user_added_businesses(verification_status);
CREATE INDEX IF NOT EXISTS idx_user_added_businesses_name ON user_added_businesses USING gin(to_tsvector('italian', name));

CREATE TABLE IF NOT EXISTS registered_businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  category_id uuid REFERENCES business_categories(id),
  name text NOT NULL,
  description text DEFAULT '',
  vat_number text UNIQUE,
  unique_code text,
  pec_email text,
  ateco_code text,
  website text,
  billing_street text,
  billing_street_number text,
  billing_postal_code text,
  billing_city text,
  billing_province text,
  logo_url text,
  verified boolean DEFAULT false,
  verification_badge text CHECK (verification_badge IN ('claimed', 'verified', 'premium')),
  source_type text DEFAULT 'direct_registration' CHECK (source_type IN ('direct_registration', 'claimed_imported', 'claimed_user_added')),
  source_id uuid,
  registered_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_registered_businesses_owner ON registered_businesses(owner_id);
CREATE INDEX IF NOT EXISTS idx_registered_businesses_category ON registered_businesses(category_id);
CREATE INDEX IF NOT EXISTS idx_registered_businesses_vat ON registered_businesses(vat_number) WHERE vat_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_registered_businesses_source ON registered_businesses(source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_registered_businesses_name ON registered_businesses USING gin(to_tsvector('italian', name));

CREATE TABLE IF NOT EXISTS registered_business_locations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES registered_businesses(id) ON DELETE CASCADE,
  name text DEFAULT 'Sede',
  internal_name text,
  description text,
  street text,
  street_number text,
  city text,
  province text,
  region text,
  postal_code text,
  country text DEFAULT 'Italia',
  phone text,
  email text,
  website text,
  business_hours jsonb,
  latitude numeric,
  longitude numeric,
  avatar_url text,
  services text[] DEFAULT '{}',
  is_primary boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_registered_locations_business ON registered_business_locations(business_id);
CREATE INDEX IF NOT EXISTS idx_registered_locations_city ON registered_business_locations(city);
CREATE INDEX IF NOT EXISTS idx_registered_locations_province ON registered_business_locations(province);
CREATE INDEX IF NOT EXISTS idx_registered_locations_region ON registered_business_locations(region);
CREATE INDEX IF NOT EXISTS idx_registered_locations_location ON registered_business_locations(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_registered_locations_primary ON registered_business_locations(business_id, is_primary);

-- Aggiorna tabella reviews
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'business_type') THEN
    ALTER TABLE reviews ADD COLUMN business_type text CHECK (business_type IN ('imported', 'user_added', 'registered'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'imported_business_id') THEN
    ALTER TABLE reviews ADD COLUMN imported_business_id uuid REFERENCES imported_businesses(id) ON DELETE CASCADE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reviews' AND column_name = 'user_added_business_id') THEN
    ALTER TABLE reviews ADD COLUMN user_added_business_id uuid REFERENCES user_added_businesses(id) ON DELETE CASCADE;
  END IF;
END $$;

ALTER TABLE reviews DROP COLUMN IF EXISTS unclaimed_business_id CASCADE;

CREATE INDEX IF NOT EXISTS idx_reviews_business_type ON reviews(business_type);
CREATE INDEX IF NOT EXISTS idx_reviews_imported_business ON reviews(imported_business_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_added_business ON reviews(user_added_business_id);

-- Migra dati
INSERT INTO imported_businesses (
  id, name, category_id, description, street, city, province, region,
  postal_code, country, phone, email, website, business_hours,
  latitude, longitude, source, created_at, updated_at
)
SELECT 
  id, name, category_id, COALESCE(description, ''), street, city,
  province, region, postal_code, COALESCE(country, 'Italia'),
  phone, email, website,
  CASE WHEN business_hours IS NOT NULL AND business_hours != ''
    THEN jsonb_build_object('hours', business_hours) ELSE NULL END,
  latitude, longitude, 'osm', created_at, updated_at
FROM unclaimed_business_locations
WHERE NOT is_claimed
ON CONFLICT (id) DO NOTHING;

-- RLS
ALTER TABLE imported_businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_added_businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE registered_businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE registered_business_locations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view imported businesses" ON imported_businesses FOR SELECT USING (true);
CREATE POLICY "Only admins can manage imported businesses" ON imported_businesses FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));

CREATE POLICY "Anyone can view verified user added businesses" ON user_added_businesses FOR SELECT
  USING (verification_status = 'verified' OR added_by = auth.uid());
CREATE POLICY "Authenticated users can add businesses" ON user_added_businesses FOR INSERT TO authenticated
  WITH CHECK (added_by = auth.uid());
CREATE POLICY "Users can update own businesses" ON user_added_businesses FOR UPDATE TO authenticated
  USING (added_by = auth.uid() OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true))
  WITH CHECK (added_by = auth.uid() OR EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true));
CREATE POLICY "Users can delete own pending businesses" ON user_added_businesses FOR DELETE TO authenticated
  USING (added_by = auth.uid() AND verification_status = 'pending');

CREATE POLICY "Anyone can view registered businesses" ON registered_businesses FOR SELECT USING (true);
CREATE POLICY "Business owners can manage their businesses" ON registered_businesses FOR ALL TO authenticated
  USING (owner_id = auth.uid()) WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Anyone can view registered locations" ON registered_business_locations FOR SELECT USING (true);
CREATE POLICY "Business owners can manage their locations" ON registered_business_locations FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM registered_businesses WHERE id = business_id AND owner_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM registered_businesses WHERE id = business_id AND owner_id = auth.uid()));

-- RLS Reviews
DROP POLICY IF EXISTS "Customers can create reviews for businesses" ON reviews;
CREATE POLICY "Customers can create reviews for all types" ON reviews FOR INSERT TO authenticated
  WITH CHECK (customer_id = auth.uid() AND (
    (business_type = 'imported' AND imported_business_id IS NOT NULL) OR
    (business_type = 'user_added' AND user_added_business_id IS NOT NULL) OR
    (business_type = 'registered' AND business_id IS NOT NULL)
  ));
CREATE POLICY "Anyone can view approved reviews" ON reviews FOR SELECT
  USING (review_status = 'approved' OR customer_id = auth.uid());

-- Funzioni
CREATE OR REPLACE FUNCTION search_all_businesses(
  search_query text DEFAULT '', search_city text DEFAULT NULL,
  search_province text DEFAULT NULL, search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL, limit_count int DEFAULT 50
)
RETURNS TABLE (
  id uuid, name text, category_id uuid, description text,
  city text, province text, region text, phone text, email text,
  website text, latitude numeric, longitude numeric,
  business_type text, has_multiple_locations boolean, created_at timestamptz
) AS $$
BEGIN
  RETURN QUERY
  SELECT rb.id, rb.name, rb.category_id, rb.description, rbl.city, rbl.province, rbl.region,
    rbl.phone, rbl.email, COALESCE(rbl.website, rb.website), rbl.latitude, rbl.longitude,
    'registered'::text, (SELECT COUNT(*) > 1 FROM registered_business_locations WHERE business_id = rb.id), rb.created_at
  FROM registered_businesses rb
  LEFT JOIN registered_business_locations rbl ON rb.id = rbl.business_id AND rbl.is_primary = true
  WHERE (search_query = '' OR rb.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR rbl.city ILIKE search_city)
    AND (search_province IS NULL OR rbl.province = search_province)
    AND (search_region IS NULL OR rbl.region ILIKE search_region)
    AND (search_category_id IS NULL OR rb.category_id = search_category_id)
  UNION ALL
  SELECT ib.id, ib.name, ib.category_id, ib.description, ib.city, ib.province, ib.region,
    ib.phone, ib.email, ib.website, ib.latitude, ib.longitude, 'imported'::text, false, ib.created_at
  FROM imported_businesses ib
  WHERE (search_query = '' OR ib.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR ib.city ILIKE search_city)
    AND (search_province IS NULL OR ib.province = search_province)
    AND (search_region IS NULL OR ib.region ILIKE search_region)
    AND (search_category_id IS NULL OR ib.category_id = search_category_id)
  UNION ALL
  SELECT uab.id, uab.name, uab.category_id, uab.description, uab.city, uab.province, uab.region,
    uab.phone, uab.email, uab.website, uab.latitude, uab.longitude, 'user_added'::text, false, uab.created_at
  FROM user_added_businesses uab
  WHERE uab.verification_status = 'verified'
    AND (search_query = '' OR uab.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR uab.city ILIKE search_city)
    AND (search_province IS NULL OR uab.province = search_province)
    AND (search_region IS NULL OR uab.region ILIKE search_region)
    AND (search_category_id IS NULL OR uab.category_id = search_category_id)
  ORDER BY name LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_business_details(p_business_id uuid, p_business_type text)
RETURNS jsonb AS $$
DECLARE result jsonb;
BEGIN
  IF p_business_type = 'registered' THEN
    SELECT jsonb_build_object('id', rb.id, 'type', 'registered', 'name', rb.name, 'description', rb.description,
      'category_id', rb.category_id, 'logo_url', rb.logo_url, 'website', rb.website, 'verified', rb.verified,
      'verification_badge', rb.verification_badge, 'owner_id', rb.owner_id,
      'locations', (SELECT jsonb_agg(jsonb_build_object('id', rbl.id, 'name', rbl.name, 'street', rbl.street,
        'street_number', rbl.street_number, 'city', rbl.city, 'province', rbl.province, 'region', rbl.region,
        'postal_code', rbl.postal_code, 'phone', rbl.phone, 'email', rbl.email, 'website', rbl.website,
        'business_hours', rbl.business_hours, 'latitude', rbl.latitude, 'longitude', rbl.longitude,
        'is_primary', rbl.is_primary, 'services', rbl.services))
      FROM registered_business_locations rbl WHERE rbl.business_id = rb.id))
    INTO result FROM registered_businesses rb WHERE rb.id = p_business_id;
  ELSIF p_business_type = 'imported' THEN
    SELECT jsonb_build_object('id', ib.id, 'type', 'imported', 'name', ib.name, 'description', ib.description,
      'category_id', ib.category_id, 'street', ib.street, 'street_number', ib.street_number, 'city', ib.city,
      'province', ib.province, 'region', ib.region, 'postal_code', ib.postal_code, 'phone', ib.phone,
      'email', ib.email, 'website', ib.website, 'business_hours', ib.business_hours, 'latitude', ib.latitude,
      'longitude', ib.longitude, 'source', ib.source)
    INTO result FROM imported_businesses ib WHERE ib.id = p_business_id;
  ELSIF p_business_type = 'user_added' THEN
    SELECT jsonb_build_object('id', uab.id, 'type', 'user_added', 'name', uab.name, 'description', uab.description,
      'category_id', uab.category_id, 'street', uab.street, 'street_number', uab.street_number, 'city', uab.city,
      'province', uab.province, 'region', uab.region, 'postal_code', uab.postal_code, 'phone', uab.phone,
      'email', uab.email, 'website', uab.website, 'latitude', uab.latitude, 'longitude', uab.longitude,
      'added_by', uab.added_by, 'verification_status', uab.verification_status)
    INTO result FROM user_added_businesses uab WHERE uab.id = p_business_id;
  END IF;
  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Triggers
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_imported_businesses_updated_at ON imported_businesses;
CREATE TRIGGER update_imported_businesses_updated_at BEFORE UPDATE ON imported_businesses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_user_added_businesses_updated_at ON user_added_businesses;
CREATE TRIGGER update_user_added_businesses_updated_at BEFORE UPDATE ON user_added_businesses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_registered_businesses_updated_at ON registered_businesses;
CREATE TRIGGER update_registered_businesses_updated_at BEFORE UPDATE ON registered_businesses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_registered_business_locations_updated_at ON registered_business_locations;
CREATE TRIGGER update_registered_business_locations_updated_at BEFORE UPDATE ON registered_business_locations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
