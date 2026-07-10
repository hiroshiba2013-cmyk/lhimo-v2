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

const REGIONS = [
  {
    name: 'Piemonte',
    provinces: ['AL', 'AT', 'BI', 'CN', 'NO', 'TO', 'VB', 'VC'],
    url: 'https://download.geofabrik.de/europe/italy/nord-ovest-latest.osm.pbf',
    file: './piemonte.osm.pbf'
  },
  {
    name: 'Valle d\'Aosta',
    provinces: ['AO'],
    url: 'https://download.geofabrik.de/europe/italy/nord-ovest-latest.osm.pbf',
    file: './valle-aosta.osm.pbf'
  },
  {
    name: 'Lombardia',
    provinces: ['BG', 'BS', 'CO', 'CR', 'LC', 'LO', 'MN', 'MI', 'MB', 'PV', 'SO', 'VA'],
    url: 'https://download.geofabrik.de/europe/italy/nord-ovest-latest.osm.pbf',
    file: './lombardia.osm.pbf'
  },
  {
    name: 'Liguria',
    provinces: ['GE', 'IM', 'SP', 'SV'],
    url: 'https://download.geofabrik.de/europe/italy/nord-ovest-latest.osm.pbf',
    file: './liguria.osm.pbf'
  },
  {
    name: 'Trentino-Alto Adige',
    provinces: ['BZ', 'TN'],
    url: 'https://download.geofabrik.de/europe/italy/nord-est-latest.osm.pbf',
    file: './trentino.osm.pbf'
  },
  {
    name: 'Veneto',
    provinces: ['BL', 'PD', 'RO', 'TV', 'VE', 'VI', 'VR'],
    url: 'https://download.geofabrik.de/europe/italy/nord-est-latest.osm.pbf',
    file: './veneto.osm.pbf'
  },
  {
    name: 'Friuli-Venezia Giulia',
    provinces: ['GO', 'PN', 'TS', 'UD'],
    url: 'https://download.geofabrik.de/europe/italy/nord-est-latest.osm.pbf',
    file: './friuli.osm.pbf'
  },
  {
    name: 'Emilia-Romagna',
    provinces: ['BO', 'FC', 'FE', 'MO', 'PC', 'PR', 'RA', 'RE', 'RN'],
    url: 'https://download.geofabrik.de/europe/italy/nord-est-latest.osm.pbf',
    file: './emilia.osm.pbf'
  },
  {
    name: 'Toscana',
    provinces: ['AR', 'FI', 'GR', 'LI', 'LU', 'MS', 'PI', 'PO', 'PT', 'SI'],
    url: 'https://download.geofabrik.de/europe/italy/centro-latest.osm.pbf',
    file: './toscana.osm.pbf'
  },
  {
    name: 'Umbria',
    provinces: ['PG', 'TR'],
    url: 'https://download.geofabrik.de/europe/italy/centro-latest.osm.pbf',
    file: './umbria.osm.pbf'
  },
  {
    name: 'Marche',
    provinces: ['AN', 'AP', 'FM', 'MC', 'PU'],
    url: 'https://download.geofabrik.de/europe/italy/centro-latest.osm.pbf',
    file: './marche.osm.pbf'
  },
  {
    name: 'Lazio',
    provinces: ['FR', 'LT', 'RI', 'RM', 'VT'],
    url: 'https://download.geofabrik.de/europe/italy/centro-latest.osm.pbf',
    file: './lazio.osm.pbf'
  },
  {
    name: 'Abruzzo',
    provinces: ['AQ', 'CH', 'PE', 'TE'],
    url: 'https://download.geofabrik.de/europe/italy/sud-latest.osm.pbf',
    file: './abruzzo.osm.pbf'
  },
  {
    name: 'Molise',
    provinces: ['CB', 'IS'],
    url: 'https://download.geofabrik.de/europe/italy/sud-latest.osm.pbf',
    file: './molise.osm.pbf'
  },
  {
    name: 'Campania',
    provinces: ['AV', 'BN', 'CE', 'NA', 'SA'],
    url: 'https://download.geofabrik.de/europe/italy/sud-latest.osm.pbf',
    file: './campania.osm.pbf'
  },
  {
    name: 'Puglia',
    provinces: ['BA', 'BT', 'BR', 'FG', 'LE', 'TA'],
    url: 'https://download.geofabrik.de/europe/italy/sud-latest.osm.pbf',
    file: './puglia.osm.pbf'
  },
  {
    name: 'Basilicata',
    provinces: ['MT', 'PZ'],
    url: 'https://download.geofabrik.de/europe/italy/sud-latest.osm.pbf',
    file: './basilicata.osm.pbf'
  },
  {
    name: 'Calabria',
    provinces: ['CZ', 'CS', 'KR', 'RC', 'VV'],
    url: 'https://download.geofabrik.de/europe/italy/sud-latest.osm.pbf',
    file: './calabria.osm.pbf'
  },
  {
    name: 'Sicilia',
    provinces: ['AG', 'CL', 'CT', 'EN', 'ME', 'PA', 'RG', 'SR', 'TP'],
    url: 'https://download.geofabrik.de/europe/italy/isole-latest.osm.pbf',
    file: './sicilia.osm.pbf'
  },
  {
    name: 'Sardegna',
    provinces: ['CA', 'CI', 'NU', 'OR', 'SS', 'SU'],
    url: 'https://download.geofabrik.de/europe/italy/isole-latest.osm.pbf',
    file: './sardegna.osm.pbf'
  }
];

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
  'butcher': 'Macellerie',
  'greengrocer': 'Alimentari',
  'beverages': 'Alimentari',
  'wine': 'Alimentari',
  'cheese': 'Alimentari',
  'seafood': 'Alimentari',
  'pastry': 'Panifici e Pasticcerie',
  'deli': 'Alimentari',
  'dairy': 'Alimentari',
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
  'car_repair': 'Autofficine',
  'car': 'Autofficine',
  'car_wash': 'Autolavaggi',
  'fuel': 'Benzinai',
  'bicycle': 'Autofficine',
  'motorcycle': 'Autofficine',
  'tyres': 'Autofficine',
  'car_parts': 'Autofficine',
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
const downloadedFiles = new Set();

async function downloadFile(url, dest) {
  if (downloadedFiles.has(url)) {
    console.log(`✓ File già scaricato per questo URL\n`);
    return;
  }

  return new Promise((resolve, reject) => {
    if (fs.existsSync(dest)) {
      const stats = fs.statSync(dest);
      if (stats.size > 1000000) {
        console.log(`✓ File già presente: ${dest} (${(stats.size / 1024 / 1024).toFixed(1)} MB)\n`);
        downloadedFiles.add(url);
        return resolve();
      } else {
        fs.unlinkSync(dest);
      }
    }

    console.log(`📥 Download da Geofabrik...`);
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
          downloadedFiles.add(url);
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

function belongsToRegion(tags, region) {
  const province = (tags['addr:province'] || tags['is_in:province'] || '').toUpperCase();
  return region.provinces.includes(province);
}

async function insertBusiness(data, region) {
  try {
    const categoryId = await getCategoryId(data.category);
    if (!categoryId) {
      return { success: false, reason: 'category' };
    }

    const { data: existing } = await supabase
      .from('unclaimed_business_locations')
      .select('id')
      .eq('city', data.city)
      .eq('street', data.address)
      .eq('name', data.name)
      .maybeSingle();

    if (existing) {
      return { success: false, reason: 'duplicate' };
    }

    const { error } = await supabase
      .from('unclaimed_business_locations')
      .insert({
        name: data.name,
        category_id: categoryId,
        description: data.description,
        street: data.address,
        city: data.city,
        province: data.province,
        region: region.name,
        postal_code: data.postcode,
        phone: data.phone,
        email: data.email,
        website: data.website,
        business_hours: data.opening_hours,
        latitude: data.latitude,
        longitude: data.longitude,
      });

    if (!error) {
      return { success: true };
    } else {
      return { success: false, reason: 'error', error };
    }
  } catch (error) {
    return { success: false, reason: 'error', error };
  }
}

function formatTime(seconds) {
  if (seconds < 60) return `${Math.round(seconds)}s`;
  if (seconds < 3600) return `${Math.floor(seconds / 60)}m ${Math.round(seconds % 60)}s`;
  return `${Math.floor(seconds / 3600)}h ${Math.floor((seconds % 3600) / 60)}m`;
}

async function processPBFForRegion(region) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 PROCESSAMENTO REGIONE: ${region.name.toUpperCase()}`);
  console.log(`${'='.repeat(70)}\n`);

  const startTime = Date.now();

  const stats = {
    total: 0,
    inserted: 0,
    skipped: 0,
    errors: 0,
    byCategory: {},
  };

  const businesses = [];
  let processedNodes = 0;
  let lastLog = Date.now();

  return new Promise((resolve, reject) => {
    const parser = parseOSM();

    fs.createReadStream(region.file)
      .pipe(parser)
      .pipe(through2.obj(async (items, enc, next) => {
        for (const item of items) {
          if (item.type === 'node') {
            processedNodes++;

            const now = Date.now();
            if (now - lastLog > 3000) {
              process.stdout.write(`\r🔍 Nodi: ${processedNodes.toLocaleString()} | Trovati: ${businesses.length}`);
              lastLog = now;
            }

            const tags = item.tags || {};

            if (!isRelevantPOI(tags)) continue;
            if (!belongsToRegion(tags, region)) continue;

            const category = extractCategory(tags);
            if (!category) continue;

            const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
            if (!name) continue;

            const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'];
            if (!city) continue;

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
              province: tags['addr:province'] || '',
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
        console.log(`📊 Attività trovate: ${businesses.length.toLocaleString()}\n`);

        if (businesses.length > 0) {
          console.log(`💾 Importazione nel database...\n`);

          const importStartTime = Date.now();
          const batchSize = 100;

          for (let i = 0; i < businesses.length; i += batchSize) {
            const batch = businesses.slice(i, i + batchSize);

            for (const business of batch) {
              const result = await insertBusiness(business, region);
              if (result.success) {
                stats.inserted++;
                stats.byCategory[business.category] = (stats.byCategory[business.category] || 0) + 1;
              } else if (result.reason === 'duplicate') {
                stats.skipped++;
              } else {
                stats.errors++;
              }
            }

            const percent = ((i + batch.length) / businesses.length * 100).toFixed(1);
            const processed = i + batch.length;
            const elapsed = (Date.now() - importStartTime) / 1000;
            const rate = processed / elapsed;
            const remaining = businesses.length - processed;
            const eta = remaining / rate;

            process.stdout.write(`\r   ✓ ${percent}% | Inserite: ${stats.inserted} | ETA: ${formatTime(eta)} | Trascorso: ${formatTime(elapsed)}`);
          }
          console.log('\n');
        }

        resolve(stats);
      })
      .on('error', reject);
  });
}

async function main() {
  const overallStartTime = Date.now();

  console.log('\n╔══════════════════════════════════════════════════════════════════╗');
  console.log('║    IMPORTAZIONE TUTTE LE REGIONI ITALIANE DA GEOFABRIK         ║');
  console.log('║              Attività commerciali e professionali               ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝\n');

  const args = process.argv.slice(2);
  let regionsToImport = REGIONS;

  if (args.length > 0) {
    const regionNames = args.map(r => r.toLowerCase());
    regionsToImport = REGIONS.filter(r =>
      regionNames.some(name => r.name.toLowerCase().includes(name))
    );

    if (regionsToImport.length === 0) {
      console.log('❌ Nessuna regione trovata con i nomi specificati.\n');
      console.log('Regioni disponibili:');
      REGIONS.forEach(r => console.log(`  - ${r.name}`));
      console.log('\nEsempio: node import-all-regions.js lombardia veneto\n');
      process.exit(1);
    }
  }

  console.log(`📍 Regioni da importare: ${regionsToImport.map(r => r.name).join(', ')}\n`);
  console.log(`⏱️  Stima tempo totale: ${regionsToImport.length < 5 ? '15-60 minuti' : regionsToImport.length < 10 ? '1-3 ore' : '4-8 ore'}\n`);

  const globalStats = {
    totalInserted: 0,
    totalSkipped: 0,
    totalErrors: 0,
    byRegion: {},
  };

  try {
    const uniqueUrls = [...new Set(regionsToImport.map(r => r.url))];
    console.log(`📥 Download dei file PBF necessari...\n`);

    for (const url of uniqueUrls) {
      const fileName = url.split('/').pop();
      await downloadFile(url, `./${fileName}`);

      const regions = regionsToImport.filter(r => r.url === url);
      for (const region of regions) {
        if (!fs.existsSync(region.file)) {
          fs.copyFileSync(`./${fileName}`, region.file);
        }
      }
    }

    for (let idx = 0; idx < regionsToImport.length; idx++) {
      const region = regionsToImport[idx];
      const regionStartTime = Date.now();

      console.log(`\n[${idx + 1}/${regionsToImport.length}] Inizio ${region.name}...`);

      const stats = await processPBFForRegion(region);

      globalStats.totalInserted += stats.inserted;
      globalStats.totalSkipped += stats.skipped;
      globalStats.totalErrors += stats.errors;
      globalStats.byRegion[region.name] = stats.inserted;

      const regionElapsed = (Date.now() - regionStartTime) / 1000;
      console.log(`✅ ${region.name}: ${stats.inserted} attività inserite in ${formatTime(regionElapsed)}`);

      if (idx < regionsToImport.length - 1) {
        const avgTimePerRegion = (Date.now() - overallStartTime) / (idx + 1) / 1000;
        const remainingRegions = regionsToImport.length - (idx + 1);
        const etaTotal = avgTimePerRegion * remainingRegions;
        console.log(`⏱️  Tempo stimato rimanente: ${formatTime(etaTotal)}\n`);
      }
    }

    const totalElapsed = (Date.now() - overallStartTime) / 1000;

    console.log('\n╔══════════════════════════════════════════════════════════════════╗');
    console.log('║                  ✅ IMPORTAZIONE COMPLETATA                      ║');
    console.log('╚══════════════════════════════════════════════════════════════════╝\n');

    console.log(`⏱️  Tempo totale impiegato: ${formatTime(totalElapsed)}\n`);
    console.log(`📊 Riepilogo Globale:\n`);
    console.log(`   ✅ Totale inserite:  ${globalStats.totalInserted.toLocaleString()}`);
    console.log(`   ⏭️  Totale saltate:   ${globalStats.totalSkipped.toLocaleString()}`);
    console.log(`   ❌ Totale errori:    ${globalStats.totalErrors.toLocaleString()}\n`);

    if (Object.keys(globalStats.byRegion).length > 0) {
      console.log(`📍 Per Regione:\n`);
      Object.entries(globalStats.byRegion)
        .sort(([,a], [,b]) => b - a)
        .forEach(([region, count]) => {
          console.log(`   ${region.padEnd(30)} ${count.toLocaleString()}`);
        });
      console.log('');
    }

  } catch (error) {
    console.error('\n❌ Errore:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

main().catch(console.error);
