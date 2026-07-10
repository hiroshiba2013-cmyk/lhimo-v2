import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function testBatchSearch() {
  console.log('Testing BATCH search for Lombardia...\n');

  // Step 1: Get location IDs
  const { data: locationData, error: locationError } = await supabase
    .from('business_locations')
    .select('business_id')
    .eq('region', 'Lombardia');

  if (locationError) {
    console.error('Location error:', locationError);
    return;
  }

  const businessIds = locationData
    ?.map(loc => loc.business_id)
    .filter(id => id != null) || [];

  console.log(`Found ${businessIds.length} business IDs`);

  if (businessIds.length === 0) {
    console.log('No IDs found!');
    return;
  }

  // Step 2: Query in batches
  const batchSize = 100;
  const batches = Math.ceil(businessIds.length / batchSize);
  let allBusinesses = [];

  console.log(`Processing ${batches} batches...`);

  for (let i = 0; i < batches; i++) {
    const batchIds = businessIds.slice(i * batchSize, (i + 1) * batchSize);

    const { data: batchData, error: batchError } = await supabase
      .from('businesses')
      .select(`
        id,
        name,
        city,
        category:business_categories(name)
      `)
      .in('id', batchIds);

    if (batchError) {
      console.error(`Batch ${i + 1} error:`, batchError);
      continue;
    }

    if (batchData) {
      allBusinesses.push(...batchData);
      console.log(`Batch ${i + 1}/${batches}: ${batchData.length} businesses`);
    }
  }

  console.log(`\nTotal businesses found: ${allBusinesses.length}`);
  console.log('\nFirst 5 businesses:');
  allBusinesses.slice(0, 5).forEach(b => {
    console.log(`- ${b.name} (${b.city || 'no city'}) - ${b.category?.name || 'no category'}`);
  });
}

testBatchSearch().catch(console.error);
