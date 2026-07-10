/**
 * Import veloce - 1 tag + 1 provincia alla volta
 * Feedback immediato, nessun blocco su query pesanti
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const PROVINCES = [
  { province: 'AO', region: "Valle d'Aosta", bbox: [45.45, 6.80, 45.90, 7.90] },
  { province: 'AV', region: 'Campania', bbox: [40.60, 14.50, 41.30, 15.40] },
  { province: 'EN', region: 'Sicilia', bbox: [37.20, 13.90, 37.95, 14.75] },
  { province: 'NU', region: 'Sardegna', bbox: [39.80, 8.80, 40.85, 9.95] },
  { province: 'OR', region: 'Sardegna', bbox: [39.40, 8.20, 40.50, 9.30] },
  { province: 'OT', region: 'Sardegna', bbox: [40.65, 8.75, 41.45, 9.85] },
  { province: 'VV', region: 'Calabria', bbox: [38.30, 15.70, 38.95, 16.55] },
  { province: 'SO', region: 'Lombardia', bbox: [45.80, 9.10, 46.75, 10.80] },
  { province: 'BI', region: 'Piemonte', bbox: [45.35, 7.85, 45.85, 8.35] },
  { province: 'LC', region: 'Lombardia', bbox: [45.55, 9.15, 46.05, 9.75] },
  { province: 'CL', region: 'Sicilia', bbox: [36.80, 13.55, 37.75, 14.65] },
  { province: 'BL', region: 'Veneto', bbox: [45.85, 11.60, 46.75, 12.70] },
  { province: 'VT', region: 'Lazio', bbox: [42.05, 11.40, 42.85, 12.55] },
  { province: 'TE', region: 'Abruzzo', bbox: [42.35, 13.35, 42.95, 14.15] },
  { province: 'IS', region: 'Molise', bbox: [41.35, 13.85, 41.95, 14.65] },
  { province: 'GR', region: 'Toscana', bbox: [42.20, 10.55, 43.25, 11.95] },
  { province: 'CZ', region: 'Calabria', bbox: [38.45, 16.15, 39.25, 17.00] },
  { province: 'RC', region: 'Calabria', bbox: [37.75, 15.35, 38.65, 16.65] },
  { province: 'BN', region: 'Campania', bbox: [40.95, 14.35, 41.45, 15.25] },
  { province: 'MC', region: 'Marche', bbox: [42.85, 12.85, 43.65, 13.95] },
  { province: 'FG', region: 'Puglia', bbox: [40.95, 14.85, 42.05, 16.25] },
  { province: 'CR', region: 'Lombardia', bbox: [44.85, 9.65, 45.45, 10.45] },
  { province: 'SS', region: 'Sardegna', bbox: [40.35, 8.05, 41.35, 9.35] },
  { province: 'AG', region: 'Sicilia', bbox: [36.95, 12.75, 37.75, 14.05] },
  { province: 'PU', region: 'Marche', bbox: [43.35, 11.95, 44.05, 13.25] },
  { province: 'VB', region: 'Piemonte', bbox: [45.70, 8.00, 46.55, 9.00] },
  { province: 'TR', region: 'Umbria', bbox: [42.25, 11.75, 42.85, 13.05] },
  { province: 'GO', region: 'Friuli-Venezia Giulia', bbox: [45.65, 13.35, 46.05, 13.85] },
  { province: 'FR', region: 'Lazio', bbox: [41.35, 12.95, 41.95, 14.05] },
  { province: 'AR', region: 'Toscana', bbox: [43.05, 11.35, 43.85, 12.35] },
  { province: 'FM', region: 'Marche', bbox: [42.85, 13.45, 43.45, 13.95] },
  { province: 'RO', region: 'Veneto', bbox: [44.75, 11.45, 45.25, 12.45] },
  { province: 'PZ', region: 'Basilicata', bbox: [39.95, 15.15, 41.25, 16.45] },
  { province: 'SA', region: 'Campania', bbox: [39.85, 14.55, 41.05, 15.85] },
  { province: 'PN', region: 'Friuli-Venezia Giulia', bbox: [45.75, 12.35, 46.35, 13.05] },
  { province: 'CS', region: 'Calabria', bbox: [38.95, 15.55, 40.15, 16.85] },
  { province: 'LT', region: 'Lazio', bbox: [41.05, 12.55, 41.75, 13.85] },
  { province: 'AP', region: 'Marche', bbox: [42.55, 13.25, 43.15, 14.05] },
  { province: 'MS', region: 'Toscana', bbox: [43.95, 9.65, 44.55, 10.25] },
  { province: 'IM', region: 'Liguria', bbox: [43.65, 7.45, 44.15, 8.25] },
  { province: 'CE', region: 'Campania', bbox: [40.85, 13.75, 41.45, 14.65] },
  { province: 'RG', region: 'Sicilia', bbox: [36.65, 14.35, 37.35, 15.15] },
  { province: 'MN', region: 'Lombardia', bbox: [44.85, 10.45, 45.35, 11.25] },
  { province: 'AQ', region: 'Abruzzo', bbox: [41.65, 12.95, 42.65, 14.25] },
  { province: 'CB', region: 'Molise', bbox: [41.35, 14.35, 41.95, 15.25] },
  { province: 'KR', region: 'Calabria', bbox: [38.65, 16.55, 39.55, 17.55] },
  { province: 'TP', region: 'Sicilia', bbox: [37.45, 12.15, 38.25, 13.25] },
  { province: 'RI', region: 'Lazio', bbox: [41.95, 12.35, 42.65, 13.55] },
  { province: 'LO', region: 'Lombardia', bbox: [45.05, 9.25, 45.55, 9.85] },
  { province: 'BT', region: 'Puglia', bbox: [40.95, 15.85, 41.55, 16.65] },
  { province: 'MT', region: 'Basilicata', bbox: [39.85, 15.75, 40.85, 16.95] },
  { province: 'PV', region: 'Lombardia', bbox: [44.75, 8.65, 45.45, 9.55] },
  { province: 'VC', region: 'Piemonte', bbox: [44.95, 7.95, 45.65, 8.75] },
  { province: 'SP', region: 'Liguria', bbox: [43.85, 9.45, 44.35, 10.05] },
  { province: 'SV', region: 'Liguria', bbox: [43.85, 7.95, 44.55, 8.85] },
  { province: 'PC', region: 'Emilia-Romagna', bbox: [44.55, 9.15, 45.25, 10.15] },
  { province: 'FE', region: 'Emilia-Romagna', bbox: [44.45, 11.35, 45.05, 12.15] },
  { province: 'PT', region: 'Toscana', bbox: [43.65, 10.55, 44.25, 11.25] },
  { province: 'PO', region: 'Toscana', bbox: [43.65, 10.75, 44.15, 11.35] },
  { province: 'SI', region: 'Toscana', bbox: [42.75, 10.85, 43.65, 12.05] },
  { province: 'LU', region: 'Toscana', bbox: [43.65, 10.25, 44.35, 10.85] },
  { province: 'AT', region: 'Piemonte', bbox: [44.55, 7.85, 45.05, 8.55] },
  { province: 'AL', region: 'Piemonte', bbox: [44.45, 8.25, 45.15, 9.05] },
  { province: 'VA', region: 'Lombardia', bbox: [45.55, 8.40, 46.05, 9.00] },
  { province: 'CO', region: 'Lombardia', bbox: [45.65, 8.95, 46.15, 9.55] },
  { province: 'NO', region: 'Piemonte', bbox: [45.30, 8.35, 45.85, 8.85] },
  { province: 'TN', region: 'Trentino-Alto Adige', bbox: [45.55, 10.50, 46.65, 11.60] },
  { province: 'BZ', region: 'Trentino-Alto Adige', bbox: [46.20, 10.35, 47.10, 12.30] },
  { province: 'CH', region: 'Abruzzo', bbox: [41.85, 13.75, 42.65, 14.85] },
  { province: 'PE', region: 'Abruzzo', bbox: [42.10, 13.75, 42.65, 14.45] },
  { province: 'BR', region: 'Puglia', bbox: [40.25, 17.35, 40.95, 18.25] },
  { province: 'TA', region: 'Puglia', bbox: [40.05, 16.55, 40.75, 17.85] },
  { province: 'CA', region: 'Sardegna', bbox: [38.75, 8.55, 39.55, 9.65] },
  { province: 'ME', region: 'Sicilia', bbox: [37.85, 14.35, 38.35, 15.65] },
  { province: 'SR', region: 'Sicilia', bbox: [36.65, 14.85, 37.45, 15.45] },
  { province: 'FC', region: 'Emilia-Romagna', bbox: [43.65, 11.60, 44.35, 12.45] },
  { province: 'RA', region: 'Emilia-Romagna', bbox: [44.10, 11.65, 44.65, 12.45] },
  { province: 'RN', region: 'Emilia-Romagna', bbox: [43.75, 12.10, 44.25, 12.75] },
  { province: 'AN', region: 'Marche', bbox: [43.15, 12.75, 43.85, 13.75] },
  { province: 'PG', region: 'Umbria', bbox: [42.45, 11.75, 43.65, 13.15] },
  { province: 'TV', region: 'Veneto', bbox: [45.55, 11.75, 46.05, 12.55] },
  { province: 'VI', region: 'Veneto', bbox: [45.35, 11.15, 45.95, 11.75] },
  { province: 'UD', region: 'Friuli-Venezia Giulia', bbox: [45.80, 12.75, 46.65, 13.55] },
  { province: 'TS', region: 'Friuli-Venezia Giulia', bbox: [45.55, 13.60, 45.85, 13.95] },
  { province: 'TO', region: 'Piemonte', bbox: [44.70, 7.00, 45.60, 8.10] },
  { province: 'MI', region: 'Lombardia', bbox: [45.20, 8.80, 45.65, 9.75] },
  { province: 'RM', region: 'Lazio', bbox: [41.40, 12.10, 42.50, 13.30] },
  { province: 'NA', region: 'Campania', bbox: [40.50, 14.00, 41.20, 14.60] },
  { province: 'CN', region: 'Piemonte', bbox: [43.90, 7.10, 44.80, 8.00] },
  { province: 'MO', region: 'Emilia-Romagna', bbox: [44.20, 10.60, 44.80, 11.30] },
  { province: 'RE', region: 'Emilia-Romagna', bbox: [44.25, 10.25, 44.75, 10.85] },
  { province: 'PR', region: 'Emilia-Romagna', bbox: [44.25, 9.85, 44.90, 10.65] },
  { province: 'BS', region: 'Lombardia', bbox: [45.10, 10.05, 46.20, 10.65] },
  { province: 'BG', region: 'Lombardia', bbox: [45.55, 9.55, 46.15, 10.25] },
  { province: 'VR', region: 'Veneto', bbox: [45.10, 10.55, 45.65, 11.45] },
  { province: 'PD', region: 'Veneto', bbox: [45.05, 11.50, 45.65, 12.15] },
  { province: 'VE', region: 'Veneto', bbox: [45.25, 12.05, 45.75, 12.65] },
  { province: 'FI', region: 'Toscana', bbox: [43.55, 10.75, 44.05, 11.65] },
  { province: 'GE', region: 'Liguria', bbox: [44.20, 8.65, 44.55, 9.25] },
  { province: 'PA', region: 'Sicilia', bbox: [37.80, 13.10, 38.30, 13.75] },
  { province: 'CT', region: 'Sicilia', bbox: [37.20, 14.75, 37.80, 15.35] },
  { province: 'BO', region: 'Emilia-Romagna', bbox: [44.25, 10.95, 44.75, 11.75] },
  { province: 'LE', region: 'Puglia', bbox: [39.75, 17.75, 40.45, 18.55] },
  { province: 'BA', region: 'Puglia', bbox: [40.65, 16.55, 41.25, 17.25] },
  { province: 'MB', region: 'Lombardia', bbox: [45.50, 9.10, 45.80, 9.55] },
  { province: 'PI', region: 'Toscana', bbox: [43.45, 10.20, 43.95, 11.05] },
  { province: 'LI', region: 'Toscana', bbox: [42.60, 10.15, 43.55, 10.85] },
];

const TAGS = [
  { key: 'amenity', val: 'restaurant', cat: 'Ristoranti' },
  { key: 'amenity', val: 'cafe', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'bar', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'fast_food', cat: 'Fast Food' },
  { key: 'amenity', val: 'pub', cat: 'Pub e Locali' },
  { key: 'amenity', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'amenity', val: 'nightclub', cat: 'Discoteche' },
  { key: 'shop', val: 'supermarket', cat: 'Supermercati' },
  { key: 'shop', val: 'convenience', cat: 'Alimentari' },
  { key: 'shop', val: 'bakery', cat: 'Panifici' },
  { key: 'shop', val: 'butcher', cat: 'Macellerie' },
  { key: 'shop', val: 'greengrocer', cat: 'Frutta e Verdura' },
  { key: 'shop', val: 'pastry', cat: 'Pasticcerie' },
  { key: 'shop', val: 'fishmonger', cat: 'Pescherie' },
  { key: 'shop', val: 'deli', cat: 'Gastronomie' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  { key: 'shop', val: 'alcohol', cat: 'Enoteche' },
  { key: 'shop', val: 'tobacco', cat: 'Tabaccherie' },
  { key: 'shop', val: 'coffee', cat: 'Torrefazioni' },
  { key: 'amenity', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  { key: 'shop', val: 'hairdresser', cat: 'Parrucchieri' },
  { key: 'shop', val: 'beauty', cat: 'Estetisti' },
  { key: 'shop', val: 'optician', cat: 'Ottici' },
  { key: 'amenity', val: 'spa', cat: 'Centri Estetici' },
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'leisure', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'shop', val: 'sports', cat: 'Articoli Sportivi' },
  { key: 'shop', val: 'bicycle', cat: 'Cicli e Moto' },
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'doityourself', cat: 'Bricolage' },
  { key: 'shop', val: 'florist', cat: 'Fiorai' },
  { key: 'shop', val: 'garden_centre', cat: 'Garden Center' },
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'mobile_phone', cat: 'Telefonia' },
  { key: 'shop', val: 'computer', cat: 'Computer e Informatica' },
  { key: 'shop', val: 'car', cat: 'Concessionarie Auto' },
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'amenity', val: 'fuel', cat: 'Distributori Carburante' },
  { key: 'shop', val: 'car_parts', cat: 'Ricambi Auto' },
  { key: 'amenity', val: 'bank', cat: 'Banche' },
  { key: 'amenity', val: 'post_office', cat: 'Poste' },
  { key: 'office', val: 'insurance', cat: 'Assicurazioni' },
  { key: 'office', val: 'lawyer', cat: 'Avvocati' },
  { key: 'office', val: 'accountant', cat: 'Commercialisti' },
  { key: 'office', val: 'notary', cat: 'Notai' },
  { key: 'office', val: 'architect', cat: 'Architetti' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'tourism', val: 'hostel', cat: 'Ostelli' },
  { key: 'tourism', val: 'camp_site', cat: 'Campeggi' },
  { key: 'craft', val: 'plumber', cat: 'Idraulici' },
  { key: 'craft', val: 'electrician', cat: 'Elettricisti' },
  { key: 'craft', val: 'carpenter', cat: 'Falegnami' },
  { key: 'craft', val: 'painter', cat: 'Imbianchini' },
  { key: 'amenity', val: 'school', cat: 'Scuole' },
  { key: 'amenity', val: 'kindergarten', cat: 'Asili Nido' },
  { key: 'amenity', val: 'language_school', cat: 'Scuole di Lingue' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'shop', val: 'books', cat: 'Librerie' },
  { key: 'shop', val: 'newsagent', cat: 'Giornali' },
  { key: 'shop', val: 'gift', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'toys', cat: 'Giocattoli' },
  { key: 'shop', val: 'pet', cat: 'Negozi per Animali' },
  { key: 'amenity', val: 'cinema', cat: 'Cinema' },
  { key: 'amenity', val: 'theatre', cat: 'Teatri' },
  { key: 'shop', val: 'photo', cat: 'Fotografia' },
  { key: 'shop', val: 'musical_instrument', cat: 'Strumenti Musicali' },
  { key: 'amenity', val: 'laundry', cat: 'Lavanderie' },
  { key: 'shop', val: 'dry_cleaning', cat: 'Lavanderie' },
  { key: 'shop', val: 'stationery', cat: 'Cartolerie' },
  { key: 'shop', val: 'antiques', cat: 'Antiquari' },
  { key: 'craft', val: 'gardener', cat: 'Giardinieri' },
  { key: 'craft', val: 'tailor', cat: 'Sartorie' },
  { key: 'craft', val: 'watchmaker', cat: 'Orologiai' },
  { key: 'craft', val: 'photographer', cat: 'Fotografi' },
  { key: 'craft', val: 'winery', cat: 'Cantine' },
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
        'User-Agent': 'ItalianBizDir/11.0'
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
    // Timeout breve: 30s per query singola, nessun blocco
    req.setTimeout(30000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body); req.end();
  });
}

async function runOne(tag, province) {
  const catId = categoryCache[tag.cat];
  if (!catId) return 0;

  const [s, w, n, e] = province.bbox;
  const bbox = `${s},${w},${n},${e}`;
  const query = `[out:json][timeout:25];\n(\n  node["${tag.key}"="${tag.val}"](${bbox});\n  way["${tag.key}"="${tag.val}"](${bbox});\n);\nout center tags;`;

  let elements = [];
  for (let retry = 0; retry < 2; retry++) {
    try {
      const data = await fetchOverpass(query);
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(45000); retry--; continue; }
      if (retry < 1) { await sleep(3000); continue; }
      return 0;
    }
  }

  const records = [];
  const seen = new Set();
  for (const el of elements) {
    const tags = el.tags || {};
    if (!tags.name) continue;
    const lat = el.lat ?? el.center?.lat;
    const lon = el.lon ?? el.center?.lon;
    if (!lat || !lon) continue;
    const key = `${tags.name}|${province.province}|${lat.toFixed(4)}|${lon.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    const street = tags['addr:street'] || '';
    const hnum = tags['addr:housenumber'] || '';
    const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || tags['addr:municipality'] || '';
    records.push({
      name: tags.name.substring(0, 200),
      category_id: catId,
      street: street ? (hnum ? `${street}, ${hnum}` : street) : null,
      city: city ? city.substring(0, 100) : province.province,
      province: province.province,
      region: province.region,
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
    });
  }

  if (!records.length) return 0;

  let inserted = 0;
  for (let i = 0; i < records.length; i += 100) {
    const batch = records.slice(i, i + 100);
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
  return inserted;
}

async function main() {
  const total = TAGS.length * PROVINCES.length;
  console.log(`\n=== IMPORT VELOCE: ${TAGS.length} tag x ${PROVINCES.length} province = ${total} query ===\n`);
  await loadCategories();

  let step = 0;
  for (const tag of TAGS) {
    let tagTotal = 0;
    process.stdout.write(`\n[${tag.key}=${tag.val}] `);

    for (const province of PROVINCES) {
      step++;
      const n = await runOne(tag, province);
      if (n > 0) {
        tagTotal += n;
        totalImported += n;
        const elapsed = ((Date.now() - startTime) / 60000).toFixed(1);
        process.stdout.write(`${province.province}+${n} `);
        // Stampa riga di riepilogo ogni volta che inserisce
        console.log(`  => +${n} ${tag.cat} in ${province.province} | Totale sessione: ${totalImported.toLocaleString()} | ${elapsed}min`);
        process.stdout.write(`[${tag.key}=${tag.val}] `);
      }
      await sleep(600);
    }

    const elapsed = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n  [FINE TAG] ${tag.cat}: +${tagTotal} | Sessione: ${totalImported.toLocaleString()} | ${elapsed}min`);
    await sleep(1000);
  }

  console.log(`\n=== COMPLETATO ===`);
  console.log(`Importati questa sessione: ${totalImported.toLocaleString()}`);
}

main().catch(console.error);
