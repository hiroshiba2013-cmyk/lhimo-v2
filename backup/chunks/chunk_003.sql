-- ============================================================
-- FILE: 20251209215951_add_additional_italian_job_categories.sql
-- ============================================================
/*
  # Aggiungi Categorie di Lavoro Italiane Aggiuntive

  Questo migration aggiunge tutte le principali categorie di lavoro riconosciute in Italia
  basate sulla classificazione ATECO (Attività Economiche).

  ## Nuove Categorie Aggiunte:
  1. Professioni Tecniche
     - Architetti (71.11.00)
     - Ingegneri (71.12.10)
     - Geometri (71.12.20)
     - Notai (69.10.20)
  
  2. Servizi Finanziari e Assicurativi
     - Assicurazioni (65.12.00)
     - Banche (64.19.10)
  
  3. Educazione e Formazione
     - Scuole Private (85.31.10)
     - Centri per l'Infanzia (88.91.00)
     - Corsi di Formazione (85.59.20)
  
  4. Servizi alla Persona
     - Lavanderie (96.01.10)
     - Sartorie (14.13.10)
     - Calzolai (95.23.00)
  
  5. Automotive e Trasporti
     - Carrozzerie (45.20.20)
     - Concessionarie Auto (45.11.01)
     - Ricambi Auto (45.32.10)
     - Taxi e NCC (49.32.10)
     - Autoscuole (85.53.00)
  
  6. Artigianato e Costruzioni
     - Falegnami (16.23.00)
     - Serramentisti (43.32.02)
     - Tappezzieri (31.09.10)
     - Piastrellisti (43.33.00)
     - Pavimenti (43.33.00)
  
  7. Installazioni Tecniche
     - Climatizzazione (43.22.02)
     - Allarmi e Sicurezza (80.20.00)
     - Antennisti (43.21.02)
  
  8. Servizi Immobiliari e Manutenzione
     - Pulizie (81.21.00)
     - Giardinaggio (81.30.00)
     - Traslochi (49.42.00)
     - Amministratori di Condominio (68.32.00)
  
  9. Alimentari e Bevande
     - Alimentari (47.11.30)
     - Pescherie (47.23.00)
     - Frutta e Verdura (47.21.00)
     - Enoteche (47.25.00)
     - Rosticcerie (56.10.20)
  
  10. Commercio Specializzato
     - Ferramenta (47.52.10)
     - Materiali Edili (46.73.00)
     - Sanitari e Piastrelle (47.52.30)
     - Tabaccherie (47.26.00)
     - Edicole (47.62.10)
     - Cartolerie (47.62.20)
     - Gioiellerie (47.77.00)
     - Orologerie (47.77.10)
     - Ottica (47.78.10)
     - Profumerie (47.75.10)
     - Articoli Sportivi (47.64.10)
     - Giocattoli (47.65.00)
     - Arredamento (47.59.10)
     - Antiquariato (47.79.10)
  
  11. Servizi Sanitari
     - Laboratori Analisi (86.90.21)
     - Ambulatori (86.90.11)
     - Farmacie Ospedaliere (86.90.30)
     - Psicologi (86.90.30)
  
  12. Servizi Professionali
     - Traduttori e Interpreti (74.30.00)
     - Organizzazione Eventi (82.30.00)
     - Servizi di Vigilanza (80.10.00)
     - Disinfestazione (81.29.10)
  
  13. Comunicazione e Media
     - Tipografie (18.12.00)
     - Stampa Digitale (18.13.00)
     - Emittenti Radio (60.10.00)
     - Case di Produzione (59.11.00)
  
  14. Tempo Libero e Intrattenimento
     - Cinema (59.14.00)
     - Teatri (90.01.01)
     - Sale Giochi (93.29.10)
     - Discoteche (93.29.20)
  
  15. Trasporti e Logistica
     - Corrieri (53.20.00)
     - Magazzinaggio (52.10.10)
     - Spedizioni (52.29.10)
  
  ## Note Importanti:
  - Tutte le categorie includono codici ATECO ufficiali
  - Le categorie sono ordinate alfabeticamente
  - Ogni categoria include una descrizione chiara
*/

-- Professioni Tecniche
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Architetti', 'architetti', 'Attività degli studi di architettura', '71.11.00'),
  ('Ingegneri', 'ingegneri', 'Attività degli studi di ingegneria', '71.12.10'),
  ('Geometri', 'geometri', 'Attività dei geometri', '71.12.20'),
  ('Notai', 'notai', 'Attività degli studi notarili', '69.10.20')
ON CONFLICT (slug) DO NOTHING;

-- Servizi Finanziari e Assicurativi
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Assicurazioni', 'assicurazioni', 'Assicurazioni diverse da quelle sulla vita', '65.12.00'),
  ('Banche', 'banche', 'Altre intermediazioni monetarie', '64.19.10')
ON CONFLICT (slug) DO NOTHING;

-- Educazione e Formazione
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Scuole Private', 'scuole-private', 'Istruzione secondaria di secondo grado', '85.31.10'),
  ('Centri per l''Infanzia', 'centri-infanzia', 'Asili nido e servizi di assistenza diurna per bambini', '88.91.00'),
  ('Corsi di Formazione', 'corsi-formazione', 'Altra formazione culturale', '85.59.20'),
  ('Autoscuole', 'autoscuole', 'Scuole di guida professionale', '85.53.00')
ON CONFLICT (slug) DO NOTHING;

-- Servizi alla Persona
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Lavanderie', 'lavanderie', 'Attività delle lavanderie industriali', '96.01.10'),
  ('Sartorie', 'sartorie', 'Confezione di abbigliamento su misura', '14.13.10'),
  ('Calzolai', 'calzolai', 'Riparazione di calzature e articoli da viaggio', '95.23.00')
ON CONFLICT (slug) DO NOTHING;

-- Automotive e Trasporti
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Carrozzerie', 'carrozzerie', 'Riparazione carrozzerie di autoveicoli', '45.20.20'),
  ('Concessionarie Auto', 'concessionarie-auto', 'Commercio di autovetture e autoveicoli leggeri', '45.11.01'),
  ('Ricambi Auto', 'ricambi-auto', 'Commercio di parti e accessori di autoveicoli', '45.32.10'),
  ('Taxi e NCC', 'taxi-ncc', 'Trasporto con taxi e noleggio con conducente', '49.32.10')
ON CONFLICT (slug) DO NOTHING;

-- Artigianato e Costruzioni
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Falegnami', 'falegnami', 'Fabbricazione di prodotti in legno', '16.23.00'),
  ('Serramentisti', 'serramentisti', 'Installazione di infissi e serramenti', '43.32.02'),
  ('Tappezzieri', 'tappezzieri', 'Fabbricazione di altri mobili', '31.09.10'),
  ('Piastrellisti', 'piastrellisti', 'Rivestimenti e pavimentazioni', '43.33.00'),
  ('Pavimenti', 'pavimenti', 'Posa di pavimenti e rivestimenti', '43.33.00')
ON CONFLICT (slug) DO NOTHING;

-- Installazioni Tecniche
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Climatizzazione', 'climatizzazione', 'Installazione di impianti di climatizzazione', '43.22.02'),
  ('Allarmi e Sicurezza', 'allarmi-sicurezza', 'Attività di vigilanza privata', '80.20.00'),
  ('Antennisti', 'antennisti', 'Installazione di impianti elettronici', '43.21.02')
ON CONFLICT (slug) DO NOTHING;

-- Servizi Immobiliari e Manutenzione
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Pulizie', 'pulizie', 'Pulizia generale di edifici', '81.21.00'),
  ('Giardinaggio', 'giardinaggio', 'Cura e manutenzione del paesaggio', '81.30.00'),
  ('Traslochi', 'traslochi', 'Servizi di trasloco', '49.42.00'),
  ('Amministratori di Condominio', 'amministratori-condominio', 'Amministrazione di condomini', '68.32.00')
ON CONFLICT (slug) DO NOTHING;

-- Alimentari e Bevande
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Alimentari', 'alimentari', 'Minimarket ed altri esercizi non specializzati', '47.11.30'),
  ('Pescherie', 'pescherie', 'Commercio al dettaglio di pesci e prodotti ittici', '47.23.00'),
  ('Frutta e Verdura', 'frutta-verdura', 'Commercio al dettaglio di frutta e verdura', '47.21.00'),
  ('Enoteche', 'enoteche', 'Commercio al dettaglio di bevande', '47.25.00'),
  ('Rosticcerie', 'rosticcerie', 'Rosticcerie con somministrazione', '56.10.20')
ON CONFLICT (slug) DO NOTHING;

-- Commercio Specializzato
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Ferramenta', 'ferramenta', 'Commercio al dettaglio di ferramenta', '47.52.10'),
  ('Materiali Edili', 'materiali-edili', 'Commercio all''ingrosso di materiali da costruzione', '46.73.00'),
  ('Sanitari e Piastrelle', 'sanitari-piastrelle', 'Commercio al dettaglio di materiali da costruzione', '47.52.30'),
  ('Tabaccherie', 'tabaccherie', 'Commercio al dettaglio di prodotti del tabacco', '47.26.00'),
  ('Edicole', 'edicole', 'Commercio al dettaglio di giornali e riviste', '47.62.10'),
  ('Cartolerie', 'cartolerie', 'Commercio al dettaglio di articoli di cartoleria', '47.62.20'),
  ('Gioiellerie', 'gioiellerie', 'Commercio al dettaglio di articoli di gioielleria', '47.77.00'),
  ('Orologerie', 'orologerie', 'Commercio al dettaglio di orologi', '47.77.10'),
  ('Ottica', 'ottica', 'Commercio al dettaglio di articoli di ottica', '47.78.10'),
  ('Profumerie', 'profumerie', 'Commercio al dettaglio di articoli di profumeria', '47.75.10'),
  ('Articoli Sportivi', 'articoli-sportivi', 'Commercio al dettaglio di articoli sportivi', '47.64.10'),
  ('Giocattoli', 'giocattoli', 'Commercio al dettaglio di giochi e giocattoli', '47.65.00'),
  ('Arredamento', 'arredamento', 'Commercio al dettaglio di mobili', '47.59.10'),
  ('Antiquariato', 'antiquariato', 'Commercio al dettaglio di oggetti d''arte', '47.79.10')
ON CONFLICT (slug) DO NOTHING;

-- Servizi Sanitari
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Laboratori Analisi', 'laboratori-analisi', 'Laboratori di analisi cliniche', '86.90.21'),
  ('Ambulatori', 'ambulatori', 'Ambulatori e poliambulatori', '86.90.11'),
  ('Psicologi', 'psicologi', 'Attività degli psicologi', '86.90.30')
ON CONFLICT (slug) DO NOTHING;

-- Servizi Professionali
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Traduttori e Interpreti', 'traduttori-interpreti', 'Attività di traduzione e interpretariato', '74.30.00'),
  ('Organizzazione Eventi', 'organizzazione-eventi', 'Organizzazione di convegni e fiere', '82.30.00'),
  ('Servizi di Vigilanza', 'servizi-vigilanza', 'Servizi di vigilanza privata', '80.10.00'),
  ('Disinfestazione', 'disinfestazione', 'Disinfestazione, disinfestazione e derattizzazione', '81.29.10')
ON CONFLICT (slug) DO NOTHING;

-- Comunicazione e Media
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Tipografie', 'tipografie', 'Stampa di giornali e libri', '18.12.00'),
  ('Stampa Digitale', 'stampa-digitale', 'Stampa di altri prodotti', '18.13.00'),
  ('Emittenti Radio', 'emittenti-radio', 'Trasmissioni radiofoniche', '60.10.00'),
  ('Case di Produzione', 'case-produzione', 'Attività di produzione cinematografica', '59.11.00')
ON CONFLICT (slug) DO NOTHING;

-- Tempo Libero e Intrattenimento
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Cinema', 'cinema', 'Attività di proiezione cinematografica', '59.14.00'),
  ('Teatri', 'teatri', 'Rappresentazioni artistiche', '90.01.01'),
  ('Sale Giochi', 'sale-giochi', 'Sale giochi e biliardi', '93.29.10'),
  ('Discoteche', 'discoteche', 'Discoteche e sale da ballo', '93.29.20')
ON CONFLICT (slug) DO NOTHING;

-- Trasporti e Logistica
INSERT INTO business_categories (name, slug, description, ateco_code)
VALUES 
  ('Corrieri', 'corrieri', 'Servizi postali con obbligo di servizio universale', '53.20.00'),
  ('Magazzinaggio', 'magazzinaggio', 'Magazzini di custodia e deposito', '52.10.10'),
  ('Spedizioni', 'spedizioni', 'Spedizionieri e agenzie di operazioni doganali', '52.29.10')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- FILE: 20251210092908_add_avatar_to_family_members.sql
-- ============================================================
/*
  # Aggiungi campo avatar ai membri della famiglia

  ## Modifiche
  
  1. Aggiungi campo `avatar_url` alla tabella `customer_family_members`
    - `avatar_url` (text, nullable) - URL dell'avatar del membro della famiglia
  
  ## Note
  
  - Il campo è nullable perché i membri esistenti potrebbero non avere un avatar
  - Gli avatar saranno caricati nel bucket Supabase Storage
*/

-- Aggiungi campo avatar_url se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'avatar_url'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN avatar_url text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251210103425_add_resume_to_family_members.sql
-- ============================================================
/*
  # Aggiungi campo curriculum ai membri della famiglia

  ## Modifiche
  
  1. Aggiungi campo `resume_url` alla tabella `customer_family_members`
    - `resume_url` (text, nullable) - URL del curriculum del membro della famiglia
  
  ## Note
  
  - Il campo è nullable perché i membri esistenti potrebbero non avere un curriculum
  - I curriculum saranno caricati nel bucket Supabase Storage
*/

-- Aggiungi campo resume_url se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'resume_url'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN resume_url text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251210110538_add_missing_foreign_key_indexes.sql
-- ============================================================
/*
  # Aggiungi indici per chiavi esterne

  ## Modifiche
  
  Questo migration aggiunge gli indici mancanti per tutte le chiavi esterne per migliorare
  le prestazioni delle query.
  
  1. Indici per la tabella `businesses`
    - `idx_businesses_category_id` - per chiave esterna category_id
    - `idx_businesses_owner_id` - per chiave esterna owner_id
  
  2. Indici per la tabella `discounts`
    - `idx_discounts_business_id` - per chiave esterna business_id
  
  3. Indici per la tabella `job_requests`
    - `idx_job_requests_customer_id` - per chiave esterna customer_id
  
  4. Indici per la tabella `review_responses`
    - `idx_review_responses_business_id` - per chiave esterna business_id
    - `idx_review_responses_review_id` - per chiave esterna review_id
  
  5. Indici per la tabella `reviews`
    - `idx_reviews_business_id` - per chiave esterna business_id
    - `idx_reviews_customer_id` - per chiave esterna customer_id
  
  6. Indici per la tabella `subscriptions`
    - `idx_subscriptions_customer_id` - per chiave esterna customer_id
    - `idx_subscriptions_plan_id` - per chiave esterna plan_id
  
  ## Note
  
  Gli indici sulle chiavi esterne migliorano significativamente le prestazioni delle query
  che fanno JOIN o filtrano su queste colonne.
*/

-- Indici per businesses
CREATE INDEX IF NOT EXISTS idx_businesses_category_id ON businesses(category_id);
CREATE INDEX IF NOT EXISTS idx_businesses_owner_id ON businesses(owner_id);

-- Indici per discounts
CREATE INDEX IF NOT EXISTS idx_discounts_business_id ON discounts(business_id);

-- Indici per job_requests
CREATE INDEX IF NOT EXISTS idx_job_requests_customer_id ON job_requests(customer_id);

-- Indici per review_responses
CREATE INDEX IF NOT EXISTS idx_review_responses_business_id ON review_responses(business_id);
CREATE INDEX IF NOT EXISTS idx_review_responses_review_id ON review_responses(review_id);

-- Indici per reviews
CREATE INDEX IF NOT EXISTS idx_reviews_business_id ON reviews(business_id);
CREATE INDEX IF NOT EXISTS idx_reviews_customer_id ON reviews(customer_id);

-- Indici per subscriptions
CREATE INDEX IF NOT EXISTS idx_subscriptions_customer_id ON subscriptions(customer_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_plan_id ON subscriptions(plan_id);

-- ============================================================
-- FILE: 20251210110651_optimize_rls_policies_performance_fixed.sql
-- ============================================================
/*
  # Ottimizza le policy RLS per le prestazioni

  ## Modifiche
  
  Questo migration ottimizza tutte le policy RLS sostituendo `auth.uid()` con `(select auth.uid())`
  per evitare la rievalutazione della funzione per ogni riga, migliorando le prestazioni su scala.
  
  ## Tabelle modificate
  
  1. profiles
  2. businesses
  3. discounts
  4. reviews
  5. review_responses
  6. job_postings
  7. job_applications
  8. job_requests
  9. customer_family_members
  10. business_locations
  11. subscriptions
  
  ## Note
  
  Questo pattern è raccomandato da Supabase per ottimizzare le prestazioni RLS.
  Vedi: https://supabase.com/docs/guides/database/postgres/row-level-security#call-functions-with-select
*/

-- =====================================================
-- PROFILES TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (id = (select auth.uid()))
  WITH CHECK (id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (id = (select auth.uid()));

-- =====================================================
-- BUSINESSES TABLE
-- =====================================================

DROP POLICY IF EXISTS "Anyone can view verified businesses" ON businesses;
CREATE POLICY "Anyone can view verified businesses"
  ON businesses FOR SELECT
  TO authenticated
  USING (verified = true OR owner_id = (select auth.uid()));

DROP POLICY IF EXISTS "Business owners can insert own business" ON businesses;
CREATE POLICY "Business owners can insert own business"
  ON businesses FOR INSERT
  TO authenticated
  WITH CHECK (owner_id = (select auth.uid()));

DROP POLICY IF EXISTS "Business owners can update own business" ON businesses;
CREATE POLICY "Business owners can update own business"
  ON businesses FOR UPDATE
  TO authenticated
  USING (owner_id = (select auth.uid()))
  WITH CHECK (owner_id = (select auth.uid()));

DROP POLICY IF EXISTS "Business owners can delete own business" ON businesses;
CREATE POLICY "Business owners can delete own business"
  ON businesses FOR DELETE
  TO authenticated
  USING (owner_id = (select auth.uid()));

-- =====================================================
-- DISCOUNTS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Business owners can create discounts" ON discounts;
CREATE POLICY "Business owners can create discounts"
  ON discounts FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = discounts.business_id
      AND businesses.owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can update own discounts" ON discounts;
CREATE POLICY "Business owners can update own discounts"
  ON discounts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = discounts.business_id
      AND businesses.owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can delete own discounts" ON discounts;
CREATE POLICY "Business owners can delete own discounts"
  ON discounts FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = discounts.business_id
      AND businesses.owner_id = (select auth.uid())
    )
  );

-- =====================================================
-- REVIEWS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Customers can create reviews" ON reviews;
CREATE POLICY "Customers can create reviews"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Customers can update own reviews" ON reviews;
CREATE POLICY "Customers can update own reviews"
  ON reviews FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()))
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Customers can delete own reviews" ON reviews;
CREATE POLICY "Customers can delete own reviews"
  ON reviews FOR DELETE
  TO authenticated
  USING (customer_id = (select auth.uid()));

-- =====================================================
-- REVIEW_RESPONSES TABLE
-- =====================================================

DROP POLICY IF EXISTS "Business owners can respond to reviews" ON review_responses;
CREATE POLICY "Business owners can respond to reviews"
  ON review_responses FOR INSERT
  TO authenticated
  WITH CHECK (business_id IN (
    SELECT id FROM businesses WHERE owner_id = (select auth.uid())
  ));

-- =====================================================
-- JOB_POSTINGS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Businesses can view their own postings" ON job_postings;
CREATE POLICY "Businesses can view their own postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Businesses can create job postings" ON job_postings;
CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Businesses can update their own postings" ON job_postings;
CREATE POLICY "Businesses can update their own postings"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Businesses can delete their own postings" ON job_postings;
CREATE POLICY "Businesses can delete their own postings"
  ON job_postings FOR DELETE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

-- =====================================================
-- JOB_APPLICATIONS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view applications they submitted" ON job_applications;
CREATE POLICY "Users can view applications they submitted"
  ON job_applications FOR SELECT
  TO authenticated
  USING (user_id = (select auth.uid()));

DROP POLICY IF EXISTS "Businesses can view applications to their postings" ON job_applications;
CREATE POLICY "Businesses can view applications to their postings"
  ON job_applications FOR SELECT
  TO authenticated
  USING (
    job_posting_id IN (
      SELECT jp.id FROM job_postings jp
      INNER JOIN businesses b ON jp.business_id = b.id
      WHERE b.owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Authenticated users can apply to jobs" ON job_applications;
CREATE POLICY "Authenticated users can apply to jobs"
  ON job_applications FOR INSERT
  TO authenticated
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update their own applications" ON job_applications;
CREATE POLICY "Users can update their own applications"
  ON job_applications FOR UPDATE
  TO authenticated
  USING (user_id = (select auth.uid()));

-- =====================================================
-- JOB_REQUESTS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own job requests" ON job_requests;
CREATE POLICY "Users can view own job requests"
  ON job_requests FOR SELECT
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Customers can create job requests" ON job_requests;
CREATE POLICY "Customers can create job requests"
  ON job_requests FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own job requests" ON job_requests;
CREATE POLICY "Users can update own job requests"
  ON job_requests FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can delete own job requests" ON job_requests;
CREATE POLICY "Users can delete own job requests"
  ON job_requests FOR DELETE
  TO authenticated
  USING (customer_id = (select auth.uid()));

-- =====================================================
-- CUSTOMER_FAMILY_MEMBERS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own family members" ON customer_family_members;
CREATE POLICY "Users can view own family members"
  ON customer_family_members FOR SELECT
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can insert own family members" ON customer_family_members;
CREATE POLICY "Users can insert own family members"
  ON customer_family_members FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own family members" ON customer_family_members;
CREATE POLICY "Users can update own family members"
  ON customer_family_members FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()))
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can delete own family members" ON customer_family_members;
CREATE POLICY "Users can delete own family members"
  ON customer_family_members FOR DELETE
  TO authenticated
  USING (customer_id = (select auth.uid()));

-- =====================================================
-- BUSINESS_LOCATIONS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Business owners can view own locations" ON business_locations;
CREATE POLICY "Business owners can view own locations"
  ON business_locations FOR SELECT
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can insert own locations" ON business_locations;
CREATE POLICY "Business owners can insert own locations"
  ON business_locations FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can update own locations" ON business_locations;
CREATE POLICY "Business owners can update own locations"
  ON business_locations FOR UPDATE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can delete own locations" ON business_locations;
CREATE POLICY "Business owners can delete own locations"
  ON business_locations FOR DELETE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

-- =====================================================
-- SUBSCRIPTIONS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own subscriptions" ON subscriptions;
CREATE POLICY "Users can view own subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can create own subscriptions" ON subscriptions;
CREATE POLICY "Users can create own subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own subscriptions" ON subscriptions;
CREATE POLICY "Users can update own subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()))
  WITH CHECK (customer_id = (select auth.uid()));

-- ============================================================
-- FILE: 20251215095248_add_relationship_to_profiles.sql
-- ============================================================
/*
  # Add relationship field to profiles table

  1. Changes
    - Add `relationship` column to `profiles` table
    - The column is optional (nullable) and stores the relationship type
    - Default value is 'Titolare' for existing profiles

  2. Purpose
    - Allow the primary account holder (Person 1) to specify their relationship type
    - This aligns with family members who already have this field
*/

-- Add relationship column to profiles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'relationship'
  ) THEN
    ALTER TABLE profiles ADD COLUMN relationship text DEFAULT 'Titolare';
  END IF;
END $$;

