import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Province italiane con coordinate bounding box
const PROVINCES = {
  'Aosta': { region: "Valle d'Aosta", bbox: [45.4, 6.7, 46.0, 7.9], code: 'AO' },
  'Torino': { region: 'Piemonte', bbox: [44.8, 6.9, 45.4, 8.0], code: 'TO' },
  'Milano': { region: 'Lombardia', bbox: [45.3, 8.8, 45.7, 9.5], code: 'MI' },
  'Varese': { region: 'Lombardia', bbox: [45.6, 8.5, 46.0, 9.0], code: 'VA' },
  'Como': { region: 'Lombardia', bbox: [45.6, 8.9, 46.1, 9.5], code: 'CO' },
  'Lecco': { region: 'Lombardia', bbox: [45.7, 9.2, 46.0, 9.6], code: 'LC' },
  'Bergamo': { region: 'Lombardia', bbox: [45.5, 9.4, 46.0, 10.2], code: 'BG' },
  'Brescia': { region: 'Lombardia', bbox: [45.3, 9.8, 46.0, 10.7], code: 'BS' },
  'Sondrio': { region: 'Lombardia', bbox: [46.0, 9.5, 46.5, 10.4], code: 'SO' },
  'Monza e Brianza': { region: 'Lombardia', bbox: [45.5, 9.1, 45.7, 9.4], code: 'MB' },
  'Pavia': { region: 'Lombardia', bbox: [44.9, 8.6, 45.4, 9.5], code: 'PV' },
  'Lodi': { region: 'Lombardia', bbox: [45.2, 9.3, 45.5, 9.8], code: 'LO' },
  'Cremona': { region: 'Lombardia', bbox: [45.0, 9.6, 45.3, 10.2], code: 'CR' },
  'Mantova': { region: 'Lombardia', bbox: [44.9, 10.4, 45.3, 11.2], code: 'MN' },
  'Venezia': { region: 'Veneto', bbox: [45.2, 12.0, 45.7, 13.0], code: 'VE' },
  'Verona': { region: 'Veneto', bbox: [45.2, 10.7, 45.8, 11.3], code: 'VR' },
  'Padova': { region: 'Veneto', bbox: [45.2, 11.6, 45.6, 12.2], code: 'PD' },
  'Vicenza': { region: 'Veneto', bbox: [45.4, 11.3, 45.9, 11.8], code: 'VI' },
  'Treviso': { region: 'Veneto', bbox: [45.5, 11.9, 46.0, 12.5], code: 'TV' },
  'Belluno': { region: 'Veneto', bbox: [46.0, 11.8, 46.6, 12.6], code: 'BL' },
  'Rovigo': { region: 'Veneto', bbox: [44.8, 11.5, 45.2, 12.2], code: 'RO' },
  'Bologna': { region: 'Emilia-Romagna', bbox: [44.2, 11.0, 44.7, 11.7], code: 'BO' },
  'Modena': { region: 'Emilia-Romagna', bbox: [44.4, 10.6, 44.8, 11.3], code: 'MO' },
  'Parma': { region: 'Emilia-Romagna', bbox: [44.5, 9.7, 44.9, 10.4], code: 'PR' },
  'Reggio Emilia': { region: 'Emilia-Romagna', bbox: [44.5, 10.3, 44.8, 10.8], code: 'RE' },
  'Piacenza': { region: 'Emilia-Romagna', bbox: [44.7, 9.3, 45.1, 9.9], code: 'PC' },
  'Ferrara': { region: 'Emilia-Romagna', bbox: [44.6, 11.4, 45.1, 12.4], code: 'FE' },
  'Ravenna': { region: 'Emilia-Romagna', bbox: [44.2, 11.8, 44.6, 12.4], code: 'RA' },
  'Forlì-Cesena': { region: 'Emilia-Romagna', bbox: [43.9, 11.9, 44.3, 12.3], code: 'FC' },
  'Rimini': { region: 'Emilia-Romagna', bbox: [43.9, 12.3, 44.1, 12.7], code: 'RN' },
  'Roma': { region: 'Lazio', bbox: [41.6, 12.2, 42.2, 13.0], code: 'RM' },
  'Latina': { region: 'Lazio', bbox: [41.2, 12.9, 41.7, 13.6], code: 'LT' },
  'Frosinone': { region: 'Lazio', bbox: [41.4, 13.3, 41.9, 14.0], code: 'FR' },
  'Viterbo': { region: 'Lazio', bbox: [42.2, 11.5, 42.7, 12.2], code: 'VT' },
  'Rieti': { region: 'Lazio', bbox: [42.2, 12.6, 42.7, 13.3], code: 'RI' },
  'Napoli': { region: 'Campania', bbox: [40.7, 14.0, 41.1, 14.6], code: 'NA' },
  'Salerno': { region: 'Campania', bbox: [40.2, 14.7, 40.9, 15.6], code: 'SA' },
  'Caserta': { region: 'Campania', bbox: [40.9, 13.8, 41.4, 14.5], code: 'CE' },
  'Avellino': { region: 'Campania', bbox: [40.7, 14.7, 41.2, 15.2], code: 'AV' },
  'Benevento': { region: 'Campania', bbox: [41.0, 14.5, 41.4, 15.0], code: 'BN' },
  'Firenze': { region: 'Toscana', bbox: [43.6, 11.0, 44.0, 11.5], code: 'FI' },
  'Genova': { region: 'Liguria', bbox: [44.2, 8.7, 44.6, 9.3], code: 'GE' },
  'Palermo': { region: 'Sicilia', bbox: [37.9, 13.0, 38.3, 13.6], code: 'PA' },
  'Bari': { region: 'Puglia', bbox: [40.8, 16.8, 41.3, 17.3], code: 'BA' },
};

const CATEGORIES = [
  { osm: 'shop=supermarket', db: 'Supermercati' },
  { osm: 'shop=convenience', db: 'Alimentari' },
  { osm: 'shop=bakery', db: 'Panifici e Pasticcerie' },
  { osm: 'shop=butcher', db: 'Macellerie' },
  { osm: 'shop=clothes', db: 'Abbigliamento' },
  { osm: 'shop=hairdresser', db: 'Parrucchieri e Barbieri' },
  { osm: 'shop=beauty', db: 'Centri Estetici' },
  { osm: 'shop=florist', db: 'Fioristi' },
  { osm: 'shop=pharmacy', db: 'Farmacie' },
  { osm: 'shop=bookshop', db: 'Librerie' },
  { osm: 'shop=jewelry', db: 'Gioiellerie' },
  { osm: 'shop=hardware', db: 'Ferramenta' },
  { osm: 'shop=car_repair', db: 'Autofficine' },
  { osm: 'amenity=restaurant', db: 'Ristoranti' },
  { osm: 'amenity=cafe', db: 'Bar e Caffè' },
  { osm: 'amenity=bar', db: 'Bar e Caffè' },
  { osm: 'amenity=fast_food', db: 'Fast Food' },
  { osm: 'amenity=pub', db: 'Pub e Locali' },
  { osm: 'amenity=bank', db: 'Banche' },
  { osm: 'amenity=pharmacy', db: 'Farmacie' },
  { osm: 'amenity=dentist', db: 'Dentisti' },
  { osm: 'amenity=doctors', db: 'Medici' },
  { osm: 'amenity=veterinary', db: 'Veterinari' },
  { osm: 'amenity=fuel', db: 'Benzinai' },
  { osm: 'amenity=ice_cream', db: 'Gelaterie' },
  { osm: 'office=lawyer', db: 'Avvocati' },
  { osm: 'office=accountant', db: 'Commercialisti' },
  { osm: 'office=architect', db: 'Architetti' },
  { osm: 'office=estate_agent', db: 'Agenzie Immobiliari' },
  { osm: 'office=insurance', db: 'Assicurazioni' },
  { osm: 'tourism=hotel', db: 'Hotel' },
  { osm: 'leisure=fitness_centre', db: 'Palestre' },
];

const categoryCache = {};

async function getCategoryId(name) {
  if (categoryCache[name]) return categoryCache[name];

  const { data } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', name)
    .maybeSingle();

  if (data) {
    categoryCache[name] = data.id;
    return data.id;
  }
  return null;
}

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function queryOverpass(bbox, osmTag) {
  const bboxStr = `${bbox[0]},${bbox[1]},${bbox[2]},${bbox[3]}`;
  const query = `
    [out:json][timeout:60];
    (
      node[${osmTag}](${bboxStr});
      way[${osmTag}](${bboxStr});
      relation[${osmTag}](${bboxStr});
    );
    out center;
  `;

  try {
    const response = await fetch('https://overpass-api.de/api/interpreter', {
      method: 'POST',
      body: query,
      headers: { 'Content-Type': 'text/plain' }
    });

    if (!response.ok) return [];
    const data = await response.json();
    return data.elements || [];
  } catch (error) {
    return [];
  }
}

function extractData(element, provinceName, provinceData) {
  const tags = element.tags || {};

  let lat, lon;
  if (element.lat && element.lon) {
    lat = element.lat;
    lon = element.lon;
  } else if (element.center) {
    lat = element.center.lat;
    lon = element.center.lon;
  } else {
    return null;
  }

  const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
  if (!name) return null;

  const street = tags['addr:street'] || '';
  const houseNumber = tags['addr:housenumber'] || '';
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || provinceName;
  const postcode = tags['addr:postcode'] || '';
  const address = [street, houseNumber].filter(Boolean).join(' ') || 'Indirizzo non disponibile';

  return {
    name,
    address,
    city,
    province: provinceData.code,
    region: provinceData.region,
    postcode,
    latitude: lat,
    longitude: lon,
    phone: tags.phone || tags['contact:phone'] || '',
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
  };
}

async function importProvince(provinceName, provinceData) {
  console.log(`\n========================================`);
  console.log(`PROVINCIA: ${provinceName} (${provinceData.region})`);
  console.log(`========================================`);

  let total = 0;

  for (const category of CATEGORIES) {
    const categoryId = await getCategoryId(category.db);
    if (!categoryId) {
      await sleep(1000);
      continue;
    }

    const elements = await queryOverpass(provinceData.bbox, category.osm);

    if (elements.length === 0) {
      await sleep(2000);
      continue;
    }

    let imported = 0;
    for (const element of elements) {
      const data = extractData(element, provinceName, provinceData);
      if (!data) continue;

      try {
        const { data: existing } = await supabase
          .from('businesses')
          .select('id')
          .eq('name', data.name)
          .eq('city', data.city)
          .maybeSingle();

        if (existing) continue;

        const { data: newBiz, error: bizError } = await supabase
          .from('businesses')
          .insert({
            name: data.name,
            category_id: categoryId,
            description: '',
            address: data.address,
            city: data.city,
            phone: data.phone,
            email: data.email,
            website: data.website,
            verified: true,
            is_claimed: false,
            owner_id: null
          })
          .select('id')
          .single();

        if (bizError) continue;

        await supabase
          .from('business_locations')
          .insert({
            business_id: newBiz.id,
            name: 'Sede principale',
            address: data.address,
            city: data.city,
            province: data.province,
            region: data.region,
            postal_code: data.postcode,
            latitude: data.latitude,
            longitude: data.longitude,
            phone: data.phone,
            email: data.email,
            website: data.website,
            is_primary: true
          });

        imported++;
      } catch (error) {
        // Skip errors
      }
    }

    if (imported > 0) {
      console.log(`  ✓ ${category.db}: ${imported} attività`);
      total += imported;
    }

    await sleep(3000);
  }

  console.log(`\n  TOTALE ${provinceName}: ${total} attività importate\n`);
  return total;
}

async function main() {
  console.log('\n╔════════════════════════════════════════════════════════════╗');
  console.log('║   IMPORTAZIONE DATI DA OPENSTREETMAP - ITALIA             ║');
  console.log('║   Provincia per provincia per non sovraccaricare i server ║');
  console.log('╚════════════════════════════════════════════════════════════╝\n');

  let grandTotal = 0;
  let provinceCount = 0;

  for (const [provinceName, provinceData] of Object.entries(PROVINCES)) {
    try {
      const count = await importProvince(provinceName, provinceData);
      grandTotal += count;
      provinceCount++;

      console.log(`Pausa di 10 secondi prima della prossima provincia...\n`);
      await sleep(10000);
    } catch (error) {
      console.error(`Errore in ${provinceName}:`, error.message);
      await sleep(5000);
    }
  }

  console.log('\n╔════════════════════════════════════════════════════════════╗');
  console.log('║                 IMPORTAZIONE COMPLETATA                    ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log(`\nProvince processate: ${provinceCount}`);
  console.log(`Totale attività importate: ${grandTotal}\n`);
}

main().catch(console.error);
