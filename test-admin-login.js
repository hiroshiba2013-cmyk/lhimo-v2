import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Missing Supabase credentials in .env file');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testAdminLogin() {
  console.log('\n=== Test Admin Login ===\n');

  const email = 'admin@example.com';
  const password = 'admin123'; // Devi usare la password corretta

  try {
    // 1. Login
    console.log('1. Attempting login with:', email);
    const { data: authData, error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (signInError) {
      console.error('❌ Login failed:', signInError.message);
      return;
    }

    console.log('✅ Login successful');
    console.log('   User ID:', authData.user.id);

    // 2. Check admin status
    console.log('\n2. Checking admin status...');
    const { data: adminCheck, error: adminError } = await supabase
      .from('admins')
      .select('user_id')
      .eq('user_id', authData.user.id)
      .maybeSingle();

    if (adminError) {
      console.error('❌ Admin check failed:', adminError.message);
      await supabase.auth.signOut();
      return;
    }

    if (!adminCheck) {
      console.log('❌ User is not an admin');
      await supabase.auth.signOut();
      return;
    }

    console.log('✅ User is an admin');

    // 3. Check profile
    console.log('\n3. Checking profile...');
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', authData.user.id)
      .single();

    if (profileError) {
      console.error('❌ Profile check failed:', profileError.message);
    } else {
      console.log('✅ Profile found:');
      console.log('   Email:', profile.email);
      console.log('   Full Name:', profile.full_name);
      console.log('   User Type:', profile.user_type);
      console.log('   Nickname:', profile.nickname);
    }

    // 4. Logout
    console.log('\n4. Logging out...');
    await supabase.auth.signOut();
    console.log('✅ Logged out successfully');

    console.log('\n=== Test Completed Successfully ===\n');
  } catch (err) {
    console.error('\n❌ Unexpected error:', err.message);
  }
}

testAdminLogin();
