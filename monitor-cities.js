import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function getStats() {
  const { data: businesses, error } = await supabase
    .from('unclaimed_business_locations')
    .select('city, region, category_id');

  if (error) {
    console.error('Errore:', error);
    return;
  }

  const byCity = {};
  const byRegion = {};
  const byCategory = {};

  for (const b of businesses) {
    byCity[b.city] = (byCity[b.city] || 0) + 1;
    byRegion[b.region] = (byRegion[b.region] || 0) + 1;
    byCategory[b.category_id] = (byCategory[b.category_id] || 0) + 1;
  }

  console.clear();
  console.log('\n╔═══════════════════════════════════════════════════════════════════╗');
  console.log('║          📊 MONITORAGGIO IMPORTAZIONE CITTÀ IN TEMPO REALE       ║');
  console.log('╚═══════════════════════════════════════════════════════════════════╝\n');

  console.log(`🎯 TOTALE ATTIVITÀ: ${businesses.length.toLocaleString()}\n`);

  console.log('🏆 TOP 20 CITTÀ:');
  console.log('─'.repeat(70));
  Object.entries(byCity)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 20)
    .forEach(([city, count], i) => {
      const bar = '█'.repeat(Math.ceil(count / 100));
      console.log(`${(i+1).toString().padStart(2)}. ${city.padEnd(30)} ${count.toString().padStart(6)} ${bar}`);
    });

  console.log('\n🗺️  PER REGIONE:');
  console.log('─'.repeat(70));
  Object.entries(byRegion)
    .sort(([,a], [,b]) => b - a)
    .forEach(([region, count]) => {
      const bar = '█'.repeat(Math.ceil(count / 200));
      console.log(`${region.padEnd(30)} ${count.toString().padStart(6)} ${bar}`);
    });

  console.log('\n⏰ Aggiornamento ogni 10 secondi...');
  console.log('─'.repeat(70));
}

async function monitor() {
  await getStats();
  setInterval(getStats, 10000);
}

monitor().catch(console.error);
