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
  apiKey: string;
  categories?: string[];
  radius?: number;
}

interface GooglePlace {
  place_id: string;
  name: string;
  formatted_address: string;
  geometry: {
    location: {
      lat: number;
      lng: number;
    };
  };
  types: string[];
  formatted_phone_number?: string;
  website?: string;
  opening_hours?: {
    weekday_text?: string[];
  };
  business_status?: string;
}

// Map Google Place types to our categories
const categoryMapping: Record<string, string> = {
  // Food & Drink
  restaurant: "Ristoranti",
  cafe: "Bar e Caffè",
  bar: "Bar e Caffè",
  bakery: "Panifici e Pasticcerie",
  meal_delivery: "Fast Food",
  meal_takeaway: "Fast Food",
  pizza_restaurant: "Pizzerie",
  supermarket: "Supermercati",
  convenience_store: "Alimentari",
  grocery_or_supermarket: "Supermercati",
  butcher_shop: "Macellerie",

  // Health & Beauty
  pharmacy: "Farmacie",
  drugstore: "Farmacie",
  doctor: "Medici",
  dentist: "Dentisti",
  hospital: "Medici",
  physiotherapist: "Medici",
  hair_care: "Parrucchieri e Barbieri",
  beauty_salon: "Centri Estetici",
  spa: "Centri Estetici",

  // Accommodation
  lodging: "Hotel",
  hotel: "Hotel",
  guest_house: "B&B",

  // Automotive
  car_repair: "Autofficine",
  car_dealer: "Autofficine",
  car_wash: "Autolavaggi",
  gas_station: "Distributori di Carburante",

  // Fitness
  gym: "Palestre",
  stadium: "Palestre",

  // Financial & Professional Services
  bank: "Banche",
  atm: "Banche",
  lawyer: "Avvocati",
  accounting: "Commercialisti",
  notary_public: "Notai",
  insurance_agency: "Assicurazioni",
  architect: "Architetti",

  // Real Estate
  real_estate_agency: "Agenzie Immobiliari",

  // Retail
  clothing_store: "Abbigliamento",
  shoe_store: "Abbigliamento",
  book_store: "Librerie",
  florist: "Fioristi",
  jewelry_store: "Gioiellerie",
  pet_store: "Veterinari",
  veterinary_care: "Veterinari",

  // Tradespeople & Artisans
  plumber: "Idraulici",
  electrician: "Elettricisti",
  painter: "Imbianchini",
  carpenter: "Falegnami",
  locksmith: "Serramenti",
  roofing_contractor: "Imprese Edili",
  general_contractor: "Imprese Edili",
  home_goods_store: "Ferramenta",
  hardware_store: "Ferramenta",
  hvac: "Climatizzazione",
};

function getCategoryFromGoogle(types: string[]): string | null {
  for (const type of types) {
    if (categoryMapping[type]) {
      return categoryMapping[type];
    }
  }
  return null;
}

function parseAddress(formattedAddress: string, city: string): { street: string; streetNumber: string; postalCode: string | null } {
  // Try to extract street, number, and postal code from formatted address
  const parts = formattedAddress.split(",");
  
  if (parts.length > 0) {
    const streetPart = parts[0].trim();
    const match = streetPart.match(/^(.+?)\s+(\d+[A-Za-z]?)$/);
    
    if (match) {
      return {
        street: match[1],
        streetNumber: match[2],
        postalCode: null, // Could be extracted from other parts if needed
      };
    }
    
    return {
      street: streetPart,
      streetNumber: "s.n.",
      postalCode: null,
    };
  }
  
  return {
    street: "Via non specificata",
    streetNumber: "s.n.",
    postalCode: null,
  };
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

    const { city, province, apiKey, radius = 5000 }: ImportRequest = await req.json();

    if (!city || !province || !apiKey) {
      throw new Error("City, province, and API key are required");
    }

    // Get city coordinates using Google Geocoding API
    const geocodeUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(city + ", Italy")}&key=${apiKey}`;
    const geocodeResponse = await fetch(geocodeUrl);
    const geocodeData = await geocodeResponse.json();

    if (!geocodeData.results || geocodeData.results.length === 0) {
      throw new Error(`City ${city} not found`);
    }

    const location = geocodeData.results[0].geometry.location;

    // Search for places using Google Places API Nearby Search
    const allPlaces: GooglePlace[] = [];
    const placeTypes = Object.keys(categoryMapping);

    // Make requests for different types (Google limits results per request)
    for (const type of placeTypes.slice(0, 10)) { // Limit to first 10 types to avoid too many requests
      const placesUrl = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.lat},${location.lng}&radius=${radius}&type=${type}&key=${apiKey}`;
      const placesResponse = await fetch(placesUrl);
      const placesData = await placesResponse.json();

      if (placesData.results && placesData.results.length > 0) {
        allPlaces.push(...placesData.results);
      }

      // Respect rate limits
      await new Promise(resolve => setTimeout(resolve, 100));
    }

    // Remove duplicates by place_id
    const uniquePlaces = Array.from(
      new Map(allPlaces.map(place => [place.place_id, place])).values()
    );

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

    for (const place of uniquePlaces) {
      if (place.business_status !== "OPERATIONAL") continue;

      const category = getCategoryFromGoogle(place.types);
      if (!category) continue;

      const categoryId = categoryMap.get(category);
      if (!categoryId) continue;

      businesses.push({
        name: place.name,
        category_id: categoryId,
        is_claimed: false,
        vat_number: generateVAT(),
      });

      const addressParts = parseAddress(place.formatted_address, city);

      locations.push({
        city,
        province,
        postal_code: addressParts.postalCode,
        street_address: `${addressParts.street}, ${addressParts.streetNumber}`,
        street_number: addressParts.streetNumber,
        latitude: place.geometry.location.lat,
        longitude: place.geometry.location.lng,
        phone_number: place.formatted_phone_number || null,
        email: null,
        business_hours: place.opening_hours?.weekday_text?.join("; ") || null,
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
        message: "Businesses imported successfully from Google Places",
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