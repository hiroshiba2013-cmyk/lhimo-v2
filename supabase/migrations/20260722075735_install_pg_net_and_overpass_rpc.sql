CREATE EXTENSION IF NOT EXISTS pg_net SCHEMA extensions;

CREATE OR REPLACE FUNCTION public.import_osm_for_comune(
  p_city text,
  p_province text,
  p_region text,
  p_osm_tag text,
  p_lat numeric DEFAULT NULL,
  p_lng numeric DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  v_osm_key text;
  v_cat_name text;
  v_cat_id uuid;
  v_query text;
  v_response jsonb;
  v_elements jsonb;
  v_businesses jsonb := '[]'::jsonb;
  v_biz jsonb;
  v_tags jsonb;
  v_existing_ids text[];
  v_to_insert jsonb := '[]'::jsonb;
  v_inserted int := 0;
  v_skipped int := 0;
  v_found int := 0;
  v_row record;
  v_osm_id text;
  v_hours jsonb;
  v_endpoint text;
  v_endpoints text[] := ARRAY[
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass.osm.ch/api/interpreter'
  ];
  v_response_text text;
  v_success boolean := false;
BEGIN
  -- Map OSM tag to category name
  v_cat_name := CASE p_osm_tag
    WHEN 'restaurant' THEN 'Ristoranti'
    WHEN 'fast_food' THEN 'Fast Food'
    WHEN 'cafe' THEN 'Bar e Caffè'
    WHEN 'bar' THEN 'Bar e Caffè'
    WHEN 'pub' THEN 'Pub e Locali'
    WHEN 'biergarten' THEN 'Pub e Locali'
    WHEN 'food_court' THEN 'Food Court'
    WHEN 'ice_cream' THEN 'Gelaterie'
    WHEN 'confectionery' THEN 'Pasticcerie'
    WHEN 'pastry' THEN 'Pasticcerie'
    WHEN 'bakery' THEN 'Panetterie'
    WHEN 'pizza' THEN 'Pizzerie'
    WHEN 'supermarket' THEN 'Supermercati'
    WHEN 'convenience' THEN 'Alimentari'
    WHEN 'greengrocer' THEN 'Frutta e Verdura'
    WHEN 'butcher' THEN 'Macellerie'
    WHEN 'fishmonger' THEN 'Pescherie'
    WHEN 'deli' THEN 'Gastronomie'
    WHEN 'dairy' THEN 'Latterie'
    WHEN 'pasta' THEN 'Pastifici'
    WHEN 'chocolate' THEN 'Cioccolaterie'
    WHEN 'cheese' THEN 'Formaggerie'
    WHEN 'wine' THEN 'Enoteche'
    WHEN 'beverages' THEN 'Negozi di Bevande'
    WHEN 'pharmacy' THEN 'Farmacie'
    WHEN 'optician' THEN 'Ottici'
    WHEN 'hearing_aids' THEN 'Apparecchi Acustici'
    WHEN 'doctors' THEN 'Medici'
    WHEN 'dentist' THEN 'Dentisti'
    WHEN 'hospital' THEN 'Ospedali'
    WHEN 'clinic' THEN 'Cliniche'
    WHEN 'physiotherapist' THEN 'Fisioterapisti'
    WHEN 'psychologist' THEN 'Psicologi'
    WHEN 'veterinary' THEN 'Veterinari'
    WHEN 'laboratory' THEN 'Laboratori Analisi'
    WHEN 'hairdresser' THEN 'Parrucchieri'
    WHEN 'hairdresser_supply' THEN 'Forniture Parrucchieri'
    WHEN 'beauty' THEN 'Centri Estetici'
    WHEN 'massage' THEN 'Centri Massaggi'
    WHEN 'tattoo' THEN 'Tatuatori'
    WHEN 'hotel' THEN 'Hotel'
    WHEN 'motel' THEN 'Motel'
    WHEN 'hostel' THEN 'Ostelli'
    WHEN 'guest_house' THEN 'B&B'
    WHEN 'camp_site' THEN 'Campeggi'
    WHEN 'caravan_site' THEN 'Aree Camper'
    WHEN 'chalet' THEN 'Chalet'
    WHEN 'bank' THEN 'Banche'
    WHEN 'atm' THEN 'Bancomat'
    WHEN 'insurance' THEN 'Assicurazioni'
    WHEN 'lawyer' THEN 'Avvocati'
    WHEN 'notary' THEN 'Notai'
    WHEN 'accountant' THEN 'Commercialisti'
    WHEN 'financial_advisor' THEN 'Consulenti Finanziari'
    WHEN 'tax_advisor' THEN 'Consulenti Fiscali'
    WHEN 'architect' THEN 'Architetti'
    WHEN 'engineer' THEN 'Ingegneri'
    WHEN 'surveyor' THEN 'Geometri'
    WHEN 'estate_agent' THEN 'Agenzie Immobiliari'
    WHEN 'travel_agency' THEN 'Agenzie di Viaggio'
    WHEN 'employment_agency' THEN 'Agenzie del Lavoro'
    WHEN 'advertising' THEN 'Agenzie Pubblicitarie'
    WHEN 'consultant' THEN 'Consulenti'
    WHEN 'school' THEN 'Scuole'
    WHEN 'university' THEN 'Università'
    WHEN 'kindergarten' THEN 'Asili'
    WHEN 'language_school' THEN 'Scuole di Lingue'
    WHEN 'music_school' THEN 'Scuole di Musica'
    WHEN 'dancing_school' THEN 'Scuole di Danza'
    WHEN 'driving_school' THEN 'Autoscuole'
    WHEN 'clothes' THEN 'Abbigliamento'
    WHEN 'shoes' THEN 'Calzature'
    WHEN 'boutique' THEN 'Boutique'
    WHEN 'fashion' THEN 'Moda'
    WHEN 'leather' THEN 'Articoli in Pelle'
    WHEN 'tailor' THEN 'Sartorie'
    WHEN 'electronics' THEN 'Elettronica'
    WHEN 'computer' THEN 'Negozi di Computer'
    WHEN 'mobile_phone' THEN 'Negozi di Telefonia'
    WHEN 'hifi' THEN 'Hi-Fi'
    WHEN 'camera' THEN 'Fotocamere'
    WHEN 'video_games' THEN 'Videogiochi'
    WHEN 'telecommunication' THEN 'Telecomunicazioni'
    WHEN 'furniture' THEN 'Arredamento'
    WHEN 'kitchen' THEN 'Cucine'
    WHEN 'bed' THEN 'Materassi e Letti'
    WHEN 'flooring' THEN 'Pavimenti'
    WHEN 'tiles' THEN 'Piastrelle'
    WHEN 'bathroom_furnishing' THEN 'Arredo Bagno'
    WHEN 'curtain' THEN 'Tendaggi'
    WHEN 'carpet' THEN 'Tappeti'
    WHEN 'lighting' THEN 'Illuminazione'
    WHEN 'glaziery' THEN 'Vetrai'
    WHEN 'books' THEN 'Librerie'
    WHEN 'newsagent' THEN 'Edicole'
    WHEN 'stationery' THEN 'Cartolerie'
    WHEN 'florist' THEN 'Fioristi'
    WHEN 'jewelry' THEN 'Gioiellerie'
    WHEN 'watches' THEN 'Orologerie'
    WHEN 'toys' THEN 'Giocattoli'
    WHEN 'baby_goods' THEN 'Articoli per Bambini'
    WHEN 'sports' THEN 'Negozi di Sport'
    WHEN 'outdoor' THEN 'Outdoor e Camping'
    WHEN 'bicycle' THEN 'Negozi di Biciclette'
    WHEN 'motorcycle' THEN 'Moto'
    WHEN 'music' THEN 'Negozi di Musica'
    WHEN 'musical_instrument' THEN 'Strumenti Musicali'
    WHEN 'gift' THEN 'Regali'
    WHEN 'antiques' THEN 'Antiquari'
    WHEN 'second_hand' THEN 'Usato'
    WHEN 'model' THEN 'Modellismo'
    WHEN 'hobby' THEN 'Hobby e Bricolage'
    WHEN 'art' THEN 'Gallerie d''Arte'
    WHEN 'photo' THEN 'Fotografia'
    WHEN 'tobacco' THEN 'Tabaccherie'
    WHEN 'e_cigarette' THEN 'Sigarette Elettroniche'
    WHEN 'erotic' THEN 'Sexy Shop'
    WHEN 'weapons' THEN 'Armerie'
    WHEN 'hardware' THEN 'Ferramenta'
    WHEN 'doityourself' THEN 'Fai da Te'
    WHEN 'paint' THEN 'Colorifici'
    WHEN 'building_materials' THEN 'Imprese Edili'
    WHEN 'car_repair' THEN 'Autofficine'
    WHEN 'car_wash' THEN 'Autolavaggi'
    WHEN 'car_rental' THEN 'Autonoleggi'
    WHEN 'car_parts' THEN 'Ricambi Auto'
    WHEN 'car_dealer' THEN 'Concessionarie Auto'
    WHEN 'tyres' THEN 'Pneumatici'
    WHEN 'vehicle_inspection' THEN 'Revisioni Auto'
    WHEN 'fuel' THEN 'Distributori di Carburante'
    WHEN 'gym' THEN 'Palestre'
    WHEN 'sports_centre' THEN 'Centri Sportivi'
    WHEN 'swimming_pool' THEN 'Piscine'
    WHEN 'golf_course' THEN 'Golf'
    WHEN 'martial_arts' THEN 'Arti Marziali'
    WHEN 'yoga' THEN 'Centri Yoga'
    WHEN 'laundry' THEN 'Lavanderie'
    WHEN 'dry_cleaning' THEN 'Lavanderie'
    WHEN 'post_office' THEN 'Uffici Postali'
    WHEN 'funeral_directors' THEN 'Onoranze Funebri'
    WHEN 'taxi' THEN 'Taxi'
    WHEN 'copyshop' THEN 'Tipografie'
    WHEN 'blacksmith' THEN 'Fabbri'
    WHEN 'carpenter' THEN 'Falegnami'
    WHEN 'plumber' THEN 'Idraulici'
    WHEN 'electrician' THEN 'Elettricisti'
    WHEN 'painter' THEN 'Imbianchini'
    WHEN 'shoemaker' THEN 'Calzolai'
    WHEN 'key_cutter' THEN 'Duplicazione Chiavi'
    WHEN 'roofing' THEN 'Lattonieri'
    WHEN 'stonemason' THEN 'Scalpellini'
    WHEN 'beekeeper' THEN 'Apicoltori'
    WHEN 'winery' THEN 'Cantine'
    WHEN 'distillery' THEN 'Distillerie'
    WHEN 'library' THEN 'Biblioteche'
    WHEN 'charging_station' THEN 'Colonnine Ricarica'
    WHEN 'vending_machine' THEN 'Distributori Automatici'
    WHEN 'parking' THEN 'Parcheggi'
    WHEN 'bicycle_rental' THEN 'Noleggio Biciclette'
    WHEN 'nightclub' THEN 'Discoteche'
    WHEN 'sauna' THEN 'Saune'
    WHEN 'pet' THEN 'Negozi per Animali'
    WHEN 'pet_grooming' THEN 'Toelettatura Animali'
    WHEN 'coffee' THEN 'Torrefazioni'
    WHEN 'spices' THEN 'Spezierie'
    WHEN 'tea' THEN 'Negozi di Tè'
    WHEN 'department_store' THEN 'Grandi Magazzini'
    WHEN 'mall' THEN 'Centri Commerciali'
    WHEN 'variety_store' THEN 'Bazar'
    WHEN 'general' THEN 'Alimentari'
    ELSE NULL
  END;

  IF v_cat_name IS NULL THEN
    RAISE EXCEPTION 'Unknown OSM tag: %', p_osm_tag;
  END IF;

  -- Determine OSM key (amenity/shop/office/craft/tourism)
  v_osm_key := CASE
    WHEN p_osm_tag IN ('restaurant','fast_food','cafe','bar','pub','biergarten','food_court','ice_cream',
      'pharmacy','doctors','dentist','hospital','clinic','gym','bank','atm','post_office','library',
      'nightclub','taxi','driving_school','kindergarten','university','school','funeral_directors',
      'sauna','fuel','bicycle_rental','music_school','dancing_school','language_school','veterinary',
      'charging_station','vending_machine','parking') THEN 'amenity'
    WHEN p_osm_tag IN ('supermarket','convenience','greengrocer','butcher','fishmonger','deli','dairy',
      'bakery','pastry','confectionery','chocolate','cheese','wine','beverages','pasta','pizza',
      'clothes','shoes','boutique','fashion','leather','electronics','computer','mobile_phone','hifi',
      'camera','video_games','furniture','kitchen','bed','flooring','tiles','bathroom_furnishing',
      'curtain','carpet','lighting','glaziery','books','newsagent','stationery','florist','jewelry',
      'watches','toys','baby_goods','sports','outdoor','bicycle','motorcycle','music','musical_instrument',
      'gift','antiques','second_hand','model','hobby','art','photo','tobacco','e_cigarette','erotic',
      'weapons','hardware','doityourself','paint','building_materials','car_repair','car_wash',
      'car_rental','car_parts','car_dealer','tyres','vehicle_inspection','pet','pet_grooming','coffee',
      'spices','tea','department_store','mall','variety_store','general','hairdresser','hairdresser_supply',
      'optician','hearing_aids','travel_agency','copyshop','laundry','dry_cleaning','swimming_pool',
      'golf_course','beauty','massage','tattoo') THEN 'shop'
    WHEN p_osm_tag IN ('lawyer','notary','accountant','financial_advisor','tax_advisor','architect',
      'engineer','surveyor','estate_agent','employment_agency','advertising','consultant',
      'insurance','telecommunication') THEN 'office'
    WHEN p_osm_tag IN ('blacksmith','carpenter','plumber','electrician','painter','shoemaker',
      'key_cutter','roofing','stonemason','beekeeper','winery','distillery','tailor') THEN 'craft'
    WHEN p_osm_tag IN ('hotel','motel','hostel','guest_house','camp_site','caravan_site','chalet') THEN 'tourism'
    ELSE 'amenity'
  END;

  -- Find category
  SELECT id INTO v_cat_id FROM business_categories WHERE name = v_cat_name LIMIT 1;
  IF v_cat_id IS NULL THEN
    RAISE EXCEPTION 'Category not found: %', v_cat_name;
  END IF;

  -- Build Overpass query
  IF p_lat IS NOT NULL AND p_lng IS NOT NULL THEN
    v_query := format(
      '[out:json][timeout:60];(node["name"]["%s"="%s"](around:5000,%s,%s);way["name"]["%s"="%s"](around:5000,%s,%s););out center tags;',
      v_osm_key, p_osm_tag, p_lat, p_lng, v_osm_key, p_osm_tag, p_lat, p_lng
    );
  ELSE
    v_query := format(
      '[out:json][timeout:90];area["ISO3166-1"="IT"]->.country;area["name"="%s"]["boundary"="administrative"](area.country)->.city;(node["name"]["%s"="%s"](area.city);way["name"]["%s"="%s"](area.city););out center tags;',
      p_city, v_osm_key, p_osm_tag, v_osm_key, p_osm_tag
    );
  END IF;

  -- Try each Overpass endpoint
  FOREACH v_endpoint IN ARRAY v_endpoints LOOP
    BEGIN
      SELECT content::text INTO v_response_text FROM net.http_post(
        url := v_endpoint,
        body := 'data=' || urlencode(v_query),
        headers := jsonb_build_object('Content-Type', 'application/x-www-form-urlencoded')
      );
      v_response := v_response_text::jsonb;
      v_elements := v_response->'elements';
      IF v_elements IS NOT NULL THEN
        v_success := true;
        EXIT;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      -- try next endpoint
      CONTINUE;
    END;
  END LOOP;

  IF NOT v_success THEN
    RETURN jsonb_build_object('error', 'Tutti i server Overpass non rispondono');
  END IF;

  -- Parse elements
  FOR v_biz IN SELECT * FROM jsonb_array_elements(v_elements) LOOP
    v_tags := v_biz->'tags';
    IF v_tags->>'name' IS NULL THEN
      CONTINUE;
    END IF;

    v_osm_id := (v_biz->>'type') || '/' || (v_biz->>'id');
    v_found := v_found + 1;

    v_businesses := v_businesses || jsonb_build_object(
      'name', v_tags->>'name',
      'osm_id', v_osm_id,
      'city', COALESCE(v_tags->>'addr:city', v_tags->>'addr:municipality', p_city),
      'street', v_tags->>'addr:street',
      'postal_code', v_tags->>'addr:postcode',
      'phone', COALESCE(v_tags->>'phone', v_tags->>'contact:phone'),
      'website', COALESCE(v_tags->>'website', v_tags->>'contact:website'),
      'email', COALESCE(v_tags->>'email', v_tags->>'contact:email'),
      'business_hours', v_tags->>'opening_hours',
      'latitude', COALESCE((v_biz->>'lat')::numeric, (v_biz->'center'->>'lat')::numeric),
      'longitude', COALESCE((v_biz->>'lon')::numeric, (v_biz->'center'->>'lon')::numeric)
    );
  END LOOP;

  IF v_found = 0 THEN
    RETURN jsonb_build_object('imported', 0, 'skipped', 0, 'found', 0, 'category', v_cat_name);
  END IF;

  -- Get existing osm_ids for this city+category
  SELECT array_agg(osm_id) INTO v_existing_ids
  FROM unclaimed_business_locations
  WHERE city = p_city AND category_id = v_cat_id AND osm_id IS NOT NULL;

  -- Build insert array
  FOR v_biz IN SELECT * FROM jsonb_array_elements(v_businesses) LOOP
    v_osm_id := v_biz->>'osm_id';
    IF v_osm_id = ANY(COALESCE(v_existing_ids, ARRAY[]::text[])) THEN
      v_skipped := v_skipped + 1;
      CONTINUE;
    END IF;

    -- Parse business_hours as jsonb if possible
    v_hours := NULL;
    IF v_biz->>'business_hours' IS NOT NULL THEN
      BEGIN
        v_hours := (v_biz->>'business_hours')::jsonb;
      EXCEPTION WHEN OTHERS THEN
        v_hours := jsonb_build_object('raw', v_biz->>'business_hours');
      END;
    END IF;

    v_to_insert := v_to_insert || jsonb_build_object(
      'name', v_biz->>'name',
      'category_id', v_cat_id,
      'city', COALESCE(v_biz->>'city', p_city),
      'province', p_province,
      'region', p_region,
      'street', v_biz->>'street',
      'postal_code', v_biz->>'postal_code',
      'phone', v_biz->>'phone',
      'website', v_biz->>'website',
      'email', v_biz->>'email',
      'business_hours', v_hours,
      'latitude', NULLIF(v_biz->>'latitude', '')::numeric,
      'longitude', NULLIF(v_biz->>'longitude', '')::numeric,
      'osm_id', v_osm_id,
      'is_claimed', false,
      'approval_status', 'approved'
    );
  END LOOP;

  -- Insert in batches
  v_inserted := 0;
  FOR v_row IN SELECT * FROM jsonb_array_elements(v_to_insert) LOOP
    BEGIN
      INSERT INTO unclaimed_business_locations (
        name, category_id, city, province, region, street, postal_code,
        phone, website, email, business_hours, latitude, longitude,
        osm_id, is_claimed, approval_status
      ) VALUES (
        v_row->>'name',
        (v_row->>'category_id')::uuid,
        v_row->>'city',
        v_row->>'province',
        v_row->>'region',
        v_row->>'street',
        v_row->>'postal_code',
        v_row->>'phone',
        v_row->>'website',
        v_row->>'email',
        NULLIF(v_row->>'business_hours','')::jsonb,
        NULLIF(v_row->>'latitude','')::numeric,
        NULLIF(v_row->>'longitude','')::numeric,
        v_row->>'osm_id',
        false,
        'approved'
      );
      v_inserted := v_inserted + 1;
    EXCEPTION WHEN OTHERS THEN
      -- skip duplicates or errors
      CONTINUE;
    END;
  END LOOP;

  RETURN jsonb_build_object(
    'imported', v_inserted,
    'skipped', v_skipped,
    'found', v_found,
    'category', v_cat_name
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.import_osm_for_comune(text, text, text, text, numeric, numeric) TO authenticated;
