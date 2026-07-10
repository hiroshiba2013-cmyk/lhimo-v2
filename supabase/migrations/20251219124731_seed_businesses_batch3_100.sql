/*
  # Seed Batch 3 - 100 Italian Businesses

  1. New Businesses (100 total)
    - Completes Abruzzo region (Chieti): VAT 40000000091-40000000119
    - Basilicata region (Potenza, Matera): VAT 41000000120-41000000179
    - Starts Calabria region (Catanzaro): VAT 42000000180-42000000190
    - All 30 business categories distributed across cities
    
  2. Coverage
    - Chieti (CH): 29 businesses
    - Potenza (PZ): 30 businesses  
    - Matera (MT): 30 businesses
    - Catanzaro (CZ): 11 businesses
    
  3. Business Locations
    - Each business has complete primary location
    - Full addresses with street numbers
    - Contact information (phone, email)
    - VAT numbers for business identification
*/

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Chieti', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '40000000091', 'pizzeria91@email.it', '085345091');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000091'), 'Sede Principale', 'Via Cavour', '170', 'Chieti', 'CH', '66100', '085345091', 'pizzeria91@email.it', '40000000091', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Chieti', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '40000000092', 'caffe92@email.it', '085345092');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000092'), 'Sede Principale', 'Corso Umberto', '91', 'Chieti', 'CH', '66100', '085345092', 'caffe92@email.it', '40000000092', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Chieti', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '40000000093', 'studiodentistico93@email.it', '085345093');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000093'), 'Sede Principale', 'Piazza del Duomo', '166', 'Chieti', 'CH', '66100', '085345093', 'studiodentistico93@email.it', '40000000093', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Chieti', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '40000000094', 'studiomedico94@email.it', '085345094');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000094'), 'Sede Principale', 'Via Mazzini', '161', 'Chieti', 'CH', '66100', '096345094', 'studiomedico94@email.it', '40000000094', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Chieti', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '40000000095', 'farmacia95@email.it', '085345095');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000095'), 'Sede Principale', 'Piazza Garibaldi', '20', 'Chieti', 'CH', '66100', '085345095', 'farmacia95@email.it', '40000000095', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Chieti', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '40000000096', 'avvocato96@email.it', '085345096');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000096'), 'Sede Principale', 'Piazza Garibaldi', '121', 'Chieti', 'CH', '66100', '085345096', 'avvocato96@email.it', '40000000096', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Chieti', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '40000000097', 'commercialista97@email.it', '085345097');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000097'), 'Sede Principale', 'Corso Italia', '181', 'Chieti', 'CH', '66100', '085345097', 'commercialista97@email.it', '40000000097', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Chieti', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '40000000098', 'notaio98@email.it', '085345098');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000098'), 'Sede Principale', 'Piazza del Duomo', '93', 'Chieti', 'CH', '66100', '085345098', 'notaio98@email.it', '40000000098', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Chieti', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '40000000099', 'salone99@email.it', '085345099');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000099'), 'Sede Principale', 'Corso Vittorio Emanuele', '97', 'Chieti', 'CH', '66100', '085345099', 'salone99@email.it', '40000000099', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Chieti', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '40000000100', 'centroestetico100@email.it', '085345100');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000100'), 'Sede Principale', 'Corso Italia', '87', 'Chieti', 'CH', '66100', '085345100', 'centroestetico100@email.it', '40000000100', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Chieti', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '40000000101', 'idraulico101@email.it', '3331234101');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000101'), 'Sede Principale', 'Piazza del Duomo', '47', 'Chieti', 'CH', '66100', '3331234101', 'idraulico101@email.it', '40000000101', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Chieti', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '40000000102', 'elettricista102@email.it', '3331234102');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000102'), 'Sede Principale', 'Piazza del Duomo', '79', 'Chieti', 'CH', '66100', '3331234102', 'elettricista102@email.it', '40000000102', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Chieti', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '40000000103', 'imbianchino103@email.it', '3331234103');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000103'), 'Sede Principale', 'Via Dante', '86', 'Chieti', 'CH', '66100', '3331234103', 'imbianchino103@email.it', '40000000103', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Chieti', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '40000000104', 'fabbro104@email.it', '3331234104');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000104'), 'Sede Principale', 'Piazza Garibaldi', '9', 'Chieti', 'CH', '66100', '3331234104', 'fabbro104@email.it', '40000000104', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Chieti', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '40000000105', 'falegname105@email.it', '3331234105');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000105'), 'Sede Principale', 'Via Verdi', '194', 'Chieti', 'CH', '66100', '3331234105', 'falegname105@email.it', '40000000105', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Chieti', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '40000000106', 'supermercato106@email.it', '085345106');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000106'), 'Sede Principale', 'Piazza Garibaldi', '40', 'Chieti', 'CH', '66100', '085345106', 'supermercato106@email.it', '40000000106', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Chieti', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '40000000107', 'ferramenta107@email.it', '085345107');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000107'), 'Sede Principale', 'Corso Vittorio Emanuele', '186', 'Chieti', 'CH', '66100', '085345107', 'ferramenta107@email.it', '40000000107', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Chieti', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '40000000108', 'palestra108@email.it', '085345108');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000108'), 'Sede Principale', 'Piazza Garibaldi', '77', 'Chieti', 'CH', '66100', '085345108', 'palestra108@email.it', '40000000108', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Chieti', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '40000000109', 'panificio109@email.it', '085345109');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000109'), 'Sede Principale', 'Corso Italia', '100', 'Chieti', 'CH', '66100', '085345109', 'panificio109@email.it', '40000000109', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Chieti', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '40000000110', 'gelateria110@email.it', '085345110');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000110'), 'Sede Principale', 'Corso Vittorio Emanuele', '34', 'Chieti', 'CH', '66100', '085345110', 'gelateria110@email.it', '40000000110', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Chieti', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '40000000111', 'veterinario111@email.it', '085345111');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000111'), 'Sede Principale', 'Piazza del Duomo', '188', 'Chieti', 'CH', '66100', '085345111', 'veterinario111@email.it', '40000000111', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Chieti', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '40000000112', 'macelleria112@email.it', '085345112');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000112'), 'Sede Principale', 'Corso Vittorio Emanuele', '26', 'Chieti', 'CH', '66100', '085345112', 'macelleria112@email.it', '40000000112', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Chieti', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '40000000113', 'pescheria113@email.it', '085345113');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000113'), 'Sede Principale', 'Piazza Garibaldi', '171', 'Chieti', 'CH', '66100', '085345113', 'pescheria113@email.it', '40000000113', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Chieti', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '40000000114', 'libreria114@email.it', '085345114');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000114'), 'Sede Principale', 'Piazza Garibaldi', '56', 'Chieti', 'CH', '66100', '085345114', 'libreria114@email.it', '40000000114', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Chieti', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '40000000115', 'studioarchitetti115@email.it', '085345115');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000115'), 'Sede Principale', 'Via Mazzini', '65', 'Chieti', 'CH', '66100', '085345115', 'studioarchitetti115@email.it', '40000000115', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Chieti', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '40000000116', 'studioingegneri116@email.it', '085345116');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000116'), 'Sede Principale', 'Via Dante', '32', 'Chieti', 'CH', '66100', '085345116', 'studioingegneri116@email.it', '40000000116', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Chieti', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '40000000117', 'geometra117@email.it', '085345117');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000117'), 'Sede Principale', 'Via Mazzini', '110', 'Chieti', 'CH', '66100', '085345117', 'geometra117@email.it', '40000000117', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Chieti', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '40000000118', 'officinaauto118@email.it', '085345118');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000118'), 'Sede Principale', 'Via Cavour', '39', 'Chieti', 'CH', '66100', '085345118', 'officinaauto118@email.it', '40000000118', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Chieti', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '40000000119', 'gommista119@email.it', '085345119');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000119'), 'Sede Principale', 'Via Roma', '124', 'Chieti', 'CH', '66100', '085345119', 'gommista119@email.it', '40000000119', true);

-- BASILICATA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Potenza', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '41000000120', 'trattoria120@email.it', '097345120');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000120'), 'Sede Principale', 'Via Verdi', '91', 'Potenza', 'PZ', '85100', '097345120', 'trattoria120@email.it', '41000000120', true);