/**
 * ROUND 2 - Query per nome/type invece di tag specifici
 * Cattura attività che non hanno tag amenity/shop/craft standard
 * Usa: name queries, office types, healthcare types, leisure types
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';
config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

// Province con meno attività - priorità assoluta
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

// Tag meno comuni - round 2 cattura ciò che sfugge ai tag principali
const TAG_QUERIES = [
  // Ristorazione avanzata
  { key: 'cuisine', val: 'pizza', cat: 'Ristoranti' },
  { key: 'cuisine', val: 'italian', cat: 'Ristoranti' },
  { key: 'cuisine', val: 'sushi', cat: 'Ristoranti' },
  { key: 'cuisine', val: 'kebab', cat: 'Fast Food' },
  { key: 'cuisine', val: 'chinese', cat: 'Ristoranti' },
  { key: 'cuisine', val: 'greek', cat: 'Ristoranti' },
  { key: 'cuisine', val: 'indian', cat: 'Ristoranti' },
  // Healthcare avanzata
  { key: 'healthcare', val: 'centre', cat: 'Cliniche' },
  { key: 'healthcare', val: 'hospital', cat: 'Ospedali' },
  { key: 'healthcare', val: 'clinic', cat: 'Cliniche' },
  { key: 'healthcare', val: 'dentist', cat: 'Dentisti' },
  { key: 'healthcare', val: 'doctor', cat: 'Medici' },
  { key: 'healthcare', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'healthcare', val: 'rehabilitation', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'audiologist', cat: 'Medici' },
  { key: 'healthcare', val: 'chiropractor', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'midwife', cat: 'Medici' },
  { key: 'healthcare', val: 'acupuncturist', cat: 'Medicine Alternative' },
  // Office types
  { key: 'office', val: 'property_management', cat: 'Agenzie Immobiliari' },
  { key: 'office', val: 'moving_company', cat: 'Traslochi' },
  { key: 'office', val: 'newspaper', cat: 'Media' },
  { key: 'office', val: 'publishing', cat: 'Media' },
  { key: 'office', val: 'telecommunication', cat: 'Telefonia' },
  { key: 'office', val: 'diplomatic', cat: 'Uffici Pubblici' },
  { key: 'office', val: 'government', cat: 'Uffici Pubblici' },
  { key: 'office', val: 'coworking', cat: 'Coworking' },
  { key: 'office', val: 'quango', cat: 'Uffici Pubblici' },
  { key: 'office', val: 'political_party', cat: 'Associazioni' },
  { key: 'office', val: 'religion', cat: 'Associazioni' },
  { key: 'office', val: 'private_investigator', cat: 'Investigatori' },
  { key: 'office', val: 'pest_control', cat: 'Disinfestazione' },
  { key: 'office', val: 'security', cat: 'Sicurezza' },
  { key: 'office', val: 'cleaning', cat: 'Pulizie' },
  { key: 'office', val: 'logistics', cat: 'Logistica' },
  { key: 'office', val: 'courier', cat: 'Corrieri' },
  // Leisure avanzato
  { key: 'leisure', val: 'amusement_arcade', cat: 'Sale Giochi' },
  { key: 'leisure', val: 'bowling_alley', cat: 'Bowling' },
  { key: 'leisure', val: 'escape_game', cat: 'Sale Giochi' },
  { key: 'leisure', val: 'miniature_golf', cat: 'Golf' },
  { key: 'leisure', val: 'hackerspace', cat: 'Coworking' },
  { key: 'leisure', val: 'water_park', cat: 'Parchi Acquatici' },
  { key: 'leisure', val: 'bird_hide', cat: 'Outdoor e Camping' },
  // Tourism avanzato
  { key: 'tourism', val: 'attraction', cat: 'Attrazioni Turistiche' },
  { key: 'tourism', val: 'museum', cat: 'Musei' },
  { key: 'tourism', val: 'gallery', cat: "Gallerie d'Arte" },
  { key: 'tourism', val: 'information', cat: 'Turismo' },
  { key: 'tourism', val: 'theme_park', cat: 'Parchi Divertimento' },
  { key: 'tourism', val: 'zoo', cat: 'Zoo' },
  { key: 'tourism', val: 'aquarium', cat: 'Acquari' },
  { key: 'tourism', val: 'spa', cat: 'Centri Estetici' },
  { key: 'tourism', val: 'alpine_hut', cat: 'Hotel' },
  { key: 'tourism', val: 'wilderness_hut', cat: 'Hotel' },
  // Craft avanzato
  { key: 'craft', val: 'signmaker', cat: 'Insegne' },
  { key: 'craft', val: 'sculptor', cat: "Gallerie d'Arte" },
  { key: 'craft', val: 'bookbinder', cat: 'Cartolibrerie' },
  { key: 'craft', val: 'clockmaker', cat: 'Orologiai' },
  { key: 'craft', val: 'dental_technician', cat: 'Dentisti' },
  { key: 'craft', val: 'dressmaker', cat: 'Sartorie' },
  { key: 'craft', val: 'embroiderer', cat: 'Sartorie' },
  { key: 'craft', val: 'engraver', cat: 'Incisori' },
  { key: 'craft', val: 'furniture', cat: 'Arredamento' },
  { key: 'craft', val: 'insulation', cat: 'Isolamenti' },
  { key: 'craft', val: 'interior_decorator', cat: 'Interior Design' },
  { key: 'craft', val: 'metal_construction', cat: 'Strutture Metalliche' },
  { key: 'craft', val: 'optician', cat: 'Ottici' },
  { key: 'craft', val: 'organ_builder', cat: 'Strumenti Musicali' },
  { key: 'craft', val: 'packaging', cat: 'Imballaggi' },
  { key: 'craft', val: 'paver', cat: 'Pavimentatori' },
  { key: 'craft', val: 'piano_tuner', cat: 'Strumenti Musicali' },
  { key: 'craft', val: 'plasterer', cat: 'Imbianchini' },
  { key: 'craft', val: 'rigger', cat: 'Installatori' },
  { key: 'craft', val: 'roofer', cat: 'Tetti' },
  { key: 'craft', val: 'saddler', cat: 'Sellai' },
  { key: 'craft', val: 'scaffolder', cat: 'Ponteggi' },
  { key: 'craft', val: 'sweep', cat: 'Spazzacamini' },
  { key: 'craft', val: 'window_construction', cat: 'Infissi' },
  { key: 'craft', val: 'woodworker', cat: 'Falegnami' },
  // Shop avanzato
  { key: 'shop', val: 'anime', cat: 'Fumetterie' },
  { key: 'shop', val: 'appliance', cat: 'Elettrodomestici' },
  { key: 'shop', val: 'bag', cat: 'Pelletterie' },
  { key: 'shop', val: 'boat', cat: 'Nautica' },
  { key: 'shop', val: 'bodycare', cat: 'Centri Estetici' },
  { key: 'shop', val: 'candles', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'charity', cat: 'Associazioni' },
  { key: 'shop', val: 'chemist', cat: 'Farmacie' },
  { key: 'shop', val: 'collector', cat: 'Collezionismo' },
  { key: 'shop', val: 'comics', cat: 'Fumetterie' },
  { key: 'shop', val: 'copyshop', cat: 'Centri Copia' },
  { key: 'shop', val: 'craft', cat: 'Hobbistica' },
  { key: 'shop', val: 'curtain', cat: 'Tendaggi' },
  { key: 'shop', val: 'cycle', cat: 'Biciclette' },
  { key: 'shop', val: 'decorating', cat: 'Decorazioni' },
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'erotic', cat: 'Eroticar' },
  { key: 'shop', val: 'florist', cat: 'Fiorai' },
  { key: 'shop', val: 'food', cat: 'Alimentari' },
  { key: 'shop', val: 'frozen_food', cat: 'Alimentari' },
  { key: 'shop', val: 'funeral_directors', cat: 'Onoranze Funebri' },
  { key: 'shop', val: 'gambling', cat: 'Ricevitorie' },
  { key: 'shop', val: 'general', cat: 'Bazar' },
  { key: 'shop', val: 'health', cat: 'Erboristerie' },
  { key: 'shop', val: 'health_food', cat: 'Erboristerie' },
  { key: 'shop', val: 'herbalist', cat: 'Erboristerie' },
  { key: 'shop', val: 'houseware', cat: 'Casalinghi' },
  { key: 'shop', val: 'hunting', cat: 'Pesca e Caccia' },
  { key: 'shop', val: 'interior_decoration', cat: 'Interior Design' },
  { key: 'shop', val: 'laundry', cat: 'Lavanderie' },
  { key: 'shop', val: 'locksmith', cat: 'Duplicazione Chiavi' },
  { key: 'shop', val: 'lottery', cat: 'Ricevitorie' },
  { key: 'shop', val: 'medical_supply', cat: 'Forniture Mediche' },
  { key: 'shop', val: 'nutrition_supplements', cat: 'Integratori' },
  { key: 'shop', val: 'office_supplies', cat: 'Cartolerie' },
  { key: 'shop', val: 'paint', cat: 'Colorifici' },
  { key: 'shop', val: 'party', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'perfumery', cat: 'Profumerie' },
  { key: 'shop', val: 'plumbing', cat: 'Idraulici' },
  { key: 'shop', val: 'printing', cat: 'Tipografie' },
  { key: 'shop', val: 'psychic', cat: 'Esoterismo' },
  { key: 'shop', val: 'shoe_repair', cat: 'Calzolai' },
  { key: 'shop', val: 'storage_rental', cat: 'Box e Depositi' },
  { key: 'shop', val: 'surf', cat: 'Surf' },
  { key: 'shop', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'shop', val: 'ticket', cat: 'Agenzie di Viaggio' },
  { key: 'shop', val: 'trade', cat: 'Commercio' },
  { key: 'shop', val: 'travel_agency', cat: 'Agenzie di Viaggio' },
  { key: 'shop', val: 'trophy', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'tyres', cat: 'Pneumatici' },
  { key: 'shop', val: 'vacuum_cleaner', cat: 'Elettrodomestici' },
  { key: 'shop', val: 'watches', cat: 'Orologiai' },
  { key: 'shop', val: 'water', cat: 'Acqua' },
  { key: 'shop', val: 'wholesale', cat: 'Ingrosso' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  // Amenity avanzata
  { key: 'amenity', val: 'animal_shelter', cat: 'Veterinari' },
  { key: 'amenity', val: 'childcare', cat: 'Asili' },
  { key: 'amenity', val: 'cinema', cat: 'Cinema' },
  { key: 'amenity', val: 'community_centre', cat: 'Associazioni' },
  { key: 'amenity', val: 'conference_centre', cat: 'Sale Conferenze' },
  { key: 'amenity', val: 'courier', cat: 'Corrieri' },
  { key: 'amenity', val: 'crematorium', cat: 'Onoranze Funebri' },
  { key: 'amenity', val: 'dive_centre', cat: 'Sub e Diving' },
  { key: 'amenity', val: 'events_venue', cat: 'Sale Conferenze' },
  { key: 'amenity', val: 'exhibition_centre', cat: 'Fiere' },
  { key: 'amenity', val: 'ferry_terminal', cat: 'Trasporti' },
  { key: 'amenity', val: 'flight_school', cat: 'Scuole di Volo' },
  { key: 'amenity', val: 'food_court', cat: 'Ristoranti' },
  { key: 'amenity', val: 'freelancer', cat: 'Consulenti' },
  { key: 'amenity', val: 'game_feeding', cat: 'Outdoor e Camping' },
  { key: 'amenity', val: 'internet_cafe', cat: 'Internet Café' },
  { key: 'amenity', val: 'karaoke_box', cat: 'Karaoke' },
  { key: 'amenity', val: 'lounge', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'mortuary', cat: 'Onoranze Funebri' },
  { key: 'amenity', val: 'motorcycle_parking', cat: 'Parcheggi' },
  { key: 'amenity', val: 'nursing_home', cat: 'Case di Cura' },
  { key: 'amenity', val: 'parcel_locker', cat: 'Corrieri' },
  { key: 'amenity', val: 'photo_booth', cat: 'Fotografia' },
  { key: 'amenity', val: 'planetarium', cat: 'Musei' },
  { key: 'amenity', val: 'playground', cat: 'Parchi Giochi' },
  { key: 'amenity', val: 'police', cat: 'Uffici Pubblici' },
  { key: 'amenity', val: 'prep_school', cat: 'Scuole' },
  { key: 'amenity', val: 'prison', cat: 'Uffici Pubblici' },
  { key: 'amenity', val: 'public_building', cat: 'Uffici Pubblici' },
  { key: 'amenity', val: 'research_institute', cat: 'Centri di Ricerca' },
  { key: 'amenity', val: 'retirement_home', cat: 'Case di Cura' },
  { key: 'amenity', val: 'science_museum', cat: 'Musei' },
  { key: 'amenity', val: 'social_centre', cat: 'Associazioni' },
  { key: 'amenity', val: 'social_facility', cat: 'Servizi Sociali' },
  { key: 'amenity', val: 'studio', cat: 'Studi' },
  { key: 'amenity', val: 'theatre', cat: 'Teatri' },
  { key: 'amenity', val: 'townhall', cat: 'Uffici Pubblici' },
  { key: 'amenity', val: 'training', cat: 'Istituti Formativi' },
  { key: 'amenity', val: 'waste_disposal', cat: 'Rifiuti' },
  { key: 'amenity', val: 'water_point', cat: 'Acqua' },
];

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const body = `data=${encodeURIComponent(query)}`;
    const opts = {
      hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': Buffer.byteLength(body), 'User-Agent': 'ItalianBizDir/R2' }
    };
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

// Mappa province -> region
const PROV_REGION = {};
ZONES.forEach(z => { PROV_REGION[z.province] = z.region; });

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
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '').substring(0, 50) || null,
    email: (tags.email || tags['contact:email'] || '').substring(0, 200) || null,
    website: (tags.website || tags['contact:website'] || '').substring(0, 500) || null,
    business_hours: tags.opening_hours || null,
    is_claimed: false,
    approval_status: 'approved',
  };
}

async function runTagZone(tq, zone) {
  const catId = categoryCache[tq.cat];
  if (!catId) return 0;
  let elements = [];
  for (let retry = 0; retry < 3; retry++) {
    try {
      const data = await fetchOverpass(buildQuery(tq, zone));
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(90000); retry--; continue; }
      if (retry < 2) { await sleep((retry + 1) * 10000); continue; }
      return 0;
    }
  }
  const records = [];
  const seen = new Set();
  for (const el of elements) {
    const r = makeRecord(el, zone, catId);
    if (!r) continue;
    const key = `${r.name}|${r.province}|${r.latitude?.toFixed(4)}|${r.longitude?.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    records.push(r);
  }
  if (!records.length) return 0;
  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const batch = records.slice(i, i + 200);
    const { error } = await supabase.from('unclaimed_business_locations').insert(batch);
    if (!error) { inserted += batch.length; }
    else if (error.code === '23505') {
      for (const rec of batch) { const { error: e2 } = await supabase.from('unclaimed_business_locations').insert(rec); if (!e2) inserted++; }
    }
  }
  totalImported += inserted;
  return inserted;
}

async function main() {
  console.log(`\n=== ROUND 2 - TAG AVANZATI ===`);
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
  console.log(`\n=== R2 COMPLETATO === sessione: ${totalImported.toLocaleString()} | DB: ${count?.toLocaleString()}`);
}
main().catch(console.error);
