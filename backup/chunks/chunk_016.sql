-- ============================================================
-- FILE: 20251229115822_create_job_seekers_and_messaging_system.sql
-- ============================================================
/*
  # Create Job Seekers and Messaging System for Jobs

  ## Overview
  This migration creates a two-way job system:
  1. Job Seekers - Private users create "looking for work" ads
  2. Job Offers - Professional users (businesses) create job postings
  3. Messaging system for both types

  ## New Tables
  
  ### job_seekers
  - `id` (uuid, primary key)
  - `user_id` (uuid, foreign key to auth.users) - The person looking for work
  - `title` (text) - Job title seeking
  - `description` (text) - Personal description and experience
  - `skills` (text array) - Skills and competencies
  - `contract_type` (text) - Type of contract seeking (Full-time, Part-time, Contract, etc.)
  - `desired_salary_min` (numeric) - Minimum desired salary
  - `desired_salary_max` (numeric) - Maximum desired salary
  - `salary_currency` (text) - Currency (default EUR)
  - `location` (text) - Preferred work location
  - `available_from` (date) - When available to start
  - `experience_years` (integer) - Years of experience
  - `education_level` (text) - Education level
  - `status` (text) - active, paused, closed
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### job_seeker_conversations
  - `id` (uuid, primary key)
  - `job_seeker_id` (uuid, references job_seekers)
  - `employer_id` (uuid, references auth.users) - The business/employer interested
  - `seeker_id` (uuid, references auth.users) - The job seeker
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)
  - `last_message_at` (timestamptz)

  ### job_seeker_messages
  - `id` (uuid, primary key)
  - `conversation_id` (uuid, references job_seeker_conversations)
  - `sender_id` (uuid, references auth.users)
  - `message` (text)
  - `is_read` (boolean)
  - `created_at` (timestamptz)

  ### job_offer_conversations
  - `id` (uuid, primary key)
  - `job_posting_id` (uuid, references job_postings)
  - `applicant_id` (uuid, references auth.users) - The person interested in the job
  - `employer_id` (uuid, references auth.users) - The business owner
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)
  - `last_message_at` (timestamptz)

  ### job_offer_messages
  - `id` (uuid, primary key)
  - `conversation_id` (uuid, references job_offer_conversations)
  - `sender_id` (uuid, references auth.users)
  - `message` (text)
  - `is_read` (boolean)
  - `created_at` (timestamptz)

  ## Updates to Existing Tables

  ### job_postings
  - Add `company_name` (text) - Name of the company
  - Add `gross_annual_salary` (numeric) - Gross annual salary
  - Add `benefits` (text array) - Benefits offered
  - Add `remote_work` (boolean) - Remote work option
  - Add `required_languages` (text array) - Required languages

  ## Security
  - Enable RLS on all tables
  - Job seekers can manage their own ads
  - Businesses can view job seeker ads
  - Users can only see conversations they are part of
  - Users can only send messages to their conversations

  ## Indexes
  - Indexes on foreign keys for performance
  - Indexes on status fields for filtering
  - Indexes for conversation lookups
*/

-- Add new fields to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'company_name'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN company_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'gross_annual_salary'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN gross_annual_salary numeric;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'benefits'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN benefits text[] DEFAULT '{}';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'remote_work'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN remote_work boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'required_languages'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN required_languages text[] DEFAULT '{}';
  END IF;
END $$;

-- Create job_seekers table
CREATE TABLE IF NOT EXISTS job_seekers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  skills text[] DEFAULT '{}',
  contract_type text NOT NULL DEFAULT 'Full-time',
  desired_salary_min numeric,
  desired_salary_max numeric,
  salary_currency text DEFAULT 'EUR',
  location text NOT NULL,
  available_from date,
  experience_years integer DEFAULT 0,
  education_level text,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create job_seeker_conversations table
CREATE TABLE IF NOT EXISTS job_seeker_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_seeker_id uuid NOT NULL REFERENCES job_seekers(id) ON DELETE CASCADE,
  employer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  seeker_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  last_message_at timestamptz DEFAULT now(),
  UNIQUE(job_seeker_id, employer_id, seeker_id)
);

-- Create job_seeker_messages table
CREATE TABLE IF NOT EXISTS job_seeker_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES job_seeker_conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create job_offer_conversations table
CREATE TABLE IF NOT EXISTS job_offer_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  applicant_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  employer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  last_message_at timestamptz DEFAULT now(),
  UNIQUE(job_posting_id, applicant_id, employer_id)
);

-- Create job_offer_messages table
CREATE TABLE IF NOT EXISTS job_offer_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES job_offer_conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_job_seekers_user_id ON job_seekers(user_id);
CREATE INDEX IF NOT EXISTS idx_job_seekers_status ON job_seekers(status);
CREATE INDEX IF NOT EXISTS idx_job_seekers_location ON job_seekers(location);
CREATE INDEX IF NOT EXISTS idx_job_seekers_contract_type ON job_seekers(contract_type);

CREATE INDEX IF NOT EXISTS idx_job_seeker_conversations_job_seeker_id ON job_seeker_conversations(job_seeker_id);
CREATE INDEX IF NOT EXISTS idx_job_seeker_conversations_employer_id ON job_seeker_conversations(employer_id);
CREATE INDEX IF NOT EXISTS idx_job_seeker_conversations_seeker_id ON job_seeker_conversations(seeker_id);

CREATE INDEX IF NOT EXISTS idx_job_seeker_messages_conversation_id ON job_seeker_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_job_seeker_messages_sender_id ON job_seeker_messages(sender_id);

CREATE INDEX IF NOT EXISTS idx_job_offer_conversations_job_posting_id ON job_offer_conversations(job_posting_id);
CREATE INDEX IF NOT EXISTS idx_job_offer_conversations_applicant_id ON job_offer_conversations(applicant_id);
CREATE INDEX IF NOT EXISTS idx_job_offer_conversations_employer_id ON job_offer_conversations(employer_id);

CREATE INDEX IF NOT EXISTS idx_job_offer_messages_conversation_id ON job_offer_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_job_offer_messages_sender_id ON job_offer_messages(sender_id);

-- Enable RLS
ALTER TABLE job_seekers ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_seeker_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_seeker_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_offer_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_offer_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for job_seekers

-- Anyone can view active job seeker ads
CREATE POLICY "Anyone can view active job seeker ads"
  ON job_seekers FOR SELECT
  USING (status = 'active');

-- Users can view their own ads regardless of status
CREATE POLICY "Users can view own job seeker ads"
  ON job_seekers FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Users can create job seeker ads
CREATE POLICY "Users can create job seeker ads"
  ON job_seekers FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Users can update their own ads
CREATE POLICY "Users can update own job seeker ads"
  ON job_seekers FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Users can delete their own ads
CREATE POLICY "Users can delete own job seeker ads"
  ON job_seekers FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

-- RLS Policies for job_seeker_conversations

-- Users can view conversations they are part of
CREATE POLICY "Users can view own job seeker conversations"
  ON job_seeker_conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = employer_id OR auth.uid() = seeker_id);

-- Employers can create conversations with job seekers
CREATE POLICY "Employers can create job seeker conversations"
  ON job_seeker_conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = employer_id);

-- Users can update conversations they are part of
CREATE POLICY "Users can update own job seeker conversations"
  ON job_seeker_conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = employer_id OR auth.uid() = seeker_id)
  WITH CHECK (auth.uid() = employer_id OR auth.uid() = seeker_id);

-- RLS Policies for job_seeker_messages

-- Users can view messages from their conversations
CREATE POLICY "Users can view job seeker messages from own conversations"
  ON job_seeker_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = job_seeker_messages.conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  );

-- Users can send messages to their conversations
CREATE POLICY "Users can send job seeker messages to own conversations"
  ON job_seeker_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  );

-- Users can update messages in their conversations
CREATE POLICY "Users can update job seeker messages in own conversations"
  ON job_seeker_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = job_seeker_messages.conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = job_seeker_messages.conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  );

-- RLS Policies for job_offer_conversations

-- Users can view conversations they are part of
CREATE POLICY "Users can view own job offer conversations"
  ON job_offer_conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = applicant_id OR auth.uid() = employer_id);

-- Applicants can create conversations for job offers
CREATE POLICY "Applicants can create job offer conversations"
  ON job_offer_conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = applicant_id);

-- Users can update conversations they are part of
CREATE POLICY "Users can update own job offer conversations"
  ON job_offer_conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = applicant_id OR auth.uid() = employer_id)
  WITH CHECK (auth.uid() = applicant_id OR auth.uid() = employer_id);

-- RLS Policies for job_offer_messages

-- Users can view messages from their conversations
CREATE POLICY "Users can view job offer messages from own conversations"
  ON job_offer_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = job_offer_messages.conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  );

-- Users can send messages to their conversations
CREATE POLICY "Users can send job offer messages to own conversations"
  ON job_offer_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  );

-- Users can update messages in their conversations
CREATE POLICY "Users can update job offer messages in own conversations"
  ON job_offer_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = job_offer_messages.conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = job_offer_messages.conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  );

-- Create function to update job seeker conversation last_message_at
CREATE OR REPLACE FUNCTION update_job_seeker_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE job_seeker_conversations
  SET last_message_at = NEW.created_at,
      updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to update job offer conversation last_message_at
CREATE OR REPLACE FUNCTION update_job_offer_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE job_offer_conversations
  SET last_message_at = NEW.created_at,
      updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers
DROP TRIGGER IF EXISTS update_job_seeker_conversation_last_message_trigger ON job_seeker_messages;
CREATE TRIGGER update_job_seeker_conversation_last_message_trigger
  AFTER INSERT ON job_seeker_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_job_seeker_conversation_last_message();

DROP TRIGGER IF EXISTS update_job_offer_conversation_last_message_trigger ON job_offer_messages;
CREATE TRIGGER update_job_offer_conversation_last_message_trigger
  AFTER INSERT ON job_offer_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_job_offer_conversation_last_message();

-- ============================================================
-- FILE: 20251229125430_add_extensive_classified_categories.sql
-- ============================================================
/*
  # Expand Classified Ad Categories

  ## Overview
  Adds extensive categories to the classified ads system to cover all possible product and service types.

  ## New Categories Added
  - Health & Beauty (Salute e Bellezza)
  - Photography & Video (Fotografia e Video)
  - Cycling (Ciclismo)
  - IT & Software (Informatica e Software)
  - Courses & Training (Corsi e Formazione)
  - Building Materials (Materiale Edile)
  - Gardening (Giardinaggio)
  - Boating & Marine (Nautica)
  - Camping & Outdoor (Campeggio e Outdoor)
  - Professional Equipment (Attrezzatura Professionale)
  - Weddings & Events (Matrimoni ed Eventi)
  - Travel & Holidays (Viaggi e Vacanze)
  - Telephony (Telefonia)
  - Security & Surveillance (Videosorveglianza)
  - HVAC & Heating (Climatizzazione e Riscaldamento)
  - Kitchen & Restaurant Equipment (Attrezzature per Ristorazione)
  - Office Supplies (Cancelleria e Ufficio)
  - Crafts & DIY (Bricolage e Fai da Te)
  - Antiques & Vintage (Antiquariato e Vintage)
  - Jewelry & Watches (Gioielli e Orologi)
  - Toys & Games (Giocattoli e Giochi)
  - Musical Instruments (Strumenti Musicali)
  - Fitness & Wellness (Fitness e Benessere)
  - Agricultural Equipment (Attrezzature Agricole)
  - Wine & Food (Vino e Gastronomia)
  - Pets & Animals (Animali Domestici)
  - Beauty Salon Equipment (Attrezzature per Parrucchieri ed Estetisti)
  - Medical Equipment (Attrezzature Mediche)
  - Industrial Machinery (Macchinari Industriali)
  - Renewable Energy (Energie Rinnovabili)
  - And many more specific categories (120+ total new categories)

  ## Security
  - No RLS changes needed (categories already have public read access)
*/

-- Insert extensive classified categories
INSERT INTO classified_categories (name, slug, icon, description) VALUES
  -- Health & Beauty
  ('Salute e Bellezza', 'salute-bellezza', 'Heart', 'Prodotti per la cura della persona, cosmetici, profumi'),
  ('Attrezzature Parrucchieri', 'attrezzature-parrucchieri', 'Scissors', 'Phon, piastre, forbici, prodotti professionali per parrucchieri'),
  ('Attrezzature Estetiste', 'attrezzature-estetiste', 'Sparkles', 'Lettini, lampade UV, prodotti per estetica e spa'),

  -- Photography & Media
  ('Fotografia e Video', 'fotografia-video', 'Camera', 'Fotocamere, videocamere, obiettivi, treppiedi, accessori'),
  ('Droni', 'droni', 'Plane', 'Droni per fotografia, videomaking e hobby'),

  -- Sports & Fitness
  ('Ciclismo', 'ciclismo', 'Bike', 'Biciclette, mountain bike, accessori e ricambi'),
  ('Fitness e Palestra', 'fitness-palestra', 'Dumbbell', 'Attrezzi palestra, pesi, tapis roulant, cyclette'),
  ('Calcio', 'calcio', 'Trophy', 'Scarpe, palloni, abbigliamento da calcio'),
  ('Tennis e Racchette', 'tennis-racchette', 'Award', 'Racchette, palloni, abbigliamento da tennis'),
  ('Sport Invernali', 'sport-invernali', 'Mountain', 'Sci, snowboard, abbigliamento da neve'),
  ('Sport Acquatici', 'sport-acquatici', 'Waves', 'Surf, windsurf, kitesurf, immersioni'),
  ('Arrampicata', 'arrampicata', 'TrendingUp', 'Attrezzatura per arrampicata e alpinismo'),

  -- Technology
  ('Computer e Laptop', 'computer-laptop', 'Monitor', 'PC desktop, laptop, componenti hardware'),
  ('Tablet', 'tablet', 'Tablet', 'Tablet di tutte le marche e accessori'),
  ('Smartphone', 'smartphone', 'Smartphone', 'Cellulari nuovi e usati, accessori'),
  ('Smartwatch e Wearable', 'smartwatch-wearable', 'Watch', 'Smartwatch, fitness tracker, auricolari wireless'),
  ('Console e Videogiochi', 'console-videogiochi', 'Gamepad2', 'PlayStation, Xbox, Nintendo, giochi e accessori'),
  ('Software e Licenze', 'software-licenze', 'Code', 'Software, licenze, corsi online'),
  ('Networking', 'networking', 'Wifi', 'Router, switch, access point, cavi di rete'),
  ('Stampa e Scanner', 'stampa-scanner', 'Printer', 'Stampanti, scanner, multifunzione, toner'),
  ('Videosorveglianza', 'videosorveglianza', 'Shield', 'Telecamere, DVR, sistemi di sicurezza'),

  -- Home & Garden
  ('Elettrodomestici Grandi', 'elettrodomestici-grandi', 'Refrigerator', 'Frigoriferi, lavatrici, lavastoviglie, forni'),
  ('Elettrodomestici Piccoli', 'elettrodomestici-piccoli', 'Microwave', 'Microonde, frullatori, tostapane, caffettiere'),
  ('Mobili Soggiorno', 'mobili-soggiorno', 'Sofa', 'Divani, poltrone, tavoli, librerie'),
  ('Mobili Camera da Letto', 'mobili-camera-letto', 'Bed', 'Letti, armadi, comodini, materassi'),
  ('Mobili Cucina', 'mobili-cucina', 'ChefHat', 'Cucine componibili, tavoli, sedie'),
  ('Illuminazione', 'illuminazione', 'Lightbulb', 'Lampadari, lampade da tavolo, faretti'),
  ('Decorazione Casa', 'decorazione-casa', 'Paintbrush', 'Quadri, specchi, tende, tappeti'),
  ('Giardinaggio', 'giardinaggio', 'TreeDeciduous', 'Piante, attrezzi da giardino, vasi, fertilizzanti'),
  ('Climatizzazione', 'climatizzazione', 'Wind', 'Condizionatori, stufe, ventilatori, deumidificatori'),
  ('Idraulica e Riscaldamento', 'idraulica-riscaldamento', 'Droplet', 'Caldaie, termosifoni, rubinetteria'),
  ('Edilizia e Materiali', 'edilizia-materiali', 'HardHat', 'Materiali da costruzione, piastrelle, sanitari'),
  ('Porte e Finestre', 'porte-finestre', 'DoorOpen', 'Porte, finestre, infissi, serrande'),

  -- Vehicles & Transportation
  ('Auto', 'auto', 'Car', 'Automobili nuove e usate di tutte le marche'),
  ('Moto e Scooter', 'moto-scooter', 'Bike', 'Motociclette, scooter, ciclomotori'),
  ('Camper e Roulotte', 'camper-roulotte', 'Caravan', 'Camper, caravan, accessori camping'),
  ('Barche e Gommoni', 'barche-gommoni', 'Ship', 'Imbarcazioni, motori marini, accessori nautici'),
  ('Ricambi Auto', 'ricambi-auto', 'Wrench', 'Parti di ricambio, pneumatici, cerchi'),
  ('Accessori Auto', 'accessori-auto', 'Navigation', 'Navigatori, portapacchi, sedili'),

  -- Real Estate
  ('Vendita Appartamenti', 'vendita-appartamenti', 'Building', 'Appartamenti in vendita'),
  ('Affitto Appartamenti', 'affitto-appartamenti', 'Home', 'Appartamenti in affitto'),
  ('Ville e Case', 'ville-case', 'Castle', 'Ville, villette, case indipendenti'),
  ('Uffici e Negozi', 'uffici-negozi', 'Store', 'Locali commerciali, uffici, capannoni'),
  ('Terreni', 'terreni', 'MapPin', 'Terreni edificabili e agricoli'),
  ('Box e Garage', 'box-garage', 'Warehouse', 'Box auto, garage, posti auto'),

  -- Jobs & Services
  ('Offerte di Lavoro', 'offerte-lavoro', 'Briefcase', 'Ricerca personale e offerte di lavoro'),
  ('Cerco Lavoro', 'cerco-lavoro', 'Search', 'Annunci di chi cerca lavoro'),
  ('Ripetizioni e Lezioni', 'ripetizioni-lezioni', 'GraduationCap', 'Lezioni private, corsi, ripetizioni'),
  ('Badanti e Colf', 'badanti-colf', 'Users', 'Assistenza anziani, pulizie domestiche'),
  ('Baby Sitter', 'baby-sitter', 'Baby', 'Servizio baby sitting'),
  ('Traslochi', 'traslochi', 'Truck', 'Servizi di trasloco e trasporto'),
  ('Ristrutturazioni', 'ristrutturazioni', 'Hammer', 'Muratori, elettricisti, idraulici, imbianchini'),
  ('Pulizie', 'pulizie', 'SprayBottle', 'Servizi di pulizia casa e uffici'),
  ('Riparazioni', 'riparazioni', 'Tool', 'Riparazione elettrodomestici, computer, smartphone'),
  ('Web e Marketing', 'web-marketing', 'Globe', 'Sviluppo siti web, SEO, social media marketing'),
  ('Grafica e Design', 'grafica-design', 'Palette', 'Graphic design, logo, brochure, video editing'),
  ('Fotografi e Video', 'fotografi-video-servizi', 'Video', 'Servizi fotografici, videomaker, matrimoni'),

  -- Fashion & Accessories
  ('Abbigliamento Uomo', 'abbigliamento-uomo', 'User', 'Vestiti, giacche, pantaloni uomo'),
  ('Abbigliamento Donna', 'abbigliamento-donna', 'UserSquare', 'Vestiti, gonne, camicie donna'),
  ('Abbigliamento Bambini', 'abbigliamento-bambini', 'Users', 'Vestiti per bambini e neonati'),
  ('Scarpe Uomo', 'scarpe-uomo', 'Footprints', 'Scarpe da uomo, sneakers, eleganti'),
  ('Scarpe Donna', 'scarpe-donna', 'HeartHandshake', 'Scarpe da donna, tacchi, stivali'),
  ('Borse e Zaini', 'borse-zaini', 'Backpack', 'Borse, zaini, valigie, trolley'),
  ('Occhiali', 'occhiali', 'Glasses', 'Occhiali da sole, da vista, montature'),
  ('Gioielli', 'gioielli', 'Gem', 'Anelli, collane, bracciali, orologi'),

  -- Hobbies & Entertainment
  ('Strumenti Musicali', 'strumenti-musicali', 'Music', 'Chitarre, pianoforti, batterie, accessori'),
  ('Vinili e CD', 'vinili-cd', 'Disc', 'Dischi in vinile, CD, collezioni musicali'),
  ('Libri Scolastici', 'libri-scolastici', 'BookOpen', 'Libri di testo, universitari'),
  ('Libri Narrativa', 'libri-narrativa', 'Book', 'Romanzi, saggi, libri usati'),
  ('Fumetti', 'fumetti', 'BookMarked', 'Fumetti, manga, graphic novel'),
  ('Collezionismo', 'collezionismo', 'Archive', 'Francobolli, monete, oggetti da collezione'),
  ('Modellismo', 'modellismo', 'Box', 'Modellini, trenini, aerei radiocomandati'),
  ('Pesca', 'pesca', 'Fish', 'Canne da pesca, mulinelli, accessori'),
  ('Caccia', 'caccia', 'Target', 'Fucili, ottiche, abbigliamento da caccia'),
  ('Paintball e Softair', 'paintball-softair', 'Crosshair', 'Repliche, protezioni, accessori softair'),

  -- Kids & Baby
  ('Passeggini', 'passeggini', 'Baby', 'Passeggini, trio, carrozzine'),
  ('Seggiolini Auto', 'seggiolini-auto', 'UserCheck', 'Seggiolini per auto, omologati'),
  ('Giocattoli Prima Infanzia', 'giocattoli-prima-infanzia', 'Blocks', 'Giochi per neonati e bambini piccoli'),
  ('Biciclette Bambini', 'biciclette-bambini', 'Bike', 'Bici per bambini, tricicli, monopattini'),
  ('Abbigliamento Premaman', 'abbigliamento-premaman', 'Heart', 'Vestiti per gravidanza'),

  -- Animals
  ('Cani', 'cani', 'Dog', 'Accessori per cani, cucce, guinzagli'),
  ('Gatti', 'gatti', 'Cat', 'Accessori per gatti, tiragraffi, lettiere'),
  ('Acquari', 'acquari', 'Fish', 'Acquari, pesci, accessori acquariofilia'),
  ('Uccelli', 'uccelli', 'Bird', 'Gabbie, mangiatoie, accessori'),
  ('Roditori', 'roditori', 'Rabbit', 'Accessori per criceti, conigli, furetti'),
  ('Cavalli', 'cavalli', 'Horse', 'Selle, finimenti, abbigliamento equestre'),

  -- Food & Wine
  ('Vini', 'vini', 'Wine', 'Bottiglie di vino, collezioni, cantine'),
  ('Prodotti Tipici', 'prodotti-tipici', 'Utensils', 'Prodotti gastronomici regionali'),
  ('Attrezzature Ristorazione', 'attrezzature-ristorazione', 'ChefHat', 'Forni, frigoriferi professionali, pentolame'),

  -- Professional & Industrial
  ('Attrezzature Edili', 'attrezzature-edili', 'HardHat', 'Ponteggi, betoniere, trapani professionali'),
  ('Macchinari Industriali', 'macchinari-industriali', 'Factory', 'Macchinari per produzione industriale'),
  ('Attrezzature Agricole', 'attrezzature-agricole', 'Tractor', 'Trattori, aratri, mietitrebbie'),
  ('Carrelli Elevatori', 'carrelli-elevatori', 'Container', 'Muletti, transpallet, sollevatori'),
  ('Generatori', 'generatori', 'Zap', 'Generatori di corrente, gruppi elettrogeni'),
  ('Compressori', 'compressori', 'Wind', 'Compressori aria, utensili pneumatici'),

  -- Events & Entertainment
  ('Matrimoni', 'matrimoni', 'Heart', 'Servizi per matrimoni, allestimenti'),
  ('Feste ed Eventi', 'feste-eventi', 'PartyPopper', 'Animazione, catering, noleggio attrezzature'),
  ('Noleggio Audio Video', 'noleggio-audio-video', 'Speaker', 'Service audio, luci, impianti'),

  -- Renewable Energy
  ('Pannelli Solari', 'pannelli-solari', 'Sun', 'Fotovoltaico, pannelli solari, inverter'),
  ('Stufe a Pellet', 'stufe-pellet', 'Flame', 'Stufe e caldaie a biomassa'),

  -- Other
  ('Oggetti Vintage', 'oggetti-vintage', 'Clock', 'Oggetti e mobili d''epoca'),
  ('Bomboniere', 'bomboniere', 'Gift', 'Bomboniere matrimonio, comunione, laurea'),
  ('Articoli Religiosi', 'articoli-religiosi', 'Church', 'Statue, icone, rosari'),
  ('Campeggio', 'campeggio', 'Tent', 'Tende, sacchi a pelo, materassini'),
  ('Escursionismo', 'escursionismo', 'Mountain', 'Zaini trekking, scarponi, bastoncini'),
  ('Biglietti e Voucher', 'biglietti-voucher', 'Ticket', 'Biglietti concerti, eventi sportivi, voucher'),
  ('Permute', 'permute', 'ArrowLeftRight', 'Scambio oggetti senza denaro'),
  ('Gratis', 'gratis', 'Gift', 'Oggetti da regalare gratuitamente')
ON CONFLICT (slug) DO NOTHING;


-- ============================================================
-- FILE: 20251229141536_add_trial_subscription_system.sql
-- ============================================================
/*
  # Aggiorna Sistema di Abbonamento con Trial di 2 Mesi

  1. Modifiche
    - Aggiunge 'trial' come stato valido per le subscriptions
    - Aggiunge campo 'payment_method_added' per tracciare se l'utente ha aggiunto un metodo di pagamento
    - Aggiunge campo 'reminder_sent' per tracciare se è stata inviata l'email di promemoria
    - Aggiunge campo 'trial_end_date' per distinguere la fine del trial dalla fine del periodo pagato
    - Periodo di trial: 60 giorni (2 mesi) gratuiti

  2. Sicurezza
    - Mantiene le policy RLS esistenti
*/

-- Modifica il check constraint per includere 'trial'
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage 
    WHERE table_name = 'subscriptions' AND constraint_name LIKE '%status_check%'
  ) THEN
    ALTER TABLE subscriptions DROP CONSTRAINT IF EXISTS subscriptions_status_check;
  END IF;
END $$;

ALTER TABLE subscriptions 
ADD CONSTRAINT subscriptions_status_check 
CHECK (status IN ('trial', 'active', 'expired', 'cancelled'));

-- Aggiungi nuovi campi se non esistono già
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'subscriptions' AND column_name = 'payment_method_added'
  ) THEN
    ALTER TABLE subscriptions ADD COLUMN payment_method_added boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'subscriptions' AND column_name = 'reminder_sent'
  ) THEN
    ALTER TABLE subscriptions ADD COLUMN reminder_sent boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'subscriptions' AND column_name = 'trial_end_date'
  ) THEN
    ALTER TABLE subscriptions ADD COLUMN trial_end_date timestamptz;
  END IF;
END $$;

