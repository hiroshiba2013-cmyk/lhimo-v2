-- Add parent_id column for hierarchical categories
ALTER TABLE business_categories ADD COLUMN IF NOT EXISTS parent_id uuid REFERENCES business_categories(id) ON DELETE SET NULL;

-- Nullify all FK references before clearing categories
UPDATE businesses SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE job_postings SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE job_seekers SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE registered_business_locations SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE profiles SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE customer_family_members SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE unclaimed_business_locations SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE registered_businesses SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE classified_ads SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE imported_businesses SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE products SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE user_added_businesses SET category_id = NULL WHERE category_id IS NOT NULL;

-- Delete all existing categories
DELETE FROM business_categories;

-- Insert new hierarchical categories
DO $$
DECLARE
  pid uuid;
BEGIN

  -- 1. Artigiani
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Artigiani', 'artigiani') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Elettricista', 'elettricista', pid),
    ('Idraulico', 'idraulico', pid),
    ('Termoidraulico', 'termoidraulico', pid),
    ('Muratore', 'muratore', pid),
    ('Piastrellista', 'piastrellista', pid),
    ('Imbianchino', 'imbianchino', pid),
    ('Cartongessista', 'cartongessista', pid),
    ('Falegname', 'falegname', pid),
    ('Fabbro', 'fabbro', pid),
    ('Serramentista', 'serramentista', pid),
    ('Tettoista', 'tettoista', pid),
    ('Lattoniere', 'lattoniere', pid),
    ('Pavimentista', 'pavimentista', pid),
    ('Parquettista', 'parquettista', pid),
    ('Giardiniere', 'giardiniere', pid),
    ('Potatore', 'potatore', pid),
    ('Antennista', 'antennista', pid),
    ('Tecnico climatizzatori', 'tecnico-climatizzatori', pid),
    ('Installatore fotovoltaico', 'installatore-fotovoltaico', pid),
    ('Installatore allarmi', 'installatore-allarmi', pid);

  -- 2. Edilizia
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Edilizia', 'edilizia') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Impresa edile', 'impresa-edile', pid),
    ('Ristrutturazioni', 'ristrutturazioni', pid),
    ('Demolizioni', 'demolizioni', pid),
    ('Scavi', 'scavi', pid),
    ('Movimento terra', 'movimento-terra', pid),
    ('Ponteggi', 'ponteggi', pid),
    ('Impermeabilizzazioni', 'impermeabilizzazioni', pid),
    ('Restauro edifici', 'restauro-edifici', pid);

  -- 3. Casa e Servizi
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Casa e Servizi', 'casa-e-servizi') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Impresa di pulizie', 'impresa-di-pulizie', pid),
    ('Disinfestazione', 'disinfestazione', pid),
    ('Spurghi', 'spurghi', pid),
    ('Traslochi', 'traslochi', pid),
    ('Sgomberi', 'sgomberi', pid),
    ('Deposito mobili', 'deposito-mobili', pid),
    ('Lavanderia', 'lavanderia', pid),
    ('Sartoria', 'sartoria', pid),
    ('Calzolaio', 'calzolaio', pid),
    ('Duplicazione chiavi', 'duplicazione-chiavi', pid);

  -- 4. Automotive
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Automotive', 'automotive') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Officina meccanica', 'officina-meccanica', pid),
    ('Carrozzeria', 'carrozzeria', pid),
    ('Gommista', 'gommista', pid),
    ('Elettrauto', 'elettrauto', pid),
    ('Centro revisioni', 'centro-revisioni', pid),
    ('Soccorso stradale', 'soccorso-stradale', pid),
    ('Autolavaggio', 'autolavaggio', pid),
    ('Noleggio auto', 'noleggio-auto', pid),
    ('Noleggio furgoni', 'noleggio-furgoni', pid),
    ('Concessionaria', 'concessionaria', pid),
    ('Autoscuola', 'autoscuola', pid);

  -- 5. Studi Professionali
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Studi Professionali', 'studi-professionali') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Avvocato', 'avvocato', pid),
    ('Notaio', 'notaio', pid),
    ('Commercialista', 'commercialista', pid),
    ('Consulente del lavoro', 'consulente-del-lavoro', pid),
    ('Tributarista', 'tributarista', pid),
    ('Revisore contabile', 'revisore-contabile', pid);

  -- 6. Consulenza
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Consulenza', 'consulenza') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Business Consultant', 'business-consultant', pid),
    ('Consulente finanziario', 'consulente-finanziario', pid),
    ('Consulente assicurativo', 'consulente-assicurativo', pid),
    ('Consulente energetico', 'consulente-energetico', pid),
    ('Consulente ambientale', 'consulente-ambientale', pid),
    ('Consulente privacy', 'consulente-privacy', pid),
    ('Coach', 'coach', pid),
    ('Career Coach', 'career-coach', pid);

  -- 7. Salute
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Salute', 'salute') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Medico di base', 'medico-di-base', pid),
    ('Cardiologo', 'cardiologo', pid),
    ('Dermatologo', 'dermatologo', pid),
    ('Ortopedico', 'ortopedico', pid),
    ('Neurologo', 'neurologo', pid),
    ('Pediatra', 'pediatra', pid),
    ('Ginecologo', 'ginecologo', pid),
    ('Oculista', 'oculista', pid),
    ('Dentista', 'dentista', pid),
    ('Ortodontista', 'ortodontista', pid),
    ('Psicologo', 'psicologo', pid),
    ('Psicoterapeuta', 'psicoterapeuta', pid),
    ('Psichiatra', 'psichiatra', pid),
    ('Fisioterapista', 'fisioterapista', pid),
    ('Osteopata', 'osteopata', pid),
    ('Chiropratico', 'chiropratico', pid),
    ('Nutrizionista', 'nutrizionista', pid),
    ('Dietista', 'dietista', pid),
    ('Infermiere', 'infermiere', pid),
    ('Ostetrica', 'ostetrica', pid),
    ('Logopedista', 'logopedista', pid),
    ('Podologo', 'podologo', pid),
    ('Veterinario', 'veterinario', pid);

  -- 8. Benessere
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Benessere', 'benessere') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Parrucchiere', 'parrucchiere', pid),
    ('Barbiere', 'barbiere', pid),
    ('Estetista', 'estetista', pid),
    ('Nail Artist', 'nail-artist', pid),
    ('Make-up Artist', 'make-up-artist', pid),
    ('Massaggiatore', 'massaggiatore', pid),
    ('Tattoo Artist', 'tattoo-artist', pid),
    ('Piercer', 'piercer', pid),
    ('Centro benessere', 'centro-benessere', pid),
    ('Solarium', 'solarium', pid);

  -- 9. Animali
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Animali', 'animali') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Toelettatura', 'toelettatura', pid),
    ('Pensione animali', 'pensione-animali', pid),
    ('Addestratore', 'addestratore', pid),
    ('Dog Sitter', 'dog-sitter', pid),
    ('Pet Sitter', 'pet-sitter', pid),
    ('Negozio animali', 'negozio-animali', pid);

  -- 10. Ristorazione
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Ristorazione', 'ristorazione') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Ristorante', 'ristorante', pid),
    ('Pizzeria', 'pizzeria', pid),
    ('Bar', 'bar', pid),
    ('Pub', 'pub', pid),
    ('Gelateria', 'gelateria', pid),
    ('Pasticceria', 'pasticceria', pid),
    ('Panificio', 'panificio', pid),
    ('Gastronomia', 'gastronomia', pid),
    ('Catering', 'catering', pid),
    ('Street Food', 'street-food', pid);

  -- 11. Turismo
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Turismo', 'turismo') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Hotel', 'hotel', pid),
    ('B&B', 'b-b', pid),
    ('Agriturismo', 'agriturismo', pid),
    ('Campeggio', 'campeggio', pid),
    ('Resort', 'resort', pid),
    ('Villaggio turistico', 'villaggio-turistico', pid),
    ('Casa vacanze', 'casa-vacanze', pid),
    ('Ostello', 'ostello', pid),
    ('Agenzia viaggi', 'agenzia-viaggi', pid),
    ('Guida turistica', 'guida-turistica', pid);

  -- 12. Commercio
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Commercio', 'commercio') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Supermercato', 'supermercato', pid),
    ('Alimentari', 'alimentari', pid),
    ('Ferramenta', 'ferramenta', pid),
    ('Abbigliamento', 'abbigliamento', pid),
    ('Calzature', 'calzature', pid),
    ('Gioielleria', 'gioielleria', pid),
    ('Ottica', 'ottica', pid),
    ('Libreria', 'libreria', pid),
    ('Cartoleria', 'cartoleria', pid),
    ('Arredamento', 'arredamento', pid),
    ('Casalinghi', 'casalinghi', pid),
    ('Telefonia', 'telefonia', pid),
    ('Elettronica', 'elettronica', pid),
    ('Fiorista', 'fiorista', pid),
    ('Tabaccheria', 'tabaccheria', pid);

  -- 13. Informatica
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Informatica', 'informatica') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Web Developer', 'web-developer', pid),
    ('Software Developer', 'software-developer', pid),
    ('App Developer', 'app-developer', pid),
    ('Web Designer', 'web-designer', pid),
    ('UX/UI Designer', 'ux-ui-designer', pid),
    ('Sistemista', 'sistemista', pid),
    ('Cybersecurity', 'cybersecurity', pid),
    ('Assistenza informatica', 'assistenza-informatica', pid),
    ('Riparazione PC', 'riparazione-pc', pid),
    ('Riparazione smartphone', 'riparazione-smartphone', pid);

  -- 14. Marketing e Creator
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Marketing e Creator', 'marketing-e-creator') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Social Media Manager', 'social-media-manager', pid),
    ('SEO Specialist', 'seo-specialist', pid),
    ('Copywriter', 'copywriter', pid),
    ('Graphic Designer', 'graphic-designer', pid),
    ('Fotografo', 'fotografo', pid),
    ('Videomaker', 'videomaker', pid),
    ('Influencer', 'influencer', pid),
    ('Content Creator', 'content-creator', pid),
    ('YouTuber', 'youtuber', pid),
    ('TikToker', 'tiktoker', pid),
    ('Streamer', 'streamer', pid),
    ('Blogger', 'blogger', pid),
    ('Podcaster', 'podcaster', pid);

  -- 15. Industria
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Industria', 'industria') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Carpenteria', 'carpenteria', pid),
    ('Automazione industriale', 'automazione-industriale', pid),
    ('Robotica', 'robotica', pid),
    ('Lavorazioni CNC', 'lavorazioni-cnc', pid),
    ('Packaging', 'packaging', pid),
    ('Produzione alimentare', 'produzione-alimentare', pid),
    ('Manutenzione industriale', 'manutenzione-industriale', pid);

  -- 16. Trasporti
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Trasporti', 'trasporti') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Corriere', 'corriere', pid),
    ('Autotrasportatore', 'autotrasportatore', pid),
    ('Logistica', 'logistica', pid),
    ('Taxi', 'taxi', pid),
    ('NCC', 'ncc', pid),
    ('Trasporto persone', 'trasporto-persone', pid);

  -- 17. Agricoltura
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Agricoltura', 'agricoltura') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Azienda agricola', 'azienda-agricola', pid),
    ('Vivaio', 'vivaio', pid),
    ('Floricoltura', 'floricoltura', pid),
    ('Allevamento', 'allevamento', pid),
    ('Apicoltura', 'apicoltura', pid),
    ('Cantina', 'cantina', pid),
    ('Frantoio', 'frantoio', pid);

  -- 18. Energia
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Energia', 'energia') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Fornitore luce e gas', 'fornitore-luce-e-gas', pid),
    ('Installatore colonnine elettriche', 'installatore-colonnine-elettriche', pid),
    ('Energy Manager', 'energy-manager', pid),
    ('Comunità energetica', 'comunita-energetica', pid);

  -- 19. Finanza
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Finanza', 'finanza') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Banca', 'banca', pid),
    ('Assicurazione', 'assicurazione', pid),
    ('Agenzia pratiche auto', 'agenzia-pratiche-auto', pid),
    ('CAF', 'caf', pid),
    ('Patronato', 'patronato', pid),
    ('Agenzia finanziaria', 'agenzia-finanziaria', pid);

  -- 20. Immobiliare
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Immobiliare', 'immobiliare') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Agenzia immobiliare', 'agenzia-immobiliare', pid),
    ('Agente immobiliare', 'agente-immobiliare', pid),
    ('Architetto', 'architetto', pid),
    ('Ingegnere', 'ingegnere', pid),
    ('Geometra', 'geometra', pid),
    ('Interior Designer', 'interior-designer', pid),
    ('Home Stager', 'home-stager', pid),
    ('Amministratore condominiale', 'amministratore-condominiale', pid),
    ('Certificatore energetico', 'certificatore-energetico', pid);

  -- 21. Formazione
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Formazione', 'formazione') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Scuola', 'scuola', pid),
    ('Università', 'universita', pid),
    ('Autoscuola formazione', 'autoscuola-formazione', pid),
    ('Scuola lingue', 'scuola-lingue', pid),
    ('Tutor', 'tutor', pid),
    ('Ripetizioni', 'ripetizioni', pid),
    ('Formazione professionale', 'formazione-professionale', pid);

  -- 22. Arte e Spettacolo
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Arte e Spettacolo', 'arte-e-spettacolo') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Musicista', 'musicista', pid),
    ('Cantante', 'cantante', pid),
    ('DJ', 'dj', pid),
    ('Attore', 'attore', pid),
    ('Animatore', 'animatore', pid),
    ('Wedding Planner', 'wedding-planner', pid),
    ('Organizzatore eventi', 'organizzatore-eventi', pid),
    ('Fiorista eventi', 'fiorista-eventi', pid);

  -- 23. Gaming
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Gaming', 'gaming') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Sviluppatore videogiochi', 'sviluppatore-videogiochi', pid),
    ('Esports', 'esports', pid),
    ('Sala giochi', 'sala-giochi', pid),
    ('Negozio gaming', 'negozio-gaming', pid);

  -- 24. Media
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Media', 'media') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Radio', 'radio', pid),
    ('TV', 'tv', pid),
    ('Casa editrice', 'casa-editrice', pid),
    ('Tipografia', 'tipografia', pid),
    ('Agenzia pubblicitaria', 'agenzia-pubblicitaria', pid);

  -- 25. Ricerca
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Ricerca', 'ricerca') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Laboratorio analisi', 'laboratorio-analisi', pid),
    ('Laboratorio odontotecnico', 'laboratorio-odontotecnico', pid),
    ('Laboratorio chimico', 'laboratorio-chimico', pid),
    ('Centro ricerca', 'centro-ricerca', pid);

  -- 26. Infanzia
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Infanzia', 'infanzia') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Asilo nido', 'asilo-nido', pid),
    ('Baby Sitter', 'baby-sitter', pid),
    ('Ludoteca', 'ludoteca', pid),
    ('Educatore', 'educatore', pid),
    ('Centro estivo', 'centro-estivo', pid);

  -- 27. Assistenza
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Assistenza', 'assistenza') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Badante', 'badante', pid),
    ('OSS', 'oss', pid),
    ('Casa di riposo', 'casa-di-riposo', pid),
    ('Assistenza domiciliare', 'assistenza-domiciliare', pid);

  -- 28. Enti e Associazioni
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Enti e Associazioni', 'enti-e-associazioni') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Comune', 'comune', pid),
    ('Fondazione', 'fondazione', pid),
    ('ONLUS', 'onlus', pid),
    ('Associazione culturale', 'associazione-culturale', pid),
    ('Associazione sportiva', 'associazione-sportiva', pid);

  -- 29. Sport e Fitness
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Sport e Fitness', 'sport-e-fitness') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Palestra', 'palestra', pid),
    ('Personal Trainer', 'personal-trainer', pid),
    ('Piscina', 'piscina', pid),
    ('Yoga', 'yoga', pid),
    ('Pilates', 'pilates', pid),
    ('CrossFit', 'crossfit', pid),
    ('Scuola danza', 'scuola-danza', pid),
    ('Arti marziali', 'arti-marziali', pid);

  -- 30. Servizi Digitali
  INSERT INTO business_categories (id, name, slug) VALUES (gen_random_uuid(), 'Servizi Digitali', 'servizi-digitali') RETURNING id INTO pid;
  INSERT INTO business_categories (name, slug, parent_id) VALUES
    ('Hosting', 'hosting', pid),
    ('Cloud', 'cloud', pid),
    ('SaaS', 'saas', pid),
    ('Intelligenza Artificiale', 'intelligenza-artificiale', pid),
    ('Blockchain', 'blockchain', pid),
    ('Consulenza digitale', 'consulenza-digitale', pid),
    ('Sviluppo e-commerce', 'sviluppo-e-commerce', pid),
    ('Automazione processi', 'automazione-processi', pid);

END $$;
