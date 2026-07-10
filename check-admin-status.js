import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

async function checkAdminStatus() {
  console.log('\n=== Controllo Stato Admin ===\n');

  // Check if there are any admins
  const { data: admins, error: adminsError } = await supabase
    .from('admins')
    .select('user_id');

  if (adminsError) {
    console.error('Errore nel controllare la tabella admins:', adminsError);
    return;
  }

  console.log(`Numero totale di admin nella tabella admins: ${admins?.length || 0}`);

  if (!admins || admins.length === 0) {
    console.log('\n❌ Nessun admin trovato nel sistema!');
    console.log('\n📝 Per creare un admin, segui questi passi:');
    console.log('1. Registrati normalmente su /');
    console.log('2. Esegui questa query SQL:');
    console.log(`
UPDATE profiles
SET is_admin = true, user_type = 'admin'
WHERE email = 'TUA_EMAIL@example.com';

INSERT INTO admins (user_id)
SELECT id FROM profiles WHERE email = 'TUA_EMAIL@example.com'
ON CONFLICT (user_id) DO NOTHING;
    `);
    return;
  }

  // Get admin details
  console.log('\n✅ Admin trovati:\n');

  for (const admin of admins) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('id, email, full_name, user_type, is_admin')
      .eq('id', admin.user_id)
      .single();

    if (profile) {
      console.log(`📧 Email: ${profile.email}`);
      console.log(`👤 Nome: ${profile.full_name}`);
      console.log(`🔑 User Type: ${profile.user_type}`);
      console.log(`✓ Is Admin: ${profile.is_admin}`);
      console.log(`🆔 User ID: ${profile.id}`);
      console.log('---');
    }
  }

  console.log('\n💡 Per accedere come admin:');
  console.log('1. Vai su /admin-login');
  console.log('2. Usa le credenziali dell\'admin registrato');
}

checkAdminStatus().catch(console.error);
