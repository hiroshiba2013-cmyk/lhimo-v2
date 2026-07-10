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
