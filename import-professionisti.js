/**
 * Importazione professionisti: notai, avvocati, commercialisti, architetti, geometri, ingegneri
 * Tag OSM: office=lawyer|notary|accountant|architect|surveyor|engineer|tax_advisor|financial_advisor
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const ITALIAN_CITIES = [
  { name: 'Roma', region: 'Lazio', province: 'RM', bbox: [41.78, 12.38, 41.98, 12.58] },
  { name: 'Milano', region: 'Lombardia', province: 'MI', bbox: [45.38, 9.08, 45.54, 9.28] },
  { name: 'Napoli', region: 'Campania', province: 'NA', bbox: [40.78, 14.18, 40.90, 14.32] },
  { name: 'Torino', region: 'Piemonte', province: 'TO', bbox: [44.98, 7.60, 45.14, 7.76] },
  { name: 'Palermo', region: 'Sicilia', province: 'PA', bbox: [38.06, 13.30, 38.18, 13.42] },
  { name: 'Genova', region: 'Liguria', province: 'GE', bbox: [44.36, 8.86, 44.48, 9.00] },
  { name: 'Bologna', region: 'Emilia-Romagna', province: 'BO', bbox: [44.44, 11.28, 44.56, 11.40] },
  { name: 'Firenze', region: 'Toscana', province: 'FI', bbox: [43.72, 11.20, 43.84, 11.32] },
  { name: 'Bari', region: 'Puglia', province: 'BA', bbox: [41.06, 16.82, 41.18, 16.94] },
  { name: 'Catania', region: 'Sicilia', province: 'CT', bbox: [37.46, 15.04, 37.58, 15.16] },
  { name: 'Verona', region: 'Veneto', province: 'VR', bbox: [45.38, 10.94, 45.50, 11.06] },
  { name: 'Venezia', region: 'Veneto', province: 'VE', bbox: [45.38, 12.28, 45.50, 12.40] },
  { name: 'Messina', region: 'Sicilia', province: 'ME', bbox: [38.14, 15.50, 38.26, 15.62] },
  { name: 'Padova', region: 'Veneto', province: 'PD', bbox: [45.36, 11.82, 45.48, 11.94] },
  { name: 'Trieste', region: 'Friuli-Venezia Giulia', province: 'TS', bbox: [45.60, 13.72, 45.72, 13.84] },
  { name: 'Brescia', region: 'Lombardia', province: 'BS', bbox: [45.50, 10.18, 45.62, 10.30] },
  { name: 'Taranto', region: 'Puglia', province: 'TA', bbox: [40.42, 17.20, 40.54, 17.32] },
  { name: 'Prato', region: 'Toscana', province: 'PO', bbox: [43.84, 11.04, 43.96, 11.16] },
  { name: 'Parma', region: 'Emilia-Romagna', province: 'PR', bbox: [44.74, 10.28, 44.86, 10.40] },
  { name: 'Modena', region: 'Emilia-Romagna', province: 'MO', bbox: [44.60, 10.88, 44.72, 11.00] },
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [38.06, 15.60, 38.18, 15.72] },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'RE', bbox: [44.64, 10.58, 44.76, 10.70] },
  { name: 'Perugia', region: 'Umbria', province: 'PG', bbox: [43.06, 12.34, 43.18, 12.46] },
  { name: 'Ravenna', region: 'Emilia-Romagna', province: 'RA', bbox: [44.36, 12.16, 44.48, 12.28] },
  { name: 'Livorno', region: 'Toscana', province: 'LI', bbox: [43.50, 10.28, 43.62, 10.40] },
  { name: 'Cagliari', region: 'Sardegna', province: 'CA', bbox: [39.18, 9.06, 39.30, 9.18] },
  { name: 'Foggia', region: 'Puglia', province: 'FG', bbox: [41.42, 15.52, 41.54, 15.64] },
  { name: 'Rimini', region: 'Emilia-Romagna', province: 'RN', bbox: [44.02, 12.52, 44.14, 12.64] },
  { name: 'Salerno', region: 'Campania', province: 'SA', bbox: [40.64, 14.72, 40.76, 14.84] },
  { name: 'Ferrara', region: 'Emilia-Romagna', province: 'FE', bbox: [44.80, 11.58, 44.92, 11.70] },
  { name: 'Sassari', region: 'Sardegna', province: 'SS', bbox: [40.70, 8.52, 40.82, 8.64] },
  { name: 'Latina', region: 'Lazio', province: 'LT', bbox: [41.42, 12.86, 41.54, 12.98] },
  { name: 'Monza', region: 'Lombardia', province: 'MB', bbox: [45.56, 9.24, 45.68, 9.36] },
  { name: 'Siracusa', region: 'Sicilia', province: 'SR', bbox: [37.04, 15.26, 37.16, 15.38] },
  { name: 'Pescara', region: 'Abruzzo', province: 'PE', bbox: [42.42, 14.18, 42.54, 14.30] },
  { name: 'Bergamo', region: 'Lombardia', province: 'BG', bbox: [45.66, 9.64, 45.78, 9.76] },
  { name: 'Trento', region: 'Trentino-Alto Adige', province: 'TN', bbox: [46.04, 11.10, 46.16, 11.22] },
  { name: 'Vicenza', region: 'Veneto', province: 'VI', bbox: [45.52, 11.50, 45.64, 11.62] },
  { name: 'Terni', region: 'Umbria', province: 'TR', bbox: [42.52, 12.60, 42.64, 12.72] },
  { name: 'Bolzano', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.46, 11.30, 46.58, 11.42] },
  { name: 'Novara', region: 'Piemonte', province: 'NO', bbox: [45.42, 8.58, 45.54, 8.70] },
  { name: 'Piacenza', region: 'Emilia-Romagna', province: 'PC', bbox: [45.02, 9.66, 45.14, 9.78] },
  { name: 'Ancona', region: 'Marche', province: 'AN', bbox: [43.56, 13.48, 43.68, 13.60] },
  { name: 'Arezzo', region: 'Toscana', province: 'AR', bbox: [43.44, 11.84, 43.56, 11.96] },
  { name: 'Udine', region: 'Friuli-Venezia Giulia', province: 'UD', bbox: [46.04, 13.20, 46.16, 13.32] },
  { name: 'Lecce', region: 'Puglia', province: 'LE', bbox: [40.32, 18.14, 40.44, 18.26] },
  { name: 'Pesaro', region: 'Marche', province: 'PU', bbox: [43.88, 12.88, 44.00, 13.00] },
  { name: 'Alessandria', region: 'Piemonte', province: 'AL', bbox: [44.88, 8.58, 45.00, 8.70] },
  { name: 'La Spezia', region: 'Liguria', province: 'SP', bbox: [44.08, 9.78, 44.20, 9.90] },
  { name: 'Pisa', region: 'Toscana', province: 'PI', bbox: [43.68, 10.36, 43.80, 10.48] },
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.86, 16.56, 38.98, 16.68] },
  { name: 'Lucca', region: 'Toscana', province: 'LU', bbox: [43.80, 10.46, 43.92, 10.58] },
  { name: 'Brindisi', region: 'Puglia', province: 'BR', bbox: [40.60, 17.90, 40.72, 18.02] },
  { name: 'Como', region: 'Lombardia', province: 'CO', bbox: [45.78, 9.06, 45.90, 9.18] },
  { name: 'Treviso', region: 'Veneto', province: 'TV', bbox: [45.64, 12.22, 45.76, 12.34] },
  { name: 'Varese', region: 'Lombardia', province: 'VA', bbox: [45.78, 8.78, 45.90, 8.90] },
  { name: 'Asti', region: 'Piemonte', province: 'AT', bbox: [44.86, 8.16, 44.98, 8.28] },
  { name: 'Caserta', region: 'Campania', province: 'CE', bbox: [41.04, 14.30, 41.16, 14.42] },
  { name: 'Pavia', region: 'Lombardia', province: 'PV', bbox: [45.16, 9.12, 45.28, 9.24] },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.26, 16.22, 39.38, 16.34] },
  { name: 'Cremona', region: 'Lombardia', province: 'CR', bbox: [45.10, 10.00, 45.22, 10.12] },
  { name: 'Matera', region: 'Basilicata', province: 'MT', bbox: [40.62, 16.56, 40.74, 16.68] },
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.61, 15.77, 40.73, 15.89] },
  { name: 'Campobasso', region: 'Molise', province: 'CB', bbox: [41.53, 14.62, 41.65, 14.74] },
  { name: 'Aosta', region: "Valle d'Aosta", province: 'AO', bbox: [45.70, 7.27, 45.82, 7.39] },
  { name: "L'Aquila", region: 'Abruzzo', province: 'AQ', bbox: [42.33, 13.33, 42.45, 13.45] },
  { name: 'Avellino', region: 'Campania', province: 'AV', bbox: [40.89, 14.77, 41.01, 14.89] },
  { name: 'Benevento', region: 'Campania', province: 'BN', bbox: [41.10, 14.76, 41.22, 14.88] },
  { name: 'Frosinone', region: 'Lazio', province: 'FR', bbox: [41.61, 13.31, 41.73, 13.43] },
  { name: 'Rieti', region: 'Lazio', province: 'RI', bbox: [42.38, 12.82, 42.50, 12.94] },
  { name: 'Viterbo', region: 'Lazio', province: 'VT', bbox: [42.38, 12.04, 42.50, 12.16] },
  { name: 'Grosseto', region: 'Toscana', province: 'GR', bbox: [42.74, 11.06, 42.86, 11.18] },
  { name: 'Siena', region: 'Toscana', province: 'SI', bbox: [43.30, 11.28, 43.42, 11.40] },
  { name: 'Massa', region: 'Toscana', province: 'MS', bbox: [44.00, 10.10, 44.12, 10.22] },
  { name: 'Pistoia', region: 'Toscana', province: 'PT', bbox: [43.90, 10.88, 44.02, 11.00] },
  { name: 'Macerata', region: 'Marche', province: 'MC', bbox: [43.27, 13.43, 43.39, 13.55] },
  { name: 'Ascoli Piceno', region: 'Marche', province: 'AP', bbox: [42.84, 13.57, 42.92, 13.65] },
  { name: 'Fermo', region: 'Marche', province: 'FM', bbox: [43.15, 13.71, 43.23, 13.79] },
  { name: 'Isernia', region: 'Molise', province: 'IS', bbox: [41.59, 14.22, 41.67, 14.30] },
  { name: 'Olbia', region: 'Sardegna', province: 'SS', bbox: [40.89, 9.47, 41.01, 9.59] },
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', bbox: [40.29, 9.30, 40.41, 9.42] },
  { name: 'Oristano', region: 'Sardegna', province: 'OR', bbox: [39.89, 8.58, 39.97, 8.66] },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'RE', bbox: [44.64, 10.58, 44.76, 10.70] },
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.94, 12.62, 46.06, 12.74] },
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.92, 13.60, 46.04, 13.72] },
  { name: 'Cuneo', region: 'Piemonte', province: 'CN', bbox: [44.36, 7.52, 44.48, 7.64] },
  { name: 'Biella', region: 'Piemonte', province: 'BI', bbox: [45.54, 8.04, 45.66, 8.16] },
  { name: 'Verbania', region: 'Piemonte', province: 'VB', bbox: [45.92, 8.50, 46.04, 8.62] },
  { name: 'Vercelli', region: 'Piemonte', province: 'VC', bbox: [45.30, 8.38, 45.42, 8.50] },
  { name: 'Mantova', region: 'Lombardia', province: 'MN', bbox: [45.14, 10.74, 45.26, 10.86] },
  { name: 'Lecco', region: 'Lombardia', province: 'LC', bbox: [45.82, 9.36, 45.94, 9.48] },
  { name: 'Lodi', region: 'Lombardia', province: 'LO', bbox: [45.30, 9.48, 45.42, 9.60] },
  { name: 'Sondrio', region: 'Lombardia', province: 'SO', bbox: [46.16, 9.84, 46.28, 9.96] },
  { name: 'Belluno', region: 'Veneto', province: 'BL', bbox: [46.12, 12.20, 46.24, 12.32] },
  { name: 'Rovigo', region: 'Veneto', province: 'RO', bbox: [44.98, 11.78, 45.10, 11.90] },
  { name: 'Crotone', region: 'Calabria', province: 'KR', bbox: [38.97, 17.08, 39.09, 17.20] },
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.67, 16.08, 38.79, 16.20] },
  { name: 'Agrigento', region: 'Sicilia', province: 'AG', bbox: [37.28, 13.56, 37.40, 13.68] },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [37.46, 14.02, 37.58, 14.14] },
  { name: 'Enna', region: 'Sicilia', province: 'EN', bbox: [37.54, 14.26, 37.66, 14.38] },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.90, 14.70, 37.02, 14.82] },
  { name: 'Trapani', region: 'Sicilia', province: 'TP', bbox: [37.98, 12.50, 38.10, 12.62] },
  { name: 'Chieti', region: 'Abruzzo', province: 'CH', bbox: [42.34, 14.14, 42.42, 14.22] },
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.64, 13.68, 42.72, 13.76] },
  { name: 'Avezzano', region: 'Abruzzo', province: 'AQ', bbox: [42.02, 13.41, 42.10, 13.49] },
  { name: 'Andria', region: 'Puglia', province: 'BT', bbox: [41.20, 16.28, 41.28, 16.36] },
  { name: 'Barletta', region: 'Puglia', province: 'BT', bbox: [41.30, 16.26, 41.38, 16.34] },
  { name: 'Trani', region: 'Puglia', province: 'BT', bbox: [41.26, 16.40, 41.34, 16.48] },
  { name: 'Altamura', region: 'Puglia', province: 'BA', bbox: [40.80, 16.54, 40.88, 16.62] },
  { name: 'Cerignola', region: 'Puglia', province: 'FG', bbox: [41.26, 15.88, 41.34, 15.96] },
];

// Query Overpass specifica per professionisti
const PROF_QUERY = (bboxStr) => `
[out:json][timeout:180];
(
  node["office"~"^(lawyer|notary|accountant|architect|surveyor|engineer|tax_advisor|financial_advisor|insurance|estate_agent|travel_agent|it|consulting|political_party|association|foundation|research|educational_institution|property_management)$"](${bboxStr});
  way["office"~"^(lawyer|notary|accountant|architect|surveyor|engineer|tax_advisor|financial_advisor|insurance|estate_agent|travel_agent|it|consulting|property_management)$"](${bboxStr});
  node["amenity"="courthouse"](${bboxStr});
  node["amenity"="townhall"](${bboxStr});
);
out center tags;
`;

const OFFICE_CATEGORY_MAP = {
  'lawyer': 'Avvocati',
  'notary': 'Notai',
  'accountant': 'Commercialisti',
  'architect': 'Architetti',
  'surveyor': 'Geometri',
  'engineer': 'Ingegneri',
  'tax_advisor': 'Consulenti Fiscali',
  'financial_advisor': 'Consulenti Finanziari',
  'insurance': 'Assicurazioni',
  'estate_agent': 'Agenzie Immobiliari',
  'travel_agent': 'Agenzie di Viaggio',
  'it': 'Informatica',
  'consulting': 'Consulenti',
  'property_management': 'Agenzie Immobiliari',
};

let categoryCache = {};
let totalImported = 0;
let startTime = Date.now();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie`);
}

function getCategory(tags) {
  if (tags.office) {
    const catName = OFFICE_CATEGORY_MAP[tags.office];
    if (catName && categoryCache[catName]) return categoryCache[catName];
  }
  return null;
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const opts = {
      hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': Buffer.byteLength(query), 'User-Agent': 'ItalianBizDir/3.1-prof' }
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
    req.setTimeout(150000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(query); req.end();
  });
}

async function importCity(city, idx, total) {
  process.stdout.write(`[${idx}/${total}] ${city.name} (${city.region})... `);
  const bboxStr = `${city.bbox[0]},${city.bbox[1]},${city.bbox[2]},${city.bbox[3]}`;

  let elements = [];
  for (let retry = 0; retry < 3; retry++) {
    try {
      const data = await fetchOverpass(PROF_QUERY(bboxStr));
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { process.stdout.write('\n   Rate limit 90s...'); await sleep(90000); retry--; continue; }
      if (retry < 2) await sleep((retry + 1) * 15000);
      else { console.log('ERRORE'); return 0; }
    }
  }

  if (!elements.length) { console.log('0'); return 0; }

  const records = [];
  const seen = new Set();

  for (const el of elements) {
    const tags = el.tags || {};
    if (!tags.name) continue;
    const categoryId = getCategory(tags);
    if (!categoryId) continue;
    const lat = el.lat || el.center?.lat;
    const lon = el.lon || el.center?.lon;
    if (!lat || !lon) continue;

    const cityName = (tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || city.name).substring(0, 100);
    const street = tags['addr:street'] || '';
    const houseNum = tags['addr:housenumber'] || '';
    const streetFull = street ? (houseNum ? `${street}, ${houseNum}` : street) : null;
    const key = `${tags.name}|${cityName}|${lat.toFixed(4)}|${lon.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);

    records.push({
      name: tags.name.substring(0, 200),
      category_id: categoryId,
      street: streetFull,
      city: cityName,
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
    });
  }

  if (!records.length) { console.log('0 categorie valide'); return 0; }

  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const { error } = await supabase.from('unclaimed_business_locations').insert(records.slice(i, i + 200));
    if (!error) inserted += Math.min(200, records.length - i);
    else console.error('\n  Insert error:', error.message);
  }

  totalImported += inserted;
  const mins = ((Date.now() - startTime) / 60000).toFixed(1);
  console.log(`${inserted} professionisti | Totale: ${totalImported.toLocaleString()} (${mins}min)`);
  return inserted;
}

async function main() {
  console.log(`\n=== IMPORTAZIONE PROFESSIONISTI (${ITALIAN_CITIES.length} città) ===`);
  console.log(`Categorie: Notai, Avvocati, Commercialisti, Architetti, Geometri, Ingegneri + altri uffici\n`);
  await loadCategories();

  for (let i = 0; i < ITALIAN_CITIES.length; i++) {
    await importCity(ITALIAN_CITIES[i], i + 1, ITALIAN_CITIES.length);
    await sleep(4000);
    if ((i + 1) % 20 === 0) {
      const mins = ((Date.now() - startTime) / 60000).toFixed(0);
      console.log(`\n--- Checkpoint: ${totalImported.toLocaleString()} inseriti in ${mins} min ---\n`);
    }
  }

  // Riepilogo finale
  console.log('\n=== RIEPILOGO FINALE ===');
  const cats = ['Notai','Avvocati','Commercialisti','Architetti','Geometri','Ingegneri','Consulenti Fiscali','Consulenti Finanziari','Assicurazioni','Agenzie Immobiliari'];
  const { data } = await supabase
    .from('unclaimed_business_locations')
    .select('category_id, business_categories!inner(name)')
    .in('category_id', cats.map(c => categoryCache[c]).filter(Boolean));

  const totals = {};
  (data || []).forEach(r => {
    const n = r.business_categories?.name;
    if (n) totals[n] = (totals[n] || 0) + 1;
  });
  Object.entries(totals).sort((a,b) => b[1]-a[1]).forEach(([k,v]) => console.log(`  ${k}: ${v}`));
  console.log(`\nTotale sessione: ${totalImported.toLocaleString()}`);
}

main().catch(console.error);
