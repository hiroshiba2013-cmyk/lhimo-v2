import { createClient } from '@supabase/supabase-js';
import fetch from 'node-fetch';
import * as dotenv from 'dotenv';
import { writeFileSync } from 'fs';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Tutte le province italiane con regione
const PROVINCE = [
  // Valle d'Aosta
  { name: 'Aosta', code: 'AO', region: 'Valle d\'Aosta' },

  // Piemonte
  { name: 'Torino', code: 'TO', region: 'Piemonte' },
  { name: 'Alessandria', code: 'AL', region: 'Piemonte' },
  { name: 'Asti', code: 'AT', region: 'Piemonte' },
  { name: 'Biella', code: 'BI', region: 'Piemonte' },
  { name: 'Cuneo', code: 'CN', region: 'Piemonte' },
  { name: 'Novara', code: 'NO', region: 'Piemonte' },
  { name: 'Verbano-Cusio-Ossola', code: 'VB', region: 'Piemonte' },
  { name: 'Vercelli', code: 'VC', region: 'Piemonte' },

  // Lombardia
  { name: 'Milano', code: 'MI', region: 'Lombardia' },
  { name: 'Bergamo', code: 'BG', region: 'Lombardia' },
  { name: 'Brescia', code: 'BS', region: 'Lombardia' },
  { name: 'Como', code: 'CO', region: 'Lombardia' },
  { name: 'Cremona', code: 'CR', region: 'Lombardia' },
  { name: 'Lecco', code: 'LC', region: 'Lombardia' },
  { name: 'Lodi', code: 'LO', region: 'Lombardia' },
  { name: 'Mantova', code: 'MN', region: 'Lombardia' },
  { name: 'Monza e Brianza', code: 'MB', region: 'Lombardia' },
  { name: 'Pavia', code: 'PV', region: 'Lombardia' },
  { name: 'Sondrio', code: 'SO', region: 'Lombardia' },
  { name: 'Varese', code: 'VA', region: 'Lombardia' },

  // Trentino-Alto Adige
  { name: 'Trento', code: 'TN', region: 'Trentino-Alto Adige' },
  { name: 'Bolzano', code: 'BZ', region: 'Trentino-Alto Adige' },

  // Veneto
  { name: 'Venezia', code: 'VE', region: 'Veneto' },
  { name: 'Belluno', code: 'BL', region: 'Veneto' },
  { name: 'Padova', code: 'PD', region: 'Veneto' },
  { name: 'Rovigo', code: 'RO', region: 'Veneto' },
  { name: 'Treviso', code: 'TV', region: 'Veneto' },
  { name: 'Verona', code: 'VR', region: 'Veneto' },
  { name: 'Vicenza', code: 'VI', region: 'Veneto' },

  // Friuli-Venezia Giulia
  { name: 'Trieste', code: 'TS', region: 'Friuli-Venezia Giulia' },
  { name: 'Gorizia', code: 'GO', region: 'Friuli-Venezia Giulia' },
  { name: 'Pordenone', code: 'PN', region: 'Friuli-Venezia Giulia' },
  { name: 'Udine', code: 'UD', region: 'Friuli-Venezia Giulia' },

  // Liguria
  { name: 'Genova', code: 'GE', region: 'Liguria' },
  { name: 'Imperia', code: 'IM', region: 'Liguria' },
  { name: 'La Spezia', code: 'SP', region: 'Liguria' },
  { name: 'Savona', code: 'SV', region: 'Liguria' },

  // Emilia-Romagna
  { name: 'Bologna', code: 'BO', region: 'Emilia-Romagna' },
  { name: 'Ferrara', code: 'FE', region: 'Emilia-Romagna' },
  { name: 'Forlì-Cesena', code: 'FC', region: 'Emilia-Romagna' },
  { name: 'Modena', code: 'MO', region: 'Emilia-Romagna' },
  { name: 'Parma', code: 'PR', region: 'Emilia-Romagna' },
  { name: 'Piacenza', code: 'PC', region: 'Emilia-Romagna' },
  { name: 'Ravenna', code: 'RA', region: 'Emilia-Romagna' },
  { name: 'Reggio Emilia', code: 'RE', region: 'Emilia-Romagna' },
  { name: 'Rimini', code: 'RN', region: 'Emilia-Romagna' },

  // Toscana
  { name: 'Firenze', code: 'FI', region: 'Toscana' },
  { name: 'Arezzo', code: 'AR', region: 'Toscana' },
  { name: 'Grosseto', code: 'GR', region: 'Toscana' },
  { name: 'Livorno', code: 'LI', region: 'Toscana' },
  { name: 'Lucca', code: 'LU', region: 'Toscana' },
  { name: 'Massa-Carrara', code: 'MS', region: 'Toscana' },
  { name: 'Pisa', code: 'PI', region: 'Toscana' },
  { name: 'Pistoia', code: 'PT', region: 'Toscana' },
  { name: 'Prato', code: 'PO', region: 'Toscana' },
  { name: 'Siena', code: 'SI', region: 'Toscana' },

  // Umbria
  { name: 'Perugia', code: 'PG', region: 'Umbria' },
  { name: 'Terni', code: 'TR', region: 'Umbria' },

  // Marche
  { name: 'Ancona', code: 'AN', region: 'Marche' },
  { name: 'Ascoli Piceno', code: 'AP', region: 'Marche' },
  { name: 'Fermo', code: 'FM', region: 'Marche' },
  { name: 'Macerata', code: 'MC', region: 'Marche' },
  { name: 'Pesaro e Urbino', code: 'PU', region: 'Marche' },

  // Lazio
  { name: 'Roma', code: 'RM', region: 'Lazio' },
  { name: 'Frosinone', code: 'FR', region: 'Lazio' },
  { name: 'Latina', code: 'LT', region: 'Lazio' },
  { name: 'Rieti', code: 'RI', region: 'Lazio' },
  { name: 'Viterbo', code: 'VT', region: 'Lazio' },

  // Abruzzo
  { name: 'L\'Aquila', code: 'AQ', region: 'Abruzzo' },
  { name: 'Chieti', code: 'CH', region: 'Abruzzo' },
  { name: 'Pescara', code: 'PE', region: 'Abruzzo' },
  { name: 'Teramo', code: 'TE', region: 'Abruzzo' },

  // Molise
  { name: 'Campobasso', code: 'CB', region: 'Molise' },
  { name: 'Isernia', code: 'IS', region: 'Molise' },

  // Campania
  { name: 'Napoli', code: 'NA', region: 'Campania' },
  { name: 'Avellino', code: 'AV', region: 'Campania' },
  { name: 'Benevento', code: 'BN', region: 'Campania' },
  { name: 'Caserta', code: 'CE', region: 'Campania' },
  { name: 'Salerno', code: 'SA', region: 'Campania' },

  // Puglia
  { name: 'Bari', code: 'BA', region: 'Puglia' },
  { name: 'Barletta-Andria-Trani', code: 'BT', region: 'Puglia' },
  { name: 'Brindisi', code: 'BR', region: 'Puglia' },
  { name: 'Foggia', code: 'FG', region: 'Puglia' },
  { name: 'Lecce', code: 'LE', region: 'Puglia' },
  { name: 'Taranto', code: 'TA', region: 'Puglia' },

  // Basilicata
  { name: 'Potenza', code: 'PZ', region: 'Basilicata' },
  { name: 'Matera', code: 'MT', region: 'Basilicata' },

  // Calabria
  { name: 'Catanzaro', code: 'CZ', region: 'Calabria' },
  { name: 'Cosenza', code: 'CS', region: 'Calabria' },
  { name: 'Crotone', code: 'KR', region: 'Calabria' },
  { name: 'Reggio Calabria', code: 'RC', region: 'Calabria' },
  { name: 'Vibo Valentia', code: 'VV', region: 'Calabria' },

  // Sicilia
  { name: 'Palermo', code: 'PA', region: 'Sicilia' },
  { name: 'Agrigento', code: 'AG', region: 'Sicilia' },
  { name: 'Caltanissetta', code: 'CL', region: 'Sicilia' },
  { name: 'Catania', code: 'CT', region: 'Sicilia' },
  { name: 'Enna', code: 'EN', region: 'Sicilia' },
  { name: 'Messina', code: 'ME', region: 'Sicilia' },
  { name: 'Ragusa', code: 'RG', region: 'Sicilia' },
  { name: 'Siracusa', code: 'SR', region: 'Sicilia' },
  { name: 'Trapani', code: 'TP', region: 'Sicilia' },

  // Sardegna
  { name: 'Cagliari', code: 'CA', region: 'Sardegna' },
  { name: 'Nuoro', code: 'NU', region: 'Sardegna' },
  { name: 'Oristano', code: 'OR', region: 'Sardegna' },
  { name: 'Sassari', code: 'SS', region: 'Sardegna' },
  { name: 'Sud Sardegna', code: 'SU', region: 'Sardegna' }
];

// Categorie prioritarie
const CATEGORIES = [
  { name: 'Supermercati', tags: { shop: 'supermarket' } },
  { name: 'Alimentari', tags: { shop: 'convenience' } },
  { name: 'Panifici', tags: { shop: 'bakery' } },
  { name: 'Farmacie', tags: { amenity: 'pharmacy' } },
  { name: 'Ristoranti', tags: { amenity: 'restaurant' } },
  { name: 'Bar e Caffè', tags: { amenity: 'cafe' } },
  { name: 'Pizzerie', tags: { amenity: 'restaurant', cuisine: 'pizza' } },
  { name: 'Gelaterie', tags: { amenity: 'ice_cream' } },
  { name: 'Parrucchieri', tags: { shop: 'hairdresser' } },
  { name: 'Centri Estetici', tags: { shop: 'beauty' } },
  { name: 'Palestre', tags: { leisure: 'fitness_centre' } },
  { name: 'Stazioni di Servizio', tags: { amenity: 'fuel' } },
  { name: 'Banche', tags: { amenity: 'bank' } },
  { name: 'Uffici Postali', tags: { amenity: 'post_office' } },
  { name: 'Tabaccherie', tags: { shop: 'tobacco' } },
  { name: 'Edicole', tags: { shop: 'newsagent' } },
  { name: 'Librerie', tags: { shop: 'books' } },
  { name: 'Fiorai', tags: { shop: 'florist' } },
  { name: 'Ferramenta', tags: { shop: 'hardware' } },
  { name: 'Elettrauto', tags: { shop: 'car_repair' } },
  { name: 'Autofficine', tags: { shop: 'car_repair' } },
  { name: 'Lavanderie', tags: { shop: 'laundry' } },
  { name: 'Hotel', tags: { tourism: 'hotel' } },
  { name: 'B&B', tags: { tourism: 'guest_house' } },
  { name: 'Agenzie Immobiliari', tags: { office: 'estate_agent' } },
  { name: 'Dentisti', tags: { amenity: 'dentist' } },
  { name: 'Medici', tags: { amenity: 'doctors' } },
  { name: 'Veterinari', tags: { amenity: 'veterinary' } },
  { name: 'Ottici', tags: { shop: 'optician' } },
  { name: 'Negozi di Abbigliamento', tags: { shop: 'clothes' } }
];

const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Funzione per ottenere dati da Overpass API
async function fetchFromOverpass(provincia, category, retries = 3) {
  const overpassUrl = 'https://overpass-api.de/api/interpreter';

  // Costruisci la query Overpass
  let filters = Object.entries(category.tags)
    .map(([key, value]) => `["${key}"="${value}"]`)
    .join('');

  const query = `
    [out:json][timeout:60];
    area["name"="${provincia.name}"]["admin_level"="6"]->.searchArea;
    (
      node${filters}(area.searchArea);
      way${filters}(area.searchArea);
      relation${filters}(area.searchArea);
    );
    out center;
  `;

  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const response = await fetch(overpassUrl, {
        method: 'POST',
        body: `data=${encodeURIComponent(query)}`,
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
      });

      if (!response.ok) {
        if (response.status === 429 || response.status === 504) {
          if (attempt < retries) {
            const waitTime = attempt * 15000; // 15s, 30s
            console.log(`   ⏳ Rate limit/Timeout, attendo ${waitTime/1000}s...`);
            await delay(waitTime);
            continue;
          }
        }
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      return data.elements || [];

    } catch (error) {
      if (attempt === retries) {
        console.log(`   ❌ Errore definitivo: ${error.message}`);
        return [];
      }
      await delay(attempt * 10000);
    }
  }

  return [];
}

// Trova o crea categoria nel DB
async function findOrCreateCategory(categoryName) {
  let { data: existing } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  if (existing) return existing.id;

  const { data: created } = await supabase
    .from('business_categories')
    .insert({ name: categoryName, description: `Categoria: ${categoryName}` })
    .select('id')
    .single();

  return created?.id;
}

// Salva le attività nel database
async function saveBusinesses(businesses, categoryId, provincia) {
  if (businesses.length === 0) return 0;

  const records = businesses.map(b => ({
    name: b.tags?.name || b.tags?.brand || 'Senza nome',
    category_id: categoryId,
    street: b.tags?.['addr:street']
      ? `${b.tags['addr:street']} ${b.tags['addr:housenumber'] || ''}`.trim()
      : null,
    city: b.tags?.['addr:city'] || provincia.name,
    region: provincia.region,
    province: provincia.name,
    postal_code: b.tags?.['addr:postcode'] || null,
    country: 'Italia',
    latitude: b.lat || b.center?.lat,
    longitude: b.lon || b.center?.lon,
    phone: b.tags?.phone || b.tags?.['contact:phone'] || null,
    website: b.tags?.website || b.tags?.['contact:website'] || null,
    email: b.tags?.email || b.tags?.['contact:email'] || null,
    is_claimed: false
  }));

  const { error } = await supabase
    .from('unclaimed_business_locations')
    .insert(records);

  if (error) {
    console.log(`   ⚠️  Errore inserimento: ${error.message}`);
    return 0;
  }

  return records.length;
}

// Main
async function main() {
  console.log('\n╔════════════════════════════════════════════════════════════════════╗');
  console.log('║ IMPORTAZIONE OSM PER CATEGORIA                                      ║');
  console.log('║                                                                    ║');
  console.log(`║ Totale categorie: ${CATEGORIES.length.toString().padStart(3)}                                            ║`);
  console.log(`║ Totale province: ${PROVINCE.length.toString().padStart(3)}                                             ║`);
  console.log('╚════════════════════════════════════════════════════════════════════╝\n');

  const startTime = Date.now();
  let totalImported = 0;
  const results = [];

  for (let catIndex = 0; catIndex < CATEGORIES.length; catIndex++) {
    const category = CATEGORIES[catIndex];

    console.log('\n' + '='.repeat(70));
    console.log(`📦 CATEGORIA [${catIndex + 1}/${CATEGORIES.length}]: ${category.name}`);
    console.log('='.repeat(70));

    const categoryId = await findOrCreateCategory(category.name);
    let categoryTotal = 0;

    for (let provIndex = 0; provIndex < PROVINCE.length; provIndex++) {
      const provincia = PROVINCE[provIndex];

      process.stdout.write(`   [${(provIndex + 1).toString().padStart(3)}/${PROVINCE.length}] ${provincia.name.padEnd(25)} `);

      // Fetch da Overpass
      const businesses = await fetchFromOverpass(provincia, category);

      // Salva nel DB
      const saved = await saveBusinesses(businesses, categoryId, provincia);
      categoryTotal += saved;
      totalImported += saved;

      if (saved > 0) {
        console.log(`✅ ${saved}`);
      } else {
        console.log(`⚪ 0`);
      }

      // Delay tra province
      await delay(2000);
    }

    results.push({
      category: category.name,
      total: categoryTotal
    });

    console.log(`\n   📊 Totale categoria: ${categoryTotal} attività`);

    // Delay più lungo tra categorie
    await delay(5000);
  }

  const elapsed = ((Date.now() - startTime) / 1000 / 60).toFixed(1);

  console.log('\n' + '='.repeat(70));
  console.log('✅ IMPORTAZIONE COMPLETATA');
  console.log('='.repeat(70));
  console.log(`📊 Totale attività importate: ${totalImported}`);
  console.log(`⏱️  Tempo impiegato: ${elapsed} minuti`);
  console.log('\n📋 RIEPILOGO PER CATEGORIA:\n');

  results.forEach(r => {
    console.log(`   ${r.category.padEnd(30)} ${r.total.toString().padStart(6)} attività`);
  });

  // Salva report
  writeFileSync('import-by-category-report.json', JSON.stringify(results, null, 2));
  console.log('\n💾 Report salvato in: import-by-category-report.json\n');
}

main().catch(console.error);
