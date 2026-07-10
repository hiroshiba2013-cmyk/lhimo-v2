import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

let lastCount = 0;
let lastTime = Date.now();
let startCount = null;
let startTime = null;

async function checkProgress() {
  const { data, error } = await supabase
    .from('unclaimed_business_locations')
    .select('created_at', { count: 'exact', head: false })
    .order('created_at', { ascending: false })
    .limit(1);

  if (error) {
    console.error('Errore:', error);
    return;
  }

  const { count } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true });

  const currentCount = count || 0;
  const now = Date.now();

  if (startCount === null) {
    startCount = currentCount;
    startTime = now;
  }

  const deltaCount = currentCount - lastCount;
  const deltaTime = (now - lastTime) / 1000;
  const rate = deltaCount / deltaTime;

  const totalInserted = currentCount - startCount;
  const totalElapsed = (now - startTime) / 1000;
  const avgRate = totalInserted / totalElapsed;

  console.clear();
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║          MONITORAGGIO IMPORTAZIONE OSM IN TEMPO REALE       ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  console.log(`📊 Totale attività nel database: ${currentCount.toLocaleString()}`);
  console.log(`📈 Inserite dall'inizio monitoraggio: ${totalInserted.toLocaleString()}`);
  console.log(`⚡ Velocità attuale: ${Math.round(rate)} attività/secondo`);
  console.log(`📉 Velocità media: ${Math.round(avgRate)} attività/secondo`);

  if (data && data[0]) {
    const lastUpdate = new Date(data[0].created_at);
    const secondsAgo = Math.floor((now - lastUpdate.getTime()) / 1000);
    console.log(`🕐 Ultimo inserimento: ${secondsAgo} secondi fa`);
  }

  console.log(`\n⏱️  Tempo di monitoraggio: ${formatTime(totalElapsed)}`);
  console.log(`\n💡 Premi CTRL+C per uscire`);

  lastCount = currentCount;
  lastTime = now;
}

function formatTime(seconds) {
  if (seconds < 60) return `${Math.round(seconds)}s`;
  if (seconds < 3600) return `${Math.floor(seconds / 60)}m ${Math.round(seconds % 60)}s`;
  return `${Math.floor(seconds / 3600)}h ${Math.floor((seconds % 3600) / 60)}m`;
}

console.log('Avvio monitoraggio...\n');
setInterval(checkProgress, 2000);
checkProgress();
