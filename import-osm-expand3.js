/**
 * Importazione OSM - Round 3
 * Espande province sottorappresentate e aggiunge nuovi tag OSM
 * Stessa logica di import-osm-fast.js
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

// Province sottorappresentate + città mancanti
const CITIES = [
  // Province con < 500 record - bbox province complete (più larghi)
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.42, 15.86, 38.88, 16.34] },
  { name: 'Sondrio', region: 'Lombardia', province: 'SO', bbox: [45.98, 9.52, 46.62, 10.54] },
  { name: 'Lecco', region: 'Lombardia', province: 'LC', bbox: [45.66, 9.18, 46.10, 9.62] },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [37.18, 13.72, 37.72, 14.36] },
  { name: 'Viterbo', region: 'Lazio', province: 'VT', bbox: [42.12, 11.66, 42.68, 12.44] },
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.40, 13.44, 42.90, 14.02] },
  { name: 'Isernia', region: 'Molise', province: 'IS', bbox: [41.40, 13.98, 41.82, 14.42] },
  { name: 'Grosseto', region: 'Toscana', province: 'GR', bbox: [42.38, 10.88, 43.06, 11.82] },
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.58, 16.32, 39.12, 17.00] },
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [37.86, 15.46, 38.42, 16.12] },
  { name: 'Benevento', region: 'Campania', province: 'BN', bbox: [40.86, 14.56, 41.36, 15.20] },
  { name: 'Macerata', region: 'Marche', province: 'MC', bbox: [42.88, 13.04, 43.42, 13.82] },
  { name: 'Foggia', region: 'Puglia', province: 'FG', bbox: [41.02, 15.12, 41.94, 16.12] },
  { name: 'Cremona', region: 'Lombardia', province: 'CR', bbox: [44.86, 9.72, 45.38, 10.46] },
  { name: 'Sassari', region: 'Sardegna', province: 'SS', bbox: [40.44, 8.22, 41.20, 9.08] },
  { name: 'Agrigento', region: 'Sicilia', province: 'AG', bbox: [37.02, 13.08, 37.58, 13.92] },
  { name: 'Pesaro', region: 'Marche', province: 'PU', bbox: [43.52, 12.50, 44.06, 13.24] },
  { name: 'Terni', region: 'Umbria', province: 'TR', bbox: [42.28, 12.36, 42.82, 13.00] },
  { name: 'Arezzo', region: 'Toscana', province: 'AR', bbox: [43.12, 11.56, 43.72, 12.24] },
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.14, 15.42, 40.92, 16.14] },
  { name: 'Salerno', region: 'Campania', province: 'SA', bbox: [40.06, 14.68, 40.84, 15.62] },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.02, 15.84, 39.62, 16.62] },
  { name: 'Latina', region: 'Lazio', province: 'LT', bbox: [41.12, 12.62, 41.68, 13.34] },
  { name: 'Caserta', region: 'Campania', province: 'CE', bbox: [40.86, 13.86, 41.32, 14.60] },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.70, 14.42, 37.08, 15.02] },
  { name: 'Mantova', region: 'Lombardia', province: 'MN', bbox: [44.92, 10.52, 45.32, 11.22] },
  { name: "L'Aquila", region: 'Abruzzo', province: 'AQ', bbox: [41.82, 13.08, 42.58, 14.08] },
  { name: 'Pistoia', region: 'Toscana', province: 'PT', bbox: [43.72, 10.68, 44.12, 11.14] },
  { name: 'Lodi', region: 'Lombardia', province: 'LO', bbox: [45.10, 9.30, 45.42, 9.82] },
  { name: 'Campobasso', region: 'Molise', province: 'CB', bbox: [41.30, 14.40, 41.82, 14.96] },
  { name: 'Ravenna', region: 'Emilia-Romagna', province: 'RA', bbox: [44.14, 11.82, 44.60, 12.48] },
  { name: 'Crotone', region: 'Calabria', province: 'KR', bbox: [38.78, 16.78, 39.24, 17.36] },
  { name: 'Trapani', region: 'Sicilia', province: 'TP', bbox: [37.68, 12.22, 38.18, 13.04] },
  { name: 'Treviso', region: 'Veneto', province: 'TV', bbox: [45.54, 11.88, 46.00, 12.54] },
  { name: 'Prato', region: 'Toscana', province: 'PO', bbox: [43.78, 10.84, 44.06, 11.26] },
  // BAT (Barletta-Andria-Trani) - mancante
  { name: 'Barletta', region: 'Puglia', province: 'BT', bbox: [41.10, 15.98, 41.46, 16.40] },
  { name: 'Como', region: 'Lombardia', province: 'CO', bbox: [45.62, 8.86, 46.04, 9.40] },
  { name: 'Piacenza', region: 'Emilia-Romagna', province: 'PC', bbox: [44.68, 9.30, 45.20, 10.02] },
  { name: 'Pavia', region: 'Lombardia', province: 'PV', bbox: [44.92, 8.76, 45.34, 9.48] },
  { name: 'Matera', region: 'Basilicata', province: 'MT', bbox: [40.24, 16.12, 40.82, 16.92] },
  { name: 'Taranto', region: 'Puglia', province: 'TA', bbox: [40.22, 17.04, 40.68, 17.54] },
  { name: 'Siena', region: 'Toscana', province: 'SI', bbox: [42.94, 10.98, 43.56, 11.96] },
  { name: 'Vercelli', region: 'Piemonte', province: 'VC', bbox: [45.08, 8.12, 45.58, 8.72] },
  { name: 'La Spezia', region: 'Liguria', province: 'SP', bbox: [43.84, 9.62, 44.28, 10.08] },
  { name: 'Messina', region: 'Sicilia', province: 'ME', bbox: [37.82, 14.78, 38.38, 15.66] },
  { name: 'Forlì-Cesena', region: 'Emilia-Romagna', province: 'FC', bbox: [43.88, 11.72, 44.42, 12.40] },
  { name: 'Savona', region: 'Liguria', province: 'SV', bbox: [44.06, 8.08, 44.48, 8.82] },
  { name: 'Alessandria', region: 'Piemonte', province: 'AL', bbox: [44.54, 8.22, 45.14, 9.02] },
  { name: 'Asti', region: 'Piemonte', province: 'AT', bbox: [44.60, 7.88, 45.08, 8.54] },
  { name: 'Novara', region: 'Piemonte', province: 'NO', bbox: [45.28, 8.36, 45.70, 8.88] },
  // Città medie non coperte
  { name: 'Andria', region: 'Puglia', province: 'BT', bbox: [41.18, 16.14, 41.34, 16.32] },
  { name: 'Trani', region: 'Puglia', province: 'BT', bbox: [41.24, 16.38, 41.40, 16.52] },
  { name: 'Cerignola', region: 'Puglia', province: 'FG', bbox: [41.22, 15.84, 41.42, 16.08] },
  { name: 'Gioia del Colle', region: 'Puglia', province: 'BA', bbox: [40.74, 16.88, 40.94, 17.08] },
  { name: 'Altamura', region: 'Puglia', province: 'BA', bbox: [40.78, 16.46, 40.94, 16.70] },
  { name: 'Battipaglia', region: 'Campania', province: 'SA', bbox: [40.54, 14.94, 40.68, 15.12] },
  { name: 'Nocera Inferiore', region: 'Campania', province: 'SA', bbox: [40.66, 14.58, 40.78, 14.78] },
  { name: 'Scafati', region: 'Campania', province: 'SA', bbox: [40.70, 14.66, 40.82, 14.84] },
  { name: 'Aversa', region: 'Campania', province: 'CE', bbox: [40.94, 14.14, 41.06, 14.30] },
  { name: 'Acerra', region: 'Campania', province: 'NA', bbox: [40.88, 14.30, 41.00, 14.46] },
  { name: 'Afragola', region: 'Campania', province: 'NA', bbox: [40.88, 14.26, 41.02, 14.42] },
  { name: 'Ercolano', region: 'Campania', province: 'NA', bbox: [40.74, 14.32, 40.86, 14.48] },
  { name: 'Torre del Greco', region: 'Campania', province: 'NA', bbox: [40.74, 14.34, 40.90, 14.52] },
  { name: 'Castellammare di Stabia', region: 'Campania', province: 'NA', bbox: [40.64, 14.44, 40.80, 14.60] },
  { name: 'Giugliano in Campania', region: 'Campania', province: 'NA', bbox: [40.90, 14.00, 41.06, 14.20] },
  { name: 'Pozzuoli', region: 'Campania', province: 'NA', bbox: [40.78, 14.06, 40.94, 14.22] },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'RE', bbox: [44.48, 10.44, 44.92, 11.02] },
  { name: 'Carpi', region: 'Emilia-Romagna', province: 'MO', bbox: [44.74, 10.82, 44.94, 11.02] },
  { name: 'Imola', region: 'Emilia-Romagna', province: 'BO', bbox: [44.28, 11.60, 44.48, 11.80] },
  { name: 'Faenza', region: 'Emilia-Romagna', province: 'RA', bbox: [44.20, 11.78, 44.40, 12.00] },
  { name: 'Rimini', region: 'Emilia-Romagna', province: 'RN', bbox: [43.88, 12.34, 44.10, 12.62] },
  { name: 'Cesena', region: 'Emilia-Romagna', province: 'FC', bbox: [43.98, 12.12, 44.20, 12.44] },
  { name: 'Trento', region: 'Trentino-Alto Adige', province: 'TN', bbox: [45.84, 10.82, 46.24, 11.36] },
  { name: 'Bolzano', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.28, 11.10, 46.78, 11.64] },
  { name: 'Rovereto', region: 'Trentino-Alto Adige', province: 'TN', bbox: [45.82, 10.92, 46.02, 11.12] },
  { name: 'Merano', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.62, 11.06, 46.78, 11.22] },
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.80, 12.44, 46.08, 12.84] },
  { name: 'Udine', region: 'Friuli-Venezia Giulia', province: 'UD', bbox: [45.84, 12.88, 46.24, 13.56] },
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.76, 13.44, 46.04, 13.82] },
  { name: 'Vicenza', region: 'Veneto', province: 'VI', bbox: [45.38, 11.24, 45.78, 11.82] },
  { name: 'Rovigo', region: 'Veneto', province: 'RO', bbox: [44.78, 11.46, 45.14, 12.04] },
  { name: 'Belluno', region: 'Veneto', province: 'BL', bbox: [45.88, 11.72, 46.60, 12.58] },
  { name: 'Mestre', region: 'Veneto', province: 'VE', bbox: [45.40, 12.12, 45.58, 12.38] },
  { name: 'Treviso', region: 'Veneto', province: 'TV', bbox: [45.62, 12.14, 45.84, 12.48] },
  { name: 'Imperia', region: 'Liguria', province: 'IM', bbox: [43.70, 7.68, 44.14, 8.34] },
  { name: 'Sanremo', region: 'Liguria', province: 'IM', bbox: [43.78, 7.72, 43.94, 7.90] },
  // Sardegna
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', bbox: [39.96, 8.96, 40.58, 9.76] },
  { name: 'Oristano', region: 'Sardegna', province: 'OR', bbox: [39.62, 8.34, 40.14, 8.96] },
  { name: 'Olbia', region: 'Sardegna', province: 'OT', bbox: [40.62, 9.12, 41.18, 9.82] },
  { name: 'Carbonia', region: 'Sardegna', province: 'CI', bbox: [39.02, 8.44, 39.28, 8.76] },
  { name: 'Iglesias', region: 'Sardegna', province: 'CI', bbox: [39.22, 8.46, 39.42, 8.68] },
  { name: 'Nuoro Città', region: 'Sardegna', province: 'NU', bbox: [40.28, 9.26, 40.48, 9.48] },
  // Abruzzo piccoli centri
  { name: 'Pescara', region: 'Abruzzo', province: 'PE', bbox: [42.28, 13.96, 42.58, 14.44] },
  { name: 'Chieti', region: 'Abruzzo', province: 'CH', bbox: [42.10, 13.92, 42.52, 14.44] },
  // Sicilia centri minori
  { name: 'Acireale', region: 'Sicilia', province: 'CT', bbox: [37.56, 15.10, 37.72, 15.24] },
  { name: 'Marsala', region: 'Sicilia', province: 'TP', bbox: [37.76, 12.40, 37.92, 12.58] },
  { name: 'Mazara del Vallo', region: 'Sicilia', province: 'TP', bbox: [37.62, 12.52, 37.76, 12.68] },
  { name: 'Vittoria', region: 'Sicilia', province: 'RG', bbox: [36.92, 14.50, 37.06, 14.66] },
  { name: 'Gela', region: 'Sicilia', province: 'CL', bbox: [37.02, 14.18, 37.18, 14.34] },
  { name: 'Milazzo', region: 'Sicilia', province: 'ME', bbox: [38.18, 15.20, 38.30, 15.36] },
  // Centro Italia
  { name: 'Perugia', region: 'Umbria', province: 'PG', bbox: [42.88, 12.18, 43.26, 12.60] },
  { name: 'Terni', region: 'Umbria', province: 'TR', bbox: [42.44, 12.56, 42.68, 12.76] },
  { name: 'Ancona', region: 'Marche', province: 'AN', bbox: [43.48, 13.22, 43.72, 13.64] },
  { name: 'Fermo', region: 'Marche', province: 'FM', bbox: [42.96, 13.54, 43.22, 13.82] },
  { name: 'Ascoli Piceno', region: 'Marche', province: 'AP', bbox: [42.76, 13.44, 43.00, 13.82] },
];

// Tag OSM aggiuntivi - categorie DB non ancora coperte o poco coperte
const TAG_QUERIES = [
  // ─── Ristorazione ───
  { key: 'amenity', val: 'restaurant', cat: 'Ristoranti' },
  { key: 'amenity', val: 'cafe', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'bar', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'fast_food', cat: 'Fast Food' },
  { key: 'amenity', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'shop', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'shop', val: 'pastry', cat: 'Pasticcerie' },
  { key: 'shop', val: 'confectionery', cat: 'Pasticcerie' },
  { key: 'shop', val: 'chocolate', cat: 'Cioccolaterie' },
  { key: 'shop', val: 'pizza', cat: 'Pizzerie' },
  { key: 'amenity', val: 'food_court', cat: 'Food Court' },
  // ─── Alimentari ───
  { key: 'shop', val: 'supermarket', cat: 'Supermercati' },
  { key: 'shop', val: 'convenience', cat: 'Alimentari' },
  { key: 'shop', val: 'greengrocer', cat: 'Frutta e Verdura' },
  { key: 'shop', val: 'butcher', cat: 'Macellerie' },
  { key: 'shop', val: 'seafood', cat: 'Pescherie' },
  { key: 'shop', val: 'deli', cat: 'Gastronomie' },
  { key: 'shop', val: 'cheese', cat: 'Formaggerie' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  { key: 'shop', val: 'coffee', cat: 'Torrefazioni' },
  // ─── Salute ───
  { key: 'amenity', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'amenity', val: 'clinic', cat: 'Cliniche' },
  { key: 'amenity', val: 'hospital', cat: 'Ospedali' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'amenity', val: 'physiotherapist', cat: 'Fisioterapisti' },
  { key: 'amenity', val: 'optician', cat: 'Ottici' },
  { key: 'healthcare', val: 'laboratory', cat: 'Laboratori Analisi' },
  { key: 'healthcare', val: 'physiotherapist', cat: 'Fisioterapisti' },
  { key: 'healthcare', val: 'psychologist', cat: 'Psicologi' },
  { key: 'healthcare', val: 'alternative', cat: 'Medicine Alternative' },
  { key: 'healthcare', val: 'podiatrist', cat: 'Podologi' },
  { key: 'healthcare', val: 'speech_therapist', cat: 'Logopedisti' },
  { key: 'healthcare', val: 'audiologist', cat: 'Apparecchi Acustici' },
  // ─── Bellezza ───
  { key: 'shop', val: 'hairdresser', cat: 'Parrucchieri' },
  { key: 'shop', val: 'beauty', cat: 'Centri Estetici' },
  { key: 'shop', val: 'cosmetics', cat: 'Profumerie' },
  { key: 'shop', val: 'perfumery', cat: 'Profumerie' },
  { key: 'shop', val: 'tattoo', cat: 'Tatuatori' },
  // ─── Sport / Fitness ───
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'leisure', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'leisure', val: 'sports_centre', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'dance', cat: 'Scuole di Danza' },
  { key: 'sport', val: 'swimming', cat: 'Piscine' },
  // ─── Alloggi ───
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'motel', cat: 'Motel' },
  { key: 'tourism', val: 'hostel', cat: 'Ostelli' },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'tourism', val: 'camp_site', cat: 'Campeggi' },
  { key: 'tourism', val: 'caravan_site', cat: 'Aree Camper' },
  { key: 'tourism', val: 'chalet', cat: 'Chalet' },
  // ─── Automotive ───
  { key: 'shop', val: 'car', cat: 'Concessionarie Auto' },
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'amenity', val: 'car_wash', cat: 'Autolavaggi' },
  { key: 'amenity', val: 'car_rental', cat: 'Autonoleggi' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'shop', val: 'car_parts', cat: 'Ricambi Auto' },
  { key: 'amenity', val: 'fuel', cat: 'Distributori di Carburante' },
  { key: 'amenity', val: 'charging_station', cat: 'Colonnine Ricarica' },
  { key: 'amenity', val: 'parking', cat: 'Parcheggi' },
  // ─── Servizi professionali ───
  { key: 'office', val: 'lawyer', cat: 'Avvocati' },
  { key: 'office', val: 'notary', cat: 'Notai' },
  { key: 'office', val: 'accountant', cat: 'Commercialisti' },
  { key: 'office', val: 'financial', cat: 'Consulenti Finanziari' },
  { key: 'office', val: 'insurance', cat: 'Assicurazioni' },
  { key: 'office', val: 'architect', cat: 'Architetti' },
  { key: 'office', val: 'engineer', cat: 'Ingegneri' },
  { key: 'office', val: 'surveyor', cat: 'Geometri' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'office', val: 'travel_agent', cat: 'Agenzie di Viaggio' },
  { key: 'office', val: 'it', cat: 'Informatica' },
  { key: 'office', val: 'company', cat: 'Aziende' },
  // ─── Banche / Finanza ───
  { key: 'amenity', val: 'bank', cat: 'Banche' },
  { key: 'amenity', val: 'atm', cat: 'Bancomat' },
  // ─── Istruzione ───
  { key: 'amenity', val: 'school', cat: 'Scuole' },
  { key: 'amenity', val: 'kindergarten', cat: 'Asili' },
  { key: 'amenity', val: 'language_school', cat: 'Scuole di Lingue' },
  { key: 'amenity', val: 'music_school', cat: 'Scuole di Musica' },
  // ─── Negozi vari ───
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'boutique', cat: 'Boutique' },
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'optician', cat: 'Ottici' },
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'computer', cat: 'Negozi di Computer' },
  { key: 'shop', val: 'mobile_phone', cat: 'Negozi di Telefonia' },
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'kitchen', cat: 'Cucine' },
  { key: 'shop', val: 'bathroom_furnishing', cat: 'Arredo Bagno' },
  { key: 'shop', val: 'flooring', cat: 'Pavimenti' },
  { key: 'shop', val: 'tiles', cat: 'Piastrelle' },
  { key: 'shop', val: 'paint', cat: 'Colorifici' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'doityourself', cat: 'Fai da Te' },
  { key: 'shop', val: 'books', cat: 'Librerie' },
  { key: 'shop', val: 'stationery', cat: 'Cartolerie' },
  { key: 'shop', val: 'toys', cat: 'Giocattoli' },
  { key: 'shop', val: 'gift', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'florist', cat: 'Fioristi' },
  { key: 'shop', val: 'pet', cat: 'Negozi per Animali' },
  { key: 'shop', val: 'veterinary', cat: 'Veterinari' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  { key: 'shop', val: 'antiques', cat: 'Antiquari' },
  { key: 'shop', val: 'second_hand', cat: 'Usato' },
  { key: 'shop', val: 'bicycle', cat: 'Biciclette' },
  { key: 'shop', val: 'laundry', cat: 'Lavanderie' },
  { key: 'amenity', val: 'laundry', cat: 'Lavanderie' },
  { key: 'shop', val: 'dry_cleaning', cat: 'Lavanderie' },
  { key: 'shop', val: 'leather', cat: 'Articoli in Pelle' },
  { key: 'shop', val: 'bag', cat: 'Pelletterie' },
  { key: 'shop', val: 'carpet', cat: 'Tappeti' },
  { key: 'shop', val: 'fabric', cat: 'Tessuti' },
  { key: 'shop', val: 'medical_supply', cat: 'Sanitaria' },
  { key: 'shop', val: 'art', cat: 'Gallerie d\'Arte' },
  { key: 'shop', val: 'copyshop', cat: 'Tipografie' },
  { key: 'shop', val: 'baby_goods', cat: 'Articoli per Bambini' },
  // ─── Poste ───
  { key: 'amenity', val: 'post_office', cat: 'Uffici Postali' },
  // ─── Lotterie / Ricevitorie ───
  { key: 'shop', val: 'lottery', cat: 'Ricevitorie' },
  // ─── Vending ───
  { key: 'amenity', val: 'vending_machine', cat: 'Distributori Automatici' },
  // ─── Biblioteche ───
  { key: 'amenity', val: 'library', cat: 'Biblioteche' },
  // ─── Discoteche / Intrattenimento ───
  { key: 'amenity', val: 'nightclub', cat: 'Discoteche' },
  { key: 'amenity', val: 'cinema', cat: 'Scuole' },
  // ─── Artigiani ancora mancanti ───
  { key: 'craft', val: 'ceramics', cat: 'Ceramisti' },
  { key: 'craft', val: 'basket_maker', cat: 'Cestai' },
  { key: 'craft', val: 'sail_maker', cat: 'Velai' },
  { key: 'craft', val: 'plasterer', cat: 'Stuccatori' },
  { key: 'craft', val: 'roofer', cat: 'Costruttori' },
  { key: 'craft', val: 'printer', cat: 'Tipografie' },
  { key: 'craft', val: 'upholsterer', cat: 'Tappezzieri' },
  { key: 'craft', val: 'farrier', cat: 'Maniscalchi' },
  { key: 'craft', val: 'bookbinder', cat: 'Rilegatori' },
  { key: 'craft', val: 'sign_maker', cat: 'Insegne' },
  { key: 'craft', val: 'tinsmith', cat: 'Lattonieri' },
  { key: 'craft', val: 'sailmaker', cat: 'Velai' },
  // ─── Scuole guida ───
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  // ─── Logistica ───
  { key: 'office', val: 'logistics', cat: 'Logistica' },
  // ─── Mercatini solidali ───
  { key: 'shop', val: 'charity', cat: 'Mercatini Solidali' },
];

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie`);
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const body = `data=${encodeURIComponent(query)}`;
    const opts = {
      hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(body),
        'User-Agent': 'ItalianBizDir/6.0'
      }
    };
    const req = https.request(opts, res => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => {
        if (res.statusCode === 429) { reject(new Error('RATE_LIMIT')); return; }
        if (res.statusCode >= 400) { reject(new Error(`HTTP ${res.statusCode}`)); return; }
        try { resolve(JSON.parse(data)); } catch { reject(new Error('JSON_PARSE')); }
      });
    });
    req.on('error', reject);
    req.setTimeout(90000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(body); req.end();
  });
}

function buildQuery(tagQuery, city) {
  const [s, w, n, e] = city.bbox;
  const bbox = `${s},${w},${n},${e}`;
  let filter = '';
  if (tagQuery.filter) filter = `[${tagQuery.filter}]`;
  return `[out:json][timeout:60];\n(\n  node["${tagQuery.key}"="${tagQuery.val}"]${filter}(${bbox});\n  way["${tagQuery.key}"="${tagQuery.val}"]${filter}(${bbox});\n);\nout center tags;`;
}

function makeRecord(el, city, catId) {
  const tags = el.tags || {};
  if (!tags.name) return null;
  const lat = el.lat ?? el.center?.lat;
  const lon = el.lon ?? el.center?.lon;
  if (!lat || !lon) return null;
  const osmId = `${el.type}/${el.id}`;
  const street = tags['addr:street'] || '';
  const hnum = tags['addr:housenumber'] || '';
  return {
    name: tags.name.substring(0, 200),
    category_id: catId,
    street: street ? (hnum ? `${street}, ${hnum}` : street) : null,
    city: (tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || city.name).substring(0, 100),
    province: city.province,
    region: city.region,
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
    osm_id: osmId,
  };
}

async function runTagQuery(tagQuery, city) {
  const catId = categoryCache[tagQuery.cat];
  if (!catId) return 0;

  const query = buildQuery(tagQuery, city);
  let elements = [];
  for (let retry = 0; retry < 3; retry++) {
    try {
      const data = await fetchOverpass(query);
      elements = data.elements || [];
      break;
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { await sleep(60000); retry--; continue; }
      if (retry < 2) { await sleep((retry + 1) * 8000); continue; }
      return 0;
    }
  }

  const records = [];
  const seen = new Set();
  for (const el of elements) {
    const r = makeRecord(el, city, catId);
    if (!r) continue;
    // Deduplica locale per posizione
    const key = `${r.name}|${r.city}|${(r.latitude)?.toFixed(4)}|${(r.longitude)?.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    records.push(r);
  }
  if (!records.length) return 0;

  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const batch = records.slice(i, i + 200);
    // Usa upsert su osm_id per evitare duplicati con importazioni precedenti
    const { error, data } = await supabase
      .from('unclaimed_business_locations')
      .upsert(batch, { onConflict: 'osm_id', ignoreDuplicates: true })
      .select('id');
    if (!error) inserted += (data?.length || 0);
  }
  totalImported += inserted;
  return inserted;
}

async function main() {
  console.log(`\n=== IMPORTAZIONE OSM - ROUND 3 ===`);
  console.log(`${TAG_QUERIES.length} tag OSM x ${CITIES.length} citta'/province\n`);
  await loadCategories();

  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    const tagTotal = { count: 0 };
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val} -> ${tq.cat}: `);

    for (const city of CITIES) {
      const n = await runTagQuery(tq, city);
      if (n > 0) { process.stdout.write(`${city.name}(+${n}) `); tagTotal.count += n; }
      await sleep(2000);
    }

    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   Totale tag: +${tagTotal.count} | Sessione: ${totalImported.toLocaleString()} (${mins}min)`);
    await sleep(3000);
  }

  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== COMPLETATO === Sessione: +${totalImported.toLocaleString()} | Totale DB: ${count?.toLocaleString()}`);
}

main().catch(console.error);
