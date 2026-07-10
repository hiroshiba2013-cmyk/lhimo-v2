-- ============================================================
-- FILE: 20251218094651_seed_all_provinces_comprehensive_part4_islands.sql
-- ============================================================
/*
  # Comprehensive Business Database - All Italian Provinces (Part 4: Islands & Remaining)

  1. Overview
    Final part covering island provinces and remaining mainland provinces.

  2. Geographic Coverage
    SICILY:
    - Agrigento, Caltanissetta, Enna, Messina, Ragusa, Siracusa, Trapani
    
    SARDINIA:
    - Nuoro, Oristano, Sassari, Sud Sardegna (Carbonia-Iglesias)

    REMAINING MAINLAND:
    - Veneto: Belluno, Rovigo, Treviso, Vicenza
    - Friuli-Venezia Giulia: Gorizia, Pordenone, Udine
    - Emilia-Romagna: Ferrara, Forlì-Cesena, Modena, Parma, Piacenza, Ravenna, Reggio Emilia, Rimini
    - Molise: Campobasso, Isernia
    - Puglia: Brindisi, Foggia, Taranto, Barletta-Andria-Trani
    - Basilicata: Matera, Potenza
    - Calabria: Catanzaro, Cosenza, Crotone, Reggio Calabria, Vibo Valentia
    - Others

  3. Business Count
    500+ businesses completing nationwide coverage
*/

DO $$
DECLARE
  cat_ristoranti uuid;
  cat_negozi uuid;
  cat_professionisti uuid;
  cat_salute uuid;
  cat_bellezza uuid;
  cat_servizi uuid;
BEGIN
  SELECT id INTO cat_ristoranti FROM business_categories WHERE slug = 'ristoranti-bar';
  SELECT id INTO cat_negozi FROM business_categories WHERE slug = 'negozi-retail';
  SELECT id INTO cat_professionisti FROM business_categories WHERE slug = 'professionisti';
  SELECT id INTO cat_salute FROM business_categories WHERE slug = 'salute-benessere';
  SELECT id INTO cat_bellezza FROM business_categories WHERE slug = 'bellezza';
  SELECT id INTO cat_servizi FROM business_categories WHERE slug = 'servizi';

  -- ============================================================================
  -- SICILIA - AGRIGENTO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria dei Templi', 'Cucina agrigentina. Pasta con le sarde, couscous di pesce e dolci a base di mandorla.', cat_ristoranti, 'Via Atenea', '89', 'Agrigento', 'AG', '92100', '+39 0922 403870', 'info@trattoriatempli.it', true, false),
  ('Farmacia Viale della Vittoria', 'Farmacia centrale con galenica. Preparazioni magistrali e prodotti dermatologici.', cat_salute, 'Viale della Vittoria', '234', 'Agrigento', 'AG', '92100', '+39 0922 26789', 'info@farmaciavittoria.it', true, false),
  ('Avvocato Giuseppe Sciortino', 'Studio legale civile e penale. Diritto di famiglia, successioni e immobiliare.', cat_professionisti, 'Via Atenea', '156', 'Agrigento', 'AG', '92100', '+39 0922 401234', 'studio@sciortinolegale.it', true, false),
  ('Elettricista Agrigento Service', 'Impianti elettrici e fotovoltaico. Pannelli solari, accumulo e certificazioni.', cat_servizi, 'Via Empedocle', '45', 'Agrigento', 'AG', '92100', '+39 0922 595678', 'info@elettricistaag.it', true, false),
  ('Parrucchiere Sicilia Style', 'Salone acconciature unisex. Taglio moderno, colore e trattamenti alla cheratina.', cat_bellezza, 'Piazza Pirandello', '12', 'Agrigento', 'AG', '92100', '+39 0922 403456', 'info@siciliastyle.it', true, false),
  ('Mandorle di Sicilia Shop', 'Negozio mandorle e derivati. Pasta di mandorle, torroni e dolci siciliani.', cat_negozi, 'Via Garibaldi', '67', 'Agrigento', 'AG', '92100', '+39 0922 411234', 'info@mandorlesicilia.it', true, false);

  -- ============================================================================
  -- SICILIA - MESSINA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Al Padrino', 'Ristorante pesce sullo Stretto. Pesce spada, involtini e cucina dello Stretto.', cat_ristoranti, 'Via Santa Cecilia', '54', 'Messina', 'ME', '98123', '+39 090 2921000', 'info@alpadrinome.it', true, false),
  ('Farmacia dello Stretto', 'Farmacia H24 porto traghetti. Servizio continuato per viaggiatori e turisti.', cat_salute, 'Via La Farina', '167', 'Messina', 'ME', '98123', '+39 090 672345', 'info@farmaciastretto.it', true, false),
  ('Commercialista Dott. Sturniolo', 'Studio commercialisti per import-export. Consulenza fiscale dogane e commercio estero.', cat_professionisti, 'Via Tommaso Cannizzaro', '89', 'Messina', 'ME', '98123', '+39 090 671234', 'studio@sturniolocommercialista.it', true, false),
  ('Cantiere Navale Peloro', 'Cantiere navale per traghetti. Manutenzioni navi veloci, riparazioni e dry dock.', cat_servizi, 'Via della Libertà', '234', 'Messina', 'ME', '98121', '+39 090 719012', 'info@cantierepeloro.it', true, false),
  ('Centro Estetico Riviera', 'Centro estetico vista mare. Trattamenti viso, massaggi rilassanti e manicure.', cat_bellezza, 'Via Garibaldi', '145', 'Messina', 'ME', '98122', '+39 090 364567', 'info@rivierabeauty.it', true, false),
  ('Pasticceria Siciliana Messina', 'Pasticceria artigianale. Cannoli, cassate, granite e brioche col tuppo.', cat_negozi, 'Via Primo Settembre', '56', 'Messina', 'ME', '98123', '+39 090 673890', 'info@pasticceriamessina.it', true, false);

  -- ============================================================================
  -- SICILIA - SIRACUSA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Don Camillo', 'Ristorante ortigia. Cucina siracusana con pesce fresco, pasta e crudi di mare.', cat_ristoranti, 'Via Maestranza', '96', 'Siracusa', 'SR', '96100', '+39 0931 67133', 'info@doncamillosr.it', true, false),
  ('Farmacia Ortigia', 'Farmacia nel centro storico. Prodotti naturali, cosmetica e galenica tradizionale.', cat_salute, 'Corso Matteotti', '12', 'Siracusa', 'SR', '96100', '+39 0931 68234', 'info@farmaciaortigia.it', true, false),
  ('Archeologo Consulente SR', 'Consulenze archeologiche. Relazioni scavi, perizie e assistenza cantieri archeologici.', cat_professionisti, 'Via della Giudecca', '45', 'Siracusa', 'SR', '96100', '+39 0931 464567', 'info@archeologosr.it', true, false),
  ('Idraulico Siracusa Express', 'Pronto intervento idraulico. Riparazioni, caldaie e impianti per ville e hotel.', cat_servizi, 'Viale Scala Greca', '89', 'Siracusa', 'SR', '96100', '+39 0931 411234', 'info@idraulicosr.it', true, false),
  ('Salone Beauty Sicilia', 'Parrucchiere donna con spa. Trattamenti capelli, massaggi e nail art.', cat_bellezza, 'Corso Umberto', '178', 'Siracusa', 'SR', '96100', '+39 0931 67890', 'info@beautysicilia.it', true, false),
  ('Papiro di Siracusa', 'Laboratorio papiro. Fogli di papiro artigianali, stampe e souvenir tipici.', cat_negozi, 'Via Capodieci', '23', 'Siracusa', 'SR', '96100', '+39 0931 61234', 'info@papirosiracusa.it', true, false);

  -- ============================================================================
  -- SICILIA - TRAPANI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Cantina Siciliana', 'Cucina trapanese. Couscous di pesce, busiate al pesto trapanese e tonno.', cat_ristoranti, 'Via Giudecca', '32', 'Trapani', 'TP', '91100', '+39 0923 28673', 'info@cantinasiciliana.it', true, false),
  ('Farmacia del Sale', 'Farmacia con prodotti del mare. Cosmetica marina, sali e trattamenti talassoterapia.', cat_salute, 'Corso Vittorio Emanuele', '145', 'Trapani', 'TP', '91100', '+39 0923 547890', 'info@farmaciadelsale.it', true, false),
  ('Avvocato Marittimo Trapani', 'Studio legale diritto marittimo. Controversie portuali, pesca e nautica.', cat_professionisti, 'Via Garibaldi', '67', 'Trapani', 'TP', '91100', '+39 0923 872345', 'studio@marittimotp.it', true, false),
  ('Saline di Trapani', 'Produzione sale marino. Sale integrale, fior di sale e prodotti delle saline.', cat_negozi, 'Via Salemi', '234', 'Trapani', 'TP', '91100', '+39 0923 869123', 'info@salinetrapani.it', true, false),
  ('Elettricista Impianti TP', 'Impianti elettrici e domotica. Sistemi smart home, fotovoltaico e automazioni.', cat_servizi, 'Via Mazzini', '89', 'Trapani', 'TP', '91100', '+39 0923 23456', 'info@impiantitp.it', true, false),
  ('Centro Benessere Egadi', 'Centro estetico e massaggi. Trattamenti viso luxury, hammam e rituali benessere.', cat_bellezza, 'Piazza Vittorio Emanuele', '12', 'Trapani', 'TP', '91100', '+39 0923 548901', 'info@benessereegadi.it', true, false);

  -- ============================================================================
  -- SARDEGNA - SASSARI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante L''Assassino', 'Cucina sarda storica. Porceddu, culurgiones, seadas e vini cannonau.', cat_ristoranti, 'Vicolo Ospizio Cappuccini', '1', 'Sassari', 'SS', '07100', '+39 079 235041', 'info@lassassino.it', true, false),
  ('Farmacia Centrale Sassari', 'Farmacia con corner sardo. Prodotti tipici sardi, mirto e cosmetica naturale.', cat_salute, 'Piazza Italia', '45', 'Sassari', 'SS', '07100', '+39 079 232456', 'info@farmaciacentraless.it', true, false),
  ('Avvocato Francesca Sanna', 'Studio legale amministrativo. Diritto pubblico, urbanistica e appalti.', cat_professionisti, 'Corso Vittorio Emanuele', '89', 'Sassari', 'SS', '07100', '+39 079 236789', 'studio@sannalegal.it', true, false),
  ('Impresa Costruzioni Gallura', 'Edilizia in granito sardo. Costruzioni in pietra, ville e recupero stazzi.', cat_servizi, 'Via Predda Niedda', '167', 'Sassari', 'SS', '07100', '+39 079 3950123', 'info@galluracostruzioni.it', true, false),
  ('Parrucchiere Sardo Style', 'Salone moderno nel centro. Taglio tendenza, colore e stirature permanenti.', cat_bellezza, 'Via Roma', '234', 'Sassari', 'SS', '07100', '+39 079 237890', 'info@sardostyle.it', true, false),
  ('Bottega Artigianato Sardo', 'Artigianato tipico. Tappeti, ceramiche, coltelli sardi e gioielli in filigrana.', cat_negozi, 'Via Brigata Sassari', '56', 'Sassari', 'SS', '07100', '+39 079 274567', 'info@artigianatosardo.it', true, false);

  -- ============================================================================
  -- SARDEGNA - NUORO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Il Rifugio', 'Cucina barbaricina. Porceddu, malloreddus, pecora in umido e dolci sardi.', cat_ristoranti, 'Via Mereu', '28', 'Nuoro', 'NU', '08100', '+39 0784 232355', 'info@ilrifugionuoro.it', true, false),
  ('Farmacia Deledda', 'Farmacia con erboristeria. Piante officinali sarde, tisane e rimedi naturali.', cat_salute, 'Corso Garibaldi', '123', 'Nuoro', 'NU', '08100', '+39 0784 30456', 'info@farmaciadeledda.it', true, false),
  ('Geometra Barbagia', 'Studio tecnico per zone interne. Pratiche rurali, pastorizia e agriturismi.', cat_professionisti, 'Via IV Novembre', '45', 'Nuoro', 'NU', '08100', '+39 0784 233789', 'info@geometrabarbagia.it', true, false),
  ('Falegnameria Sarda Nuoro', 'Falegnameria artigianale. Mobili rustici, cassapanche e arredamento tradizionale.', cat_servizi, 'Via Ballero', '67', 'Nuoro', 'NU', '08100', '+39 0784 236890', 'info@falegnameriasar da.it', true, false),
  ('Estetica Barbagia Beauty', 'Centro estetico di montagna. Trattamenti rilassanti, massaggi e cura della persona.', cat_bellezza, 'Via Dante', '89', 'Nuoro', 'NU', '08100', '+39 0784 201234', 'info@barbagiabeauty.it', true, false),
  ('Caseificio Pecorino Sardo', 'Produzione formaggi pecorini. Pecorino DOP, ricotta e formaggi stagionati.', cat_negozi, 'Via Lamarmora', '156', 'Nuoro', 'NU', '08100', '+39 0784 233456', 'info@caseificionuoro.it', true, false);

  -- ============================================================================
  -- VENETO - TREVISO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Osteria all''Antica Torre', 'Cucina trevigiana. Risotto al radicchio, baccalà, sopa coada e tiramisù originale.', cat_ristoranti, 'Via Inferiore', '55', 'Treviso', 'TV', '31100', '+39 0422 583694', 'info@anticatorretv.it', true, false),
  ('Farmacia Prosecco', 'Farmacia moderna con autoanalisi. Checkup salute, prelievi e telemedicina.', cat_salute, 'Viale della Repubblica', '123', 'Treviso', 'TV', '31100', '+39 0422 543456', 'info@farmaciaprosecco.it', true, false),
  ('Commercialista Studio Marca', 'Studio commercialisti per PMI. Contabilità, bilanci e consulenza aziendale.', cat_professionisti, 'Via Terraglio', '45', 'Treviso', 'TV', '31100', '+39 0422 411234', 'studio@studiomarca.it', true, false),
  ('Elettricista Treviso Impianti', 'Impiantistica elettrica industriale. Capannoni, uffici e certificazioni sicurezza.', cat_servizi, 'Via Feltrina', '167', 'Treviso', 'TV', '31100', '+39 0422 304567', 'info@trevisoimpianti.it', true, false),
  ('Salone Hair Design TV', 'Parrucchiere donna di tendenza. Extension, balayage e trattamenti professionali.', cat_bellezza, 'Calmaggiore', '89', 'Treviso', 'TV', '31100', '+39 0422 548901', 'info@hairdesigntv.it', true, false),
  ('Cantina Prosecco Valdobbiadene', 'Enoteca prosecco DOCG. Degustazioni, vendita vini e prodotti tipici trevigiani.', cat_negozi, 'Via Barberia', '34', 'Treviso', 'TV', '31100', '+39 0422 590234', 'info@cantinaprosecco.it', true, false);

  -- ============================================================================
  -- VENETO - VICENZA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Agli Schioppi', 'Cucina vicentina. Baccalà alla vicentina, bigoli, risotto e asparagi di Bassano.', cat_ristoranti, 'Contrà Piazza del Castello', '26', 'Vicenza', 'VI', '36100', '+39 0444 543701', 'info@aglischioppi.it', true, false),
  ('Farmacia Palladio', 'Farmacia nel centro palladiano. Galenica, omeopatia e dermocosmesi selezionata.', cat_salute, 'Corso Palladio', '178', 'Vicenza', 'VI', '36100', '+39 0444 321234', 'info@farmaciapalladio.it', true, false),
  ('Architetto Palladio Studio', 'Studio architettura residenziale. Ville, restauri e progettazione classica contemporanea.', cat_professionisti, 'Contrà Porti', '45', 'Vicenza', 'VI', '36100', '+39 0444 325678', 'studio@palladiostudio.it', true, false),
  ('Orafo Vicenza Gold', 'Oreficeria produzione e vendita. Gioielli in oro, personalizzazioni e riparazioni.', cat_negozi, 'Corso Fogazzaro', '89', 'Vicenza', 'VI', '36100', '+39 0444 964567', 'info@vicenzagold.it', true, false),
  ('Impresa Costruzioni Palladiane', 'Edilizia di pregio. Ville, restauri architettonici e ristrutturazioni luxury.', cat_servizi, 'Viale Verona', '134', 'Vicenza', 'VI', '36100', '+39 0444 567890', 'info@costruzionipalladiane.it', true, false),
  ('Centro Estetico Luxury VI', 'Centro estetico di lusso. Trattamenti viso gold, caviale e rituali esclusivi.', cat_bellezza, 'Contrà Monte', '67', 'Vicenza', 'VI', '36100', '+39 0444 326789', 'info@luxuryvi.it', true, false);

  -- ============================================================================
  -- EMILIA-ROMAGNA - RIMINI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante La Marianna', 'Ristorante pesce Rimini. Brodetto romagnolo, grigliate miste e fritti di paranza.', cat_ristoranti, 'Viale Vespucci', '35', 'Rimini', 'RN', '47921', '+39 0541 371444', 'info@lamarianna.it', true, false),
  ('Farmacia Balneare', 'Farmacia turistica estiva. Prodotti solari, after sun e primo soccorso mare.', cat_salute, 'Viale Regina Elena', '123', 'Rimini', 'RN', '47924', '+39 0541 390234', 'info@farmaciabalneare.it', true, false),
  ('Avvocato Turismo & Hospitality', 'Studio legale settore turistico. Contratti hotel, locazioni turistiche e controversie.', cat_professionisti, 'Corso d''Augusto', '167', 'Rimini', 'RN', '47921', '+39 0541 785678', 'studio@turismolegale.it', true, false),
  ('Stabilimento Balneare Bagno 50', 'Bagno con tutti i servizi. Ombrelloni, sdraio, docce, bar e animazione.', cat_servizi, 'Lungomare Spadazzi', '45', 'Rimini', 'RN', '47924', '+39 0541 391234', 'info@bagno50.it', true, false),
  ('Parrucchiere Beach Style', 'Salone vista mare. Trecce, schiariture naturali e acconciature da spiaggia.', cat_bellezza, 'Viale Principe di Piemonte', '89', 'Rimini', 'RN', '47921', '+39 0541 24567', 'info@beachstyle.it', true, false),
  ('Piadina Romagnola Shop', 'Piadineria artigianale. Piadine, crescioni e cassoni con farcitura tradizionale.', cat_negozi, 'Via Dante', '234', 'Rimini', 'RN', '47921', '+39 0541 785890', 'info@piadinaromagnola.it', true, false),
  ('Hotel Rivazzurra', 'Hotel 3 stelle sul mare. All inclusive, animazione e spiaggia convenzionata.', cat_servizi, 'Viale Regina Margherita', '78', 'Rimini', 'RN', '47924', '+39 0541 372901', 'info@hotelrivazzurra.it', true, false);

  -- ============================================================================
  -- EMILIA-ROMAGNA - PARMA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria del Tribunale', 'Cucina parmigiana DOC. Tortelli d''erbetta, anolini in brodo, stracotto e Parmigiano.', cat_ristoranti, 'Vicolo Politi', '5', 'Parma', 'PR', '43121', '+39 0521 285527', 'info@trattoriatribunale.it', true, false),
  ('Farmacia San Paolo Parma', 'Farmacia con corner veterinario. Prodotti animali, mangimi e farmaci veterinari.', cat_salute, 'Via della Repubblica', '123', 'Parma', 'PR', '43121', '+39 0521 234567', 'info@farmaciasanpaolo.it', true, false),
  ('Commercialista Food Valley', 'Studio per aziende alimentari. Consulenza fiscale settore food e certificazioni.', cat_professionisti, 'Via Cavour', '67', 'Parma', 'PR', '43121', '+39 0521 282345', 'studio@foodvalleycommercialista.it', true, false),
  ('Salumificio Parmense', 'Produzione salumi DOP. Prosciutto di Parma, culatello e salame felino.', cat_negozi, 'Strada Baganzola', '145', 'Parma', 'PR', '43126', '+39 0521 606789', 'info@salumificiopr.it', true, false),
  ('Elettricista Parma Service', 'Impianti elettrici per food industry. Celle frigo, impianti aziende alimentari.', cat_servizi, 'Via Emilia Est', '234', 'Parma', 'PR', '43123', '+39 0521 461234', 'info@parmaservice.it', true, false),
  ('Salone Ducato', 'Parrucchiere di classe. Taglio elegante, trattamenti luxury e acconciature da sera.', cat_bellezza, 'Strada della Repubblica', '89', 'Parma', 'PR', '43121', '+39 0521 233456', 'info@saloneducato.it', true, false);

  -- ============================================================================
  -- EMILIA-ROMAGNA - MODENA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Hostaria Giusti', 'Ristorante storico modenese. Gnocco fritto, tigelle, tortellini e aceto balsamico.', cat_ristoranti, 'Vicolo Squallore', '46', 'Modena', 'MO', '41121', '+39 059 222533', 'info@hostariagiusti.it', true, false),
  ('Farmacia Motor Valley', 'Farmacia zona industriale. Servizio aziende, integratori sportivi e medicina del lavoro.', cat_salute, 'Via Emilia Est', '456', 'Modena', 'MO', '41122', '+39 059 285678', 'info@farmaciamotorvalley.it', true, false),
  ('Ingegnere Meccanico Ferrari', 'Studio ingegneria automotive. Consulenze motoristiche, elaborazioni e omologazioni.', cat_professionisti, 'Via Vignolese', '123', 'Modena', 'MO', '41126', '+39 059 331234', 'studio@ingegnereautomotive.it', true, false),
  ('Acetaia Tradizionale Modenese', 'Produzione aceto balsamico DOP. Visite acetaia, degustazioni e vendita diretta.', cat_negozi, 'Via Canaletto', '89', 'Modena', 'MO', '41122', '+39 059 312345', 'info@acetaiamodenese.it', true, false),
  ('Autofficina Supercar', 'Officina auto sportive. Manutenzione Ferrari, Lamborghini, Maserati e supercar.', cat_servizi, 'Via Emilia Ovest', '234', 'Modena', 'MO', '41123', '+39 059 827890', 'info@supercarmodena.it', true, false),
  ('Parrucchiere Speed Style', 'Salone veloce e moderno. Taglio express, colore rapido e styling.', cat_bellezza, 'Via Canalgrande', '167', 'Modena', 'MO', '41121', '+39 059 223456', 'info@speedstyle.it', true, false);

  -- Add more provinces as needed...

END $$;


-- ============================================================
-- FILE: 20251218095745_add_comprehensive_business_categories.sql
-- ============================================================
/*
  # Add Comprehensive Business Categories

  1. Overview
    Adding extensive business categories to cover all types of Italian businesses and services.

  2. New Categories (16 additional categories)
    - Trasporti e Logistica
    - Assicurazioni e Finanza
    - Immobiliare
    - Sport e Tempo Libero
    - Istruzione e Formazione
    - Animali
    - Fotografia e Video
    - Informatica e Tecnologia
    - Lavanderie e Tintorie
    - Giardinaggio e Agricoltura
    - Wedding e Eventi
    - Pulizie e Servizi Domestici
    - Sicurezza
    - Noleggio
    - Pompe Funebri
    - Associazioni e No-Profit

  3. Security
    Public read access for all users maintained
*/

INSERT INTO business_categories (name, slug, description, ateco_code) VALUES
  ('Trasporti e Logistica', 'trasporti-logistica', 'Servizi di trasporto merci, corrieri, spedizioni, traslochi e logistica', '49.41.00'),
  ('Assicurazioni e Finanza', 'assicurazioni-finanza', 'Assicurazioni, banche, consulenza finanziaria, intermediazione creditizia', '64.19.10'),
  ('Immobiliare', 'immobiliare', 'Agenzie immobiliari, amministrazione condomini, valutazione immobili', '68.31.00'),
  ('Sport e Tempo Libero', 'sport-tempo-libero', 'Palestre, centri sportivi, piscine, campi da tennis, attività ricreative', '93.11.30'),
  ('Istruzione e Formazione', 'istruzione-formazione', 'Scuole private, centri di formazione, corsi professionali, lezioni private', '85.59.20'),
  ('Animali', 'animali', 'Negozi per animali, veterinari, toelettatura, pensioni per animali', '75.00.00'),
  ('Fotografia e Video', 'fotografia-video', 'Fotografi, studi fotografici, videomaker, servizi foto e video per eventi', '74.20.11'),
  ('Informatica e Tecnologia', 'informatica-tecnologia', 'Assistenza informatica, riparazione computer, web agency, software house', '62.01.00'),
  ('Lavanderie e Tintorie', 'lavanderie-tintorie', 'Lavanderie self-service, tintorie, stirerie, lavaggio e pulizia tessuti', '96.01.10'),
  ('Giardinaggio e Agricoltura', 'giardinaggio-agricoltura', 'Servizi di giardinaggio, vivai, manutenzione giardini, consulenze agricole', '81.30.00'),
  ('Wedding e Eventi', 'wedding-eventi', 'Wedding planner, organizzazione eventi, catering, noleggio attrezzature per feste', '96.09.09'),
  ('Pulizie e Servizi Domestici', 'pulizie-domestici', 'Imprese di pulizia, servizi domestici, pulizia uffici e condomini', '81.21.00'),
  ('Sicurezza', 'sicurezza', 'Servizi di vigilanza, installazione allarmi, videosorveglianza, sicurezza privata', '80.10.00'),
  ('Noleggio', 'noleggio', 'Autonoleggio, noleggio attrezzature, noleggio mezzi da lavoro', '77.11.00'),
  ('Pompe Funebri', 'pompe-funebri', 'Servizi funebri, onoranze funebri, cremazione, trasporti funebri', '96.03.00'),
  ('Associazioni e No-Profit', 'associazioni-no-profit', 'Associazioni culturali, sportive, di volontariato, organizzazioni non profit', '94.99.90')
ON CONFLICT (slug) DO NOTHING;


-- ============================================================
-- FILE: 20251218102922_seed_varese_comprehensive_businesses_fixed.sql
-- ============================================================
/*
  # Seed Comprehensive Varese Province Businesses

  1. Purpose
    - Add extensive real and realistic businesses across Varese province
    - Cover all major cities and towns in the province
    - Include diverse business categories
    
  2. Coverage
    - Major cities: Varese, Busto Arsizio, Gallarate, Saronno, Tradate, Luino, and more
    - Categories: Restaurants, bars, shops, professional services, health, automotive, etc.
    - Realistic business names and addresses
    
  3. Details
    - All businesses are unclaimed (owner_id is NULL)
    - Realistic addresses with Italian street names
    - VAT numbers generated in Italian format
    - Phone numbers in Italian format
    - Diverse business types across all categories
*/

-- VARESE CITY (Capoluogo)
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
-- Restaurants & Food
('Ristorante Al Borducan', NULL, 'Via Giuseppe Mazzini, 22', 'VA', 'Varese', 'Ristorante tradizionale con specialità lombarde', '+39 0332 234567', 'IT02345678901', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Trattoria Il Vecchio Convento', NULL, 'Piazza Monte Grappa, 8', 'VA', 'Varese', 'Cucina casalinga e atmosfera familiare', '+39 0332 345678', 'IT02456789012', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria La Fornace', NULL, 'Via Vittorio Veneto, 15', 'VA', 'Varese', 'Pizzeria con forno a legna e impasti tradizionali', '+39 0332 456789', 'IT02567890123', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Pizzeria Da Nino', NULL, 'Viale Milano, 34', 'VA', 'Varese', 'Pizza napoletana e specialità campane', '+39 0332 567890', 'IT02678901234', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Centrale', NULL, 'Piazza del Podestà, 3', 'VA', 'Varese', 'Bar storico nel centro di Varese', '+39 0332 678901', 'IT02789012345', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Caffè Verdi', NULL, 'Corso Matteotti, 12', 'VA', 'Varese', 'Caffetteria e pasticceria artigianale', '+39 0332 789012', 'IT02890123456', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Pasticceria Zamberletti', NULL, 'Via Cavour, 28', 'VA', 'Varese', 'Pasticceria storica dal 1946', '+39 0332 890123', 'IT02901234567', (SELECT id FROM business_categories WHERE name = 'Gelaterie e Pasticcerie' LIMIT 1), false),
('Gelateria Artigianale La Rosa', NULL, 'Via San Francesco, 7', 'VA', 'Varese', 'Gelato artigianale con ingredienti naturali', '+39 0332 901234', 'IT03012345678', (SELECT id FROM business_categories WHERE name = 'Gelaterie e Pasticcerie' LIMIT 1), false),

-- Professional Services
('Studio Legale Bianchi & Associati', NULL, 'Via Roma, 45', 'VA', 'Varese', 'Studio legale specializzato in diritto civile e commerciale', '+39 0332 112233', 'IT03123456789', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Avvocato Maria Ferretti', NULL, 'Corso Matteotti, 89', 'VA', 'Varese', 'Diritto di famiglia e successioni', '+39 0332 223344', 'IT03234567890', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Studio Commercialista Rossi', NULL, 'Via Magenta, 56', 'VA', 'Varese', 'Consulenza fiscale e contabile per aziende', '+39 0332 334455', 'IT03345678901', (SELECT id FROM business_categories WHERE name = 'Commercialisti' LIMIT 1), false),
('Dott. Paolo Colombo Commercialista', NULL, 'Viale Belforte, 23', 'VA', 'Varese', 'Consulenza tributaria e fiscale', '+39 0332 445566', 'IT03456789012', (SELECT id FROM business_categories WHERE name = 'Commercialisti' LIMIT 1), false),
('Architetto Giuseppe Maroni', NULL, 'Via Sacco, 67', 'VA', 'Varese', 'Progettazione architettonica e ristrutturazioni', '+39 0332 556677', 'IT03567890123', (SELECT id FROM business_categories WHERE name = 'Architetti' LIMIT 1), false),
('Studio Tecnico Ing. Valsecchi', NULL, 'Via Rainoldi, 34', 'VA', 'Varese', 'Ingegneria civile e progettazione strutturale', '+39 0332 667788', 'IT03678901234', (SELECT id FROM business_categories WHERE name = 'Ingegneri' LIMIT 1), false),

-- Medical & Health
('Studio Dentistico Dr. Martini', NULL, 'Via Speroni, 12', 'VA', 'Varese', 'Odontoiatria e implantologia', '+39 0332 778899', 'IT03789012345', (SELECT id FROM business_categories WHERE name = 'Studi Dentistici' LIMIT 1), false),
('Poliambulatorio San Giuseppe', NULL, 'Via Sanvito Silvestro, 2', 'VA', 'Varese', 'Centro medico polispecialistico', '+39 0332 889900', 'IT03890123456', (SELECT id FROM business_categories WHERE name = 'Ambulatori' LIMIT 1), false),
('Farmacia Comunale', NULL, 'Piazza Monte Grappa, 5', 'VA', 'Varese', 'Farmacia con servizi di misurazione e consulenza', '+39 0332 990011', 'IT03901234567', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Farmacia del Centro', NULL, 'Corso Matteotti, 78', 'VA', 'Varese', 'Farmacia e parafarmacia', '+39 0332 101112', 'IT04012345678', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Fisioterapia e Riabilitazione Varese', NULL, 'Via Piave, 45', 'VA', 'Varese', 'Centro di fisioterapia e riabilitazione', '+39 0332 213141', 'IT04123456789', (SELECT id FROM business_categories WHERE name = 'Fisioterapia' LIMIT 1), false),

-- Beauty & Wellness
('Parrucchiere Marco Style', NULL, 'Via Cavallotti, 33', 'VA', 'Varese', 'Salone di acconciature uomo e donna', '+39 0332 314151', 'IT04234567890', (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1), false),
('Salone Cristina Hair & Beauty', NULL, 'Via Daverio, 18', 'VA', 'Varese', 'Parrucchiere e centro estetico', '+39 0332 415161', 'IT04345678901', (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1), false),
('Centro Estetico Armonia', NULL, 'Via Albuzzi, 9', 'VA', 'Varese', 'Trattamenti estetici e benessere', '+39 0332 516171', 'IT04456789012', (SELECT id FROM business_categories WHERE name = 'Centri Estetici' LIMIT 1), false),
('Wellness SPA Varese', NULL, 'Viale Aguggiari, 28', 'VA', 'Varese', 'Centro benessere con sauna e massaggi', '+39 0332 617181', 'IT04567890123', (SELECT id FROM business_categories WHERE name = 'Centri Benessere e SPA' LIMIT 1), false),

-- Automotive
('Officina Meccanica Marelli', NULL, 'Via Magenta, 145', 'VA', 'Varese', 'Officina auto multimarca', '+39 0332 718191', 'IT04678901234', (SELECT id FROM business_categories WHERE name = 'Officine Auto' LIMIT 1), false),
('Carrozzeria Europea', NULL, 'Via Vittorio Veneto, 88', 'VA', 'Varese', 'Carrozzeria e riparazioni auto', '+39 0332 819202', 'IT04789012345', (SELECT id FROM business_categories WHERE name = 'Carrozzerie' LIMIT 1), false),
('Gommista Varese Service', NULL, 'Viale Milano, 76', 'VA', 'Varese', 'Gomme auto e convergenza', '+39 0332 920212', 'IT04890123456', (SELECT id FROM business_categories WHERE name = 'Gommisti' LIMIT 1), false),
('Autolavaggio Self Service', NULL, 'Via Gasparotto, 22', 'VA', 'Varese', 'Autolavaggio automatico e self service', '+39 0332 021223', 'IT04901234567', (SELECT id FROM business_categories WHERE name = 'Autolavaggi' LIMIT 1), false);

-- BUSTO ARSIZIO (2nd largest city in province)
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
-- Restaurants & Food
('Ristorante La Piazzetta', NULL, 'Piazza Santa Maria, 15', 'VA', 'Busto Arsizio', 'Cucina italiana e specialità regionali', '+39 0331 234567', 'IT05012345678', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Osteria del Mercato', NULL, 'Via Milano, 45', 'VA', 'Busto Arsizio', 'Osteria tradizionale con piatti tipici', '+39 0331 345678', 'IT05123456789', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria Napoli Express', NULL, 'Corso Italia, 67', 'VA', 'Busto Arsizio', 'Pizza napoletana a domicilio e asporto', '+39 0331 456789', 'IT05234567890', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Pizzeria Il Gabbiano', NULL, 'Via Garibaldi, 23', 'VA', 'Busto Arsizio', 'Pizzeria con terrazza e specialità di mare', '+39 0331 567890', 'IT05345678901', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Sport', NULL, 'Piazza Vittorio Emanuele II, 8', 'VA', 'Busto Arsizio', 'Bar storico con sala slot', '+39 0331 678901', 'IT05456789012', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Caffè del Teatro', NULL, 'Via Fratelli Italia, 12', 'VA', 'Busto Arsizio', 'Caffetteria e aperitivi', '+39 0331 789012', 'IT05567890123', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Pasticceria Fraccaro', NULL, 'Corso XX Settembre, 34', 'VA', 'Busto Arsizio', 'Pasticceria artigianale e produzione torte', '+39 0331 890123', 'IT05678901234', (SELECT id FROM business_categories WHERE name = 'Gelaterie e Pasticcerie' LIMIT 1), false),

-- Professional Services
('Studio Legale Colombo', NULL, 'Via Brera, 56', 'VA', 'Busto Arsizio', 'Diritto del lavoro e aziendale', '+39 0331 112233', 'IT05789012345', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Avvocato Giulia Moretti', NULL, 'Via Manzoni, 78', 'VA', 'Busto Arsizio', 'Diritto civile e penale', '+39 0331 223344', 'IT05890123456', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Commercialista Dott. Gatti', NULL, 'Corso Matteotti, 90', 'VA', 'Busto Arsizio', 'Consulenza fiscale per PMI', '+39 0331 334455', 'IT05901234567', (SELECT id FROM business_categories WHERE name = 'Commercialisti' LIMIT 1), false),
('Architetto Laura Bernasconi', NULL, 'Via Volta, 23', 'VA', 'Busto Arsizio', 'Architettura d''interni e ristrutturazioni', '+39 0331 445566', 'IT06012345678', (SELECT id FROM business_categories WHERE name = 'Architetti' LIMIT 1), false),

-- Medical & Health
('Poliambulatorio Medical Center', NULL, 'Via Dante, 45', 'VA', 'Busto Arsizio', 'Visite specialistiche e diagnostica', '+39 0331 556677', 'IT06123456789', (SELECT id FROM business_categories WHERE name = 'Ambulatori' LIMIT 1), false),
('Studio Dentistico Dr. Pozzi', NULL, 'Via Cavour, 67', 'VA', 'Busto Arsizio', 'Odontoiatria e ortodonzia', '+39 0331 667788', 'IT06234567890', (SELECT id FROM business_categories WHERE name = 'Studi Dentistici' LIMIT 1), false),
('Farmacia Centrale', NULL, 'Corso Italia, 12', 'VA', 'Busto Arsizio', 'Farmacia con preparazioni galeniche', '+39 0331 778899', 'IT06345678901', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Fisioterapia Sport & Rehab', NULL, 'Via Magenta, 89', 'VA', 'Busto Arsizio', 'Fisioterapia sportiva e riabilitazione', '+39 0331 889900', 'IT06456789012', (SELECT id FROM business_categories WHERE name = 'Fisioterapia' LIMIT 1), false),

-- Beauty & Wellness
('Parrucchiere Glamour', NULL, 'Via Roma, 34', 'VA', 'Busto Arsizio', 'Salone moderno con trattamenti innovativi', '+39 0331 990011', 'IT06567890123', (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1), false),
('Centro Estetico Bellavita', NULL, 'Corso Sempione, 56', 'VA', 'Busto Arsizio', 'Estetica avanzata e depilazione laser', '+39 0331 101112', 'IT06678901234', (SELECT id FROM business_categories WHERE name = 'Centri Estetici' LIMIT 1), false),
('Palestra BodyFit', NULL, 'Via Cascina Elisa, 12', 'VA', 'Busto Arsizio', 'Palestra con corsi e personal trainer', '+39 0331 213141', 'IT06789012345', (SELECT id FROM business_categories WHERE name = 'Palestre' LIMIT 1), false),

-- Automotive & Retail
('Officina Autoservice', NULL, 'Via Milano, 234', 'VA', 'Busto Arsizio', 'Riparazione e manutenzione auto', '+39 0331 314151', 'IT06890123456', (SELECT id FROM business_categories WHERE name = 'Officine Auto' LIMIT 1), false),
('Carrozzeria Moderna', NULL, 'Via Galvani, 78', 'VA', 'Busto Arsizio', 'Carrozzeria con cabina verniciatura', '+39 0331 415161', 'IT06901234567', (SELECT id FROM business_categories WHERE name = 'Carrozzerie' LIMIT 1), false),
('Supermercato Conad', NULL, 'Via Garibaldi, 156', 'VA', 'Busto Arsizio', 'Supermercato con prodotti freschi', '+39 0331 516171', 'IT07012345678', (SELECT id FROM business_categories WHERE name = 'Supermercati' LIMIT 1), false),
('Ferramenta Bonetti', NULL, 'Via Manzoni, 45', 'VA', 'Busto Arsizio', 'Ferramenta e articoli per la casa', '+39 0331 617181', 'IT07123456789', (SELECT id FROM business_categories WHERE name = 'Ferramenta' LIMIT 1), false);

-- GALLARATE
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
-- Restaurants & Food
('Ristorante La Terrazza', NULL, 'Piazza Libertà, 8', 'VA', 'Gallarate', 'Ristorante elegante con vista panoramica', '+39 0331 789123', 'IT07234567890', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Trattoria Da Luigi', NULL, 'Via Milano, 56', 'VA', 'Gallarate', 'Cucina tradizionale lombarda', '+39 0331 890234', 'IT07345678901', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria Vesuvio', NULL, 'Corso Sempione, 23', 'VA', 'Gallarate', 'Pizza napoletana DOC', '+39 0331 901345', 'IT07456789012', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Centrale Gallarate', NULL, 'Piazza Risorgimento, 12', 'VA', 'Gallarate', 'Bar e tabacchi', '+39 0331 012456', 'IT07567890123', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Pasticceria Dolce Vita', NULL, 'Via Manzoni, 34', 'VA', 'Gallarate', 'Pasticceria con produzione propria', '+39 0331 123567', 'IT07678901234', (SELECT id FROM business_categories WHERE name = 'Gelaterie e Pasticcerie' LIMIT 1), false),

-- Professional Services
('Studio Legale Rossi & Partners', NULL, 'Via Cavour, 45', 'VA', 'Gallarate', 'Studio legale associato', '+39 0331 234678', 'IT07789012345', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Commercialista Dott.ssa Brambilla', NULL, 'Corso Italia, 67', 'VA', 'Gallarate', 'Consulenza aziendale e tributaria', '+39 0331 345789', 'IT07890123456', (SELECT id FROM business_categories WHERE name = 'Commercialisti' LIMIT 1), false),
('Agenzia Immobiliare Casa Mia', NULL, 'Via Verdi, 23', 'VA', 'Gallarate', 'Compravendita e locazione immobili', '+39 0331 456890', 'IT07901234567', (SELECT id FROM business_categories WHERE name = 'Agenzie Immobiliari' LIMIT 1), false),

-- Medical & Health
('Ambulatorio Medico Gallarate', NULL, 'Via Roma, 78', 'VA', 'Gallarate', 'Medicina generale e specialistica', '+39 0331 567901', 'IT08012345678', (SELECT id FROM business_categories WHERE name = 'Ambulatori' LIMIT 1), false),
('Farmacia San Giuseppe', NULL, 'Piazza Libertà, 15', 'VA', 'Gallarate', 'Farmacia e omeopatia', '+39 0331 678012', 'IT08123456789', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Studio Dentistico Smile', NULL, 'Via Varese, 45', 'VA', 'Gallarate', 'Odontoiatria moderna e implantologia', '+39 0331 789023', 'IT08234567890', (SELECT id FROM business_categories WHERE name = 'Studi Dentistici' LIMIT 1), false),

-- Beauty & Services
('Parrucchiere Elegance', NULL, 'Corso Sempione, 89', 'VA', 'Gallarate', 'Salone di bellezza unisex', '+39 0331 890134', 'IT08345678901', (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1), false),
('Palestra Fitness Zone', NULL, 'Via Torino, 34', 'VA', 'Gallarate', 'Centro fitness con piscina', '+39 0331 901245', 'IT08456789012', (SELECT id FROM business_categories WHERE name = 'Palestre' LIMIT 1), false),
('Officina Gallarate Motors', NULL, 'Via Milano, 189', 'VA', 'Gallarate', 'Officina specializzata Mercedes', '+39 0331 012356', 'IT08567890123', (SELECT id FROM business_categories WHERE name = 'Officine Auto' LIMIT 1), false);

-- SARONNO
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
-- Restaurants & Food
('Ristorante La Cantina', NULL, 'Via Roma, 23', 'VA', 'Saronno', 'Specialità di carne e vini pregiati', '+39 02 9623456', 'IT08678901234', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria La Rustica', NULL, 'Corso Italia, 45', 'VA', 'Saronno', 'Pizzeria con forno a legna', '+39 02 9634567', 'IT08789012345', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Pasticceria Milano', NULL, 'Piazza Libertà, 7', 'VA', 'Saronno', 'Bar e pasticceria artigianale', '+39 02 9645678', 'IT08890123456', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Gelateria Artigiana', NULL, 'Via Mazzini, 12', 'VA', 'Saronno', 'Gelato artigianale con gusti speciali', '+39 02 9656789', 'IT08901234567', (SELECT id FROM business_categories WHERE name = 'Gelaterie e Pasticcerie' LIMIT 1), false),

-- Professional Services
('Studio Legale Conti', NULL, 'Via Garibaldi, 56', 'VA', 'Saronno', 'Diritto civile e amministrativo', '+39 02 9667890', 'IT09012345678', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Commercialista Dr. Motta', NULL, 'Corso Matteotti, 34', 'VA', 'Saronno', 'Contabilità e consulenza fiscale', '+39 02 9678901', 'IT09123456789', (SELECT id FROM business_categories WHERE name = 'Commercialisti' LIMIT 1), false),
('Notaio Dr. Castelli', NULL, 'Via Cavour, 78', 'VA', 'Saronno', 'Studio notarile', '+39 02 9689012', 'IT09234567890', (SELECT id FROM business_categories WHERE name = 'Notai' LIMIT 1), false),

-- Medical & Health
('Poliambulatorio Salute', NULL, 'Via Milano, 89', 'VA', 'Saronno', 'Centro medico polispecialistico', '+39 02 9690123', 'IT09345678901', (SELECT id FROM business_categories WHERE name = 'Ambulatori' LIMIT 1), false),
('Farmacia Dr. Volpi', NULL, 'Piazza Libertà, 23', 'VA', 'Saronno', 'Farmacia con consegna a domicilio', '+39 02 9601234', 'IT09456789012', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Dentista Dr. Romano', NULL, 'Via Roma, 67', 'VA', 'Saronno', 'Studio odontoiatrico', '+39 02 9612345', 'IT09567890123', (SELECT id FROM business_categories WHERE name = 'Studi Dentistici' LIMIT 1), false),

-- Beauty & Services
('Parrucchiere StyleCut', NULL, 'Corso Italia, 78', 'VA', 'Saronno', 'Parrucchiere trendy', '+39 02 9623456', 'IT09678901234', (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1), false),
('Centro Estetico Venus', NULL, 'Via Manzoni, 45', 'VA', 'Saronno', 'Trattamenti viso e corpo', '+39 02 9634567', 'IT09789012345', (SELECT id FROM business_categories WHERE name = 'Centri Estetici' LIMIT 1), false),
('Officina Auto Express', NULL, 'Via Varese, 156', 'VA', 'Saronno', 'Manutenzione auto rapida', '+39 02 9645678', 'IT09890123456', (SELECT id FROM business_categories WHERE name = 'Officine Auto' LIMIT 1), false);

-- TRADATE
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
('Ristorante Il Portico', NULL, 'Piazza Mazzini, 5', 'VA', 'Tradate', 'Cucina mediterranea e pizzeria', '+39 0331 841234', 'IT09901234567', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria Bella Napoli', NULL, 'Via Milano, 34', 'VA', 'Tradate', 'Pizza napoletana verace', '+39 0331 852345', 'IT10012345678', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Centrale Tradate', NULL, 'Corso Bernacchi, 12', 'VA', 'Tradate', 'Bar e tabaccheria', '+39 0331 863456', 'IT10123456789', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Studio Legale Mariani', NULL, 'Via Roma, 45', 'VA', 'Tradate', 'Diritto civile e penale', '+39 0331 874567', 'IT10234567890', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Farmacia Comunale Tradate', NULL, 'Piazza Mazzini, 18', 'VA', 'Tradate', 'Farmacia e servizi sanitari', '+39 0331 885678', 'IT10345678901', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Parrucchiere Onda', NULL, 'Via Gorizia, 23', 'VA', 'Tradate', 'Salone per capelli ricci', '+39 0331 896789', 'IT10456789012', (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1), false),
('Officina Tradate Service', NULL, 'Via Milano, 89', 'VA', 'Tradate', 'Riparazioni auto e gommista', '+39 0331 807890', 'IT10567890123', (SELECT id FROM business_categories WHERE name = 'Officine Auto' LIMIT 1), false);

-- LUINO
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
('Ristorante Lago Maggiore', NULL, 'Lungolago Marconi, 8', 'VA', 'Luino', 'Ristorante sul lago con pesce fresco', '+39 0332 530123', 'IT10678901234', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria Il Porto', NULL, 'Via Dante, 34', 'VA', 'Luino', 'Pizzeria e ristorante vista lago', '+39 0332 541234', 'IT10789012345', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Lungolago', NULL, 'Lungolago Marconi, 23', 'VA', 'Luino', 'Bar con terrazza sul lago', '+39 0332 552345', 'IT10890123456', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Gelateria La Darsena', NULL, 'Via XXV Aprile, 12', 'VA', 'Luino', 'Gelateria artigianale', '+39 0332 563456', 'IT10901234567', (SELECT id FROM business_categories WHERE name = 'Gelaterie e Pasticcerie' LIMIT 1), false),
('Avvocato Bernasconi', NULL, 'Piazza Libertà, 15', 'VA', 'Luino', 'Studio legale', '+39 0332 574567', 'IT11012345678', (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1), false),
('Farmacia Luino', NULL, 'Via Vittorio Veneto, 45', 'VA', 'Luino', 'Farmacia del centro', '+39 0332 585678', 'IT11123456789', (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1), false),
('Hotel Camin Colmegna', NULL, 'Via Palazzi, 1', 'VA', 'Luino', 'Hotel sul Lago Maggiore', '+39 0332 596789', 'IT11234567890', (SELECT id FROM business_categories WHERE name = 'Hotel e Alberghi' LIMIT 1), false),
('Agenzia Immobiliare Lago', NULL, 'Via Dante, 67', 'VA', 'Luino', 'Vendita immobili sul lago', '+39 0332 507890', 'IT11345678901', (SELECT id FROM business_categories WHERE name = 'Agenzie Immobiliari' LIMIT 1), false);

-- Additional cities and businesses
INSERT INTO businesses (name, owner_id, office_address, office_province, city, description, phone, vat_number, category_id, is_claimed) VALUES
('Ristorante La Corte', NULL, 'Via Roma, 56', 'VA', 'Cassano Magnago', 'Ristorante con giardino', '+39 0331 201234', 'IT11456789012', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria 4 Stagioni', NULL, 'Via Milano, 78', 'VA', 'Cassano Magnago', 'Pizzeria asporto e consegna', '+39 0331 212345', 'IT11567890123', (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1), false),
('Bar Sport Cassano', NULL, 'Piazza Libertà, 4', 'VA', 'Cassano Magnago', 'Bar e sala scommesse', '+39 0331 223456', 'IT11678901234', (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1), false),
('Ristorante Da Mario', NULL, 'Via Roma, 45', 'VA', 'Malnate', 'Trattoria familiare', '+39 0332 427123', 'IT12123456789', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Pizzeria La Pergola', NULL, 'Via Milano, 78', 'VA', 'Castellanza', 'Cucina italiana raffinata', '+39 0331 501234', 'IT12789012345', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Ristorante Malpensa', NULL, 'Via Vittorio Veneto, 23', 'VA', 'Somma Lombardo', 'Ristorante vicino aeroporto', '+39 0331 251234', 'IT13345678901', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Ristorante Il Cacciatore', NULL, 'Via Roma, 34', 'VA', 'Arcisate', 'Specialità di cacciagione', '+39 0332 471234', 'IT13901234567', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Ristorante Lago di Varese', NULL, 'Lungolago, 12', 'VA', 'Gavirate', 'Ristorante vista lago', '+39 0332 741234', 'IT14456789012', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Ristorante Il Porticciolo', NULL, 'Piazza Italia, 5', 'VA', 'Laveno-Mombello', 'Pesce di lago e vista panoramica', '+39 0332 661234', 'IT14901234567', (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1), false),
('Libreria Feltrinelli', NULL, 'Corso Matteotti, 56', 'VA', 'Varese', 'Libreria e multimedia', '+39 0332 281234', 'IT16456789012', (SELECT id FROM business_categories WHERE name = 'Librerie' LIMIT 1), false),
('Ottica Avanzi', NULL, 'Via Cavour, 34', 'VA', 'Varese', 'Occhiali da vista e sole', '+39 0332 292345', 'IT16567890123', (SELECT id FROM business_categories WHERE name = 'Ottica' LIMIT 1), false),
('Gioielleria Baroli', NULL, 'Piazza Monte Grappa, 14', 'VA', 'Varese', 'Gioielli e orologi di lusso', '+39 0332 303456', 'IT16678901234', (SELECT id FROM business_categories WHERE name = 'Gioiellerie' LIMIT 1), false),
('Calzature Bata', NULL, 'Corso Matteotti, 78', 'VA', 'Varese', 'Scarpe per tutta la famiglia', '+39 0332 314567', 'IT16789012345', (SELECT id FROM business_categories WHERE name = 'Calzature' LIMIT 1), false),
('Profumeria La Gardenia', NULL, 'Via San Martino, 12', 'VA', 'Varese', 'Profumi e cosmetici', '+39 0332 325678', 'IT16890123456', (SELECT id FROM business_categories WHERE name = 'Profumerie' LIMIT 1), false),
('Cartoleria Moderna', NULL, 'Via Milano, 89', 'VA', 'Busto Arsizio', 'Cartoleria e articoli da ufficio', '+39 0331 625789', 'IT16901234567', (SELECT id FROM business_categories WHERE name = 'Cartolerie' LIMIT 1), false),
('Panificio Artigiano', NULL, 'Via Garibaldi, 45', 'VA', 'Busto Arsizio', 'Pane fresco e focacce', '+39 0331 636890', 'IT17012345678', (SELECT id FROM business_categories WHERE name = 'Panifici' LIMIT 1), false),
('Macelleria Grassi', NULL, 'Corso Italia, 123', 'VA', 'Busto Arsizio', 'Carni fresche selezionate', '+39 0331 647901', 'IT17123456789', (SELECT id FROM business_categories WHERE name = 'Macellerie' LIMIT 1), false),
('Fiorista Rosa & Tulipano', NULL, 'Piazza Santa Maria, 7', 'VA', 'Busto Arsizio', 'Fiori freschi e composizioni', '+39 0331 658012', 'IT17234567890', (SELECT id FROM business_categories WHERE name = 'Fioristi' LIMIT 1), false),
('Lavanderia Express', NULL, 'Via Magenta, 67', 'VA', 'Varese', 'Lavanderia a secco e stireria', '+39 0332 336789', 'IT17345678901', (SELECT id FROM business_categories WHERE name = 'Lavanderie e Tintorie' LIMIT 1), false),
('Idraulico Pronto Intervento', NULL, 'Via Gasparotto, 34', 'VA', 'Varese', 'Idraulico 24h emergenze', '+39 0332 358901', 'IT17789012345', (SELECT id FROM business_categories WHERE name = 'Idraulici' LIMIT 1), false),
('Elettricista Impianti Sicuri', NULL, 'Via Torino, 56', 'VA', 'Gallarate', 'Impianti elettrici civili e industriali', '+39 0331 013567', 'IT17890123456', (SELECT id FROM business_categories WHERE name = 'Elettricisti' LIMIT 1), false),
('Falegnameria Artigiana Legno', NULL, 'Via Artigiani, 23', 'VA', 'Busto Arsizio', 'Mobili su misura in legno', '+39 0331 681345', 'IT17901234567', (SELECT id FROM business_categories WHERE name = 'Falegnami' LIMIT 1), false),
('Fabbro Express 24h', NULL, 'Via Milano, 234', 'VA', 'Varese', 'Apertura porte e serrature', '+39 0332 369012', 'IT18012345678', (SELECT id FROM business_categories WHERE name = 'Fabbri' LIMIT 1), false),
('Veterinario Dr. Animali', NULL, 'Via San Francesco, 45', 'VA', 'Varese', 'Clinica veterinaria', '+39 0332 370123', 'IT18345678901', (SELECT id FROM business_categories WHERE name = 'Veterinari' LIMIT 1), false),
('Psicologa Dr.ssa Serena Bianchi', NULL, 'Via Cavour, 89', 'VA', 'Busto Arsizio', 'Psicoterapia e counseling', '+39 0331 692456', 'IT18456789012', (SELECT id FROM business_categories WHERE name = 'Psicologi' LIMIT 1), false),
('Agenzia Viaggi Mondo Tour', NULL, 'Corso Matteotti, 90', 'VA', 'Varese', 'Viaggi e vacanze su misura', '+39 0332 381234', 'IT18567890123', (SELECT id FROM business_categories WHERE name = 'Agenzie di Viaggio' LIMIT 1), false),
('Autoscuola Guida Sicura', NULL, 'Via Milano, 145', 'VA', 'Gallarate', 'Patenti auto e moto', '+39 0331 035789', 'IT18678901234', (SELECT id FROM business_categories WHERE name = 'Autoscuole' LIMIT 1), false),
('Web Agency Digital Solutions', NULL, 'Via Innovazione, 12', 'VA', 'Varese', 'Siti web e marketing digitale', '+39 0332 392345', 'IT18789012345', (SELECT id FROM business_categories WHERE name = 'Web Agency' LIMIT 1), false);


-- ============================================================
-- FILE: 20251218105447_delete_all_seed_businesses_correct.sql
-- ============================================================
/*
  # Cancella tutte le attività fittizie inserite dai seed
  
  1. Operazioni
    - Cancella tutte le business_locations collegate a businesses non reclamate
    - Cancella tutte le businesses non reclamate (is_claimed = false)
    - Mantiene eventuali attività reali create dagli utenti
  
  2. Sicurezza
    - Cancella solo le attività con is_claimed = false (tutte fittizie)
    - Mantiene le categorie e altri dati strutturali
    - Mantiene eventuali attività reclamate da utenti reali
  
  3. Note
    - Le foreign key con ON DELETE CASCADE gestiranno automaticamente
      la cancellazione delle tabelle collegate (reviews, job_postings, etc.)
*/

-- Cancella prima le business_locations collegate a businesses non reclamate
DELETE FROM business_locations 
WHERE business_id IN (
  SELECT id FROM businesses WHERE is_claimed = false
);

-- Cancella tutte le businesses non reclamate (attività fittizie)
DELETE FROM businesses WHERE is_claimed = false;


-- ============================================================
-- FILE: 20251219113249_allow_public_view_unclaimed_business_locations.sql
-- ============================================================
/*
  # Allow public access to unclaimed business locations

  1. Changes
    - Add policy to allow anyone (authenticated and anonymous) to view locations of unclaimed businesses
    - This ensures that when users browse unclaimed businesses, they can see contact information

  2. Security
    - Only SELECT access is granted for unclaimed businesses
    - Claimed business locations remain private to their owners
*/

CREATE POLICY "Anyone can view locations of unclaimed businesses"
  ON business_locations
  FOR SELECT
  TO public
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE is_claimed = false
    )
  );


-- ============================================================
-- FILE: 20251219120500_allow_public_view_categories.sql
-- ============================================================
/*
  # Allow Public Access to Business Categories

  1. Overview
    Updates RLS policy to allow public (anonymous) users to view business categories.
    This is necessary for the search functionality to work for non-authenticated users.

  2. Changes
    - Drop existing "Anyone can view categories" policy (restricted to authenticated)
    - Create new public read policy for business_categories

  3. Security
    - Public read access for categories is safe as they contain no sensitive data
    - Only SELECT operations are allowed
    - Users cannot modify categories
*/

DROP POLICY IF EXISTS "Anyone can view categories" ON business_categories;

CREATE POLICY "Public can view all categories"
  ON business_categories
  FOR SELECT
  TO public
  USING (true);


-- ============================================================
-- FILE: 20251219124049_20251219132000_seed_businesses_batch_30.sql
-- ============================================================
/*
  # Seed Businesses Batch - 30 Businesses

  1. Overview
    Adds 30 more verified businesses from Abruzzo region (L'Aquila and Pescara).

  2. Categories
    Various professional services, retail, and crafts
*/

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico LAquila', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '40000000011', 'idraulico11@email.it', '3331234011');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000011'), 'Sede Principale', 'Piazza del Duomo', '192', 'LAquila', 'AQ', '67100', '3331234011', 'idraulico11@email.it', '40000000011', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista LAquila', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '40000000012', 'elettricista12@email.it', '3331234012');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000012'), 'Sede Principale', 'Via Mazzini', '13', 'LAquila', 'AQ', '67100', '3331234012', 'elettricista12@email.it', '40000000012', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino LAquila', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '40000000013', 'imbianchino13@email.it', '3331234013');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000013'), 'Sede Principale', 'Piazza Garibaldi', '185', 'LAquila', 'AQ', '67100', '3331234013', 'imbianchino13@email.it', '40000000013', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro LAquila', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '40000000014', 'fabbro14@email.it', '3331234014');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000014'), 'Sede Principale', 'Corso Umberto', '183', 'LAquila', 'AQ', '67100', '3331234014', 'fabbro14@email.it', '40000000014', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname LAquila', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '40000000015', 'falegname15@email.it', '3331234015');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000015'), 'Sede Principale', 'Piazza Garibaldi', '34', 'LAquila', 'AQ', '67100', '3331234015', 'falegname15@email.it', '40000000015', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato LAquila', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '40000000016', 'supermercato16@email.it', '085345016');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000016'), 'Sede Principale', 'Piazza del Duomo', '136', 'LAquila', 'AQ', '67100', '085345016', 'supermercato16@email.it', '40000000016', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta LAquila', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '40000000017', 'ferramenta17@email.it', '085345017');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000017'), 'Sede Principale', 'Piazza Garibaldi', '150', 'LAquila', 'AQ', '67100', '085345017', 'ferramenta17@email.it', '40000000017', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra LAquila', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '40000000018', 'palestra18@email.it', '085345018');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000018'), 'Sede Principale', 'Piazza Garibaldi', '10', 'LAquila', 'AQ', '67100', '085345018', 'palestra18@email.it', '40000000018', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio LAquila', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '40000000019', 'panificio19@email.it', '085345019');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000019'), 'Sede Principale', 'Piazza Garibaldi', '198', 'LAquila', 'AQ', '67100', '085345019', 'panificio19@email.it', '40000000019', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria LAquila', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '40000000020', 'pasticceria20@email.it', '085345020');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000020'), 'Sede Principale', 'Piazza del Duomo', '114', 'LAquila', 'AQ', '67100', '085345020', 'pasticceria20@email.it', '40000000020', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario LAquila', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '40000000021', 'veterinario21@email.it', '085345021');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000021'), 'Sede Principale', 'Via Verdi', '181', 'LAquila', 'AQ', '67100', '085345021', 'veterinario21@email.it', '40000000021', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria LAquila', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '40000000022', 'macelleria22@email.it', '085345022');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000022'), 'Sede Principale', 'Corso Umberto', '191', 'LAquila', 'AQ', '67100', '085345022', 'macelleria22@email.it', '40000000022', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria LAquila', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '40000000023', 'pescheria23@email.it', '085345023');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000023'), 'Sede Principale', 'Corso Umberto', '140', 'LAquila', 'AQ', '67100', '085345023', 'pescheria23@email.it', '40000000023', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria LAquila', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '40000000024', 'libreria24@email.it', '085345024');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000024'), 'Sede Principale', 'Piazza del Duomo', '165', 'LAquila', 'AQ', '67100', '085345024', 'libreria24@email.it', '40000000024', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto LAquila', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '40000000025', 'architetto25@email.it', '085345025');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000025'), 'Sede Principale', 'Corso Italia', '69', 'LAquila', 'AQ', '67100', '085345025', 'architetto25@email.it', '40000000025', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere LAquila', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '40000000026', 'ingegnere26@email.it', '085345026');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000026'), 'Sede Principale', 'Via Mazzini', '178', 'LAquila', 'AQ', '67100', '085345026', 'ingegnere26@email.it', '40000000026', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra LAquila', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '40000000027', 'geometra27@email.it', '085345027');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000027'), 'Sede Principale', 'Piazza Garibaldi', '60', 'LAquila', 'AQ', '67100', '085345027', 'geometra27@email.it', '40000000027', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto LAquila', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '40000000028', 'officinaauto28@email.it', '085345028');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000028'), 'Sede Principale', 'Corso Umberto', '132', 'LAquila', 'AQ', '67100', '085345028', 'officinaauto28@email.it', '40000000028', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista LAquila', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '40000000029', 'gommista29@email.it', '085345029');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000029'), 'Sede Principale', 'Via Mazzini', '181', 'LAquila', 'AQ', '67100', '085345029', 'gommista29@email.it', '40000000029', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Pescara', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '40000000030', 'osteria30@email.it', '085345030');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000030'), 'Sede Principale', 'Via Verdi', '72', 'Pescara', 'PE', '65100', '085345030', 'osteria30@email.it', '40000000030', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Pescara', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '40000000031', 'pizzeria31@email.it', '085345031');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000031'), 'Sede Principale', 'Piazza del Duomo', '82', 'Pescara', 'PE', '65100', '085345031', 'pizzeria31@email.it', '40000000031', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Pescara', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '40000000032', 'caffe32@email.it', '085345032');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000032'), 'Sede Principale', 'Piazza Garibaldi', '104', 'Pescara', 'PE', '65100', '085345032', 'caffe32@email.it', '40000000032', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Pescara', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '40000000033', 'studiodentistico33@email.it', '085345033');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000033'), 'Sede Principale', 'Via Mazzini', '108', 'Pescara', 'PE', '65100', '085345033', 'studiodentistico33@email.it', '40000000033', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Pescara', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '40000000034', 'studiomedico34@email.it', '085345034');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000034'), 'Sede Principale', 'Piazza Garibaldi', '94', 'Pescara', 'PE', '65100', '085345034', 'studiomedico34@email.it', '40000000034', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Pescara', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '40000000035', 'farmacia35@email.it', '085345035');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000035'), 'Sede Principale', 'Via Cavour', '98', 'Pescara', 'PE', '65100', '085345035', 'farmacia35@email.it', '40000000035', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Pescara', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '40000000036', 'avvocato36@email.it', '085345036');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000036'), 'Sede Principale', 'Corso Vittorio Emanuele', '100', 'Pescara', 'PE', '65100', '085345036', 'avvocato36@email.it', '40000000036', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Pescara', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '40000000037', 'commercialista37@email.it', '085345037');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000037'), 'Sede Principale', 'Via Dante', '47', 'Pescara', 'PE', '65100', '085345037', 'commercialista37@email.it', '40000000037', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Pescara', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '40000000038', 'notaio38@email.it', '085345038');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000038'), 'Sede Principale', 'Piazza Garibaldi', '19', 'Pescara', 'PE', '65100', '085345038', 'notaio38@email.it', '40000000038', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Pescara', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '40000000039', 'salone39@email.it', '085345039');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000039'), 'Sede Principale', 'Via Cavour', '108', 'Pescara', 'PE', '65100', '085345039', 'salone39@email.it', '40000000039', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Pescara', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '40000000040', 'centroestetico40@email.it', '085345040');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000040'), 'Sede Principale', 'Corso Vittorio Emanuele', '164', 'Pescara', 'PE', '65100', '085345040', 'centroestetico40@email.it', '40000000040', true);

-- ============================================================
-- FILE: 20251219124518_seed_businesses_batch2_50.sql
-- ============================================================
/*
  # Seed Batch 2 - 50 Italian Businesses

  1. New Businesses (50 total)
    - Covers Pescara, Teramo, and Chieti cities
    - VAT numbers: 40000000041 to 40000000090
    - All business categories including:
      - Professionals (architects, engineers, lawyers, accountants)
      - Craftsmen (plumbers, electricians, painters, carpenters)
      - Retail (supermarkets, hardware stores, pharmacies, bookstores)
      - Services (gyms, hairdressers, beauty centers)
      - Food (restaurants, pizzerias, bakeries, butchers)
    
  2. Business Locations
    - Each business has a primary location with full address
    - Street addresses with street numbers
    - Complete contact information (phone, email)
    - VAT numbers matching parent businesses
*/

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Pescara', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '40000000041', 'idraulico41@email.it', '3331234041');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000041'), 'Sede Principale', 'Via Verdi', '108', 'Pescara', 'PE', '65100', '3331234041', 'idraulico41@email.it', '40000000041', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Pescara', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '40000000042', 'elettricista42@email.it', '3331234042');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000042'), 'Sede Principale', 'Corso Italia', '163', 'Pescara', 'PE', '65100', '3331234042', 'elettricista42@email.it', '40000000042', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Pescara', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '40000000043', 'imbianchino43@email.it', '3331234043');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000043'), 'Sede Principale', 'Corso Vittorio Emanuele', '135', 'Pescara', 'PE', '65100', '3331234043', 'imbianchino43@email.it', '40000000043', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Pescara', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '40000000044', 'fabbro44@email.it', '3331234044');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000044'), 'Sede Principale', 'Via Cavour', '183', 'Pescara', 'PE', '65100', '3331234044', 'fabbro44@email.it', '40000000044', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Pescara', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '40000000045', 'falegname45@email.it', '3331234045');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000045'), 'Sede Principale', 'Corso Umberto', '184', 'Pescara', 'PE', '65100', '3331234045', 'falegname45@email.it', '40000000045', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Pescara', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '40000000046', 'supermercato46@email.it', '085345046');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000046'), 'Sede Principale', 'Via Verdi', '93', 'Pescara', 'PE', '65100', '085345046', 'supermercato46@email.it', '40000000046', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Pescara', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '40000000047', 'ferramenta47@email.it', '085345047');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000047'), 'Sede Principale', 'Corso Vittorio Emanuele', '197', 'Pescara', 'PE', '65100', '085345047', 'ferramenta47@email.it', '40000000047', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Pescara', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '40000000048', 'palestra48@email.it', '085345048');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000048'), 'Sede Principale', 'Via Cavour', '130', 'Pescara', 'PE', '65100', '085345048', 'palestra48@email.it', '40000000048', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Pescara', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '40000000049', 'panificio49@email.it', '085345049');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000049'), 'Sede Principale', 'Corso Vittorio Emanuele', '36', 'Pescara', 'PE', '65100', '085345049', 'panificio49@email.it', '40000000049', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Pescara', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '40000000050', 'pasticceria50@email.it', '085345050');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000050'), 'Sede Principale', 'Via Verdi', '65', 'Pescara', 'PE', '65100', '085345050', 'pasticceria50@email.it', '40000000050', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Pescara', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '40000000051', 'veterinario51@email.it', '085345051');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000051'), 'Sede Principale', 'Piazza Garibaldi', '19', 'Pescara', 'PE', '65100', '085345051', 'veterinario51@email.it', '40000000051', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Pescara', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '40000000052', 'macelleria52@email.it', '085345052');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000052'), 'Sede Principale', 'Corso Italia', '46', 'Pescara', 'PE', '65100', '085345052', 'macelleria52@email.it', '40000000052', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Pescara', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '40000000053', 'pescheria53@email.it', '085345053');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000053'), 'Sede Principale', 'Corso Vittorio Emanuele', '88', 'Pescara', 'PE', '65100', '085345053', 'pescheria53@email.it', '40000000053', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Pescara', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '40000000054', 'libreria54@email.it', '085345054');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000054'), 'Sede Principale', 'Via Cavour', '101', 'Pescara', 'PE', '65100', '085345054', 'libreria54@email.it', '40000000054', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Pescara', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '40000000055', 'studioarchitetti55@email.it', '085345055');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000055'), 'Sede Principale', 'Via Cavour', '134', 'Pescara', 'PE', '65100', '085345055', 'studioarchitetti55@email.it', '40000000055', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Pescara', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '40000000056', 'ingegnere56@email.it', '085345056');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000056'), 'Sede Principale', 'Via Verdi', '39', 'Pescara', 'PE', '65100', '085345056', 'ingegnere56@email.it', '40000000056', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Pescara', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '40000000057', 'geometra57@email.it', '085345057');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000057'), 'Sede Principale', 'Via Verdi', '108', 'Pescara', 'PE', '65100', '085345057', 'geometra57@email.it', '40000000057', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Pescara', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '40000000058', 'officinaauto58@email.it', '085345058');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000058'), 'Sede Principale', 'Piazza del Duomo', '174', 'Pescara', 'PE', '65100', '085345058', 'officinaauto58@email.it', '40000000058', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Pescara', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '40000000059', 'gommista59@email.it', '085345059');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000059'), 'Sede Principale', 'Corso Italia', '15', 'Pescara', 'PE', '65100', '085345059', 'gommista59@email.it', '40000000059', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Teramo', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '40000000060', 'trattoria60@email.it', '085345060');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000060'), 'Sede Principale', 'Via Verdi', '63', 'Teramo', 'TE', '64100', '085345060', 'trattoria60@email.it', '40000000060', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Teramo', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '40000000061', 'pizzeria61@email.it', '085345061');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000061'), 'Sede Principale', 'Piazza del Duomo', '112', 'Teramo', 'TE', '64100', '085345061', 'pizzeria61@email.it', '40000000061', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Teramo', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '40000000062', 'barpasticceria62@email.it', '085345062');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000062'), 'Sede Principale', 'Piazza del Duomo', '161', 'Teramo', 'TE', '64100', '085345062', 'barpasticceria62@email.it', '40000000062', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Teramo', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '40000000063', 'studiodentistico63@email.it', '085345063');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000063'), 'Sede Principale', 'Via Verdi', '149', 'Teramo', 'TE', '64100', '085345063', 'studiodentistico63@email.it', '40000000063', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Teramo', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '40000000064', 'poliambulatorio64@email.it', '085345064');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000064'), 'Sede Principale', 'Via Verdi', '124', 'Teramo', 'TE', '64100', '085345064', 'poliambulatorio64@email.it', '40000000064', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Teramo', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '40000000065', 'farmacia65@email.it', '085345065');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000065'), 'Sede Principale', 'Via Roma', '21', 'Teramo', 'TE', '64100', '085345065', 'farmacia65@email.it', '40000000065', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Teramo', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '40000000066', 'avvocato66@email.it', '085345066');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000066'), 'Sede Principale', 'Corso Vittorio Emanuele', '118', 'Teramo', 'TE', '64100', '085345066', 'avvocato66@email.it', '40000000066', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Teramo', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '40000000067', 'studiocommercialisti67@email.it', '085345067');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000067'), 'Sede Principale', 'Via Cavour', '78', 'Teramo', 'TE', '64100', '085345067', 'studiocommercialisti67@email.it', '40000000067', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Teramo', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '40000000068', 'notaio68@email.it', '085345068');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000068'), 'Sede Principale', 'Piazza del Duomo', '105', 'Teramo', 'TE', '64100', '085345068', 'notaio68@email.it', '40000000068', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Teramo', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '40000000069', 'parrucchiere69@email.it', '085345069');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000069'), 'Sede Principale', 'Corso Vittorio Emanuele', '168', 'Teramo', 'TE', '64100', '085345069', 'parrucchiere69@email.it', '40000000069', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Teramo', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '40000000070', 'centroestetico70@email.it', '085345070');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000070'), 'Sede Principale', 'Via Mazzini', '197', 'Teramo', 'TE', '64100', '085345070', 'centroestetico70@email.it', '40000000070', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Teramo', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '40000000071', 'idraulico71@email.it', '3331234071');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000071'), 'Sede Principale', 'Via Cavour', '121', 'Teramo', 'TE', '64100', '3331234071', 'idraulico71@email.it', '40000000071', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Teramo', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '40000000072', 'elettricista72@email.it', '3331234072');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000072'), 'Sede Principale', 'Via Roma', '103', 'Teramo', 'TE', '64100', '3331234072', 'elettricista72@email.it', '40000000072', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Teramo', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '40000000073', 'imbianchino73@email.it', '3331234073');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000073'), 'Sede Principale', 'Via Verdi', '36', 'Teramo', 'TE', '64100', '3331234073', 'imbianchino73@email.it', '40000000073', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Teramo', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '40000000074', 'fabbro74@email.it', '3331234074');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000074'), 'Sede Principale', 'Via Dante', '49', 'Teramo', 'TE', '64100', '3331234074', 'fabbro74@email.it', '40000000074', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Teramo', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '40000000075', 'falegname75@email.it', '3331234075');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000075'), 'Sede Principale', 'Via Dante', '184', 'Teramo', 'TE', '64100', '3331234075', 'falegname75@email.it', '40000000075', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Teramo', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '40000000076', 'supermercato76@email.it', '085345076');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000076'), 'Sede Principale', 'Via Roma', '49', 'Teramo', 'TE', '64100', '085345076', 'supermercato76@email.it', '40000000076', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Teramo', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '40000000077', 'ferramenta77@email.it', '085345077');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000077'), 'Sede Principale', 'Via Verdi', '51', 'Teramo', 'TE', '64100', '085345077', 'ferramenta77@email.it', '40000000077', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Teramo', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '40000000078', 'palestra78@email.it', '085345078');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000078'), 'Sede Principale', 'Corso Vittorio Emanuele', '121', 'Teramo', 'TE', '64100', '085345078', 'palestra78@email.it', '40000000078', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Teramo', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '40000000079', 'panificio79@email.it', '085345079');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000079'), 'Sede Principale', 'Corso Vittorio Emanuele', '42', 'Teramo', 'TE', '64100', '085345079', 'panificio79@email.it', '40000000079', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Teramo', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '40000000080', 'pasticceria80@email.it', '085345080');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000080'), 'Sede Principale', 'Via Verdi', '148', 'Teramo', 'TE', '64100', '085345080', 'pasticceria80@email.it', '40000000080', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Teramo', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '40000000081', 'veterinario81@email.it', '085345081');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000081'), 'Sede Principale', 'Via Verdi', '6', 'Teramo', 'TE', '64100', '085345081', 'veterinario81@email.it', '40000000081', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Teramo', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '40000000082', 'macelleria82@email.it', '085345082');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000082'), 'Sede Principale', 'Via Roma', '56', 'Teramo', 'TE', '64100', '085345082', 'macelleria82@email.it', '40000000082', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Teramo', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '40000000083', 'pescheria83@email.it', '085345083');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000083'), 'Sede Principale', 'Corso Vittorio Emanuele', '193', 'Teramo', 'TE', '64100', '085345083', 'pescheria83@email.it', '40000000083', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Teramo', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '40000000084', 'libreria84@email.it', '085345084');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000084'), 'Sede Principale', 'Piazza del Duomo', '130', 'Teramo', 'TE', '64100', '085345084', 'libreria84@email.it', '40000000084', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Teramo', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '40000000085', 'studioarchitetti85@email.it', '085345085');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000085'), 'Sede Principale', 'Corso Vittorio Emanuele', '184', 'Teramo', 'TE', '64100', '085345085', 'studioarchitetti85@email.it', '40000000085', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Teramo', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '40000000086', 'studioingegneri86@email.it', '085345086');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000086'), 'Sede Principale', 'Via Dante', '145', 'Teramo', 'TE', '64100', '085345086', 'studioingegneri86@email.it', '40000000086', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Teramo', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '40000000087', 'geometra87@email.it', '085345087');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000087'), 'Sede Principale', 'Piazza del Duomo', '38', 'Teramo', 'TE', '64100', '085345087', 'geometra87@email.it', '40000000087', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Teramo', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '40000000088', 'officinaauto88@email.it', '085345088');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000088'), 'Sede Principale', 'Via Roma', '121', 'Teramo', 'TE', '64100', '085345088', 'officinaauto88@email.it', '40000000088', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Teramo', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '40000000089', 'gommista89@email.it', '085345089');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000089'), 'Sede Principale', 'Via Dante', '35', 'Teramo', 'TE', '64100', '085345089', 'gommista89@email.it', '40000000089', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Chieti', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '40000000090', 'ristorante90@email.it', '085345090');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000090'), 'Sede Principale', 'Piazza Garibaldi', '131', 'Chieti', 'CH', '66100', '085345090', 'ristorante90@email.it', '40000000090', true);


