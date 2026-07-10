import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('Missing Supabase credentials in .env file');
  console.error('Need: VITE_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

async function resetAdminPassword() {
  const email = 'admin@example.com';
  const newPassword = 'Admin2024!Secure';
  const userId = 'bc580ea3-c03d-4284-9253-a1d911c73052'; // Hardcoded since we know it

  console.log('🔐 Resetting admin password...\n');
  console.log('Email:', email);
  console.log('User ID:', userId);
  console.log('New password:', newPassword);
  console.log('');

  try {
    // Update password using admin API
    const { data, error } = await supabase.auth.admin.updateUserById(
      userId,
      { password: newPassword }
    );

    if (error) {
      console.error('❌ Error updating password:', error);
      console.error('Details:', JSON.stringify(error, null, 2));
      return;
    }

    console.log('✅ Password updated successfully!\n');
    console.log('New credentials:');
    console.log('Email:', email);
    console.log('Password:', newPassword);
    console.log('\nYou can now login at /admin-login');

  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

resetAdminPassword();
