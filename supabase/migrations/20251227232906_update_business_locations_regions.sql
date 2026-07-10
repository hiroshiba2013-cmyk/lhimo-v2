/*
  # Update Business Locations with Missing Regions
  
  1. Purpose
    - Add region field to business_locations that are missing it
    - Map province codes to their corresponding regions
    - Enable proper filtering by region in search results
  
  2. Impact
    - Updates ~4,500 business_locations with missing region field
    - Fixes search/filter functionality for regional searches
    - Businesses will now appear in region-based searches
  
  3. Mapping
    - Uses province codes (MI, RM, TO, etc.) to determine region
    - Maps to 20 Italian regions (Lombardia, Lazio, Piemonte, etc.)
*/

-- Update business_locations with region based on province code
UPDATE business_locations
SET region = CASE 
  -- Lombardia
  WHEN province IN ('MI', 'BG', 'BS', 'CO', 'CR', 'LC', 'LO', 'MN', 'MB', 'PV', 'SO', 'VA') THEN 'Lombardia'
  
  -- Piemonte
  WHEN province IN ('TO', 'AL', 'AT', 'BI', 'CN', 'NO', 'VB', 'VC') THEN 'Piemonte'
  
  -- Lazio
  WHEN province IN ('RM', 'FR', 'LT', 'RI', 'VT') THEN 'Lazio'
  
  -- Veneto
  WHEN province IN ('VE', 'VR', 'PD', 'VI', 'TV', 'BL', 'RO') THEN 'Veneto'
  
  -- Emilia-Romagna
  WHEN province IN ('BO', 'MO', 'PR', 'RE', 'FE', 'RA', 'FC', 'RN', 'PC') THEN 'Emilia-Romagna'
  
  -- Toscana
  WHEN province IN ('FI', 'AR', 'GR', 'LI', 'LU', 'MS', 'PI', 'PT', 'PO', 'SI') THEN 'Toscana'
  
  -- Campania
  WHEN province IN ('NA', 'SA', 'AV', 'BN', 'CE') THEN 'Campania'
  
  -- Sicilia
  WHEN province IN ('PA', 'CT', 'ME', 'SR', 'TP', 'AG', 'CL', 'EN', 'RG') THEN 'Sicilia'
  
  -- Puglia
  WHEN province IN ('BA', 'BR', 'FG', 'LE', 'TA', 'BT') THEN 'Puglia'
  
  -- Liguria
  WHEN province IN ('GE', 'SP', 'SV', 'IM') THEN 'Liguria'
  
  -- Friuli-Venezia Giulia
  WHEN province IN ('TS', 'UD', 'PN', 'GO') THEN 'Friuli-Venezia Giulia'
  
  -- Trentino-Alto Adige
  WHEN province IN ('TN', 'BZ') THEN 'Trentino-Alto Adige'
  
  -- Marche
  WHEN province IN ('AN', 'AP', 'FM', 'MC', 'PU') THEN 'Marche'
  
  -- Abruzzo
  WHEN province IN ('AQ', 'TE', 'PE', 'CH') THEN 'Abruzzo'
  
  -- Umbria
  WHEN province IN ('PG', 'TR') THEN 'Umbria'
  
  -- Calabria
  WHEN province IN ('CZ', 'CS', 'RC', 'KR', 'VV') THEN 'Calabria'
  
  -- Sardegna
  WHEN province IN ('CA', 'SS', 'NU', 'OR', 'SU') THEN 'Sardegna'
  
  -- Molise
  WHEN province IN ('CB', 'IS') THEN 'Molise'
  
  -- Basilicata
  WHEN province IN ('PZ', 'MT') THEN 'Basilicata'
  
  -- Valle d'Aosta
  WHEN province = 'AO' THEN 'Valle d''Aosta'
  
  ELSE region
END
WHERE (region IS NULL OR region = '')
  AND province IS NOT NULL 
  AND province != '';
