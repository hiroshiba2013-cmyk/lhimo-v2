import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;

async function registerAdmin() {
  const adminData = {
    email: 'superadmin@example.com',
    password: 'SuperAdmin2024!',
    fullName: 'Super Admin',
    fiscalCode: 'SPRADM00A01H501Z',
    userCode: 'superadmin',
    adminKey: 'ADMIN_2024_SECRET_KEY',
  };

  console.log('🔐 Registering new admin...\n');
  console.log('Email:', adminData.email);
  console.log('Password:', adminData.password);
  console.log('User Code:', adminData.userCode);
  console.log('');

  try {
    const response = await fetch(`${supabaseUrl}/functions/v1/admin-register`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(adminData),
    });

    const result = await response.json();

    if (!response.ok) {
      console.error('❌ Error:', result.error);
      return;
    }

    console.log('✅ SUCCESS! Admin account created!\n');
    console.log('Login credentials:');
    console.log('Email:', adminData.email);
    console.log('Password:', adminData.password);
    console.log('\nGo to /admin-login to access the admin dashboard');

  } catch (error) {
    console.error('❌ Unexpected error:', error);
  }
}

registerAdmin();
