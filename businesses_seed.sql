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

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Gorizia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '43000000370', 'centroestetico370@email.it', '040345370');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000370'), 'Sede Principale', 'Corso Italia', '10', 'Gorizia', 'GO', '34170', '040345370', 'centroestetico370@email.it', '43000000370', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Gorizia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '43000000371', 'idraulico371@email.it', '3331234371');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000371'), 'Sede Principale', 'Piazza Garibaldi', '7', 'Gorizia', 'GO', '34170', '3331234371', 'idraulico371@email.it', '43000000371', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Gorizia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '43000000372', 'elettricista372@email.it', '3331234372');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000372'), 'Sede Principale', 'Via Mazzini', '20', 'Gorizia', 'GO', '34170', '3331234372', 'elettricista372@email.it', '43000000372', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Gorizia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '43000000373', 'imbianchino373@email.it', '3331234373');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000373'), 'Sede Principale', 'Corso Umberto', '94', 'Gorizia', 'GO', '34170', '3331234373', 'imbianchino373@email.it', '43000000373', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Gorizia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '43000000374', 'fabbro374@email.it', '3331234374');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000374'), 'Sede Principale', 'Via Roma', '92', 'Gorizia', 'GO', '34170', '3331234374', 'fabbro374@email.it', '43000000374', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Gorizia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '43000000375', 'falegname375@email.it', '3331234375');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000375'), 'Sede Principale', 'Corso Vittorio Emanuele', '38', 'Gorizia', 'GO', '34170', '3331234375', 'falegname375@email.it', '43000000375', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Gorizia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '43000000376', 'supermercato376@email.it', '040345376');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000376'), 'Sede Principale', 'Via Mazzini', '124', 'Gorizia', 'GO', '34170', '040345376', 'supermercato376@email.it', '43000000376', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Gorizia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '43000000377', 'ferramenta377@email.it', '040345377');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000377'), 'Sede Principale', 'Corso Umberto', '171', 'Gorizia', 'GO', '34170', '040345377', 'ferramenta377@email.it', '43000000377', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Gorizia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '43000000378', 'palestra378@email.it', '040345378');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000378'), 'Sede Principale', 'Via Verdi', '191', 'Gorizia', 'GO', '34170', '040345378', 'palestra378@email.it', '43000000378', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Gorizia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '43000000379', 'panificio379@email.it', '040345379');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000379'), 'Sede Principale', 'Via Roma', '117', 'Gorizia', 'GO', '34170', '040345379', 'panificio379@email.it', '43000000379', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Gorizia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '43000000380', 'gelateria380@email.it', '040345380');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000380'), 'Sede Principale', 'Via Cavour', '109', 'Gorizia', 'GO', '34170', '040345380', 'gelateria380@email.it', '43000000380', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Gorizia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '43000000381', 'veterinario381@email.it', '040345381');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000381'), 'Sede Principale', 'Via Cavour', '118', 'Gorizia', 'GO', '34170', '040345381', 'veterinario381@email.it', '43000000381', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Gorizia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '43000000382', 'macelleria382@email.it', '040345382');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000382'), 'Sede Principale', 'Corso Vittorio Emanuele', '137', 'Gorizia', 'GO', '34170', '040345382', 'macelleria382@email.it', '43000000382', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Gorizia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '43000000383', 'pescheria383@email.it', '040345383');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000383'), 'Sede Principale', 'Via Mazzini', '94', 'Gorizia', 'GO', '34170', '040345383', 'pescheria383@email.it', '43000000383', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Gorizia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '43000000384', 'libreria384@email.it', '040345384');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000384'), 'Sede Principale', 'Corso Vittorio Emanuele', '196', 'Gorizia', 'GO', '34170', '040345384', 'libreria384@email.it', '43000000384', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Gorizia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '43000000385', 'architetto385@email.it', '040345385');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000385'), 'Sede Principale', 'Via Cavour', '55', 'Gorizia', 'GO', '34170', '040345385', 'architetto385@email.it', '43000000385', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Gorizia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '43000000386', 'ingegnere386@email.it', '040345386');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000386'), 'Sede Principale', 'Corso Italia', '34', 'Gorizia', 'GO', '34170', '040345386', 'ingegnere386@email.it', '43000000386', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Gorizia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '43000000387', 'geometra387@email.it', '040345387');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000387'), 'Sede Principale', 'Via Mazzini', '88', 'Gorizia', 'GO', '34170', '040345387', 'geometra387@email.it', '43000000387', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Gorizia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '43000000388', 'officinaauto388@email.it', '040345388');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000388'), 'Sede Principale', 'Via Verdi', '110', 'Gorizia', 'GO', '34170', '040345388', 'officinaauto388@email.it', '43000000388', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Gorizia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '43000000389', 'gommista389@email.it', '040345389');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '43000000389'), 'Sede Principale', 'Via Cavour', '118', 'Gorizia', 'GO', '34170', '040345389', 'gommista389@email.it', '43000000389', true);

-- LIGURIA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Genova', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '44000000390', 'ristorante390@email.it', '010345390');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000390'), 'Sede Principale', 'Via Cavour', '73', 'Genova', 'GE', '16100', '010345390', 'ristorante390@email.it', '44000000390', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Genova', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '44000000391', 'pizzeria391@email.it', '010345391');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000391'), 'Sede Principale', 'Via Cavour', '130', 'Genova', 'GE', '16100', '010345391', 'pizzeria391@email.it', '44000000391', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Genova', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '44000000392', 'bar392@email.it', '010345392');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000392'), 'Sede Principale', 'Corso Vittorio Emanuele', '153', 'Genova', 'GE', '16100', '010345392', 'bar392@email.it', '44000000392', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Genova', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '44000000393', 'studiodentistico393@email.it', '010345393');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000393'), 'Sede Principale', 'Via Cavour', '91', 'Genova', 'GE', '16100', '010345393', 'studiodentistico393@email.it', '44000000393', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Genova', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '44000000394', 'studiomedico394@email.it', '010345394');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000394'), 'Sede Principale', 'Corso Vittorio Emanuele', '47', 'Genova', 'GE', '16100', '010345394', 'studiomedico394@email.it', '44000000394', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Genova', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '44000000395', 'farmacia395@email.it', '010345395');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000395'), 'Sede Principale', 'Via Verdi', '147', 'Genova', 'GE', '16100', '010345395', 'farmacia395@email.it', '44000000395', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Genova', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '44000000396', 'studiolegale396@email.it', '010345396');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000396'), 'Sede Principale', 'Via Mazzini', '100', 'Genova', 'GE', '16100', '010345396', 'studiolegale396@email.it', '44000000396', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Genova', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '44000000397', 'studiocommercialisti397@email.it', '010345397');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000397'), 'Sede Principale', 'Via Cavour', '131', 'Genova', 'GE', '16100', '010345397', 'studiocommercialisti397@email.it', '44000000397', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Genova', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '44000000398', 'notaio398@email.it', '010345398');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000398'), 'Sede Principale', 'Via Cavour', '198', 'Genova', 'GE', '16100', '010345398', 'notaio398@email.it', '44000000398', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Genova', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '44000000399', 'salone399@email.it', '010345399');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000399'), 'Sede Principale', 'Via Mazzini', '80', 'Genova', 'GE', '16100', '010345399', 'salone399@email.it', '44000000399', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Genova', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '44000000400', 'centroestetico400@email.it', '010345400');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000400'), 'Sede Principale', 'Corso Italia', '7', 'Genova', 'GE', '16100', '010345400', 'centroestetico400@email.it', '44000000400', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Genova', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '44000000401', 'idraulico401@email.it', '3331234401');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000401'), 'Sede Principale', 'Via Dante', '10', 'Genova', 'GE', '16100', '3331234401', 'idraulico401@email.it', '44000000401', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Genova', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '44000000402', 'elettricista402@email.it', '3331234402');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000402'), 'Sede Principale', 'Piazza del Duomo', '15', 'Genova', 'GE', '16100', '3331234402', 'elettricista402@email.it', '44000000402', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Genova', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '44000000403', 'imbianchino403@email.it', '3331234403');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000403'), 'Sede Principale', 'Corso Italia', '174', 'Genova', 'GE', '16100', '3331234403', 'imbianchino403@email.it', '44000000403', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Genova', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '44000000404', 'fabbro404@email.it', '3331234404');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000404'), 'Sede Principale', 'Corso Italia', '20', 'Genova', 'GE', '16100', '3331234404', 'fabbro404@email.it', '44000000404', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Genova', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '44000000405', 'falegname405@email.it', '3331234405');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000405'), 'Sede Principale', 'Via Roma', '26', 'Genova', 'GE', '16100', '3331234405', 'falegname405@email.it', '44000000405', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Genova', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '44000000406', 'supermercato406@email.it', '010345406');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000406'), 'Sede Principale', 'Via Roma', '18', 'Genova', 'GE', '16100', '010345406', 'supermercato406@email.it', '44000000406', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Genova', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '44000000407', 'ferramenta407@email.it', '010345407');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000407'), 'Sede Principale', 'Via Cavour', '77', 'Genova', 'GE', '16100', '010345407', 'ferramenta407@email.it', '44000000407', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Genova', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '44000000408', 'palestra408@email.it', '010345408');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000408'), 'Sede Principale', 'Via Mazzini', '196', 'Genova', 'GE', '16100', '010345408', 'palestra408@email.it', '44000000408', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Genova', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '44000000409', 'panificio409@email.it', '010345409');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000409'), 'Sede Principale', 'Corso Umberto', '116', 'Genova', 'GE', '16100', '010345409', 'panificio409@email.it', '44000000409', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Genova', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '44000000410', 'pasticceria410@email.it', '010345410');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000410'), 'Sede Principale', 'Via Mazzini', '32', 'Genova', 'GE', '16100', '010345410', 'pasticceria410@email.it', '44000000410', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Genova', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '44000000411', 'veterinario411@email.it', '010345411');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000411'), 'Sede Principale', 'Via Cavour', '5', 'Genova', 'GE', '16100', '010345411', 'veterinario411@email.it', '44000000411', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Genova', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '44000000412', 'macelleria412@email.it', '010345412');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000412'), 'Sede Principale', 'Corso Vittorio Emanuele', '94', 'Genova', 'GE', '16100', '010345412', 'macelleria412@email.it', '44000000412', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Genova', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '44000000413', 'pescheria413@email.it', '010345413');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000413'), 'Sede Principale', 'Via Dante', '59', 'Genova', 'GE', '16100', '010345413', 'pescheria413@email.it', '44000000413', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Genova', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '44000000414', 'libreria414@email.it', '010345414');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000414'), 'Sede Principale', 'Via Cavour', '39', 'Genova', 'GE', '16100', '010345414', 'libreria414@email.it', '44000000414', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Genova', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '44000000415', 'architetto415@email.it', '010345415');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000415'), 'Sede Principale', 'Via Cavour', '4', 'Genova', 'GE', '16100', '010345415', 'architetto415@email.it', '44000000415', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Genova', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '44000000416', 'studioingegneri416@email.it', '010345416');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000416'), 'Sede Principale', 'Via Dante', '110', 'Genova', 'GE', '16100', '010345416', 'studioingegneri416@email.it', '44000000416', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Genova', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '44000000417', 'geometra417@email.it', '010345417');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000417'), 'Sede Principale', 'Corso Vittorio Emanuele', '69', 'Genova', 'GE', '16100', '010345417', 'geometra417@email.it', '44000000417', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Genova', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '44000000418', 'officinaauto418@email.it', '010345418');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000418'), 'Sede Principale', 'Corso Umberto', '197', 'Genova', 'GE', '16100', '010345418', 'officinaauto418@email.it', '44000000418', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Genova', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '44000000419', 'gommista419@email.it', '010345419');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000419'), 'Sede Principale', 'Via Dante', '113', 'Genova', 'GE', '16100', '010345419', 'gommista419@email.it', '44000000419', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante La Spezia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '44000000420', 'ristorante420@email.it', '010345420');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000420'), 'Sede Principale', 'Via Verdi', '96', 'La Spezia', 'SP', '19100', '010345420', 'ristorante420@email.it', '44000000420', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria La Spezia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '44000000421', 'pizzeria421@email.it', '010345421');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000421'), 'Sede Principale', 'Piazza Garibaldi', '69', 'La Spezia', 'SP', '19100', '010345421', 'pizzeria421@email.it', '44000000421', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria La Spezia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '44000000422', 'barpasticceria422@email.it', '010345422');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000422'), 'Sede Principale', 'Corso Vittorio Emanuele', '41', 'La Spezia', 'SP', '19100', '010345422', 'barpasticceria422@email.it', '44000000422', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico La Spezia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '44000000423', 'studiodentistico423@email.it', '010345423');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000423'), 'Sede Principale', 'Via Verdi', '31', 'La Spezia', 'SP', '19100', '010345423', 'studiodentistico423@email.it', '44000000423', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio La Spezia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '44000000424', 'poliambulatorio424@email.it', '010345424');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000424'), 'Sede Principale', 'Corso Italia', '92', 'La Spezia', 'SP', '19100', '010345424', 'poliambulatorio424@email.it', '44000000424', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia La Spezia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '44000000425', 'farmacia425@email.it', '010345425');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000425'), 'Sede Principale', 'Piazza del Duomo', '40', 'La Spezia', 'SP', '19100', '010345425', 'farmacia425@email.it', '44000000425', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato La Spezia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '44000000426', 'avvocato426@email.it', '010345426');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000426'), 'Sede Principale', 'Via Roma', '112', 'La Spezia', 'SP', '19100', '010345426', 'avvocato426@email.it', '44000000426', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista La Spezia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '44000000427', 'commercialista427@email.it', '010345427');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000427'), 'Sede Principale', 'Corso Vittorio Emanuele', '36', 'La Spezia', 'SP', '19100', '010345427', 'commercialista427@email.it', '44000000427', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio La Spezia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '44000000428', 'notaio428@email.it', '010345428');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000428'), 'Sede Principale', 'Via Cavour', '100', 'La Spezia', 'SP', '19100', '010345428', 'notaio428@email.it', '44000000428', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere La Spezia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '44000000429', 'parrucchiere429@email.it', '010345429');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000429'), 'Sede Principale', 'Piazza Garibaldi', '71', 'La Spezia', 'SP', '19100', '010345429', 'parrucchiere429@email.it', '44000000429', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico La Spezia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '44000000430', 'centroestetico430@email.it', '010345430');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000430'), 'Sede Principale', 'Corso Vittorio Emanuele', '163', 'La Spezia', 'SP', '19100', '010345430', 'centroestetico430@email.it', '44000000430', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico La Spezia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '44000000431', 'idraulico431@email.it', '3331234431');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000431'), 'Sede Principale', 'Corso Italia', '76', 'La Spezia', 'SP', '19100', '3331234431', 'idraulico431@email.it', '44000000431', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista La Spezia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '44000000432', 'elettricista432@email.it', '3331234432');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000432'), 'Sede Principale', 'Via Verdi', '40', 'La Spezia', 'SP', '19100', '3331234432', 'elettricista432@email.it', '44000000432', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino La Spezia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '44000000433', 'imbianchino433@email.it', '3331234433');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000433'), 'Sede Principale', 'Piazza del Duomo', '75', 'La Spezia', 'SP', '19100', '3331234433', 'imbianchino433@email.it', '44000000433', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro La Spezia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '44000000434', 'fabbro434@email.it', '3331234434');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000434'), 'Sede Principale', 'Via Verdi', '174', 'La Spezia', 'SP', '19100', '3331234434', 'fabbro434@email.it', '44000000434', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname La Spezia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '44000000435', 'falegname435@email.it', '3331234435');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000435'), 'Sede Principale', 'Corso Umberto', '5', 'La Spezia', 'SP', '19100', '3331234435', 'falegname435@email.it', '44000000435', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato La Spezia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '44000000436', 'supermercato436@email.it', '010345436');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000436'), 'Sede Principale', 'Via Verdi', '98', 'La Spezia', 'SP', '19100', '010345436', 'supermercato436@email.it', '44000000436', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta La Spezia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '44000000437', 'ferramenta437@email.it', '010345437');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000437'), 'Sede Principale', 'Via Verdi', '171', 'La Spezia', 'SP', '19100', '010345437', 'ferramenta437@email.it', '44000000437', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra La Spezia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '44000000438', 'palestra438@email.it', '010345438');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000438'), 'Sede Principale', 'Via Cavour', '169', 'La Spezia', 'SP', '19100', '010345438', 'palestra438@email.it', '44000000438', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio La Spezia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '44000000439', 'panificio439@email.it', '010345439');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000439'), 'Sede Principale', 'Via Roma', '195', 'La Spezia', 'SP', '19100', '010345439', 'panificio439@email.it', '44000000439', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria La Spezia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '44000000440', 'gelateria440@email.it', '010345440');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000440'), 'Sede Principale', 'Via Dante', '1', 'La Spezia', 'SP', '19100', '010345440', 'gelateria440@email.it', '44000000440', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario La Spezia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '44000000441', 'veterinario441@email.it', '010345441');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000441'), 'Sede Principale', 'Piazza del Duomo', '153', 'La Spezia', 'SP', '19100', '010345441', 'veterinario441@email.it', '44000000441', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria La Spezia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '44000000442', 'macelleria442@email.it', '010345442');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000442'), 'Sede Principale', 'Corso Italia', '76', 'La Spezia', 'SP', '19100', '010345442', 'macelleria442@email.it', '44000000442', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria La Spezia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '44000000443', 'pescheria443@email.it', '010345443');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000443'), 'Sede Principale', 'Via Dante', '96', 'La Spezia', 'SP', '19100', '010345443', 'pescheria443@email.it', '44000000443', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria La Spezia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '44000000444', 'libreria444@email.it', '010345444');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000444'), 'Sede Principale', 'Via Mazzini', '17', 'La Spezia', 'SP', '19100', '010345444', 'libreria444@email.it', '44000000444', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti La Spezia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '44000000445', 'studioarchitetti445@email.it', '010345445');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000445'), 'Sede Principale', 'Via Dante', '72', 'La Spezia', 'SP', '19100', '010345445', 'studioarchitetti445@email.it', '44000000445', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri La Spezia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '44000000446', 'studioingegneri446@email.it', '010345446');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000446'), 'Sede Principale', 'Via Cavour', '7', 'La Spezia', 'SP', '19100', '010345446', 'studioingegneri446@email.it', '44000000446', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra La Spezia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '44000000447', 'geometra447@email.it', '010345447');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000447'), 'Sede Principale', 'Piazza Garibaldi', '172', 'La Spezia', 'SP', '19100', '010345447', 'geometra447@email.it', '44000000447', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto La Spezia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '44000000448', 'officinaauto448@email.it', '010345448');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000448'), 'Sede Principale', 'Via Cavour', '189', 'La Spezia', 'SP', '19100', '010345448', 'officinaauto448@email.it', '44000000448', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista La Spezia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '44000000449', 'gommista449@email.it', '010345449');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000449'), 'Sede Principale', 'Via Mazzini', '1', 'La Spezia', 'SP', '19100', '010345449', 'gommista449@email.it', '44000000449', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Savona', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '44000000450', 'osteria450@email.it', '010345450');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000450'), 'Sede Principale', 'Piazza del Duomo', '174', 'Savona', 'SV', '17100', '010345450', 'osteria450@email.it', '44000000450', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Savona', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '44000000451', 'pizzeria451@email.it', '010345451');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000451'), 'Sede Principale', 'Via Roma', '124', 'Savona', 'SV', '17100', '010345451', 'pizzeria451@email.it', '44000000451', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Savona', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '44000000452', 'caffe452@email.it', '010345452');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000452'), 'Sede Principale', 'Corso Umberto', '143', 'Savona', 'SV', '17100', '010345452', 'caffe452@email.it', '44000000452', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Savona', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '44000000453', 'studiodentistico453@email.it', '010345453');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000453'), 'Sede Principale', 'Corso Italia', '10', 'Savona', 'SV', '17100', '010345453', 'studiodentistico453@email.it', '44000000453', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Savona', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '44000000454', 'studiomedico454@email.it', '010345454');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000454'), 'Sede Principale', 'Via Dante', '29', 'Savona', 'SV', '17100', '010345454', 'studiomedico454@email.it', '44000000454', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Savona', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '44000000455', 'farmacia455@email.it', '010345455');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000455'), 'Sede Principale', 'Corso Vittorio Emanuele', '33', 'Savona', 'SV', '17100', '010345455', 'farmacia455@email.it', '44000000455', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Savona', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '44000000456', 'studiolegale456@email.it', '010345456');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000456'), 'Sede Principale', 'Corso Italia', '45', 'Savona', 'SV', '17100', '010345456', 'studiolegale456@email.it', '44000000456', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Savona', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '44000000457', 'studiocommercialisti457@email.it', '010345457');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000457'), 'Sede Principale', 'Piazza del Duomo', '17', 'Savona', 'SV', '17100', '010345457', 'studiocommercialisti457@email.it', '44000000457', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Savona', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '44000000458', 'notaio458@email.it', '010345458');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000458'), 'Sede Principale', 'Via Verdi', '158', 'Savona', 'SV', '17100', '010345458', 'notaio458@email.it', '44000000458', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Savona', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '44000000459', 'salone459@email.it', '010345459');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000459'), 'Sede Principale', 'Piazza Garibaldi', '138', 'Savona', 'SV', '17100', '010345459', 'salone459@email.it', '44000000459', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Savona', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '44000000460', 'centroestetico460@email.it', '010345460');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000460'), 'Sede Principale', 'Via Verdi', '147', 'Savona', 'SV', '17100', '010345460', 'centroestetico460@email.it', '44000000460', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Savona', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '44000000461', 'idraulico461@email.it', '3331234461');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000461'), 'Sede Principale', 'Corso Vittorio Emanuele', '115', 'Savona', 'SV', '17100', '3331234461', 'idraulico461@email.it', '44000000461', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Savona', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '44000000462', 'elettricista462@email.it', '3331234462');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000462'), 'Sede Principale', 'Via Verdi', '25', 'Savona', 'SV', '17100', '3331234462', 'elettricista462@email.it', '44000000462', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Savona', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '44000000463', 'imbianchino463@email.it', '3331234463');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000463'), 'Sede Principale', 'Via Roma', '59', 'Savona', 'SV', '17100', '3331234463', 'imbianchino463@email.it', '44000000463', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Savona', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '44000000464', 'fabbro464@email.it', '3331234464');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000464'), 'Sede Principale', 'Via Verdi', '132', 'Savona', 'SV', '17100', '3331234464', 'fabbro464@email.it', '44000000464', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Savona', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '44000000465', 'falegname465@email.it', '3331234465');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000465'), 'Sede Principale', 'Via Verdi', '171', 'Savona', 'SV', '17100', '3331234465', 'falegname465@email.it', '44000000465', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Savona', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '44000000466', 'supermercato466@email.it', '010345466');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000466'), 'Sede Principale', 'Corso Italia', '17', 'Savona', 'SV', '17100', '010345466', 'supermercato466@email.it', '44000000466', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Savona', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '44000000467', 'ferramenta467@email.it', '010345467');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000467'), 'Sede Principale', 'Piazza Garibaldi', '39', 'Savona', 'SV', '17100', '010345467', 'ferramenta467@email.it', '44000000467', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Savona', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '44000000468', 'palestra468@email.it', '010345468');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000468'), 'Sede Principale', 'Corso Vittorio Emanuele', '51', 'Savona', 'SV', '17100', '010345468', 'palestra468@email.it', '44000000468', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Savona', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '44000000469', 'panificio469@email.it', '010345469');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000469'), 'Sede Principale', 'Via Roma', '145', 'Savona', 'SV', '17100', '010345469', 'panificio469@email.it', '44000000469', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Savona', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '44000000470', 'gelateria470@email.it', '010345470');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000470'), 'Sede Principale', 'Via Cavour', '160', 'Savona', 'SV', '17100', '010345470', 'gelateria470@email.it', '44000000470', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Savona', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '44000000471', 'veterinario471@email.it', '010345471');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000471'), 'Sede Principale', 'Corso Vittorio Emanuele', '181', 'Savona', 'SV', '17100', '010345471', 'veterinario471@email.it', '44000000471', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Savona', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '44000000472', 'macelleria472@email.it', '010345472');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000472'), 'Sede Principale', 'Piazza Garibaldi', '110', 'Savona', 'SV', '17100', '010345472', 'macelleria472@email.it', '44000000472', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Savona', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '44000000473', 'pescheria473@email.it', '010345473');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000473'), 'Sede Principale', 'Corso Umberto', '161', 'Savona', 'SV', '17100', '010345473', 'pescheria473@email.it', '44000000473', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Savona', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '44000000474', 'libreria474@email.it', '010345474');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000474'), 'Sede Principale', 'Via Roma', '61', 'Savona', 'SV', '17100', '010345474', 'libreria474@email.it', '44000000474', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Savona', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '44000000475', 'architetto475@email.it', '010345475');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000475'), 'Sede Principale', 'Via Dante', '1', 'Savona', 'SV', '17100', '010345475', 'architetto475@email.it', '44000000475', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Savona', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '44000000476', 'studioingegneri476@email.it', '010345476');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000476'), 'Sede Principale', 'Corso Italia', '48', 'Savona', 'SV', '17100', '010345476', 'studioingegneri476@email.it', '44000000476', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Savona', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '44000000477', 'geometra477@email.it', '010345477');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000477'), 'Sede Principale', 'Via Roma', '138', 'Savona', 'SV', '17100', '010345477', 'geometra477@email.it', '44000000477', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Savona', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '44000000478', 'officinaauto478@email.it', '010345478');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000478'), 'Sede Principale', 'Piazza del Duomo', '160', 'Savona', 'SV', '17100', '010345478', 'officinaauto478@email.it', '44000000478', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Savona', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '44000000479', 'gommista479@email.it', '010345479');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000479'), 'Sede Principale', 'Via Dante', '70', 'Savona', 'SV', '17100', '010345479', 'gommista479@email.it', '44000000479', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Imperia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '44000000480', 'osteria480@email.it', '010345480');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000480'), 'Sede Principale', 'Via Cavour', '149', 'Imperia', 'IM', '18100', '010345480', 'osteria480@email.it', '44000000480', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Imperia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '44000000481', 'pizzeria481@email.it', '010345481');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000481'), 'Sede Principale', 'Via Verdi', '72', 'Imperia', 'IM', '18100', '010345481', 'pizzeria481@email.it', '44000000481', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Imperia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '44000000482', 'bar482@email.it', '010345482');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000482'), 'Sede Principale', 'Corso Umberto', '52', 'Imperia', 'IM', '18100', '010345482', 'bar482@email.it', '44000000482', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Imperia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '44000000483', 'studiodentistico483@email.it', '010345483');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000483'), 'Sede Principale', 'Piazza del Duomo', '120', 'Imperia', 'IM', '18100', '010345483', 'studiodentistico483@email.it', '44000000483', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Imperia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '44000000484', 'studiomedico484@email.it', '010345484');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000484'), 'Sede Principale', 'Corso Italia', '120', 'Imperia', 'IM', '18100', '010345484', 'studiomedico484@email.it', '44000000484', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Imperia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '44000000485', 'farmacia485@email.it', '010345485');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000485'), 'Sede Principale', 'Via Roma', '135', 'Imperia', 'IM', '18100', '010345485', 'farmacia485@email.it', '44000000485', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Imperia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '44000000486', 'studiolegale486@email.it', '010345486');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000486'), 'Sede Principale', 'Piazza del Duomo', '150', 'Imperia', 'IM', '18100', '010345486', 'studiolegale486@email.it', '44000000486', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Imperia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '44000000487', 'studiocommercialisti487@email.it', '010345487');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000487'), 'Sede Principale', 'Corso Umberto', '47', 'Imperia', 'IM', '18100', '010345487', 'studiocommercialisti487@email.it', '44000000487', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Imperia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '44000000488', 'notaio488@email.it', '010345488');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000488'), 'Sede Principale', 'Corso Vittorio Emanuele', '69', 'Imperia', 'IM', '18100', '010345488', 'notaio488@email.it', '44000000488', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Imperia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '44000000489', 'salone489@email.it', '010345489');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000489'), 'Sede Principale', 'Via Verdi', '40', 'Imperia', 'IM', '18100', '010345489', 'salone489@email.it', '44000000489', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Imperia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '44000000490', 'centroestetico490@email.it', '010345490');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000490'), 'Sede Principale', 'Via Verdi', '6', 'Imperia', 'IM', '18100', '010345490', 'centroestetico490@email.it', '44000000490', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Imperia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '44000000491', 'idraulico491@email.it', '3331234491');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000491'), 'Sede Principale', 'Via Mazzini', '57', 'Imperia', 'IM', '18100', '3331234491', 'idraulico491@email.it', '44000000491', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Imperia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '44000000492', 'elettricista492@email.it', '3331234492');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000492'), 'Sede Principale', 'Piazza del Duomo', '19', 'Imperia', 'IM', '18100', '3331234492', 'elettricista492@email.it', '44000000492', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Imperia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '44000000493', 'imbianchino493@email.it', '3331234493');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000493'), 'Sede Principale', 'Piazza Garibaldi', '95', 'Imperia', 'IM', '18100', '3331234493', 'imbianchino493@email.it', '44000000493', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Imperia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '44000000494', 'fabbro494@email.it', '3331234494');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000494'), 'Sede Principale', 'Via Verdi', '157', 'Imperia', 'IM', '18100', '3331234494', 'fabbro494@email.it', '44000000494', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Imperia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '44000000495', 'falegname495@email.it', '3331234495');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000495'), 'Sede Principale', 'Via Roma', '117', 'Imperia', 'IM', '18100', '3331234495', 'falegname495@email.it', '44000000495', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Imperia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '44000000496', 'supermercato496@email.it', '010345496');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000496'), 'Sede Principale', 'Piazza del Duomo', '171', 'Imperia', 'IM', '18100', '010345496', 'supermercato496@email.it', '44000000496', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Imperia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '44000000497', 'ferramenta497@email.it', '010345497');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000497'), 'Sede Principale', 'Via Mazzini', '60', 'Imperia', 'IM', '18100', '010345497', 'ferramenta497@email.it', '44000000497', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Imperia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '44000000498', 'palestra498@email.it', '010345498');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000498'), 'Sede Principale', 'Corso Umberto', '51', 'Imperia', 'IM', '18100', '010345498', 'palestra498@email.it', '44000000498', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Imperia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '44000000499', 'panificio499@email.it', '010345499');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000499'), 'Sede Principale', 'Via Cavour', '113', 'Imperia', 'IM', '18100', '010345499', 'panificio499@email.it', '44000000499', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Imperia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '44000000500', 'pasticceria500@email.it', '010345500');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000500'), 'Sede Principale', 'Corso Vittorio Emanuele', '68', 'Imperia', 'IM', '18100', '010345500', 'pasticceria500@email.it', '44000000500', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Imperia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '44000000501', 'veterinario501@email.it', '010345501');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000501'), 'Sede Principale', 'Via Cavour', '166', 'Imperia', 'IM', '18100', '010345501', 'veterinario501@email.it', '44000000501', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Imperia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '44000000502', 'macelleria502@email.it', '010345502');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000502'), 'Sede Principale', 'Via Verdi', '166', 'Imperia', 'IM', '18100', '010345502', 'macelleria502@email.it', '44000000502', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Imperia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '44000000503', 'pescheria503@email.it', '010345503');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000503'), 'Sede Principale', 'Via Cavour', '122', 'Imperia', 'IM', '18100', '010345503', 'pescheria503@email.it', '44000000503', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Imperia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '44000000504', 'libreria504@email.it', '010345504');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000504'), 'Sede Principale', 'Via Roma', '110', 'Imperia', 'IM', '18100', '010345504', 'libreria504@email.it', '44000000504', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Imperia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '44000000505', 'architetto505@email.it', '010345505');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000505'), 'Sede Principale', 'Via Dante', '14', 'Imperia', 'IM', '18100', '010345505', 'architetto505@email.it', '44000000505', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Imperia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '44000000506', 'ingegnere506@email.it', '010345506');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000506'), 'Sede Principale', 'Corso Vittorio Emanuele', '101', 'Imperia', 'IM', '18100', '010345506', 'ingegnere506@email.it', '44000000506', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Imperia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '44000000507', 'geometra507@email.it', '010345507');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000507'), 'Sede Principale', 'Corso Vittorio Emanuele', '70', 'Imperia', 'IM', '18100', '010345507', 'geometra507@email.it', '44000000507', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Imperia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '44000000508', 'officinaauto508@email.it', '010345508');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000508'), 'Sede Principale', 'Via Dante', '104', 'Imperia', 'IM', '18100', '010345508', 'officinaauto508@email.it', '44000000508', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Imperia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '44000000509', 'gommista509@email.it', '010345509');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '44000000509'), 'Sede Principale', 'Via Verdi', '76', 'Imperia', 'IM', '18100', '010345509', 'gommista509@email.it', '44000000509', true);

-- MARCHE
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Ancona', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '45000000510', 'osteria510@email.it', '071345510');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000510'), 'Sede Principale', 'Via Verdi', '156', 'Ancona', 'AN', '60100', '071345510', 'osteria510@email.it', '45000000510', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Ancona', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '45000000511', 'pizzeria511@email.it', '071345511');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000511'), 'Sede Principale', 'Via Dante', '96', 'Ancona', 'AN', '60100', '071345511', 'pizzeria511@email.it', '45000000511', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Ancona', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '45000000512', 'caffe512@email.it', '071345512');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000512'), 'Sede Principale', 'Via Roma', '83', 'Ancona', 'AN', '60100', '071345512', 'caffe512@email.it', '45000000512', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Ancona', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '45000000513', 'studiodentistico513@email.it', '071345513');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000513'), 'Sede Principale', 'Piazza del Duomo', '111', 'Ancona', 'AN', '60100', '071345513', 'studiodentistico513@email.it', '45000000513', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Ancona', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '45000000514', 'poliambulatorio514@email.it', '071345514');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000514'), 'Sede Principale', 'Corso Italia', '62', 'Ancona', 'AN', '60100', '071345514', 'poliambulatorio514@email.it', '45000000514', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Ancona', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '45000000515', 'farmacia515@email.it', '071345515');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000515'), 'Sede Principale', 'Via Dante', '165', 'Ancona', 'AN', '60100', '071345515', 'farmacia515@email.it', '45000000515', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Ancona', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '45000000516', 'studiolegale516@email.it', '071345516');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000516'), 'Sede Principale', 'Piazza Garibaldi', '127', 'Ancona', 'AN', '60100', '071345516', 'studiolegale516@email.it', '45000000516', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Ancona', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '45000000517', 'studiocommercialisti517@email.it', '071345517');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000517'), 'Sede Principale', 'Corso Vittorio Emanuele', '2', 'Ancona', 'AN', '60100', '071345517', 'studiocommercialisti517@email.it', '45000000517', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Ancona', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '45000000518', 'notaio518@email.it', '071345518');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000518'), 'Sede Principale', 'Corso Vittorio Emanuele', '49', 'Ancona', 'AN', '60100', '071345518', 'notaio518@email.it', '45000000518', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Ancona', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '45000000519', 'parrucchiere519@email.it', '071345519');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000519'), 'Sede Principale', 'Via Dante', '59', 'Ancona', 'AN', '60100', '071345519', 'parrucchiere519@email.it', '45000000519', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Ancona', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '45000000520', 'centroestetico520@email.it', '071345520');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000520'), 'Sede Principale', 'Corso Umberto', '36', 'Ancona', 'AN', '60100', '071345520', 'centroestetico520@email.it', '45000000520', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Ancona', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '45000000521', 'idraulico521@email.it', '3331234521');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000521'), 'Sede Principale', 'Piazza del Duomo', '198', 'Ancona', 'AN', '60100', '3331234521', 'idraulico521@email.it', '45000000521', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Ancona', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '45000000522', 'elettricista522@email.it', '3331234522');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000522'), 'Sede Principale', 'Piazza del Duomo', '25', 'Ancona', 'AN', '60100', '3331234522', 'elettricista522@email.it', '45000000522', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Ancona', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '45000000523', 'imbianchino523@email.it', '3331234523');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000523'), 'Sede Principale', 'Corso Umberto', '102', 'Ancona', 'AN', '60100', '3331234523', 'imbianchino523@email.it', '45000000523', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Ancona', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '45000000524', 'fabbro524@email.it', '3331234524');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000524'), 'Sede Principale', 'Via Dante', '140', 'Ancona', 'AN', '60100', '3331234524', 'fabbro524@email.it', '45000000524', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Ancona', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '45000000525', 'falegname525@email.it', '3331234525');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000525'), 'Sede Principale', 'Piazza Garibaldi', '45', 'Ancona', 'AN', '60100', '3331234525', 'falegname525@email.it', '45000000525', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Ancona', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '45000000526', 'supermercato526@email.it', '071345526');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000526'), 'Sede Principale', 'Corso Italia', '104', 'Ancona', 'AN', '60100', '071345526', 'supermercato526@email.it', '45000000526', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Ancona', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '45000000527', 'ferramenta527@email.it', '071345527');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000527'), 'Sede Principale', 'Via Dante', '21', 'Ancona', 'AN', '60100', '071345527', 'ferramenta527@email.it', '45000000527', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Ancona', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '45000000528', 'palestra528@email.it', '071345528');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000528'), 'Sede Principale', 'Via Mazzini', '38', 'Ancona', 'AN', '60100', '071345528', 'palestra528@email.it', '45000000528', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Ancona', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '45000000529', 'panificio529@email.it', '071345529');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000529'), 'Sede Principale', 'Corso Vittorio Emanuele', '21', 'Ancona', 'AN', '60100', '071345529', 'panificio529@email.it', '45000000529', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Ancona', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '45000000530', 'pasticceria530@email.it', '071345530');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000530'), 'Sede Principale', 'Corso Vittorio Emanuele', '68', 'Ancona', 'AN', '60100', '071345530', 'pasticceria530@email.it', '45000000530', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Ancona', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '45000000531', 'veterinario531@email.it', '071345531');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000531'), 'Sede Principale', 'Corso Umberto', '111', 'Ancona', 'AN', '60100', '071345531', 'veterinario531@email.it', '45000000531', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Ancona', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '45000000532', 'macelleria532@email.it', '071345532');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000532'), 'Sede Principale', 'Via Cavour', '122', 'Ancona', 'AN', '60100', '071345532', 'macelleria532@email.it', '45000000532', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Ancona', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '45000000533', 'pescheria533@email.it', '071345533');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000533'), 'Sede Principale', 'Via Roma', '175', 'Ancona', 'AN', '60100', '071345533', 'pescheria533@email.it', '45000000533', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Ancona', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '45000000534', 'libreria534@email.it', '071345534');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000534'), 'Sede Principale', 'Via Mazzini', '125', 'Ancona', 'AN', '60100', '071345534', 'libreria534@email.it', '45000000534', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Ancona', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '45000000535', 'architetto535@email.it', '071345535');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000535'), 'Sede Principale', 'Via Verdi', '97', 'Ancona', 'AN', '60100', '071345535', 'architetto535@email.it', '45000000535', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Ancona', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '45000000536', 'ingegnere536@email.it', '071345536');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000536'), 'Sede Principale', 'Via Dante', '57', 'Ancona', 'AN', '60100', '071345536', 'ingegnere536@email.it', '45000000536', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Ancona', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '45000000537', 'geometra537@email.it', '071345537');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000537'), 'Sede Principale', 'Via Cavour', '99', 'Ancona', 'AN', '60100', '071345537', 'geometra537@email.it', '45000000537', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Ancona', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '45000000538', 'officinaauto538@email.it', '071345538');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000538'), 'Sede Principale', 'Corso Vittorio Emanuele', '64', 'Ancona', 'AN', '60100', '071345538', 'officinaauto538@email.it', '45000000538', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Ancona', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '45000000539', 'gommista539@email.it', '071345539');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000539'), 'Sede Principale', 'Via Dante', '57', 'Ancona', 'AN', '60100', '071345539', 'gommista539@email.it', '45000000539', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Pesaro', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '45000000540', 'trattoria540@email.it', '071345540');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000540'), 'Sede Principale', 'Piazza del Duomo', '175', 'Pesaro', 'PU', '61100', '071345540', 'trattoria540@email.it', '45000000540', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Pesaro', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '45000000541', 'pizzeria541@email.it', '071345541');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000541'), 'Sede Principale', 'Via Verdi', '145', 'Pesaro', 'PU', '61100', '071345541', 'pizzeria541@email.it', '45000000541', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Pesaro', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '45000000542', 'barpasticceria542@email.it', '071345542');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000542'), 'Sede Principale', 'Via Mazzini', '125', 'Pesaro', 'PU', '61100', '071345542', 'barpasticceria542@email.it', '45000000542', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Pesaro', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '45000000543', 'studiodentistico543@email.it', '071345543');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000543'), 'Sede Principale', 'Via Verdi', '199', 'Pesaro', 'PU', '61100', '071345543', 'studiodentistico543@email.it', '45000000543', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Pesaro', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '45000000544', 'poliambulatorio544@email.it', '071345544');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000544'), 'Sede Principale', 'Via Mazzini', '117', 'Pesaro', 'PU', '61100', '071345544', 'poliambulatorio544@email.it', '45000000544', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Pesaro', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '45000000545', 'farmacia545@email.it', '071345545');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000545'), 'Sede Principale', 'Corso Italia', '152', 'Pesaro', 'PU', '61100', '071345545', 'farmacia545@email.it', '45000000545', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Pesaro', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '45000000546', 'studiolegale546@email.it', '071345546');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000546'), 'Sede Principale', 'Via Roma', '44', 'Pesaro', 'PU', '61100', '071345546', 'studiolegale546@email.it', '45000000546', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Pesaro', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '45000000547', 'commercialista547@email.it', '071345547');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000547'), 'Sede Principale', 'Via Verdi', '164', 'Pesaro', 'PU', '61100', '071345547', 'commercialista547@email.it', '45000000547', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Pesaro', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '45000000548', 'notaio548@email.it', '071345548');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000548'), 'Sede Principale', 'Corso Umberto', '7', 'Pesaro', 'PU', '61100', '071345548', 'notaio548@email.it', '45000000548', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Pesaro', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '45000000549', 'parrucchiere549@email.it', '071345549');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000549'), 'Sede Principale', 'Corso Italia', '144', 'Pesaro', 'PU', '61100', '071345549', 'parrucchiere549@email.it', '45000000549', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Pesaro', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '45000000550', 'centroestetico550@email.it', '071345550');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000550'), 'Sede Principale', 'Via Verdi', '148', 'Pesaro', 'PU', '61100', '071345550', 'centroestetico550@email.it', '45000000550', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Pesaro', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '45000000551', 'idraulico551@email.it', '3331234551');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000551'), 'Sede Principale', 'Via Verdi', '180', 'Pesaro', 'PU', '61100', '3331234551', 'idraulico551@email.it', '45000000551', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Pesaro', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '45000000552', 'elettricista552@email.it', '3331234552');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000552'), 'Sede Principale', 'Corso Umberto', '105', 'Pesaro', 'PU', '61100', '3331234552', 'elettricista552@email.it', '45000000552', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Pesaro', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '45000000553', 'imbianchino553@email.it', '3331234553');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000553'), 'Sede Principale', 'Via Roma', '176', 'Pesaro', 'PU', '61100', '3331234553', 'imbianchino553@email.it', '45000000553', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Pesaro', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '45000000554', 'fabbro554@email.it', '3331234554');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000554'), 'Sede Principale', 'Via Cavour', '157', 'Pesaro', 'PU', '61100', '3331234554', 'fabbro554@email.it', '45000000554', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Pesaro', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '45000000555', 'falegname555@email.it', '3331234555');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000555'), 'Sede Principale', 'Via Cavour', '170', 'Pesaro', 'PU', '61100', '3331234555', 'falegname555@email.it', '45000000555', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Pesaro', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '45000000556', 'supermercato556@email.it', '071345556');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000556'), 'Sede Principale', 'Via Verdi', '105', 'Pesaro', 'PU', '61100', '071345556', 'supermercato556@email.it', '45000000556', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Pesaro', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '45000000557', 'ferramenta557@email.it', '071345557');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000557'), 'Sede Principale', 'Via Mazzini', '103', 'Pesaro', 'PU', '61100', '071345557', 'ferramenta557@email.it', '45000000557', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Pesaro', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '45000000558', 'palestra558@email.it', '071345558');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000558'), 'Sede Principale', 'Via Verdi', '159', 'Pesaro', 'PU', '61100', '071345558', 'palestra558@email.it', '45000000558', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Pesaro', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '45000000559', 'panificio559@email.it', '071345559');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000559'), 'Sede Principale', 'Via Verdi', '183', 'Pesaro', 'PU', '61100', '071345559', 'panificio559@email.it', '45000000559', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Pesaro', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '45000000560', 'gelateria560@email.it', '071345560');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000560'), 'Sede Principale', 'Via Verdi', '62', 'Pesaro', 'PU', '61100', '071345560', 'gelateria560@email.it', '45000000560', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Pesaro', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '45000000561', 'veterinario561@email.it', '071345561');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000561'), 'Sede Principale', 'Corso Vittorio Emanuele', '81', 'Pesaro', 'PU', '61100', '071345561', 'veterinario561@email.it', '45000000561', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Pesaro', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '45000000562', 'macelleria562@email.it', '071345562');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000562'), 'Sede Principale', 'Piazza Garibaldi', '183', 'Pesaro', 'PU', '61100', '071345562', 'macelleria562@email.it', '45000000562', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Pesaro', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '45000000563', 'pescheria563@email.it', '071345563');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000563'), 'Sede Principale', 'Piazza Garibaldi', '27', 'Pesaro', 'PU', '61100', '071345563', 'pescheria563@email.it', '45000000563', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Pesaro', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '45000000564', 'libreria564@email.it', '071345564');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000564'), 'Sede Principale', 'Piazza Garibaldi', '122', 'Pesaro', 'PU', '61100', '071345564', 'libreria564@email.it', '45000000564', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Pesaro', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '45000000565', 'architetto565@email.it', '071345565');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000565'), 'Sede Principale', 'Corso Umberto', '115', 'Pesaro', 'PU', '61100', '071345565', 'architetto565@email.it', '45000000565', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Pesaro', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '45000000566', 'studioingegneri566@email.it', '071345566');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000566'), 'Sede Principale', 'Corso Vittorio Emanuele', '108', 'Pesaro', 'PU', '61100', '071345566', 'studioingegneri566@email.it', '45000000566', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Pesaro', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '45000000567', 'geometra567@email.it', '071345567');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000567'), 'Sede Principale', 'Piazza del Duomo', '165', 'Pesaro', 'PU', '61100', '071345567', 'geometra567@email.it', '45000000567', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Pesaro', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '45000000568', 'officinaauto568@email.it', '071345568');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000568'), 'Sede Principale', 'Corso Umberto', '39', 'Pesaro', 'PU', '61100', '071345568', 'officinaauto568@email.it', '45000000568', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Pesaro', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '45000000569', 'gommista569@email.it', '071345569');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000569'), 'Sede Principale', 'Piazza del Duomo', '170', 'Pesaro', 'PU', '61100', '071345569', 'gommista569@email.it', '45000000569', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Macerata', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '45000000570', 'trattoria570@email.it', '071345570');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000570'), 'Sede Principale', 'Piazza Garibaldi', '1', 'Macerata', 'MC', '62100', '071345570', 'trattoria570@email.it', '45000000570', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Macerata', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '45000000571', 'pizzeria571@email.it', '071345571');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000571'), 'Sede Principale', 'Corso Italia', '4', 'Macerata', 'MC', '62100', '071345571', 'pizzeria571@email.it', '45000000571', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Macerata', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '45000000572', 'bar572@email.it', '071345572');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000572'), 'Sede Principale', 'Via Dante', '88', 'Macerata', 'MC', '62100', '071345572', 'bar572@email.it', '45000000572', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Macerata', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '45000000573', 'studiodentistico573@email.it', '071345573');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000573'), 'Sede Principale', 'Via Dante', '140', 'Macerata', 'MC', '62100', '071345573', 'studiodentistico573@email.it', '45000000573', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Macerata', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '45000000574', 'studiomedico574@email.it', '071345574');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000574'), 'Sede Principale', 'Corso Umberto', '160', 'Macerata', 'MC', '62100', '071345574', 'studiomedico574@email.it', '45000000574', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Macerata', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '45000000575', 'farmacia575@email.it', '071345575');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000575'), 'Sede Principale', 'Via Cavour', '200', 'Macerata', 'MC', '62100', '071345575', 'farmacia575@email.it', '45000000575', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Macerata', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '45000000576', 'studiolegale576@email.it', '071345576');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000576'), 'Sede Principale', 'Corso Vittorio Emanuele', '191', 'Macerata', 'MC', '62100', '071345576', 'studiolegale576@email.it', '45000000576', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Macerata', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '45000000577', 'commercialista577@email.it', '071345577');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000577'), 'Sede Principale', 'Corso Vittorio Emanuele', '16', 'Macerata', 'MC', '62100', '071345577', 'commercialista577@email.it', '45000000577', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Macerata', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '45000000578', 'notaio578@email.it', '071345578');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000578'), 'Sede Principale', 'Corso Vittorio Emanuele', '24', 'Macerata', 'MC', '62100', '071345578', 'notaio578@email.it', '45000000578', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Macerata', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '45000000579', 'parrucchiere579@email.it', '071345579');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000579'), 'Sede Principale', 'Piazza del Duomo', '180', 'Macerata', 'MC', '62100', '071345579', 'parrucchiere579@email.it', '45000000579', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Macerata', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '45000000580', 'centroestetico580@email.it', '071345580');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000580'), 'Sede Principale', 'Via Mazzini', '117', 'Macerata', 'MC', '62100', '071345580', 'centroestetico580@email.it', '45000000580', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Macerata', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '45000000581', 'idraulico581@email.it', '3331234581');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000581'), 'Sede Principale', 'Via Verdi', '80', 'Macerata', 'MC', '62100', '3331234581', 'idraulico581@email.it', '45000000581', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Macerata', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '45000000582', 'elettricista582@email.it', '3331234582');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000582'), 'Sede Principale', 'Corso Italia', '162', 'Macerata', 'MC', '62100', '3331234582', 'elettricista582@email.it', '45000000582', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Macerata', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '45000000583', 'imbianchino583@email.it', '3331234583');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000583'), 'Sede Principale', 'Corso Italia', '65', 'Macerata', 'MC', '62100', '3331234583', 'imbianchino583@email.it', '45000000583', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Macerata', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '45000000584', 'fabbro584@email.it', '3331234584');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000584'), 'Sede Principale', 'Corso Italia', '116', 'Macerata', 'MC', '62100', '3331234584', 'fabbro584@email.it', '45000000584', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Macerata', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '45000000585', 'falegname585@email.it', '3331234585');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000585'), 'Sede Principale', 'Via Roma', '160', 'Macerata', 'MC', '62100', '3331234585', 'falegname585@email.it', '45000000585', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Macerata', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '45000000586', 'supermercato586@email.it', '071345586');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000586'), 'Sede Principale', 'Piazza del Duomo', '30', 'Macerata', 'MC', '62100', '071345586', 'supermercato586@email.it', '45000000586', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Macerata', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '45000000587', 'ferramenta587@email.it', '071345587');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000587'), 'Sede Principale', 'Via Mazzini', '117', 'Macerata', 'MC', '62100', '071345587', 'ferramenta587@email.it', '45000000587', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Macerata', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '45000000588', 'palestra588@email.it', '071345588');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000588'), 'Sede Principale', 'Piazza Garibaldi', '81', 'Macerata', 'MC', '62100', '071345588', 'palestra588@email.it', '45000000588', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Macerata', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '45000000589', 'panificio589@email.it', '071345589');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000589'), 'Sede Principale', 'Via Cavour', '64', 'Macerata', 'MC', '62100', '071345589', 'panificio589@email.it', '45000000589', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Macerata', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '45000000590', 'pasticceria590@email.it', '071345590');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000590'), 'Sede Principale', 'Piazza del Duomo', '148', 'Macerata', 'MC', '62100', '071345590', 'pasticceria590@email.it', '45000000590', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Macerata', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '45000000591', 'veterinario591@email.it', '071345591');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000591'), 'Sede Principale', 'Piazza del Duomo', '191', 'Macerata', 'MC', '62100', '071345591', 'veterinario591@email.it', '45000000591', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Macerata', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '45000000592', 'macelleria592@email.it', '071345592');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000592'), 'Sede Principale', 'Corso Umberto', '66', 'Macerata', 'MC', '62100', '071345592', 'macelleria592@email.it', '45000000592', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Macerata', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '45000000593', 'pescheria593@email.it', '071345593');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000593'), 'Sede Principale', 'Piazza del Duomo', '99', 'Macerata', 'MC', '62100', '071345593', 'pescheria593@email.it', '45000000593', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Macerata', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '45000000594', 'libreria594@email.it', '071345594');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000594'), 'Sede Principale', 'Piazza Garibaldi', '115', 'Macerata', 'MC', '62100', '071345594', 'libreria594@email.it', '45000000594', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Macerata', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '45000000595', 'architetto595@email.it', '071345595');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000595'), 'Sede Principale', 'Corso Vittorio Emanuele', '57', 'Macerata', 'MC', '62100', '071345595', 'architetto595@email.it', '45000000595', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Macerata', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '45000000596', 'ingegnere596@email.it', '071345596');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000596'), 'Sede Principale', 'Via Roma', '5', 'Macerata', 'MC', '62100', '071345596', 'ingegnere596@email.it', '45000000596', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Macerata', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '45000000597', 'geometra597@email.it', '071345597');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000597'), 'Sede Principale', 'Via Cavour', '102', 'Macerata', 'MC', '62100', '071345597', 'geometra597@email.it', '45000000597', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Macerata', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '45000000598', 'officinaauto598@email.it', '071345598');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000598'), 'Sede Principale', 'Via Cavour', '171', 'Macerata', 'MC', '62100', '071345598', 'officinaauto598@email.it', '45000000598', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Macerata', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '45000000599', 'gommista599@email.it', '071345599');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000599'), 'Sede Principale', 'Via Cavour', '91', 'Macerata', 'MC', '62100', '071345599', 'gommista599@email.it', '45000000599', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '45000000600', 'ristorante600@email.it', '071345600');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000600'), 'Sede Principale', 'Via Roma', '20', 'Ascoli Piceno', 'AP', '63100', '071345600', 'ristorante600@email.it', '45000000600', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '45000000601', 'pizzeria601@email.it', '071345601');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000601'), 'Sede Principale', 'Via Mazzini', '124', 'Ascoli Piceno', 'AP', '63100', '071345601', 'pizzeria601@email.it', '45000000601', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '45000000602', 'barpasticceria602@email.it', '071345602');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000602'), 'Sede Principale', 'Piazza del Duomo', '93', 'Ascoli Piceno', 'AP', '63100', '071345602', 'barpasticceria602@email.it', '45000000602', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '45000000603', 'studiodentistico603@email.it', '071345603');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000603'), 'Sede Principale', 'Corso Vittorio Emanuele', '76', 'Ascoli Piceno', 'AP', '63100', '071345603', 'studiodentistico603@email.it', '45000000603', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '45000000604', 'studiomedico604@email.it', '071345604');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000604'), 'Sede Principale', 'Via Mazzini', '128', 'Ascoli Piceno', 'AP', '63100', '071345604', 'studiomedico604@email.it', '45000000604', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '45000000605', 'farmacia605@email.it', '071345605');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000605'), 'Sede Principale', 'Via Verdi', '22', 'Ascoli Piceno', 'AP', '63100', '071345605', 'farmacia605@email.it', '45000000605', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '45000000606', 'avvocato606@email.it', '071345606');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000606'), 'Sede Principale', 'Piazza Garibaldi', '136', 'Ascoli Piceno', 'AP', '63100', '071345606', 'avvocato606@email.it', '45000000606', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '45000000607', 'commercialista607@email.it', '071345607');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000607'), 'Sede Principale', 'Via Verdi', '14', 'Ascoli Piceno', 'AP', '63100', '071345607', 'commercialista607@email.it', '45000000607', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '45000000608', 'notaio608@email.it', '071345608');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000608'), 'Sede Principale', 'Corso Umberto', '162', 'Ascoli Piceno', 'AP', '63100', '071345608', 'notaio608@email.it', '45000000608', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '45000000609', 'parrucchiere609@email.it', '071345609');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000609'), 'Sede Principale', 'Via Cavour', '150', 'Ascoli Piceno', 'AP', '63100', '071345609', 'parrucchiere609@email.it', '45000000609', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '45000000610', 'centroestetico610@email.it', '071345610');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000610'), 'Sede Principale', 'Piazza del Duomo', '169', 'Ascoli Piceno', 'AP', '63100', '071345610', 'centroestetico610@email.it', '45000000610', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '45000000611', 'idraulico611@email.it', '3331234611');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000611'), 'Sede Principale', 'Via Mazzini', '25', 'Ascoli Piceno', 'AP', '63100', '3331234611', 'idraulico611@email.it', '45000000611', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '45000000612', 'elettricista612@email.it', '3331234612');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000612'), 'Sede Principale', 'Via Cavour', '15', 'Ascoli Piceno', 'AP', '63100', '3331234612', 'elettricista612@email.it', '45000000612', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '45000000613', 'imbianchino613@email.it', '3331234613');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000613'), 'Sede Principale', 'Via Roma', '146', 'Ascoli Piceno', 'AP', '63100', '3331234613', 'imbianchino613@email.it', '45000000613', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '45000000614', 'fabbro614@email.it', '3331234614');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000614'), 'Sede Principale', 'Via Roma', '70', 'Ascoli Piceno', 'AP', '63100', '3331234614', 'fabbro614@email.it', '45000000614', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '45000000615', 'falegname615@email.it', '3331234615');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000615'), 'Sede Principale', 'Via Dante', '86', 'Ascoli Piceno', 'AP', '63100', '3331234615', 'falegname615@email.it', '45000000615', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '45000000616', 'supermercato616@email.it', '071345616');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000616'), 'Sede Principale', 'Via Cavour', '52', 'Ascoli Piceno', 'AP', '63100', '071345616', 'supermercato616@email.it', '45000000616', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '45000000617', 'ferramenta617@email.it', '071345617');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000617'), 'Sede Principale', 'Corso Italia', '168', 'Ascoli Piceno', 'AP', '63100', '071345617', 'ferramenta617@email.it', '45000000617', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '45000000618', 'palestra618@email.it', '071345618');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000618'), 'Sede Principale', 'Via Mazzini', '62', 'Ascoli Piceno', 'AP', '63100', '071345618', 'palestra618@email.it', '45000000618', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '45000000619', 'panificio619@email.it', '071345619');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000619'), 'Sede Principale', 'Corso Umberto', '19', 'Ascoli Piceno', 'AP', '63100', '071345619', 'panificio619@email.it', '45000000619', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '45000000620', 'pasticceria620@email.it', '071345620');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000620'), 'Sede Principale', 'Via Verdi', '78', 'Ascoli Piceno', 'AP', '63100', '071345620', 'pasticceria620@email.it', '45000000620', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '45000000621', 'veterinario621@email.it', '071345621');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000621'), 'Sede Principale', 'Via Dante', '113', 'Ascoli Piceno', 'AP', '63100', '071345621', 'veterinario621@email.it', '45000000621', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '45000000622', 'macelleria622@email.it', '071345622');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000622'), 'Sede Principale', 'Corso Italia', '139', 'Ascoli Piceno', 'AP', '63100', '071345622', 'macelleria622@email.it', '45000000622', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '45000000623', 'pescheria623@email.it', '071345623');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000623'), 'Sede Principale', 'Corso Vittorio Emanuele', '5', 'Ascoli Piceno', 'AP', '63100', '071345623', 'pescheria623@email.it', '45000000623', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '45000000624', 'libreria624@email.it', '071345624');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000624'), 'Sede Principale', 'Via Roma', '162', 'Ascoli Piceno', 'AP', '63100', '071345624', 'libreria624@email.it', '45000000624', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '45000000625', 'studioarchitetti625@email.it', '071345625');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000625'), 'Sede Principale', 'Via Verdi', '35', 'Ascoli Piceno', 'AP', '63100', '071345625', 'studioarchitetti625@email.it', '45000000625', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '45000000626', 'studioingegneri626@email.it', '071345626');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000626'), 'Sede Principale', 'Via Dante', '186', 'Ascoli Piceno', 'AP', '63100', '071345626', 'studioingegneri626@email.it', '45000000626', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '45000000627', 'geometra627@email.it', '071345627');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000627'), 'Sede Principale', 'Corso Italia', '183', 'Ascoli Piceno', 'AP', '63100', '071345627', 'geometra627@email.it', '45000000627', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '45000000628', 'officinaauto628@email.it', '071345628');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000628'), 'Sede Principale', 'Piazza del Duomo', '99', 'Ascoli Piceno', 'AP', '63100', '071345628', 'officinaauto628@email.it', '45000000628', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Ascoli Piceno', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '45000000629', 'gommista629@email.it', '071345629');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '45000000629'), 'Sede Principale', 'Corso Vittorio Emanuele', '10', 'Ascoli Piceno', 'AP', '63100', '071345629', 'gommista629@email.it', '45000000629', true);

-- MOLISE
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Campobasso', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '46000000630', 'osteria630@email.it', '087345630');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000630'), 'Sede Principale', 'Via Cavour', '154', 'Campobasso', 'CB', '86100', '087345630', 'osteria630@email.it', '46000000630', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Campobasso', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '46000000631', 'pizzeria631@email.it', '087345631');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000631'), 'Sede Principale', 'Via Cavour', '70', 'Campobasso', 'CB', '86100', '087345631', 'pizzeria631@email.it', '46000000631', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Campobasso', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '46000000632', 'barpasticceria632@email.it', '087345632');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000632'), 'Sede Principale', 'Via Verdi', '97', 'Campobasso', 'CB', '86100', '087345632', 'barpasticceria632@email.it', '46000000632', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Campobasso', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '46000000633', 'studiodentistico633@email.it', '087345633');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000633'), 'Sede Principale', 'Via Verdi', '90', 'Campobasso', 'CB', '86100', '087345633', 'studiodentistico633@email.it', '46000000633', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Campobasso', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '46000000634', 'studiomedico634@email.it', '087345634');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000634'), 'Sede Principale', 'Via Mazzini', '29', 'Campobasso', 'CB', '86100', '087345634', 'studiomedico634@email.it', '46000000634', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Campobasso', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '46000000635', 'farmacia635@email.it', '087345635');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000635'), 'Sede Principale', 'Via Cavour', '34', 'Campobasso', 'CB', '86100', '087345635', 'farmacia635@email.it', '46000000635', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Campobasso', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '46000000636', 'studiolegale636@email.it', '087345636');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000636'), 'Sede Principale', 'Via Dante', '134', 'Campobasso', 'CB', '86100', '087345636', 'studiolegale636@email.it', '46000000636', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Campobasso', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '46000000637', 'commercialista637@email.it', '087345637');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000637'), 'Sede Principale', 'Via Roma', '191', 'Campobasso', 'CB', '86100', '087345637', 'commercialista637@email.it', '46000000637', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Campobasso', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '46000000638', 'notaio638@email.it', '087345638');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000638'), 'Sede Principale', 'Via Dante', '176', 'Campobasso', 'CB', '86100', '087345638', 'notaio638@email.it', '46000000638', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Campobasso', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '46000000639', 'parrucchiere639@email.it', '087345639');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000639'), 'Sede Principale', 'Piazza Garibaldi', '74', 'Campobasso', 'CB', '86100', '087345639', 'parrucchiere639@email.it', '46000000639', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Campobasso', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '46000000640', 'centroestetico640@email.it', '087345640');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000640'), 'Sede Principale', 'Corso Vittorio Emanuele', '30', 'Campobasso', 'CB', '86100', '087345640', 'centroestetico640@email.it', '46000000640', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Campobasso', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '46000000641', 'idraulico641@email.it', '3331234641');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000641'), 'Sede Principale', 'Via Cavour', '65', 'Campobasso', 'CB', '86100', '3331234641', 'idraulico641@email.it', '46000000641', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Campobasso', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '46000000642', 'elettricista642@email.it', '3331234642');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000642'), 'Sede Principale', 'Via Dante', '34', 'Campobasso', 'CB', '86100', '3331234642', 'elettricista642@email.it', '46000000642', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Campobasso', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '46000000643', 'imbianchino643@email.it', '3331234643');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000643'), 'Sede Principale', 'Piazza Garibaldi', '73', 'Campobasso', 'CB', '86100', '3331234643', 'imbianchino643@email.it', '46000000643', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Campobasso', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '46000000644', 'fabbro644@email.it', '3331234644');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000644'), 'Sede Principale', 'Piazza Garibaldi', '117', 'Campobasso', 'CB', '86100', '3331234644', 'fabbro644@email.it', '46000000644', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Campobasso', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '46000000645', 'falegname645@email.it', '3331234645');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000645'), 'Sede Principale', 'Via Mazzini', '128', 'Campobasso', 'CB', '86100', '3331234645', 'falegname645@email.it', '46000000645', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Campobasso', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '46000000646', 'supermercato646@email.it', '087345646');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000646'), 'Sede Principale', 'Piazza Garibaldi', '39', 'Campobasso', 'CB', '86100', '087345646', 'supermercato646@email.it', '46000000646', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Campobasso', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '46000000647', 'ferramenta647@email.it', '087345647');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000647'), 'Sede Principale', 'Via Roma', '65', 'Campobasso', 'CB', '86100', '087345647', 'ferramenta647@email.it', '46000000647', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Campobasso', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '46000000648', 'palestra648@email.it', '087345648');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000648'), 'Sede Principale', 'Corso Vittorio Emanuele', '142', 'Campobasso', 'CB', '86100', '087345648', 'palestra648@email.it', '46000000648', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Campobasso', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '46000000649', 'panificio649@email.it', '087345649');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000649'), 'Sede Principale', 'Corso Vittorio Emanuele', '65', 'Campobasso', 'CB', '86100', '087345649', 'panificio649@email.it', '46000000649', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Campobasso', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '46000000650', 'gelateria650@email.it', '087345650');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000650'), 'Sede Principale', 'Via Verdi', '35', 'Campobasso', 'CB', '86100', '087345650', 'gelateria650@email.it', '46000000650', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Campobasso', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '46000000651', 'veterinario651@email.it', '087345651');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000651'), 'Sede Principale', 'Via Dante', '117', 'Campobasso', 'CB', '86100', '087345651', 'veterinario651@email.it', '46000000651', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Campobasso', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '46000000652', 'macelleria652@email.it', '087345652');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000652'), 'Sede Principale', 'Via Mazzini', '94', 'Campobasso', 'CB', '86100', '087345652', 'macelleria652@email.it', '46000000652', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Campobasso', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '46000000653', 'pescheria653@email.it', '087345653');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000653'), 'Sede Principale', 'Corso Umberto', '181', 'Campobasso', 'CB', '86100', '087345653', 'pescheria653@email.it', '46000000653', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Campobasso', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '46000000654', 'libreria654@email.it', '087345654');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000654'), 'Sede Principale', 'Via Cavour', '189', 'Campobasso', 'CB', '86100', '087345654', 'libreria654@email.it', '46000000654', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Campobasso', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '46000000655', 'architetto655@email.it', '087345655');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000655'), 'Sede Principale', 'Corso Vittorio Emanuele', '94', 'Campobasso', 'CB', '86100', '087345655', 'architetto655@email.it', '46000000655', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Campobasso', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '46000000656', 'ingegnere656@email.it', '087345656');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000656'), 'Sede Principale', 'Piazza del Duomo', '113', 'Campobasso', 'CB', '86100', '087345656', 'ingegnere656@email.it', '46000000656', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Campobasso', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '46000000657', 'geometra657@email.it', '087345657');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000657'), 'Sede Principale', 'Via Mazzini', '115', 'Campobasso', 'CB', '86100', '087345657', 'geometra657@email.it', '46000000657', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Campobasso', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '46000000658', 'officinaauto658@email.it', '087345658');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000658'), 'Sede Principale', 'Via Cavour', '136', 'Campobasso', 'CB', '86100', '087345658', 'officinaauto658@email.it', '46000000658', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Campobasso', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '46000000659', 'gommista659@email.it', '087345659');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000659'), 'Sede Principale', 'Corso Vittorio Emanuele', '180', 'Campobasso', 'CB', '86100', '087345659', 'gommista659@email.it', '46000000659', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Isernia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '46000000660', 'ristorante660@email.it', '087345660');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000660'), 'Sede Principale', 'Piazza del Duomo', '181', 'Isernia', 'IS', '86170', '087345660', 'ristorante660@email.it', '46000000660', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Isernia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '46000000661', 'pizzeria661@email.it', '087345661');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000661'), 'Sede Principale', 'Via Mazzini', '84', 'Isernia', 'IS', '86170', '087345661', 'pizzeria661@email.it', '46000000661', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Isernia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '46000000662', 'bar662@email.it', '087345662');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000662'), 'Sede Principale', 'Via Dante', '171', 'Isernia', 'IS', '86170', '087345662', 'bar662@email.it', '46000000662', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Isernia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '46000000663', 'studiodentistico663@email.it', '087345663');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000663'), 'Sede Principale', 'Piazza del Duomo', '140', 'Isernia', 'IS', '86170', '087345663', 'studiodentistico663@email.it', '46000000663', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Isernia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '46000000664', 'poliambulatorio664@email.it', '087345664');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000664'), 'Sede Principale', 'Corso Vittorio Emanuele', '81', 'Isernia', 'IS', '86170', '087345664', 'poliambulatorio664@email.it', '46000000664', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Isernia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '46000000665', 'farmacia665@email.it', '087345665');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000665'), 'Sede Principale', 'Piazza del Duomo', '75', 'Isernia', 'IS', '86170', '087345665', 'farmacia665@email.it', '46000000665', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Isernia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '46000000666', 'avvocato666@email.it', '087345666');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000666'), 'Sede Principale', 'Via Dante', '190', 'Isernia', 'IS', '86170', '087345666', 'avvocato666@email.it', '46000000666', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Isernia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '46000000667', 'studiocommercialisti667@email.it', '087345667');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000667'), 'Sede Principale', 'Via Cavour', '162', 'Isernia', 'IS', '86170', '087345667', 'studiocommercialisti667@email.it', '46000000667', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Isernia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '46000000668', 'notaio668@email.it', '087345668');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000668'), 'Sede Principale', 'Via Dante', '124', 'Isernia', 'IS', '86170', '087345668', 'notaio668@email.it', '46000000668', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Isernia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '46000000669', 'salone669@email.it', '087345669');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000669'), 'Sede Principale', 'Piazza del Duomo', '49', 'Isernia', 'IS', '86170', '087345669', 'salone669@email.it', '46000000669', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Isernia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '46000000670', 'centroestetico670@email.it', '087345670');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000670'), 'Sede Principale', 'Piazza del Duomo', '67', 'Isernia', 'IS', '86170', '087345670', 'centroestetico670@email.it', '46000000670', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Isernia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '46000000671', 'idraulico671@email.it', '3331234671');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000671'), 'Sede Principale', 'Corso Italia', '18', 'Isernia', 'IS', '86170', '3331234671', 'idraulico671@email.it', '46000000671', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Isernia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '46000000672', 'elettricista672@email.it', '3331234672');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000672'), 'Sede Principale', 'Via Cavour', '1', 'Isernia', 'IS', '86170', '3331234672', 'elettricista672@email.it', '46000000672', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Isernia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '46000000673', 'imbianchino673@email.it', '3331234673');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000673'), 'Sede Principale', 'Via Mazzini', '10', 'Isernia', 'IS', '86170', '3331234673', 'imbianchino673@email.it', '46000000673', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Isernia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '46000000674', 'fabbro674@email.it', '3331234674');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000674'), 'Sede Principale', 'Via Mazzini', '92', 'Isernia', 'IS', '86170', '3331234674', 'fabbro674@email.it', '46000000674', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Isernia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '46000000675', 'falegname675@email.it', '3331234675');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000675'), 'Sede Principale', 'Piazza del Duomo', '119', 'Isernia', 'IS', '86170', '3331234675', 'falegname675@email.it', '46000000675', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Isernia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '46000000676', 'supermercato676@email.it', '087345676');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000676'), 'Sede Principale', 'Corso Umberto', '77', 'Isernia', 'IS', '86170', '087345676', 'supermercato676@email.it', '46000000676', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Isernia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '46000000677', 'ferramenta677@email.it', '087345677');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000677'), 'Sede Principale', 'Via Cavour', '189', 'Isernia', 'IS', '86170', '087345677', 'ferramenta677@email.it', '46000000677', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Isernia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '46000000678', 'palestra678@email.it', '087345678');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000678'), 'Sede Principale', 'Piazza Garibaldi', '37', 'Isernia', 'IS', '86170', '087345678', 'palestra678@email.it', '46000000678', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Isernia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '46000000679', 'panificio679@email.it', '087345679');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000679'), 'Sede Principale', 'Piazza del Duomo', '184', 'Isernia', 'IS', '86170', '087345679', 'panificio679@email.it', '46000000679', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Isernia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '46000000680', 'gelateria680@email.it', '087345680');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000680'), 'Sede Principale', 'Via Cavour', '92', 'Isernia', 'IS', '86170', '087345680', 'gelateria680@email.it', '46000000680', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Isernia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '46000000681', 'veterinario681@email.it', '087345681');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000681'), 'Sede Principale', 'Via Dante', '54', 'Isernia', 'IS', '86170', '087345681', 'veterinario681@email.it', '46000000681', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Isernia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '46000000682', 'macelleria682@email.it', '087345682');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000682'), 'Sede Principale', 'Via Dante', '67', 'Isernia', 'IS', '86170', '087345682', 'macelleria682@email.it', '46000000682', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Isernia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '46000000683', 'pescheria683@email.it', '087345683');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000683'), 'Sede Principale', 'Via Verdi', '197', 'Isernia', 'IS', '86170', '087345683', 'pescheria683@email.it', '46000000683', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Isernia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '46000000684', 'libreria684@email.it', '087345684');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000684'), 'Sede Principale', 'Corso Italia', '131', 'Isernia', 'IS', '86170', '087345684', 'libreria684@email.it', '46000000684', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Isernia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '46000000685', 'architetto685@email.it', '087345685');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000685'), 'Sede Principale', 'Via Roma', '69', 'Isernia', 'IS', '86170', '087345685', 'architetto685@email.it', '46000000685', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Isernia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '46000000686', 'studioingegneri686@email.it', '087345686');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000686'), 'Sede Principale', 'Piazza Garibaldi', '79', 'Isernia', 'IS', '86170', '087345686', 'studioingegneri686@email.it', '46000000686', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Isernia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '46000000687', 'geometra687@email.it', '087345687');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000687'), 'Sede Principale', 'Piazza del Duomo', '78', 'Isernia', 'IS', '86170', '087345687', 'geometra687@email.it', '46000000687', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Isernia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '46000000688', 'officinaauto688@email.it', '087345688');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000688'), 'Sede Principale', 'Via Mazzini', '179', 'Isernia', 'IS', '86170', '087345688', 'officinaauto688@email.it', '46000000688', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Isernia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '46000000689', 'gommista689@email.it', '087345689');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '46000000689'), 'Sede Principale', 'Via Roma', '64', 'Isernia', 'IS', '86170', '087345689', 'gommista689@email.it', '46000000689', true);

-- PUGLIA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Bari', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '47000000690', 'ristorante690@email.it', '080345690');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000690'), 'Sede Principale', 'Piazza Garibaldi', '125', 'Bari', 'BA', '70100', '080345690', 'ristorante690@email.it', '47000000690', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Bari', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '47000000691', 'pizzeria691@email.it', '080345691');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000691'), 'Sede Principale', 'Via Dante', '87', 'Bari', 'BA', '70100', '080345691', 'pizzeria691@email.it', '47000000691', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Bari', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '47000000692', 'bar692@email.it', '080345692');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000692'), 'Sede Principale', 'Via Dante', '14', 'Bari', 'BA', '70100', '080345692', 'bar692@email.it', '47000000692', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Bari', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '47000000693', 'studiodentistico693@email.it', '080345693');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000693'), 'Sede Principale', 'Via Mazzini', '14', 'Bari', 'BA', '70100', '080345693', 'studiodentistico693@email.it', '47000000693', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Bari', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '47000000694', 'poliambulatorio694@email.it', '080345694');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000694'), 'Sede Principale', 'Via Verdi', '117', 'Bari', 'BA', '70100', '080345694', 'poliambulatorio694@email.it', '47000000694', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Bari', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '47000000695', 'farmacia695@email.it', '080345695');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000695'), 'Sede Principale', 'Corso Vittorio Emanuele', '142', 'Bari', 'BA', '70100', '080345695', 'farmacia695@email.it', '47000000695', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Bari', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '47000000696', 'studiolegale696@email.it', '080345696');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000696'), 'Sede Principale', 'Piazza del Duomo', '5', 'Bari', 'BA', '70100', '080345696', 'studiolegale696@email.it', '47000000696', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Bari', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '47000000697', 'studiocommercialisti697@email.it', '080345697');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000697'), 'Sede Principale', 'Via Cavour', '82', 'Bari', 'BA', '70100', '080345697', 'studiocommercialisti697@email.it', '47000000697', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Bari', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '47000000698', 'notaio698@email.it', '080345698');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000698'), 'Sede Principale', 'Via Mazzini', '165', 'Bari', 'BA', '70100', '080345698', 'notaio698@email.it', '47000000698', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Bari', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '47000000699', 'parrucchiere699@email.it', '080345699');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000699'), 'Sede Principale', 'Via Roma', '150', 'Bari', 'BA', '70100', '080345699', 'parrucchiere699@email.it', '47000000699', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Bari', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '47000000700', 'centroestetico700@email.it', '080345700');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000700'), 'Sede Principale', 'Piazza del Duomo', '192', 'Bari', 'BA', '70100', '080345700', 'centroestetico700@email.it', '47000000700', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Bari', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '47000000701', 'idraulico701@email.it', '3331234701');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000701'), 'Sede Principale', 'Via Mazzini', '82', 'Bari', 'BA', '70100', '3331234701', 'idraulico701@email.it', '47000000701', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Bari', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '47000000702', 'elettricista702@email.it', '3331234702');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000702'), 'Sede Principale', 'Via Mazzini', '50', 'Bari', 'BA', '70100', '3331234702', 'elettricista702@email.it', '47000000702', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Bari', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '47000000703', 'imbianchino703@email.it', '3331234703');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000703'), 'Sede Principale', 'Corso Italia', '174', 'Bari', 'BA', '70100', '3331234703', 'imbianchino703@email.it', '47000000703', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Bari', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '47000000704', 'fabbro704@email.it', '3331234704');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000704'), 'Sede Principale', 'Corso Umberto', '89', 'Bari', 'BA', '70100', '3331234704', 'fabbro704@email.it', '47000000704', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Bari', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '47000000705', 'falegname705@email.it', '3331234705');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000705'), 'Sede Principale', 'Corso Italia', '139', 'Bari', 'BA', '70100', '3331234705', 'falegname705@email.it', '47000000705', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Bari', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '47000000706', 'supermercato706@email.it', '080345706');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000706'), 'Sede Principale', 'Via Verdi', '70', 'Bari', 'BA', '70100', '080345706', 'supermercato706@email.it', '47000000706', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Bari', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '47000000707', 'ferramenta707@email.it', '080345707');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000707'), 'Sede Principale', 'Corso Italia', '128', 'Bari', 'BA', '70100', '080345707', 'ferramenta707@email.it', '47000000707', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Bari', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '47000000708', 'palestra708@email.it', '080345708');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000708'), 'Sede Principale', 'Via Mazzini', '113', 'Bari', 'BA', '70100', '080345708', 'palestra708@email.it', '47000000708', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Bari', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '47000000709', 'panificio709@email.it', '080345709');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000709'), 'Sede Principale', 'Corso Umberto', '69', 'Bari', 'BA', '70100', '080345709', 'panificio709@email.it', '47000000709', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Bari', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '47000000710', 'gelateria710@email.it', '080345710');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000710'), 'Sede Principale', 'Via Mazzini', '124', 'Bari', 'BA', '70100', '080345710', 'gelateria710@email.it', '47000000710', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Bari', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '47000000711', 'veterinario711@email.it', '080345711');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000711'), 'Sede Principale', 'Corso Italia', '54', 'Bari', 'BA', '70100', '080345711', 'veterinario711@email.it', '47000000711', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Bari', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '47000000712', 'macelleria712@email.it', '080345712');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000712'), 'Sede Principale', 'Corso Italia', '75', 'Bari', 'BA', '70100', '080345712', 'macelleria712@email.it', '47000000712', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Bari', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '47000000713', 'pescheria713@email.it', '080345713');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000713'), 'Sede Principale', 'Via Cavour', '171', 'Bari', 'BA', '70100', '080345713', 'pescheria713@email.it', '47000000713', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Bari', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '47000000714', 'libreria714@email.it', '080345714');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000714'), 'Sede Principale', 'Via Roma', '166', 'Bari', 'BA', '70100', '080345714', 'libreria714@email.it', '47000000714', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Bari', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '47000000715', 'studioarchitetti715@email.it', '080345715');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000715'), 'Sede Principale', 'Piazza del Duomo', '51', 'Bari', 'BA', '70100', '080345715', 'studioarchitetti715@email.it', '47000000715', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Bari', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '47000000716', 'studioingegneri716@email.it', '080345716');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000716'), 'Sede Principale', 'Via Cavour', '22', 'Bari', 'BA', '70100', '080345716', 'studioingegneri716@email.it', '47000000716', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Bari', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '47000000717', 'geometra717@email.it', '080345717');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000717'), 'Sede Principale', 'Piazza Garibaldi', '110', 'Bari', 'BA', '70100', '080345717', 'geometra717@email.it', '47000000717', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Bari', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '47000000718', 'officinaauto718@email.it', '080345718');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000718'), 'Sede Principale', 'Via Cavour', '111', 'Bari', 'BA', '70100', '080345718', 'officinaauto718@email.it', '47000000718', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Bari', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '47000000719', 'gommista719@email.it', '080345719');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000719'), 'Sede Principale', 'Via Dante', '170', 'Bari', 'BA', '70100', '080345719', 'gommista719@email.it', '47000000719', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Lecce', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '47000000720', 'osteria720@email.it', '080345720');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000720'), 'Sede Principale', 'Piazza Garibaldi', '85', 'Lecce', 'LE', '73100', '080345720', 'osteria720@email.it', '47000000720', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Lecce', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '47000000721', 'pizzeria721@email.it', '080345721');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000721'), 'Sede Principale', 'Corso Italia', '52', 'Lecce', 'LE', '73100', '080345721', 'pizzeria721@email.it', '47000000721', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Lecce', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '47000000722', 'barpasticceria722@email.it', '080345722');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000722'), 'Sede Principale', 'Via Cavour', '111', 'Lecce', 'LE', '73100', '080345722', 'barpasticceria722@email.it', '47000000722', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Lecce', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '47000000723', 'studiodentistico723@email.it', '080345723');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000723'), 'Sede Principale', 'Corso Vittorio Emanuele', '144', 'Lecce', 'LE', '73100', '080345723', 'studiodentistico723@email.it', '47000000723', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Lecce', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '47000000724', 'studiomedico724@email.it', '080345724');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000724'), 'Sede Principale', 'Piazza Garibaldi', '73', 'Lecce', 'LE', '73100', '080345724', 'studiomedico724@email.it', '47000000724', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Lecce', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '47000000725', 'farmacia725@email.it', '080345725');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000725'), 'Sede Principale', 'Piazza del Duomo', '67', 'Lecce', 'LE', '73100', '080345725', 'farmacia725@email.it', '47000000725', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Lecce', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '47000000726', 'studiolegale726@email.it', '080345726');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000726'), 'Sede Principale', 'Via Dante', '63', 'Lecce', 'LE', '73100', '080345726', 'studiolegale726@email.it', '47000000726', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Lecce', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '47000000727', 'studiocommercialisti727@email.it', '080345727');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000727'), 'Sede Principale', 'Piazza Garibaldi', '105', 'Lecce', 'LE', '73100', '080345727', 'studiocommercialisti727@email.it', '47000000727', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Lecce', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '47000000728', 'notaio728@email.it', '080345728');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000728'), 'Sede Principale', 'Via Verdi', '30', 'Lecce', 'LE', '73100', '080345728', 'notaio728@email.it', '47000000728', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Lecce', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '47000000729', 'parrucchiere729@email.it', '080345729');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000729'), 'Sede Principale', 'Piazza Garibaldi', '160', 'Lecce', 'LE', '73100', '080345729', 'parrucchiere729@email.it', '47000000729', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Lecce', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '47000000730', 'centroestetico730@email.it', '080345730');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000730'), 'Sede Principale', 'Via Verdi', '156', 'Lecce', 'LE', '73100', '080345730', 'centroestetico730@email.it', '47000000730', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Lecce', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '47000000731', 'idraulico731@email.it', '3331234731');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000731'), 'Sede Principale', 'Via Dante', '2', 'Lecce', 'LE', '73100', '3331234731', 'idraulico731@email.it', '47000000731', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Lecce', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '47000000732', 'elettricista732@email.it', '3331234732');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000732'), 'Sede Principale', 'Via Mazzini', '158', 'Lecce', 'LE', '73100', '3331234732', 'elettricista732@email.it', '47000000732', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Lecce', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '47000000733', 'imbianchino733@email.it', '3331234733');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000733'), 'Sede Principale', 'Corso Italia', '124', 'Lecce', 'LE', '73100', '3331234733', 'imbianchino733@email.it', '47000000733', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Lecce', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '47000000734', 'fabbro734@email.it', '3331234734');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000734'), 'Sede Principale', 'Via Mazzini', '86', 'Lecce', 'LE', '73100', '3331234734', 'fabbro734@email.it', '47000000734', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Lecce', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '47000000735', 'falegname735@email.it', '3331234735');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000735'), 'Sede Principale', 'Via Verdi', '114', 'Lecce', 'LE', '73100', '3331234735', 'falegname735@email.it', '47000000735', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Lecce', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '47000000736', 'supermercato736@email.it', '080345736');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000736'), 'Sede Principale', 'Via Cavour', '121', 'Lecce', 'LE', '73100', '080345736', 'supermercato736@email.it', '47000000736', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Lecce', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '47000000737', 'ferramenta737@email.it', '080345737');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000737'), 'Sede Principale', 'Corso Umberto', '29', 'Lecce', 'LE', '73100', '080345737', 'ferramenta737@email.it', '47000000737', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Lecce', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '47000000738', 'palestra738@email.it', '080345738');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000738'), 'Sede Principale', 'Via Roma', '142', 'Lecce', 'LE', '73100', '080345738', 'palestra738@email.it', '47000000738', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Lecce', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '47000000739', 'panificio739@email.it', '080345739');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000739'), 'Sede Principale', 'Via Verdi', '79', 'Lecce', 'LE', '73100', '080345739', 'panificio739@email.it', '47000000739', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Lecce', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '47000000740', 'gelateria740@email.it', '080345740');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000740'), 'Sede Principale', 'Corso Vittorio Emanuele', '63', 'Lecce', 'LE', '73100', '080345740', 'gelateria740@email.it', '47000000740', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Lecce', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '47000000741', 'veterinario741@email.it', '080345741');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000741'), 'Sede Principale', 'Corso Vittorio Emanuele', '54', 'Lecce', 'LE', '73100', '080345741', 'veterinario741@email.it', '47000000741', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Lecce', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '47000000742', 'macelleria742@email.it', '080345742');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000742'), 'Sede Principale', 'Via Roma', '55', 'Lecce', 'LE', '73100', '080345742', 'macelleria742@email.it', '47000000742', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Lecce', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '47000000743', 'pescheria743@email.it', '080345743');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000743'), 'Sede Principale', 'Via Roma', '104', 'Lecce', 'LE', '73100', '080345743', 'pescheria743@email.it', '47000000743', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Lecce', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '47000000744', 'libreria744@email.it', '080345744');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000744'), 'Sede Principale', 'Piazza Garibaldi', '156', 'Lecce', 'LE', '73100', '080345744', 'libreria744@email.it', '47000000744', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Lecce', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '47000000745', 'studioarchitetti745@email.it', '080345745');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000745'), 'Sede Principale', 'Piazza del Duomo', '30', 'Lecce', 'LE', '73100', '080345745', 'studioarchitetti745@email.it', '47000000745', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Lecce', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '47000000746', 'ingegnere746@email.it', '080345746');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000746'), 'Sede Principale', 'Piazza Garibaldi', '159', 'Lecce', 'LE', '73100', '080345746', 'ingegnere746@email.it', '47000000746', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Lecce', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '47000000747', 'geometra747@email.it', '080345747');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000747'), 'Sede Principale', 'Piazza Garibaldi', '179', 'Lecce', 'LE', '73100', '080345747', 'geometra747@email.it', '47000000747', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Lecce', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '47000000748', 'officinaauto748@email.it', '080345748');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000748'), 'Sede Principale', 'Via Mazzini', '138', 'Lecce', 'LE', '73100', '080345748', 'officinaauto748@email.it', '47000000748', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Lecce', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '47000000749', 'gommista749@email.it', '080345749');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000749'), 'Sede Principale', 'Corso Umberto', '133', 'Lecce', 'LE', '73100', '080345749', 'gommista749@email.it', '47000000749', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Taranto', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '47000000750', 'trattoria750@email.it', '080345750');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000750'), 'Sede Principale', 'Via Dante', '7', 'Taranto', 'TA', '74100', '080345750', 'trattoria750@email.it', '47000000750', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Taranto', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '47000000751', 'pizzeria751@email.it', '080345751');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000751'), 'Sede Principale', 'Via Mazzini', '104', 'Taranto', 'TA', '74100', '080345751', 'pizzeria751@email.it', '47000000751', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Taranto', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '47000000752', 'barpasticceria752@email.it', '080345752');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000752'), 'Sede Principale', 'Corso Vittorio Emanuele', '195', 'Taranto', 'TA', '74100', '080345752', 'barpasticceria752@email.it', '47000000752', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Taranto', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '47000000753', 'studiodentistico753@email.it', '080345753');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000753'), 'Sede Principale', 'Corso Vittorio Emanuele', '96', 'Taranto', 'TA', '74100', '080345753', 'studiodentistico753@email.it', '47000000753', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Taranto', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '47000000754', 'poliambulatorio754@email.it', '080345754');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000754'), 'Sede Principale', 'Piazza Garibaldi', '3', 'Taranto', 'TA', '74100', '080345754', 'poliambulatorio754@email.it', '47000000754', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Taranto', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '47000000755', 'farmacia755@email.it', '080345755');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000755'), 'Sede Principale', 'Via Dante', '126', 'Taranto', 'TA', '74100', '080345755', 'farmacia755@email.it', '47000000755', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Taranto', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '47000000756', 'avvocato756@email.it', '080345756');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000756'), 'Sede Principale', 'Piazza del Duomo', '84', 'Taranto', 'TA', '74100', '080345756', 'avvocato756@email.it', '47000000756', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Taranto', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '47000000757', 'studiocommercialisti757@email.it', '080345757');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000757'), 'Sede Principale', 'Via Roma', '33', 'Taranto', 'TA', '74100', '080345757', 'studiocommercialisti757@email.it', '47000000757', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Taranto', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '47000000758', 'notaio758@email.it', '080345758');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000758'), 'Sede Principale', 'Corso Vittorio Emanuele', '108', 'Taranto', 'TA', '74100', '080345758', 'notaio758@email.it', '47000000758', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Taranto', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '47000000759', 'salone759@email.it', '080345759');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000759'), 'Sede Principale', 'Via Mazzini', '130', 'Taranto', 'TA', '74100', '080345759', 'salone759@email.it', '47000000759', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Taranto', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '47000000760', 'centroestetico760@email.it', '080345760');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000760'), 'Sede Principale', 'Via Roma', '140', 'Taranto', 'TA', '74100', '080345760', 'centroestetico760@email.it', '47000000760', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Taranto', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '47000000761', 'idraulico761@email.it', '3331234761');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000761'), 'Sede Principale', 'Via Mazzini', '117', 'Taranto', 'TA', '74100', '3331234761', 'idraulico761@email.it', '47000000761', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Taranto', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '47000000762', 'elettricista762@email.it', '3331234762');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000762'), 'Sede Principale', 'Via Cavour', '143', 'Taranto', 'TA', '74100', '3331234762', 'elettricista762@email.it', '47000000762', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Taranto', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '47000000763', 'imbianchino763@email.it', '3331234763');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000763'), 'Sede Principale', 'Via Verdi', '6', 'Taranto', 'TA', '74100', '3331234763', 'imbianchino763@email.it', '47000000763', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Taranto', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '47000000764', 'fabbro764@email.it', '3331234764');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000764'), 'Sede Principale', 'Via Mazzini', '100', 'Taranto', 'TA', '74100', '3331234764', 'fabbro764@email.it', '47000000764', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Taranto', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '47000000765', 'falegname765@email.it', '3331234765');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000765'), 'Sede Principale', 'Via Verdi', '115', 'Taranto', 'TA', '74100', '3331234765', 'falegname765@email.it', '47000000765', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Taranto', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '47000000766', 'supermercato766@email.it', '080345766');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000766'), 'Sede Principale', 'Via Dante', '67', 'Taranto', 'TA', '74100', '080345766', 'supermercato766@email.it', '47000000766', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Taranto', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '47000000767', 'ferramenta767@email.it', '080345767');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000767'), 'Sede Principale', 'Piazza del Duomo', '95', 'Taranto', 'TA', '74100', '080345767', 'ferramenta767@email.it', '47000000767', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Taranto', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '47000000768', 'palestra768@email.it', '080345768');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000768'), 'Sede Principale', 'Via Verdi', '12', 'Taranto', 'TA', '74100', '080345768', 'palestra768@email.it', '47000000768', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Taranto', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '47000000769', 'panificio769@email.it', '080345769');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000769'), 'Sede Principale', 'Via Roma', '81', 'Taranto', 'TA', '74100', '080345769', 'panificio769@email.it', '47000000769', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Taranto', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '47000000770', 'gelateria770@email.it', '080345770');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000770'), 'Sede Principale', 'Corso Vittorio Emanuele', '44', 'Taranto', 'TA', '74100', '080345770', 'gelateria770@email.it', '47000000770', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Taranto', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '47000000771', 'veterinario771@email.it', '080345771');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000771'), 'Sede Principale', 'Corso Umberto', '197', 'Taranto', 'TA', '74100', '080345771', 'veterinario771@email.it', '47000000771', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Taranto', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '47000000772', 'macelleria772@email.it', '080345772');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000772'), 'Sede Principale', 'Via Mazzini', '154', 'Taranto', 'TA', '74100', '080345772', 'macelleria772@email.it', '47000000772', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Taranto', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '47000000773', 'pescheria773@email.it', '080345773');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000773'), 'Sede Principale', 'Via Mazzini', '21', 'Taranto', 'TA', '74100', '080345773', 'pescheria773@email.it', '47000000773', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Taranto', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '47000000774', 'libreria774@email.it', '080345774');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000774'), 'Sede Principale', 'Piazza del Duomo', '142', 'Taranto', 'TA', '74100', '080345774', 'libreria774@email.it', '47000000774', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Taranto', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '47000000775', 'architetto775@email.it', '080345775');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000775'), 'Sede Principale', 'Via Roma', '25', 'Taranto', 'TA', '74100', '080345775', 'architetto775@email.it', '47000000775', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Taranto', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '47000000776', 'studioingegneri776@email.it', '080345776');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000776'), 'Sede Principale', 'Piazza del Duomo', '158', 'Taranto', 'TA', '74100', '080345776', 'studioingegneri776@email.it', '47000000776', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Taranto', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '47000000777', 'geometra777@email.it', '080345777');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000777'), 'Sede Principale', 'Via Cavour', '40', 'Taranto', 'TA', '74100', '080345777', 'geometra777@email.it', '47000000777', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Taranto', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '47000000778', 'officinaauto778@email.it', '080345778');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000778'), 'Sede Principale', 'Via Roma', '124', 'Taranto', 'TA', '74100', '080345778', 'officinaauto778@email.it', '47000000778', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Taranto', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '47000000779', 'gommista779@email.it', '080345779');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000779'), 'Sede Principale', 'Via Verdi', '73', 'Taranto', 'TA', '74100', '080345779', 'gommista779@email.it', '47000000779', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Foggia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '47000000780', 'ristorante780@email.it', '080345780');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000780'), 'Sede Principale', 'Via Verdi', '191', 'Foggia', 'FG', '71100', '080345780', 'ristorante780@email.it', '47000000780', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Foggia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '47000000781', 'pizzeria781@email.it', '080345781');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000781'), 'Sede Principale', 'Corso Vittorio Emanuele', '20', 'Foggia', 'FG', '71100', '080345781', 'pizzeria781@email.it', '47000000781', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Foggia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '47000000782', 'barpasticceria782@email.it', '080345782');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000782'), 'Sede Principale', 'Corso Vittorio Emanuele', '26', 'Foggia', 'FG', '71100', '080345782', 'barpasticceria782@email.it', '47000000782', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Foggia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '47000000783', 'studiodentistico783@email.it', '080345783');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000783'), 'Sede Principale', 'Via Mazzini', '121', 'Foggia', 'FG', '71100', '080345783', 'studiodentistico783@email.it', '47000000783', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Foggia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '47000000784', 'studiomedico784@email.it', '080345784');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000784'), 'Sede Principale', 'Via Mazzini', '60', 'Foggia', 'FG', '71100', '080345784', 'studiomedico784@email.it', '47000000784', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Foggia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '47000000785', 'farmacia785@email.it', '080345785');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000785'), 'Sede Principale', 'Via Mazzini', '22', 'Foggia', 'FG', '71100', '080345785', 'farmacia785@email.it', '47000000785', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Foggia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '47000000786', 'studiolegale786@email.it', '080345786');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000786'), 'Sede Principale', 'Via Roma', '161', 'Foggia', 'FG', '71100', '080345786', 'studiolegale786@email.it', '47000000786', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Foggia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '47000000787', 'studiocommercialisti787@email.it', '080345787');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000787'), 'Sede Principale', 'Via Cavour', '188', 'Foggia', 'FG', '71100', '080345787', 'studiocommercialisti787@email.it', '47000000787', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Foggia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '47000000788', 'notaio788@email.it', '080345788');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000788'), 'Sede Principale', 'Via Roma', '66', 'Foggia', 'FG', '71100', '080345788', 'notaio788@email.it', '47000000788', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Foggia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '47000000789', 'parrucchiere789@email.it', '080345789');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000789'), 'Sede Principale', 'Via Roma', '47', 'Foggia', 'FG', '71100', '080345789', 'parrucchiere789@email.it', '47000000789', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Foggia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '47000000790', 'centroestetico790@email.it', '080345790');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000790'), 'Sede Principale', 'Via Verdi', '95', 'Foggia', 'FG', '71100', '080345790', 'centroestetico790@email.it', '47000000790', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Foggia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '47000000791', 'idraulico791@email.it', '3331234791');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000791'), 'Sede Principale', 'Corso Vittorio Emanuele', '22', 'Foggia', 'FG', '71100', '3331234791', 'idraulico791@email.it', '47000000791', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Foggia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '47000000792', 'elettricista792@email.it', '3331234792');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000792'), 'Sede Principale', 'Piazza Garibaldi', '197', 'Foggia', 'FG', '71100', '3331234792', 'elettricista792@email.it', '47000000792', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Foggia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '47000000793', 'imbianchino793@email.it', '3331234793');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000793'), 'Sede Principale', 'Corso Umberto', '108', 'Foggia', 'FG', '71100', '3331234793', 'imbianchino793@email.it', '47000000793', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Foggia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '47000000794', 'fabbro794@email.it', '3331234794');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000794'), 'Sede Principale', 'Corso Italia', '45', 'Foggia', 'FG', '71100', '3331234794', 'fabbro794@email.it', '47000000794', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Foggia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '47000000795', 'falegname795@email.it', '3331234795');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000795'), 'Sede Principale', 'Via Verdi', '45', 'Foggia', 'FG', '71100', '3331234795', 'falegname795@email.it', '47000000795', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Foggia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '47000000796', 'supermercato796@email.it', '080345796');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000796'), 'Sede Principale', 'Via Cavour', '2', 'Foggia', 'FG', '71100', '080345796', 'supermercato796@email.it', '47000000796', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Foggia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '47000000797', 'ferramenta797@email.it', '080345797');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000797'), 'Sede Principale', 'Corso Umberto', '156', 'Foggia', 'FG', '71100', '080345797', 'ferramenta797@email.it', '47000000797', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Foggia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '47000000798', 'palestra798@email.it', '080345798');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000798'), 'Sede Principale', 'Via Verdi', '100', 'Foggia', 'FG', '71100', '080345798', 'palestra798@email.it', '47000000798', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Foggia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '47000000799', 'panificio799@email.it', '080345799');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000799'), 'Sede Principale', 'Corso Umberto', '12', 'Foggia', 'FG', '71100', '080345799', 'panificio799@email.it', '47000000799', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Foggia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '47000000800', 'pasticceria800@email.it', '080345800');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000800'), 'Sede Principale', 'Corso Vittorio Emanuele', '82', 'Foggia', 'FG', '71100', '080345800', 'pasticceria800@email.it', '47000000800', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Foggia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '47000000801', 'veterinario801@email.it', '080345801');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000801'), 'Sede Principale', 'Piazza del Duomo', '175', 'Foggia', 'FG', '71100', '080345801', 'veterinario801@email.it', '47000000801', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Foggia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '47000000802', 'macelleria802@email.it', '080345802');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000802'), 'Sede Principale', 'Via Cavour', '169', 'Foggia', 'FG', '71100', '080345802', 'macelleria802@email.it', '47000000802', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Foggia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '47000000803', 'pescheria803@email.it', '080345803');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000803'), 'Sede Principale', 'Corso Italia', '159', 'Foggia', 'FG', '71100', '080345803', 'pescheria803@email.it', '47000000803', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Foggia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '47000000804', 'libreria804@email.it', '080345804');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000804'), 'Sede Principale', 'Via Dante', '16', 'Foggia', 'FG', '71100', '080345804', 'libreria804@email.it', '47000000804', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Foggia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '47000000805', 'studioarchitetti805@email.it', '080345805');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000805'), 'Sede Principale', 'Piazza del Duomo', '82', 'Foggia', 'FG', '71100', '080345805', 'studioarchitetti805@email.it', '47000000805', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Foggia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '47000000806', 'studioingegneri806@email.it', '080345806');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000806'), 'Sede Principale', 'Via Verdi', '116', 'Foggia', 'FG', '71100', '080345806', 'studioingegneri806@email.it', '47000000806', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Foggia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '47000000807', 'geometra807@email.it', '080345807');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000807'), 'Sede Principale', 'Via Verdi', '65', 'Foggia', 'FG', '71100', '080345807', 'geometra807@email.it', '47000000807', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Foggia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '47000000808', 'officinaauto808@email.it', '080345808');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000808'), 'Sede Principale', 'Piazza del Duomo', '25', 'Foggia', 'FG', '71100', '080345808', 'officinaauto808@email.it', '47000000808', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Foggia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '47000000809', 'gommista809@email.it', '080345809');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000809'), 'Sede Principale', 'Via Cavour', '180', 'Foggia', 'FG', '71100', '080345809', 'gommista809@email.it', '47000000809', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Trattoria Brindisi', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '47000000810', 'trattoria810@email.it', '080345810');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000810'), 'Sede Principale', 'Piazza Garibaldi', '9', 'Brindisi', 'BR', '72100', '080345810', 'trattoria810@email.it', '47000000810', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Brindisi', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '47000000811', 'pizzeria811@email.it', '080345811');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000811'), 'Sede Principale', 'Via Roma', '27', 'Brindisi', 'BR', '72100', '080345811', 'pizzeria811@email.it', '47000000811', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Brindisi', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '47000000812', 'barpasticceria812@email.it', '080345812');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000812'), 'Sede Principale', 'Via Cavour', '160', 'Brindisi', 'BR', '72100', '080345812', 'barpasticceria812@email.it', '47000000812', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Brindisi', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '47000000813', 'studiodentistico813@email.it', '080345813');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000813'), 'Sede Principale', 'Via Cavour', '166', 'Brindisi', 'BR', '72100', '080345813', 'studiodentistico813@email.it', '47000000813', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Brindisi', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '47000000814', 'studiomedico814@email.it', '080345814');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000814'), 'Sede Principale', 'Corso Vittorio Emanuele', '40', 'Brindisi', 'BR', '72100', '080345814', 'studiomedico814@email.it', '47000000814', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Brindisi', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '47000000815', 'farmacia815@email.it', '080345815');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000815'), 'Sede Principale', 'Corso Vittorio Emanuele', '166', 'Brindisi', 'BR', '72100', '080345815', 'farmacia815@email.it', '47000000815', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Brindisi', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '47000000816', 'avvocato816@email.it', '080345816');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000816'), 'Sede Principale', 'Piazza Garibaldi', '100', 'Brindisi', 'BR', '72100', '080345816', 'avvocato816@email.it', '47000000816', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Brindisi', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '47000000817', 'studiocommercialisti817@email.it', '080345817');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000817'), 'Sede Principale', 'Via Roma', '121', 'Brindisi', 'BR', '72100', '080345817', 'studiocommercialisti817@email.it', '47000000817', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Brindisi', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '47000000818', 'notaio818@email.it', '080345818');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000818'), 'Sede Principale', 'Piazza del Duomo', '15', 'Brindisi', 'BR', '72100', '080345818', 'notaio818@email.it', '47000000818', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Brindisi', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '47000000819', 'parrucchiere819@email.it', '080345819');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000819'), 'Sede Principale', 'Corso Vittorio Emanuele', '59', 'Brindisi', 'BR', '72100', '080345819', 'parrucchiere819@email.it', '47000000819', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Brindisi', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '47000000820', 'centroestetico820@email.it', '080345820');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000820'), 'Sede Principale', 'Via Verdi', '171', 'Brindisi', 'BR', '72100', '080345820', 'centroestetico820@email.it', '47000000820', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Brindisi', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '47000000821', 'idraulico821@email.it', '3331234821');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000821'), 'Sede Principale', 'Via Verdi', '133', 'Brindisi', 'BR', '72100', '3331234821', 'idraulico821@email.it', '47000000821', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Brindisi', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '47000000822', 'elettricista822@email.it', '3331234822');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000822'), 'Sede Principale', 'Via Dante', '111', 'Brindisi', 'BR', '72100', '3331234822', 'elettricista822@email.it', '47000000822', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Brindisi', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '47000000823', 'imbianchino823@email.it', '3331234823');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000823'), 'Sede Principale', 'Via Cavour', '97', 'Brindisi', 'BR', '72100', '3331234823', 'imbianchino823@email.it', '47000000823', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Brindisi', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '47000000824', 'fabbro824@email.it', '3331234824');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000824'), 'Sede Principale', 'Via Cavour', '154', 'Brindisi', 'BR', '72100', '3331234824', 'fabbro824@email.it', '47000000824', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Brindisi', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '47000000825', 'falegname825@email.it', '3331234825');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000825'), 'Sede Principale', 'Via Cavour', '171', 'Brindisi', 'BR', '72100', '3331234825', 'falegname825@email.it', '47000000825', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Brindisi', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '47000000826', 'supermercato826@email.it', '080345826');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000826'), 'Sede Principale', 'Via Verdi', '161', 'Brindisi', 'BR', '72100', '080345826', 'supermercato826@email.it', '47000000826', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Brindisi', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '47000000827', 'ferramenta827@email.it', '080345827');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000827'), 'Sede Principale', 'Via Mazzini', '119', 'Brindisi', 'BR', '72100', '080345827', 'ferramenta827@email.it', '47000000827', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Brindisi', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '47000000828', 'palestra828@email.it', '080345828');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000828'), 'Sede Principale', 'Via Verdi', '137', 'Brindisi', 'BR', '72100', '080345828', 'palestra828@email.it', '47000000828', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Brindisi', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '47000000829', 'panificio829@email.it', '080345829');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000829'), 'Sede Principale', 'Via Dante', '98', 'Brindisi', 'BR', '72100', '080345829', 'panificio829@email.it', '47000000829', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Brindisi', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '47000000830', 'gelateria830@email.it', '080345830');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000830'), 'Sede Principale', 'Piazza del Duomo', '183', 'Brindisi', 'BR', '72100', '080345830', 'gelateria830@email.it', '47000000830', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Brindisi', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '47000000831', 'veterinario831@email.it', '080345831');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000831'), 'Sede Principale', 'Via Dante', '134', 'Brindisi', 'BR', '72100', '080345831', 'veterinario831@email.it', '47000000831', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Brindisi', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '47000000832', 'macelleria832@email.it', '080345832');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000832'), 'Sede Principale', 'Via Verdi', '6', 'Brindisi', 'BR', '72100', '080345832', 'macelleria832@email.it', '47000000832', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Brindisi', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '47000000833', 'pescheria833@email.it', '080345833');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000833'), 'Sede Principale', 'Piazza Garibaldi', '9', 'Brindisi', 'BR', '72100', '080345833', 'pescheria833@email.it', '47000000833', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Brindisi', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '47000000834', 'libreria834@email.it', '080345834');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000834'), 'Sede Principale', 'Via Verdi', '191', 'Brindisi', 'BR', '72100', '080345834', 'libreria834@email.it', '47000000834', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Brindisi', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '47000000835', 'studioarchitetti835@email.it', '080345835');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000835'), 'Sede Principale', 'Via Dante', '190', 'Brindisi', 'BR', '72100', '080345835', 'studioarchitetti835@email.it', '47000000835', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Brindisi', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '47000000836', 'ingegnere836@email.it', '080345836');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000836'), 'Sede Principale', 'Corso Umberto', '192', 'Brindisi', 'BR', '72100', '080345836', 'ingegnere836@email.it', '47000000836', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Brindisi', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '47000000837', 'geometra837@email.it', '080345837');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000837'), 'Sede Principale', 'Via Cavour', '121', 'Brindisi', 'BR', '72100', '080345837', 'geometra837@email.it', '47000000837', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Brindisi', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '47000000838', 'officinaauto838@email.it', '080345838');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000838'), 'Sede Principale', 'Piazza del Duomo', '16', 'Brindisi', 'BR', '72100', '080345838', 'officinaauto838@email.it', '47000000838', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Brindisi', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '47000000839', 'gommista839@email.it', '080345839');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '47000000839'), 'Sede Principale', 'Via Mazzini', '163', 'Brindisi', 'BR', '72100', '080345839', 'gommista839@email.it', '47000000839', true);

-- SARDEGNA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Cagliari', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '48000000840', 'osteria840@email.it', '070345840');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000840'), 'Sede Principale', 'Via Mazzini', '171', 'Cagliari', 'CA', '09100', '070345840', 'osteria840@email.it', '48000000840', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Cagliari', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '48000000841', 'pizzeria841@email.it', '070345841');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000841'), 'Sede Principale', 'Corso Vittorio Emanuele', '97', 'Cagliari', 'CA', '09100', '070345841', 'pizzeria841@email.it', '48000000841', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Cagliari', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '48000000842', 'bar842@email.it', '070345842');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000842'), 'Sede Principale', 'Via Dante', '51', 'Cagliari', 'CA', '09100', '070345842', 'bar842@email.it', '48000000842', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Cagliari', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '48000000843', 'studiodentistico843@email.it', '070345843');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000843'), 'Sede Principale', 'Corso Italia', '59', 'Cagliari', 'CA', '09100', '070345843', 'studiodentistico843@email.it', '48000000843', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Cagliari', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '48000000844', 'poliambulatorio844@email.it', '070345844');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000844'), 'Sede Principale', 'Via Verdi', '182', 'Cagliari', 'CA', '09100', '070345844', 'poliambulatorio844@email.it', '48000000844', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Cagliari', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '48000000845', 'farmacia845@email.it', '070345845');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000845'), 'Sede Principale', 'Via Mazzini', '123', 'Cagliari', 'CA', '09100', '070345845', 'farmacia845@email.it', '48000000845', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Cagliari', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '48000000846', 'studiolegale846@email.it', '070345846');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000846'), 'Sede Principale', 'Corso Italia', '73', 'Cagliari', 'CA', '09100', '070345846', 'studiolegale846@email.it', '48000000846', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Cagliari', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '48000000847', 'commercialista847@email.it', '070345847');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000847'), 'Sede Principale', 'Via Roma', '16', 'Cagliari', 'CA', '09100', '070345847', 'commercialista847@email.it', '48000000847', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Cagliari', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '48000000848', 'notaio848@email.it', '070345848');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000848'), 'Sede Principale', 'Piazza Garibaldi', '24', 'Cagliari', 'CA', '09100', '070345848', 'notaio848@email.it', '48000000848', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Cagliari', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '48000000849', 'parrucchiere849@email.it', '070345849');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000849'), 'Sede Principale', 'Piazza del Duomo', '156', 'Cagliari', 'CA', '09100', '070345849', 'parrucchiere849@email.it', '48000000849', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Cagliari', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '48000000850', 'centroestetico850@email.it', '070345850');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000850'), 'Sede Principale', 'Via Dante', '144', 'Cagliari', 'CA', '09100', '070345850', 'centroestetico850@email.it', '48000000850', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Cagliari', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '48000000851', 'idraulico851@email.it', '3331234851');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000851'), 'Sede Principale', 'Corso Italia', '52', 'Cagliari', 'CA', '09100', '3331234851', 'idraulico851@email.it', '48000000851', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Cagliari', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '48000000852', 'elettricista852@email.it', '3331234852');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000852'), 'Sede Principale', 'Via Verdi', '149', 'Cagliari', 'CA', '09100', '3331234852', 'elettricista852@email.it', '48000000852', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Cagliari', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '48000000853', 'imbianchino853@email.it', '3331234853');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000853'), 'Sede Principale', 'Via Cavour', '175', 'Cagliari', 'CA', '09100', '3331234853', 'imbianchino853@email.it', '48000000853', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Cagliari', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '48000000854', 'fabbro854@email.it', '3331234854');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000854'), 'Sede Principale', 'Via Mazzini', '119', 'Cagliari', 'CA', '09100', '3331234854', 'fabbro854@email.it', '48000000854', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Cagliari', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '48000000855', 'falegname855@email.it', '3331234855');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000855'), 'Sede Principale', 'Via Verdi', '31', 'Cagliari', 'CA', '09100', '3331234855', 'falegname855@email.it', '48000000855', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Cagliari', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '48000000856', 'supermercato856@email.it', '070345856');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000856'), 'Sede Principale', 'Corso Umberto', '13', 'Cagliari', 'CA', '09100', '070345856', 'supermercato856@email.it', '48000000856', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Cagliari', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '48000000857', 'ferramenta857@email.it', '070345857');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000857'), 'Sede Principale', 'Via Mazzini', '62', 'Cagliari', 'CA', '09100', '070345857', 'ferramenta857@email.it', '48000000857', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Cagliari', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '48000000858', 'palestra858@email.it', '070345858');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000858'), 'Sede Principale', 'Via Dante', '57', 'Cagliari', 'CA', '09100', '070345858', 'palestra858@email.it', '48000000858', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Cagliari', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '48000000859', 'panificio859@email.it', '070345859');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000859'), 'Sede Principale', 'Via Roma', '108', 'Cagliari', 'CA', '09100', '070345859', 'panificio859@email.it', '48000000859', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Cagliari', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '48000000860', 'gelateria860@email.it', '070345860');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000860'), 'Sede Principale', 'Via Cavour', '112', 'Cagliari', 'CA', '09100', '070345860', 'gelateria860@email.it', '48000000860', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Cagliari', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '48000000861', 'veterinario861@email.it', '070345861');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000861'), 'Sede Principale', 'Via Dante', '133', 'Cagliari', 'CA', '09100', '070345861', 'veterinario861@email.it', '48000000861', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Cagliari', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '48000000862', 'macelleria862@email.it', '070345862');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000862'), 'Sede Principale', 'Via Roma', '50', 'Cagliari', 'CA', '09100', '070345862', 'macelleria862@email.it', '48000000862', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Cagliari', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '48000000863', 'pescheria863@email.it', '070345863');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000863'), 'Sede Principale', 'Via Verdi', '200', 'Cagliari', 'CA', '09100', '070345863', 'pescheria863@email.it', '48000000863', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Cagliari', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '48000000864', 'libreria864@email.it', '070345864');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000864'), 'Sede Principale', 'Corso Vittorio Emanuele', '77', 'Cagliari', 'CA', '09100', '070345864', 'libreria864@email.it', '48000000864', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Cagliari', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '48000000865', 'architetto865@email.it', '070345865');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000865'), 'Sede Principale', 'Corso Vittorio Emanuele', '129', 'Cagliari', 'CA', '09100', '070345865', 'architetto865@email.it', '48000000865', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Cagliari', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '48000000866', 'ingegnere866@email.it', '070345866');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000866'), 'Sede Principale', 'Via Roma', '5', 'Cagliari', 'CA', '09100', '070345866', 'ingegnere866@email.it', '48000000866', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Cagliari', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '48000000867', 'geometra867@email.it', '070345867');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000867'), 'Sede Principale', 'Via Cavour', '79', 'Cagliari', 'CA', '09100', '070345867', 'geometra867@email.it', '48000000867', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Cagliari', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '48000000868', 'officinaauto868@email.it', '070345868');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000868'), 'Sede Principale', 'Corso Umberto', '52', 'Cagliari', 'CA', '09100', '070345868', 'officinaauto868@email.it', '48000000868', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Cagliari', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '48000000869', 'gommista869@email.it', '070345869');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000869'), 'Sede Principale', 'Via Roma', '91', 'Cagliari', 'CA', '09100', '070345869', 'gommista869@email.it', '48000000869', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Sassari', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '48000000870', 'ristorante870@email.it', '070345870');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000870'), 'Sede Principale', 'Corso Umberto', '111', 'Sassari', 'SS', '07100', '070345870', 'ristorante870@email.it', '48000000870', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Sassari', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '48000000871', 'pizzeria871@email.it', '070345871');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000871'), 'Sede Principale', 'Via Roma', '182', 'Sassari', 'SS', '07100', '070345871', 'pizzeria871@email.it', '48000000871', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Sassari', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '48000000872', 'bar872@email.it', '070345872');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000872'), 'Sede Principale', 'Piazza Garibaldi', '33', 'Sassari', 'SS', '07100', '070345872', 'bar872@email.it', '48000000872', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Sassari', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '48000000873', 'studiodentistico873@email.it', '070345873');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000873'), 'Sede Principale', 'Via Mazzini', '38', 'Sassari', 'SS', '07100', '070345873', 'studiodentistico873@email.it', '48000000873', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Sassari', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '48000000874', 'studiomedico874@email.it', '070345874');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000874'), 'Sede Principale', 'Via Verdi', '117', 'Sassari', 'SS', '07100', '070345874', 'studiomedico874@email.it', '48000000874', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Sassari', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '48000000875', 'farmacia875@email.it', '070345875');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000875'), 'Sede Principale', 'Piazza Garibaldi', '125', 'Sassari', 'SS', '07100', '070345875', 'farmacia875@email.it', '48000000875', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Sassari', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '48000000876', 'studiolegale876@email.it', '070345876');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000876'), 'Sede Principale', 'Corso Vittorio Emanuele', '142', 'Sassari', 'SS', '07100', '070345876', 'studiolegale876@email.it', '48000000876', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Sassari', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '48000000877', 'studiocommercialisti877@email.it', '070345877');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000877'), 'Sede Principale', 'Corso Umberto', '59', 'Sassari', 'SS', '07100', '070345877', 'studiocommercialisti877@email.it', '48000000877', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Sassari', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '48000000878', 'notaio878@email.it', '070345878');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000878'), 'Sede Principale', 'Piazza del Duomo', '177', 'Sassari', 'SS', '07100', '070345878', 'notaio878@email.it', '48000000878', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Sassari', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '48000000879', 'parrucchiere879@email.it', '070345879');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000879'), 'Sede Principale', 'Via Roma', '75', 'Sassari', 'SS', '07100', '070345879', 'parrucchiere879@email.it', '48000000879', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Sassari', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '48000000880', 'centroestetico880@email.it', '070345880');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000880'), 'Sede Principale', 'Via Dante', '71', 'Sassari', 'SS', '07100', '070345880', 'centroestetico880@email.it', '48000000880', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Sassari', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '48000000881', 'idraulico881@email.it', '3331234881');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000881'), 'Sede Principale', 'Via Mazzini', '90', 'Sassari', 'SS', '07100', '3331234881', 'idraulico881@email.it', '48000000881', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Sassari', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '48000000882', 'elettricista882@email.it', '3331234882');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000882'), 'Sede Principale', 'Corso Vittorio Emanuele', '53', 'Sassari', 'SS', '07100', '3331234882', 'elettricista882@email.it', '48000000882', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Sassari', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '48000000883', 'imbianchino883@email.it', '3331234883');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000883'), 'Sede Principale', 'Via Verdi', '17', 'Sassari', 'SS', '07100', '3331234883', 'imbianchino883@email.it', '48000000883', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Sassari', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '48000000884', 'fabbro884@email.it', '3331234884');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000884'), 'Sede Principale', 'Corso Italia', '86', 'Sassari', 'SS', '07100', '3331234884', 'fabbro884@email.it', '48000000884', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Sassari', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '48000000885', 'falegname885@email.it', '3331234885');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000885'), 'Sede Principale', 'Via Dante', '4', 'Sassari', 'SS', '07100', '3331234885', 'falegname885@email.it', '48000000885', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Sassari', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '48000000886', 'supermercato886@email.it', '070345886');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000886'), 'Sede Principale', 'Via Dante', '4', 'Sassari', 'SS', '07100', '070345886', 'supermercato886@email.it', '48000000886', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Sassari', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '48000000887', 'ferramenta887@email.it', '070345887');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000887'), 'Sede Principale', 'Via Cavour', '165', 'Sassari', 'SS', '07100', '070345887', 'ferramenta887@email.it', '48000000887', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Sassari', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '48000000888', 'palestra888@email.it', '070345888');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000888'), 'Sede Principale', 'Via Verdi', '163', 'Sassari', 'SS', '07100', '070345888', 'palestra888@email.it', '48000000888', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Sassari', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '48000000889', 'panificio889@email.it', '070345889');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000889'), 'Sede Principale', 'Corso Italia', '15', 'Sassari', 'SS', '07100', '070345889', 'panificio889@email.it', '48000000889', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Sassari', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '48000000890', 'pasticceria890@email.it', '070345890');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000890'), 'Sede Principale', 'Corso Italia', '48', 'Sassari', 'SS', '07100', '070345890', 'pasticceria890@email.it', '48000000890', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Sassari', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '48000000891', 'veterinario891@email.it', '070345891');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000891'), 'Sede Principale', 'Via Mazzini', '5', 'Sassari', 'SS', '07100', '070345891', 'veterinario891@email.it', '48000000891', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Sassari', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '48000000892', 'macelleria892@email.it', '070345892');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000892'), 'Sede Principale', 'Via Cavour', '107', 'Sassari', 'SS', '07100', '070345892', 'macelleria892@email.it', '48000000892', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Sassari', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '48000000893', 'pescheria893@email.it', '070345893');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000893'), 'Sede Principale', 'Corso Vittorio Emanuele', '62', 'Sassari', 'SS', '07100', '070345893', 'pescheria893@email.it', '48000000893', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Sassari', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '48000000894', 'libreria894@email.it', '070345894');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000894'), 'Sede Principale', 'Corso Umberto', '7', 'Sassari', 'SS', '07100', '070345894', 'libreria894@email.it', '48000000894', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Sassari', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '48000000895', 'architetto895@email.it', '070345895');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000895'), 'Sede Principale', 'Via Verdi', '7', 'Sassari', 'SS', '07100', '070345895', 'architetto895@email.it', '48000000895', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Sassari', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '48000000896', 'studioingegneri896@email.it', '070345896');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000896'), 'Sede Principale', 'Via Roma', '172', 'Sassari', 'SS', '07100', '070345896', 'studioingegneri896@email.it', '48000000896', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Sassari', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '48000000897', 'geometra897@email.it', '070345897');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000897'), 'Sede Principale', 'Via Mazzini', '137', 'Sassari', 'SS', '07100', '070345897', 'geometra897@email.it', '48000000897', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Sassari', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '48000000898', 'officinaauto898@email.it', '070345898');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000898'), 'Sede Principale', 'Corso Umberto', '27', 'Sassari', 'SS', '07100', '070345898', 'officinaauto898@email.it', '48000000898', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Sassari', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '48000000899', 'gommista899@email.it', '070345899');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000899'), 'Sede Principale', 'Piazza del Duomo', '38', 'Sassari', 'SS', '07100', '070345899', 'gommista899@email.it', '48000000899', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Olbia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '48000000900', 'ristorante900@email.it', '070345900');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000900'), 'Sede Principale', 'Corso Vittorio Emanuele', '118', 'Olbia', 'SS', '07026', '070345900', 'ristorante900@email.it', '48000000900', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Olbia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '48000000901', 'pizzeria901@email.it', '070345901');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000901'), 'Sede Principale', 'Corso Umberto', '62', 'Olbia', 'SS', '07026', '070345901', 'pizzeria901@email.it', '48000000901', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Olbia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '48000000902', 'bar902@email.it', '070345902');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000902'), 'Sede Principale', 'Via Dante', '199', 'Olbia', 'SS', '07026', '070345902', 'bar902@email.it', '48000000902', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Olbia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '48000000903', 'studiodentistico903@email.it', '070345903');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000903'), 'Sede Principale', 'Via Cavour', '28', 'Olbia', 'SS', '07026', '070345903', 'studiodentistico903@email.it', '48000000903', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Olbia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '48000000904', 'studiomedico904@email.it', '070345904');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000904'), 'Sede Principale', 'Corso Italia', '146', 'Olbia', 'SS', '07026', '070345904', 'studiomedico904@email.it', '48000000904', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Olbia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '48000000905', 'farmacia905@email.it', '070345905');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000905'), 'Sede Principale', 'Via Mazzini', '76', 'Olbia', 'SS', '07026', '070345905', 'farmacia905@email.it', '48000000905', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Olbia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '48000000906', 'avvocato906@email.it', '070345906');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000906'), 'Sede Principale', 'Piazza Garibaldi', '51', 'Olbia', 'SS', '07026', '070345906', 'avvocato906@email.it', '48000000906', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Olbia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '48000000907', 'studiocommercialisti907@email.it', '070345907');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000907'), 'Sede Principale', 'Via Verdi', '176', 'Olbia', 'SS', '07026', '070345907', 'studiocommercialisti907@email.it', '48000000907', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Olbia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '48000000908', 'notaio908@email.it', '070345908');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000908'), 'Sede Principale', 'Via Dante', '18', 'Olbia', 'SS', '07026', '070345908', 'notaio908@email.it', '48000000908', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Olbia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '48000000909', 'parrucchiere909@email.it', '070345909');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000909'), 'Sede Principale', 'Corso Vittorio Emanuele', '119', 'Olbia', 'SS', '07026', '070345909', 'parrucchiere909@email.it', '48000000909', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Olbia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '48000000910', 'centroestetico910@email.it', '070345910');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000910'), 'Sede Principale', 'Piazza del Duomo', '34', 'Olbia', 'SS', '07026', '070345910', 'centroestetico910@email.it', '48000000910', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Olbia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '48000000911', 'idraulico911@email.it', '3331234911');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000911'), 'Sede Principale', 'Via Roma', '113', 'Olbia', 'SS', '07026', '3331234911', 'idraulico911@email.it', '48000000911', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Olbia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '48000000912', 'elettricista912@email.it', '3331234912');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000912'), 'Sede Principale', 'Piazza del Duomo', '83', 'Olbia', 'SS', '07026', '3331234912', 'elettricista912@email.it', '48000000912', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Olbia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '48000000913', 'imbianchino913@email.it', '3331234913');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000913'), 'Sede Principale', 'Via Verdi', '184', 'Olbia', 'SS', '07026', '3331234913', 'imbianchino913@email.it', '48000000913', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Olbia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '48000000914', 'fabbro914@email.it', '3331234914');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000914'), 'Sede Principale', 'Via Mazzini', '174', 'Olbia', 'SS', '07026', '3331234914', 'fabbro914@email.it', '48000000914', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Olbia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '48000000915', 'falegname915@email.it', '3331234915');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000915'), 'Sede Principale', 'Via Dante', '63', 'Olbia', 'SS', '07026', '3331234915', 'falegname915@email.it', '48000000915', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Olbia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '48000000916', 'supermercato916@email.it', '070345916');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000916'), 'Sede Principale', 'Via Cavour', '19', 'Olbia', 'SS', '07026', '070345916', 'supermercato916@email.it', '48000000916', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Olbia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '48000000917', 'ferramenta917@email.it', '070345917');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000917'), 'Sede Principale', 'Corso Italia', '15', 'Olbia', 'SS', '07026', '070345917', 'ferramenta917@email.it', '48000000917', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Olbia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '48000000918', 'palestra918@email.it', '070345918');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000918'), 'Sede Principale', 'Corso Vittorio Emanuele', '45', 'Olbia', 'SS', '07026', '070345918', 'palestra918@email.it', '48000000918', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Olbia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '48000000919', 'panificio919@email.it', '070345919');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000919'), 'Sede Principale', 'Corso Italia', '137', 'Olbia', 'SS', '07026', '070345919', 'panificio919@email.it', '48000000919', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Olbia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '48000000920', 'gelateria920@email.it', '070345920');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000920'), 'Sede Principale', 'Via Mazzini', '135', 'Olbia', 'SS', '07026', '070345920', 'gelateria920@email.it', '48000000920', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Olbia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '48000000921', 'veterinario921@email.it', '070345921');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000921'), 'Sede Principale', 'Corso Umberto', '74', 'Olbia', 'SS', '07026', '070345921', 'veterinario921@email.it', '48000000921', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Olbia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '48000000922', 'macelleria922@email.it', '070345922');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000922'), 'Sede Principale', 'Via Dante', '55', 'Olbia', 'SS', '07026', '070345922', 'macelleria922@email.it', '48000000922', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Olbia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '48000000923', 'pescheria923@email.it', '070345923');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000923'), 'Sede Principale', 'Corso Umberto', '61', 'Olbia', 'SS', '07026', '070345923', 'pescheria923@email.it', '48000000923', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Olbia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '48000000924', 'libreria924@email.it', '070345924');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000924'), 'Sede Principale', 'Via Dante', '31', 'Olbia', 'SS', '07026', '070345924', 'libreria924@email.it', '48000000924', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Olbia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '48000000925', 'studioarchitetti925@email.it', '070345925');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000925'), 'Sede Principale', 'Piazza del Duomo', '37', 'Olbia', 'SS', '07026', '070345925', 'studioarchitetti925@email.it', '48000000925', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Olbia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '48000000926', 'studioingegneri926@email.it', '070345926');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000926'), 'Sede Principale', 'Via Dante', '35', 'Olbia', 'SS', '07026', '070345926', 'studioingegneri926@email.it', '48000000926', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Olbia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '48000000927', 'geometra927@email.it', '070345927');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000927'), 'Sede Principale', 'Via Mazzini', '154', 'Olbia', 'SS', '07026', '070345927', 'geometra927@email.it', '48000000927', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Olbia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '48000000928', 'officinaauto928@email.it', '070345928');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000928'), 'Sede Principale', 'Piazza del Duomo', '88', 'Olbia', 'SS', '07026', '070345928', 'officinaauto928@email.it', '48000000928', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Olbia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '48000000929', 'gommista929@email.it', '070345929');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000929'), 'Sede Principale', 'Corso Umberto', '161', 'Olbia', 'SS', '07026', '070345929', 'gommista929@email.it', '48000000929', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Nuoro', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '48000000930', 'osteria930@email.it', '070345930');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000930'), 'Sede Principale', 'Corso Italia', '3', 'Nuoro', 'NU', '08100', '070345930', 'osteria930@email.it', '48000000930', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Nuoro', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '48000000931', 'pizzeria931@email.it', '070345931');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000931'), 'Sede Principale', 'Piazza del Duomo', '88', 'Nuoro', 'NU', '08100', '070345931', 'pizzeria931@email.it', '48000000931', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Nuoro', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '48000000932', 'bar932@email.it', '070345932');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000932'), 'Sede Principale', 'Via Roma', '16', 'Nuoro', 'NU', '08100', '070345932', 'bar932@email.it', '48000000932', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Nuoro', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '48000000933', 'studiodentistico933@email.it', '070345933');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000933'), 'Sede Principale', 'Corso Italia', '114', 'Nuoro', 'NU', '08100', '070345933', 'studiodentistico933@email.it', '48000000933', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Nuoro', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '48000000934', 'studiomedico934@email.it', '070345934');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000934'), 'Sede Principale', 'Via Dante', '113', 'Nuoro', 'NU', '08100', '070345934', 'studiomedico934@email.it', '48000000934', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Nuoro', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '48000000935', 'farmacia935@email.it', '070345935');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000935'), 'Sede Principale', 'Via Dante', '59', 'Nuoro', 'NU', '08100', '070345935', 'farmacia935@email.it', '48000000935', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Nuoro', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '48000000936', 'avvocato936@email.it', '070345936');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000936'), 'Sede Principale', 'Via Roma', '67', 'Nuoro', 'NU', '08100', '070345936', 'avvocato936@email.it', '48000000936', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Nuoro', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '48000000937', 'commercialista937@email.it', '070345937');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000937'), 'Sede Principale', 'Via Mazzini', '141', 'Nuoro', 'NU', '08100', '070345937', 'commercialista937@email.it', '48000000937', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Nuoro', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '48000000938', 'notaio938@email.it', '070345938');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000938'), 'Sede Principale', 'Via Dante', '56', 'Nuoro', 'NU', '08100', '070345938', 'notaio938@email.it', '48000000938', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Nuoro', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '48000000939', 'salone939@email.it', '070345939');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000939'), 'Sede Principale', 'Corso Italia', '168', 'Nuoro', 'NU', '08100', '070345939', 'salone939@email.it', '48000000939', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Nuoro', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '48000000940', 'centroestetico940@email.it', '070345940');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000940'), 'Sede Principale', 'Via Verdi', '166', 'Nuoro', 'NU', '08100', '070345940', 'centroestetico940@email.it', '48000000940', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Nuoro', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '48000000941', 'idraulico941@email.it', '3331234941');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000941'), 'Sede Principale', 'Piazza Garibaldi', '25', 'Nuoro', 'NU', '08100', '3331234941', 'idraulico941@email.it', '48000000941', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Nuoro', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '48000000942', 'elettricista942@email.it', '3331234942');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000942'), 'Sede Principale', 'Piazza Garibaldi', '155', 'Nuoro', 'NU', '08100', '3331234942', 'elettricista942@email.it', '48000000942', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Nuoro', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '48000000943', 'imbianchino943@email.it', '3331234943');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000943'), 'Sede Principale', 'Corso Italia', '126', 'Nuoro', 'NU', '08100', '3331234943', 'imbianchino943@email.it', '48000000943', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Nuoro', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '48000000944', 'fabbro944@email.it', '3331234944');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000944'), 'Sede Principale', 'Via Mazzini', '144', 'Nuoro', 'NU', '08100', '3331234944', 'fabbro944@email.it', '48000000944', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Nuoro', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '48000000945', 'falegname945@email.it', '3331234945');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000945'), 'Sede Principale', 'Corso Vittorio Emanuele', '135', 'Nuoro', 'NU', '08100', '3331234945', 'falegname945@email.it', '48000000945', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Nuoro', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '48000000946', 'supermercato946@email.it', '070345946');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000946'), 'Sede Principale', 'Via Mazzini', '158', 'Nuoro', 'NU', '08100', '070345946', 'supermercato946@email.it', '48000000946', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Nuoro', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '48000000947', 'ferramenta947@email.it', '070345947');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000947'), 'Sede Principale', 'Via Roma', '141', 'Nuoro', 'NU', '08100', '070345947', 'ferramenta947@email.it', '48000000947', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Nuoro', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '48000000948', 'palestra948@email.it', '070345948');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000948'), 'Sede Principale', 'Corso Italia', '125', 'Nuoro', 'NU', '08100', '070345948', 'palestra948@email.it', '48000000948', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Nuoro', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '48000000949', 'panificio949@email.it', '070345949');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000949'), 'Sede Principale', 'Piazza Garibaldi', '12', 'Nuoro', 'NU', '08100', '070345949', 'panificio949@email.it', '48000000949', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Nuoro', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '48000000950', 'pasticceria950@email.it', '070345950');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000950'), 'Sede Principale', 'Via Roma', '15', 'Nuoro', 'NU', '08100', '070345950', 'pasticceria950@email.it', '48000000950', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Nuoro', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '48000000951', 'veterinario951@email.it', '070345951');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000951'), 'Sede Principale', 'Via Verdi', '88', 'Nuoro', 'NU', '08100', '070345951', 'veterinario951@email.it', '48000000951', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Nuoro', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '48000000952', 'macelleria952@email.it', '070345952');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000952'), 'Sede Principale', 'Via Roma', '39', 'Nuoro', 'NU', '08100', '070345952', 'macelleria952@email.it', '48000000952', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Nuoro', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '48000000953', 'pescheria953@email.it', '070345953');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000953'), 'Sede Principale', 'Piazza Garibaldi', '143', 'Nuoro', 'NU', '08100', '070345953', 'pescheria953@email.it', '48000000953', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Nuoro', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '48000000954', 'libreria954@email.it', '070345954');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000954'), 'Sede Principale', 'Via Cavour', '186', 'Nuoro', 'NU', '08100', '070345954', 'libreria954@email.it', '48000000954', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Nuoro', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '48000000955', 'architetto955@email.it', '070345955');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000955'), 'Sede Principale', 'Via Roma', '172', 'Nuoro', 'NU', '08100', '070345955', 'architetto955@email.it', '48000000955', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Nuoro', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '48000000956', 'studioingegneri956@email.it', '070345956');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000956'), 'Sede Principale', 'Via Roma', '199', 'Nuoro', 'NU', '08100', '070345956', 'studioingegneri956@email.it', '48000000956', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Nuoro', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '48000000957', 'geometra957@email.it', '070345957');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000957'), 'Sede Principale', 'Via Roma', '132', 'Nuoro', 'NU', '08100', '070345957', 'geometra957@email.it', '48000000957', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Nuoro', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '48000000958', 'officinaauto958@email.it', '070345958');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000958'), 'Sede Principale', 'Piazza del Duomo', '159', 'Nuoro', 'NU', '08100', '070345958', 'officinaauto958@email.it', '48000000958', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Nuoro', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '48000000959', 'gommista959@email.it', '070345959');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '48000000959'), 'Sede Principale', 'Corso Italia', '138', 'Nuoro', 'NU', '08100', '070345959', 'gommista959@email.it', '48000000959', true);

-- TRENTINO-ALTO ADIGE
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Trento', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '49000000960', 'ristorante960@email.it', '046345960');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000960'), 'Sede Principale', 'Via Verdi', '175', 'Trento', 'TN', '38100', '046345960', 'ristorante960@email.it', '49000000960', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Trento', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '49000000961', 'pizzeria961@email.it', '046345961');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000961'), 'Sede Principale', 'Corso Vittorio Emanuele', '187', 'Trento', 'TN', '38100', '046345961', 'pizzeria961@email.it', '49000000961', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Trento', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '49000000962', 'barpasticceria962@email.it', '046345962');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000962'), 'Sede Principale', 'Via Dante', '79', 'Trento', 'TN', '38100', '046345962', 'barpasticceria962@email.it', '49000000962', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Trento', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '49000000963', 'studiodentistico963@email.it', '046345963');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000963'), 'Sede Principale', 'Via Dante', '166', 'Trento', 'TN', '38100', '046345963', 'studiodentistico963@email.it', '49000000963', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Trento', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '49000000964', 'studiomedico964@email.it', '046345964');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000964'), 'Sede Principale', 'Piazza Garibaldi', '117', 'Trento', 'TN', '38100', '046345964', 'studiomedico964@email.it', '49000000964', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Trento', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '49000000965', 'farmacia965@email.it', '046345965');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000965'), 'Sede Principale', 'Via Roma', '11', 'Trento', 'TN', '38100', '046345965', 'farmacia965@email.it', '49000000965', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Trento', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '49000000966', 'avvocato966@email.it', '046345966');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000966'), 'Sede Principale', 'Piazza Garibaldi', '95', 'Trento', 'TN', '38100', '046345966', 'avvocato966@email.it', '49000000966', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Trento', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '49000000967', 'commercialista967@email.it', '046345967');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000967'), 'Sede Principale', 'Corso Vittorio Emanuele', '65', 'Trento', 'TN', '38100', '046345967', 'commercialista967@email.it', '49000000967', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Trento', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '49000000968', 'notaio968@email.it', '046345968');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000968'), 'Sede Principale', 'Via Roma', '148', 'Trento', 'TN', '38100', '046345968', 'notaio968@email.it', '49000000968', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Trento', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '49000000969', 'salone969@email.it', '046345969');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000969'), 'Sede Principale', 'Via Dante', '17', 'Trento', 'TN', '38100', '046345969', 'salone969@email.it', '49000000969', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Trento', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '49000000970', 'centroestetico970@email.it', '046345970');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000970'), 'Sede Principale', 'Via Dante', '49', 'Trento', 'TN', '38100', '046345970', 'centroestetico970@email.it', '49000000970', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Trento', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '49000000971', 'idraulico971@email.it', '3331234971');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000971'), 'Sede Principale', 'Via Cavour', '71', 'Trento', 'TN', '38100', '3331234971', 'idraulico971@email.it', '49000000971', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Trento', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '49000000972', 'elettricista972@email.it', '3331234972');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000972'), 'Sede Principale', 'Via Mazzini', '2', 'Trento', 'TN', '38100', '3331234972', 'elettricista972@email.it', '49000000972', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Trento', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '49000000973', 'imbianchino973@email.it', '3331234973');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000973'), 'Sede Principale', 'Corso Italia', '173', 'Trento', 'TN', '38100', '3331234973', 'imbianchino973@email.it', '49000000973', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Trento', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '49000000974', 'fabbro974@email.it', '3331234974');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000974'), 'Sede Principale', 'Via Roma', '139', 'Trento', 'TN', '38100', '3331234974', 'fabbro974@email.it', '49000000974', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Trento', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '49000000975', 'falegname975@email.it', '3331234975');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000975'), 'Sede Principale', 'Via Verdi', '113', 'Trento', 'TN', '38100', '3331234975', 'falegname975@email.it', '49000000975', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Trento', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '49000000976', 'supermercato976@email.it', '046345976');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000976'), 'Sede Principale', 'Piazza Garibaldi', '80', 'Trento', 'TN', '38100', '046345976', 'supermercato976@email.it', '49000000976', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Trento', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '49000000977', 'ferramenta977@email.it', '046345977');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000977'), 'Sede Principale', 'Corso Vittorio Emanuele', '11', 'Trento', 'TN', '38100', '046345977', 'ferramenta977@email.it', '49000000977', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Trento', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '49000000978', 'palestra978@email.it', '046345978');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000978'), 'Sede Principale', 'Via Roma', '160', 'Trento', 'TN', '38100', '046345978', 'palestra978@email.it', '49000000978', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Trento', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '49000000979', 'panificio979@email.it', '046345979');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000979'), 'Sede Principale', 'Corso Italia', '85', 'Trento', 'TN', '38100', '046345979', 'panificio979@email.it', '49000000979', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Trento', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '49000000980', 'pasticceria980@email.it', '046345980');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000980'), 'Sede Principale', 'Piazza Garibaldi', '84', 'Trento', 'TN', '38100', '046345980', 'pasticceria980@email.it', '49000000980', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Trento', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '49000000981', 'veterinario981@email.it', '046345981');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000981'), 'Sede Principale', 'Piazza Garibaldi', '26', 'Trento', 'TN', '38100', '046345981', 'veterinario981@email.it', '49000000981', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Trento', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '49000000982', 'macelleria982@email.it', '046345982');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000982'), 'Sede Principale', 'Via Dante', '58', 'Trento', 'TN', '38100', '046345982', 'macelleria982@email.it', '49000000982', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Trento', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '49000000983', 'pescheria983@email.it', '046345983');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000983'), 'Sede Principale', 'Corso Vittorio Emanuele', '153', 'Trento', 'TN', '38100', '046345983', 'pescheria983@email.it', '49000000983', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Trento', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '49000000984', 'libreria984@email.it', '046345984');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000984'), 'Sede Principale', 'Corso Umberto', '61', 'Trento', 'TN', '38100', '046345984', 'libreria984@email.it', '49000000984', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Trento', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '49000000985', 'studioarchitetti985@email.it', '046345985');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000985'), 'Sede Principale', 'Piazza del Duomo', '198', 'Trento', 'TN', '38100', '046345985', 'studioarchitetti985@email.it', '49000000985', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Ingegneri Trento', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '49000000986', 'studioingegneri986@email.it', '046345986');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000986'), 'Sede Principale', 'Via Verdi', '143', 'Trento', 'TN', '38100', '046345986', 'studioingegneri986@email.it', '49000000986', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Trento', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '49000000987', 'geometra987@email.it', '046345987');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000987'), 'Sede Principale', 'Via Mazzini', '8', 'Trento', 'TN', '38100', '046345987', 'geometra987@email.it', '49000000987', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Trento', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '49000000988', 'officinaauto988@email.it', '046345988');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000988'), 'Sede Principale', 'Via Mazzini', '79', 'Trento', 'TN', '38100', '046345988', 'officinaauto988@email.it', '49000000988', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Trento', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '49000000989', 'gommista989@email.it', '046345989');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000989'), 'Sede Principale', 'Piazza Garibaldi', '158', 'Trento', 'TN', '38100', '046345989', 'gommista989@email.it', '49000000989', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Bolzano', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '49000000990', 'ristorante990@email.it', '046345990');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000990'), 'Sede Principale', 'Via Cavour', '133', 'Bolzano', 'BZ', '39100', '046345990', 'ristorante990@email.it', '49000000990', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Bolzano', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '49000000991', 'pizzeria991@email.it', '046345991');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000991'), 'Sede Principale', 'Via Verdi', '77', 'Bolzano', 'BZ', '39100', '046345991', 'pizzeria991@email.it', '49000000991', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Bolzano', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '49000000992', 'barpasticceria992@email.it', '046345992');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000992'), 'Sede Principale', 'Via Dante', '150', 'Bolzano', 'BZ', '39100', '046345992', 'barpasticceria992@email.it', '49000000992', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Bolzano', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '49000000993', 'studiodentistico993@email.it', '046345993');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000993'), 'Sede Principale', 'Via Cavour', '187', 'Bolzano', 'BZ', '39100', '046345993', 'studiodentistico993@email.it', '49000000993', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Bolzano', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '49000000994', 'studiomedico994@email.it', '046345994');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000994'), 'Sede Principale', 'Corso Italia', '49', 'Bolzano', 'BZ', '39100', '046345994', 'studiomedico994@email.it', '49000000994', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Bolzano', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '49000000995', 'farmacia995@email.it', '046345995');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000995'), 'Sede Principale', 'Corso Italia', '112', 'Bolzano', 'BZ', '39100', '046345995', 'farmacia995@email.it', '49000000995', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Bolzano', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '49000000996', 'avvocato996@email.it', '046345996');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000996'), 'Sede Principale', 'Corso Italia', '200', 'Bolzano', 'BZ', '39100', '046345996', 'avvocato996@email.it', '49000000996', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Bolzano', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '49000000997', 'commercialista997@email.it', '046345997');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000997'), 'Sede Principale', 'Piazza Garibaldi', '119', 'Bolzano', 'BZ', '39100', '046345997', 'commercialista997@email.it', '49000000997', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Bolzano', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '49000000998', 'notaio998@email.it', '046345998');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000998'), 'Sede Principale', 'Via Mazzini', '134', 'Bolzano', 'BZ', '39100', '046345998', 'notaio998@email.it', '49000000998', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Bolzano', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '49000000999', 'salone999@email.it', '046345999');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000000999'), 'Sede Principale', 'Via Mazzini', '23', 'Bolzano', 'BZ', '39100', '046345999', 'salone999@email.it', '49000000999', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Bolzano', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '49000001000', 'centroestetico1000@email.it', '046346000');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001000'), 'Sede Principale', 'Via Mazzini', '25', 'Bolzano', 'BZ', '39100', '046346000', 'centroestetico1000@email.it', '49000001000', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Bolzano', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '49000001001', 'idraulico1001@email.it', '3331235001');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001001'), 'Sede Principale', 'Corso Vittorio Emanuele', '120', 'Bolzano', 'BZ', '39100', '3331235001', 'idraulico1001@email.it', '49000001001', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Bolzano', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '49000001002', 'elettricista1002@email.it', '3331235002');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001002'), 'Sede Principale', 'Piazza del Duomo', '178', 'Bolzano', 'BZ', '39100', '3331235002', 'elettricista1002@email.it', '49000001002', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Bolzano', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '49000001003', 'imbianchino1003@email.it', '3331235003');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001003'), 'Sede Principale', 'Via Dante', '23', 'Bolzano', 'BZ', '39100', '3331235003', 'imbianchino1003@email.it', '49000001003', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Bolzano', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '49000001004', 'fabbro1004@email.it', '3331235004');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001004'), 'Sede Principale', 'Via Verdi', '83', 'Bolzano', 'BZ', '39100', '3331235004', 'fabbro1004@email.it', '49000001004', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Bolzano', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '49000001005', 'falegname1005@email.it', '3331235005');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001005'), 'Sede Principale', 'Via Dante', '126', 'Bolzano', 'BZ', '39100', '3331235005', 'falegname1005@email.it', '49000001005', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Bolzano', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '49000001006', 'supermercato1006@email.it', '046346006');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001006'), 'Sede Principale', 'Via Cavour', '105', 'Bolzano', 'BZ', '39100', '046346006', 'supermercato1006@email.it', '49000001006', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Bolzano', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '49000001007', 'ferramenta1007@email.it', '046346007');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001007'), 'Sede Principale', 'Via Mazzini', '48', 'Bolzano', 'BZ', '39100', '046346007', 'ferramenta1007@email.it', '49000001007', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Bolzano', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '49000001008', 'palestra1008@email.it', '046346008');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001008'), 'Sede Principale', 'Corso Umberto', '68', 'Bolzano', 'BZ', '39100', '046346008', 'palestra1008@email.it', '49000001008', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Bolzano', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '49000001009', 'panificio1009@email.it', '046346009');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001009'), 'Sede Principale', 'Piazza Garibaldi', '60', 'Bolzano', 'BZ', '39100', '046346009', 'panificio1009@email.it', '49000001009', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Bolzano', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '49000001010', 'pasticceria1010@email.it', '046346010');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001010'), 'Sede Principale', 'Piazza Garibaldi', '142', 'Bolzano', 'BZ', '39100', '046346010', 'pasticceria1010@email.it', '49000001010', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Bolzano', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '49000001011', 'veterinario1011@email.it', '046346011');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001011'), 'Sede Principale', 'Via Mazzini', '58', 'Bolzano', 'BZ', '39100', '046346011', 'veterinario1011@email.it', '49000001011', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Bolzano', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '49000001012', 'macelleria1012@email.it', '046346012');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001012'), 'Sede Principale', 'Via Roma', '53', 'Bolzano', 'BZ', '39100', '046346012', 'macelleria1012@email.it', '49000001012', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Bolzano', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '49000001013', 'pescheria1013@email.it', '046346013');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001013'), 'Sede Principale', 'Via Verdi', '75', 'Bolzano', 'BZ', '39100', '046346013', 'pescheria1013@email.it', '49000001013', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Bolzano', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '49000001014', 'libreria1014@email.it', '046346014');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001014'), 'Sede Principale', 'Via Cavour', '38', 'Bolzano', 'BZ', '39100', '046346014', 'libreria1014@email.it', '49000001014', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Bolzano', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '49000001015', 'architetto1015@email.it', '046346015');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001015'), 'Sede Principale', 'Via Cavour', '165', 'Bolzano', 'BZ', '39100', '046346015', 'architetto1015@email.it', '49000001015', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Bolzano', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '49000001016', 'ingegnere1016@email.it', '046346016');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001016'), 'Sede Principale', 'Piazza del Duomo', '87', 'Bolzano', 'BZ', '39100', '046346016', 'ingegnere1016@email.it', '49000001016', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Bolzano', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '49000001017', 'geometra1017@email.it', '046346017');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001017'), 'Sede Principale', 'Piazza Garibaldi', '155', 'Bolzano', 'BZ', '39100', '046346017', 'geometra1017@email.it', '49000001017', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Bolzano', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '49000001018', 'officinaauto1018@email.it', '046346018');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001018'), 'Sede Principale', 'Via Mazzini', '38', 'Bolzano', 'BZ', '39100', '046346018', 'officinaauto1018@email.it', '49000001018', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Bolzano', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '49000001019', 'gommista1019@email.it', '046346019');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '49000001019'), 'Sede Principale', 'Via Cavour', '37', 'Bolzano', 'BZ', '39100', '046346019', 'gommista1019@email.it', '49000001019', true);

-- UMBRIA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Perugia', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '50000001020', 'osteria1020@email.it', '075346020');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001020'), 'Sede Principale', 'Piazza del Duomo', '98', 'Perugia', 'PG', '06100', '075346020', 'osteria1020@email.it', '50000001020', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Perugia', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '50000001021', 'pizzeria1021@email.it', '075346021');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001021'), 'Sede Principale', 'Corso Italia', '7', 'Perugia', 'PG', '06100', '075346021', 'pizzeria1021@email.it', '50000001021', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Caffe Perugia', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '50000001022', 'caffe1022@email.it', '075346022');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001022'), 'Sede Principale', 'Piazza del Duomo', '41', 'Perugia', 'PG', '06100', '075346022', 'caffe1022@email.it', '50000001022', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Perugia', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '50000001023', 'studiodentistico1023@email.it', '075346023');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001023'), 'Sede Principale', 'Via Dante', '71', 'Perugia', 'PG', '06100', '075346023', 'studiodentistico1023@email.it', '50000001023', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Perugia', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '50000001024', 'studiomedico1024@email.it', '075346024');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001024'), 'Sede Principale', 'Corso Italia', '180', 'Perugia', 'PG', '06100', '075346024', 'studiomedico1024@email.it', '50000001024', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Perugia', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '50000001025', 'farmacia1025@email.it', '075346025');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001025'), 'Sede Principale', 'Via Dante', '24', 'Perugia', 'PG', '06100', '075346025', 'farmacia1025@email.it', '50000001025', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Legale Perugia', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '50000001026', 'studiolegale1026@email.it', '075346026');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001026'), 'Sede Principale', 'Via Cavour', '33', 'Perugia', 'PG', '06100', '075346026', 'studiolegale1026@email.it', '50000001026', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Perugia', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '50000001027', 'commercialista1027@email.it', '075346027');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001027'), 'Sede Principale', 'Via Mazzini', '49', 'Perugia', 'PG', '06100', '075346027', 'commercialista1027@email.it', '50000001027', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Perugia', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '50000001028', 'notaio1028@email.it', '075346028');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001028'), 'Sede Principale', 'Corso Umberto', '197', 'Perugia', 'PG', '06100', '075346028', 'notaio1028@email.it', '50000001028', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Perugia', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '50000001029', 'salone1029@email.it', '075346029');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001029'), 'Sede Principale', 'Corso Vittorio Emanuele', '189', 'Perugia', 'PG', '06100', '075346029', 'salone1029@email.it', '50000001029', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Perugia', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '50000001030', 'centroestetico1030@email.it', '075346030');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001030'), 'Sede Principale', 'Via Cavour', '131', 'Perugia', 'PG', '06100', '075346030', 'centroestetico1030@email.it', '50000001030', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Perugia', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '50000001031', 'idraulico1031@email.it', '3331235031');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001031'), 'Sede Principale', 'Via Dante', '118', 'Perugia', 'PG', '06100', '3331235031', 'idraulico1031@email.it', '50000001031', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Perugia', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '50000001032', 'elettricista1032@email.it', '3331235032');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001032'), 'Sede Principale', 'Via Dante', '102', 'Perugia', 'PG', '06100', '3331235032', 'elettricista1032@email.it', '50000001032', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Perugia', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '50000001033', 'imbianchino1033@email.it', '3331235033');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001033'), 'Sede Principale', 'Via Verdi', '190', 'Perugia', 'PG', '06100', '3331235033', 'imbianchino1033@email.it', '50000001033', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Perugia', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '50000001034', 'fabbro1034@email.it', '3331235034');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001034'), 'Sede Principale', 'Via Roma', '149', 'Perugia', 'PG', '06100', '3331235034', 'fabbro1034@email.it', '50000001034', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Perugia', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '50000001035', 'falegname1035@email.it', '3331235035');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001035'), 'Sede Principale', 'Corso Umberto', '77', 'Perugia', 'PG', '06100', '3331235035', 'falegname1035@email.it', '50000001035', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Perugia', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '50000001036', 'supermercato1036@email.it', '075346036');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001036'), 'Sede Principale', 'Via Verdi', '140', 'Perugia', 'PG', '06100', '075346036', 'supermercato1036@email.it', '50000001036', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Perugia', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '50000001037', 'ferramenta1037@email.it', '075346037');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001037'), 'Sede Principale', 'Corso Umberto', '112', 'Perugia', 'PG', '06100', '075346037', 'ferramenta1037@email.it', '50000001037', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Perugia', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '50000001038', 'palestra1038@email.it', '075346038');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001038'), 'Sede Principale', 'Piazza del Duomo', '89', 'Perugia', 'PG', '06100', '075346038', 'palestra1038@email.it', '50000001038', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Perugia', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '50000001039', 'panificio1039@email.it', '075346039');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001039'), 'Sede Principale', 'Via Cavour', '45', 'Perugia', 'PG', '06100', '075346039', 'panificio1039@email.it', '50000001039', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Perugia', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '50000001040', 'pasticceria1040@email.it', '075346040');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001040'), 'Sede Principale', 'Via Roma', '39', 'Perugia', 'PG', '06100', '075346040', 'pasticceria1040@email.it', '50000001040', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Perugia', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '50000001041', 'veterinario1041@email.it', '075346041');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001041'), 'Sede Principale', 'Corso Umberto', '178', 'Perugia', 'PG', '06100', '075346041', 'veterinario1041@email.it', '50000001041', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Perugia', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '50000001042', 'macelleria1042@email.it', '075346042');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001042'), 'Sede Principale', 'Corso Umberto', '55', 'Perugia', 'PG', '06100', '075346042', 'macelleria1042@email.it', '50000001042', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Perugia', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '50000001043', 'pescheria1043@email.it', '075346043');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001043'), 'Sede Principale', 'Corso Italia', '119', 'Perugia', 'PG', '06100', '075346043', 'pescheria1043@email.it', '50000001043', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Perugia', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '50000001044', 'libreria1044@email.it', '075346044');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001044'), 'Sede Principale', 'Via Verdi', '142', 'Perugia', 'PG', '06100', '075346044', 'libreria1044@email.it', '50000001044', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Architetto Perugia', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '50000001045', 'architetto1045@email.it', '075346045');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001045'), 'Sede Principale', 'Corso Vittorio Emanuele', '54', 'Perugia', 'PG', '06100', '075346045', 'architetto1045@email.it', '50000001045', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Perugia', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '50000001046', 'ingegnere1046@email.it', '075346046');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001046'), 'Sede Principale', 'Corso Umberto', '174', 'Perugia', 'PG', '06100', '075346046', 'ingegnere1046@email.it', '50000001046', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Perugia', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '50000001047', 'geometra1047@email.it', '075346047');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001047'), 'Sede Principale', 'Piazza Garibaldi', '40', 'Perugia', 'PG', '06100', '075346047', 'geometra1047@email.it', '50000001047', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Perugia', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '50000001048', 'officinaauto1048@email.it', '075346048');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001048'), 'Sede Principale', 'Via Verdi', '69', 'Perugia', 'PG', '06100', '075346048', 'officinaauto1048@email.it', '50000001048', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Perugia', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '50000001049', 'gommista1049@email.it', '075346049');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001049'), 'Sede Principale', 'Via Cavour', '36', 'Perugia', 'PG', '06100', '075346049', 'gommista1049@email.it', '50000001049', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Osteria Terni', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '50000001050', 'osteria1050@email.it', '075346050');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001050'), 'Sede Principale', 'Via Mazzini', '73', 'Terni', 'TR', '05100', '075346050', 'osteria1050@email.it', '50000001050', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Terni', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '50000001051', 'pizzeria1051@email.it', '075346051');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001051'), 'Sede Principale', 'Piazza del Duomo', '68', 'Terni', 'TR', '05100', '075346051', 'pizzeria1051@email.it', '50000001051', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Terni', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '50000001052', 'bar1052@email.it', '075346052');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001052'), 'Sede Principale', 'Corso Italia', '89', 'Terni', 'TR', '05100', '075346052', 'bar1052@email.it', '50000001052', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Terni', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '50000001053', 'studiodentistico1053@email.it', '075346053');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001053'), 'Sede Principale', 'Piazza Garibaldi', '97', 'Terni', 'TR', '05100', '075346053', 'studiodentistico1053@email.it', '50000001053', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Medico Terni', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '50000001054', 'studiomedico1054@email.it', '075346054');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001054'), 'Sede Principale', 'Via Mazzini', '163', 'Terni', 'TR', '05100', '075346054', 'studiomedico1054@email.it', '50000001054', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Terni', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '50000001055', 'farmacia1055@email.it', '075346055');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001055'), 'Sede Principale', 'Via Roma', '19', 'Terni', 'TR', '05100', '075346055', 'farmacia1055@email.it', '50000001055', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Terni', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '50000001056', 'avvocato1056@email.it', '075346056');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001056'), 'Sede Principale', 'Via Verdi', '73', 'Terni', 'TR', '05100', '075346056', 'avvocato1056@email.it', '50000001056', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Commercialisti Terni', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '50000001057', 'studiocommercialisti1057@email.it', '075346057');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001057'), 'Sede Principale', 'Via Cavour', '188', 'Terni', 'TR', '05100', '075346057', 'studiocommercialisti1057@email.it', '50000001057', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Terni', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '50000001058', 'notaio1058@email.it', '075346058');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001058'), 'Sede Principale', 'Via Dante', '182', 'Terni', 'TR', '05100', '075346058', 'notaio1058@email.it', '50000001058', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Parrucchiere Terni', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '50000001059', 'parrucchiere1059@email.it', '075346059');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001059'), 'Sede Principale', 'Via Dante', '130', 'Terni', 'TR', '05100', '075346059', 'parrucchiere1059@email.it', '50000001059', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Terni', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '50000001060', 'centroestetico1060@email.it', '075346060');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001060'), 'Sede Principale', 'Via Verdi', '27', 'Terni', 'TR', '05100', '075346060', 'centroestetico1060@email.it', '50000001060', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Terni', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '50000001061', 'idraulico1061@email.it', '3331235061');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001061'), 'Sede Principale', 'Corso Vittorio Emanuele', '94', 'Terni', 'TR', '05100', '3331235061', 'idraulico1061@email.it', '50000001061', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Terni', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '50000001062', 'elettricista1062@email.it', '3331235062');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001062'), 'Sede Principale', 'Via Roma', '1', 'Terni', 'TR', '05100', '3331235062', 'elettricista1062@email.it', '50000001062', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Terni', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '50000001063', 'imbianchino1063@email.it', '3331235063');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001063'), 'Sede Principale', 'Piazza del Duomo', '147', 'Terni', 'TR', '05100', '3331235063', 'imbianchino1063@email.it', '50000001063', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Terni', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '50000001064', 'fabbro1064@email.it', '3331235064');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001064'), 'Sede Principale', 'Piazza Garibaldi', '103', 'Terni', 'TR', '05100', '3331235064', 'fabbro1064@email.it', '50000001064', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Terni', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '50000001065', 'falegname1065@email.it', '3331235065');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001065'), 'Sede Principale', 'Via Mazzini', '159', 'Terni', 'TR', '05100', '3331235065', 'falegname1065@email.it', '50000001065', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Terni', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '50000001066', 'supermercato1066@email.it', '075346066');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001066'), 'Sede Principale', 'Piazza Garibaldi', '162', 'Terni', 'TR', '05100', '075346066', 'supermercato1066@email.it', '50000001066', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Terni', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '50000001067', 'ferramenta1067@email.it', '075346067');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001067'), 'Sede Principale', 'Via Dante', '73', 'Terni', 'TR', '05100', '075346067', 'ferramenta1067@email.it', '50000001067', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Terni', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '50000001068', 'palestra1068@email.it', '075346068');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001068'), 'Sede Principale', 'Via Roma', '48', 'Terni', 'TR', '05100', '075346068', 'palestra1068@email.it', '50000001068', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Terni', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '50000001069', 'panificio1069@email.it', '075346069');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001069'), 'Sede Principale', 'Via Mazzini', '170', 'Terni', 'TR', '05100', '075346069', 'panificio1069@email.it', '50000001069', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pasticceria Terni', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '50000001070', 'pasticceria1070@email.it', '075346070');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001070'), 'Sede Principale', 'Via Roma', '50', 'Terni', 'TR', '05100', '075346070', 'pasticceria1070@email.it', '50000001070', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Terni', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '50000001071', 'veterinario1071@email.it', '075346071');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001071'), 'Sede Principale', 'Corso Italia', '43', 'Terni', 'TR', '05100', '075346071', 'veterinario1071@email.it', '50000001071', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Terni', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '50000001072', 'macelleria1072@email.it', '075346072');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001072'), 'Sede Principale', 'Via Mazzini', '186', 'Terni', 'TR', '05100', '075346072', 'macelleria1072@email.it', '50000001072', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Terni', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '50000001073', 'pescheria1073@email.it', '075346073');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001073'), 'Sede Principale', 'Corso Italia', '33', 'Terni', 'TR', '05100', '075346073', 'pescheria1073@email.it', '50000001073', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Terni', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '50000001074', 'libreria1074@email.it', '075346074');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001074'), 'Sede Principale', 'Piazza Garibaldi', '131', 'Terni', 'TR', '05100', '075346074', 'libreria1074@email.it', '50000001074', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Terni', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '50000001075', 'studioarchitetti1075@email.it', '075346075');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001075'), 'Sede Principale', 'Via Cavour', '23', 'Terni', 'TR', '05100', '075346075', 'studioarchitetti1075@email.it', '50000001075', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Terni', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '50000001076', 'ingegnere1076@email.it', '075346076');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001076'), 'Sede Principale', 'Piazza Garibaldi', '178', 'Terni', 'TR', '05100', '075346076', 'ingegnere1076@email.it', '50000001076', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Terni', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '50000001077', 'geometra1077@email.it', '075346077');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001077'), 'Sede Principale', 'Via Mazzini', '32', 'Terni', 'TR', '05100', '075346077', 'geometra1077@email.it', '50000001077', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Terni', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '50000001078', 'officinaauto1078@email.it', '075346078');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001078'), 'Sede Principale', 'Via Mazzini', '13', 'Terni', 'TR', '05100', '075346078', 'officinaauto1078@email.it', '50000001078', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Terni', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '50000001079', 'gommista1079@email.it', '075346079');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '50000001079'), 'Sede Principale', 'Corso Italia', '48', 'Terni', 'TR', '05100', '075346079', 'gommista1079@email.it', '50000001079', true);

-- VALLE DAOSTA
INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ristorante Aosta', (SELECT id FROM business_categories WHERE slug = 'ristoranti'), false, true, '51000001080', 'ristorante1080@email.it', '016346080');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001080'), 'Sede Principale', 'Piazza del Duomo', '108', 'Aosta', 'AO', '11100', '016346080', 'ristorante1080@email.it', '51000001080', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pizzeria Aosta', (SELECT id FROM business_categories WHERE slug = 'pizzerie'), false, true, '51000001081', 'pizzeria1081@email.it', '016346081');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001081'), 'Sede Principale', 'Via Roma', '11', 'Aosta', 'AO', '11100', '016346081', 'pizzeria1081@email.it', '51000001081', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Bar Pasticceria Aosta', (SELECT id FROM business_categories WHERE slug = 'bar-caffe'), false, true, '51000001082', 'barpasticceria1082@email.it', '016346082');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001082'), 'Sede Principale', 'Via Verdi', '126', 'Aosta', 'AO', '11100', '016346082', 'barpasticceria1082@email.it', '51000001082', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Dentistico Aosta', (SELECT id FROM business_categories WHERE slug = 'studi-dentistici'), false, true, '51000001083', 'studiodentistico1083@email.it', '016346083');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001083'), 'Sede Principale', 'Corso Vittorio Emanuele', '178', 'Aosta', 'AO', '11100', '016346083', 'studiodentistico1083@email.it', '51000001083', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Poliambulatorio Aosta', (SELECT id FROM business_categories WHERE slug = 'studi-medici'), false, true, '51000001084', 'poliambulatorio1084@email.it', '016346084');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001084'), 'Sede Principale', 'Piazza Garibaldi', '196', 'Aosta', 'AO', '11100', '016346084', 'poliambulatorio1084@email.it', '51000001084', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Farmacia Aosta', (SELECT id FROM business_categories WHERE slug = 'farmacie'), false, true, '51000001085', 'farmacia1085@email.it', '016346085');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001085'), 'Sede Principale', 'Corso Vittorio Emanuele', '121', 'Aosta', 'AO', '11100', '016346085', 'farmacia1085@email.it', '51000001085', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Avvocato Aosta', (SELECT id FROM business_categories WHERE slug = 'avvocati'), false, true, '51000001086', 'avvocato1086@email.it', '016346086');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001086'), 'Sede Principale', 'Via Roma', '174', 'Aosta', 'AO', '11100', '016346086', 'avvocato1086@email.it', '51000001086', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Commercialista Aosta', (SELECT id FROM business_categories WHERE slug = 'commercialisti'), false, true, '51000001087', 'commercialista1087@email.it', '016346087');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001087'), 'Sede Principale', 'Piazza Garibaldi', '68', 'Aosta', 'AO', '11100', '016346087', 'commercialista1087@email.it', '51000001087', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Notaio Aosta', (SELECT id FROM business_categories WHERE slug = 'notai'), false, true, '51000001088', 'notaio1088@email.it', '016346088');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001088'), 'Sede Principale', 'Piazza Garibaldi', '137', 'Aosta', 'AO', '11100', '016346088', 'notaio1088@email.it', '51000001088', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Salone Aosta', (SELECT id FROM business_categories WHERE slug = 'parrucchieri'), false, true, '51000001089', 'salone1089@email.it', '016346089');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001089'), 'Sede Principale', 'Piazza Garibaldi', '96', 'Aosta', 'AO', '11100', '016346089', 'salone1089@email.it', '51000001089', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Centro Estetico Aosta', (SELECT id FROM business_categories WHERE slug = 'centri-estetici'), false, true, '51000001090', 'centroestetico1090@email.it', '016346090');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001090'), 'Sede Principale', 'Piazza Garibaldi', '69', 'Aosta', 'AO', '11100', '016346090', 'centroestetico1090@email.it', '51000001090', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Idraulico Aosta', (SELECT id FROM business_categories WHERE slug = 'idraulici'), false, true, '51000001091', 'idraulico1091@email.it', '3331235091');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001091'), 'Sede Principale', 'Piazza del Duomo', '3', 'Aosta', 'AO', '11100', '3331235091', 'idraulico1091@email.it', '51000001091', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Elettricista Aosta', (SELECT id FROM business_categories WHERE slug = 'elettricisti'), false, true, '51000001092', 'elettricista1092@email.it', '3331235092');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001092'), 'Sede Principale', 'Piazza Garibaldi', '44', 'Aosta', 'AO', '11100', '3331235092', 'elettricista1092@email.it', '51000001092', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Imbianchino Aosta', (SELECT id FROM business_categories WHERE slug = 'imbianchini'), false, true, '51000001093', 'imbianchino1093@email.it', '3331235093');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001093'), 'Sede Principale', 'Via Roma', '38', 'Aosta', 'AO', '11100', '3331235093', 'imbianchino1093@email.it', '51000001093', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Fabbro Aosta', (SELECT id FROM business_categories WHERE slug = 'fabbri'), false, true, '51000001094', 'fabbro1094@email.it', '3331235094');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001094'), 'Sede Principale', 'Via Mazzini', '177', 'Aosta', 'AO', '11100', '3331235094', 'fabbro1094@email.it', '51000001094', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Falegname Aosta', (SELECT id FROM business_categories WHERE slug = 'falegnami'), false, true, '51000001095', 'falegname1095@email.it', '3331235095');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001095'), 'Sede Principale', 'Piazza del Duomo', '54', 'Aosta', 'AO', '11100', '3331235095', 'falegname1095@email.it', '51000001095', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Supermercato Aosta', (SELECT id FROM business_categories WHERE slug = 'supermercati'), false, true, '51000001096', 'supermercato1096@email.it', '016346096');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001096'), 'Sede Principale', 'Corso Umberto', '13', 'Aosta', 'AO', '11100', '016346096', 'supermercato1096@email.it', '51000001096', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ferramenta Aosta', (SELECT id FROM business_categories WHERE slug = 'ferramenta'), false, true, '51000001097', 'ferramenta1097@email.it', '016346097');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001097'), 'Sede Principale', 'Via Dante', '104', 'Aosta', 'AO', '11100', '016346097', 'ferramenta1097@email.it', '51000001097', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Palestra Aosta', (SELECT id FROM business_categories WHERE slug = 'palestre'), false, true, '51000001098', 'palestra1098@email.it', '016346098');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001098'), 'Sede Principale', 'Corso Italia', '177', 'Aosta', 'AO', '11100', '016346098', 'palestra1098@email.it', '51000001098', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Panificio Aosta', (SELECT id FROM business_categories WHERE slug = 'panifici'), false, true, '51000001099', 'panificio1099@email.it', '016346099');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001099'), 'Sede Principale', 'Via Mazzini', '138', 'Aosta', 'AO', '11100', '016346099', 'panificio1099@email.it', '51000001099', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gelateria Aosta', (SELECT id FROM business_categories WHERE slug = 'gelaterie-pasticcerie'), false, true, '51000001100', 'gelateria1100@email.it', '016346100');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001100'), 'Sede Principale', 'Corso Vittorio Emanuele', '33', 'Aosta', 'AO', '11100', '016346100', 'gelateria1100@email.it', '51000001100', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Veterinario Aosta', (SELECT id FROM business_categories WHERE slug = 'veterinari'), false, true, '51000001101', 'veterinario1101@email.it', '016346101');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001101'), 'Sede Principale', 'Via Mazzini', '121', 'Aosta', 'AO', '11100', '016346101', 'veterinario1101@email.it', '51000001101', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Macelleria Aosta', (SELECT id FROM business_categories WHERE slug = 'macellerie'), false, true, '51000001102', 'macelleria1102@email.it', '016346102');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001102'), 'Sede Principale', 'Via Mazzini', '112', 'Aosta', 'AO', '11100', '016346102', 'macelleria1102@email.it', '51000001102', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Pescheria Aosta', (SELECT id FROM business_categories WHERE slug = 'pescherie'), false, true, '51000001103', 'pescheria1103@email.it', '016346103');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001103'), 'Sede Principale', 'Piazza del Duomo', '53', 'Aosta', 'AO', '11100', '016346103', 'pescheria1103@email.it', '51000001103', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Libreria Aosta', (SELECT id FROM business_categories WHERE slug = 'librerie'), false, true, '51000001104', 'libreria1104@email.it', '016346104');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001104'), 'Sede Principale', 'Via Verdi', '161', 'Aosta', 'AO', '11100', '016346104', 'libreria1104@email.it', '51000001104', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Studio Architetti Aosta', (SELECT id FROM business_categories WHERE slug = 'architetti'), false, true, '51000001105', 'studioarchitetti1105@email.it', '016346105');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001105'), 'Sede Principale', 'Via Cavour', '189', 'Aosta', 'AO', '11100', '016346105', 'studioarchitetti1105@email.it', '51000001105', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Ingegnere Aosta', (SELECT id FROM business_categories WHERE slug = 'ingegneri'), false, true, '51000001106', 'ingegnere1106@email.it', '016346106');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001106'), 'Sede Principale', 'Piazza del Duomo', '99', 'Aosta', 'AO', '11100', '016346106', 'ingegnere1106@email.it', '51000001106', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Geometra Aosta', (SELECT id FROM business_categories WHERE slug = 'geometri'), false, true, '51000001107', 'geometra1107@email.it', '016346107');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001107'), 'Sede Principale', 'Via Roma', '101', 'Aosta', 'AO', '11100', '016346107', 'geometra1107@email.it', '51000001107', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Officina Auto Aosta', (SELECT id FROM business_categories WHERE slug = 'officine-auto'), false, true, '51000001108', 'officinaauto1108@email.it', '016346108');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001108'), 'Sede Principale', 'Via Roma', '18', 'Aosta', 'AO', '11100', '016346108', 'officinaauto1108@email.it', '51000001108', true);

INSERT INTO businesses (name, category_id, is_claimed, verified, vat_number, email, phone) VALUES ('Gommista Aosta', (SELECT id FROM business_categories WHERE slug = 'gommisti'), false, true, '51000001109', 'gommista1109@email.it', '016346109');
INSERT INTO business_locations (business_id, name, address, street_number, city, province, postal_code, phone, email, vat_number, is_primary) VALUES ((SELECT id FROM businesses WHERE vat_number = '51000001109'), 'Sede Principale', 'Corso Umberto', '86', 'Aosta', 'AO', '11100', '016346109', 'gommista1109@email.it', '51000001109', true);

-- Total businesses generated: 1110
