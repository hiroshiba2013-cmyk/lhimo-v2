import { createClient } from '@supabase/supabase-js';
import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const LIGURIA_CITIES = [
  { name: 'Genova', province: 'GE', region: 'Liguria' },
  { name: 'La Spezia', province: 'SP', region: 'Liguria' },
  { name: 'Sanremo', province: 'IM', region: 'Liguria' },
  { name: 'Savona', province: 'SV', region: 'Liguria' },
  { name: 'Imperia', province: 'IM', region: 'Liguria' },
  { name: 'Albenga', province: 'SV', region: 'Liguria' },
  { name: 'Rapallo', province: 'GE', region: 'Liguria' },
  { name: 'Chiavari', province: 'GE', region: 'Liguria' },
  { name: 'Ventimiglia', province: 'IM', region: 'Liguria' },
  { name: 'Sestri Levante', province: 'GE', region: 'Liguria' }
];

const OSM_TO_CATEGORY = {
  'amenity:restaurant': 'Ristoranti',
  'amenity:cafe': 'Bar e Caffè',
  'amenity:bar': 'Pub e Locali',
  'amenity:fast_food': 'Fast Food',
  'amenity:pub': 'Pub e Locali',
  'amenity:ice_cream': 'Gelaterie',
  'amenity:pharmacy': 'Farmacie',
  'amenity:dentist': 'Dentisti',
  'amenity:doctors': 'Medici',
  'amenity:hospital': 'Ospedali',
  'amenity:clinic': 'Cliniche',
  'amenity:veterinary': 'Veterinari',
  'amenity:bank': 'Banche',
  'amenity:fuel': 'Benzinai',
  'amenity:car_wash': 'Autolavaggi',
  'amenity:parking': 'Parcheggi',
  'amenity:post_office': 'Poste',
  'amenity:library': 'Biblioteche',
  'amenity:school': 'Scuole',
  'amenity:kindergarten': 'Asili',
  'amenity:gym': 'Palestre',
  'shop:supermarket': 'Supermercati',
  'shop:convenience': 'Alimentari',
  'shop:bakery': 'Panetterie',
  'shop:butcher': 'Macellerie',
  'shop:greengrocer': 'Frutta e Verdura',
  'shop:clothes': 'Abbigliamento',
  'shop:shoes': 'Calzature',
  'shop:florist': 'Fioristi',
  'shop:hairdresser': 'Parrucchieri',
  'shop:beauty': 'Centri Estetici',
  'shop:jewelry': 'Gioiellerie',
  'shop:bookshop': 'Librerie',
  'shop:electronics': 'Elettronica',
  'shop:furniture': 'Arredamento',
  'shop:hardware': 'Ferramenta',
  'shop:car_repair': 'Autofficine',
  'shop:bicycle': 'Biciclette',
  'shop:optician': 'Ottici',
  'shop:mobile_phone': 'Telefonia',
  'shop:gift': 'Articoli da Regalo',
  'shop:sports': 'Articoli Sportivi',
  'shop:toys': 'Giocattoli',
  'shop:stationery': 'Cartolerie',
  'shop:pet': 'Animali',
  'shop:car': 'Concessionarie Auto',
  'tourism:hotel': 'Hotel',
  'tourism:guest_house': 'B&B',
  'tourism:apartment': 'Appartamenti',
  'tourism:hostel': 'Ostelli',
  'office:lawyer': 'Avvocati',
  'office:accountant': 'Commercialisti',
  'office:estate_agent': 'Agenzie Immobiliari',
  'office:architect': 'Architetti',
  'office:notary': 'Notai',
  'office:company': 'Aziende',
  'office:insurance': 'Assicurazioni',
  'craft:electrician': 'Elettricisti',
  'craft:plumber': 'Idraulici',
  'craft:carpenter': 'Falegnami',
  'craft:painter': 'Imbianchini',
  'craft:shoemaker': 'Calzolai',
  'craft:tailor': 'Sarti',
  'craft:locksmith': 'Fabbri',
  'craft:glazier': 'Vetrai',
  'craft:roofer': 'Lattonieri',
  'craft:hvac': 'Climatizzazione',
  'craft:gardener': 'Giardinieri',
  'healthcare:physiotherapist': 'Fisioterapisti',
  'leisure:fitness_centre': 'Palestre',
  'leisure:sports_centre': 'Centri Sportivi'
};

let stats = {
  totalProcessed: 0,
  totalInserted: 0,
  totalSkipped: 0,
  errors: 0,
  byCity: {},
  byCategory: {},
  categoriesFound: new Set()
};

const categoryCache = new Map();

async function getCategoryId(categoryName) {
  if (categoryCache.has(categoryName)) {
    return categoryCache.get(categoryName);
  }

  const { data, error } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  if (error || !data) {
    console.error(`⚠️  Categoria "${categoryName}" non trovata`);
    categoryCache.set(categoryName, null);
    return null;
  }

  categoryCache.set(categoryName, data.id);
  return data.id;
}

async function checkBusinessExists(name, city, street) {
  const { data, error } = await supabase
    .from('unclaimed_business_locations')
    .select('id')
    .eq('name', name)
    .eq('city', city)
    .eq('street', street || '')
    .maybeSingle();

  if (error) return false;
  return !!data;
}

function buildCombinedQuery(cityName) {
  return `
    [out:json][timeout:90];
    area["name"="${cityName}"]["admin_level"="8"]->.city;
    (
      node["amenity"~"restaurant|cafe|bar|fast_food|pub|ice_cream|pharmacy|dentist|doctors|hospital|clinic|veterinary|bank|fuel|car_wash|parking|post_office|library|school|kindergarten|gym"](area.city);
      way["amenity"~"restaurant|cafe|bar|fast_food|pub|ice_cream|pharmacy|dentist|doctors|hospital|clinic|veterinary|bank|fuel|car_wash|parking|post_office|library|school|kindergarten|gym"](area.city);

      node["shop"~"supermarket|convenience|bakery|butcher|greengrocer|clothes|shoes|florist|hairdresser|beauty|jewelry|bookshop|electronics|furniture|hardware|car_repair|bicycle|optician|mobile_phone|gift|sports|toys|stationery|pet|car"](area.city);
      way["shop"~"supermarket|convenience|bakery|butcher|greengrocer|clothes|shoes|florist|hairdresser|beauty|jewelry|bookshop|electronics|furniture|hardware|car_repair|bicycle|optician|mobile_phone|gift|sports|toys|stationery|pet|car"](area.city);

      node["tourism"~"hotel|guest_house|apartment|hostel"](area.city);
      way["tourism"~"hotel|guest_house|apartment|hostel"](area.city);

      node["office"~"lawyer|accountant|estate_agent|architect|notary|company|insurance"](area.city);
      way["office"~"lawyer|accountant|estate_agent|architect|notary|company|insurance"](area.city);

      node["craft"~"electrician|plumber|carpenter|painter|shoemaker|tailor|locksmith|glazier|roofer|hvac|gardener"](area.city);
      way["craft"~"electrician|plumber|carpenter|painter|shoemaker|tailor|locksmith|glazier|roofer|hvac|gardener"](area.city);

      node["healthcare"="physiotherapist"](area.city);
      way["healthcare"="physiotherapist"](area.city);

      node["leisure"~"fitness_centre|sports_centre"](area.city);
      way["leisure"~"fitness_centre|sports_centre"](area.city);
    );
    out center;
  `;
}

async function queryOverpassAPI(query, retries = 3) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      console.log(`   🌐 Query Overpass (tentativo ${attempt}/${retries})...`);

      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        body: query,
        headers: { 'Content-Type': 'text/plain' }
      });

      if (response.status === 429) {
        const waitTime = Math.pow(2, attempt) * 10000;
        console.log(`   ⏳ Rate limit, attendo ${waitTime/1000}s...`);
        await new Promise(resolve => setTimeout(resolve, waitTime));
        continue;
      }

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      console.log(`   ✅ Ricevuti ${data.elements?.length || 0} elementi`);
      return data;

    } catch (error) {
      console.error(`   ❌ Errore tentativo ${attempt}: ${error.message}`);
      if (attempt === retries) throw error;
      await new Promise(resolve => setTimeout(resolve, 5000 * attempt));
    }
  }
}

function detectCategory(element) {
  const tags = element.tags || {};

  for (const [key, value] of Object.entries(tags)) {
    const lookup = `${key}:${value}`;
    if (OSM_TO_CATEGORY[lookup]) {
      return OSM_TO_CATEGORY[lookup];
    }
  }

  return null;
}

function extractBusinessData(element, cityData) {
  const tags = element.tags || {};

  const lat = element.lat || element.center?.lat;
  const lon = element.lon || element.center?.lon;

  if (!lat || !lon) return null;

  const categoryName = detectCategory(element);
  if (!categoryName) return null;

  const name = tags.name || tags.brand || tags.operator;
  if (!name || name === 'Nome non disponibile') return null;

  const street = tags['addr:street'] || tags.street || '';
  const streetNumber = tags['addr:housenumber'] || '';
  const fullStreet = streetNumber ? `${street} ${streetNumber}`.trim() : street;

  return {
    name: name,
    street: fullStreet,
    city: cityData.name,
    province: cityData.province,
    region: cityData.region,
    postal_code: tags['addr:postcode'] || tags.postcode || '',
    latitude: parseFloat(lat),
    longitude: parseFloat(lon),
    phone: tags.phone || tags['contact:phone'] || '',
    email: tags.email || tags['contact:email'] || '',
    website: tags.website || tags['contact:website'] || '',
    business_hours: tags.opening_hours || '',
    _categoryName: categoryName
  };
}

async function importCity(cityData) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`🏙️  CITTÀ: ${cityData.name} (${cityData.province})`);
  console.log(`${'='.repeat(70)}\n`);

  try {
    const query = buildCombinedQuery(cityData.name);
    const data = await queryOverpassAPI(query);

    if (!data.elements || data.elements.length === 0) {
      console.log(`   ℹ️  Nessun dato trovato per ${cityData.name}\n`);
      return 0;
    }

    console.log(`\n   📊 Processamento ${data.elements.length} elementi...`);

    let inserted = 0;
    let skipped = 0;
    const cityCategories = new Set();

    for (const element of data.elements) {
      try {
        const businessData = extractBusinessData(element, cityData);

        if (!businessData) {
          skipped++;
          continue;
        }

        const categoryName = businessData._categoryName;
        delete businessData._categoryName;

        const categoryId = await getCategoryId(categoryName);
        if (!categoryId) {
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
          console.error(`   ⚠️  Errore: ${error.message}`);
          stats.errors++;
        } else {
          inserted++;
          stats.totalInserted++;
          cityCategories.add(categoryName);
          stats.categoriesFound.add(categoryName);
        }

        stats.totalProcessed++;

      } catch (err) {
        console.error(`   ⚠️  Errore elemento: ${err.message}`);
        stats.errors++;
      }
    }

    stats.byCity[cityData.name] = inserted;
    stats.totalSkipped += skipped;

    cityCategories.forEach(cat => {
      if (!stats.byCategory[cat]) stats.byCategory[cat] = 0;
      stats.byCategory[cat]++;
    });

    console.log(`\n   ✅ Inseriti: ${inserted}`);
    console.log(`   ⏭️  Saltati: ${skipped}`);
    console.log(`   📂 Categorie trovate: ${cityCategories.size}`);
    console.log(`   📋 ${Array.from(cityCategories).join(', ')}\n`);

    return inserted;

  } catch (error) {
    console.error(`\n❌ Errore critico per ${cityData.name}: ${error.message}\n`);
    stats.errors++;
    return 0;
  }
}

async function main() {
  console.log('╔══════════════════════════════════════════════════════════════════╗');
  console.log('║      🌊 IMPORTAZIONE LIGURIA OTTIMIZZATA - OSM 🌊               ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝\n');

  console.log(`📍 Città: ${LIGURIA_CITIES.length}`);
  console.log(`📂 Categorie mappate: ${Object.keys(OSM_TO_CATEGORY).length}`);
  console.log(`⚡ Query per città: 1 (invece di 70+)\n`);

  const startTime = Date.now();

  for (let i = 0; i < LIGURIA_CITIES.length; i++) {
    const city = LIGURIA_CITIES[i];
    console.log(`[${i + 1}/${LIGURIA_CITIES.length}] Processando ${city.name}...`);

    await importCity(city);

    if (i < LIGURIA_CITIES.length - 1) {
      console.log('⏳ Pausa 15 secondi...\n');
      await new Promise(resolve => setTimeout(resolve, 15000));
    }
  }

  const endTime = Date.now();
  const duration = ((endTime - startTime) / 1000 / 60).toFixed(2);

  console.log('\n' + '═'.repeat(70));
  console.log('📊 REPORT FINALE');
  console.log('═'.repeat(70) + '\n');

  console.log(`⏱️  Durata: ${duration} minuti`);
  console.log(`📦 Processati: ${stats.totalProcessed}`);
  console.log(`✅ Inseriti: ${stats.totalInserted}`);
  console.log(`⏭️  Saltati: ${stats.totalSkipped}`);
  console.log(`❌ Errori: ${stats.errors}`);
  console.log(`📂 Categorie trovate: ${stats.categoriesFound.size}\n`);

  console.log('🏙️  PER CITTÀ:');
  console.log('─'.repeat(70));
  Object.entries(stats.byCity)
    .sort((a, b) => b[1] - a[1])
    .forEach(([city, count], i) => {
      console.log(`${(i + 1).toString().padStart(3)}. ${city.padEnd(25)} ${count.toString().padStart(6)} attività`);
    });

  console.log('\n📂 PER CATEGORIA (Top 20):');
  console.log('─'.repeat(70));
  Object.entries(stats.byCategory)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 20)
    .forEach(([cat, count], i) => {
      console.log(`${(i + 1).toString().padStart(3)}. ${cat.padEnd(25)} ${count.toString().padStart(6)} attività`);
    });

  console.log('\n📋 TUTTE LE CATEGORIE TROVATE:');
  console.log('─'.repeat(70));
  const sortedCategories = Array.from(stats.categoriesFound).sort();
  sortedCategories.forEach((cat, i) => {
    console.log(`${(i + 1).toString().padStart(3)}. ${cat}`);
  });

  console.log('\n' + '═'.repeat(70));
  console.log('✨ COMPLETATO!');
  console.log('═'.repeat(70) + '\n');
}

main().catch(console.error);
