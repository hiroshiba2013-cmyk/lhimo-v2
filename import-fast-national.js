import { createClient } from '@supabase/supabase-js';
import fetch from 'node-fetch';
import * as dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const ITALY_REGIONS = [
  { name: 'Valle d\'Aosta', bbox: [45.4, 6.7, 46.0, 7.9] },
  { name: 'Piemonte', bbox: [44.0, 6.6, 46.5, 9.2] },
  { name: 'Lombardia', bbox: [44.6, 8.5, 46.7, 11.5] },
  { name: 'Trentino-Alto Adige', bbox: [45.7, 10.4, 47.1, 12.5] },
  { name: 'Veneto', bbox: [44.8, 10.7, 46.7, 13.0] },
  { name: 'Friuli-Venezia Giulia', bbox: [45.5, 12.3, 46.7, 13.9] },
  { name: 'Liguria', bbox: [43.8, 7.5, 44.7, 10.1] },
  { name: 'Emilia-Romagna', bbox: [43.7, 9.2, 45.2, 12.8] },
  { name: 'Toscana', bbox: [42.2, 9.7, 44.5, 12.4] },
  { name: 'Umbria', bbox: [42.4, 11.9, 43.6, 13.3] },
  { name: 'Marche', bbox: [42.7, 12.3, 44.0, 13.9] },
  { name: 'Lazio', bbox: [41.0, 11.5, 42.9, 13.8] },
  { name: 'Abruzzo', bbox: [41.7, 13.0, 42.9, 14.8] },
  { name: 'Molise', bbox: [41.4, 14.1, 42.0, 15.2] },
  { name: 'Campania', bbox: [39.9, 13.7, 41.5, 15.8] },
  { name: 'Puglia', bbox: [39.8, 14.9, 42.2, 18.5] },
  { name: 'Basilicata', bbox: [39.9, 15.4, 41.2, 16.9] },
  { name: 'Calabria', bbox: [37.9, 15.6, 40.2, 17.2] },
  { name: 'Sicilia', bbox: [36.6, 12.4, 38.3, 15.7] },
  { name: 'Sardegna', bbox: [38.9, 8.1, 41.3, 9.8] },
];

const TOP_CATEGORIES = [
  { osm: 'amenity=restaurant', db: 'Ristoranti' },
  { osm: 'amenity=bar', db: 'Bar e Caffè' },
  { osm: 'shop=supermarket', db: 'Supermercati' },
  { osm: 'amenity=pharmacy', db: 'Farmacie' },
  { osm: 'amenity=bank', db: 'Banche' },
  { osm: 'amenity=post_office', db: 'Uffici Postali' },
  { osm: 'amenity=fuel', db: 'Distributori di Carburante' },
  { osm: 'amenity=hospital', db: 'Ospedali e Cliniche' },
  { osm: 'amenity=dentist', db: 'Dentisti' },
  { osm: 'amenity=veterinary', db: 'Veterinari' },
  { osm: 'shop=bakery', db: 'Panifici e Pasticcerie' },
  { osm: 'shop=hairdresser', db: 'Parrucchieri' },
  { osm: 'shop=car_repair', db: 'Officine Auto' },
  { osm: 'craft=electrician', db: 'Elettricisti' },
  { osm: 'craft=plumber', db: 'Idraulici' },
  { osm: 'office=lawyer', db: 'Avvocati' },
  { osm: 'office=accountant', db: 'Commercialisti' },
  { osm: 'office=estate_agent', db: 'Agenzie Immobiliari' },
  { osm: 'shop=florist', db: 'Fioristi' },
  { osm: 'shop=hardware', db: 'Ferramenta' },
];

const categoryCache = {};
let totalImported = 0;
let totalProcessed = 0;

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

async function queryOverpass(bbox, osmTag, maxRetries = 2) {
  const bboxStr = `${bbox[0]},${bbox[1]},${bbox[2]},${bbox[3]}`;
  const query = `
    [out:json][timeout:90];
    (
      node[${osmTag}](${bboxStr});
      way[${osmTag}](${bboxStr});
    );
    out center;
  `;

  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        body: query,
        headers: { 'Content-Type': 'text/plain' },
        signal: AbortSignal.timeout(60000)
      });

      if (!response.ok) {
        if (response.status === 429) {
          console.log('   ⏳ Rate limit, attendo...');
          await sleep(90000);
          continue;
        }
        if (response.status >= 500) {
          throw new Error(`Server error: ${response.status}`);
        }
        return [];
      }

      const data = await response.json();
      return data.elements || [];
    } catch (error) {
      if (attempt < maxRetries - 1) {
        await sleep(15000);
      }
    }
  }

  return [];
}

function extractData(element, region) {
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
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || '';
  const province = tags['addr:province'] || '';
  const postcode = tags['addr:postcode'] || '';

  let address = '';
  if (street && houseNumber) {
    address = `${street}, ${houseNumber}`;
  } else if (street) {
    address = street;
  }

  return {
    name,
    address,
    city,
    province,
    region,
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
    business_hours: tags.opening_hours || null,
  };
}

async function importRegion(region, regionIndex) {
  console.log(`\n${'='.repeat(80)}`);
  console.log(`📍 REGIONE [${regionIndex}/${ITALY_REGIONS.length}]: ${region.name}`);
  console.log('='.repeat(80));

  let regionImported = 0;

  for (let i = 0; i < TOP_CATEGORIES.length; i++) {
    const category = TOP_CATEGORIES[i];
    const categoryId = await getCategoryId(category.db);

    if (!categoryId) {
      console.log(`   [${i+1}/${TOP_CATEGORIES.length}] ${category.db.padEnd(30)} ⚠️  SKIP (categoria non trovata)`);
      continue;
    }

    process.stdout.write(`   [${i+1}/${TOP_CATEGORIES.length}] ${category.db.padEnd(30)} `);

    const elements = await queryOverpass(region.bbox, category.osm);
    totalProcessed += elements.length;

    if (elements.length === 0) {
      console.log('⚪ 0');
      await sleep(2000);
      continue;
    }

    let imported = 0;
    let duplicates = 0;

    for (const element of elements) {
      const businessData = extractData(element, region.name);
      if (!businessData || !businessData.city) continue;

      const { data: existing } = await supabase
        .from('unclaimed_business_locations')
        .select('id')
        .eq('name', businessData.name)
        .eq('city', businessData.city)
        .maybeSingle();

      if (existing) {
        duplicates++;
        continue;
      }

      const { error } = await supabase
        .from('unclaimed_business_locations')
        .insert({
          category_id: categoryId,
          name: businessData.name,
          address: businessData.address,
          city: businessData.city,
          province: businessData.province,
          region: businessData.region,
          postal_code: businessData.postal_code,
          country: 'Italia',
          latitude: businessData.latitude,
          longitude: businessData.longitude,
          phone: businessData.phone,
          email: businessData.email,
          website: businessData.website,
          business_hours: businessData.business_hours,
          verified: true,
        });

      if (!error) {
        imported++;
      }
    }

    console.log(`✅ ${imported} (dup: ${duplicates})`);
    regionImported += imported;
    totalImported += imported;

    await sleep(3000);
  }

  console.log(`\n📊 ${region.name}: ${regionImported} attività importate`);

  return regionImported;
}

async function main() {
  console.log('\n╔════════════════════════════════════════════════════════════════════╗');
  console.log('║         IMPORTAZIONE RAPIDA NAZIONALE                              ║');
  console.log('║                                                                    ║');
  console.log(`║  Regioni: ${ITALY_REGIONS.length}                                                       ║`);
  console.log(`║  Categorie per regione: ${TOP_CATEGORIES.length}                                      ║`);
  console.log('║  Focus: Categorie più popolate a livello nazionale                 ║');
  console.log('╚════════════════════════════════════════════════════════════════════╝\n');

  const startTime = Date.now();

  for (let i = 0; i < ITALY_REGIONS.length; i++) {
    await importRegion(ITALY_REGIONS[i], i + 1);

    if ((i + 1) % 5 === 0) {
      const elapsed = ((Date.now() - startTime) / 1000 / 60).toFixed(1);
      console.log(`\n${'▓'.repeat(60)}`);
      console.log(`📈 PROGRESSO: ${i + 1}/${ITALY_REGIONS.length} regioni completate`);
      console.log(`   Totale importate: ${totalImported.toLocaleString()}`);
      console.log(`   Totale processate: ${totalProcessed.toLocaleString()}`);
      console.log(`   Tempo trascorso: ${elapsed} minuti`);
      console.log('▓'.repeat(60) + '\n');
    }
  }

  const totalTime = ((Date.now() - startTime) / 1000 / 60).toFixed(1);

  console.log('\n╔════════════════════════════════════════════════════════════════════╗');
  console.log('║                    IMPORTAZIONE COMPLETATA ✓                        ║');
  console.log('╚════════════════════════════════════════════════════════════════════╝');
  console.log(`\n📊 RIEPILOGO FINALE:`);
  console.log(`   Regioni processate:        ${ITALY_REGIONS.length}`);
  console.log(`   Attività importate:        ${totalImported.toLocaleString()}`);
  console.log(`   Attività processate:       ${totalProcessed.toLocaleString()}`);
  console.log(`   Tasso successo:            ${((totalImported/totalProcessed)*100).toFixed(1)}%`);
  console.log(`   Tempo totale:              ${totalTime} minuti`);
  console.log(`   Media per regione:         ${(totalImported/ITALY_REGIONS.length).toFixed(0)} attività\n`);
}

main().catch(console.error);
