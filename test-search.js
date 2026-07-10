import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function testSearch() {
  console.log('Testing search for Lombardia...\n');

  // Step 1: Query business_locations
  console.log('Step 1: Querying business_locations for Lombardia...');
  const { data: locationData, error: locationError } = await supabase
    .from('business_locations')
    .select('business_id, city, province, region')
    .eq('region', 'Lombardia');

  if (locationError) {
    console.error('Error querying locations:', locationError);
    return;
  }

  console.log(`Found ${locationData?.length || 0} locations`);
  if (locationData && locationData.length > 0) {
    console.log('First 3 locations:', locationData.slice(0, 3));
  }

  // Step 2: Get business IDs
  const businessIds = locationData
    ?.map(loc => loc.business_id)
    .filter(id => id != null) || [];

  console.log(`\nStep 2: Extracted ${businessIds.length} business IDs`);
  console.log('First 3 IDs:', businessIds.slice(0, 3));

  if (businessIds.length === 0) {
    console.log('No business IDs found, stopping here.');
    return;
  }

  // Step 3: Query businesses
  console.log('\nStep 3: Querying businesses...');
  const { data: businessData, error: businessError } = await supabase
    .from('businesses')
    .select(`
      id,
      name,
      city,
      category:business_categories(name)
    `)
    .in('id', businessIds.slice(0, 100)); // Test with first 100

  if (businessError) {
    console.error('Error querying businesses:', businessError);
    return;
  }

  console.log(`Found ${businessData?.length || 0} businesses`);
  if (businessData && businessData.length > 0) {
    console.log('\nFirst 5 businesses:');
    businessData.slice(0, 5).forEach(b => {
      console.log(`- ${b.name} (${b.city || 'no city'}) - ${b.category?.name || 'no category'}`);
    });
  }

  // Step 4: Test complete query as frontend does
  console.log('\n\nStep 4: Testing complete frontend query...');

  const locationQuery = supabase
    .from('business_locations')
    .select('business_id')
    .eq('region', 'Lombardia');

  const { data: locData } = await locationQuery;

  const ids = locData?.map(loc => loc.business_id).filter(id => id != null) || [];

  console.log(`Location query returned ${ids.length} IDs`);

  if (ids.length === 0) {
    console.log('ERROR: No IDs returned from location query!');
    return;
  }

  const query = supabase
    .from('businesses')
    .select(`
      *,
      category:business_categories(*)
    `)
    .in('id', ids);

  const { data: finalData, error: finalError } = await query;

  if (finalError) {
    console.error('Final query error:', finalError);
    return;
  }

  console.log(`Final query returned ${finalData?.length || 0} businesses`);
}

testSearch().catch(console.error);
