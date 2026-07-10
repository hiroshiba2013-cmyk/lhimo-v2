import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// 📍 PROVINCE ITALIANE con bounding box
// Focus su città sotto i 10.000 abitanti
const ITALIAN_PROVINCES = [
  // LOMBARDIA
  { name: 'Bergamo', code: 'BG', region: 'Lombardia', bbox: [45.5, 9.5, 45.9, 10.2] },
  { name: 'Brescia', code: 'BS', region: 'Lombardia', bbox: [45.3, 9.9, 45.8, 10.7] },
  { name: 'Como', code: 'CO', region: 'Lombardia', bbox: [45.7, 9.0, 46.1, 9.5] },
  { name: 'Cremona', code: 'CR', region: 'Lombardia', bbox: [45.0, 9.8, 45.3, 10.3] },
  { name: 'Lecco', code: 'LC', region: 'Lombardia', bbox: [45.8, 9.3, 46.0, 9.6] },
  { name: 'Lodi', code: 'LO', region: 'Lombardia', bbox: [45.2, 9.4, 45.4, 9.7] },
  { name: 'Mantova', code: 'MN', region: 'Lombardia', bbox: [44.9, 10.4, 45.3, 11.1] },
  { name: 'Milano', code: 'MI', region: 'Lombardia', bbox: [45.3, 8.8, 45.6, 9.5] },
  { name: 'Monza e Brianza', code: 'MB', region: 'Lombardia', bbox: [45.5, 9.2, 45.7, 9.4] },
  { name: 'Pavia', code: 'PV', region: 'Lombardia', bbox: [45.0, 8.6, 45.3, 9.4] },
  { name: 'Sondrio', code: 'SO', region: 'Lombardia', bbox: [46.0, 9.5, 46.5, 10.5] },
  { name: 'Varese', code: 'VA', region: 'Lombardia', bbox: [45.6, 8.5, 45.9, 9.0] },

  // PIEMONTE
  { name: 'Alessandria', code: 'AL', region: 'Piemonte', bbox: [44.6, 8.4, 45.1, 9.0] },
  { name: 'Asti', code: 'AT', region: 'Piemonte', bbox: [44.7, 8.0, 45.0, 8.5] },
  { name: 'Biella', code: 'BI', region: 'Piemonte', bbox: [45.4, 7.9, 45.7, 8.3] },
  { name: 'Cuneo', code: 'CN', region: 'Piemonte', bbox: [44.0, 7.0, 44.8, 8.2] },
  { name: 'Novara', code: 'NO', region: 'Piemonte', bbox: [45.3, 8.3, 45.7, 8.8] },
  { name: 'Torino', code: 'TO', region: 'Piemonte', bbox: [44.8, 7.2, 45.3, 7.9] },
  { name: 'Verbano-Cusio-Ossola', code: 'VB', region: 'Piemonte', bbox: [45.7, 8.0, 46.5, 8.7] },
  { name: 'Vercelli', code: 'VC', region: 'Piemonte', bbox: [45.1, 8.1, 45.6, 8.6] },

  // VENETO
  { name: 'Belluno', code: 'BL', region: 'Veneto', bbox: [45.9, 11.8, 46.7, 12.6] },
  { name: 'Padova', code: 'PD', region: 'Veneto', bbox: [45.2, 11.6, 45.6, 12.1] },
  { name: 'Rovigo', code: 'RO', region: 'Veneto', bbox: [44.8, 11.5, 45.2, 12.1] },
  { name: 'Treviso', code: 'TV', region: 'Veneto', bbox: [45.5, 12.0, 45.9, 12.5] },
  { name: 'Venezia', code: 'VE', region: 'Veneto', bbox: [45.2, 12.0, 45.7, 12.8] },
  { name: 'Verona', code: 'VR', region: 'Veneto', bbox: [45.2, 10.6, 45.7, 11.3] },
  { name: 'Vicenza', code: 'VI', region: 'Veneto', bbox: [45.4, 11.2, 45.9, 11.8] },

  // EMILIA-ROMAGNA
  { name: 'Bologna', code: 'BO', region: 'Emilia-Romagna', bbox: [44.2, 11.0, 44.7, 11.7] },
  { name: 'Ferrara', code: 'FE', region: 'Emilia-Romagna', bbox: [44.6, 11.4, 45.1, 12.2] },
  { name: 'Forlì-Cesena', code: 'FC', region: 'Emilia-Romagna', bbox: [43.9, 11.9, 44.3, 12.4] },
  { name: 'Modena', code: 'MO', region: 'Emilia-Romagna', bbox: [44.4, 10.6, 44.8, 11.2] },
  { name: 'Parma', code: 'PR', region: 'Emilia-Romagna', bbox: [44.5, 9.7, 44.9, 10.5] },
  { name: 'Piacenza', code: 'PC', region: 'Emilia-Romagna', bbox: [44.8, 9.4, 45.2, 9.9] },
  { name: 'Ravenna', code: 'RA', region: 'Emilia-Romagna', bbox: [44.2, 11.9, 44.6, 12.4] },
  { name: 'Reggio Emilia', code: 'RE', region: 'Emilia-Romagna', bbox: [44.5, 10.3, 44.8, 10.7] },
  { name: 'Rimini', code: 'RN', region: 'Emilia-Romagna', bbox: [43.9, 12.4, 44.2, 12.7] },

  // TOSCANA
  { name: 'Arezzo', code: 'AR', region: 'Toscana', bbox: [43.2, 11.6, 43.7, 12.2] },
  { name: 'Firenze', code: 'FI', region: 'Toscana', bbox: [43.6, 11.0, 44.0, 11.6] },
  { name: 'Grosseto', code: 'GR', region: 'Toscana', bbox: [42.5, 10.8, 43.0, 11.5] },
  { name: 'Livorno', code: 'LI', region: 'Toscana', bbox: [42.9, 10.2, 43.6, 10.7] },
  { name: 'Lucca', code: 'LU', region: 'Toscana', bbox: [43.7, 10.2, 44.1, 10.7] },
  { name: 'Massa-Carrara', code: 'MS', region: 'Toscana', bbox: [44.0, 9.9, 44.3, 10.3] },
  { name: 'Pisa', code: 'PI', region: 'Toscana', bbox: [43.5, 10.2, 43.9, 10.7] },
  { name: 'Pistoia', code: 'PT', region: 'Toscana', bbox: [43.8, 10.7, 44.1, 11.1] },
  { name: 'Prato', code: 'PO', region: 'Toscana', bbox: [43.8, 11.0, 44.0, 11.2] },
  { name: 'Siena', code: 'SI', region: 'Toscana', bbox: [43.0, 11.1, 43.5, 11.7] },

  // LAZIO
  { name: 'Frosinone', code: 'FR', region: 'Lazio', bbox: [41.4, 13.4, 41.8, 13.9] },
  { name: 'Latina', code: 'LT', region: 'Lazio', bbox: [41.2, 12.9, 41.6, 13.5] },
  { name: 'Rieti', code: 'RI', region: 'Lazio', bbox: [42.2, 12.6, 42.7, 13.2] },
  { name: 'Roma', code: 'RM', region: 'Lazio', bbox: [41.6, 12.2, 42.2, 13.0] },
  { name: 'Viterbo', code: 'VT', region: 'Lazio', bbox: [42.2, 11.6, 42.7, 12.3] },

  // LIGURIA
  { name: 'Genova', code: 'GE', region: 'Liguria', bbox: [44.2, 8.5, 44.6, 9.3] },
  { name: 'Imperia', code: 'IM', region: 'Liguria', bbox: [43.8, 7.5, 44.2, 8.2] },
  { name: 'La Spezia', code: 'SP', region: 'Liguria', bbox: [44.0, 9.6, 44.4, 10.0] },
  { name: 'Savona', code: 'SV', region: 'Liguria', bbox: [44.1, 8.1, 44.5, 8.6] },

  // TRENTINO-ALTO ADIGE
  { name: 'Bolzano', code: 'BZ', region: 'Trentino-Alto Adige', bbox: [46.2, 10.5, 47.1, 12.5] },
  { name: 'Trento', code: 'TN', region: 'Trentino-Alto Adige', bbox: [45.7, 10.5, 46.5, 11.8] },

  // FRIULI-VENEZIA GIULIA
  { name: 'Gorizia', code: 'GO', region: 'Friuli-Venezia Giulia', bbox: [45.8, 13.4, 46.0, 13.8] },
  { name: 'Pordenone', code: 'PN', region: 'Friuli-Venezia Giulia', bbox: [45.8, 12.5, 46.3, 13.0] },
  { name: 'Trieste', code: 'TS', region: 'Friuli-Venezia Giulia', bbox: [45.5, 13.6, 45.8, 13.9] },
  { name: 'Udine', code: 'UD', region: 'Friuli-Venezia Giulia', bbox: [45.9, 12.9, 46.6, 13.5] },

  // MARCHE
  { name: 'Ancona', code: 'AN', region: 'Marche', bbox: [43.3, 13.0, 43.8, 13.6] },
  { name: 'Ascoli Piceno', code: 'AP', region: 'Marche', bbox: [42.7, 13.4, 43.1, 13.8] },
  { name: 'Fermo', code: 'FM', region: 'Marche', bbox: [43.0, 13.4, 43.3, 13.8] },
  { name: 'Macerata', code: 'MC', region: 'Marche', bbox: [43.0, 13.0, 43.5, 13.6] },
  { name: 'Pesaro e Urbino', code: 'PU', region: 'Marche', bbox: [43.5, 12.5, 43.9, 13.0] },

  // UMBRIA
  { name: 'Perugia', code: 'PG', region: 'Umbria', bbox: [42.7, 11.9, 43.3, 12.9] },
  { name: 'Terni', code: 'TR', region: 'Umbria', bbox: [42.4, 12.3, 42.8, 12.8] },

  // ABRUZZO
  { name: 'Chieti', code: 'CH', region: 'Abruzzo', bbox: [41.8, 14.0, 42.3, 14.6] },
  { name: 'L\'Aquila', code: 'AQ', region: 'Abruzzo', bbox: [41.9, 13.0, 42.5, 14.0] },
  { name: 'Pescara', code: 'PE', region: 'Abruzzo', bbox: [42.2, 13.8, 42.6, 14.3] },
  { name: 'Teramo', code: 'TE', region: 'Abruzzo', bbox: [42.5, 13.5, 42.9, 13.9] },

  // MOLISE
  { name: 'Campobasso', code: 'CB', region: 'Molise', bbox: [41.4, 14.3, 42.0, 15.0] },
  { name: 'Isernia', code: 'IS', region: 'Molise', bbox: [41.5, 13.8, 41.8, 14.4] },

  // CAMPANIA
  { name: 'Avellino', code: 'AV', region: 'Campania', bbox: [40.7, 14.7, 41.2, 15.2] },
  { name: 'Benevento', code: 'BN', region: 'Campania', bbox: [41.0, 14.5, 41.4, 15.0] },
  { name: 'Caserta', code: 'CE', region: 'Campania', bbox: [40.9, 13.9, 41.4, 14.6] },
  { name: 'Napoli', code: 'NA', region: 'Campania', bbox: [40.6, 14.0, 41.0, 14.6] },
  { name: 'Salerno', code: 'SA', region: 'Campania', bbox: [40.2, 14.5, 40.8, 15.5] },

  // PUGLIA
  { name: 'Bari', code: 'BA', region: 'Puglia', bbox: [40.7, 16.4, 41.2, 17.2] },
  { name: 'Barletta-Andria-Trani', code: 'BT', region: 'Puglia', bbox: [41.1, 16.0, 41.4, 16.4] },
  { name: 'Brindisi', code: 'BR', region: 'Puglia', bbox: [40.4, 17.5, 40.8, 18.1] },
  { name: 'Foggia', code: 'FG', region: 'Puglia', bbox: [41.2, 15.0, 41.9, 16.2] },
  { name: 'Lecce', code: 'LE', region: 'Puglia', bbox: [39.9, 17.9, 40.5, 18.6] },
  { name: 'Taranto', code: 'TA', region: 'Puglia', bbox: [40.3, 17.0, 40.7, 17.6] },

  // BASILICATA
  { name: 'Matera', code: 'MT', region: 'Basilicata', bbox: [40.3, 16.2, 40.8, 16.9] },
  { name: 'Potenza', code: 'PZ', region: 'Basilicata', bbox: [40.2, 15.4, 40.9, 16.2] },

  // CALABRIA
  { name: 'Catanzaro', code: 'CZ', region: 'Calabria', bbox: [38.7, 16.3, 39.1, 16.7] },
  { name: 'Cosenza', code: 'CS', region: 'Calabria', bbox: [39.1, 15.8, 39.8, 16.5] },
  { name: 'Crotone', code: 'KR', region: 'Calabria', bbox: [38.9, 16.9, 39.3, 17.3] },
  { name: 'Reggio Calabria', code: 'RC', region: 'Calabria', bbox: [37.9, 15.6, 38.3, 16.2] },
  { name: 'Vibo Valentia', code: 'VV', region: 'Calabria', bbox: [38.5, 16.0, 38.8, 16.3] },

  // SICILIA
  { name: 'Agrigento', code: 'AG', region: 'Sicilia', bbox: [37.1, 13.3, 37.5, 13.9] },
  { name: 'Caltanissetta', code: 'CL', region: 'Sicilia', bbox: [37.2, 13.9, 37.6, 14.5] },
  { name: 'Catania', code: 'CT', region: 'Sicilia', bbox: [37.3, 14.8, 37.8, 15.3] },
  { name: 'Enna', code: 'EN', region: 'Sicilia', bbox: [37.3, 14.1, 37.7, 14.7] },
  { name: 'Messina', code: 'ME', region: 'Sicilia', bbox: [37.8, 14.8, 38.4, 15.7] },
  { name: 'Palermo', code: 'PA', region: 'Sicilia', bbox: [37.7, 13.2, 38.2, 13.9] },
  { name: 'Ragusa', code: 'RG', region: 'Sicilia', bbox: [36.7, 14.4, 37.1, 14.9] },
  { name: 'Siracusa', code: 'SR', region: 'Sicilia', bbox: [36.9, 14.9, 37.3, 15.4] },
  { name: 'Trapani', code: 'TP', region: 'Sicilia', bbox: [37.6, 12.3, 38.2, 12.9] },

  // SARDEGNA
  { name: 'Cagliari', code: 'CA', region: 'Sardegna', bbox: [38.9, 8.9, 39.5, 9.5] },
  { name: 'Nuoro', code: 'NU', region: 'Sardegna', bbox: [39.8, 8.9, 40.5, 9.7] },
  { name: 'Oristano', code: 'OR', region: 'Sardegna', bbox: [39.7, 8.4, 40.2, 9.0] },
  { name: 'Sassari', code: 'SS', region: 'Sardegna', bbox: [40.5, 8.3, 41.0, 9.2] },
  { name: 'Sud Sardegna', code: 'SU', region: 'Sardegna', bbox: [38.9, 8.4, 39.5, 9.3] },
];

// 🏷️ CATEGORIE FOCUS su PROFESSIONISTI e ARTIGIANI per piccole città
const PROFESSIONAL_CATEGORIES = [
  // PROFESSIONISTI SANITARI
  { osm: 'amenity=dentist', db: 'Dentisti' },
  { osm: 'amenity=doctors', db: 'Medici' },
  { osm: 'amenity=pharmacy', db: 'Farmacie' },
  { osm: 'amenity=veterinary', db: 'Veterinari' },
  { osm: 'healthcare=physiotherapist', db: 'Fisioterapisti' },
  { osm: 'healthcare=psychotherapist', db: 'Psicologi' },
  { osm: 'healthcare=podiatrist', db: 'Podologi' },
  { osm: 'healthcare=speech_therapist', db: 'Logopedisti' },
  { osm: 'healthcare=optometrist', db: 'Optometristi' },
  { osm: 'healthcare=midwife', db: 'Ostetriche' },

  // PROFESSIONISTI E STUDI
  { osm: 'office=lawyer', db: 'Avvocati' },
  { osm: 'office=accountant', db: 'Commercialisti' },
  { osm: 'office=tax_advisor', db: 'Consulenti Fiscali' },
  { osm: 'office=architect', db: 'Architetti' },
  { osm: 'office=engineer', db: 'Ingegneri' },
  { osm: 'office=surveyor', db: 'Geometri' },
  { osm: 'office=estate_agent', db: 'Agenzie Immobiliari' },
  { osm: 'office=insurance', db: 'Assicurazioni' },
  { osm: 'office=notary', db: 'Notai' },
  { osm: 'office=photographer', db: 'Fotografi' },

  // ARTIGIANI
  { osm: 'craft=carpenter', db: 'Falegnami' },
  { osm: 'craft=electrician', db: 'Elettricisti' },
  { osm: 'craft=plumber', db: 'Idraulici' },
  { osm: 'craft=painter', db: 'Imbianchini' },
  { osm: 'craft=shoemaker', db: 'Calzolai' },
  { osm: 'craft=tailor', db: 'Sarti' },
  { osm: 'craft=metal_construction', db: 'Fabbri' },
  { osm: 'craft=locksmith', db: 'Fabbri' },
  { osm: 'craft=hvac', db: 'Climatizzazione' },
  { osm: 'craft=glaziery', db: 'Vetrai' },
  { osm: 'craft=gardener', db: 'Giardinieri' },
  { osm: 'craft=roofer', db: 'Lattonieri' },
  { osm: 'craft=window_construction', db: 'Serramenti' },
  { osm: 'craft=tiler', db: 'Piastrellisti' },
  { osm: 'craft=jeweller', db: 'Orefici' },
  { osm: 'craft=watchmaker', db: 'Orologiai' },
  { osm: 'craft=optician', db: 'Ottici' },

  // NEGOZI ESSENZIALI
  { osm: 'shop=supermarket', db: 'Supermercati' },
  { osm: 'shop=convenience', db: 'Alimentari' },
  { osm: 'shop=bakery', db: 'Panifici e Pasticcerie' },
  { osm: 'shop=butcher', db: 'Macellerie' },
  { osm: 'shop=greengrocer', db: 'Frutta e Verdura' },
  { osm: 'shop=hardware', db: 'Ferramenta' },
  { osm: 'shop=hairdresser', db: 'Parrucchieri e Barbieri' },
  { osm: 'shop=beauty', db: 'Centri Estetici' },
  { osm: 'shop=florist', db: 'Fioristi' },
  { osm: 'shop=car_repair', db: 'Autofficine' },
  { osm: 'shop=bicycle', db: 'Negozi di Biciclette' },

  // SERVIZI
  { osm: 'amenity=bank', db: 'Banche' },
  { osm: 'amenity=post_office', db: 'Uffici Postali' },
  { osm: 'amenity=fuel', db: 'Benzinai' },
  { osm: 'amenity=restaurant', db: 'Ristoranti' },
  { osm: 'amenity=cafe', db: 'Bar e Caffè' },
  { osm: 'amenity=bar', db: 'Bar e Caffè' },
];

const categoryCache = {};
let stats = {
  totalProcessed: 0,
  totalImported: 0,
  byProvince: {},
  byRegion: {},
  byCategory: {},
  errors: 0,
  skippedProvinces: 0,
};

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
    [out:json][timeout:180];
    (
      node[${osmTag}](${bboxStr});
      way[${osmTag}](${bboxStr});
      relation[${osmTag}](${bboxStr});
    );
    out center;
  `;

  let retries = 0;
  const maxRetries = 3;

  while (retries < maxRetries) {
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        body: query,
        headers: { 'Content-Type': 'text/plain' },
        signal: AbortSignal.timeout(90000)
      });

      if (!response.ok) {
        if (response.status === 429) {
          console.log('   ⏳ Rate limit, attendo 90 secondi...');
          await sleep(90000);
          return queryOverpass(bbox, osmTag);
        }
        if (response.status === 504) {
          throw new Error('Gateway timeout');
        }
        if (response.status >= 500) {
          throw new Error(`Server error: ${response.status}`);
        }
        return [];
      }

      const data = await response.json();
      return data.elements || [];
    } catch (error) {
      retries++;
      if (retries < maxRetries) {
        const waitTime = retries * 20000;
        console.log(`   ⚠️  Errore (${retries}/${maxRetries}): ${error.message}`);
        console.log(`   ⏳ Riprovo tra ${waitTime/1000}s...`);
        await sleep(waitTime);
      } else {
        console.log(`   ⏹️  Saltata dopo ${maxRetries} tentativi`);
        return [];
      }
    }
  }

  return [];
}

function extractData(element, provinceData) {
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
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || '';
  const postcode = tags['addr:postcode'] || '';

  let address = '';
  if (street && houseNumber) {
    address = `${street}, ${houseNumber}`;
  } else if (street) {
    address = street;
  } else if (city) {
    address = city;
  }

  return {
    name,
    address,
    city: city || provinceData.name,
    province: provinceData.code,
    region: provinceData.region,
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
    business_hours: tags.opening_hours || null,
  };
}

async function importProvince(provinceData, provinceIndex, totalProvinces) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 PROVINCIA [${provinceIndex}/${totalProvinces}]: ${provinceData.name} (${provinceData.region})`);
  console.log('='.repeat(70));

  let provinceTotal = 0;
  let categoryCount = 0;
  let skippedCategories = 0;

  for (const category of PROFESSIONAL_CATEGORIES) {
    categoryCount++;
    process.stdout.write(`   [${categoryCount}/${PROFESSIONAL_CATEGORIES.length}] ${category.db.padEnd(35)} `);

    try {
      const categoryId = await getCategoryId(category.db);
      if (!categoryId) {
        console.log('⚠️  cat. non trovata - SKIP');
        skippedCategories++;
        await sleep(1000);
        continue;
      }

      const elements = await queryOverpass(provinceData.bbox, category.osm);

      if (elements.length === 0) {
        console.log('⚪ 0');
        await sleep(3000);
        continue;
      }

      let imported = 0;
      for (const element of elements) {
        const businessData = extractData(element, provinceData);
        if (!businessData) continue;

        try {
          const { data: existing } = await supabase
            .from('unclaimed_business_locations')
            .select('id')
            .eq('name', businessData.name)
            .eq('city', businessData.city)
            .eq('address', businessData.address)
            .maybeSingle();

          if (existing) continue;

          const { error } = await supabase
            .from('unclaimed_business_locations')
            .insert({
              category_id: categoryId,
              name: businessData.name,
              address: businessData.address,
              city: businessData.city,
              province: businessData.province,
              region: businessData.region,
              postal_code: businessData.postal_code,
              country: 'Italia',
              latitude: businessData.latitude,
              longitude: businessData.longitude,
              phone: businessData.phone,
              email: businessData.email,
              website: businessData.website,
              business_hours: businessData.business_hours,
              verified: true,
            });

          if (!error) {
            imported++;
            stats.totalImported++;
            stats.byCategory[category.db] = (stats.byCategory[category.db] || 0) + 1;
            stats.byRegion[provinceData.region] = (stats.byRegion[provinceData.region] || 0) + 1;
            stats.byProvince[provinceData.name] = (stats.byProvince[provinceData.name] || 0) + 1;
          } else {
            stats.errors++;
          }
        } catch (error) {
          stats.errors++;
        }
      }

      if (imported > 0) {
        console.log(`✅ ${imported}`);
      } else {
        console.log(`⚪ 0`);
      }

      provinceTotal += imported;
      stats.totalProcessed += elements.length;

      await sleep(4000);
    } catch (error) {
      console.log(`❌ Errore - SKIP`);
      skippedCategories++;
      stats.errors++;
      await sleep(5000);
      continue;
    }
  }

  console.log(`\n   🎯 TOTALE ${provinceData.name}: ${provinceTotal} attività`);
  if (skippedCategories > 0) {
    console.log(`   ⚠️  Categorie saltate: ${skippedCategories}`);
  }
  console.log(`   📊 Totale complessivo: ${stats.totalImported.toLocaleString()}\n`);

  return provinceTotal;
}

function printProgressSummary() {
  console.log('\n' + '='.repeat(70));
  console.log('📊 RIEPILOGO PROGRESSIVO');
  console.log('='.repeat(70));
  console.log(`Totale importate: ${stats.totalImported.toLocaleString()}`);
  console.log(`Errori: ${stats.errors}`);

  console.log(`\n🏆 Top 15 Province:`);
  Object.entries(stats.byProvince)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 15)
    .forEach(([prov, count], i) => {
      console.log(`   ${(i+1).toString().padStart(2)}. ${prov.padEnd(30)} ${count.toLocaleString()}`);
    });

  console.log(`\n🗺️  Per Regione:`);
  Object.entries(stats.byRegion)
    .sort(([,a], [,b]) => b - a)
    .forEach(([reg, count]) => {
      console.log(`   ${reg.padEnd(30)} ${count.toLocaleString()}`);
    });

  console.log(`\n📊 Top 10 Categorie:`);
  Object.entries(stats.byCategory)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 10)
    .forEach(([cat, count], i) => {
      console.log(`   ${(i+1).toString().padStart(2)}. ${cat.padEnd(30)} ${count.toLocaleString()}`);
    });

  console.log('');
}

async function main() {
  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' IMPORTAZIONE PROFESSIONISTI - PICCOLE CITTÀ (<10k ab.)'.padEnd(68) + '║');
  console.log('║' + ' '.repeat(68) + '║');
  console.log('║' + ` Totale province: ${ITALIAN_PROVINCES.length}`.padEnd(68) + '║');
  console.log('║' + ` Totale categorie: ${PROFESSIONAL_CATEGORIES.length}`.padEnd(68) + '║');
  console.log('║' + ' Focus: Professionisti, Artigiani, Servizi essenziali'.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  let grandTotal = 0;
  let provinceCount = 0;

  const totalProvinces = ITALIAN_PROVINCES.length;

  for (const provinceData of ITALIAN_PROVINCES) {
    try {
      provinceCount++;
      const count = await importProvince(provinceData, provinceCount, totalProvinces);
      grandTotal += count;

      if (provinceCount % 5 === 0) {
        printProgressSummary();
      }

      console.log(`⏳ Pausa 10 secondi... (${provinceCount}/${totalProvinces})\n`);
      await sleep(10000);

    } catch (error) {
      console.error(`\n❌ ERRORE in ${provinceData.name}:`, error.message);
      console.error(`   Provincia SALTATA - continuo...\n`);
      stats.errors++;
      stats.skippedProvinces++;
      stats.byProvince[provinceData.name] = 0;
      await sleep(10000);
    }
  }

  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' ✅ IMPORTAZIONE COMPLETATA '.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  printProgressSummary();

  console.log('\n' + '='.repeat(70));
  console.log('🎉 STATISTICHE FINALI');
  console.log('='.repeat(70));
  console.log(`Province processate: ${provinceCount}/${totalProvinces}`);
  console.log(`Province completate: ${provinceCount - stats.skippedProvinces}`);
  console.log(`Province saltate: ${stats.skippedProvinces}`);
  console.log(`Totale attività importate: ${grandTotal.toLocaleString()}`);
  console.log(`Errori totali: ${stats.errors}`);
  console.log('='.repeat(70) + '\n');
}

main().catch(console.error);
