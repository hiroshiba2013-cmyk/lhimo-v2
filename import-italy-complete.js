import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';
import { createWriteStream, createReadStream, existsSync, mkdirSync, unlinkSync, statSync } from 'fs';
import parseOSM from 'osm-pbf-parser';
import through2 from 'through2';
import { unlink } from 'fs/promises';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const REGIONS = [
  { name: 'Valle d\'Aosta', geofabrik: 'valle-d-aosta', provinces: ['AO'] },
  { name: 'Piemonte', geofabrik: 'piemonte', provinces: ['TO', 'AL', 'AT', 'BI', 'CN', 'NO', 'VC', 'VB'] },
  { name: 'Lombardia', geofabrik: 'lombardia', provinces: ['MI', 'BG', 'BS', 'CO', 'CR', 'LC', 'LO', 'MN', 'MB', 'PV', 'SO', 'VA'] },
  { name: 'Trentino-Alto Adige', geofabrik: 'trentino-alto-adige', provinces: ['BZ', 'TN'] },
  { name: 'Veneto', geofabrik: 'veneto', provinces: ['VE', 'BL', 'PD', 'RO', 'TV', 'VR', 'VI'] },
  { name: 'Friuli-Venezia Giulia', geofabrik: 'friuli-venezia-giulia', provinces: ['TS', 'GO', 'PN', 'UD'] },
  { name: 'Liguria', geofabrik: 'liguria', provinces: ['GE', 'IM', 'SP', 'SV'] },
  { name: 'Emilia-Romagna', geofabrik: 'emilia-romagna', provinces: ['BO', 'FC', 'FE', 'MO', 'PR', 'PC', 'RA', 'RE', 'RN'] },
  { name: 'Toscana', geofabrik: 'toscana', provinces: ['FI', 'AR', 'GR', 'LI', 'LU', 'MS', 'PI', 'PT', 'PO', 'SI'] },
  { name: 'Umbria', geofabrik: 'umbria', provinces: ['PG', 'TR'] },
  { name: 'Marche', geofabrik: 'marche', provinces: ['AN', 'AP', 'FM', 'MC', 'PU'] },
  { name: 'Lazio', geofabrik: 'lazio', provinces: ['RM', 'FR', 'LT', 'RI', 'VT'] },
  { name: 'Abruzzo', geofabrik: 'abruzzo', provinces: ['AQ', 'CH', 'PE', 'TE'] },
  { name: 'Molise', geofabrik: 'molise', provinces: ['CB', 'IS'] },
  { name: 'Campania', geofabrik: 'campania', provinces: ['NA', 'AV', 'BN', 'CE', 'SA'] },
  { name: 'Puglia', geofabrik: 'puglia', provinces: ['BA', 'BR', 'BT', 'FG', 'LE', 'TA'] },
  { name: 'Basilicata', geofabrik: 'basilicata', provinces: ['MT', 'PZ'] },
  { name: 'Calabria', geofabrik: 'calabria', provinces: ['CZ', 'CS', 'KR', 'RC', 'VV'] },
  { name: 'Sicilia', geofabrik: 'sicilia', provinces: ['PA', 'AG', 'CL', 'CT', 'EN', 'ME', 'RG', 'SR', 'TP'] },
  { name: 'Sardegna', geofabrik: 'sardegna', provinces: ['CA', 'CI', 'NU', 'OR', 'SS', 'SU'] }
];

const TAG_TO_CATEGORY = {
  'shop': {
    'convenience': 'Alimentari',
    'general': 'Alimentari',
    'grocery': 'Alimentari',
    'supermarket': 'Supermercati',
    'department_store': 'Supermercati',
    'bakery': 'Panifici e Pasticcerie',
    'pastry': 'Panifici e Pasticcerie',
    'confectionery': 'Panifici e Pasticcerie',
    'butcher': 'Macellerie',
    'hairdresser': 'Parrucchieri e Barbieri',
    'barber': 'Parrucchieri e Barbieri',
    'beauty': 'Parrucchieri e Barbieri',
    'clothes': 'Abbigliamento',
    'fashion': 'Abbigliamento',
    'boutique': 'Abbigliamento',
    'shoes': 'Scarpe',
    'jewelry': 'Gioiellerie',
    'watches': 'Gioiellerie',
    'books': 'Librerie',
    'stationery': 'Librerie',
    'hardware': 'Ferramenta',
    'doityourself': 'Ferramenta',
    'florist': 'Fioristi',
    'garden_centre': 'Fioristi',
    'tobacco': 'Tabaccherie',
    'newsagent': 'Edicole',
    'kiosk': 'Edicole',
    'car_repair': 'Autofficine',
    'tyres': 'Gommisti',
    'laundry': 'Lavanderie',
    'dry_cleaning': 'Lavanderie',
    'plumber': 'Idraulici',
    'electrician': 'Elettricisti',
  },
  'amenity': {
    'restaurant': 'Ristoranti',
    'fast_food': 'Ristoranti',
    'food_court': 'Ristoranti',
    'bar': 'Bar e Caffè',
    'cafe': 'Bar e Caffè',
    'pub': 'Bar e Caffè',
    'pharmacy': 'Farmacie',
    'fuel': 'Benzinai',
    'bank': 'Banche',
    'post_office': 'Uffici Postali',
  },
  'tourism': {
    'hotel': 'Hotel',
    'motel': 'Hotel',
    'guest_house': 'Hotel',
    'bed_and_breakfast': 'B&B',
    'apartment': 'B&B',
  },
  'leisure': {
    'fitness_centre': 'Palestre',
    'sports_centre': 'Palestre',
  },
  'craft': {
    'plumber': 'Idraulici',
    'electrician': 'Elettricisti',
    'carpenter': 'Falegnami',
    'cabinet_maker': 'Falegnami',
    'builder': 'Imprese Edili',
    'car_repair': 'Autofficine',
  },
  'office': {
    'lawyer': 'Avvocati',
    'legal': 'Avvocati',
    'accountant': 'Commercialisti',
    'tax_advisor': 'Commercialisti',
    'notary': 'Notai',
    'architect': 'Architetti',
    'engineer': 'Architetti',
    'construction_company': 'Imprese Edili',
  },
};

const categoryCache = new Map();
const stats = {
  regions: 0,
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

function categorizeElement(tags) {
  for (const [tagType, mappings] of Object.entries(TAG_TO_CATEGORY)) {
    if (tags[tagType] && mappings[tags[tagType]]) {
      return mappings[tags[tagType]];
    }
  }
  return null;
}

function extractBusinessData(element, region, provinces) {
  const tags = element.tags || {};

  const category = categorizeElement(tags);
  if (!category) return null;

  const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
  if (!name) return null;

  let lat, lon;
  if (element.type === 'node') {
    lat = element.lat;
    lon = element.lon;
  } else if (element.centroid) {
    lat = element.centroid.lat;
    lon = element.centroid.lon;
  }

  if (!lat || !lon) return null;

  const street = tags['addr:street'] || tags['addr:place'] || '';
  const houseNumber = tags['addr:housenumber'] || '';
  const address = street && houseNumber ? `${street}, ${houseNumber}` : street;

  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || '';
  if (!city) return null;

  const provinceCode = tags['addr:province'] || tags['addr:county'] || '';
  const province = provinces.find(p => provinceCode.toUpperCase().includes(p)) || provinces[0];

  const postcode = tags['addr:postcode'] || '';
  const phone = (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '');
  const email = tags.email || tags['contact:email'] || '';
  const website = tags.website || tags['contact:website'] || '';
  const opening_hours = tags.opening_hours || '';

  return {
    name,
    category,
    description: tags.description || `${category} a ${city}`,
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

async function downloadRegion(region) {
  const url = `https://download.geofabrik.de/europe/italy/${region.geofabrik}-latest.osm.pbf`;
  const filename = `/tmp/${region.geofabrik}.osm.pbf`;

  if (existsSync(filename)) {
    const stats = statSync(filename);
    if (stats.size > 1000000) {
      console.log(`   ℹ️  File già scaricato: ${filename} (${(stats.size / 1024 / 1024).toFixed(1)} MB)`);
      return filename;
    } else {
      unlinkSync(filename);
    }
  }

  console.log(`   📥 Scaricamento da: ${url}`);

  return new Promise((resolve, reject) => {
    const file = createWriteStream(filename);
    let downloadedBytes = 0;

    const doDownload = (downloadUrl) => {
      https.get(downloadUrl, (response) => {
        if (response.statusCode === 302 || response.statusCode === 301) {
          file.close();
          if (existsSync(filename)) unlinkSync(filename);
          console.log(`   ↪️  Redirect...`);
          return doDownload(response.headers.location);
        }

        if (response.statusCode !== 200) {
          file.close();
          if (existsSync(filename)) unlinkSync(filename);
          return reject(new Error(`HTTP ${response.statusCode}`));
        }

        const totalBytes = parseInt(response.headers['content-length'], 10);
        console.log(`   Dimensione: ${(totalBytes / 1024 / 1024).toFixed(1)} MB`);

        response.on('data', (chunk) => {
          downloadedBytes += chunk.length;
        });

        response.pipe(file);

        file.on('finish', () => {
          file.close();
          console.log(`   ✅ Scaricato: ${filename}`);
          resolve(filename);
        });

        file.on('error', (err) => {
          file.close();
          if (existsSync(filename)) unlinkSync(filename);
          reject(err);
        });
      }).on('error', (err) => {
        file.close();
        if (existsSync(filename)) unlinkSync(filename);
        reject(err);
      });
    };

    doDownload(url);
  });
}

async function processRegion(region) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 REGIONE: ${region.name.toUpperCase()}`);
  console.log(`${'='.repeat(70)}\n`);

  try {
    const filename = await downloadRegion(region);

    console.log(`   🔄 Processamento file PBF...`);

    const businesses = await new Promise((resolve, reject) => {
      const parser = parseOSM();
      const found = [];
      const seenBusinesses = new Set();
      let processedCount = 0;
      let relevantCount = 0;

      createReadStream(filename)
        .pipe(parser)
        .pipe(through2.obj(function (items, enc, next) {
          for (const item of items) {
            processedCount++;
            if (item.type === 'node' || item.type === 'way') {
              if (item.tags && (item.tags.name || item.tags.brand)) {
                relevantCount++;
                const business = extractBusinessData(item, region.name, region.provinces);
                if (business) {
                  const key = `${business.name}-${business.city}-${business.latitude.toFixed(5)}`;
                  if (!seenBusinesses.has(key)) {
                    seenBusinesses.add(key);
                    found.push(business);
                  }
                }
              }
            }
          }
          next();
        }))
        .on('finish', () => {
          console.log(`      Processati: ${processedCount.toLocaleString()} elementi`);
          console.log(`      Con nome:   ${relevantCount.toLocaleString()} elementi`);
          resolve(found);
        })
        .on('error', reject);
    });

    console.log(`   📊 Trovate ${businesses.length} attività uniche\n`);

    if (businesses.length === 0) {
      console.log(`   ⚠️  Nessuna attività da importare\n`);
      return;
    }

    console.log(`   💾 Importazione nel database...`);

    let regionInserted = 0;
    let regionSkipped = 0;
    let regionErrors = 0;

    for (const business of businesses) {
      try {
        const categoryId = await getCategoryId(business.category);
        if (!categoryId) {
          regionSkipped++;
          continue;
        }

        const { data: existing } = await supabase
          .from('unclaimed_business_locations')
          .select('id')
          .eq('name', business.name)
          .eq('city', business.city)
          .maybeSingle();

        if (existing) {
          regionSkipped++;
          continue;
        }

        const { error } = await supabase
          .from('unclaimed_business_locations')
          .insert({
            name: business.name,
            category_id: categoryId,
            description: business.description,
            street: business.street,
            city: business.city,
            province: business.province,
            region: business.region,
            postal_code: business.postal_code,
            phone: business.phone,
            email: business.email,
            website: business.website,
            business_hours: business.business_hours,
            latitude: business.latitude,
            longitude: business.longitude,
          });

        if (!error) {
          regionInserted++;
          stats.inserted++;
          stats.byCategory[business.category] = (stats.byCategory[business.category] || 0) + 1;
        } else {
          regionErrors++;
          stats.errors++;
        }
      } catch (error) {
        regionErrors++;
        stats.errors++;
      }
    }

    stats.byRegion[region.name] = regionInserted;
    stats.regions++;

    console.log(`\n   ✅ ${region.name}:`);
    console.log(`      Inserite: ${regionInserted.toLocaleString()}`);
    console.log(`      Saltate:  ${regionSkipped.toLocaleString()}`);
    console.log(`      Errori:   ${regionErrors.toLocaleString()}`);

    console.log(`\n   🗑️  Rimozione file temporaneo...`);
    await unlink(filename);

  } catch (error) {
    console.error(`\n   ❌ Errore per ${region.name}:`, error.message);
    stats.errors++;
  }
}

async function main() {
  console.log('\n╔════════════════════════════════════════════════════════════════════════╗');
  console.log('║         IMPORTAZIONE COMPLETA ITALIA DA OPENSTREETMAP                 ║');
  console.log('║                    (Dati Geofabrik - PBF)                              ║');
  console.log('╚════════════════════════════════════════════════════════════════════════╝\n');

  console.log(`📋 Regioni da processare: ${REGIONS.length}`);
  const categoryCount = Object.values(TAG_TO_CATEGORY).reduce((sum, cat) => sum + Object.keys(cat).length, 0);
  console.log(`📂 Categorie monitorate: ${categoryCount}\n`);

  if (!existsSync('/tmp')) {
    mkdirSync('/tmp', { recursive: true });
  }

  const startTime = Date.now();

  // Test con Valle d'Aosta prima
  await processRegion(REGIONS[0]);

  // Processa tutte le regioni
  // for (const region of REGIONS) {
  //   await processRegion(region);
  //   await new Promise(resolve => setTimeout(resolve, 2000));
  // }

  const duration = ((Date.now() - startTime) / 1000 / 60).toFixed(1);

  console.log('\n\n╔════════════════════════════════════════════════════════════════════════╗');
  console.log('║                    ✅ IMPORTAZIONE COMPLETATA                          ║');
  console.log('╚════════════════════════════════════════════════════════════════════════╝\n');

  console.log(`⏱️  Tempo totale: ${duration} minuti\n`);
  console.log('📊 RIEPILOGO GENERALE:\n');
  console.log(`   Regioni processate:  ${stats.regions}/${REGIONS.length}`);
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
    console.log('🏷️  PER CATEGORIA (Top 20):\n');
    Object.entries(stats.byCategory)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 20)
      .forEach(([category, count]) => {
        console.log(`   ${category.padEnd(30)} ${count.toLocaleString().padStart(8)}`);
      });
    console.log('');
  }
}

main().catch(console.error);
