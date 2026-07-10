import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function listCategories() {
  console.log('\n📋 CATEGORIE DISPONIBILI NEL DATABASE\n');
  console.log('='.repeat(80) + '\n');

  const { data: categories, error } = await supabase
    .from('business_categories')
    .select('id, name')
    .order('name');

  if (error) {
    console.error('Errore:', error);
    return;
  }

  console.log(`Totale categorie: ${categories.length}\n`);

  categories.forEach((cat, i) => {
    console.log(`${(i+1).toString().padStart(3)}. ${cat.name}`);
  });

  console.log('\n' + '='.repeat(80));

  const { data: withBusinesses } = await supabase
    .from('unclaimed_business_locations')
    .select('category_id, business_categories(name)')
    .not('category_id', 'is', null);

  if (withBusinesses) {
    const counts = {};
    withBusinesses.forEach(b => {
      const name = b.business_categories?.name;
      if (name) {
        counts[name] = (counts[name] || 0) + 1;
      }
    });

    console.log('\n📊 CATEGORIE CON ATTIVITÀ (Top 30):\n');
    Object.entries(counts)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 30)
      .forEach(([name, count], i) => {
        console.log(`${(i+1).toString().padStart(3)}. ${name.padEnd(40)} ${count.toLocaleString()}`);
      });
  }

  console.log('\n' + '='.repeat(80) + '\n');
}

listCategories().catch(console.error);
