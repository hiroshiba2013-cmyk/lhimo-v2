import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function getDetailedStats() {
  console.clear();
  console.log('╔══════════════════════════════════════════════════════════════════╗');
  console.log('║      📊 STATISTICHE DETTAGLIATE IMPORTAZIONE OSM ITALIA          ║');
  console.log('╚══════════════════════════════════════════════════════════════════╝\n');

  // Totale generale
  const { count: total } = await supabase
    .from('unclaimed_business_locations')
    .select('*', { count: 'exact', head: true });

  console.log(`🎯 TOTALE ATTIVITÀ IMPORTATE: ${(total || 0).toLocaleString()}\n`);
  console.log('═'.repeat(70) + '\n');

  // 1. PER REGIONE
  console.log('📍 1. DIVISIONE PER REGIONE');
  console.log('─'.repeat(70));

  const { data: allData } = await supabase
    .from('unclaimed_business_locations')
    .select('region, province, city, category_id');

  const regionStats = {};
  allData?.forEach(row => {
    if (!regionStats[row.region]) {
      regionStats[row.region] = { count: 0, provinces: new Set(), cities: new Set() };
    }
    regionStats[row.region].count++;
    if (row.province) regionStats[row.region].provinces.add(row.province);
    if (row.city) regionStats[row.region].cities.add(row.city);
  });

  Object.entries(regionStats)
    .sort(([,a], [,b]) => b.count - a.count)
    .forEach(([region, stats], i) => {
      const bar = '█'.repeat(Math.floor(stats.count / 300));
      console.log(`${(i + 1).toString().padStart(2)}. ${region.padEnd(25)} ${stats.count.toLocaleString().padStart(6)} attività  |  ${stats.provinces.size} prov  |  ${stats.cities.size} città ${bar}`);
    });

  // 2. PER PROVINCIA
  console.log('\n\n🏙️  2. DIVISIONE PER PROVINCIA (Top 30)');
  console.log('─'.repeat(70));

  const provinceStats = {};
  allData?.forEach(row => {
    const key = `${row.province || 'N/D'} (${row.region})`;
    if (!provinceStats[key]) {
      provinceStats[key] = { count: 0, cities: new Set() };
    }
    provinceStats[key].count++;
    if (row.city) provinceStats[key].cities.add(row.city);
  });

  Object.entries(provinceStats)
    .sort(([,a], [,b]) => b.count - a.count)
    .slice(0, 30)
    .forEach(([prov, stats], i) => {
      const bar = '█'.repeat(Math.floor(stats.count / 200));
      console.log(`${(i + 1).toString().padStart(2)}. ${prov.padEnd(40)} ${stats.count.toLocaleString().padStart(6)} attività  |  ${stats.cities.size} città ${bar}`);
    });

  // 3. PER CITTÀ
  console.log('\n\n🏘️  3. DIVISIONE PER CITTÀ (Top 40)');
  console.log('─'.repeat(70));

  const cityStats = {};
  allData?.forEach(row => {
    if (!row.city) return;
    const key = `${row.city} (${row.province || row.region})`;
    cityStats[key] = (cityStats[key] || 0) + 1;
  });

  Object.entries(cityStats)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 40)
    .forEach(([city, count], i) => {
      const bar = '█'.repeat(Math.floor(count / 100));
      console.log(`${(i + 1).toString().padStart(2)}. ${city.padEnd(45)} ${count.toLocaleString().padStart(6)} ${bar}`);
    });

  // 4. PER CATEGORIA
  console.log('\n\n🏪 4. DIVISIONE PER CATEGORIA (Top 40)');
  console.log('─'.repeat(70));

  const { data: withCategories } = await supabase
    .from('unclaimed_business_locations')
    .select(`
      category_id,
      business_categories (
        name
      )
    `);

  const categoryStats = {};
  withCategories?.forEach(row => {
    const catName = row.business_categories?.name || 'Altro';
    categoryStats[catName] = (categoryStats[catName] || 0) + 1;
  });

  Object.entries(categoryStats)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 40)
    .forEach(([category, count], i) => {
      const bar = '█'.repeat(Math.floor(count / 150));
      console.log(`${(i + 1).toString().padStart(2)}. ${category.padEnd(40)} ${count.toLocaleString().padStart(6)} ${bar}`);
    });

  // 5. TABELLA INCROCIATA: Top 5 Categorie per Top 10 Province
  console.log('\n\n📊 5. CATEGORIE PIÙ COMUNI PER PROVINCIA');
  console.log('─'.repeat(70));

  const topProvinces = Object.entries(provinceStats)
    .sort(([,a], [,b]) => b.count - a.count)
    .slice(0, 10)
    .map(([name]) => name);

  for (const prov of topProvinces) {
    const provCode = prov.split('(')[0].trim();
    const { data: provData } = await supabase
      .from('unclaimed_business_locations')
      .select(`
        category_id,
        business_categories (name)
      `)
      .or(`province.eq.${provCode},city.ilike.%${provCode}%`)
      .limit(1000);

    const catCounts = {};
    provData?.forEach(row => {
      const catName = row.business_categories?.name || 'Altro';
      catCounts[catName] = (catCounts[catName] || 0) + 1;
    });

    const topCats = Object.entries(catCounts)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 5)
      .map(([name, count]) => `${name}(${count})`)
      .join(', ');

    console.log(`\n${prov}:`);
    console.log(`   ${topCats || 'Nessun dato'}`);
  }

  // Timestamp
  console.log('\n\n' + '═'.repeat(70));
  console.log(`⏰ Report generato: ${new Date().toLocaleString('it-IT')}`);
  console.log('═'.repeat(70) + '\n');
}

getDetailedStats().catch(console.error);
