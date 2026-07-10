import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function checkStats() {
  console.log('\n╔════════════════════════════════════════════════════════════════╗');
  console.log('║         STATISTICHE ATTIVITÀ NEL DATABASE                      ║');
  console.log('╚════════════════════════════════════════════════════════════════╝\n');

  const { count: total } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true });

  console.log(`📊 TOTALE ATTIVITÀ: ${total?.toLocaleString() || 0}\n`);

  const { data: byRegion } = await supabase
    .from('unclaimed_business_locations')
    .select('region')
    .order('region');

  if (byRegion) {
    const regionCounts = {};
    byRegion.forEach(r => {
      regionCounts[r.region] = (regionCounts[r.region] || 0) + 1;
    });

    console.log('🗺️  PER REGIONE:');
    Object.entries(regionCounts)
      .sort(([,a], [,b]) => b - a)
      .forEach(([region, count]) => {
        console.log(`   ${region.padEnd(30)} ${count.toLocaleString()}`);
      });
  }

  const { data: byProvince } = await supabase
    .from('unclaimed_business_locations')
    .select('province, region')
    .order('province');

  if (byProvince) {
    const provinceCounts = {};
    byProvince.forEach(p => {
      const key = `${p.province} (${p.region})`;
      provinceCounts[key] = (provinceCounts[key] || 0) + 1;
    });

    console.log('\n🏛️  TOP 20 PROVINCE:');
    Object.entries(provinceCounts)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 20)
      .forEach(([prov, count], i) => {
        console.log(`   ${(i+1).toString().padStart(2)}. ${prov.padEnd(35)} ${count.toLocaleString()}`);
      });
  }

  const { data: categories } = await supabase
    .from('unclaimed_business_locations')
    .select('category_id, business_categories(name)');

  if (categories) {
    const categoryCounts = {};
    categories.forEach(c => {
      const catName = c.business_categories?.name || 'Sconosciuta';
      categoryCounts[catName] = (categoryCounts[catName] || 0) + 1;
    });

    console.log('\n📋 TOP 15 CATEGORIE:');
    Object.entries(categoryCounts)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 15)
      .forEach(([cat, count], i) => {
        console.log(`   ${(i+1).toString().padStart(2)}. ${cat.padEnd(35)} ${count.toLocaleString()}`);
      });
  }

  const { count: withEmail } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true })
    .not('email', 'is', null)
    .neq('email', '');

  const { count: withPhone } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true })
    .not('phone', 'is', null)
    .neq('phone', '');

  const { count: withWebsite } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true })
    .not('website', 'is', null)
    .neq('website', '');

  console.log('\n📧 CONTATTI:');
  console.log(`   Con Email:     ${withEmail?.toLocaleString() || 0} (${total ? ((withEmail/total)*100).toFixed(1) : 0}%)`);
  console.log(`   Con Telefono:  ${withPhone?.toLocaleString() || 0} (${total ? ((withPhone/total)*100).toFixed(1) : 0}%)`);
  console.log(`   Con Sito Web:  ${withWebsite?.toLocaleString() || 0} (${total ? ((withWebsite/total)*100).toFixed(1) : 0}%)`);

  console.log('\n' + '='.repeat(70) + '\n');
}

checkStats().catch(console.error);
