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

const GEOFABRIK_URL = 'https://download.geofabrik.de/europe/italy-latest.osm.pbf';
const PBF_FILE = './italy-latest.osm.pbf';

const CATEGORY_MAPPING = {
  'restaurant': 'Ristoranti',
  'cafe': 'Bar e Caffè',
  'bar': 'Bar e Caffè',
  'fast_food': 'Fast Food',
  'pub': 'Pub e Locali',
  'ice_cream': 'Gelaterie',
  'bakery': 'Panifici e Pasticcerie',
  'pizza': 'Pizzerie',
  'supermarket': 'Supermercati',
  'convenience': 'Alimentari',
  'clothes': 'Abbigliamento',
  'hairdresser': 'Parrucchieri e Barbieri',
  'beauty': 'Centri Estetici',
  'florist': 'Fioristi',
  'butcher': 'Macellerie',
  'greengrocer': 'Frutta e Verdura',
  'pharmacy': 'Farmacie',
  'bookshop': 'Librerie',
  'jewelry': 'Gioiellerie',
  'electronics': 'Elettronica',
  'furniture': 'Arredamento',
  'hardware': 'Ferramenta',
  'bicycle': 'Negozi di Biciclette',
  'car_repair': 'Autofficine',
  'car': 'Concessionarie Auto',
  'dentist': 'Dentisti',
  'doctors': 'Medici',
  'veterinary': 'Veterinari',
  'lawyer': 'Avvocati',
  'accountant': 'Commercialisti',
  'architect': 'Architetti',
  'estate_agent': 'Agenzie Immobiliari',
  'insurance': 'Assicurazioni',
  'bank': 'Banche',
  'post_office': 'Uffici Postali',
  'hotel': 'Hotel',
  'guest_house': 'B&B',
  'gym': 'Palestre',
  'fitness_centre': 'Palestre',
  'car_wash': 'Autolavaggi',
  'fuel': 'Benzinai',
  'parking': 'Parcheggi',
  'plumber': 'Idraulici',
  'electrician': 'Elettricisti',
  'carpenter': 'Falegnami',
  'painter': 'Imbianchini',
  'photographer': 'Fotografi',
  'tailor': 'Sarti',
  'shoemaker': 'Calzolai',
  'optician': 'Ottici',
  'computer': 'Negozi di Computer',
  'mobile_phone': 'Negozi di Telefonia',
  'kiosk': 'Edicole',
  'travel_agency': 'Agenzie di Viaggio',
  'laundry': 'Lavanderie',
  'dry_cleaning': 'Lavanderie a Secco',
  'pet': 'Negozi per Animali',
  'toys': 'Negozi di Giocattoli',
  'sports': 'Negozi di Sport',
  'gift': 'Negozi di Regali',
  'shoe': 'Calzature',
  'mall': 'Centri Commerciali',
  'department_store': 'Grandi Magazzini',
};

const REGIONS = {
  'Abruzzo': ['AQ', 'CH', 'PE', 'TE'],
  'Basilicata': ['MT', 'PZ'],
  'Calabria': ['CZ', 'CS', 'KR', 'RC', 'VV'],
  'Campania': ['AV', 'BN', 'CE', 'NA', 'SA'],
  'Emilia-Romagna': ['BO', 'FC', 'FE', 'MO', 'PC', 'PR', 'RA', 'RE', 'RN'],
  'Friuli-Venezia Giulia': ['GO', 'PN', 'TS', 'UD'],
  'Lazio': ['FR', 'LT', 'RI', 'RM', 'VT'],
  'Liguria': ['GE', 'IM', 'SP', 'SV'],
  'Lombardia': ['BG', 'BS', 'CO', 'CR', 'LC', 'LO', 'MN', 'MI', 'MB', 'PV', 'SO', 'VA'],
  'Marche': ['AN', 'AP', 'FM', 'MC', 'PU'],
  'Molise': ['CB', 'IS'],
  'Piemonte': ['AL', 'AT', 'BI', 'CN', 'NO', 'TO', 'VB', 'VC'],
  'Puglia': ['BA', 'BT', 'BR', 'FG', 'LE', 'TA'],
  'Sardegna': ['CA', 'CI', 'NU', 'OR', 'SS', 'SU'],
  'Sicilia': ['AG', 'CL', 'CT', 'EN', 'ME', 'PA', 'RG', 'SR', 'TP'],
  'Toscana': ['AR', 'FI', 'GR', 'LI', 'LU', 'MS', 'PI', 'PO', 'PT', 'SI'],
  'Trentino-Alto Adige': ['BZ', 'TN'],
  'Umbria': ['PG', 'TR'],
  'Valle d\'Aosta': ['AO'],
  'Veneto': ['BL', 'PD', 'RO', 'TV', 'VE', 'VI', 'VR'],
};

const categoryCache = {};
const stats = {
  total: 0,
  inserted: 0,
  skipped: 0,
  errors: 0,
  byCategory: {},
  byRegion: {},
};

async function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    if (fs.existsSync(dest)) {
      const stats = fs.statSync(dest);
      if (stats.size > 1000000) { // Se > 1MB è probabilmente valido
        console.log(`\n✓ File già scaricato: ${dest} (${(stats.size / 1024 / 1024).toFixed(1)} MB)`);
        return resolve();
      } else {
        // File troppo piccolo, è probabilmente un redirect HTML
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
        // Gestisci redirect
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

function getRegionFromProvince(province) {
  for (const [region, provinces] of Object.entries(REGIONS)) {
    if (provinces.includes(province)) {
      return region;
    }
  }
  return null;
}

function extractCategory(tags) {
  if (tags.shop && CATEGORY_MAPPING[tags.shop]) {
    return CATEGORY_MAPPING[tags.shop];
  }
  if (tags.amenity && CATEGORY_MAPPING[tags.amenity]) {
    return CATEGORY_MAPPING[tags.amenity];
  }
  if (tags.craft && CATEGORY_MAPPING[tags.craft]) {
    return CATEGORY_MAPPING[tags.craft];
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

async function insertBusiness(data) {
  try {
    const { data: existing } = await supabase
      .from('business_locations')
      .select('id')
      .eq('city', data.city)
      .eq('street', data.address)
      .maybeSingle();

    if (existing) {
      stats.skipped++;
      return;
    }

    const categoryId = await getCategoryId(data.category);
    if (!categoryId) {
      stats.skipped++;
      return;
    }

    const { data: newBiz, error: bizError } = await supabase
      .from('businesses')
      .insert({
        name: data.name,
        category_id: categoryId,
        description: data.description || '',
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

    if (bizError || !newBiz) {
      stats.errors++;
      return;
    }

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
      });

    if (!locError) {
      stats.inserted++;
      stats.byCategory[data.category] = (stats.byCategory[data.category] || 0) + 1;
      if (data.region) {
        stats.byRegion[data.region] = (stats.byRegion[data.region] || 0) + 1;
      }
    } else {
      stats.errors++;
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
            if (now - lastLog > 3000) {
              process.stdout.write(`\r🔍 Nodi processati: ${processedNodes.toLocaleString()} | Trovati: ${businesses.length}`);
              lastLog = now;
            }

            const tags = item.tags || {};

            if (!isRelevantPOI(tags)) continue;

            const category = extractCategory(tags);
            if (!category) continue;

            const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
            if (!name) continue;

            const province = tags['addr:province'] || tags['is_in:province'];
            const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'];

            if (!city) continue;

            const street = tags['addr:street'] || '';
            const houseNumber = tags['addr:housenumber'] || '';
            const address = street && houseNumber
              ? `${street}, ${houseNumber}`
              : street || city;

            const region = province ? getRegionFromProvince(province) : null;

            businesses.push({
              name,
              category,
              description: tags.description || `${category} a ${city}`,
              address,
              city,
              province: province || '',
              region: region || '',
              postcode: tags['addr:postcode'] || '',
              phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
              website: tags.website || tags['contact:website'] || '',
              email: tags.email || tags['contact:email'] || '',
              opening_hours: tags.opening_hours || '',
            });

            stats.total++;
          }
        }
        next();
      }))
      .on('finish', async () => {
        console.log(`\n\n✅ Processamento completato!`);
        console.log(`📊 Totale attività trovate: ${businesses.length.toLocaleString()}\n`);
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
  console.log('║              ✅ IMPORTAZIONE COMPLETATA                      ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  console.log(`📊 Riepilogo:\n`);
  console.log(`   Totale trovate:     ${stats.total.toLocaleString()}`);
  console.log(`   ✅ Inserite:        ${stats.inserted.toLocaleString()}`);
  console.log(`   ⏭️  Saltate:         ${stats.skipped.toLocaleString()}`);
  console.log(`   ❌ Errori:          ${stats.errors.toLocaleString()}\n`);

  if (Object.keys(stats.byRegion).length > 0) {
    console.log(`📍 Per Regione (top 10):\n`);
    Object.entries(stats.byRegion)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 10)
      .forEach(([region, count]) => {
        console.log(`   ${region.padEnd(25)} ${count.toLocaleString()}`);
      });
    console.log('');
  }

  if (Object.keys(stats.byCategory).length > 0) {
    console.log(`🏷️  Per Categoria (top 10):\n`);
    Object.entries(stats.byCategory)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 10)
      .forEach(([category, count]) => {
        console.log(`   ${category.padEnd(25)} ${count.toLocaleString()}`);
      });
    console.log('');
  }
}

async function main() {
  console.log('\n╔══════════════════════════════════════════════════════════════╗');
  console.log('║        IMPORTAZIONE DA GEOFABRIK (OpenStreetMap)            ║');
  console.log('║           Tutte le attività commerciali d\'Italia            ║');
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
    process.exit(1);
  }
}

main().catch(console.error);
