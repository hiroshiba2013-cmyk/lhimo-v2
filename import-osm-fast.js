/**
 * Importazione mirata per categorie con 0 o pochi record
 * Una query per tag alla volta per evitare timeout
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const CITIES = [
  { name: 'Torino', region: 'Piemonte', province: 'TO', bbox: [44.94, 7.56, 45.18, 7.80] },
  { name: 'Milano', region: 'Lombardia', province: 'MI', bbox: [45.34, 9.04, 45.58, 9.32] },
  { name: 'Genova', region: 'Liguria', province: 'GE', bbox: [44.32, 8.82, 44.52, 9.04] },
  { name: 'Aosta', region: "Valle d'Aosta", province: 'AO', bbox: [45.68, 7.25, 45.84, 7.41] },
  { name: 'Novara', region: 'Piemonte', province: 'NO', bbox: [45.40, 8.54, 45.56, 8.72] },
  { name: 'Cuneo', region: 'Piemonte', province: 'CN', bbox: [44.32, 7.48, 44.52, 7.68] },
  { name: 'Alessandria', region: 'Piemonte', province: 'AL', bbox: [44.84, 8.54, 45.04, 8.74] },
  { name: 'Asti', region: 'Piemonte', province: 'AT', bbox: [44.82, 8.12, 45.02, 8.32] },
  { name: 'Brescia', region: 'Lombardia', province: 'BS', bbox: [45.46, 10.14, 45.66, 10.34] },
  { name: 'Bergamo', region: 'Lombardia', province: 'BG', bbox: [45.62, 9.60, 45.82, 9.80] },
  { name: 'Como', region: 'Lombardia', province: 'CO', bbox: [45.74, 9.02, 45.94, 9.22] },
  { name: 'Varese', region: 'Lombardia', province: 'VA', bbox: [45.74, 8.74, 45.94, 8.94] },
  { name: 'Monza', region: 'Lombardia', province: 'MB', bbox: [45.52, 9.20, 45.72, 9.40] },
  { name: 'Pavia', region: 'Lombardia', province: 'PV', bbox: [45.12, 9.08, 45.32, 9.28] },
  { name: 'Cremona', region: 'Lombardia', province: 'CR', bbox: [45.06, 9.96, 45.26, 10.16] },
  { name: 'Mantova', region: 'Lombardia', province: 'MN', bbox: [45.10, 10.70, 45.30, 10.90] },
  { name: 'Lecco', region: 'Lombardia', province: 'LC', bbox: [45.78, 9.32, 45.98, 9.52] },
  { name: 'Lodi', region: 'Lombardia', province: 'LO', bbox: [45.26, 9.44, 45.46, 9.64] },
  { name: 'Sondrio', region: 'Lombardia', province: 'SO', bbox: [46.12, 9.80, 46.32, 10.00] },
  { name: 'La Spezia', region: 'Liguria', province: 'SP', bbox: [44.04, 9.74, 44.24, 9.94] },
  { name: 'Savona', region: 'Liguria', province: 'SV', bbox: [44.26, 8.42, 44.46, 8.62] },
  { name: 'Imperia', region: 'Liguria', province: 'IM', bbox: [43.86, 7.96, 44.06, 8.16] },
  { name: 'Venezia', region: 'Veneto', province: 'VE', bbox: [45.34, 12.24, 45.54, 12.44] },
  { name: 'Verona', region: 'Veneto', province: 'VR', bbox: [45.34, 10.90, 45.54, 11.10] },
  { name: 'Padova', region: 'Veneto', province: 'PD', bbox: [45.32, 11.78, 45.52, 11.98] },
  { name: 'Vicenza', region: 'Veneto', province: 'VI', bbox: [45.48, 11.46, 45.68, 11.66] },
  { name: 'Treviso', region: 'Veneto', province: 'TV', bbox: [45.60, 12.18, 45.80, 12.38] },
  { name: 'Belluno', region: 'Veneto', province: 'BL', bbox: [46.08, 12.16, 46.28, 12.36] },
  { name: 'Rovigo', region: 'Veneto', province: 'RO', bbox: [44.94, 11.74, 45.14, 11.94] },
  { name: 'Trieste', region: 'Friuli-Venezia Giulia', province: 'TS', bbox: [45.56, 13.68, 45.76, 13.88] },
  { name: 'Udine', region: 'Friuli-Venezia Giulia', province: 'UD', bbox: [46.00, 13.16, 46.20, 13.36] },
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.90, 12.58, 46.10, 12.78] },
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.88, 13.56, 46.08, 13.76] },
  { name: 'Trento', region: 'Trentino-Alto Adige', province: 'TN', bbox: [46.00, 11.06, 46.20, 11.26] },
  { name: 'Bolzano', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.42, 11.26, 46.62, 11.46] },
  { name: 'Bologna', region: 'Emilia-Romagna', province: 'BO', bbox: [44.40, 11.24, 44.60, 11.44] },
  { name: 'Modena', region: 'Emilia-Romagna', province: 'MO', bbox: [44.56, 10.84, 44.76, 11.04] },
  { name: 'Parma', region: 'Emilia-Romagna', province: 'PR', bbox: [44.70, 10.24, 44.90, 10.44] },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'RE', bbox: [44.60, 10.54, 44.80, 10.74] },
  { name: 'Ferrara', region: 'Emilia-Romagna', province: 'FE', bbox: [44.76, 11.54, 44.96, 11.74] },
  { name: 'Rimini', region: 'Emilia-Romagna', province: 'RN', bbox: [43.98, 12.48, 44.18, 12.68] },
  { name: 'Ravenna', region: 'Emilia-Romagna', province: 'RA', bbox: [44.32, 12.12, 44.52, 12.32] },
  { name: 'Piacenza', region: 'Emilia-Romagna', province: 'PC', bbox: [44.98, 9.62, 45.18, 9.82] },
  { name: 'Forlì', region: 'Emilia-Romagna', province: 'FC', bbox: [44.18, 12.00, 44.38, 12.20] },
  { name: 'Cesena', region: 'Emilia-Romagna', province: 'FC', bbox: [44.10, 12.20, 44.30, 12.40] },
  { name: 'Roma', region: 'Lazio', province: 'RM', bbox: [41.74, 12.34, 42.02, 12.62] },
  { name: 'Firenze', region: 'Toscana', province: 'FI', bbox: [43.68, 11.16, 43.88, 11.36] },
  { name: 'Ancona', region: 'Marche', province: 'AN', bbox: [43.52, 13.44, 43.72, 13.64] },
  { name: 'Perugia', region: 'Umbria', province: 'PG', bbox: [43.02, 12.30, 43.22, 12.50] },
  { name: 'Livorno', region: 'Toscana', province: 'LI', bbox: [43.46, 10.24, 43.66, 10.44] },
  { name: 'Pisa', region: 'Toscana', province: 'PI', bbox: [43.64, 10.32, 43.84, 10.52] },
  { name: 'Arezzo', region: 'Toscana', province: 'AR', bbox: [43.40, 11.80, 43.60, 12.00] },
  { name: 'Siena', region: 'Toscana', province: 'SI', bbox: [43.26, 11.24, 43.46, 11.44] },
  { name: 'Prato', region: 'Toscana', province: 'PO', bbox: [43.80, 11.00, 44.00, 11.20] },
  { name: 'Lucca', region: 'Toscana', province: 'LU', bbox: [43.76, 10.42, 43.96, 10.62] },
  { name: 'Pistoia', region: 'Toscana', province: 'PT', bbox: [43.86, 10.84, 44.06, 11.04] },
  { name: 'Massa', region: 'Toscana', province: 'MS', bbox: [43.96, 10.06, 44.16, 10.26] },
  { name: 'Grosseto', region: 'Toscana', province: 'GR', bbox: [42.70, 11.02, 42.90, 11.22] },
  { name: 'Latina', region: 'Lazio', province: 'LT', bbox: [41.38, 12.82, 41.58, 13.02] },
  { name: 'Frosinone', region: 'Lazio', province: 'FR', bbox: [41.57, 13.27, 41.77, 13.47] },
  { name: 'Viterbo', region: 'Lazio', province: 'VT', bbox: [42.34, 12.00, 42.54, 12.20] },
  { name: 'Rieti', region: 'Lazio', province: 'RI', bbox: [42.34, 12.78, 42.54, 12.98] },
  { name: 'Pesaro', region: 'Marche', province: 'PU', bbox: [43.84, 12.84, 44.04, 13.04] },
  { name: 'Macerata', region: 'Marche', province: 'MC', bbox: [43.23, 13.39, 43.43, 13.59] },
  { name: 'Ascoli Piceno', region: 'Marche', province: 'AP', bbox: [42.80, 13.53, 43.00, 13.73] },
  { name: 'Fermo', region: 'Marche', province: 'FM', bbox: [43.11, 13.67, 43.27, 13.83] },
  { name: 'Terni', region: 'Umbria', province: 'TR', bbox: [42.48, 12.56, 42.68, 12.76] },
  { name: "L'Aquila", region: 'Abruzzo', province: 'AQ', bbox: [42.29, 13.29, 42.49, 13.49] },
  { name: 'Pescara', region: 'Abruzzo', province: 'PE', bbox: [42.38, 14.14, 42.58, 14.34] },
  { name: 'Chieti', region: 'Abruzzo', province: 'CH', bbox: [42.30, 14.10, 42.50, 14.30] },
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.61, 13.66, 42.76, 13.82] },
  { name: 'Napoli', region: 'Campania', province: 'NA', bbox: [40.74, 14.14, 40.94, 14.34] },
  { name: 'Salerno', region: 'Campania', province: 'SA', bbox: [40.60, 14.68, 40.80, 14.88] },
  { name: 'Caserta', region: 'Campania', province: 'CE', bbox: [41.00, 14.26, 41.20, 14.46] },
  { name: 'Benevento', region: 'Campania', province: 'BN', bbox: [41.06, 14.72, 41.26, 14.92] },
  { name: 'Avellino', region: 'Campania', province: 'AV', bbox: [40.85, 14.73, 41.05, 14.93] },
  { name: 'Bari', region: 'Puglia', province: 'BA', bbox: [41.02, 16.78, 41.22, 16.98] },
  { name: 'Foggia', region: 'Puglia', province: 'FG', bbox: [41.38, 15.48, 41.58, 15.68] },
  { name: 'Lecce', region: 'Puglia', province: 'LE', bbox: [40.28, 18.10, 40.48, 18.30] },
  { name: 'Taranto', region: 'Puglia', province: 'TA', bbox: [40.38, 17.16, 40.58, 17.36] },
  { name: 'Brindisi', region: 'Puglia', province: 'BR', bbox: [40.56, 17.86, 40.76, 18.06] },
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.57, 15.73, 40.77, 15.93] },
  { name: 'Matera', region: 'Basilicata', province: 'MT', bbox: [40.58, 16.52, 40.78, 16.72] },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.22, 16.18, 39.42, 16.38] },
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [38.02, 15.56, 38.22, 15.76] },
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.82, 16.52, 39.02, 16.72] },
  { name: 'Crotone', region: 'Calabria', province: 'KR', bbox: [38.93, 17.04, 39.13, 17.24] },
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.63, 16.04, 38.83, 16.24] },
  { name: 'Campobasso', region: 'Molise', province: 'CB', bbox: [41.49, 14.58, 41.69, 14.78] },
  { name: 'Isernia', region: 'Molise', province: 'IS', bbox: [41.55, 14.18, 41.65, 14.28] },
  { name: 'Palermo', region: 'Sicilia', province: 'PA', bbox: [38.02, 13.26, 38.22, 13.46] },
  { name: 'Catania', region: 'Sicilia', province: 'CT', bbox: [37.42, 15.00, 37.62, 15.20] },
  { name: 'Messina', region: 'Sicilia', province: 'ME', bbox: [38.10, 15.46, 38.30, 15.66] },
  { name: 'Siracusa', region: 'Sicilia', province: 'SR', bbox: [37.00, 15.22, 37.20, 15.42] },
  { name: 'Agrigento', region: 'Sicilia', province: 'AG', bbox: [37.24, 13.52, 37.44, 13.72] },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.86, 14.66, 37.06, 14.86] },
  { name: 'Trapani', region: 'Sicilia', province: 'TP', bbox: [37.94, 12.46, 38.14, 12.66] },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [37.42, 13.98, 37.62, 14.18] },
  { name: 'Enna', region: 'Sicilia', province: 'EN', bbox: [37.50, 14.22, 37.70, 14.42] },
  { name: 'Cagliari', region: 'Sardegna', province: 'CA', bbox: [39.14, 9.02, 39.34, 9.22] },
  { name: 'Sassari', region: 'Sardegna', province: 'SS', bbox: [40.66, 8.48, 40.86, 8.68] },
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', bbox: [40.25, 9.26, 40.45, 9.46] },
  { name: 'Oristano', region: 'Sardegna', province: 'OR', bbox: [39.85, 8.54, 40.05, 8.74] },
  { name: 'Olbia', region: 'Sardegna', province: 'OT', bbox: [40.87, 9.45, 41.07, 9.65] },
];

// Ogni TAG_QUERY e' una singola query OSM -> categoria
const TAG_QUERIES = [
  // Pizzerie
  { key: 'amenity', val: 'restaurant', filter: 'cuisine~"pizza"', cat: 'Pizzerie' },
  { key: 'amenity', val: 'fast_food', filter: 'cuisine~"pizza"', cat: 'Pizzerie' },
  // Panifici
  { key: 'shop', val: 'bakery', cat: 'Panifici' },
  { key: 'craft', val: 'bakery', cat: 'Panifici' },
  // Pastifici
  { key: 'craft', val: 'pasta', cat: 'Pastifici' },
  // Distillerie
  { key: 'craft', val: 'distillery', cat: 'Distillerie' },
  // Birrifici
  { key: 'craft', val: 'brewery', cat: 'Birrifici' },
  // Cantine
  { key: 'craft', val: 'winery', cat: 'Cantine' },
  { key: 'amenity', val: 'winery', cat: 'Cantine' },
  // Pub
  { key: 'amenity', val: 'pub', cat: 'Pub e Locali' },
  { key: 'amenity', val: 'biergarten', cat: 'Pub e Locali' },
  // Yoga
  { key: 'sport', val: 'yoga', cat: 'Centri Yoga' },
  { key: 'leisure', val: 'yoga', cat: 'Centri Yoga' },
  // Saune
  { key: 'leisure', val: 'sauna', cat: 'Saune' },
  { key: 'amenity', val: 'sauna', cat: 'Saune' },
  // Golf
  { key: 'leisure', val: 'golf_course', cat: 'Golf' },
  { key: 'sport', val: 'golf', cat: 'Golf' },
  // Sub
  { key: 'sport', val: 'diving', cat: 'Sub e Diving' },
  { key: 'shop', val: 'diving', cat: 'Sub e Diving' },
  // Arti marziali
  { key: 'sport', val: 'martial_arts', cat: 'Arti Marziali' },
  { key: 'sport', val: 'judo', cat: 'Arti Marziali' },
  { key: 'sport', val: 'karate', cat: 'Arti Marziali' },
  // Massaggi
  { key: 'amenity', val: 'massage', cat: 'Centri Massaggi' },
  { key: 'shop', val: 'massage', cat: 'Centri Massaggi' },
  // Onoranze funebri
  { key: 'amenity', val: 'funeral_directors', cat: 'Onoranze Funebri' },
  { key: 'shop', val: 'funeral_directors', cat: 'Onoranze Funebri' },
  // Toelettatura
  { key: 'shop', val: 'pet_grooming', cat: 'Toelettatura Animali' },
  // Taxi
  { key: 'amenity', val: 'taxi', cat: 'Taxi' },
  // Sartorie
  { key: 'shop', val: 'tailor', cat: 'Sartorie' },
  { key: 'craft', val: 'tailor', cat: 'Sartorie' },
  // Università
  { key: 'amenity', val: 'university', cat: 'Università' },
  { key: 'amenity', val: 'college', cat: 'Istituti Formativi' },
  // Fotografi
  { key: 'craft', val: 'photographer', cat: 'Fotografi' },
  { key: 'shop', val: 'photo', cat: 'Fotografi' },
  { key: 'shop', val: 'camera', cat: 'Fotocamere' },
  { key: 'shop', val: 'hifi', cat: 'Hi-Fi' },
  // Pneumatici
  { key: 'shop', val: 'tyres', cat: 'Pneumatici' },
  // Revisioni
  { key: 'amenity', val: 'vehicle_inspection', cat: 'Revisioni Auto' },
  // Artigiani edili
  { key: 'craft', val: 'plumber', cat: 'Idraulici' },
  { key: 'craft', val: 'electrician', cat: 'Elettricisti' },
  { key: 'craft', val: 'builder', cat: 'Costruttori' },
  { key: 'craft', val: 'hvac', cat: 'Climatizzazione' },
  { key: 'craft', val: 'painter', cat: 'Imbianchini' },
  { key: 'craft', val: 'carpenter', cat: 'Falegnami' },
  { key: 'craft', val: 'stonemason', cat: 'Scalpellini' },
  { key: 'craft', val: 'scaffolder', cat: 'Ponteggiatori' },
  { key: 'craft', val: 'tiler', cat: 'Piastrellisti' },
  { key: 'craft', val: 'floorer', cat: 'Posatori Parquet' },
  { key: 'craft', val: 'glazier', cat: 'Vetrai' },
  { key: 'craft', val: 'locksmith', cat: 'Duplicazione Chiavi' },
  { key: 'craft', val: 'blacksmith', cat: 'Fabbri' },
  { key: 'craft', val: 'watchmaker', cat: 'Orologiai' },
  { key: 'craft', val: 'gardener', cat: 'Giardinieri' },
  { key: 'craft', val: 'beekeeper', cat: 'Apicoltori' },
  { key: 'craft', val: 'jeweller', cat: 'Orefici' },
  { key: 'craft', val: 'shoemaker', cat: 'Calzolai' },
  // Shop vari
  { key: 'shop', val: 'motorcycle', cat: 'Moto' },
  { key: 'shop', val: 'windows', cat: 'Infissi' },
  { key: 'shop', val: 'lighting', cat: 'Illuminazione' },
  { key: 'shop', val: 'bed', cat: 'Materassi e Letti' },
  { key: 'shop', val: 'curtain', cat: 'Tendaggi' },
  { key: 'shop', val: 'variety_store', cat: 'Bazar' },
  { key: 'shop', val: 'newsagent', cat: 'Giornali' },
  { key: 'shop', val: 'tobacco', cat: 'Tabaccherie' },
  { key: 'shop', val: 'e-cigarette', cat: 'Sigarette Elettroniche' },
  { key: 'shop', val: 'model', cat: 'Modellismo' },
  { key: 'shop', val: 'garden_centre', cat: 'Giardinaggio' },
  { key: 'shop', val: 'fishing', cat: 'Pesca e Caccia' },
  { key: 'shop', val: 'weapons', cat: 'Armerie' },
  { key: 'shop', val: 'frame', cat: 'Cornici' },
  { key: 'shop', val: 'mall', cat: 'Centri Commerciali' },
  { key: 'shop', val: 'department_store', cat: 'Grandi Magazzini' },
  { key: 'shop', val: 'fashion', cat: 'Moda' },
  { key: 'shop', val: 'ski', cat: 'Sci e Snowboard' },
  { key: 'shop', val: 'sports', cat: 'Articoli Sportivi' },
  { key: 'shop', val: 'outdoor', cat: 'Outdoor e Camping' },
  { key: 'shop', val: 'erotic', cat: 'Sexy Shop' },
  { key: 'shop', val: 'video_games', cat: 'Videogiochi' },
  { key: 'shop', val: 'video', cat: 'Videonoleggi' },
  { key: 'shop', val: 'musical_instrument', cat: 'Strumenti Musicali' },
  { key: 'shop', val: 'beverages', cat: 'Negozi di Bevande' },
  { key: 'shop', val: 'tea', cat: "Negozi di Tè" },
  { key: 'shop', val: 'spices', cat: 'Spezierie' },
  { key: 'shop', val: 'hairdresser_supply', cat: 'Forniture Parrucchieri' },
  { key: 'shop', val: 'dairy', cat: 'Latterie' },
  { key: 'shop', val: 'agrarian', cat: 'Consorzi Agrari' },
  { key: 'shop', val: 'farm', cat: 'Prodotti Agricoli' },
  // Uffici
  { key: 'office', val: 'employment_agency', cat: 'Agenzie del Lavoro' },
  { key: 'office', val: 'advertising_agency', cat: 'Agenzie Pubblicitarie' },
  { key: 'office', val: 'ngo', cat: 'ONG' },
  { key: 'office', val: 'association', cat: 'Associazioni' },
  { key: 'office', val: 'foundation', cat: 'Fondazioni' },
  { key: 'office', val: 'graphic_design', cat: 'Grafici' },
  { key: 'office', val: 'research', cat: 'Centri di Ricerca' },
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
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': Buffer.byteLength(body), 'User-Agent': 'ItalianBizDir/5.0' }
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
    req.setTimeout(90000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body); req.end();
  });
}

function buildQuery(tagQuery, city) {
  const [s, w, n, e] = city.bbox;
  const bbox = `${s},${w},${n},${e}`;
  let filter = '';
  if (tagQuery.filter) filter = `[${tagQuery.filter}]`;
  return `[out:json][timeout:60];(\n  node["${tagQuery.key}"="${tagQuery.val}"]${filter}(${bbox});\n  way["${tagQuery.key}"="${tagQuery.val}"]${filter}(${bbox});\n);\nout center tags;`;
}

function makeRecord(el, city, catId) {
  const tags = el.tags || {};
  if (!tags.name) return null;
  const lat = el.lat ?? el.center?.lat;
  const lon = el.lon ?? el.center?.lon;
  if (!lat || !lon) return null;
  const street = tags['addr:street'] || '';
  const hnum = tags['addr:housenumber'] || '';
  return {
    name: tags.name.substring(0, 200),
    category_id: catId,
    street: street ? (hnum ? `${street}, ${hnum}` : street) : null,
    city: (tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || city.name).substring(0, 100),
    province: city.province,
    region: city.region,
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

async function runTagQuery(tagQuery, city) {
  const catId = categoryCache[tagQuery.cat];
  if (!catId) return 0;

  const query = buildQuery(tagQuery, city);
  let elements = [];
  for (let retry = 0; retry < 3; retry++) {
    try {
      const data = await fetchOverpass(query);
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(60000); retry--; continue; }
      if (retry < 2) { await sleep((retry + 1) * 8000); continue; }
      return 0;
    }
  }

  const records = [];
  const seen = new Set();
  for (const el of elements) {
    const r = makeRecord(el, city, catId);
    if (!r) continue;
    const key = `${r.name}|${r.city}|${r.latitude?.toFixed(4)}|${r.longitude?.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    records.push(r);
  }
  if (!records.length) return 0;

  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const { error } = await supabase.from('unclaimed_business_locations').insert(records.slice(i, i + 200));
    if (!error) inserted += Math.min(200, records.length - i);
  }
  totalImported += inserted;
  return inserted;
}

async function main() {
  console.log(`\n=== IMPORTAZIONE CATEGORIE MANCANTI ===`);
  console.log(`${TAG_QUERIES.length} tag OSM x ${CITIES.length} citta'\n`);
  await loadCategories();

  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    const tagTotal = { count: 0 };
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val} -> ${tq.cat}: `);

    for (const city of CITIES) {
      const n = await runTagQuery(tq, city);
      if (n > 0) { process.stdout.write(`${city.name}(+${n}) `); tagTotal.count += n; }
      await sleep(2000);
    }

    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   Totale tag: +${tagTotal.count} | Sessione: ${totalImported.toLocaleString()} (${mins}min)`);
    await sleep(3000);
  }

  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== COMPLETATO === Sessione: ${totalImported.toLocaleString()} | DB: ${count?.toLocaleString()}`);
}

main().catch(console.error);
