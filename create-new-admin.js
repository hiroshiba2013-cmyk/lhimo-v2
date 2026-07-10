import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Missing Supabase credentials in .env file');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function createNewAdmin() {
  const email = 'admin2@example.com';
  const password = 'Admin2024!Secure';
  const fullName = 'Admin Principale';
  const nickname = 'admin2';
  const fiscalCode = 'ADMIN00000000002';

  console.log('🔐 Creating new admin account...\n');
  console.log('Email:', email);
  console.log('Password:', password);
  console.log('Full name:', fullName);
  console.log('');

  try {
    // Step 1: Sign up
    console.log('Step 1: Creating auth user...');
    const { data: authData, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
    });

    if (signUpError) {
      console.error('❌ Sign up error:', signUpError.message);
      return;
    }

    if (!authData.user) {
      console.error('❌ No user returned from signup');
      return;
    }

    console.log('✅ Auth user created:', authData.user.id);

    // Step 2: Create profile
    console.log('\nStep 2: Creating profile...');
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        email,
        full_name: fullName,
        nickname,
        fiscal_code: fiscalCode,
        user_type: 'admin',
        is_admin: true,
        subscription_status: 'active',
      });

    if (profileError) {
      console.error('❌ Profile error:', profileError);
      // Try to continue anyway
    } else {
      console.log('✅ Profile created');
    }

    // Step 3: Add to admins table
    console.log('\nStep 3: Adding to admins table...');
    const { error: adminError } = await supabase
      .from('admins')
      .insert({
        user_id: authData.user.id,
      });

    if (adminError) {
      console.error('❌ Admin table error:', adminError);
    } else {
      console.log('✅ Added to admins table');
    }

    console.log('\n✅ SUCCESS! Admin account created!\n');
    console.log('Login credentials:');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('\nGo to /admin-login to access the admin dashboard');

    // Sign out
    await supabase.auth.signOut();

  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

createNewAdmin();
