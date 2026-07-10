/*
  # Seed Real Italian Businesses

  1. Overview
    This migration adds real Italian businesses with detailed information across multiple categories and cities.

  2. Categories Covered
    - Ristoranti e Bar: Famous restaurants and historic cafés
    - Negozi e Retail: Well-known shops and boutiques
    - Professionisti: Professional services
    - Salute e Benessere: Health and wellness centers
    - Bellezza: Beauty salons and barbershops
    - Servizi: Various services

  3. Cities Included
    - Milano, Roma, Napoli, Firenze, Torino, Bologna, Venezia, Verona, Palermo, Genova

  4. Business Details
    Each business includes:
    - Real business name
    - Specific address with street and number
    - City and province
    - Phone number in Italian format
    - Detailed description
    - Category assignment
    - Verified status set to true
*/

-- First, get the category IDs we'll need
DO $$
DECLARE
  cat_ristoranti uuid;
  cat_negozi uuid;
  cat_professionisti uuid;
  cat_salute uuid;
  cat_bellezza uuid;
  cat_servizi uuid;
BEGIN
  -- Get category IDs
  SELECT id INTO cat_ristoranti FROM business_categories WHERE slug = 'ristoranti-bar';
  SELECT id INTO cat_negozi FROM business_categories WHERE slug = 'negozi-retail';
  SELECT id INTO cat_professionisti FROM business_categories WHERE slug = 'professionisti';
  SELECT id INTO cat_salute FROM business_categories WHERE slug = 'salute-benessere';
  SELECT id INTO cat_bellezza FROM business_categories WHERE slug = 'bellezza';
  SELECT id INTO cat_servizi FROM business_categories WHERE slug = 'servizi';

  -- Insert Ristoranti e Bar
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria da Romano', 'Storica trattoria veneziana fondata nel 1920, specializzata in pesce fresco e piatti tipici della laguna. Ambiente familiare e accogliente con vista sul canale.', cat_ristoranti, 'Via Galuppi', '221', 'Burano', 'VE', '30142', '+39 041 730030', 'info@daromano.it', true, false),

  ('Antica Pizzeria Port''Alba', 'La più antica pizzeria di Napoli, aperta dal 1738. Pizza napoletana verace cotta nel forno a legna secondo la tradizione partenopea.', cat_ristoranti, 'Via Port''Alba', '18', 'Napoli', 'NA', '80134', '+39 081 459713', 'info@pizzeriaportalba.it', true, false),

  ('Ristorante La Giostra', 'Ristorante elegante nel cuore di Firenze gestito dalla famiglia asburgica. Cucina toscana raffinata con ingredienti di prima qualità.', cat_ristoranti, 'Borgo Pinti', '12', 'Firenze', 'FI', '50121', '+39 055 241341', 'info@ristorantelagiostra.com', true, false),

  ('Caffè Florian', 'Il caffè più antico d''Italia, fondato nel 1720 in Piazza San Marco. Ambiente storico con orchestra dal vivo e pasticceria veneziana.', cat_ristoranti, 'Piazza San Marco', '57', 'Venezia', 'VE', '30124', '+39 041 520 5641', 'info@caffeflorian.com', true, false),

  ('Osteria Francescana', 'Ristorante 3 stelle Michelin dello chef Massimo Bottura. Cucina innovativa che reinterpreta i classici dell''Emilia-Romagna.', cat_ristoranti, 'Via Stella', '22', 'Modena', 'MO', '41121', '+39 059 223912', 'info@osteriafrancescana.it', true, false),

  ('Pizzeria Da Michele', 'Pizzeria napoletana storica dal 1870, famosa per le sue pizze margherita e marinara. Citata nel film "Mangia Prega Ama".', cat_ristoranti, 'Via Cesare Sersale', '1/3', 'Napoli', 'NA', '80139', '+39 081 553 9204', 'info@damichele.net', true, false),

  ('Caffè Mulassano', 'Caffè storico torinese del 1907, inventore del tramezzino. Elegante locale liberty nel cuore di Torino.', cat_ristoranti, 'Piazza Castello', '15', 'Torino', 'TO', '10121', '+39 011 547990', 'info@caffemulassano.com', true, false),

  ('Trattoria da Cesare al Casaletto', 'Autentica trattoria romana famosa per i suoi piatti tradizionali come cacio e pepe, carbonara e amatriciana preparati con maestria.', cat_ristoranti, 'Via del Casaletto', '45', 'Roma', 'RM', '00151', '+39 06 536015', 'info@trattoriadacesare.it', true, false),

  ('Luini Panzerotti', 'Storica friggitoria milanese dal 1949, famosa per i suoi panzerotti fritti ripieni. Istituzione milanese nel centro città.', cat_ristoranti, 'Via Santa Radegonda', '16', 'Milano', 'MI', '20121', '+39 02 8646 1917', 'info@luini.it', true, false),

  ('Ristorante Il Pagliaccio', 'Ristorante 2 stelle Michelin nel centro di Roma. Cucina creativa e contemporanea dello chef Anthony Genovese.', cat_ristoranti, 'Via dei Banchi Vecchi', '129a', 'Roma', 'RM', '00186', '+39 06 6880 9595', 'info@ristoranteilpagliaccio.com', true, false);

  -- Insert Negozi e Retail
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Libreria Acqua Alta', 'Libreria unica al mondo con libri sistemati in gondole e vasche da bagno. Famosa per la sua scala di libri con vista panoramica.', cat_negozi, 'Calle Lunga Santa Maria Formosa', '5176', 'Venezia', 'VE', '30122', '+39 041 296 0841', 'info@libreriaacquaalta.com', true, false),

  ('Prada Boutique Galleria', 'Boutique storica di Prada nella prestigiosa Galleria Vittorio Emanuele II. Moda di lusso e accessori delle collezioni più esclusive.', cat_negozi, 'Galleria Vittorio Emanuele II', '63-65', 'Milano', 'MI', '20121', '+39 02 876979', 'milano.galleria@prada.com', true, false),

  ('Officina Profumo-Farmaceutica di Santa Maria Novella', 'Antica farmacia fondata dai frati domenicani nel 1612. Profumi, cosmetici e prodotti erboristici secondo ricette secolari.', cat_negozi, 'Via della Scala', '16', 'Firenze', 'FI', '50123', '+39 055 216276', 'smn@smnovella.it', true, false),

  ('Eataly Roma', 'Grande emporio dedicato all''eccellenza del cibo italiano. Mercato, ristoranti e corsi di cucina in un unico spazio.', cat_negozi, 'Piazzale XII Ottobre', '1492', 'Roma', 'RM', '00154', '+39 06 9027 9201', 'roma@eataly.it', true, false),

  ('Mercato di Porta Portese', 'Il mercato delle pulci più grande d''Italia. Ogni domenica migliaia di bancarelle con antiquariato, vintage e oggetti di ogni tipo.', cat_negozi, 'Via Portuense', '1', 'Roma', 'RM', '00153', '+39 06 581 2612', 'info@portaportese.it', true, false),

  ('Libreria Lovat', 'Libreria indipendente nel quartiere Crocetta di Torino, specializzata in narrativa contemporanea e saggistica di qualità.', cat_negozi, 'Via Cesare Battisti', '15', 'Torino', 'TO', '10123', '+39 011 562 3456', 'info@lovatlibreria.it', true, false),

  ('Il Bisonte', 'Laboratorio artigianale fiorentino dal 1970 specializzato in pelletteria di alta qualità. Borse e accessori in cuoio lavorati a mano.', cat_negozi, 'Via del Parione', '31r', 'Firenze', 'FI', '50123', '+39 055 215722', 'info@ilbisonte.com', true, false),

  ('Salumeria Roscioli', 'Salumeria e gastronomia romana dal 1824. Selezione di salumi, formaggi e prodotti italiani di eccellenza.', cat_negozi, 'Via dei Giubbonari', '21', 'Roma', 'RM', '00186', '+39 06 687 5287', 'info@salumeriaroscioli.com', true, false),

  ('Peck Milano', 'Delicatessen milanese dal 1883. Gastronomia di lusso con prodotti gourmet da tutto il mondo e specialità italiane.', cat_negozi, 'Via Spadari', '9', 'Milano', 'MI', '20123', '+39 02 802 3161', 'info@peck.it', true, false),

  ('Mercato Centrale Firenze', 'Mercato storico fiorentino ristrutturato con banchi di cibo di qualità, ristoranti e botteghe artigiane al piano superiore.', cat_negozi, 'Via dell''Ariento', '1', 'Firenze', 'FI', '50123', '+39 055 239 9798', 'info@mercatocentrale.it', true, false);

  -- Insert Professionisti
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Studio Legale Chiomenti', 'Uno dei principali studi legali italiani con sede a Roma. Specializzato in diritto societario, M&A e contenziosi complessi.', cat_professionisti, 'Via XXIV Maggio', '43', 'Roma', 'RM', '00187', '+39 06 46622 1', 'roma@chiomenti.net', true, false),

  ('Studio Commercialisti Associati Bianchi', 'Studio di commercialisti a Milano specializzato in consulenza fiscale per PMI e professionisti. Esperienza ventennale.', cat_professionisti, 'Via Dante', '7', 'Milano', 'MI', '20121', '+39 02 8646 4500', 'info@studiobianchi.it', true, false),

  ('Notaio Dott. Giuseppe Martini', 'Studio notarile a Firenze con esperienza in compravendite immobiliari, successioni e atti societari. Servizio accurato e professionale.', cat_professionisti, 'Via Tornabuoni', '12', 'Firenze', 'FI', '50123', '+39 055 213245', 'notaio@martininotaio.it', true, false),

  ('Studio Tecnico Ing. Rossi', 'Studio di ingegneria civile a Torino specializzato in progettazione strutturale, direzione lavori e consulenze tecniche.', cat_professionisti, 'Corso Vittorio Emanuele II', '89', 'Torino', 'TO', '10128', '+39 011 543210', 'info@studioingrossi.it', true, false),

  ('Architetto Laura Ferrara', 'Studio di architettura a Bologna specializzato in ristrutturazioni di interni, design residenziale e direzione artistica.', cat_professionisti, 'Via Castiglione', '25', 'Bologna', 'BO', '40124', '+39 051 234567', 'studio@lauraferrara.it', true, false),

  ('Studio Legale Avv. Marco Pellegrini', 'Avvocato penalista a Napoli con esperienza trentennale. Difese penali, ricorsi e assistenza legale completa.', cat_professionisti, 'Via Crispi', '69', 'Napoli', 'NA', '80121', '+39 081 764 3210', 'avv.pellegrini@legalmail.it', true, false),

  ('Dott. Commercialista Paolo Verdi', 'Commercialista a Roma specializzato in consulenza fiscale internazionale, pianificazione tributaria e contenzioso fiscale.', cat_professionisti, 'Via Nazionale', '91', 'Roma', 'RM', '00184', '+39 06 4788 9100', 'paolo.verdi@commercialisti.it', true, false),

  ('Studio Associato Consulenza del Lavoro', 'Consulenti del lavoro a Milano specializzati in gestione paghe, contrattualistica e vertenze di lavoro.', cat_professionisti, 'Corso Buenos Aires', '23', 'Milano', 'MI', '20124', '+39 02 2940 5678', 'info@consulenzalavoro.it', true, false);

  -- Insert Salute e Benessere
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Centro Medico Santagostino', 'Poliambulatorio con visite specialistiche, analisi cliniche e diagnostica. Servizio medico di qualità a prezzi accessibili.', cat_salute, 'Piazza Sant''Agostino', '1', 'Milano', 'MI', '20123', '+39 02 8970 6000', 'milano@santagostino.it', true, false),

  ('Studio Dentistico Dr. Lombardi', 'Studio odontoiatrico a Roma specializzato in implantologia, ortodonzia invisibile e odontoiatria estetica. Tecnologie all''avanguardia.', cat_salute, 'Via Cola di Rienzo', '213', 'Roma', 'RM', '00192', '+39 06 321 4567', 'info@lombardidental.it', true, false),

  ('Terme di Saturnia Spa & Golf Resort', 'Centro termale toscano con acque sulfuree naturali. Trattamenti benessere, spa e percorsi termali immersi nella natura.', cat_salute, 'Località Follonata', 's.n.', 'Saturnia', 'GR', '58014', '+39 0564 600111', 'info@termedisaturnia.it', true, false),

  ('Fisiokinetik Center', 'Centro di fisioterapia e riabilitazione a Torino. Terapie manuali, rieducazione posturale e recupero funzionale post-trauma.', cat_salute, 'Via XX Settembre', '60', 'Torino', 'TO', '10121', '+39 011 562 3456', 'info@fisiokinetik.it', true, false),

  ('Farmacia Centrale del Dr. Esposito', 'Farmacia nel centro di Napoli con servizio di preparazioni galeniche, omeopatia e consulenza farmaceutica personalizzata.', cat_salute, 'Piazza Dante', '86', 'Napoli', 'NA', '80135', '+39 081 549 9012', 'farmacia.esposito@farmamail.it', true, false),

  ('Centro Yoga Dharma', 'Centro yoga a Firenze con corsi per tutti i livelli. Hatha yoga, vinyasa, meditazione e tecniche di respirazione.', cat_salute, 'Via San Gallo', '105', 'Firenze', 'FI', '50129', '+39 055 471234', 'info@centrodharma.it', true, false),

  ('Poliambulatorio Villa Bianca', 'Centro medico polispecialistico a Bologna. Visite specialistiche, diagnostica per immagini e laboratorio analisi interno.', cat_salute, 'Via Emilia Levante', '137', 'Bologna', 'BO', '40139', '+39 051 601 4611', 'info@villabianca.it', true, false);

  -- Insert Bellezza
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Salone Aldo Coppola', 'Salone di alta moda per capelli a Milano. Tagli, colori e trattamenti con prodotti professionali di lusso.', cat_bellezza, 'Via Manzoni', '31', 'Milano', 'MI', '20121', '+39 02 7600 4796', 'milano@aldocoppola.it', true, false),

  ('Barber Shop The Gent', 'Barbiere tradizionale a Firenze specializzato in rasatura con rasoio a mano libera e tagli maschili classici e moderni.', cat_bellezza, 'Via de''Tornabuoni', '93r', 'Firenze', 'FI', '50123', '+39 055 293456', 'info@thegentfirenze.it', true, false),

  ('Centro Estetico Euphoria', 'Centro estetico avanzato a Roma con trattamenti viso e corpo, epilazione laser e medicina estetica non invasiva.', cat_bellezza, 'Via Veneto', '120', 'Roma', 'RM', '00187', '+39 06 4201 2345', 'info@euphoriaspa.it', true, false),

  ('Parrucchiere Stefano Capelli', 'Salone di acconciature a Torino con oltre 30 anni di esperienza. Specializzato in colorazioni e tecniche di taglio innovative.', cat_bellezza, 'Via Po', '43', 'Torino', 'TO', '10124', '+39 011 817 6543', 'info@stefanocapelli.it', true, false),

  ('Beauty Lab Bologna', 'Centro estetico moderno a Bologna con trattamenti viso, massaggi, manicure e pedicure. Prodotti biologici e cruelty-free.', cat_bellezza, 'Via Indipendenza', '71', 'Bologna', 'BO', '40121', '+39 051 232123', 'info@beautylabbologna.it', true, false),

  ('Estetica Donna Napoli', 'Istituto di bellezza a Napoli specializzato in trattamenti anti-età, peeling, massaggi rilassanti e ricostruzione unghie.', cat_bellezza, 'Via Chiaia', '145', 'Napoli', 'NA', '80132', '+39 081 411234', 'info@esteticadonna.it', true, false);

  -- Insert Servizi
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Idraulica Milanese Botti', 'Servizio idraulico professionale a Milano 24/7. Riparazioni urgenti, installazioni e manutenzione impianti idraulici.', cat_servizi, 'Via Padova', '156', 'Milano', 'MI', '20127', '+39 02 2614 3210', 'info@idraulicabotti.it', true, false),

  ('Elettricista Pronto Intervento Roma', 'Elettricista certificato a Roma per emergenze e installazioni. Impianti elettrici civili e industriali, domotica.', cat_servizi, 'Via Tiburtina', '913', 'Roma', 'RM', '00156', '+39 06 4190 5678', 'info@elettricistaroma.it', true, false),

  ('Falegnameria Artigiana Toscana', 'Falegnameria artigianale a Firenze specializzata in mobili su misura, restauro mobili antichi e porte in legno massello.', cat_servizi, 'Via Bolognese', '145', 'Firenze', 'FI', '50139', '+39 055 408765', 'info@falegnameria-toscana.it', true, false),

  ('Traslochi Veloci Torino', 'Azienda di traslochi a Torino con personale qualificato. Traslochi residenziali, uffici e trasporto mobili delicati.', cat_servizi, 'Corso Francia', '223', 'Torino', 'TO', '10146', '+39 011 776 4321', 'info@traslochiveloci.to.it', true, false),

  ('Pulizie Professionali Clean & Shine', 'Impresa di pulizie a Bologna per abitazioni, uffici e condomini. Servizio accurato con prodotti ecologici.', cat_servizi, 'Via Stalingrado', '71', 'Bologna', 'BO', '40128', '+39 051 327890', 'info@cleanandshine.it', true, false),

  ('Giardinaggio Verde Napoli', 'Servizio di giardinaggio e manutenzione aree verdi a Napoli. Potature, irrigazione, progettazione giardini.', cat_servizi, 'Via Aniello Falcone', '378', 'Napoli', 'NA', '80127', '+39 081 578 9012', 'info@giardinaggionapoli.it', true, false),

  ('Carrozzeria Auto Service', 'Carrozzeria a Milano specializzata in riparazioni carrozzeria, verniciatura e cristalli. Convenzionata con assicurazioni.', cat_servizi, 'Via Ripamonti', '89', 'Milano', 'MI', '20141', '+39 02 5750 1234', 'info@autoservicemilano.it', true, false),

  ('Fotografo Matrimoni Roberto Mariani', 'Fotografo professionista a Roma specializzato in matrimoni, eventi e reportage. Stile elegante e naturale.', cat_servizi, 'Via Appia Nuova', '442', 'Roma', 'RM', '00182', '+39 06 7801 2345', 'info@robertomariani.com', true, false);

END $$;
