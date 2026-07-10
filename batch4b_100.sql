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
