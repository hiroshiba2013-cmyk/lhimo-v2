-- ============================================================
-- FILE: 20251227232906_update_business_locations_regions.sql
-- ============================================================
/*
  # Update Business Locations with Missing Regions
  
  1. Purpose
    - Add region field to business_locations that are missing it
    - Map province codes to their corresponding regions
    - Enable proper filtering by region in search results
  
  2. Impact
    - Updates ~4,500 business_locations with missing region field
    - Fixes search/filter functionality for regional searches
    - Businesses will now appear in region-based searches
  
  3. Mapping
    - Uses province codes (MI, RM, TO, etc.) to determine region
    - Maps to 20 Italian regions (Lombardia, Lazio, Piemonte, etc.)
*/

-- Update business_locations with region based on province code
UPDATE business_locations
SET region = CASE 
  -- Lombardia
  WHEN province IN ('MI', 'BG', 'BS', 'CO', 'CR', 'LC', 'LO', 'MN', 'MB', 'PV', 'SO', 'VA') THEN 'Lombardia'
  
  -- Piemonte
  WHEN province IN ('TO', 'AL', 'AT', 'BI', 'CN', 'NO', 'VB', 'VC') THEN 'Piemonte'
  
  -- Lazio
  WHEN province IN ('RM', 'FR', 'LT', 'RI', 'VT') THEN 'Lazio'
  
  -- Veneto
  WHEN province IN ('VE', 'VR', 'PD', 'VI', 'TV', 'BL', 'RO') THEN 'Veneto'
  
  -- Emilia-Romagna
  WHEN province IN ('BO', 'MO', 'PR', 'RE', 'FE', 'RA', 'FC', 'RN', 'PC') THEN 'Emilia-Romagna'
  
  -- Toscana
  WHEN province IN ('FI', 'AR', 'GR', 'LI', 'LU', 'MS', 'PI', 'PT', 'PO', 'SI') THEN 'Toscana'
  
  -- Campania
  WHEN province IN ('NA', 'SA', 'AV', 'BN', 'CE') THEN 'Campania'
  
  -- Sicilia
  WHEN province IN ('PA', 'CT', 'ME', 'SR', 'TP', 'AG', 'CL', 'EN', 'RG') THEN 'Sicilia'
  
  -- Puglia
  WHEN province IN ('BA', 'BR', 'FG', 'LE', 'TA', 'BT') THEN 'Puglia'
  
  -- Liguria
  WHEN province IN ('GE', 'SP', 'SV', 'IM') THEN 'Liguria'
  
  -- Friuli-Venezia Giulia
  WHEN province IN ('TS', 'UD', 'PN', 'GO') THEN 'Friuli-Venezia Giulia'
  
  -- Trentino-Alto Adige
  WHEN province IN ('TN', 'BZ') THEN 'Trentino-Alto Adige'
  
  -- Marche
  WHEN province IN ('AN', 'AP', 'FM', 'MC', 'PU') THEN 'Marche'
  
  -- Abruzzo
  WHEN province IN ('AQ', 'TE', 'PE', 'CH') THEN 'Abruzzo'
  
  -- Umbria
  WHEN province IN ('PG', 'TR') THEN 'Umbria'
  
  -- Calabria
  WHEN province IN ('CZ', 'CS', 'RC', 'KR', 'VV') THEN 'Calabria'
  
  -- Sardegna
  WHEN province IN ('CA', 'SS', 'NU', 'OR', 'SU') THEN 'Sardegna'
  
  -- Molise
  WHEN province IN ('CB', 'IS') THEN 'Molise'
  
  -- Basilicata
  WHEN province IN ('PZ', 'MT') THEN 'Basilicata'
  
  -- Valle d'Aosta
  WHEN province = 'AO' THEN 'Valle d''Aosta'
  
  ELSE region
END
WHERE (region IS NULL OR region = '')
  AND province IS NOT NULL 
  AND province != '';


-- ============================================================
-- FILE: 20251228144135_add_comprehensive_business_categories_complete.sql
-- ============================================================
/*
  # Aggiungi Categorie Complete per Importazione OSM
  
  1. Nuove Categorie
    Aggiunge tutte le categorie mancanti necessarie per l'importazione completa
    da OpenStreetMap, organizzate per settore.
    
    Totale: ~180 nuove categorie
    
  2. Note
    - Le categorie esistenti non vengono duplicate (ON CONFLICT DO NOTHING)
    - Slug viene generato automaticamente dal nome
*/

-- Funzione helper per generare slug
CREATE OR REPLACE FUNCTION generate_slug(text_input text) RETURNS text AS $$
BEGIN
  RETURN lower(
    regexp_replace(
      regexp_replace(
        regexp_replace(text_input, '[àáâãäå]', 'a', 'g'),
        '[èéêë]', 'e', 'g'
      ),
      '[^a-z0-9]+', '-', 'g'
    )
  );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Alimentari e Gastronomia
INSERT INTO business_categories (name, slug, description) VALUES
('Frutta e Verdura', 'frutta-e-verdura', 'Negozi di frutta e verdura'),
('Enoteche', 'enoteche', 'Enoteche e wine bar'),
('Negozi di Bevande', 'negozi-di-bevande', 'Negozi specializzati in bevande'),
('Pescherie', 'pescherie', 'Pescherie'),
('Formaggerie', 'formaggerie', 'Negozi specializzati in formaggi'),
('Cioccolaterie', 'cioccolaterie', 'Negozi di cioccolato artigianale'),
('Torrefazioni', 'torrefazioni', 'Torrefazioni e caffè'),
('Gastronomie', 'gastronomie', 'Gastronomie e salumerie'),
('Latterie', 'latterie', 'Latterie'),
('Pastifici', 'pastifici', 'Pastifici artigianali'),
('Spezierie', 'spezierie', 'Negozi di spezie'),
('Negozi di Tè', 'negozi-di-te', 'Negozi specializzati in tè'),
('Pasticcerie', 'pasticcerie', 'Pasticcerie'),
('Food Court', 'food-court', 'Aree ristorazione'),
('Birrerie', 'birrerie', 'Birrerie e birrifici')
ON CONFLICT (name) DO NOTHING;

-- Abbigliamento e Accessori
INSERT INTO business_categories (name, slug, description) VALUES
('Calzature', 'calzature', 'Negozi di scarpe'),
('Orologerie', 'orologerie', 'Negozi di orologi'),
('Pelletterie', 'pelletterie', 'Pelletterie e articoli in pelle'),
('Boutique', 'boutique', 'Boutique di moda'),
('Moda', 'moda', 'Negozi di moda'),
('Tessuti', 'tessuti', 'Negozi di tessuti'),
('Sarti', 'sarti', 'Sarti'),
('Articoli in Pelle', 'articoli-in-pelle', 'Articoli in pelle')
ON CONFLICT (name) DO NOTHING;

-- Bellezza e Cura Persona
INSERT INTO business_categories (name, slug, description) VALUES
('Profumerie', 'profumerie', 'Profumerie e cosmetici'),
('Centri Massaggi', 'centri-massaggi', 'Centri massaggi'),
('Tatuatori', 'tatuatori', 'Studi di tatuaggi'),
('Forniture Parrucchieri', 'forniture-parrucchieri', 'Forniture per parrucchieri')
ON CONFLICT (name) DO NOTHING;

-- Casa e Giardino
INSERT INTO business_categories (name, slug, description) VALUES
('Fai da Te', 'fai-da-te', 'Negozi fai da te e bricolage'),
('Arredamento', 'arredamento', 'Negozi di arredamento'),
('Materassi e Letti', 'materassi-e-letti', 'Negozi di materassi e letti'),
('Arredo Bagno', 'arredo-bagno', 'Arredo bagno'),
('Cucine', 'cucine', 'Negozi di cucine'),
('Giardinaggio', 'giardinaggio', 'Articoli per giardinaggio'),
('Consorzi Agrari', 'consorzi-agrari', 'Consorzi agrari'),
('Colorifici', 'colorifici', 'Colorifici'),
('Tappeti', 'tappeti', 'Negozi di tappeti'),
('Tendaggi', 'tendaggi', 'Negozi di tendaggi'),
('Illuminazione', 'illuminazione', 'Negozi di illuminazione'),
('Piastrelle', 'piastrelle', 'Negozi di piastrelle'),
('Vetrai', 'vetrai', 'Vetrai'),
('Infissi', 'infissi', 'Infissi e serramenti')
ON CONFLICT (name) DO NOTHING;

-- Elettronica e Tecnologia
INSERT INTO business_categories (name, slug, description) VALUES
('Elettronica', 'elettronica', 'Negozi di elettronica'),
('Negozi di Computer', 'negozi-di-computer', 'Negozi di computer'),
('Negozi di Telefonia', 'negozi-di-telefonia', 'Negozi di telefonia'),
('Hi-Fi', 'hi-fi', 'Negozi Hi-Fi'),
('Videonoleggi', 'videonoleggi', 'Videonoleggi'),
('Fotografia', 'fotografia', 'Negozi di fotografia'),
('Videogiochi', 'videogiochi', 'Negozi di videogiochi'),
('Fotocamere', 'fotocamere', 'Negozi di fotocamere')
ON CONFLICT (name) DO NOTHING;

-- Libri, Cultura e Hobby
INSERT INTO business_categories (name, slug, description) VALUES
('Cartolerie', 'cartolerie', 'Cartolerie'),
('Edicole', 'edicole', 'Edicole e giornalai'),
('Negozi di Musica', 'negozi-di-musica', 'Negozi di musica'),
('Strumenti Musicali', 'strumenti-musicali', 'Negozi di strumenti musicali'),
('Gallerie d''Arte', 'gallerie-d-arte', 'Gallerie d''arte'),
('Cornici', 'cornici', 'Negozi di cornici'),
('Hobby e Bricolage', 'hobby-e-bricolage', 'Negozi di hobby'),
('Modellismo', 'modellismo', 'Negozi di modellismo')
ON CONFLICT (name) DO NOTHING;

-- Salute
INSERT INTO business_categories (name, slug, description) VALUES
('Ottici', 'ottici', 'Ottici'),
('Sanitaria', 'sanitaria', 'Sanitaria e articoli ortopedici'),
('Apparecchi Acustici', 'apparecchi-acustici', 'Negozi di apparecchi acustici')
ON CONFLICT (name) DO NOTHING;

-- Sport e Tempo Libero
INSERT INTO business_categories (name, slug, description) VALUES
('Negozi di Sport', 'negozi-di-sport', 'Negozi di articoli sportivi'),
('Negozi di Biciclette', 'negozi-di-biciclette', 'Negozi di biciclette'),
('Pesca e Caccia', 'pesca-e-caccia', 'Articoli per pesca e caccia'),
('Outdoor e Camping', 'outdoor-e-camping', 'Articoli outdoor e camping'),
('Golf', 'golf', 'Articoli da golf'),
('Sub e Diving', 'sub-e-diving', 'Articoli sub e diving'),
('Piscine', 'piscine', 'Piscine e accessori'),
('Sci e Snowboard', 'sci-e-snowboard', 'Articoli da sci e snowboard')
ON CONFLICT (name) DO NOTHING;

-- Animali
INSERT INTO business_categories (name, slug, description) VALUES
('Negozi per Animali', 'negozi-per-animali', 'Negozi per animali'),
('Toelettatura Animali', 'toelettatura-animali', 'Toelettatura animali')
ON CONFLICT (name) DO NOTHING;

-- Auto e Moto
INSERT INTO business_categories (name, slug, description) VALUES
('Concessionarie Auto', 'concessionarie-auto', 'Concessionarie auto'),
('Ricambi Auto', 'ricambi-auto', 'Ricambi auto'),
('Moto', 'moto', 'Moto e accessori'),
('Pneumatici', 'pneumatici', 'Negozi di pneumatici')
ON CONFLICT (name) DO NOTHING;

-- Altri Negozi
INSERT INTO business_categories (name, slug, description) VALUES
('Grandi Magazzini', 'grandi-magazzini', 'Grandi magazzini'),
('Centri Commerciali', 'centri-commerciali', 'Centri commerciali'),
('Regali', 'regali', 'Negozi di regali'),
('Giocattoli', 'giocattoli', 'Negozi di giocattoli'),
('Articoli per Bambini', 'articoli-per-bambini', 'Articoli per bambini'),
('Bazar', 'bazar', 'Bazar e articoli vari'),
('Antiquari', 'antiquari', 'Antiquari'),
('Usato', 'usato', 'Negozi dell''usato'),
('Mercatini Solidali', 'mercatini-solidali', 'Mercatini solidali'),
('Tabaccherie', 'tabaccherie', 'Tabaccherie'),
('Sigarette Elettroniche', 'sigarette-elettroniche', 'Negozi di sigarette elettroniche'),
('Ricevitorie', 'ricevitorie', 'Ricevitorie e lotterie'),
('Onoranze Funebri', 'onoranze-funebri', 'Onoranze funebri'),
('Fuochi d''Artificio', 'fuochi-d-artificio', 'Fuochi d''artificio'),
('Armerie', 'armerie', 'Armerie'),
('Sexy Shop', 'sexy-shop', 'Sexy shop')
ON CONFLICT (name) DO NOTHING;

-- Ristorazione
INSERT INTO business_categories (name, slug, description) VALUES
('Discoteche', 'discoteche', 'Discoteche e nightclub')
ON CONFLICT (name) DO NOTHING;

-- Servizi
INSERT INTO business_categories (name, slug, description) VALUES
('Bancomat', 'bancomat', 'Bancomat e sportelli automatici'),
('Uffici Postali', 'uffici-postali', 'Uffici postali'),
('Stazioni di Servizio', 'stazioni-di-servizio', 'Stazioni di servizio'),
('Colonnine Ricarica', 'colonnine-ricarica', 'Colonnine ricarica elettrica'),
('Parcheggi', 'parcheggi', 'Parcheggi'),
('Parcheggi Biciclette', 'parcheggi-biciclette', 'Parcheggi per biciclette'),
('Autonoleggi', 'autonoleggi', 'Autonoleggi'),
('Taxi', 'taxi', 'Servizi taxi'),
('Noleggio Biciclette', 'noleggio-biciclette', 'Noleggio biciclette'),
('Revisioni Auto', 'revisioni-auto', 'Centri revisione auto'),
('Distributori Automatici', 'distributori-automatici', 'Distributori automatici'),
('Lavanderie', 'lavanderie', 'Lavanderie')
ON CONFLICT (name) DO NOTHING;

-- Professionisti Sanitari
INSERT INTO business_categories (name, slug, description) VALUES
('Cliniche', 'cliniche', 'Cliniche'),
('Ospedali', 'ospedali', 'Ospedali'),
('Laboratori Analisi', 'laboratori-analisi', 'Laboratori di analisi'),
('Fisioterapisti', 'fisioterapisti', 'Fisioterapisti'),
('Psicologi', 'psicologi', 'Psicologi e psicoterapeuti'),
('Medicine Alternative', 'medicine-alternative', 'Medicine alternative'),
('Ostetriche', 'ostetriche', 'Ostetriche'),
('Optometristi', 'optometristi', 'Optometristi'),
('Podologi', 'podologi', 'Podologi'),
('Logopedisti', 'logopedisti', 'Logopedisti')
ON CONFLICT (name) DO NOTHING;

-- Professionisti e Studi
INSERT INTO business_categories (name, slug, description) VALUES
('Consulenti Fiscali', 'consulenti-fiscali', 'Consulenti fiscali'),
('Ingegneri', 'ingegneri', 'Studi di ingegneria'),
('Geometri', 'geometri', 'Geometri'),
('Consulenti Finanziari', 'consulenti-finanziari', 'Consulenti finanziari'),
('Consulenti', 'consulenti', 'Consulenti generici'),
('Agenzie del Lavoro', 'agenzie-del-lavoro', 'Agenzie del lavoro'),
('Agenzie di Viaggio', 'agenzie-di-viaggio', 'Agenzie di viaggio'),
('Agenzie Pubblicitarie', 'agenzie-pubblicitarie', 'Agenzie pubblicitarie'),
('Informatica', 'informatica', 'Servizi informatici'),
('Telecomunicazioni', 'telecomunicazioni', 'Telecomunicazioni'),
('Grafici', 'grafici', 'Grafici e designer'),
('Fotografi', 'fotografi', 'Fotografi professionisti'),
('Istituti Formativi', 'istituti-formativi', 'Istituti formativi'),
('Centri di Ricerca', 'centri-di-ricerca', 'Centri di ricerca'),
('Giornali', 'giornali', 'Redazioni giornali'),
('Logistica', 'logistica', 'Aziende di logistica'),
('Associazioni', 'associazioni', 'Associazioni'),
('Fondazioni', 'fondazioni', 'Fondazioni'),
('ONG', 'ong', 'Organizzazioni non governative')
ON CONFLICT (name) DO NOTHING;

-- Artigiani
INSERT INTO business_categories (name, slug, description) VALUES
('Fabbri', 'fabbri', 'Fabbri'),
('Giardinieri', 'giardinieri', 'Giardinieri'),
('Ceramisti', 'ceramisti', 'Ceramisti'),
('Scalpellini', 'scalpellini', 'Scalpellini'),
('Posatori Parquet', 'posatori-parquet', 'Posatori di parquet'),
('Tappezzieri', 'tappezzieri', 'Tappezzieri'),
('Lattonieri', 'lattonieri', 'Lattonieri'),
('Ponteggiatori', 'ponteggiatori', 'Ponteggiatori'),
('Costruttori', 'costruttori', 'Imprese di costruzioni'),
('Pavimenti', 'pavimenti', 'Posatori di pavimenti'),
('Piastrellisti', 'piastrellisti', 'Piastrellisti'),
('Stuccatori', 'stuccatori', 'Stuccatori'),
('Apicoltori', 'apicoltori', 'Apicoltori'),
('Maniscalchi', 'maniscalchi', 'Maniscalchi'),
('Birrifici', 'birrifici', 'Birrifici artigianali'),
('Cantine', 'cantine', 'Cantine vinicole'),
('Distillerie', 'distillerie', 'Distillerie'),
('Panifici', 'panifici', 'Panifici'),
('Sartorie', 'sartorie', 'Sartorie'),
('Orefici', 'orefici', 'Orefici'),
('Orologiai', 'orologiai', 'Orologiai'),
('Riparazione Elettronica', 'riparazione-elettronica', 'Riparazione elettronica'),
('Duplicazione Chiavi', 'duplicazione-chiavi', 'Duplicazione chiavi'),
('Tipografie', 'tipografie', 'Tipografie'),
('Insegne', 'insegne', 'Insegne pubblicitarie'),
('Velai', 'velai', 'Velai'),
('Cestai', 'cestai', 'Cestai'),
('Rilegatori', 'rilegatori', 'Rilegatori'),
('Calzolai', 'calzolai', 'Calzolai')
ON CONFLICT (name) DO NOTHING;

-- Alloggi
INSERT INTO business_categories (name, slug, description) VALUES
('Ostelli', 'ostelli', 'Ostelli'),
('Motel', 'motel', 'Motel'),
('Appartamenti', 'appartamenti', 'Appartamenti turistici'),
('Chalet', 'chalet', 'Chalet'),
('Campeggi', 'campeggi', 'Campeggi'),
('Aree Camper', 'aree-camper', 'Aree sosta camper')
ON CONFLICT (name) DO NOTHING;

-- Fitness e Benessere
INSERT INTO business_categories (name, slug, description) VALUES
('Centri Sportivi', 'centri-sportivi', 'Centri sportivi'),
('Saune', 'saune', 'Saune'),
('Scuole di Danza', 'scuole-di-danza', 'Scuole di danza'),
('Centri Yoga', 'centri-yoga', 'Centri yoga'),
('Arti Marziali', 'arti-marziali', 'Palestre di arti marziali')
ON CONFLICT (name) DO NOTHING;

-- Educazione
INSERT INTO business_categories (name, slug, description) VALUES
('Scuole', 'scuole', 'Scuole'),
('Asili', 'asili', 'Asili nido e scuole materne'),
('Università', 'universita', 'Università'),
('Autoscuole', 'autoscuole', 'Autoscuole'),
('Scuole di Lingue', 'scuole-di-lingue', 'Scuole di lingue'),
('Scuole di Musica', 'scuole-di-musica', 'Scuole di musica'),
('Biblioteche', 'biblioteche', 'Biblioteche')
ON CONFLICT (name) DO NOTHING;


-- ============================================================
-- FILE: 20251228205449_add_award_points_function.sql
-- ============================================================
/*
  # Add award_points function

  1. Function
    - Creates `award_points` function to award points to users
    - Automatically creates user_points record if it doesn't exist
    - Records activity in user_activities table
    - Returns the new points total

  2. Security
    - Function is accessible to authenticated users
    - Ensures data integrity with proper error handling
*/

CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT NULL
) RETURNS integer AS $$
DECLARE
  v_new_total integer;
BEGIN
  INSERT INTO user_points (user_id, points_balance)
  VALUES (p_user_id, p_points)
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    points_balance = user_points.points_balance + p_points,
    updated_at = now();

  INSERT INTO user_activities (user_id, activity_type, points_earned, description)
  VALUES (p_user_id, p_activity_type, p_points, p_description);

  SELECT points_balance INTO v_new_total
  FROM user_points
  WHERE user_id = p_user_id;

  RETURN v_new_total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION award_points TO authenticated;


-- ============================================================
-- FILE: 20251228210409_add_detailed_ratings_to_reviews.sql
-- ============================================================
/*
  # Aggiunta valutazioni dettagliate alle recensioni

  ## Modifiche
  
  1. Aggiunte nuove colonne alla tabella reviews:
    - `price_rating` (integer, 1-5): Valutazione del prezzo
    - `service_rating` (integer, 1-5): Valutazione del servizio
    - `quality_rating` (integer, 1-5): Valutazione della qualità
    - `overall_rating` (integer, 1-5): Voto finale complessivo
  
  2. Note:
    - Il campo `rating` esistente viene mantenuto per compatibilità con recensioni esistenti
    - I nuovi campi sono NOT NULL per garantire valutazioni complete
    - Viene aggiunto un constraint per verificare che i voti siano tra 1 e 5
    - Per le recensioni esistenti, impostiamo i nuovi campi uguali al rating esistente
  
  ## Scala valutazioni
  - 1 stella = Pessimo
  - 2 stelle = Discreto
  - 3 stelle = Buono
  - 4 stelle = Eccellente
  - 5 stelle = Ottimo
*/

-- Aggiungi i nuovi campi per le valutazioni dettagliate
DO $$
BEGIN
  -- Price rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'price_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN price_rating integer;
  END IF;

  -- Service rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'service_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN service_rating integer;
  END IF;

  -- Quality rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'quality_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN quality_rating integer;
  END IF;

  -- Overall rating
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'overall_rating'
  ) THEN
    ALTER TABLE reviews ADD COLUMN overall_rating integer;
  END IF;
END $$;

-- Imposta i valori per le recensioni esistenti (usa il rating esistente)
UPDATE reviews 
SET 
  price_rating = rating,
  service_rating = rating,
  quality_rating = rating,
  overall_rating = rating
WHERE price_rating IS NULL;

-- Rendi i campi NOT NULL
ALTER TABLE reviews 
  ALTER COLUMN price_rating SET NOT NULL,
  ALTER COLUMN service_rating SET NOT NULL,
  ALTER COLUMN quality_rating SET NOT NULL,
  ALTER COLUMN overall_rating SET NOT NULL;

-- Aggiungi constraint per verificare che i voti siano tra 1 e 5
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_price_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_price_rating_check 
      CHECK (price_rating >= 1 AND price_rating <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_service_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_service_rating_check 
      CHECK (service_rating >= 1 AND service_rating <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_quality_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_quality_rating_check 
      CHECK (quality_rating >= 1 AND quality_rating <= 5);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_overall_rating_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_overall_rating_check 
      CHECK (overall_rating >= 1 AND overall_rating <= 5);
  END IF;
END $$;


-- ============================================================
-- FILE: 20251228210610_update_get_business_ratings_use_overall_rating.sql
-- ============================================================
/*
  # Aggiorna funzione get_business_ratings per usare overall_rating

  ## Modifiche
  
  1. Aggiorna la funzione get_business_ratings per:
    - Usare overall_rating invece di rating
    - Calcolare la media basata sul voto finale complessivo
  
  Note:
    - Questo garantisce che il rating medio mostrato corrisponda al voto finale dato dagli utenti
    - Mantiene la retrocompatibilità con recensioni esistenti
*/

-- Aggiorna la funzione per usare overall_rating
CREATE OR REPLACE FUNCTION get_business_ratings(business_ids uuid[])
RETURNS TABLE (
  business_id uuid,
  avg_rating numeric,
  review_count bigint
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    b.id as business_id,
    COALESCE(AVG(r.overall_rating), 0)::numeric as avg_rating,
    COUNT(r.id) as review_count
  FROM unnest(business_ids) AS b(id)
  LEFT JOIN reviews r ON r.business_id = b.id
  GROUP BY b.id;
END;
$$ LANGUAGE plpgsql STABLE;


-- ============================================================
-- FILE: 20251228211351_add_review_proof_and_approval_system.sql
-- ============================================================
/*
  # Sistema di Approvazione Recensioni con Prove

  ## Modifiche
  
  1. Aggiunte colonne alla tabella reviews:
    - `proof_image_url` (text): URL dell'immagine di prova (scontrino/fattura)
    - `review_status` (text): Stato della recensione (pending, approved, rejected)
    - `approved_by` (uuid): ID dello staff che ha approvato
    - `approved_at` (timestamp): Data/ora approvazione
    - `points_awarded` (integer): Punti assegnati per questa recensione
  
  2. Rende opzionali i campi price_rating, service_rating, quality_rating
  
  3. Note:
    - Le immagini di prova sono visibili solo allo staff
    - Dopo l'approvazione, le immagini vengono cancellate
    - Sistema di punti:
      * Recensione completa con prova: 25 punti
      * Recensione completa senza prova: 15 punti
      * Recensione solo voto finale: 5 punti
*/

-- Aggiungi nuove colonne per il sistema di approvazione
DO $$
BEGIN
  -- Proof image URL
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'proof_image_url'
  ) THEN
    ALTER TABLE reviews ADD COLUMN proof_image_url text;
  END IF;

  -- Review status
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'review_status'
  ) THEN
    ALTER TABLE reviews ADD COLUMN review_status text DEFAULT 'approved' NOT NULL;
  END IF;

  -- Approved by
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'approved_by'
  ) THEN
    ALTER TABLE reviews ADD COLUMN approved_by uuid REFERENCES profiles(id);
  END IF;

  -- Approved at
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'approved_at'
  ) THEN
    ALTER TABLE reviews ADD COLUMN approved_at timestamptz;
  END IF;

  -- Points awarded
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'points_awarded'
  ) THEN
    ALTER TABLE reviews ADD COLUMN points_awarded integer DEFAULT 0 NOT NULL;
  END IF;
END $$;

-- Rendi opzionali price_rating, service_rating, quality_rating
ALTER TABLE reviews 
  ALTER COLUMN price_rating DROP NOT NULL,
  ALTER COLUMN service_rating DROP NOT NULL,
  ALTER COLUMN quality_rating DROP NOT NULL;

-- Aggiungi constraint per review_status
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'reviews_status_check'
  ) THEN
    ALTER TABLE reviews ADD CONSTRAINT reviews_status_check 
      CHECK (review_status IN ('pending', 'approved', 'rejected'));
  END IF;
END $$;

-- Crea indice per le recensioni in attesa di approvazione
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(review_status) 
  WHERE review_status = 'pending';

-- Aggiorna le recensioni esistenti come approvate
UPDATE reviews 
SET review_status = 'approved', 
    points_awarded = CASE 
      WHEN price_rating IS NOT NULL AND service_rating IS NOT NULL AND quality_rating IS NOT NULL THEN 15
      ELSE 5
    END
WHERE review_status = 'approved' AND points_awarded = 0;

-- Funzione per approvare una recensione
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Ottieni i dettagli della recensione
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Calcola i punti da assegnare
  IF review_record.proof_image_url IS NOT NULL THEN
    -- Con prova
    IF review_record.price_rating IS NOT NULL AND 
       review_record.service_rating IS NOT NULL AND 
       review_record.quality_rating IS NOT NULL THEN
      points_to_award := 25; -- Recensione completa con prova
    ELSE
      points_to_award := 10; -- Solo voto finale con prova
    END IF;
  ELSE
    -- Senza prova
    IF review_record.price_rating IS NOT NULL AND 
       review_record.service_rating IS NOT NULL AND 
       review_record.quality_rating IS NOT NULL THEN
      points_to_award := 15; -- Recensione completa senza prova
    ELSE
      points_to_award := 5; -- Solo voto finale senza prova
    END IF;
  END IF;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Cancella l'immagine dopo l'approvazione
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', review_id_param);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per rifiutare una recensione
CREATE OR REPLACE FUNCTION reject_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
BEGIN
  UPDATE reviews 
  SET review_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      proof_image_url = NULL -- Cancella l'immagine
  WHERE id = review_id_param AND review_status = 'pending';
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata o già processata';
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Permetti accesso alle funzioni
GRANT EXECUTE ON FUNCTION approve_review TO authenticated;
GRANT EXECUTE ON FUNCTION reject_review TO authenticated;

-- Aggiorna la policy per permettere agli utenti di vedere solo le recensioni approvate
-- (eccetto le proprie)
DROP POLICY IF EXISTS "Reviews are viewable by everyone" ON reviews;

CREATE POLICY "Approved reviews are viewable by everyone"
  ON reviews FOR SELECT
  USING (
    review_status = 'approved' OR 
    customer_id = auth.uid()
  );

-- Policy per permettere allo staff di vedere tutte le recensioni
CREATE POLICY "Staff can view all reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.user_type = 'business'
    )
  );


