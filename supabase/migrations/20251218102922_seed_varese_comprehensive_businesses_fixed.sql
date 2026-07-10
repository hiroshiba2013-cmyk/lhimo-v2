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
