import { createClient } from '@supabase/supabase-js';
import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Città della Liguria con più di 20.000 abitanti
const LIGURIA_CITIES = [
  { name: 'Genova', province: 'GE', region: 'Liguria', area: '240 km²' },
  { name: 'La Spezia', province: 'SP', region: 'Liguria', area: '51 km²' },
  { name: 'Sanremo', province: 'IM', region: 'Liguria', area: '55 km²' },
  { name: 'Savona', province: 'SV', region: 'Liguria', area: '65 km²' },
  { name: 'Imperia', province: 'IM', region: 'Liguria', area: '45 km²' },
  { name: 'Albenga', province: 'SV', region: 'Liguria', area: '36 km²' },
  { name: 'Rapallo', province: 'GE', region: 'Liguria', area: '33 km²' },
  { name: 'Chiavari', province: 'GE', region: 'Liguria', area: '30 km²' },
  { name: 'Ventimiglia', province: 'IM', region: 'Liguria', area: '54 km²' },
  { name: 'Sestri Levante', province: 'GE', region: 'Liguria', area: '35 km²' }
];

// Mappatura completa OSM tag -> categoria database
const OSM_CATEGORY_MAPPING = {
  // Ristorazione
  'amenity=restaurant': 'Ristoranti',
  'amenity=cafe': 'Bar e Caffè',
  'amenity=bar': 'Pub e Locali',
  'amenity=fast_food': 'Fast Food',
  'amenity=pub': 'Pub e Locali',
  'amenity=ice_cream': 'Gelaterie',
  'amenity=biergarten': 'Pub e Locali',

  // Negozi
  'shop=supermarket': 'Supermercati',
  'shop=convenience': 'Alimentari',
  'shop=bakery': 'Panetterie',
  'shop=butcher': 'Macellerie',
  'shop=greengrocer': 'Frutta e Verdura',
  'shop=clothes': 'Abbigliamento',
  'shop=shoes': 'Calzature',
  'shop=florist': 'Fioristi',
  'shop=hairdresser': 'Parrucchieri',
  'shop=beauty': 'Centri Estetici',
  'shop=jewelry': 'Gioiellerie',
  'shop=bookshop': 'Librerie',
  'shop=electronics': 'Elettronica',
  'shop=furniture': 'Arredamento',
  'shop=hardware': 'Ferramenta',
  'shop=car_repair': 'Autofficine',
  'shop=bicycle': 'Biciclette',
  'shop=optician': 'Ottici',
  'shop=mobile_phone': 'Telefonia',
  'shop=gift': 'Articoli da Regalo',
  'shop=sports': 'Articoli Sportivi',
  'shop=toys': 'Giocattoli',
  'shop=stationery': 'Cartolerie',
  'shop=pet': 'Animali',
  'shop=car': 'Concessionarie Auto',

  // Servizi sanitari
  'amenity=pharmacy': 'Farmacie',
  'amenity=dentist': 'Dentisti',
  'amenity=doctors': 'Medici',
  'amenity=hospital': 'Ospedali',
  'amenity=clinic': 'Cliniche',
  'amenity=veterinary': 'Veterinari',
  'healthcare=physiotherapist': 'Fisioterapisti',

  // Alloggi
  'tourism=hotel': 'Hotel',
  'tourism=guest_house': 'B&B',
  'tourism=apartment': 'Appartamenti',
  'tourism=hostel': 'Ostelli',

  // Servizi finanziari
  'amenity=bank': 'Banche',
  'amenity=atm': 'Bancomat',
  'office=insurance': 'Assicurazioni',
  'office=financial': 'Servizi Finanziari',

  // Servizi professionali
  'office=lawyer': 'Avvocati',
  'office=accountant': 'Commercialisti',
  'office=estate_agent': 'Agenzie Immobiliari',
  'office=architect': 'Architetti',
  'office=notary': 'Notai',
  'office=company': 'Aziende',
  'office=consulting': 'Consulenti',

  // Artigiani e professionisti
  'craft=electrician': 'Elettricisti',
  'craft=plumber': 'Idraulici',
  'craft=carpenter': 'Falegnami',
  'craft=painter': 'Imbianchini',
  'craft=shoemaker': 'Calzolai',
  'craft=tailor': 'Sarti',
  'craft=locksmith': 'Fabbri',
  'craft=glazier': 'Vetrai',
  'craft=roofer': 'Lattonieri',
  'craft=hvac': 'Climatizzazione',
  'craft=gardener': 'Giardinieri',

  // Servizi auto
  'amenity=fuel': 'Benzinai',
  'amenity=charging_station': 'Colonnine Elettriche',
  'amenity=car_wash': 'Autolavaggi',
  'amenity=parking': 'Parcheggi',

  // Altri servizi
  'amenity=post_office': 'Poste',
  'amenity=library': 'Biblioteche',
  'amenity=school': 'Scuole',
  'amenity=kindergarten': 'Asili',
  'amenity=gym': 'Palestre',
  'leisure=fitness_centre': 'Palestre',
  'leisure=sports_centre': 'Centri Sportivi'
};

let stats = {
  totalProcessed: 0,
  totalInserted: 0,
  totalSkipped: 0,
  errors: 0,
  byCity: {},
  byCategory: {}
};

async function getCategoryId(categoryName) {
  const { data, error } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  if (error) {
    console.error(`Errore nel recuperare categoria ${categoryName}:`, error.message);
    return null;
  }

  return data?.id || null;
}

async function checkBusinessExists(name, city, street) {
  const { data, error } = await supabase
    .from('unclaimed_business_locations')
    .select('id')
    .eq('name', name)
    .eq('city', city)
    .eq('street', street || '')
    .maybeSingle();

  if (error) {
    console.error('Errore controllo duplicato:', error.message);
    return false;
  }

  return !!data;
}

function buildOverpassQuery(cityName, osmTag) {
  // Query per area città
  return `
    [out:json][timeout:60];
    area["name"="${cityName}"]["admin_level"="8"]->.city;
    (
      node["${osmTag.split('=')[0]}"="${osmTag.split('=')[1]}"](area.city);
      way["${osmTag.split('=')[0]}"="${osmTag.split('=')[1]}"](area.city);
      relation["${osmTag.split('=')[0]}"="${osmTag.split('=')[1]}"](area.city);
    );
    out center;
  `;
}

async function queryOverpassAPI(query, retries = 3) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        body: query,
        headers: { 'Content-Type': 'text/plain' }
      });

      if (response.status === 429) {
        const waitTime = Math.pow(2, attempt) * 10000;
        console.log(`⏳ Rate limit, attendo ${waitTime/1000}s...`);
        await new Promise(resolve => setTimeout(resolve, waitTime));
        continue;
      }

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      if (attempt === retries) {
        throw error;
      }
      await new Promise(resolve => setTimeout(resolve, 5000 * attempt));
    }
  }
}

function extractBusinessData(element, cityData, categoryName) {
  const tags = element.tags || {};

  const lat = element.lat || element.center?.lat;
  const lon = element.lon || element.center?.lon;

  if (!lat || !lon) return null;

  const name = tags.name || tags.brand || tags.operator || 'Nome non disponibile';

  return {
    name: name,
    street: tags['addr:street'] || tags.street || '',
    street_number: tags['addr:housenumber'] || '',
    city: cityData.name,
    province: cityData.province,
    region: cityData.region,
    postal_code: tags['addr:postcode'] || tags.postcode || '',
    latitude: parseFloat(lat),
    longitude: parseFloat(lon),
    phone: tags.phone || tags['contact:phone'] || '',
    email: tags.email || tags['contact:email'] || '',
    website: tags.website || tags['contact:website'] || '',
    category_name: categoryName,
    business_hours: tags.opening_hours || '',
    osm_id: element.id?.toString() || null,
    osm_type: element.type || null
  };
}

async function importCategoryForCity(cityData, osmTag, categoryName) {
  try {
    const categoryId = await getCategoryId(categoryName);
    if (!categoryId) {
      console.log(`❌ Categoria "${categoryName}" non trovata nel database`);
      return 0;
    }

    const query = buildOverpassQuery(cityData.name, osmTag);
    console.log(`🔍 Interrogo ${categoryName} a ${cityData.name}...`);

    await new Promise(resolve => setTimeout(resolve, 2000)); // Rate limiting

    const data = await queryOverpassAPI(query);

    if (!data.elements || data.elements.length === 0) {
      console.log(`   ℹ️  Nessun risultato per ${categoryName}`);
      return 0;
    }

    console.log(`   📦 Trovati ${data.elements.length} elementi per ${categoryName}`);

    let inserted = 0;
    let skipped = 0;

    for (const element of data.elements) {
      try {
        const businessData = extractBusinessData(element, cityData, categoryName);

        if (!businessData) {
          skipped++;
          continue;
        }

        const exists = await checkBusinessExists(
          businessData.name,
          businessData.city,
          businessData.street
        );

        if (exists) {
          skipped++;
          continue;
        }

        const { error } = await supabase
          .from('unclaimed_business_locations')
          .insert({
            ...businessData,
            category_id: categoryId
          });

        if (error) {
          console.error(`   ⚠️  Errore inserimento: ${error.message}`);
          stats.errors++;
        } else {
          inserted++;
          stats.totalInserted++;
        }

        stats.totalProcessed++;

      } catch (err) {
        console.error(`   ⚠️  Errore elemento: ${err.message}`);
        stats.errors++;
      }
    }

    console.log(`   ✅ Inseriti: ${inserted}, Saltati: ${skipped}`);

    // Aggiorna statistiche
    if (!stats.byCity[cityData.name]) {
      stats.byCity[cityData.name] = 0;
    }
    stats.byCity[cityData.name] += inserted;

    if (!stats.byCategory[categoryName]) {
      stats.byCategory[categoryName] = 0;
    }
    stats.byCategory[categoryName] += inserted;

    stats.totalSkipped += skipped;

    return inserted;

  } catch (error) {
    console.error(`❌ Errore categoria ${categoryName} a ${cityData.name}:`, error.message);
    stats.errors++;
    return 0;
  }
}

async function importCity(cityData) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`🏙️  CITTÀ: ${cityData.name} (${cityData.province}) - ${cityData.region}`);
  console.log(`${'='.repeat(70)}\n`);

  let cityTotal = 0;

  for (const [osmTag, categoryName] of Object.entries(OSM_CATEGORY_MAPPING)) {
    const count = await importCategoryForCity(cityData, osmTag, categoryName);
    cityTotal += count;
  }

  console.log(`\n✨ Totale ${cityData.name}: ${cityTotal} attività importate\n`);

  return cityTotal;
}

async function main() {
  console.log('╔══════════════════════════════════════════════════════════════════╗');
  console.log('║    🌊 IMPORTAZIONE COMPLETA LIGURIA DA OPENSTREETMAP 🌊         ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝\n');

  console.log(`📍 Città da importare: ${LIGURIA_CITIES.length}`);
  console.log(`📂 Categorie totali: ${Object.keys(OSM_CATEGORY_MAPPING).length}\n`);

  const startTime = Date.now();

  for (let i = 0; i < LIGURIA_CITIES.length; i++) {
    const city = LIGURIA_CITIES[i];
    console.log(`\n[${i + 1}/${LIGURIA_CITIES.length}] Processando ${city.name}...`);

    try {
      await importCity(city);
    } catch (error) {
      console.error(`❌ Errore critico per ${city.name}:`, error.message);
      stats.errors++;
    }

    // Pausa tra città per evitare rate limiting
    if (i < LIGURIA_CITIES.length - 1) {
      console.log('\n⏳ Pausa 10 secondi prima della prossima città...');
      await new Promise(resolve => setTimeout(resolve, 10000));
    }
  }

  const endTime = Date.now();
  const duration = ((endTime - startTime) / 1000 / 60).toFixed(2);

  console.log('\n' + '═'.repeat(70));
  console.log('📊 REPORT FINALE IMPORTAZIONE LIGURIA');
  console.log('═'.repeat(70) + '\n');

  console.log(`⏱️  Durata totale: ${duration} minuti`);
  console.log(`📦 Elementi processati: ${stats.totalProcessed}`);
  console.log(`✅ Attività inserite: ${stats.totalInserted}`);
  console.log(`⏭️  Attività saltate (duplicati): ${stats.totalSkipped}`);
  console.log(`❌ Errori: ${stats.errors}\n`);

  console.log('🏙️  ATTIVITÀ PER CITTÀ:');
  console.log('─'.repeat(70));
  Object.entries(stats.byCity)
    .sort((a, b) => b[1] - a[1])
    .forEach(([city, count], index) => {
      console.log(`${(index + 1).toString().padStart(3)}. ${city.padEnd(30)} ${count.toString().padStart(5)} attività`);
    });

  console.log('\n📂 ATTIVITÀ PER CATEGORIA (Top 20):');
  console.log('─'.repeat(70));
  Object.entries(stats.byCategory)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 20)
    .forEach(([category, count], index) => {
      console.log(`${(index + 1).toString().padStart(3)}. ${category.padEnd(30)} ${count.toString().padStart(5)} attività`);
    });

  console.log('\n' + '═'.repeat(70));
  console.log('✨ IMPORTAZIONE COMPLETATA!');
  console.log('═'.repeat(70) + '\n');
}

main().catch(console.error);
