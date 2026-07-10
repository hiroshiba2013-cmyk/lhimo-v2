-- TROVAFACILE - BACKUP DATI CORRENTI
-- Generato il: 2026-05-22
-- Contiene: subscription_plans, business_categories, classified_categories, faqs, rules_content
-- NON contiene: dati utenti (privacy), attivita' OSM (146k righe - troppo pesante)
-- IMPORTANTE: eseguire DOPO 01_schema_complete.sql

-- === SUBSCRIPTION PLANS ===
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('a3fbba4c-29e4-4bb7-8316-7387547cfb68', 'Piano Mensile - 1 Persona', 0.49, 'monthly', 1, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('cb8bad67-1ffa-4c81-bace-76322ead3165', 'Piano Annuale - 1 Persona', 4.90, 'yearly', 1, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('91907577-c01b-4a3d-99b7-f90c13587064', 'Piano Mensile - 2 Persone', 0.79, 'monthly', 2, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('6bb74deb-e3e6-44ca-a242-2e301e5d69bf', 'Piano Annuale - 2 Persone', 7.90, 'yearly', 2, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('3fa50626-3457-4a6e-85aa-9d635e6a6fdb', 'Piano Mensile - 3 Persone', 1.09, 'monthly', 3, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('175a7837-f5bf-4df2-ac27-103ec0c5d25d', 'Piano Annuale - 3 Persone', 10.90, 'yearly', 3, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('f326f222-f3c1-40c7-b3e1-2afea5bc17ac', 'Piano Mensile - 4 Persone', 1.49, 'monthly', 4, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('a88a0e2b-968f-4e79-8e6e-53bf0994ad69', 'Piano Annuale - 4 Persone', 14.90, 'yearly', 4, '2025-12-09 16:30:06.579383+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('cba556d2-ae9d-44e0-b606-cfec435c9562', 'Piano Business Mensile - 2 Sedi', 3.99, 'monthly', 2, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('6611200b-fa49-4916-928c-731213d2c864', 'Piano Business Annuale - 2 Sedi', 39.90, 'yearly', 2, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('38ad2c95-3c9a-450b-acd4-1816dc1e34cb', 'Piano Business Mensile - 3 Sedi', 5.49, 'monthly', 3, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('88106f92-8be6-407a-b5a7-a43c553c3cc9', 'Piano Business Annuale - 3 Sedi', 54.90, 'yearly', 3, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('564a05ba-e25f-4d8a-9258-70b63b2c5371', 'Piano Business Mensile - 4 Sedi', 7.99, 'monthly', 4, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('c84453c9-bd8e-4790-9e31-8c46565e1578', 'Piano Business Annuale - 4 Sedi', 79.90, 'yearly', 4, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('48e3fec2-ec01-4e6e-a7f3-342fa82134b9', 'Piano Business Mensile - 5 Sedi', 9.99, 'monthly', 5, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('85ca0585-7418-4349-a985-709bd28e753f', 'Piano Business Annuale - 5 Sedi', 99.90, 'yearly', 5, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('a7588c69-9efb-4b14-ad9c-30b6389a880c', 'Piano Business Mensile - 6-10 Sedi', 12.99, 'monthly', 10, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('57c1384c-f7b2-4da7-ae04-3707d68fa258', 'Piano Business Annuale - 6-10 Sedi', 129.90, 'yearly', 10, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('298614dc-9e37-457b-b048-98a1738da990', 'Piano Business Mensile - Oltre 10 Sedi', 14.99, 'monthly', 999, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('a195c9cf-eecd-413e-b1ca-84ae0953fac0', 'Piano Business Annuale - Oltre 10 Sedi', 149.90, 'yearly', 999, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('c55c8f6f-9b9f-4163-861f-cbb7862458fc', 'Piano Business Mensile - 1 Sede', 2.49, 'monthly', 1, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, created_at) VALUES ('9c8c7b44-110f-4276-a8f9-5aa71bf2807d', 'Piano Business Annuale - 1 Sede', 24.90, 'yearly', 1, '2025-12-16 10:49:02.339748+00') ON CONFLICT (id) DO NOTHING;


-- === CLASSIFIED CATEGORIES (117 righe) ===
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('bcaa9dfb-b600-4b03-9936-ba6e68d1ed5f', 'Vendita Auto', 'auto', 'Car', 'Compra e vendi auto, moto e veicoli', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('07992734-abe4-40f6-8a4f-aefc373fdce0', 'Immobili', 'immobili', 'Home', 'Affitti, vendite e ricerche immobiliari', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d88e725c-97bf-453a-8eaa-57e6c72b4591', 'Lavoro', 'lavoro', 'Briefcase', 'Offerte di lavoro e ricerche personale', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('9524ff19-8f3a-4a6f-ba3e-00270a3eadbe', 'Elettronica', 'elettronica', 'Smartphone', 'Smartphone, computer, console e accessori', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('7e71b3fa-051c-4262-bbc0-e70b60a74e44', 'Arredamento', 'arredamento', 'Armchair', 'Mobili e complementi d''arredo', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('4cadbcee-e1ae-4c61-a50e-9ec6728db1d2', 'Abbigliamento', 'abbigliamento', 'Shirt', 'Vestiti, scarpe e accessori', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('36dbc713-6430-4066-bdf0-ab14458cbf29', 'Sport e Hobby', 'sport-hobby', 'Dumbbell', 'Attrezzature sportive e hobby', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('aaa2dc19-dd12-4464-a145-2ff757203cc4', 'Animali', 'animali', 'Dog', 'Animali domestici e accessori', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('14282b01-c6b4-4f50-86ab-4718cfb67f0b', 'Servizi', 'servizi', 'Wrench', 'Servizi professionali e lavoretti', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('1be0ec29-9cdf-4126-a805-a12fc2f7b865', 'Altro', 'altro', 'Package', 'Tutto il resto', '2025-12-28 22:30:01.715143+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('91240cd1-6d53-4b90-85d9-ba2ad98c9617', 'Salute e Bellezza', 'salute-bellezza', 'Heart', 'Prodotti per la cura della persona, cosmetici, profumi', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('046580b6-7bca-4cc0-87a0-4d026b8f3736', 'Attrezzature Parrucchieri', 'attrezzature-parrucchieri', 'Scissors', 'Phon, piastre, forbici, prodotti professionali per parrucchieri', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('7d85c58f-8ada-4f72-8865-f28c16c3c14f', 'Attrezzature Estetiste', 'attrezzature-estetiste', 'Sparkles', 'Lettini, lampade UV, prodotti per estetica e spa', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('6bb46382-116b-4d94-b4b4-d31cc05af5a5', 'Fotografia e Video', 'fotografia-video', 'Camera', 'Fotocamere, videocamere, obiettivi, treppiedi, accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('ea846f38-1209-4b99-861a-74090f5171be', 'Droni', 'droni', 'Plane', 'Droni per fotografia, videomaking e hobby', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('64b815df-1961-493d-b29f-5a2f9b872c9f', 'Ciclismo', 'ciclismo', 'Bike', 'Biciclette, mountain bike, accessori e ricambi', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('acf50639-95f8-4c47-abc1-f89784fa61c8', 'Fitness e Palestra', 'fitness-palestra', 'Dumbbell', 'Attrezzi palestra, pesi, tapis roulant, cyclette', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('285c43cc-9644-4b96-bffc-e334f09aeb30', 'Calcio', 'calcio', 'Trophy', 'Scarpe, palloni, abbigliamento da calcio', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d598ebd5-310e-49e7-af27-474dccf33b65', 'Tennis e Racchette', 'tennis-racchette', 'Award', 'Racchette, palloni, abbigliamento da tennis', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('15c13b14-1a42-4444-a233-353b950e8eef', 'Sport Invernali', 'sport-invernali', 'Mountain', 'Sci, snowboard, abbigliamento da neve', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('15a16cef-49d4-444c-b39d-dcfd10488401', 'Sport Acquatici', 'sport-acquatici', 'Waves', 'Surf, windsurf, kitesurf, immersioni', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d081ee4a-e5a6-4408-97bc-223b38efda02', 'Arrampicata', 'arrampicata', 'TrendingUp', 'Attrezzatura per arrampicata e alpinismo', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('2b0de97f-5a72-485c-92b5-4fc3eedf8098', 'Computer e Laptop', 'computer-laptop', 'Monitor', 'PC desktop, laptop, componenti hardware', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('8788b24d-32a3-49aa-a321-d4ea459c580b', 'Tablet', 'tablet', 'Tablet', 'Tablet di tutte le marche e accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('4565ab1c-2f80-4b6c-a209-013df72afdbb', 'Smartphone', 'smartphone', 'Smartphone', 'Cellulari nuovi e usati, accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('592207c6-42e4-47ca-9116-ae791109fb87', 'Smartwatch e Wearable', 'smartwatch-wearable', 'Watch', 'Smartwatch, fitness tracker, auricolari wireless', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('ef9a5d8a-0546-4550-adac-10807c0ec28c', 'Console e Videogiochi', 'console-videogiochi', 'Gamepad2', 'PlayStation, Xbox, Nintendo, giochi e accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('2d1dc14e-4501-48f1-a88d-94d34d6c761c', 'Software e Licenze', 'software-licenze', 'Code', 'Software, licenze, corsi online', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('81e9ffc2-0f6d-434c-b66b-950d73a74cd8', 'Networking', 'networking', 'Wifi', 'Router, switch, access point, cavi di rete', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('b712cb09-8879-435d-9dbe-0ab5781804b6', 'Stampa e Scanner', 'stampa-scanner', 'Printer', 'Stampanti, scanner, multifunzione, toner', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('a9fac84b-e686-4cae-8d81-772ff492e8ae', 'Videosorveglianza', 'videosorveglianza', 'Shield', 'Telecamere, DVR, sistemi di sicurezza', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('21abbc13-7657-4a99-ba22-8980fa335c3f', 'Elettrodomestici Grandi', 'elettrodomestici-grandi', 'Refrigerator', 'Frigoriferi, lavatrici, lavastoviglie, forni', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('56b743b9-82a5-4fae-a39c-4b0fba3b6140', 'Elettrodomestici Piccoli', 'elettrodomestici-piccoli', 'Microwave', 'Microonde, frullatori, tostapane, caffettiere', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('6d6374b0-d666-4d12-8cef-ea60aae940f0', 'Mobili Soggiorno', 'mobili-soggiorno', 'Sofa', 'Divani, poltrone, tavoli, librerie', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('4fd9b618-9c20-4cbd-b11e-f1b33397d72f', 'Mobili Camera da Letto', 'mobili-camera-letto', 'Bed', 'Letti, armadi, comodini, materassi', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('bd5a2d1d-1ad4-4280-b257-76fd58f86a69', 'Mobili Cucina', 'mobili-cucina', 'ChefHat', 'Cucine componibili, tavoli, sedie', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('b1890351-4e08-4a35-9ec2-2311d5068234', 'Illuminazione', 'illuminazione', 'Lightbulb', 'Lampadari, lampade da tavolo, faretti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d14017e3-bf9a-4d80-aec8-ed6c63dc2c25', 'Decorazione Casa', 'decorazione-casa', 'Paintbrush', 'Quadri, specchi, tende, tappeti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('629846b9-02da-4129-af1c-3d1dd5fa5f76', 'Giardinaggio', 'giardinaggio', 'TreeDeciduous', 'Piante, attrezzi da giardino, vasi, fertilizzanti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('210757ed-4678-4ce4-9040-10ba14501aa8', 'Climatizzazione', 'climatizzazione', 'Wind', 'Condizionatori, stufe, ventilatori, deumidificatori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('52e7cc28-852c-43cb-8eb3-9c3536c863a1', 'Idraulica e Riscaldamento', 'idraulica-riscaldamento', 'Droplet', 'Caldaie, termosifoni, rubinetteria', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('da5ca0c1-35c2-4d7a-8d48-9c45d1a0dba0', 'Edilizia e Materiali', 'edilizia-materiali', 'HardHat', 'Materiali da costruzione, piastrelle, sanitari', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('7b54cd56-c2b4-4e99-92ff-83938b8d428c', 'Porte e Finestre', 'porte-finestre', 'DoorOpen', 'Porte, finestre, infissi, serrande', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f538e61a-da61-4902-85b5-59121eafe739', 'Moto e Scooter', 'moto-scooter', 'Bike', 'Motociclette, scooter, ciclomotori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('87bc95d7-7b92-4739-a31f-b863be82a876', 'Camper e Roulotte', 'camper-roulotte', 'Caravan', 'Camper, caravan, accessori camping', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('95351a21-9fbb-4b15-bf29-6a13ccf2d075', 'Barche e Gommoni', 'barche-gommoni', 'Ship', 'Imbarcazioni, motori marini, accessori nautici', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d57c8ac0-dc7f-429a-9187-7eedc306fd07', 'Ricambi Auto', 'ricambi-auto', 'Wrench', 'Parti di ricambio, pneumatici, cerchi', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('24d04c68-93c6-44a3-a260-d3624c1430a8', 'Accessori Auto', 'accessori-auto', 'Navigation', 'Navigatori, portapacchi, sedili', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('b9becaeb-e226-4f0a-b2b8-0d76d4716026', 'Vendita Appartamenti', 'vendita-appartamenti', 'Building', 'Appartamenti in vendita', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('04f63ec2-038a-4dc2-9cc0-636851b9a055', 'Affitto Appartamenti', 'affitto-appartamenti', 'Home', 'Appartamenti in affitto', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('1d1c007d-2bcb-4d82-a2e1-47f60ce78f98', 'Ville e Case', 'ville-case', 'Castle', 'Ville, villette, case indipendenti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d3968c0d-910d-4e36-bdd7-668f4b1e4c43', 'Uffici e Negozi', 'uffici-negozi', 'Store', 'Locali commerciali, uffici, capannoni', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('88104897-dba6-46e1-9c61-6c1a0dd95070', 'Terreni', 'terreni', 'MapPin', 'Terreni edificabili e agricoli', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('0d00a8a2-31cf-4f2f-a06a-39e788a4a78a', 'Box e Garage', 'box-garage', 'Warehouse', 'Box auto, garage, posti auto', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('1e79e3e5-78d1-40e1-b69c-1b4abb4fb109', 'Offerte di Lavoro', 'offerte-lavoro', 'Briefcase', 'Ricerca personale e offerte di lavoro', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('ea37168c-59d0-4129-a454-5047f0ed44e4', 'Cerco Lavoro', 'cerco-lavoro', 'Search', 'Annunci di chi cerca lavoro', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('3841f5e9-76d1-46c8-8cd2-e46047a05204', 'Ripetizioni e Lezioni', 'ripetizioni-lezioni', 'GraduationCap', 'Lezioni private, corsi, ripetizioni', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('fba54889-3c53-461d-a4ff-e578275e9e6c', 'Badanti e Colf', 'badanti-colf', 'Users', 'Assistenza anziani, pulizie domestiche', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('e9a25822-d245-48dc-990a-8ce48e76b81d', 'Baby Sitter', 'baby-sitter', 'Baby', 'Servizio baby sitting', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('a40e83ba-333a-4f0d-a17c-eb7a8955b9bd', 'Traslochi', 'traslochi', 'Truck', 'Servizi di trasloco e trasporto', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f5a823ab-abe9-4e54-a0b7-57836408e7c0', 'Ristrutturazioni', 'ristrutturazioni', 'Hammer', 'Muratori, elettricisti, idraulici, imbianchini', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('adf843f7-21dc-4ac3-b8ed-75cb35fb750c', 'Pulizie', 'pulizie', 'SprayBottle', 'Servizi di pulizia casa e uffici', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('72aa8cf1-d956-4782-8a01-a697f17d37b8', 'Riparazioni', 'riparazioni', 'Tool', 'Riparazione elettrodomestici, computer, smartphone', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d7e59b5f-1498-4d9b-858d-27573f7409cf', 'Web e Marketing', 'web-marketing', 'Globe', 'Sviluppo siti web, SEO, social media marketing', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('53054966-a118-489d-8092-fb0f3a3b0e81', 'Grafica e Design', 'grafica-design', 'Palette', 'Graphic design, logo, brochure, video editing', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f55d7d96-5c51-4ddc-8995-247a57b7d7d7', 'Fotografi e Video', 'fotografi-video-servizi', 'Video', 'Servizi fotografici, videomaker, matrimoni', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('7f1a2502-b07b-4d37-ad62-8b28c290c4d8', 'Abbigliamento Uomo', 'abbigliamento-uomo', 'User', 'Vestiti, giacche, pantaloni uomo', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('fdf91d6e-35b4-45bf-9986-799c158f55f4', 'Abbigliamento Donna', 'abbigliamento-donna', 'UserSquare', 'Vestiti, gonne, camicie donna', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('a6d4cb43-1988-4c3d-a206-cad3fa12d8c5', 'Abbigliamento Bambini', 'abbigliamento-bambini', 'Users', 'Vestiti per bambini e neonati', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('b303b50b-5a38-4efc-abee-7ccb7b979d44', 'Scarpe Uomo', 'scarpe-uomo', 'Footprints', 'Scarpe da uomo, sneakers, eleganti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('8c51747f-ce97-403a-a3b4-f3942cc559a4', 'Scarpe Donna', 'scarpe-donna', 'HeartHandshake', 'Scarpe da donna, tacchi, stivali', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('2dbd10dc-ef2e-4418-838f-64e1c66e1411', 'Borse e Zaini', 'borse-zaini', 'Backpack', 'Borse, zaini, valigie, trolley', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('6d730342-db44-4938-a4c0-226110c4fb65', 'Occhiali', 'occhiali', 'Glasses', 'Occhiali da sole, da vista, montature', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('92ecdac5-7daa-4aae-b314-6b0fca08df18', 'Gioielli', 'gioielli', 'Gem', 'Anelli, collane, bracciali, orologi', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('943daa58-efa8-42d3-8a35-8e100d6454e5', 'Strumenti Musicali', 'strumenti-musicali', 'Music', 'Chitarre, pianoforti, batterie, accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('739112f6-8c46-405c-b752-fa45361e6d30', 'Vinili e CD', 'vinili-cd', 'Disc', 'Dischi in vinile, CD, collezioni musicali', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f1723f01-a37f-48ca-984a-c25519d7ee9b', 'Libri Scolastici', 'libri-scolastici', 'BookOpen', 'Libri di testo, universitari', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('bf175e39-827e-43aa-aacf-f1db8f318991', 'Libri Narrativa', 'libri-narrativa', 'Book', 'Romanzi, saggi, libri usati', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('dbf6acd6-66c3-4dd1-9b77-9fb17686bbde', 'Fumetti', 'fumetti', 'BookMarked', 'Fumetti, manga, graphic novel', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('fcfe9fe7-706e-4aad-a56e-d128f291e42e', 'Collezionismo', 'collezionismo', 'Archive', 'Francobolli, monete, oggetti da collezione', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('c724238d-c7c0-413c-8fb0-800220f25cf3', 'Modellismo', 'modellismo', 'Box', 'Modellini, trenini, aerei radiocomandati', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('028f9eee-8ba5-4a32-a64a-2b5fe2fa8cc7', 'Pesca', 'pesca', 'Fish', 'Canne da pesca, mulinelli, accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('5316e509-0296-4f35-91e8-90c612d4b608', 'Caccia', 'caccia', 'Target', 'Fucili, ottiche, abbigliamento da caccia', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d2bdb2be-cabe-4d69-a161-c0285228a4d9', 'Paintball e Softair', 'paintball-softair', 'Crosshair', 'Repliche, protezioni, accessori softair', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('fc849d8b-2c97-4d67-a192-1ea6566a084b', 'Passeggini', 'passeggini', 'Baby', 'Passeggini, trio, carrozzine', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('5ebf4eb2-81e0-4f1b-8c86-ce745963a15b', 'Seggiolini Auto', 'seggiolini-auto', 'UserCheck', 'Seggiolini per auto, omologati', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f1177c60-5df2-445a-a3c3-4c84099359c5', 'Giocattoli Prima Infanzia', 'giocattoli-prima-infanzia', 'Blocks', 'Giochi per neonati e bambini piccoli', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('8e68ecc7-7380-47ae-bfd3-b8495a8d6aa7', 'Biciclette Bambini', 'biciclette-bambini', 'Bike', 'Bici per bambini, tricicli, monopattini', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('6b1effa0-cd77-4077-86e2-31c1af17eb2d', 'Abbigliamento Premaman', 'abbigliamento-premaman', 'Heart', 'Vestiti per gravidanza', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('e631d37e-649f-4889-8d4c-d53023815368', 'Cani', 'cani', 'Dog', 'Accessori per cani, cucce, guinzagli', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('1f783ba5-ee63-40ea-a6ef-e2b7e96b89d0', 'Gatti', 'gatti', 'Cat', 'Accessori per gatti, tiragraffi, lettiere', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('dde3ba13-e8ad-4644-a948-dc3faf49b106', 'Acquari', 'acquari', 'Fish', 'Acquari, pesci, accessori acquariofilia', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('2387a149-ee57-42a8-832e-cb89e556f8b9', 'Uccelli', 'uccelli', 'Bird', 'Gabbie, mangiatoie, accessori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('45de900f-4099-4b36-be36-9296143cf568', 'Roditori', 'roditori', 'Rabbit', 'Accessori per criceti, conigli, furetti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('be3954dd-b2ae-4116-a80f-f037a8135628', 'Cavalli', 'cavalli', 'Horse', 'Selle, finimenti, abbigliamento equestre', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('6a621986-8616-4f36-9759-9a33e6c0ca9e', 'Vini', 'vini', 'Wine', 'Bottiglie di vino, collezioni, cantine', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('ac3a9007-15c6-41f9-b8cb-ffd2e6a8ff74', 'Prodotti Tipici', 'prodotti-tipici', 'Utensils', 'Prodotti gastronomici regionali', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('43786ea6-de6b-4cb0-be10-2f1058a1761e', 'Attrezzature Ristorazione', 'attrezzature-ristorazione', 'ChefHat', 'Forni, frigoriferi professionali, pentolame', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f236f6be-1a81-4985-8fbc-d6457fe49242', 'Attrezzature Edili', 'attrezzature-edili', 'HardHat', 'Ponteggi, betoniere, trapani professionali', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('fa640f18-ac7d-467f-8110-4c8e101eea52', 'Macchinari Industriali', 'macchinari-industriali', 'Factory', 'Macchinari per produzione industriale', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('61943c69-6710-45ec-b476-5910ff193e43', 'Attrezzature Agricole', 'attrezzature-agricole', 'Tractor', 'Trattori, aratri, mietitrebbie', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('3121b1c4-5654-4b15-b8b8-65f54465da33', 'Carrelli Elevatori', 'carrelli-elevatori', 'Container', 'Muletti, transpallet, sollevatori', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('8804a8be-1d1a-422b-9248-0a6c3f058688', 'Generatori', 'generatori', 'Zap', 'Generatori di corrente, gruppi elettrogeni', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('8454aeee-6bb7-46cb-bf14-98095afb1fc2', 'Compressori', 'compressori', 'Wind', 'Compressori aria, utensili pneumatici', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('749eaacb-3087-4047-aa3c-e440bdb52b72', 'Matrimoni', 'matrimoni', 'Heart', 'Servizi per matrimoni, allestimenti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('970b2d9d-2f9f-4182-9572-d7bab5c729fe', 'Feste ed Eventi', 'feste-eventi', 'PartyPopper', 'Animazione, catering, noleggio attrezzature', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('492c1823-2c59-4e2d-b3ba-a0d31a208c5e', 'Noleggio Audio Video', 'noleggio-audio-video', 'Speaker', 'Service audio, luci, impianti', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f19064df-f6e1-4fed-9568-f7211612551d', 'Pannelli Solari', 'pannelli-solari', 'Sun', 'Fotovoltaico, pannelli solari, inverter', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('898e0a03-a62c-4c70-8932-64735b8e5eda', 'Stufe a Pellet', 'stufe-pellet', 'Flame', 'Stufe e caldaie a biomassa', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('dd8bcbae-4d05-4d21-a134-70907dad0408', 'Oggetti Vintage', 'oggetti-vintage', 'Clock', 'Oggetti e mobili d''epoca', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d6942c88-02c9-476a-b287-7dcd8bf5d04c', 'Bomboniere', 'bomboniere', 'Gift', 'Bomboniere matrimonio, comunione, laurea', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('d1d2a253-3954-4f48-92b2-ea9ef774a4e4', 'Articoli Religiosi', 'articoli-religiosi', 'Church', 'Statue, icone, rosari', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('39bfbc73-21d1-4e1f-b511-a44b029885b4', 'Campeggio', 'campeggio', 'Tent', 'Tende, sacchi a pelo, materassini', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('35b7a85d-2241-40c6-9472-5b50f31e53da', 'Escursionismo', 'escursionismo', 'Mountain', 'Zaini trekking, scarponi, bastoncini', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f1fbe5a6-6c40-4b50-b741-343f8711975f', 'Biglietti e Voucher', 'biglietti-voucher', 'Ticket', 'Biglietti concerti, eventi sportivi, voucher', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('f861a48a-b547-42f7-9828-b2aa52f31e78', 'Permute', 'permute', 'ArrowLeftRight', 'Scambio oggetti senza denaro', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO classified_categories (id, name, slug, icon, description, created_at) VALUES ('62aa3b45-bee7-4cd6-b271-a93a5dba3d23', 'Gratis', 'gratis', 'Gift', 'Oggetti da regalare gratuitamente', '2025-12-29 12:54:31.543879+00') ON CONFLICT (id) DO NOTHING;


-- === FAQS (25 righe) ===
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('67b3873d-5afa-4d2e-8dfb-b6e12f6faa1b', 'Iscrizione e Account', 'Come mi iscrivo alla piattaforma?', 'Clicca su "Registrati", scegli tra account Cliente o Business, inserisci email e password. Gli account Cliente hanno 1 mese di prova gratuita, poi partono da 0,49€/mese. Gli account Business partono da 2,49€/mese + IVA dopo la prova.', 1, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('9b72635c-d114-4eab-ae52-88f56505c4d4', 'Aste', 'Chi può partecipare alle aste?', 'Tutti gli utenti autenticati possono partecipare alle aste, sia utenti privati che aziende. È necessario acquistare un ticket di partecipazione per poter fare offerte.', 1, true, '2026-04-05 16:07:05.581274+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('a8b2df87-55a7-4614-bcfa-dddf65175169', 'Iscrizione e Account', 'Qual è la differenza tra account Cliente e Business?', 'L''account Cliente è per privati che vogliono lasciare recensioni, pubblicare annunci e cercare lavoro. L''account Business è per aziende che vogliono gestire la propria attività, rispondere a recensioni, pubblicare offerte di lavoro e gestire più sedi.', 2, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('609bd9bf-0d5b-4636-beda-2f7a76f95605', 'Aste', 'Quanto costa il deposito per partecipare?', 'Il ticket è pari al 10% della base d''asta. Ad esempio: base d''asta 100 € → ticket 10 €; base 500 € → ticket 50 €. Il ticket viene trattenuto dalla piattaforma se sei il vincitore e confermi l''affare. Se perdi, il ticket viene rimborsato.', 2, true, '2026-04-05 16:07:05.581274+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('ee285fe2-6ba9-4c96-8281-38fd7cd8cff7', 'Iscrizione e Account', 'Posso avere più account sulla piattaforma?', 'No, ogni utente può avere un solo account. Tuttavia, gli account Cliente possono aggiungere fino a 4 membri della famiglia con profili separati.', 3, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('c8428239-f103-4972-a906-0469fb9acc3e', 'Aste', 'Quando viene restituito il deposito?', 'Se perdi l''asta il ticket viene rimborsato. Se vinci e confermi l''affare, il ticket resta alla piattaforma. Se vinci ma non confermi entro 48 ore, perdi il ticket e l''asta passa al secondo classificato.', 3, true, '2026-04-05 16:07:05.581274+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('9dcc0cd1-cd9e-4c73-b2d7-0a412778989a', 'Punti e Classifica', 'Come funziona il sistema dei punti?', 'Guadagni punti solo se hai un Account Cliente (privati e famiglie). Gli utenti Business non partecipano alla classifica.', 4, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('278a3910-7f4d-4344-915c-5ec356bd8372', 'Aste', 'Come faccio un''offerta?', 'Dopo aver acquistato il ticket, puoi inserire l''importo della tua offerta. L''offerta deve essere superiore all''offerta attuale o alla base d''asta. Attenzione: le offerte sono irrevocabili.', 4, true, '2026-04-05 16:07:05.581274+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('bb1cd932-17a9-4bf3-bb50-4cf40a550ecc', 'Punti e Classifica', 'Quando ricevo i punti per una recensione?', 'I punti vengono assegnati solo agli utenti con Account Cliente. Ricevi 25 punti per una recensione approvata oppure 50 punti se alleghi prove documentali.', 5, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('a7b4f639-4f89-4501-8225-06e0988d39b4', 'Aste', 'Cosa succede se vinco l''asta?', 'Se vinci l''asta, ricevi una notifica e hai 48 ore per confermare l''affare. Anche il venditore deve confermare. Se non confermi entro 48 ore, perdi il ticket e l''asta passa al secondo classificato.', 5, true, '2026-04-05 16:07:05.581274+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('ff54267f-c2f0-4984-8f42-c90c28a15e59', 'Recensioni', 'Come scrivo una recensione?', 'Cerca l''azienda, vai sulla sua pagina e clicca "Scrivi Recensione". Valuta servizio, qualità/prezzo, puntualità e disponibilità. Aggiungi un commento dettagliato (minimo 100 caratteri).', 6, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('419c3f84-b327-48c9-9974-031f314eb0d8', 'Aste', 'La piattaforma gestisce i pagamenti?', 'No, la piattaforma NON gestisce pagamenti o spedizioni. Le transazioni avvengono direttamente tra venditore e acquirente.', 6, true, '2026-04-05 16:07:05.581274+00', '2026-04-05 16:07:05.581274+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('5e3bbd10-f842-4dbc-a53c-489c11fa1a85', 'Recensioni', 'Posso modificare una recensione dopo averla pubblicata?', 'No, una volta pubblicata la recensione non può essere modificata. Se hai commesso un errore, contatta il supporto.', 7, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('3dd4069a-7f26-436b-9685-7b2ebcebc253', 'Aste', 'Come confermare la conclusione della transazione?', 'Dopo la chiusura dell''asta, sia venditore che acquirente devono premere il pulsante "Conferma Affare". Avete 48 ore per farlo.', 7, true, '2026-04-05 16:07:05.581274+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('59f00e89-5bfe-4a87-87c8-b1b570160139', 'Annunci', 'Quanti annunci gratuiti posso pubblicare?', 'Puoi pubblicare fino a 20 annunci contemporaneamente. Gli annunci scadono dopo 30 giorni ma possono essere rinnovati gratuitamente.', 8, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('993f87ec-86b4-4772-9a51-05ddbb8eda19', 'Aste', 'Posso annullare un''asta?', 'Puoi eliminare un''asta solo se non ci sono ancora offerte. Una volta che qualcuno ha fatto un''offerta, l''asta non può più essere annullata.', 8, true, '2026-04-05 16:07:05.581274+00', '2026-04-05 16:07:05.581274+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('4817aa20-d6eb-4d43-a380-8c1f891a9f26', 'Lavoro', 'Come funziona la ricerca di lavoro?', 'Crea un profilo "Cerca Lavoro" con le tue competenze, esperienza e CV. Le aziende possono vedere il tuo profilo e contattarti direttamente.', 9, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('4efebd10-eca9-4de1-b87c-26cb43228530', 'Aste', 'Posso creare aste come azienda?', 'Sì, anche le aziende possono creare e partecipare alle aste. Il sistema è aperto a tutti gli utenti autenticati.', 9, true, '2026-04-05 16:07:05.581274+00', '2026-04-05 16:07:05.581274+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('844660cd-7c07-4e9f-ba36-06a5eacf3337', 'Aziende', 'Come rivendico la mia azienda?', 'Registrati come account Business, cerca la tua azienda nel database e clicca "Rivendica". Fornisci Partita IVA, Codice Fiscale, Codice Univoco SDI, PEC e Codice ATECO. La verifica richiede 24-48 ore.', 10, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('64f63545-9264-4df2-ade9-e8a136591682', 'Aste', 'Posso ritirare la mia offerta?', 'No, le offerte sono assolutamente irrevocabili. Una volta inviata un''offerta non è possibile ritirarla in nessun caso.', 10, true, '2026-05-07 12:42:52.00928+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('80b96d2f-e837-4921-ae82-d5a55c779333', 'Abbonamenti', 'Quali sono i piani di abbonamento?', 'Per Clienti: da 0,49€/mese (1 persona) a 1,49€/mese (4 persone). Per Business: da 2,49€/mese + IVA (1 sede) a tariffe personalizzate per 10+ sedi.', 11, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('77043a23-bf52-4057-8481-05ebf564afc1', 'Aste', 'Cosa succede se il vincitore non conferma entro 48 ore?', 'Se il vincitore non conferma entro 48 ore, perde il ticket e l''asta passa al secondo classificato, che ha a sua volta 48 ore per confermare.', 11, true, '2026-05-07 12:42:52.00928+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('0eea0a6e-f305-46ff-b2b2-d64dc90da916', 'Privacy e Sicurezza', 'I miei dati sono al sicuro?', 'Sì, trattiamo i dati in conformità al GDPR. I dati vengono usati solo per i servizi della piattaforma e non vengono condivisi con terze parti senza consenso.', 12, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('2e1ae9ea-f87b-4215-b490-1f668de29084', 'Aste', 'Come funziona il ticket di partecipazione?', 'Il ticket è pari al 10% della base d''asta. Se non vinci, il ticket viene rimborsato. Se vinci e confermi l''affare, il ticket viene trattenuto dalla piattaforma.', 12, true, '2026-05-07 12:42:52.00928+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('0d8c37dc-5cfe-4239-8422-cf886167cf2c', 'Generale', 'Come segnalo contenuti inappropriati?', 'Usa il pulsante "Segnala" presente su recensioni, annunci e profili. Il nostro team esaminerà la segnalazione entro 24-48 ore. Le segnalazioni sono anonime.', 13, true, '2026-03-05 22:45:13.989227+00', '2026-03-05 22:45:13.989227+00') ON CONFLICT (id) DO NOTHING;
INSERT INTO faqs (id, category, question, answer, display_order, is_active, created_at, updated_at) VALUES ('086d18da-293c-450a-9e66-43ebd4d4945a', 'Aste', 'Cosa succede se nessun vincitore conferma?', 'Se nessun partecipante conferma l''affare, l''asta si chiude definitivamente senza conclusione. Il venditore riceve una notifica.', 13, true, '2026-05-07 12:42:52.00928+00', '2026-05-07 12:42:52.00928+00') ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- TABLE: rules_content (20 rows)
-- ============================================================
INSERT INTO rules_content (id, section_key, section_title, content_text, display_order, is_active) VALUES
('2b76a469-0208-4c79-a458-3b0f3a649dc7','intro','Introduzione','Benvenuto in TrovaFacile! Questa guida completa ti aiuterà a comprendere tutte le funzionalità della piattaforma, le regole da seguire e come sfruttare al meglio tutti i servizi disponibili.',1,true),
('9c4b181e-3c0a-459e-9ffb-b7e7d0340279','getting_started','Come Iniziare - Registrazione','Passo 1: Clicca su "Accedi" o "Inizia Gratis"
Passo 2: Scegli il tipo di account (Cliente per privati o Business per aziende)
Passo 3: Inserisci email, password e completa la registrazione
Passo 4: Attiva la prova gratuita di 1 mese (nessuna carta richiesta)

IMPORTANTE: Riceverai un promemoria via email 7 giorni prima della scadenza della prova. Se non rinnovi, l''abbonamento termina automaticamente senza addebiti.',2,true),
('d9a77cfd-edb7-42ac-b8a4-49221a0d6d83','account_cliente','Account Cliente - Caratteristiche','L''Account Cliente è perfetto per privati e famiglie. Include:
- Fino a 4 membri della famiglia con profili separati
- Scrivi recensioni e guadagna punti
- Pubblica fino a 20 annunci gratuiti contemporaneamente
- Cerca lavoro per te e i tuoi familiari
- Il 10% del fatturato annuale della piattaforma viene donato in beneficienza
- Prezzo: da 0,49€/mese dopo 1 mese di prova gratuita',3,true),
('260411b7-f35d-453a-b4ae-b92d13ac56a2','reviews_rules','Recensioni - Regole Fondamentali','REGOLA PRINCIPALE: Puoi recensire la stessa azienda UNA SOLA VOLTA ALL''ANNO. Questo garantisce recensioni fresche e autentiche.

REQUISITO MINIMO: La descrizione deve contenere ALMENO 100 CARATTERI. Recensioni troppo brevi non verranno accettate.

Come Scrivere una Recensione:
1. Cerca l''azienda o il servizio che vuoi recensire
2. Clicca sulla scheda dell''azienda
3. Clicca su "Scrivi una Recensione"
4. Valuta 4 aspetti con stelle da 1 a 5:
- Qualità del prodotto o servizio
- Rapporto qualità/prezzo
- Esperienza complessiva e servizio ricevuto
- Voto generale
5. IMPORTANTE: Scrivi una descrizione dettagliata di almeno 100 caratteri
6. OPZIONALE: Carica una prova (scontrino, fattura, foto) per ricevere 50 punti invece di 25',4,true),
('755ed244-b1c4-4fa7-9c72-9d9c5b8b3f44','reviews_points','Recensioni - Sistema Punti','PUNTI PER RECENSIONI:
- 25 punti: per ogni recensione approvata (minimo 100 caratteri)
- 50 punti: per recensioni con prova documentale + Badge "Verificata"
- Le recensioni vengono verificate entro 7 giorni
- I punti vengono assegnati solo dopo l''approvazione
- Recensioni false = perdita punti e sospensione account

COSA NON FARE:
❌ Non lasciare recensioni false o inventate
❌ Non scrivere recensioni troppo brevi (minimo 100 caratteri)
❌ Non usare linguaggio offensivo o diffamatorio
❌ Non recensire la stessa azienda più di una volta all''anno
❌ Non chiedere/offrire compensi per recensioni positive',5,true)
ON CONFLICT (id) DO UPDATE SET section_key=EXCLUDED.section_key, section_title=EXCLUDED.section_title, content_text=EXCLUDED.content_text, display_order=EXCLUDED.display_order, is_active=EXCLUDED.is_active;

INSERT INTO rules_content (id, section_key, section_title, content_text, display_order, is_active) VALUES
('f7cb1080-f2cb-49b9-a467-8e49e357194f','classified_ads','Annunci Gratuiti','Pubblica annunci per vendere, comprare, scambiare o regalare oggetti.

TIPI DI ANNUNCIO:
Vendita | Acquisto | Scambio | Regalo

REGOLE IMPORTANTI:
✅ Massimo 20 annunci attivi contemporaneamente
✅ Ogni annuncio dura 30 giorni (rinnovabili gratis)
✅ Gli utenti con Account Cliente guadagnano 5 punti per ogni annuncio approvato
⚠️ Gli utenti Business non ricevono punti (non partecipano alla classifica)
⚠️ La ripubblicazione dopo la scadenza non comporta ulteriori punti
✅ Usa la messaggistica interna per le trattative
✅ Incontra sempre in luoghi pubblici per la consegna

PRODOTTI VIETATI:
❌ Armi e munizioni | ❌ Droga e sostanze | ❌ Prodotti contraffatti
❌ Tabacco e sigarette | ❌ Farmaci | ❌ Documenti falsi
❌ Animali protetti | ❌ Fuochi d''artificio

SANZIONE: Rimozione immediata + Sospensione account',6,true),
('64358d39-cb5a-4e4f-ba2f-025c156961e8','job_search','Cerca Lavoro','Crea profili di ricerca lavoro per te e fino a 4 membri della tua famiglia. Le aziende potranno trovarti e contattarti direttamente.

COME FUNZIONA:
1. Vai nella sezione "Lavoro" o nel tuo Profilo
2. Clicca su "Crea Profilo Cerca Lavoro"
3. Seleziona per chi (te stesso o un membro della famiglia)
4. Inserisci: categoria, titolo di studio, esperienza, competenze, zona
5. Pubblica il profilo - è visibile alle aziende

RISPONDERE AGLI ANNUNCI:
• Cerca annunci nella sezione "Lavoro"
• Filtra per categoria, città e livello di esperienza
• Clicca su "Candidati" per rispondere
• Le aziende riceveranno il tuo profilo e ti contatteranno

PRIVACY E SICUREZZA:
✓ Il cognome completo non è mai visibile pubblicamente
✓ Email e telefono visibili solo dopo che rispondi
✓ Puoi nascondere il profilo in qualsiasi momento
✓ Segnala immediatamente offerte sospette',7,true),
('c3edaf37-ac65-466f-92f7-86b2846141ee','points_system','Sistema Punti e Classifica','Guadagna punti per ogni attività sulla piattaforma e scala la classifica mensile per vincere premi e badge esclusivi.

NOTA: Il sistema punti e la classifica sono riservati agli utenti con Account Cliente (privati e famiglie). Gli utenti Business non partecipano alla classifica.

COME GUADAGNARE PUNTI (solo Account Cliente):
⭐ Recensione con prova documentale allegata = +50 punti + Badge "Verificata"
👥 Presenta un amico che si abbona = +30 punti
⭐ Recensione approvata (senza prova) = +25 punti
🏪 Inserimento attività completa (con sito, email o telefono) = +25 punti
🔨 Pubblicazione di un''asta approvata = +15 punti
🏪 Inserimento attività base (nome e indirizzo) = +10 punti
📝 Pubblicazione annuncio approvato = +5 punti

BADGE E LIVELLI:
🎯 Nuovo Arrivato: 0 punti
🥉 Principiante: 100+ punti
🔍 Esploratore: 300+ punti
🥈 Veterano: 800+ punti
🥇 Maestro: 2500+ punti
👑 Leggenda: 5000+ punti

REGOLE DELLA CLASSIFICA:
• La classifica si azzera ogni anno il 1° gennaio
• I badge e i premi restano permanentemente nel profilo
• Comportamenti scorretti = perdita di tutti i punti
• Recensioni false o spam comportano sospensione',8,true)
ON CONFLICT (id) DO UPDATE SET section_key=EXCLUDED.section_key, section_title=EXCLUDED.section_title, content_text=EXCLUDED.content_text, display_order=EXCLUDED.display_order, is_active=EXCLUDED.is_active;

INSERT INTO rules_content (id, section_key, section_title, content_text, display_order, is_active) VALUES
('0b1cc4a4-7991-4ed5-bbe4-22399927242c','solidarity','Solidarietà TrovaFacile','In TrovaFacile crediamo fermamente nel valore della solidarietà e nel dare un contributo concreto alla nostra comunità.

IL NOSTRO IMPEGNO:
Ci impegniamo a donare il 10% DEL NOSTRO FATTURATO ANNUALE a organizzazioni no profit, enti di beneficenza e progetti sociali che fanno la differenza.

SCELTA DEMOCRATICA:
La scelta degli enti destinatari viene effettuata democraticamente dagli utenti attraverso un sondaggio annuale.
• Ogni anno proponiamo una lista di enti verificati
• Ogni utente abbonato può votare fino a 3 enti
• Gli enti più votati riceveranno una quota del 10%
• La distribuzione avviene in base alle percentuali di voto
• Tutti i risultati vengono pubblicati in trasparenza

TRASPARENZA TOTALE:
Pubblichiamo regolarmente:
• Documenti ufficiali del fatturato aziendale
• Ricevute delle donazioni effettuate
• Contatori in tempo reale del fatturato e fondo solidarietà
• Statistiche complete sugli abbonamenti attivi
• Informazioni sui destinatari e impatto delle donazioni

NOTA: I contatori saranno a zero per il primo mese perché la prova è gratuita. Si aggiorneranno con l''arrivo dei primi abbonamenti a pagamento.',9,true),
('63c85f88-3864-4af6-b1d0-0d714f300d36','auctions','Sistema Aste','## Come Funzionano le Aste

Le aste su Trovafacile permettono a tutti gli utenti (privati e aziende) di vendere e acquistare oggetti attraverso un sistema di offerte competitive.

### Creazione Asta
- Ogni utente autenticato può creare un''asta
- È necessario fornire: titolo, descrizione, immagini, base d''asta, categoria, condizioni e località
- La durata dell''asta può essere da 1 a 14 giorni
- Le aste richiedono l''approvazione dell''amministratore prima di diventare visibili
- ✅ Guadagni 15 punti per ogni asta approvata e pubblicata

### Ticket di Partecipazione
- Per partecipare a un''asta è necessario acquistare un **ticket pari al 10% della base d''asta**
- Esempio: base d''asta 200 € → ticket 20 €; base 500 € → ticket 50 €
- Il ticket viene trattenuto dalla piattaforma se l''acquirente vincitore conferma l''affare
- Se perdi l''asta, il ticket ti viene rimborsato
- Se vinci ma **non confermi entro 48 ore**, il ticket viene **trattenuto** e l''asta passa al classificato successivo

### Offerte — Regola Fondamentale
- Le offerte sono **irrevocabili**: una volta inviata un''offerta, non è possibile ritirarla
- Le offerte devono essere superiori all''offerta attuale (o alla base d''asta se non ci sono offerte)
- Chi fa l''offerta più alta alla scadenza è il vincitore provvisorio

### Conclusione Asta
- L''asta termina automaticamente alla scadenza
- Il vincitore (chi ha fatto l''offerta più alta) riceve una notifica e ha **48 ore** per confermare l''affare
- Anche il venditore deve confermare entro le stesse 48 ore
- La transazione si considera conclusa quando **entrambe le parti** premono il pulsante "Conferma Affare"

### Scalabilità dei Vincitori
- Se il vincitore **non conferma entro 48 ore**, perde il ticket e l''asta passa automaticamente al **secondo classificato**
- Il secondo classificato riceve una notifica e ha a sua volta 48 ore per confermare
- Questo meccanismo continua fino a che qualcuno conferma o non ci sono più partecipanti disponibili
- In quest''ultimo caso l''asta si chiude definitivamente senza conclusione

### Responsabilità
- La piattaforma NON gestisce pagamenti o spedizioni: le transazioni avvengono direttamente tra venditore e acquirente
- Si consiglia di utilizzare metodi di pagamento sicuri e tracciabili
- La piattaforma non ha alcuna responsabilità sulle transazioni tra utenti',10,true),
('003d55fc-5caa-48b8-aa09-1b9a3aa80c78','business_account','Account Business - Guida Aziende','L''Account Business è per aziende che vogliono gestire la propria presenza online.

CARATTERISTICHE:
✓ Rivendica e gestisci la tua azienda
✓ Gestisci più sedi e punti vendita
✓ Rispondi alle recensioni
✓ Pubblica annunci di lavoro illimitati
✓ Crea offerte e sconti esclusivi
✓ Il 10% del fatturato annuale della piattaforma viene donato in beneficienza
✓ Prezzo: da 2,49€/mese + IVA dopo 1 mese di prova

RIVENDICARE LA TUA AZIENDA:
1. Registra un account Business
2. Cerca la tua azienda (o creala se non c''è)
3. Clicca su "Rivendica Questa Attività"
4. Fornisci: Partita IVA, Codice Fiscale, Codice Univoco SDI, PEC, Codice ATECO
5. Attendi verifica (24-48 ore)
6. Ricevi conferma via email',10,true)
ON CONFLICT (id) DO UPDATE SET section_key=EXCLUDED.section_key, section_title=EXCLUDED.section_title, content_text=EXCLUDED.content_text, display_order=EXCLUDED.display_order, is_active=EXCLUDED.is_active;

INSERT INTO rules_content (id, section_key, section_title, content_text, display_order, is_active) VALUES
('e52d9222-ec7d-4190-9cf1-8583f89669de','business_locations','Gestione Sedi Multiple','Se hai più punti vendita, negozi o uffici, puoi gestirli tutti da un unico account.

PER OGNI SEDE PUOI:
✓ Impostare indirizzo e contatti specifici
✓ Configurare orari di apertura diversi
✓ Caricare foto e logo personalizzati
✓ Aggiungere descrizione e servizi offerti
✓ Visualizzare recensioni specifiche
✓ Gestire annunci di lavoro per sede

COSTI:
Mensile: da 2,49€ (1 sede) a 14,99€ (10+ sedi)
Annuale: da 24,90€ (1 sede) a 149,90€ (10+ sedi)
Tutti i prezzi + IVA',11,true),
('1fa24ae5-dc2e-4c4d-80ef-0a2fac0fd4b9','business_reviews_management','Gestione Recensioni Aziende','Le recensioni sono fondamentali per la reputazione online. Gestiscile in modo professionale.

COME RISPONDERE:
1. Accedi alla Dashboard
2. Vai su "Recensioni"
3. Clicca "Rispondi" sotto la recensione
4. Scrivi una risposta professionale
5. La risposta sarà visibile pubblicamente

BUONE PRATICHE:
✓ Rispondi sempre, anche alle recensioni negative
✓ Ringrazia i clienti per le recensioni positive
✓ Offri soluzioni concrete per i problemi
✓ Mantieni un tono professionale e cortese
✓ Non essere mai difensivo o aggressivo
✓ Usa le recensioni per migliorare il servizio

COSA NON FARE:
❌ Non minacciare o insultare i clienti
❌ Non chiedere di rimuovere recensioni negative
❌ Non offrire compensi per recensioni positive
❌ Non creare account falsi per recensirti
❌ Non rivelare informazioni private dei clienti',12,true),
('276f6d6e-cd92-4342-bd50-3657daf57f22','forbidden_behaviors','Comportamenti Vietati','ACCOUNT E IDENTITÀ:
❌ Creare account multipli
❌ Fingere di essere qualcun altro
❌ Usare bot o script automatici
❌ Vendere o cedere il proprio account
❌ Condividere credenziali di accesso

CONTENUTI:
❌ Linguaggio offensivo, discriminatorio
❌ Contenuti violenti o espliciti
❌ Spam e pubblicità ingannevole
❌ Informazioni false o diffamatorie
❌ Violazione copyright altrui

RECENSIONI:
❌ Recensioni false o inventate
❌ Vendere/comprare recensioni
❌ Recensire se stessi
❌ Recensioni su concorrenti
❌ Minacce o estorsioni

TRANSAZIONI:
❌ Truffe e frodi
❌ Vendere prodotti vietati/illegali
❌ Evasione fiscale
❌ Riciclaggio di denaro
❌ Schemi piramidali

SANZIONI: Rimozione contenuti, perdita punti, sospensione temporanea o permanente, segnalazione alle autorità per reati penali.',13,true),
('3d03d9b6-6f53-4754-8db4-14d416eabf0c','moderation','Moderazione e Segnalazioni','TrovaFacile mantiene un ambiente sicuro e rispettoso per tutti.

COME SEGNALARE:
1. Clicca sul pulsante "Segnala" su recensioni, annunci e profili
2. Seleziona il motivo della segnalazione
3. Aggiungi dettagli opzionali
4. Invia - il team esaminerà entro 24-48 ore

GARANZIE:
✓ Le segnalazioni sono completamente anonime
✓ Vengono prese molto sul serio
✓ Risposta rapida del team di moderazione
✓ Zero tolleranza per abusi gravi',14,true)
ON CONFLICT (id) DO UPDATE SET section_key=EXCLUDED.section_key, section_title=EXCLUDED.section_title, content_text=EXCLUDED.content_text, display_order=EXCLUDED.display_order, is_active=EXCLUDED.is_active;

INSERT INTO rules_content (id, section_key, section_title, content_text, display_order, is_active) VALUES
('9ea8c6ef-f977-4906-8989-202b2cf9c723','approval_times','Tempi di Approvazione - Regola delle 48 Ore','Tutti i contenuti pubblicati sulla piattaforma sono soggetti a moderazione da parte del team di Trovafacile prima di essere visibili pubblicamente. Il team amministrativo ha un massimo di 48 ore di tempo per esaminare ogni contenuto e decidere se approvarlo o rifiutarlo.

CONTENUTI SOGGETTI ALLA REGOLA DELLE 48 ORE:

1. RECENSIONI (con o senza prova)
Ogni recensione inviata da un utente — sia quella semplice che quella accompagnata da prova fotografica o documentale — viene esaminata entro 48 ore dall''invio. L''admin valuta la veridicità, la pertinenza e il rispetto delle regole della community. La recensione rimane in stato "in attesa" fino all''approvazione o al rifiuto.

2. ASTE
Ogni asta pubblicata da un utente viene sottoposta a verifica entro 48 ore. L''admin controlla che l''oggetto o il servizio messo all''asta sia reale, lecito e conforme alle regole della piattaforma. Solo dopo l''approvazione l''asta diventa visibile e attiva per le offerte.

3. ANNUNCI DI LAVORO
Le offerte e le ricerche di lavoro pubblicate dalle aziende o dagli utenti vengono esaminate entro 48 ore. L''admin verifica che la posizione sia reale, che il contenuto sia chiaro e che non vi siano elementi fuorvianti o non conformi.

4. ANNUNCI (VENDITA, REGALO, CERCO)
Tutti gli annunci nella sezione Annunci — che si tratti di oggetti in vendita, oggetti in regalo o richieste di articoli — vengono verificati entro 48 ore. L''admin controlla che il contenuto sia autentico, legale e rispettoso delle regole della community.

5. ATTIVITA'' AGGIUNTE DAGLI UTENTI
Quando un utente segnala o aggiunge una nuova attività commerciale non ancora presente nel database di Trovafacile, la segnalazione viene esaminata entro 48 ore. L''admin verifica che l''attività esista realmente, che le informazioni siano corrette e che non si tratti di un duplicato.

COSA SUCCEDE DOPO LE 48 ORE:

• Se il contenuto viene APPROVATO: diventa immediatamente visibile sulla piattaforma. L''utente riceve una notifica di approvazione.
• Se il contenuto viene RIFIUTATO: l''utente riceve una notifica con la motivazione del rifiuto. Il contenuto non viene pubblicato.
• In caso di MANCATA RISPOSTA entro 48 ore: l''utente può contattare il supporto a supporto@trovafacile.it per richiedere aggiornamenti sullo stato della propria richiesta.

Trovafacile si impegna a rispettare questi tempi per garantire un servizio equo e trasparente a tutti gli utenti.',15,true),
('cf4a02a0-d245-4908-8fb3-06043fe2c436','terms_conditions','Termini e Condizioni','1. OGGETTO DEL SERVIZIO
TrovaFacile è una piattaforma digitale che offre servizi di marketplace, recensioni, annunci classificati e opportunità di lavoro sul territorio italiano. L''utilizzo comporta l''accettazione integrale dei presenti Termini.

2. REGISTRAZIONE E ACCOUNT
• Riservata a maggiorenni e persone giuridiche
• Vietato creare account multipli
• L''utente è responsabile delle credenziali
• TrovaFacile può sospendere account che violano i termini

3. LIMITAZIONI DI RESPONSABILITÀ
• TrovaFacile agisce come intermediario
• Non garantiamo accuratezza dei contenuti degli utenti
• Non siamo responsabili per transazioni tra utenti
• Non garantiamo disponibilità ininterrotta del servizio

4. PROPRIETÀ INTELLETTUALE
Tutti i contenuti del sito (design, loghi, software) sono proprietà di TrovaFacile e protetti dalle leggi sul diritto d''autore. Gli utenti mantengono la proprietà dei contenuti pubblicati ma concedono a TrovaFacile una licenza per utilizzarli nell''ambito del servizio.

5. LEGGE APPLICABILE
I presenti Termini sono regolati dalla legge italiana. Per controversie è competente il Foro del luogo di residenza del consumatore, ai sensi del D.Lgs. 206/2005 (Codice del Consumo).',16,true),
('fd20540a-ad2d-44bf-8ccc-2adc63c9c60b','privacy_gdpr','Privacy Policy e GDPR','Ai sensi dell''art. 13 del Regolamento UE 2016/679 (GDPR):

TITOLARE DEL TRATTAMENTO: TrovaFacile S.r.l. - Email: privacy@trovafacile.it

DATI TRATTATI:
• Dati anagrafici: nome, cognome, data di nascita
• Dati di contatto: email, telefono, indirizzo
• Dati di navigazione: IP, browser, pagine visitate
• Dati business: P.IVA, C.F., PEC, ATECO (solo aziende)
• Contenuti: recensioni, annunci, messaggi, foto
• Dati di pagamento: gestiti da Stripe (non conservati da noi)

FINALITÀ:
• Erogazione dei servizi della piattaforma
• Gestione registrazione e autenticazione
• Gestione abbonamenti e pagamenti
• Verifica identità aziende
• Moderazione contenuti
• Assistenza clienti
• Obblighi legali, contabili e fiscali

DIRITTI DELL''INTERESSATO (artt. 15-22 GDPR):
• Accesso: ottenere copia dei dati
• Rettifica: correggere dati inesatti
• Cancellazione: richiedere eliminazione
• Limitazione: limitare il trattamento
• Portabilità: ricevere dati in formato strutturato
• Opposizione: opporsi al trattamento
• Revoca consenso: in qualsiasi momento

Per esercitare i diritti: privacy@trovafacile.it

SICUREZZA:
Adottiamo misure tecniche e organizzative per proteggere i dati. Le password sono crittografate. I dati sensibili sono conservati su server sicuri nell''UE.',17,true)
ON CONFLICT (id) DO UPDATE SET section_key=EXCLUDED.section_key, section_title=EXCLUDED.section_title, content_text=EXCLUDED.content_text, display_order=EXCLUDED.display_order, is_active=EXCLUDED.is_active;

INSERT INTO rules_content (id, section_key, section_title, content_text, display_order, is_active) VALUES
('184ab208-f31f-45ed-a2cb-c65a1c10af68','subscriptions','Abbonamenti e Prezzi','TUTTI I PIANI INCLUDONO:
✓ 1 mese di prova gratuita (nessuna carta richiesta)
✓ Tutte le funzionalità della piattaforma
✓ Il 10% del fatturato annuale della piattaforma viene donato in beneficienza
✓ Nessun vincolo, disdici quando vuoi
✓ Promemoria 7 giorni prima della scadenza della prova

CLIENTI - ABBONAMENTO MENSILE:
€0,49/mese (1 persona) | €0,79/mese (2 persone)
€0,99/mese (3 persone) | €1,49/mese (4 persone)

CLIENTI - ABBONAMENTO ANNUALE:
€4,90/anno (1 persona) | €7,90/anno (2 persone)
€9,90/anno (3 persone) | €14,90/anno (4 persone)

BUSINESS - ABBONAMENTO MENSILE + IVA:
€2,49/mese (1 sede) | €3,99/mese (2 sedi) | €5,49/mese (3 sedi)
€7,99/mese (4 sedi) | €9,99/mese (5 sedi) | €12,99/mese (6-10 sedi)
€14,99/mese (10+ sedi)

BUSINESS - ABBONAMENTO ANNUALE + IVA:
€24,90/anno (1 sede) | €39,90/anno (2 sedi) | €54,90/anno (3 sedi)
€79,90/anno (4 sedi) | €99,90/anno (5 sedi) | €129,90/anno (6-10 sedi)
€149,90/anno (10+ sedi)',18,true),
('c40c0d6a-8c7e-4032-9e17-ca7db9f4fefa','refund_policy','Diritto di Recesso','Ai sensi degli artt. 52-59 del D.Lgs. 206/2005 (Codice del Consumo), hai diritto di recedere dall''abbonamento entro 14 giorni dalla sottoscrizione senza motivazione.

COME ESERCITARE IL DIRITTO:
1. Invia comunicazione a: recesso@trovafacile.it
2. Indica: nome, email, numero abbonamento, data sottoscrizione
3. Riceverai conferma entro 48 ore
4. Rimborso entro 14 giorni sulla stessa modalità di pagamento

ECCEZIONI:
Ai sensi dell''art. 59, il diritto di recesso è escluso per servizi già completamente eseguiti con consenso espresso del consumatore.',19,true),
('7d8886b4-a92a-4253-b08c-2ce5f3a6adc4','contact_support','Contatti e Supporto','Per reclami, assistenza o controversie:

EMAIL: supporto@trovafacile.it
PEC: trovafacile@pec.it
TEMPI DI RISPOSTA: 7 giorni lavorativi

PIATTAFORMA ODR:
Ai sensi del Regolamento UE 524/2013, i consumatori possono utilizzare la piattaforma europea per la risoluzione online delle controversie: https://ec.europa.eu/consumers/odr

MODIFICHE AL REGOLAMENTO:
TrovaFacile si riserva il diritto di modificare il presente regolamento. Le modifiche saranno comunicate via email e pubblicate su questa pagina. L''utilizzo continuato dopo le modifiche costituisce accettazione.

Ultimo aggiornamento: 6 Marzo 2026',20,true)
ON CONFLICT (id) DO UPDATE SET section_key=EXCLUDED.section_key, section_title=EXCLUDED.section_title, content_text=EXCLUDED.content_text, display_order=EXCLUDED.display_order, is_active=EXCLUDED.is_active;


-- ============================================================
-- TABLE: business_categories (230 rows)
-- ============================================================
INSERT INTO business_categories (id, name, slug, description, ateco_code) VALUES
('7294b7d7-bbcf-4d0a-8055-8010c5ebac1c','Abbigliamento','abbigliamento','Negozi di abbigliamento',NULL),
('cd121f3a-9288-49ef-8e71-c30e4188716f','Agenzie del Lavoro','agenzie-del-lavoro','Agenzie del lavoro',NULL),
('6d84119f-7123-4c18-9597-19e798a95715','Agenzie di Viaggio','agenzie-di-viaggio','Agenzie di viaggio',NULL),
('166c9e4c-a3e2-4f86-b2fc-36a64345d108','Agenzie Immobiliari','agenzie-immobiliari','Agenzie immobiliari',NULL),
('60890ca2-2f7b-4862-b9ab-955346c29ebe','Agenzie Pubblicitarie','agenzie-pubblicitarie','Agenzie pubblicitarie',NULL),
('86d6e23f-29c0-4b53-a8a7-3646045a6612','Alimentari','alimentari','Negozi di alimentari',NULL),
('0f5ff27a-ed05-4bc7-abf5-40d7e016fffc','Animali','animali','Negozi di animali e accessori per animali',NULL),
('812cd60b-614a-4960-a1cb-50ddef52651b','Antiquari','antiquari','Antiquari',NULL),
('d218cd82-9f0a-4b4e-ae31-2c32a441cd4c','Apicoltori','apicoltori','Apicoltori',NULL),
('fa6285a8-2cd5-41a6-92cb-1d34ba8ccd61','Apparecchi Acustici','apparecchi-acustici','Negozi di apparecchi acustici',NULL),
('a4de9224-0e85-49b3-b43d-9d081257362b','Appartamenti','appartamenti','Appartamenti turistici',NULL),
('dbf42de1-b32a-452f-a8ef-121e45c031c7','Architetti','architetti','',NULL),
('8448bd8d-e055-4b95-b2f9-f60ef3b37e40','Aree Camper','aree-camper','Aree sosta camper',NULL),
('90df8b25-0999-405f-9bdf-47fcb425987c','Armerie','armerie','Armerie',NULL),
('218f101f-8726-4f41-ad5d-447650424dc6','Arredamento','arredamento','Negozi di arredamento',NULL),
('5ab38487-4ff8-4632-a517-e18552ca0fdd','Arredo Bagno','arredo-bagno','Arredo bagno',NULL),
('7202201e-8550-4270-81b2-7e919d55bd70','Arti Marziali','arti-marziali','Palestre di arti marziali',NULL),
('df86e69f-5167-4e68-a61b-4f790601c940','Articoli da Regalo','articoli-da-regalo','Negozi di regali e articoli da regalo',NULL),
('c8418605-37fd-42c7-a85f-43c5bf7db038','Articoli in Pelle','articoli-in-pelle','Articoli in pelle',NULL),
('c694adbf-b1ce-4c0c-a47b-9dd3107fe4c0','Articoli per Bambini','articoli-per-bambini','Articoli per bambini',NULL),
('222a0014-ca91-491e-a979-20f6906b4111','Articoli Sportivi','articoli-sportivi','Negozi di attrezzature sportive',NULL),
('c718671f-029a-4fe3-9043-9f2796d09ae7','Asili','asili','Asili nido e scuole materne',NULL),
('e7154f03-24f1-44d4-9a46-da08d96ea923','Assicurazioni','assicurazioni','',NULL),
('f0825c84-0ae3-4db2-a22e-d4287b9c72ee','Associazioni','associazioni','Associazioni',NULL),
('f22b70c8-428a-4ff0-970a-4016159618a6','Autofficine','autofficine','Autofficine e meccanici',NULL),
('3ff669f7-689a-4ec9-927d-098ae304a932','Autolavaggi','autolavaggi','',NULL),
('8156f8c0-96c3-427d-9350-912ce6ca35b8','Autonoleggi','autonoleggi','Autonoleggi',NULL),
('7959de58-da45-4779-9dec-12ae07633df1','Autoscuole','autoscuole','Autoscuole',NULL),
('8568ec3e-9b4b-4590-95f8-0afa5bbe0eb7','Avvocati','avvocati','Studi legali',NULL),
('f8df00d1-707c-4ec7-9f01-dec276d8ba24','Aziende','aziende','Società e uffici aziendali',NULL),
('50c23c76-b85c-4d74-8805-1d7f69180eb4','B&B','bnb','',NULL),
('cb0f313a-2007-4277-bd16-25a582cf07b7','Banche','banche','Istituti bancari',NULL),
('72c8e838-4e9a-4082-ae44-a2f48866b71f','Bancomat','bancomat','Bancomat e sportelli automatici',NULL),
('e3687213-9ec5-46bc-a326-ec73df9d8fa4','Bar e Caffè','bar-e-caffe','Bar, caffè e pasticcerie',NULL),
('fce14c21-3092-45bc-9701-0fc5ec5031f1','Bazar','bazar','Bazar e articoli vari',NULL),
('e6aca334-cad2-4ce5-bdfc-3837822cd550','Benzinai','benzinai','',NULL),
('f5fd5cb7-ef9b-4f65-924e-d2f347b01d43','Biblioteche','biblioteche','Biblioteche',NULL),
('de22833a-a287-4fc3-962c-e676bd6114ea','Biciclette','biciclette','Negozi di biciclette e accessori',NULL),
('a3b73872-0596-473f-9673-f5d0cf4f64e2','Birrerie','birrerie','Birrerie e birrifici',NULL),
('9dc9f977-18e9-4f10-a749-30acf571215a','Birrifici','birrifici','Birrifici artigianali',NULL),
('f1557626-a6c3-463b-abfe-a906106aed98','Boutique','boutique','Boutique di moda',NULL),
('49f46702-eb5b-4e7a-b0fa-4f70a2c4d24a','Calzature','calzature','Negozi di scarpe',NULL),
('7cbe8fdc-3977-45ed-8b04-d73fc4865ca4','Calzolai','calzolai','Calzolai',NULL),
('030b771b-aa43-4613-a541-e5ca4dbb6896','Campeggi','campeggi','Campeggi',NULL),
('0ae62183-935d-49fa-9fca-7388fb3e5086','Cantine','cantine','Cantine vinicole',NULL),
('8abf1967-f761-47f5-afd6-491b595eee82','Cartolerie','cartolerie','Cartolerie',NULL),
('66a14384-ca2b-4d8c-9790-d6f46bd6ef14','Centri Commerciali','centri-commerciali','Centri commerciali',NULL),
('c1d0c741-519e-412d-a1b3-38d9be0be6f4','Centri di Ricerca','centri-di-ricerca','Centri di ricerca',NULL),
('f95d46f3-a33b-442f-91a6-a2fc308356a6','Centri Estetici','centri-estetici','Centri estetici e beauty center',NULL),
('903601bb-1267-435f-ae5d-831fa6237687','Centri Massaggi','centri-massaggi','Centri massaggi',NULL),
('74b961b4-ffc4-451e-9d38-110243196e4a','Centri Sportivi','centri-sportivi','Centri sportivi',NULL),
('1ef2b123-c2c0-45e8-bf03-3986b1e81cd7','Centri Yoga','centri-yoga','Centri yoga',NULL),
('468c6502-1cf1-4f74-8ca3-185b9d1eb22f','Ceramisti','ceramisti','Ceramisti',NULL),
('2aa4aeeb-0fc6-4df6-8724-d4416d51f17a','Cestai','cestai','Cestai',NULL),
('461b13b5-b64e-49d7-8186-9f6b7f8a4d51','Chalet','chalet','Chalet',NULL),
('0a42366f-2e8d-48ec-8f0d-b40484eb5ed2','Cioccolaterie','cioccolaterie','Negozi di cioccolato artigianale',NULL),
('c3275dfb-ad43-4469-a776-a2efd5f8e5c9','Climatizzazione','climatizzazione','Impianti di riscaldamento e condizionamento',NULL),
('2da1f2a4-ed43-4330-827d-6eb10397d726','Cliniche','cliniche','Cliniche',NULL),
('e8d5e1f4-b0d9-4ebf-a818-ff360b215db4','Colonnine Ricarica','colonnine-ricarica','Colonnine ricarica elettrica',NULL),
('e8a97117-276e-4d15-89b2-a3b1542bc245','Colorifici','colorifici','Colorifici',NULL),
('d3bb92f7-eda9-49d2-ad8f-dda9343ba9c6','Commercialisti','commercialisti','Studi di commercialisti',NULL),
('4f548fc9-8978-495b-82e8-d518f8590ab0','Concessionarie Auto','concessionarie-auto','Concessionarie auto',NULL),
('ba13603d-7e89-4684-9e15-6157e1b93176','Consorzi Agrari','consorzi-agrari','Consorzi agrari',NULL),
('22c9fe66-84ec-4827-94b0-d148015917b9','Consulenti','consulenti','Consulenti generici',NULL),
('695edab5-58e2-4660-b6da-e715a10dc8a5','Consulenti Finanziari','consulenti-finanziari','Consulenti finanziari',NULL),
('354c21e1-4148-41f6-b0f5-3f1ad3ebb454','Consulenti Fiscali','consulenti-fiscali','Consulenti fiscali',NULL),
('32572d73-39ae-48fe-bb14-7b0191551a9d','Cornici','cornici','Negozi di cornici',NULL),
('cffd9e1d-c7cf-450f-bb4e-17fc19fa7923','Costruttori','costruttori','Imprese di costruzioni',NULL),
('e5ab980c-2616-4eed-8ec3-d845c1e3a624','Cucine','cucine','Negozi di cucine',NULL),
('421787a0-b851-4d3c-899f-747c47081262','Dentisti','dentisti','Studi dentistici',NULL),
('2d17038a-4d6a-4bc9-af71-2eb4745e556e','Discoteche','discoteche','Discoteche e nightclub',NULL),
('4ccffc22-ede9-42d0-a0cb-13b676ebf8af','Distillerie','distillerie','Distillerie',NULL),
('60122696-9f6a-4034-a45f-881c86827845','Distributori Automatici','distributori-automatici','Distributori automatici',NULL),
('09c96e13-fd04-46a4-8d98-1cbe2d725a71','Distributori di Carburante','distributori-carburante','Stazioni di servizio per rifornimento carburante (benzina, diesel, GPL, metano, elettrico)','47.30.00'),
('1684203a-8b43-4b50-9a5c-2af7f6391906','Duplicazione Chiavi','duplicazione-chiavi','Duplicazione chiavi',NULL),
('42ce5887-45a1-4c53-8be2-cceac0665fab','Edicole','edicole','Edicole e giornalai',NULL),
('0bebc2af-2741-4c07-8210-0388ba18d702','Elettricisti','elettricisti','Installazione e manutenzione impianti elettrici',NULL),
('081bb7fb-d7e5-460c-9fc3-f6e1b442b51a','Elettronica','elettronica','Negozi di elettronica',NULL),
('0a693b6c-4b14-41cc-a374-312447047c78','Enoteche','enoteche','Enoteche e wine bar',NULL),
('2613b6c0-71fc-49ff-822e-3b5e28d6bed8','Fabbri','fabbri','Fabbri',NULL),
('c9bb00c0-a81d-4ea3-a6f0-2e6e09fdb36f','Fai da Te','fai-da-te','Negozi fai da te e bricolage',NULL),
('0b94f874-5b3b-460f-b6c7-aba7f2cfcc43','Falegnami','falegnami','Lavorazione del legno e falegnameria',NULL),
('f32ccf20-1dc1-4bc3-88b7-4cc0c7b107d4','Farmacie','farmacie','Farmacie',NULL),
('71cda317-e680-43cd-a56f-13434ff25f3b','Fast Food','fast-food','',NULL),
('c1bf3384-600f-4edb-a208-431728d72aa9','Ferramenta','ferramenta','Ferramenta e bricolage',NULL),
('2d90ad96-9ad8-444d-bb5f-0f005bb5214e','Fioristi','fioristi','Negozi di fiori',NULL),
('598c78e4-0e24-4b11-b511-9e9dd78a6ee2','Fisioterapisti','fisioterapisti','Fisioterapisti',NULL),
('41d4716e-ce12-437a-8722-c60a13756f73','Fondazioni','fondazioni','Fondazioni',NULL),
('36c3e8fe-e487-44d9-bfe6-d96ceec3da99','Food Court','food-court','Aree ristorazione',NULL),
('5ffc5277-dc74-4e5c-999f-e994b254bbeb','Formaggerie','formaggerie','Negozi specializzati in formaggi',NULL),
('4f599096-9fa4-429f-9bdb-a67aa3525594','Forniture Parrucchieri','forniture-parrucchieri','Forniture per parrucchieri',NULL),
('312f318d-84d8-4dc3-a6b2-10c1210d7d3e','Fotocamere','fotocamere','Negozi di fotocamere',NULL),
('d32bf0c8-97d4-41a4-8c05-c4e590e1cee1','Fotografi','fotografi','Fotografi professionisti',NULL),
('86c85873-3fe4-4cb9-8b3c-671999e7e462','Fotografia','fotografia','Negozi di fotografia',NULL),
('39e0200c-3363-4c78-8c94-3be64799110b','Frutta e Verdura','frutta-e-verdura','Negozi di frutta e verdura',NULL),
('e1e4e497-92ce-4275-a445-1a2bdcbcb671','Fuochi d''Artificio','fuochi-d-artificio','Fuochi d''artificio',NULL),
('8410d064-5d51-4555-b427-9f3c149cacba','Gallerie d''Arte','gallerie-d-arte','Gallerie d''arte',NULL),
('0ee4e184-f1cb-4afd-8a5f-e4f8057160b9','Gastronomie','gastronomie','Gastronomie e salumerie',NULL),
('ff3670d7-0cf4-495a-9a2e-bef31b3db66e','Gelaterie','gelaterie','Gelaterie',NULL),
('928d78c4-059d-4f4b-a2de-302c7a11edc1','Geometri','geometri','Geometri',NULL)
ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name, slug=EXCLUDED.slug, description=EXCLUDED.description, ateco_code=EXCLUDED.ateco_code;

INSERT INTO business_categories (id, name, slug, description, ateco_code) VALUES
('34da2b3c-39e1-4a0f-901f-7e41807b5b7f','Giardinaggio','giardinaggio','Articoli per giardinaggio',NULL),
('e1c34691-ea09-4608-86f9-ba16a057f0aa','Giardinieri','giardinieri','Giardinieri',NULL),
('850192cf-da0a-4a9e-b934-f5f98fa53ce7','Giocattoli','giocattoli','Negozi di giocattoli',NULL),
('aba355f1-1767-4a0f-8e18-80eab1c23771','Gioiellerie','gioiellerie','Gioiellerie e oreficerie',NULL),
('22a0a7be-f961-49ac-9254-e588efb19009','Giornali','giornali','Redazioni giornali',NULL),
('4080d5da-5bfc-418e-9e98-d7c29f2676f2','Golf','golf','Articoli da golf',NULL),
('62b322a6-dc4a-4647-a324-0a4e05492e63','Grafici','grafici','Grafici e designer',NULL),
('9bd61242-58e4-4e6e-81ed-ac6ef19a5772','Grandi Magazzini','grandi-magazzini','Grandi magazzini',NULL),
('e083aaf3-c674-4608-851b-b7c65e45b619','Hi-Fi','hi-fi','Negozi Hi-Fi',NULL),
('68713c51-d754-4aee-875f-020ae56553de','Hobby e Bricolage','hobby-e-bricolage','Negozi di hobby',NULL),
('aa097f99-e221-486f-bb2b-1beca15558b6','Hotel','hotel','Hotel e alberghi',NULL),
('9b5c369c-8383-4cd1-9395-3dadd6921e40','Idraulici','idraulici','Installazione e riparazione impianti idraulici',NULL),
('b6bc271f-3672-4858-ab45-4b6fa5136604','Illuminazione','illuminazione','Negozi di illuminazione',NULL),
('0648bee8-c78a-4d69-a865-32d876996676','Imbianchini','imbianchini','Servizi di imbiancatura e tinteggiatura',NULL),
('f94ef40a-fff6-4c8a-9edc-4f00faa0235f','Imprese Edili','imprese-edili','Costruzioni e ristrutturazioni edili',NULL),
('8c3d527f-5299-4be2-b011-9c69b900da9a','Infissi','infissi','Infissi e serramenti',NULL),
('ce6dcf6c-3cbc-449c-810d-2486bb7c33aa','Informatica','informatica','Servizi informatici',NULL),
('8d0e98a9-df07-42ee-9c0d-34af3c139a2f','Ingegneri','ingegneri','Studi di ingegneria',NULL),
('9e05d503-9218-42f3-85ac-715b2a8de778','Insegne','insegne','Insegne pubblicitarie',NULL),
('6cc8712e-569a-45cf-a782-9dde523e41e3','Istituti Formativi','istituti-formativi','Istituti formativi',NULL),
('77497f21-93a0-44d1-8744-2ac57835792d','Laboratori Analisi','laboratori-analisi','Laboratori di analisi',NULL),
('4a60e637-664c-4ecb-a6b2-5ffe73fcbf36','Latterie','latterie','Latterie',NULL),
('a1229cfa-f256-452a-863e-1809524e3dab','Lattonieri','lattonieri','Lattonieri',NULL),
('3046f155-67b6-4ff7-8cde-e04b56ae1e8e','Lavanderie','lavanderie','Lavanderie',NULL),
('0359d206-3fda-44bc-b242-908716e586d9','Librerie','librerie','Librerie e cartolerie',NULL),
('1383aae2-0dae-4370-89a6-b1ea5429966e','Logistica','logistica','Aziende di logistica',NULL),
('47cb4aaf-b46b-48d3-8f0d-0e144bb0efc5','Logopedisti','logopedisti','Logopedisti',NULL),
('df6b5a42-ade9-4bbf-a2bb-88e85a9d41fb','Macellerie','macellerie','Macellerie',NULL),
('06485dad-4114-42ce-9dd0-dbf067f8a0aa','Maniscalchi','maniscalchi','Maniscalchi',NULL),
('de5bf46c-263b-425b-9940-98d93ef2efcb','Materassi e Letti','materassi-e-letti','Negozi di materassi e letti',NULL),
('e270ab19-1a37-4120-a7bb-3fb86365a4a6','Medici','medici','Studi medici',NULL),
('793c0025-567b-4a9f-ab1f-b908db4d1c41','Medicine Alternative','medicine-alternative','Medicine alternative',NULL),
('5867c74c-42a3-41b9-a1ae-ad55e445ac52','Mercatini Solidali','mercatini-solidali','Mercatini solidali',NULL),
('a3f1b456-6291-470c-bf6f-bbbd763de21b','Moda','moda','Negozi di moda',NULL),
('97ae3744-0799-43fd-9248-1a9c238dbbb4','Modellismo','modellismo','Negozi di modellismo',NULL),
('5a4f75ea-7504-4076-b2f0-6d0b337fbb5f','Motel','motel','Motel',NULL),
('22698258-fd88-4c46-8e86-1f66ec546f8b','Moto','moto','Moto e accessori',NULL),
('02d932c0-2f61-461e-89e1-95efc7ad8491','Negozi di Bevande','negozi-di-bevande','Negozi specializzati in bevande',NULL),
('93c5a975-7df9-4cc8-8389-426683f97fc0','Negozi di Biciclette','negozi-di-biciclette','Negozi di biciclette',NULL),
('77216b6c-e8a9-4b16-9c6a-8e194cbedb51','Negozi di Computer','negozi-di-computer','Negozi di computer',NULL),
('8952885d-4017-4f6f-be80-16adb45f69bb','Negozi di Musica','negozi-di-musica','Negozi di musica',NULL),
('f910c945-be77-463c-979f-25722fe2b3e6','Negozi di Sport','negozi-di-sport','Negozi di articoli sportivi',NULL),
('f21a179e-009c-43fa-b3b9-09f21c7456a3','Negozi di Tè','negozi-di-te','Negozi specializzati in tè',NULL),
('4ca1cbac-3848-4471-95ce-8565935e413a','Negozi di Telefonia','negozi-di-telefonia','Negozi di telefonia',NULL),
('8d111bb2-65b2-4ae4-ae1b-f572db59e3ce','Negozi per Animali','negozi-per-animali','Negozi per animali',NULL),
('27dd1f3d-ac85-4282-b0d6-3b3d60ed7522','Noleggio Biciclette','noleggio-biciclette','Noleggio biciclette',NULL),
('6c808ed1-b16f-4eb9-bc79-ae79fa81277a','Notai','notai','Servizi notarili e atti pubblici',NULL),
('fcc113bc-2bc2-4000-81ab-6a4aecce05b9','ONG','ong','Organizzazioni non governative',NULL),
('cdb3403d-1d73-4625-a8ea-3b35aee3df4c','Onoranze Funebri','onoranze-funebri','Onoranze funebri',NULL),
('d3f2393c-45ca-46d2-8252-dba8ee5a81c6','Optometristi','optometristi','Optometristi',NULL),
('6e834c62-4713-492a-8a28-f1ed42f7867d','Orefici','orefici','Orefici',NULL),
('dc2f6c70-248d-4c58-99d4-2e4f9baa10d4','Orologerie','orologerie','Negozi di orologi',NULL),
('cf7359c2-e69c-4531-8cee-ca6bb546d26d','Orologiai','orologiai','Orologiai',NULL),
('528d5b62-8f57-449f-b3b5-e851c1730acc','Ospedali','ospedali','Ospedali',NULL),
('224fcc2a-7a90-4bf7-8e45-93df993f2301','Ostelli','ostelli','Ostelli',NULL),
('931003fd-7f3c-4492-a19e-e2d21df9c467','Ostetriche','ostetriche','Ostetriche',NULL),
('202c5507-d4c3-435c-82ba-543e4d921a5e','Ottici','ottici','Ottici',NULL),
('dacb2347-6443-47a3-927b-751f91873380','Outdoor e Camping','outdoor-e-camping','Articoli outdoor e camping',NULL),
('ec7b5a53-d900-4110-bfe2-4d4ce2d6306d','Palestre','palestre','Palestre e centri fitness',NULL),
('c01d3fd7-20be-4f75-87ca-0d3f1f21b973','Panetterie','panetterie','Panifici e produzione di pane',NULL),
('05af0418-e19e-424b-a9b2-829647b32ab6','Panifici','panifici','Panifici',NULL),
('a188e286-8a6a-4225-ac1a-f0bbdff84805','Panifici e Pasticcerie','panifici-e-pasticcerie','Panifici, pasticcerie e forni',NULL),
('417da4db-fc8c-456f-a76f-e2b0efa2c678','Parcheggi','parcheggi','Parcheggi',NULL),
('5ddd5d4b-d2a9-425d-9b28-6f40b995b3a4','Parcheggi Biciclette','parcheggi-biciclette','Parcheggi per biciclette',NULL),
('d5fbf633-d5e4-46b7-8ed5-d752ace87d8a','Parrucchieri','parrucchieri','Saloni di parrucchiere e barbieri',NULL),
('bc007dec-dac6-4d74-8e21-1936cf6a158e','Parrucchieri e Barbieri','parrucchieri-e-barbieri','Parrucchieri e barbieri',NULL),
('0d588a55-f153-4ed3-b1e6-d624a06e7e09','Pasticcerie','pasticcerie','Pasticcerie',NULL),
('2094b01e-b1dd-4d12-a899-13e31c3ac41c','Pastifici','pastifici','Pastifici artigianali',NULL),
('e1704f8f-ff4f-409f-b314-60573f61fbdc','Pavimenti','pavimenti','Posatori di pavimenti',NULL),
('e5381c25-9425-4779-a681-c49613a465d9','Pelletterie','pelletterie','Pelletterie e articoli in pelle',NULL),
('d2bc1175-c2eb-4810-ab90-6680819cbe9a','Pesca e Caccia','pesca-e-caccia','Articoli per pesca e caccia',NULL),
('04f975b2-6c61-4760-83be-439c7559916d','Pescherie','pescherie','Pescherie',NULL),
('15305b9f-2b3c-48fc-913c-0f9ccdd59882','Piastrelle','piastrelle','Negozi di piastrelle',NULL),
('7cd7f4db-9634-4503-baa0-30e49e3a61d3','Piastrellisti','piastrellisti','Piastrellisti',NULL),
('71d373d9-3f0a-48c8-a3b4-10e64c89db19','Piscine','piscine','Piscine e accessori',NULL),
('b098d330-a277-41dd-b190-c786e9fc993f','Pizzerie','pizzerie','Pizzerie',NULL),
('2eabd667-f8d2-4212-9a3e-b2225dc7f23e','Pneumatici','pneumatici','Negozi di pneumatici',NULL),
('27ac8c6e-6cb3-4284-87c8-c1317e81c4da','Podologi','podologi','Podologi',NULL),
('f40a7cb7-ac29-4e9a-9464-e717dee92a06','Ponteggiatori','ponteggiatori','Ponteggiatori',NULL),
('7591c99e-02c7-45a7-9496-2493c95b30b5','Posatori Parquet','posatori-parquet','Posatori di parquet',NULL),
('500f2487-c5d9-4c20-874d-cbf0628b687a','Poste','poste','Uffici postali e servizi di spedizione',NULL),
('a8fbede6-47d4-430d-8be7-4361d684e426','Profumerie','profumerie','Profumerie e cosmetici',NULL),
('61f9d8cf-9d6d-4365-a995-233fb1c4ca68','Psicologi','psicologi','Psicologi e psicoterapeuti',NULL),
('3355b8e9-c674-498c-a82f-6d0d4fa478f5','Pub e Locali','pub-e-locali','',NULL),
('2b49c211-ac9f-4b0a-8fb3-1864fc1bc350','Regali','regali','Negozi di regali',NULL),
('53239a4a-18fb-490e-87a8-70b6b4f9c8e6','Revisioni Auto','revisioni-auto','Centri revisione auto',NULL),
('8554fb22-b0cd-4975-ae5d-95acac30d7f3','Ricambi Auto','ricambi-auto','Ricambi auto',NULL),
('9bce9ec6-d0b1-469f-90e6-03a6840dc057','Ricevitorie','ricevitorie','Ricevitorie e lotterie',NULL),
('01cd5ad4-2cd4-423c-9ae9-2936518fe71b','Rilegatori','rilegatori','Rilegatori',NULL),
('712e6967-7c7b-4af7-9d2c-8f6278f3f13a','Riparazione Elettronica','riparazione-elettronica','Riparazione elettronica',NULL),
('b266278e-8233-4d0c-8f7c-38635e5764ea','Ristoranti','ristoranti','Ristoranti e trattorie',NULL),
('5f662eba-f5a1-48a6-8ab4-5bdfa4de3d0e','Sanitaria','sanitaria','Sanitaria e articoli ortopedici',NULL),
('0531b457-61d8-405e-98b4-019fc48aeaa6','Sarti','sarti','Sarti',NULL),
('62dbbd91-5df6-47e7-b21d-0961d0755359','Sartorie','sartorie','Sartorie',NULL),
('e05b5140-d887-495a-b669-c8f92a96f719','Saune','saune','Saune',NULL),
('b83340d1-55a8-4c8b-be7d-230194ed330e','Scalpellini','scalpellini','Scalpellini',NULL),
('fd2d9615-4cf9-4f08-8907-515192a5fc1e','Sci e Snowboard','sci-e-snowboard','Articoli da sci e snowboard',NULL),
('d179a092-10cb-48d5-bce0-463c09179ed1','Scuole','scuole','Scuole',NULL),
('0bf7ebca-a3dd-441b-891a-02a8e0aa60c2','Scuole di Danza','scuole-di-danza','Scuole di danza',NULL),
('fa691eb1-a760-4bba-b157-5c1611cf5af6','Scuole di Lingue','scuole-di-lingue','Scuole di lingue',NULL),
('f3050c77-70d9-4cba-ace8-7598fcf409f9','Scuole di Musica','scuole-di-musica','Scuole di musica',NULL),
('bcaaf7e3-ce66-4b53-9a08-2b7968080a46','Serramenti','serramenti','Installazione serramenti e infissi',NULL),
('836c29e7-ef5c-4f2e-98e5-79d18508441d','Sexy Shop','sexy-shop','Sexy shop',NULL),
('c1e51066-c28d-425b-b21b-b5e8796fc70d','Sigarette Elettroniche','sigarette-elettroniche','Negozi di sigarette elettroniche',NULL),
('bcfb5b11-0104-42e3-b533-4ba32c0adfc1','Spezierie','spezierie','Negozi di spezie',NULL),
('3aef4844-d911-4f5c-9129-5c37f97b3e5e','Stazioni di Servizio','stazioni-di-servizio','Stazioni di servizio',NULL),
('40ccaab3-bc92-403b-b6ac-9d424ab6d3d6','Strumenti Musicali','strumenti-musicali','Negozi di strumenti musicali',NULL),
('6ea6432e-d7b6-489d-85c4-92ac834e11dc','Stuccatori','stuccatori','Stuccatori',NULL),
('aa35d9a4-dade-4d1e-8353-e8ceaeff3233','Sub e Diving','sub-e-diving','Articoli sub e diving',NULL),
('fd447cfb-5445-4193-acb6-2c519db838d3','Supermercati','supermercati','Supermercati e ipermercati',NULL),
('c541a178-7e7b-4624-ba07-47020e071b25','Tabaccherie','tabaccherie','Tabaccherie',NULL),
('54210cd9-d977-40af-a370-44342cf2d103','Tappeti','tappeti','Negozi di tappeti',NULL),
('6c59cc46-2ce9-4ec1-9671-63922f448be7','Tappezzieri','tappezzieri','Tappezzieri',NULL),
('72cd7648-aab4-4496-833d-12aa81fc6036','Tatuatori','tatuatori','Studi di tatuaggi',NULL),
('8d6d742d-eb19-468a-832d-7c2f864ecb3f','Taxi','taxi','Servizi taxi',NULL),
('6dfacc84-30a3-4cbb-be8c-d65054f6e565','Telecomunicazioni','telecomunicazioni','Telecomunicazioni',NULL),
('e0151044-0bfc-4150-9f6a-fb2ab0a69ee1','Telefonia','telefonia','Negozi di telefonia e accessori',NULL),
('cedb0b58-8023-4d4e-8f02-d3966b49a0fb','Tendaggi','tendaggi','Negozi di tendaggi',NULL),
('1b32a225-298a-4ca8-a2fc-36b23a94fdf1','Tessuti','tessuti','Negozi di tessuti',NULL),
('4575549b-3d0a-4982-96e7-e69de804985d','Tipografie','tipografie','Tipografie',NULL),
('5b750a10-23ef-4d83-a051-e77d2e45c849','Toelettatura Animali','toelettatura-animali','Toelettatura animali',NULL),
('b8c5e3dd-6257-4754-9118-2d45bab54eac','Torrefazioni','torrefazioni','Torrefazioni e caffè',NULL),
('bd94fd16-4ffb-4525-9203-f3a02b95baaf','Uffici Postali','uffici-postali','Uffici postali',NULL),
('4780876c-e762-4a88-946a-8f4d387026f1','Università','universita','Università',NULL),
('3b1eaf1e-2d2e-4027-ac01-4a3072af4264','Usato','usato','Negozi dell''usato',NULL),
('267da5cd-fbcb-4066-bb03-7f20bdcb7792','Velai','velai','Velai',NULL),
('ce2cec3b-ae96-4d96-9fa6-09ba91130e91','Veterinari','veterinari','',NULL),
('45e3c073-952d-42a6-abe7-a4f21fdac282','Vetrai','vetrai','Vetrai',NULL),
('ad6c3bf4-c8ad-403d-93d5-e26cac72c56b','Videogiochi','videogiochi','Negozi di videogiochi',NULL),
('ab2b856b-8456-494c-b8c2-5aa06ac7958c','Videonoleggi','videonoleggi','Videonoleggi',NULL)
ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name, slug=EXCLUDED.slug, description=EXCLUDED.description, ateco_code=EXCLUDED.ateco_code;

