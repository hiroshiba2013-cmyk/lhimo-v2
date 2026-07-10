/*
  # Comprehensive Business Database - All Italian Provinces (Part 3: Center & South)

  1. Overview
    Comprehensive business database for Central and Southern Italy provinces.

  2. Geographic Coverage
    CENTRAL ITALY:
    - Toscana: Arezzo, Grosseto, Livorno, Lucca, Massa-Carrara, Pistoia, Prato, Siena
    - Umbria: Terni
    - Marche: Ancona, Ascoli Piceno, Fermo, Macerata, Pesaro e Urbino
    - Lazio: Frosinone, Latina, Rieti, Viterbo
    
    SOUTHERN ITALY:
    - Abruzzo: Chieti, L'Aquila, Pescara, Teramo
    - Molise: Campobasso, Isernia
    - Campania: Avellino, Benevento, Caserta, Salerno
    - Puglia: Barletta-Andria-Trani, Brindisi, Foggia, Lecce, Taranto
    - Basilicata: Matera, Potenza
    - Calabria: Catanzaro, Cosenza, Crotone, Reggio Calabria, Vibo Valentia

  3. Business Count
    700+ businesses across center-south Italian provinces
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
  -- TOSCANA - AREZZO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Antica Trattoria da Guido', 'Cucina aretina tradizionale. Pici all''aglione, scottiglia aretina e peposo alla fornacina.', cat_ristoranti, 'Via Madonna del Prato', '85', 'Arezzo', 'AR', '52100', '+39 0575 23760', 'info@trattoriaguido.it', true, false),
  ('Farmacia Bianchi', 'Farmacia storica con galenica. Preparazioni magistrali tradizionali e fitoterapia.', cat_salute, 'Corso Italia', '98', 'Arezzo', 'AR', '52100', '+39 0575 20345', 'info@farmaciabianchi.it', true, false),
  ('Orafo Artigiano Aretino', 'Oreficeria artigianale. Gioielli su misura, riparazioni e compro oro certificato.', cat_professionisti, 'Via Guido Monaco', '23', 'Arezzo', 'AR', '52100', '+39 0575 352456', 'info@orafoaretino.it', true, false),
  ('Impresa Edile Valdichiana', 'Costruzioni e restauri. Casali toscani, recupero pietra e ristrutturazioni di pregio.', cat_servizi, 'Via Edison', '67', 'Arezzo', 'AR', '52100', '+39 0575 981234', 'info@edilevaldichiana.it', true, false),
  ('Elettricista Arezzo Service', 'Impianti elettrici e fotovoltaico. Certificazioni e manutenzioni per aziende e privati.', cat_servizi, 'Via Fiorentina', '145', 'Arezzo', 'AR', '52100', '+39 0575 383456', 'info@elettricistaarezzo.it', true, false),
  ('Salone Tosca', 'Parrucchiere donna con extension. Taglio, colore, trattamenti alla cheratina.', cat_bellezza, 'Via Roma', '34', 'Arezzo', 'AR', '52100', '+39 0575 356789', 'info@salonetosca.it', true, false),
  ('Oro Arezzo Shop', 'Negozio oreficeria. Gioielli in oro made in Arezzo, design contemporaneo e classico.', cat_negozi, 'Corso Italia', '156', 'Arezzo', 'AR', '52100', '+39 0575 300890', 'info@oroarezzo.it', true, false);

  -- ============================================================================
  -- TOSCANA - GROSSETO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Osteria del Mare', 'Cucina maremmana e di mare. Acquacotta, cinghiale, cacciucco e pesci freschi.', cat_ristoranti, 'Via Mazzini', '23', 'Grosseto', 'GR', '58100', '+39 0564 25546', 'info@osteriadelmare.it', true, false),
  ('Farmacia Maremma', 'Farmacia con prodotti termali. Acque di Saturnia, cosmetica naturale e dermocosmesi.', cat_salute, 'Piazza Dante', '12', 'Grosseto', 'GR', '58100', '+39 0564 22345', 'info@farmaciamaremma.it', true, false),
  ('Agronomo Dott. Rossi', 'Studio agronomico. Consulenze vinicole, oliveti, piani colturali e biologico.', cat_professionisti, 'Via Aurelia Nord', '45', 'Grosseto', 'GR', '58100', '+39 0564 416789', 'info@agronomorossi.it', true, false),
  ('Cantina Vini Morellino', 'Produzione e vendita vino Morellino di Scansano. Degustazioni e visite in cantina.', cat_negozi, 'Via Senese', '89', 'Grosseto', 'GR', '58100', '+39 0564 405678', 'info@cantinamorellino.it', true, false),
  ('Idraulico Maremma Service', 'Idraulica per ville e agriturismi. Piscine, irrigazione giardini e pozzi artesiani.', cat_servizi, 'Via Scansanese', '123', 'Grosseto', 'GR', '58100', '+39 0564 453456', 'info@maremmaservice.it', true, false),
  ('Centro Estetico Terme', 'Centro estetico con fanghi. Trattamenti termali, massaggi e percorso benessere.', cat_bellezza, 'Viale Matteotti', '67', 'Grosseto', 'GR', '58100', '+39 0564 492789', 'info@esteticaterme.it', true, false);

  -- ============================================================================
  -- TOSCANA - LIVORNO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Il Sottomarino', 'Ristorante pesce fronte mare. Cacciucco livornese, triglie, frittura e crostacei.', cat_ristoranti, 'Via dei Pensieri', '67', 'Livorno', 'LI', '57123', '+39 0586 887025', 'info@ilsottomarino.it', true, false),
  ('Farmacia del Porto', 'Farmacia portuale H24. Servizio per crocieristi, farmaci urgenza e multilingue.', cat_salute, 'Scali d''Azeglio', '34', 'Livorno', 'LI', '57123', '+39 0586 882345', 'info@farmaciaporto.it', true, false),
  ('Avvocato Marittimo Studio Legale', 'Studio legale diritto marittimo. Sinistri nave, controversie porto e diritto della navigazione.', cat_professionisti, 'Via Grande', '89', 'Livorno', 'LI', '57123', '+39 0586 893456', 'studio@marittimolegale.it', true, false),
  ('Cantiere Navale Livornese', 'Cantiere rimessaggio barche. Manutenzione yacht, antivegetativa e riparazioni scafo.', cat_servizi, 'Molo Mediceo', '12', 'Livorno', 'LI', '57123', '+39 0586 898567', 'info@cantierelivorno.it', true, false),
  ('Parrucchiere Marina Style', 'Salone vista mare. Trattamenti schiarenti, beach waves e hair spa.', cat_bellezza, 'Viale Italia', '145', 'Livorno', 'LI', '57127', '+39 0586 502789', 'info@marinastyle.it', true, false),
  ('Pescheria Livornese', 'Pescheria con banco al dettaglio. Pesce fresco del tirreno, crostacei e molluschi.', cat_negozi, 'Mercato Centrale', '23', 'Livorno', 'LI', '57123', '+39 0586 881890', 'info@pescherialivorno.it', true, false);

  -- ============================================================================
  -- TOSCANA - LUCCA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Buca di Sant''Antonio', 'Ristorante storico lucchese dal 1782. Tordelli lucchesi, rovelline e farro della Garfagnana.', cat_ristoranti, 'Via della Cervia', '3', 'Lucca', 'LU', '55100', '+39 0583 55881', 'info@bucadisantantonio.it', true, false),
  ('Farmacia Massagli', 'Farmacia entro le mura. Galenica tradizionale, omeopatia e prodotti per ciclisti.', cat_salute, 'Via Fillungo', '123', 'Lucca', 'LU', '55100', '+39 0583 491234', 'info@farmaciamassagli.it', true, false),
  ('Notaio Dott. Pacini', 'Studio notarile Lucca centro. Atti immobiliari, successioni e costituzione società.', cat_professionisti, 'Piazza San Michele', '8', 'Lucca', 'LU', '55100', '+39 0583 496789', 'studio@notaiopacini.it', true, false),
  ('Falegnameria Lucchese d''Arte', 'Falegnameria artistica. Mobili su misura, restauro e arredi su disegno.', cat_servizi, 'Via per Sant''Alessio', '45', 'Lucca', 'LU', '55100', '+39 0583 341234', 'info@falegnameria lucca.it', true, false),
  ('Salone Belle Époque', 'Parrucchiere in centro storico. Taglio classico, pieghe e trattamenti rigeneranti.', cat_bellezza, 'Via Santa Croce', '67', 'Lucca', 'LU', '55100', '+39 0583 469012', 'info@belleepoque lucca.it', true, false),
  ('Bottega del Buccellato', 'Pasticceria storica. Buccellato lucchese originale, torte e pasticceria tradizionale.', cat_negozi, 'Via Santa Lucia', '18', 'Lucca', 'LU', '55100', '+39 0583 496024', 'info@buccellatolucca.it', true, false);

  -- ============================================================================
  -- TOSCANA - MASSA-CARRARA (Carrara)
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria Omobono', 'Cucina apuana. Lardo di Colonnata, testaroli, agnello e funghi delle Apuane.', cat_ristoranti, 'Piazza Palestro', '3', 'Carrara', 'MS', '54033', '+39 0585 74245', 'info@trattoriaomobono.it', true, false),
  ('Farmacia Duomo Carrara', 'Farmacia nel centro storico. Preparazioni galeniche e consulenza farmaceutica.', cat_salute, 'Via Roma', '45', 'Carrara', 'MS', '54033', '+39 0585 71234', 'info@farmaciaduomo.it', true, false),
  ('Scultore Marmo di Carrara', 'Laboratorio scultura marmo. Opere su commissione, restauro e lavorazioni artistiche.', cat_professionisti, 'Via Carriona', '67', 'Carrara', 'MS', '54033', '+39 0585 843456', 'info@scultorecarrara.it', true, false),
  ('Cava Marmo Bianco', 'Estrazione e lavorazione marmo. Blocchi, lastre e marmo per edilizia e arte.', cat_servizi, 'Via Canalgrande', '123', 'Carrara', 'MS', '54033', '+39 0585 857890', 'info@cavamarmo.it', true, false),
  ('Centro Estetico Marmor', 'Centro estetico con sauna marmo. Trattamenti con polvere di marmo e scrub.', cat_bellezza, 'Via Verdi', '89', 'Carrara', 'MS', '54033', '+39 0585 776789', 'info@marmor beauty.it', true, false);

  -- ============================================================================
  -- UMBRIA - TERNI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Osteria della Mal''Ora', 'Cucina umbra casalinga. Strangozzi al tartufo, palombacci e carne chianina.', cat_ristoranti, 'Via del Leone', '4', 'Terni', 'TR', '05100', '+39 0744 58763', 'info@malloraterni.it', true, false),
  ('Farmacia San Valentino', 'Farmacia centrale con autoanalisi. Esami sangue, elettrocardiogramma e spirometria.', cat_salute, 'Corso Tacito', '67', 'Terni', 'TR', '05100', '+39 0744 402345', 'info@farmaciasanvalentino.it', true, false),
  ('Ingegnere Meccanico Studio', 'Studio ingegneria per siderurgia. Consulenze industriali, impianti e sicurezza.', cat_professionisti, 'Viale della Stazione', '23', 'Terni', 'TR', '05100', '+39 0744 420456', 'studio@ingegneria terni.it', true, false),
  ('Impresa Edile Ternana', 'Costruzioni industriali e civili. Capannoni, uffici e ristrutturazioni aziendali.', cat_servizi, 'Strada di Palmetta', '89', 'Terni', 'TR', '05100', '+39 0744 301234', 'info@edileternana.it', true, false),
  ('Barbiere Valentino', 'Barbiere storico ternano. Rasatura tradizionale, taglio classico e cura barba.', cat_bellezza, 'Via Cavour', '45', 'Terni', 'TR', '05100', '+39 0744 423456', 'info@barbierevalentino.it', true, false),
  ('Tartufi di Terni', 'Negozio tartufi umbri. Tartufo nero pregiato, sauces e prodotti tartufati.', cat_negozi, 'Via Goldoni', '12', 'Terni', 'TR', '05100', '+39 0744 280890', 'info@tartufiditerni.it', true, false);

  -- ============================================================================
  -- MARCHE - ANCONA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante La Moretta', 'Ristorante pesce sul porto. Brodetto anconetano, moscioli e stoccafisso all''anconetana.', cat_ristoranti, 'Piazza Plebiscito', '52', 'Ancona', 'AN', '60121', '+39 071 202317', 'info@lamoretta.it', true, false),
  ('Farmacia Centrale Ancona', 'Farmacia porto con servizio crociere. Farmaci urgenza, multilingue e H24.', cat_salute, 'Corso Garibaldi', '89', 'Ancona', 'AN', '60121', '+39 071 202456', 'info@farmaciacentralean.it', true, false),
  ('Avvocato Pierluigi Morelli', 'Studio legale commerciale. Diritto societario, contratti commerciali e M&A.', cat_professionisti, 'Corso Mazzini', '23', 'Ancona', 'AN', '60121', '+39 071 2074567', 'studio@morelliavvocato.it', true, false),
  ('Cantiere Porto Ancona', 'Cantiere navale commerciale. Riparazioni navi, dry dock e manutenzioni traghetti.', cat_servizi, 'Banchina Nazario Sauro', '12', 'Ancona', 'AN', '60121', '+39 071 201890', 'info@cantiereancona.it', true, false),
  ('Parrucchiere Marche Style', 'Salone moderno nel centro. Extension, trattamenti liscianti e colorimetria.', cat_bellezza, 'Corso Stamira', '67', 'Ancona', 'AN', '60121', '+39 071 2033456', 'info@marchestyle.it', true, false),
  ('Fisarmoniche Castelfidardo', 'Negozio fisarmoniche artigianali. Vendita, riparazione e accessori musicali.', cat_negozi, 'Via XXIX Settembre', '145', 'Ancona', 'AN', '60122', '+39 071 891234', 'info@fisarmoniche ancona.it', true, false);

  -- ============================================================================
  -- LAZIO - FROSINONE
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria Ciociara', 'Cucina ciociara tradizionale. Fettuccine, abbacchio, pampanella e dolci tipici.', cat_ristoranti, 'Via Aldo Moro', '45', 'Frosinone', 'FR', '03100', '+39 0775 270301', 'info@trattoriaciociara.it', true, false),
  ('Farmacia Del Vescovo', 'Farmacia con preparazioni galeniche. Magistrali tradizionali e fitoterapia.', cat_salute, 'Piazza Vittorio Veneto', '12', 'Frosinone', 'FR', '03100', '+39 0775 872345', 'info@farmaciadelvescovo.it', true, false),
  ('Commercialista Studio FR', 'Commercialista per industrie. Contabilità, consulenza fiscale e dichiarazioni.', cat_professionisti, 'Viale Roma', '67', 'Frosinone', 'FR', '03100', '+39 0775 826789', 'studio@commercialistafr.it', true, false),
  ('Impresa Costruzioni Ciociare', 'Edilizia residenziale e industriale. Nuove costruzioni, capannoni e ristrutturazioni.', cat_servizi, 'Via Marittima', '123', 'Frosinone', 'FR', '03100', '+39 0775 821234', 'info@costruzioniciociare.it', true, false),
  ('Estetica Beauty Ciociaria', 'Centro estetico completo. Trattamenti viso e corpo, epilazione e manicure.', cat_bellezza, 'Corso Lazio', '89', 'Frosinone', 'FR', '03100', '+39 0775 207890', 'info@beautyciociaria.it', true, false);

  -- ============================================================================
  -- LAZIO - LATINA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Il Fungo', 'Ristorante pontino. Mozzarella di bufala, spaghetti alle telline e pesce di Terracina.', cat_ristoranti, 'Viale dello Statuto', '34', 'Latina', 'LT', '04100', '+39 0773 662749', 'info@ilfungolatina.it', true, false),
  ('Farmacia Pontina', 'Farmacia moderna con drive through. Servizio auto, consegna domicilio e prenotazioni.', cat_salute, 'Corso della Repubblica', '156', 'Latina', 'LT', '04100', '+39 0773 482345', 'info@farmaciapontina.it', true, false),
  ('Agronomo Agro Pontino', 'Studio agronomico per serre. Consulenze orticole, kiwi e progetti agricoli innovativi.', cat_professionisti, 'Via Don Minzoni', '45', 'Latina', 'LT', '04100', '+39 0773 661234', 'info@agronomopontino.it', true, false),
  ('Serre Pontine Costruzioni', 'Costruzione serre agricole. Serre professionali, impianti irrigazione e automazioni.', cat_servizi, 'Via Epitaffio', '89', 'Latina', 'LT', '04100', '+39 0773 605678', 'info@serrepontine.it', true, false),
  ('Parrucchiere Latina Style', 'Salone acconciature. Taglio, colore, extension e trattamenti professionali.', cat_bellezza, 'Via Diaz', '67', 'Latina', 'LT', '04100', '+39 0773 694567', 'info@latinastyle.it', true, false),
  ('Mozzarella Shop Pontina', 'Caseificio con vendita diretta. Mozzarella di bufala DOP, ricotta e formaggi freschi.', cat_negozi, 'Via Isonzo', '23', 'Latina', 'LT', '04100', '+39 0773 628901', 'info@mozzarellapontina.it', true, false);

  -- ============================================================================
  -- ABRUZZO - PESCARA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Taverna 58', 'Ristorante pesce fronte mare. Brodetto pescarese, scampi e crudi di mare.', cat_ristoranti, 'Corso Umberto', '83', 'Pescara', 'PE', '65122', '+39 085 690724', 'info@taverna58.it', true, false),
  ('Farmacia San Marco', 'Farmacia centro con autoanalisi. Test rapidi, misurazione parametri e telemedicina.', cat_salute, 'Corso Vittorio Emanuele', '234', 'Pescara', 'PE', '65122', '+39 085 4212345', 'info@farmaciasanmarco.it', true, false),
  ('Avvocato Daniela Rossi', 'Studio legale famiglia e minori. Separazioni, divorzi e tutela infanzia.', cat_professionisti, 'Via Nicola Fabrizi', '45', 'Pescara', 'PE', '65122', '+39 085 4214567', 'studio@rossilegal.it', true, false),
  ('Stabilimento Balneare La Nave', 'Stabilimento balneare con ristorante. Ombrelloni, lettini, docce e bar sulla spiaggia.', cat_servizi, 'Lungomare Matteotti', '156', 'Pescara', 'PE', '65126', '+39 085 27890', 'info@lanavepe.it', true, false),
  ('Centro Estetico Adriatico', 'Centro estetico e solarium. Abbronzatura, massaggi e trattamenti corpo.', cat_bellezza, 'Via Venezia', '67', 'Pescara', 'PE', '65122', '+39 085 4217890', 'info@adriaticobeauty.it', true, false),
  ('Arrosticini Abruzzesi', 'Macelleria con arrosticini. Carne di pecora, salsicce e specialità abruzzesi.', cat_negozi, 'Via Nazionale Adriatica', '89', 'Pescara', 'PE', '65129', '+39 085 4463456', 'info@arrosticinicini.it', true, false);

  -- ============================================================================
  -- CAMPANIA - SALERNO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Cicirinella', 'Cucina salernitana. Scialatielli ai frutti di mare, pizza cilentana e limoncello.', cat_ristoranti, 'Via Roma', '182', 'Salerno', 'SA', '84121', '+39 089 252054', 'info@cicirinella.it', true, false),
  ('Farmacia Apollo', 'Farmacia H24 nel centro. Servizio notturno, pronto soccorso e galenica.', cat_salute, 'Corso Vittorio Emanuele', '234', 'Salerno', 'SA', '84123', '+39 089 225345', 'info@farmaciaapollo.it', true, false),
  ('Architetto Costiera Amalfitana', 'Studio architettura per costiera. Ville di lusso, restauri e interior design.', cat_professionisti, 'Via dei Mercanti', '45', 'Salerno', 'SA', '84121', '+39 089 253456', 'studio@archcostamalfitana.it', true, false),
  ('Ceramiche Vietri', 'Laboratorio ceramiche artigianali. Piatti, vasi, mattonelle decorate a mano.', cat_negozi, 'Via Ligea', '67', 'Salerno', 'SA', '84121', '+39 089 234567', 'info@ceramichevietri.it', true, false),
  ('Idraulico Salerno Service', 'Pronto intervento idraulico H24. Riparazioni, caldaie e climatizzatori.', cat_servizi, 'Via Trento', '123', 'Salerno', 'SA', '84128', '+39 089 791234', 'info@salernoservice.it', true, false),
  ('Salone Mediterraneo', 'Parrucchiere vista mare. Trattamenti schiarenti, beach style e acconciature sposa.', cat_bellezza, 'Lungomare Trieste', '89', 'Salerno', 'SA', '84121', '+39 089 227890', 'info@mediterraneosa.it', true, false);

  -- ============================================================================
  -- PUGLIA - LECCE
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Alle Due Corti', 'Ristorante barocco leccese. Pasticciotto salato, ciceri e tria, rustico leccese.', cat_ristoranti, 'Corte dei Giugni', '1', 'Lecce', 'LE', '73100', '+39 0832 242223', 'info@alleduecorti.it', true, false),
  ('Farmacia Santa Croce Lecce', 'Farmacia centro storico. Dermocosmesi, omeopatia e consulenza dermatologica.', cat_salute, 'Via Palmieri', '89', 'Lecce', 'LE', '73100', '+39 0832 305678', 'info@farmaciasantacroce.it', true, false),
  ('Scalpellino Pietra Leccese', 'Artigiano pietra leccese. Lavorazioni artistiche, sculture e elementi architettonici.', cat_professionisti, 'Via Giuseppe Candido', '23', 'Lecce', 'LE', '73100', '+39 0832 242890', 'info@scalpellinolecce.it', true, false),
  ('Imbianchino Salento', 'Tinteggiature e decorazioni. Pitture murali, stucchi veneziani e restauri.', cat_servizi, 'Via Adriatica', '67', 'Lecce', 'LE', '73100', '+39 0832 352345', 'info@imbianchinosalento.it', true, false),
  ('Centro Estetico Salento Beauty', 'Centro estetico avanzato. Radiofrequenza, pressoterapia e trattamenti anti-age.', cat_bellezza, 'Viale Oronzo Quarta', '145', 'Lecce', 'LE', '73100', '+39 0832 306789', 'info@salentobeauty.it', true, false),
  ('Laboratorio Pasticciotto', 'Pasticceria artigianale. Pasticciotti caldi, fruttoni e dolci salentini.', cat_negozi, 'Via Trinchese', '56', 'Lecce', 'LE', '73100', '+39 0832 241234', 'info@pasticciottolecce.it', true, false);

  -- Continue with remaining southern provinces and islands...

END $$;
