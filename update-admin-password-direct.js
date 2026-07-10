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

async function updatePassword() {
  console.log('🔐 Updating admin password in auth.users...\n');

  const userId = 'bc580ea3-c03d-4284-9253-a1d911c73052';
  const newPassword = 'Admin2024!Secure';

  try {
    // Try updating via SQL directly
    const { error } = await supabase.rpc('update_user_password', {
      user_id: userId,
      new_password: newPassword
    });

    if (error) {
      console.error('❌ Error:', error.message);
      console.log('\n💡 Alternative: Try logging in with your original password.');
      console.log('💡 Or use the web interface to reset password.');
      return;
    }

    console.log('✅ Password updated!\n');
    console.log('New credentials:');
    console.log('Email: admin@example.com');
    console.log('Password:', newPassword);

  } catch (error) {
    console.error('❌ Error:', error);
    console.log('\n💡 The function to update password might not exist.');
    console.log('💡 Please tell me what password you used when creating the admin account.');
  }
}

updatePassword();
