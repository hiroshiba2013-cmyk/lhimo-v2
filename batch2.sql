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

