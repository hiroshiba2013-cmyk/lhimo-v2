/*
  # Sistema Recensioni Avanzato

  1. Modifiche alla Tabella Reviews
    - Aggiunta `review_type`: tipo di esperienza (service_used, booking_not_completed, quote_request, customer_service, problem_before_service)
    - Aggiunta rating dettagliati per chi ha usufruito del servizio:
      - `booking_management_rating`: gestione prenotazione (1-5)
      - `reliability_rating`: affidabilità (1-5)
      - `organization_rating`: organizzazione (1-5)
      - `experience_rating`: esperienza/servizio (1-5)
      - `price_rating`: prezzo (1-5)
    - `overall_rating` viene calcolato come media dei 5 rating per service_used
    - Per altri tipi, `overall_rating` rimane il campo principale
    - `proof_documents`: array di URL per documenti di prova (fatture, scontrini, prenotazioni, ecc.)

  2. Aggiornamento Funzione Calcolo Rating
    - Calcola due medie separate:
      - Media per chi ha usufruito del servizio (service_used)
      - Media per chi NON ha usufruito del servizio (altri tipi)

  3. Sicurezza
    - Mantiene le policy RLS esistenti
    - Aggiunge validazione per proof_documents storage
*/

-- Aggiungi nuove colonne alla tabella reviews
ALTER TABLE reviews
ADD COLUMN IF NOT EXISTS review_type text NOT NULL DEFAULT 'service_used',
ADD COLUMN IF NOT EXISTS booking_management_rating integer,
ADD COLUMN IF NOT EXISTS reliability_rating integer,
ADD COLUMN IF NOT EXISTS organization_rating integer,
ADD COLUMN IF NOT EXISTS experience_rating integer,
ADD COLUMN IF NOT EXISTS price_rating integer,
ADD COLUMN IF NOT EXISTS proof_documents text[];

-- Aggiungi constraint per review_type
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_review_type_check'
  ) THEN
    ALTER TABLE reviews
    ADD CONSTRAINT reviews_review_type_check
    CHECK (review_type IN ('service_used', 'booking_not_completed', 'quote_request', 'customer_service', 'problem_before_service'));
  END IF;
END $$;

-- Aggiungi constraint per i rating dettagliati (1-5)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_booking_management_rating_check'
  ) THEN
    ALTER TABLE reviews
    ADD CONSTRAINT reviews_booking_management_rating_check
    CHECK (booking_management_rating IS NULL OR (booking_management_rating >= 1 AND booking_management_rating <= 5));
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_reliability_rating_check'
  ) THEN
    ALTER TABLE reviews
    ADD CONSTRAINT reviews_reliability_rating_check
    CHECK (reliability_rating IS NULL OR (reliability_rating >= 1 AND reliability_rating <= 5));
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_organization_rating_check'
  ) THEN
    ALTER TABLE reviews
    ADD CONSTRAINT reviews_organization_rating_check
    CHECK (organization_rating IS NULL OR (organization_rating >= 1 AND organization_rating <= 5));
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_experience_rating_check'
  ) THEN
    ALTER TABLE reviews
    ADD CONSTRAINT reviews_experience_rating_check
    CHECK (experience_rating IS NULL OR (experience_rating >= 1 AND experience_rating <= 5));
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_price_rating_check'
  ) THEN
    ALTER TABLE reviews
    ADD CONSTRAINT reviews_price_rating_check
    CHECK (price_rating IS NULL OR (price_rating >= 1 AND price_rating <= 5));
  END IF;
END $$;

-- Aggiorna la funzione get_business_ratings per calcolare medie separate
CREATE OR REPLACE FUNCTION get_business_ratings(business_id_param uuid)
RETURNS TABLE (
  average_rating numeric,
  total_reviews bigint,
  service_used_rating numeric,
  service_used_count bigint,
  other_experience_rating numeric,
  other_experience_count bigint,
  quality_rating numeric,
  service_rating numeric,
  cleanliness_rating numeric,
  value_rating numeric,
  booking_management_rating numeric,
  reliability_rating numeric,
  organization_rating numeric,
  experience_rating numeric,
  price_rating numeric
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(AVG(r.overall_rating), 0)::numeric AS average_rating,
    COUNT(*)::bigint AS total_reviews,
    COALESCE(AVG(r.overall_rating) FILTER (WHERE r.review_type = 'service_used'), 0)::numeric AS service_used_rating,
    COUNT(*) FILTER (WHERE r.review_type = 'service_used')::bigint AS service_used_count,
    COALESCE(AVG(r.overall_rating) FILTER (WHERE r.review_type != 'service_used'), 0)::numeric AS other_experience_rating,
    COUNT(*) FILTER (WHERE r.review_type != 'service_used')::bigint AS other_experience_count,
    COALESCE(AVG(r.quality_rating), 0)::numeric AS quality_rating,
    COALESCE(AVG(r.service_rating), 0)::numeric AS service_rating,
    COALESCE(AVG(r.cleanliness_rating), 0)::numeric AS cleanliness_rating,
    COALESCE(AVG(r.value_rating), 0)::numeric AS value_rating,
    COALESCE(AVG(r.booking_management_rating), 0)::numeric AS booking_management_rating,
    COALESCE(AVG(r.reliability_rating), 0)::numeric AS reliability_rating,
    COALESCE(AVG(r.organization_rating), 0)::numeric AS organization_rating,
    COALESCE(AVG(r.experience_rating), 0)::numeric AS experience_rating,
    COALESCE(AVG(r.price_rating), 0)::numeric AS price_rating
  FROM reviews r
  WHERE r.business_id = business_id_param
    AND r.status = 'approved';
END;
$$;

-- Aggiorna la funzione per unclaimed businesses
CREATE OR REPLACE FUNCTION get_location_ratings(location_id_param uuid)
RETURNS TABLE (
  average_rating numeric,
  total_reviews bigint,
  service_used_rating numeric,
  service_used_count bigint,
  other_experience_rating numeric,
  other_experience_count bigint,
  quality_rating numeric,
  service_rating numeric,
  cleanliness_rating numeric,
  value_rating numeric,
  booking_management_rating numeric,
  reliability_rating numeric,
  organization_rating numeric,
  experience_rating numeric,
  price_rating numeric
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(AVG(r.overall_rating), 0)::numeric AS average_rating,
    COUNT(*)::bigint AS total_reviews,
    COALESCE(AVG(r.overall_rating) FILTER (WHERE r.review_type = 'service_used'), 0)::numeric AS service_used_rating,
    COUNT(*) FILTER (WHERE r.review_type = 'service_used')::bigint AS service_used_count,
    COALESCE(AVG(r.overall_rating) FILTER (WHERE r.review_type != 'service_used'), 0)::numeric AS other_experience_rating,
    COUNT(*) FILTER (WHERE r.review_type != 'service_used')::bigint AS other_experience_count,
    COALESCE(AVG(r.quality_rating), 0)::numeric AS quality_rating,
    COALESCE(AVG(r.service_rating), 0)::numeric AS service_rating,
    COALESCE(AVG(r.cleanliness_rating), 0)::numeric AS cleanliness_rating,
    COALESCE(AVG(r.value_rating), 0)::numeric AS value_rating,
    COALESCE(AVG(r.booking_management_rating), 0)::numeric AS booking_management_rating,
    COALESCE(AVG(r.reliability_rating), 0)::numeric AS reliability_rating,
    COALESCE(AVG(r.organization_rating), 0)::numeric AS organization_rating,
    COALESCE(AVG(r.experience_rating), 0)::numeric AS experience_rating,
    COALESCE(AVG(r.price_rating), 0)::numeric AS price_rating
  FROM reviews r
  WHERE r.unclaimed_business_location_id = location_id_param
    AND r.status = 'approved';
END;
$$;

-- Trigger per calcolare automatically overall_rating per service_used
CREATE OR REPLACE FUNCTION calculate_overall_rating_for_service_used()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.review_type = 'service_used' AND
     NEW.booking_management_rating IS NOT NULL AND
     NEW.reliability_rating IS NOT NULL AND
     NEW.organization_rating IS NOT NULL AND
     NEW.experience_rating IS NOT NULL AND
     NEW.price_rating IS NOT NULL THEN
    NEW.overall_rating := ROUND(
      (NEW.booking_management_rating +
       NEW.reliability_rating +
       NEW.organization_rating +
       NEW.experience_rating +
       NEW.price_rating) / 5.0
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crea trigger
DROP TRIGGER IF EXISTS calculate_overall_rating_trigger ON reviews;
CREATE TRIGGER calculate_overall_rating_trigger
  BEFORE INSERT OR UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION calculate_overall_rating_for_service_used();

-- Crea storage bucket per proof documents se non esiste
INSERT INTO storage.buckets (id, name, public)
VALUES ('review-proof-documents', 'review-proof-documents', false)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies se esistono
DROP POLICY IF EXISTS "Users can upload their own proof documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can view their own proof documents" ON storage.objects;
DROP POLICY IF EXISTS "Admins can view all proof documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own proof documents" ON storage.objects;

-- Policy per storage proof documents
CREATE POLICY "Users can upload their own proof documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'review-proof-documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can view their own proof documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'review-proof-documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Admins can view all proof documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'review-proof-documents' AND
  EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid())
);

CREATE POLICY "Users can delete their own proof documents"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'review-proof-documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);
