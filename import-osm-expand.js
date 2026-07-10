/**
 * Espansione importazione OSM - citta' nuove non ancora coperte
 * Tutte le citta' italiane >10k abitanti non ancora nel DB
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.VITE_SUPABASE_ANON_KEY;
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Citta' aggiuntive non coperte dal primo script
// Focus su: Abruzzo, Marche, Umbria, Basilicata + altre mancanti
// Ogni bbox = ~0.10 gradi = ~11km raggio
const EXTRA_CITIES = [
  // === ABRUZZO (solo 4 citta' finora) ===
  { name: 'L\'Aquila', region: 'Abruzzo', province: 'AQ', bbox: [42.35, 13.35, 42.43, 13.43] },
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.65, 13.70, 42.73, 13.78] },
  { name: 'Lanciano', region: 'Abruzzo', province: 'CH', bbox: [42.22, 14.38, 42.30, 14.46] },
  { name: 'Vasto', region: 'Abruzzo', province: 'CH', bbox: [42.10, 14.70, 42.18, 14.78] },
  { name: 'Chieti', region: 'Abruzzo', province: 'CH', bbox: [42.34, 14.14, 42.42, 14.22] },
  { name: 'Avezzano', region: 'Abruzzo', province: 'AQ', bbox: [42.02, 13.41, 42.10, 13.49] },
  { name: 'Sulmona', region: 'Abruzzo', province: 'AQ', bbox: [42.04, 13.92, 42.12, 14.00] },
  { name: 'Montesilvano', region: 'Abruzzo', province: 'PE', bbox: [42.50, 14.14, 42.58, 14.22] },
  { name: 'Francavilla al Mare', region: 'Abruzzo', province: 'CH', bbox: [42.41, 14.27, 42.49, 14.35] },
  { name: 'Ortona', region: 'Abruzzo', province: 'CH', bbox: [42.35, 14.40, 42.43, 14.48] },

  // === MARCHE (solo 2 citta' finora) ===
  { name: 'Macerata', region: 'Marche', province: 'MC', bbox: [43.29, 13.45, 43.37, 13.53] },
  { name: 'Fermo', region: 'Marche', province: 'FM', bbox: [43.15, 13.71, 43.23, 13.79] },
  { name: 'Senigallia', region: 'Marche', province: 'AN', bbox: [43.70, 13.20, 43.78, 13.28] },
  { name: 'Fabriano', region: 'Marche', province: 'AN', bbox: [43.33, 12.89, 43.41, 12.97] },
  { name: 'Civitanova Marche', region: 'Marche', province: 'MC', bbox: [43.29, 13.72, 43.37, 13.80] },
  { name: 'San Benedetto del Tronto', region: 'Marche', province: 'AP', bbox: [42.94, 13.86, 43.02, 13.94] },
  { name: 'Jesi', region: 'Marche', province: 'AN', bbox: [43.52, 13.24, 43.60, 13.32] },
  { name: 'Ascoli Piceno', region: 'Marche', province: 'AP', bbox: [42.84, 13.57, 42.92, 13.65] },
  { name: 'Porto San Giorgio', region: 'Marche', province: 'FM', bbox: [43.18, 13.78, 43.26, 13.86] },
  { name: 'Osimo', region: 'Marche', province: 'AN', bbox: [43.47, 13.47, 43.55, 13.55] },

  // === UMBRIA (solo 4 citta' finora) ===
  { name: 'Foligno', region: 'Umbria', province: 'PG', bbox: [42.94, 12.69, 43.02, 12.77] },
  { name: 'Spoleto', region: 'Umbria', province: 'PG', bbox: [42.73, 12.73, 42.81, 12.81] },
  { name: 'Città di Castello', region: 'Umbria', province: 'PG', bbox: [43.45, 12.24, 43.53, 12.32] },
  { name: 'Gubbio', region: 'Umbria', province: 'PG', bbox: [43.35, 12.56, 43.43, 12.64] },
  { name: 'Orvieto', region: 'Umbria', province: 'TR', bbox: [42.71, 12.10, 42.79, 12.18] },
  { name: 'Narni', region: 'Umbria', province: 'TR', bbox: [42.51, 12.51, 42.59, 12.59] },
  { name: 'Corciano', region: 'Umbria', province: 'PG', bbox: [43.09, 12.28, 43.17, 12.36] },
  { name: 'Bastia Umbra', region: 'Umbria', province: 'PG', bbox: [43.06, 12.53, 43.14, 12.61] },

  // === BASILICATA (solo 3 citta' finora) ===
  { name: 'Melfi', region: 'Basilicata', province: 'PZ', bbox: [40.99, 15.64, 41.07, 15.72] },
  { name: 'Pisticci', region: 'Basilicata', province: 'MT', bbox: [40.38, 16.55, 40.46, 16.63] },
  { name: 'Policoro', region: 'Basilicata', province: 'MT', bbox: [40.19, 16.66, 40.27, 16.74] },
  { name: 'Lagonegro', region: 'Basilicata', province: 'PZ', bbox: [40.12, 15.76, 40.20, 15.84] },
  { name: 'Venosa', region: 'Basilicata', province: 'PZ', bbox: [40.95, 15.81, 41.03, 15.89] },
  { name: 'Lavello', region: 'Basilicata', province: 'PZ', bbox: [40.98, 15.78, 41.06, 15.86] },
  { name: 'Rionero in Vulture', region: 'Basilicata', province: 'PZ', bbox: [40.91, 15.66, 40.99, 15.74] },
  { name: 'Senise', region: 'Basilicata', province: 'PZ', bbox: [40.14, 16.27, 40.22, 16.35] },

  // === CALABRIA (ampliamento) ===
  { name: 'Palmi', region: 'Calabria', province: 'RC', bbox: [38.35, 15.84, 38.43, 15.92] },
  { name: 'Gioia Tauro', region: 'Calabria', province: 'RC', bbox: [38.42, 15.89, 38.50, 15.97] },
  { name: 'Locri', region: 'Calabria', province: 'RC', bbox: [38.23, 16.25, 38.31, 16.33] },
  { name: 'Siderno', region: 'Calabria', province: 'RC', bbox: [38.26, 16.29, 38.34, 16.37] },
  { name: 'Scalea', region: 'Calabria', province: 'CS', bbox: [39.81, 15.78, 39.89, 15.86] },
  { name: 'Praia a Mare', region: 'Calabria', province: 'CS', bbox: [39.89, 15.77, 39.97, 15.85] },
  { name: 'Diamante', region: 'Calabria', province: 'CS', bbox: [39.67, 15.82, 39.75, 15.90] },
  { name: 'Trebisacce', region: 'Calabria', province: 'CS', bbox: [39.86, 16.52, 39.94, 16.60] },
  { name: 'Acri', region: 'Calabria', province: 'CS', bbox: [39.49, 16.37, 39.57, 16.45] },
  { name: 'Rossano', region: 'Calabria', province: 'CS', bbox: [39.57, 16.63, 39.65, 16.71] },
  { name: 'Cirò Marina', region: 'Calabria', province: 'KR', bbox: [39.36, 17.12, 39.44, 17.20] },
  { name: 'Isola di Capo Rizzuto', region: 'Calabria', province: 'KR', bbox: [38.95, 17.08, 39.03, 17.16] },
  { name: 'Catanzaro Lido', region: 'Calabria', province: 'CZ', bbox: [38.82, 16.58, 38.90, 16.66] },
  { name: 'Soverato', region: 'Calabria', province: 'CZ', bbox: [38.68, 16.53, 38.76, 16.61] },
  { name: 'Serra San Bruno', region: 'Calabria', province: 'VV', bbox: [38.55, 16.31, 38.63, 16.39] },

  // === SARDEGNA (ampliamento) ===
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', bbox: [40.31, 9.32, 40.39, 9.40] },
  { name: 'Olbia', region: 'Sardegna', province: 'SS', bbox: [40.91, 9.49, 40.99, 9.57] },
  { name: 'Oristano', region: 'Sardegna', province: 'OR', bbox: [39.89, 8.58, 39.97, 8.66] },
  { name: 'Quartu Sant\'Elena', region: 'Sardegna', province: 'CA', bbox: [39.24, 9.17, 39.32, 9.25] },
  { name: 'Alghero', region: 'Sardegna', province: 'SS', bbox: [40.55, 8.29, 40.63, 8.37] },
  { name: 'Selargius', region: 'Sardegna', province: 'CA', bbox: [39.24, 9.13, 39.32, 9.21] },
  { name: 'Iglesias', region: 'Sardegna', province: 'SU', bbox: [39.30, 8.52, 39.38, 8.60] },
  { name: 'Carbonia', region: 'Sardegna', province: 'SU', bbox: [39.16, 8.51, 39.24, 8.59] },
  { name: 'La Maddalena', region: 'Sardegna', province: 'SS', bbox: [41.21, 9.39, 41.29, 9.47] },
  { name: 'Tempio Pausania', region: 'Sardegna', province: 'SS', bbox: [40.89, 9.09, 40.97, 9.17] },

  // === PUGLIA (ampliamento) ===
  { name: 'Manfredonia', region: 'Puglia', province: 'FG', bbox: [41.62, 15.91, 41.70, 15.99] },
  { name: 'Cerignola', region: 'Puglia', province: 'FG', bbox: [41.26, 15.90, 41.34, 15.98] },
  { name: 'Lucera', region: 'Puglia', province: 'FG', bbox: [41.50, 15.33, 41.58, 15.41] },
  { name: 'San Severo', region: 'Puglia', province: 'FG', bbox: [41.68, 15.37, 41.76, 15.45] },
  { name: 'Corato', region: 'Puglia', province: 'BA', bbox: [41.14, 16.40, 41.22, 16.48] },
  { name: 'Ruvo di Puglia', region: 'Puglia', province: 'BA', bbox: [41.11, 16.48, 41.19, 16.56] },
  { name: 'Canosa di Puglia', region: 'Puglia', province: 'BT', bbox: [41.21, 16.06, 41.29, 16.14] },
  { name: 'Trani', region: 'Puglia', province: 'BT', bbox: [41.27, 16.41, 41.35, 16.49] },
  { name: 'Monopoli', region: 'Puglia', province: 'BA', bbox: [40.94, 17.28, 41.02, 17.36] },
  { name: 'Fasano', region: 'Puglia', province: 'BR', bbox: [40.83, 17.35, 40.91, 17.43] },
  { name: 'Ostuni', region: 'Puglia', province: 'BR', bbox: [40.72, 17.57, 40.80, 17.65] },
  { name: 'Grottaglie', region: 'Puglia', province: 'TA', bbox: [40.53, 17.43, 40.61, 17.51] },
  { name: 'Martina Franca', region: 'Puglia', province: 'TA', bbox: [40.70, 17.33, 40.78, 17.41] },
  { name: 'Nardò', region: 'Puglia', province: 'LE', bbox: [40.17, 18.02, 40.25, 18.10] },
  { name: 'Galatina', region: 'Puglia', province: 'LE', bbox: [40.17, 18.16, 40.25, 18.24] },
  { name: 'Gallipoli', region: 'Puglia', province: 'LE', bbox: [39.99, 17.98, 40.07, 18.06] },
  { name: 'Maglie', region: 'Puglia', province: 'LE', bbox: [40.11, 18.29, 40.19, 18.37] },
  { name: 'Squinzano', region: 'Puglia', province: 'LE', bbox: [40.43, 18.03, 40.51, 18.11] },

  // === CAMPANIA (ampliamento) ===
  { name: 'Battipaglia', region: 'Campania', province: 'SA', bbox: [40.60, 14.97, 40.68, 15.05] },
  { name: 'Nocera Inferiore', region: 'Campania', province: 'SA', bbox: [40.74, 14.63, 40.82, 14.71] },
  { name: 'Pagani', region: 'Campania', province: 'SA', bbox: [40.74, 14.61, 40.82, 14.69] },
  { name: 'Scafati', region: 'Campania', province: 'SA', bbox: [40.75, 14.52, 40.83, 14.60] },
  { name: 'Eboli', region: 'Campania', province: 'SA', bbox: [40.61, 15.05, 40.69, 15.13] },
  { name: 'Agropoli', region: 'Campania', province: 'SA', bbox: [40.34, 14.98, 40.42, 15.06] },
  { name: 'Capaccio', region: 'Campania', province: 'SA', bbox: [40.42, 15.07, 40.50, 15.15] },
  { name: 'Nola', region: 'Campania', province: 'NA', bbox: [40.91, 14.51, 40.99, 14.59] },
  { name: 'Marigliano', region: 'Campania', province: 'NA', bbox: [40.93, 14.45, 41.01, 14.53] },
  { name: 'Pomigliano d\'Arco', region: 'Campania', province: 'NA', bbox: [40.91, 14.38, 40.99, 14.46] },
  { name: 'Qualiano', region: 'Campania', province: 'NA', bbox: [40.92, 14.14, 41.00, 14.22] },
  { name: 'Mugnano di Napoli', region: 'Campania', province: 'NA', bbox: [40.90, 14.21, 40.98, 14.29] },
  { name: 'Villaricca', region: 'Campania', province: 'NA', bbox: [40.92, 14.18, 41.00, 14.26] },
  { name: 'Ottaviano', region: 'Campania', province: 'NA', bbox: [40.84, 14.47, 40.92, 14.55] },
  { name: 'Avellino', region: 'Campania', province: 'AV', bbox: [40.91, 14.79, 40.99, 14.87] },
  { name: 'Ariano Irpino', region: 'Campania', province: 'AV', bbox: [41.15, 15.08, 41.23, 15.16] },
  { name: 'Nocera Superiore', region: 'Campania', province: 'SA', bbox: [40.75, 14.67, 40.83, 14.75] },

  // === TRENTINO-ALTO ADIGE (ampliamento) ===
  { name: 'Merano', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.66, 11.15, 46.74, 11.23] },
  { name: 'Bressanone', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.70, 11.64, 46.78, 11.72] },
  { name: 'Laives', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.42, 11.32, 46.50, 11.40] },
  { name: 'Rovereto', region: 'Trentino-Alto Adige', province: 'TN', bbox: [45.88, 11.01, 45.96, 11.09] },
  { name: 'Riva del Garda', region: 'Trentino-Alto Adige', province: 'TN', bbox: [45.88, 10.83, 45.96, 10.91] },
  { name: 'Pergine Valsugana', region: 'Trentino-Alto Adige', province: 'TN', bbox: [46.05, 11.23, 46.13, 11.31] },
  { name: 'Arco', region: 'Trentino-Alto Adige', province: 'TN', bbox: [45.91, 10.87, 45.99, 10.95] },
  { name: 'Cles', region: 'Trentino-Alto Adige', province: 'TN', bbox: [46.35, 11.03, 46.43, 11.11] },
  { name: 'Brunico', region: 'Trentino-Alto Adige', province: 'BZ', bbox: [46.79, 11.93, 46.87, 12.01] },

  // === FRIULI-VENEZIA GIULIA (ampliamento) ===
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.93, 13.61, 46.01, 13.69] },
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.95, 12.64, 46.03, 12.72] },
  { name: 'Monfalcone', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.79, 13.52, 45.87, 13.60] },
  { name: 'Muggia', region: 'Friuli-Venezia Giulia', province: 'TS', bbox: [45.59, 13.75, 45.67, 13.83] },
  { name: 'Sacile', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.96, 12.49, 46.04, 12.57] },

  // === VENETO (ampliamento) ===
  { name: 'Rovigo', region: 'Veneto', province: 'RO', bbox: [44.41, 11.77, 44.49, 11.85] },
  { name: 'Belluno', region: 'Veneto', province: 'BL', bbox: [46.13, 12.20, 46.21, 12.28] },
  { name: 'Conegliano', region: 'Veneto', province: 'TV', bbox: [45.88, 12.29, 45.96, 12.37] },
  { name: 'Vittorio Veneto', region: 'Veneto', province: 'TV', bbox: [45.97, 12.29, 46.05, 12.37] },
  { name: 'Castelfranco Veneto', region: 'Veneto', province: 'TV', bbox: [45.66, 11.91, 45.74, 11.99] },
  { name: 'Montebelluna', region: 'Veneto', province: 'TV', bbox: [45.77, 12.03, 45.85, 12.11] },
  { name: 'Thiene', region: 'Veneto', province: 'VI', bbox: [45.70, 11.47, 45.78, 11.55] },
  { name: 'Schio', region: 'Veneto', province: 'VI', bbox: [45.71, 11.35, 45.79, 11.43] },
  { name: 'Bassano del Grappa', region: 'Veneto', province: 'VI', bbox: [45.76, 11.72, 45.84, 11.80] },
  { name: 'Chioggia', region: 'Veneto', province: 'VE', bbox: [45.21, 12.27, 45.29, 12.35] },
  { name: 'San Donà di Piave', region: 'Veneto', province: 'VE', bbox: [45.62, 12.56, 45.70, 12.64] },
  { name: 'Jesolo', region: 'Veneto', province: 'VE', bbox: [45.53, 12.63, 45.61, 12.71] },
  { name: 'Portogruaro', region: 'Veneto', province: 'VE', bbox: [45.77, 12.83, 45.85, 12.91] },
  { name: 'Mestre', region: 'Veneto', province: 'VE', bbox: [45.48, 12.22, 45.56, 12.30] },
  { name: 'Verona Nord', region: 'Veneto', province: 'VR', bbox: [45.46, 10.99, 45.54, 11.07] },
  { name: 'Villafranca di Verona', region: 'Veneto', province: 'VR', bbox: [45.35, 10.83, 45.43, 10.91] },
  { name: 'San Giovanni Lupatoto', region: 'Veneto', province: 'VR', bbox: [45.36, 11.04, 45.44, 11.12] },

  // === LOMBARDIA (ampliamento piccoli comuni) ===
  { name: 'Sondrio', region: 'Lombardia', province: 'SO', bbox: [46.16, 9.86, 46.24, 9.94] },
  { name: 'Lecco', region: 'Lombardia', province: 'LC', bbox: [45.85, 9.38, 45.93, 9.46] },
  { name: 'Gallarate', region: 'Lombardia', province: 'VA', bbox: [45.65, 8.78, 45.73, 8.86] },
  { name: 'Saronno', region: 'Lombardia', province: 'VA', bbox: [45.62, 9.03, 45.70, 9.11] },
  { name: 'Sesto San Giovanni', region: 'Lombardia', province: 'MI', bbox: [45.52, 9.22, 45.60, 9.30] },
  { name: 'Cinisello Balsamo', region: 'Lombardia', province: 'MI', bbox: [45.55, 9.21, 45.63, 9.29] },
  { name: 'Cologno Monzese', region: 'Lombardia', province: 'MI', bbox: [45.53, 9.27, 45.61, 9.35] },
  { name: 'Vigevano', region: 'Lombardia', province: 'PV', bbox: [45.31, 8.85, 45.39, 8.93] },
  { name: 'Abbiategrasso', region: 'Lombardia', province: 'MI', bbox: [45.39, 8.91, 45.47, 8.99] },
  { name: 'Corsico', region: 'Lombardia', province: 'MI', bbox: [45.44, 9.10, 45.52, 9.18] },
  { name: 'Rho', region: 'Lombardia', province: 'MI', bbox: [45.52, 9.03, 45.60, 9.11] },
  { name: 'Seregno', region: 'Lombardia', province: 'MB', bbox: [45.64, 9.19, 45.72, 9.27] },
  { name: 'Desio', region: 'Lombardia', province: 'MB', bbox: [45.61, 9.20, 45.69, 9.28] },
  { name: 'Limbiate', region: 'Lombardia', province: 'MB', bbox: [45.59, 9.13, 45.67, 9.21] },
  { name: 'Cassano d\'Adda', region: 'Lombardia', province: 'MI', bbox: [45.52, 9.51, 45.60, 9.59] },
  { name: 'Treviglio', region: 'Lombardia', province: 'BG', bbox: [45.52, 9.58, 45.60, 9.66] },
  { name: 'Seriate', region: 'Lombardia', province: 'BG', bbox: [45.67, 9.72, 45.75, 9.80] },
  { name: 'Caravaggio', region: 'Lombardia', province: 'BG', bbox: [45.49, 9.64, 45.57, 9.72] },
  { name: 'Crema', region: 'Lombardia', province: 'CR', bbox: [45.36, 9.68, 45.44, 9.76] },
  { name: 'Lissone', region: 'Lombardia', province: 'MB', bbox: [45.60, 9.23, 45.68, 9.31] },

  // === PIEMONTE (ampliamento) ===
  { name: 'Verbania', region: 'Piemonte', province: 'VB', bbox: [45.91, 8.52, 45.99, 8.60] },
  { name: 'Biella', region: 'Piemonte', province: 'BI', bbox: [45.55, 8.04, 45.63, 8.12] },
  { name: 'Ivrea', region: 'Piemonte', province: 'TO', bbox: [45.46, 7.86, 45.54, 7.94] },
  { name: 'Moncalieri', region: 'Piemonte', province: 'TO', bbox: [44.99, 7.68, 45.07, 7.76] },
  { name: 'Collegno', region: 'Piemonte', province: 'TO', bbox: [45.07, 7.57, 45.15, 7.65] },
  { name: 'Rivoli', region: 'Piemonte', province: 'TO', bbox: [45.07, 7.51, 45.15, 7.59] },
  { name: 'Settimo Torinese', region: 'Piemonte', province: 'TO', bbox: [45.13, 7.76, 45.21, 7.84] },
  { name: 'Pinerolo', region: 'Piemonte', province: 'TO', bbox: [44.88, 7.33, 44.96, 7.41] },
  { name: 'Chieri', region: 'Piemonte', province: 'TO', bbox: [44.99, 7.83, 45.07, 7.91] },
  { name: 'Bra', region: 'Piemonte', province: 'CN', bbox: [44.69, 7.85, 44.77, 7.93] },
  { name: 'Alba', region: 'Piemonte', province: 'CN', bbox: [44.69, 8.01, 44.77, 8.09] },
  { name: 'Fossano', region: 'Piemonte', province: 'CN', bbox: [44.54, 7.72, 44.62, 7.80] },
  { name: 'Savigliano', region: 'Piemonte', province: 'CN', bbox: [44.64, 7.65, 44.72, 7.73] },
  { name: 'Tortona', region: 'Piemonte', province: 'AL', bbox: [44.89, 8.86, 44.97, 8.94] },
  { name: 'Acqui Terme', region: 'Piemonte', province: 'AL', bbox: [44.67, 8.46, 44.75, 8.54] },
  { name: 'Casale Monferrato', region: 'Piemonte', province: 'AL', bbox: [45.13, 8.44, 45.21, 8.52] },

  // === TOSCANA (ampliamento) ===
  { name: 'Empoli', region: 'Toscana', province: 'FI', bbox: [43.71, 10.93, 43.79, 11.01] },
  { name: 'Sesto Fiorentino', region: 'Toscana', province: 'FI', bbox: [43.82, 11.19, 43.90, 11.27] },
  { name: 'Scandicci', region: 'Toscana', province: 'FI', bbox: [43.74, 11.18, 43.82, 11.26] },
  { name: 'Campi Bisenzio', region: 'Toscana', province: 'FI', bbox: [43.82, 11.13, 43.90, 11.21] },
  { name: 'Pontassieve', region: 'Toscana', province: 'FI', bbox: [43.77, 11.43, 43.85, 11.51] },
  { name: 'Poggibonsi', region: 'Toscana', province: 'SI', bbox: [43.46, 11.14, 43.54, 11.22] },
  { name: 'Colle di Val d\'Elsa', region: 'Toscana', province: 'SI', bbox: [43.42, 11.11, 43.50, 11.19] },
  { name: 'Montepulciano', region: 'Toscana', province: 'SI', bbox: [43.09, 11.77, 43.17, 11.85] },
  { name: 'Chiusi', region: 'Toscana', province: 'SI', bbox: [42.99, 11.93, 43.07, 12.01] },
  { name: 'Piombino', region: 'Toscana', province: 'LI', bbox: [42.91, 10.52, 42.99, 10.60] },
  { name: 'Portoferraio', region: 'Toscana', province: 'LI', bbox: [42.80, 10.31, 42.88, 10.39] },
  { name: 'Follonica', region: 'Toscana', province: 'GR', bbox: [42.91, 10.74, 42.99, 10.82] },
  { name: 'Massa', region: 'Toscana', province: 'MS', bbox: [44.01, 10.13, 44.09, 10.21] },
  { name: 'Viareggio', region: 'Toscana', province: 'LU', bbox: [43.86, 10.22, 43.94, 10.30] },
  { name: 'Forte dei Marmi', region: 'Toscana', province: 'LU', bbox: [43.96, 10.16, 44.04, 10.24] },

  // === EMILIA-ROMAGNA (ampliamento) ===
  { name: 'Carpi', region: 'Emilia-Romagna', province: 'MO', bbox: [44.78, 10.87, 44.86, 10.95] },
  { name: 'Sassuolo', region: 'Emilia-Romagna', province: 'MO', bbox: [44.53, 10.78, 44.61, 10.86] },
  { name: 'Castelfranco Emilia', region: 'Emilia-Romagna', province: 'MO', bbox: [44.59, 11.04, 44.67, 11.12] },
  { name: 'Mirandola', region: 'Emilia-Romagna', province: 'MO', bbox: [44.88, 11.06, 44.96, 11.14] },
  { name: 'Fidenza', region: 'Emilia-Romagna', province: 'PR', bbox: [44.86, 10.06, 44.94, 10.14] },
  { name: 'Salsomaggiore Terme', region: 'Emilia-Romagna', province: 'PR', bbox: [44.81, 9.97, 44.89, 10.05] },
  { name: 'Riccione', region: 'Emilia-Romagna', province: 'RN', bbox: [43.99, 12.65, 44.07, 12.73] },
  { name: 'Misano Adriatico', region: 'Emilia-Romagna', province: 'RN', bbox: [44.01, 12.69, 44.09, 12.77] },
  { name: 'Cattolica', region: 'Emilia-Romagna', province: 'RN', bbox: [43.96, 12.73, 44.04, 12.81] },
  { name: 'Lugo', region: 'Emilia-Romagna', province: 'RA', bbox: [44.41, 11.90, 44.49, 11.98] },
  { name: 'Faenza', region: 'Emilia-Romagna', province: 'RA', bbox: [44.28, 11.88, 44.36, 11.96] },
  { name: 'Comacchio', region: 'Emilia-Romagna', province: 'FE', bbox: [44.69, 12.18, 44.77, 12.26] },
  { name: 'Cento', region: 'Emilia-Romagna', province: 'FE', bbox: [44.72, 11.28, 44.80, 11.36] },
  { name: 'Argenta', region: 'Emilia-Romagna', province: 'FE', bbox: [44.61, 11.83, 44.69, 11.91] },

  // === LAZIO (ampliamento) ===
  { name: 'Frosinone', region: 'Lazio', province: 'FR', bbox: [41.63, 13.33, 41.71, 13.41] },
  { name: 'Cassino', region: 'Lazio', province: 'FR', bbox: [41.48, 13.82, 41.56, 13.90] },
  { name: 'Rieti', region: 'Lazio', province: 'RI', bbox: [42.40, 12.85, 42.48, 12.93] },
  { name: 'Formia', region: 'Lazio', province: 'LT', bbox: [41.25, 13.61, 41.33, 13.69] },
  { name: 'Gaeta', region: 'Lazio', province: 'LT', bbox: [41.20, 13.56, 41.28, 13.64] },
  { name: 'Terracina', region: 'Lazio', province: 'LT', bbox: [41.28, 13.24, 41.36, 13.32] },
  { name: 'Aprilia', region: 'Lazio', province: 'LT', bbox: [41.60, 12.64, 41.68, 12.72] },
  { name: 'Anzio', region: 'Lazio', province: 'RM', bbox: [41.44, 12.60, 41.52, 12.68] },
  { name: 'Nettuno', region: 'Lazio', province: 'RM', bbox: [41.45, 12.65, 41.53, 12.73] },
  { name: 'Velletri', region: 'Lazio', province: 'RM', bbox: [41.68, 12.77, 41.76, 12.85] },
  { name: 'Albano Laziale', region: 'Lazio', province: 'RM', bbox: [41.72, 12.65, 41.80, 12.73] },
  { name: 'Tivoli', region: 'Lazio', province: 'RM', bbox: [41.96, 12.79, 42.04, 12.87] },
  { name: 'Colleferro', region: 'Lazio', province: 'RM', bbox: [41.71, 13.00, 41.79, 13.08] },
  { name: 'Monterotondo', region: 'Lazio', province: 'RM', bbox: [42.04, 12.61, 42.12, 12.69] },

  // === SICILIA (ampliamento) ===
  { name: 'Enna', region: 'Sicilia', province: 'EN', bbox: [37.56, 14.27, 37.64, 14.35] },
  { name: 'Noto', region: 'Sicilia', province: 'SR', bbox: [36.89, 15.06, 36.97, 15.14] },
  { name: 'Avola', region: 'Sicilia', province: 'SR', bbox: [36.90, 15.13, 36.98, 15.21] },
  { name: 'Augusta', region: 'Sicilia', province: 'SR', bbox: [37.22, 15.21, 37.30, 15.29] },
  { name: 'Lentini', region: 'Sicilia', province: 'SR', bbox: [37.27, 14.99, 37.35, 15.07] },
  { name: 'Caltagirone', region: 'Sicilia', province: 'CT', bbox: [37.23, 14.51, 37.31, 14.59] },
  { name: 'Paternò', region: 'Sicilia', province: 'CT', bbox: [37.56, 14.89, 37.64, 14.97] },
  { name: 'Adrano', region: 'Sicilia', province: 'CT', bbox: [37.66, 14.82, 37.74, 14.90] },
  { name: 'Misterbianco', region: 'Sicilia', province: 'CT', bbox: [37.51, 15.00, 37.59, 15.08] },
  { name: 'Sciacca', region: 'Sicilia', province: 'AG', bbox: [37.50, 13.07, 37.58, 13.15] },
  { name: 'Licata', region: 'Sicilia', province: 'AG', bbox: [37.10, 13.93, 37.18, 14.01] },
  { name: 'Canicattì', region: 'Sicilia', province: 'AG', bbox: [37.35, 13.83, 37.43, 13.91] },
  { name: 'Alcamo', region: 'Sicilia', province: 'TP', bbox: [37.97, 12.95, 38.05, 13.03] },
  { name: 'Castelvetrano', region: 'Sicilia', province: 'TP', bbox: [37.67, 12.79, 37.75, 12.87] },
  { name: 'Partanna', region: 'Sicilia', province: 'TP', bbox: [37.72, 12.88, 37.80, 12.96] },
  { name: 'Campobello di Mazara', region: 'Sicilia', province: 'TP', bbox: [37.63, 12.74, 37.71, 12.82] },
  { name: 'Termini Imerese', region: 'Sicilia', province: 'PA', bbox: [37.98, 13.69, 38.06, 13.77] },
  { name: 'Misilmeri', region: 'Sicilia', province: 'PA', bbox: [38.03, 13.44, 38.11, 13.52] },

  // === LIGURIA (ampliamento) ===
  { name: 'Imperia', region: 'Liguria', province: 'IM', bbox: [43.88, 8.02, 43.96, 8.10] },
  { name: 'Sanremo', region: 'Liguria', province: 'IM', bbox: [43.81, 7.77, 43.89, 7.85] },
  { name: 'Ventimiglia', region: 'Liguria', province: 'IM', bbox: [43.78, 7.60, 43.86, 7.68] },
  { name: 'Bordighera', region: 'Liguria', province: 'IM', bbox: [43.77, 7.66, 43.85, 7.74] },
  { name: 'Rapallo', region: 'Liguria', province: 'GE', bbox: [44.35, 9.22, 44.43, 9.30] },
  { name: 'Chiavari', region: 'Liguria', province: 'GE', bbox: [44.31, 9.32, 44.39, 9.40] },
  { name: 'Sestri Levante', region: 'Liguria', province: 'GE', bbox: [44.27, 9.39, 44.35, 9.47] },
  { name: 'Sarzana', region: 'Liguria', province: 'SP', bbox: [44.11, 9.96, 44.19, 10.04] },

  // === MOLISE ===
  { name: 'Campobasso', region: 'Molise', province: 'CB', bbox: [41.55, 14.64, 41.63, 14.72] },
  { name: 'Isernia', region: 'Molise', province: 'IS', bbox: [41.59, 14.22, 41.67, 14.30] },
  { name: 'Termoli', region: 'Molise', province: 'CB', bbox: [42.00, 14.99, 42.08, 15.07] },
  { name: 'Venafro', region: 'Molise', province: 'IS', bbox: [41.48, 14.03, 41.56, 14.11] },
  { name: 'Bojano', region: 'Molise', province: 'CB', bbox: [41.48, 14.47, 41.56, 14.55] },

  // === VALLE D'AOSTA ===
  { name: 'Aosta', region: "Valle d'Aosta", province: 'AO', bbox: [45.72, 7.29, 45.80, 7.37] },
  { name: 'Châtillon', region: "Valle d'Aosta", province: 'AO', bbox: [45.74, 7.60, 45.82, 7.68] },
  { name: 'Saint-Vincent', region: "Valle d'Aosta", province: 'AO', bbox: [45.74, 7.63, 45.82, 7.71] },
  { name: 'Courmayeur', region: "Valle d'Aosta", province: 'AO', bbox: [45.78, 6.97, 45.86, 7.05] },
];

// Stessa query batch del primo script
const BATCH_QUERY_TEMPLATE = (bboxStr) => `
[out:json][timeout:180];
(
  node["amenity"~"restaurant|cafe|bar|pub|fast_food|ice_cream|nightclub|bank|pharmacy|dentist|doctors|clinic|hospital|veterinary|fuel|post_office|car_wash|car_rental|laundry|driving_school|language_school|music_school|school|kindergarten|library"](${bboxStr});
  way["amenity"~"restaurant|cafe|bar|pub|fast_food|ice_cream|nightclub|bank|pharmacy|dentist|doctors|clinic|hospital|veterinary|fuel|post_office|car_wash|car_rental|laundry|driving_school|language_school|music_school|school|kindergarten|library"](${bboxStr});
  node["shop"~"supermarket|convenience|bakery|butcher|greengrocer|clothes|shoes|jewelry|hairdresser|beauty|cosmetics|hardware|furniture|florist|electronics|computer|mobile_phone|books|stationery|newsagent|pharmacy|optician|sports|bicycle|pet|car|car_repair|tobacco|alcohol|seafood|cheese|deli|gift|toys|antiques|second_hand|fabric|tailor|watches|bag|photo|music|art|medical_supply"](${bboxStr});
  way["shop"~"supermarket|convenience|bakery|butcher|greengrocer|clothes|shoes|jewelry|hairdresser|beauty|cosmetics|hardware|furniture|florist|electronics|computer|mobile_phone|books|stationery|newsagent|pharmacy|optician|sports|bicycle|pet|car|car_repair|tobacco|alcohol|seafood|cheese|deli|gift|toys|antiques|second_hand|fabric|tailor|watches|bag|photo|music|art|medical_supply"](${bboxStr});
  node["tourism"~"hotel|guest_house|hostel|motel|apartment|camp_site"](${bboxStr});
  way["tourism"~"hotel|guest_house|hostel|motel|apartment|camp_site"](${bboxStr});
  node["leisure"~"fitness_centre|sports_centre|swimming_pool|dance"](${bboxStr});
  way["leisure"~"fitness_centre|sports_centre|swimming_pool|dance"](${bboxStr});
  node["office"~"lawyer|accountant|architect|engineer|estate_agent|insurance|notary|travel_agent|it"](${bboxStr});
  way["office"~"lawyer|accountant|architect|engineer|estate_agent|insurance|notary|travel_agent|it"](${bboxStr});
  node["craft"~"carpenter|electrician|plumber|painter|shoemaker|tailor|bakery|jeweller|printing"](${bboxStr});
  way["craft"~"carpenter|electrician|plumber|painter|shoemaker|tailor|bakery|jeweller|printing"](${bboxStr});
  node["healthcare"~"laboratory|physiotherapist|psychotherapist"](${bboxStr});
  way["healthcare"~"laboratory|physiotherapist|psychotherapist"](${bboxStr});
);
out center tags;
`;

const OSM_CATEGORY_MAP = {
  'restaurant': 'Ristoranti', 'cafe': 'Bar e Caffè', 'bar': 'Bar e Caffè', 'pub': 'Pub e Locali',
  'fast_food': 'Fast Food', 'ice_cream': 'Gelaterie', 'nightclub': 'Discoteche', 'bank': 'Banche',
  'pharmacy': 'Farmacie', 'dentist': 'Dentisti', 'doctors': 'Medici', 'clinic': 'Cliniche',
  'hospital': 'Ospedali', 'veterinary': 'Veterinari', 'fuel': 'Benzinai', 'post_office': 'Uffici Postali',
  'car_wash': 'Autolavaggi', 'car_rental': 'Autonoleggi', 'laundry': 'Lavanderie',
  'driving_school': 'Autoscuole', 'language_school': 'Scuole di Lingue', 'music_school': 'Scuole di Musica',
  'school': 'Scuole', 'kindergarten': 'Asili', 'library': 'Biblioteche',
  'supermarket': 'Supermercati', 'convenience': 'Alimentari', 'bakery': 'Panifici e Pasticcerie',
  'butcher': 'Macellerie', 'greengrocer': 'Frutta e Verdura', 'clothes': 'Abbigliamento',
  'shoes': 'Calzature', 'jewelry': 'Gioiellerie', 'hairdresser': 'Parrucchieri e Barbieri',
  'beauty': 'Centri Estetici', 'cosmetics': 'Profumerie', 'hardware': 'Ferramenta',
  'furniture': 'Arredamento', 'florist': 'Fioristi', 'electronics': 'Elettronica',
  'computer': 'Negozi di Computer', 'mobile_phone': 'Negozi di Telefonia', 'books': 'Librerie',
  'stationery': 'Cartolerie', 'newsagent': 'Edicole', 'optician': 'Ottici',
  'sports': 'Negozi di Sport', 'bicycle': 'Negozi di Biciclette', 'pet': 'Negozi per Animali',
  'car': 'Concessionarie Auto', 'car_repair': 'Autofficine', 'tobacco': 'Tabaccherie',
  'alcohol': 'Enoteche', 'seafood': 'Pescherie', 'cheese': 'Formaggerie', 'deli': 'Gastronomie',
  'gift': 'Regali', 'toys': 'Giocattoli', 'antiques': 'Antiquari', 'second_hand': 'Usato',
  'fabric': 'Tessuti', 'tailor': 'Sarti', 'watches': 'Orologerie', 'bag': 'Pelletterie',
  'photo': 'Fotografia', 'music': 'Negozi di Musica', 'art': "Gallerie d'Arte", 'medical_supply': 'Sanitaria',
  'hotel': 'Hotel', 'guest_house': 'B&B', 'hostel': 'Ostelli', 'motel': 'Motel',
  'apartment': 'Appartamenti', 'camp_site': 'Campeggi',
  'fitness_centre': 'Palestre', 'sports_centre': 'Centri Sportivi', 'swimming_pool': 'Piscine',
  'dance': 'Scuole di Danza',
  'lawyer': 'Avvocati', 'accountant': 'Commercialisti', 'architect': 'Architetti',
  'engineer': 'Ingegneri', 'estate_agent': 'Agenzie Immobiliari', 'insurance': 'Assicurazioni',
  'notary': 'Notai', 'travel_agent': 'Agenzie di Viaggio', 'it': 'Informatica',
  'carpenter': 'Falegnami', 'electrician': 'Elettricisti', 'plumber': 'Idraulici',
  'painter': 'Imbianchini', 'shoemaker': 'Calzolai', 'jeweller': 'Orefici', 'printing': 'Tipografie',
  'laboratory': 'Laboratori Analisi', 'physiotherapist': 'Fisioterapisti', 'psychotherapist': 'Psicologi',
};

let categoryCache = {};
let totalImported = 0;
let startTime = Date.now();

async function loadAllCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(cat => { categoryCache[cat.name] = cat.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie`);
}

function getCategoryFromElement(tags) {
  for (const field of ['amenity', 'shop', 'tourism', 'leisure', 'office', 'craft', 'healthcare']) {
    const val = tags[field];
    if (val && OSM_CATEGORY_MAP[val] && categoryCache[OSM_CATEGORY_MAP[val]]) {
      return categoryCache[OSM_CATEGORY_MAP[val]];
    }
  }
  return null;
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

function fetchOverpass(query) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'overpass-api.de', path: '/api/interpreter', method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Content-Length': Buffer.byteLength(query), 'User-Agent': 'ItalianBusinessDirectory/2.1' }
    };
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        if (res.statusCode === 429) { reject(new Error('RATE_LIMIT')); return; }
        if (res.statusCode >= 400) { reject(new Error(`HTTP ${res.statusCode}`)); return; }
        try { resolve(JSON.parse(data)); } catch (e) { reject(new Error('JSON parse')); }
      });
    });
    req.on('error', reject);
    req.setTimeout(150000, () => { req.destroy(); reject(new Error('Timeout')); });
    req.write(query);
    req.end();
  });
}

async function queryCity(city) {
  const bboxStr = `${city.bbox[0]},${city.bbox[1]},${city.bbox[2]},${city.bbox[3]}`;
  for (let retry = 0; retry < 3; retry++) {
    try {
      const data = await fetchOverpass(BATCH_QUERY_TEMPLATE(bboxStr));
      return data.elements || [];
    } catch (err) {
      if (err.message === 'RATE_LIMIT') { console.log('   Rate limit - attendo 90s...'); await sleep(90000); retry--; continue; }
      if (retry < 2) { await sleep((retry + 1) * 20000); }
    }
  }
  return [];
}

async function importCity(city, idx, total) {
  process.stdout.write(`[${idx}/${total}] ${city.name} (${city.region})... `);
  const elements = await queryCity(city);
  if (!elements.length) { console.log('0'); return 0; }

  const records = [];
  const seen = new Set();

  for (const el of elements) {
    const tags = el.tags || {};
    if (!tags.name) continue;
    const categoryId = getCategoryFromElement(tags);
    if (!categoryId) continue;
    const lat = el.lat || el.center?.lat;
    const lon = el.lon || el.center?.lon;
    if (!lat || !lon) continue;

    const cityName = (tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || city.name).substring(0, 100);
    const street = tags['addr:street'] || '';
    const houseNum = tags['addr:housenumber'] || '';
    const streetFull = street ? (houseNum ? `${street}, ${houseNum}` : street) : null;
    const key = `${tags.name}|${cityName}|${streetFull || ''}`;
    if (seen.has(key)) continue;
    seen.add(key);

    records.push({
      name: tags.name.substring(0, 200), category_id: categoryId,
      street: streetFull, city: cityName, province: city.province, region: city.region,
      postal_code: tags['addr:postcode'] || null, country: 'Italia',
      latitude: lat, longitude: lon,
      phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, '').substring(0, 50) || null,
      email: (tags.email || tags['contact:email'] || '').substring(0, 200) || null,
      website: (tags.website || tags['contact:website'] || '').substring(0, 500) || null,
      business_hours: tags.opening_hours || null,
      is_claimed: false, approval_status: 'approved',
    });
  }

  if (!records.length) { console.log('0 cat valide'); return 0; }

  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const chunk = records.slice(i, i + 200);
    const { error } = await supabase.from('unclaimed_business_locations').insert(chunk, { defaultToNull: true });
    if (!error) inserted += chunk.length;
  }

  totalImported += inserted;
  const mins = ((Date.now() - startTime) / 60000).toFixed(1);
  console.log(`${inserted} inseriti | Totale: ${totalImported.toLocaleString()} (${mins}min)`);
  return inserted;
}

async function main() {
  console.log('\n============================================================');
  console.log(' ESPANSIONE OSM - NUOVE CITTA\' ITALIANE');
  console.log(`  Citta\' da aggiungere: ${EXTRA_CITIES.length}`);
  console.log(`  Avvio: ${new Date().toLocaleTimeString()}`);
  console.log('============================================================\n');

  await loadAllCategories();

  for (let i = 0; i < EXTRA_CITIES.length; i++) {
    await importCity(EXTRA_CITIES[i], i + 1, EXTRA_CITIES.length);
    await sleep(4000);
    if ((i + 1) % 25 === 0) {
      const mins = ((Date.now() - startTime) / 60000).toFixed(0);
      console.log(`\n--- RIEPILOGO: ${totalImported.toLocaleString()} nuove attivita\' in ${mins} minuti ---\n`);
    }
  }

  console.log(`\n=== COMPLETATO: ${totalImported.toLocaleString()} attivita\' aggiunte ===\n`);
}

main().catch(console.error);
