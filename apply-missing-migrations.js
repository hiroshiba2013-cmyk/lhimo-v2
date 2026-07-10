import { createClient } from '@supabase/supabase-js';
import { readFileSync, readdirSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('Missing Supabase credentials');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function getAppliedMigrations() {
  const { data, error } = await supabase
    .from('_migrations')
    .select('filename')
    .order('filename');

  if (error) {
    console.error('Error fetching migrations:', error);
    return [];
  }

  return data.map(m => m.filename);
}

async function applyMigration(filename, content) {
  try {
    console.log(`\nApplying: ${filename}`);

    // Execute SQL
    const { error } = await supabase.rpc('exec_sql', { sql: content });

    if (error) {
      console.error(`  ❌ Error: ${error.message}`);
      return false;
    }

    // Record migration
    const { error: recordError } = await supabase
      .from('_migrations')
      .insert({ filename, applied_at: new Date().toISOString() });

    if (recordError) {
      console.error(`  ❌ Error recording migration: ${recordError.message}`);
      return false;
    }

    console.log(`  ✅ Applied successfully`);
    return true;
  } catch (err) {
    console.error(`  ❌ Exception: ${err.message}`);
    return false;
  }
}

async function main() {
  console.log('🔍 Checking applied migrations...');

  const applied = await getAppliedMigrations();
  console.log(`✅ Found ${applied.length} applied migrations`);

  const migrationsDir = join(__dirname, 'supabase', 'migrations');
  const allFiles = readdirSync(migrationsDir)
    .filter(f => f.endsWith('.sql'))
    .sort();

  console.log(`📁 Found ${allFiles.length} total migration files`);

  const pending = allFiles.filter(f => !applied.includes(f));
  console.log(`⏳ ${pending.length} migrations to apply\n`);

  if (pending.length === 0) {
    console.log('✅ All migrations are already applied!');
    return;
  }

  let success = 0;
  let failed = 0;

  for (const filename of pending) {
    const filepath = join(migrationsDir, filename);
    const content = readFileSync(filepath, 'utf-8');

    const result = await applyMigration(filename, content);
    if (result) {
      success++;
    } else {
      failed++;
      console.log('⚠️  Stopping due to error. Fix the issue and run again.');
      break;
    }

    // Small delay to avoid rate limiting
    await new Promise(resolve => setTimeout(resolve, 100));
  }

  console.log(`\n📊 Summary:`);
  console.log(`  ✅ Successfully applied: ${success}`);
  console.log(`  ❌ Failed: ${failed}`);
  console.log(`  ⏳ Remaining: ${pending.length - success - failed}`);
}

main().catch(console.error);
