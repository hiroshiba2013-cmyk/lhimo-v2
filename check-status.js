import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function checkStatus() {
  const { data: total, count } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true });

  const { data: regions } = await supabase
    .from('unclaimed_business_locations')
    .select('region')
    .order('region');

  const regionCounts = {};
  regions?.forEach(item => {
    regionCounts[item.region] = (regionCounts[item.region] || 0) + 1;
  });

  const allRegions = [
    "Valle d'Aosta", "Piemonte", "Lombardia", "Trentino-Alto Adige", "Veneto",
    "Friuli-Venezia Giulia", "Liguria", "Emilia-Romagna", "Toscana", "Umbria",
    "Marche", "Lazio", "Abruzzo", "Molise", "Campania", "Puglia",
    "Basilicata", "Calabria", "Sicilia", "Sardegna"
  ];

  const completedRegions = Object.keys(regionCounts).length;
  const progress = (completedRegions / allRegions.length * 100).toFixed(1);

  console.log('\n╔════════════════════════════════════════════════════════════════════════╗');
  console.log('║                   STATO IMPORTAZIONE ITALIA                            ║');
  console.log('╚════════════════════════════════════════════════════════════════════════╝\n');

  console.log(`📊 TOTALE ATTIVITÀ: ${count?.toLocaleString() || 0}`);
  console.log(`🗺️  REGIONI COMPLETATE: ${completedRegions}/20 (${progress}%)\n`);

  if (completedRegions > 0) {
    console.log('✅ REGIONI CON DATI:\n');
    Object.entries(regionCounts)
      .sort(([,a], [,b]) => b - a)
      .forEach(([region, count]) => {
        const bar = '█'.repeat(Math.floor(count / 50));
        console.log(`   ${region.padEnd(25)} ${count.toString().padStart(6)} ${bar}`);
      });
  }

  console.log('\n⏳ REGIONI IN ATTESA:\n');
  allRegions.forEach(region => {
    if (!regionCounts[region]) {
      console.log(`   ⌛ ${region}`);
    }
  });

  console.log(`\n⏱️  Ultimo aggiornamento: ${new Date().toLocaleString('it-IT')}`);

  if (completedRegions === 20) {
    console.log('\n🎉 IMPORTAZIONE COMPLETATA! 🎉\n');
  } else {
    console.log('\n💡 Usa "npm run monitor" per aggiornamenti in tempo reale\n');
  }
}

checkStatus();
