import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface ImportRequest {
  city: string;
  province?: string | null;
  region?: string | null;
  osmKey: string;
  osmValue: string;
  lat?: number | null;
  lng?: number | null;
}

const OVERPASS_ENDPOINTS = [
  "https://overpass-api.de/api/interpreter",
  "https://overpass.kumi.systems/api/interpreter",
  "https://overpass.osm.ch/api/interpreter",
];

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  try {
    if (req.method !== "POST") {
      return json(
        { error: "Metodo non consentito" },
        405
      );
    }

    const body = (await req.json()) as ImportRequest;

    const city = body.city?.trim();
    const province = body.province?.trim() || null;
    const region = body.region?.trim() || null;
    const osmKey = body.osmKey?.trim();
    const osmValue = body.osmValue?.trim();

    if (!city || !osmKey || !osmValue) {
      return json(
        {
          error:
            "city, osmKey e osmValue sono obbligatori",
        },
        400
      );
    }

    const supabaseUrl =
      Deno.env.get("SUPABASE_URL");

    const serviceRoleKey =
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error(
        "Variabili Supabase mancanti"
      );
    }

    const supabase = createClient(
      supabaseUrl,
      serviceRoleKey
    );

    /*
     * =========================================================
     * 1. Recuperiamo la categoria OSM
     * =========================================================
     */

    const { data: osmCategory, error: categoryError } =
      await supabase
        .from("osm_categories")
        .select("id, name, osm_key, osm_value")
        .eq("osm_key", osmKey)
        .eq("osm_value", osmValue)
        .maybeSingle();

    if (categoryError) {
      throw new Error(
        `Errore categoria OSM: ${categoryError.message}`
      );
    }

    if (!osmCategory) {
      throw new Error(
        `Categoria OSM non trovata: ${osmKey}=${osmValue}`
      );
    }

    /*
     * =========================================================
     * 2. Costruiamo query Overpass
     * =========================================================
     */

    let overpassQuery: string;

    if (
      body.lat !== null &&
      body.lat !== undefined &&
      body.lng !== null &&
      body.lng !== undefined
    ) {
      overpassQuery = `
[out:json][timeout:60];
(
  node["name"]["${osmKey}"="${osmValue}"](around:5000,${body.lat},${body.lng});
  way["name"]["${osmKey}"="${osmValue}"](around:5000,${body.lat},${body.lng});
  relation["name"]["${osmKey}"="${osmValue}"](around:5000,${body.lat},${body.lng});
);
out center tags;
`;
    } else {
      const escapedCity = escapeOverpass(city);

      overpassQuery = `
[out:json][timeout:90];
area["ISO3166-1"="IT"]->.country;
area["name"="${escapedCity}"]["boundary"="administrative"](area.country)->.city;
(
  node["name"]["${osmKey}"="${osmValue}"](area.city);
  way["name"]["${osmKey}"="${osmValue}"](area.city);
  relation["name"]["${osmKey}"="${osmValue}"](area.city);
);
out center tags;
`;
    }

    /*
     * =========================================================
     * 3. Chiamiamo Overpass con fallback
     * =========================================================
     */

    let overpassData: any = null;
    let lastError = "";

    for (const endpoint of OVERPASS_ENDPOINTS) {
      try {
        const response = await fetch(
          endpoint,
          {
            method: "POST",
            headers: {
              "Content-Type":
                "application/x-www-form-urlencoded",
            },
            body:
              "data=" +
              encodeURIComponent(
                overpassQuery
              ),
          }
        );

        if (!response.ok) {
          lastError =
            `${endpoint}: HTTP ${response.status}`;

          continue;
        }

        const data = await response.json();

        if (
          data &&
          Array.isArray(data.elements)
        ) {
          overpassData = data;
          break;
        }

        lastError =
          `${endpoint}: risposta Overpass non valida`;
      } catch (error) {
        lastError =
          error instanceof Error
            ? error.message
            : String(error);

        continue;
      }
    }

    if (!overpassData) {
      throw new Error(
        `Nessun server Overpass disponibile. ${lastError}`
      );
    }

    /*
     * =========================================================
     * 4. Elaboriamo i risultati
     * =========================================================
     */

    const elements =
      overpassData.elements ?? [];

    let found = 0;
    let imported = 0;
    let skipped = 0;

    /*
     * Recuperiamo gli OSM ID già presenti
     * nella tabella delle attività non rivendicate.
     */

    const { data: existingRows, error: existingError } =
      await supabase
        .from("unclaimed_business_locations")
        .select("osm_id")
        .eq("city", city)
        .not("osm_id", "is", null);

    if (existingError) {
      throw new Error(
        `Errore controllo duplicati: ${existingError.message}`
      );
    }

    const existingIds = new Set(
      (existingRows ?? [])
        .map((row) => row.osm_id)
        .filter(Boolean)
    );

    /*
     * =========================================================
     * 5. Inserimento
     * =========================================================
     */

    for (const element of elements) {
      const tags = element.tags ?? {};

      if (!tags.name) {
        continue;
      }

      const osmId =
        `${element.type}/${element.id}`;

      found++;

      if (existingIds.has(osmId)) {
        skipped++;
        continue;
      }

      const latitude =
        element.lat ??
        element.center?.lat ??
        null;

      const longitude =
        element.lon ??
        element.center?.lon ??
        null;

      const businessHours =
        tags.opening_hours
          ? {
              raw: tags.opening_hours,
            }
          : null;

      const row = {
        name: tags.name,

        /*
         * La classificazione LHIMO verrà fatta
         * successivamente.
         */
        category_id: null,

        city:
          tags["addr:city"] ??
          tags["addr:municipality"] ??
          city,

        province,

        region,

        street:
          tags["addr:street"] ?? null,

        postal_code:
          tags["addr:postcode"] ?? null,

        phone:
          tags.phone ??
          tags["contact:phone"] ??
          null,

        website:
          tags.website ??
          tags["contact:website"] ??
          null,

        email:
          tags.email ??
          tags["contact:email"] ??
          null,

        business_hours: businessHours,

        latitude,

        longitude,

        osm_id: osmId,

        is_claimed: false,

        approval_status: "approved",
      };

      const { error: insertError } =
        await supabase
          .from("unclaimed_business_locations")
          .insert(row);

      if (insertError) {
        console.error(
          "Errore inserimento:",
          insertError
        );

        skipped++;
        continue;
      }

      imported++;
      existingIds.add(osmId);
    }

    /*
     * =========================================================
     * 6. Risultato
     * =========================================================
     */

    return json({
      success: true,
      found,
      imported,
      skipped,
      category: osmCategory.name,
      osm_key: osmKey,
      osm_value: osmValue,
    });
  } catch (error) {
    console.error(
      "IMPORT OSM ERROR:",
      error
    );

    return json(
      {
        success: false,
        error:
          error instanceof Error
            ? error.message
            : String(error),
      },
      500
    );
  }
});

function escapeOverpass(value: string): string {
  return value
    .replace(/\\/g, "\\\\")
    .replace(/"/g, '\\"');
}

function json(
  data: unknown,
  status = 200
) {
  return new Response(
    JSON.stringify(data),
    {
      status,
      headers: {
        ...corsHeaders,
        "Content-Type":
          "application/json",
      },
    }
  );
}