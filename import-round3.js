/**
 * ROUND 3 - Query su RELAZIONI/WAYS con tag building=commercial/retail/industrial
 * + landuse=commercial + amenity generico
 * Cattura strutture commerciali senza tag specifici
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';
config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const ZONES = [
  { province: 'AO', region: "Valle d'Aosta", bbox: [45.45, 6.80, 45.90, 7.90] },
  { province: 'AV', region: 'Campania', bbox: [40.60, 14.50, 41.30, 15.40] },
  { province: 'EN', region: 'Sicilia', bbox: [37.20, 13.90, 37.95, 14.75] },
  { province: 'NU', region: 'Sardegna', bbox: [39.80, 8.80, 40.85, 9.95] },
  { province: 'OR', region: 'Sardegna', bbox: [39.40, 8.20, 40.50, 9.30] },
  { province: 'OT', region: 'Sardegna', bbox: [40.65, 8.75, 41.45, 9.85] },
  { province: 'VV', region: 'Calabria', bbox: [38.30, 15.70, 38.95, 16.55] },
  { province: 'SO', region: 'Lombardia', bbox: [45.80, 9.10, 46.75, 10.80] },
  { province: 'BI', region: 'Piemonte', bbox: [45.35, 7.85, 45.85, 8.35] },
  { province: 'LC', region: 'Lombardia', bbox: [45.55, 9.15, 46.05, 9.75] },
  { province: 'CL', region: 'Sicilia', bbox: [36.80, 13.55, 37.75, 14.65] },
  { province: 'BL', region: 'Veneto', bbox: [45.85, 11.60, 46.75, 12.70] },
  { province: 'VT', region: 'Lazio', bbox: [42.05, 11.40, 42.85, 12.55] },
  { province: 'TE', region: 'Abruzzo', bbox: [42.35, 13.35, 42.95, 14.15] },
  { province: 'IS', region: 'Molise', bbox: [41.35, 13.85, 41.95, 14.65] },
  { province: 'GR', region: 'Toscana', bbox: [42.20, 10.55, 43.25, 11.95] },
  { province: 'CZ', region: 'Calabria', bbox: [38.45, 16.15, 39.25, 17.00] },
  { province: 'RC', region: 'Calabria', bbox: [37.75, 15.35, 38.65, 16.65] },
  { province: 'BN', region: 'Campania', bbox: [40.95, 14.35, 41.45, 15.25] },
  { province: 'MC', region: 'Marche', bbox: [42.85, 12.85, 43.65, 13.95] },
  { province: 'FG', region: 'Puglia', bbox: [40.95, 14.85, 42.05, 16.25] },
  { province: 'CR', region: 'Lombardia', bbox: [44.85, 9.65, 45.45, 10.45] },
  { province: 'SS', region: 'Sardegna', bbox: [40.35, 8.05, 41.35, 9.35] },
  { province: 'AG', region: 'Sicilia', bbox: [36.95, 12.75, 37.75, 14.05] },
  { province: 'PU', region: 'Marche', bbox: [43.35, 11.95, 44.05, 13.25] },
  { province: 'VB', region: 'Piemonte', bbox: [45.70, 8.00, 46.55, 9.00] },
  { province: 'TR', region: 'Umbria', bbox: [42.25, 11.75, 42.85, 13.05] },
  { province: 'GO', region: 'Friuli-Venezia Giulia', bbox: [45.65, 13.35, 46.05, 13.85] },
  { province: 'FR', region: 'Lazio', bbox: [41.35, 12.95, 41.95, 14.05] },
  { province: 'AR', region: 'Toscana', bbox: [43.05, 11.35, 43.85, 12.35] },
  { province: 'FM', region: 'Marche', bbox: [42.85, 13.45, 43.45, 13.95] },
  { province: 'RO', region: 'Veneto', bbox: [44.75, 11.45, 45.25, 12.45] },
  { province: 'PZ', region: 'Basilicata', bbox: [39.95, 15.15, 41.25, 16.45] },
  { province: 'SA', region: 'Campania', bbox: [39.85, 14.55, 41.05, 15.85] },
  { province: 'PN', region: 'Friuli-Venezia Giulia', bbox: [45.75, 12.35, 46.35, 13.05] },
  { province: 'CS', region: 'Calabria', bbox: [38.95, 15.55, 40.15, 16.85] },
  { province: 'LT', region: 'Lazio', bbox: [41.05, 12.55, 41.75, 13.85] },
  { province: 'AP', region: 'Marche', bbox: [42.55, 13.25, 43.15, 14.05] },
  { province: 'MS', region: 'Toscana', bbox: [43.95, 9.65, 44.55, 10.25] },
  { province: 'IM', region: 'Liguria', bbox: [43.65, 7.45, 44.15, 8.25] },
  { province: 'CE', region: 'Campania', bbox: [40.85, 13.75, 41.45, 14.65] },
  { province: 'RG', region: 'Sicilia', bbox: [36.65, 14.35, 37.35, 15.15] },
  { province: 'MN', region: 'Lombardia', bbox: [44.85, 10.45, 45.35, 11.25] },
  { province: 'AQ', region: 'Abruzzo', bbox: [41.65, 12.95, 42.65, 14.25] },
  { province: 'CB', region: 'Molise', bbox: [41.35, 14.35, 41.95, 15.25] },
  { province: 'KR', region: 'Calabria', bbox: [38.65, 16.55, 39.55, 17.55] },
  { province: 'TP', region: 'Sicilia', bbox: [37.45, 12.15, 38.25, 13.25] },
  { province: 'RI', region: 'Lazio', bbox: [41.95, 12.35, 42.65, 13.55] },
  { province: 'LO', region: 'Lombardia', bbox: [45.05, 9.25, 45.55, 9.85] },
  { province: 'BT', region: 'Puglia', bbox: [40.95, 15.85, 41.55, 16.65] },
  { province: 'MT', region: 'Basilicata', bbox: [39.85, 15.75, 40.85, 16.95] },
  { province: 'PV', region: 'Lombardia', bbox: [44.75, 8.65, 45.45, 9.55] },
  { province: 'VC', region: 'Piemonte', bbox: [44.95, 7.95, 45.65, 8.75] },
  { province: 'SP', region: 'Liguria', bbox: [43.85, 9.45, 44.35, 10.05] },
  { province: 'SV', region: 'Liguria', bbox: [43.85, 7.95, 44.55, 8.85] },
  { province: 'PC', region: 'Emilia-Romagna', bbox: [44.55, 9.15, 45.25, 10.15] },
  { province: 'FE', region: 'Emilia-Romagna', bbox: [44.45, 11.35, 45.05, 12.15] },
  { province: 'PT', region: 'Toscana', bbox: [43.65, 10.55, 44.25, 11.25] },
  { province: 'PO', region: 'Toscana', bbox: [43.65, 10.75, 44.15, 11.35] },
  { province: 'SI', region: 'Toscana', bbox: [42.75, 10.85, 43.65, 12.05] },
  { province: 'LU', region: 'Toscana', bbox: [43.65, 10.25, 44.35, 10.85] },
  { province: 'AT', region: 'Piemonte', bbox: [44.55, 7.85, 45.05, 8.55] },
  { province: 'AL', region: 'Piemonte', bbox: [44.45, 8.25, 45.15, 9.05] },
  { province: 'NO', region: 'Piemonte', bbox: [45.30, 8.35, 45.85, 8.85] },
  { province: 'CH', region: 'Abruzzo', bbox: [41.85, 13.75, 42.65, 14.85] },
  { province: 'PE', region: 'Abruzzo', bbox: [42.10, 13.75, 42.65, 14.45] },
  { province: 'BR', region: 'Puglia', bbox: [40.25, 17.35, 40.95, 18.25] },
  { province: 'TA', region: 'Puglia', bbox: [40.05, 16.55, 40.75, 17.85] },
  { province: 'CA', region: 'Sardegna', bbox: [38.75, 8.55, 39.55, 9.65] },
  { province: 'ME', region: 'Sicilia', bbox: [37.85, 14.35, 38.35, 15.65] },
  { province: 'SR', region: 'Sicilia', bbox: [36.65, 14.85, 37.45, 15.45] },
  { province: 'FC', region: 'Emilia-Romagna', bbox: [43.65, 11.60, 44.35, 12.45] },
  { province: 'RA', region: 'Emilia-Romagna', bbox: [44.10, 11.65, 44.65, 12.45] },
  { province: 'RN', region: 'Emilia-Romagna', bbox: [43.75, 12.10, 44.25, 12.75] },
  { province: 'AN', region: 'Marche', bbox: [43.15, 12.75, 43.85, 13.75] },
  { province: 'PG', region: 'Umbria', bbox: [42.45, 11.75, 43.65, 13.15] },
  { province: 'TV', region: 'Veneto', bbox: [45.55, 11.75, 46.05, 12.55] },
  { province: 'VI', region: 'Veneto', bbox: [45.35, 11.15, 45.95, 11.75] },
  { province: 'UD', region: 'Friuli-Venezia Giulia', bbox: [45.80, 12.75, 46.65, 13.55] },
  { province: 'TS', region: 'Friuli-Venezia Giulia', bbox: [45.55, 13.60, 45.85, 13.95] },
  { province: 'TN', region: 'Trentino-Alto Adige', bbox: [45.55, 10.50, 46.65, 11.60] },
  { province: 'BZ', region: 'Trentino-Alto Adige', bbox: [46.20, 10.35, 47.10, 12.30] },
  { province: 'VA', region: 'Lombardia', bbox: [45.55, 8.40, 46.05, 9.00] },
  { province: 'CO', region: 'Lombardia', bbox: [45.65, 8.95, 46.15, 9.55] },
  { province: 'MB', region: 'Lombardia', bbox: [45.50, 9.10, 45.80, 9.55] },
  { province: 'TO', region: 'Piemonte', bbox: [44.70, 7.00, 45.60, 8.10] },
  { province: 'CN', region: 'Piemonte', bbox: [43.90, 7.10, 44.80, 8.00] },
  { province: 'MI', region: 'Lombardia', bbox: [45.20, 8.80, 45.65, 9.75] },
  { province: 'BS', region: 'Lombardia', bbox: [45.10, 10.05, 46.20, 10.65] },
  { province: 'BG', region: 'Lombardia', bbox: [45.55, 9.55, 46.15, 10.25] },
  { province: 'VR', region: 'Veneto', bbox: [45.10, 10.55, 45.65, 11.45] },
  { province: 'PD', region: 'Veneto', bbox: [45.05, 11.50, 45.65, 12.15] },
  { province: 'VE', region: 'Veneto', bbox: [45.25, 12.05, 45.75, 12.65] },
  { province: 'GE', region: 'Liguria', bbox: [44.20, 8.65, 44.55, 9.25] },
  { province: 'PA', region: 'Sicilia', bbox: [37.80, 13.10, 38.30, 13.75] },
  { province: 'CT', region: 'Sicilia', bbox: [37.20, 14.75, 37.80, 15.35] },
  { province: 'BO', region: 'Emilia-Romagna', bbox: [44.25, 10.95, 44.75, 11.75] },
  { province: 'MO', region: 'Emilia-Romagna', bbox: [44.20, 10.60, 44.80, 11.30] },
  { province: 'RE', region: 'Emilia-Romagna', bbox: [44.25, 10.25, 44.75, 10.85] },
  { province: 'PR', region: 'Emilia-Romagna', bbox: [44.25, 9.85, 44.90, 10.65] },
  { province: 'FI', region: 'Toscana', bbox: [43.55, 10.75, 44.05, 11.65] },
  { province: 'PI', region: 'Toscana', bbox: [43.45, 10.20, 43.95, 11.05] },
  { province: 'LI', region: 'Toscana', bbox: [42.60, 10.15, 43.55, 10.85] },
  { province: 'LE', region: 'Puglia', bbox: [39.75, 17.75, 40.45, 18.55] },
  { province: 'BA', region: 'Puglia', bbox: [40.65, 16.55, 41.25, 17.25] },
  { province: 'NA', region: 'Campania', bbox: [40.50, 14.00, 41.20, 14.60] },
  { province: 'RM', region: 'Lazio', bbox: [41.40, 12.10, 42.50, 13.30] },
];

// Tag focalizzati su categorie rimaste: florist, studi medici, sport, istruzione, artigianato rurale
const TAG_QUERIES = [
  { key: 'shop', val: 'florist', cat: 'Fiorai' },
  { key: 'shop', val: 'florist', cat: 'Fiorai' }, // duplicato intenzionale per retry diversi
  { key: 'amenity', val: 'marketplace', cat: 'Mercati' },
  { key: 'amenity', val: 'marketplace', cat: 'Mercati' },
  // Ristorazione etnica molto diffusa
  { key: 'amenity', val: 'bbq', cat: 'Ristoranti' },
  { key: 'amenity', val: 'canteen', cat: 'Ristoranti' },
  { key: 'amenity', val: 'vending_machine', cat: 'Distributori Automatici' },
  // Nuovi sport
  { key: 'sport', val: 'athletics', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'basketball', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'football', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'volleyball', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'swimming', cat: 'Piscine' },
  { key: 'sport', val: 'cycling', cat: 'Biciclette' },
  { key: 'sport', val: 'gymnastics', cat: 'Palestre' },
  { key: 'sport', val: 'hockey', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'ice_skating', cat: 'Piste di Pattinaggio' },
  { key: 'sport', val: 'skiing', cat: 'Sci e Snowboard' },
  { key: 'sport', val: 'snowboard', cat: 'Sci e Snowboard' },
  { key: 'sport', val: 'table_tennis', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'rowing', cat: 'Nautica' },
  { key: 'sport', val: 'sailing', cat: 'Nautica' },
  { key: 'sport', val: 'surfing', cat: 'Surf' },
  { key: 'sport', val: 'kitesurfing', cat: 'Surf' },
  { key: 'sport', val: 'windsurfing', cat: 'Surf' },
  { key: 'sport', val: 'billiards', cat: 'Sale Giochi' },
  { key: 'sport', val: 'boxing', cat: 'Arti Marziali' },
  { key: 'sport', val: 'judo', cat: 'Arti Marziali' },
  { key: 'sport', val: 'karate', cat: 'Arti Marziali' },
  { key: 'sport', val: 'wrestling', cat: 'Arti Marziali' },
  { key: 'sport', val: 'crossfit', cat: 'Palestre' },
  { key: 'sport', val: 'pilates', cat: 'Centri Yoga' },
  { key: 'sport', val: 'aerobics', cat: 'Palestre' },
  { key: 'sport', val: 'dance', cat: 'Scuole di Danza' },
  { key: 'sport', val: 'fencing', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'archery', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'climbing', cat: 'Centri Sportivi' },
  { key: 'sport', val: 'horse_racing', cat: 'Maneggi' },
  { key: 'sport', val: 'polo', cat: 'Maneggi' },
  // Veicoli speciali
  { key: 'shop', val: 'boat', cat: 'Nautica' },
  { key: 'shop', val: 'scuba_diving', cat: 'Sub e Diving' },
  { key: 'craft', val: 'boatbuilder', cat: 'Nautica' },
  // Nuovi craft
  { key: 'craft', val: 'agricultural_engines', cat: 'Meccanici' },
  { key: 'craft', val: 'caterer', cat: 'Catering' },
  { key: 'craft', val: 'cleaning', cat: 'Pulizie' },
  { key: 'craft', val: 'construction_machine_operator', cat: 'Edilizia' },
  { key: 'craft', val: 'demolition', cat: 'Edilizia' },
  { key: 'craft', val: 'dressmaker', cat: 'Sartorie' },
  { key: 'craft', val: 'electronics_repair', cat: 'Riparazione Elettronica' },
  { key: 'craft', val: 'gardener', cat: 'Giardinieri' },
  { key: 'craft', val: 'grinding', cat: 'Affilatura' },
  { key: 'craft', val: 'handicraft', cat: 'Artigianato' },
  { key: 'craft', val: 'horologist', cat: 'Orologiai' },
  { key: 'craft', val: 'hvac', cat: 'Climatizzazione' },
  { key: 'craft', val: 'joiner', cat: 'Falegnami' },
  { key: 'craft', val: 'key_cutter', cat: 'Duplicazione Chiavi' },
  { key: 'craft', val: 'laboratory', cat: 'Laboratori Analisi' },
  { key: 'craft', val: 'laundry', cat: 'Lavanderie' },
  { key: 'craft', val: 'leather', cat: 'Pelletterie' },
  { key: 'craft', val: 'microbrewery', cat: 'Birrifici' },
  { key: 'craft', val: 'mosaic', cat: 'Ceramisti' },
  { key: 'craft', val: 'oil_pressing', cat: 'Frantoi' },
  { key: 'craft', val: 'sawmill', cat: 'Segherie' },
  { key: 'craft', val: 'shoemaker', cat: 'Calzolai' },
  { key: 'craft', val: 'slaughterer', cat: 'Macellerie' },
  { key: 'craft', val: 'wicker', cat: 'Artigianato' },
  // Office ancora mancanti
  { key: 'office', val: 'bail_bond_agent', cat: 'Avvocati' },
  { key: 'office', val: 'customs', cat: 'Spedizioni' },
  { key: 'office', val: 'forestry', cat: 'Forestale' },
  { key: 'office', val: 'gaming', cat: 'Videogiochi' },
  { key: 'office', val: 'geodesy', cat: 'Geometri' },
  { key: 'office', val: 'harbour_master', cat: 'Nautica' },
  { key: 'office', val: 'marriage_bureau', cat: 'Servizi Personali' },
  { key: 'office', val: 'network_operator', cat: 'Telefonia' },
  { key: 'office', val: 'parish', cat: 'Associazioni' },
  { key: 'office', val: 'private_investigator', cat: 'Investigatori' },
  { key: 'office', val: 'recruitment', cat: 'Agenzie del Lavoro' },
  { key: 'office', val: 'translation', cat: 'Traduttori' },
  { key: 'office', val: 'visa', cat: 'Agenzie di Viaggio' },
  // Healthcare rari
  { key: 'healthcare', val: 'blood_bank', cat: 'Ospedali' },
  { key: 'healthcare', val: 'blood_donation', cat: 'Ospedali' },
  { key: 'healthcare', val: 'hospice', cat: 'Case di Cura' },
  { key: 'healthcare', val: 'nursing_home', cat: 'Case di Cura' },
  { key: 'healthcare', val: 'sample_collection', cat: 'Laboratori Analisi' },
  { key: 'healthcare', val: 'skin', cat: 'Cliniche' },
  { key: 'healthcare', val: 'nutrition', cat: 'Nutrizionisti' },
  { key: 'healthcare', val: 'hearing', cat: 'Ottici' },
  { key: 'healthcare', val: 'urology', cat: 'Cliniche' },
  { key: 'healthcare', val: 'cardiology', cat: 'Cliniche' },
  { key: 'healthcare', val: 'oncology', cat: 'Cliniche' },
  { key: 'healthcare', val: 'paediatrics', cat: 'Medici' },
  { key: 'healthcare', val: 'radiology', cat: 'Cliniche' },
  { key: 'healthcare', val: 'orthopaedics', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'gynaecology', cat: 'Cliniche' },
  { key: 'healthcare', val: 'neurology', cat: 'Cliniche' },
  // Leisure rari
  { key: 'leisure', val: 'adult_gaming_centre', cat: 'Sale Giochi' },
  { key: 'leisure', val: 'bird_hide', cat: 'Outdoor e Camping' },
  { key: 'leisure', val: 'dog_park', cat: 'Negozi per Animali' },
  { key: 'leisure', val: 'horse_riding', cat: 'Maneggi' },
  { key: 'leisure', val: 'ice_rink', cat: 'Piste di Pattinaggio' },
  { key: 'leisure', val: 'indoor_play', cat: 'Parchi Giochi' },
  { key: 'leisure', val: 'marina', cat: 'Nautica' },
  { key: 'leisure', val: 'nature_reserve', cat: 'Outdoor e Camping' },
  { key: 'leisure', val: 'outdoor_seating', cat: 'Bar e Caffè' },
  { key: 'leisure', val: 'pitch', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'riding_school', cat: 'Maneggi' },
  { key: 'leisure', val: 'sports_hall', cat: 'Palestre' },
  { key: 'leisure', val: 'stadium', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'track', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'trampoline_park', cat: 'Parchi Giochi' },
  // Shop rarissimi ma presenti in Italia
  { key: 'shop', val: 'bread', cat: 'Panifici' },
  { key: 'shop', val: 'canteen', cat: 'Ristoranti' },
  { key: 'shop', val: 'cheesemonger', cat: 'Formaggerie' },
  { key: 'shop', val: 'confectionery', cat: 'Pasticcerie' },
  { key: 'shop', val: 'deli_grocery', cat: 'Gastronomie' },
  { key: 'shop', val: 'fashion_accessories', cat: 'Abbigliamento' },
  { key: 'shop', val: 'food_and_drink', cat: 'Alimentari' },
  { key: 'shop', val: 'gift_shop', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'grocery', cat: 'Alimentari' },
  { key: 'shop', val: 'grocery_store', cat: 'Alimentari' },
  { key: 'shop', val: 'home_appliance', cat: 'Elettrodomestici' },
  { key: 'shop', val: 'ice', cat: 'Alimentari' },
  { key: 'shop', val: 'kiosk', cat: 'Giornali' },
  { key: 'shop', val: 'laundry_service', cat: 'Lavanderie' },
  { key: 'shop', val: 'leatherwork', cat: 'Pelletterie' },
  { key: 'shop', val: 'meat', cat: 'Macellerie' },
  { key: 'shop', val: 'motorcycle_repair', cat: 'Autofficine' },
  { key: 'shop', val: 'olive_oil', cat: 'Gastronomie' },
  { key: 'shop', val: 'paints', cat: 'Colorifici' },
  { key: 'shop', val: 'pasta', cat: 'Gastronomie' },
  { key: 'shop', val: 'phone_accessories', cat: 'Telefonia' },
  { key: 'shop', val: 'pizza', cat: 'Ristoranti' },
  { key: 'shop', val: 'rental', cat: 'Noleggi' },
  { key: 'shop', val: 'road_equipment', cat: 'Ricambi Auto' },
  { key: 'shop', val: 'safety_equipment', cat: 'Sicurezza' },
  { key: 'shop', val: 'sanitair', cat: 'Idraulici' },
  { key: 'shop', val: 'seafood', cat: 'Pescherie' },
  { key: 'shop', val: 'shoe_store', cat: 'Calzature' },
  { key: 'shop', val: 'sushi', cat: 'Ristoranti' },
  { key: 'shop', val: 'sweets', cat: 'Pasticcerie' },
  { key: 'shop', val: 'trade_tools', cat: 'Ferramenta' },
  { key: 'shop', val: 'travel', cat: 'Agenzie di Viaggio' },
  { key: 'shop', val: 'uniform', cat: 'Abbigliamento' },
  { key: 'shop', val: 'vegetable', cat: 'Frutta e Verdura' },
  { key: 'shop', val: 'wine_shop', cat: 'Enoteche' },
];

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();
const PROV_REGION = {};
ZONES.forEach(z => { PROV_REGION[z.province] = z.region; });

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
}
const sleep = ms => new Promise(r => setTimeout(r, ms));

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const body = `data=${encodeURIComponent(query)}`;
    const opts = { hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': Buffer.byteLength(body), 'User-Agent': 'ItalianBizDir/R3' } };
    const req = https.request(opts, res => {
      let d = '';
      res.on('data', c => d += c);
      res.on('end', () => {
        if (res.statusCode === 429) { reject(new Error('RATE_LIMIT')); return; }
        if (res.statusCode >= 400) { reject(new Error(`HTTP ${res.statusCode}`)); return; }
        try { resolve(JSON.parse(d)); } catch { reject(new Error('JSON')); }
      });
    });
    req.on('error', reject);
    req.setTimeout(120000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body); req.end();
  });
}

function buildQuery(tq, zone) {
  const [s, w, n, e] = zone.bbox;
  return `[out:json][timeout:90];\n(\n  node["${tq.key}"="${tq.val}"](${s},${w},${n},${e});\n  way["${tq.key}"="${tq.val}"](${s},${w},${n},${e});\n);\nout center tags;`;
}

function makeRecord(el, zone, catId) {
  const tags = el.tags || {};
  if (!tags.name) return null;
  const lat = el.lat ?? el.center?.lat;
  const lon = el.lon ?? el.center?.lon;
  if (!lat || !lon) return null;
  return {
    name: tags.name.substring(0, 200),
    category_id: catId,
    street: tags['addr:street'] ? (tags['addr:housenumber'] ? `${tags['addr:street']}, ${tags['addr:housenumber']}` : tags['addr:street']) : null,
    city: (tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || tags['addr:municipality'] || '').substring(0, 100) || zone.province,
    province: zone.province,
    region: PROV_REGION[zone.province] || zone.region,
    postal_code: tags['addr:postcode'] || null,
    country: 'Italia',
    latitude: lat, longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '').substring(0, 50) || null,
    email: (tags.email || tags['contact:email'] || '').substring(0, 200) || null,
    website: (tags.website || tags['contact:website'] || '').substring(0, 500) || null,
    business_hours: tags.opening_hours || null,
    is_claimed: false, approval_status: 'approved',
  };
}

async function runTagZone(tq, zone) {
  const catId = categoryCache[tq.cat];
  if (!catId) return 0;
  let elements = [];
  for (let retry = 0; retry < 3; retry++) {
    try { const data = await fetchOverpass(buildQuery(tq, zone)); elements = data.elements || []; break; }
    catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(90000); retry--; continue; }
      if (retry < 2) { await sleep((retry + 1) * 10000); continue; }
      return 0;
    }
  }
  const records = []; const seen = new Set();
  for (const el of elements) {
    const r = makeRecord(el, zone, catId);
    if (!r) continue;
    const key = `${r.name}|${r.province}|${r.latitude?.toFixed(4)}|${r.longitude?.toFixed(4)}`;
    if (seen.has(key)) continue; seen.add(key); records.push(r);
  }
  if (!records.length) return 0;
  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const batch = records.slice(i, i + 200);
    const { error } = await supabase.from('unclaimed_business_locations').insert(batch);
    if (!error) { inserted += batch.length; }
    else if (error.code === '23505') { for (const rec of batch) { const { error: e2 } = await supabase.from('unclaimed_business_locations').insert(rec); if (!e2) inserted++; } }
  }
  totalImported += inserted;
  return inserted;
}

async function main() {
  console.log(`\n=== ROUND 3 - TAG SPORT/ARTIGIANATO/RARI ===`);
  console.log(`${TAG_QUERIES.length} tag x ${ZONES.length} province\n`);
  await loadCategories();
  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    let tagTotal = 0;
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val}: `);
    for (const zone of ZONES) {
      const n = await runTagZone(tq, zone);
      if (n > 0) { process.stdout.write(`${zone.province}+${n} `); tagTotal += n; }
      await sleep(1800);
    }
    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   +${tagTotal} | tot: ${totalImported.toLocaleString()} (${mins}m)`);
    await sleep(2500);
  }
  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== R3 COMPLETATO === sessione: ${totalImported.toLocaleString()} | DB: ${count?.toLocaleString()}`);
}
main().catch(console.error);
