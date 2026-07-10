import { createClient } from 'npm:@supabase/supabase-js@2.97.0';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Client-Info, Apikey',
};

const ADMIN_SECRET_KEY = Deno.env.get('ADMIN_SECRET_KEY') || 'ADMIN_2024_SECRET_KEY';

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    // Create admin client with service role (bypasses RLS)
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

    const { email, password, fullName, fiscalCode, userCode, phone, adminKey } = await req.json();

    // Verify admin key
    if (adminKey !== ADMIN_SECRET_KEY) {
      return new Response(
        JSON.stringify({ error: 'Chiave admin non valida' }),
        {
          status: 403,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // Check if nickname already exists
    const { data: existingCode } = await supabaseAdmin
      .from('profiles')
      .select('id')
      .eq('nickname', userCode)
      .maybeSingle();

    if (existingCode) {
      return new Response(
        JSON.stringify({ error: 'Codice utente già in uso, scegline un altro' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // Create user in auth
    console.log('Creating auth user with email:', email);
    const { data: authData, error: signUpError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true, // Auto-confirm email
      user_metadata: {
        full_name: fullName,
      },
    });

    if (signUpError) {
      console.error('SignUp error:', signUpError);
      return new Response(
        JSON.stringify({
          error: `Errore creazione utente auth: ${signUpError.message}`,
          details: signUpError
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    if (!authData.user) {
      console.error('No user data returned from auth.admin.createUser');
      return new Response(
        JSON.stringify({ error: 'Errore durante la creazione dell\'account - nessun dato utente restituito' }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    console.log('Auth user created successfully with ID:', authData.user.id);

    // Split full name into first and last name
    const nameParts = fullName.trim().split(' ');
    const firstName = nameParts[0] || '';
    const lastName = nameParts.slice(1).join(' ') || '';

    // Wait a moment for trigger to complete
    await new Promise(resolve => setTimeout(resolve, 100));

    // Update or create profile directly (bypassing RLS)
    console.log('Updating/Creating profile for user ID:', authData.user.id);
    const { error: profileError } = await supabaseAdmin
      .from('profiles')
      .upsert({
        id: authData.user.id,
        email,
        full_name: fullName,
        first_name: firstName,
        last_name: lastName,
        fiscal_code: fiscalCode.toUpperCase(),
        nickname: userCode,
        phone: phone || null,
        user_type: 'admin',
        is_admin: true,
        subscription_status: null,
        subscription_type: null,
      }, {
        onConflict: 'id'
      });

    if (profileError) {
      console.error('Profile creation error:', profileError);
      console.error('Profile error details:', JSON.stringify(profileError, null, 2));

      // Cleanup: delete the auth user if profile creation fails
      console.log('Cleaning up auth user...');
      await supabaseAdmin.auth.admin.deleteUser(authData.user.id);

      return new Response(
        JSON.stringify({
          error: `Errore database creazione profilo: ${profileError.message}`,
          code: profileError.code,
          details: profileError.details
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    console.log('Profile created successfully');

    // Add to admins table
    const { error: adminError } = await supabaseAdmin
      .from('admins')
      .insert({
        user_id: authData.user.id,
      });

    if (adminError) {
      console.error('Admin error:', adminError);
      // Don't fail completely, just log it
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Account admin creato con successo',
        userId: authData.user.id,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  } catch (error: any) {
    console.error('Error:', error);
    return new Response(
      JSON.stringify({ error: error.message || 'Errore interno del server' }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
