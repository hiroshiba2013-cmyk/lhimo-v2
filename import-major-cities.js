import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fetch from 'node-fetch';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const CITIES_20K_PLUS = [
  // Lombardia
  { name: 'Milano', region: 'Lombardia', province: 'MI', population: 1396000 },
  { name: 'Brescia', region: 'Lombardia', province: 'BS', population: 197000 },
  { name: 'Monza', region: 'Lombardia', province: 'MB', population: 124000 },
  { name: 'Bergamo', region: 'Lombardia', province: 'BG', population: 121000 },
  { name: 'Como', region: 'Lombardia', province: 'CO', population: 84000 },
  { name: 'Varese', region: 'Lombardia', province: 'VA', population: 80000 },
  { name: 'Busto Arsizio', region: 'Lombardia', province: 'VA', population: 83000 },
  { name: 'Pavia', region: 'Lombardia', province: 'PV', population: 73000 },
  { name: 'Cremona', region: 'Lombardia', province: 'CR', population: 72000 },
  { name: 'Mantova', region: 'Lombardia', province: 'MN', population: 49000 },
  { name: 'Lecco', region: 'Lombardia', province: 'LC', population: 48000 },
  { name: 'Rho', region: 'Lombardia', province: 'MI', population: 51000 },
  { name: 'Sesto San Giovanni', region: 'Lombardia', province: 'MI', population: 82000 },
  { name: 'Cinisello Balsamo', region: 'Lombardia', province: 'MI', population: 76000 },
  { name: 'Legnano', region: 'Lombardia', province: 'MI', population: 60000 },
  { name: 'Vigevano', region: 'Lombardia', province: 'PV', population: 63000 },
  { name: 'Desio', region: 'Lombardia', province: 'MB', population: 42000 },
  { name: 'Lodi', region: 'Lombardia', province: 'LO', population: 45000 },

  // Lazio
  { name: 'Roma', region: 'Lazio', province: 'RM', population: 2873000 },
  { name: 'Latina', region: 'Lazio', province: 'LT', population: 126000 },
  { name: 'Guidonia Montecelio', region: 'Lazio', province: 'RM', population: 88000 },
  { name: 'Fiumicino', region: 'Lazio', province: 'RM', population: 79000 },
  { name: 'Aprilia', region: 'Lazio', province: 'LT', population: 74000 },
  { name: 'Pomezia', region: 'Lazio', province: 'RM', population: 63000 },
  { name: 'Anzio', region: 'Lazio', province: 'RM', population: 54000 },
  { name: 'Tivoli', region: 'Lazio', province: 'RM', population: 57000 },
  { name: 'Velletri', region: 'Lazio', province: 'RM', population: 53000 },
  { name: 'Civitavecchia', region: 'Lazio', province: 'RM', population: 52000 },
  { name: 'Viterbo', region: 'Lazio', province: 'VT', population: 67000 },
  { name: 'Frosinone', region: 'Lazio', province: 'FR', population: 46000 },
  { name: 'Nettuno', region: 'Lazio', province: 'RM', population: 49000 },

  // Campania
  { name: 'Napoli', region: 'Campania', province: 'NA', population: 967000 },
  { name: 'Salerno', region: 'Campania', province: 'SA', population: 133000 },
  { name: 'Giugliano in Campania', region: 'Campania', province: 'NA', population: 124000 },
  { name: 'Torre del Greco', region: 'Campania', province: 'NA', population: 86000 },
  { name: 'Pozzuoli', region: 'Campania', province: 'NA', population: 81000 },
  { name: 'Caserta', region: 'Campania', province: 'CE', population: 76000 },
  { name: 'Castellammare di Stabia', region: 'Campania', province: 'NA', population: 65000 },
  { name: 'Casoria', region: 'Campania', province: 'NA', population: 78000 },
  { name: 'Afragola', region: 'Campania', province: 'NA', population: 64000 },
  { name: 'Aversa', region: 'Campania', province: 'CE', population: 53000 },
  { name: 'Marano di Napoli', region: 'Campania', province: 'NA', population: 60000 },
  { name: 'Benevento', region: 'Campania', province: 'BN', population: 60000 },
  { name: 'Cava de\' Tirreni', region: 'Campania', province: 'SA', population: 53000 },
  { name: 'Portici', region: 'Campania', province: 'NA', population: 55000 },
  { name: 'Acerra', region: 'Campania', province: 'NA', population: 59000 },
  { name: 'Ercolano', region: 'Campania', province: 'NA', population: 54000 },

  // Sicilia
  { name: 'Palermo', region: 'Sicilia', province: 'PA', population: 676000 },
  { name: 'Catania', region: 'Sicilia', province: 'CT', population: 311000 },
  { name: 'Messina', region: 'Sicilia', province: 'ME', population: 238000 },
  { name: 'Siracusa', region: 'Sicilia', province: 'SR', population: 122000 },
  { name: 'Marsala', region: 'Sicilia', province: 'TP', population: 82000 },
  { name: 'Gela', region: 'Sicilia', province: 'CL', population: 77000 },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', population: 73000 },
  { name: 'Trapani', region: 'Sicilia', province: 'TP', population: 69000 },
  { name: 'Vittoria', region: 'Sicilia', province: 'RG', population: 64000 },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', population: 62000 },
  { name: 'Agrigento', region: 'Sicilia', province: 'AG', population: 59000 },
  { name: 'Bagheria', region: 'Sicilia', province: 'PA', population: 55000 },
  { name: 'Modica', region: 'Sicilia', province: 'RG', population: 54000 },
  { name: 'Acireale', region: 'Sicilia', province: 'CT', population: 52000 },
  { name: 'Mazara del Vallo', region: 'Sicilia', province: 'TP', population: 51000 },

  // Veneto
  { name: 'Verona', region: 'Veneto', province: 'VR', population: 258000 },
  { name: 'Padova', region: 'Veneto', province: 'PD', population: 210000 },
  { name: 'Vicenza', region: 'Veneto', province: 'VI', population: 112000 },
  { name: 'Treviso', region: 'Veneto', province: 'TV', population: 84000 },
  { name: 'Venezia', region: 'Veneto', province: 'VE', population: 261000 },
  { name: 'Rovigo', region: 'Veneto', province: 'RO', population: 51000 },
  { name: 'Belluno', region: 'Veneto', province: 'BL', population: 36000 },
  { name: 'Chioggia', region: 'Veneto', province: 'VE', population: 50000 },
  { name: 'Bassano del Grappa', region: 'Veneto', province: 'VI', population: 43000 },
  { name: 'San Donà di Piave', region: 'Veneto', province: 'VE', population: 42000 },

  // Piemonte
  { name: 'Torino', region: 'Piemonte', province: 'TO', population: 886000 },
  { name: 'Novara', region: 'Piemonte', province: 'NO', population: 104000 },
  { name: 'Alessandria', region: 'Piemonte', province: 'AL', population: 93000 },
  { name: 'Asti', region: 'Piemonte', province: 'AT', population: 76000 },
  { name: 'Moncalieri', region: 'Piemonte', province: 'TO', population: 57000 },
  { name: 'Cuneo', region: 'Piemonte', province: 'CN', population: 56000 },
  { name: 'Rivoli', region: 'Piemonte', province: 'TO', population: 49000 },
  { name: 'Collegno', region: 'Piemonte', province: 'TO', population: 50000 },
  { name: 'Casale Monferrato', region: 'Piemonte', province: 'AL', population: 34000 },
  { name: 'Biella', region: 'Piemonte', province: 'BI', population: 45000 },
  { name: 'Verbania', region: 'Piemonte', province: 'VB', population: 31000 },

  // Emilia-Romagna
  { name: 'Bologna', region: 'Emilia-Romagna', province: 'BO', population: 390000 },
  { name: 'Modena', region: 'Emilia-Romagna', province: 'MO', population: 185000 },
  { name: 'Parma', region: 'Emilia-Romagna', province: 'PR', population: 198000 },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'RE', population: 171000 },
  { name: 'Ravenna', region: 'Emilia-Romagna', province: 'RA', population: 159000 },
  { name: 'Ferrara', region: 'Emilia-Romagna', province: 'FE', population: 133000 },
  { name: 'Rimini', region: 'Emilia-Romagna', province: 'RN', population: 149000 },
  { name: 'Forlì', region: 'Emilia-Romagna', province: 'FC', population: 118000 },
  { name: 'Piacenza', region: 'Emilia-Romagna', province: 'PC', population: 104000 },
  { name: 'Cesena', region: 'Emilia-Romagna', province: 'FC', population: 97000 },
  { name: 'Carpi', region: 'Emilia-Romagna', province: 'MO', population: 71000 },
  { name: 'Imola', region: 'Emilia-Romagna', province: 'BO', population: 70000 },

  // Puglia
  { name: 'Bari', region: 'Puglia', province: 'BA', population: 326000 },
  { name: 'Taranto', region: 'Puglia', province: 'TA', population: 195000 },
  { name: 'Foggia', region: 'Puglia', province: 'FG', population: 153000 },
  { name: 'Lecce', region: 'Puglia', province: 'LE', population: 95000 },
  { name: 'Andria', region: 'Puglia', province: 'BT', population: 100000 },
  { name: 'Brindisi', region: 'Puglia', province: 'BR', population: 88000 },
  { name: 'Barletta', region: 'Puglia', province: 'BT', population: 94000 },
  { name: 'Altamura', region: 'Puglia', province: 'BA', population: 70000 },
  { name: 'Molfetta', region: 'Puglia', province: 'BA', population: 60000 },
  { name: 'Cerignola', region: 'Puglia', province: 'FG', population: 58000 },
  { name: 'Monopoli', region: 'Puglia', province: 'BA', population: 49000 },
  { name: 'Manfredonia', region: 'Puglia', province: 'FG', population: 57000 },
  { name: 'Trani', region: 'Puglia', province: 'BT', population: 56000 },

  // Toscana
  { name: 'Firenze', region: 'Toscana', province: 'FI', population: 382000 },
  { name: 'Prato', region: 'Toscana', province: 'PO', population: 195000 },
  { name: 'Livorno', region: 'Toscana', province: 'LI', population: 158000 },
  { name: 'Arezzo', region: 'Toscana', province: 'AR', population: 100000 },
  { name: 'Pisa', region: 'Toscana', province: 'PI', population: 91000 },
  { name: 'Pistoia', region: 'Toscana', province: 'PT', population: 90000 },
  { name: 'Lucca', region: 'Toscana', province: 'LU', population: 89000 },
  { name: 'Grosseto', region: 'Toscana', province: 'GR', population: 82000 },
  { name: 'Massa', region: 'Toscana', province: 'MS', population: 69000 },
  { name: 'Carrara', region: 'Toscana', province: 'MS', population: 64000 },
  { name: 'Siena', region: 'Toscana', province: 'SI', population: 54000 },
  { name: 'Viareggio', region: 'Toscana', province: 'LU', population: 62000 },
  { name: 'Scandicci', region: 'Toscana', province: 'FI', population: 50000 },
  { name: 'Empoli', region: 'Toscana', province: 'FI', population: 49000 },

  // Calabria
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', population: 182000 },
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', population: 91000 },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', population: 67000 },
  { name: 'Lamezia Terme', region: 'Calabria', province: 'CZ', population: 71000 },
  { name: 'Crotone', region: 'Calabria', province: 'KR', population: 65000 },
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', population: 34000 },
  { name: 'Rende', region: 'Calabria', province: 'CS', population: 35000 },

  // Sardegna
  { name: 'Cagliari', region: 'Sardegna', province: 'CA', population: 154000 },
  { name: 'Sassari', region: 'Sardegna', province: 'SS', population: 127000 },
  { name: 'Quartu Sant\'Elena', region: 'Sardegna', province: 'CA', population: 71000 },
  { name: 'Olbia', region: 'Sardegna', province: 'SS', population: 60000 },
  { name: 'Alghero', region: 'Sardegna', province: 'SS', population: 44000 },
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', population: 37000 },
  { name: 'Oristano', region: 'Sardegna', province: 'OR', population: 32000 },

  // Liguria
  { name: 'Genova', region: 'Liguria', province: 'GE', population: 583000 },
  { name: 'La Spezia', region: 'Liguria', province: 'SP', population: 94000 },
  { name: 'Savona', region: 'Liguria', province: 'SV', population: 61000 },
  { name: 'Sanremo', region: 'Liguria', province: 'IM', population: 55000 },
  { name: 'Imperia', region: 'Liguria', province: 'IM', population: 42000 },

  // Marche
  { name: 'Ancona', region: 'Marche', province: 'AN', population: 101000 },
  { name: 'Pesaro', region: 'Marche', province: 'PU', population: 95000 },
  { name: 'Ascoli Piceno', region: 'Marche', province: 'AP', population: 49000 },
  { name: 'Fano', region: 'Marche', province: 'PU', population: 61000 },
  { name: 'Macerata', region: 'Marche', province: 'MC', population: 42000 },

  // Abruzzo
  { name: 'Pescara', region: 'Abruzzo', province: 'PE', population: 120000 },
  { name: 'L\'Aquila', region: 'Abruzzo', province: 'AQ', population: 70000 },
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', population: 55000 },
  { name: 'Chieti', region: 'Abruzzo', province: 'CH', population: 52000 },
  { name: 'Montesilvano', region: 'Abruzzo', province: 'PE', population: 54000 },

  // Friuli-Venezia Giulia
  { name: 'Trieste', region: 'Friuli-Venezia Giulia', province: 'TS', population: 204000 },
  { name: 'Udine', region: 'Friuli-Venezia Giulia', province: 'UD', population: 100000 },
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', population: 51000 },
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', population: 35000 },

  // Trentino-Alto Adige
  { name: 'Trento', region: 'Trentino-Alto Adige', province: 'TN', population: 118000 },
  { name: 'Bolzano', region: 'Trentino-Alto Adige', province: 'BZ', population: 107000 },
  { name: 'Merano', region: 'Trentino-Alto Adige', province: 'BZ', population: 41000 },
  { name: 'Rovereto', region: 'Trentino-Alto Adige', province: 'TN', population: 40000 },

  // Umbria
  { name: 'Perugia', region: 'Umbria', province: 'PG', population: 166000 },
  { name: 'Terni', region: 'Umbria', province: 'TR', population: 112000 },
  { name: 'Foligno', region: 'Umbria', province: 'PG', population: 57000 },

  // Molise
  { name: 'Campobasso', region: 'Molise', province: 'CB', population: 50000 },
  { name: 'Termoli', region: 'Molise', province: 'CB', population: 34000 },

  // Basilicata
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', population: 67000 },
  { name: 'Matera', region: 'Basilicata', province: 'MT', population: 60000 },
];

// OSM categories mapping
const OSM_CATEGORIES = {
  'shop': {
    'supermarket': 'Supermercati',
    'convenience': 'Minimarket',
    'bakery': 'Panifici e Forni',
    'butcher': 'Macellerie',
    'greengrocer': 'Frutta e Verdura',
    'clothes': 'Abbigliamento',
    'shoes': 'Calzature',
    'hairdresser': 'Parrucchieri',
    'beauty': 'Centri Estetici',
    'jewelry': 'Gioiellerie',
    'optician': 'Ottici',
    'electronics': 'Elettronica',
    'mobile_phone': 'Telefonia',
    'computer': 'Informatica',
    'bicycle': 'Biciclette',
    'car': 'Concessionarie Auto',
    'car_repair': 'Autofficine',
    'furniture': 'Arredamento',
    'hardware': 'Ferramenta',
    'paint': 'Colorifici',
    'florist': 'Fioristi',
    'gift': 'Articoli da Regalo',
    'books': 'Librerie',
    'stationery': 'Cartolerie',
    'sports': 'Articoli Sportivi',
    'toys': 'Giocattoli',
    'pet': 'Animali',
    'garden_centre': 'Giardinaggio',
    'doityourself': 'Bricolage',
    'alcohol': 'Enoteche',
    'wine': 'Enoteche',
    'tobacco': 'Tabaccherie',
    'kiosk': 'Edicole',
    'newsagent': 'Edicole',
    'mall': 'Centri Commerciali',
    'department_store': 'Grandi Magazzini',
  },
  'amenity': {
    'restaurant': 'Ristoranti',
    'cafe': 'Bar e Caffetterie',
    'bar': 'Bar e Pub',
    'pub': 'Bar e Pub',
    'fast_food': 'Fast Food',
    'pharmacy': 'Farmacie',
    'bank': 'Banche',
    'atm': 'Sportelli Bancomat',
    'post_office': 'Uffici Postali',
    'fuel': 'Distributori di Carburante',
    'hospital': 'Ospedali',
    'clinic': 'Cliniche',
    'dentist': 'Dentisti',
    'doctors': 'Medici',
    'veterinary': 'Veterinari',
    'parking': 'Parcheggi',
    'car_wash': 'Autolavaggi',
    'gym': 'Palestre',
    'cinema': 'Cinema',
    'theatre': 'Teatri',
    'library': 'Biblioteche',
    'school': 'Scuole',
    'kindergarten': 'Asili',
    'college': 'Istituti',
    'university': 'Università',
  },
  'tourism': {
    'hotel': 'Hotel',
    'guest_house': 'Bed & Breakfast',
    'hostel': 'Ostelli',
    'museum': 'Musei',
    'attraction': 'Attrazioni Turistiche',
    'information': 'Uffici Turistici',
  },
  'leisure': {
    'fitness_centre': 'Palestre',
    'sports_centre': 'Centri Sportivi',
    'swimming_pool': 'Piscine',
    'park': 'Parchi',
  },
  'office': {
    'accountant': 'Commercialisti',
    'lawyer': 'Avvocati',
    'estate_agent': 'Agenzie Immobiliari',
    'insurance': 'Assicurazioni',
    'architect': 'Architetti',
    'company': 'Aziende',
    'employment_agency': 'Agenzie del Lavoro',
    'tax_advisor': 'Consulenti Fiscali',
  },
  'craft': {
    'electrician': 'Elettricisti',
    'plumber': 'Idraulici',
    'carpenter': 'Falegnami',
    'painter': 'Imbianchini',
    'photographic_laboratory': 'Fotografi',
    'shoemaker': 'Calzolai',
    'tailor': 'Sarti',
  }
};

// Rate limiting
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function getCategoryId(categoryName) {
  const { data, error } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  if (error) {
    console.error(`Error finding category ${categoryName}:`, error);
    return null;
  }

  if (!data) {
    const { data: newCategory, error: insertError } = await supabase
      .from('business_categories')
      .insert({ name: categoryName })
      .select()
      .single();

    if (insertError) {
      console.error(`Error creating category ${categoryName}:`, insertError);
      return null;
    }
    return newCategory.id;
  }

  return data.id;
}

async function queryOverpass(city, osmType, osmSubtype) {
  const query = `
    [out:json][timeout:60];
    area["name"="${city.name}"]["admin_level"~"^(6|8)$"]->.searchArea;
    (
      node["${osmType}"="${osmSubtype}"](area.searchArea);
      way["${osmType}"="${osmSubtype}"](area.searchArea);
    );
    out center;
  `;

  try {
    const response = await fetch('https://overpass-api.de/api/interpreter', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: `data=${encodeURIComponent(query)}`
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data.elements || [];
  } catch (error) {
    console.error(`Error querying Overpass for ${city.name}:`, error);
    return [];
  }
}

async function importBusinessesForCity(city, categoryName, osmType, osmSubtype) {
  console.log(`\nQuerying ${categoryName} in ${city.name}...`);

  const elements = await queryOverpass(city, osmType, osmSubtype);

  if (elements.length === 0) {
    console.log(`No ${categoryName} found in ${city.name}`);
    return 0;
  }

  console.log(`Found ${elements.length} ${categoryName} in ${city.name}`);

  const categoryId = await getCategoryId(categoryName);
  if (!categoryId) {
    console.log(`Could not get category ID for ${categoryName}`);
    return 0;
  }

  const businesses = elements
    .filter(el => {
      const lat = el.lat || (el.center && el.center.lat);
      const lon = el.lon || (el.center && el.center.lon);
      return lat && lon && el.tags && el.tags.name;
    })
    .map(el => {
      const lat = el.lat || el.center.lat;
      const lon = el.lon || el.center.lon;
      const tags = el.tags || {};

      return {
        name: tags.name,
        category_id: categoryId,
        street: tags['addr:street'] || null,
        street_number: tags['addr:housenumber'] || null,
        city: city.name,
        province: city.province,
        region: city.region,
        postal_code: tags['addr:postcode'] || null,
        latitude: lat,
        longitude: lon,
        phone: tags.phone || tags['contact:phone'] || null,
        email: tags.email || tags['contact:email'] || null,
        website: tags.website || tags['contact:website'] || null,
        business_hours: tags.opening_hours || null,
      };
    });

  if (businesses.length === 0) {
    return 0;
  }

  // Insert in batches of 50
  let inserted = 0;
  for (let i = 0; i < businesses.length; i += 50) {
    const batch = businesses.slice(i, i + 50);

    const { data, error } = await supabase
      .from('unclaimed_business_locations')
      .insert(batch)
      .select();

    if (error) {
      console.error(`Error inserting batch for ${city.name}:`, error);
      console.error('Sample record:', batch[0]);
    } else {
      inserted += data.length;
    }

    await delay(100);
  }

  console.log(`✓ Imported ${inserted}/${businesses.length} ${categoryName} in ${city.name}`);
  return inserted;
}

async function importAllCities() {
  console.log('Starting import of major Italian cities (20k+ population)');
  console.log(`Processing ${CITIES_20K_PLUS.length} cities`);

  const stats = {
    totalCities: CITIES_20K_PLUS.length,
    processedCities: 0,
    totalBusinesses: 0,
    byRegion: {},
    byCategory: {}
  };

  // Sort cities by population (descending) to process larger cities first
  const sortedCities = [...CITIES_20K_PLUS].sort((a, b) => b.population - a.population);

  for (const city of sortedCities) {
    console.log(`\n${'='.repeat(60)}`);
    console.log(`Processing ${city.name} (${city.region}) - Pop: ${city.population.toLocaleString()}`);
    console.log(`Progress: ${stats.processedCities + 1}/${stats.totalCities}`);
    console.log('='.repeat(60));

    let cityTotal = 0;

    // Process each category
    for (const [osmType, subtypes] of Object.entries(OSM_CATEGORIES)) {
      for (const [osmSubtype, categoryName] of Object.entries(subtypes)) {
        try {
          const count = await importBusinessesForCity(city, categoryName, osmType, osmSubtype);
          cityTotal += count;

          if (!stats.byCategory[categoryName]) {
            stats.byCategory[categoryName] = 0;
          }
          stats.byCategory[categoryName] += count;

          // Rate limiting - wait 2 seconds between queries
          await delay(2000);
        } catch (error) {
          console.error(`Error processing ${categoryName} in ${city.name}:`, error);
          await delay(5000); // Longer delay on error
        }
      }
    }

    stats.processedCities++;
    stats.totalBusinesses += cityTotal;

    if (!stats.byRegion[city.region]) {
      stats.byRegion[city.region] = 0;
    }
    stats.byRegion[city.region] += cityTotal;

    console.log(`\n✓ Completed ${city.name}: ${cityTotal} businesses imported`);
    console.log(`Overall progress: ${stats.totalBusinesses} total businesses`);
  }

  // Final summary
  console.log('\n' + '='.repeat(60));
  console.log('IMPORT COMPLETE');
  console.log('='.repeat(60));
  console.log(`\nTotal cities processed: ${stats.processedCities}`);
  console.log(`Total businesses imported: ${stats.totalBusinesses}`);

  console.log('\n--- By Region ---');
  Object.entries(stats.byRegion)
    .sort((a, b) => b[1] - a[1])
    .forEach(([region, count]) => {
      console.log(`${region}: ${count}`);
    });

  console.log('\n--- Top Categories ---');
  Object.entries(stats.byCategory)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 20)
    .forEach(([category, count]) => {
      console.log(`${category}: ${count}`);
    });
}

// Run the import
importAllCities()
  .then(() => {
    console.log('\n✓ Import script completed successfully');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n✗ Import script failed:', error);
    process.exit(1);
  });
