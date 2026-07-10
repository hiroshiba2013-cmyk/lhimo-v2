import { createClient } from '@supabase/supabase-js';
import { readFileSync, readdirSync } from 'fs';
import { join } from 'path';

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing VITE_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: { persistSession: false }
});

async function getAppliedMigrations() {
  const { data, error } = await supabase
    .rpc('get_applied_migrations')
    .select('*');

  if (error && error.code !== 'PGRST202') {
    // If function doesn't exist, query table directly
    const { data: migrations } = await supabase
      .from('_supabase_migrations')
      .select('version');

    return migrations ? migrations.map(m => m.version + '.sql') : [];
  }

  return data || [];
}

async function applyMigration(filename, sql) {
  console.log(`\n📝 Applying: ${filename}`);

  try {
    const { error } = await supabase.rpc('exec_sql', { sql_query: sql });

    if (error) {
      // Try direct execution via REST API
      const response = await fetch(`${supabaseUrl}/rest/v1/rpc/exec_sql`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': supabaseServiceKey,
          'Authorization': `Bearer ${supabaseServiceKey}`
        },
        body: JSON.stringify({ sql_query: sql })
      });

      if (!response.ok) {
        console.error(`   ❌ Failed: ${error.message}`);
        return false;
      }
    }

    console.log(`   ✅ Success`);
    return true;
  } catch (err) {
    console.error(`   ❌ Error: ${err.message}`);
    return false;
  }
}

async function main() {
  console.log('🚀 Starting migration process...\n');

  const migrationsDir = join(process.cwd(), 'supabase', 'migrations');
  const allMigrations = readdirSync(migrationsDir)
    .filter(f => f.endsWith('.sql'))
    .sort();

  console.log(`📁 Found ${allMigrations.length} migration files\n`);

  const applied = await getAppliedMigrations();
  console.log(`✅ ${applied.length} migrations already applied\n`);

  const pending = allMigrations.filter(f => !applied.includes(f));
  console.log(`⏳ ${pending.length} migrations to apply\n`);

  if (pending.length === 0) {
    console.log('✨ Database is up to date!');
    return;
  }

  let successCount = 0;
  let failureCount = 0;

  for (const filename of pending) {
    const filepath = join(migrationsDir, filename);
    const sql = readFileSync(filepath, 'utf-8');

    const success = await applyMigration(filename, sql);

    if (success) {
      successCount++;
    } else {
      failureCount++;
      console.log('\n⚠️  Migration failed. Check error above.');
      console.log('💡 Fix the issue and run this script again.\n');
      break;
    }

    // Rate limiting
    await new Promise(resolve => setTimeout(resolve, 200));
  }

  console.log('\n' + '='.repeat(50));
  console.log('📊 MIGRATION SUMMARY');
  console.log('='.repeat(50));
  console.log(`✅ Successfully applied: ${successCount}`);
  console.log(`❌ Failed: ${failureCount}`);
  console.log(`⏳ Remaining: ${pending.length - successCount - failureCount}`);
  console.log('='.repeat(50) + '\n');

  if (failureCount === 0 && successCount > 0) {
    console.log('🎉 All pending migrations applied successfully!');
  }
}

main().catch(err => {
  console.error('💥 Fatal error:', err);
  process.exit(1);
});
