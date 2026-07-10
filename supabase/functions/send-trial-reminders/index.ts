import { createClient } from 'npm:@supabase/supabase-js@2.57.4';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Client-Info, Apikey',
};

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
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const sevenDaysFromNow = new Date();
    sevenDaysFromNow.setDate(sevenDaysFromNow.getDate() + 7);
    const startOfDay = new Date(sevenDaysFromNow);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(sevenDaysFromNow);
    endOfDay.setHours(23, 59, 59, 999);

    const { data: subscriptions, error } = await supabase
      .from('subscriptions')
      .select(`
        *,
        subscription_plans(*),
        customer:customer_id(
          id,
          email
        )
      `)
      .eq('status', 'trial')
      .eq('reminder_sent', false)
      .gte('trial_end_date', startOfDay.toISOString())
      .lte('trial_end_date', endOfDay.toISOString());

    if (error) throw error;

    const results = [];

    for (const subscription of subscriptions || []) {
      const trialEndDate = new Date(subscription.trial_end_date);
      const formattedDate = trialEndDate.toLocaleDateString('it-IT', {
        day: '2-digit',
        month: 'long',
        year: 'numeric',
      });

      const planName = subscription.subscription_plans.name;
      const billingPeriod = subscription.subscription_plans.billing_period === 'monthly' ? 'mensile' : 'annuale';
      const price = subscription.subscription_plans.price.toFixed(2);

      results.push({
        subscription_id: subscription.id,
        email: subscription.customer.email,
        trial_end_date: formattedDate,
        plan_name: planName,
        billing_period: billingPeriod,
        price: price,
      });

      const { error: updateError } = await supabase
        .from('subscriptions')
        .update({ reminder_sent: true })
        .eq('id', subscription.id);

      if (updateError) {
        console.error(`Error updating subscription ${subscription.id}:`, updateError);
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: `Processed ${results.length} trial reminders`,
        reminders: results,
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  } catch (error) {
    console.error('Error processing trial reminders:', error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  }
});