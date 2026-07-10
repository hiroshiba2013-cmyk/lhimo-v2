/*
  # Seed Unclaimed Businesses Data

  1. Purpose
    - Insert 10 sample businesses for each business category
    - Businesses are created as unclaimed (owner_id = NULL, is_claimed = false)
    - All businesses are marked as verified to be visible in searches
    - Data includes realistic Italian business names and addresses

  2. Data Structure
    - Business name follows pattern: [Category Type] + [Italian Name/Location]
    - Addresses distributed across major Italian cities
    - All required fields populated with realistic data
    - Each business has unique VAT number
*/

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