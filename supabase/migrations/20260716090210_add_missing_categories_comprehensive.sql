-- ===================================================
-- COMMERCIO: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'commercio' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Farmacia', 'farmacia', cat_parent),
    ('Erboristeria', 'erboristeria', cat_parent),
    ('Profumeria', 'profumeria', cat_parent),
    ('Parafarmacia', 'parafarmacia', cat_parent),
    ('Enoteca', 'enoteca', cat_parent),
    ('Giocattoli', 'giocattoli', cat_parent),
    ('Articoli sportivi', 'articoli-sportivi', cat_parent),
    ('Pelletteria', 'pelletteria', cat_parent),
    ('Bricolage', 'bricolage', cat_parent),
    ('Orologeria', 'orologeria', cat_parent),
    ('Negozio biologico', 'negozio-biologico', cat_parent),
    ('Numismatica e collezionismo', 'numismatica-collezionismo', cat_parent),
    ('Giochi e videogiochi', 'giochi-videogiochi', cat_parent),
    ('Mercatino usato', 'mercatino-usato', cat_parent),
    ('Strumenti musicali', 'strumenti-musicali', cat_parent),
    ('Articoli religiosi', 'articoli-religiosi', cat_parent),
    ('Tessuti e stoffe', 'tessuti-stoffe', cat_parent),
    ('Armeria', 'armeria', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- SALUTE: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'salute' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Poliambulatorio', 'poliambulatorio', cat_parent),
    ('Ospedale / Clinica', 'ospedale-clinica', cat_parent),
    ('Radiologo', 'radiologo', cat_parent),
    ('Urologo', 'urologo', cat_parent),
    ('Oncologo', 'oncologo', cat_parent),
    ('Fisiatra', 'fisiatra', cat_parent),
    ('Endocrinologo', 'endocrinologo', cat_parent),
    ('Reumatologo', 'reumatologo', cat_parent),
    ('Allergologo', 'allergologo', cat_parent),
    ('Otorino', 'otorino', cat_parent),
    ('Chirurgo', 'chirurgo', cat_parent),
    ('Laboratorio analisi cliniche', 'laboratorio-analisi-cliniche', cat_parent),
    ('Estetica medica', 'estetica-medica', cat_parent),
    ('Centro riabilitazione', 'centro-riabilitazione', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- RISTORAZIONE: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'ristorazione' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Trattoria', 'trattoria', cat_parent),
    ('Osteria', 'osteria', cat_parent),
    ('Braceria / Steakhouse', 'braceria-steakhouse', cat_parent),
    ('Sushi', 'sushi', cat_parent),
    ('Kebab', 'kebab', cat_parent),
    ('Rosticceria', 'rosticceria', cat_parent),
    ('Piadineria', 'piadineria', cat_parent),
    ('Hamburgeria', 'hamburgeria', cat_parent),
    ('Enoteca / Wine bar', 'enoteca-wine-bar', cat_parent),
    ('Birreria', 'birreria', cat_parent),
    ('Cocktail bar', 'cocktail-bar', cat_parent),
    ('Cucina etnica', 'cucina-etnica', cat_parent),
    ('Macelleria con cucina', 'macelleria-con-cucina', cat_parent),
    ('Friggitoria', 'friggitoria', cat_parent),
    ('Crêperie', 'creperie', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- BENESSERE: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'benessere' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Centro depilazione laser', 'centro-depilazione-laser', cat_parent),
    ('Terme e Spa', 'terme-spa', cat_parent),
    ('Centro termale', 'centro-termale', cat_parent),
    ('Riflessologia', 'riflessologia', cat_parent),
    ('Agopuntura', 'agopuntura', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- ASSISTENZA: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'assistenza' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Assistenza disabili', 'assistenza-disabili', cat_parent),
    ('Centro diurno', 'centro-diurno', cat_parent),
    ('Hospice', 'hospice', cat_parent),
    ('Comunità terapeutica', 'comunita-terapeutica', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- FORMAZIONE: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'formazione' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Accademia', 'accademia', cat_parent),
    ('Scuola guida moto/camion', 'scuola-guida-moto-camion', cat_parent),
    ('Scuola musica', 'scuola-musica', cat_parent),
    ('Scuola arte', 'scuola-arte', cat_parent),
    ('Master e corsi online', 'master-corsi-online', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- ARTIGIANI: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'artigiani' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Saldatore', 'saldatore', cat_parent),
    ('Pittore decoratore', 'pittore-decoratore', cat_parent),
    ('Marmista', 'marmista', cat_parent),
    ('Vetraio', 'vetraio', cat_parent),
    ('Costruttore piscine', 'costruttore-piscine', cat_parent),
    ('Riparatore elettrodomestici', 'riparatore-elettrodomestici', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- AUTOMOTIVE: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'automotive' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Riparazione moto', 'riparazione-moto', cat_parent),
    ('Negozio moto', 'negozio-moto', cat_parent),
    ('Noleggio moto', 'noleggio-moto', cat_parent),
    ('Autodemolizione', 'autodemolizione', cat_parent),
    ('Preparazione veicoli', 'preparazione-veicoli', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- CASA E SERVIZI: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'casa-e-servizi' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Decorazione interni', 'decorazione-interni', cat_parent),
    ('Mobili su misura', 'mobili-su-misura', cat_parent),
    ('Gestione condominiale', 'gestione-condominiale', cat_parent),
    ('Mini storage / Box', 'mini-storage-box', cat_parent),
    ('Tintoria', 'tintoria', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- TURISMO: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'turismo' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Affittacamere', 'affittacamere', cat_parent),
    ('Albergo diffuso', 'albergo-diffuso', cat_parent),
    ('Locanda', 'locanda', cat_parent),
    ('Diving center', 'diving-center', cat_parent),
    ('Noleggio bici / e-bike', 'noleggio-bici-ebike', cat_parent),
    ('Tour operator', 'tour-operator', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- SPORT E FITNESS: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'sport-e-fitness' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Circolo tennis', 'circolo-tennis', cat_parent),
    ('Campo da golf', 'campo-golf', cat_parent),
    ('Maneggio', 'maneggio', cat_parent),
    ('Scuola sci', 'scuola-sci', cat_parent),
    ('Surf / Kitesurf', 'surf-kitesurf', cat_parent),
    ('Campo calcio a 5', 'campo-calcio-5', cat_parent),
    ('Pugilato / Boxe', 'pugilato-boxe', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- AGRICOLTURA: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'agricoltura' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Fattoria didattica', 'fattoria-didattica', cat_parent),
    ('Caseificio', 'caseificio', cat_parent),
    ('Ortofrutta', 'ortofrutta', cat_parent),
    ('Distilleria', 'distilleria', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- ENTI E ASSOCIAZIONI: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'enti-e-associazioni' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Cooperativa sociale', 'cooperativa-sociale', cat_parent),
    ('Proloco', 'proloco', cat_parent),
    ('Sindacato', 'sindacato', cat_parent),
    ('Confraternita / Parrocchia', 'confraternita-parrocchia', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ===================================================
-- FINANZA: aggiunte categorie mancanti
-- ===================================================
DO $$
DECLARE cat_parent uuid;
BEGIN
  SELECT id INTO cat_parent FROM business_categories WHERE slug = 'finanza' AND parent_id IS NULL;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Finanziaria / Prestiti', 'finanziaria-prestiti', cat_parent),
    ('Crypto / Investimenti', 'crypto-investimenti', cat_parent),
    ('Cambiavalute', 'cambiavalute', cat_parent)
  ON CONFLICT (slug) DO NOTHING;
END $$;
