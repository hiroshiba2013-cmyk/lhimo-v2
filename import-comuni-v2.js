/**
 * Importazione v2 - comuni vuoti e province scarse
 * Priorità assoluta: AO, AV, EN, NU, OR, OT (ancora a 0)
 * Poi tutte le province sotto 1000
 * Bbox ampliate al massimo
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const ZONES = [
  // ===== ANCORA A 0 =====
  { province: 'AO', region: "Valle d'Aosta", name: "Valle d'Aosta", bbox: [45.45, 6.80, 45.90, 7.90] },
  { province: 'AV', region: 'Campania', name: 'Avellino', bbox: [40.60, 14.50, 41.30, 15.40] },
  { province: 'EN', region: 'Sicilia', name: 'Enna', bbox: [37.20, 13.90, 37.95, 14.75] },
  { province: 'NU', region: 'Sardegna', name: 'Nuoro', bbox: [39.80, 8.80, 40.85, 9.95] },
  { province: 'OR', region: 'Sardegna', name: 'Oristano', bbox: [39.40, 8.20, 40.50, 9.30] },
  { province: 'OT', region: 'Sardegna', name: 'Olbia-Tempio', bbox: [40.65, 8.75, 41.45, 9.85] },

  // ===== < 100 =====
  { province: 'VV', region: 'Calabria', name: 'Vibo Valentia', bbox: [38.30, 15.70, 38.95, 16.55] },
  { province: 'SO', region: 'Lombardia', name: 'Sondrio', bbox: [45.80, 9.10, 46.75, 10.80] },
  { province: 'BI', region: 'Piemonte', name: 'Biella', bbox: [45.35, 7.85, 45.85, 8.35] },
  { province: 'LC', region: 'Lombardia', name: 'Lecco', bbox: [45.55, 9.15, 46.05, 9.75] },

  // ===== < 200 =====
  { province: 'CL', region: 'Sicilia', name: 'Caltanissetta', bbox: [36.80, 13.55, 37.75, 14.65] },
  { province: 'BL', region: 'Veneto', name: 'Belluno', bbox: [45.85, 11.60, 46.75, 12.70] },
  { province: 'VT', region: 'Lazio', name: 'Viterbo', bbox: [42.05, 11.40, 42.85, 12.55] },
  { province: 'TE', region: 'Abruzzo', name: 'Teramo', bbox: [42.35, 13.35, 42.95, 14.15] },
  { province: 'IS', region: 'Molise', name: 'Isernia', bbox: [41.35, 13.85, 41.95, 14.65] },
  { province: 'GR', region: 'Toscana', name: 'Grosseto', bbox: [42.20, 10.55, 43.25, 11.95] },

  // ===== < 300 =====
  { province: 'CZ', region: 'Calabria', name: 'Catanzaro', bbox: [38.45, 16.15, 39.25, 17.00] },
  { province: 'RC', region: 'Calabria', name: 'Reggio Calabria', bbox: [37.75, 15.35, 38.65, 16.65] },
  { province: 'BN', region: 'Campania', name: 'Benevento', bbox: [40.95, 14.35, 41.45, 15.25] },
  { province: 'MC', region: 'Marche', name: 'Macerata', bbox: [42.85, 12.85, 43.65, 13.95] },
  { province: 'FG', region: 'Puglia', name: 'Foggia', bbox: [40.95, 14.85, 42.05, 16.25] },
  { province: 'CR', region: 'Lombardia', name: 'Cremona', bbox: [44.85, 9.65, 45.45, 10.45] },
  { province: 'SS', region: 'Sardegna', name: 'Sassari', bbox: [40.35, 8.05, 41.35, 9.35] },
  { province: 'AG', region: 'Sicilia', name: 'Agrigento', bbox: [36.95, 12.75, 37.75, 14.05] },
  { province: 'PU', region: 'Marche', name: 'Pesaro-Urbino', bbox: [43.35, 11.95, 44.05, 13.25] },

  // ===== < 500 =====
  { province: 'VB', region: 'Piemonte', name: 'Verbano-Cusio-Ossola', bbox: [45.70, 8.00, 46.55, 9.00] },
  { province: 'TR', region: 'Umbria', name: 'Terni', bbox: [42.25, 11.75, 42.85, 13.05] },
  { province: 'GO', region: 'Friuli-Venezia Giulia', name: 'Gorizia', bbox: [45.65, 13.35, 46.05, 13.85] },
  { province: 'FR', region: 'Lazio', name: 'Frosinone', bbox: [41.35, 12.95, 41.95, 14.05] },
  { province: 'AR', region: 'Toscana', name: 'Arezzo', bbox: [43.05, 11.35, 43.85, 12.35] },
  { province: 'FM', region: 'Marche', name: 'Fermo', bbox: [42.85, 13.45, 43.45, 13.95] },
  { province: 'RO', region: 'Veneto', name: 'Rovigo', bbox: [44.75, 11.45, 45.25, 12.45] },
  { province: 'PZ', region: 'Basilicata', name: 'Potenza', bbox: [39.95, 15.15, 41.25, 16.45] },
  { province: 'SA', region: 'Campania', name: 'Salerno', bbox: [39.85, 14.55, 41.05, 15.85] },
  { province: 'PN', region: 'Friuli-Venezia Giulia', name: 'Pordenone', bbox: [45.75, 12.35, 46.35, 13.05] },
  { province: 'CS', region: 'Calabria', name: 'Cosenza', bbox: [38.95, 15.55, 40.15, 16.85] },
  { province: 'LT', region: 'Lazio', name: 'Latina', bbox: [41.05, 12.55, 41.75, 13.85] },
  { province: 'AP', region: 'Marche', name: 'Ascoli Piceno', bbox: [42.55, 13.25, 43.15, 14.05] },
  { province: 'MS', region: 'Toscana', name: 'Massa-Carrara', bbox: [43.95, 9.65, 44.55, 10.25] },
  { province: 'IM', region: 'Liguria', name: 'Imperia', bbox: [43.65, 7.45, 44.15, 8.25] },

  // ===== < 700 =====
  { province: 'CE', region: 'Campania', name: 'Caserta', bbox: [40.85, 13.75, 41.45, 14.65] },
  { province: 'RG', region: 'Sicilia', name: 'Ragusa', bbox: [36.65, 14.35, 37.35, 15.15] },
  { province: 'MN', region: 'Lombardia', name: 'Mantova', bbox: [44.85, 10.45, 45.35, 11.25] },
  { province: 'AQ', region: 'Abruzzo', name: "L'Aquila", bbox: [41.65, 12.95, 42.65, 14.25] },
  { province: 'CB', region: 'Molise', name: 'Campobasso', bbox: [41.35, 14.35, 41.95, 15.25] },
  { province: 'KR', region: 'Calabria', name: 'Crotone', bbox: [38.65, 16.55, 39.55, 17.55] },
  { province: 'TP', region: 'Sicilia', name: 'Trapani', bbox: [37.45, 12.15, 38.25, 13.25] },
  { province: 'RI', region: 'Lazio', name: 'Rieti', bbox: [41.95, 12.35, 42.65, 13.55] },
  { province: 'LO', region: 'Lombardia', name: 'Lodi', bbox: [45.05, 9.25, 45.55, 9.85] },
  { province: 'BT', region: 'Puglia', name: 'BAT', bbox: [40.95, 15.85, 41.55, 16.65] },
  { province: 'MT', region: 'Basilicata', name: 'Matera', bbox: [39.85, 15.75, 40.85, 16.95] },
  { province: 'PV', region: 'Lombardia', name: 'Pavia', bbox: [44.75, 8.65, 45.45, 9.55] },
  { province: 'VC', region: 'Piemonte', name: 'Vercelli', bbox: [44.95, 7.95, 45.65, 8.75] },

  // ===== < 1000 =====
  { province: 'SP', region: 'Liguria', name: 'La Spezia', bbox: [43.85, 9.45, 44.35, 10.05] },
  { province: 'SV', region: 'Liguria', name: 'Savona', bbox: [43.85, 7.95, 44.55, 8.85] },
  { province: 'PC', region: 'Emilia-Romagna', name: 'Piacenza', bbox: [44.55, 9.15, 45.25, 10.15] },
  { province: 'FE', region: 'Emilia-Romagna', name: 'Ferrara', bbox: [44.45, 11.35, 45.05, 12.15] },
  { province: 'PT', region: 'Toscana', name: 'Pistoia', bbox: [43.65, 10.55, 44.25, 11.25] },
  { province: 'PO', region: 'Toscana', name: 'Prato', bbox: [43.65, 10.75, 44.15, 11.35] },
  { province: 'SI', region: 'Toscana', name: 'Siena', bbox: [42.75, 10.85, 43.65, 12.05] },
  { province: 'LU', region: 'Toscana', name: 'Lucca', bbox: [43.65, 10.25, 44.35, 10.85] },
  { province: 'AT', region: 'Piemonte', name: 'Asti', bbox: [44.55, 7.85, 45.05, 8.55] },
  { province: 'AL', region: 'Piemonte', name: 'Alessandria', bbox: [44.45, 8.25, 45.15, 9.05] },
  { province: 'AO', region: "Valle d'Aosta", name: "Aosta (extra)", bbox: [45.40, 6.70, 45.95, 8.00] },
  { province: 'VA', region: 'Lombardia', name: 'Varese', bbox: [45.55, 8.40, 46.05, 9.00] },
  { province: 'CO', region: 'Lombardia', name: 'Como', bbox: [45.65, 8.95, 46.15, 9.55] },
  { province: 'NO', region: 'Piemonte', name: 'Novara', bbox: [45.30, 8.35, 45.85, 8.85] },
  { province: 'TN', region: 'Trentino-Alto Adige', name: 'Trento', bbox: [45.55, 10.50, 46.65, 11.60] },
  { province: 'BZ', region: 'Trentino-Alto Adige', name: 'Bolzano', bbox: [46.20, 10.35, 47.10, 12.30] },
  { province: 'CH', region: 'Abruzzo', name: 'Chieti', bbox: [41.85, 13.75, 42.65, 14.85] },
  { province: 'PE', region: 'Abruzzo', name: 'Pescara', bbox: [42.10, 13.75, 42.65, 14.45] },
  { province: 'BR', region: 'Puglia', name: 'Brindisi', bbox: [40.25, 17.35, 40.95, 18.25] },
  { province: 'TA', region: 'Puglia', name: 'Taranto', bbox: [40.05, 16.55, 40.75, 17.85] },
  { province: 'CA', region: 'Sardegna', name: 'Cagliari', bbox: [38.75, 8.55, 39.55, 9.65] },
  { province: 'ME', region: 'Sicilia', name: 'Messina', bbox: [37.85, 14.35, 38.35, 15.65] },
  { province: 'SR', region: 'Sicilia', name: 'Siracusa', bbox: [36.65, 14.85, 37.45, 15.45] },
  { province: 'FC', region: 'Emilia-Romagna', name: 'Forlì-Cesena', bbox: [43.65, 11.60, 44.35, 12.45] },
  { province: 'RA', region: 'Emilia-Romagna', name: 'Ravenna', bbox: [44.10, 11.65, 44.65, 12.45] },
  { province: 'RN', region: 'Emilia-Romagna', name: 'Rimini', bbox: [43.75, 12.10, 44.25, 12.75] },
  { province: 'AN', region: 'Marche', name: 'Ancona', bbox: [43.15, 12.75, 43.85, 13.75] },
  { province: 'PG', region: 'Umbria', name: 'Perugia', bbox: [42.45, 11.75, 43.65, 13.15] },
  { province: 'TV', region: 'Veneto', name: 'Treviso', bbox: [45.55, 11.75, 46.05, 12.55] },
  { province: 'VI', region: 'Veneto', name: 'Vicenza', bbox: [45.35, 11.15, 45.95, 11.75] },
  { province: 'UD', region: 'Friuli-Venezia Giulia', name: 'Udine', bbox: [45.80, 12.75, 46.65, 13.55] },
  { province: 'TS', region: 'Friuli-Venezia Giulia', name: 'Trieste', bbox: [45.55, 13.60, 45.85, 13.95] },

  // ===== GRANDI PROVINCE - hinterland non ancora coperti =====
  // Suddivise in quadranti per non sovraccaricare Overpass
  // TO - Torino (17088) - solo zone periferiche
  { province: 'TO', region: 'Piemonte', name: 'Torino Nord', bbox: [45.20, 7.00, 45.60, 7.80] },
  { province: 'TO', region: 'Piemonte', name: 'Torino Sud', bbox: [44.70, 7.00, 45.20, 7.80] },
  { province: 'TO', region: 'Piemonte', name: 'Torino Est', bbox: [44.90, 7.80, 45.40, 8.10] },
  // MI - Milano - zone periferiche
  { province: 'MI', region: 'Lombardia', name: 'Milano Ovest', bbox: [45.20, 8.80, 45.60, 9.20] },
  { province: 'MI', region: 'Lombardia', name: 'Milano Est', bbox: [45.20, 9.40, 45.65, 9.75] },
  // RM - Roma - zone periferiche
  { province: 'RM', region: 'Lazio', name: 'Roma Nord', bbox: [42.00, 12.10, 42.50, 12.80] },
  { province: 'RM', region: 'Lazio', name: 'Roma Sud', bbox: [41.40, 12.40, 42.00, 13.30] },
  { province: 'RM', region: 'Lazio', name: 'Roma Est', bbox: [41.80, 12.80, 42.10, 13.30] },
  // NA - Napoli - zone periferiche
  { province: 'NA', region: 'Campania', name: 'Napoli Nord', bbox: [40.90, 14.00, 41.20, 14.50] },
  { province: 'NA', region: 'Campania', name: 'Napoli Sud', bbox: [40.50, 14.10, 40.90, 14.60] },
  // CN - Cuneo
  { province: 'CN', region: 'Piemonte', name: 'Cuneo Nord', bbox: [44.40, 7.10, 44.80, 7.90] },
  { province: 'CN', region: 'Piemonte', name: 'Cuneo Sud', bbox: [43.90, 7.10, 44.40, 8.00] },
  // MO - Modena
  { province: 'MO', region: 'Emilia-Romagna', name: 'Modena', bbox: [44.20, 10.60, 44.80, 11.30] },
  // RE - Reggio Emilia
  { province: 'RE', region: 'Emilia-Romagna', name: 'Reggio Emilia', bbox: [44.25, 10.25, 44.75, 10.85] },
  // PR - Parma
  { province: 'PR', region: 'Emilia-Romagna', name: 'Parma', bbox: [44.25, 9.85, 44.90, 10.65] },
  // BS - Brescia
  { province: 'BS', region: 'Lombardia', name: 'Brescia Nord', bbox: [45.55, 10.05, 46.20, 10.65] },
  { province: 'BS', region: 'Lombardia', name: 'Brescia Sud', bbox: [45.10, 10.05, 45.55, 10.65] },
  // BG - Bergamo
  { province: 'BG', region: 'Lombardia', name: 'Bergamo', bbox: [45.55, 9.55, 46.15, 10.25] },
  // VR - Verona
  { province: 'VR', region: 'Veneto', name: 'Verona', bbox: [45.10, 10.55, 45.65, 11.45] },
  // PD - Padova
  { province: 'PD', region: 'Veneto', name: 'Padova', bbox: [45.05, 11.50, 45.65, 12.15] },
  // VE - Venezia
  { province: 'VE', region: 'Veneto', name: 'Venezia', bbox: [45.25, 12.05, 45.75, 12.65] },
  // FI - Firenze - zone periferiche
  { province: 'FI', region: 'Toscana', name: 'Firenze periferica', bbox: [43.55, 10.75, 44.05, 11.65] },
  // GE - Genova
  { province: 'GE', region: 'Liguria', name: 'Genova', bbox: [44.20, 8.65, 44.55, 9.25] },
  // PA - Palermo
  { province: 'PA', region: 'Sicilia', name: 'Palermo', bbox: [37.80, 13.10, 38.30, 13.75] },
  // CT - Catania
  { province: 'CT', region: 'Sicilia', name: 'Catania', bbox: [37.20, 14.75, 37.80, 15.35] },
  // BO - Bologna
  { province: 'BO', region: 'Emilia-Romagna', name: 'Bologna', bbox: [44.25, 10.95, 44.75, 11.75] },
  // LE - Lecce
  { province: 'LE', region: 'Puglia', name: 'Lecce', bbox: [39.75, 17.75, 40.45, 18.55] },
  // BA - Bari
  { province: 'BA', region: 'Puglia', name: 'Bari', bbox: [40.65, 16.55, 41.25, 17.25] },
  // MB - Monza-Brianza
  { province: 'MB', region: 'Lombardia', name: 'Monza-Brianza', bbox: [45.50, 9.10, 45.80, 9.55] },
  // PI - Pisa
  { province: 'PI', region: 'Toscana', name: 'Pisa', bbox: [43.45, 10.20, 43.95, 11.05] },
  // LI - Livorno
  { province: 'LI', region: 'Toscana', name: 'Livorno', bbox: [42.60, 10.15, 43.55, 10.85] },
];

// TUTTI i tag OSM possibili
const TAG_QUERIES = [
  // Cibo e bevande
  { key: 'amenity', val: 'restaurant', cat: 'Ristoranti' },
  { key: 'amenity', val: 'cafe', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'bar', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'fast_food', cat: 'Fast Food' },
  { key: 'amenity', val: 'pub', cat: 'Pub e Locali' },
  { key: 'amenity', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'amenity', val: 'food_court', cat: 'Ristoranti' },
  { key: 'amenity', val: 'biergarten', cat: 'Pub e Locali' },
  { key: 'amenity', val: 'nightclub', cat: 'Discoteche' },
  { key: 'amenity', val: 'stripclub', cat: 'Discoteche' },
  // Alimentari
  { key: 'shop', val: 'supermarket', cat: 'Supermercati' },
  { key: 'shop', val: 'convenience', cat: 'Alimentari' },
  { key: 'shop', val: 'bakery', cat: 'Panifici' },
  { key: 'shop', val: 'butcher', cat: 'Macellerie' },
  { key: 'shop', val: 'greengrocer', cat: 'Frutta e Verdura' },
  { key: 'shop', val: 'pastry', cat: 'Pasticcerie' },
  { key: 'shop', val: 'fishmonger', cat: 'Pescherie' },
  { key: 'shop', val: 'deli', cat: 'Gastronomie' },
  { key: 'shop', val: 'cheese', cat: 'Formaggerie' },
  { key: 'shop', val: 'dairy', cat: 'Latterie' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  { key: 'shop', val: 'alcohol', cat: 'Enoteche' },
  { key: 'shop', val: 'beverages', cat: 'Negozi di Bevande' },
  { key: 'shop', val: 'coffee', cat: 'Torrefazioni' },
  { key: 'shop', val: 'chocolate', cat: 'Cioccolaterie' },
  { key: 'shop', val: 'tea', cat: 'Negozi di Tè' },
  { key: 'shop', val: 'farm', cat: 'Prodotti Agricoli' },
  { key: 'shop', val: 'organic', cat: 'Alimentari' },
  { key: 'shop', val: 'spices', cat: 'Gastronomie' },
  { key: 'shop', val: 'nuts', cat: 'Gastronomie' },
  // Salute
  { key: 'amenity', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'amenity', val: 'hospital', cat: 'Ospedali' },
  { key: 'amenity', val: 'clinic', cat: 'Cliniche' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  { key: 'healthcare', val: 'physiotherapist', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'optometrist', cat: 'Ottici' },
  { key: 'healthcare', val: 'psychologist', cat: 'Psicologi' },
  { key: 'healthcare', val: 'laboratory', cat: 'Laboratori Analisi' },
  { key: 'healthcare', val: 'alternative', cat: 'Medicine Alternative' },
  { key: 'healthcare', val: 'nurse', cat: 'Infermieri' },
  { key: 'healthcare', val: 'podiatrist', cat: 'Podologi' },
  { key: 'healthcare', val: 'speech_therapist', cat: 'Logopedisti' },
  { key: 'healthcare', val: 'dietitian', cat: 'Nutrizionisti' },
  { key: 'healthcare', val: 'occupational_therapist', cat: 'Terapisti' },
  // Bellezza / Cura persona
  { key: 'shop', val: 'hairdresser', cat: 'Parrucchieri' },
  { key: 'shop', val: 'barber', cat: 'Parrucchieri e Barbieri' },
  { key: 'shop', val: 'beauty', cat: 'Centri Estetici' },
  { key: 'shop', val: 'cosmetics', cat: 'Profumerie' },
  { key: 'shop', val: 'optician', cat: 'Ottici' },
  { key: 'shop', val: 'tattoo', cat: 'Tatuatori' },
  { key: 'shop', val: 'massage', cat: 'Centri Massaggi' },
  { key: 'amenity', val: 'spa', cat: 'Centri Estetici' },
  { key: 'leisure', val: 'sauna', cat: 'Saune' },
  // Sport / Fitness
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'leisure', val: 'sports_centre', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'leisure', val: 'golf_course', cat: 'Golf' },
  { key: 'leisure', val: 'dance', cat: 'Scuole di Danza' },
  { key: 'sport', val: 'yoga', cat: 'Centri Yoga' },
  { key: 'sport', val: 'martial_arts', cat: 'Arti Marziali' },
  { key: 'sport', val: 'diving', cat: 'Sub e Diving' },
  { key: 'sport', val: 'climbing', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'shooting', cat: 'Poligoni di Tiro' },
  { key: 'sport', val: 'equestrian', cat: 'Maneggi' },
  { key: 'sport', val: 'tennis', cat: 'Tennis' },
  { key: 'sport', val: 'padel', cat: 'Padel' },
  { key: 'sport', val: 'bowling', cat: 'Bowling' },
  // Abbigliamento / Moda
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'fashion', cat: 'Moda' },
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'leather', cat: 'Pelletterie' },
  { key: 'shop', val: 'baby_goods', cat: 'Articoli per Bambini' },
  { key: 'shop', val: 'fabric', cat: 'Tessuti' },
  { key: 'shop', val: 'second_hand', cat: 'Usato' },
  { key: 'shop', val: 'vintage', cat: 'Usato' },
  { key: 'shop', val: 'underwear', cat: 'Abbigliamento' },
  { key: 'shop', val: 'sports', cat: 'Articoli Sportivi' },
  { key: 'shop', val: 'outdoor', cat: 'Outdoor e Camping' },
  { key: 'shop', val: 'ski', cat: 'Sci e Snowboard' },
  // Casa e arredamento
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'doityourself', cat: 'Fai da Te' },
  { key: 'shop', val: 'paint', cat: 'Colorifici' },
  { key: 'shop', val: 'lighting', cat: 'Illuminazione' },
  { key: 'shop', val: 'kitchen', cat: 'Cucine' },
  { key: 'shop', val: 'bathroom_furnishing', cat: 'Arredo Bagno' },
  { key: 'shop', val: 'tiles', cat: 'Piastrelle' },
  { key: 'shop', val: 'floor', cat: 'Pavimenti' },
  { key: 'shop', val: 'flooring', cat: 'Pavimenti' },
  { key: 'shop', val: 'carpet', cat: 'Tappeti' },
  { key: 'shop', val: 'curtain', cat: 'Tendaggi' },
  { key: 'shop', val: 'bed', cat: 'Materassi e Letti' },
  { key: 'shop', val: 'windows', cat: 'Infissi' },
  { key: 'shop', val: 'garden_centre', cat: 'Giardinaggio' },
  // Tecnologia / Elettronica
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'mobile_phone', cat: 'Telefonia' },
  { key: 'shop', val: 'computer', cat: 'Negozi di Computer' },
  { key: 'shop', val: 'hifi', cat: 'Hi-Fi' },
  { key: 'shop', val: 'video_games', cat: 'Videogiochi' },
  { key: 'shop', val: 'repair', cat: 'Riparazione Elettronica' },
  { key: 'shop', val: 'camera', cat: 'Fotocamere' },
  // Auto / Moto / Trasporti
  { key: 'amenity', val: 'fuel', cat: 'Distributori di Carburante' },
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'shop', val: 'car', cat: 'Concessionarie Auto' },
  { key: 'shop', val: 'tyres', cat: 'Pneumatici' },
  { key: 'shop', val: 'car_parts', cat: 'Ricambi Auto' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'amenity', val: 'car_wash', cat: 'Autolavaggi' },
  { key: 'amenity', val: 'car_rental', cat: 'Autonoleggi' },
  { key: 'amenity', val: 'vehicle_inspection', cat: 'Revisioni Auto' },
  { key: 'shop', val: 'motorcycle', cat: 'Moto' },
  { key: 'shop', val: 'bicycle', cat: 'Biciclette' },
  { key: 'amenity', val: 'bicycle_rental', cat: 'Noleggio Biciclette' },
  { key: 'amenity', val: 'charging_station', cat: 'Colonnine Ricarica' },
  // Servizi finanziari / Legali
  { key: 'amenity', val: 'bank', cat: 'Banche' },
  { key: 'amenity', val: 'atm', cat: 'Bancomat' },
  { key: 'amenity', val: 'post_office', cat: 'Poste' },
  { key: 'office', val: 'lawyer', cat: 'Avvocati' },
  { key: 'office', val: 'accountant', cat: 'Commercialisti' },
  { key: 'office', val: 'notary', cat: 'Notai' },
  { key: 'office', val: 'insurance', cat: 'Assicurazioni' },
  { key: 'office', val: 'financial', cat: 'Consulenti Finanziari' },
  { key: 'office', val: 'tax_advisor', cat: 'Consulenti Fiscali' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'office', val: 'travel_agent', cat: 'Agenzie di Viaggio' },
  { key: 'office', val: 'employment_agency', cat: 'Agenzie del Lavoro' },
  { key: 'office', val: 'surveyor', cat: 'Geometri' },
  { key: 'office', val: 'architect', cat: 'Architetti' },
  { key: 'office', val: 'engineer', cat: 'Ingegneri' },
  { key: 'office', val: 'consulting', cat: 'Consulenti' },
  { key: 'office', val: 'it', cat: 'Informatica' },
  { key: 'office', val: 'advertising_agency', cat: 'Agenzie Pubblicitarie' },
  { key: 'office', val: 'association', cat: 'Associazioni' },
  { key: 'office', val: 'ngo', cat: 'ONG' },
  { key: 'office', val: 'foundation', cat: 'Fondazioni' },
  { key: 'office', val: 'company', cat: 'Aziende' },
  // Istruzione
  { key: 'amenity', val: 'school', cat: 'Scuole' },
  { key: 'amenity', val: 'kindergarten', cat: 'Asili' },
  { key: 'amenity', val: 'university', cat: 'Università' },
  { key: 'amenity', val: 'language_school', cat: 'Scuole di Lingue' },
  { key: 'amenity', val: 'music_school', cat: 'Scuole di Musica' },
  { key: 'amenity', val: 'college', cat: 'Istituti Formativi' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  // Turismo / Ospitalità
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'tourism', val: 'hostel', cat: 'Ostelli' },
  { key: 'tourism', val: 'motel', cat: 'Motel' },
  { key: 'tourism', val: 'camp_site', cat: 'Campeggi' },
  { key: 'tourism', val: 'caravan_site', cat: 'Aree Camper' },
  { key: 'tourism', val: 'apartment', cat: 'Appartamenti' },
  { key: 'tourism', val: 'chalet', cat: 'Hotel' },
  // Artigianato
  { key: 'craft', val: 'plumber', cat: 'Idraulici' },
  { key: 'craft', val: 'electrician', cat: 'Elettricisti' },
  { key: 'craft', val: 'carpenter', cat: 'Falegnami' },
  { key: 'craft', val: 'locksmith', cat: 'Duplicazione Chiavi' },
  { key: 'craft', val: 'painter', cat: 'Imbianchini' },
  { key: 'craft', val: 'gardener', cat: 'Giardinieri' },
  { key: 'craft', val: 'tailor', cat: 'Sartorie' },
  { key: 'craft', val: 'watchmaker', cat: 'Orologiai' },
  { key: 'craft', val: 'jeweller', cat: 'Orefici' },
  { key: 'craft', val: 'shoemaker', cat: 'Calzolai' },
  { key: 'craft', val: 'blacksmith', cat: 'Fabbri' },
  { key: 'craft', val: 'hvac', cat: 'Climatizzazione' },
  { key: 'craft', val: 'tiler', cat: 'Piastrellisti' },
  { key: 'craft', val: 'glazier', cat: 'Vetrai' },
  { key: 'craft', val: 'stonemason', cat: 'Scalpellini' },
  { key: 'craft', val: 'upholsterer', cat: 'Tappezzieri' },
  { key: 'craft', val: 'pottery', cat: 'Ceramisti' },
  { key: 'craft', val: 'beekeeper', cat: 'Apicoltori' },
  { key: 'craft', val: 'floorer', cat: 'Posatori Parquet' },
  { key: 'craft', val: 'tinsmith', cat: 'Lattonieri' },
  { key: 'craft', val: 'photographer', cat: 'Fotografi' },
  { key: 'craft', val: 'printer', cat: 'Tipografie' },
  { key: 'craft', val: 'winery', cat: 'Cantine' },
  { key: 'craft', val: 'brewery', cat: 'Birrifici' },
  { key: 'craft', val: 'distillery', cat: 'Distillerie' },
  { key: 'craft', val: 'bakery', cat: 'Panifici' },
  { key: 'craft', val: 'builder', cat: 'Costruttori' },
  { key: 'craft', val: 'roofer', cat: 'Lattonieri' },
  { key: 'craft', val: 'welder', cat: 'Saldatori' },
  { key: 'craft', val: 'sailmaker', cat: 'Velai' },
  { key: 'craft', val: 'farrier', cat: 'Maniscalchi' },
  { key: 'craft', val: 'frame', cat: 'Cornici' },
  // Varie
  { key: 'shop', val: 'stationery', cat: 'Cartolerie' },
  { key: 'shop', val: 'books', cat: 'Librerie' },
  { key: 'shop', val: 'newsagent', cat: 'Giornali' },
  { key: 'shop', val: 'tobacco', cat: 'Tabaccherie' },
  { key: 'shop', val: 'gift', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'toys', cat: 'Giocattoli' },
  { key: 'shop', val: 'pet', cat: 'Negozi per Animali' },
  { key: 'shop', val: 'pet_grooming', cat: 'Toelettatura Animali' },
  { key: 'shop', val: 'photo', cat: 'Fotografia' },
  { key: 'shop', val: 'musical_instrument', cat: 'Strumenti Musicali' },
  { key: 'shop', val: 'music', cat: 'Negozi di Musica' },
  { key: 'shop', val: 'antiques', cat: 'Antiquari' },
  { key: 'shop', val: 'art', cat: "Gallerie d'Arte" },
  { key: 'shop', val: 'frame', cat: 'Cornici' },
  { key: 'amenity', val: 'arts_centre', cat: "Gallerie d'Arte" },
  { key: 'shop', val: 'funeral_directors', cat: 'Onoranze Funebri' },
  { key: 'amenity', val: 'laundry', cat: 'Lavanderie' },
  { key: 'shop', val: 'dry_cleaning', cat: 'Lavanderie' },
  { key: 'amenity', val: 'taxi', cat: 'Taxi' },
  { key: 'shop', val: 'variety_store', cat: 'Bazar' },
  { key: 'shop', val: 'department_store', cat: 'Grandi Magazzini' },
  { key: 'shop', val: 'mall', cat: 'Centri Commerciali' },
  { key: 'amenity', val: 'library', cat: 'Biblioteche' },
  { key: 'amenity', val: 'betting', cat: 'Ricevitorie' },
  { key: 'shop', val: 'fishing', cat: 'Pesca e Caccia' },
  { key: 'shop', val: 'weapons', cat: 'Armerie' },
  { key: 'shop', val: 'agrarian', cat: 'Consorzi Agrari' },
  { key: 'shop', val: 'model', cat: 'Modellismo' },
  { key: 'shop', val: 'e-cigarette', cat: 'Sigarette Elettroniche' },
  { key: 'shop', val: 'hairdresser_supply', cat: 'Forniture Parrucchieri' },
];

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie`);
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const body = `data=${encodeURIComponent(query)}`;
    const opts = {
      hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(body),
        'User-Agent': 'ItalianBizDir/9.0'
      }
    };
    const req = https.request(opts, res => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => {
        if (res.statusCode === 429) { reject(new Error('RATE_LIMIT')); return; }
        if (res.statusCode >= 400) { reject(new Error(`HTTP ${res.statusCode}`)); return; }
        try { resolve(JSON.parse(data)); } catch { reject(new Error('JSON')); }
      });
    });
    req.on('error', reject);
    req.setTimeout(120000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body); req.end();
  });
}

function buildQuery(tq, zone) {
  const [s, w, n, e] = zone.bbox;
  const bbox = `${s},${w},${n},${e}`;
  return `[out:json][timeout:90];\n(\n  node["${tq.key}"="${tq.val}"](${bbox});\n  way["${tq.key}"="${tq.val}"](${bbox});\n);\nout center tags;`;
}

function makeRecord(el, zone, catId) {
  const tags = el.tags || {};
  if (!tags.name) return null;
  const lat = el.lat ?? el.center?.lat;
  const lon = el.lon ?? el.center?.lon;
  if (!lat || !lon) return null;
  const street = tags['addr:street'] || '';
  const hnum = tags['addr:housenumber'] || '';
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || tags['addr:municipality'] || tags['addr:suburb'] || '';
  return {
    name: tags.name.substring(0, 200),
    category_id: catId,
    street: street ? (hnum ? `${street}, ${hnum}` : street) : null,
    city: city ? city.substring(0, 100) : zone.name,
    province: zone.province,
    region: zone.region,
    postal_code: tags['addr:postcode'] || null,
    country: 'Italia',
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '').substring(0, 50) || null,
    email: (tags.email || tags['contact:email'] || '').substring(0, 200) || null,
    website: (tags.website || tags['contact:website'] || '').substring(0, 500) || null,
    business_hours: tags.opening_hours || null,
    is_claimed: false,
    approval_status: 'approved',
  };
}

async function runTagZone(tq, zone) {
  const catId = categoryCache[tq.cat];
  if (!catId) return 0;
  const query = buildQuery(tq, zone);
  let elements = [];
  for (let retry = 0; retry < 3; retry++) {
    try {
      const data = await fetchOverpass(query);
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(90000); retry--; continue; }
      if (retry < 2) { await sleep((retry + 1) * 10000); continue; }
      return 0;
    }
  }
  const records = [];
  const seen = new Set();
  for (const el of elements) {
    const r = makeRecord(el, zone, catId);
    if (!r) continue;
    const key = `${r.name}|${r.province}|${r.latitude?.toFixed(4)}|${r.longitude?.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    records.push(r);
  }
  if (!records.length) return 0;
  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const batch = records.slice(i, i + 200);
    const { error } = await supabase.from('unclaimed_business_locations').insert(batch);
    if (!error) {
      inserted += batch.length;
    } else if (error.code === '23505') {
      for (const rec of batch) {
        const { error: e2 } = await supabase.from('unclaimed_business_locations').insert(rec);
        if (!e2) inserted++;
      }
    }
  }
  totalImported += inserted;
  return inserted;
}

async function main() {
  console.log(`\n=== IMPORTAZIONE COMUNI v2 - COPERTURA TOTALE ===`);
  console.log(`${TAG_QUERIES.length} tag x ${ZONES.length} zone\n`);
  await loadCategories();

  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    let tagTotal = 0;
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val} (${tq.cat}): `);

    for (const zone of ZONES) {
      const n = await runTagZone(tq, zone);
      if (n > 0) { process.stdout.write(`${zone.province}+${n} `); tagTotal += n; }
      await sleep(2000);
    }

    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   Subtotale tag: +${tagTotal} | Sessione: ${totalImported.toLocaleString()} (${mins}min)`);
    await sleep(3000);
  }

  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== COMPLETATO ===`);
  console.log(`Importati questa sessione: ${totalImported.toLocaleString()}`);
  console.log(`Totale DB: ${count?.toLocaleString()}`);
}

main().catch(console.error);
