import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';

dotenv.config();

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('❌ Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env file');
  console.error('\nPlease add SUPABASE_SERVICE_ROLE_KEY to your .env file');
  console.error('You can find it in: Supabase Dashboard > Project Settings > API > service_role key');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

const ADMIN_CREDENTIALS = {
  email: 'admin@cittabella.it',
  password: 'AdminCitta2026!',
  full_name: 'Admin Cittabella',
  user_type: 'customer'
};

async function createAdmin() {
  console.log('🔧 Creating admin user...\n');
  console.log('📧 Email:', ADMIN_CREDENTIALS.email);
  console.log('🔑 Password:', ADMIN_CREDENTIALS.password);
  console.log('');

  try {
    // Create user with admin email
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email: ADMIN_CREDENTIALS.email,
      password: ADMIN_CREDENTIALS.password,
      email_confirm: true,
      user_metadata: {
        full_name: ADMIN_CREDENTIALS.full_name
      }
    });

    if (authError) {
      console.error('❌ Error creating user:', authError.message);
      process.exit(1);
    }

    console.log('✅ User created successfully!');
    console.log('👤 User ID:', authData.user.id);

    // Wait a moment for the profile to be created by trigger
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Set user as admin
    const { error: updateError } = await supabase
      .from('profiles')
      .update({
        is_admin: true,
        full_name: ADMIN_CREDENTIALS.full_name,
        user_type: ADMIN_CREDENTIALS.user_type
      })
      .eq('id', authData.user.id);

    if (updateError) {
      console.error('❌ Error setting admin role:', updateError.message);
      process.exit(1);
    }

    console.log('✅ Admin role granted successfully!\n');

    // Verify admin status
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('id, full_name, email, is_admin, user_type')
      .eq('id', authData.user.id)
      .single();

    if (profileError) {
      console.error('❌ Error verifying profile:', profileError.message);
    } else {
      console.log('✅ Admin Profile Created:\n');
      console.log('   ID:', profile.id);
      console.log('   Name:', profile.full_name);
      console.log('   Email:', profile.email);
      console.log('   Admin:', profile.is_admin ? '✓ YES' : '✗ NO');
      console.log('   Type:', profile.user_type);
      console.log('');
    }

    console.log('🎉 Admin account ready to use!\n');
    console.log('📝 Login Credentials:');
    console.log('   Email:', ADMIN_CREDENTIALS.email);
    console.log('   Password:', ADMIN_CREDENTIALS.password);
    console.log('');
    console.log('🔗 You can now login at: /admin/login');

  } catch (error) {
    console.error('❌ Unexpected error:', error);
    process.exit(1);
  }
}

createAdmin();
