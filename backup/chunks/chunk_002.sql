-- ============================================================
-- FILE: 20251204105615_add_customer_avatar_and_job_requests.sql
-- ============================================================
/*
  # Add Customer Avatar and Job Requests

  ## Overview
  This migration adds avatar support for profiles and creates a job requests table
  for customers to post job search announcements.

  ## Changes

  ### Modified Tables
  - `profiles` - Add avatar_url field for profile pictures

  ### New Tables
  - `job_requests` - Store customer job search announcements
    - `id` (uuid, primary key)
    - `customer_id` (uuid, foreign key to profiles)
    - `title` (text) - Job title/position seeking
    - `description` (text) - Detailed job request description
    - `category` (text) - Job category/field
    - `location` (text) - Preferred work location
    - `employment_type` (text) - Full-time, part-time, contract, etc.
    - `experience_years` (integer) - Years of experience
    - `active` (boolean) - Whether the request is active
    - `created_at` (timestamptz)
    - `updated_at` (timestamptz)

  ### Storage
  - Create 'avatars' storage bucket for profile pictures

  ## Security
  - Enable RLS on job_requests table
  - Add policies for authenticated users to manage their own job requests
  - Add policies for public read access to active job requests
  - Configure storage policies for avatar uploads

  ## Notes
  - Customers can create job search announcements
  - Job requests are public when active
  - Avatar images are stored in Supabase Storage
*/

-- Add avatar_url to profiles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'avatar_url'
  ) THEN
    ALTER TABLE profiles ADD COLUMN avatar_url text;
  END IF;
END $$;

-- Create job_requests table
CREATE TABLE IF NOT EXISTS job_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  category text NOT NULL,
  location text NOT NULL,
  employment_type text NOT NULL,
  experience_years integer DEFAULT 0,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on job_requests
ALTER TABLE job_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view active job requests
CREATE POLICY "Anyone can view active job requests"
  ON job_requests
  FOR SELECT
  USING (active = true);

-- Policy: Authenticated users can view their own job requests
CREATE POLICY "Users can view own job requests"
  ON job_requests
  FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

-- Policy: Authenticated customers can create job requests
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
  );

-- Policy: Users can update their own job requests
CREATE POLICY "Users can update own job requests"
  ON job_requests
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id)
  WITH CHECK (auth.uid() = customer_id);

-- Policy: Users can delete their own job requests
CREATE POLICY "Users can delete own job requests"
  ON job_requests
  FOR DELETE
  TO authenticated
  USING (auth.uid() = customer_id);

-- Create storage bucket for avatars
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policy: Anyone can view avatars
CREATE POLICY "Public avatar access"
  ON storage.objects
  FOR SELECT
  USING (bucket_id = 'avatars');

-- Storage policy: Authenticated users can upload their own avatar
CREATE POLICY "Users can upload own avatar"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Storage policy: Users can update their own avatar
CREATE POLICY "Users can update own avatar"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Storage policy: Users can delete their own avatar
CREATE POLICY "Users can delete own avatar"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- ============================================================
-- FILE: 20251204110139_add_business_website_field.sql
-- ============================================================
/*
  # Add Business Website Field

  ## Overview
  This migration adds a website URL field to businesses table to allow
  businesses to showcase their website on their profile.

  ## Changes

  ### Modified Tables
  - `businesses` - Add website_url field

  ## New Columns

  ### businesses table
  - `website_url` (text) - Company website URL (optional)

  ## Notes
  - This field is optional and can be left empty if the business doesn't have a website
  - The URL should be a valid HTTP/HTTPS URL
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'businesses' AND column_name = 'website_url'
  ) THEN
    ALTER TABLE businesses ADD COLUMN website_url text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251204164128_add_resume_url_to_profiles.sql
-- ============================================================
/*
  # Add resume URL field to profiles table

  1. Changes
    - Add `resume_url` column to `profiles` table
      - `resume_url` (text, nullable) - URL path to the uploaded resume PDF in Supabase Storage
  
  2. Notes
    - This field will store the path to the resume PDF file in Supabase Storage
    - Only relevant for customer profiles
    - Nullable field as not all customers may want to upload a resume
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'resume_url'
  ) THEN
    ALTER TABLE profiles ADD COLUMN resume_url text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20251205105522_add_ateco_codes_to_categories.sql
-- ============================================================
/*
  # Aggiunta Codici ATECO alle Categorie Professionali

  1. Modifiche
    - Aggiunta colonna `ateco_code` alla tabella `business_categories`
    - Pulizia delle categorie esistenti
    - Inserimento di 30+ categorie professionali con codici ATECO ufficiali
  
  2. Categorie Aggiunte
    - Ristorazione e somministrazione
    - Servizi alla persona (parrucchieri, estetisti)
    - Edilizia e costruzioni
    - Servizi professionali (avvocati, commercialisti, consulenti)
    - Salute (medici, dentisti, farmacie)
    - Commercio al dettaglio
    - Automotive (officine, autolavaggi)
    - Sport e fitness
    - Alloggi e turismo
    - Servizi tecnici (idraulici, elettricisti)
    - Alimentari (panifici, pasticcerie)
    - E molte altre categorie comuni
  
  3. Note Importanti
    - Ogni categoria include nome, slug, descrizione e codice ATECO ufficiale
    - I codici ATECO seguono la classificazione ufficiale italiana
    - Le categorie esistenti vengono sostituite con quelle nuove più complete
*/

-- Add ateco_code column to business_categories if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_categories' AND column_name = 'ateco_code'
  ) THEN
    ALTER TABLE business_categories ADD COLUMN ateco_code TEXT;
  END IF;
END $$;

-- Clear existing categories
DELETE FROM business_categories;

-- Insert comprehensive list of professional categories with ATECO codes
INSERT INTO business_categories (name, slug, description, ateco_code) VALUES

-- Ristorazione e Bar
('Ristoranti', 'ristoranti', 'Ristoranti con somministrazione di pasti e bevande', '56.10.11'),
('Pizzerie', 'pizzerie', 'Pizzerie e rosticcerie con somministrazione', '56.10.12'),
('Bar e Caffè', 'bar-caffe', 'Bar e altri esercizi simili senza cucina', '56.30.00'),
('Catering', 'catering', 'Servizi di catering per eventi e ricevimenti', '56.21.00'),
('Gelaterie e Pasticcerie', 'gelaterie-pasticcerie', 'Gelaterie e pasticcerie con somministrazione', '56.10.30'),

-- Bellezza e Cura della Persona
('Parrucchieri', 'parrucchieri', 'Servizi dei saloni di barbiere e parrucchiere', '96.02.01'),
('Centri Estetici', 'centri-estetici', 'Servizi degli istituti di bellezza e centri estetici', '96.02.02'),
('Centri Benessere e SPA', 'centri-benessere-spa', 'Stabilimenti termali e centri per il benessere fisico', '96.04.20'),

-- Salute
('Studi Medici', 'studi-medici', 'Servizi degli studi medici di medicina generale', '86.21.00'),
('Studi Dentistici', 'studi-dentistici', 'Servizi degli studi odontoiatrici', '86.23.00'),
('Farmacie', 'farmacie', 'Commercio al dettaglio di medicinali', '47.73.10'),
('Fisioterapia', 'fisioterapia', 'Altre attività paramediche indipendenti', '86.90.29'),
('Veterinari', 'veterinari', 'Servizi veterinari', '75.00.00'),

-- Servizi Professionali
('Avvocati', 'avvocati', 'Attività degli studi legali', '69.10.10'),
('Commercialisti', 'commercialisti', 'Servizi forniti da dottori commercialisti', '69.20.11'),
('Consulenti Aziendali', 'consulenti-aziendali', 'Attività di consulenza gestionale', '70.22.09'),
('Agenzie Immobiliari', 'agenzie-immobiliari', 'Attività di intermediazione immobiliare', '68.31.00'),
('Agenzie di Viaggio', 'agenzie-viaggio', 'Attività delle agenzie di viaggio', '79.11.00'),

-- Edilizia e Costruzioni
('Imprese Edili', 'imprese-edili', 'Costruzione di edifici residenziali e non', '41.20.00'),
('Idraulici', 'idraulici', 'Installazione di impianti idraulici e termici', '43.22.01'),
('Elettricisti', 'elettricisti', 'Installazione di impianti elettrici', '43.21.01'),
('Imbianchini', 'imbianchini', 'Attività di pittura e posa in opera di vetri', '43.34.00'),
('Fabbri', 'fabbri', 'Installazione di infissi, arredi e strutture metalliche', '43.32.01'),

-- Automotive
('Officine Auto', 'officine-auto', 'Manutenzione e riparazione di autoveicoli', '45.20.10'),
('Autolavaggi', 'autolavaggi', 'Lavaggio auto', '45.20.30'),
('Gommisti', 'gommisti', 'Commercio di pneumatici e cerchi', '45.32.00'),

-- Commercio al Dettaglio
('Supermercati', 'supermercati', 'Supermercati e ipermercati', '47.11.10'),
('Abbigliamento', 'abbigliamento', 'Commercio al dettaglio di articoli di abbigliamento', '47.71.00'),
('Calzature', 'calzature', 'Commercio al dettaglio di articoli di calzature', '47.72.10'),
('Elettronica', 'elettronica', 'Commercio al dettaglio di elettronica ed elettrodomestici', '47.54.00'),
('Librerie', 'librerie', 'Commercio al dettaglio di libri', '47.61.00'),
('Fioristi', 'fioristi', 'Commercio al dettaglio di fiori e piante', '47.76.10'),

-- Alimentari Artigianali
('Panifici', 'panifici', 'Produzione di prodotti di panetteria freschi', '10.71.10'),
('Macellerie', 'macellerie', 'Commercio al dettaglio di carni e prodotti a base di carne', '47.22.01'),

-- Sport e Tempo Libero
('Palestre', 'palestre', 'Gestione di palestre', '93.13.00'),
('Piscine', 'piscine', 'Gestione di piscine', '93.11.30'),

-- Alloggi e Turismo
('Hotel e Alberghi', 'hotel-alberghi', 'Alberghi e strutture simili', '55.10.00'),
('Bed and Breakfast', 'bed-breakfast', 'Alloggi per vacanze e affittacamere', '55.20.51'),

-- Servizi alle Imprese
('Web Agency', 'web-agency', 'Consulenza nel settore delle tecnologie informatiche', '62.02.00'),
('Fotografi', 'fotografi', 'Attività di fotografia', '74.20.11'),
('Agenzie Pubblicitarie', 'agenzie-pubblicitarie', 'Attività delle agenzie pubblicitarie', '73.11.01')

ON CONFLICT (name) DO NOTHING;


-- ============================================================
-- FILE: 20251209105704_add_education_level_to_job_postings.sql
-- ============================================================
/*
  # Aggiunta Titolo di Studio agli Annunci di Lavoro

  1. Modifiche
    - Aggiunta colonna `education_level` alla tabella `job_postings`
    - Il campo memorizza il titolo di studio richiesto per la posizione
  
  2. Dettagli Campo
    - `education_level` (text, nullable)
    - Valori comuni: 'Nessuno', 'Licenza Media', 'Diploma', 'Laurea Triennale', 'Laurea Magistrale', 'Master/Dottorato'
    - Campo opzionale per permettere flessibilità negli annunci
  
  3. Note Importanti
    - Il campo è nullable per retrocompatibilità con annunci esistenti
    - Non viene impostato un valore di default per permettere la scelta esplicita
*/

-- Add education_level column to job_postings if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'education_level'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN education_level TEXT;
  END IF;
END $$;


-- ============================================================
-- FILE: 20251209152033_add_family_members_and_business_locations.sql
-- ============================================================
/*
  # Aggiungi supporto per account multi-utente e sedi multiple

  ## Nuove Tabelle
  
  ### 1. `customer_family_members`
  Permette agli utenti privati di registrare più persone (familiari) su un singolo account:
  - `id` (uuid, primary key) - ID univoco del membro
  - `customer_id` (uuid) - ID del profilo principale (owner dell'account)
  - `first_name` (text) - Nome del membro
  - `last_name` (text) - Cognome del membro
  - `date_of_birth` (date) - Data di nascita del membro
  - `tax_code` (text, unique) - Codice fiscale del membro
  - `relationship` (text) - Relazione con il titolare (es. "Coniuge", "Figlio/a", "Genitore")
  - `created_at` (timestamptz) - Data di creazione
  
  ### 2. `business_locations`
  Permette alle aziende di registrare più sedi operative:
  - `id` (uuid, primary key) - ID univoco della sede
  - `business_id` (uuid) - ID dell'azienda
  - `name` (text) - Nome della sede (es. "Sede Principale", "Filiale Roma")
  - `address` (text) - Indirizzo completo della sede
  - `city` (text) - Città
  - `province` (text) - Provincia
  - `postal_code` (text) - CAP
  - `phone` (text) - Numero di telefono della sede
  - `is_primary` (boolean) - Se è la sede principale
  - `created_at` (timestamptz) - Data di creazione

  ## Sicurezza
  
  - Abilita RLS su entrambe le tabelle
  - Gli utenti possono vedere/modificare solo i propri dati
  - I membri della famiglia sono visibili solo al titolare dell'account
  - Le sedi aziendali sono visibili solo al proprietario dell'azienda
*/

-- Crea tabella per i membri della famiglia
CREATE TABLE IF NOT EXISTS customer_family_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  first_name text NOT NULL,
  last_name text NOT NULL,
  date_of_birth date NOT NULL,
  tax_code text UNIQUE NOT NULL,
  relationship text NOT NULL DEFAULT 'Familiare',
  created_at timestamptz DEFAULT now()
);

-- Crea tabella per le sedi aziendali
CREATE TABLE IF NOT EXISTS business_locations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  name text NOT NULL DEFAULT 'Sede',
  address text NOT NULL,
  city text NOT NULL,
  province text NOT NULL,
  postal_code text NOT NULL,
  phone text,
  is_primary boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Abilita RLS su customer_family_members
ALTER TABLE customer_family_members ENABLE ROW LEVEL SECURITY;

-- Abilita RLS su business_locations
ALTER TABLE business_locations ENABLE ROW LEVEL SECURITY;

-- Policy per customer_family_members: gli utenti possono vedere i propri membri della famiglia
CREATE POLICY "Users can view own family members"
  ON customer_family_members
  FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

-- Policy per customer_family_members: gli utenti possono inserire membri della famiglia
CREATE POLICY "Users can insert own family members"
  ON customer_family_members
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = customer_id);

-- Policy per customer_family_members: gli utenti possono aggiornare i propri membri della famiglia
CREATE POLICY "Users can update own family members"
  ON customer_family_members
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id)
  WITH CHECK (auth.uid() = customer_id);

-- Policy per customer_family_members: gli utenti possono eliminare i propri membri della famiglia
CREATE POLICY "Users can delete own family members"
  ON customer_family_members
  FOR DELETE
  TO authenticated
  USING (auth.uid() = customer_id);

-- Policy per business_locations: i proprietari possono vedere le sedi della propria azienda
CREATE POLICY "Business owners can view own locations"
  ON business_locations
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = business_locations.business_id
      AND businesses.owner_id = auth.uid()
    )
  );

-- Policy per business_locations: i proprietari possono inserire sedi per la propria azienda
CREATE POLICY "Business owners can insert own locations"
  ON business_locations
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = business_locations.business_id
      AND businesses.owner_id = auth.uid()
    )
  );

-- Policy per business_locations: i proprietari possono aggiornare le sedi della propria azienda
CREATE POLICY "Business owners can update own locations"
  ON business_locations
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = business_locations.business_id
      AND businesses.owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = business_locations.business_id
      AND businesses.owner_id = auth.uid()
    )
  );

-- Policy per business_locations: i proprietari possono eliminare le sedi della propria azienda
CREATE POLICY "Business owners can delete own locations"
  ON business_locations
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = business_locations.business_id
      AND businesses.owner_id = auth.uid()
    )
  );

-- Indici per migliorare le performance
CREATE INDEX IF NOT EXISTS idx_customer_family_members_customer_id ON customer_family_members(customer_id);
CREATE INDEX IF NOT EXISTS idx_business_locations_business_id ON business_locations(business_id);
CREATE INDEX IF NOT EXISTS idx_business_locations_is_primary ON business_locations(business_id, is_primary);


-- ============================================================
-- FILE: 20251209161302_add_nickname_to_family_members.sql
-- ============================================================
/*
  # Aggiungi campo nickname ai membri della famiglia

  ## Modifiche
  
  1. Aggiungi colonna `nickname` alla tabella `customer_family_members`
    - `nickname` (text, unique) - Nome visibile per le review, univoco per ogni membro
  
  ## Note
  
  - Il nickname è univoco in tutto il sistema per consentire identificazione nelle review
  - Obbligatorio per ogni membro della famiglia, come per il titolare principale
*/

-- Aggiungi colonna nickname alla tabella customer_family_members
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'nickname'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN nickname text UNIQUE NOT NULL;
  END IF;
END $$;


-- ============================================================
-- FILE: 20251209163005_create_subscription_system.sql
-- ============================================================
/*
  # Sistema Abbonamenti per Utenti Privati

  ## Nuove Tabelle
  
  1. `subscription_plans`
    - `id` (uuid, primary key)
    - `name` (text) - Nome del piano
    - `price` (decimal) - Prezzo in euro
    - `billing_period` (text) - 'monthly' o 'yearly'
    - `max_persons` (integer) - Numero massimo di persone coperte
    - `created_at` (timestamp)
  
  2. `subscriptions`
    - `id` (uuid, primary key)
    - `customer_id` (uuid, foreign key) - Riferimento all'utente
    - `plan_id` (uuid, foreign key) - Riferimento al piano
    - `status` (text) - 'active', 'expired', 'cancelled'
    - `start_date` (timestamp)
    - `end_date` (timestamp) - Data di scadenza
    - `created_at` (timestamp)
    - `updated_at` (timestamp)
  
  ## Sicurezza
  
  - Abilita RLS su entrambe le tabelle
  - Gli utenti possono vedere tutti i piani disponibili
  - Gli utenti possono vedere solo i propri abbonamenti
  - Solo gli utenti autenticati possono creare abbonamenti
  
  ## Note
  
  - I piani abbonamento sono predefiniti e popolati automaticamente
  - Il prezzo aumenta in base al numero di persone (1, 2, 3, 4+)
  - L'abbonamento viene creato automaticamente durante la registrazione
*/

-- Crea tabella subscription_plans
CREATE TABLE IF NOT EXISTS subscription_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  price decimal(10, 2) NOT NULL,
  billing_period text NOT NULL CHECK (billing_period IN ('monthly', 'yearly')),
  max_persons integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Crea tabella subscriptions
CREATE TABLE IF NOT EXISTS subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id uuid NOT NULL REFERENCES subscription_plans(id),
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
  start_date timestamptz DEFAULT now(),
  end_date timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Abilita RLS
ALTER TABLE subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Policy per subscription_plans: tutti possono leggere
CREATE POLICY "Anyone can view subscription plans"
  ON subscription_plans FOR SELECT
  TO authenticated
  USING (true);

-- Policy per subscriptions: lettura
CREATE POLICY "Users can view own subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

-- Policy per subscriptions: creazione
CREATE POLICY "Users can create own subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = customer_id);

-- Policy per subscriptions: aggiornamento
CREATE POLICY "Users can update own subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id)
  WITH CHECK (auth.uid() = customer_id);

-- Inserisci i piani abbonamento predefiniti
INSERT INTO subscription_plans (name, price, billing_period, max_persons) VALUES
  ('Piano Mensile - 1 Persona', 0.99, 'monthly', 1),
  ('Piano Annuale - 1 Persona', 9.90, 'yearly', 1),
  ('Piano Mensile - 2 Persone', 1.49, 'monthly', 2),
  ('Piano Annuale - 2 Persone', 14.90, 'yearly', 2),
  ('Piano Mensile - 3 Persone', 1.99, 'monthly', 3),
  ('Piano Annuale - 3 Persone', 19.90, 'yearly', 3),
  ('Piano Mensile - 4 Persone', 2.49, 'monthly', 4),
  ('Piano Annuale - 4 Persone', 24.90, 'yearly', 4)
ON CONFLICT DO NOTHING;


-- ============================================================
-- FILE: 20251209214008_add_business_subscription_plans.sql
-- ============================================================
/*
  # Piani Abbonamento per Professionisti

  ## Modifiche
  
  1. Aggiunta piani abbonamento business
    - Piani basati sul numero di punti vendita (1, 2, 3, 4+)
    - Prezzi mensili e annuali
    - Prezzi escluso IVA (IVA da applicare al checkout)
  
  ## Piani Business
  
  - 1 punto vendita: 2,49€/mese o 24,90€/anno (+ IVA)
  - 2 punti vendita: 3,99€/mese o 39,90€/anno (+ IVA)
  - 3 punti vendita: 4,99€/mese o 49,90€/anno (+ IVA)
  - 4+ punti vendita: 5,99€/mese o 59,90€/anno (+ IVA)
  
  ## Note
  
  - I prezzi sono escluso IVA
  - I piani business usano il campo max_persons per indicare il numero di punti vendita
  - L'abbonamento viene creato automaticamente durante la registrazione
*/

-- Inserisci i piani abbonamento business
INSERT INTO subscription_plans (name, price, billing_period, max_persons) VALUES
  ('Piano Business Mensile - 1 Punto Vendita', 2.49, 'monthly', 1),
  ('Piano Business Annuale - 1 Punto Vendita', 24.90, 'yearly', 1),
  ('Piano Business Mensile - 2 Punti Vendita', 3.99, 'monthly', 2),
  ('Piano Business Annuale - 2 Punti Vendita', 39.90, 'yearly', 2),
  ('Piano Business Mensile - 3 Punti Vendita', 4.99, 'monthly', 3),
  ('Piano Business Annuale - 3 Punti Vendita', 49.90, 'yearly', 3),
  ('Piano Business Mensile - 4 Punti Vendita', 5.99, 'monthly', 4),
  ('Piano Business Annuale - 4 Punti Vendita', 59.90, 'yearly', 4)
ON CONFLICT DO NOTHING;


