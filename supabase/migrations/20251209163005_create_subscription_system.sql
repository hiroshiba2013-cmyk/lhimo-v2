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
