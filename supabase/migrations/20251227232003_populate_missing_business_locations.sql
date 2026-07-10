/*
  # Populate Missing Business Locations
  
  1. Purpose
    - Create business_locations for all businesses that don't have one yet
    - Use existing city data from businesses table to populate locations
    - Map cities to their correct province codes
  
  2. Process
    - Create temporary table with city to province mapping
    - Insert business_locations for all businesses with valid cities
    - Approximately 10,000+ businesses will get locations
  
  3. Data Mapping
    - Maps Italian cities to their province codes (e.g., Milano → MI, Roma → RM)
    - Uses business name, address, and city from businesses table
    - Sets is_primary to true for these locations
  
  4. Impact
    - Will significantly improve search results
    - Businesses will be findable by province and region filters
    - Fixes issue where filters were finding too few businesses
*/

-- Create temporary table with city to province mapping
CREATE TEMP TABLE IF NOT EXISTS city_province_map (
  city TEXT PRIMARY KEY,
  province_code TEXT NOT NULL
);

-- Insert city mappings for major Italian cities and most common cities from our data
INSERT INTO city_province_map (city, province_code) VALUES
  -- Lombardia
  ('Milano', 'MI'),
  ('Bergamo', 'BG'),
  ('Brescia', 'BS'),
  ('Como', 'CO'),
  ('Cremona', 'CR'),
  ('Lecco', 'LC'),
  ('Lodi', 'LO'),
  ('Mantova', 'MN'),
  ('Monza', 'MB'),
  ('Pavia', 'PV'),
  ('Sondrio', 'SO'),
  ('Varese', 'VA'),
  ('Cinisello Balsamo', 'MI'),
  ('Cusano Milanino', 'MI'),
  ('Sesto San Giovanni', 'MI'),
  ('Rho', 'MI'),
  ('Cologno Monzese', 'MI'),
  
  -- Piemonte
  ('Torino', 'TO'),
  ('Alessandria', 'AL'),
  ('Asti', 'AT'),
  ('Biella', 'BI'),
  ('Cuneo', 'CN'),
  ('Novara', 'NO'),
  ('Verbania', 'VB'),
  ('Vercelli', 'VC'),
  ('Moncalieri', 'TO'),
  ('Rivoli', 'TO'),
  ('Collegno', 'TO'),
  
  -- Lazio
  ('Roma', 'RM'),
  ('Frosinone', 'FR'),
  ('Latina', 'LT'),
  ('Rieti', 'RI'),
  ('Viterbo', 'VT'),
  
  -- Veneto
  ('Venezia', 'VE'),
  ('Verona', 'VR'),
  ('Padova', 'PD'),
  ('Vicenza', 'VI'),
  ('Treviso', 'TV'),
  ('Belluno', 'BL'),
  ('Rovigo', 'RO'),
  
  -- Emilia-Romagna
  ('Bologna', 'BO'),
  ('Modena', 'MO'),
  ('Parma', 'PR'),
  ('Reggio Emilia', 'RE'),
  ('Ferrara', 'FE'),
  ('Ravenna', 'RA'),
  ('Forlì', 'FC'),
  ('Cesena', 'FC'),
  ('Rimini', 'RN'),
  ('Piacenza', 'PC'),
  ('Imola', 'BO'),
  
  -- Toscana
  ('Firenze', 'FI'),
  ('Arezzo', 'AR'),
  ('Grosseto', 'GR'),
  ('Livorno', 'LI'),
  ('Lucca', 'LU'),
  ('Massa', 'MS'),
  ('Carrara', 'MS'),
  ('Pisa', 'PI'),
  ('Pistoia', 'PT'),
  ('Prato', 'PO'),
  ('Siena', 'SI'),
  ('Viareggio', 'LU'),
  
  -- Campania
  ('Napoli', 'NA'),
  ('Salerno', 'SA'),
  ('Avellino', 'AV'),
  ('Benevento', 'BN'),
  ('Caserta', 'CE'),
  
  -- Sicilia
  ('Palermo', 'PA'),
  ('Catania', 'CT'),
  ('Messina', 'ME'),
  ('Siracusa', 'SR'),
  ('Trapani', 'TP'),
  ('Agrigento', 'AG'),
  ('Caltanissetta', 'CL'),
  ('Enna', 'EN'),
  ('Ragusa', 'RG'),
  
  -- Puglia
  ('Bari', 'BA'),
  ('Brindisi', 'BR'),
  ('Foggia', 'FG'),
  ('Lecce', 'LE'),
  ('Taranto', 'TA'),
  ('Barletta', 'BT'),
  ('Andria', 'BT'),
  ('Trani', 'BT'),
  ('Terlizzi', 'BA'),
  
  -- Liguria
  ('Genova', 'GE'),
  ('La Spezia', 'SP'),
  ('Savona', 'SV'),
  ('Imperia', 'IM'),
  
  -- Friuli-Venezia Giulia
  ('Trieste', 'TS'),
  ('Udine', 'UD'),
  ('Pordenone', 'PN'),
  ('Gorizia', 'GO'),
  
  -- Trentino-Alto Adige
  ('Trento', 'TN'),
  ('Bolzano', 'BZ'),
  ('Bolzano - Bozen', 'BZ'),
  ('Bozen', 'BZ'),
  
  -- Marche
  ('Ancona', 'AN'),
  ('Ascoli Piceno', 'AP'),
  ('Fermo', 'FM'),
  ('Macerata', 'MC'),
  ('Pesaro', 'PU'),
  ('Urbino', 'PU'),
  ('San Benedetto del Tronto', 'AP'),
  
  -- Abruzzo
  ('L''Aquila', 'AQ'),
  ('Teramo', 'TE'),
  ('Pescara', 'PE'),
  ('Chieti', 'CH'),
  ('Montesilvano', 'PE'),
  
  -- Umbria
  ('Perugia', 'PG'),
  ('Terni', 'TR'),
  
  -- Calabria
  ('Catanzaro', 'CZ'),
  ('Cosenza', 'CS'),
  ('Reggio Calabria', 'RC'),
  ('Crotone', 'KR'),
  ('Vibo Valentia', 'VV'),
  
  -- Sardegna
  ('Cagliari', 'CA'),
  ('Sassari', 'SS'),
  ('Nuoro', 'NU'),
  ('Oristano', 'OR'),
  
  -- Molise
  ('Campobasso', 'CB'),
  ('Isernia', 'IS'),
  
  -- Basilicata
  ('Potenza', 'PZ'),
  ('Matera', 'MT'),
  
  -- Valle d'Aosta
  ('Aosta', 'AO')
ON CONFLICT (city) DO NOTHING;

-- Insert business_locations for all businesses without locations that have valid cities
INSERT INTO business_locations (
  business_id,
  name,
  address,
  city,
  province,
  postal_code,
  latitude,
  longitude,
  phone,
  email,
  is_primary
)
SELECT 
  b.id,
  b.name,
  COALESCE(b.address, ''),
  b.city,
  cpm.province_code,
  '',
  NULL,
  NULL,
  COALESCE(b.phone, ''),
  COALESCE(b.email, ''),
  true
FROM businesses b
INNER JOIN city_province_map cpm ON b.city = cpm.city
WHERE b.id NOT IN (SELECT business_id FROM business_locations WHERE business_id IS NOT NULL)
  AND b.city IS NOT NULL 
  AND b.city != '';

-- Drop the temporary table
DROP TABLE IF EXISTS city_province_map;
