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

async function testAdminLogin() {
  console.log('🔐 Testing admin login...\n');

  const email = 'admin@example.com';
  const password = 'Hiro2013';

  try {
    // Step 1: Sign in
    console.log('Step 1: Signing in with email:', email);
    const { data: authData, error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (signInError) {
      console.error('❌ Sign in error:', signInError.message);

      // Try to check if user exists
      const { data: profile } = await supabase
        .from('profiles')
        .select('email, user_type, is_admin')
        .eq('email', email)
        .maybeSingle();

      if (profile) {
        console.log('✅ Profile exists:', profile);
        console.log('❗ The issue is with the password. Try resetting it.');
      } else {
        console.log('❌ Profile not found');
      }

      return;
    }

    console.log('✅ Signed in successfully');
    console.log('User ID:', authData.user.id);

    // Step 2: Check admin status
    console.log('\nStep 2: Checking admin status...');
    const { data: adminCheck, error: adminError } = await supabase
      .from('admins')
      .select('user_id')
      .eq('user_id', authData.user.id)
      .maybeSingle();

    if (adminError) {
      console.error('❌ Admin check error:', adminError);
      await supabase.auth.signOut();
      return;
    }

    if (!adminCheck) {
      console.log('❌ User is not an admin');
      await supabase.auth.signOut();
      return;
    }

    console.log('✅ Admin verified');

    // Step 3: Get full profile
    console.log('\nStep 3: Getting full profile...');
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', authData.user.id)
      .single();

    if (profileError) {
      console.error('❌ Profile error:', profileError);
    } else {
      console.log('✅ Profile:', {
        email: profile.email,
        full_name: profile.full_name,
        user_type: profile.user_type,
        is_admin: profile.is_admin,
        subscription_status: profile.subscription_status,
      });
    }

    // Step 4: Log admin login
    console.log('\nStep 4: Logging admin login...');
    const { error: logError } = await supabase.from('admin_login_logs').insert({
      admin_id: authData.user.id,
      login_time: new Date().toISOString(),
    });

    if (logError) {
      console.error('❌ Log error:', logError);
    } else {
      console.log('✅ Login logged successfully');
    }

    console.log('\n✅ ALL CHECKS PASSED - Admin login successful!');
    console.log('You should be able to access /admin dashboard');

    // Sign out
    await supabase.auth.signOut();
    console.log('\n✅ Signed out');

  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

testAdminLogin();
