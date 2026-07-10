/**
 * Watchdog - monitora e rilancia i round di importazione per 1 ora
 * Cicla tra v2 -> round2 -> round3 -> v2 ...
 */
import { spawn } from 'child_process';
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
config();

const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);
const END = Date.now() + 60 * 60 * 1000; // 1 ora
const SCRIPTS = ['import-comuni-v2.js', 'import-round2.js', 'import-round3.js'];
let round = 0;

async function getCount() {
  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  return count || 0;
}

async function runScript(script) {
  return new Promise((resolve) => {
    console.log(`\n[${new Date().toLocaleTimeString()}] Avvio: ${script}`);
    const child = spawn('node', [script], { stdio: 'inherit' });
    child.on('close', (code) => {
      console.log(`\n[${new Date().toLocaleTimeString()}] Fine ${script} (code ${code})`);
      resolve(code);
    });
    child.on('error', (err) => {
      console.error(`Errore spawn: ${err.message}`);
      resolve(-1);
    });
  });
}

async function main() {
  console.log(`=== WATCHDOG avviato, fine alle ${new Date(END).toLocaleTimeString()} ===`);
  let startCount = await getCount();
  console.log(`Totale iniziale DB: ${startCount.toLocaleString()}`);

  while (Date.now() < END) {
    const script = SCRIPTS[round % SCRIPTS.length];
    await runScript(script);
    round++;

    const now = await getCount();
    const added = now - startCount;
    const remaining = Math.round((END - Date.now()) / 60000);
    console.log(`\nDB totale: ${now.toLocaleString()} (+${added.toLocaleString()} questa sessione) | Tempo rimanente: ${remaining}min`);

    if (Date.now() >= END) break;
    // Piccola pausa tra round
    await new Promise(r => setTimeout(r, 5000));
  }

  const finalCount = await getCount();
  console.log(`\n=== WATCHDOG COMPLETATO ===`);
  console.log(`DB finale: ${finalCount.toLocaleString()}`);
}

main().catch(console.error);
