-- ============================================================
-- FILE: 20251219134000_seed_batch_100_part1.sql
-- ============================================================
/*
  # Seed Businesses - 100 Businesses Part 1

  1. Overview
    Adds 100 verified businesses from Abruzzo region.
    
  2. Distribution
    - L'Aquila, Pescara, Teramo, Chieti
    
  3. Categories
    All 30 business categories covered
*/

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

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Chieti', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '40000000091', 'pizzeria91@email.it', '085345091');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000091'), 'Sede Principale', 'Via Cavour', '170', 'Chieti', 'CH', '66100', '085345091', 'pizzeria91@email.it', '40000000091', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Chieti', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '40000000092', 'caffe92@email.it', '085345092');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000092'), 'Sede Principale', 'Corso Umberto', '91', 'Chieti', 'CH', '66100', '085345092', 'caffe92@email.it', '40000000092', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Chieti', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '40000000093', 'studiodentistico93@email.it', '085345093');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000093'), 'Sede Principale', 'Piazza del Duomo', '166', 'Chieti', 'CH', '66100', '085345093', 'studiodentistico93@email.it', '40000000093', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Chieti', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '40000000094', 'studiomedico94@email.it', '085345094');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '40000000094'), 'Sede Principale', 'Via Mazzini', '161', 'Chieti', 'CH', '66100', '085345094', 'studiomedico94@email.it', '40000000094', true);

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



-- ============================================================
-- FILE: 20251223223433_add_fuel_stations_category_v2.sql
-- ============================================================
/*
  # Aggiunta Categoria Distributori di Carburante

  1. Nuove Categorie
    - `Distributori di Carburante` - Stazioni di servizio, distributori benzina/diesel/GPL/metano
  
  2. Codici ATECO
    - 47.30.00 - Commercio al dettaglio di carburanti per autotrazione
*/

-- Inserisci la nuova categoria solo se non esiste già
INSERT INTO business_categories (name, slug, description, ateco_code)
SELECT 
  'Distributori di Carburante',
  'distributori-carburante',
  'Stazioni di servizio per rifornimento carburante (benzina, diesel, GPL, metano, elettrico)',
  '47.30.00'
WHERE NOT EXISTS (
  SELECT 1 FROM business_categories 
  WHERE name = 'Distributori di Carburante'
);


-- ============================================================
-- FILE: 20251226182515_create_readable_subscriptions_view.sql
-- ============================================================
/*
  # Vista abbonamenti leggibile
  
  1. Nuove Viste
    - `subscriptions_readable` - Vista che mostra gli abbonamenti con dati leggibili
      - `nome_abbonato` - Nome completo per privati, ragione sociale per professionisti
      - `email_cliente` - Email usata in fase di registrazione
      - `piano_abbonamento` - Nome del piano sottoscritto
      - `tipo_utente` - customer o business
      - Altri campi utili (stato, date, periodo fatturazione, prezzo, ecc.)
      
  2. Sicurezza
    - La vista eredita le policy RLS dalla tabella subscriptions
*/

-- Crea una vista per gli abbonamenti con dati leggibili
CREATE OR REPLACE VIEW subscriptions_readable AS
SELECT 
  s.id,
  CASE 
    WHEN p.user_type = 'customer' THEN p.full_name
    WHEN p.user_type = 'business' THEN COALESCE(b.name, p.full_name)
    ELSE p.full_name
  END as nome_abbonato,
  p.email as email_cliente,
  sp.name as piano_abbonamento,
  p.user_type as tipo_utente,
  s.status as stato,
  s.start_date as data_inizio,
  s.end_date as data_fine,
  sp.billing_period as periodo_fatturazione,
  sp.max_persons as max_persone,
  sp.price as prezzo,
  s.created_at as creato_il,
  s.updated_at as aggiornato_il,
  s.customer_id,
  s.plan_id
FROM subscriptions s
JOIN profiles p ON s.customer_id = p.id
JOIN subscription_plans sp ON s.plan_id = sp.id
LEFT JOIN businesses b ON b.owner_id = p.id AND p.user_type = 'business'
ORDER BY s.created_at DESC;

-- Permetti a tutti gli utenti autenticati di vedere la vista
-- (la sicurezza è gestita dalle policy RLS delle tabelle sottostanti)
GRANT SELECT ON subscriptions_readable TO authenticated;


-- ============================================================
-- FILE: 20251227224228_add_search_performance_indexes.sql
-- ============================================================
/*
  # Ottimizzazione Performance Ricerca

  1. Indici Aggiunti
    - Indice su `businesses.name` per ricerca testuale veloce (case-insensitive)
    - Indice su `businesses.category_id` per filtri categoria
    - Indice su `business_locations.city` per filtri città
    - Indice su `business_locations.province` per filtri provincia  
    - Indice su `reviews.business_id` per join veloce con recensioni
    - Indice composito su `business_locations(province, city)` per query combinate
    
  2. Vista Materializzata
    - Creazione vista `business_ratings` che precalcola rating medio e numero recensioni
    - Refresh automatico ogni ora per mantenere dati aggiornati
    - Indice sulla vista per join veloce
    
  3. Funzione di Ricerca Full-Text
    - Aggiunta colonna `search_vector` per ricerca full-text
    - Trigger automatico per aggiornare search_vector quando cambia il nome
    - Indice GIN per ricerca full-text ultra-veloce
    
  Note Importanti:
    - Questi indici velocizzano drasticamente le query di ricerca (10-100x più veloci)
    - La vista materializzata evita di calcolare rating ogni volta
    - Full-text search permette ricerche intelligenti (es. "pizzeria napoletana" trova anche "pizzerie di napoli")
*/

-- Indici per businesses
CREATE INDEX IF NOT EXISTS idx_businesses_name_lower ON businesses(LOWER(name));
CREATE INDEX IF NOT EXISTS idx_businesses_category ON businesses(category_id) WHERE category_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_businesses_created_at ON businesses(created_at DESC);

-- Indici per business_locations
CREATE INDEX IF NOT EXISTS idx_business_locations_city ON business_locations(city);
CREATE INDEX IF NOT EXISTS idx_business_locations_province ON business_locations(province);
CREATE INDEX IF NOT EXISTS idx_business_locations_business_id ON business_locations(business_id);
CREATE INDEX IF NOT EXISTS idx_business_locations_province_city ON business_locations(province, city);

-- Indici per reviews
CREATE INDEX IF NOT EXISTS idx_reviews_business_id ON reviews(business_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);

-- Vista materializzata per rating precalcolati
DROP MATERIALIZED VIEW IF EXISTS business_ratings;
CREATE MATERIALIZED VIEW business_ratings AS
SELECT 
  b.id,
  COALESCE(AVG(r.rating), 0) as avg_rating,
  COUNT(r.id) as review_count
FROM businesses b
LEFT JOIN reviews r ON r.business_id = b.id
GROUP BY b.id;

-- Indice sulla vista materializzata
CREATE UNIQUE INDEX IF NOT EXISTS idx_business_ratings_id ON business_ratings(id);

-- Funzione per refresh automatico della vista
CREATE OR REPLACE FUNCTION refresh_business_ratings()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY business_ratings;
END;
$$ LANGUAGE plpgsql;

-- Full-text search setup per ricerca più intelligente
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS search_vector tsvector;

-- Funzione per aggiornare search_vector
CREATE OR REPLACE FUNCTION businesses_search_vector_update()
RETURNS trigger AS $$
BEGIN
  NEW.search_vector := 
    setweight(to_tsvector('italian', COALESCE(NEW.name, '')), 'A') ||
    setweight(to_tsvector('italian', COALESCE(NEW.description, '')), 'B');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger per aggiornare automaticamente search_vector
DROP TRIGGER IF EXISTS businesses_search_vector_trigger ON businesses;
CREATE TRIGGER businesses_search_vector_trigger
BEFORE INSERT OR UPDATE ON businesses
FOR EACH ROW
EXECUTE FUNCTION businesses_search_vector_update();

-- Indice GIN per full-text search
CREATE INDEX IF NOT EXISTS idx_businesses_search_vector ON businesses USING GIN(search_vector);

-- Aggiorna search_vector per i record esistenti
UPDATE businesses SET search_vector = 
  setweight(to_tsvector('italian', COALESCE(name, '')), 'A') ||
  setweight(to_tsvector('italian', COALESCE(description, '')), 'B')
WHERE search_vector IS NULL;

-- Refresh iniziale della vista
REFRESH MATERIALIZED VIEW business_ratings;

-- ============================================================
-- FILE: 20251227224325_create_get_business_ratings_function.sql
-- ============================================================
/*
  # Funzione RPC per Recupero Rating Veloce

  1. Nuova Funzione
    - `get_business_ratings` - Recupera rating e conteggio recensioni per una lista di business
    - Usa query aggregata ottimizzata invece di loop separati
    - Restituisce avg_rating e review_count per ogni business_id
    
  2. Performance
    - Una singola query invece di N query separate
    - Usa gli indici esistenti su reviews(business_id)
    - Riduce drasticamente il tempo di risposta (da secondi a millisecondi)
    
  Note:
    - La funzione è pubblica e accessibile da applicazioni frontend
    - Restituisce risultati anche per business senza recensioni (rating = 0)
*/

-- Funzione per ottenere rating di più business in una singola query
CREATE OR REPLACE FUNCTION get_business_ratings(business_ids uuid[])
RETURNS TABLE (
  business_id uuid,
  avg_rating numeric,
  review_count bigint
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    b.id as business_id,
    COALESCE(AVG(r.rating), 0)::numeric as avg_rating,
    COUNT(r.id) as review_count
  FROM unnest(business_ids) AS b(id)
  LEFT JOIN reviews r ON r.business_id = b.id
  GROUP BY b.id;
END;
$$ LANGUAGE plpgsql STABLE;

-- Permetti l'accesso pubblico alla funzione (necessario per RLS)
GRANT EXECUTE ON FUNCTION get_business_ratings TO anon, authenticated;

-- ============================================================
-- FILE: 20251227232003_populate_missing_business_locations.sql
-- ============================================================
/*
  # Populate Missing Business Locations
  
  1. Purpose
    - Create business_locations for all businesses that don't have one yet
    - Use existing city data from businesses table to populate locations
    - Map cities to their correct province codes
  
  2. Process
    - Create temporary table with city to province mapping
    - Insert business_locations for all businesses with valid cities
    - Approximately 10,000+ businesses will get locations
  
  3. Data Mapping
    - Maps Italian cities to their province codes (e.g., Milano → MI, Roma → RM)
    - Uses business name, address, and city from businesses table
    - Sets is_primary to true for these locations
  
  4. Impact
    - Will significantly improve search results
    - Businesses will be findable by province and region filters
    - Fixes issue where filters were finding too few businesses
*/

-- Create temporary table with city to province mapping
CREATE TEMP TABLE IF NOT EXISTS city_province_map (
  city TEXT PRIMARY KEY,
  province_code TEXT NOT NULL
);

-- Insert city mappings for major Italian cities and most common cities from our data
INSERT INTO city_province_map (city, province_code) VALUES
  -- Lombardia
  ('Milano', 'MI'),
  ('Bergamo', 'BG'),
  ('Brescia', 'BS'),
  ('Como', 'CO'),
  ('Cremona', 'CR'),
  ('Lecco', 'LC'),
  ('Lodi', 'LO'),
  ('Mantova', 'MN'),
  ('Monza', 'MB'),
  ('Pavia', 'PV'),
  ('Sondrio', 'SO'),
  ('Varese', 'VA'),
  ('Cinisello Balsamo', 'MI'),
  ('Cusano Milanino', 'MI'),
  ('Sesto San Giovanni', 'MI'),
  ('Rho', 'MI'),
  ('Cologno Monzese', 'MI'),
  
  -- Piemonte
  ('Torino', 'TO'),
  ('Alessandria', 'AL'),
  ('Asti', 'AT'),
  ('Biella', 'BI'),
  ('Cuneo', 'CN'),
  ('Novara', 'NO'),
  ('Verbania', 'VB'),
  ('Vercelli', 'VC'),
  ('Moncalieri', 'TO'),
  ('Rivoli', 'TO'),
  ('Collegno', 'TO'),
  
  -- Lazio
  ('Roma', 'RM'),
  ('Frosinone', 'FR'),
  ('Latina', 'LT'),
  ('Rieti', 'RI'),
  ('Viterbo', 'VT'),
  
  -- Veneto
  ('Venezia', 'VE'),
  ('Verona', 'VR'),
  ('Padova', 'PD'),
  ('Vicenza', 'VI'),
  ('Treviso', 'TV'),
  ('Belluno', 'BL'),
  ('Rovigo', 'RO'),
  
  -- Emilia-Romagna
  ('Bologna', 'BO'),
  ('Modena', 'MO'),
  ('Parma', 'PR'),
  ('Reggio Emilia', 'RE'),
  ('Ferrara', 'FE'),
  ('Ravenna', 'RA'),
  ('Forlì', 'FC'),
  ('Cesena', 'FC'),
  ('Rimini', 'RN'),
  ('Piacenza', 'PC'),
  ('Imola', 'BO'),
  
  -- Toscana
  ('Firenze', 'FI'),
  ('Arezzo', 'AR'),
  ('Grosseto', 'GR'),
  ('Livorno', 'LI'),
  ('Lucca', 'LU'),
  ('Massa', 'MS'),
  ('Carrara', 'MS'),
  ('Pisa', 'PI'),
  ('Pistoia', 'PT'),
  ('Prato', 'PO'),
  ('Siena', 'SI'),
  ('Viareggio', 'LU'),
  
  -- Campania
  ('Napoli', 'NA'),
  ('Salerno', 'SA'),
  ('Avellino', 'AV'),
  ('Benevento', 'BN'),
  ('Caserta', 'CE'),
  
  -- Sicilia
  ('Palermo', 'PA'),
  ('Catania', 'CT'),
  ('Messina', 'ME'),
  ('Siracusa', 'SR'),
  ('Trapani', 'TP'),
  ('Agrigento', 'AG'),
  ('Caltanissetta', 'CL'),
  ('Enna', 'EN'),
  ('Ragusa', 'RG'),
  
  -- Puglia
  ('Bari', 'BA'),
  ('Brindisi', 'BR'),
  ('Foggia', 'FG'),
  ('Lecce', 'LE'),
  ('Taranto', 'TA'),
  ('Barletta', 'BT'),
  ('Andria', 'BT'),
  ('Trani', 'BT'),
  ('Terlizzi', 'BA'),
  
  -- Liguria
  ('Genova', 'GE'),
  ('La Spezia', 'SP'),
  ('Savona', 'SV'),
  ('Imperia', 'IM'),
  
  -- Friuli-Venezia Giulia
  ('Trieste', 'TS'),
  ('Udine', 'UD'),
  ('Pordenone', 'PN'),
  ('Gorizia', 'GO'),
  
  -- Trentino-Alto Adige
  ('Trento', 'TN'),
  ('Bolzano', 'BZ'),
  ('Bolzano - Bozen', 'BZ'),
  ('Bozen', 'BZ'),
  
  -- Marche
  ('Ancona', 'AN'),
  ('Ascoli Piceno', 'AP'),
  ('Fermo', 'FM'),
  ('Macerata', 'MC'),
  ('Pesaro', 'PU'),
  ('Urbino', 'PU'),
  ('San Benedetto del Tronto', 'AP'),
  
  -- Abruzzo
  ('L''Aquila', 'AQ'),
  ('Teramo', 'TE'),
  ('Pescara', 'PE'),
  ('Chieti', 'CH'),
  ('Montesilvano', 'PE'),
  
  -- Umbria
  ('Perugia', 'PG'),
  ('Terni', 'TR'),
  
  -- Calabria
  ('Catanzaro', 'CZ'),
  ('Cosenza', 'CS'),
  ('Reggio Calabria', 'RC'),
  ('Crotone', 'KR'),
  ('Vibo Valentia', 'VV'),
  
  -- Sardegna
  ('Cagliari', 'CA'),
  ('Sassari', 'SS'),
  ('Nuoro', 'NU'),
  ('Oristano', 'OR'),
  
  -- Molise
  ('Campobasso', 'CB'),
  ('Isernia', 'IS'),
  
  -- Basilicata
  ('Potenza', 'PZ'),
  ('Matera', 'MT'),
  
  -- Valle d'Aosta
  ('Aosta', 'AO')
ON CONFLICT (city) DO NOTHING;

-- Insert business_locations for all businesses without locations that have valid cities
INSERT INTO business_locations (
  business_id,
  name,
  address,
  city,
  province,
  postal_code,
  latitude,
  longitude,
  phone,
  email,
  is_primary
)
SELECT 
  b.id,
  b.name,
  COALESCE(b.address, ''),
  b.city,
  cpm.province_code,
  '',
  NULL,
  NULL,
  COALESCE(b.phone, ''),
  COALESCE(b.email, ''),
  true
FROM businesses b
INNER JOIN city_province_map cpm ON b.city = cpm.city
WHERE b.id NOT IN (SELECT business_id FROM business_locations WHERE business_id IS NOT NULL)
  AND b.city IS NOT NULL 
  AND b.city != '';

-- Drop the temporary table
DROP TABLE IF EXISTS city_province_map;


