import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Download all Italian comuni from public open data
    const resp = await fetch("https://raw.githubusercontent.com/Samurai016/Comuni-ITA/master/data/comuni.json");
    if (!resp.ok) throw new Error(`Failed to download: ${resp.status}`);
    const comuni = await resp.json();

    // Delete all existing rows first
    const { error: delError } = await supabase
      .from("comuni_italiani")
      .delete()
      .neq("codice_istat", "___IMPOSSIBLE___");
    if (delError) throw new Error(`Delete failed: ${delError.message}`);

    // Insert in batches of 500
    let inserted = 0;
    const batchSize = 500;
    for (let i = 0; i < comuni.length; i += batchSize) {
      const batch = comuni.slice(i, i + batchSize);
      const rows = batch.map((c: any) => ({
        nome: c.nome,
        codice_istat: c.codice || null,
        sigla_provincia: c.provincia.sigla,
        provincia_sigla: c.provincia.sigla,
        nome_provincia: c.provincia.nome,
        regione: c.provincia.regione,
        lat: c.coordinate?.lat ?? null,
        lng: c.coordinate?.lng ?? null,
      }));
      const { error: insError } = await supabase
        .from("comuni_italiani")
        .insert(rows);
      if (insError) throw new Error(`Insert batch ${i}: ${insError.message}`);
      inserted += rows.length;
    }

    const { count } = await supabase
      .from("comuni_italiani")
      .select("*", { count: "exact", head: true });

    return new Response(
      JSON.stringify({ success: true, inserted, total: count }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
