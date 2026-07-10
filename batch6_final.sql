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
