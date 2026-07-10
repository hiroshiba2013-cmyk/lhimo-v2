import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const ITALIAN_CITIES = [
  { name: 'Modica', region: 'Sicilia', province: 'RG', bbox: [36.84, 14.74, 36.92, 14.82], population: 54000 },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.92, 14.72, 37.00, 14.80], population: 73000 },
  { name: 'Gela', region: 'Sicilia', province: 'CL', bbox: [37.06, 14.24, 37.14, 14.32], population: 75000 },
  { name: 'Matera', region: 'Basilicata', province: 'MT', bbox: [40.64, 16.58, 40.72, 16.66], population: 60000 },
  { name: 'Grosseto', region: 'Toscana', province: 'GR', bbox: [42.76, 11.10, 42.84, 11.18], population: 82000 },
  { name: 'Mantova', region: 'Lombardia', province: 'MN', bbox: [45.14, 10.78, 45.22, 10.86], population: 49000 },
  { name: 'Vercelli', region: 'Piemonte', province: 'VC', bbox: [45.32, 8.40, 45.40, 8.48], population: 46000 },
  { name: 'Cremona', region: 'Lombardia', province: 'CR', bbox: [45.12, 10.02, 45.20, 10.10], population: 72000 },
  { name: 'Acerra', region: 'Campania', province: 'NA', bbox: [40.94, 14.36, 41.02, 14.44], population: 60000 },
  { name: 'Benevento', region: 'Campania', province: 'BN', bbox: [41.12, 14.76, 41.20, 14.84], population: 60000 },
  { name: 'Legnano', region: 'Lombardia', province: 'MI', bbox: [45.58, 8.90, 45.66, 8.98], population: 60000 },
  { name: 'Trapani', region: 'Sicilia', province: 'TP', bbox: [38.00, 12.50, 38.08, 12.58], population: 68000 },
  { name: 'Viterbo', region: 'Lazio', province: 'VT', bbox: [42.42, 12.10, 42.50, 12.18], population: 67000 },
  { name: 'Imola', region: 'Emilia-Romagna', province: 'BO', bbox: [44.34, 11.70, 44.42, 11.78], population: 70000 },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.28, 16.24, 39.36, 16.32], population: 67000 },
  { name: 'Lamezia Terme', region: 'Calabria', province: 'CZ', bbox: [38.96, 16.30, 39.04, 16.38], population: 70000 },
  { name: 'Pavia', region: 'Lombardia', province: 'PV', bbox: [45.18, 9.14, 45.26, 9.22], population: 73000 },
  { name: 'Carrara', region: 'Toscana', province: 'MS', bbox: [44.04, 10.08, 44.12, 10.16], population: 63000 },
  { name: 'Asti', region: 'Piemonte', province: 'AT', bbox: [44.88, 8.18, 44.96, 8.26], population: 76000 },
  { name: 'Caserta', region: 'Campania', province: 'CE', bbox: [41.06, 14.32, 41.14, 14.40], population: 76000 },
];

const PRIORITY_CATEGORIES = [
  { osm: 'shop=supermarket', db: 'Supermercati' },
  { osm: 'amenity=restaurant', db: 'Ristoranti' },
  { osm: 'amenity=bar', db: 'Bar e Caffè' },
  { osm: 'amenity=cafe', db: 'Bar e Caffè' },
  { osm: 'amenity=pharmacy', db: 'Farmacie' },
  { osm: 'amenity=fuel', db: 'Benzinai' },
  { osm: 'amenity=bank', db: 'Banche' },
  { osm: 'amenity=hospital', db: 'Ospedali' },
  { osm: 'amenity=dentist', db: 'Dentisti' },
  { osm: 'amenity=doctors', db: 'Medici' },
  { osm: 'tourism=hotel', db: 'Hotel' },
  { osm: 'shop=bakery', db: 'Panifici e Pasticcerie' },
  { osm: 'shop=butcher', db: 'Macellerie' },
  { osm: 'shop=greengrocer', db: 'Frutta e Verdura' },
  { osm: 'shop=convenience', db: 'Alimentari' },
];

const categoryCache = new Map();
const stats = {
  totalImported: 0,
  byCity: {},
  byRegion: {},
  errors: 0,
};

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function getCategoryId(categoryName) {
  if (categoryCache.has(categoryName)) {
    return categoryCache.get(categoryName);
  }

  const { data } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  const id = data?.id || null;
  categoryCache.set(categoryName, id);
  return id;
}

async function queryOverpass(bbox, query) {
  const [minLat, minLon, maxLat, maxLon] = bbox;
  const overpassQuery = `
    [out:json][timeout:90];
    (
      node["${query.split('=')[0]}"="${query.split('=')[1]}"](${minLat},${minLon},${maxLat},${maxLon});
      way["${query.split('=')[0]}"="${query.split('=')[1]}"](${minLat},${minLon},${maxLat},${maxLon});
      relation["${query.split('=')[0]}"="${query.split('=')[1]}"](${minLat},${minLon},${maxLat},${maxLon});
    );
    out center;
  `;

  let retries = 0;
  const maxRetries = 3;

  while (retries < maxRetries) {
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `data=${encodeURIComponent(overpassQuery)}`,
      });

      if (response.status === 429) {
        console.log(`   ⏳ Rate limit, attendo 120 secondi...`);
        await sleep(120000);
        continue;
      }

      if (!response.ok) {
        if (response.status === 504) {
          throw new Error('Gateway timeout');
        }
        return [];
      }

      const data = await response.json();
      return data.elements || [];
    } catch (error) {
      retries++;
      if (retries < maxRetries) {
        const waitTime = retries * 30000;
        console.log(`   ⚠️  Errore (${retries}/${maxRetries}): ${error.message}`);
        console.log(`   ⏳ Riprovo tra ${waitTime/1000}s...`);
        await sleep(waitTime);
      } else {
        console.log(`   ⏹️  Saltata dopo ${maxRetries} tentativi`);
        return [];
      }
    }
  }

  return [];
}

function extractData(element, cityData) {
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
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || cityData.name;
  const postcode = tags['addr:postcode'] || '';

  let address = '';
  if (street && houseNumber) {
    address = `${street}, ${houseNumber}`;
  } else if (street) {
    address = street;
  } else {
    address = city;
  }

  return {
    name,
    address,
    city,
    province: cityData.province,
    region: cityData.region,
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
    business_hours: tags.opening_hours || null,
  };
}

async function importCity(cityData, cityIndex, totalCities) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 CITTÀ [${cityIndex}/${totalCities}]: ${cityData.name} (${cityData.region})`);
  console.log('='.repeat(70));

  let cityTotal = 0;

  for (const category of PRIORITY_CATEGORIES) {
    process.stdout.write(`   ${category.db.padEnd(35)} `);

    try {
      const categoryId = await getCategoryId(category.db);
      if (!categoryId) {
        console.log('⚠️  SKIP');
        await sleep(2000);
        continue;
      }

      const elements = await queryOverpass(cityData.bbox, category.osm);

      if (elements.length === 0) {
        console.log('⚪ 0');
        await sleep(10000);
        continue;
      }

      let imported = 0;
      for (const element of elements) {
        const businessData = extractData(element, cityData);
        if (!businessData) continue;

        try {
          const { data: existing } = await supabase
            .from('unclaimed_business_locations')
            .select('id')
            .eq('name', businessData.name)
            .eq('city', businessData.city)
            .eq('address', businessData.address)
            .maybeSingle();

          if (existing) continue;

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
            stats.totalImported++;
            stats.byRegion[cityData.region] = (stats.byRegion[cityData.region] || 0) + 1;
          } else {
            stats.errors++;
          }
        } catch (error) {
          stats.errors++;
        }
      }

      if (imported > 0) {
        console.log(`✅ ${imported}`);
      } else {
        console.log(`⚪ 0`);
      }

      cityTotal += imported;

      await sleep(10000);
    } catch (error) {
      console.log(`❌ SKIP`);
      stats.errors++;
      await sleep(10000);
      continue;
    }
  }

  stats.byCity[cityData.name] = cityTotal;

  console.log(`\n   🎯 TOTALE ${cityData.name}: ${cityTotal} attività`);
  console.log(`   📊 Totale complessivo: ${stats.totalImported.toLocaleString()}\n`);

  return cityTotal;
}

async function main() {
  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' IMPORTAZIONE LENTA E COSTANTE '.padEnd(68) + '║');
  console.log('║' + ' '.repeat(68) + '║');
  console.log('║' + ` Città: ${ITALIAN_CITIES.length}`.padEnd(68) + '║');
  console.log('║' + ` Categorie prioritarie: ${PRIORITY_CATEGORIES.length}`.padEnd(68) + '║');
  console.log('║' + ' Delay lunghi per evitare rate limits'.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  let grandTotal = 0;
  let cityCount = 0;
  const totalCities = ITALIAN_CITIES.length;

  for (const cityData of ITALIAN_CITIES) {
    try {
      cityCount++;
      const count = await importCity(cityData, cityCount, totalCities);
      grandTotal += count;

      console.log(`⏳ Pausa 30 secondi prima della prossima città...\n`);
      await sleep(30000);

    } catch (error) {
      console.error(`\n❌ ERRORE in ${cityData.name}:`, error.message);
      stats.errors++;
      await sleep(30000);
    }
  }

  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' ✅ IMPORTAZIONE COMPLETATA '.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  console.log('STATISTICHE FINALI:');
  console.log(`Città processate: ${cityCount}/${totalCities}`);
  console.log(`Totale attività: ${grandTotal.toLocaleString()}`);
  console.log(`Errori: ${stats.errors}`);
  console.log('');
}

main().catch(console.error);
