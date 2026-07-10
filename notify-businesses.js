#!/usr/bin/env node

/**
 * Script per notificare le attività non rivendicate
 *
 * Utilizzo:
 *   node notify-businesses.js [limit] [offset]
 *
 * Esempi:
 *   node notify-businesses.js          # Invia a 100 attività (default)
 *   node notify-businesses.js 50       # Invia a 50 attività
 *   node notify-businesses.js 100 200  # Invia a 100 attività partendo dalla 200esima
 */

import dotenv from 'dotenv';
import fetch from 'node-fetch';

dotenv.config();

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.VITE_SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.error('❌ Errore: Variabili d\'ambiente mancanti');
  console.error('Assicurati che VITE_SUPABASE_URL e VITE_SUPABASE_ANON_KEY siano definite nel file .env');
  process.exit(1);
}

async function notifyBusinesses(limit = 100, offset = 0) {
  const functionUrl = `${SUPABASE_URL}/functions/v1/notify-unclaimed-businesses`;

  console.log('🚀 Invio notifiche alle attività non rivendicate...');
  console.log(`📊 Parametri: limit=${limit}, offset=${offset}`);
  console.log('');

  try {
    const response = await fetch(functionUrl, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ limit, offset })
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`HTTP ${response.status}: ${errorText}`);
    }

    const result = await response.json();

    console.log('✅ Operazione completata!');
    console.log('');
    console.log('📈 Statistiche:');
    console.log(`   - Attività processate: ${result.sent + result.failed}`);
    console.log(`   - Email inviate: ${result.sent}`);
    console.log(`   - Errori: ${result.failed}`);
    console.log('');

    if (result.sentEmails && result.sentEmails.length > 0) {
      console.log('📧 Email inviate a:');
      result.sentEmails.slice(0, 10).forEach(email => {
        console.log(`   - ${email}`);
      });
      if (result.sentEmails.length > 10) {
        console.log(`   ... e altre ${result.sentEmails.length - 10} email`);
      }
      console.log('');
    }

    if (result.failedEmails && result.failedEmails.length > 0) {
      console.log('⚠️  Email fallite:');
      result.failedEmails.forEach(({ email, error }) => {
        console.log(`   - ${email}: ${error}`);
      });
      console.log('');
    }

    return result;
  } catch (error) {
    console.error('❌ Errore durante l\'invio delle notifiche:', error.message);
    throw error;
  }
}

async function notifyAll() {
  const batchSize = 100;
  let offset = 0;
  let totalSent = 0;
  let totalFailed = 0;
  let hasMore = true;
  let batchNumber = 1;

  console.log('🔄 Avvio invio notifiche a TUTTE le attività non rivendicate...');
  console.log('');

  while (hasMore) {
    console.log(`\n📦 Batch ${batchNumber} (offset: ${offset})`);
    console.log('─'.repeat(50));

    try {
      const result = await notifyBusinesses(batchSize, offset);

      totalSent += result.sent;
      totalFailed += result.failed;

      // Se abbiamo processato meno del batch size, abbiamo finito
      hasMore = (result.sent + result.failed) === batchSize;
      offset += batchSize;
      batchNumber++;

      // Pausa di 2 secondi tra i batch
      if (hasMore) {
        console.log('⏳ Pausa di 2 secondi prima del prossimo batch...');
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    } catch (error) {
      console.error(`❌ Errore nel batch ${batchNumber}:`, error.message);
      console.log('🛑 Interrompo l\'invio per sicurezza');
      break;
    }
  }

  console.log('\n');
  console.log('═'.repeat(50));
  console.log('🎉 Invio completato!');
  console.log('═'.repeat(50));
  console.log(`📊 Riepilogo Totale:`);
  console.log(`   - Batch processati: ${batchNumber - 1}`);
  console.log(`   - Email inviate con successo: ${totalSent}`);
  console.log(`   - Email fallite: ${totalFailed}`);
  console.log(`   - Totale attività processate: ${totalSent + totalFailed}`);
  console.log('');
}

// Parsing argomenti da linea di comando
const args = process.argv.slice(2);

if (args.length === 0) {
  // Nessun argomento: invia a 100 attività
  notifyBusinesses(100, 0)
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
} else if (args[0] === 'all') {
  // Argomento "all": invia a tutte le attività
  notifyAll()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
} else {
  // Argomenti numerici: limit e offset
  const limit = parseInt(args[0]) || 100;
  const offset = parseInt(args[1]) || 0;

  notifyBusinesses(limit, offset)
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}
