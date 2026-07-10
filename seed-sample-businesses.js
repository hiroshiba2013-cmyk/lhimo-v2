import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

const sampleBusinesses = [
  // Milano
  {
    name: 'Trattoria Milanese',
    city: 'Milano',
    province: 'MI',
    region: 'Lombardia',
    address: 'Via Santa Marta 11',
    category: 'Ristoranti'
  },
  {
    name: 'Bar Centrale',
    city: 'Milano',
    province: 'MI',
    region: 'Lombardia',
    address: 'Piazza Duomo 21',
    category: 'Bar e Caffè'
  },
  {
    name: 'Farmacia San Carlo',
    city: 'Milano',
    province: 'MI',
    region: 'Lombardia',
    address: 'Corso Venezia 45',
    category: 'Farmacie'
  },
  // Roma
  {
    name: 'Ristorante Da Enzo',
    city: 'Roma',
    province: 'RM',
    region: 'Lazio',
    address: 'Via dei Vascellari 29',
    category: 'Ristoranti'
  },
  {
    name: 'Pizzeria Romana',
    city: 'Roma',
    province: 'RM',
    region: 'Lazio',
    address: 'Via della Lungaretta 46',
    category: 'Ristoranti'
  },
  {
    name: 'Farmacia Vaticano',
    city: 'Roma',
    province: 'RM',
    region: 'Lazio',
    address: 'Via Cola di Rienzo 213',
    category: 'Farmacie'
  },
  // Napoli
  {
    name: 'Pizzeria da Michele',
    city: 'Napoli',
    province: 'NA',
    region: 'Campania',
    address: 'Via Cesare Sersale 1',
    category: 'Ristoranti'
  },
  {
    name: 'Bar Toledo',
    city: 'Napoli',
    province: 'NA',
    region: 'Campania',
    address: 'Via Toledo 156',
    category: 'Bar e Caffè'
  },
  {
    name: 'Pasticceria Scaturchio',
    city: 'Napoli',
    province: 'NA',
    region: 'Campania',
    address: 'Piazza San Domenico Maggiore 19',
    category: 'Alimentari'
  },
  // Torino
  {
    name: 'Ristorante Del Cambio',
    city: 'Torino',
    province: 'TO',
    region: 'Piemonte',
    address: 'Piazza Carignano 2',
    category: 'Ristoranti'
  },
  {
    name: 'Caffè Mulassano',
    city: 'Torino',
    province: 'TO',
    region: 'Piemonte',
    address: 'Piazza Castello 15',
    category: 'Bar e Caffè'
  },
  {
    name: 'Farmacia Boniscontro',
    city: 'Torino',
    province: 'TO',
    region: 'Piemonte',
    address: 'Corso Vittorio Emanuele II 72',
    category: 'Farmacie'
  },
  // Firenze
  {
    name: 'Trattoria Mario',
    city: 'Firenze',
    province: 'FI',
    region: 'Toscana',
    address: 'Via Rosina 2',
    category: 'Ristoranti'
  },
  {
    name: 'Gelateria dei Neri',
    city: 'Firenze',
    province: 'FI',
    region: 'Toscana',
    address: 'Via dei Neri 9',
    category: 'Gelaterie'
  },
  {
    name: 'Farmacia Comunale',
    city: 'Firenze',
    province: 'FI',
    region: 'Toscana',
    address: 'Piazza del Mercato Centrale 38',
    category: 'Farmacie'
  },
  // Bologna
  {
    name: 'Osteria Francescana',
    city: 'Bologna',
    province: 'BO',
    region: 'Emilia-Romagna',
    address: 'Via Stella 22',
    category: 'Ristoranti'
  },
  {
    name: 'Caffè Terzi',
    city: 'Bologna',
    province: 'BO',
    region: 'Emilia-Romagna',
    address: 'Via Oberdan 10',
    category: 'Bar e Caffè'
  },
  {
    name: 'Farmacia Santa Maria della Vita',
    city: 'Bologna',
    province: 'BO',
    region: 'Emilia-Romagna',
    address: 'Via Clavature 10',
    category: 'Farmacie'
  },
  // Venezia
  {
    name: 'Osteria alle Testiere',
    city: 'Venezia',
    province: 'VE',
    region: 'Veneto',
    address: 'Calle del Mondo Novo 5801',
    category: 'Ristoranti'
  },
  {
    name: 'Caffè Florian',
    city: 'Venezia',
    province: 'VE',
    region: 'Veneto',
    address: 'Piazza San Marco 57',
    category: 'Bar e Caffè'
  },
  {
    name: 'Farmacia Morelli',
    city: 'Venezia',
    province: 'VE',
    region: 'Veneto',
    address: 'Calle Larga XXII Marzo 2356',
    category: 'Farmacie'
  },
  // Palermo
  {
    name: 'Antica Focacceria San Francesco',
    city: 'Palermo',
    province: 'PA',
    region: 'Sicilia',
    address: 'Via Alessandro Paternostro 58',
    category: 'Ristoranti'
  },
  {
    name: 'Bar Marocco',
    city: 'Palermo',
    province: 'PA',
    region: 'Sicilia',
    address: 'Via Generale Magliocco 15',
    category: 'Bar e Caffè'
  },
  {
    name: 'Farmacia Di Via Roma',
    city: 'Palermo',
    province: 'PA',
    region: 'Sicilia',
    address: 'Via Roma 207',
    category: 'Farmacie'
  },
  // Genova
  {
    name: 'Trattoria Rosmarino',
    city: 'Genova',
    province: 'GE',
    region: 'Liguria',
    address: 'Salita del Fondaco 30',
    category: 'Ristoranti'
  },
  {
    name: 'Caffè degli Specchi',
    city: 'Genova',
    province: 'GE',
    region: 'Liguria',
    address: 'Salita Pollaiuoli 43',
    category: 'Bar e Caffè'
  },
  {
    name: 'Farmacia Ghigliotti',
    city: 'Genova',
    province: 'GE',
    region: 'Liguria',
    address: 'Via XX Settembre 101',
    category: 'Farmacie'
  }
];

async function seedBusinesses() {
  console.log('Starting to seed sample businesses...\n');

  // Get all categories
  const { data: categories, error: catError } = await supabase
    .from('business_categories')
    .select('id, name');

  if (catError) {
    console.error('Error loading categories:', catError);
    return;
  }

  const categoryMap = new Map(categories.map(cat => [cat.name, cat.id]));

  let created = 0;
  let skipped = 0;

  for (const business of sampleBusinesses) {
    try {
      // Check if business already exists
      const { data: existing } = await supabase
        .from('business_locations')
        .select('id')
        .eq('city', business.city.toLowerCase())
        .ilike('address', `%${business.address.split(' ')[0]}%`)
        .limit(1);

      if (existing && existing.length > 0) {
        console.log(`⏭️  Skipped: ${business.name} in ${business.city} (already exists)`);
        skipped++;
        continue;
      }

      // Find category
      const categoryId = categoryMap.get(business.category);
      if (!categoryId) {
        console.log(`⚠️  Warning: Category "${business.category}" not found for ${business.name}`);
        continue;
      }

      // Create business
      const { data: newBusiness, error: businessError } = await supabase
        .from('businesses')
        .insert({
          name: business.name,
          category_id: categoryId,
          is_claimed: false,
          owner_id: null,
          verified: true
        })
        .select()
        .single();

      if (businessError) {
        console.error(`❌ Error creating business ${business.name}:`, businessError.message);
        continue;
      }

      // Create location
      const { error: locationError } = await supabase
        .from('business_locations')
        .insert({
          business_id: newBusiness.id,
          address: business.address,
          city: business.city.toLowerCase(),
          province: business.province,
          region: business.region,
          postal_code: '00000',
          is_claimed: false,
          verification_badge: null
        });

      if (locationError) {
        console.error(`❌ Error creating location for ${business.name}:`, locationError.message);
        await supabase.from('businesses').delete().eq('id', newBusiness.id);
        continue;
      }

      console.log(`✅ Created: ${business.name} in ${business.city}`);
      created++;

      // Small delay to avoid rate limiting
      await new Promise(resolve => setTimeout(resolve, 100));
    } catch (error) {
      console.error(`Error processing ${business.name}:`, error);
    }
  }

  console.log(`\n📊 Summary:`);
  console.log(`   ✅ Created: ${created} businesses`);
  console.log(`   ⏭️  Skipped: ${skipped} businesses (already existed)`);
  console.log(`   📍 Total: ${sampleBusinesses.length} businesses processed`);
}

seedBusinesses().catch(console.error);
