const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const client = new Client({
  host: 'db.lrqeojukjpjllnvsjtor.supabase.co',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: 'Hiroshiba2013!',
  ssl: { rejectUnauthorized: false }
});

async function run() {
  await client.connect();
  console.log('Connected!');

  const migrationsDir = '/tmp/cc-agent/60717690/project/supabase/migrations';
  const files = fs.readdirSync(migrationsDir)
    .filter(f => f.endsWith('.sql'))
    .sort();

  console.log(`Found ${files.length} migration files`);

  let success = 0;
  let errors = [];

  for (const file of files) {
    const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf8');
    try {
      await client.query('BEGIN');
      await client.query(sql);
      await client.query('COMMIT');
      success++;
      if (success % 50 === 0) console.log(`Progress: ${success}/${files.length}`);
    } catch(e) {
      await client.query('ROLLBACK');
      errors.push({ file, error: e.message.slice(0, 150) });
    }
  }

  console.log(`\nDone: ${success} OK, ${errors.length} errors`);
  if (errors.length > 0) {
    console.log('\nErrors:');
    errors.slice(0, 20).forEach(e => console.log(`  ${e.file}: ${e.error}`));
  }

  // Check tables
  const r = await client.query("SELECT count(*) FROM pg_tables WHERE schemaname='public'");
  console.log('\nPublic tables created:', r.rows[0].count);

  await client.end();
}

run().catch(e => console.error('Fatal:', e.message));
