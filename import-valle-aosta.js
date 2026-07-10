import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import fs from 'fs';
import https from 'https';
import parseOSM from 'osm-pbf-parser';
import through2 from 'through2';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// URL specifico per Valle d'Aosta (molto più piccolo!)
const GEOFABRIK_URL = 'https://download.geofabrik.de/europe/italy/nord-ovest-latest.osm.pbf';
const PBF_FILE = './valle-aosta.osm.pbf';

// Mappatura completa di tutte le categorie commerciali e professionali
const CATEGORY_MAPPING = {
  // Ristorazione
  'restaurant': 'Ristoranti',
  'cafe': 'Bar e Caffè',
  'bar': 'Bar e Caffè',
  'fast_food': 'Fast Food',
  'pub': 'Pub e Locali',
  'ice_cream': 'Gelaterie',
  'bakery': 'Panifici e Pasticcerie',
  'pizza': 'Pizzerie',

  // Negozi alimentari
  'supermarket': 'Supermercati',
  'convenience': 'Alimentari',
  'butcher': 'Macellerie',
  'greengrocer': 'Alimentari',
  'beverages': 'Alimentari',
  'wine': 'Alimentari',
  'cheese': 'Alimentari',
  'seafood': 'Alimentari',
  'pastry': 'Panifici e Pasticcerie',
  'deli': 'Alimentari',
  'dairy': 'Alimentari',

  // Negozi abbigliamento e moda
  'clothes': 'Abbigliamento',
  'shoes': 'Abbigliamento',
  'jewelry': 'Gioiellerie',
  'boutique': 'Abbigliamento',
  'fashion': 'Abbigliamento',
  'tailor': 'Abbigliamento',
  'bag': 'Abbigliamento',
  'fabric': 'Abbigliamento',
  'leather': 'Abbigliamento',
  'watches': 'Gioiellerie',

  // Salute e bellezza
  'hairdresser': 'Parrucchieri e Barbieri',
  'beauty': 'Centri Estetici',
  'pharmacy': 'Farmacie',
  'dentist': 'Dentisti',
  'doctors': 'Medici',
  'veterinary': 'Veterinari',
  'optician': 'Medici',
  'hearing_aids': 'Medici',
  'medical_supply': 'Farmacie',
  'cosmetics': 'Centri Estetici',
  'perfumery': 'Centri Estetici',
  'massage': 'Centri Estetici',

  // Servizi professionali
  'lawyer': 'Avvocati',
  'accountant': 'Commercialisti',
  'architect': 'Architetti',
  'engineer': 'Architetti',
  'surveyor': 'Architetti',
  'notary': 'Notai',
  'estate_agent': 'Agenzie Immobiliari',
  'insurance': 'Assicurazioni',
  'financial': 'Commercialisti',
  'tax_advisor': 'Commercialisti',
  'consulting': 'Commercialisti',

  // Artigiani e mestieri
  'plumber': 'Idraulici',
  'electrician': 'Elettricisti',
  'carpenter': 'Falegnami',
  'painter': 'Imbianchini',
  'mason': 'Imprese Edili',
  'builder': 'Imprese Edili',
  'roofer': 'Imprese Edili',
  'glaziery': 'Serramenti',
  'window_construction': 'Serramenti',
  'metal_construction': 'Serramenti',
  'locksmith': 'Ferramenta',
  'shoemaker': 'Abbigliamento',
  'upholsterer': 'Arredamento',
  'cabinet_maker': 'Falegnami',
  'tiler': 'Imprese Edili',
  'flooring': 'Imprese Edili',
  'scaffolder': 'Imprese Edili',
  'stonemason': 'Imprese Edili',
  'gardener': 'Climatizzazione',
  'hvac': 'Climatizzazione',
  'pottery': 'Arredamento',
  'photographer': 'Centri Estetici',
  'watchmaker': 'Gioiellerie',
  'jeweller': 'Gioiellerie',

  // Auto e veicoli
  'car_repair': 'Autofficine',
  'car': 'Autofficine',
  'car_wash': 'Autolavaggi',
  'fuel': 'Benzinai',
  'bicycle': 'Autofficine',
  'motorcycle': 'Autofficine',
  'tyres': 'Autofficine',
  'car_parts': 'Autofficine',

  // Negozi vari
  'florist': 'Fioristi',
  'bookshop': 'Librerie',
  'electronics': 'Elettricisti',
  'furniture': 'Arredamento',
  'hardware': 'Ferramenta',
  'computer': 'Elettricisti',
  'mobile_phone': 'Elettricisti',
  'kiosk': 'Alimentari',
  'pet': 'Veterinari',
  'toys': 'Abbigliamento',
  'sports': 'Palestre',
  'gift': 'Fioristi',
  'mall': 'Supermercati',
  'department_store': 'Supermercati',
  'doityourself': 'Ferramenta',
  'garden_centre': 'Fioristi',
  'paint': 'Ferramenta',
  'trade': 'Ferramenta',
  'bathroom_furnishing': 'Arredamento',
  'kitchen': 'Arredamento',
  'curtain': 'Arredamento',
  'floor_covering': 'Arredamento',
  'interior_decoration': 'Arredamento',
  'lighting': 'Arredamento',
  'carpet': 'Arredamento',

  // Servizi
  'bank': 'Banche',
  'post_office': 'Banche',
  'hotel': 'Hotel',
  'guest_house': 'B&B',
  'gym': 'Palestre',
  'fitness_centre': 'Palestre',
  'travel_agency': 'Agenzie Immobiliari',
  'laundry': 'Autolavaggi',
  'dry_cleaning': 'Autolavaggi',
  'real_estate': 'Agenzie Immobiliari',
  'employment_agency': 'Agenzie Immobiliari',
  'advertising_agency': 'Commercialisti',
  'graphic_design': 'Commercialisti',
  'it': 'Elettricisti',
  'printer': 'Commercialisti',
  'copyshop': 'Commercialisti',
  'translation': 'Commercialisti',
};

const categoryCache = {};
const stats = {
  total: 0,
  inserted: 0,
  skipped: 0,
  errors: 0,
  byCategory: {},
  byCity: {},
};

async function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    if (fs.existsSync(dest)) {
      const stats = fs.statSync(dest);
      if (stats.size > 100000) {
        console.log(`\n✓ File già scaricato: ${dest} (${(stats.size / 1024 / 1024).toFixed(1)} MB)`);
        return resolve();
      } else {
        fs.unlinkSync(dest);
      }
    }

    console.log(`\n📥 Download da Geofabrik...`);
    console.log(`URL: ${url}`);
    console.log(`Destinazione: ${dest}\n`);

    const file = fs.createWriteStream(dest);
    let downloadedBytes = 0;
    let totalBytes = 0;
    let lastLog = Date.now();

    const doDownload = (downloadUrl) => {
      https.get(downloadUrl, (response) => {
        if (response.statusCode === 302 || response.statusCode === 301) {
          file.close();
          fs.unlinkSync(dest);
          console.log(`↪️  Seguendo redirect...`);
          return doDownload(response.headers.location);
        }

        totalBytes = parseInt(response.headers['content-length'], 10);
        console.log(`📦 Dimensione file: ${(totalBytes / 1024 / 1024).toFixed(1)} MB\n`);

        response.on('data', (chunk) => {
          downloadedBytes += chunk.length;
          const now = Date.now();

          if (now - lastLog > 2000) {
            const percent = ((downloadedBytes / totalBytes) * 100).toFixed(1);
            const mb = (downloadedBytes / 1024 / 1024).toFixed(1);
            const totalMb = (totalBytes / 1024 / 1024).toFixed(1);
            process.stdout.write(`\r📥 Download: ${percent}% (${mb}/${totalMb} MB)`);
            lastLog = now;
          }
        });

        response.pipe(file);

        file.on('finish', () => {
          file.close();
          console.log(`\n✅ Download completato!\n`);
          resolve();
        });
      }).on('error', (err) => {
        if (fs.existsSync(dest)) {
          fs.unlinkSync(dest);
        }
        reject(err);
      });
    };

    doDownload(url);
  });
}

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

function extractCategory(tags) {
  // Priorità: shop > craft > amenity > office > tourism > leisure
  if (tags.craft && CATEGORY_MAPPING[tags.craft]) {
    return CATEGORY_MAPPING[tags.craft];
  }
  if (tags.shop && CATEGORY_MAPPING[tags.shop]) {
    return CATEGORY_MAPPING[tags.shop];
  }
  if (tags.amenity && CATEGORY_MAPPING[tags.amenity]) {
    return CATEGORY_MAPPING[tags.amenity];
  }
  if (tags.office && CATEGORY_MAPPING[tags.office]) {
    return CATEGORY_MAPPING[tags.office];
  }
  if (tags.tourism && CATEGORY_MAPPING[tags.tourism]) {
    return CATEGORY_MAPPING[tags.tourism];
  }
  if (tags.leisure && CATEGORY_MAPPING[tags.leisure]) {
    return CATEGORY_MAPPING[tags.leisure];
  }
  return null;
}

function isRelevantPOI(tags) {
  return tags.name && (
    tags.shop ||
    tags.amenity ||
    tags.craft ||
    tags.office ||
    tags.tourism ||
    tags.leisure
  );
}

function isInValleDaosta(tags) {
  // Filtra solo attività della Valle d'Aosta
  const province = (tags['addr:province'] || tags['is_in:province'] || '').toUpperCase();
  const city = (tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || '').toLowerCase();

  // Controlla provincia AO o città della Valle d'Aosta
  if (province === 'AO' || province === 'AOSTA') return true;

  // Lista città principali Valle d'Aosta
  const valleDaostaCity = [
    'aosta', 'aoste', 'courmayeur', 'cogne', 'saint-vincent',
    'châtillon', 'verrès', 'pont-saint-martin', 'gressoney',
    'cervinia', 'breuil-cervinia', 'valtournenche', 'antey-saint-andré',
    'la thuile', 'morgex', 'pré-saint-didier', 'arvier',
    'villeneuve', 'sarre', 'saint-pierre', 'nus',
    'fénis', 'chambave', 'saint-denis', 'torgnon',
    'la magdeleine', 'chamois', 'valpelline', 'ollomont',
    'bionaz', 'oyace', 'doues', 'gignod', 'roisan',
    'quart', 'saint-christophe', 'pollein', 'charvensod',
    'jovençan', 'montjovet', 'issogne', 'arnad',
    'donnas', 'bard', 'hône', 'champorcher',
    'pontboset', 'lillianes', 'fontainemore', 'issime',
    'gressoney-saint-jean', 'gressoney-la-trinité', 'gaby', 'ayas',
    'brusson', 'challand-saint-victor', 'challand-saint-anselme',
    'saint-marcel', 'brissogne', 'emarèse', 'verrayes',
    'diémoz', 'saint-vincent', 'montjovet'
  ];

  return valleDaostaCity.some(c => city.includes(c));
}

async function insertBusiness(data) {
  try {
    const categoryId = await getCategoryId(data.category);
    if (!categoryId) {
      stats.skipped++;
      return;
    }

    // Controlla duplicati
    const { data: existing } = await supabase
      .from('unclaimed_business_locations')
      .select('id')
      .eq('city', data.city)
      .eq('street', data.address)
      .eq('name', data.name)
      .maybeSingle();

    if (existing) {
      stats.skipped++;
      return;
    }

    const { error } = await supabase
      .from('unclaimed_business_locations')
      .insert({
        name: data.name,
        category_id: categoryId,
        description: data.description,
        street: data.address,
        city: data.city,
        province: 'AO',
        region: 'Valle d\'Aosta',
        postal_code: data.postcode,
        phone: data.phone,
        email: data.email,
        website: data.website,
        business_hours: data.opening_hours,
        latitude: data.latitude,
        longitude: data.longitude,
      });

    if (!error) {
      stats.inserted++;
      stats.byCategory[data.category] = (stats.byCategory[data.category] || 0) + 1;
      stats.byCity[data.city] = (stats.byCity[data.city] || 0) + 1;
    } else {
      stats.errors++;
      if (stats.errors < 5) {
        console.log(`\n⚠️  Errore inserimento: ${error.message}`);
      }
    }
  } catch (error) {
    stats.errors++;
  }
}

async function processPBF() {
  console.log(`📖 Lettura e processamento file PBF...\n`);

  const businesses = [];
  let processedNodes = 0;
  let lastLog = Date.now();

  return new Promise((resolve, reject) => {
    const parser = parseOSM();

    fs.createReadStream(PBF_FILE)
      .pipe(parser)
      .pipe(through2.obj(async (items, enc, next) => {
        for (const item of items) {
          if (item.type === 'node') {
            processedNodes++;

            const now = Date.now();
            if (now - lastLog > 2000) {
              process.stdout.write(`\r🔍 Nodi processati: ${processedNodes.toLocaleString()} | Trovati: ${businesses.length}`);
              lastLog = now;
            }

            const tags = item.tags || {};

            if (!isRelevantPOI(tags)) continue;
            if (!isInValleDaosta(tags)) continue;

            const category = extractCategory(tags);
            if (!category) continue;

            const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
            if (!name) continue;

            const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || 'Aosta';

            const street = tags['addr:street'] || '';
            const houseNumber = tags['addr:housenumber'] || '';
            const address = street && houseNumber
              ? `${street}, ${houseNumber}`
              : street || city;

            businesses.push({
              name,
              category,
              description: tags.description || `${category} a ${city}`,
              address,
              city,
              postcode: tags['addr:postcode'] || '',
              phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
              website: tags.website || tags['contact:website'] || '',
              email: tags.email || tags['contact:email'] || '',
              opening_hours: tags.opening_hours || '',
              latitude: item.lat || null,
              longitude: item.lon || null,
            });

            stats.total++;
          }
        }
        next();
      }))
      .on('finish', async () => {
        console.log(`\n\n✅ Processamento completato!`);
        console.log(`📊 Totale attività trovate in Valle d'Aosta: ${businesses.length.toLocaleString()}\n`);
        resolve(businesses);
      })
      .on('error', reject);
  });
}

async function importToDatabase(businesses) {
  console.log(`💾 Importazione nel database...\n`);

  const batchSize = 50;
  const totalBatches = Math.ceil(businesses.length / batchSize);

  for (let i = 0; i < businesses.length; i += batchSize) {
    const batch = businesses.slice(i, i + batchSize);
    const batchNum = Math.floor(i / batchSize) + 1;

    console.log(`📦 Batch ${batchNum}/${totalBatches} (${batch.length} attività)`);

    for (const business of batch) {
      await insertBusiness(business);
    }

    const percent = ((i + batch.length) / businesses.length * 100).toFixed(1);
    console.log(`   ✓ Inserite: ${stats.inserted} | Saltate: ${stats.skipped} | Errori: ${stats.errors} (${percent}%)\n`);
  }
}

function printStats() {
  console.log('\n╔══════════════════════════════════════════════════════════════╗');
  console.log('║          ✅ IMPORTAZIONE VALLE D\'AOSTA COMPLETATA           ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  console.log(`📊 Riepilogo:\n`);
  console.log(`   Totale trovate:     ${stats.total.toLocaleString()}`);
  console.log(`   ✅ Inserite:        ${stats.inserted.toLocaleString()}`);
  console.log(`   ⏭️  Saltate:         ${stats.skipped.toLocaleString()}`);
  console.log(`   ❌ Errori:          ${stats.errors.toLocaleString()}\n`);

  if (Object.keys(stats.byCity).length > 0) {
    console.log(`📍 Per Città:\n`);
    Object.entries(stats.byCity)
      .sort(([,a], [,b]) => b - a)
      .forEach(([city, count]) => {
        console.log(`   ${city.padEnd(30)} ${count.toLocaleString()}`);
      });
    console.log('');
  }

  if (Object.keys(stats.byCategory).length > 0) {
    console.log(`🏷️  Per Categoria:\n`);
    Object.entries(stats.byCategory)
      .sort(([,a], [,b]) => b - a)
      .forEach(([category, count]) => {
        console.log(`   ${category.padEnd(30)} ${count.toLocaleString()}`);
      });
    console.log('');
  }
}

async function main() {
  console.log('\n╔══════════════════════════════════════════════════════════════╗');
  console.log('║   IMPORTAZIONE VALLE D\'AOSTA DA GEOFABRIK (OpenStreetMap)   ║');
  console.log('║         Tutte le attività commerciali e professionali       ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  try {
    await downloadFile(GEOFABRIK_URL, PBF_FILE);

    const businesses = await processPBF();

    if (businesses.length === 0) {
      console.log('⚠️  Nessuna attività trovata da importare.');
      return;
    }

    await importToDatabase(businesses);

    printStats();

    console.log(`💡 Suggerimento: Puoi eliminare il file ${PBF_FILE} per liberare spazio.\n`);
  } catch (error) {
    console.error('\n❌ Errore:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

main().catch(console.error);
