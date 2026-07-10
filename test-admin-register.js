import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

async function createAdmin() {
  try {
    console.log('Creating admin user...');

    const email = 'francesco.esposto92@gmail.com';
    const password = 'Hiro2013';
    const fullName = 'Francesco Esposto';
    const fiscalCode = 'SPTFNC92A01H501X';
    const nickname = 'francesco_admin';

    // Check if user already exists
    const { data: existingProfile } = await supabase
      .from('profiles')
      .select('id, email')
      .eq('email', email)
      .maybeSingle();

    if (existingProfile) {
      console.log('User already exists with ID:', existingProfile.id);

      // Update to admin
      const { error: updateError } = await supabase
        .from('profiles')
        .update({
          user_type: 'admin',
          is_admin: true,
          nickname: nickname,
          fiscal_code: fiscalCode.toUpperCase(),
        })
        .eq('id', existingProfile.id);

      if (updateError) {
        console.error('Error updating profile:', updateError);
      } else {
        console.log('Profile updated to admin successfully');
      }

      // Add to admins table
      const { error: adminError } = await supabase
        .from('admins')
        .insert({ user_id: existingProfile.id })
        .select()
        .maybeSingle();

      if (adminError && !adminError.message.includes('duplicate')) {
        console.error('Error adding to admins table:', adminError);
      } else {
        console.log('Added to admins table');
      }

      console.log('\nAdmin account ready!');
      console.log('Email:', email);
      console.log('Password:', password);
      return;
    }

    // Check if nickname is taken
    const { data: existingNickname } = await supabase
      .from('profiles')
      .select('id')
      .eq('nickname', nickname)
      .maybeSingle();

    if (existingNickname) {
      console.error('Nickname already taken');
      return;
    }

    // Create new user
    const { data: authData, error: signUpError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: {
        full_name: fullName,
      },
    });

    if (signUpError) {
      console.error('Error creating user:', signUpError);
      return;
    }

    console.log('User created:', authData.user.id);

    // Create profile
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        email,
        full_name: fullName,
        fiscal_code: fiscalCode.toUpperCase(),
        nickname,
        user_type: 'admin',
        subscription_status: 'none',
        is_admin: true,
      });

    if (profileError) {
      console.error('Error creating profile:', profileError);

      // Cleanup
      await supabase.auth.admin.deleteUser(authData.user.id);
      return;
    }

    console.log('Profile created');

    // Add to admins table
    const { error: adminError } = await supabase
      .from('admins')
      .insert({
        user_id: authData.user.id,
      });

    if (adminError) {
      console.error('Error adding to admins table:', adminError);
    } else {
      console.log('Added to admins table');
    }

    console.log('\nAdmin account created successfully!');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('User ID:', authData.user.id);

  } catch (error) {
    console.error('Error:', error);
  }
}

createAdmin();
