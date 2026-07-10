-- ============================================================
-- FILE: 20260405160148_create_auctions_system.sql
-- ============================================================
/*
  # Create Auctions System

  1. New Tables
    - `auctions`
      - Complete auction listing with all details
      - Tracks base price, duration, status
      - Includes deposit requirement (5€ for base ≤500€, 10€ for >500€)
      - Status: active, completed, cancelled, expired

    - `auction_bids`
      - All bids placed on auctions
      - Tracks bid amount and timestamp
      - Links to user/family member who placed bid

    - `auction_deposits`
      - Tracks deposit payments for auction participation
      - Amount based on base price (5€ or 10€)
      - Refunded after auction completion or expiration

    - `auction_completions`
      - Tracks completion confirmations from both parties
      - 48-hour window to confirm transaction
      - Both buyer and seller must confirm

  2. Security
    - Enable RLS on all tables
    - Users can create their own auctions
    - Users can view active auctions
    - Users can place bids after paying deposit
    - Admins have full access

  3. Storage
    - Create bucket for auction images
    - Allow authenticated users to upload
    - Public read access
*/

-- Create auctions table
CREATE TABLE IF NOT EXISTS auctions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text NOT NULL,
  base_price numeric NOT NULL CHECK (base_price > 0),
  current_price numeric NOT NULL DEFAULT 0,
  deposit_amount numeric NOT NULL,
  images text[] DEFAULT '{}',
  category text NOT NULL,
  condition text CHECK (condition IN ('new', 'like_new', 'good', 'fair', 'poor')),
  city text NOT NULL,
  province text NOT NULL,
  region text NOT NULL,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled', 'expired')),
  ends_at timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  winner_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  winner_family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  completed_at timestamptz,
  CONSTRAINT valid_end_date CHECK (ends_at > created_at)
);

-- Create auction_bids table
CREATE TABLE IF NOT EXISTS auction_bids (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id uuid NOT NULL REFERENCES auctions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  bid_amount numeric NOT NULL CHECK (bid_amount > 0),
  created_at timestamptz DEFAULT now(),
  CONSTRAINT unique_user_bid_per_auction UNIQUE(auction_id, user_id, created_at)
);

-- Create auction_deposits table
CREATE TABLE IF NOT EXISTS auction_deposits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id uuid NOT NULL REFERENCES auctions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  amount numeric NOT NULL CHECK (amount IN (5, 10)),
  paid_at timestamptz DEFAULT now(),
  refunded boolean DEFAULT false,
  refunded_at timestamptz,
  CONSTRAINT unique_deposit_per_user_auction UNIQUE(auction_id, user_id)
);

-- Create auction_completions table
CREATE TABLE IF NOT EXISTS auction_completions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id uuid NOT NULL REFERENCES auctions(id) ON DELETE CASCADE,
  seller_confirmed boolean DEFAULT false,
  seller_confirmed_at timestamptz,
  buyer_confirmed boolean DEFAULT false,
  buyer_confirmed_at timestamptz,
  completion_deadline timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  CONSTRAINT unique_completion_per_auction UNIQUE(auction_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_auctions_user_id ON auctions(user_id);
CREATE INDEX IF NOT EXISTS idx_auctions_status ON auctions(status);
CREATE INDEX IF NOT EXISTS idx_auctions_ends_at ON auctions(ends_at);
CREATE INDEX IF NOT EXISTS idx_auctions_category ON auctions(category);
CREATE INDEX IF NOT EXISTS idx_auctions_city ON auctions(city);
CREATE INDEX IF NOT EXISTS idx_auctions_province ON auctions(province);
CREATE INDEX IF NOT EXISTS idx_auctions_region ON auctions(region);
CREATE INDEX IF NOT EXISTS idx_auction_bids_auction_id ON auction_bids(auction_id);
CREATE INDEX IF NOT EXISTS idx_auction_bids_user_id ON auction_bids(user_id);
CREATE INDEX IF NOT EXISTS idx_auction_deposits_auction_id ON auction_deposits(auction_id);
CREATE INDEX IF NOT EXISTS idx_auction_deposits_user_id ON auction_deposits(user_id);
CREATE INDEX IF NOT EXISTS idx_auction_completions_auction_id ON auction_completions(auction_id);

-- Enable RLS
ALTER TABLE auctions ENABLE ROW LEVEL SECURITY;
ALTER TABLE auction_bids ENABLE ROW LEVEL SECURITY;
ALTER TABLE auction_deposits ENABLE ROW LEVEL SECURITY;
ALTER TABLE auction_completions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for auctions

-- Public can view active auctions
CREATE POLICY "Anyone can view active auctions"
  ON auctions FOR SELECT
  USING (status = 'active' OR auth.uid() = user_id OR auth.uid() IN (
    SELECT user_id FROM admins
  ));

-- Users can view their own auctions regardless of status
CREATE POLICY "Users can view own auctions"
  ON auctions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Authenticated users can create auctions
CREATE POLICY "Authenticated users can create auctions"
  ON auctions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own auctions
CREATE POLICY "Users can update own auctions"
  ON auctions FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own auctions if no bids yet
CREATE POLICY "Users can delete own auctions without bids"
  ON auctions FOR DELETE
  TO authenticated
  USING (
    auth.uid() = user_id AND
    NOT EXISTS (SELECT 1 FROM auction_bids WHERE auction_id = id)
  );

-- Admins can do everything
CREATE POLICY "Admins have full access to auctions"
  ON auctions FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- RLS Policies for auction_bids

-- Anyone can view bids on active auctions
CREATE POLICY "Anyone can view bids on active auctions"
  ON auction_bids FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.status = 'active' OR auctions.user_id = auth.uid())
    )
  );

-- Authenticated users can place bids if they paid deposit
CREATE POLICY "Users can place bids after paying deposit"
  ON auction_bids FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM auction_deposits
      WHERE auction_deposits.auction_id = auction_bids.auction_id
      AND auction_deposits.user_id = auth.uid()
      AND auction_deposits.refunded = false
    )
  );

-- Admins can do everything
CREATE POLICY "Admins have full access to bids"
  ON auction_bids FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- RLS Policies for auction_deposits

-- Users can view their own deposits
CREATE POLICY "Users can view own deposits"
  ON auction_deposits FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Auction owners can view deposits for their auctions
CREATE POLICY "Auction owners can view deposits"
  ON auction_deposits FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND auctions.user_id = auth.uid()
    )
  );

-- Users can create deposits
CREATE POLICY "Users can create deposits"
  ON auction_deposits FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Admins can do everything
CREATE POLICY "Admins have full access to deposits"
  ON auction_deposits FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- RLS Policies for auction_completions

-- Auction participants can view completions
CREATE POLICY "Auction participants can view completions"
  ON auction_completions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.user_id = auth.uid() OR auctions.winner_id = auth.uid())
    )
  );

-- System creates completion records (admins)
CREATE POLICY "Admins can create completions"
  ON auction_completions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- Sellers and buyers can update their confirmation
CREATE POLICY "Participants can confirm completion"
  ON auction_completions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.user_id = auth.uid() OR auctions.winner_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.user_id = auth.uid() OR auctions.winner_id = auth.uid())
    )
  );

-- Admins can do everything
CREATE POLICY "Admins have full access to completions"
  ON auction_completions FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- Create function to automatically set deposit amount based on base price
CREATE OR REPLACE FUNCTION set_auction_deposit_amount()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.base_price <= 500 THEN
    NEW.deposit_amount := 5;
  ELSE
    NEW.deposit_amount := 10;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to set deposit amount
DROP TRIGGER IF EXISTS trigger_set_auction_deposit_amount ON auctions;
CREATE TRIGGER trigger_set_auction_deposit_amount
  BEFORE INSERT OR UPDATE OF base_price ON auctions
  FOR EACH ROW
  EXECUTE FUNCTION set_auction_deposit_amount();

-- Create function to update current price when new bid is placed
CREATE OR REPLACE FUNCTION update_auction_current_price()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE auctions
  SET
    current_price = NEW.bid_amount,
    updated_at = now()
  WHERE id = NEW.auction_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to update current price
DROP TRIGGER IF EXISTS trigger_update_auction_current_price ON auction_bids;
CREATE TRIGGER trigger_update_auction_current_price
  AFTER INSERT ON auction_bids
  FOR EACH ROW
  EXECUTE FUNCTION update_auction_current_price();

-- Create function to automatically expire auctions
CREATE OR REPLACE FUNCTION expire_auctions()
RETURNS void AS $$
BEGIN
  -- Mark auctions as expired if end time has passed and no winner
  UPDATE auctions
  SET status = 'expired', updated_at = now()
  WHERE status = 'active'
  AND ends_at < now()
  AND winner_id IS NULL;

  -- Mark auctions as completed if they have a winner and end time has passed
  UPDATE auctions
  SET
    status = 'completed',
    winner_id = (
      SELECT user_id
      FROM auction_bids
      WHERE auction_id = auctions.id
      ORDER BY bid_amount DESC, created_at ASC
      LIMIT 1
    ),
    winner_family_member_id = (
      SELECT family_member_id
      FROM auction_bids
      WHERE auction_id = auctions.id
      ORDER BY bid_amount DESC, created_at ASC
      LIMIT 1
    ),
    completed_at = now(),
    updated_at = now()
  WHERE status = 'active'
  AND ends_at < now()
  AND current_price > 0;

  -- Create completion records for newly completed auctions
  INSERT INTO auction_completions (auction_id, completion_deadline)
  SELECT id, now() + interval '48 hours'
  FROM auctions
  WHERE status = 'completed'
  AND completed_at > now() - interval '1 minute'
  AND NOT EXISTS (
    SELECT 1 FROM auction_completions WHERE auction_id = auctions.id
  );

  -- Refund deposits for expired auctions
  UPDATE auction_deposits
  SET refunded = true, refunded_at = now()
  WHERE auction_id IN (
    SELECT id FROM auctions WHERE status = 'expired'
  )
  AND refunded = false;
END;
$$ LANGUAGE plpgsql;

-- Create storage bucket for auction images
INSERT INTO storage.buckets (id, name, public)
VALUES ('auction-images', 'auction-images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for auction images
CREATE POLICY "Authenticated users can upload auction images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'auction-images');

CREATE POLICY "Anyone can view auction images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'auction-images');

CREATE POLICY "Users can update own auction images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'auction-images' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own auction images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'auction-images' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Admins have full access to auction images"
  ON storage.objects FOR ALL
  TO authenticated
  USING (
    bucket_id = 'auction-images' AND
    auth.uid() IN (SELECT user_id FROM admins)
  );

-- ============================================================
-- FILE: 20260405160704_add_auction_rules_and_faqs.sql
-- ============================================================
/*
  # Add Auction Rules and FAQs

  1. New Data
    - Add auction rules section
    - Add auction FAQs

  2. Content
    - How auctions work
    - Deposit system
    - Completion confirmation
    - User responsibilities
*/

-- Add auction rules section
INSERT INTO rules_content (section_key, section_title, content_text, display_order, is_active)
VALUES
  ('auctions', 'Sistema Aste', E'## Come Funzionano le Aste\n\nLe aste su Trovafacile permettono a tutti gli utenti (privati e aziende) di vendere e acquistare oggetti attraverso un sistema di offerte competitive.\n\n### Creazione Asta\n- Ogni utente autenticato può creare un''asta\n- È necessario fornire: titolo, descrizione, immagini, base d''asta, categoria, condizioni e località\n- La durata dell''asta può essere da 1 a 14 giorni\n- Il sistema calcola automaticamente il deposito richiesto (5€ per basi d''asta fino a 500€, 10€ oltre)\n\n### Partecipazione\n- Per partecipare a un''asta è necessario pagare un deposito\n- Il deposito viene restituito automaticamente alla fine dell''asta\n- Le offerte devono essere superiori all''offerta attuale o alla base d''asta\n- L''offerta più alta viene evidenziata in grassetto\n\n### Conclusione Asta\n- L''asta termina automaticamente alla scadenza\n- Il vincitore è chi ha fatto l''offerta più alta\n- Venditore e acquirente hanno 48 ore per confermare la transazione\n- La transazione si considera conclusa quando entrambi confermano\n\n### Responsabilità\n- La piattaforma NON gestisce pagamenti o spedizioni\n- Le transazioni avvengono direttamente tra venditore e acquirente\n- La piattaforma non ha alcuna responsabilità sulla transazione\n- Si consiglia di utilizzare metodi di pagamento sicuri e tracciabili', 10, true);

-- Add auction FAQs
INSERT INTO faqs (category, question, answer, display_order, is_active)
VALUES
  ('Aste', 'Chi può partecipare alle aste?', 'Tutti gli utenti autenticati possono partecipare alle aste, sia utenti privati che aziende. È necessario pagare un deposito per poter fare offerte.', 1, true),
  ('Aste', 'Quanto costa il deposito per partecipare?', 'Il deposito è di 5€ per aste con base fino a 500€, e 10€ per aste con base superiore a 500€. Il deposito viene restituito automaticamente alla fine dell''asta.', 2, true),
  ('Aste', 'Quando viene restituito il deposito?', 'Il deposito viene restituito automaticamente alla scadenza dell''asta, sia che tu vinca sia che perda.', 3, true),
  ('Aste', 'Come faccio un''offerta?', 'Dopo aver pagato il deposito, puoi inserire l''importo della tua offerta. L''offerta deve essere superiore all''offerta attuale o alla base d''asta se non ci sono ancora offerte.', 4, true),
  ('Aste', 'Cosa succede se vinco l''asta?', 'Se vinci l''asta, hai 48 ore di tempo per completare la transazione con il venditore. Dovrai contattare il venditore per accordarvi su pagamento e consegna.', 5, true),
  ('Aste', 'La piattaforma gestisce i pagamenti?', 'No, la piattaforma NON gestisce pagamenti o spedizioni. Le transazioni avvengono direttamente tra venditore e acquirente. La piattaforma non ha alcuna responsabilità sulla transazione.', 6, true),
  ('Aste', 'Come confermare la conclusione della transazione?', 'Dopo la chiusura dell''asta, sia venditore che acquirente devono confermare che la transazione è stata completata (oggetto ricevuto e pagamento effettuato). Avete 48 ore per confermare.', 7, true),
  ('Aste', 'Posso annullare un''asta?', 'Puoi eliminare un''asta solo se non ci sono ancora offerte. Una volta che qualcuno ha fatto un''offerta, l''asta non può più essere annullata.', 8, true),
  ('Aste', 'Posso creare aste come azienda?', 'Sì, anche le aziende possono creare e partecipare alle aste. Il sistema è aperto a tutti gli utenti autenticati.', 9, true);

-- ============================================================
-- FILE: 20260408100149_update_review_system_advanced.sql
-- ============================================================
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


