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

