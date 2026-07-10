import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function queryOverpass(query) {
  const overpassUrl = 'https://overpass-api.de/api/interpreter';

  try {
    console.log('Interrogando Overpass API...');
    const response = await fetch(overpassUrl, {
      method: 'POST',
      body: query,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    });

    if (!response.ok) {
      throw new Error(`Overpass API error: ${response.status}`);
    }

    const data = await response.json();
    console.log(`Ricevuti ${data.elements?.length || 0} elementi da Overpass`);
    return data.elements || [];
  } catch (error) {
    console.error('Errore interrogazione Overpass:', error);
    return [];
  }
}

function buildVareseFuelQuery() {
  return `
    [out:json][timeout:180];
    area["name"="Varese"]["admin_level"="6"]->.searchArea;
    (
      node["amenity"="fuel"](area.searchArea);
      way["amenity"="fuel"](area.searchArea);
      relation["amenity"="fuel"](area.searchArea);
    );
    out center tags;
  `;
}

function extractFuelStationData(element) {
  const tags = element.tags || {};

  const lat = element.lat || element.center?.lat;
  const lon = element.lon || element.center?.lon;

  if (!lat || !lon) {
    console.log('  Elemento senza coordinate, saltato');
    return null;
  }

  const name = tags.name || tags['name:it'] || tags.operator || tags.brand || 'Distributore Carburante';

  const street = tags['addr:street'] || '';
  const houseNumber = tags['addr:housenumber'] || '';
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || 'Varese';
  const postcode = tags['addr:postcode'] || '';
  const province = tags['addr:province'] || 'VA';

  const address = `${street} ${houseNumber}`.trim();

  const phone = (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '');
  const website = tags.website || tags['contact:website'] || tags['brand:website'] || '';
  const email = tags.email || tags['contact:email'] || '';

  const openingHours = tags.opening_hours || '';

  const fuelTypes = [];
  if (tags['fuel:diesel'] === 'yes') fuelTypes.push('Diesel');
  if (tags['fuel:octane_95'] === 'yes' || tags['fuel:petrol'] === 'yes') fuelTypes.push('Benzina');
  if (tags['fuel:lpg'] === 'yes') fuelTypes.push('GPL');
  if (tags['fuel:cng'] === 'yes' || tags['fuel:methane'] === 'yes') fuelTypes.push('Metano');
  if (tags['fuel:e85'] === 'yes') fuelTypes.push('E85');
  if (tags['fuel:electric'] === 'yes') fuelTypes.push('Elettrico');

  const services = [];
  if (tags.shop === 'convenience' || tags.amenity === 'shop') services.push('Negozio');
  if (tags['service:vehicle:washing'] === 'yes' || tags.car_wash === 'yes') services.push('Autolavaggio');
  if (tags.restaurant === 'yes' || tags.cafe === 'yes') services.push('Bar/Ristorante');
  if (tags.atm === 'yes') services.push('Bancomat');

  let description = `Distributore di carburante a ${city}`;
  if (fuelTypes.length > 0) {
    description += `. Carburanti disponibili: ${fuelTypes.join(', ')}`;
  }
  if (services.length > 0) {
    description += `. Servizi: ${services.join(', ')}`;
  }

  const operator = tags.operator || tags.brand || '';
  if (operator && !name.includes(operator)) {
    description = `${operator} - ${description}`;
  }

  return {
    name,
    description,
    address: address || 'Indirizzo da verificare',
    city,
    province,
    region: 'Lombardia',
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone,
    website,
    email,
    opening_hours: openingHours,
    fuel_types: fuelTypes.join(', '),
    services: services.join(', '),
    brand: tags.brand || tags.operator || '',
    osm_id: `${element.type}/${element.id}`,
    verified: true,
    is_claimed: false
  };
}

async function getCategoryId(categoryName) {
  const { data } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  return data?.id || null;
}

async function importFuelStations() {
  console.log('\n=== IMPORTAZIONE DISTRIBUTORI DI CARBURANTE - PROVINCIA DI VARESE ===\n');

  const query = buildVareseFuelQuery();
  const elements = await queryOverpass(query);

  if (elements.length === 0) {
    console.log('Nessun distributore trovato.');
    return;
  }

  console.log(`\nTrovati ${elements.length} distributori di carburante`);
  console.log('Elaborazione dati...\n');

  const fuelStations = [];
  for (const element of elements) {
    const stationData = extractFuelStationData(element);
    if (stationData) {
      fuelStations.push(stationData);
    }
  }

  console.log(`Distributori validi estratti: ${fuelStations.length}\n`);

  const categoryId = await getCategoryId('Distributori di Carburante');
  if (!categoryId) {
    console.error('Categoria "Distributori di Carburante" non trovata nel database!');
    return;
  }

  console.log('Inserimento nel database...\n');

  const cityStats = {};
  let imported = 0;
  let skipped = 0;
  let errors = 0;

  for (const station of fuelStations) {
    try {
      const { data: existing } = await supabase
        .from('businesses')
        .select('id, name')
        .eq('name', station.name)
        .maybeSingle();

      if (existing) {
        const { data: existingLocation } = await supabase
          .from('business_locations')
          .select('id')
          .eq('business_id', existing.id)
          .eq('city', station.city)
          .maybeSingle();

        if (existingLocation) {
          console.log(`  ⏭️  Già presente: ${station.name} (${station.city})`);
          skipped++;
          continue;
        }
      }

      const { data: newBusiness, error: businessError } = await supabase
        .from('businesses')
        .insert({
          name: station.name,
          description: station.description,
          category_id: categoryId,
          verified: station.verified,
          is_claimed: station.is_claimed
        })
        .select()
        .single();

      if (businessError) {
        console.error(`  ❌ Errore business ${station.name}:`, businessError.message);
        errors++;
        continue;
      }

      const { error: locationError } = await supabase
        .from('business_locations')
        .insert({
          business_id: newBusiness.id,
          address: station.address,
          city: station.city,
          province: station.province,
          region: station.region,
          postal_code: station.postal_code,
          country: 'Italia',
          latitude: station.latitude,
          longitude: station.longitude,
          phone: station.phone,
          website: station.website,
          email: station.email,
          business_hours: station.opening_hours || null
        });

      if (locationError) {
        console.error(`  ❌ Errore location per ${station.name}:`, locationError.message);
        await supabase.from('businesses').delete().eq('id', newBusiness.id);
        errors++;
        continue;
      }

      console.log(`  ✅ ${station.name} - ${station.city}`);
      if (station.brand) console.log(`     Brand: ${station.brand}`);
      if (station.fuel_types) console.log(`     Carburanti: ${station.fuel_types}`);
      if (station.services) console.log(`     Servizi: ${station.services}`);

      cityStats[station.city] = (cityStats[station.city] || 0) + 1;
      imported++;

    } catch (error) {
      console.error(`  ❌ Errore per ${station.name}:`, error.message);
      errors++;
    }
  }

  console.log('\n=== RIEPILOGO IMPORTAZIONE ===');
  console.log(`Totale trovati: ${fuelStations.length}`);
  console.log(`✅ Importati: ${imported}`);
  console.log(`⏭️  Già presenti: ${skipped}`);
  console.log(`❌ Errori: ${errors}`);

  console.log('\n=== DISTRIBUZIONE PER CITTÀ ===');
  const sortedCities = Object.entries(cityStats).sort((a, b) => b[1] - a[1]);
  for (const [city, count] of sortedCities) {
    console.log(`${city}: ${count} distributori`);
  }
}

importFuelStations()
  .then(() => {
    console.log('\n✅ Importazione completata!');
    process.exit(0);
  })
  .catch(error => {
    console.error('\n❌ Errore durante importazione:', error);
    process.exit(1);
  });
