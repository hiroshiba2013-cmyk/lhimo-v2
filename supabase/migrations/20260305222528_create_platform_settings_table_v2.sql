/*
  # Crea tabella impostazioni piattaforma

  ## Panoramica
  Tabella per gestire le impostazioni globali della piattaforma inclusi contatti e regole.

  ## Nuove Tabelle
  
  ### `platform_settings`
  - `id` (uuid, primary key)
  - `setting_key` (text, unique) - Chiave univoca per l'impostazione
  - `setting_value` (jsonb) - Valore dell'impostazione in formato JSON
  - `category` (text) - Categoria: 'contact', 'rules', 'general'
  - `description` (text) - Descrizione dell'impostazione
  - `updated_at` (timestamp)
  - `updated_by` (uuid) - Admin che ha fatto l'ultima modifica

  ## Sicurezza
  - RLS abilitato
  - Chiunque può leggere (pubblico)
  - Solo admin possono modificare

  ## Seed Data
  Dati iniziali per contatti e regole della piattaforma
*/

CREATE TABLE IF NOT EXISTS platform_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  setting_key text UNIQUE NOT NULL,
  setting_value jsonb NOT NULL DEFAULT '{}'::jsonb,
  category text NOT NULL CHECK (category IN ('contact', 'rules', 'general')),
  description text,
  updated_at timestamptz DEFAULT now(),
  updated_by uuid REFERENCES profiles(id)
);

-- Indici per performance
CREATE INDEX IF NOT EXISTS idx_platform_settings_category ON platform_settings(category);
CREATE INDEX IF NOT EXISTS idx_platform_settings_key ON platform_settings(setting_key);

-- RLS Policies
ALTER TABLE platform_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view platform settings"
  ON platform_settings FOR SELECT
  TO authenticated, anon
  USING (true);

CREATE POLICY "Only admins can update platform settings"
  ON platform_settings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Only admins can insert platform settings"
  ON platform_settings FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Only admins can delete platform settings"
  ON platform_settings FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Seed data iniziali
INSERT INTO platform_settings (setting_key, setting_value, category, description) VALUES
-- Contatti
('contact_email', '{"value": "info@piattaforma.it"}'::jsonb, 'contact', 'Email di contatto principale'),
('contact_phone', '{"value": "+39 123 456 7890"}'::jsonb, 'contact', 'Numero di telefono'),
('contact_address', '{"street": "Via Roma 123", "city": "Milano", "cap": "20100", "country": "Italia"}'::jsonb, 'contact', 'Indirizzo fisico'),
('contact_social_facebook', '{"value": "https://facebook.com/piattaforma"}'::jsonb, 'contact', 'Link Facebook'),
('contact_social_instagram', '{"value": "https://instagram.com/piattaforma"}'::jsonb, 'contact', 'Link Instagram'),
('contact_social_twitter', '{"value": "https://twitter.com/piattaforma"}'::jsonb, 'contact', 'Link Twitter'),
('contact_whatsapp', '{"value": "+39 123 456 7890"}'::jsonb, 'contact', 'Numero WhatsApp'),
('contact_support_hours', '{"value": "Lun-Ven 9:00-18:00"}'::jsonb, 'contact', 'Orari assistenza'),

-- Regole piattaforma
('rules_reviews', '{"rules": ["Le recensioni devono essere veritiere e basate su esperienze reali", "Non è consentito linguaggio offensivo o discriminatorio", "Le recensioni devono riguardare l''attività e non le persone", "Non sono ammesse recensioni duplicate", "Le recensioni con prova di acquisto valgono 50 punti, senza prova 25 punti"]}'::jsonb, 'rules', 'Regole per le recensioni'),
('rules_classified_ads', '{"rules": ["Gli annunci devono contenere informazioni veritiere", "Vietata la vendita di prodotti illegali o contraffatti", "Le immagini devono essere appropriate e pertinenti", "Non è consentito spam o duplicazione annunci", "Gli annunci scadono dopo 30 giorni"]}'::jsonb, 'rules', 'Regole per gli annunci'),
('rules_messaging', '{"rules": ["Rispetta sempre gli altri utenti", "Non inviare spam o messaggi non richiesti", "Non condividere informazioni personali sensibili", "Segnala comportamenti inappropriati", "Non utilizzare la piattaforma per truffe o frodi"]}'::jsonb, 'rules', 'Regole per la messaggistica'),
('rules_points', '{"rules": ["I punti vengono assegnati per attività verificate", "Non è possibile trasferire punti tra utenti", "I punti non hanno valore monetario", "Comportamenti scorretti possono portare alla perdita di punti", "La classifica viene aggiornata in tempo reale"]}'::jsonb, 'rules', 'Regole sistema punti'),
('rules_general', '{"rules": ["Ogni utente può avere un solo account", "Vietato impersonare altre persone", "Rispetta la privacy degli altri utenti", "Non pubblicare contenuti protetti da copyright", "La piattaforma si riserva il diritto di rimuovere contenuti inappropriati"]}'::jsonb, 'rules', 'Regole generali piattaforma'),

-- Impostazioni generali
('platform_name', '{"value": "Piattaforma Recensioni"}'::jsonb, 'general', 'Nome della piattaforma'),
('platform_description', '{"value": "La piattaforma italiana per recensire attività locali e connettersi con la comunità"}'::jsonb, 'general', 'Descrizione piattaforma'),
('platform_terms_url', '{"value": "/termini-servizio"}'::jsonb, 'general', 'URL termini di servizio'),
('platform_privacy_url', '{"value": "/privacy-policy"}'::jsonb, 'general', 'URL privacy policy')
ON CONFLICT (setting_key) DO NOTHING;

-- Trigger per aggiornare updated_at
CREATE OR REPLACE FUNCTION update_platform_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_platform_settings_updated_at
  BEFORE UPDATE ON platform_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_platform_settings_updated_at();

-- Commenti
COMMENT ON TABLE platform_settings IS 'Impostazioni globali della piattaforma';
COMMENT ON COLUMN platform_settings.setting_key IS 'Chiave univoca per identificare l''impostazione';
COMMENT ON COLUMN platform_settings.setting_value IS 'Valore dell''impostazione in formato JSON per flessibilità';
COMMENT ON COLUMN platform_settings.category IS 'Categoria: contact (contatti), rules (regole), general (generale)';
