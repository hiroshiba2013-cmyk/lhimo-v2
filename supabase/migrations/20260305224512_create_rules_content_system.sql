/*
  # Create Rules Content Management System

  1. New Tables
    - `rules_sections`
      - Stores all content sections from the Rules page
    - `faqs`
      - Stores FAQ questions and answers

  2. Security
    - Enable RLS
    - Only admins can modify
    - Public read access

  3. Features
    - Hierarchical structure
    - Support for multiple content types
*/

-- Create rules_sections table
CREATE TABLE IF NOT EXISTS rules_sections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_key text UNIQUE NOT NULL,
  section_title text NOT NULL,
  section_anchor text NOT NULL,
  display_order integer NOT NULL DEFAULT 0,
  icon_name text,
  border_color text,
  content jsonb NOT NULL DEFAULT '[]'::jsonb,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  updated_by uuid REFERENCES profiles(id)
);

-- Create FAQs table
CREATE TABLE IF NOT EXISTS faqs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL,
  question text NOT NULL,
  answer text NOT NULL,
  display_order integer NOT NULL DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  updated_by uuid REFERENCES profiles(id)
);

-- Enable RLS
ALTER TABLE rules_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;

-- Public read policies
CREATE POLICY "Anyone can view active rules sections"
  ON rules_sections FOR SELECT
  USING (is_active = true);

CREATE POLICY "Anyone can view active FAQs"
  ON faqs FOR SELECT
  USING (is_active = true);

-- Admin policies for rules_sections
CREATE POLICY "Admins can view all rules sections"
  ON rules_sections FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can insert rules sections"
  ON rules_sections FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can update rules sections"
  ON rules_sections FOR UPDATE
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

CREATE POLICY "Admins can delete rules sections"
  ON rules_sections FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Admin policies for faqs
CREATE POLICY "Admins can view all FAQs"
  ON faqs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can insert FAQs"
  ON faqs FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can update FAQs"
  ON faqs FOR UPDATE
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

CREATE POLICY "Admins can delete FAQs"
  ON faqs FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_rules_sections_key ON rules_sections(section_key);
CREATE INDEX IF NOT EXISTS idx_rules_sections_active ON rules_sections(is_active);
CREATE INDEX IF NOT EXISTS idx_rules_sections_order ON rules_sections(display_order);
CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs(category);
CREATE INDEX IF NOT EXISTS idx_faqs_active ON faqs(is_active);
CREATE INDEX IF NOT EXISTS idx_faqs_order ON faqs(display_order);

-- Seed initial FAQs
INSERT INTO faqs (category, question, answer, display_order) VALUES
('Iscrizione e Account', 'Come mi iscrivo alla piattaforma?', 'Clicca su "Registrati", scegli tra account Cliente o Business, inserisci email e password. Gli account Cliente hanno 1 mese di prova gratuita, poi partono da 0,49€/mese. Gli account Business partono da 2,49€/mese + IVA dopo la prova.', 1),
('Iscrizione e Account', 'Qual è la differenza tra account Cliente e Business?', 'L''account Cliente è per privati che vogliono lasciare recensioni, pubblicare annunci e cercare lavoro. L''account Business è per aziende che vogliono gestire la propria attività, rispondere a recensioni, pubblicare offerte di lavoro e gestire più sedi.', 2),
('Iscrizione e Account', 'Posso avere più account sulla piattaforma?', 'No, ogni utente può avere un solo account. Tuttavia, gli account Cliente possono aggiungere fino a 4 membri della famiglia con profili separati.', 3),
('Punti e Classifica', 'Come funziona il sistema dei punti?', 'Guadagni punti per ogni attività: annunci (5pt), prodotti (10pt), segnalazioni attività base (10pt), segnalazioni complete (25pt), recensioni approvate (25pt base o 50pt con prova), presenta un amico (30pt).', 4),
('Punti e Classifica', 'Quando ricevo i punti per una recensione?', 'I punti vengono assegnati solo quando la tua recensione viene approvata dallo staff (entro 7 giorni). Ricevi 25 punti per una recensione base o 50 punti se alleghi prove documentali.', 5),
('Recensioni', 'Come scrivo una recensione?', 'Cerca l''azienda, vai sulla sua pagina e clicca "Scrivi Recensione". Valuta servizio, qualità/prezzo, puntualità e disponibilità. Aggiungi un commento dettagliato (minimo 100 caratteri) e, se vuoi 50 punti invece di 25, carica una prova.', 6),
('Recensioni', 'Posso modificare una recensione dopo averla pubblicata?', 'No, una volta pubblicata la recensione non può essere modificata. Se hai commesso un errore, contatta il supporto.', 7),
('Annunci', 'Quanti annunci gratuiti posso pubblicare?', 'Puoi pubblicare fino a 20 annunci contemporaneamente. Gli annunci scadono dopo 30 giorni ma possono essere rinnovati gratuitamente. Ogni annuncio pubblicato ti fa guadagnare 5 punti.', 8),
('Lavoro', 'Come funziona la ricerca di lavoro?', 'Crea un profilo "Cerca Lavoro" con le tue competenze, esperienza e CV. Le aziende possono vedere il tuo profilo e contattarti direttamente.', 9),
('Aziende', 'Come rivendico la mia azienda?', 'Registrati come account Business, cerca la tua azienda nel database e clicca "Rivendica". Fornisci Partita IVA, Codice Fiscale, Codice Univoco SDI, PEC e Codice ATECO. La verifica richiede 24-48 ore.', 10),
('Abbonamenti', 'Quali sono i piani di abbonamento?', 'Per Clienti: da 0,49€/mese (1 persona) a 1,49€/mese (4 persone). Per Business: da 2,49€/mese + IVA (1 sede) a tariffe personalizzate per 10+ sedi. Tutti includono 1 mese di prova gratuita.', 11),
('Privacy e Sicurezza', 'I miei dati sono al sicuro?', 'Sì, trattiamo i dati in conformità al GDPR. I dati vengono usati solo per i servizi della piattaforma e non vengono condivisi con terze parti senza consenso.', 12),
('Generale', 'Come segnalo contenuti inappropriati?', 'Usa il pulsante "Segnala" presente su recensioni, annunci e profili. Il nostro team esaminerà la segnalazione entro 24-48 ore. Le segnalazioni sono anonime.', 13)
ON CONFLICT DO NOTHING;