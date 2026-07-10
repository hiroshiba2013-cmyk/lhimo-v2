import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('Missing environment variables!');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

async function registerAdmin() {
  const email = 'admin@italianreview.com';
  const password = 'AdminSecure2024!';
  const fullName = 'Super Amministratore';
  const nickname = 'admin001';
  const fiscalCode = 'ADMINS00A01H501A';

  console.log('Registering admin user...');

  try {
    // First check if user already exists in auth
    const { data: existingUsers } = await supabase.auth.admin.listUsers();
    const existingUser = existingUsers.users.find(u => u.email === email);

    let userId;

    if (existingUser) {
      console.log('User already exists in auth:', existingUser.id);
      userId = existingUser.id;

      // Check if profile exists
      const { data: existingProfile } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();

      if (existingProfile) {
        console.log('Profile exists, updating...');

        // Update profile to be admin
        const { error: updateError } = await supabase
          .from('profiles')
          .update({
            user_type: 'admin',
            is_admin: true,
            subscription_status: 'active',
          })
          .eq('id', userId);

        if (updateError) {
          console.error('Error updating profile:', updateError);
          throw updateError;
        }
      } else {
        console.log('Profile does not exist, creating...');

        // Create profile
        const { error: profileError } = await supabase
          .from('profiles')
          .insert({
            id: userId,
            email,
            full_name: fullName,
            fiscal_code: fiscalCode,
            nickname,
            user_type: 'admin',
            subscription_status: 'active',
            is_admin: true,
          });

        if (profileError) {
          console.error('Error creating profile:', profileError);
          throw profileError;
        }
      }
    } else {
      console.log('Creating new user in auth...');

      // Create user in auth
      const { data: authData, error: signUpError } = await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: {
          full_name: fullName,
        },
      });

      if (signUpError) {
        console.error('SignUp error:', signUpError);
        throw signUpError;
      }

      if (!authData.user) {
        throw new Error('No user returned from auth');
      }

      userId = authData.user.id;
      console.log('User created:', userId);

      // Create profile
      console.log('Creating profile...');
      const { error: profileError } = await supabase
        .from('profiles')
        .insert({
          id: userId,
          email,
          full_name: fullName,
          fiscal_code: fiscalCode,
          nickname,
          user_type: 'admin',
          subscription_status: 'active',
          is_admin: true,
        });

      if (profileError) {
        console.error('Profile error:', profileError);
        throw profileError;
      }
    }

    console.log('Checking admins table...');

    // Check if already in admins table
    const { data: existingAdmin } = await supabase
      .from('admins')
      .select('*')
      .eq('user_id', userId)
      .maybeSingle();

    if (existingAdmin) {
      console.log('Already in admins table');
    } else {
      console.log('Adding to admins table...');
      const { error: adminError } = await supabase
        .from('admins')
        .insert({
          user_id: userId,
        });

      if (adminError) {
        console.error('Admin error:', adminError);
        throw adminError;
      }
    }

    console.log('\n✅ Admin registered successfully!');
    console.log('\nCredentials:');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('User ID:', userId);
    console.log('\nYou can now login at /admin-login');

    // Verify the setup
    console.log('\nVerifying setup...');
    const { data: profile } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single();

    console.log('Profile:', profile);

    const { data: adminRecord } = await supabase
      .from('admins')
      .select('*')
      .eq('user_id', userId)
      .single();

    console.log('Admin record:', adminRecord);

  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

registerAdmin();
