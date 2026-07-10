import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function registerAdmin() {
  try {
    console.log('Registering admin...');

    const email = 'francesco.esposto92@gmail.com';
    const password = 'Hiro2013';
    const fullName = 'Francesco Esposto';
    const fiscalCode = 'SPTFNC92A01H501X';
    const nickname = 'admin_123456';

    // Check if user already exists
    const { data: existingProfile } = await supabase
      .from('profiles')
      .select('id, email, is_admin')
      .eq('email', email)
      .maybeSingle();

    if (existingProfile) {
      console.log('User already exists:', existingProfile);
      console.log('Is admin:', existingProfile.is_admin);

      // Try to sign in
      const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (signInError) {
        console.error('Cannot sign in:', signInError.message);
        console.log('\nIf you need to update this user to admin, use the Supabase dashboard SQL editor and run:');
        console.log(`
UPDATE profiles
SET user_type = 'admin', is_admin = true, nickname = 'admin_123456', fiscal_code = 'SPTFNC92A01H501X'
WHERE id = '${existingProfile.id}';

INSERT INTO admins (user_id) VALUES ('${existingProfile.id}') ON CONFLICT DO NOTHING;
        `);
      } else {
        console.log('Sign in successful!');
        console.log('Session:', signInData.session?.access_token ? 'Active' : 'None');
      }
      return;
    }

    // Sign up
    console.log('Creating new user...');
    const { data: authData, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          fiscal_code: fiscalCode,
          nickname: nickname,
          user_type: 'admin',
        },
      },
    });

    if (signUpError) {
      console.error('Sign up error:', signUpError);
      return;
    }

    if (!authData.user) {
      console.error('No user returned');
      return;
    }

    console.log('User created:', authData.user.id);

    // Wait a bit for the profile to be created
    await new Promise(resolve => setTimeout(resolve, 2000));

    // Update profile to admin
    console.log('Updating profile to admin...');
    const { error: updateError } = await supabase
      .from('profiles')
      .update({
        user_type: 'admin',
        is_admin: true,
        fiscal_code: fiscalCode,
        nickname: nickname,
      })
      .eq('id', authData.user.id);

    if (updateError) {
      console.error('Update error:', updateError);
    } else {
      console.log('Profile updated successfully');
    }

    // Add to admins table
    console.log('Adding to admins table...');
    const { error: adminError } = await supabase
      .from('admins')
      .insert({
        user_id: authData.user.id,
      });

    if (adminError) {
      console.error('Admin table error:', adminError);
    } else {
      console.log('Added to admins table');
    }

    console.log('\n=== ADMIN ACCOUNT CREATED ===');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('User ID:', authData.user.id);
    console.log('\nYou can now login at /admin-login');

  } catch (error) {
    console.error('Error:', error);
  }
}

registerAdmin();
