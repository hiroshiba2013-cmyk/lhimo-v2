import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

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
  { osm: 'tourism=guest_house', db: 'B&B' },
  { osm: 'leisure=fitness_centre', db: 'Palestre' },
  { osm: 'amenity=car_wash', db: 'Autolavaggi' },
];

const CITIES = [
  { name: 'Varese', province: 'VA', region: 'Lombardia', bbox: [45.780, 8.780, 45.860, 8.880] },
  { name: 'Milano', province: 'MI', region: 'Lombardia', bbox: [45.400, 9.100, 45.530, 9.280] },
  { name: 'Roma', province: 'RM', region: 'Lazio', bbox: [41.800, 12.400, 41.970, 12.600] },
  { name: 'Napoli', province: 'NA', region: 'Campania', bbox: [40.800, 14.200, 40.900, 14.300] },
  { name: 'Torino', province: 'TO', region: 'Piemonte', bbox: [45.000, 7.600, 45.120, 7.750] },
  { name: 'Palermo', province: 'PA', region: 'Sicilia', bbox: [38.080, 13.330, 38.160, 13.410] },
  { name: 'Genova', province: 'GE', region: 'Liguria', bbox: [44.380, 8.880, 44.450, 8.990] },
  { name: 'Bologna', province: 'BO', region: 'Emilia-Romagna', bbox: [44.460, 11.290, 44.530, 11.380] },
  { name: 'Firenze', province: 'FI', region: 'Toscana', bbox: [43.730, 11.210, 43.810, 11.310] },
  { name: 'Bari', province: 'BA', region: 'Puglia', bbox: [41.080, 16.830, 41.150, 16.910] },
  { name: 'Catania', province: 'CT', region: 'Sicilia', bbox: [37.470, 15.050, 37.540, 15.130] },
  { name: 'Venezia', province: 'VE', region: 'Veneto', bbox: [45.400, 12.280, 45.470, 12.380] },
  { name: 'Verona', province: 'VR', region: 'Veneto', bbox: [45.410, 10.960, 45.470, 11.040] },
  { name: 'Messina', province: 'ME', region: 'Sicilia', bbox: [38.160, 15.520, 38.220, 15.590] },
  { name: 'Padova', province: 'PD', region: 'Veneto', bbox: [45.380, 11.850, 45.430, 11.920] },
  { name: 'Trieste', province: 'TS', region: 'Friuli-Venezia Giulia', bbox: [45.620, 13.740, 45.680, 13.820] },
  { name: 'Brescia', province: 'BS', region: 'Lombardia', bbox: [45.510, 10.180, 45.570, 10.260] },
  { name: 'Parma', province: 'PR', region: 'Emilia-Romagna', bbox: [44.770, 10.310, 44.820, 10.380] },
  { name: 'Modena', province: 'MO', region: 'Emilia-Romagna', bbox: [44.620, 10.900, 44.670, 10.970] },
  { name: 'Reggio Calabria', province: 'RC', region: 'Calabria', bbox: [38.080, 15.620, 38.140, 15.690] },
  { name: 'Perugia', province: 'PG', region: 'Umbria', bbox: [43.090, 12.360, 43.140, 12.420] },
  { name: 'Livorno', province: 'LI', region: 'Toscana', bbox: [43.510, 10.280, 43.570, 10.350] },
  { name: 'Cagliari', province: 'CA', region: 'Sardegna', bbox: [39.180, 9.080, 39.240, 9.150] },
  { name: 'Foggia', province: 'FG', region: 'Puglia', bbox: [41.440, 15.520, 41.490, 15.580] },
  { name: 'Salerno', province: 'SA', region: 'Campania', bbox: [40.650, 14.730, 40.700, 14.800] },
  { name: 'Ravenna', province: 'RA', region: 'Emilia-Romagna', bbox: [44.390, 12.170, 44.440, 12.240] },
  { name: 'Ferrara', province: 'FE', region: 'Emilia-Romagna', bbox: [44.810, 11.590, 44.860, 11.660] },
  { name: 'Rimini', province: 'RN', region: 'Emilia-Romagna', bbox: [44.040, 12.540, 44.090, 12.610] },
  { name: 'Bergamo', province: 'BG', region: 'Lombardia', bbox: [45.660, 9.630, 45.720, 9.710] },
  { name: 'Como', province: 'CO', region: 'Lombardia', bbox: [45.790, 9.050, 45.840, 9.110] },
  { name: 'Lecce', province: 'LE', region: 'Puglia', bbox: [40.330, 18.140, 40.380, 18.200] },
  { name: 'Siracusa', province: 'SR', region: 'Sicilia', bbox: [37.040, 15.260, 37.090, 15.320] },
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
    [out:json][timeout:25];
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

    if (!response.ok) {
      if (response.status === 429) {
        console.log('   ⚠️  Rate limit, attendo 60 secondi...');
        await sleep(60000);
        return queryOverpass(bbox, osmTag);
      }
      return [];
    }
    const data = await response.json();
    return data.elements || [];
  } catch (error) {
    console.log(`   ⚠️  Errore: ${error.message}`);
    return [];
  }
}

function extractData(element, city) {
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
  const cityName = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || city.name;
  const postcode = tags['addr:postcode'] || '';

  let address;
  if (street && houseNumber) {
    address = `${street}, ${houseNumber}`;
  } else if (street) {
    address = street;
  } else {
    address = cityName;
  }

  return {
    name,
    address,
    city: cityName,
    province: city.province,
    postcode,
    latitude: lat,
    longitude: lon,
    phone: tags.phone || tags['contact:phone'] || null,
    website: tags.website || tags['contact:website'] || null,
    email: tags.email || tags['contact:email'] || null,
    opening_hours: tags.opening_hours || null,
    vat_number: tags['ref:vat'] || null,
  };
}

async function importCity(city) {
  console.log(`\n🏙️  ${city.name} (${city.province}) - ${city.region}`);

  let total = 0;
  const categoryStats = {};

  for (const category of CATEGORIES) {
    const categoryId = await getCategoryId(category.db);
    if (!categoryId) {
      continue;
    }

    const elements = await queryOverpass(city.bbox, category.osm);

    if (elements.length === 0) {
      await sleep(800);
      continue;
    }

    let imported = 0;
    let skipped = 0;

    for (const element of elements) {
      const data = extractData(element, city);
      if (!data) continue;

      try {
        const { data: existing } = await supabase
          .from('business_locations')
          .select('id')
          .eq('city', data.city)
          .ilike('street', `%${data.address.substring(0, 20)}%`)
          .maybeSingle();

        if (existing) {
          skipped++;
          continue;
        }

        const { data: newBiz, error: bizError } = await supabase
          .from('businesses')
          .insert({
            name: data.name,
            category_id: categoryId,
            description: '',
            address: data.address,
            city: data.city,
            phone: data.phone || '',
            email: data.email || '',
            website: data.website || '',
            verified: true,
            is_claimed: false,
            owner_id: null
          })
          .select('id')
          .maybeSingle();

        if (bizError || !newBiz) continue;

        const { error: locError } = await supabase
          .from('business_locations')
          .insert({
            business_id: newBiz.id,
            location_name: 'Sede principale',
            street: data.address,
            city: data.city,
            province: data.province,
            postal_code: data.postcode,
            phone: data.phone,
            email: data.email,
            business_hours: data.opening_hours,
            vat_number: data.vat_number,
          });

        if (!locError) {
          imported++;
        }
      } catch (error) {
        continue;
      }
    }

    if (imported > 0) {
      categoryStats[category.db] = imported;
      total += imported;
    }

    await sleep(1200);
  }

  if (total > 0) {
    console.log(`   ✅ ${total} nuove attività`);
    const top3 = Object.entries(categoryStats)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 3)
      .map(([cat, count]) => `${cat}(${count})`)
      .join(', ');
    if (top3) console.log(`   📊 Top 3: ${top3}`);
  } else {
    console.log(`   ⚪ Nessuna nuova attività`);
  }

  return total;
}

async function main() {
  console.log('\n╔══════════════════════════════════════════════════════════════╗');
  console.log('║      IMPORTAZIONE OTTIMIZZATA DA OPENSTREETMAP              ║');
  console.log('║      Query piccole città per città = Veloce e Affidabile   ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  console.log(`📍 ${CITIES.length} città da processare`);
  console.log(`🏷️  ${CATEGORIES.length} categorie per città`);
  console.log(`⏱️  Tempo stimato: ${Math.ceil(CITIES.length * 2)} minuti\n`);

  let grandTotal = 0;
  let processedCities = 0;
  const regionStats = {};

  for (const city of CITIES) {
    try {
      const count = await importCity(city);
      grandTotal += count;
      processedCities++;

      if (!regionStats[city.region]) {
        regionStats[city.region] = { cities: 0, businesses: 0 };
      }
      regionStats[city.region].cities++;
      regionStats[city.region].businesses += count;

      await sleep(2000);
    } catch (error) {
      console.error(`   ❌ Errore: ${error.message}`);
      await sleep(3000);
    }
  }

  console.log('\n╔══════════════════════════════════════════════════════════════╗');
  console.log('║                 ✅ IMPORTAZIONE COMPLETATA                   ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');
  console.log(`📊 Città processate: ${processedCities}/${CITIES.length}`);
  console.log(`🏢 Totale attività importate: ${grandTotal}\n`);

  console.log('📍 Riepilogo per regione:\n');
  Object.entries(regionStats)
    .sort(([,a], [,b]) => b.businesses - a.businesses)
    .forEach(([region, stats]) => {
      console.log(`   ${region}: ${stats.businesses} attività in ${stats.cities} città`);
    });
  console.log('');
}

main().catch(console.error);
