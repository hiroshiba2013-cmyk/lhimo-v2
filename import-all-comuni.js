/**
 * Importazione mirata: comuni e province vuote
 * Usa bbox per province intere per catturare tutti i comuni
 * Priorità: province a 0 e < 300 attività
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

// Province intere con bbox ampie per catturare tutti i comuni
// Ordinate per priorità (0 prima, poi scarse)
const ZONES = [
  // ===== PROVINCE A 0 =====
  // RO - Rovigo
  { name: 'Provincia di Rovigo', region: 'Veneto', province: 'RO', bbox: [44.80, 11.50, 45.20, 12.40] },
  // PN - Pordenone
  { name: 'Provincia di Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.80, 12.40, 46.30, 13.00] },
  // GO - Gorizia
  { name: 'Provincia di Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.70, 13.40, 46.00, 13.80] },
  // IM - Imperia
  { name: 'Provincia di Imperia', region: 'Liguria', province: 'IM', bbox: [43.70, 7.50, 44.10, 8.20] },
  // MS - Massa Carrara
  { name: 'Provincia di Massa-Carrara', region: 'Toscana', province: 'MS', bbox: [44.00, 9.70, 44.50, 10.20] },
  // AP - Ascoli Piceno
  { name: 'Provincia di Ascoli Piceno', region: 'Marche', province: 'AP', bbox: [42.60, 13.30, 43.10, 14.00] },
  // FM - Fermo
  { name: 'Provincia di Fermo', region: 'Marche', province: 'FM', bbox: [42.90, 13.50, 43.40, 13.90] },
  // FR - Frosinone
  { name: 'Provincia di Frosinone', region: 'Lazio', province: 'FR', bbox: [41.40, 13.00, 41.90, 14.00] },
  // RI - Rieti
  { name: 'Provincia di Rieti', region: 'Lazio', province: 'RI', bbox: [42.00, 12.40, 42.60, 13.50] },
  // AV - Avellino
  { name: 'Provincia di Avellino', region: 'Campania', province: 'AV', bbox: [40.60, 14.60, 41.20, 15.30] },
  // EN - Enna
  { name: 'Provincia di Enna', region: 'Sicilia', province: 'EN', bbox: [37.30, 14.00, 37.90, 14.70] },
  // NU - Nuoro
  { name: 'Provincia di Nuoro', region: 'Sardegna', province: 'NU', bbox: [39.90, 8.90, 40.80, 9.90] },
  // OR - Oristano
  { name: 'Provincia di Oristano', region: 'Sardegna', province: 'OR', bbox: [39.50, 8.30, 40.40, 9.20] },
  // OT - Olbia-Tempio
  { name: 'Provincia di Olbia-Tempio', region: 'Sardegna', province: 'OT', bbox: [40.70, 8.80, 41.40, 9.80] },

  // ===== PROVINCE CON < 100 =====
  // VV - Vibo Valentia (6)
  { name: 'Provincia di Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.40, 15.80, 38.90, 16.50] },
  // SO - Sondrio (21)
  { name: 'Provincia di Sondrio', region: 'Lombardia', province: 'SO', bbox: [45.90, 9.20, 46.70, 10.70] },
  // BI - Biella (64)
  { name: 'Provincia di Biella', region: 'Piemonte', province: 'BI', bbox: [45.40, 7.90, 45.80, 8.30] },
  // LC - Lecco (65)
  { name: 'Provincia di Lecco', region: 'Lombardia', province: 'LC', bbox: [45.60, 9.20, 46.00, 9.70] },
  // BL - Belluno (129)
  { name: 'Provincia di Belluno', region: 'Veneto', province: 'BL', bbox: [45.90, 11.70, 46.70, 12.60] },

  // ===== PROVINCE CON < 200 =====
  // CL - Caltanissetta (103)
  { name: 'Provincia di Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [36.90, 13.60, 37.70, 14.60] },
  // VT - Viterbo (137)
  { name: 'Provincia di Viterbo', region: 'Lazio', province: 'VT', bbox: [42.10, 11.50, 42.80, 12.50] },
  // TE - Teramo (164)
  { name: 'Provincia di Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.40, 13.40, 42.90, 14.10] },
  // IS - Isernia (172)
  { name: 'Provincia di Isernia', region: 'Molise', province: 'IS', bbox: [41.40, 13.90, 41.90, 14.60] },
  // GR - Grosseto (191)
  { name: 'Provincia di Grosseto', region: 'Toscana', province: 'GR', bbox: [42.30, 10.60, 43.20, 11.90] },

  // ===== PROVINCE CON < 300 =====
  // CZ - Catanzaro (218)
  { name: 'Provincia di Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.50, 16.20, 39.20, 16.90] },
  // RC - Reggio Calabria (232)
  { name: 'Provincia di Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [37.80, 15.40, 38.60, 16.60] },
  // BN - Benevento (266)
  { name: 'Provincia di Benevento', region: 'Campania', province: 'BN', bbox: [41.00, 14.40, 41.40, 15.20] },
  // MC - Macerata (270)
  { name: 'Provincia di Macerata', region: 'Marche', province: 'MC', bbox: [42.90, 12.90, 43.60, 13.90] },
  // FG - Foggia (277)
  { name: 'Provincia di Foggia', region: 'Puglia', province: 'FG', bbox: [41.00, 14.90, 42.00, 16.20] },
  // SS - Sassari (291)
  { name: 'Provincia di Sassari', region: 'Sardegna', province: 'SS', bbox: [40.40, 8.10, 41.30, 9.30] },
  // CR - Cremona (291)
  { name: 'Provincia di Cremona', region: 'Lombardia', province: 'CR', bbox: [44.90, 9.70, 45.40, 10.40] },

  // ===== PROVINCE CON < 500 =====
  // AG - Agrigento (293)
  { name: 'Provincia di Agrigento', region: 'Sicilia', province: 'AG', bbox: [37.00, 12.80, 37.70, 14.00] },
  // PU - Pesaro e Urbino (302)
  { name: 'Provincia di Pesaro e Urbino', region: 'Marche', province: 'PU', bbox: [43.40, 12.00, 44.00, 13.20] },
  // TR - Terni (359)
  { name: 'Provincia di Terni', region: 'Umbria', province: 'TR', bbox: [42.30, 11.80, 42.80, 13.00] },
  // AR - Arezzo (398)
  { name: 'Provincia di Arezzo', region: 'Toscana', province: 'AR', bbox: [43.10, 11.40, 43.80, 12.30] },
  // PZ - Potenza (434)
  { name: 'Provincia di Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.00, 15.20, 41.20, 16.40] },
  // SA - Salerno (435)
  { name: 'Provincia di Salerno', region: 'Campania', province: 'SA', bbox: [39.90, 14.60, 41.00, 15.80] },
  // CS - Cosenza (447)
  { name: 'Provincia di Cosenza', region: 'Calabria', province: 'CS', bbox: [39.00, 15.60, 40.10, 16.80] },
  // LT - Latina (454)
  { name: 'Provincia di Latina', region: 'Lazio', province: 'LT', bbox: [41.10, 12.60, 41.70, 13.80] },

  // Città medie nelle province scarse - per catturare comuni piccoli
  // Molise - CB
  { name: 'Provincia di Campobasso', region: 'Molise', province: 'CB', bbox: [41.40, 14.40, 41.90, 15.20] },
  // KR - Crotone
  { name: 'Provincia di Crotone', region: 'Calabria', province: 'KR', bbox: [38.70, 16.60, 39.50, 17.50] },
  // MT - Matera
  { name: 'Provincia di Matera', region: 'Basilicata', province: 'MT', bbox: [39.90, 15.80, 40.80, 16.90] },
  // AQ - L Aquila
  { name: "Provincia dell'Aquila", region: 'Abruzzo', province: 'AQ', bbox: [41.70, 13.00, 42.60, 14.20] },
  // RG - Ragusa
  { name: 'Provincia di Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.70, 14.40, 37.30, 15.10] },
  // TP - Trapani
  { name: 'Provincia di Trapani', region: 'Sicilia', province: 'TP', bbox: [37.50, 12.20, 38.20, 13.20] },
  // MN - Mantova
  { name: 'Provincia di Mantova', region: 'Lombardia', province: 'MN', bbox: [44.90, 10.50, 45.30, 11.20] },
  // LO - Lodi
  { name: 'Provincia di Lodi', region: 'Lombardia', province: 'LO', bbox: [45.10, 9.30, 45.50, 9.80] },
  // PV - Pavia
  { name: 'Provincia di Pavia', region: 'Lombardia', province: 'PV', bbox: [44.80, 8.70, 45.40, 9.50] },
  // VC - Vercelli
  { name: 'Provincia di Vercelli', region: 'Piemonte', province: 'VC', bbox: [45.00, 8.00, 45.60, 8.70] },
  // SP - La Spezia
  { name: 'Provincia di La Spezia', region: 'Liguria', province: 'SP', bbox: [43.90, 9.50, 44.30, 10.00] },
  // SV - Savona
  { name: 'Provincia di Savona', region: 'Liguria', province: 'SV', bbox: [43.90, 8.00, 44.50, 8.80] },
  // PC - Piacenza
  { name: 'Provincia di Piacenza', region: 'Emilia-Romagna', province: 'PC', bbox: [44.60, 9.20, 45.20, 10.10] },
  // FE - Ferrara
  { name: 'Provincia di Ferrara', region: 'Emilia-Romagna', province: 'FE', bbox: [44.50, 11.40, 45.00, 12.10] },
  // PT - Pistoia
  { name: 'Provincia di Pistoia', region: 'Toscana', province: 'PT', bbox: [43.70, 10.60, 44.20, 11.20] },
  // PO - Prato
  { name: 'Provincia di Prato', region: 'Toscana', province: 'PO', bbox: [43.70, 10.80, 44.10, 11.30] },
  // PG - Perugia
  { name: 'Provincia di Perugia', region: 'Umbria', province: 'PG', bbox: [42.50, 11.80, 43.60, 13.10] },
  // AN - Ancona
  { name: 'Provincia di Ancona', region: 'Marche', province: 'AN', bbox: [43.20, 12.80, 43.80, 13.70] },
  // CH - Chieti
  { name: 'Provincia di Chieti', region: 'Abruzzo', province: 'CH', bbox: [41.90, 13.80, 42.60, 14.80] },
  // CE - Caserta
  { name: 'Provincia di Caserta', region: 'Campania', province: 'CE', bbox: [40.90, 13.80, 41.40, 14.60] },
  // BT - Barletta-Andria-Trani
  { name: 'Provincia BAT', region: 'Puglia', province: 'BT', bbox: [41.00, 15.90, 41.50, 16.60] },
  // BR - Brindisi
  { name: 'Provincia di Brindisi', region: 'Puglia', province: 'BR', bbox: [40.30, 17.40, 40.90, 18.20] },
  // TA - Taranto
  { name: 'Provincia di Taranto', region: 'Puglia', province: 'TA', bbox: [40.10, 16.60, 40.70, 17.80] },
  // CA - Cagliari
  { name: 'Provincia di Cagliari', region: 'Sardegna', province: 'CA', bbox: [38.80, 8.60, 39.50, 9.60] },
];

// Tag principali per riempire i comuni
const TAG_QUERIES = [
  { key: 'amenity', val: 'restaurant', cat: 'Ristoranti' },
  { key: 'amenity', val: 'cafe', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'bar', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'fast_food', cat: 'Fast Food' },
  { key: 'amenity', val: 'pub', cat: 'Pub e Locali' },
  { key: 'amenity', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'shop', val: 'supermarket', cat: 'Supermercati' },
  { key: 'shop', val: 'convenience', cat: 'Alimentari' },
  { key: 'shop', val: 'bakery', cat: 'Panifici' },
  { key: 'shop', val: 'butcher', cat: 'Macellerie' },
  { key: 'shop', val: 'greengrocer', cat: 'Frutta e Verdura' },
  { key: 'shop', val: 'pastry', cat: 'Pasticcerie' },
  { key: 'shop', val: 'fishmonger', cat: 'Pescherie' },
  { key: 'shop', val: 'deli', cat: 'Gastronomie' },
  { key: 'amenity', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'amenity', val: 'hospital', cat: 'Ospedali' },
  { key: 'amenity', val: 'clinic', cat: 'Cliniche' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  { key: 'healthcare', val: 'physiotherapist', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'optometrist', cat: 'Ottici' },
  { key: 'shop', val: 'optician', cat: 'Ottici' },
  { key: 'shop', val: 'hairdresser', cat: 'Parrucchieri' },
  { key: 'shop', val: 'barber', cat: 'Parrucchieri e Barbieri' },
  { key: 'shop', val: 'beauty', cat: 'Centri Estetici' },
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'mobile_phone', cat: 'Telefonia' },
  { key: 'shop', val: 'stationery', cat: 'Cartolerie' },
  { key: 'shop', val: 'books', cat: 'Librerie' },
  { key: 'shop', val: 'newsagent', cat: 'Giornali' },
  { key: 'shop', val: 'tobacco', cat: 'Tabaccherie' },
  { key: 'amenity', val: 'fuel', cat: 'Distributori di Carburante' },
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'shop', val: 'car', cat: 'Concessionarie Auto' },
  { key: 'shop', val: 'tyres', cat: 'Pneumatici' },
  { key: 'shop', val: 'car_parts', cat: 'Ricambi Auto' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'amenity', val: 'bank', cat: 'Banche' },
  { key: 'amenity', val: 'post_office', cat: 'Poste' },
  { key: 'amenity', val: 'atm', cat: 'Bancomat' },
  { key: 'office', val: 'lawyer', cat: 'Avvocati' },
  { key: 'office', val: 'accountant', cat: 'Commercialisti' },
  { key: 'office', val: 'notary', cat: 'Notai' },
  { key: 'office', val: 'insurance', cat: 'Assicurazioni' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'amenity', val: 'school', cat: 'Scuole' },
  { key: 'amenity', val: 'kindergarten', cat: 'Asili' },
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'tourism', val: 'camp_site', cat: 'Campeggi' },
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'leisure', val: 'sports_centre', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'amenity', val: 'nightclub', cat: 'Discoteche' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
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
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'pet', cat: 'Negozi per Animali' },
  { key: 'shop', val: 'toys', cat: 'Giocattoli' },
  { key: 'shop', val: 'gift', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'garden_centre', cat: 'Giardinaggio' },
  { key: 'shop', val: 'doityourself', cat: 'Fai da Te' },
  { key: 'shop', val: 'bicycle', cat: 'Biciclette' },
  { key: 'shop', val: 'motorcycle', cat: 'Moto' },
  { key: 'shop', val: 'sports', cat: 'Articoli Sportivi' },
  { key: 'shop', val: 'outdoor', cat: 'Outdoor e Camping' },
  { key: 'shop', val: 'photo', cat: 'Fotografia' },
  { key: 'shop', val: 'musical_instrument', cat: 'Strumenti Musicali' },
  { key: 'shop', val: 'second_hand', cat: 'Usato' },
  { key: 'shop', val: 'antiques', cat: 'Antiquari' },
  { key: 'amenity', val: 'laundry', cat: 'Lavanderie' },
  { key: 'amenity', val: 'car_wash', cat: 'Autolavaggi' },
  { key: 'amenity', val: 'car_rental', cat: 'Autonoleggi' },
  { key: 'amenity', val: 'taxi', cat: 'Taxi' },
  { key: 'office', val: 'travel_agent', cat: 'Agenzie di Viaggio' },
  { key: 'office', val: 'architect', cat: 'Architetti' },
  { key: 'office', val: 'engineer', cat: 'Ingegneri' },
  { key: 'office', val: 'consulting', cat: 'Consulenti' },
  { key: 'office', val: 'association', cat: 'Associazioni' },
  { key: 'shop', val: 'cosmetics', cat: 'Profumerie' },
  { key: 'shop', val: 'cheese', cat: 'Formaggerie' },
  { key: 'shop', val: 'dairy', cat: 'Latterie' },
  { key: 'shop', val: 'beverages', cat: 'Negozi di Bevande' },
  { key: 'shop', val: 'coffee', cat: 'Torrefazioni' },
  { key: 'shop', val: 'computer', cat: 'Negozi di Computer' },
  { key: 'shop', val: 'paint', cat: 'Colorifici' },
  { key: 'shop', val: 'lighting', cat: 'Illuminazione' },
  { key: 'shop', val: 'kitchen', cat: 'Cucine' },
  { key: 'shop', val: 'tattoo', cat: 'Tatuatori' },
  { key: 'shop', val: 'farm', cat: 'Prodotti Agricoli' },
  { key: 'craft', val: 'winery', cat: 'Cantine' },
  { key: 'craft', val: 'brewery', cat: 'Birrifici' },
  { key: 'craft', val: 'distillery', cat: 'Distillerie' },
  { key: 'craft', val: 'bakery', cat: 'Panifici' },
  { key: 'craft', val: 'photographer', cat: 'Fotografi' },
  { key: 'craft', val: 'printer', cat: 'Tipografie' },
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
  { key: 'healthcare', val: 'psychologist', cat: 'Psicologi' },
  { key: 'healthcare', val: 'laboratory', cat: 'Laboratori Analisi' },
  { key: 'healthcare', val: 'alternative', cat: 'Medicine Alternative' },
  { key: 'amenity', val: 'library', cat: 'Biblioteche' },
  { key: 'amenity', val: 'language_school', cat: 'Scuole di Lingue' },
  { key: 'amenity', val: 'music_school', cat: 'Scuole di Musica' },
  { key: 'amenity', val: 'university', cat: 'Università' },
  { key: 'amenity', val: 'betting', cat: 'Ricevitorie' },
  { key: 'amenity', val: 'charging_station', cat: 'Colonnine Ricarica' },
  { key: 'amenity', val: 'vehicle_inspection', cat: 'Revisioni Auto' },
  { key: 'tourism', val: 'hostel', cat: 'Ostelli' },
  { key: 'tourism', val: 'caravan_site', cat: 'Aree Camper' },
  { key: 'tourism', val: 'apartment', cat: 'Appartamenti' },
  { key: 'shop', val: 'funeral_directors', cat: 'Onoranze Funebri' },
  { key: 'shop', val: 'massage', cat: 'Centri Massaggi' },
  { key: 'shop', val: 'pet_grooming', cat: 'Toelettatura Animali' },
  { key: 'shop', val: 'fabric', cat: 'Tessuti' },
  { key: 'shop', val: 'floor', cat: 'Pavimenti' },
  { key: 'shop', val: 'tiles', cat: 'Piastrelle' },
  { key: 'shop', val: 'windows', cat: 'Infissi' },
  { key: 'shop', val: 'variety_store', cat: 'Bazar' },
  { key: 'sport', val: 'yoga', cat: 'Centri Yoga' },
  { key: 'sport', val: 'martial_arts', cat: 'Arti Marziali' },
  { key: 'sport', val: 'diving', cat: 'Sub e Diving' },
  { key: 'leisure', val: 'sauna', cat: 'Saune' },
  { key: 'leisure', val: 'golf_course', cat: 'Golf' },
  { key: 'leisure', val: 'dance', cat: 'Scuole di Danza' },
  { key: 'shop', val: 'e-cigarette', cat: 'Sigarette Elettroniche' },
  { key: 'shop', val: 'agrarian', cat: 'Consorzi Agrari' },
  { key: 'shop', val: 'fishing', cat: 'Pesca e Caccia' },
  { key: 'shop', val: 'weapons', cat: 'Armerie' },
  { key: 'shop', val: 'ski', cat: 'Sci e Snowboard' },
  { key: 'shop', val: 'video_games', cat: 'Videogiochi' },
  { key: 'shop', val: 'repair', cat: 'Riparazione Elettronica' },
  { key: 'shop', val: 'model', cat: 'Modellismo' },
  { key: 'shop', val: 'chocolate', cat: 'Cioccolaterie' },
  { key: 'shop', val: 'leather', cat: 'Pelletterie' },
  { key: 'shop', val: 'baby_goods', cat: 'Articoli per Bambini' },
  { key: 'shop', val: 'hairdresser_supply', cat: 'Forniture Parrucchieri' },
  { key: 'shop', val: 'art', cat: 'Gallerie d Arte' },
  { key: 'office', val: 'employment_agency', cat: 'Agenzie del Lavoro' },
  { key: 'office', val: 'advertising_agency', cat: 'Agenzie Pubblicitarie' },
  { key: 'office', val: 'financial', cat: 'Consulenti Finanziari' },
  { key: 'office', val: 'tax_advisor', cat: 'Consulenti Fiscali' },
  { key: 'office', val: 'it', cat: 'Informatica' },
  { key: 'office', val: 'ngo', cat: 'ONG' },
  { key: 'office', val: 'foundation', cat: 'Fondazioni' },
  { key: 'office', val: 'surveyor', cat: 'Geometri' },
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
        'User-Agent': 'ItalianBizDir/8.0'
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

function buildQuery(tagQuery, zone) {
  const [s, w, n, e] = zone.bbox;
  const bbox = `${s},${w},${n},${e}`;
  return `[out:json][timeout:90];\n(\n  node["${tagQuery.key}"="${tagQuery.val}"](${bbox});\n  way["${tagQuery.key}"="${tagQuery.val}"](${bbox});\n);\nout center tags;`;
}

function makeRecord(el, zone, catId) {
  const tags = el.tags || {};
  if (!tags.name) return null;
  const lat = el.lat ?? el.center?.lat;
  const lon = el.lon ?? el.center?.lon;
  if (!lat || !lon) return null;
  const street = tags['addr:street'] || '';
  const hnum = tags['addr:housenumber'] || '';
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || tags['addr:municipality'] || '';
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

async function runTagZone(tagQuery, zone) {
  const catId = categoryCache[tagQuery.cat];
  if (!catId) return 0;

  const query = buildQuery(tagQuery, zone);
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
  console.log(`\n=== IMPORTAZIONE COMUNI VUOTI - PROVINCE INTERE ===`);
  console.log(`${TAG_QUERIES.length} tag OSM x ${ZONES.length} province/zone\n`);
  await loadCategories();

  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    let tagTotal = 0;
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val} -> ${tq.cat}: `);

    for (const zone of ZONES) {
      const n = await runTagZone(tq, zone);
      if (n > 0) { process.stdout.write(`${zone.province}(+${n}) `); tagTotal += n; }
      await sleep(2500);
    }

    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   Tag totale: +${tagTotal} | Sessione: ${totalImported.toLocaleString()} (${mins}min)`);
    await sleep(3000);
  }

  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== COMPLETATO ===`);
  console.log(`Importati questa sessione: ${totalImported.toLocaleString()}`);
  console.log(`Totale nel DB: ${count?.toLocaleString()}`);
}

main().catch(console.error);
