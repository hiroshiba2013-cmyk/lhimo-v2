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
