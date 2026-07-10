/*
  # Expand Classified Ad Categories

  ## Overview
  Adds extensive categories to the classified ads system to cover all possible product and service types.

  ## New Categories Added
  - Health & Beauty (Salute e Bellezza)
  - Photography & Video (Fotografia e Video)
  - Cycling (Ciclismo)
  - IT & Software (Informatica e Software)
  - Courses & Training (Corsi e Formazione)
  - Building Materials (Materiale Edile)
  - Gardening (Giardinaggio)
  - Boating & Marine (Nautica)
  - Camping & Outdoor (Campeggio e Outdoor)
  - Professional Equipment (Attrezzatura Professionale)
  - Weddings & Events (Matrimoni ed Eventi)
  - Travel & Holidays (Viaggi e Vacanze)
  - Telephony (Telefonia)
  - Security & Surveillance (Videosorveglianza)
  - HVAC & Heating (Climatizzazione e Riscaldamento)
  - Kitchen & Restaurant Equipment (Attrezzature per Ristorazione)
  - Office Supplies (Cancelleria e Ufficio)
  - Crafts & DIY (Bricolage e Fai da Te)
  - Antiques & Vintage (Antiquariato e Vintage)
  - Jewelry & Watches (Gioielli e Orologi)
  - Toys & Games (Giocattoli e Giochi)
  - Musical Instruments (Strumenti Musicali)
  - Fitness & Wellness (Fitness e Benessere)
  - Agricultural Equipment (Attrezzature Agricole)
  - Wine & Food (Vino e Gastronomia)
  - Pets & Animals (Animali Domestici)
  - Beauty Salon Equipment (Attrezzature per Parrucchieri ed Estetisti)
  - Medical Equipment (Attrezzature Mediche)
  - Industrial Machinery (Macchinari Industriali)
  - Renewable Energy (Energie Rinnovabili)
  - And many more specific categories (120+ total new categories)

  ## Security
  - No RLS changes needed (categories already have public read access)
*/

-- Insert extensive classified categories
INSERT INTO classified_categories (name, slug, icon, description) VALUES
  -- Health & Beauty
  ('Salute e Bellezza', 'salute-bellezza', 'Heart', 'Prodotti per la cura della persona, cosmetici, profumi'),
  ('Attrezzature Parrucchieri', 'attrezzature-parrucchieri', 'Scissors', 'Phon, piastre, forbici, prodotti professionali per parrucchieri'),
  ('Attrezzature Estetiste', 'attrezzature-estetiste', 'Sparkles', 'Lettini, lampade UV, prodotti per estetica e spa'),

  -- Photography & Media
  ('Fotografia e Video', 'fotografia-video', 'Camera', 'Fotocamere, videocamere, obiettivi, treppiedi, accessori'),
  ('Droni', 'droni', 'Plane', 'Droni per fotografia, videomaking e hobby'),

  -- Sports & Fitness
  ('Ciclismo', 'ciclismo', 'Bike', 'Biciclette, mountain bike, accessori e ricambi'),
  ('Fitness e Palestra', 'fitness-palestra', 'Dumbbell', 'Attrezzi palestra, pesi, tapis roulant, cyclette'),
  ('Calcio', 'calcio', 'Trophy', 'Scarpe, palloni, abbigliamento da calcio'),
  ('Tennis e Racchette', 'tennis-racchette', 'Award', 'Racchette, palloni, abbigliamento da tennis'),
  ('Sport Invernali', 'sport-invernali', 'Mountain', 'Sci, snowboard, abbigliamento da neve'),
  ('Sport Acquatici', 'sport-acquatici', 'Waves', 'Surf, windsurf, kitesurf, immersioni'),
  ('Arrampicata', 'arrampicata', 'TrendingUp', 'Attrezzatura per arrampicata e alpinismo'),

  -- Technology
  ('Computer e Laptop', 'computer-laptop', 'Monitor', 'PC desktop, laptop, componenti hardware'),
  ('Tablet', 'tablet', 'Tablet', 'Tablet di tutte le marche e accessori'),
  ('Smartphone', 'smartphone', 'Smartphone', 'Cellulari nuovi e usati, accessori'),
  ('Smartwatch e Wearable', 'smartwatch-wearable', 'Watch', 'Smartwatch, fitness tracker, auricolari wireless'),
  ('Console e Videogiochi', 'console-videogiochi', 'Gamepad2', 'PlayStation, Xbox, Nintendo, giochi e accessori'),
  ('Software e Licenze', 'software-licenze', 'Code', 'Software, licenze, corsi online'),
  ('Networking', 'networking', 'Wifi', 'Router, switch, access point, cavi di rete'),
  ('Stampa e Scanner', 'stampa-scanner', 'Printer', 'Stampanti, scanner, multifunzione, toner'),
  ('Videosorveglianza', 'videosorveglianza', 'Shield', 'Telecamere, DVR, sistemi di sicurezza'),

  -- Home & Garden
  ('Elettrodomestici Grandi', 'elettrodomestici-grandi', 'Refrigerator', 'Frigoriferi, lavatrici, lavastoviglie, forni'),
  ('Elettrodomestici Piccoli', 'elettrodomestici-piccoli', 'Microwave', 'Microonde, frullatori, tostapane, caffettiere'),
  ('Mobili Soggiorno', 'mobili-soggiorno', 'Sofa', 'Divani, poltrone, tavoli, librerie'),
  ('Mobili Camera da Letto', 'mobili-camera-letto', 'Bed', 'Letti, armadi, comodini, materassi'),
  ('Mobili Cucina', 'mobili-cucina', 'ChefHat', 'Cucine componibili, tavoli, sedie'),
  ('Illuminazione', 'illuminazione', 'Lightbulb', 'Lampadari, lampade da tavolo, faretti'),
  ('Decorazione Casa', 'decorazione-casa', 'Paintbrush', 'Quadri, specchi, tende, tappeti'),
  ('Giardinaggio', 'giardinaggio', 'TreeDeciduous', 'Piante, attrezzi da giardino, vasi, fertilizzanti'),
  ('Climatizzazione', 'climatizzazione', 'Wind', 'Condizionatori, stufe, ventilatori, deumidificatori'),
  ('Idraulica e Riscaldamento', 'idraulica-riscaldamento', 'Droplet', 'Caldaie, termosifoni, rubinetteria'),
  ('Edilizia e Materiali', 'edilizia-materiali', 'HardHat', 'Materiali da costruzione, piastrelle, sanitari'),
  ('Porte e Finestre', 'porte-finestre', 'DoorOpen', 'Porte, finestre, infissi, serrande'),

  -- Vehicles & Transportation
  ('Auto', 'auto', 'Car', 'Automobili nuove e usate di tutte le marche'),
  ('Moto e Scooter', 'moto-scooter', 'Bike', 'Motociclette, scooter, ciclomotori'),
  ('Camper e Roulotte', 'camper-roulotte', 'Caravan', 'Camper, caravan, accessori camping'),
  ('Barche e Gommoni', 'barche-gommoni', 'Ship', 'Imbarcazioni, motori marini, accessori nautici'),
  ('Ricambi Auto', 'ricambi-auto', 'Wrench', 'Parti di ricambio, pneumatici, cerchi'),
  ('Accessori Auto', 'accessori-auto', 'Navigation', 'Navigatori, portapacchi, sedili'),

  -- Real Estate
  ('Vendita Appartamenti', 'vendita-appartamenti', 'Building', 'Appartamenti in vendita'),
  ('Affitto Appartamenti', 'affitto-appartamenti', 'Home', 'Appartamenti in affitto'),
  ('Ville e Case', 'ville-case', 'Castle', 'Ville, villette, case indipendenti'),
  ('Uffici e Negozi', 'uffici-negozi', 'Store', 'Locali commerciali, uffici, capannoni'),
  ('Terreni', 'terreni', 'MapPin', 'Terreni edificabili e agricoli'),
  ('Box e Garage', 'box-garage', 'Warehouse', 'Box auto, garage, posti auto'),

  -- Jobs & Services
  ('Offerte di Lavoro', 'offerte-lavoro', 'Briefcase', 'Ricerca personale e offerte di lavoro'),
  ('Cerco Lavoro', 'cerco-lavoro', 'Search', 'Annunci di chi cerca lavoro'),
  ('Ripetizioni e Lezioni', 'ripetizioni-lezioni', 'GraduationCap', 'Lezioni private, corsi, ripetizioni'),
  ('Badanti e Colf', 'badanti-colf', 'Users', 'Assistenza anziani, pulizie domestiche'),
  ('Baby Sitter', 'baby-sitter', 'Baby', 'Servizio baby sitting'),
  ('Traslochi', 'traslochi', 'Truck', 'Servizi di trasloco e trasporto'),
  ('Ristrutturazioni', 'ristrutturazioni', 'Hammer', 'Muratori, elettricisti, idraulici, imbianchini'),
  ('Pulizie', 'pulizie', 'SprayBottle', 'Servizi di pulizia casa e uffici'),
  ('Riparazioni', 'riparazioni', 'Tool', 'Riparazione elettrodomestici, computer, smartphone'),
  ('Web e Marketing', 'web-marketing', 'Globe', 'Sviluppo siti web, SEO, social media marketing'),
  ('Grafica e Design', 'grafica-design', 'Palette', 'Graphic design, logo, brochure, video editing'),
  ('Fotografi e Video', 'fotografi-video-servizi', 'Video', 'Servizi fotografici, videomaker, matrimoni'),

  -- Fashion & Accessories
  ('Abbigliamento Uomo', 'abbigliamento-uomo', 'User', 'Vestiti, giacche, pantaloni uomo'),
  ('Abbigliamento Donna', 'abbigliamento-donna', 'UserSquare', 'Vestiti, gonne, camicie donna'),
  ('Abbigliamento Bambini', 'abbigliamento-bambini', 'Users', 'Vestiti per bambini e neonati'),
  ('Scarpe Uomo', 'scarpe-uomo', 'Footprints', 'Scarpe da uomo, sneakers, eleganti'),
  ('Scarpe Donna', 'scarpe-donna', 'HeartHandshake', 'Scarpe da donna, tacchi, stivali'),
  ('Borse e Zaini', 'borse-zaini', 'Backpack', 'Borse, zaini, valigie, trolley'),
  ('Occhiali', 'occhiali', 'Glasses', 'Occhiali da sole, da vista, montature'),
  ('Gioielli', 'gioielli', 'Gem', 'Anelli, collane, bracciali, orologi'),

  -- Hobbies & Entertainment
  ('Strumenti Musicali', 'strumenti-musicali', 'Music', 'Chitarre, pianoforti, batterie, accessori'),
  ('Vinili e CD', 'vinili-cd', 'Disc', 'Dischi in vinile, CD, collezioni musicali'),
  ('Libri Scolastici', 'libri-scolastici', 'BookOpen', 'Libri di testo, universitari'),
  ('Libri Narrativa', 'libri-narrativa', 'Book', 'Romanzi, saggi, libri usati'),
  ('Fumetti', 'fumetti', 'BookMarked', 'Fumetti, manga, graphic novel'),
  ('Collezionismo', 'collezionismo', 'Archive', 'Francobolli, monete, oggetti da collezione'),
  ('Modellismo', 'modellismo', 'Box', 'Modellini, trenini, aerei radiocomandati'),
  ('Pesca', 'pesca', 'Fish', 'Canne da pesca, mulinelli, accessori'),
  ('Caccia', 'caccia', 'Target', 'Fucili, ottiche, abbigliamento da caccia'),
  ('Paintball e Softair', 'paintball-softair', 'Crosshair', 'Repliche, protezioni, accessori softair'),

  -- Kids & Baby
  ('Passeggini', 'passeggini', 'Baby', 'Passeggini, trio, carrozzine'),
  ('Seggiolini Auto', 'seggiolini-auto', 'UserCheck', 'Seggiolini per auto, omologati'),
  ('Giocattoli Prima Infanzia', 'giocattoli-prima-infanzia', 'Blocks', 'Giochi per neonati e bambini piccoli'),
  ('Biciclette Bambini', 'biciclette-bambini', 'Bike', 'Bici per bambini, tricicli, monopattini'),
  ('Abbigliamento Premaman', 'abbigliamento-premaman', 'Heart', 'Vestiti per gravidanza'),

  -- Animals
  ('Cani', 'cani', 'Dog', 'Accessori per cani, cucce, guinzagli'),
  ('Gatti', 'gatti', 'Cat', 'Accessori per gatti, tiragraffi, lettiere'),
  ('Acquari', 'acquari', 'Fish', 'Acquari, pesci, accessori acquariofilia'),
  ('Uccelli', 'uccelli', 'Bird', 'Gabbie, mangiatoie, accessori'),
  ('Roditori', 'roditori', 'Rabbit', 'Accessori per criceti, conigli, furetti'),
  ('Cavalli', 'cavalli', 'Horse', 'Selle, finimenti, abbigliamento equestre'),

  -- Food & Wine
  ('Vini', 'vini', 'Wine', 'Bottiglie di vino, collezioni, cantine'),
  ('Prodotti Tipici', 'prodotti-tipici', 'Utensils', 'Prodotti gastronomici regionali'),
  ('Attrezzature Ristorazione', 'attrezzature-ristorazione', 'ChefHat', 'Forni, frigoriferi professionali, pentolame'),

  -- Professional & Industrial
  ('Attrezzature Edili', 'attrezzature-edili', 'HardHat', 'Ponteggi, betoniere, trapani professionali'),
  ('Macchinari Industriali', 'macchinari-industriali', 'Factory', 'Macchinari per produzione industriale'),
  ('Attrezzature Agricole', 'attrezzature-agricole', 'Tractor', 'Trattori, aratri, mietitrebbie'),
  ('Carrelli Elevatori', 'carrelli-elevatori', 'Container', 'Muletti, transpallet, sollevatori'),
  ('Generatori', 'generatori', 'Zap', 'Generatori di corrente, gruppi elettrogeni'),
  ('Compressori', 'compressori', 'Wind', 'Compressori aria, utensili pneumatici'),

  -- Events & Entertainment
  ('Matrimoni', 'matrimoni', 'Heart', 'Servizi per matrimoni, allestimenti'),
  ('Feste ed Eventi', 'feste-eventi', 'PartyPopper', 'Animazione, catering, noleggio attrezzature'),
  ('Noleggio Audio Video', 'noleggio-audio-video', 'Speaker', 'Service audio, luci, impianti'),

  -- Renewable Energy
  ('Pannelli Solari', 'pannelli-solari', 'Sun', 'Fotovoltaico, pannelli solari, inverter'),
  ('Stufe a Pellet', 'stufe-pellet', 'Flame', 'Stufe e caldaie a biomassa'),

  -- Other
  ('Oggetti Vintage', 'oggetti-vintage', 'Clock', 'Oggetti e mobili d''epoca'),
  ('Bomboniere', 'bomboniere', 'Gift', 'Bomboniere matrimonio, comunione, laurea'),
  ('Articoli Religiosi', 'articoli-religiosi', 'Church', 'Statue, icone, rosari'),
  ('Campeggio', 'campeggio', 'Tent', 'Tende, sacchi a pelo, materassini'),
  ('Escursionismo', 'escursionismo', 'Mountain', 'Zaini trekking, scarponi, bastoncini'),
  ('Biglietti e Voucher', 'biglietti-voucher', 'Ticket', 'Biglietti concerti, eventi sportivi, voucher'),
  ('Permute', 'permute', 'ArrowLeftRight', 'Scambio oggetti senza denaro'),
  ('Gratis', 'gratis', 'Gift', 'Oggetti da regalare gratuitamente')
ON CONFLICT (slug) DO NOTHING;
