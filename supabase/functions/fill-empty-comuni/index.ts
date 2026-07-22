import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

const OSM_CATEGORY_MAP: Record<string, string> = {
  restaurant:"Ristoranti",fast_food:"Fast Food",cafe:"Bar e Caffè",bar:"Bar e Caffè",
  pub:"Pub e Locali",biergarten:"Pub e Locali",food_court:"Food Court",ice_cream:"Gelaterie",
  confectionery:"Pasticcerie",pastry:"Pasticcerie",bakery:"Panetterie",pizza:"Pizzerie",
  supermarket:"Supermercati",convenience:"Alimentari",greengrocer:"Frutta e Verdura",
  butcher:"Macellerie",fishmonger:"Pescherie",deli:"Gastronomie",dairy:"Latterie",
  pasta:"Pastifici",chocolate:"Cioccolaterie",cheese:"Formaggerie",wine:"Enoteche",
  beverages:"Negozi di Bevande",pharmacy:"Farmacie",optician:"Ottici",
  hearing_aids:"Apparecchi Acustici",doctors:"Medici",dentist:"Dentisti",
  hospital:"Ospedali",clinic:"Cliniche",physiotherapist:"Fisioterapisti",
  psychologist:"Psicologi",veterinary:"Veterinari",laboratory:"Laboratori Analisi",
  hairdresser:"Parrucchieri",hairdresser_supply:"Forniture Parrucchieri",
  beauty:"Centri Estetici",massage:"Centri Massaggi",tattoo:"Tatuatori",
  hotel:"Hotel",motel:"Motel",hostel:"Ostelli",guest_house:"B&B",
  camp_site:"Campeggi",caravan_site:"Aree Camper",chalet:"Chalet",
  bank:"Banche",atm:"Bancomat",insurance:"Assicurazioni",lawyer:"Avvocati",
  notary:"Notai",accountant:"Commercialisti",financial_advisor:"Consulenti Finanziari",
  tax_advisor:"Consulenti Fiscali",architect:"Architetti",engineer:"Ingegneri",
  surveyor:"Geometri",estate_agent:"Agenzie Immobiliari",travel_agency:"Agenzie di Viaggio",
  employment_agency:"Agenzie del Lavoro",advertising:"Agenzie Pubblicitarie",
  consultant:"Consulenti",school:"Scuole",university:"Università",kindergarten:"Asili",
  language_school:"Scuole di Lingue",music_school:"Scuole di Musica",
  dancing_school:"Scuole di Danza",driving_school:"Autoscuole",
  clothes:"Abbigliamento",shoes:"Calzature",boutique:"Boutique",fashion:"Moda",
  leather:"Articoli in Pelle",tailor:"Sartorie",electronics:"Elettronica",
  computer:"Negozi di Computer",mobile_phone:"Negozi di Telefonia",hifi:"Hi-Fi",
  camera:"Fotocamere",video_games:"Videogiochi",telecommunication:"Telecomunicazioni",
  furniture:"Arredamento",kitchen:"Cucine",bed:"Materassi e Letti",flooring:"Pavimenti",
  tiles:"Piastrelle",bathroom_furnishing:"Arredo Bagno",curtain:"Tendaggi",carpet:"Tappeti",
  lighting:"Illuminazione",glaziery:"Vetrai",books:"Librerie",newsagent:"Edicole",
  stationery:"Cartolerie",florist:"Fioristi",jewelry:"Gioiellerie",watches:"Orologerie",
  toys:"Giocattoli",baby_goods:"Articoli per Bambini",sports:"Negozi di Sport",
  outdoor:"Outdoor e Camping",bicycle:"Negozi di Biciclette",motorcycle:"Moto",
  music:"Negozi di Musica",musical_instrument:"Strumenti Musicali",gift:"Regali",
  antiques:"Antiquari",second_hand:"Usato",model:"Modellismo",hobby:"Hobby e Bricolage",
  art:"Gallerie d'Arte",photo:"Fotografia",tobacco:"Tabaccherie",
  e_cigarette:"Sigarette Elettroniche",erotic:"Sexy Shop",weapons:"Armerie",
  hardware:"Ferramenta",doityourself:"Fai da Te",paint:"Colorifici",
  building_materials:"Imprese Edili",car_repair:"Autofficine",car_wash:"Autolavaggi",
  car_rental:"Autonoleggi",car_parts:"Ricambi Auto",car_dealer:"Concessionarie Auto",
  tyres:"Pneumatici",vehicle_inspection:"Revisioni Auto",fuel:"Distributori di Carburante",
  gym:"Palestre",sports_centre:"Centri Sportivi",swimming_pool:"Piscine",golf_course:"Golf",
  martial_arts:"Arti Marziali",yoga:"Centri Yoga",laundry:"Lavanderie",
  dry_cleaning:"Lavanderie",post_office:"Uffici Postali",funeral_directors:"Onoranze Funebri",
  taxi:"Taxi",copyshop:"Tipografie",blacksmith:"Fabbri",carpenter:"Falegnami",
  plumber:"Idraulici",electrician:"Elettricisti",painter:"Imbianchini",shoemaker:"Calzolai",
  key_cutter:"Duplicazione Chiavi",roofing:"Lattonieri",stonemason:"Scalpellini",
  beekeeper:"Apicoltori",winery:"Cantine",distillery:"Distillerie",library:"Biblioteche",
  charging_station:"Colonnine Ricarica",vending_machine:"Distributori Automatici",
  parking:"Parcheggi",bicycle_rental:"Noleggio Biciclette",nightclub:"Discoteche",
  sauna:"Saune",pet:"Negozi per Animali",pet_grooming:"Toelettatura Animali",
  coffee:"Torrefazioni",spices:"Spezierie",tea:"Negozi di Tè",
  department_store:"Grandi Magazzini",mall:"Centri Commerciali",
  variety_store:"Bazar",general:"Alimentari",
};

const OSM_KEY: Record<string, string> = {
  restaurant:"amenity",fast_food:"amenity",cafe:"amenity",bar:"amenity",pub:"amenity",
  biergarten:"amenity",food_court:"amenity",ice_cream:"amenity",pharmacy:"amenity",
  doctors:"amenity",dentist:"amenity",hospital:"amenity",clinic:"amenity",gym:"amenity",
  bank:"amenity",atm:"amenity",post_office:"amenity",library:"amenity",nightclub:"amenity",
  taxi:"amenity",driving_school:"amenity",kindergarten:"amenity",university:"amenity",
  school:"amenity",funeral_directors:"amenity",sauna:"amenity",fuel:"amenity",
  bicycle_rental:"amenity",music_school:"amenity",dancing_school:"amenity",
  language_school:"amenity",veterinary:"amenity",charging_station:"amenity",
  vending_machine:"amenity",parking:"amenity",bicycle_rental:"amenity",
  supermarket:"shop",convenience:"shop",greengrocer:"shop",butcher:"shop",fishmonger:"shop",
  deli:"shop",dairy:"shop",bakery:"shop",pastry:"shop",confectionery:"shop",chocolate:"shop",
  cheese:"shop",wine:"shop",beverages:"shop",pasta:"shop",pizza:"shop",clothes:"shop",
  shoes:"shop",boutique:"shop",fashion:"shop",leather:"shop",electronics:"shop",
  computer:"shop",mobile_phone:"shop",hifi:"shop",camera:"shop",video_games:"shop",
  furniture:"shop",kitchen:"shop",bed:"shop",flooring:"shop",tiles:"shop",
  bathroom_furnishing:"shop",curtain:"shop",carpet:"shop",lighting:"shop",glaziery:"shop",
  books:"shop",newsagent:"shop",stationery:"shop",florist:"shop",jewelry:"shop",
  watches:"shop",toys:"shop",baby_goods:"shop",sports:"shop",outdoor:"shop",bicycle:"shop",
  motorcycle:"shop",music:"shop",musical_instrument:"shop",gift:"shop",antiques:"shop",
  second_hand:"shop",model:"shop",hobby:"shop",art:"shop",photo:"shop",tobacco:"shop",
  e_cigarette:"shop",erotic:"shop",weapons:"shop",hardware:"shop",doityourself:"shop",
  paint:"shop",building_materials:"shop",car_repair:"shop",car_wash:"shop",car_rental:"shop",
  car_parts:"shop",car_dealer:"shop",tyres:"shop",vehicle_inspection:"shop",pet:"shop",
  pet_grooming:"shop",coffee:"shop",spices:"shop",tea:"shop",department_store:"shop",
  mall:"shop",variety_store:"shop",general:"shop",hairdresser:"shop",
  hairdresser_supply:"shop",optician:"shop",hearing_aids:"shop",travel_agency:"shop",
  copyshop:"shop",laundry:"shop",dry_cleaning:"shop",swimming_pool:"shop",golf_course:"shop",
  beauty:"shop",massage:"shop",tattoo:"shop",
  lawyer:"office",notary:"office",accountant:"office",financial_advisor:"office",
  tax_advisor:"office",architect:"office",engineer:"office",surveyor:"office",
  estate_agent:"office",employment_agency:"office",advertising:"office",consultant:"office",
  insurance:"office",telecommunication:"office",
  blacksmith:"craft",carpenter:"craft",plumber:"craft",electrician:"craft",painter:"craft",
  shoemaker:"craft",key_cutter:"craft",roofing:"craft",stonemason:"craft",beekeeper:"craft",
  winery:"craft",distillery:"craft",tailor:"craft",
  hotel:"tourism",motel:"tourism",hostel:"tourism",guest_house:"tourism",
  camp_site:"tourism",caravan_site:"tourism",chalet:"tourism",
};

const OVERPASS_ENDPOINTS = [
  "https://overpass-api.de/api/interpreter",
  "https://overpass.kumi.systems/api/interpreter",
  "https://overpass.osm.ch/api/interpreter",
];

async function queryOverpassServer(
  city: string,
  osmKey: string,
  osmTag: string,
  lat: number | null,
  lng: number | null,
): Promise<any[]> {
  let query: string;
  if (lat != null && lng != null) {
    query = `[out:json][timeout:60];
(
  node["name"]["${osmKey}"="${osmTag}"](around:5000,${lat},${lng});
  way["name"]["${osmKey}"="${osmTag}"](around:5000,${lat},${lng});
);
out center tags;`;
  } else {
    query = `[out:json][timeout:90];
area["ISO3166-1"="IT"]->.country;
area["name"="${city}"]["boundary"="administrative"](area.country)->.city;
(
  node["name"]["${osmKey}"="${osmTag}"](area.city);
  way["name"]["${osmKey}"="${osmTag}"](area.city);
);
out center tags;`;
  }

  let lastErr = "";
  for (const endpoint of OVERPASS_ENDPOINTS) {
    try {
      const res = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `data=${encodeURIComponent(query)}`,
      });
      if (!res.ok) {
        const txt = await res.text();
        lastErr = `Overpass ${res.status}: ${txt.slice(0, 120)}`;
        continue;
      }
      const data = await res.json();
      return data.elements ?? [];
    } catch (e: any) {
      lastErr = e.message;
      continue;
    }
  }
  throw new Error(lastErr || "Tutti i server Overpass non rispondono");
}

function parseElements(elements: any[], fallbackCity: string) {
  return elements
    .filter((el: any) => el.tags?.name)
    .map((el: any) => {
      const tags = el.tags;
      return {
        name: tags.name,
        osm_id: `${el.type}/${el.id}`,
        city: tags["addr:city"] || tags["addr:municipality"] || fallbackCity,
        street: tags["addr:street"] || null,
        postal_code: tags["addr:postcode"] || null,
        phone: tags.phone || tags["contact:phone"] || null,
        website: tags.website || tags["contact:website"] || null,
        email: tags.email || tags["contact:email"] || null,
        business_hours: tags.opening_hours || null,
        latitude: el.lat ?? el.center?.lat ?? null,
        longitude: el.lon ?? el.center?.lon ?? null,
      };
    });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) throw new Error("Missing authorization header");

    const userClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user }, error: userError } = await userClient.auth.getUser();
    if (userError || !user) throw new Error("Unauthorized");

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    );
    const { data: adminRow } = await supabase
      .from("admins").select("user_id").eq("user_id", user.id).maybeSingle();
    if (!adminRow) throw new Error("Not an admin");

    const body = await req.json();
    const { city, province, region, osm_tag, lat, lng } = body;

    if (!city || !province || !region || !osm_tag) {
      throw new Error("city, province, region and osm_tag are required");
    }

    const catName = OSM_CATEGORY_MAP[osm_tag];
    if (!catName) throw new Error(`Unknown OSM tag: ${osm_tag}`);

    const { data: catRow } = await supabase
      .from("business_categories").select("id").eq("name", catName).maybeSingle();
    if (!catRow) throw new Error(`Category not found: ${catName}`);
    const catId = catRow.id;

    // Query Overpass server-side (no CORS issues, no browser timeouts)
    const osmKey = OSM_KEY[osm_tag] ?? "amenity";
    const elements = await queryOverpassServer(city, osmKey, osm_tag, lat ?? null, lng ?? null);
    const businesses = parseElements(elements, city);

    if (businesses.length === 0) {
      return new Response(
        JSON.stringify({ imported: 0, skipped: 0, found: 0, category: catName }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    // Deduplicate by osm_id for this city+category
    const { data: existingRows } = await supabase
      .from("unclaimed_business_locations")
      .select("osm_id")
      .eq("city", city)
      .eq("category_id", catId)
      .not("osm_id", "is", null);
    const existingIds = new Set(existingRows?.map((r: any) => r.osm_id) ?? []);

    const toInsert = businesses
      .filter((b: any) => !existingIds.has(b.osm_id))
      .map((b: any) => {
        let parsedHours = null;
        if (b.business_hours) {
          try { parsedHours = JSON.parse(b.business_hours); }
          catch { parsedHours = { raw: b.business_hours }; }
        }
        return {
          name: b.name,
          category_id: catId,
          city: b.city || city,
          province,
          region,
          street: b.street || null,
          postal_code: b.postal_code || null,
          phone: b.phone || null,
          website: b.website || null,
          email: b.email || null,
          business_hours: parsedHours,
          latitude: b.latitude || null,
          longitude: b.longitude || null,
          osm_id: b.osm_id,
          is_claimed: false,
          added_by: null,
          approval_status: "approved",
        };
      });

    let imported = 0;
    for (let i = 0; i < toInsert.length; i += 300) {
      const { error } = await supabase
        .from("unclaimed_business_locations")
        .insert(toInsert.slice(i, i + 300));
      if (!error) imported += Math.min(300, toInsert.length - i);
    }

    return new Response(
      JSON.stringify({
        imported,
        skipped: businesses.length - toInsert.length,
        found: businesses.length,
        category: catName,
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
