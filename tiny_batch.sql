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

