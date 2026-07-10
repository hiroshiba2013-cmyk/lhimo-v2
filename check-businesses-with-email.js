#!/usr/bin/env node

/**
 * Script per verificare quante attività non rivendicate hanno un'email
 */

import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Errore: Variabili d\'ambiente mancanti');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkBusinessesWithEmail() {
  console.log('🔍 Verifica attività non rivendicate con email...\n');

  try {
    // Conta tutte le attività non rivendicate
    const { count: totalUnclaimed, error: totalError } = await supabase
      .from('unclaimed_business_locations')
      .select('*', { count: 'exact', head: true })
      .eq('is_claimed', false);

    if (totalError) throw totalError;

    // Conta quelle con email
    const { count: withEmail, error: emailError } = await supabase
      .from('unclaimed_business_locations')
      .select('*', { count: 'exact', head: true })
      .eq('is_claimed', false)
      .not('email', 'is', null)
      .neq('email', '');

    if (emailError) throw emailError;

    // Conta per regione
    const { data: byRegion, error: regionError } = await supabase
      .from('unclaimed_business_locations')
      .select('region')
      .eq('is_claimed', false)
      .not('email', 'is', null)
      .neq('email', '');

    if (regionError) throw regionError;

    const regionCounts = {};
    byRegion.forEach(item => {
      const region = item.region || 'Non specificata';
      regionCounts[region] = (regionCounts[region] || 0) + 1;
    });

    // Mostra risultati
    console.log('📊 Statistiche Attività Non Rivendicate:');
    console.log('─'.repeat(50));
    console.log(`   Totale attività non rivendicate: ${totalUnclaimed}`);
    console.log(`   Attività con email valida: ${withEmail}`);
    console.log(`   Attività senza email: ${totalUnclaimed - withEmail}`);
    console.log(`   Percentuale con email: ${((withEmail / totalUnclaimed) * 100).toFixed(1)}%`);
    console.log('');

    console.log('📍 Distribuzione per Regione (con email):');
    console.log('─'.repeat(50));
    const sortedRegions = Object.entries(regionCounts)
      .sort((a, b) => b[1] - a[1]);

    sortedRegions.forEach(([region, count]) => {
      const percentage = ((count / withEmail) * 100).toFixed(1);
      const bar = '█'.repeat(Math.ceil(count / 100));
      console.log(`   ${region.padEnd(25)} ${count.toString().padStart(5)} (${percentage.padStart(5)}%) ${bar}`);
    });
    console.log('');

    // Alcune email di esempio
    const { data: samples, error: sampleError } = await supabase
      .from('unclaimed_business_locations')
      .select('name, email, city, province')
      .eq('is_claimed', false)
      .not('email', 'is', null)
      .neq('email', '')
      .limit(5);

    if (sampleError) throw sampleError;

    if (samples && samples.length > 0) {
      console.log('📧 Esempi di Attività con Email:');
      console.log('─'.repeat(50));
      samples.forEach(business => {
        console.log(`   ${business.name}`);
        console.log(`   📍 ${business.city}, ${business.province}`);
        console.log(`   📧 ${business.email}`);
        console.log('');
      });
    }

    console.log('💡 Suggerimento:');
    console.log('   Per inviare le notifiche, usa:');
    console.log('   npm run notify:businesses      # Invia a 100 attività');
    console.log('   npm run notify:all             # Invia a TUTTE le attività');
    console.log('');

  } catch (error) {
    console.error('❌ Errore:', error.message);
    process.exit(1);
  }
}

checkBusinessesWithEmail();
