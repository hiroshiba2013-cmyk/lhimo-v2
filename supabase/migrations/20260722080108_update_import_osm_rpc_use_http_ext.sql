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
  v_biz jsonb;
  v_tags jsonb;
  v_existing_ids text[];
  v_inserted int := 0;
  v_skipped int := 0;
  v_found int := 0;
  v_osm_id text;
  v_hours jsonb;
  v_endpoint text;
  v_endpoints text[] := ARRAY[
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass.osm.ch/api/interpreter'
  ];
  v_http_response record;
  v_success boolean := false;
BEGIN
  -- Set curl timeout to 120s
  PERFORM extensions.http_set_curlopt('CURLOPT_TIMEOUT', '120');

  -- Map OSM tag to category name (matching actual DB categories)
  v_cat_name := CASE p_osm_tag
    WHEN 'restaurant' THEN 'Ristorante'
    WHEN 'fast_food' THEN 'Street Food'
    WHEN 'cafe' THEN 'Bar'
    WHEN 'bar' THEN 'Bar'
    WHEN 'pub' THEN 'Pub'
    WHEN 'biergarten' THEN 'Pub'
    WHEN 'food_court' THEN 'Ristorazione'
    WHEN 'ice_cream' THEN 'Gelateria'
    WHEN 'confectionery' THEN 'Pasticceria'
    WHEN 'pastry' THEN 'Pasticceria'
    WHEN 'bakery' THEN 'Panificio'
    WHEN 'pizza' THEN 'Pizzeria'
    WHEN 'supermarket' THEN 'Supermercato'
    WHEN 'convenience' THEN 'Alimentari'
    WHEN 'greengrocer' THEN 'Alimentari'
    WHEN 'butcher' THEN 'Macelleria'
    WHEN 'fishmonger' THEN 'Pescheria'
    WHEN 'deli' THEN 'Gastronomia'
    WHEN 'dairy' THEN 'Latteria'
    WHEN 'pasta' THEN 'Produzione alimentare'
    WHEN 'chocolate' THEN 'Pasticceria'
    WHEN 'cheese' THEN 'Gastronomia'
    WHEN 'wine' THEN 'Alimentari'
    WHEN 'beverages' THEN 'Alimentari'
    WHEN 'pharmacy' THEN 'Farmacia'
    WHEN 'optician' THEN 'Ottico'
    WHEN 'hearing_aids' THEN 'Ottico'
    WHEN 'doctors' THEN 'Medico di base'
    WHEN 'dentist' THEN 'Dentista'
    WHEN 'hospital' THEN 'Ospedale'
    WHEN 'clinic' THEN 'Clinica'
    WHEN 'physiotherapist' THEN 'Fisioterapista'
    WHEN 'psychologist' THEN 'Psicologo'
    WHEN 'veterinary' THEN 'Veterinario'
    WHEN 'laboratory' THEN 'Laboratorio analisi'
    WHEN 'hairdresser' THEN 'Parrucchiere'
    WHEN 'hairdresser_supply' THEN 'Parrucchiere'
    WHEN 'beauty' THEN 'Estetista'
    WHEN 'massage' THEN 'Massaggiatore'
    WHEN 'tattoo' THEN 'Tatuatore'
    WHEN 'hotel' THEN 'Hotel'
    WHEN 'motel' THEN 'Motel'
    WHEN 'hostel' THEN 'Ostello'
    WHEN 'guest_house' THEN 'B&B'
    WHEN 'camp_site' THEN 'Campeggio'
    WHEN 'caravan_site' THEN 'Aree Camper'
    WHEN 'chalet' THEN 'Chalet'
    WHEN 'bank' THEN 'Banca'
    WHEN 'atm' THEN 'Bancomat'
    WHEN 'insurance' THEN 'Assicurazione'
    WHEN 'lawyer' THEN 'Avvocato'
    WHEN 'notary' THEN 'Notaio'
    WHEN 'accountant' THEN 'Commercialista'
    WHEN 'financial_advisor' THEN 'Consulente finanziario'
    WHEN 'tax_advisor' THEN 'Consulente fiscale'
    WHEN 'architect' THEN 'Architetto'
    WHEN 'engineer' THEN 'Ingegnere'
    WHEN 'surveyor' THEN 'Geometra'
    WHEN 'estate_agent' THEN 'Agenzia immobiliare'
    WHEN 'travel_agency' THEN 'Agenzia viaggi'
    WHEN 'employment_agency' THEN 'Agenzia del lavoro'
    WHEN 'advertising' THEN 'Agenzia pubblicitaria'
    WHEN 'consultant' THEN 'Consulenza'
    WHEN 'school' THEN 'Scuola'
    WHEN 'university' THEN 'Università'
    WHEN 'kindergarten' THEN 'Asilo nido'
    WHEN 'language_school' THEN 'Scuola lingue'
    WHEN 'music_school' THEN 'Scuola'
    WHEN 'dancing_school' THEN 'Scuola danza'
    WHEN 'driving_school' THEN 'Autoscuola'
    WHEN 'clothes' THEN 'Abbigliamento'
    WHEN 'shoes' THEN 'Calzature'
    WHEN 'boutique' THEN 'Abbigliamento'
    WHEN 'fashion' THEN 'Abbigliamento'
    WHEN 'leather' THEN 'Abbigliamento'
    WHEN 'tailor' THEN 'Sartoria'
    WHEN 'electronics' THEN 'Elettronica'
    WHEN 'computer' THEN 'Informatica'
    WHEN 'mobile_phone' THEN 'Telefonia'
    WHEN 'hifi' THEN 'Elettronica'
    WHEN 'camera' THEN 'Elettronica'
    WHEN 'video_games' THEN 'Negozio gaming'
    WHEN 'telecommunication' THEN 'Telefonia'
    WHEN 'furniture' THEN 'Arredamento'
    WHEN 'kitchen' THEN 'Arredamento'
    WHEN 'bed' THEN 'Arredamento'
    WHEN 'flooring' THEN 'Edilizia'
    WHEN 'tiles' THEN 'Edilizia'
    WHEN 'bathroom_furnishing' THEN 'Arredamento'
    WHEN 'curtain' THEN 'Arredamento'
    WHEN 'carpet' THEN 'Arredamento'
    WHEN 'lighting' THEN 'Illuminazione'
    WHEN 'glaziery' THEN 'Edilizia'
    WHEN 'books' THEN 'Libreria'
    WHEN 'newsagent' THEN 'Tabaccheria'
    WHEN 'stationery' THEN 'Cartoleria'
    WHEN 'florist' THEN 'Fiorista'
    WHEN 'jewelry' THEN 'Gioielleria'
    WHEN 'watches' THEN 'Orologeria'
    WHEN 'toys' THEN 'Giocattoli'
    WHEN 'baby_goods' THEN 'Abbigliamento'
    WHEN 'sports' THEN 'Sport e Fitness'
    WHEN 'outdoor' THEN 'Sport e Fitness'
    WHEN 'bicycle' THEN 'Sport e Fitness'
    WHEN 'motorcycle' THEN 'Automotive'
    WHEN 'music' THEN 'Musica'
    WHEN 'musical_instrument' THEN 'Musica'
    WHEN 'gift' THEN 'Casalinghi'
    WHEN 'antiques' THEN 'Arte e Spettacolo'
    WHEN 'second_hand' THEN 'Commercio'
    WHEN 'model' THEN 'Giocattoli'
    WHEN 'hobby' THEN 'Giocattoli'
    WHEN 'art' THEN 'Arte e Spettacolo'
    WHEN 'photo' THEN 'Fotografo'
    WHEN 'tobacco' THEN 'Tabaccheria'
    WHEN 'e_cigarette' THEN 'Tabaccheria'
    WHEN 'erotic' THEN 'Casalinghi'
    WHEN 'weapons' THEN 'Armeria'
    WHEN 'hardware' THEN 'Ferramenta'
    WHEN 'doityourself' THEN 'Ferramenta'
    WHEN 'paint' THEN 'Colorificio'
    WHEN 'building_materials' THEN 'Edilizia'
    WHEN 'car_repair' THEN 'Officina meccanica'
    WHEN 'car_wash' THEN 'Autolavaggio'
    WHEN 'car_rental' THEN 'Noleggio auto'
    WHEN 'car_parts' THEN 'Automotive'
    WHEN 'car_dealer' THEN 'Concessionaria'
    WHEN 'tyres' THEN 'Gommista'
    WHEN 'vehicle_inspection' THEN 'Centro revisioni'
    WHEN 'fuel' THEN 'Automotive'
    WHEN 'gym' THEN 'Palestra'
    WHEN 'sports_centre' THEN 'Centro sportivo'
    WHEN 'swimming_pool' THEN 'Piscina'
    WHEN 'golf_course' THEN 'Sport e Fitness'
    WHEN 'martial_arts' THEN 'Arti marziali'
    WHEN 'yoga' THEN 'Yoga'
    WHEN 'laundry' THEN 'Lavanderia'
    WHEN 'dry_cleaning' THEN 'Lavanderia'
    WHEN 'post_office' THEN 'Ufficio postale'
    WHEN 'funeral_directors' THEN 'Onoranze funebri'
    WHEN 'taxi' THEN 'Taxi'
    WHEN 'copyshop' THEN 'Tipografia'
    WHEN 'blacksmith' THEN 'Fabbro'
    WHEN 'carpenter' THEN 'Falegname'
    WHEN 'plumber' THEN 'Idraulico'
    WHEN 'electrician' THEN 'Elettricista'
    WHEN 'painter' THEN 'Imbianchino'
    WHEN 'shoemaker' THEN 'Calzolaio'
    WHEN 'key_cutter' THEN 'Duplicazione chiavi'
    WHEN 'roofing' THEN 'Lattoniere'
    WHEN 'stonemason' THEN 'Edilizia'
    WHEN 'beekeeper' THEN 'Apicoltura'
    WHEN 'winery' THEN 'Cantina'
    WHEN 'distillery' THEN 'Distilleria'
    WHEN 'library' THEN 'Biblioteca'
    WHEN 'charging_station' THEN 'Colonnine ricarica'
    WHEN 'vending_machine' THEN 'Alimentari'
    WHEN 'parking' THEN 'Parcheggio'
    WHEN 'bicycle_rental' THEN 'Noleggio biciclette'
    WHEN 'nightclub' THEN 'Discoteca'
    WHEN 'sauna' THEN 'Sauna'
    WHEN 'pet' THEN 'Negozio animali'
    WHEN 'pet_grooming' THEN 'Toelettatura'
    WHEN 'coffee' THEN 'Torrefazione'
    WHEN 'spices' THEN 'Alimentari'
    WHEN 'tea' THEN 'Alimentari'
    WHEN 'department_store' THEN 'Supermercato'
    WHEN 'mall' THEN 'Commercio'
    WHEN 'variety_store' THEN 'Casalinghi'
    WHEN 'general' THEN 'Alimentari'
    ELSE NULL
  END;

  IF v_cat_name IS NULL THEN
    RAISE EXCEPTION 'Unknown OSM tag: %', p_osm_tag;
  END IF;

  -- Determine OSM key
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

  -- Try each Overpass endpoint using the http extension
  FOREACH v_endpoint IN ARRAY v_endpoints LOOP
    BEGIN
      SELECT * INTO v_http_response FROM extensions.http_post(
        v_endpoint,
        'data=' || extensions.urlencode(v_query),
        'application/x-www-form-urlencoded'
      );
      IF v_http_response.status = 200 THEN
        v_response := v_http_response.content::jsonb;
        v_elements := v_response->'elements';
        IF v_elements IS NOT NULL THEN
          v_success := true;
          EXIT;
        END IF;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      CONTINUE;
    END;
  END LOOP;

  IF NOT v_success THEN
    RETURN jsonb_build_object('error', 'Tutti i server Overpass non rispondono');
  END IF;

  -- Parse elements and insert
  FOR v_biz IN SELECT * FROM jsonb_array_elements(v_elements) LOOP
    v_tags := v_biz->'tags';
    IF v_tags->>'name' IS NULL THEN
      CONTINUE;
    END IF;

    v_osm_id := (v_biz->>'type') || '/' || (v_biz->>'id');
    v_found := v_found + 1;

    -- Get existing osm_ids (only once, lazily)
    IF v_existing_ids IS NULL THEN
      SELECT array_agg(osm_id) INTO v_existing_ids
      FROM unclaimed_business_locations
      WHERE city = p_city AND category_id = v_cat_id AND osm_id IS NOT NULL;
    END IF;

    IF v_osm_id = ANY(COALESCE(v_existing_ids, ARRAY[]::text[])) THEN
      v_skipped := v_skipped + 1;
      CONTINUE;
    END IF;

    -- Parse business_hours
    v_hours := NULL;
    IF v_tags->>'opening_hours' IS NOT NULL THEN
      BEGIN
        v_hours := (v_tags->>'opening_hours')::jsonb;
      EXCEPTION WHEN OTHERS THEN
        v_hours := jsonb_build_object('raw', v_tags->>'opening_hours');
      END;
    END IF;

    BEGIN
      INSERT INTO unclaimed_business_locations (
        name, category_id, city, province, region, street, postal_code,
        phone, website, email, business_hours, latitude, longitude,
        osm_id, is_claimed, approval_status
      ) VALUES (
        v_tags->>'name',
        v_cat_id,
        COALESCE(v_tags->>'addr:city', v_tags->>'addr:municipality', p_city),
        p_province,
        p_region,
        v_tags->>'addr:street',
        v_tags->>'addr:postcode',
        COALESCE(v_tags->>'phone', v_tags->>'contact:phone'),
        COALESCE(v_tags->>'website', v_tags->>'contact:website'),
        COALESCE(v_tags->>'email', v_tags->>'contact:email'),
        v_hours,
        COALESCE((v_biz->>'lat')::numeric, (v_biz->'center'->>'lat')::numeric),
        COALESCE((v_biz->>'lon')::numeric, (v_biz->'center'->>'lon')::numeric),
        v_osm_id,
        false,
        'approved'
      );
      v_inserted := v_inserted + 1;
    EXCEPTION WHEN OTHERS THEN
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
