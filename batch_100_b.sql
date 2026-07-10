
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
