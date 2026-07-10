import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function getStats() {
  const { data: total } = await supabase
    .from('unclaimed_business_locations')
    .select('id', { count: 'exact', head: true });

  const { data: byRegion } = await supabase
    .from('unclaimed_business_locations')
    .select('region')
    .order('region');

  const { data: byCategory } = await supabase
    .from('unclaimed_business_locations')
    .select('category_id, business_categories(name)')
    .order('category_id');

  const regionCounts = {};
  byRegion?.forEach(item => {
    regionCounts[item.region] = (regionCounts[item.region] || 0) + 1;
  });

  const categoryCounts = {};
  byCategory?.forEach(item => {
    const categoryName = item.business_categories?.name || 'Sconosciuta';
    categoryCounts[categoryName] = (categoryCounts[categoryName] || 0) + 1;
  });

  return {
    total: total?.length || 0,
    byRegion: regionCounts,
    byCategory: categoryCounts
  };
}

async function monitor() {
  console.clear();
  console.log('╔════════════════════════════════════════════════════════════════════════╗');
  console.log('║              MONITORAGGIO IMPORTAZIONE IN TEMPO REALE                  ║');
  console.log('╚════════════════════════════════════════════════════════════════════════╝\n');

  const stats = await getStats();

  console.log(`📊 TOTALE ATTIVITÀ IMPORTATE: ${stats.total.toLocaleString()}\n`);

  if (Object.keys(stats.byRegion).length > 0) {
    console.log('🗺️  PER REGIONE:\n');
    Object.entries(stats.byRegion)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 10)
      .forEach(([region, count]) => {
        console.log(`   ${region.padEnd(25)} ${count.toLocaleString().padStart(8)}`);
      });
    console.log('');
  }

  if (Object.keys(stats.byCategory).length > 0) {
    console.log('🏷️  PER CATEGORIA (Top 10):\n');
    Object.entries(stats.byCategory)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 10)
      .forEach(([category, count]) => {
        console.log(`   ${category.padEnd(30)} ${count.toLocaleString().padStart(8)}`);
      });
    console.log('');
  }

  console.log(`Aggiornamento: ${new Date().toLocaleTimeString()}`);
  console.log('\nPremi CTRL+C per uscire');
}

setInterval(monitor, 10000);
monitor();
