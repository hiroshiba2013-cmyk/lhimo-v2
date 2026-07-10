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

interface BusinessRecord {
  name: string;
  osm_id: string;
  city: string | null;
  street: string | null;
  postal_code: string | null;
  phone: string | null;
  website: string | null;
  email: string | null;
  business_hours: string | null;
  latitude: number | null;
  longitude: number | null;
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
      { global: { headers: { Authorization: authHeader } } }
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

    // body: { city, province, region, osm_tag, businesses: BusinessRecord[] }
    const body = await req.json();
    const { city, province, region, osm_tag, businesses } = body;

    if (!city || !province || !region || !osm_tag || !Array.isArray(businesses)) {
      throw new Error("city, province, region, osm_tag and businesses[] are required");
    }

    const catName = OSM_CATEGORY_MAP[osm_tag];
    if (!catName) throw new Error(`Unknown OSM tag: ${osm_tag}`);

    const { data: catRow } = await supabase
      .from("business_categories").select("id").eq("name", catName).maybeSingle();
    if (!catRow) throw new Error(`Category not found: ${catName}`);
    const catId = catRow.id;

    if (businesses.length === 0) {
      return new Response(
        JSON.stringify({ imported: 0, skipped: 0, category: catName }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Deduplicate by osm_id for this city+category
    const { data: existingRows } = await supabase
      .from("unclaimed_business_locations")
      .select("osm_id")
      .eq("city", city)
      .eq("category_id", catId)
      .not("osm_id", "is", null);
    const existingIds = new Set(existingRows?.map(r => r.osm_id) ?? []);

    const toInsert = businesses
      .filter(b => !existingIds.has(b.osm_id))
      .map(b => ({
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
        business_hours: b.business_hours || null,
        latitude: b.latitude || null,
        longitude: b.longitude || null,
        osm_id: b.osm_id,
        is_claimed: false,
        added_by: null,
        approval_status: "approved",
      }));

    let imported = 0;
    for (let i = 0; i < toInsert.length; i += 300) {
      const { error } = await supabase
        .from("unclaimed_business_locations")
        .insert(toInsert.slice(i, i + 300));
      if (!error) imported += Math.min(300, toInsert.length - i);
    }

    return new Response(
      JSON.stringify({ imported, skipped: businesses.length - toInsert.length, category: catName }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
