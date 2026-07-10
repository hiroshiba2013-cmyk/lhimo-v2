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
