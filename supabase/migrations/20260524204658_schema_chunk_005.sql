-- ============================================================
-- FILE: 20251217214718_seed_unclaimed_businesses_data_v2.sql
-- ============================================================
DO $$
DECLARE
  category RECORD;
  business_counter INTEGER;
  cities TEXT[] := ARRAY[
    'Roma', 'Milano', 'Napoli', 'Torino', 'Palermo', 
    'Genova', 'Bologna', 'Firenze', 'Bari', 'Catania',
    'Venezia', 'Verona', 'Messina', 'Padova', 'Trieste',
    'Brescia', 'Parma', 'Prato', 'Modena', 'Reggio Calabria'
  ];
  provinces TEXT[] := ARRAY[
    'RM', 'MI', 'NA', 'TO', 'PA',
    'GE', 'BO', 'FI', 'BA', 'CT',
    'VE', 'VR', 'ME', 'PD', 'TS',
    'BS', 'PR', 'PO', 'MO', 'RC'
  ];
  streets TEXT[] := ARRAY[
    'Via Roma', 'Via Milano', 'Corso Italia', 'Via Garibaldi', 'Piazza Dante',
    'Via Mazzini', 'Corso Vittorio Emanuele', 'Via Nazionale', 'Via Veneto', 'Piazza Repubblica'
  ];
  business_names TEXT[] := ARRAY[
    'Il Centrale', 'La Piazza', 'Del Corso', 'Bella Vista', 'Il Faro',
    'La Perla', 'Il Punto', 'Da Mario', 'La Stella', 'Il Sole'
  ];
  city_idx INTEGER;
  random_vat TEXT;
  random_phone TEXT;
  street_number TEXT;
BEGIN
  FOR category IN SELECT id, name, ateco_code FROM business_categories LOOP
    FOR business_counter IN 1..10 LOOP
      city_idx := ((business_counter - 1) % 20) + 1;
      street_number := (business_counter * 10 + city_idx)::TEXT;
      
      random_vat := LPAD((1000000000 + (random() * 8999999999)::BIGINT)::TEXT, 11, '0');
      random_phone := '+39 0' || LPAD((10 + (random() * 89)::INT)::TEXT, 2, '0') || ' ' || 
                      LPAD((random() * 9999999)::INT::TEXT, 7, '0');
      
      INSERT INTO businesses (
        owner_id,
        name,
        category_id,
        city,
        address,
        phone,
        email,
        vat_number,
        ateco_code,
        description,
        verified,
        is_claimed,
        billing_street,
        billing_street_number,
        billing_postal_code,
        billing_city,
        billing_province,
        office_street,
        office_street_number,
        office_postal_code,
        office_city,
        office_province,
        created_at
      ) VALUES (
        NULL,
        business_names[((business_counter - 1) % 10) + 1] || ' - ' || category.name || ' ' || cities[city_idx],
        category.id,
        cities[city_idx],
        streets[((business_counter - 1) % 10) + 1] || ', ' || street_number,
        random_phone,
        LOWER(REPLACE(business_names[((business_counter - 1) % 10) + 1], ' ', '')) || city_idx || '@esempio.it',
        random_vat,
        category.ateco_code,
        'Attività professionale nel settore ' || LOWER(category.name) || '. Servizi di qualità per la zona di ' || cities[city_idx] || '.',
        true,
        false,
        streets[((business_counter - 1) % 10) + 1],
        street_number,
        LPAD((random() * 99999)::INT::TEXT, 5, '0'),
        cities[city_idx],
        provinces[city_idx],
        streets[((business_counter - 1) % 10) + 1],
        street_number,
        LPAD((random() * 99999)::INT::TEXT, 5, '0'),
        cities[city_idx],
        provinces[city_idx],
        NOW() - (random() * interval '180 days')
      );
    END LOOP;
  END LOOP;
END $$;

-- ============================================================
-- FILE: 20251217220434_add_more_unclaimed_businesses.sql
-- ============================================================
DO $$
DECLARE
  category RECORD;
  business_counter INTEGER;
  cities TEXT[] := ARRAY[
    'Roma', 'Milano', 'Napoli', 'Torino', 'Palermo', 'Genova', 'Bologna', 'Firenze', 'Bari', 'Catania',
    'Venezia', 'Verona', 'Messina', 'Padova', 'Trieste', 'Brescia', 'Parma', 'Prato', 'Modena', 'Reggio Calabria',
    'Reggio Emilia', 'Perugia', 'Ravenna', 'Livorno', 'Cagliari', 'Foggia', 'Rimini', 'Salerno', 'Ferrara', 'Sassari',
    'Latina', 'Giugliano', 'Monza', 'Siracusa', 'Pescara', 'Bergamo', 'Forlì', 'Trento', 'Vicenza', 'Terni',
    'Bolzano', 'Novara', 'Piacenza', 'Ancona', 'Andria', 'Arezzo', 'Udine', 'Cesena', 'Lecce', 'Pesaro',
    'Barletta', 'Alessandria', 'La Spezia', 'Pistoia', 'Lucca', 'Brindisi', 'Pisa', 'Como', 'Guidonia', 'Treviso',
    'Varese', 'Busto Arsizio', 'Pozzuoli', 'Marsala', 'Asti', 'Casoria', 'Gela', 'Cinisello Balsamo', 'Ragusa', 'Carrara',
    'Viterbo', 'Altamura', 'Imola', 'Matera', 'Potenza', 'Cosenza', 'Crotone', 'Pordenone', 'Cremona', 'Sesto San Giovanni',
    'Caltanissetta', 'Viareggio', 'Fano', 'Savona', 'Chieti', 'Vercelli', 'Molfetta', 'Cuneo', 'Avellino', 'Benevento',
    'Lamezia Terme', 'Trani', 'Caserta', 'Moncalieri', 'Castelfranco Veneto', 'Legnano', 'Rho', 'Sanremo', 'Acireale', 'Aprilia'
  ];
  provinces TEXT[] := ARRAY[
    'RM', 'MI', 'NA', 'TO', 'PA', 'GE', 'BO', 'FI', 'BA', 'CT',
    'VE', 'VR', 'ME', 'PD', 'TS', 'BS', 'PR', 'PO', 'MO', 'RC',
    'RE', 'PG', 'RA', 'LI', 'CA', 'FG', 'RN', 'SA', 'FE', 'SS',
    'LT', 'NA', 'MB', 'SR', 'PE', 'BG', 'FC', 'TN', 'VI', 'TR',
    'BZ', 'NO', 'PC', 'AN', 'BT', 'AR', 'UD', 'FC', 'LE', 'PU',
    'BT', 'AL', 'SP', 'PT', 'LU', 'BR', 'PI', 'CO', 'RM', 'TV',
    'VA', 'VA', 'NA', 'TP', 'AT', 'NA', 'CL', 'MI', 'RG', 'MS',
    'VT', 'BA', 'BO', 'MT', 'PZ', 'CS', 'KR', 'PN', 'CR', 'MI',
    'CL', 'LU', 'PU', 'SV', 'CH', 'VC', 'BA', 'CN', 'AV', 'BN',
    'CZ', 'BT', 'CE', 'TO', 'TV', 'MI', 'MI', 'IM', 'CT', 'LT'
  ];
  streets TEXT[] := ARRAY[
    'Via Roma', 'Via Milano', 'Corso Italia', 'Via Garibaldi', 'Piazza Dante', 'Via Mazzini', 
    'Corso Vittorio Emanuele', 'Via Nazionale', 'Via Veneto', 'Piazza Repubblica', 'Via Cavour',
    'Via Verdi', 'Corso Umberto', 'Via Colombo', 'Piazza Matteotti', 'Via Marconi', 'Via Dante',
    'Corso Garibaldi', 'Via Leopardi', 'Piazza San Marco', 'Via XX Settembre', 'Via della Libertà',
    'Corso Vittoria', 'Via Carducci', 'Piazza Duomo', 'Via Indipendenza', 'Via Manzoni', 'Corso Roma',
    'Via Diaz', 'Piazza Venezia', 'Via Pascoli', 'Corso Matteotti', 'Via Kennedy', 'Piazza Mazzini',
    'Via Gramsci', 'Corso Europa', 'Via Petrarca', 'Piazza Garibaldi', 'Via Togliatti', 'Corso Cavour'
  ];
  business_prefixes TEXT[] := ARRAY[
    'Il Nuovo', 'La Moderna', 'Antica', 'Il Miglior', 'La Perfetta', 'Nuova', 'Il Professionista',
    'La Grande', 'Il Centro', 'La Casa', 'Il Punto', 'La Bottega', 'Il Negozio', 'La Stanza',
    'Il Mondo', 'La Città', 'Il Regno', 'La Reggia', 'Il Palazzo', 'La Torre', 'Il Castello',
    'La Villa', 'Il Giardino', 'La Piazzetta', 'Il Vicolo', 'La Terrazza', 'Il Cortile', 'La Corte',
    'Il Portico', 'La Loggia', 'Il Tempio', 'La Basilica', 'Il Duomo', 'La Cattedrale', 'Il Santuario',
    'La Cappella', 'Il Convento', 'La Canonica', 'Il Monastero', 'La Badia', 'Da Giulio', 'Da Franco',
    'Da Luca', 'Da Marco', 'Da Paolo', 'Da Antonio', 'Da Giovanni', 'Da Roberto', 'Da Carlo', 'Da Pietro'
  ];
  business_suffixes TEXT[] := ARRAY[
    'Centrale', 'Principale', 'Storico', 'Classico', 'Moderno', 'Elegante', 'Prestigioso',
    'Esclusivo', 'Raffinato', 'Eccellente', 'Premium', 'Elite', 'Top', 'Plus', 'Star',
    'Gold', 'Silver', 'Platinum', 'Royal', 'Imperial', 'Superior', 'Deluxe', 'Extra',
    'Prime', 'Select', 'Choice', 'Quality', 'Pro', 'Master', 'Expert', 'Professional',
    'Specialist', 'Leader', 'Winner', 'Champion', 'Best', 'First', 'Number One', 'Express',
    'Rapido', 'Veloce', 'Comodo', 'Facile', 'Sicuro', 'Affidabile', 'Garantito', 'Certificato'
  ];
  city_idx INTEGER;
  random_vat TEXT;
  random_phone TEXT;
  street_number TEXT;
  business_name TEXT;
  area_code TEXT;
BEGIN
  FOR category IN SELECT id, name, ateco_code FROM business_categories LOOP
    FOR business_counter IN 11..50 LOOP
      city_idx := ((business_counter - 1) % 100) + 1;
      street_number := (business_counter + (random() * 100)::INT)::TEXT;
      
      random_vat := LPAD((1000000000 + (random() * 8999999999)::BIGINT)::TEXT, 11, '0');
      
      area_code := CASE 
        WHEN city_idx <= 10 THEN (10 + city_idx)::TEXT
        WHEN city_idx <= 30 THEN '0' || (30 + city_idx)::TEXT
        WHEN city_idx <= 60 THEN '0' || (60 + (city_idx % 30))::TEXT
        ELSE '0' || (80 + (city_idx % 20))::TEXT
      END;
      random_phone := '+39 ' || area_code || ' ' || LPAD((random() * 9999999)::INT::TEXT, 7, '0');
      
      IF business_counter % 3 = 0 THEN
        business_name := business_prefixes[((business_counter - 1) % 50) + 1] || ' ' || 
                        category.name || ' ' || cities[city_idx];
      ELSIF business_counter % 3 = 1 THEN
        business_name := category.name || ' ' || business_suffixes[((business_counter - 1) % 47) + 1] || 
                        ' - ' || cities[city_idx];
      ELSE
        business_name := business_prefixes[((business_counter - 1) % 50) + 1] || ' ' || 
                        business_suffixes[((business_counter + 10) % 47) + 1] || ' - ' || 
                        category.name;
      END IF;
      
      INSERT INTO businesses (
        owner_id,
        name,
        category_id,
        city,
        address,
        phone,
        email,
        vat_number,
        ateco_code,
        description,
        verified,
        is_claimed,
        billing_street,
        billing_street_number,
        billing_postal_code,
        billing_city,
        billing_province,
        office_street,
        office_street_number,
        office_postal_code,
        office_city,
        office_province,
        created_at
      ) VALUES (
        NULL,
        business_name,
        category.id,
        cities[city_idx],
        streets[((business_counter - 1) % 40) + 1] || ', ' || street_number,
        random_phone,
        LOWER(REPLACE(REPLACE(business_name, ' ', ''), '-', '')) || business_counter || '@pec.it',
        random_vat,
        category.ateco_code,
        'Attività specializzata nel settore ' || LOWER(category.name) || '. Operativa nella zona di ' || 
        cities[city_idx] || ' con servizi di qualità e professionalità garantita.',
        true,
        false,
        streets[((business_counter - 1) % 40) + 1],
        street_number,
        LPAD((10000 + (random() * 89999)::INT)::TEXT, 5, '0'),
        cities[city_idx],
        provinces[city_idx],
        streets[((business_counter + 20) % 40) + 1],
        street_number,
        LPAD((10000 + (random() * 89999)::INT)::TEXT, 5, '0'),
        cities[city_idx],
        provinces[city_idx],
        NOW() - (random() * interval '365 days')
      );
    END LOOP;
  END LOOP;
END $$;
