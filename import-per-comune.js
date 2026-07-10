/**
 * Import per comune - bbox da geocoding Overpass interno
 * Usa Overpass per trovare lat/lon di ogni comune (niente Nominatim)
 * poi query bbox ~6km con tutti i tag
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const TAGS = [
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
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  { key: 'shop', val: 'tobacco', cat: 'Tabaccherie' },
  { key: 'amenity', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  { key: 'shop', val: 'hairdresser', cat: 'Parrucchieri' },
  { key: 'shop', val: 'beauty', cat: 'Estetisti' },
  { key: 'shop', val: 'optician', cat: 'Ottici' },
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'florist', cat: 'Fiorai' },
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'mobile_phone', cat: 'Telefonia' },
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'amenity', val: 'fuel', cat: 'Distributori Carburante' },
  { key: 'amenity', val: 'bank', cat: 'Banche' },
  { key: 'amenity', val: 'post_office', cat: 'Poste' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'office', val: 'insurance', cat: 'Assicurazioni' },
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'craft', val: 'plumber', cat: 'Idraulici' },
  { key: 'craft', val: 'electrician', cat: 'Elettricisti' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'shop', val: 'books', cat: 'Librerie' },
  { key: 'shop', val: 'pet', cat: 'Negozi per Animali' },
];

// Centroidi approssimativi per provincia — usati come fallback se geocoding fallisce
const PROVINCE_COORDS = {
  AG:{lat:37.32,lon:13.58},AL:{lat:44.91,lon:8.61},AN:{lat:43.61,lon:13.51},AO:{lat:45.74,lon:7.32},
  AP:{lat:42.85,lon:13.58},AQ:{lat:42.35,lon:13.40},AR:{lat:43.46,lon:11.88},AT:{lat:44.90,lon:8.21},
  AV:{lat:40.91,lon:15.05},BA:{lat:41.12,lon:16.87},BG:{lat:45.70,lon:9.67},BI:{lat:45.56,lon:8.05},
  BL:{lat:46.14,lon:12.22},BN:{lat:41.13,lon:14.78},BO:{lat:44.49,lon:11.34},BR:{lat:40.63,lon:17.94},
  BS:{lat:45.54,lon:10.22},BT:{lat:41.22,lon:16.29},BZ:{lat:46.50,lon:11.35},CA:{lat:39.22,lon:9.11},
  CB:{lat:41.56,lon:14.67},CE:{lat:41.07,lon:14.33},CH:{lat:42.35,lon:14.17},CL:{lat:37.49,lon:14.06},
  CN:{lat:44.39,lon:7.55},CO:{lat:45.80,lon:9.08},CR:{lat:45.13,lon:10.03},CS:{lat:39.30,lon:16.25},
  CT:{lat:37.50,lon:15.09},CZ:{lat:38.91,lon:16.59},EN:{lat:37.56,lon:14.28},FC:{lat:44.22,lon:12.04},
  FE:{lat:44.84,lon:11.62},FG:{lat:41.46,lon:15.55},FI:{lat:43.77,lon:11.25},FM:{lat:43.16,lon:13.72},
  FR:{lat:41.64,lon:13.34},GE:{lat:44.41,lon:8.93},GO:{lat:45.94,lon:13.62},GR:{lat:42.76,lon:11.11},
  IM:{lat:43.88,lon:7.91},IS:{lat:41.59,lon:14.23},KR:{lat:39.08,lon:17.13},LC:{lat:45.86,lon:9.40},
  LE:{lat:40.35,lon:18.17},LI:{lat:43.00,lon:10.30},LO:{lat:45.31,lon:9.50},LT:{lat:41.46,lon:13.07},
  LU:{lat:43.84,lon:10.50},MB:{lat:45.62,lon:9.28},MC:{lat:43.30,lon:13.45},ME:{lat:38.19,lon:15.55},
  MI:{lat:45.46,lon:9.19},MN:{lat:45.16,lon:10.79},MO:{lat:44.65,lon:10.93},MS:{lat:44.03,lon:9.92},
  MT:{lat:40.33,lon:16.33},NA:{lat:40.85,lon:14.27},NO:{lat:45.55,lon:8.62},NU:{lat:40.32,lon:9.33},
  OR:{lat:39.90,lon:8.59},OT:{lat:40.92,lon:9.50},PA:{lat:38.13,lon:13.34},PC:{lat:44.83,lon:9.65},
  PD:{lat:45.41,lon:11.88},PE:{lat:42.46,lon:13.95},PG:{lat:43.11,lon:12.39},PI:{lat:43.72,lon:10.40},
  PN:{lat:46.07,lon:12.66},PO:{lat:43.88,lon:11.10},PR:{lat:44.80,lon:10.33},PT:{lat:43.93,lon:10.91},
  PU:{lat:43.62,lon:12.64},PV:{lat:45.18,lon:9.16},PZ:{lat:40.64,lon:15.80},RA:{lat:44.41,lon:12.20},
  RC:{lat:38.11,lon:15.65},RE:{lat:44.70,lon:10.63},RG:{lat:36.93,lon:14.73},RI:{lat:42.40,lon:12.86},
  RM:{lat:41.90,lon:12.49},RN:{lat:44.06,lon:12.57},RO:{lat:45.07,lon:11.79},SA:{lat:40.68,lon:15.14},
  SI:{lat:43.32,lon:11.33},SO:{lat:46.17,lon:9.87},SP:{lat:44.10,lon:9.82},SR:{lat:37.07,lon:15.29},
  SS:{lat:40.73,lon:8.56},SV:{lat:44.31,lon:8.33},TA:{lat:40.47,lon:17.23},TE:{lat:42.66,lon:13.70},
  TN:{lat:46.07,lon:11.12},TO:{lat:45.07,lon:7.68},TP:{lat:37.87,lon:12.67},TR:{lat:42.56,lon:12.64},
  TS:{lat:45.65,lon:13.77},TV:{lat:45.66,lon:12.24},UD:{lat:46.07,lon:13.24},VA:{lat:45.82,lon:8.83},
  VB:{lat:46.13,lon:8.54},VC:{lat:45.32,lon:8.42},VE:{lat:45.44,lon:12.33},VI:{lat:45.55,lon:11.55},
  VR:{lat:45.44,lon:11.00},VT:{lat:42.42,lon:11.86},VV:{lat:38.68,lon:16.10},
};

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();
// Cache geocoding per comune
const geoCache = new Map();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie`);
}

async function loadAllComuni() {
  const all = [];
  let from = 0;
  while (true) {
    const { data, error } = await supabase
      .from('comuni_italiani')
      .select('id, comune, provincia, sigla, regione')
      .order('id', { ascending: true })
      .range(from, from + 999);
    if (error || !data || data.length === 0) break;
    all.push(...data);
    if (data.length < 1000) break;
    from += 1000;
  }
  return all;
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

function doPost(hostname, path, body, timeoutMs = 30000) {
  return new Promise((resolve, reject) => {
    const opts = {
      hostname, path, method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(body),
        'User-Agent': 'ItalianBizDir/14.0'
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
    req.setTimeout(timeoutMs, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body); req.end();
  });
}

// Geocodifica un comune cercando il nodo/relation con place+name in Italia
async function geocodeComune(comuneName, sigla) {
  const key = `${comuneName}|${sigla}`;
  if (geoCache.has(key)) return geoCache.get(key);

  const pCoord = PROVINCE_COORDS[sigla];
  if (!pCoord) return null;

  const deg = 1.0;
  const bbox = `${pCoord.lat - deg},${pCoord.lon - deg},${pCoord.lat + deg},${pCoord.lon + deg}`;
  const escaped = comuneName.replace(/"/g, '\\"');
  const q = `[out:json][timeout:10];
(
  node["place"~"city|town|village|municipality"]["name"="${escaped}"](${bbox});
  node["place"="hamlet"]["name"="${escaped}"](${bbox});
);
out 1;`;

  try {
    const body = `data=${encodeURIComponent(q)}`;
    const data = await doPost('overpass-api.de', '/api/interpreter', body, 12000);
    const el = data.elements && data.elements[0];
    if (el) {
      // Trovato: coord precisa, raggio normale
      const coord = { lat: el.lat, lon: el.lon, precise: true };
      geoCache.set(key, coord);
      return coord;
    }
  } catch {
    // fallback
  }

  // Fallback: centroide provincia, raggio ridotto (2km) per evitare sovrapposizioni
  const coord = { lat: pCoord.lat, lon: pCoord.lon, precise: false };
  geoCache.set(key, coord);
  return coord;
}

function bboxFromCoord(lat, lon, radiusKm = 5) {
  const deg = radiusKm / 111.0;
  const degLon = deg / Math.cos(lat * Math.PI / 180);
  return `${(lat - deg).toFixed(5)},${(lon - degLon).toFixed(5)},${(lat + deg).toFixed(5)},${(lon + degLon).toFixed(5)}`;
}

function buildBboxQuery(bbox) {
  const parts = TAGS.map(t =>
    `  node["${t.key}"="${t.val}"](${bbox});\n  way["${t.key}"="${t.val}"](${bbox});`
  ).join('\n');
  return `[out:json][timeout:25];\n(\n${parts}\n);\nout center tags;`;
}

async function runComune(comune) {
  const geo = await geocodeComune(comune.comune, comune.sigla);
  if (!geo) return 0;

  await sleep(300); // piccola pausa tra geocoding e query dati

  // Raggio ridotto se coord non precisa (fallback su capoluogo provincia)
  const radius = geo.precise ? 6 : 2;
  const bbox = bboxFromCoord(geo.lat, geo.lon, radius);
  const query = buildBboxQuery(bbox);

  let elements = [];
  for (let retry = 0; retry < 2; retry++) {
    try {
      const body = `data=${encodeURIComponent(query)}`;
      const data = await doPost('overpass-api.de', '/api/interpreter', body, 30000);
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(60000); retry--; continue; }
      if (retry < 1) { await sleep(4000); continue; }
      return 0;
    }
  }

  if (!elements.length) return 0;

  const records = [];
  const seen = new Set();
  for (const el of elements) {
    const tags = el.tags || {};
    if (!tags.name) continue;
    const lat = el.lat ?? el.center?.lat;
    const lon = el.lon ?? el.center?.lon;
    if (!lat || !lon) continue;

    const key = `${tags.name}|${comune.sigla}|${lat.toFixed(4)}|${lon.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);

    const elKey = ['amenity', 'shop', 'craft', 'tourism', 'office', 'leisure'].find(k => tags[k]);
    const elVal = elKey ? tags[elKey] : null;
    const matchedTag = TAGS.find(t => t.key === elKey && t.val === elVal);
    if (!matchedTag) continue;
    const catId = categoryCache[matchedTag.cat];
    if (!catId) continue;

    const street = tags['addr:street'] || '';
    const hnum = tags['addr:housenumber'] || '';
    const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || tags['addr:municipality'] || comune.comune;
    records.push({
      name: tags.name.substring(0, 200),
      category_id: catId,
      street: street ? (hnum ? `${street}, ${hnum}` : street) : null,
      city: city.substring(0, 100),
      province: comune.sigla,
      region: comune.regione,
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
  console.log(`\n=== IMPORT PER COMUNE v2 (bbox geocodificata) ===\n`);
  await loadCategories();

  const comuni = await loadAllComuni();
  console.log(`Comuni caricati: ${comuni.length}\n`);

  for (let i = 0; i < comuni.length; i++) {
    const comune = comuni[i];
    try {
      const n = await runComune(comune);
      if (n > 0) {
        totalImported += n;
        const elapsed = ((Date.now() - startTime) / 60000).toFixed(1);
        const pct = (((i + 1) / comuni.length) * 100).toFixed(1);
        console.log(`[${i + 1}/${comuni.length}] ${comune.comune} (${comune.sigla}) +${n} | Totale: ${totalImported.toLocaleString()} | ${pct}% | ${elapsed}min`);
      }
    } catch (err) {
      console.error(`[${i + 1}] ERRORE ${comune.comune}: ${err.message}`);
    }
    await sleep(400);
  }

  console.log(`\n=== COMPLETATO ===`);
  console.log(`Importati: ${totalImported.toLocaleString()}`);
}

main().catch(console.error);
