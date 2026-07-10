import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Principali città italiane per regione con bounding box ridotte
const CITIES = [
  // Valle d'Aosta
  { name: 'Aosta', province: 'AO', region: "Valle d'Aosta", bbox: [45.720, 7.300, 45.760, 7.350] },

  // Piemonte
  { name: 'Torino', province: 'TO', region: 'Piemonte', bbox: [45.000, 7.600, 45.120, 7.750] },
  { name: 'Alessandria', province: 'AL', region: 'Piemonte', bbox: [44.880, 8.580, 44.940, 8.650] },
  { name: 'Asti', province: 'AT', region: 'Piemonte', bbox: [44.880, 8.180, 44.930, 8.250] },
  { name: 'Biella', province: 'BI', region: 'Piemonte', bbox: [45.540, 8.030, 45.580, 8.080] },
  { name: 'Cuneo', province: 'CN', region: 'Piemonte', bbox: [44.360, 7.520, 44.410, 7.580] },
  { name: 'Novara', province: 'NO', region: 'Piemonte', bbox: [45.420, 8.590, 45.470, 8.650] },
  { name: 'Verbania', province: 'VB', region: 'Piemonte', bbox: [45.900, 8.520, 45.950, 8.580] },
  { name: 'Vercelli', province: 'VC', region: 'Piemonte', bbox: [45.300, 8.390, 45.350, 8.450] },

  // Lombardia
  { name: 'Milano', province: 'MI', region: 'Lombardia', bbox: [45.400, 9.100, 45.530, 9.280] },
  { name: 'Bergamo', province: 'BG', region: 'Lombardia', bbox: [45.660, 9.630, 45.720, 9.710] },
  { name: 'Brescia', province: 'BS', region: 'Lombardia', bbox: [45.510, 10.180, 45.570, 10.260] },
  { name: 'Como', province: 'CO', region: 'Lombardia', bbox: [45.790, 9.050, 45.840, 9.110] },
  { name: 'Cremona', province: 'CR', region: 'Lombardia', bbox: [45.110, 9.970, 45.160, 10.050] },
  { name: 'Lecco', province: 'LC', region: 'Lombardia', bbox: [45.830, 9.370, 45.870, 9.430] },
  { name: 'Lodi', province: 'LO', region: 'Lombardia', bbox: [45.300, 9.480, 45.340, 9.540] },
  { name: 'Mantova', province: 'MN', region: 'Lombardia', bbox: [45.130, 10.760, 45.180, 10.830] },
  { name: 'Pavia', province: 'PV', region: 'Lombardia', bbox: [45.170, 9.130, 45.220, 9.190] },
  { name: 'Sondrio', province: 'SO', region: 'Lombardia', bbox: [46.150, 9.850, 46.190, 9.910] },
  { name: 'Varese', province: 'VA', region: 'Lombardia', bbox: [45.800, 8.800, 45.850, 8.860] },
  { name: 'Monza', province: 'MB', region: 'Lombardia', bbox: [45.570, 9.250, 45.610, 9.310] },

  // Trentino-Alto Adige
  { name: 'Trento', province: 'TN', region: 'Trentino-Alto Adige', bbox: [46.040, 11.100, 46.090, 11.160] },
  { name: 'Bolzano', province: 'BZ', region: 'Trentino-Alto Adige', bbox: [46.470, 11.320, 46.520, 11.380] },

  // Veneto
  { name: 'Venezia', province: 'VE', region: 'Veneto', bbox: [45.400, 12.280, 45.470, 12.380] },
  { name: 'Verona', province: 'VR', region: 'Veneto', bbox: [45.410, 10.960, 45.470, 11.040] },
  { name: 'Padova', province: 'PD', region: 'Veneto', bbox: [45.380, 11.850, 45.430, 11.920] },
  { name: 'Vicenza', province: 'VI', region: 'Veneto', bbox: [45.530, 11.520, 45.580, 11.580] },
  { name: 'Treviso', province: 'TV', region: 'Veneto', bbox: [45.640, 12.220, 45.690, 12.280] },
  { name: 'Rovigo', province: 'RO', region: 'Veneto', bbox: [45.050, 11.770, 45.090, 11.830] },
  { name: 'Belluno', province: 'BL', region: 'Veneto', bbox: [46.120, 12.190, 46.170, 12.250] },

  // Friuli-Venezia Giulia
  { name: 'Trieste', province: 'TS', region: 'Friuli-Venezia Giulia', bbox: [45.620, 13.740, 45.680, 13.820] },
  { name: 'Udine', province: 'UD', region: 'Friuli-Venezia Giulia', bbox: [46.040, 13.210, 46.090, 13.270] },
  { name: 'Pordenone', province: 'PN', region: 'Friuli-Venezia Giulia', bbox: [45.940, 12.630, 45.990, 12.690] },
  { name: 'Gorizia', province: 'GO', region: 'Friuli-Venezia Giulia', bbox: [45.920, 13.590, 45.960, 13.650] },

  // Liguria
  { name: 'Genova', province: 'GE', region: 'Liguria', bbox: [44.380, 8.880, 44.450, 8.990] },
  { name: 'Savona', province: 'SV', region: 'Liguria', bbox: [44.280, 8.450, 44.320, 8.510] },
  { name: 'Imperia', province: 'IM', region: 'Liguria', bbox: [43.860, 8.000, 43.910, 8.060] },
  { name: 'La Spezia', province: 'SP', region: 'Liguria', bbox: [44.090, 9.800, 44.140, 9.870] },

  // Emilia-Romagna
  { name: 'Bologna', province: 'BO', region: 'Emilia-Romagna', bbox: [44.460, 11.290, 44.530, 11.380] },
  { name: 'Modena', province: 'MO', region: 'Emilia-Romagna', bbox: [44.620, 10.900, 44.670, 10.970] },
  { name: 'Parma', province: 'PR', region: 'Emilia-Romagna', bbox: [44.770, 10.310, 44.820, 10.380] },
  { name: 'Reggio Emilia', province: 'RE', region: 'Emilia-Romagna', bbox: [44.670, 10.600, 44.720, 10.660] },
  { name: 'Piacenza', province: 'PC', region: 'Emilia-Romagna', bbox: [45.030, 9.670, 45.080, 9.730] },
  { name: 'Ferrara', province: 'FE', region: 'Emilia-Romagna', bbox: [44.810, 11.590, 44.860, 11.660] },
  { name: 'Ravenna', province: 'RA', region: 'Emilia-Romagna', bbox: [44.390, 12.170, 44.440, 12.240] },
  { name: 'Forlì', province: 'FC', region: 'Emilia-Romagna', bbox: [44.200, 12.020, 44.250, 12.080] },
  { name: 'Cesena', province: 'FC', region: 'Emilia-Romagna', bbox: [44.120, 12.220, 44.170, 12.280] },
  { name: 'Rimini', province: 'RN', region: 'Emilia-Romagna', bbox: [44.040, 12.540, 44.090, 12.610] },

  // Toscana
  { name: 'Firenze', province: 'FI', region: 'Toscana', bbox: [43.730, 11.210, 43.810, 11.310] },
  { name: 'Pisa', province: 'PI', region: 'Toscana', bbox: [43.690, 10.370, 43.740, 10.430] },
  { name: 'Livorno', province: 'LI', region: 'Toscana', bbox: [43.510, 10.280, 43.570, 10.350] },
  { name: 'Lucca', province: 'LU', region: 'Toscana', bbox: [43.820, 10.470, 43.870, 10.530] },
  { name: 'Pistoia', province: 'PT', region: 'Toscana', bbox: [43.910, 10.880, 43.960, 10.940] },
  { name: 'Prato', province: 'PO', region: 'Toscana', bbox: [43.860, 11.070, 43.910, 11.130] },
  { name: 'Arezzo', province: 'AR', region: 'Toscana', bbox: [43.440, 11.850, 43.490, 11.910] },
  { name: 'Siena', province: 'SI', region: 'Toscana', bbox: [43.300, 11.300, 43.350, 11.360] },
  { name: 'Grosseto', province: 'GR', region: 'Toscana', bbox: [42.730, 11.080, 42.780, 11.140] },
  { name: 'Massa', province: 'MS', region: 'Toscana', bbox: [44.010, 10.110, 44.060, 10.170] },

  // Marche
  { name: 'Ancona', province: 'AN', region: 'Marche', bbox: [43.580, 13.480, 43.640, 13.550] },
  { name: 'Pesaro', province: 'PU', region: 'Marche', bbox: [43.890, 12.880, 43.940, 12.940] },
  { name: 'Macerata', province: 'MC', region: 'Marche', bbox: [43.280, 13.430, 43.330, 13.490] },
  { name: 'Ascoli Piceno', province: 'AP', region: 'Marche', bbox: [42.840, 13.560, 42.890, 13.620] },
  { name: 'Fermo', province: 'FM', region: 'Marche', bbox: [43.140, 13.690, 43.190, 13.750] },

  // Umbria
  { name: 'Perugia', province: 'PG', region: 'Umbria', bbox: [43.090, 12.360, 43.140, 12.420] },
  { name: 'Terni', province: 'TR', region: 'Umbria', bbox: [42.540, 12.620, 42.590, 12.680] },

  // Lazio
  { name: 'Roma', province: 'RM', region: 'Lazio', bbox: [41.800, 12.400, 41.970, 12.600] },
  { name: 'Latina', province: 'LT', region: 'Lazio', bbox: [41.440, 12.880, 41.490, 12.940] },
  { name: 'Frosinone', province: 'FR', region: 'Lazio', bbox: [41.620, 13.320, 41.670, 13.380] },
  { name: 'Viterbo', province: 'VT', region: 'Lazio', bbox: [42.400, 12.090, 42.450, 12.150] },
  { name: 'Rieti', province: 'RI', region: 'Lazio', bbox: [42.380, 12.840, 42.430, 12.910] },

  // Abruzzo
  { name: "L'Aquila", province: 'AQ', region: 'Abruzzo', bbox: [42.320, 13.370, 42.370, 13.430] },
  { name: 'Teramo', province: 'TE', region: 'Abruzzo', bbox: [42.640, 13.680, 42.690, 13.740] },
  { name: 'Pescara', province: 'PE', region: 'Abruzzo', bbox: [42.430, 14.180, 42.480, 14.250] },
  { name: 'Chieti', province: 'CH', region: 'Abruzzo', bbox: [42.330, 14.140, 42.380, 14.210] },

  // Molise
  { name: 'Campobasso', province: 'CB', region: 'Molise', bbox: [41.530, 14.640, 41.580, 14.700] },
  { name: 'Isernia', province: 'IS', region: 'Molise', bbox: [41.570, 14.210, 41.620, 14.270] },

  // Campania
  { name: 'Napoli', province: 'NA', region: 'Campania', bbox: [40.800, 14.200, 40.900, 14.300] },
  { name: 'Salerno', province: 'SA', region: 'Campania', bbox: [40.650, 14.730, 40.700, 14.800] },
  { name: 'Caserta', province: 'CE', region: 'Campania', bbox: [41.050, 14.310, 41.100, 14.370] },
  { name: 'Avellino', province: 'AV', region: 'Campania', bbox: [40.890, 14.760, 40.940, 14.820] },
  { name: 'Benevento', province: 'BN', region: 'Campania', bbox: [41.110, 14.750, 41.160, 14.810] },

  // Puglia
  { name: 'Bari', province: 'BA', region: 'Puglia', bbox: [41.080, 16.830, 41.150, 16.910] },
  { name: 'Lecce', province: 'LE', region: 'Puglia', bbox: [40.330, 18.140, 40.380, 18.200] },
  { name: 'Taranto', province: 'TA', region: 'Puglia', bbox: [40.430, 17.200, 40.490, 17.270] },
  { name: 'Foggia', province: 'FG', region: 'Puglia', bbox: [41.440, 15.520, 41.490, 15.580] },
  { name: 'Brindisi', province: 'BR', region: 'Puglia', bbox: [40.610, 17.920, 40.660, 17.980] },
  { name: 'Andria', province: 'BT', region: 'Puglia', bbox: [41.200, 16.270, 41.250, 16.330] },

  // Basilicata
  { name: 'Potenza', province: 'PZ', region: 'Basilicata', bbox: [40.610, 15.770, 40.660, 15.830] },
  { name: 'Matera', province: 'MT', region: 'Basilicata', bbox: [40.630, 16.570, 40.680, 16.630] },

  // Calabria
  { name: 'Catanzaro', province: 'CZ', region: 'Calabria', bbox: [38.870, 16.570, 38.920, 16.630] },
  { name: 'Reggio Calabria', province: 'RC', region: 'Calabria', bbox: [38.080, 15.620, 38.140, 15.690] },
  { name: 'Cosenza', province: 'CS', region: 'Calabria', bbox: [39.270, 16.230, 39.330, 16.290] },
  { name: 'Crotone', province: 'KR', region: 'Calabria', bbox: [39.050, 17.100, 39.100, 17.160] },
  { name: 'Vibo Valentia', province: 'VV', region: 'Calabria', bbox: [38.650, 16.070, 38.700, 16.130] },

  // Sicilia
  { name: 'Palermo', province: 'PA', region: 'Sicilia', bbox: [38.080, 13.330, 38.160, 13.410] },
  { name: 'Catania', province: 'CT', region: 'Sicilia', bbox: [37.470, 15.050, 37.540, 15.130] },
  { name: 'Messina', province: 'ME', region: 'Sicilia', bbox: [38.160, 15.520, 38.220, 15.590] },
  { name: 'Siracusa', province: 'SR', region: 'Sicilia', bbox: [37.040, 15.260, 37.090, 15.320] },
  { name: 'Ragusa', province: 'RG', region: 'Sicilia', bbox: [36.900, 14.700, 36.950, 14.760] },
  { name: 'Trapani', province: 'TP', region: 'Sicilia', bbox: [38.000, 12.480, 38.050, 12.540] },
  { name: 'Agrigento', province: 'AG', region: 'Sicilia', bbox: [37.280, 13.560, 37.330, 13.620] },
  { name: 'Caltanissetta', province: 'CL', region: 'Sicilia', bbox: [37.460, 14.030, 37.510, 14.090] },
  { name: 'Enna', province: 'EN', region: 'Sicilia', bbox: [37.540, 14.260, 37.590, 14.320] },

  // Sardegna
  { name: 'Cagliari', province: 'CA', region: 'Sardegna', bbox: [39.180, 9.080, 39.240, 9.150] },
  { name: 'Sassari', province: 'SS', region: 'Sardegna', bbox: [40.700, 8.540, 40.750, 8.600] },
  { name: 'Nuoro', province: 'NU', region: 'Sardegna', bbox: [40.300, 9.310, 40.350, 9.370] },
  { name: 'Oristano', province: 'OR', region: 'Sardegna', bbox: [39.880, 8.570, 39.930, 8.630] },
];

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
  { osm: 'shop=furniture', db: 'Negozi di Arredamento' },
  { osm: 'shop=electronics', db: 'Negozi di Elettronica' },
  { osm: 'shop=mobile_phone', db: 'Negozi di Telefonia' },
  { osm: 'shop=bicycle', db: 'Negozi di Biciclette' },
  { osm: 'shop=sports', db: 'Negozi Sportivi' },
  { osm: 'shop=optician', db: 'Ottici' },
  { osm: 'shop=shoes', db: 'Calzature' },
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
  { osm: 'amenity=post_office', db: 'Uffici Postali' },
  { osm: 'office=lawyer', db: 'Avvocati' },
  { osm: 'office=accountant', db: 'Commercialisti' },
  { osm: 'office=architect', db: 'Architetti' },
  { osm: 'office=estate_agent', db: 'Agenzie Immobiliari' },
  { osm: 'office=insurance', db: 'Assicurazioni' },
  { osm: 'tourism=hotel', db: 'Hotel' },
  { osm: 'tourism=guest_house', db: "Bed & Breakfast" },
  { osm: 'leisure=fitness_centre', db: 'Palestre' },
  { osm: 'craft=electrician', db: 'Elettricisti' },
  { osm: 'craft=plumber', db: 'Idraulici' },
  { osm: 'craft=carpenter', db: 'Falegnami' },
  { osm: 'craft=painter', db: 'Imbianchini' },
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
    [out:json][timeout:30];
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
  const address = [street, houseNumber].filter(Boolean).join(' ') || 'Indirizzo non disponibile';

  return {
    name,
    address,
    city: cityName,
    province: city.province,
    region: city.region,
    postcode,
    latitude: lat,
    longitude: lon,
    phone: tags.phone || tags['contact:phone'] || '',
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
    opening_hours: tags.opening_hours || '',
  };
}

async function importCity(city) {
  console.log(`\n📍 ${city.name} (${city.province}) - ${city.region}`);

  let total = 0;
  const summary = {};

  for (const category of CATEGORIES) {
    const categoryId = await getCategoryId(category.db);
    if (!categoryId) {
      await sleep(500);
      continue;
    }

    const elements = await queryOverpass(city.bbox, category.osm);

    if (elements.length === 0) {
      await sleep(1000);
      continue;
    }

    let imported = 0;
    for (const element of elements) {
      const data = extractData(element, city);
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
            business_hours: data.opening_hours || null,
            is_primary: true
          });

        imported++;
      } catch (error) {
        // Skip errors
      }
    }

    if (imported > 0) {
      summary[category.db] = imported;
      total += imported;
    }

    await sleep(1500);
  }

  if (total > 0) {
    console.log(`   ✅ ${total} attività importate`);
    const top3 = Object.entries(summary)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 3)
      .map(([cat, count]) => `${cat} (${count})`)
      .join(', ');
    if (top3) console.log(`   Top 3: ${top3}`);
  } else {
    console.log(`   ⚠️  Nessuna nuova attività`);
  }

  return total;
}

async function main() {
  console.log('\n╔══════════════════════════════════════════════════════════════════╗');
  console.log('║  IMPORTAZIONE RAPIDA DA OPENSTREETMAP - CITTÀ PER CITTÀ         ║');
  console.log('║  Query più piccole = risposte più veloci                        ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝\n');

  let grandTotal = 0;
  let cityCount = 0;
  const regionStats = {};

  for (const city of CITIES) {
    try {
      const count = await importCity(city);
      grandTotal += count;
      cityCount++;

      if (!regionStats[city.region]) {
        regionStats[city.region] = { cities: 0, businesses: 0 };
      }
      regionStats[city.region].cities++;
      regionStats[city.region].businesses += count;

      await sleep(2000);
    } catch (error) {
      console.error(`   ❌ Errore in ${city.name}:`, error.message);
      await sleep(3000);
    }
  }

  console.log('\n╔══════════════════════════════════════════════════════════════════╗');
  console.log('║                    IMPORTAZIONE COMPLETATA                       ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝\n');
  console.log(`Città processate: ${cityCount}/${CITIES.length}`);
  console.log(`Totale attività importate: ${grandTotal}\n`);

  console.log('📊 Riepilogo per regione:');
  Object.entries(regionStats)
    .sort(([,a], [,b]) => b.businesses - a.businesses)
    .forEach(([region, stats]) => {
      console.log(`   ${region}: ${stats.businesses} attività in ${stats.cities} città`);
    });
  console.log('');
}

main().catch(console.error);
