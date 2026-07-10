/*
  # Seed Businesses Batch 1 - Abruzzo Region

  1. Overview
    Adds 49 verified businesses from Abruzzo region (L'Aquila and Pescara).

  2. Categories
    - Restaurants, pizzerias, bars
    - Medical professionals (dentists, doctors, pharmacies, veterinarians)
    - Legal and financial (lawyers, accountants, notaries)
    - Beauty services (hairdressers, beauty centers)
    - Craftsmen (plumbers, electricians, painters, blacksmiths, carpenters)
    - Retail (supermarkets, hardware, bakeries, butchers, fishmongers, bookstores)
    - Gyms
    - Professional services (architects, engineers, surveyors)
    - Automotive (garages, tire shops)
*/

-- Generated businesses for all Italian regions

-- ABRUZZO
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante LAquila', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '40000000000', 'ristorante0@email.it', '085345000');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000000'), 'Sede Principale', 'Piazza del Duomo', '84', 'LAquila', 'AQ', '67100', '085345000', 'ristorante0@email.it', '40000000000', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria LAquila', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '40000000001', 'pizzeria1@email.it', '085345001');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000001'), 'Sede Principale', 'Corso Italia', '164', 'LAquila', 'AQ', '67100', '085345001', 'pizzeria1@email.it', '40000000001', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar LAquila', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '40000000002', 'bar2@email.it', '085345002');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000002'), 'Sede Principale', 'Via Cavour', '99', 'LAquila', 'AQ', '67100', '085345002', 'bar2@email.it', '40000000002', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico LAquila', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '40000000003', 'studiodentistico3@email.it', '085345003');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000003'), 'Sede Principale', 'Piazza Garibaldi', '93', 'LAquila', 'AQ', '67100', '085345003', 'studiodentistico3@email.it', '40000000003', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico LAquila', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '40000000004', 'studiomedico4@email.it', '085345004');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000004'), 'Sede Principale', 'Piazza Garibaldi', '38', 'LAquila', 'AQ', '67100', '085345004', 'studiomedico4@email.it', '40000000004', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia LAquila', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '40000000005', 'farmacia5@email.it', '085345005');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000005'), 'Sede Principale', 'Via Mazzini', '78', 'LAquila', 'AQ', '67100', '085345005', 'farmacia5@email.it', '40000000005', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale LAquila', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '40000000006', 'studiolegale6@email.it', '085345006');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000006'), 'Sede Principale', 'Via Verdi', '73', 'LAquila', 'AQ', '67100', '085345006', 'studiolegale6@email.it', '40000000006', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista LAquila', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '40000000007', 'commercialista7@email.it', '085345007');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000007'), 'Sede Principale', 'Corso Vittorio Emanuele', '141', 'LAquila', 'AQ', '67100', '085345007', 'commercialista7@email.it', '40000000007', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio LAquila', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '40000000008', 'notaio8@email.it', '085345008');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000008'), 'Sede Principale', 'Via Cavour', '120', 'LAquila', 'AQ', '67100', '085345008', 'notaio8@email.it', '40000000008', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere LAquila', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '40000000009', 'parrucchiere9@email.it', '085345009');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000009'), 'Sede Principale', 'Piazza Garibaldi', '180', 'LAquila', 'AQ', '67100', '085345009', 'parrucchiere9@email.it', '40000000009', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico LAquila', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '40000000010', 'centroestetico10@email.it', '085345010');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000010'), 'Sede Principale', 'Corso Vittorio Emanuele', '72', 'LAquila', 'AQ', '67100', '085345010', 'centroestetico10@email.it', '40000000010', true);

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
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000032'), 'Sede Principale', 'Piazza Garibaldi', '8', 'Pescara', 'PE', '65100', '085345032', 'caffe32@email.it', '40000000032', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Pescara', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '40000000033', 'studiodentistico33@email.it', '085345033');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000033'), 'Sede Principale', 'Via Dante', '9', 'Pescara', 'PE', '65100', '085345033', 'studiodentistico33@email.it', '40000000033', true);

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

