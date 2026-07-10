/**
 * Import espanso: regioni deboli + categorie mancanti (medici, dentisti, avvocati, ecc.)
 * Focalizzato su regioni con < 3000 aziende: Molise, Basilicata, Calabria, Sardegna, Umbria, Marche, Abruzzo
 * Plus categorie mancanti per tutte le regioni
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

// Citta' con copertura insufficiente + citta' medie mancanti
const CITIES = [
  // Regioni deboli - piu' citta' per provincia
  { name: 'Campobasso', region: 'Molise', province: 'CB', bbox: [41.49, 14.58, 41.69, 14.78] },
  { name: 'Termoli', region: 'Molise', province: 'CB', bbox: [41.97, 14.95, 42.12, 15.10] },
  { name: 'Isernia', region: 'Molise', province: 'IS', bbox: [41.55, 14.18, 41.65, 14.28] },
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.57, 15.73, 40.77, 15.93] },
  { name: 'Matera', region: 'Basilicata', province: 'MT', bbox: [40.58, 16.52, 40.78, 16.72] },
  { name: 'Melfi', region: 'Basilicata', province: 'PZ', bbox: [40.96, 15.59, 41.06, 15.69] },
  { name: 'Pisticci', region: 'Basilicata', province: 'MT', bbox: [40.35, 16.53, 40.45, 16.63] },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.22, 16.18, 39.42, 16.38] },
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [38.02, 15.56, 38.22, 15.76] },
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.82, 16.52, 39.02, 16.72] },
  { name: 'Lamezia Terme', region: 'Calabria', province: 'CZ', bbox: [38.91, 16.24, 39.01, 16.34] },
  { name: 'Crotone', region: 'Calabria', province: 'KR', bbox: [38.93, 17.04, 39.13, 17.24] },
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.63, 16.04, 38.83, 16.24] },
  { name: 'Rende', region: 'Calabria', province: 'CS', bbox: [39.28, 16.16, 39.38, 16.26] },
  { name: 'Corigliano-Rossano', region: 'Calabria', province: 'CS', bbox: [39.53, 16.49, 39.63, 16.59] },
  { name: 'Cagliari', region: 'Sardegna', province: 'CA', bbox: [39.14, 9.02, 39.34, 9.22] },
  { name: 'Sassari', region: 'Sardegna', province: 'SS', bbox: [40.66, 8.48, 40.86, 8.68] },
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', bbox: [40.25, 9.26, 40.45, 9.46] },
  { name: 'Oristano', region: 'Sardegna', province: 'OR', bbox: [39.85, 8.54, 40.05, 8.74] },
  { name: 'Olbia', region: 'Sardegna', province: 'OT', bbox: [40.87, 9.45, 41.07, 9.65] },
  { name: 'Alghero', region: 'Sardegna', province: 'SS', bbox: [40.53, 8.25, 40.63, 8.35] },
  { name: 'Carbonia', region: 'Sardegna', province: 'SU', bbox: [39.14, 8.47, 39.24, 8.57] },
  { name: 'Iglesias', region: 'Sardegna', province: 'SU', bbox: [39.26, 8.47, 39.36, 8.57] },
  { name: 'Perugia', region: 'Umbria', province: 'PG', bbox: [43.02, 12.30, 43.22, 12.50] },
  { name: 'Terni', region: 'Umbria', province: 'TR', bbox: [42.48, 12.56, 42.68, 12.76] },
  { name: 'Foligno', region: 'Umbria', province: 'PG', bbox: [42.93, 12.68, 43.03, 12.78] },
  { name: "Città di Castello", region: 'Umbria', province: 'PG', bbox: [43.43, 12.20, 43.53, 12.30] },
  { name: 'Ancona', region: 'Marche', province: 'AN', bbox: [43.52, 13.44, 43.72, 13.64] },
  { name: 'Pesaro', region: 'Marche', province: 'PU', bbox: [43.84, 12.84, 44.04, 13.04] },
  { name: 'Macerata', region: 'Marche', province: 'MC', bbox: [43.23, 13.39, 43.43, 13.59] },
  { name: 'Fano', region: 'Marche', province: 'PU', bbox: [43.81, 13.00, 43.91, 13.10] },
  { name: 'Senigallia', region: 'Marche', province: 'AN', bbox: [43.69, 13.18, 43.79, 13.28] },
  { name: 'Civitanova Marche', region: 'Marche', province: 'MC', bbox: [43.28, 13.68, 43.38, 13.78] },
  { name: "L'Aquila", region: 'Abruzzo', province: 'AQ', bbox: [42.29, 13.29, 42.49, 13.49] },
  { name: 'Pescara', region: 'Abruzzo', province: 'PE', bbox: [42.38, 14.14, 42.58, 14.34] },
  { name: 'Chieti', region: 'Abruzzo', province: 'CH', bbox: [42.30, 14.10, 42.50, 14.30] },
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.61, 13.66, 42.76, 13.82] },
  { name: 'Lanciano', region: 'Abruzzo', province: 'CH', bbox: [42.19, 14.33, 42.29, 14.43] },
  { name: 'Vasto', region: 'Abruzzo', province: 'CH', bbox: [42.05, 14.65, 42.15, 14.75] },
  // Citta' medie mancanti nelle regioni forti
  { name: 'Biella', region: 'Piemonte', province: 'BI', bbox: [45.50, 8.00, 45.60, 8.10] },
  { name: 'Verbania', region: 'Piemonte', province: 'VB', bbox: [45.90, 8.46, 46.00, 8.56] },
  { name: 'Vercelli', region: 'Piemonte', province: 'VC', bbox: [45.30, 8.39, 45.40, 8.49] },
  { name: 'Vigevano', region: 'Lombardia', province: 'PV', bbox: [45.29, 8.82, 45.39, 8.92] },
  { name: 'Voghera', region: 'Lombardia', province: 'PV', bbox: [44.95, 9.00, 45.05, 9.10] },
  { name: 'Gallarate', region: 'Lombardia', province: 'VA', bbox: [45.65, 8.76, 45.75, 8.86] },
  { name: 'Busto Arsizio', region: 'Lombardia', province: 'VA', bbox: [45.58, 8.81, 45.68, 8.91] },
  { name: 'Saronno', region: 'Lombardia', province: 'VA', bbox: [45.60, 9.00, 45.70, 9.10] },
  { name: 'Casalmaggiore', region: 'Lombardia', province: 'CR', bbox: [44.98, 10.38, 45.08, 10.48] },
  { name: 'Viadana', region: 'Lombardia', province: 'MN', bbox: [44.91, 10.50, 45.01, 10.60] },
  { name: 'Chiavari', region: 'Liguria', province: 'GE', bbox: [44.31, 9.28, 44.41, 9.38] },
  { name: 'Rapallo', region: 'Liguria', province: 'GE', bbox: [44.32, 9.20, 44.42, 9.30] },
  { name: 'Treviglio', region: 'Lombardia', province: 'BG', bbox: [45.49, 9.56, 45.59, 9.66] },
  { name: 'Seriate', region: 'Lombardia', province: 'BG', bbox: [45.66, 9.70, 45.72, 9.76] },
  { name: 'Rovato', region: 'Lombardia', province: 'BS', bbox: [45.55, 10.00, 45.65, 10.10] },
  { name: 'Chiari', region: 'Lombardia', province: 'BS', bbox: [45.50, 9.90, 45.60, 10.00] },
  { name: 'Fano', region: 'Marche', province: 'PU', bbox: [43.83, 13.00, 43.92, 13.09] },
  { name: 'Fabriano', region: 'Marche', province: 'AN', bbox: [43.28, 12.85, 43.38, 12.95] },
  { name: 'Jesi', region: 'Marche', province: 'AN', bbox: [43.49, 13.23, 43.59, 13.33] },
  { name: 'Caserta', region: 'Campania', province: 'CE', bbox: [41.00, 14.26, 41.20, 14.46] },
  { name: 'Nola', region: 'Campania', province: 'NA', bbox: [40.88, 14.48, 40.98, 14.58] },
  { name: 'Torre del Greco', region: 'Campania', province: 'NA', bbox: [40.75, 14.34, 40.85, 14.44] },
  { name: 'Pozzuoli', region: 'Campania', province: 'NA', bbox: [40.81, 14.07, 40.91, 14.17] },
  { name: 'Foggia', region: 'Puglia', province: 'FG', bbox: [41.38, 15.48, 41.58, 15.68] },
  { name: 'Manfredonia', region: 'Puglia', province: 'FG', bbox: [41.60, 15.86, 41.70, 15.96] },
  { name: 'Cerignola', region: 'Puglia', province: 'FG', bbox: [41.22, 15.85, 41.32, 15.95] },
  { name: 'Altamura', region: 'Puglia', province: 'BA', bbox: [40.79, 16.52, 40.89, 16.62] },
  { name: 'Molfetta', region: 'Puglia', province: 'BA', bbox: [41.18, 16.56, 41.28, 16.66] },
  { name: 'Andria', region: 'Puglia', province: 'BT', bbox: [41.20, 16.24, 41.30, 16.34] },
  { name: 'Trani', region: 'Puglia', province: 'BT', bbox: [41.26, 16.38, 41.36, 16.48] },
  { name: 'Acireale', region: 'Sicilia', province: 'CT', bbox: [37.58, 15.12, 37.68, 15.22] },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.86, 14.66, 37.06, 14.86] },
  { name: 'Marsala', region: 'Sicilia', province: 'TP', bbox: [37.74, 12.40, 37.84, 12.50] },
  { name: 'Mazara del Vallo', region: 'Sicilia', province: 'TP', bbox: [37.62, 12.56, 37.72, 12.66] },
  { name: 'Gela', region: 'Sicilia', province: 'CL', bbox: [37.05, 14.18, 37.15, 14.28] },
  { name: 'Augusta', region: 'Sicilia', province: 'SR', bbox: [37.21, 15.18, 37.31, 15.28] },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [37.42, 13.98, 37.62, 14.18] },
];

// Tag queries mirati per categorie poco rappresentate
const TAG_QUERIES = [
  // Professioni sanitarie
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'healthcare', val: 'dentist', cat: 'Dentisti' },
  { key: 'healthcare', val: 'doctor', cat: 'Medici' },
  { key: 'amenity', val: 'hospital', cat: 'Ospedali' },
  { key: 'amenity', val: 'clinic', cat: 'Cliniche' },
  { key: 'healthcare', val: 'physiotherapist', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'psychologist', cat: 'Psicologi' },
  { key: 'healthcare', val: 'optometrist', cat: 'Ottici' },
  { key: 'healthcare', val: 'laboratory', cat: 'Laboratori Analisi' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  // Professioni legali e finanziarie
  { key: 'office', val: 'lawyer', cat: 'Avvocati' },
  { key: 'office', val: 'notary', cat: 'Notai' },
  { key: 'office', val: 'accountant', cat: 'Commercialisti' },
  { key: 'office', val: 'financial', cat: 'Consulenti Finanziari' },
  { key: 'office', val: 'insurance', cat: 'Agenzie Assicurative' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'office', val: 'tax_adviser', cat: 'Consulenti Fiscali' },
  // Sport e fitness
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'leisure', val: 'sports_centre', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'leisure', val: 'stadium', cat: 'Stadi' },
  { key: 'leisure', val: 'track', cat: 'Piste Atletica' },
  { key: 'leisure', val: 'horse_riding', cat: 'Equitazione' },
  { key: 'leisure', val: 'bowling_alley', cat: 'Bowling' },
  { key: 'leisure', val: 'ice_rink', cat: 'Piste di Ghiaccio' },
  { key: 'leisure', val: 'tennis', cat: 'Tennis' },
  { key: 'sport', val: 'swimming', cat: 'Piscine' },
  { key: 'sport', val: 'tennis', cat: 'Tennis' },
  { key: 'sport', val: 'football', cat: 'Calcio' },
  { key: 'sport', val: 'basketball', cat: 'Pallacanestro' },
  { key: 'sport', val: 'volleyball', cat: 'Pallavolo' },
  { key: 'sport', val: 'cycling', cat: 'Ciclismo' },
  { key: 'sport', val: 'climbing', cat: 'Arrampicata' },
  // Istruzione
  { key: 'amenity', val: 'school', cat: 'Scuole' },
  { key: 'amenity', val: 'kindergarten', cat: 'Asili Nido' },
  { key: 'amenity', val: 'language_school', cat: 'Scuole di Lingua' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'amenity', val: 'music_school', cat: 'Scuole di Musica' },
  { key: 'amenity', val: 'dance_school', cat: 'Scuole di Danza' },
  // Ristorazione specializzata
  { key: 'amenity', val: 'bar', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'cafe', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'amenity', val: 'bbq', cat: 'Ristoranti' },
  { key: 'amenity', val: 'food_court', cat: 'Fast Food' },
  // Turismo e ospitalità
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'hostel', cat: "Ostelli" },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'tourism', val: 'apartment', cat: 'Appartamenti Turistici' },
  { key: 'tourism', val: 'camp_site', cat: 'Campeggi' },
  { key: 'tourism', val: 'caravan_site', cat: 'Aree Camper' },
  { key: 'tourism', val: 'chalet', cat: 'Chalet' },
  // Trasporti
  { key: 'amenity', val: 'car_rental', cat: 'Autonoleggi' },
  { key: 'amenity', val: 'car_wash', cat: 'Autolavaggi' },
  { key: 'amenity', val: 'parking', cat: 'Parcheggi' },
  { key: 'amenity', val: 'bicycle_rental', cat: 'Noleggio Bici' },
  { key: 'shop', val: 'car', cat: 'Concessionarie Auto' },
  { key: 'shop', val: 'bicycle', cat: 'Biciclette' },
  { key: 'shop', val: 'boat', cat: 'Barche' },
  // Culturale e intrattenimento
  { key: 'amenity', val: 'theatre', cat: 'Teatri' },
  { key: 'amenity', val: 'cinema', cat: 'Cinema' },
  { key: 'amenity', val: 'nightclub', cat: 'Discoteche' },
  { key: 'amenity', val: 'arts_centre', cat: 'Centri Culturali' },
  { key: 'amenity', val: 'casino', cat: 'Casino' },
  { key: 'tourism', val: 'museum', cat: 'Musei' },
  { key: 'tourism', val: 'gallery', cat: 'Gallerie d\'Arte' },
  { key: 'tourism', val: 'attraction', cat: 'Attrazioni Turistiche' },
  { key: 'tourism', val: 'theme_park', cat: 'Parchi a Tema' },
  { key: 'tourism', val: 'zoo', cat: 'Zoo' },
  { key: 'tourism', val: 'aquarium', cat: 'Acquari' },
  // Servizi vari
  { key: 'amenity', val: 'post_office', cat: 'Uffici Postali' },
  { key: 'amenity', val: 'police', cat: 'Forze dell\'Ordine' },
  { key: 'amenity', val: 'fire_station', cat: 'Vigili del Fuoco' },
  { key: 'amenity', val: 'social_facility', cat: 'Strutture Sociali' },
  { key: 'amenity', val: 'childcare', cat: 'Asili Nido' },
  { key: 'amenity', val: 'place_of_worship', cat: 'Chiese e Luoghi di Culto' },
  { key: 'amenity', val: 'marketplace', cat: 'Mercati' },
  { key: 'amenity', val: 'conference_centre', cat: 'Centri Congressi' },
  { key: 'amenity', val: 'coworking_space', cat: 'Coworking' },
  // Alimentari e negozi
  { key: 'shop', val: 'supermarket', cat: 'Supermercati' },
  { key: 'shop', val: 'convenience', cat: 'Alimentari' },
  { key: 'shop', val: 'deli', cat: 'Salumerie' },
  { key: 'shop', val: 'butcher', cat: 'Macellerie' },
  { key: 'shop', val: 'fishmonger', cat: 'Pescherie' },
  { key: 'shop', val: 'greengrocer', cat: 'Fruttivendoli' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  { key: 'shop', val: 'cheese', cat: 'Formaggi' },
  { key: 'shop', val: 'confectionery', cat: 'Confetterie' },
  { key: 'shop', val: 'chocolate', cat: 'Cioccolato' },
  { key: 'shop', val: 'coffee', cat: 'Caffè' },
  // Cura della persona
  { key: 'shop', val: 'beauty', cat: 'Centri Estetici' },
  { key: 'shop', val: 'cosmetics', cat: 'Cosmetici' },
  { key: 'shop', val: 'perfumery', cat: 'Profumerie' },
  { key: 'shop', val: 'tattoo', cat: 'Tatuaggi' },
  // Arredamento e casa
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'doityourself', cat: 'Fai da Te' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'florist', cat: 'Fiorerie' },
  { key: 'shop', val: 'houseware', cat: 'Casalinghi' },
  { key: 'shop', val: 'kitchen', cat: 'Cucine' },
  { key: 'shop', val: 'carpet', cat: 'Tappeti' },
  // Elettronica
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'computer', cat: 'Computer' },
  { key: 'shop', val: 'mobile_phone', cat: 'Telefonia' },
  { key: 'shop', val: 'appliance', cat: 'Elettrodomestici' },
  // Abbigliamento
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'watches', cat: 'Orologi' },
  { key: 'shop', val: 'bag', cat: 'Borse' },
  { key: 'shop', val: 'leather', cat: 'Pelletterie' },
  // Auto
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'shop', val: 'car_parts', cat: 'Ricambi Auto' },
  { key: 'amenity', val: 'fuel', cat: 'Benzinai' },
  // Animali
  { key: 'shop', val: 'pet', cat: 'Negozi Animali' },
  { key: 'amenity', val: 'animal_boarding', cat: 'Pensioni Animali' },
];

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach((c) => { categoryCache[c.name] = c.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie`);
}

const sleep = (ms) => new Promise(r => setTimeout(r, ms));

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const body = `data=${encodeURIComponent(query)}`;
    const opts = {
      hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': Buffer.byteLength(body), 'User-Agent': 'ItalianBizDir/6.0' }
    };
    const req = https.request(opts, (res) => {
      let data = '';
      res.on('data', (c) => data += c);
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

function buildQuery(tq, city) {
  const [s, w, n, e] = city.bbox;
  const bbox = `${s},${w},${n},${e}`;
  const filter = tq.filter ? `[${tq.filter}]` : '';
  return `[out:json][timeout:60];\n(\n  node["${tq.key}"="${tq.val}"]${filter}(${bbox});\n  way["${tq.key}"="${tq.val}"]${filter}(${bbox});\n);\nout center tags;`;
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
    latitude: lat, longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '').substring(0, 50) || null,
    email: (tags.email || tags['contact:email'] || '').substring(0, 200) || null,
    website: (tags.website || tags['contact:website'] || '').substring(0, 500) || null,
    business_hours: tags.opening_hours || null,
    is_claimed: false, approval_status: 'approved',
  };
}

async function runTagQuery(tq, city) {
  const catId = categoryCache[tq.cat];
  if (!catId) return 0;
  const query = buildQuery(tq, city);
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
  console.log(`\n=== IMPORTAZIONE ESPANSA ===`);
  console.log(`${TAG_QUERIES.length} tag OSM x ${CITIES.length} citta'\n`);
  await loadCategories();

  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    let tagTotal = 0;
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val} -> ${tq.cat}: `);

    for (const city of CITIES) {
      const n = await runTagQuery(tq, city);
      if (n > 0) { process.stdout.write(`${city.name}(+${n}) `); tagTotal += n; }
      await sleep(2000);
    }

    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   Tag: +${tagTotal} | Sessione: ${totalImported.toLocaleString()} (${mins}min)`);
    await sleep(3000);
  }

  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== COMPLETATO === Sessione: ${totalImported.toLocaleString()} | DB totale: ${count?.toLocaleString()}`);
}

main().catch(console.error);
