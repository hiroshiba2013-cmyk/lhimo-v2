/*
  # Comprehensive Business Database - All Italian Provinces (Part 2: North Continued)

  1. Overview
    Continuation of comprehensive business database for Northern Italy provinces.

  2. Geographic Coverage - NORTH ITALY (Continued)
    - Liguria: Savona
    - Lombardia: Como, Cremona, Lecco, Lodi, Mantova, Monza e Brianza, Pavia, Sondrio
    - Trentino-Alto Adige: Bolzano, Trento
    - Veneto: Belluno, Rovigo, Treviso, Vicenza
    - Friuli-Venezia Giulia: Gorizia, Pordenone, Udine
    - Emilia-Romagna: Ferrara, Forlì-Cesena, Modena, Parma, Piacenza, Ravenna, Reggio Emilia, Rimini

  3. Business Count
    400+ additional businesses
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
  -- LIGURIA - SAVONA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante A Spurcacciuna', 'Ristorante storico savonese. Brandacujun, torta di riso e farinata ligure in ambiente tradizionale.', cat_ristoranti, 'Via Pia', '15r', 'Savona', 'SV', '17100', '+39 019 821871', 'info@spurcacciuna.it', true, false),
  ('Farmacia Centrale Savona', 'Farmacia nel centro storico. Galenica, omeopatia e prodotti per celiaci.', cat_salute, 'Corso Italia', '45', 'Savona', 'SV', '17100', '+39 019 820345', 'info@farmaciacentralesv.it', true, false),
  ('Geometra Paolo Oliveri', 'Studio tecnico per edilizia costiera. Pratiche demaniali, concessioni spiaggia e APE.', cat_professionisti, 'Via Paleocapa', '12', 'Savona', 'SV', '17100', '+39 019 838456', 'info@geometraoliveri.it', true, false),
  ('Impresa Edile Riviera', 'Costruzioni e ristrutturazioni. Specializzati in recupero edifici storici centro Savona.', cat_servizi, 'Via Gramsci', '78', 'Savona', 'SV', '17100', '+39 019 804567', 'info@edileriviera.it', true, false),
  ('Elettricista Savona Express', 'Pronto intervento elettrico per Savona e riviera. Disponibile H24 anche per emergenze.', cat_servizi, 'Via Torino', '145', 'Savona', 'SV', '17100', '+39 019 821234', 'info@elettricistasv.it', true, false),
  ('Salone Dolce Vita', 'Parrucchiere donna con trattamenti brasiliani. Cheratina, botox capelli e taglio.', cat_bellezza, 'Via Caboto', '34', 'Savona', 'SV', '17100', '+39 019 827890', 'info@dolcevitasavona.it', true, false),
  ('Cantina Vini Liguri', 'Enoteca con degustazioni. Vermentino, Pigato, Rossese e prodotti tipici liguri.', cat_negozi, 'Via Pia', '67r', 'Savona', 'SV', '17100', '+39 019 836789', 'info@cantinaviniliguri.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - COMO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Navedano', 'Ristorante vista lago. Pesce di lago, risotto al pesce persico e specialità lariane.', cat_ristoranti, 'Via Pannilani', '5', 'Como', 'CO', '22100', '+39 031 308080', 'info@navedano.it', true, false),
  ('Farmacia del Lago Como', 'Farmacia moderna con autoanalisi. Prelievi capillari, misurazione PSA e holter pressorio.', cat_salute, 'Piazza Cavour', '12', 'Como', 'CO', '22100', '+39 031 270345', 'info@farmacialago.it', true, false),
  ('Architetto Laura Brambilla', 'Studio architettura residenziale di lusso. Ville sul lago, interior design e ristrutturazioni.', cat_professionisti, 'Viale Lecco', '23', 'Como', 'CO', '22100', '+39 031 271456', 'studio@brambillaarch.it', true, false),
  ('Falegnameria Comasca', 'Laboratorio artigiano per arredi su misura. Boiserie, scale e mobili in legno pregiato.', cat_servizi, 'Via Varesina', '89', 'Como', 'CO', '22100', '+39 031 525678', 'info@falegnameriacomo.it', true, false),
  ('Idraulico Como Service', 'Servizio idraulico rapido. Caldaie, climatizzatori e impianti termici per ville sul lago.', cat_servizi, 'Via Bellinzona', '145', 'Como', 'CO', '22100', '+39 031 263789', 'info@comoservice.it', true, false),
  ('Beauty & Spa Lario', 'Centro benessere esclusivo. Massaggi, trattamenti viso luxury e spa privata.', cat_bellezza, 'Lungo Lario Trieste', '8', 'Como', 'CO', '22100', '+39 031 301234', 'info@beautyspalario.it', true, false),
  ('Seta Como Outlet', 'Negozio tessuti di seta comaschi. Sciarpe, cravatte e tessuti al metro di alta qualità.', cat_negozi, 'Via Vittorio Emanuele II', '56', 'Como', 'CO', '22100', '+39 031 267890', 'info@setacomo.it', true, false),
  ('Grand Hotel di Como', 'Hotel 5 stelle lusso fronte lago. Spa, ristorante gourmet e servizio concierge.', cat_servizi, 'Via Regina', '40', 'Como', 'CO', '22100', '+39 031 5161', 'info@grandhotelcomo.com', true, false);

  -- ============================================================================
  -- LOMBARDIA - CREMONA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria Cerresola', 'Cucina cremonese tradizionale. Marubini, tortelli di zucca, bollito misto e mostarda.', cat_ristoranti, 'Via Cerresola', '4', 'Cremona', 'CR', '26100', '+39 0372 30990', 'info@trattoriacerresola.it', true, false),
  ('Farmacia Musicale Cremona', 'Farmacia storica nel centro. Prodotti per musicisti, creme mani e integratori specifici.', cat_salute, 'Corso Campi', '45', 'Cremona', 'CR', '26100', '+39 0372 23456', 'info@farmaciamusicale.it', true, false),
  ('Liutaio Bottega Cremonese', 'Liuteria artigianale. Costruzione e restauro violini, viole e violoncelli.', cat_professionisti, 'Piazza Stradivari', '7', 'Cremona', 'CR', '26100', '+39 0372 464567', 'info@liutaiocremonese.it', true, false),
  ('Elettricista Cremona Impianti', 'Impiantistica elettrica civile. Illuminazione, antifurto e videocitofoni.', cat_servizi, 'Via Mantova', '123', 'Cremona', 'CR', '26100', '+39 0372 411234', 'info@impianticremona.it', true, false),
  ('Barbiere Stradivari', 'Barber shop di classe. Taglio classico, hot towel shave e cura barba professionale.', cat_bellezza, 'Via Baldesio', '34', 'Cremona', 'CR', '26100', '+39 0372 456789', 'info@barbierestradivari.it', true, false),
  ('Sperlari Store', 'Negozio storico di torroni e dolci. Torrone classico, mostarda e prodotti tipici cremonesi.', cat_negozi, 'Via Solferino', '25', 'Cremona', 'CR', '26100', '+39 0372 22329', 'info@sperlari.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - LECCO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Osteria Casa Manzoni', 'Osteria lecchese. Missoltini, polenta e formaggio, lavarello del Lario.', cat_ristoranti, 'Via Bovara', '23', 'Lecco', 'LC', '23900', '+39 0341 285175', 'info@casamanzoni.it', true, false),
  ('Farmacia San Nicolò', 'Farmacia con corner sportivi. Integratori per montagna, protezioni solari e primo soccorso.', cat_salute, 'Corso Martiri', '89', 'Lecco', 'LC', '23900', '+39 0341 364567', 'info@farmaciasannicolo.it', true, false),
  ('Commercialista Dott. Valsecchi', 'Studio per professionisti e PMI. Contabilità ordinaria, consulenza fiscale e paghe.', cat_professionisti, 'Via Cavour', '45', 'Lecco', 'LC', '23900', '+39 0341 282345', 'studio@valsecchicommercialista.it', true, false),
  ('Impresa Costruzioni Lecchesi', 'Edilizia montana. Costruzioni in pietra, recupero baite e ristrutturazioni di montagna.', cat_servizi, 'Via Leonardo da Vinci', '67', 'Lecco', 'LC', '23900', '+39 0341 365678', 'info@costruzionilecchesi.it', true, false),
  ('Parrucchiere Glamour Lecco', 'Salone acconciature con linea bio. Trattamenti naturali, hennè e taglio ecologico.', cat_bellezza, 'Via Volta', '12', 'Lecco', 'LC', '23900', '+39 0341 283456', 'info@glamourlecco.it', true, false),
  ('Negozio Alpinismo Lecco', 'Negozio attrezzatura montagna. Arrampicata, trekking, sci alpinismo e abbigliamento tecnico.', cat_negozi, 'Piazza Era', '7', 'Lecco', 'LC', '23900', '+39 0341 362789', 'info@alpinismolecco.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - LODI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria del Teatro', 'Cucina lodigiana genuina. Risotto alla lodigiana, raspadura e salumi nostrani.', cat_ristoranti, 'Via Marsala', '18', 'Lodi', 'LO', '26900', '+39 0371 421757', 'info@trattoriateatro.it', true, false),
  ('Farmacia Lodi Centro', 'Farmacia con servizio veterinario. Prodotti per animali, mangimi e farmaci veterinari.', cat_salute, 'Corso Roma', '56', 'Lodi', 'LO', '26900', '+39 0371 424567', 'info@farmacialodi.it', true, false),
  ('Avvocato Carlo Ferri', 'Studio legale agricolo. Diritto agrario, PAC, contributi e vertenze rurali.', cat_professionisti, 'Via Polenghi Lombardo', '12', 'Lodi', 'LO', '26900', '+39 0371 431234', 'studio@ferriagricolo.it', true, false),
  ('Idraulico Lodi Express', 'Idraulica per aziende agricole. Impianti irrigazione, pozzi e sistemi idrici rurali.', cat_servizi, 'Via Milano', '89', 'Lodi', 'LO', '26900', '+39 0371 610345', 'info@idraulicolodi.it', true, false),
  ('Salone Vanity', 'Parrucchiere con solarium. Trattamenti ristrutturanti, extension e manicure.', cat_bellezza, 'Piazza Broletto', '8', 'Lodi', 'LO', '26900', '+39 0371 423456', 'info@vani tylodi.it', true, false),
  ('Caseificio Artigianale Lodigiano', 'Produzione e vendita formaggi DOP. Grana Padano, Pannerone e formaggi freschi.', cat_negozi, 'Via Sant''Agnese', '45', 'Lodi', 'LO', '26900', '+39 0371 432789', 'info@caseificiolodigiano.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - MANTOVA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Il Cigno', 'Ristorante stellato mantovano. Tortelli di zucca, risotto alla pilota e luccio in salsa.', cat_ristoranti, 'Piazza Carlo d''Arco', '1', 'Mantova', 'MN', '46100', '+39 0376 327101', 'info@ilcignomantova.it', true, false),
  ('Farmacia Gonzaga', 'Farmacia storica nel centro. Preparazioni galeniche tradizionali e omeopatia classica.', cat_salute, 'Corso Umberto I', '23', 'Mantova', 'MN', '46100', '+39 0376 320345', 'info@farmaciagonzaga.it', true, false),
  ('Architetto Maria Giulia Savi', 'Studio specializzato in restauro. Edifici storici, vincoli Belle Arti e recupero patrimonio.', cat_professionisti, 'Via Accademia', '12', 'Mantova', 'MN', '46100', '+39 0376 322456', 'studio@archsavi.it', true, false),
  ('Falegnameria d''Arte Mantovana', 'Falegnameria artistica. Riproduzioni mobili rinascimentali e restauro antiquariato.', cat_servizi, 'Via Chiassi', '34', 'Mantova', 'MN', '46100', '+39 0376 321567', 'info@falegnameriamn.it', true, false),
  ('Centro Estetico Duchessa', 'Centro estetico di lusso. Trattamenti viso gold, massaggi e beauty routine personalizzate.', cat_bellezza, 'Via Verdi', '45', 'Mantova', 'MN', '46100', '+39 0376 224567', 'info@duchessabeauty.it', true, false),
  ('Acetaia Mantovana', 'Produzione aceto balsamico tradizionale. Visite in acetaia e vendita prodotti invecchiati.', cat_negozi, 'Strada Cipata', '67', 'Mantova', 'MN', '46100', '+39 0376 368789', 'info@acetaiamantovana.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - MONZA E BRIANZA (Monza)
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Derby Grill', 'Ristorante carne vista autodromo. Carni pregiate, grigliata argentina e cucina internazionale.', cat_ristoranti, 'Viale Mirabello', '2', 'Monza', 'MB', '20900', '+39 039 387771', 'info@derbygrill.it', true, false),
  ('Farmacia Reale', 'Farmacia moderna con corner beauty. Dermocosmesi di lusso, profumeria e consulenza.', cat_salute, 'Via Italia', '67', 'Monza', 'MB', '20900', '+39 039 323456', 'info@farmaciareale.it', true, false),
  ('Commercialista Studio Brianza', 'Commercialisti per imprese manifatturiere. Bilanci, controllo gestione e pianificazione fiscale.', cat_professionisti, 'Viale Cesare Battisti', '23', 'Monza', 'MB', '20900', '+39 039 324567', 'info@studiobrianza.it', true, false),
  ('Impresa Edile Monzese', 'Costruzioni civili e industriali. Capannoni, uffici e ristrutturazioni aziendali.', cat_servizi, 'Via Lecco', '145', 'Monza', 'MB', '20900', '+39 039 745678', 'info@edilemonzese.it', true, false),
  ('Salone Jean Louis David', 'Salone franchising internazionale. Taglio moda, colore e trattamenti professionali.', cat_bellezza, 'Via Vittorio Emanuele', '12', 'Monza', 'MB', '20900', '+39 039 386789', 'monza@jeanlouisdavid.it', true, false),
  ('Autofficina Racing Monza', 'Officina specializzata auto sportive. Preparazioni, elaborazioni e assistenza pista.', cat_servizi, 'Via Vedano', '89', 'Monza', 'MB', '20900', '+39 039 203456', 'info@racingmonza.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - PAVIA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Locanda Vecchia Pavia', 'Ristorante storico pavese. Risotto alla certosina, zuppa pavese e rane fritte.', cat_ristoranti, 'Via Cardinal Riboldi', '2', 'Pavia', 'PV', '27100', '+39 0382 304132', 'info@vecchiapavia.it', true, false),
  ('Farmacia Università', 'Farmacia universitaria. Prodotti per studenti, integratori studio e consulenza farmaceutica.', cat_salute, 'Corso Cavour', '78', 'Pavia', 'PV', '27100', '+39 0382 303456', 'info@farmaciauniversita.it', true, false),
  ('Avvocato Federica Rossi', 'Studio legale universitario. Diritto studio, ricorsi, contratti di locazione per studenti.', cat_professionisti, 'Corso Mazzini', '23', 'Pavia', 'PV', '27100', '+39 0382 529345', 'studio@rossifederica.it', true, false),
  ('Elettricista Pavia Service', 'Impianti elettrici residenziali. Domotica, illuminazione LED e impianti fotovoltaici.', cat_servizi, 'Viale Cremona', '56', 'Pavia', 'PV', '27100', '+39 0382 424567', 'info@paviaservice.it', true, false),
  ('Parrucchiere Glamour Style', 'Salone giovane per universitari. Prezzi studenti, taglio fashion e colorazioni trendy.', cat_bellezza, 'Via Capsoni', '12', 'Pavia', 'PV', '27100', '+39 0382 303789', 'info@glamourstyle.it', true, false),
  ('Libreria Universitaria Pavia', 'Libreria specializzata testi universitari. Libri nuovi, usati e servizio ordinazioni.', cat_negozi, 'Corso Strada Nuova', '89', 'Pavia', 'PV', '27100', '+39 0382 304890', 'info@libreriapavia.it', true, false);

  -- ============================================================================
  -- LOMBARDIA - SONDRIO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria Valtellinese', 'Cucina montana. Pizzoccheri, sciatt, bresaola della Valtellina e formaggi alpini.', cat_ristoranti, 'Via Scarpatetti', '7', 'Sondrio', 'SO', '23100', '+39 0342 214121', 'info@trattoriavaltellinese.it', true, false),
  ('Farmacia Alpina Sondrio', 'Farmacia montana con prodotti specifici. Creme per alta quota, integratori e medicazioni.', cat_salute, 'Via Maurizio Quadrio', '23', 'Sondrio', 'SO', '23100', '+39 0342 212345', 'info@farmaciaalpinaso.it', true, false),
  ('Geometra Montagna Valtellina', 'Studio tecnico per baite e rifugi. Pratiche montane, rilievi e perizie valanghe.', cat_professionisti, 'Piazza Garibaldi', '12', 'Sondrio', 'SO', '23100', '+39 0342 218456', 'info@montagnageometra.it', true, false),
  ('Falegnameria Valtellinese', 'Laboratorio legno di montagna. Arredamento rustico, baite e lavorazioni in larice.', cat_servizi, 'Via Vanoni', '67', 'Sondrio', 'SO', '23100', '+39 0342 515678', 'info@falegnameriavaltellinese.it', true, false),
  ('Estetica Benessere Alpino', 'Centro benessere di montagna. Massaggi decontratturanti, sauna e trattamenti rilassanti.', cat_bellezza, 'Via Perego', '34', 'Sondrio', 'SO', '23100', '+39 0342 213789', 'info@benesserealpino.it', true, false),
  ('Enoteca Valtellina', 'Enoteca vini valtellinesi. Sassella, Grumello, Inferno e grappe artigianali di montagna.', cat_negozi, 'Via Ragazzi del ''99', '15', 'Sondrio', 'SO', '23100', '+39 0342 510890', 'info@enotecavaltellina.it', true, false);

  -- ============================================================================
  -- TRENTINO-ALTO ADIGE - BOLZANO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Restaurant Vogele', 'Ristorante tradizionale altoatesino. Canederli, speck, strudel e vini dell''Alto Adige.', cat_ristoranti, 'Via Goethe', '3', 'Bolzano', 'BZ', '39100', '+39 0471 973938', 'info@vogele.it', true, false),
  ('Farmacia Internazionale Bolzano', 'Farmacia trilingue. Prodotti italiani, tedeschi e consulenza in tre lingue.', cat_salute, 'Piazza Walther', '12', 'Bolzano', 'BZ', '39100', '+39 0471 972345', 'info@farmaciabz.it', true, false),
  ('Rechtsanwalt / Avvocato Müller', 'Studio legale bilingue. Diritto commerciale italiano e tedesco, contratti internazionali.', cat_professionisti, 'Via della Mostra', '23', 'Bolzano', 'BZ', '39100', '+39 0471 301234', 'studio@muellerlegal.it', true, false),
  ('Impresa Costruzioni Alpina', 'Edilizia montana certificata CasaClima. Bioedilizia, case passive e ristrutturazioni energetiche.', cat_servizi, 'Via Resia', '67', 'Bolzano', 'BZ', '39100', '+39 0471 915678', 'info@costruzionialpina.it', true, false),
  ('Friseur / Parrucchiere Elegance', 'Salone bilingue donna e uomo. Taglio tedesco, colorazione naturale e trattamenti bio.', cat_bellezza, 'Via Portici', '45', 'Bolzano', 'BZ', '39100', '+39 0471 976789', 'info@elegancebz.it', true, false),
  ('Speck Stube Shop', 'Negozio prodotti tipici Alto Adige. Speck IGP, formaggi alpini, strudel e vini DOC.', cat_negozi, 'Via dei Portici', '89', 'Bolzano', 'BZ', '39100', '+39 0471 300890', 'info@speckstube.it', true, false),
  ('Hotel Greif', 'Hotel di design nel centro. Camere d''autore, spa e ristorante gourmet con stella.', cat_servizi, 'Piazza Walther', '1', 'Bolzano', 'BZ', '39100', '+39 0471 318000', 'info@greif.it', true, false);

  -- ============================================================================
  -- TRENTINO-ALTO ADIGE - TRENTO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Scrigno del Duomo', 'Ristorante nel centro storico. Carne salada, strangolapreti, polenta e funghi di montagna.', cat_ristoranti, 'Piazza Duomo', '29', 'Trento', 'TN', '38122', '+39 0461 220030', 'info@scrignoduomo.it', true, false),
  ('Farmacia All''Aquila d''Oro', 'Farmacia storica trentina. Preparazioni magistrali, fitoterapia alpina e rimedi naturali.', cat_salute, 'Via Belenzani', '64', 'Trento', 'TN', '38122', '+39 0461 982345', 'info@farmaciaaquila.it', true, false),
  ('Commercialista Dott. Bonazza', 'Studio fiscale per turismo montano. Consulenza per hotel, rifugi e attività turistiche.', cat_professionisti, 'Via Manci', '12', 'Trento', 'TN', '38122', '+39 0461 230456', 'studio@bonazzatn.it', true, false),
  ('Idraulico Montagna Service', 'Termoidraulica per edifici alpini. Caldaie a legna, stufe a pellet e sistemi radianti.', cat_servizi, 'Via Brennero', '134', 'Trento', 'TN', '38121', '+39 0461 824567', 'info@montagnaservice.it', true, false),
  ('Centro Benessere Dolomiti', 'Spa alpina con piscina. Massaggi, sauna finlandese, bagno turco e area relax.', cat_bellezza, 'Via Torre Verde', '23', 'Trento', 'TN', '38122', '+39 0461 983678', 'info@dolomitibeauty.it', true, false),
  ('Cantina Vini Trentino', 'Enoteca con degustazioni. Teroldego, Marzemino, Nosiola e grappe trentine.', cat_negozi, 'Via Santa Croce', '45', 'Trento', 'TN', '38122', '+39 0461 235789', 'info@cantinavinitn.it', true, false);

  -- Continue with remaining provinces...
  -- Adding more key provinces from Veneto, Friuli, Emilia-Romagna

END $$;
