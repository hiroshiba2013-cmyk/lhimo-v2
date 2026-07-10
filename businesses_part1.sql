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

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Potenza', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '41000000121', 'pizzeria121@email.it', '097345121');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000121'), 'Sede Principale', 'Via Cavour', '157', 'Potenza', 'PZ', '85100', '097345121', 'pizzeria121@email.it', '41000000121', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Potenza', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '41000000122', 'caffe122@email.it', '097345122');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000122'), 'Sede Principale', 'Corso Italia', '195', 'Potenza', 'PZ', '85100', '097345122', 'caffe122@email.it', '41000000122', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Potenza', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '41000000123', 'studiodentistico123@email.it', '097345123');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000123'), 'Sede Principale', 'Piazza Garibaldi', '30', 'Potenza', 'PZ', '85100', '097345123', 'studiodentistico123@email.it', '41000000123', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Potenza', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '41000000124', 'poliambulatorio124@email.it', '097345124');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000124'), 'Sede Principale', 'Via Verdi', '165', 'Potenza', 'PZ', '85100', '097345124', 'poliambulatorio124@email.it', '41000000124', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Potenza', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '41000000125', 'farmacia125@email.it', '097345125');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000125'), 'Sede Principale', 'Piazza Garibaldi', '134', 'Potenza', 'PZ', '85100', '097345125', 'farmacia125@email.it', '41000000125', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Potenza', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '41000000126', 'avvocato126@email.it', '097345126');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000126'), 'Sede Principale', 'Piazza Garibaldi', '51', 'Potenza', 'PZ', '85100', '097345126', 'avvocato126@email.it', '41000000126', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Potenza', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '41000000127', 'studiocommercialisti127@email.it', '097345127');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000127'), 'Sede Principale', 'Corso Umberto', '13', 'Potenza', 'PZ', '85100', '097345127', 'studiocommercialisti127@email.it', '41000000127', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Potenza', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '41000000128', 'notaio128@email.it', '097345128');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000128'), 'Sede Principale', 'Via Dante', '93', 'Potenza', 'PZ', '85100', '097345128', 'notaio128@email.it', '41000000128', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Potenza', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '41000000129', 'parrucchiere129@email.it', '097345129');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000129'), 'Sede Principale', 'Via Mazzini', '5', 'Potenza', 'PZ', '85100', '097345129', 'parrucchiere129@email.it', '41000000129', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Potenza', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '41000000130', 'centroestetico130@email.it', '097345130');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000130'), 'Sede Principale', 'Via Mazzini', '27', 'Potenza', 'PZ', '85100', '097345130', 'centroestetico130@email.it', '41000000130', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Potenza', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '41000000131', 'idraulico131@email.it', '3331234131');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000131'), 'Sede Principale', 'Via Verdi', '81', 'Potenza', 'PZ', '85100', '3331234131', 'idraulico131@email.it', '41000000131', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Potenza', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '41000000132', 'elettricista132@email.it', '3331234132');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000132'), 'Sede Principale', 'Corso Umberto', '135', 'Potenza', 'PZ', '85100', '3331234132', 'elettricista132@email.it', '41000000132', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Potenza', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '41000000133', 'imbianchino133@email.it', '3331234133');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000133'), 'Sede Principale', 'Via Roma', '25', 'Potenza', 'PZ', '85100', '3331234133', 'imbianchino133@email.it', '41000000133', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Potenza', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '41000000134', 'fabbro134@email.it', '3331234134');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000134'), 'Sede Principale', 'Corso Italia', '193', 'Potenza', 'PZ', '85100', '3331234134', 'fabbro134@email.it', '41000000134', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Potenza', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '41000000135', 'falegname135@email.it', '3331234135');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000135'), 'Sede Principale', 'Piazza Garibaldi', '126', 'Potenza', 'PZ', '85100', '3331234135', 'falegname135@email.it', '41000000135', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Potenza', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '41000000136', 'supermercato136@email.it', '097345136');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000136'), 'Sede Principale', 'Via Roma', '16', 'Potenza', 'PZ', '85100', '097345136', 'supermercato136@email.it', '41000000136', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Potenza', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '41000000137', 'ferramenta137@email.it', '097345137');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000137'), 'Sede Principale', 'Corso Italia', '129', 'Potenza', 'PZ', '85100', '097345137', 'ferramenta137@email.it', '41000000137', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Potenza', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '41000000138', 'palestra138@email.it', '097345138');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000138'), 'Sede Principale', 'Piazza del Duomo', '100', 'Potenza', 'PZ', '85100', '097345138', 'palestra138@email.it', '41000000138', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Potenza', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '41000000139', 'panificio139@email.it', '097345139');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000139'), 'Sede Principale', 'Via Verdi', '196', 'Potenza', 'PZ', '85100', '097345139', 'panificio139@email.it', '41000000139', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Potenza', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '41000000140', 'gelateria140@email.it', '097345140');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000140'), 'Sede Principale', 'Via Roma', '163', 'Potenza', 'PZ', '85100', '097345140', 'gelateria140@email.it', '41000000140', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Potenza', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '41000000141', 'veterinario141@email.it', '097345141');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000141'), 'Sede Principale', 'Via Dante', '182', 'Potenza', 'PZ', '85100', '097345141', 'veterinario141@email.it', '41000000141', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Potenza', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '41000000142', 'macelleria142@email.it', '097345142');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000142'), 'Sede Principale', 'Via Roma', '166', 'Potenza', 'PZ', '85100', '097345142', 'macelleria142@email.it', '41000000142', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Potenza', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '41000000143', 'pescheria143@email.it', '097345143');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000143'), 'Sede Principale', 'Via Verdi', '193', 'Potenza', 'PZ', '85100', '097345143', 'pescheria143@email.it', '41000000143', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Potenza', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '41000000144', 'libreria144@email.it', '097345144');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000144'), 'Sede Principale', 'Via Roma', '15', 'Potenza', 'PZ', '85100', '097345144', 'libreria144@email.it', '41000000144', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Potenza', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '41000000145', 'studioarchitetti145@email.it', '097345145');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000145'), 'Sede Principale', 'Corso Umberto', '71', 'Potenza', 'PZ', '85100', '097345145', 'studioarchitetti145@email.it', '41000000145', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Potenza', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '41000000146', 'ingegnere146@email.it', '097345146');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000146'), 'Sede Principale', 'Corso Vittorio Emanuele', '97', 'Potenza', 'PZ', '85100', '097345146', 'ingegnere146@email.it', '41000000146', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Potenza', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '41000000147', 'geometra147@email.it', '097345147');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000147'), 'Sede Principale', 'Corso Vittorio Emanuele', '178', 'Potenza', 'PZ', '85100', '097345147', 'geometra147@email.it', '41000000147', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Potenza', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '41000000148', 'officinaauto148@email.it', '097345148');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000148'), 'Sede Principale', 'Corso Vittorio Emanuele', '62', 'Potenza', 'PZ', '85100', '097345148', 'officinaauto148@email.it', '41000000148', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Potenza', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '41000000149', 'gommista149@email.it', '097345149');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000149'), 'Sede Principale', 'Corso Italia', '174', 'Potenza', 'PZ', '85100', '097345149', 'gommista149@email.it', '41000000149', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Matera', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '41000000150', 'trattoria150@email.it', '097345150');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000150'), 'Sede Principale', 'Piazza Garibaldi', '144', 'Matera', 'MT', '75100', '097345150', 'trattoria150@email.it', '41000000150', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Matera', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '41000000151', 'pizzeria151@email.it', '097345151');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000151'), 'Sede Principale', 'Corso Italia', '17', 'Matera', 'MT', '75100', '097345151', 'pizzeria151@email.it', '41000000151', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Matera', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '41000000152', 'barpasticceria152@email.it', '097345152');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000152'), 'Sede Principale', 'Piazza Garibaldi', '80', 'Matera', 'MT', '75100', '097345152', 'barpasticceria152@email.it', '41000000152', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Matera', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '41000000153', 'studiodentistico153@email.it', '097345153');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000153'), 'Sede Principale', 'Corso Umberto', '89', 'Matera', 'MT', '75100', '097345153', 'studiodentistico153@email.it', '41000000153', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Matera', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '41000000154', 'poliambulatorio154@email.it', '097345154');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000154'), 'Sede Principale', 'Via Cavour', '60', 'Matera', 'MT', '75100', '097345154', 'poliambulatorio154@email.it', '41000000154', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Matera', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '41000000155', 'farmacia155@email.it', '097345155');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000155'), 'Sede Principale', 'Via Dante', '48', 'Matera', 'MT', '75100', '097345155', 'farmacia155@email.it', '41000000155', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Matera', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '41000000156', 'studiolegale156@email.it', '097345156');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000156'), 'Sede Principale', 'Via Dante', '188', 'Matera', 'MT', '75100', '097345156', 'studiolegale156@email.it', '41000000156', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Matera', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '41000000157', 'studiocommercialisti157@email.it', '097345157');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000157'), 'Sede Principale', 'Corso Vittorio Emanuele', '131', 'Matera', 'MT', '75100', '097345157', 'studiocommercialisti157@email.it', '41000000157', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Matera', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '41000000158', 'notaio158@email.it', '097345158');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000158'), 'Sede Principale', 'Piazza Garibaldi', '120', 'Matera', 'MT', '75100', '097345158', 'notaio158@email.it', '41000000158', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Matera', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '41000000159', 'parrucchiere159@email.it', '097345159');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000159'), 'Sede Principale', 'Via Cavour', '130', 'Matera', 'MT', '75100', '097345159', 'parrucchiere159@email.it', '41000000159', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Matera', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '41000000160', 'centroestetico160@email.it', '097345160');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000160'), 'Sede Principale', 'Corso Umberto', '65', 'Matera', 'MT', '75100', '097345160', 'centroestetico160@email.it', '41000000160', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Matera', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '41000000161', 'idraulico161@email.it', '3331234161');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000161'), 'Sede Principale', 'Via Roma', '19', 'Matera', 'MT', '75100', '3331234161', 'idraulico161@email.it', '41000000161', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Matera', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '41000000162', 'elettricista162@email.it', '3331234162');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000162'), 'Sede Principale', 'Corso Vittorio Emanuele', '183', 'Matera', 'MT', '75100', '3331234162', 'elettricista162@email.it', '41000000162', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Matera', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '41000000163', 'imbianchino163@email.it', '3331234163');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000163'), 'Sede Principale', 'Corso Italia', '42', 'Matera', 'MT', '75100', '3331234163', 'imbianchino163@email.it', '41000000163', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Matera', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '41000000164', 'fabbro164@email.it', '3331234164');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000164'), 'Sede Principale', 'Corso Umberto', '195', 'Matera', 'MT', '75100', '3331234164', 'fabbro164@email.it', '41000000164', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Matera', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '41000000165', 'falegname165@email.it', '3331234165');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000165'), 'Sede Principale', 'Via Roma', '182', 'Matera', 'MT', '75100', '3331234165', 'falegname165@email.it', '41000000165', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Matera', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '41000000166', 'supermercato166@email.it', '097345166');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000166'), 'Sede Principale', 'Corso Italia', '130', 'Matera', 'MT', '75100', '097345166', 'supermercato166@email.it', '41000000166', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Matera', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '41000000167', 'ferramenta167@email.it', '097345167');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000167'), 'Sede Principale', 'Via Verdi', '48', 'Matera', 'MT', '75100', '097345167', 'ferramenta167@email.it', '41000000167', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Matera', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '41000000168', 'palestra168@email.it', '097345168');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000168'), 'Sede Principale', 'Via Roma', '82', 'Matera', 'MT', '75100', '097345168', 'palestra168@email.it', '41000000168', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Matera', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '41000000169', 'panificio169@email.it', '097345169');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000169'), 'Sede Principale', 'Corso Vittorio Emanuele', '67', 'Matera', 'MT', '75100', '097345169', 'panificio169@email.it', '41000000169', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Matera', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '41000000170', 'pasticceria170@email.it', '097345170');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000170'), 'Sede Principale', 'Via Dante', '12', 'Matera', 'MT', '75100', '097345170', 'pasticceria170@email.it', '41000000170', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Matera', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '41000000171', 'veterinario171@email.it', '097345171');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000171'), 'Sede Principale', 'Via Mazzini', '117', 'Matera', 'MT', '75100', '097345171', 'veterinario171@email.it', '41000000171', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Matera', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '41000000172', 'macelleria172@email.it', '097345172');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000172'), 'Sede Principale', 'Corso Umberto', '187', 'Matera', 'MT', '75100', '097345172', 'macelleria172@email.it', '41000000172', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Matera', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '41000000173', 'pescheria173@email.it', '097345173');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000173'), 'Sede Principale', 'Via Roma', '116', 'Matera', 'MT', '75100', '097345173', 'pescheria173@email.it', '41000000173', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Matera', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '41000000174', 'libreria174@email.it', '097345174');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000174'), 'Sede Principale', 'Via Cavour', '10', 'Matera', 'MT', '75100', '097345174', 'libreria174@email.it', '41000000174', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Matera', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '41000000175', 'architetto175@email.it', '097345175');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000175'), 'Sede Principale', 'Via Mazzini', '187', 'Matera', 'MT', '75100', '097345175', 'architetto175@email.it', '41000000175', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Matera', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '41000000176', 'studioingegneri176@email.it', '097345176');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000176'), 'Sede Principale', 'Corso Vittorio Emanuele', '154', 'Matera', 'MT', '75100', '097345176', 'studioingegneri176@email.it', '41000000176', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Matera', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '41000000177', 'geometra177@email.it', '097345177');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000177'), 'Sede Principale', 'Via Verdi', '70', 'Matera', 'MT', '75100', '097345177', 'geometra177@email.it', '41000000177', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Matera', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '41000000178', 'officinaauto178@email.it', '097345178');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000178'), 'Sede Principale', 'Piazza Garibaldi', '50', 'Matera', 'MT', '75100', '097345178', 'officinaauto178@email.it', '41000000178', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Matera', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '41000000179', 'gommista179@email.it', '097345179');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '41000000179'), 'Sede Principale', 'Via Cavour', '113', 'Matera', 'MT', '75100', '097345179', 'gommista179@email.it', '41000000179', true);

-- CALABRIA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Catanzaro', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '42000000180', 'ristorante180@email.it', '096345180');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000180'), 'Sede Principale', 'Piazza del Duomo', '147', 'Catanzaro', 'CZ', '88100', '096345180', 'ristorante180@email.it', '42000000180', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Catanzaro', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '42000000181', 'pizzeria181@email.it', '096345181');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000181'), 'Sede Principale', 'Via Cavour', '86', 'Catanzaro', 'CZ', '88100', '096345181', 'pizzeria181@email.it', '42000000181', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Catanzaro', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '42000000182', 'barpasticceria182@email.it', '096345182');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000182'), 'Sede Principale', 'Corso Italia', '159', 'Catanzaro', 'CZ', '88100', '096345182', 'barpasticceria182@email.it', '42000000182', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Catanzaro', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '42000000183', 'studiodentistico183@email.it', '096345183');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000183'), 'Sede Principale', 'Via Dante', '134', 'Catanzaro', 'CZ', '88100', '096345183', 'studiodentistico183@email.it', '42000000183', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Catanzaro', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '42000000184', 'poliambulatorio184@email.it', '096345184');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000184'), 'Sede Principale', 'Corso Umberto', '34', 'Catanzaro', 'CZ', '88100', '096345184', 'poliambulatorio184@email.it', '42000000184', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Catanzaro', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '42000000185', 'farmacia185@email.it', '096345185');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000185'), 'Sede Principale', 'Via Mazzini', '91', 'Catanzaro', 'CZ', '88100', '096345185', 'farmacia185@email.it', '42000000185', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Catanzaro', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '42000000186', 'studiolegale186@email.it', '096345186');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000186'), 'Sede Principale', 'Corso Italia', '188', 'Catanzaro', 'CZ', '88100', '096345186', 'studiolegale186@email.it', '42000000186', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Catanzaro', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '42000000187', 'commercialista187@email.it', '096345187');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000187'), 'Sede Principale', 'Via Verdi', '63', 'Catanzaro', 'CZ', '88100', '096345187', 'commercialista187@email.it', '42000000187', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Catanzaro', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '42000000188', 'notaio188@email.it', '096345188');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000188'), 'Sede Principale', 'Corso Umberto', '167', 'Catanzaro', 'CZ', '88100', '096345188', 'notaio188@email.it', '42000000188', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Catanzaro', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '42000000189', 'salone189@email.it', '096345189');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000189'), 'Sede Principale', 'Corso Vittorio Emanuele', '114', 'Catanzaro', 'CZ', '88100', '096345189', 'salone189@email.it', '42000000189', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Catanzaro', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '42000000190', 'centroestetico190@email.it', '096345190');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000190'), 'Sede Principale', 'Via Cavour', '154', 'Catanzaro', 'CZ', '88100', '096345190', 'centroestetico190@email.it', '42000000190', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Catanzaro', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '42000000191', 'idraulico191@email.it', '3331234191');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000191'), 'Sede Principale', 'Via Dante', '163', 'Catanzaro', 'CZ', '88100', '3331234191', 'idraulico191@email.it', '42000000191', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Catanzaro', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '42000000192', 'elettricista192@email.it', '3331234192');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000192'), 'Sede Principale', 'Corso Umberto', '100', 'Catanzaro', 'CZ', '88100', '3331234192', 'elettricista192@email.it', '42000000192', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Catanzaro', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '42000000193', 'imbianchino193@email.it', '3331234193');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000193'), 'Sede Principale', 'Corso Italia', '76', 'Catanzaro', 'CZ', '88100', '3331234193', 'imbianchino193@email.it', '42000000193', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Catanzaro', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '42000000194', 'fabbro194@email.it', '3331234194');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000194'), 'Sede Principale', 'Corso Vittorio Emanuele', '185', 'Catanzaro', 'CZ', '88100', '3331234194', 'fabbro194@email.it', '42000000194', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Catanzaro', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '42000000195', 'falegname195@email.it', '3331234195');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000195'), 'Sede Principale', 'Corso Umberto', '162', 'Catanzaro', 'CZ', '88100', '3331234195', 'falegname195@email.it', '42000000195', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Catanzaro', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '42000000196', 'supermercato196@email.it', '096345196');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000196'), 'Sede Principale', 'Corso Vittorio Emanuele', '185', 'Catanzaro', 'CZ', '88100', '096345196', 'supermercato196@email.it', '42000000196', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Catanzaro', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '42000000197', 'ferramenta197@email.it', '096345197');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000197'), 'Sede Principale', 'Via Cavour', '21', 'Catanzaro', 'CZ', '88100', '096345197', 'ferramenta197@email.it', '42000000197', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Catanzaro', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '42000000198', 'palestra198@email.it', '096345198');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000198'), 'Sede Principale', 'Piazza Garibaldi', '125', 'Catanzaro', 'CZ', '88100', '096345198', 'palestra198@email.it', '42000000198', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Catanzaro', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '42000000199', 'panificio199@email.it', '096345199');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000199'), 'Sede Principale', 'Corso Italia', '106', 'Catanzaro', 'CZ', '88100', '096345199', 'panificio199@email.it', '42000000199', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Catanzaro', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '42000000200', 'gelateria200@email.it', '096345200');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000200'), 'Sede Principale', 'Via Dante', '86', 'Catanzaro', 'CZ', '88100', '096345200', 'gelateria200@email.it', '42000000200', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Catanzaro', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '42000000201', 'veterinario201@email.it', '096345201');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000201'), 'Sede Principale', 'Corso Vittorio Emanuele', '9', 'Catanzaro', 'CZ', '88100', '096345201', 'veterinario201@email.it', '42000000201', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Catanzaro', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '42000000202', 'macelleria202@email.it', '096345202');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000202'), 'Sede Principale', 'Via Roma', '56', 'Catanzaro', 'CZ', '88100', '096345202', 'macelleria202@email.it', '42000000202', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Catanzaro', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '42000000203', 'pescheria203@email.it', '096345203');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000203'), 'Sede Principale', 'Corso Umberto', '108', 'Catanzaro', 'CZ', '88100', '096345203', 'pescheria203@email.it', '42000000203', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Catanzaro', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '42000000204', 'libreria204@email.it', '096345204');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000204'), 'Sede Principale', 'Piazza Garibaldi', '29', 'Catanzaro', 'CZ', '88100', '096345204', 'libreria204@email.it', '42000000204', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Catanzaro', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '42000000205', 'architetto205@email.it', '096345205');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000205'), 'Sede Principale', 'Corso Vittorio Emanuele', '157', 'Catanzaro', 'CZ', '88100', '096345205', 'architetto205@email.it', '42000000205', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Catanzaro', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '42000000206', 'studioingegneri206@email.it', '096345206');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000206'), 'Sede Principale', 'Corso Italia', '8', 'Catanzaro', 'CZ', '88100', '096345206', 'studioingegneri206@email.it', '42000000206', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Catanzaro', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '42000000207', 'geometra207@email.it', '096345207');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000207'), 'Sede Principale', 'Corso Italia', '5', 'Catanzaro', 'CZ', '88100', '096345207', 'geometra207@email.it', '42000000207', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Catanzaro', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '42000000208', 'officinaauto208@email.it', '096345208');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000208'), 'Sede Principale', 'Via Verdi', '7', 'Catanzaro', 'CZ', '88100', '096345208', 'officinaauto208@email.it', '42000000208', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Catanzaro', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '42000000209', 'gommista209@email.it', '096345209');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000209'), 'Sede Principale', 'Via Mazzini', '152', 'Catanzaro', 'CZ', '88100', '096345209', 'gommista209@email.it', '42000000209', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '42000000210', 'osteria210@email.it', '096345210');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000210'), 'Sede Principale', 'Via Cavour', '15', 'Reggio Calabria', 'RC', '89100', '096345210', 'osteria210@email.it', '42000000210', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '42000000211', 'pizzeria211@email.it', '096345211');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000211'), 'Sede Principale', 'Via Verdi', '155', 'Reggio Calabria', 'RC', '89100', '096345211', 'pizzeria211@email.it', '42000000211', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '42000000212', 'barpasticceria212@email.it', '096345212');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000212'), 'Sede Principale', 'Corso Vittorio Emanuele', '68', 'Reggio Calabria', 'RC', '89100', '096345212', 'barpasticceria212@email.it', '42000000212', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '42000000213', 'studiodentistico213@email.it', '096345213');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000213'), 'Sede Principale', 'Via Verdi', '198', 'Reggio Calabria', 'RC', '89100', '096345213', 'studiodentistico213@email.it', '42000000213', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '42000000214', 'poliambulatorio214@email.it', '096345214');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000214'), 'Sede Principale', 'Piazza del Duomo', '121', 'Reggio Calabria', 'RC', '89100', '096345214', 'poliambulatorio214@email.it', '42000000214', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '42000000215', 'farmacia215@email.it', '096345215');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000215'), 'Sede Principale', 'Corso Italia', '140', 'Reggio Calabria', 'RC', '89100', '096345215', 'farmacia215@email.it', '42000000215', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '42000000216', 'avvocato216@email.it', '096345216');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000216'), 'Sede Principale', 'Corso Vittorio Emanuele', '194', 'Reggio Calabria', 'RC', '89100', '096345216', 'avvocato216@email.it', '42000000216', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '42000000217', 'commercialista217@email.it', '096345217');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000217'), 'Sede Principale', 'Via Cavour', '53', 'Reggio Calabria', 'RC', '89100', '096345217', 'commercialista217@email.it', '42000000217', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '42000000218', 'notaio218@email.it', '096345218');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000218'), 'Sede Principale', 'Corso Vittorio Emanuele', '195', 'Reggio Calabria', 'RC', '89100', '096345218', 'notaio218@email.it', '42000000218', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '42000000219', 'salone219@email.it', '096345219');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000219'), 'Sede Principale', 'Via Dante', '47', 'Reggio Calabria', 'RC', '89100', '096345219', 'salone219@email.it', '42000000219', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '42000000220', 'centroestetico220@email.it', '096345220');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000220'), 'Sede Principale', 'Via Mazzini', '142', 'Reggio Calabria', 'RC', '89100', '096345220', 'centroestetico220@email.it', '42000000220', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '42000000221', 'idraulico221@email.it', '3331234221');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000221'), 'Sede Principale', 'Via Dante', '6', 'Reggio Calabria', 'RC', '89100', '3331234221', 'idraulico221@email.it', '42000000221', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '42000000222', 'elettricista222@email.it', '3331234222');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000222'), 'Sede Principale', 'Via Cavour', '165', 'Reggio Calabria', 'RC', '89100', '3331234222', 'elettricista222@email.it', '42000000222', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '42000000223', 'imbianchino223@email.it', '3331234223');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000223'), 'Sede Principale', 'Piazza del Duomo', '186', 'Reggio Calabria', 'RC', '89100', '3331234223', 'imbianchino223@email.it', '42000000223', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '42000000224', 'fabbro224@email.it', '3331234224');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000224'), 'Sede Principale', 'Via Roma', '148', 'Reggio Calabria', 'RC', '89100', '3331234224', 'fabbro224@email.it', '42000000224', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '42000000225', 'falegname225@email.it', '3331234225');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000225'), 'Sede Principale', 'Via Cavour', '133', 'Reggio Calabria', 'RC', '89100', '3331234225', 'falegname225@email.it', '42000000225', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '42000000226', 'supermercato226@email.it', '096345226');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000226'), 'Sede Principale', 'Via Dante', '181', 'Reggio Calabria', 'RC', '89100', '096345226', 'supermercato226@email.it', '42000000226', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '42000000227', 'ferramenta227@email.it', '096345227');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000227'), 'Sede Principale', 'Piazza Garibaldi', '163', 'Reggio Calabria', 'RC', '89100', '096345227', 'ferramenta227@email.it', '42000000227', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '42000000228', 'palestra228@email.it', '096345228');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000228'), 'Sede Principale', 'Piazza Garibaldi', '74', 'Reggio Calabria', 'RC', '89100', '096345228', 'palestra228@email.it', '42000000228', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '42000000229', 'panificio229@email.it', '096345229');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000229'), 'Sede Principale', 'Piazza Garibaldi', '5', 'Reggio Calabria', 'RC', '89100', '096345229', 'panificio229@email.it', '42000000229', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '42000000230', 'pasticceria230@email.it', '096345230');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000230'), 'Sede Principale', 'Via Dante', '70', 'Reggio Calabria', 'RC', '89100', '096345230', 'pasticceria230@email.it', '42000000230', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '42000000231', 'veterinario231@email.it', '096345231');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000231'), 'Sede Principale', 'Via Verdi', '35', 'Reggio Calabria', 'RC', '89100', '096345231', 'veterinario231@email.it', '42000000231', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '42000000232', 'macelleria232@email.it', '096345232');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000232'), 'Sede Principale', 'Via Roma', '179', 'Reggio Calabria', 'RC', '89100', '096345232', 'macelleria232@email.it', '42000000232', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '42000000233', 'pescheria233@email.it', '096345233');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000233'), 'Sede Principale', 'Via Mazzini', '54', 'Reggio Calabria', 'RC', '89100', '096345233', 'pescheria233@email.it', '42000000233', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '42000000234', 'libreria234@email.it', '096345234');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000234'), 'Sede Principale', 'Piazza Garibaldi', '178', 'Reggio Calabria', 'RC', '89100', '096345234', 'libreria234@email.it', '42000000234', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '42000000235', 'architetto235@email.it', '096345235');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000235'), 'Sede Principale', 'Corso Vittorio Emanuele', '141', 'Reggio Calabria', 'RC', '89100', '096345235', 'architetto235@email.it', '42000000235', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '42000000236', 'studioingegneri236@email.it', '096345236');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000236'), 'Sede Principale', 'Corso Umberto', '2', 'Reggio Calabria', 'RC', '89100', '096345236', 'studioingegneri236@email.it', '42000000236', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '42000000237', 'geometra237@email.it', '096345237');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000237'), 'Sede Principale', 'Corso Vittorio Emanuele', '76', 'Reggio Calabria', 'RC', '89100', '096345237', 'geometra237@email.it', '42000000237', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '42000000238', 'officinaauto238@email.it', '096345238');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000238'), 'Sede Principale', 'Piazza del Duomo', '59', 'Reggio Calabria', 'RC', '89100', '096345238', 'officinaauto238@email.it', '42000000238', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Reggio Calabria', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '42000000239', 'gommista239@email.it', '096345239');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000239'), 'Sede Principale', 'Via Cavour', '97', 'Reggio Calabria', 'RC', '89100', '096345239', 'gommista239@email.it', '42000000239', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Cosenza', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '42000000240', 'osteria240@email.it', '096345240');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000240'), 'Sede Principale', 'Corso Umberto', '115', 'Cosenza', 'CS', '87100', '096345240', 'osteria240@email.it', '42000000240', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Cosenza', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '42000000241', 'pizzeria241@email.it', '096345241');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000241'), 'Sede Principale', 'Via Cavour', '143', 'Cosenza', 'CS', '87100', '096345241', 'pizzeria241@email.it', '42000000241', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Cosenza', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '42000000242', 'caffe242@email.it', '096345242');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000242'), 'Sede Principale', 'Via Mazzini', '91', 'Cosenza', 'CS', '87100', '096345242', 'caffe242@email.it', '42000000242', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Cosenza', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '42000000243', 'studiodentistico243@email.it', '096345243');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000243'), 'Sede Principale', 'Corso Italia', '53', 'Cosenza', 'CS', '87100', '096345243', 'studiodentistico243@email.it', '42000000243', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Cosenza', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '42000000244', 'poliambulatorio244@email.it', '096345244');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000244'), 'Sede Principale', 'Via Verdi', '23', 'Cosenza', 'CS', '87100', '096345244', 'poliambulatorio244@email.it', '42000000244', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Cosenza', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '42000000245', 'farmacia245@email.it', '096345245');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000245'), 'Sede Principale', 'Piazza del Duomo', '109', 'Cosenza', 'CS', '87100', '096345245', 'farmacia245@email.it', '42000000245', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Cosenza', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '42000000246', 'avvocato246@email.it', '096345246');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000246'), 'Sede Principale', 'Piazza Garibaldi', '196', 'Cosenza', 'CS', '87100', '096345246', 'avvocato246@email.it', '42000000246', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Cosenza', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '42000000247', 'commercialista247@email.it', '096345247');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000247'), 'Sede Principale', 'Via Cavour', '129', 'Cosenza', 'CS', '87100', '096345247', 'commercialista247@email.it', '42000000247', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Cosenza', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '42000000248', 'notaio248@email.it', '096345248');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000248'), 'Sede Principale', 'Corso Umberto', '182', 'Cosenza', 'CS', '87100', '096345248', 'notaio248@email.it', '42000000248', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Cosenza', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '42000000249', 'parrucchiere249@email.it', '096345249');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000249'), 'Sede Principale', 'Corso Umberto', '49', 'Cosenza', 'CS', '87100', '096345249', 'parrucchiere249@email.it', '42000000249', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Cosenza', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '42000000250', 'centroestetico250@email.it', '096345250');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000250'), 'Sede Principale', 'Piazza del Duomo', '95', 'Cosenza', 'CS', '87100', '096345250', 'centroestetico250@email.it', '42000000250', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Cosenza', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '42000000251', 'idraulico251@email.it', '3331234251');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000251'), 'Sede Principale', 'Corso Italia', '15', 'Cosenza', 'CS', '87100', '3331234251', 'idraulico251@email.it', '42000000251', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Cosenza', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '42000000252', 'elettricista252@email.it', '3331234252');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000252'), 'Sede Principale', 'Piazza del Duomo', '192', 'Cosenza', 'CS', '87100', '3331234252', 'elettricista252@email.it', '42000000252', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Cosenza', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '42000000253', 'imbianchino253@email.it', '3331234253');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000253'), 'Sede Principale', 'Corso Vittorio Emanuele', '44', 'Cosenza', 'CS', '87100', '3331234253', 'imbianchino253@email.it', '42000000253', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Cosenza', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '42000000254', 'fabbro254@email.it', '3331234254');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000254'), 'Sede Principale', 'Piazza del Duomo', '27', 'Cosenza', 'CS', '87100', '3331234254', 'fabbro254@email.it', '42000000254', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Cosenza', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '42000000255', 'falegname255@email.it', '3331234255');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000255'), 'Sede Principale', 'Via Mazzini', '101', 'Cosenza', 'CS', '87100', '3331234255', 'falegname255@email.it', '42000000255', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Cosenza', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '42000000256', 'supermercato256@email.it', '096345256');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000256'), 'Sede Principale', 'Corso Umberto', '92', 'Cosenza', 'CS', '87100', '096345256', 'supermercato256@email.it', '42000000256', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Cosenza', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '42000000257', 'ferramenta257@email.it', '096345257');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000257'), 'Sede Principale', 'Corso Umberto', '75', 'Cosenza', 'CS', '87100', '096345257', 'ferramenta257@email.it', '42000000257', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Cosenza', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '42000000258', 'palestra258@email.it', '096345258');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000258'), 'Sede Principale', 'Piazza Garibaldi', '19', 'Cosenza', 'CS', '87100', '096345258', 'palestra258@email.it', '42000000258', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Cosenza', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '42000000259', 'panificio259@email.it', '096345259');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000259'), 'Sede Principale', 'Via Cavour', '111', 'Cosenza', 'CS', '87100', '096345259', 'panificio259@email.it', '42000000259', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Cosenza', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '42000000260', 'pasticceria260@email.it', '096345260');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000260'), 'Sede Principale', 'Via Cavour', '7', 'Cosenza', 'CS', '87100', '096345260', 'pasticceria260@email.it', '42000000260', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Cosenza', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '42000000261', 'veterinario261@email.it', '096345261');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000261'), 'Sede Principale', 'Via Roma', '138', 'Cosenza', 'CS', '87100', '096345261', 'veterinario261@email.it', '42000000261', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Cosenza', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '42000000262', 'macelleria262@email.it', '096345262');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000262'), 'Sede Principale', 'Piazza del Duomo', '5', 'Cosenza', 'CS', '87100', '096345262', 'macelleria262@email.it', '42000000262', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Cosenza', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '42000000263', 'pescheria263@email.it', '096345263');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000263'), 'Sede Principale', 'Via Verdi', '93', 'Cosenza', 'CS', '87100', '096345263', 'pescheria263@email.it', '42000000263', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Cosenza', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '42000000264', 'libreria264@email.it', '096345264');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000264'), 'Sede Principale', 'Corso Vittorio Emanuele', '81', 'Cosenza', 'CS', '87100', '096345264', 'libreria264@email.it', '42000000264', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Cosenza', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '42000000265', 'studioarchitetti265@email.it', '096345265');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000265'), 'Sede Principale', 'Via Roma', '23', 'Cosenza', 'CS', '87100', '096345265', 'studioarchitetti265@email.it', '42000000265', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Cosenza', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '42000000266', 'studioingegneri266@email.it', '096345266');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000266'), 'Sede Principale', 'Via Roma', '75', 'Cosenza', 'CS', '87100', '096345266', 'studioingegneri266@email.it', '42000000266', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Cosenza', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '42000000267', 'geometra267@email.it', '096345267');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000267'), 'Sede Principale', 'Piazza Garibaldi', '80', 'Cosenza', 'CS', '87100', '096345267', 'geometra267@email.it', '42000000267', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Cosenza', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '42000000268', 'officinaauto268@email.it', '096345268');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000268'), 'Sede Principale', 'Via Verdi', '114', 'Cosenza', 'CS', '87100', '096345268', 'officinaauto268@email.it', '42000000268', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Cosenza', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '42000000269', 'gommista269@email.it', '096345269');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '42000000269'), 'Sede Principale', 'Corso Italia', '191', 'Cosenza', 'CS', '87100', '096345269', 'gommista269@email.it', '42000000269', true);

-- FRIULI-VENEZIA GIULIA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Trieste', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '43000000270', 'trattoria270@email.it', '040345270');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000270'), 'Sede Principale', 'Via Roma', '106', 'Trieste', 'TS', '34100', '040345270', 'trattoria270@email.it', '43000000270', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Trieste', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '43000000271', 'pizzeria271@email.it', '040345271');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000271'), 'Sede Principale', 'Via Dante', '166', 'Trieste', 'TS', '34100', '040345271', 'pizzeria271@email.it', '43000000271', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Trieste', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '43000000272', 'bar272@email.it', '040345272');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000272'), 'Sede Principale', 'Via Verdi', '14', 'Trieste', 'TS', '34100', '040345272', 'bar272@email.it', '43000000272', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Trieste', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '43000000273', 'studiodentistico273@email.it', '040345273');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000273'), 'Sede Principale', 'Via Cavour', '51', 'Trieste', 'TS', '34100', '040345273', 'studiodentistico273@email.it', '43000000273', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Trieste', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '43000000274', 'studiomedico274@email.it', '040345274');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000274'), 'Sede Principale', 'Via Cavour', '152', 'Trieste', 'TS', '34100', '040345274', 'studiomedico274@email.it', '43000000274', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Trieste', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '43000000275', 'farmacia275@email.it', '040345275');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000275'), 'Sede Principale', 'Corso Vittorio Emanuele', '37', 'Trieste', 'TS', '34100', '040345275', 'farmacia275@email.it', '43000000275', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Trieste', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '43000000276', 'avvocato276@email.it', '040345276');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000276'), 'Sede Principale', 'Piazza del Duomo', '157', 'Trieste', 'TS', '34100', '040345276', 'avvocato276@email.it', '43000000276', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Trieste', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '43000000277', 'studiocommercialisti277@email.it', '040345277');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000277'), 'Sede Principale', 'Via Mazzini', '125', 'Trieste', 'TS', '34100', '040345277', 'studiocommercialisti277@email.it', '43000000277', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Trieste', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '43000000278', 'notaio278@email.it', '040345278');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000278'), 'Sede Principale', 'Via Dante', '182', 'Trieste', 'TS', '34100', '040345278', 'notaio278@email.it', '43000000278', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Trieste', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '43000000279', 'salone279@email.it', '040345279');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000279'), 'Sede Principale', 'Via Cavour', '137', 'Trieste', 'TS', '34100', '040345279', 'salone279@email.it', '43000000279', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Trieste', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '43000000280', 'centroestetico280@email.it', '040345280');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000280'), 'Sede Principale', 'Piazza del Duomo', '161', 'Trieste', 'TS', '34100', '040345280', 'centroestetico280@email.it', '43000000280', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Trieste', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '43000000281', 'idraulico281@email.it', '3331234281');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000281'), 'Sede Principale', 'Via Verdi', '87', 'Trieste', 'TS', '34100', '3331234281', 'idraulico281@email.it', '43000000281', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Trieste', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '43000000282', 'elettricista282@email.it', '3331234282');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000282'), 'Sede Principale', 'Corso Italia', '89', 'Trieste', 'TS', '34100', '3331234282', 'elettricista282@email.it', '43000000282', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Trieste', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '43000000283', 'imbianchino283@email.it', '3331234283');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000283'), 'Sede Principale', 'Piazza del Duomo', '140', 'Trieste', 'TS', '34100', '3331234283', 'imbianchino283@email.it', '43000000283', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Trieste', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '43000000284', 'fabbro284@email.it', '3331234284');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000284'), 'Sede Principale', 'Via Roma', '82', 'Trieste', 'TS', '34100', '3331234284', 'fabbro284@email.it', '43000000284', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Trieste', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '43000000285', 'falegname285@email.it', '3331234285');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000285'), 'Sede Principale', 'Via Dante', '76', 'Trieste', 'TS', '34100', '3331234285', 'falegname285@email.it', '43000000285', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Trieste', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '43000000286', 'supermercato286@email.it', '040345286');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000286'), 'Sede Principale', 'Via Verdi', '27', 'Trieste', 'TS', '34100', '040345286', 'supermercato286@email.it', '43000000286', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Trieste', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '43000000287', 'ferramenta287@email.it', '040345287');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000287'), 'Sede Principale', 'Via Cavour', '55', 'Trieste', 'TS', '34100', '040345287', 'ferramenta287@email.it', '43000000287', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Trieste', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '43000000288', 'palestra288@email.it', '040345288');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000288'), 'Sede Principale', 'Via Cavour', '172', 'Trieste', 'TS', '34100', '040345288', 'palestra288@email.it', '43000000288', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Trieste', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '43000000289', 'panificio289@email.it', '040345289');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000289'), 'Sede Principale', 'Corso Umberto', '16', 'Trieste', 'TS', '34100', '040345289', 'panificio289@email.it', '43000000289', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Trieste', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '43000000290', 'pasticceria290@email.it', '040345290');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000290'), 'Sede Principale', 'Corso Italia', '34', 'Trieste', 'TS', '34100', '040345290', 'pasticceria290@email.it', '43000000290', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Trieste', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '43000000291', 'veterinario291@email.it', '040345291');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000291'), 'Sede Principale', 'Piazza del Duomo', '117', 'Trieste', 'TS', '34100', '040345291', 'veterinario291@email.it', '43000000291', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Trieste', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '43000000292', 'macelleria292@email.it', '040345292');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000292'), 'Sede Principale', 'Piazza Garibaldi', '193', 'Trieste', 'TS', '34100', '040345292', 'macelleria292@email.it', '43000000292', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Trieste', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '43000000293', 'pescheria293@email.it', '040345293');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000293'), 'Sede Principale', 'Corso Vittorio Emanuele', '148', 'Trieste', 'TS', '34100', '040345293', 'pescheria293@email.it', '43000000293', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Trieste', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '43000000294', 'libreria294@email.it', '040345294');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000294'), 'Sede Principale', 'Via Roma', '27', 'Trieste', 'TS', '34100', '040345294', 'libreria294@email.it', '43000000294', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Trieste', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '43000000295', 'studioarchitetti295@email.it', '040345295');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000295'), 'Sede Principale', 'Via Cavour', '52', 'Trieste', 'TS', '34100', '040345295', 'studioarchitetti295@email.it', '43000000295', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Trieste', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '43000000296', 'ingegnere296@email.it', '040345296');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000296'), 'Sede Principale', 'Corso Italia', '57', 'Trieste', 'TS', '34100', '040345296', 'ingegnere296@email.it', '43000000296', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Trieste', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '43000000297', 'geometra297@email.it', '040345297');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000297'), 'Sede Principale', 'Corso Vittorio Emanuele', '127', 'Trieste', 'TS', '34100', '040345297', 'geometra297@email.it', '43000000297', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Trieste', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '43000000298', 'officinaauto298@email.it', '040345298');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000298'), 'Sede Principale', 'Corso Umberto', '43', 'Trieste', 'TS', '34100', '040345298', 'officinaauto298@email.it', '43000000298', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Trieste', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '43000000299', 'gommista299@email.it', '040345299');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000299'), 'Sede Principale', 'Corso Vittorio Emanuele', '52', 'Trieste', 'TS', '34100', '040345299', 'gommista299@email.it', '43000000299', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Udine', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '43000000300', 'trattoria300@email.it', '040345300');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000300'), 'Sede Principale', 'Via Dante', '69', 'Udine', 'UD', '33100', '040345300', 'trattoria300@email.it', '43000000300', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Udine', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '43000000301', 'pizzeria301@email.it', '040345301');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000301'), 'Sede Principale', 'Via Verdi', '170', 'Udine', 'UD', '33100', '040345301', 'pizzeria301@email.it', '43000000301', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Udine', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '43000000302', 'barpasticceria302@email.it', '040345302');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000302'), 'Sede Principale', 'Via Cavour', '114', 'Udine', 'UD', '33100', '040345302', 'barpasticceria302@email.it', '43000000302', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Udine', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '43000000303', 'studiodentistico303@email.it', '040345303');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000303'), 'Sede Principale', 'Corso Vittorio Emanuele', '1', 'Udine', 'UD', '33100', '040345303', 'studiodentistico303@email.it', '43000000303', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Udine', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '43000000304', 'poliambulatorio304@email.it', '040345304');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000304'), 'Sede Principale', 'Corso Umberto', '129', 'Udine', 'UD', '33100', '040345304', 'poliambulatorio304@email.it', '43000000304', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Udine', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '43000000305', 'farmacia305@email.it', '040345305');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000305'), 'Sede Principale', 'Corso Vittorio Emanuele', '15', 'Udine', 'UD', '33100', '040345305', 'farmacia305@email.it', '43000000305', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Udine', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '43000000306', 'avvocato306@email.it', '040345306');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000306'), 'Sede Principale', 'Corso Italia', '152', 'Udine', 'UD', '33100', '040345306', 'avvocato306@email.it', '43000000306', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Udine', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '43000000307', 'commercialista307@email.it', '040345307');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000307'), 'Sede Principale', 'Piazza del Duomo', '113', 'Udine', 'UD', '33100', '040345307', 'commercialista307@email.it', '43000000307', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Udine', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '43000000308', 'notaio308@email.it', '040345308');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000308'), 'Sede Principale', 'Corso Italia', '109', 'Udine', 'UD', '33100', '040345308', 'notaio308@email.it', '43000000308', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Udine', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '43000000309', 'parrucchiere309@email.it', '040345309');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000309'), 'Sede Principale', 'Via Cavour', '22', 'Udine', 'UD', '33100', '040345309', 'parrucchiere309@email.it', '43000000309', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Udine', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '43000000310', 'centroestetico310@email.it', '040345310');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000310'), 'Sede Principale', 'Piazza del Duomo', '132', 'Udine', 'UD', '33100', '040345310', 'centroestetico310@email.it', '43000000310', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Udine', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '43000000311', 'idraulico311@email.it', '3331234311');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000311'), 'Sede Principale', 'Via Dante', '105', 'Udine', 'UD', '33100', '3331234311', 'idraulico311@email.it', '43000000311', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Udine', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '43000000312', 'elettricista312@email.it', '3331234312');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000312'), 'Sede Principale', 'Via Roma', '66', 'Udine', 'UD', '33100', '3331234312', 'elettricista312@email.it', '43000000312', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Udine', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '43000000313', 'imbianchino313@email.it', '3331234313');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000313'), 'Sede Principale', 'Via Mazzini', '152', 'Udine', 'UD', '33100', '3331234313', 'imbianchino313@email.it', '43000000313', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Udine', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '43000000314', 'fabbro314@email.it', '3331234314');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000314'), 'Sede Principale', 'Via Mazzini', '154', 'Udine', 'UD', '33100', '3331234314', 'fabbro314@email.it', '43000000314', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Udine', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '43000000315', 'falegname315@email.it', '3331234315');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000315'), 'Sede Principale', 'Via Verdi', '172', 'Udine', 'UD', '33100', '3331234315', 'falegname315@email.it', '43000000315', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Udine', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '43000000316', 'supermercato316@email.it', '040345316');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000316'), 'Sede Principale', 'Via Dante', '188', 'Udine', 'UD', '33100', '040345316', 'supermercato316@email.it', '43000000316', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Udine', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '43000000317', 'ferramenta317@email.it', '040345317');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000317'), 'Sede Principale', 'Via Verdi', '40', 'Udine', 'UD', '33100', '040345317', 'ferramenta317@email.it', '43000000317', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Udine', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '43000000318', 'palestra318@email.it', '040345318');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000318'), 'Sede Principale', 'Piazza Garibaldi', '103', 'Udine', 'UD', '33100', '040345318', 'palestra318@email.it', '43000000318', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Udine', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '43000000319', 'panificio319@email.it', '040345319');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000319'), 'Sede Principale', 'Piazza Garibaldi', '129', 'Udine', 'UD', '33100', '040345319', 'panificio319@email.it', '43000000319', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Udine', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '43000000320', 'pasticceria320@email.it', '040345320');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000320'), 'Sede Principale', 'Via Roma', '197', 'Udine', 'UD', '33100', '040345320', 'pasticceria320@email.it', '43000000320', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Udine', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '43000000321', 'veterinario321@email.it', '040345321');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000321'), 'Sede Principale', 'Corso Umberto', '39', 'Udine', 'UD', '33100', '040345321', 'veterinario321@email.it', '43000000321', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Udine', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '43000000322', 'macelleria322@email.it', '040345322');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000322'), 'Sede Principale', 'Via Cavour', '68', 'Udine', 'UD', '33100', '040345322', 'macelleria322@email.it', '43000000322', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Udine', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '43000000323', 'pescheria323@email.it', '040345323');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000323'), 'Sede Principale', 'Via Dante', '1', 'Udine', 'UD', '33100', '040345323', 'pescheria323@email.it', '43000000323', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Udine', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '43000000324', 'libreria324@email.it', '040345324');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000324'), 'Sede Principale', 'Corso Vittorio Emanuele', '49', 'Udine', 'UD', '33100', '040345324', 'libreria324@email.it', '43000000324', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Udine', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '43000000325', 'architetto325@email.it', '040345325');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000325'), 'Sede Principale', 'Piazza del Duomo', '170', 'Udine', 'UD', '33100', '040345325', 'architetto325@email.it', '43000000325', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Udine', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '43000000326', 'ingegnere326@email.it', '040345326');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000326'), 'Sede Principale', 'Piazza Garibaldi', '125', 'Udine', 'UD', '33100', '040345326', 'ingegnere326@email.it', '43000000326', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Udine', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '43000000327', 'geometra327@email.it', '040345327');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000327'), 'Sede Principale', 'Via Verdi', '114', 'Udine', 'UD', '33100', '040345327', 'geometra327@email.it', '43000000327', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Udine', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '43000000328', 'officinaauto328@email.it', '040345328');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000328'), 'Sede Principale', 'Corso Umberto', '142', 'Udine', 'UD', '33100', '040345328', 'officinaauto328@email.it', '43000000328', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Udine', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '43000000329', 'gommista329@email.it', '040345329');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000329'), 'Sede Principale', 'Corso Vittorio Emanuele', '163', 'Udine', 'UD', '33100', '040345329', 'gommista329@email.it', '43000000329', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Pordenone', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '43000000330', 'trattoria330@email.it', '040345330');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000330'), 'Sede Principale', 'Piazza Garibaldi', '32', 'Pordenone', 'PN', '33170', '040345330', 'trattoria330@email.it', '43000000330', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Pordenone', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '43000000331', 'pizzeria331@email.it', '040345331');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000331'), 'Sede Principale', 'Corso Vittorio Emanuele', '135', 'Pordenone', 'PN', '33170', '040345331', 'pizzeria331@email.it', '43000000331', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pordenone', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '43000000332', 'bar332@email.it', '040345332');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000332'), 'Sede Principale', 'Corso Vittorio Emanuele', '195', 'Pordenone', 'PN', '33170', '040345332', 'bar332@email.it', '43000000332', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Pordenone', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '43000000333', 'studiodentistico333@email.it', '040345333');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000333'), 'Sede Principale', 'Piazza Garibaldi', '32', 'Pordenone', 'PN', '33170', '040345333', 'studiodentistico333@email.it', '43000000333', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Pordenone', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '43000000334', 'studiomedico334@email.it', '040345334');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000334'), 'Sede Principale', 'Piazza Garibaldi', '45', 'Pordenone', 'PN', '33170', '040345334', 'studiomedico334@email.it', '43000000334', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Pordenone', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '43000000335', 'farmacia335@email.it', '040345335');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000335'), 'Sede Principale', 'Piazza del Duomo', '22', 'Pordenone', 'PN', '33170', '040345335', 'farmacia335@email.it', '43000000335', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Pordenone', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '43000000336', 'avvocato336@email.it', '040345336');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000336'), 'Sede Principale', 'Via Mazzini', '192', 'Pordenone', 'PN', '33170', '040345336', 'avvocato336@email.it', '43000000336', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Pordenone', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '43000000337', 'studiocommercialisti337@email.it', '040345337');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000337'), 'Sede Principale', 'Corso Vittorio Emanuele', '10', 'Pordenone', 'PN', '33170', '040345337', 'studiocommercialisti337@email.it', '43000000337', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Pordenone', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '43000000338', 'notaio338@email.it', '040345338');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000338'), 'Sede Principale', 'Piazza Garibaldi', '174', 'Pordenone', 'PN', '33170', '040345338', 'notaio338@email.it', '43000000338', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Pordenone', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '43000000339', 'parrucchiere339@email.it', '040345339');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000339'), 'Sede Principale', 'Via Cavour', '164', 'Pordenone', 'PN', '33170', '040345339', 'parrucchiere339@email.it', '43000000339', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Pordenone', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '43000000340', 'centroestetico340@email.it', '040345340');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000340'), 'Sede Principale', 'Via Mazzini', '136', 'Pordenone', 'PN', '33170', '040345340', 'centroestetico340@email.it', '43000000340', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Pordenone', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '43000000341', 'idraulico341@email.it', '3331234341');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000341'), 'Sede Principale', 'Corso Italia', '30', 'Pordenone', 'PN', '33170', '3331234341', 'idraulico341@email.it', '43000000341', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Pordenone', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '43000000342', 'elettricista342@email.it', '3331234342');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000342'), 'Sede Principale', 'Corso Vittorio Emanuele', '169', 'Pordenone', 'PN', '33170', '3331234342', 'elettricista342@email.it', '43000000342', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Pordenone', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '43000000343', 'imbianchino343@email.it', '3331234343');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000343'), 'Sede Principale', 'Piazza del Duomo', '23', 'Pordenone', 'PN', '33170', '3331234343', 'imbianchino343@email.it', '43000000343', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Pordenone', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '43000000344', 'fabbro344@email.it', '3331234344');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000344'), 'Sede Principale', 'Corso Vittorio Emanuele', '87', 'Pordenone', 'PN', '33170', '3331234344', 'fabbro344@email.it', '43000000344', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Pordenone', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '43000000345', 'falegname345@email.it', '3331234345');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000345'), 'Sede Principale', 'Via Mazzini', '39', 'Pordenone', 'PN', '33170', '3331234345', 'falegname345@email.it', '43000000345', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Pordenone', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '43000000346', 'supermercato346@email.it', '040345346');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000346'), 'Sede Principale', 'Via Cavour', '162', 'Pordenone', 'PN', '33170', '040345346', 'supermercato346@email.it', '43000000346', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Pordenone', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '43000000347', 'ferramenta347@email.it', '040345347');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000347'), 'Sede Principale', 'Corso Umberto', '75', 'Pordenone', 'PN', '33170', '040345347', 'ferramenta347@email.it', '43000000347', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Pordenone', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '43000000348', 'palestra348@email.it', '040345348');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000348'), 'Sede Principale', 'Via Cavour', '163', 'Pordenone', 'PN', '33170', '040345348', 'palestra348@email.it', '43000000348', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Pordenone', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '43000000349', 'panificio349@email.it', '040345349');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000349'), 'Sede Principale', 'Piazza del Duomo', '163', 'Pordenone', 'PN', '33170', '040345349', 'panificio349@email.it', '43000000349', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Pordenone', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '43000000350', 'gelateria350@email.it', '040345350');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000350'), 'Sede Principale', 'Piazza del Duomo', '96', 'Pordenone', 'PN', '33170', '040345350', 'gelateria350@email.it', '43000000350', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Pordenone', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '43000000351', 'veterinario351@email.it', '040345351');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000351'), 'Sede Principale', 'Via Cavour', '23', 'Pordenone', 'PN', '33170', '040345351', 'veterinario351@email.it', '43000000351', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Pordenone', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '43000000352', 'macelleria352@email.it', '040345352');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000352'), 'Sede Principale', 'Via Dante', '126', 'Pordenone', 'PN', '33170', '040345352', 'macelleria352@email.it', '43000000352', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Pordenone', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '43000000353', 'pescheria353@email.it', '040345353');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000353'), 'Sede Principale', 'Via Verdi', '176', 'Pordenone', 'PN', '33170', '040345353', 'pescheria353@email.it', '43000000353', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Pordenone', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '43000000354', 'libreria354@email.it', '040345354');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000354'), 'Sede Principale', 'Via Mazzini', '38', 'Pordenone', 'PN', '33170', '040345354', 'libreria354@email.it', '43000000354', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Pordenone', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '43000000355', 'architetto355@email.it', '040345355');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000355'), 'Sede Principale', 'Via Cavour', '46', 'Pordenone', 'PN', '33170', '040345355', 'architetto355@email.it', '43000000355', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Pordenone', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '43000000356', 'ingegnere356@email.it', '040345356');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000356'), 'Sede Principale', 'Via Cavour', '49', 'Pordenone', 'PN', '33170', '040345356', 'ingegnere356@email.it', '43000000356', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Pordenone', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '43000000357', 'geometra357@email.it', '040345357');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000357'), 'Sede Principale', 'Piazza Garibaldi', '70', 'Pordenone', 'PN', '33170', '040345357', 'geometra357@email.it', '43000000357', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Pordenone', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '43000000358', 'officinaauto358@email.it', '040345358');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000358'), 'Sede Principale', 'Via Dante', '110', 'Pordenone', 'PN', '33170', '040345358', 'officinaauto358@email.it', '43000000358', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Pordenone', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '43000000359', 'gommista359@email.it', '040345359');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000359'), 'Sede Principale', 'Via Verdi', '114', 'Pordenone', 'PN', '33170', '040345359', 'gommista359@email.it', '43000000359', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Gorizia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '43000000360', 'ristorante360@email.it', '040345360');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000360'), 'Sede Principale', 'Via Verdi', '169', 'Gorizia', 'GO', '34170', '040345360', 'ristorante360@email.it', '43000000360', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Gorizia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '43000000361', 'pizzeria361@email.it', '040345361');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000361'), 'Sede Principale', 'Piazza del Duomo', '40', 'Gorizia', 'GO', '34170', '040345361', 'pizzeria361@email.it', '43000000361', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Gorizia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '43000000362', 'bar362@email.it', '040345362');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000362'), 'Sede Principale', 'Piazza del Duomo', '4', 'Gorizia', 'GO', '34170', '040345362', 'bar362@email.it', '43000000362', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Gorizia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '43000000363', 'studiodentistico363@email.it', '040345363');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000363'), 'Sede Principale', 'Piazza Garibaldi', '8', 'Gorizia', 'GO', '34170', '040345363', 'studiodentistico363@email.it', '43000000363', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Gorizia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '43000000364', 'poliambulatorio364@email.it', '040345364');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000364'), 'Sede Principale', 'Corso Italia', '18', 'Gorizia', 'GO', '34170', '040345364', 'poliambulatorio364@email.it', '43000000364', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Gorizia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '43000000365', 'farmacia365@email.it', '040345365');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000365'), 'Sede Principale', 'Corso Umberto', '70', 'Gorizia', 'GO', '34170', '040345365', 'farmacia365@email.it', '43000000365', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Gorizia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '43000000366', 'avvocato366@email.it', '040345366');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000366'), 'Sede Principale', 'Via Dante', '71', 'Gorizia', 'GO', '34170', '040345366', 'avvocato366@email.it', '43000000366', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Gorizia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '43000000367', 'studiocommercialisti367@email.it', '040345367');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000367'), 'Sede Principale', 'Via Mazzini', '166', 'Gorizia', 'GO', '34170', '040345367', 'studiocommercialisti367@email.it', '43000000367', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Gorizia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '43000000368', 'notaio368@email.it', '040345368');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000368'), 'Sede Principale', 'Piazza Garibaldi', '16', 'Gorizia', 'GO', '34170', '040345368', 'notaio368@email.it', '43000000368', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Gorizia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '43000000369', 'salone369@email.it', '040345369');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000369'), 'Sede Principale', 'Via Verdi', '40', 'Gorizia', 'GO', '34170', '040345369', 'salone369@email.it', '43000000369', true);
