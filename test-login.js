import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testLogin() {
  try {
    console.log('Testing login...');

    const email = 'francesco.esposto92@gmail.com';
    const password = 'Hiro2013';

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      console.error('Login error:', error);
      return;
    }

    console.log('Login successful!');
    console.log('User ID:', data.user.id);
    console.log('Email:', data.user.email);

    // Get profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', data.user.id)
      .single();

    if (profileError) {
      console.error('Profile error:', profileError);
    } else {
      console.log('\nProfile:', profile);
    }

    // Check if in admins table
    const { data: adminData, error: adminError } = await supabase
      .from('admins')
      .select('*')
      .eq('user_id', data.user.id)
      .maybeSingle();

    if (adminError) {
      console.error('Admin check error:', adminError);
    } else if (adminData) {
      console.log('\nUser is in admins table:', adminData);
    } else {
      console.log('\nUser is NOT in admins table');
    }

  } catch (error) {
    console.error('Error:', error);
  }
}

testLogin();
