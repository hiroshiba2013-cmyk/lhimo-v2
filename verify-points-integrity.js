/**
 * VERIFICA INTEGRITÀ SISTEMA PUNTI
 *
 * Questo script controlla che tutti i punti nella classifica siano corretti
 * secondo i parametri ufficiali definiti in SISTEMA_PUNTI_UFFICIALE.md
 *
 * USO: node verify-points-integrity.js
 */

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// PARAMETRI UFFICIALI - NON MODIFICARE
const POINTS = {
  REVIEW_WITH_PROOF: 50,
  REVIEW_NO_PROOF: 25,
  BUSINESS_COMPLETE: 25,
  BUSINESS_BASIC: 10,
  CLASSIFIED_AD: 5,
  REFERRAL: 30
};

async function calculateUserPoints(userId) {
  console.log(`\nCalcolo punti per utente: ${userId}`);

  let totalPoints = 0;
  const breakdown = {
    recensioni: 0,
    attivita: 0,
    annunci: 0,
    referral: 0
  };

  // 1. RECENSIONI APPROVATE
  const { data: reviews } = await supabase
    .from('reviews')
    .select('proof_image_url')
    .eq('customer_id', userId)
    .eq('review_status', 'approved');

  if (reviews && reviews.length > 0) {
    reviews.forEach(review => {
      const points = review.proof_image_url ? POINTS.REVIEW_WITH_PROOF : POINTS.REVIEW_NO_PROOF;
      breakdown.recensioni += points;
    });
    console.log(`  - Recensioni: ${reviews.length} (${breakdown.recensioni} punti)`);
  }

  // 2. ATTIVITÀ UNCLAIMED
  const { data: unclaimedBusinesses } = await supabase
    .from('unclaimed_business_locations')
    .select('email, phone, website')
    .eq('added_by', userId);

  if (unclaimedBusinesses && unclaimedBusinesses.length > 0) {
    unclaimedBusinesses.forEach(business => {
      const isComplete =
        (business.email && business.email !== '') ||
        (business.phone && business.phone !== '') ||
        (business.website && business.website !== '');

      const points = isComplete ? POINTS.BUSINESS_COMPLETE : POINTS.BUSINESS_BASIC;
      breakdown.attivita += points;
    });
    console.log(`  - Attività non reclamate: ${unclaimedBusinesses.length} (${breakdown.attivita} punti)`);
  }

  // 3. ATTIVITÀ USER ADDED
  const { data: userAddedBusinesses } = await supabase
    .from('user_added_businesses')
    .select('email, phone, website')
    .eq('added_by', userId);

  if (userAddedBusinesses && userAddedBusinesses.length > 0) {
    userAddedBusinesses.forEach(business => {
      const isComplete =
        (business.email && business.email !== '') ||
        (business.phone && business.phone !== '') ||
        (business.website && business.website !== '');

      const points = isComplete ? POINTS.BUSINESS_COMPLETE : POINTS.BUSINESS_BASIC;
      breakdown.attivita += points;
    });
    console.log(`  - Attività aggiunte: ${userAddedBusinesses.length} (${breakdown.attivita} punti totali attività)`);
  }

  // 4. ANNUNCI CLASSIFICATI
  const { data: ads } = await supabase
    .from('classified_ads')
    .select('id')
    .eq('owner_id', userId);

  if (ads && ads.length > 0) {
    breakdown.annunci = ads.length * POINTS.CLASSIFIED_AD;
    console.log(`  - Annunci: ${ads.length} (${breakdown.annunci} punti)`);
  }

  // 5. REFERRAL COMPLETATI
  const { data: referrals } = await supabase
    .from('referrals')
    .select('id')
    .eq('referrer_id', userId)
    .eq('status', 'completed');

  if (referrals && referrals.length > 0) {
    breakdown.referral = referrals.length * POINTS.REFERRAL;
    console.log(`  - Referral: ${referrals.length} (${breakdown.referral} punti)`);
  }

  totalPoints = breakdown.recensioni + breakdown.attivita + breakdown.annunci + breakdown.referral;

  return { totalPoints, breakdown };
}

async function verifyAllUsers() {
  console.log('==========================================');
  console.log('VERIFICA INTEGRITÀ SISTEMA PUNTI');
  console.log('==========================================\n');

  // Ottieni tutti gli utenti con punti
  const { data: userActivities, error } = await supabase
    .from('user_activity')
    .select('user_id, total_points, reviews_count, businesses_added_count, ads_count')
    .gt('total_points', 0)
    .order('total_points', { ascending: false });

  if (error) {
    console.error('Errore:', error);
    return;
  }

  if (!userActivities || userActivities.length === 0) {
    console.log('Nessun utente con punti trovato.');
    return;
  }

  console.log(`Trovati ${userActivities.length} utenti con punti.\n`);

  let totalErrors = 0;
  const errors = [];

  for (const activity of userActivities) {
    const calculated = await calculateUserPoints(activity.user_id);

    const currentPoints = activity.total_points;
    const expectedPoints = calculated.totalPoints;

    if (currentPoints !== expectedPoints) {
      totalErrors++;
      const error = {
        userId: activity.user_id,
        current: currentPoints,
        expected: expectedPoints,
        difference: currentPoints - expectedPoints,
        breakdown: calculated.breakdown
      };
      errors.push(error);

      console.log(`  ❌ ERRORE: Punti non corrispondono!`);
      console.log(`     Punti attuali: ${currentPoints}`);
      console.log(`     Punti attesi: ${expectedPoints}`);
      console.log(`     Differenza: ${error.difference > 0 ? '+' : ''}${error.difference}`);
    } else {
      console.log(`  ✅ Punti corretti: ${currentPoints}`);
    }
  }

  console.log('\n==========================================');
  console.log('RISULTATO VERIFICA');
  console.log('==========================================\n');

  if (totalErrors === 0) {
    console.log('✅ TUTTI I PUNTI SONO CORRETTI!');
    console.log(`   ${userActivities.length} utenti verificati, nessun errore trovato.`);
  } else {
    console.log(`❌ TROVATI ${totalErrors} ERRORI!\n`);

    console.log('UTENTI CON ERRORI:');
    errors.forEach((error, index) => {
      console.log(`\n${index + 1}. Utente: ${error.userId}`);
      console.log(`   Punti attuali: ${error.current}`);
      console.log(`   Punti attesi: ${error.expected}`);
      console.log(`   Differenza: ${error.difference > 0 ? '+' : ''}${error.difference}`);
      console.log(`   Breakdown atteso:`);
      console.log(`     - Recensioni: ${error.breakdown.recensioni} punti`);
      console.log(`     - Attività: ${error.breakdown.attivita} punti`);
      console.log(`     - Annunci: ${error.breakdown.annunci} punti`);
      console.log(`     - Referral: ${error.breakdown.referral} punti`);
    });

    console.log('\n⚠️  AZIONE RICHIESTA: Correggi i punti usando i valori attesi sopra.');
  }

  console.log('\n==========================================\n');
}

// Esegui verifica
verifyAllUsers().catch(console.error);
