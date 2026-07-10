import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import fetch from 'node-fetch';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const REGIONS = [
  { name: 'Valle d\'Aosta', bbox: [45.4, 6.7, 46.0, 8.0] },
  { name: 'Piemonte', bbox: [44.0, 6.5, 46.5, 9.0] },
  { name: 'Lombardia', bbox: [44.5, 8.5, 46.5, 11.5] },
  { name: 'Trentino-Alto Adige', bbox: [45.5, 10.3, 47.1, 12.5] },
  { name: 'Veneto', bbox: [44.8, 10.5, 46.7, 13.0] },
  { name: 'Friuli-Venezia Giulia', bbox: [45.5, 12.3, 46.7, 13.9] },
  { name: 'Liguria', bbox: [43.7, 7.4, 44.8, 10.0] },
  { name: 'Emilia-Romagna', bbox: [43.7, 9.2, 45.1, 12.8] },
  { name: 'Toscana', bbox: [42.2, 9.7, 44.5, 12.4] },
  { name: 'Umbria', bbox: [42.3, 11.9, 43.6, 13.3] },
  { name: 'Marche', bbox: [42.7, 12.2, 44.0, 13.9] },
  { name: 'Lazio', bbox: [40.8, 11.4, 42.8, 13.8] },
  { name: 'Abruzzo', bbox: [41.7, 13.0, 42.9, 14.8] },
  { name: 'Molise', bbox: [41.4, 14.0, 42.0, 15.2] },
  { name: 'Campania', bbox: [39.9, 13.6, 41.5, 16.0] },
  { name: 'Puglia', bbox: [39.8, 14.9, 42.2, 18.5] },
  { name: 'Basilicata', bbox: [39.9, 15.4, 41.0, 17.0] },
  { name: 'Calabria', bbox: [37.9, 15.6, 40.2, 17.2] },
  { name: 'Sicilia', bbox: [36.6, 12.3, 38.3, 15.7] },
  { name: 'Sardegna', bbox: [38.8, 8.1, 41.3, 9.9] }
];

const CATEGORIES = [
  { name: 'Ristoranti', queries: ['amenity=restaurant', 'amenity=fast_food'] },
  { name: 'Bar e Caffè', queries: ['amenity=bar', 'amenity=cafe', 'amenity=pub'] },
  { name: 'Hotel', queries: ['tourism=hotel', 'tourism=motel', 'tourism=guest_house'] },
  { name: 'B&B', queries: ['tourism=bed_and_breakfast'] },
  { name: 'Alimentari', queries: ['shop=convenience', 'shop=general', 'shop=grocery'] },
  { name: 'Supermercati', queries: ['shop=supermarket'] },
  { name: 'Panifici e Pasticcerie', queries: ['shop=bakery', 'shop=pastry'] },
  { name: 'Macellerie', queries: ['shop=butcher'] },
  { name: 'Farmacie', queries: ['amenity=pharmacy'] },
  { name: 'Parrucchieri e Barbieri', queries: ['shop=hairdresser', 'shop=barber'] },
  { name: 'Benzinai', queries: ['amenity=fuel'] },
  { name: 'Banche', queries: ['amenity=bank'] },
  { name: 'Palestre', queries: ['leisure=fitness_centre', 'leisure=sports_centre'] },
  { name: 'Abbigliamento', queries: ['shop=clothes'] },
  { name: 'Ferramenta', queries: ['shop=hardware', 'shop=doityourself'] },
  { name: 'Fioristi', queries: ['shop=florist'] },
  { name: 'Autofficine', queries: ['shop=car_repair', 'craft=car_repair'] },
  { name: 'Avvocati', queries: ['office=lawyer'] },
  { name: 'Commercialisti', queries: ['office=accountant'] },
  { name: 'Notai', queries: ['office=notary'] },
  { name: 'Architetti', queries: ['office=architect'] },
];

const categoryCache = new Map();
const stats = {
  totalRegions: 0,
  totalBusinesses: 0,
  inserted: 0,
  skipped: 0,
  errors: 0,
  byRegion: {},
  byCategory: {},
};

async function getCategoryId(name) {
  if (categoryCache.has(name)) return categoryCache.get(name);

  const { data } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', name)
    .maybeSingle();

  if (data) {
    categoryCache.set(name, data.id);
    return data.id;
  }
  return null;
}

async function queryOverpass(category, query, bbox) {
  const overpassQuery = `
    [out:json][timeout:90];
    (
      node[${query}](${bbox[0]},${bbox[1]},${bbox[2]},${bbox[3]});
      way[${query}](${bbox[0]},${bbox[1]},${bbox[2]},${bbox[3]});
    );
    out center;
  `;

  try {
    const response = await fetch('https://overpass-api.de/api/interpreter', {
      method: 'POST',
      body: overpassQuery,
      headers: { 'Content-Type': 'text/plain' }
    });

    if (!response.ok) {
      return [];
    }

    const data = await response.json();
    return data.elements || [];
  } catch (error) {
    return [];
  }
}

function extractBusinessData(element, category, region) {
  const tags = element.tags || {};

  const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
  if (!name) return null;

  let lat, lon;
  if (element.type === 'node') {
    lat = element.lat;
    lon = element.lon;
  } else if (element.center) {
    lat = element.center.lat;
    lon = element.center.lon;
  }

  if (!lat || !lon) return null;

  const street = tags['addr:street'] || '';
  const houseNumber = tags['addr:housenumber'] || '';
  const address = street && houseNumber ? `${street}, ${houseNumber}` : street;

  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || '';
  if (!city) return null;

  const province = tags['addr:province'] || tags['addr:county'] || '';
  const postcode = tags['addr:postcode'] || '';
  const phone = (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '');
  const email = tags.email || tags['contact:email'] || '';
  const website = tags.website || tags['contact:website'] || '';
  const opening_hours = tags.opening_hours || '';

  return {
    name,
    category,
    description: `${category} a ${city}`,
    street: address,
    city,
    province,
    region,
    postal_code: postcode,
    phone,
    email,
    website,
    business_hours: opening_hours,
    latitude: lat,
    longitude: lon,
  };
}

async function insertBusiness(data) {
  try {
    const categoryId = await getCategoryId(data.category);
    if (!categoryId) {
      stats.skipped++;
      return false;
    }

    const { data: existing } = await supabase
      .from('unclaimed_business_locations')
      .select('id')
      .eq('name', data.name)
      .eq('city', data.city)
      .maybeSingle();

    if (existing) {
      stats.skipped++;
      return false;
    }

    const { error } = await supabase
      .from('unclaimed_business_locations')
      .insert({
        name: data.name,
        category_id: categoryId,
        description: data.description,
        street: data.street,
        city: data.city,
        province: data.province,
        region: data.region,
        postal_code: data.postal_code,
        phone: data.phone,
        email: data.email,
        website: data.website,
        business_hours: data.business_hours,
        latitude: data.latitude,
        longitude: data.longitude,
      });

    if (!error) {
      stats.inserted++;
      stats.byCategory[data.category] = (stats.byCategory[data.category] || 0) + 1;
      stats.byRegion[data.region] = (stats.byRegion[data.region] || 0) + 1;
      return true;
    } else {
      stats.errors++;
      return false;
    }
  } catch (error) {
    stats.errors++;
    return false;
  }
}

async function processRegion(region) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 ${region.name.toUpperCase()}`);
  console.log(`${'='.repeat(70)}\n`);

  let regionTotal = 0;

  for (const catInfo of CATEGORIES) {
    console.log(`   🔍 ${catInfo.name}...`);

    const allElements = [];
    for (const query of catInfo.queries) {
      const elements = await queryOverpass(catInfo.name, query, region.bbox);
      allElements.push(...elements);
      await new Promise(resolve => setTimeout(resolve, 1000));
    }

    if (allElements.length === 0) {
      console.log(`      - Nessun risultato`);
      continue;
    }

    const businesses = allElements
      .map(el => extractBusinessData(el, catInfo.name, region.name))
      .filter(b => b !== null);

    const uniqueBusinesses = Array.from(
      new Map(businesses.map(b => [`${b.name}-${b.latitude.toFixed(5)}-${b.longitude.toFixed(5)}`, b])).values()
    );

    console.log(`      Trovati: ${uniqueBusinesses.length}`);

    for (const business of uniqueBusinesses) {
      await insertBusiness(business);
      stats.totalBusinesses++;
      regionTotal++;
    }
  }

  console.log(`\n   ✅ Regione completata: ${regionTotal} attività trovate`);
  stats.totalRegions++;
}

async function main() {
  console.log('\n╔════════════════════════════════════════════════════════════════════════╗');
  console.log('║         IMPORTAZIONE COMPLETA ITALIA DA OPENSTREETMAP                 ║');
  console.log('║                     (Overpass API)                                     ║');
  console.log('╚════════════════════════════════════════════════════════════════════════╝\n');

  console.log(`📋 Regioni: ${REGIONS.length}`);
  console.log(`📂 Categorie: ${CATEGORIES.length}\n`);
  console.log(`⏱️  Tempo stimato: 2-4 ore\n`);

  const startTime = Date.now();

  for (const region of REGIONS) {
    await processRegion(region);
    await new Promise(resolve => setTimeout(resolve, 3000));
  }

  const duration = ((Date.now() - startTime) / 1000 / 60).toFixed(1);

  console.log('\n\n╔════════════════════════════════════════════════════════════════════════╗');
  console.log('║                    ✅ IMPORTAZIONE COMPLETATA                          ║');
  console.log('╚════════════════════════════════════════════════════════════════════════╝\n');

  console.log(`⏱️  Tempo totale: ${duration} minuti\n`);
  console.log('📊 RIEPILOGO:\n');
  console.log(`   Regioni processate:  ${stats.totalRegions}/${REGIONS.length}`);
  console.log(`   Totale trovate:      ${stats.totalBusinesses.toLocaleString()}`);
  console.log(`   ✅ Inserite:         ${stats.inserted.toLocaleString()}`);
  console.log(`   ⏭️  Saltate:          ${stats.skipped.toLocaleString()}`);
  console.log(`   ❌ Errori:           ${stats.errors.toLocaleString()}\n`);

  if (Object.keys(stats.byRegion).length > 0) {
    console.log('🗺️  PER REGIONE:\n');
    Object.entries(stats.byRegion)
      .sort(([,a], [,b]) => b - a)
      .forEach(([region, count]) => {
        console.log(`   ${region.padEnd(25)} ${count.toLocaleString().padStart(8)}`);
      });
    console.log('');
  }

  if (Object.keys(stats.byCategory).length > 0) {
    console.log('🏷️  PER CATEGORIA:\n');
    Object.entries(stats.byCategory)
      .sort(([,a], [,b]) => b - a)
      .forEach(([category, count]) => {
        console.log(`   ${category.padEnd(30)} ${count.toLocaleString().padStart(8)}`);
      });
    console.log('');
  }
}

main().catch(console.error);
