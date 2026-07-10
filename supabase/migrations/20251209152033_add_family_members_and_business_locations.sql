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
