import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Mappa le categorie OSM alle nostre categorie del database
const categoryMapping = {
  // Ristorazione
  'restaurant': 'Ristoranti',
  'cafe': 'Bar e Caffè',
  'bar': 'Bar e Caffè',
  'fast_food': 'Fast Food',
  'pub': 'Pub e Locali',
  'ice_cream': 'Gelaterie',
  'bakery': 'Panifici e Pasticcerie',
  'pizza': 'Pizzerie',

  // Negozi
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

  // Servizi professionali
  'dentist': 'Dentisti',
  'doctor': 'Medici',
  'veterinary': 'Veterinari',
  'lawyer': 'Studi Legali',
  'accountant': 'Commercialisti',
  'architect': 'Architetti',
  'estate_agent': 'Agenzie Immobiliari',
  'insurance': 'Assicurazioni',
  'bank': 'Banche',
  'post_office': 'Uffici Postali',

  // Servizi
  'hotel': 'Hotel',
  'guest_house': 'B&B',
  'gym': 'Palestre',
  'car_wash': 'Autolavaggi',
  'fuel': 'Stazioni di Servizio',
  'parking': 'Parcheggi',
};

// Province italiane con le loro regioni
const italianProvinces = {
  // Lombardia
  'Milano': { region: 'Lombardia', code: 'MI' },
  'Bergamo': { region: 'Lombardia', code: 'BG' },
  'Brescia': { region: 'Lombardia', code: 'BS' },
  'Como': { region: 'Lombardia', code: 'CO' },
  'Cremona': { region: 'Lombardia', code: 'CR' },
  'Lecco': { region: 'Lombardia', code: 'LC' },
  'Lodi': { region: 'Lombardia', code: 'LO' },
  'Mantova': { region: 'Lombardia', code: 'MN' },
  'Monza e della Brianza': { region: 'Lombardia', code: 'MB' },
  'Pavia': { region: 'Lombardia', code: 'PV' },
  'Sondrio': { region: 'Lombardia', code: 'SO' },
  'Varese': { region: 'Lombardia', code: 'VA' },

  // Lazio
  'Roma': { region: 'Lazio', code: 'RM' },
  'Frosinone': { region: 'Lazio', code: 'FR' },
  'Latina': { region: 'Lazio', code: 'LT' },
  'Rieti': { region: 'Lazio', code: 'RI' },
  'Viterbo': { region: 'Lazio', code: 'VT' },

  // Campania
  'Napoli': { region: 'Campania', code: 'NA' },
  'Avellino': { region: 'Campania', code: 'AV' },
  'Benevento': { region: 'Campania', code: 'BN' },
  'Caserta': { region: 'Campania', code: 'CE' },
  'Salerno': { region: 'Campania', code: 'SA' },

  // Sicilia
  'Palermo': { region: 'Sicilia', code: 'PA' },
  'Catania': { region: 'Sicilia', code: 'CT' },
  'Messina': { region: 'Sicilia', code: 'ME' },
  'Siracusa': { region: 'Sicilia', code: 'SR' },
  'Trapani': { region: 'Sicilia', code: 'TP' },
  'Agrigento': { region: 'Sicilia', code: 'AG' },
  'Caltanissetta': { region: 'Sicilia', code: 'CL' },
  'Enna': { region: 'Sicilia', code: 'EN' },
  'Ragusa': { region: 'Sicilia', code: 'RG' },

  // Veneto
  'Venezia': { region: 'Veneto', code: 'VE' },
  'Verona': { region: 'Veneto', code: 'VR' },
  'Padova': { region: 'Veneto', code: 'PD' },
  'Vicenza': { region: 'Veneto', code: 'VI' },
  'Treviso': { region: 'Veneto', code: 'TV' },
  'Rovigo': { region: 'Veneto', code: 'RO' },
  'Belluno': { region: 'Veneto', code: 'BL' },

  // Piemonte
  'Torino': { region: 'Piemonte', code: 'TO' },
  'Alessandria': { region: 'Piemonte', code: 'AL' },
  'Asti': { region: 'Piemonte', code: 'AT' },
  'Biella': { region: 'Piemonte', code: 'BI' },
  'Cuneo': { region: 'Piemonte', code: 'CN' },
  'Novara': { region: 'Piemonte', code: 'NO' },
  'Verbano-Cusio-Ossola': { region: 'Piemonte', code: 'VB' },
  'Vercelli': { region: 'Piemonte', code: 'VC' },

  // Emilia-Romagna
  'Bologna': { region: 'Emilia-Romagna', code: 'BO' },
  'Ferrara': { region: 'Emilia-Romagna', code: 'FE' },
  'Forlì-Cesena': { region: 'Emilia-Romagna', code: 'FC' },
  'Modena': { region: 'Emilia-Romagna', code: 'MO' },
  'Parma': { region: 'Emilia-Romagna', code: 'PR' },
  'Piacenza': { region: 'Emilia-Romagna', code: 'PC' },
  'Ravenna': { region: 'Emilia-Romagna', code: 'RA' },
  'Reggio Emilia': { region: 'Emilia-Romagna', code: 'RE' },
  'Rimini': { region: 'Emilia-Romagna', code: 'RN' },

  // Toscana
  'Firenze': { region: 'Toscana', code: 'FI' },
  'Arezzo': { region: 'Toscana', code: 'AR' },
  'Grosseto': { region: 'Toscana', code: 'GR' },
  'Livorno': { region: 'Toscana', code: 'LI' },
  'Lucca': { region: 'Toscana', code: 'LU' },
  'Massa-Carrara': { region: 'Toscana', code: 'MS' },
  'Pisa': { region: 'Toscana', code: 'PI' },
  'Pistoia': { region: 'Toscana', code: 'PT' },
  'Prato': { region: 'Toscana', code: 'PO' },
  'Siena': { region: 'Toscana', code: 'SI' },
};

async function queryOverpass(query) {
  const overpassUrl = 'https://overpass-api.de/api/interpreter';

  try {
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
    return data.elements || [];
  } catch (error) {
    console.error('Error querying Overpass:', error);
    return [];
  }
}

function buildOverpassQuery(province, category) {
  const provinceData = italianProvinces[province];
  if (!provinceData) return null;

  // Query Overpass per una specifica area e categoria
  return `
    [out:json][timeout:90];
    area["name"="${province}"]["admin_level"="6"]->.searchArea;
    (
      node["shop"="${category}"](area.searchArea);
      way["shop"="${category}"](area.searchArea);
      node["amenity"="${category}"](area.searchArea);
      way["amenity"="${category}"](area.searchArea);
      node["craft"="${category}"](area.searchArea);
      way["craft"="${category}"](area.searchArea);
      node["office"="${category}"](area.searchArea);
      way["office"="${category}"](area.searchArea);
    );
    out center tags;
  `;
}

function extractBusinessData(element, province, category) {
  const tags = element.tags || {};
  const provinceData = italianProvinces[province];

  // Ottieni le coordinate
  const lat = element.lat || element.center?.lat;
  const lon = element.lon || element.center?.lon;

  if (!lat || !lon) return null;

  const name = tags.name || tags['name:it'] || tags.operator;
  if (!name) return null;

  // Estrai indirizzo
  const street = tags['addr:street'] || '';
  const houseNumber = tags['addr:housenumber'] || '';
  const city = tags['addr:city'] || province;
  const postcode = tags['addr:postcode'] || '';

  const address = `${street} ${houseNumber}`.trim();

  // Estrai altri dati
  const phone = tags.phone || tags['contact:phone'] || '';
  const website = tags.website || tags['contact:website'] || '';
  const email = tags.email || tags['contact:email'] || '';

  // Orari di apertura
  const openingHours = tags.opening_hours || '';

  return {
    name,
    description: tags.description || `${categoryMapping[category] || category} a ${city}`,
    category: categoryMapping[category] || 'Altri Servizi',
    address,
    city,
    province,
    region: provinceData.region,
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone: phone.replace(/\s+/g, ''),
    website,
    email,
    opening_hours: openingHours,
    verified: true,
    is_claimed: false,
    osm_id: `${element.type}/${element.id}`
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

async function importBusinessesFromProvince(province, categories) {
  console.log(`\n=== Importazione per ${province} ===`);

  const allBusinesses = [];

  for (const category of categories) {
    console.log(`Cercando: ${category} in ${province}...`);

    const query = buildOverpassQuery(province, category);
    if (!query) continue;

    // Aggiungi un delay per non sovraccaricare l'API
    await new Promise(resolve => setTimeout(resolve, 2000));

    const elements = await queryOverpass(query);
    console.log(`  Trovati ${elements.length} risultati`);

    for (const element of elements) {
      const businessData = extractBusinessData(element, province, category);
      if (businessData) {
        allBusinesses.push(businessData);
      }
    }
  }

  console.log(`\nTotale attività estratte per ${province}: ${allBusinesses.length}`);

  // Inserisci nel database
  if (allBusinesses.length > 0) {
    console.log(`Inserimento nel database...`);

    for (const business of allBusinesses) {
      try {
        // Verifica se esiste già (per OSM ID)
        const { data: existing } = await supabase
          .from('businesses')
          .select('id')
          .eq('name', business.name)
          .eq('address', business.address)
          .maybeSingle();

        if (existing) {
          console.log(`  Già esistente: ${business.name}`);
          continue;
        }

        // Ottieni category_id
        const categoryId = await getCategoryId(business.category);

        // Inserisci business
        const { data: newBusiness, error: businessError } = await supabase
          .from('businesses')
          .insert({
            name: business.name,
            description: business.description,
            category_id: categoryId,
            verified: business.verified,
            is_claimed: business.is_claimed
          })
          .select()
          .single();

        if (businessError) {
          console.error(`  Errore inserimento ${business.name}:`, businessError.message);
          continue;
        }

        // Inserisci location
        const { error: locationError } = await supabase
          .from('business_locations')
          .insert({
            business_id: newBusiness.id,
            address: business.address,
            city: business.city,
            province: business.province,
            region: business.region,
            postal_code: business.postal_code,
            country: 'Italia',
            latitude: business.latitude,
            longitude: business.longitude,
            phone: business.phone,
            website: business.website,
            email: business.email,
            business_hours: business.opening_hours || null
          });

        if (locationError) {
          console.error(`  Errore inserimento location per ${business.name}:`, locationError.message);
        } else {
          console.log(`  ✓ ${business.name}`);
        }
      } catch (error) {
        console.error(`  Errore per ${business.name}:`, error.message);
      }
    }
  }

  return allBusinesses.length;
}

async function main() {
  console.log('=== IMPORTAZIONE DA OPENSTREETMAP ===\n');

  // Categorie da importare (chiavi OSM)
  const categories = [
    // Shop
    'supermarket', 'convenience', 'clothes', 'hairdresser', 'beauty',
    'florist', 'butcher', 'greengrocer', 'pharmacy', 'bookshop',
    'jewelry', 'electronics', 'furniture', 'hardware', 'bicycle',
    'bakery',

    // Amenity
    'restaurant', 'cafe', 'bar', 'fast_food', 'pub', 'ice_cream',
    'bank', 'post_office', 'fuel', 'parking', 'car_wash',
    'dentist', 'doctor', 'veterinary', 'pharmacy',

    // Office
    'lawyer', 'accountant', 'architect', 'estate_agent', 'insurance',

    // Tourism
    'hotel', 'guest_house',

    // Leisure
    'gym',

    // Craft/Services
    'car_repair'
  ];

  // Puoi scegliere le province da importare
  // Esempio: importa solo alcune province
  const provincesToImport = [
    'Varese',
    'Milano',
    'Roma',
    'Napoli',
    'Torino',
    'Firenze',
    'Bologna',
    'Venezia',
    'Palermo'
  ];

  let totalImported = 0;

  for (const province of provincesToImport) {
    const count = await importBusinessesFromProvince(province, categories);
    totalImported += count;

    // Pausa tra province per non sovraccaricare l'API
    console.log('\nPausa 5 secondi prima della prossima provincia...');
    await new Promise(resolve => setTimeout(resolve, 5000));
  }

  console.log(`\n\n=== IMPORTAZIONE COMPLETATA ===`);
  console.log(`Totale attività estratte: ${totalImported}`);
}

main().catch(console.error);
