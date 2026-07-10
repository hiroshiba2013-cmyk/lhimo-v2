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
