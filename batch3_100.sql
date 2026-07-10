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
