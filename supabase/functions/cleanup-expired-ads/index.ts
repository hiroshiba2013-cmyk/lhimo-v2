import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2.57.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    console.log("Starting expired classified ads cleanup...");

    const { data, error } = await supabase.rpc("delete_expired_classified_ads");

    if (error) {
      console.error("Error cleaning up expired ads:", error);
      throw error;
    }

    console.log(`✓ Cleaned up ${data?.[0]?.deleted_count || 0} expired ads`);
    console.log(`✓ Notified ${data?.[0]?.notified_users?.length || 0} users`);

    return new Response(
      JSON.stringify({
        success: true,
        message: "Expired ads cleanup completed successfully",
        deletedCount: data?.[0]?.deleted_count || 0,
        notifiedUsers: data?.[0]?.notified_users?.length || 0,
        timestamp: new Date().toISOString(),
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  } catch (error) {
    console.error("Error in expired ads cleanup:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : "Unknown error",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  }
});
