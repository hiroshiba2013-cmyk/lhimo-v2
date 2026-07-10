import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface ImportRequest {
  city: string;
  province: string;
  categories?: string[];
  radius?: number;
}

interface OSMElement {
  type: string;
  id: number;
  lat?: number;
  lon?: number;
  tags?: {
    name?: string;
    "addr:street"?: string;
    "addr:housenumber"?: string;
    "addr:city"?: string;
    "addr:postcode"?: string;
    phone?: string;
    website?: string;
    "contact:phone"?: string;
    "contact:website"?: string;
    opening_hours?: string;
    amenity?: string;
    shop?: string;
    cuisine?: string;
    description?: string;
  };
  center?: { lat: number; lon: number };
}

interface OSMResponse {
  elements: OSMElement[];
}

// Map OSM tags to our categories
const categoryMapping: Record<string, string> = {
  restaurant: "Ristoranti",
  cafe: "Bar e Caffetterie",
  bar: "Bar e Caffetterie",
  fast_food: "Ristoranti",
  pub: "Bar e Caffetterie",
  bakery: "Alimentari e Gastronomia",
  supermarket: "Alimentari e Gastronomia",
  pharmacy: "Farmacie e Salute",
  doctors: "Farmacie e Salute",
  dentist: "Farmacie e Salute",
  hospital: "Farmacie e Salute",
  hairdresser: "Parrucchieri e Centri Estetici",
  beauty: "Parrucchieri e Centri Estetici",
  hotel: "Hotel e Alloggi",
  car_repair: "Officine e Autofficine",
  gym: "Palestre e Fitness",
  bank: "Servizi Finanziari",
  lawyer: "Servizi Professionali",
  accountant: "Servizi Professionali",
  real_estate: "Immobiliare",
  clothing: "Abbigliamento e Moda",
  shoes: "Abbigliamento e Moda",
  furniture: "Arredamento",
  electronics: "Elettronica",
  books: "Librerie ed Edicole",
  florist: "Fioristi",
  jewelry: "Gioiellerie",
  optician: "Ottici",
  pet: "Animali",
};

function getCategoryFromOSM(tags: OSMElement["tags"]): string | null {
  if (!tags) return null;
  
  const amenity = tags.amenity;
  const shop = tags.shop;
  
  if (amenity && categoryMapping[amenity]) {
    return categoryMapping[amenity];
  }
  
  if (shop && categoryMapping[shop]) {
    return categoryMapping[shop];
  }
  
  return null;
}

function generateVAT(): string {
  const random = Math.floor(Math.random() * 100000000000);
  return random.toString().padStart(11, "0");
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      throw new Error("Missing authorization header");
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: authHeader },
        },
      }
    );

    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      throw new Error("Unauthorized");
    }

    const { city, province, categories, radius = 10000 }: ImportRequest = await req.json();

    if (!city || !province) {
      throw new Error("City and province are required");
    }

    // Get city coordinates using Nominatim
    const geocodeUrl = `https://nominatim.openstreetmap.org/search?city=${encodeURIComponent(city)}&country=Italy&format=json&limit=1`;
    const geocodeResponse = await fetch(geocodeUrl, {
      headers: {
        "User-Agent": "ItalianBusinessDirectory/1.0"
      }
    });
    const geocodeData = await geocodeResponse.json();

    if (!geocodeData || geocodeData.length === 0) {
      throw new Error(`City ${city} not found`);
    }

    const { lat, lon } = geocodeData[0];

    // Build Overpass query
    const overpassQuery = `
      [out:json][timeout:90];
      (
        node["amenity"](around:${radius},${lat},${lon});
        way["amenity"](around:${radius},${lat},${lon});
        node["shop"](around:${radius},${lat},${lon});
        way["shop"](around:${radius},${lat},${lon});
      );
      out center;
    `;

    // Query Overpass API
    const overpassUrl = "https://overpass-api.de/api/interpreter";
    const overpassResponse = await fetch(overpassUrl, {
      method: "POST",
      body: overpassQuery,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }
    });

    const osmData: OSMResponse = await overpassResponse.json();

    // Get existing category IDs
    const { data: categoriesData } = await supabase
      .from("business_categories")
      .select("id, name");

    const categoryMap = new Map(
      categoriesData?.map(cat => [cat.name, cat.id]) || []
    );

    // Process and insert businesses
    const businesses = [];
    const locations = [];

    for (const element of osmData.elements) {
      if (!element.tags?.name) continue;

      const category = getCategoryFromOSM(element.tags);
      if (!category) continue;

      const categoryId = categoryMap.get(category);
      if (!categoryId) continue;

      const lat = element.lat || element.center?.lat;
      const lon = element.lon || element.center?.lon;

      if (!lat || !lon) continue;

      const phone = element.tags.phone || element.tags["contact:phone"] || null;
      const website = element.tags.website || element.tags["contact:website"] || null;

      businesses.push({
        name: element.tags.name,
        category_id: categoryId,
        is_claimed: false,
        vat_number: generateVAT(),
      });

      const street = element.tags["addr:street"] || "Via non specificata";
      const streetNumber = element.tags["addr:housenumber"] || "s.n.";

      locations.push({
        city: element.tags["addr:city"] || city,
        province,
        postal_code: element.tags["addr:postcode"] || null,
        street_address: `${street}, ${streetNumber}`,
        street_number: streetNumber,
        latitude: lat,
        longitude: lon,
        phone_number: phone,
        email: null,
        business_hours: element.tags.opening_hours || null,
      });
    }

    if (businesses.length === 0) {
      return new Response(
        JSON.stringify({ message: "No businesses found", imported: 0 }),
        {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        }
      );
    }

    // Insert businesses
    const { data: insertedBusinesses, error: businessError } = await supabase
      .from("businesses")
      .insert(businesses)
      .select("id");

    if (businessError) {
      throw businessError;
    }

    // Add business_id to locations
    const locationsWithBusinessId = locations.map((loc, index) => ({
      ...loc,
      business_id: insertedBusinesses![index].id,
    }));

    // Insert locations
    const { error: locationError } = await supabase
      .from("business_locations")
      .insert(locationsWithBusinessId);

    if (locationError) {
      throw locationError;
    }

    return new Response(
      JSON.stringify({
        message: "Businesses imported successfully",
        imported: businesses.length,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 400,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  }
});