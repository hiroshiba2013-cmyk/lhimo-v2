import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function monitorProgress() {
  console.clear();
  console.log('╔════════════════════════════════════════════════════════╗');
  console.log('║  📊 MONITORAGGIO IMPORTAZIONE OSM IN TEMPO REALE       ║');
  console.log('╚════════════════════════════════════════════════════════╝\n');

  // Totale attività
  const { data: total } = await supabase
    .from('unclaimed_business_locations')
    .select('id', { count: 'exact', head: true });

  console.log(`🎯 TOTALE ATTIVITÀ NEL DATABASE: ${(total || 0).toLocaleString()}\n`);

  // Attività per regione
  const { data: byRegion } = await supabase
    .from('unclaimed_business_locations')
    .select('region')
    .then(res => {
      const counts = {};
      res.data?.forEach(row => {
        counts[row.region] = (counts[row.region] || 0) + 1;
      });
      return { data: Object.entries(counts).map(([region, count]) => ({ region, count })).sort((a, b) => b.count - a.count) };
    });

  console.log('🗺️  PER REGIONE:');
  byRegion?.slice(0, 10).forEach(({ region, count }) => {
    console.log(`   ${region.padEnd(25)} ${count.toLocaleString().padStart(8)}`);
  });

  // Attività per provincia
  const { data: byProvince } = await supabase
    .from('unclaimed_business_locations')
    .select('province, region')
    .then(res => {
      const counts = {};
      res.data?.forEach(row => {
        const key = `${row.province} (${row.region})`;
        counts[key] = (counts[key] || 0) + 1;
      });
      return { data: Object.entries(counts).map(([prov, count]) => ({ prov, count })).sort((a, b) => b.count - a.count) };
    });

  console.log('\n🏙️  TOP 15 PROVINCE:');
  byProvince?.slice(0, 15).forEach(({ prov, count }, i) => {
    console.log(`   ${(i + 1).toString().padStart(2)}. ${prov.padEnd(40)} ${count.toLocaleString().padStart(8)}`);
  });

  // Ultime 20 attività importate
  const { data: recent } = await supabase
    .from('unclaimed_business_locations')
    .select('name, city, province, region, created_at')
    .order('created_at', { ascending: false })
    .limit(20);

  console.log('\n🆕 ULTIME 20 ATTIVITÀ IMPORTATE:');
  recent?.forEach((business, i) => {
    const time = new Date(business.created_at).toLocaleTimeString('it-IT');
    console.log(`   ${(i + 1).toString().padStart(2)}. [${time}] ${business.name} - ${business.city} (${business.province})`);
  });

  console.log('\n⏰ Ultimo aggiornamento:', new Date().toLocaleTimeString('it-IT'));
  console.log('💡 Premi Ctrl+C per uscire\n');
}

// Aggiorna ogni 30 secondi
setInterval(monitorProgress, 30000);
monitorProgress();
