import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// 🇮🇹 CITTÀ ITALIANE CON PIÙ DI 20,000 ABITANTI
// Bounding box ridotti (~0.08 gradi = ~9km di raggio) per query più veloci
const ITALIAN_CITIES = [
  // Grandi città (>100k abitanti)
  { name: 'Roma', region: 'Lazio', province: 'RM', bbox: [41.80, 12.40, 41.96, 12.56], population: 2800000 },
  { name: 'Milano', region: 'Lombardia', province: 'MI', bbox: [45.40, 9.10, 45.52, 9.26], population: 1400000 },
  { name: 'Napoli', region: 'Campania', province: 'NA', bbox: [40.80, 14.20, 40.88, 14.30], population: 950000 },
  { name: 'Torino', region: 'Piemonte', province: 'TO', bbox: [45.00, 7.62, 45.12, 7.74], population: 870000 },
  { name: 'Palermo', region: 'Sicilia', province: 'PA', bbox: [38.08, 13.32, 38.16, 13.40], population: 650000 },
  { name: 'Genova', region: 'Liguria', province: 'GE', bbox: [44.38, 8.88, 44.46, 8.98], population: 580000 },
  { name: 'Bologna', region: 'Emilia-Romagna', province: 'BO', bbox: [44.46, 11.30, 44.54, 11.38], population: 390000 },
  { name: 'Firenze', region: 'Toscana', province: 'FI', bbox: [43.74, 11.22, 43.82, 11.30], population: 380000 },
  { name: 'Bari', region: 'Puglia', province: 'BA', bbox: [41.08, 16.84, 41.16, 16.92], population: 320000 },
  { name: 'Catania', region: 'Sicilia', province: 'CT', bbox: [37.48, 15.06, 37.56, 15.14], population: 310000 },
  { name: 'Verona', region: 'Veneto', province: 'VR', bbox: [45.40, 10.96, 45.48, 11.04], population: 260000 },
  { name: 'Venezia', region: 'Veneto', province: 'VE', bbox: [45.40, 12.30, 45.48, 12.38], population: 260000 },
  { name: 'Messina', region: 'Sicilia', province: 'ME', bbox: [38.16, 15.52, 38.24, 15.60], population: 230000 },
  { name: 'Padova', region: 'Veneto', province: 'PD', bbox: [45.38, 11.84, 45.46, 11.92], population: 210000 },
  { name: 'Trieste', region: 'Friuli-Venezia Giulia', province: 'TS', bbox: [45.62, 13.74, 45.70, 13.82], population: 200000 },
  { name: 'Brescia', region: 'Lombardia', province: 'BS', bbox: [45.52, 10.20, 45.60, 10.28], population: 196000 },
  { name: 'Taranto', region: 'Puglia', province: 'TA', bbox: [40.44, 17.22, 40.52, 17.30], population: 195000 },
  { name: 'Prato', region: 'Toscana', province: 'PO', bbox: [43.86, 11.06, 43.94, 11.14], population: 195000 },
  { name: 'Parma', region: 'Emilia-Romagna', province: 'PR', bbox: [44.76, 10.30, 44.84, 10.38], population: 195000 },
  { name: 'Modena', region: 'Emilia-Romagna', province: 'MO', bbox: [44.62, 10.90, 44.70, 10.98], population: 185000 },
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [38.08, 15.62, 38.16, 15.70], population: 180000 },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'RE', bbox: [44.66, 10.60, 44.74, 10.68], population: 172000 },
  { name: 'Perugia', region: 'Umbria', province: 'PG', bbox: [43.08, 12.36, 43.16, 12.44], population: 165000 },
  { name: 'Ravenna', region: 'Emilia-Romagna', province: 'RA', bbox: [44.38, 12.18, 44.46, 12.26], population: 160000 },
  { name: 'Livorno', region: 'Toscana', province: 'LI', bbox: [43.52, 10.30, 43.60, 10.38], population: 158000 },
  { name: 'Cagliari', region: 'Sardegna', province: 'CA', bbox: [39.20, 9.08, 39.28, 9.16], population: 155000 },
  { name: 'Foggia', region: 'Puglia', province: 'FG', bbox: [41.44, 15.54, 41.52, 15.62], population: 150000 },
  { name: 'Rimini', region: 'Emilia-Romagna', province: 'RN', bbox: [44.04, 12.54, 44.12, 12.62], population: 150000 },
  { name: 'Salerno', region: 'Campania', province: 'SA', bbox: [40.66, 14.74, 40.74, 14.82], population: 132000 },
  { name: 'Ferrara', region: 'Emilia-Romagna', province: 'FE', bbox: [44.82, 11.60, 44.90, 11.68], population: 132000 },
  { name: 'Sassari', region: 'Sardegna', province: 'SS', bbox: [40.72, 8.54, 40.80, 8.62], population: 125000 },
  { name: 'Latina', region: 'Lazio', province: 'LT', bbox: [41.44, 12.88, 41.52, 12.96], population: 125000 },
  { name: 'Giugliano in Campania', region: 'Campania', province: 'NA', bbox: [40.92, 14.18, 41.00, 14.26], population: 124000 },
  { name: 'Monza', region: 'Lombardia', province: 'MB', bbox: [45.58, 9.26, 45.66, 9.34], population: 124000 },
  { name: 'Siracusa', region: 'Sicilia', province: 'SR', bbox: [37.06, 15.28, 37.14, 15.36], population: 121000 },
  { name: 'Pescara', region: 'Abruzzo', province: 'PE', bbox: [42.44, 14.20, 42.52, 14.28], population: 120000 },
  { name: 'Bergamo', region: 'Lombardia', province: 'BG', bbox: [45.68, 9.66, 45.76, 9.74], population: 120000 },
  { name: 'Forlì', region: 'Emilia-Romagna', province: 'FC', bbox: [44.20, 12.02, 44.28, 12.10], population: 118000 },
  { name: 'Trento', region: 'Trentino-Alto Adige', province: 'TN', bbox: [46.06, 11.12, 46.14, 11.20], population: 118000 },
  { name: 'Vicenza', region: 'Veneto', province: 'VI', bbox: [45.54, 11.52, 45.62, 11.60], population: 112000 },
  { name: 'Terni', region: 'Umbria', province: 'TR', bbox: [42.54, 12.62, 42.62, 12.70], population: 110000 },
  { name: 'Bolzano', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.48, 11.32, 46.56, 11.40], population: 107000 },
  { name: 'Novara', region: 'Piemonte', province: 'NO', bbox: [45.44, 8.60, 45.52, 8.68], population: 104000 },
  { name: 'Piacenza', region: 'Emilia-Romagna', province: 'PC', bbox: [45.04, 9.68, 45.12, 9.76], population: 103000 },
  { name: 'Ancona', region: 'Marche', province: 'AN', bbox: [43.58, 13.50, 43.66, 13.58], population: 100000 },
  { name: 'Andria', region: 'Puglia', province: 'BT', bbox: [41.22, 16.28, 41.30, 16.36], population: 100000 },
  { name: 'Arezzo', region: 'Toscana', province: 'AR', bbox: [43.46, 11.86, 43.54, 11.94], population: 100000 },
  { name: 'Udine', region: 'Friuli-Venezia Giulia', province: 'UD', bbox: [46.06, 13.22, 46.14, 13.30], population: 100000 },
  { name: 'Cesena', region: 'Emilia-Romagna', province: 'FC', bbox: [44.12, 12.24, 44.20, 12.32], population: 97000 },
  { name: 'Lecce', region: 'Puglia', province: 'LE', bbox: [40.34, 18.16, 40.42, 18.24], population: 95000 },
  { name: 'Pesaro', region: 'Marche', province: 'PU', bbox: [43.90, 12.90, 43.98, 12.98], population: 95000 },
  { name: 'Barletta', region: 'Puglia', province: 'BT', bbox: [41.30, 16.28, 41.38, 16.36], population: 94000 },
  { name: 'Alessandria', region: 'Piemonte', province: 'AL', bbox: [44.90, 8.60, 44.98, 8.68], population: 93000 },
  { name: 'La Spezia', region: 'Liguria', province: 'SP', bbox: [44.10, 9.80, 44.18, 9.88], population: 93000 },
  { name: 'Pisa', region: 'Toscana', province: 'PI', bbox: [43.70, 10.38, 43.78, 10.46], population: 90000 },
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.88, 16.58, 38.96, 16.66], population: 89000 },
  { name: 'Pistoia', region: 'Toscana', province: 'PT', bbox: [43.92, 10.90, 44.00, 10.98], population: 90000 },
  { name: 'Lucca', region: 'Toscana', province: 'LU', bbox: [43.82, 10.48, 43.90, 10.56], population: 89000 },
  { name: 'Brindisi', region: 'Puglia', province: 'BR', bbox: [40.62, 17.92, 40.70, 18.00], population: 88000 },
  { name: 'Torre del Greco', region: 'Campania', province: 'NA', bbox: [40.78, 14.36, 40.86, 14.44], population: 86000 },
  { name: 'Como', region: 'Lombardia', province: 'CO', bbox: [45.80, 9.08, 45.88, 9.16], population: 85000 },
  { name: 'Treviso', region: 'Veneto', province: 'TV', bbox: [45.66, 12.24, 45.74, 12.32], population: 84000 },
  { name: 'Busto Arsizio', region: 'Lombardia', province: 'VA', bbox: [45.60, 8.84, 45.68, 8.92], population: 83000 },
  { name: 'Marsala', region: 'Sicilia', province: 'TP', bbox: [37.78, 12.42, 37.86, 12.50], population: 82000 },
  { name: 'Varese', region: 'Lombardia', province: 'VA', bbox: [45.80, 8.80, 45.88, 8.88], population: 80000 },
  { name: 'Pozzuoli', region: 'Campania', province: 'NA', bbox: [40.82, 14.10, 40.90, 14.18], population: 80000 },
  { name: 'Casoria', region: 'Campania', province: 'NA', bbox: [40.90, 14.28, 40.98, 14.36], population: 78000 },
  { name: 'Asti', region: 'Piemonte', province: 'AT', bbox: [44.88, 8.18, 44.96, 8.26], population: 76000 },
  { name: 'Caserta', region: 'Campania', province: 'CE', bbox: [41.06, 14.32, 41.14, 14.40], population: 76000 },
  { name: 'Ragusa', region: 'Sicilia', province: 'RG', bbox: [36.92, 14.72, 37.00, 14.80], population: 73000 },
  { name: 'Gela', region: 'Sicilia', province: 'CL', bbox: [37.06, 14.24, 37.14, 14.32], population: 75000 },
  { name: 'Carrara', region: 'Toscana', province: 'MS', bbox: [44.04, 10.08, 44.12, 10.16], population: 63000 },
  { name: 'Pavia', region: 'Lombardia', province: 'PV', bbox: [45.18, 9.14, 45.26, 9.22], population: 73000 },
  { name: 'Lamezia Terme', region: 'Calabria', province: 'CZ', bbox: [38.96, 16.30, 39.04, 16.38], population: 70000 },
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.28, 16.24, 39.36, 16.32], population: 67000 },
  { name: 'Imola', region: 'Emilia-Romagna', province: 'BO', bbox: [44.34, 11.70, 44.42, 11.78], population: 70000 },
  { name: 'Viterbo', region: 'Lazio', province: 'VT', bbox: [42.42, 12.10, 42.50, 12.18], population: 67000 },
  { name: 'Trapani', region: 'Sicilia', province: 'TP', bbox: [38.00, 12.50, 38.08, 12.58], population: 68000 },
  { name: 'Legnano', region: 'Lombardia', province: 'MI', bbox: [45.58, 8.90, 45.66, 8.98], population: 60000 },
  { name: 'Benevento', region: 'Campania', province: 'BN', bbox: [41.12, 14.76, 41.20, 14.84], population: 60000 },
  { name: 'Acerra', region: 'Campania', province: 'NA', bbox: [40.94, 14.36, 41.02, 14.44], population: 60000 },
  { name: 'Cremona', region: 'Lombardia', province: 'CR', bbox: [45.12, 10.02, 45.20, 10.10], population: 72000 },
  { name: 'Matera', region: 'Basilicata', province: 'MT', bbox: [40.64, 16.58, 40.72, 16.66], population: 60000 },
  { name: 'Vercelli', region: 'Piemonte', province: 'VC', bbox: [45.32, 8.40, 45.40, 8.48], population: 46000 },
  { name: 'Mantova', region: 'Lombardia', province: 'MN', bbox: [45.14, 10.78, 45.22, 10.86], population: 49000 },
  { name: 'Grosseto', region: 'Toscana', province: 'GR', bbox: [42.76, 11.10, 42.84, 11.18], population: 82000 },
  { name: 'Savona', region: 'Liguria', province: 'SV', bbox: [44.30, 8.46, 44.38, 8.54], population: 60000 },
  { name: 'Cuneo', region: 'Piemonte', province: 'CN', bbox: [44.38, 7.54, 44.46, 7.62], population: 56000 },
  { name: 'Lodi', region: 'Lombardia', province: 'LO', bbox: [45.30, 9.50, 45.38, 9.58], population: 45000 },
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.63, 15.79, 40.71, 15.87], population: 67000 },
  { name: 'Crotone', region: 'Calabria', province: 'KR', bbox: [39.07, 17.11, 39.15, 17.19], population: 65000 },
  { name: 'Aversa', region: 'Campania', province: 'CE', bbox: [40.96, 14.20, 41.04, 14.28], population: 52000 },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [37.48, 14.04, 37.56, 14.12], population: 61000 },
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.66, 16.08, 38.74, 16.16], population: 33000 },
  { name: 'Agrigento', region: 'Sicilia', province: 'AG', bbox: [37.30, 13.57, 37.38, 13.65], population: 59000 },
  { name: 'Siena', region: 'Toscana', province: 'SI', bbox: [43.31, 11.33, 43.39, 11.41], population: 54000 },
  { name: 'Fiumicino', region: 'Lazio', province: 'RM', bbox: [41.76, 12.22, 41.84, 12.30], population: 80000 },
  { name: 'Guidonia Montecelio', region: 'Lazio', province: 'RM', bbox: [41.98, 12.70, 42.06, 12.78], population: 88000 },
  { name: 'Portici', region: 'Campania', province: 'NA', bbox: [40.81, 14.33, 40.89, 14.41], population: 55000 },
  { name: 'Ercolano', region: 'Campania', province: 'NA', bbox: [40.79, 14.34, 40.87, 14.42], population: 52000 },
  { name: 'Afragola', region: 'Campania', province: 'NA', bbox: [40.92, 14.30, 41.00, 14.38], population: 64000 },
  { name: 'Castellammare di Stabia', region: 'Campania', province: 'NA', bbox: [40.69, 14.48, 40.77, 14.56], population: 65000 },
  { name: 'Altamura', region: 'Puglia', province: 'BA', bbox: [40.82, 16.54, 40.90, 16.62], population: 70000 },
  { name: 'Marano di Napoli', region: 'Campania', province: 'NA', bbox: [40.89, 14.18, 40.97, 14.26], population: 58000 },
  { name: 'Molfetta', region: 'Puglia', province: 'BA', bbox: [41.19, 16.59, 41.27, 16.67], population: 60000 },
  { name: 'Civitavecchia', region: 'Lazio', province: 'RM', bbox: [42.08, 11.78, 42.16, 11.86], population: 52000 },
  { name: 'Bitonto', region: 'Puglia', province: 'BA', bbox: [41.10, 16.68, 41.18, 16.76], population: 55000 },
  { name: 'Cava de\' Tirreni', region: 'Campania', province: 'SA', bbox: [40.69, 14.70, 40.77, 14.78], population: 53000 },
  { name: 'Mazara del Vallo', region: 'Sicilia', province: 'TP', bbox: [37.65, 12.58, 37.73, 12.66], population: 51000 },
  { name: 'Corigliano-Rossano', region: 'Calabria', province: 'CS', bbox: [39.58, 16.50, 39.66, 16.58], population: 77000 },
  { name: 'Rende', region: 'Calabria', province: 'CS', bbox: [39.32, 16.18, 39.40, 16.26], population: 35000 },
  { name: 'Castrovillari', region: 'Calabria', province: 'CS', bbox: [39.80, 16.18, 39.88, 16.26], population: 22000 },
  { name: 'Paola', region: 'Calabria', province: 'CS', bbox: [39.36, 16.02, 39.44, 16.10], population: 16000 },
  { name: 'Acireale', region: 'Sicilia', province: 'CT', bbox: [37.60, 15.14, 37.68, 15.22], population: 52000 },
  { name: 'Bagheria', region: 'Sicilia', province: 'PA', bbox: [38.08, 13.50, 38.16, 13.58], population: 55000 },
  { name: 'Vittoria', region: 'Sicilia', province: 'RG', bbox: [36.94, 14.52, 37.02, 14.60], population: 63000 },
  { name: 'Modica', region: 'Sicilia', province: 'RG', bbox: [36.85, 14.75, 36.93, 14.83], population: 54000 },
];

// 🏷️ CATEGORIE COMPREHENSIVE (stesse di import-all-provinces-comprehensive.js)
const COMPREHENSIVE_CATEGORIES = [
  // === NEGOZI ===
  { osm: 'shop=supermarket', db: 'Supermercati' },
  { osm: 'shop=convenience', db: 'Alimentari' },
  { osm: 'shop=bakery', db: 'Panifici e Pasticcerie' },
  { osm: 'shop=butcher', db: 'Macellerie' },
  { osm: 'shop=greengrocer', db: 'Frutta e Verdura' },
  { osm: 'shop=alcohol', db: 'Enoteche' },
  { osm: 'shop=beverages', db: 'Negozi di Bevande' },
  { osm: 'shop=seafood', db: 'Pescherie' },
  { osm: 'shop=cheese', db: 'Formaggerie' },
  { osm: 'shop=chocolate', db: 'Cioccolaterie' },
  { osm: 'shop=coffee', db: 'Torrefazioni' },
  { osm: 'shop=confectionery', db: 'Pasticcerie' },
  { osm: 'shop=deli', db: 'Gastronomie' },
  { osm: 'shop=dairy', db: 'Latterie' },
  { osm: 'shop=pasta', db: 'Pastifici' },
  { osm: 'shop=spices', db: 'Spezierie' },
  { osm: 'shop=tea', db: 'Negozi di Tè' },
  { osm: 'shop=clothes', db: 'Abbigliamento' },
  { osm: 'shop=shoes', db: 'Calzature' },
  { osm: 'shop=jewelry', db: 'Gioiellerie' },
  { osm: 'shop=watches', db: 'Orologerie' },
  { osm: 'shop=bag', db: 'Pelletterie' },
  { osm: 'shop=boutique', db: 'Boutique' },
  { osm: 'shop=fashion', db: 'Moda' },
  { osm: 'shop=fabric', db: 'Tessuti' },
  { osm: 'shop=tailor', db: 'Sarti' },
  { osm: 'shop=leather', db: 'Articoli in Pelle' },
  { osm: 'shop=hairdresser', db: 'Parrucchieri e Barbieri' },
  { osm: 'shop=beauty', db: 'Centri Estetici' },
  { osm: 'shop=cosmetics', db: 'Profumerie' },
  { osm: 'shop=perfumery', db: 'Profumerie' },
  { osm: 'shop=massage', db: 'Centri Massaggi' },
  { osm: 'shop=tattoo', db: 'Tatuatori' },
  { osm: 'shop=hairdresser_supply', db: 'Forniture Parrucchieri' },
  { osm: 'shop=hardware', db: 'Ferramenta' },
  { osm: 'shop=doityourself', db: 'Fai da Te' },
  { osm: 'shop=furniture', db: 'Arredamento' },
  { osm: 'shop=interior_decoration', db: 'Arredamento' },
  { osm: 'shop=bed', db: 'Materassi e Letti' },
  { osm: 'shop=bathroom_furnishing', db: 'Arredo Bagno' },
  { osm: 'shop=kitchen', db: 'Cucine' },
  { osm: 'shop=florist', db: 'Fioristi' },
  { osm: 'shop=garden_centre', db: 'Giardinaggio' },
  { osm: 'shop=agrarian', db: 'Consorzi Agrari' },
  { osm: 'shop=paint', db: 'Colorifici' },
  { osm: 'shop=carpet', db: 'Tappeti' },
  { osm: 'shop=curtain', db: 'Tendaggi' },
  { osm: 'shop=lighting', db: 'Illuminazione' },
  { osm: 'shop=tiles', db: 'Piastrelle' },
  { osm: 'shop=glaziery', db: 'Vetrai' },
  { osm: 'shop=windows', db: 'Infissi' },
  { osm: 'shop=electronics', db: 'Elettronica' },
  { osm: 'shop=computer', db: 'Negozi di Computer' },
  { osm: 'shop=mobile_phone', db: 'Negozi di Telefonia' },
  { osm: 'shop=hifi', db: 'Hi-Fi' },
  { osm: 'shop=video', db: 'Videonoleggi' },
  { osm: 'shop=photo', db: 'Fotografia' },
  { osm: 'shop=video_games', db: 'Videogiochi' },
  { osm: 'shop=camera', db: 'Fotocamere' },
  { osm: 'shop=bookshop', db: 'Librerie' },
  { osm: 'shop=books', db: 'Librerie' },
  { osm: 'shop=stationery', db: 'Cartolerie' },
  { osm: 'shop=newsagent', db: 'Edicole' },
  { osm: 'shop=kiosk', db: 'Edicole' },
  { osm: 'shop=music', db: 'Negozi di Musica' },
  { osm: 'shop=musical_instrument', db: 'Strumenti Musicali' },
  { osm: 'shop=art', db: 'Gallerie d\'Arte' },
  { osm: 'shop=frame', db: 'Cornici' },
  { osm: 'shop=craft', db: 'Hobby e Bricolage' },
  { osm: 'shop=model', db: 'Modellismo' },
  { osm: 'shop=pharmacy', db: 'Farmacie' },
  { osm: 'shop=chemist', db: 'Farmacie' },
  { osm: 'shop=optician', db: 'Ottici' },
  { osm: 'shop=medical_supply', db: 'Sanitaria' },
  { osm: 'shop=hearing_aids', db: 'Apparecchi Acustici' },
  { osm: 'shop=sports', db: 'Negozi di Sport' },
  { osm: 'shop=bicycle', db: 'Negozi di Biciclette' },
  { osm: 'shop=fishing', db: 'Pesca e Caccia' },
  { osm: 'shop=hunting', db: 'Pesca e Caccia' },
  { osm: 'shop=outdoor', db: 'Outdoor e Camping' },
  { osm: 'shop=golf', db: 'Golf' },
  { osm: 'shop=scuba_diving', db: 'Sub e Diving' },
  { osm: 'shop=swimming_pool', db: 'Piscine' },
  { osm: 'shop=ski', db: 'Sci e Snowboard' },
  { osm: 'shop=pet', db: 'Negozi per Animali' },
  { osm: 'shop=pet_grooming', db: 'Toelettatura Animali' },
  { osm: 'shop=car', db: 'Concessionarie Auto' },
  { osm: 'shop=car_repair', db: 'Autofficine' },
  { osm: 'shop=car_parts', db: 'Ricambi Auto' },
  { osm: 'shop=motorcycle', db: 'Moto' },
  { osm: 'shop=tyres', db: 'Pneumatici' },
  { osm: 'shop=car_wash', db: 'Autolavaggi' },
  { osm: 'shop=department_store', db: 'Grandi Magazzini' },
  { osm: 'shop=mall', db: 'Centri Commerciali' },
  { osm: 'shop=gift', db: 'Regali' },
  { osm: 'shop=toys', db: 'Giocattoli' },
  { osm: 'shop=baby_goods', db: 'Articoli per Bambini' },
  { osm: 'shop=variety_store', db: 'Bazar' },
  { osm: 'shop=antiques', db: 'Antiquari' },
  { osm: 'shop=second_hand', db: 'Usato' },
  { osm: 'shop=charity', db: 'Mercatini Solidali' },
  { osm: 'shop=tobacco', db: 'Tabaccherie' },
  { osm: 'shop=e-cigarette', db: 'Sigarette Elettroniche' },
  { osm: 'shop=lottery', db: 'Ricevitorie' },
  { osm: 'shop=funeral_directors', db: 'Onoranze Funebri' },
  { osm: 'shop=pyrotechnics', db: 'Fuochi d\'Artificio' },
  { osm: 'shop=weapons', db: 'Armerie' },
  { osm: 'shop=erotic', db: 'Sexy Shop' },

  // === RISTORAZIONE ===
  { osm: 'amenity=restaurant', db: 'Ristoranti' },
  { osm: 'amenity=cafe', db: 'Bar e Caffè' },
  { osm: 'amenity=bar', db: 'Bar e Caffè' },
  { osm: 'amenity=pub', db: 'Pub e Locali' },
  { osm: 'amenity=fast_food', db: 'Fast Food' },
  { osm: 'amenity=food_court', db: 'Food Court' },
  { osm: 'amenity=ice_cream', db: 'Gelaterie' },
  { osm: 'amenity=biergarten', db: 'Birrerie' },
  { osm: 'amenity=nightclub', db: 'Discoteche' },

  // === SERVIZI ===
  { osm: 'amenity=bank', db: 'Banche' },
  { osm: 'amenity=atm', db: 'Bancomat' },
  { osm: 'amenity=post_office', db: 'Uffici Postali' },
  { osm: 'amenity=pharmacy', db: 'Farmacie' },
  { osm: 'amenity=fuel', db: 'Benzinai' },
  { osm: 'amenity=charging_station', db: 'Colonnine Ricarica' },
  { osm: 'amenity=parking', db: 'Parcheggi' },
  { osm: 'amenity=bicycle_parking', db: 'Parcheggi Biciclette' },
  { osm: 'amenity=car_wash', db: 'Autolavaggi' },
  { osm: 'amenity=car_rental', db: 'Autonoleggi' },
  { osm: 'amenity=taxi', db: 'Taxi' },
  { osm: 'amenity=bicycle_rental', db: 'Noleggio Biciclette' },
  { osm: 'amenity=vehicle_inspection', db: 'Revisioni Auto' },
  { osm: 'amenity=vending_machine', db: 'Distributori Automatici' },
  { osm: 'amenity=laundry', db: 'Lavanderie' },

  // === PROFESSIONISTI SANITARI ===
  { osm: 'amenity=dentist', db: 'Dentisti' },
  { osm: 'amenity=doctors', db: 'Medici' },
  { osm: 'amenity=clinic', db: 'Cliniche' },
  { osm: 'amenity=hospital', db: 'Ospedali' },
  { osm: 'amenity=veterinary', db: 'Veterinari' },
  { osm: 'healthcare=laboratory', db: 'Laboratori Analisi' },
  { osm: 'healthcare=physiotherapist', db: 'Fisioterapisti' },
  { osm: 'healthcare=psychotherapist', db: 'Psicologi' },
  { osm: 'healthcare=alternative', db: 'Medicine Alternative' },
  { osm: 'healthcare=midwife', db: 'Ostetriche' },
  { osm: 'healthcare=optometrist', db: 'Optometristi' },
  { osm: 'healthcare=podiatrist', db: 'Podologi' },
  { osm: 'healthcare=speech_therapist', db: 'Logopedisti' },

  // === PROFESSIONISTI E STUDI ===
  { osm: 'office=lawyer', db: 'Avvocati' },
  { osm: 'office=accountant', db: 'Commercialisti' },
  { osm: 'office=tax_advisor', db: 'Consulenti Fiscali' },
  { osm: 'office=architect', db: 'Architetti' },
  { osm: 'office=engineer', db: 'Ingegneri' },
  { osm: 'office=surveyor', db: 'Geometri' },
  { osm: 'office=estate_agent', db: 'Agenzie Immobiliari' },
  { osm: 'office=insurance', db: 'Assicurazioni' },
  { osm: 'office=financial', db: 'Consulenti Finanziari' },
  { osm: 'office=notary', db: 'Notai' },
  { osm: 'office=consulting', db: 'Consulenti' },
  { osm: 'office=employment_agency', db: 'Agenzie del Lavoro' },
  { osm: 'office=travel_agent', db: 'Agenzie di Viaggio' },
  { osm: 'office=advertising_agency', db: 'Agenzie Pubblicitarie' },
  { osm: 'office=it', db: 'Informatica' },
  { osm: 'office=telecommunication', db: 'Telecomunicazioni' },
  { osm: 'office=graphic_design', db: 'Grafici' },
  { osm: 'office=photographer', db: 'Fotografi' },
  { osm: 'office=educational_institution', db: 'Istituti Formativi' },
  { osm: 'office=research', db: 'Centri di Ricerca' },
  { osm: 'office=newspaper', db: 'Giornali' },
  { osm: 'office=logistics', db: 'Logistica' },
  { osm: 'office=association', db: 'Associazioni' },
  { osm: 'office=foundation', db: 'Fondazioni' },
  { osm: 'office=ngo', db: 'ONG' },

  // === ARTIGIANI ===
  { osm: 'craft=carpenter', db: 'Falegnami' },
  { osm: 'craft=electrician', db: 'Elettricisti' },
  { osm: 'craft=plumber', db: 'Idraulici' },
  { osm: 'craft=painter', db: 'Imbianchini' },
  { osm: 'craft=shoemaker', db: 'Calzolai' },
  { osm: 'craft=tailor', db: 'Sarti' },
  { osm: 'craft=metal_construction', db: 'Fabbri' },
  { osm: 'craft=locksmith', db: 'Fabbri' },
  { osm: 'craft=hvac', db: 'Climatizzazione' },
  { osm: 'craft=glaziery', db: 'Vetrai' },
  { osm: 'craft=gardener', db: 'Giardinieri' },
  { osm: 'craft=photographer', db: 'Fotografi' },
  { osm: 'craft=pottery', db: 'Ceramisti' },
  { osm: 'craft=stonemason', db: 'Scalpellini' },
  { osm: 'craft=parquet_layer', db: 'Posatori Parquet' },
  { osm: 'craft=upholsterer', db: 'Tappezzieri' },
  { osm: 'craft=roofer', db: 'Lattonieri' },
  { osm: 'craft=scaffolder', db: 'Ponteggiatori' },
  { osm: 'craft=window_construction', db: 'Serramenti' },
  { osm: 'craft=builder', db: 'Costruttori' },
  { osm: 'craft=floorer', db: 'Pavimenti' },
  { osm: 'craft=tiler', db: 'Piastrellisti' },
  { osm: 'craft=plasterer', db: 'Stuccatori' },
  { osm: 'craft=beekeeper', db: 'Apicoltori' },
  { osm: 'craft=blacksmith', db: 'Maniscalchi' },
  { osm: 'craft=brewery', db: 'Birrifici' },
  { osm: 'craft=winery', db: 'Cantine' },
  { osm: 'craft=distillery', db: 'Distillerie' },
  { osm: 'craft=bakery', db: 'Panifici' },
  { osm: 'craft=confectionery', db: 'Pasticcerie' },
  { osm: 'craft=butcher', db: 'Macellerie' },
  { osm: 'craft=dressmaker', db: 'Sartorie' },
  { osm: 'craft=jeweller', db: 'Orefici' },
  { osm: 'craft=clockmaker', db: 'Orologiai' },
  { osm: 'craft=optician', db: 'Ottici' },
  { osm: 'craft=electronics_repair', db: 'Riparazione Elettronica' },
  { osm: 'craft=key_cutter', db: 'Duplicazione Chiavi' },
  { osm: 'craft=printing', db: 'Tipografie' },
  { osm: 'craft=signmaker', db: 'Insegne' },
  { osm: 'craft=sailmaker', db: 'Velai' },
  { osm: 'craft=basket_maker', db: 'Cestai' },
  { osm: 'craft=bookbinder', db: 'Rilegatori' },

  // === ALLOGGI ===
  { osm: 'tourism=hotel', db: 'Hotel' },
  { osm: 'tourism=guest_house', db: 'B&B' },
  { osm: 'tourism=hostel', db: 'Ostelli' },
  { osm: 'tourism=motel', db: 'Motel' },
  { osm: 'tourism=apartment', db: 'Appartamenti' },
  { osm: 'tourism=chalet', db: 'Chalet' },
  { osm: 'tourism=camp_site', db: 'Campeggi' },
  { osm: 'tourism=caravan_site', db: 'Aree Camper' },

  // === FITNESS E BENESSERE ===
  { osm: 'leisure=fitness_centre', db: 'Palestre' },
  { osm: 'leisure=sports_centre', db: 'Centri Sportivi' },
  { osm: 'leisure=swimming_pool', db: 'Piscine' },
  { osm: 'leisure=sauna', db: 'Saune' },
  { osm: 'leisure=dance', db: 'Scuole di Danza' },
  { osm: 'leisure=yoga', db: 'Centri Yoga' },
  { osm: 'leisure=martial_arts', db: 'Arti Marziali' },

  // === EDUCAZIONE ===
  { osm: 'amenity=school', db: 'Scuole' },
  { osm: 'amenity=kindergarten', db: 'Asili' },
  { osm: 'amenity=college', db: 'Università' },
  { osm: 'amenity=driving_school', db: 'Autoscuole' },
  { osm: 'amenity=language_school', db: 'Scuole di Lingue' },
  { osm: 'amenity=music_school', db: 'Scuole di Musica' },
  { osm: 'amenity=library', db: 'Biblioteche' },
];

const categoryCache = {};
let stats = {
  totalProcessed: 0,
  totalImported: 0,
  byCity: {},
  byRegion: {},
  byCategory: {},
  errors: 0,
  skippedCities: 0,
};

async function getCategoryId(name) {
  if (categoryCache[name]) return categoryCache[name];

  const { data } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', name)
    .maybeSingle();

  if (data) {
    categoryCache[name] = data.id;
    return data.id;
  }
  return null;
}

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function queryOverpass(bbox, osmTag) {
  const bboxStr = `${bbox[0]},${bbox[1]},${bbox[2]},${bbox[3]}`;
  const query = `
    [out:json][timeout:120];
    (
      node[${osmTag}](${bboxStr});
      way[${osmTag}](${bboxStr});
      relation[${osmTag}](${bboxStr});
    );
    out center;
  `;

  let retries = 0;
  const maxRetries = 3;

  while (retries < maxRetries) {
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        body: query,
        headers: { 'Content-Type': 'text/plain' },
        signal: AbortSignal.timeout(60000)
      });

      if (!response.ok) {
        if (response.status === 429) {
          console.log('   ⏳ Rate limit, attendo 60 secondi...');
          await sleep(60000);
          return queryOverpass(bbox, osmTag);
        }
        if (response.status === 504) {
          throw new Error('Gateway timeout');
        }
        if (response.status >= 500) {
          throw new Error(`Server error: ${response.status}`);
        }
        return [];
      }

      const data = await response.json();
      return data.elements || [];
    } catch (error) {
      retries++;
      if (retries < maxRetries) {
        const waitTime = retries * 15000;
        console.log(`   ⚠️  Errore (${retries}/${maxRetries}): ${error.message}`);
        console.log(`   ⏳ Riprovo tra ${waitTime/1000}s...`);
        await sleep(waitTime);
      } else {
        console.log(`   ⏹️  Saltata dopo ${maxRetries} tentativi`);
        return [];
      }
    }
  }

  return [];
}

function extractData(element, cityData) {
  const tags = element.tags || {};

  let lat, lon;
  if (element.lat && element.lon) {
    lat = element.lat;
    lon = element.lon;
  } else if (element.center) {
    lat = element.center.lat;
    lon = element.center.lon;
  } else {
    return null;
  }

  const name = tags.name || tags['name:it'] || tags.operator || tags.brand;
  if (!name) return null;

  const street = tags['addr:street'] || '';
  const houseNumber = tags['addr:housenumber'] || '';
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || cityData.name;
  const postcode = tags['addr:postcode'] || '';

  let address = '';
  if (street && houseNumber) {
    address = `${street}, ${houseNumber}`;
  } else if (street) {
    address = street;
  } else {
    address = city;
  }

  return {
    name,
    address,
    city,
    province: cityData.province,
    region: cityData.region,
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
    business_hours: tags.opening_hours || null,
  };
}

async function importCity(cityData, cityIndex, totalCities) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 CITTÀ [${cityIndex}/${totalCities}]: ${cityData.name} (${cityData.region}) - ${cityData.population.toLocaleString()} abitanti`);
  console.log('='.repeat(70));

  let cityTotal = 0;
  let categoryCount = 0;
  let skippedCategories = 0;

  for (const category of COMPREHENSIVE_CATEGORIES) {
    categoryCount++;
    process.stdout.write(`   [${categoryCount}/${COMPREHENSIVE_CATEGORIES.length}] ${category.db.padEnd(35)} `);

    try {
      const categoryId = await getCategoryId(category.db);
      if (!categoryId) {
        console.log('⚠️  cat. non trovata - SKIP');
        skippedCategories++;
        await sleep(1000);
        continue;
      }

      const elements = await queryOverpass(cityData.bbox, category.osm);

      if (elements.length === 0) {
        console.log('⚪ 0');
        await sleep(2500);
        continue;
      }

      let imported = 0;
      for (const element of elements) {
        const businessData = extractData(element, cityData);
        if (!businessData) continue;

        try {
          const { data: existing } = await supabase
            .from('unclaimed_business_locations')
            .select('id')
            .eq('name', businessData.name)
            .eq('city', businessData.city)
            .eq('address', businessData.address)
            .maybeSingle();

          if (existing) continue;

          const { error } = await supabase
            .from('unclaimed_business_locations')
            .insert({
              category_id: categoryId,
              name: businessData.name,
              address: businessData.address,
              city: businessData.city,
              province: businessData.province,
              region: businessData.region,
              postal_code: businessData.postal_code,
              country: 'Italia',
              latitude: businessData.latitude,
              longitude: businessData.longitude,
              phone: businessData.phone,
              email: businessData.email,
              website: businessData.website,
              business_hours: businessData.business_hours,
              verified: true,
            });

          if (!error) {
            imported++;
            stats.totalImported++;
            stats.byCategory[category.db] = (stats.byCategory[category.db] || 0) + 1;
            stats.byRegion[cityData.region] = (stats.byRegion[cityData.region] || 0) + 1;
          } else {
            stats.errors++;
          }
        } catch (error) {
          stats.errors++;
        }
      }

      if (imported > 0) {
        console.log(`✅ ${imported}`);
      } else {
        console.log(`⚪ 0`);
      }

      cityTotal += imported;
      stats.totalProcessed += elements.length;

      await sleep(3500);
    } catch (error) {
      console.log(`❌ Errore - SKIP`);
      skippedCategories++;
      stats.errors++;
      await sleep(4000);
      continue;
    }
  }

  stats.byCity[cityData.name] = cityTotal;

  console.log(`\n   🎯 TOTALE ${cityData.name}: ${cityTotal} attività`);
  if (skippedCategories > 0) {
    console.log(`   ⚠️  Categorie saltate: ${skippedCategories}`);
  }
  console.log(`   📊 Totale complessivo: ${stats.totalImported.toLocaleString()}\n`);

  return cityTotal;
}

function printProgressSummary() {
  console.log('\n' + '='.repeat(70));
  console.log('📊 RIEPILOGO PROGRESSIVO');
  console.log('='.repeat(70));
  console.log(`Totale importate: ${stats.totalImported.toLocaleString()}`);
  console.log(`Errori: ${stats.errors}`);

  console.log(`\n🏆 Top 10 Città:`);
  Object.entries(stats.byCity)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 10)
    .forEach(([city, count], i) => {
      console.log(`   ${(i+1).toString().padStart(2)}. ${city.padEnd(30)} ${count.toLocaleString()}`);
    });

  console.log(`\n🗺️  Per Regione:`);
  Object.entries(stats.byRegion)
    .sort(([,a], [,b]) => b - a)
    .forEach(([reg, count]) => {
      console.log(`   ${reg.padEnd(30)} ${count.toLocaleString()}`);
    });

  console.log('');
}

async function main() {
  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' IMPORTAZIONE OSM PER CITTÀ (>20k abitanti) '.padEnd(68) + '║');
  console.log('║' + ' '.repeat(68) + '║');
  console.log('║' + ` Totale città: ${ITALIAN_CITIES.length}`.padEnd(68) + '║');
  console.log('║' + ` Totale categorie: ${COMPREHENSIVE_CATEGORIES.length}`.padEnd(68) + '║');
  console.log('║' + ' 🎯 Inizio dalle città PICCOLE (meno timeout!)'.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  let grandTotal = 0;
  let cityCount = 0;

  const sortedCities = [...ITALIAN_CITIES].filter(c => c.population < 500000).reverse();
  const totalCities = sortedCities.length;
  console.log(`📊 Città selezionate (< 500k ab.): ${totalCities}/${ITALIAN_CITIES.length}\n`);

  for (const cityData of sortedCities) {
    try {
      cityCount++;
      const count = await importCity(cityData, cityCount, totalCities);
      grandTotal += count;

      if (cityCount % 10 === 0) {
        printProgressSummary();
      }

      console.log(`⏳ Pausa 5 secondi... (${cityCount}/${totalCities})\n`);
      await sleep(5000); // Pausa più breve tra città

    } catch (error) {
      console.error(`\n❌ ERRORE in ${cityData.name}:`, error.message);
      console.error(`   Città SALTATA - continuo...\n`);
      stats.errors++;
      stats.skippedCities++;
      stats.byCity[cityData.name] = 0;
      await sleep(5000);
    }
  }

  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' ✅ IMPORTAZIONE COMPLETATA '.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  printProgressSummary();

  console.log('\n' + '='.repeat(70));
  console.log('🎉 STATISTICHE FINALI');
  console.log('='.repeat(70));
  console.log(`Città processate: ${cityCount}/${totalCities}`);
  console.log(`Città completate: ${cityCount - stats.skippedCities}`);
  console.log(`Città saltate: ${stats.skippedCities}`);
  console.log(`Totale attività importate: ${grandTotal.toLocaleString()}`);
  console.log(`Errori totali: ${stats.errors}`);
  console.log('='.repeat(70) + '\n');
}

main().catch(console.error);
