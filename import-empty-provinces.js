/**
 * Importazione mirata province vuote o con poche attività
 * Priorità: VB, BL, RO, PN, GO, IM, MS, AP, FM, FR, RI, AV, EN, NU, OR, OT
 * + province con < 500 attività: VV, SO, BI, LC, CL, VT, TE, IS, GR, CZ, RC, BN, MC
 */
import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import https from 'https';

config();
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

// Città focalizzate sulle province vuote/scarse
// bbox formato: [lat_sud, lon_ovest, lat_nord, lon_est]
const CITIES = [
  // ===== VB - Verbano-Cusio-Ossola (0 attività) =====
  { name: 'Verbania', region: 'Piemonte', province: 'VB', bbox: [45.90, 8.52, 45.96, 8.60] },
  { name: 'Domodossola', region: 'Piemonte', province: 'VB', bbox: [46.08, 8.26, 46.14, 8.32] },
  { name: 'Omegna', region: 'Piemonte', province: 'VB', bbox: [45.86, 8.38, 45.92, 8.44] },
  { name: 'Gravellona Toce', region: 'Piemonte', province: 'VB', bbox: [45.92, 8.42, 45.96, 8.48] },
  { name: 'Stresa', region: 'Piemonte', province: 'VB', bbox: [45.86, 8.52, 45.90, 8.56] },
  { name: 'Arona', region: 'Piemonte', province: 'NO', bbox: [45.74, 8.54, 45.78, 8.60] },
  { name: 'Borgomanero', region: 'Piemonte', province: 'NO', bbox: [45.68, 8.44, 45.72, 8.50] },
  { name: 'Cannobio', region: 'Piemonte', province: 'VB', bbox: [46.04, 8.68, 46.08, 8.74] },
  { name: 'Pallanza', region: 'Piemonte', province: 'VB', bbox: [45.92, 8.52, 45.96, 8.58] },

  // ===== BL - Belluno (0 attività) =====
  { name: 'Belluno', region: 'Veneto', province: 'BL', bbox: [46.12, 12.18, 46.18, 12.26] },
  { name: 'Feltre', region: 'Veneto', province: 'BL', bbox: [46.00, 11.88, 46.04, 11.94] },
  { name: 'Cortina d Ampezzo', region: 'Veneto', province: 'BL', bbox: [46.52, 12.12, 46.56, 12.18] },
  { name: 'Sedico', region: 'Veneto', province: 'BL', bbox: [46.08, 12.08, 46.14, 12.14] },
  { name: 'Longarone', region: 'Veneto', province: 'BL', bbox: [46.24, 12.28, 46.30, 12.34] },
  { name: 'Agordo', region: 'Veneto', province: 'BL', bbox: [46.26, 12.02, 46.30, 12.08] },
  { name: 'Pieve di Cadore', region: 'Veneto', province: 'BL', bbox: [46.42, 12.36, 46.46, 12.42] },
  { name: 'Cesiomaggiore', region: 'Veneto', province: 'BL', bbox: [46.06, 12.00, 46.10, 12.06] },

  // ===== RO - Rovigo (0 attività) =====
  { name: 'Rovigo', region: 'Veneto', province: 'RO', bbox: [45.04, 11.76, 45.10, 11.84] },
  { name: 'Adria', region: 'Veneto', province: 'RO', bbox: [45.04, 12.04, 45.08, 12.10] },
  { name: 'Porto Viro', region: 'Veneto', province: 'RO', bbox: [44.96, 12.26, 45.00, 12.32] },
  { name: 'Lendinara', region: 'Veneto', province: 'RO', bbox: [45.08, 11.58, 45.12, 11.64] },
  { name: 'Badia Polesine', region: 'Veneto', province: 'RO', bbox: [45.08, 11.50, 45.12, 11.56] },
  { name: 'Occhiobello', region: 'Veneto', province: 'RO', bbox: [44.92, 11.58, 44.96, 11.64] },

  // ===== PN - Pordenone (0 attività) =====
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.94, 12.62, 46.00, 12.70] },
  { name: 'Sacile', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.94, 12.48, 45.98, 12.54] },
  { name: 'Maniago', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [46.14, 12.70, 46.18, 12.76] },
  { name: 'Spilimbergo', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [46.06, 12.86, 46.10, 12.92] },
  { name: 'San Vito al Tagliamento', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [45.90, 12.84, 45.94, 12.90] },
  { name: 'Aviano', region: 'Friuli-Venezia Giulia', province: 'PN', bbox: [46.06, 12.56, 46.10, 12.62] },

  // ===== GO - Gorizia (0 attività) =====
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.92, 13.60, 45.96, 13.66] },
  { name: 'Monfalcone', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.78, 13.52, 45.82, 13.58] },
  { name: 'Gradisca d Isonzo', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.88, 13.50, 45.92, 13.56] },
  { name: 'Ronchi dei Legionari', region: 'Friuli-Venezia Giulia', province: 'GO', bbox: [45.82, 13.54, 45.86, 13.60] },

  // ===== IM - Imperia (0 attività) =====
  { name: 'Imperia', region: 'Liguria', province: 'IM', bbox: [43.86, 7.98, 43.92, 8.04] },
  { name: 'Sanremo', region: 'Liguria', province: 'IM', bbox: [43.80, 7.74, 43.86, 7.82] },
  { name: 'Ventimiglia', region: 'Liguria', province: 'IM', bbox: [43.78, 7.58, 43.84, 7.66] },
  { name: 'Bordighera', region: 'Liguria', province: 'IM', bbox: [43.78, 7.66, 43.82, 7.72] },
  { name: 'Taggia', region: 'Liguria', province: 'IM', bbox: [43.84, 7.84, 43.88, 7.90] },
  { name: 'Diano Marina', region: 'Liguria', province: 'IM', bbox: [43.90, 8.06, 43.94, 8.12] },
  { name: 'Alassio', region: 'Liguria', province: 'SV', bbox: [44.00, 8.16, 44.04, 8.22] },
  { name: 'Dolcedo', region: 'Liguria', province: 'IM', bbox: [43.88, 7.92, 43.92, 7.98] },

  // ===== MS - Massa-Carrara (0 attività) =====
  { name: 'Massa', region: 'Toscana', province: 'MS', bbox: [44.00, 10.08, 44.06, 10.14] },
  { name: 'Carrara', region: 'Toscana', province: 'MS', bbox: [44.04, 10.06, 44.10, 10.12] },
  { name: 'Pontremoli', region: 'Toscana', province: 'MS', bbox: [44.36, 9.86, 44.40, 9.92] },
  { name: 'Aulla', region: 'Toscana', province: 'MS', bbox: [44.20, 9.96, 44.24, 10.02] },
  { name: 'Fosdinovo', region: 'Toscana', province: 'MS', bbox: [44.12, 9.98, 44.16, 10.04] },
  { name: 'Villafranca in Lunigiana', region: 'Toscana', province: 'MS', bbox: [44.26, 9.94, 44.30, 10.00] },

  // ===== AP - Ascoli Piceno (0 attività) =====
  { name: 'Ascoli Piceno', region: 'Marche', province: 'AP', bbox: [42.84, 13.56, 42.90, 13.62] },
  { name: 'San Benedetto del Tronto', region: 'Marche', province: 'AP', bbox: [42.94, 13.86, 43.00, 13.92] },
  { name: 'Monteprandone', region: 'Marche', province: 'AP', bbox: [42.92, 13.84, 42.96, 13.90] },
  { name: 'Offida', region: 'Marche', province: 'AP', bbox: [42.92, 13.68, 42.96, 13.74] },
  { name: 'Acquaviva Picena', region: 'Marche', province: 'AP', bbox: [42.96, 13.80, 43.00, 13.86] },

  // ===== FM - Fermo (0 attività) =====
  { name: 'Fermo', region: 'Marche', province: 'FM', bbox: [43.14, 13.70, 43.20, 13.76] },
  { name: 'Porto San Giorgio', region: 'Marche', province: 'FM', bbox: [43.18, 13.78, 43.22, 13.84] },
  { name: 'Porto Sant Elpidio', region: 'Marche', province: 'FM', bbox: [43.24, 13.74, 43.28, 13.80] },
  { name: 'Montegranaro', region: 'Marche', province: 'FM', bbox: [43.24, 13.62, 43.28, 13.68] },
  { name: 'Monteurano', region: 'Marche', province: 'FM', bbox: [43.26, 13.60, 43.30, 13.66] },

  // ===== FR - Frosinone (0 attività) =====
  { name: 'Frosinone', region: 'Lazio', province: 'FR', bbox: [41.62, 13.32, 41.68, 13.38] },
  { name: 'Cassino', region: 'Lazio', province: 'FR', bbox: [41.48, 13.82, 41.54, 13.88] },
  { name: 'Sora', region: 'Lazio', province: 'FR', bbox: [41.70, 13.60, 41.76, 13.66] },
  { name: 'Alatri', region: 'Lazio', province: 'FR', bbox: [41.72, 13.34, 41.76, 13.40] },
  { name: 'Anagni', region: 'Lazio', province: 'FR', bbox: [41.74, 13.14, 41.78, 13.20] },
  { name: 'Ceccano', region: 'Lazio', province: 'FR', bbox: [41.56, 13.32, 41.60, 13.38] },
  { name: 'Ferentino', region: 'Lazio', province: 'FR', bbox: [41.68, 13.22, 41.72, 13.28] },
  { name: 'Pontecorvo', region: 'Lazio', province: 'FR', bbox: [41.44, 13.64, 41.48, 13.70] },

  // ===== RI - Rieti (0 attività) =====
  { name: 'Rieti', region: 'Lazio', province: 'RI', bbox: [42.38, 12.84, 42.44, 12.90] },
  { name: 'Monterotondo', region: 'Lazio', province: 'RM', bbox: [42.04, 12.60, 42.08, 12.66] },
  { name: 'Fara in Sabina', region: 'Lazio', province: 'RI', bbox: [42.20, 12.72, 42.24, 12.78] },
  { name: 'Poggio Mirteto', region: 'Lazio', province: 'RI', bbox: [42.26, 12.68, 42.30, 12.74] },
  { name: 'Magliano Sabina', region: 'Lazio', province: 'RI', bbox: [42.36, 12.48, 42.40, 12.54] },
  { name: 'Borgorose', region: 'Lazio', province: 'RI', bbox: [42.20, 13.24, 42.24, 13.30] },

  // ===== AV - Avellino (0 attività) =====
  { name: 'Avellino', region: 'Campania', province: 'AV', bbox: [40.90, 14.78, 40.96, 14.84] },
  { name: 'Ariano Irpino', region: 'Campania', province: 'AV', bbox: [41.14, 15.06, 41.20, 15.12] },
  { name: 'Atripalda', region: 'Campania', province: 'AV', bbox: [40.92, 14.82, 40.96, 14.88] },
  { name: 'Montoro', region: 'Campania', province: 'AV', bbox: [40.80, 14.74, 40.84, 14.80] },
  { name: 'Nola', region: 'Campania', province: 'NA', bbox: [40.92, 14.52, 40.96, 14.58] },
  { name: 'Solofra', region: 'Campania', province: 'AV', bbox: [40.84, 14.84, 40.88, 14.90] },

  // ===== EN - Enna (0 attività) =====
  { name: 'Enna', region: 'Sicilia', province: 'EN', bbox: [37.54, 14.24, 37.58, 14.30] },
  { name: 'Piazza Armerina', region: 'Sicilia', province: 'EN', bbox: [37.36, 14.36, 37.40, 14.42] },
  { name: 'Nicosia', region: 'Sicilia', province: 'EN', bbox: [37.74, 14.38, 37.78, 14.44] },
  { name: 'Leonforte', region: 'Sicilia', province: 'EN', bbox: [37.62, 14.38, 37.66, 14.44] },
  { name: 'Agira', region: 'Sicilia', province: 'EN', bbox: [37.64, 14.52, 37.68, 14.58] },

  // ===== NU - Nuoro (0 attività) =====
  { name: 'Nuoro', region: 'Sardegna', province: 'NU', bbox: [40.32, 9.32, 40.38, 9.38] },
  { name: 'Siniscola', region: 'Sardegna', province: 'NU', bbox: [40.56, 9.68, 40.60, 9.74] },
  { name: 'Orosei', region: 'Sardegna', province: 'NU', bbox: [40.36, 9.68, 40.40, 9.74] },
  { name: 'Dorgali', region: 'Sardegna', province: 'NU', bbox: [40.28, 9.58, 40.32, 9.64] },
  { name: 'Orgosolo', region: 'Sardegna', province: 'NU', bbox: [40.20, 9.34, 40.24, 9.40] },
  { name: 'Fonni', region: 'Sardegna', province: 'NU', bbox: [40.12, 9.24, 40.16, 9.30] },
  { name: 'Bitti', region: 'Sardegna', province: 'NU', bbox: [40.48, 9.36, 40.52, 9.42] },

  // ===== OR - Oristano (0 attività) =====
  { name: 'Oristano', region: 'Sardegna', province: 'OR', bbox: [39.90, 8.58, 39.96, 8.64] },
  { name: 'Ghilarza', region: 'Sardegna', province: 'OR', bbox: [40.12, 8.82, 40.16, 8.88] },
  { name: 'Bosa', region: 'Sardegna', province: 'OR', bbox: [40.30, 8.50, 40.34, 8.56] },
  { name: 'Cabras', region: 'Sardegna', province: 'OR', bbox: [39.92, 8.52, 39.96, 8.58] },
  { name: 'Terralba', region: 'Sardegna', province: 'OR', bbox: [39.72, 8.62, 39.76, 8.68] },
  { name: 'Ales', region: 'Sardegna', province: 'OR', bbox: [39.76, 8.80, 39.80, 8.86] },

  // ===== OT - Olbia-Tempio (0 attività) =====
  { name: 'Olbia', region: 'Sardegna', province: 'OT', bbox: [40.90, 9.48, 40.96, 9.56] },
  { name: 'Tempio Pausania', region: 'Sardegna', province: 'OT', bbox: [40.90, 9.10, 40.94, 9.16] },
  { name: 'Arzachena', region: 'Sardegna', province: 'OT', bbox: [41.06, 9.38, 41.10, 9.44] },
  { name: 'Porto Cervo', region: 'Sardegna', province: 'OT', bbox: [41.12, 9.52, 41.16, 9.58] },
  { name: 'Palau', region: 'Sardegna', province: 'OT', bbox: [41.18, 9.36, 41.22, 9.42] },
  { name: 'Santa Teresa Gallura', region: 'Sardegna', province: 'OT', bbox: [41.22, 9.18, 41.26, 9.24] },
  { name: 'La Maddalena', region: 'Sardegna', province: 'OT', bbox: [41.22, 9.38, 41.26, 9.44] },

  // ===== VV - Vibo Valentia (6 attività) =====
  { name: 'Vibo Valentia', region: 'Calabria', province: 'VV', bbox: [38.66, 16.08, 38.72, 16.14] },
  { name: 'Tropea', region: 'Calabria', province: 'VV', bbox: [38.66, 15.88, 38.70, 15.94] },
  { name: 'Pizzo', region: 'Calabria', province: 'VV', bbox: [38.72, 16.16, 38.76, 16.22] },
  { name: 'Serra San Bruno', region: 'Calabria', province: 'VV', bbox: [38.54, 16.32, 38.58, 16.38] },
  { name: 'Mileto', region: 'Calabria', province: 'VV', bbox: [38.60, 16.06, 38.64, 16.12] },
  { name: 'Nicotera', region: 'Calabria', province: 'VV', bbox: [38.54, 15.92, 38.58, 15.98] },

  // ===== SO - Sondrio (21 attività) =====
  { name: 'Sondrio', region: 'Lombardia', province: 'SO', bbox: [46.16, 9.86, 46.22, 9.92] },
  { name: 'Tirano', region: 'Lombardia', province: 'SO', bbox: [46.20, 10.16, 46.24, 10.22] },
  { name: 'Bormio', region: 'Lombardia', province: 'SO', bbox: [46.46, 10.36, 46.50, 10.42] },
  { name: 'Morbegno', region: 'Lombardia', province: 'SO', bbox: [46.12, 9.56, 46.16, 9.62] },
  { name: 'Livigno', region: 'Lombardia', province: 'SO', bbox: [46.52, 10.12, 46.56, 10.18] },
  { name: 'Chiavenna', region: 'Lombardia', province: 'SO', bbox: [46.32, 9.40, 46.36, 9.46] },

  // ===== BI - Biella (64 attività) =====
  { name: 'Biella', region: 'Piemonte', province: 'BI', bbox: [45.54, 8.04, 45.60, 8.10] },
  { name: 'Cossato', region: 'Piemonte', province: 'BI', bbox: [45.56, 8.16, 45.60, 8.22] },
  { name: 'Gaglianico', region: 'Piemonte', province: 'BI', bbox: [45.54, 8.10, 45.58, 8.16] },
  { name: 'Candelo', region: 'Piemonte', province: 'BI', bbox: [45.54, 8.12, 45.58, 8.18] },
  { name: 'Trivero', region: 'Piemonte', province: 'BI', bbox: [45.68, 8.06, 45.72, 8.12] },
  { name: 'Vigliano Biellese', region: 'Piemonte', province: 'BI', bbox: [45.56, 8.08, 45.60, 8.14] },

  // ===== LC - Lecco (65 attività) =====
  { name: 'Lecco', region: 'Lombardia', province: 'LC', bbox: [45.84, 9.38, 45.90, 9.44] },
  { name: 'Merate', region: 'Lombardia', province: 'LC', bbox: [45.70, 9.42, 45.74, 9.48] },
  { name: 'Calolziocorte', region: 'Lombardia', province: 'LC', bbox: [45.80, 9.42, 45.84, 9.48] },
  { name: 'Missaglia', region: 'Lombardia', province: 'LC', bbox: [45.72, 9.34, 45.76, 9.40] },
  { name: 'Casatenovo', region: 'Lombardia', province: 'LC', bbox: [45.70, 9.32, 45.74, 9.38] },
  { name: 'Valmadrera', region: 'Lombardia', province: 'LC', bbox: [45.84, 9.36, 45.88, 9.42] },

  // ===== VT - Viterbo (137 attività) =====
  { name: 'Viterbo', region: 'Lazio', province: 'VT', bbox: [42.40, 12.06, 42.46, 12.12] },
  { name: 'Civita Castellana', region: 'Lazio', province: 'VT', bbox: [42.28, 12.40, 42.32, 12.46] },
  { name: 'Tarquinia', region: 'Lazio', province: 'VT', bbox: [42.24, 11.74, 42.28, 11.80] },
  { name: 'Montefiascone', region: 'Lazio', province: 'VT', bbox: [42.52, 11.98, 42.56, 12.04] },
  { name: 'Acquapendente', region: 'Lazio', province: 'VT', bbox: [42.74, 11.86, 42.78, 11.92] },
  { name: 'Orte', region: 'Lazio', province: 'VT', bbox: [42.46, 12.38, 42.50, 12.44] },
  { name: 'Vetralla', region: 'Lazio', province: 'VT', bbox: [42.32, 12.04, 42.36, 12.10] },

  // ===== TE - Teramo (164 attività) =====
  { name: 'Teramo', region: 'Abruzzo', province: 'TE', bbox: [42.66, 13.68, 42.72, 13.74] },
  { name: 'Giulianova', region: 'Abruzzo', province: 'TE', bbox: [42.74, 13.94, 42.78, 14.00] },
  { name: 'Roseto degli Abruzzi', region: 'Abruzzo', province: 'TE', bbox: [42.68, 14.00, 42.72, 14.06] },
  { name: 'Nereto', region: 'Abruzzo', province: 'TE', bbox: [42.82, 13.80, 42.86, 13.86] },
  { name: 'Atri', region: 'Abruzzo', province: 'TE', bbox: [42.58, 13.96, 42.62, 14.02] },
  { name: 'Notaresco', region: 'Abruzzo', province: 'TE', bbox: [42.64, 13.90, 42.68, 13.96] },
  { name: 'Alba Adriatica', region: 'Abruzzo', province: 'TE', bbox: [42.82, 13.92, 42.86, 13.98] },
  { name: 'Martinsicuro', region: 'Abruzzo', province: 'TE', bbox: [42.88, 13.90, 42.92, 13.96] },

  // ===== IS - Isernia (172 attività) =====
  { name: 'Isernia', region: 'Molise', province: 'IS', bbox: [41.58, 14.22, 41.62, 14.28] },
  { name: 'Venafro', region: 'Molise', province: 'IS', bbox: [41.48, 14.04, 41.52, 14.10] },
  { name: 'Agnone', region: 'Molise', province: 'IS', bbox: [41.80, 14.36, 41.84, 14.42] },
  { name: 'Frosolone', region: 'Molise', province: 'IS', bbox: [41.60, 14.44, 41.64, 14.50] },

  // ===== GR - Grosseto (191 attività) =====
  { name: 'Grosseto', region: 'Toscana', province: 'GR', bbox: [42.74, 11.08, 42.80, 11.14] },
  { name: 'Orbetello', region: 'Toscana', province: 'GR', bbox: [42.44, 11.18, 42.48, 11.24] },
  { name: 'Follonica', region: 'Toscana', province: 'GR', bbox: [42.90, 10.74, 42.94, 10.80] },
  { name: 'Massa Marittima', region: 'Toscana', province: 'GR', bbox: [43.04, 10.88, 43.08, 10.94] },
  { name: 'Pitigliano', region: 'Toscana', province: 'GR', bbox: [42.62, 11.66, 42.66, 11.72] },
  { name: 'Sorano', region: 'Toscana', province: 'GR', bbox: [42.68, 11.70, 42.72, 11.76] },
  { name: 'Manciano', region: 'Toscana', province: 'GR', bbox: [42.58, 11.52, 42.62, 11.58] },
  { name: 'Porto Santo Stefano', region: 'Toscana', province: 'GR', bbox: [42.44, 11.12, 42.48, 11.18] },

  // ===== CZ - Catanzaro (218 attività) =====
  { name: 'Catanzaro', region: 'Calabria', province: 'CZ', bbox: [38.88, 16.56, 38.94, 16.62] },
  { name: 'Lamezia Terme', region: 'Calabria', province: 'CZ', bbox: [38.96, 16.30, 39.02, 16.36] },
  { name: 'Soverato', region: 'Calabria', province: 'CZ', bbox: [38.68, 16.54, 38.72, 16.60] },
  { name: 'Chiaravalle Centrale', region: 'Calabria', province: 'CZ', bbox: [38.68, 16.40, 38.72, 16.46] },
  { name: 'Sellia Marina', region: 'Calabria', province: 'CZ', bbox: [38.88, 16.72, 38.92, 16.78] },

  // ===== RC - Reggio Calabria (232 attività) =====
  { name: 'Reggio Calabria', region: 'Calabria', province: 'RC', bbox: [38.08, 15.62, 38.14, 15.68] },
  { name: 'Gioia Tauro', region: 'Calabria', province: 'RC', bbox: [38.42, 15.90, 38.46, 15.96] },
  { name: 'Locri', region: 'Calabria', province: 'RC', bbox: [38.22, 16.24, 38.26, 16.30] },
  { name: 'Villa San Giovanni', region: 'Calabria', province: 'RC', bbox: [38.22, 15.62, 38.26, 15.68] },
  { name: 'Palmi', region: 'Calabria', province: 'RC', bbox: [38.36, 15.84, 38.40, 15.90] },
  { name: 'Siderno', region: 'Calabria', province: 'RC', bbox: [38.26, 16.28, 38.30, 16.34] },
  { name: 'Polistena', region: 'Calabria', province: 'RC', bbox: [38.40, 16.06, 38.44, 16.12] },

  // ===== BN - Benevento (266 attività) =====
  { name: 'Benevento', region: 'Campania', province: 'BN', bbox: [41.12, 14.76, 41.18, 14.82] },
  { name: 'Montesarchio', region: 'Campania', province: 'BN', bbox: [41.06, 14.64, 41.10, 14.70] },
  { name: 'Telese Terme', region: 'Campania', province: 'BN', bbox: [41.22, 14.52, 41.26, 14.58] },
  { name: 'Sant Agata de Goti', region: 'Campania', province: 'BN', bbox: [41.08, 14.50, 41.12, 14.56] },

  // ===== MC - Macerata (270 attività) =====
  { name: 'Macerata', region: 'Marche', province: 'MC', bbox: [43.28, 13.44, 43.34, 13.50] },
  { name: 'Civitanova Marche', region: 'Marche', province: 'MC', bbox: [43.32, 13.72, 43.38, 13.78] },
  { name: 'Recanati', region: 'Marche', province: 'MC', bbox: [43.38, 13.54, 43.44, 13.60] },
  { name: 'Porto Recanati', region: 'Marche', province: 'MC', bbox: [43.42, 13.64, 43.46, 13.70] },
  { name: 'Tolentino', region: 'Marche', province: 'MC', bbox: [43.20, 13.28, 43.24, 13.34] },
  { name: 'San Severino Marche', region: 'Marche', province: 'MC', bbox: [43.24, 13.18, 43.28, 13.24] },

  // ===== CL - Caltanissetta (103 attività) =====
  { name: 'Caltanissetta', region: 'Sicilia', province: 'CL', bbox: [37.46, 14.02, 37.52, 14.08] },
  { name: 'Gela', region: 'Sicilia', province: 'CL', bbox: [37.06, 14.24, 37.10, 14.30] },
  { name: 'Niscemi', region: 'Sicilia', province: 'CL', bbox: [37.14, 14.38, 37.18, 14.44] },
  { name: 'Mussomeli', region: 'Sicilia', province: 'CL', bbox: [37.58, 13.74, 37.62, 13.80] },

  // ===== PZ - Potenza (434 attività) =====
  { name: 'Potenza', region: 'Basilicata', province: 'PZ', bbox: [40.62, 15.78, 40.68, 15.84] },
  { name: 'Melfi', region: 'Basilicata', province: 'PZ', bbox: [40.98, 15.64, 41.02, 15.70] },
  { name: 'Rionero in Vulture', region: 'Basilicata', province: 'PZ', bbox: [40.92, 15.68, 40.96, 15.74] },
  { name: 'Lagonegro', region: 'Basilicata', province: 'PZ', bbox: [40.12, 15.76, 40.16, 15.82] },
  { name: 'Lavello', region: 'Basilicata', province: 'PZ', bbox: [41.04, 15.80, 41.08, 15.86] },
  { name: 'Venosa', region: 'Basilicata', province: 'PZ', bbox: [40.96, 15.82, 41.00, 15.88] },

  // ===== CS - Cosenza (447 attività) =====
  { name: 'Cosenza', region: 'Calabria', province: 'CS', bbox: [39.28, 16.24, 39.34, 16.30] },
  { name: 'Rende', region: 'Calabria', province: 'CS', bbox: [39.32, 16.18, 39.36, 16.24] },
  { name: 'Corigliano-Rossano', region: 'Calabria', province: 'CS', bbox: [39.60, 16.50, 39.66, 16.56] },
  { name: 'Paola', region: 'Calabria', province: 'CS', bbox: [39.36, 16.02, 39.40, 16.08] },
  { name: 'Castrovillari', region: 'Calabria', province: 'CS', bbox: [39.80, 16.20, 39.84, 16.26] },
  { name: 'Acri', region: 'Calabria', province: 'CS', bbox: [39.50, 16.38, 39.54, 16.44] },
  { name: 'Amantea', region: 'Calabria', province: 'CS', bbox: [39.12, 16.06, 39.16, 16.12] },

  // ===== LT - Latina (454 attività) =====
  { name: 'Latina', region: 'Lazio', province: 'LT', bbox: [41.44, 12.88, 41.50, 12.94] },
  { name: 'Formia', region: 'Lazio', province: 'LT', bbox: [41.24, 13.60, 41.28, 13.66] },
  { name: 'Terracina', region: 'Lazio', province: 'LT', bbox: [41.28, 13.24, 41.32, 13.30] },
  { name: 'Gaeta', region: 'Lazio', province: 'LT', bbox: [41.20, 13.54, 41.24, 13.60] },
  { name: 'Fondi', region: 'Lazio', province: 'LT', bbox: [41.36, 13.40, 41.40, 13.46] },
  { name: 'Aprilia', region: 'Lazio', province: 'LT', bbox: [41.58, 12.64, 41.62, 12.70] },
  { name: 'Pontinia', region: 'Lazio', province: 'LT', bbox: [41.40, 13.04, 41.44, 13.10] },
];

// Tag OSM completi - stessa lista dello script principale
const TAG_QUERIES = [
  { key: 'amenity', val: 'restaurant', cat: 'Ristoranti' },
  { key: 'amenity', val: 'fast_food', cat: 'Fast Food' },
  { key: 'amenity', val: 'cafe', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'bar', cat: 'Bar e Caffè' },
  { key: 'amenity', val: 'pub', cat: 'Pub e Locali' },
  { key: 'amenity', val: 'nightclub', cat: 'Discoteche' },
  { key: 'amenity', val: 'ice_cream', cat: 'Gelaterie' },
  { key: 'shop', val: 'supermarket', cat: 'Supermercati' },
  { key: 'shop', val: 'convenience', cat: 'Alimentari' },
  { key: 'shop', val: 'greengrocer', cat: 'Frutta e Verdura' },
  { key: 'shop', val: 'butcher', cat: 'Macellerie' },
  { key: 'shop', val: 'fishmonger', cat: 'Pescherie' },
  { key: 'shop', val: 'bakery', cat: 'Panifici' },
  { key: 'shop', val: 'pastry', cat: 'Pasticcerie' },
  { key: 'shop', val: 'deli', cat: 'Gastronomie' },
  { key: 'shop', val: 'cheese', cat: 'Formaggerie' },
  { key: 'shop', val: 'wine', cat: 'Enoteche' },
  { key: 'amenity', val: 'pharmacy', cat: 'Farmacie' },
  { key: 'amenity', val: 'hospital', cat: 'Ospedali' },
  { key: 'amenity', val: 'clinic', cat: 'Cliniche' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'amenity', val: 'doctors', cat: 'Medici' },
  { key: 'healthcare', val: 'physiotherapist', cat: 'Fisioterapisti' },
  { key: 'amenity', val: 'veterinary', cat: 'Veterinari' },
  { key: 'shop', val: 'hairdresser', cat: 'Parrucchieri' },
  { key: 'shop', val: 'barber', cat: 'Parrucchieri e Barbieri' },
  { key: 'shop', val: 'beauty', cat: 'Centri Estetici' },
  { key: 'shop', val: 'cosmetics', cat: 'Profumerie' },
  { key: 'leisure', val: 'fitness_centre', cat: 'Palestre' },
  { key: 'leisure', val: 'sports_centre', cat: 'Centri Sportivi' },
  { key: 'leisure', val: 'swimming_pool', cat: 'Piscine' },
  { key: 'shop', val: 'clothes', cat: 'Abbigliamento' },
  { key: 'shop', val: 'shoes', cat: 'Calzature' },
  { key: 'shop', val: 'furniture', cat: 'Arredamento' },
  { key: 'shop', val: 'electronics', cat: 'Elettronica' },
  { key: 'shop', val: 'computer', cat: 'Negozi di Computer' },
  { key: 'shop', val: 'mobile_phone', cat: 'Telefonia' },
  { key: 'amenity', val: 'fuel', cat: 'Distributori di Carburante' },
  { key: 'shop', val: 'car', cat: 'Concessionarie Auto' },
  { key: 'shop', val: 'car_repair', cat: 'Autofficine' },
  { key: 'amenity', val: 'car_wash', cat: 'Autolavaggi' },
  { key: 'amenity', val: 'driving_school', cat: 'Autoscuole' },
  { key: 'shop', val: 'tyres', cat: 'Pneumatici' },
  { key: 'shop', val: 'car_parts', cat: 'Ricambi Auto' },
  { key: 'craft', val: 'plumber', cat: 'Idraulici' },
  { key: 'craft', val: 'electrician', cat: 'Elettricisti' },
  { key: 'craft', val: 'carpenter', cat: 'Falegnami' },
  { key: 'craft', val: 'painter', cat: 'Imbianchini' },
  { key: 'craft', val: 'locksmith', cat: 'Duplicazione Chiavi' },
  { key: 'craft', val: 'gardener', cat: 'Giardinieri' },
  { key: 'amenity', val: 'bank', cat: 'Banche' },
  { key: 'amenity', val: 'post_office', cat: 'Poste' },
  { key: 'office', val: 'lawyer', cat: 'Avvocati' },
  { key: 'office', val: 'accountant', cat: 'Commercialisti' },
  { key: 'office', val: 'estate_agent', cat: 'Agenzie Immobiliari' },
  { key: 'office', val: 'travel_agent', cat: 'Agenzie di Viaggio' },
  { key: 'amenity', val: 'school', cat: 'Scuole' },
  { key: 'amenity', val: 'kindergarten', cat: 'Asili' },
  { key: 'tourism', val: 'hotel', cat: 'Hotel' },
  { key: 'tourism', val: 'guest_house', cat: 'B&B' },
  { key: 'tourism', val: 'camp_site', cat: 'Campeggi' },
  { key: 'shop', val: 'hardware', cat: 'Ferramenta' },
  { key: 'shop', val: 'doityourself', cat: 'Fai da Te' },
  { key: 'shop', val: 'newsagent', cat: 'Giornali' },
  { key: 'shop', val: 'tobacco', cat: 'Tabaccherie' },
  { key: 'shop', val: 'books', cat: 'Librerie' },
  { key: 'shop', val: 'stationery', cat: 'Cartolerie' },
  { key: 'shop', val: 'gift', cat: 'Articoli da Regalo' },
  { key: 'shop', val: 'toys', cat: 'Giocattoli' },
  { key: 'shop', val: 'pet', cat: 'Negozi per Animali' },
  { key: 'shop', val: 'jewelry', cat: 'Gioiellerie' },
  { key: 'shop', val: 'optician', cat: 'Ottici' },
  { key: 'shop', val: 'sports', cat: 'Articoli Sportivi' },
  { key: 'amenity', val: 'laundry', cat: 'Lavanderie' },
  { key: 'amenity', val: 'taxi', cat: 'Taxi' },
  { key: 'shop', val: 'bicycle', cat: 'Biciclette' },
  { key: 'shop', val: 'motorcycle', cat: 'Moto' },
  { key: 'craft', val: 'watchmaker', cat: 'Orologiai' },
  { key: 'craft', val: 'jeweller', cat: 'Orefici' },
  { key: 'craft', val: 'shoemaker', cat: 'Calzolai' },
  { key: 'craft', val: 'tailor', cat: 'Sartorie' },
  { key: 'craft', val: 'blacksmith', cat: 'Fabbri' },
  { key: 'shop', val: 'funeral_directors', cat: 'Onoranze Funebri' },
  { key: 'shop', val: 'paint', cat: 'Colorifici' },
  { key: 'shop', val: 'photo', cat: 'Fotografia' },
  { key: 'shop', val: 'musical_instrument', cat: 'Strumenti Musicali' },
  { key: 'shop', val: 'second_hand', cat: 'Usato' },
  { key: 'office', val: 'notary', cat: 'Notai' },
  { key: 'office', val: 'insurance', cat: 'Assicurazioni' },
  { key: 'office', val: 'architect', cat: 'Architetti' },
  { key: 'amenity', val: 'dentist', cat: 'Dentisti' },
  { key: 'healthcare', val: 'psychologist', cat: 'Psicologi' },
  { key: 'shop', val: 'farm', cat: 'Prodotti Agricoli' },
  { key: 'craft', val: 'brewery', cat: 'Birrifici' },
  { key: 'craft', val: 'winery', cat: 'Cantine' },
  { key: 'shop', val: 'outdoor', cat: 'Outdoor e Camping' },
  { key: 'shop', val: 'fishing', cat: 'Pesca e Caccia' },
  { key: 'sport', val: 'martial_arts', cat: 'Arti Marziali' },
  { key: 'leisure', val: 'sauna', cat: 'Saune' },
  { key: 'sport', val: 'yoga', cat: 'Centri Yoga' },
  { key: 'shop', val: 'variety_store', cat: 'Bazar' },
  { key: 'shop', val: 'beverages', cat: 'Negozi di Bevande' },
  { key: 'shop', val: 'carpet', cat: 'Tappeti' },
  { key: 'shop', val: 'lighting', cat: 'Illuminazione' },
  { key: 'shop', val: 'windows', cat: 'Infissi' },
  { key: 'shop', val: 'fabric', cat: 'Tessuti' },
  { key: 'shop', val: 'video_games', cat: 'Videogiochi' },
  { key: 'shop', val: 'tattoo', cat: 'Tatuatori' },
  { key: 'amenity', val: 'college', cat: 'Istituti Formativi' },
  { key: 'amenity', val: 'language_school', cat: 'Scuole di Lingue' },
  { key: 'tourism', val: 'hostel', cat: 'Ostelli' },
  { key: 'tourism', val: 'motel', cat: 'Motel' },
  { key: 'shop', val: 'agrarian', cat: 'Consorzi Agrari' },
  { key: 'office', val: 'employment_agency', cat: 'Agenzie del Lavoro' },
  { key: 'office', val: 'association', cat: 'Associazioni' },
  { key: 'shop', val: 'art', cat: 'Gallerie d Arte' },
  { key: 'amenity', val: 'arts_centre', cat: 'Gallerie d Arte' },
  { key: 'shop', val: 'antiques', cat: 'Antiquari' },
  { key: 'shop', val: 'baby_goods', cat: 'Articoli per Bambini' },
  { key: 'shop', val: 'e-cigarette', cat: 'Sigarette Elettroniche' },
  { key: 'amenity', val: 'vehicle_inspection', cat: 'Revisioni Auto' },
  { key: 'craft', val: 'hvac', cat: 'Climatizzazione' },
  { key: 'shop', val: 'bed', cat: 'Materassi e Letti' },
  { key: 'shop', val: 'curtain', cat: 'Tendaggi' },
  { key: 'craft', val: 'stonemason', cat: 'Scalpellini' },
  { key: 'craft', val: 'glazier', cat: 'Vetrai' },
  { key: 'craft', val: 'tiler', cat: 'Piastrellisti' },
  { key: 'shop', val: 'weapons', cat: 'Armerie' },
  { key: 'shop', val: 'ski', cat: 'Sci e Snowboard' },
  { key: 'leisure', val: 'golf_course', cat: 'Golf' },
  { key: 'sport', val: 'diving', cat: 'Sub e Diving' },
  { key: 'amenity', val: 'charging_station', cat: 'Colonnine Ricarica' },
  { key: 'shop', val: 'chocolate', cat: 'Cioccolaterie' },
  { key: 'shop', val: 'hifi', cat: 'Hi-Fi' },
  { key: 'craft', val: 'printer', cat: 'Tipografie' },
  { key: 'craft', val: 'photographer', cat: 'Fotografi' },
  { key: 'shop', val: 'fashion', cat: 'Moda' },
  { key: 'shop', val: 'flooring', cat: 'Pavimenti' },
  { key: 'shop', val: 'tiles', cat: 'Piastrelle' },
  { key: 'amenity', val: 'atm', cat: 'Bancomat' },
  { key: 'office', val: 'financial', cat: 'Consulenti Finanziari' },
  { key: 'amenity', val: 'car_rental', cat: 'Autonoleggi' },
  { key: 'shop', val: 'model', cat: 'Modellismo' },
  { key: 'shop', val: 'music', cat: 'Negozi di Musica' },
  { key: 'shop', val: 'video', cat: 'Videonoleggi' },
  { key: 'shop', val: 'leather', cat: 'Pelletterie' },
  { key: 'shop', val: 'tea', cat: 'Negozi di Tè' },
  { key: 'shop', val: 'coffee', cat: 'Torrefazioni' },
  { key: 'craft', val: 'beekeeper', cat: 'Apicoltori' },
  { key: 'amenity', val: 'bicycle_rental', cat: 'Noleggio Biciclette' },
  { key: 'shop', val: 'dry_cleaning', cat: 'Lavanderie' },
  { key: 'shop', val: 'camera', cat: 'Fotocamere' },
  { key: 'shop', val: 'department_store', cat: 'Grandi Magazzini' },
  { key: 'shop', val: 'mall', cat: 'Centri Commerciali' },
  { key: 'office', val: 'consulting', cat: 'Consulenti' },
  { key: 'office', val: 'research', cat: 'Centri di Ricerca' },
  { key: 'office', val: 'ngo', cat: 'ONG' },
  { key: 'office', val: 'foundation', cat: 'Fondazioni' },
  { key: 'healthcare', val: 'laboratory', cat: 'Laboratori Analisi' },
  { key: 'shop', val: 'pet_grooming', cat: 'Toelettatura Animali' },
  { key: 'amenity', val: 'library', cat: 'Biblioteche' },
  { key: 'shop', val: 'kitchen', cat: 'Cucine' },
  { key: 'shop', val: 'bathroom_furnishing', cat: 'Arredo Bagno' },
  { key: 'craft', val: 'upholsterer', cat: 'Tappezzieri' },
  { key: 'craft', val: 'pottery', cat: 'Ceramisti' },
  { key: 'amenity', val: 'betting', cat: 'Ricevitorie' },
  { key: 'craft', val: 'floorer', cat: 'Posatori Parquet' },
  { key: 'shop', val: 'frame', cat: 'Cornici' },
  { key: 'craft', val: 'builder', cat: 'Costruttori' },
  { key: 'shop', val: 'repair', cat: 'Riparazione Elettronica' },
  { key: 'amenity', val: 'vending_machine', cat: 'Distributori Automatici' },
  { key: 'tourism', val: 'caravan_site', cat: 'Aree Camper' },
  { key: 'office', val: 'surveyor', cat: 'Geometri' },
  { key: 'office', val: 'engineer', cat: 'Ingegneri' },
  { key: 'office', val: 'advertising_agency', cat: 'Agenzie Pubblicitarie' },
  { key: 'office', val: 'graphic_design', cat: 'Grafici' },
  { key: 'office', val: 'company', cat: 'Aziende' },
  { key: 'amenity', val: 'music_school', cat: 'Scuole di Musica' },
  { key: 'shop', val: 'garden_centre', cat: 'Giardinaggio' },
  { key: 'craft', val: 'tinsmith', cat: 'Lattonieri' },
  { key: 'craft', val: 'farrier', cat: 'Maniscalchi' },
  { key: 'craft', val: 'sailmaker', cat: 'Velai' },
];

let categoryCache = {};
let totalImported = 0;
const startTime = Date.now();

async function loadCategories() {
  const { data } = await supabase.from('business_categories').select('id, name');
  if (data) data.forEach(c => { categoryCache[c.name] = c.id; });
  console.log(`Caricate ${Object.keys(categoryCache).length} categorie dal DB`);
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
        'User-Agent': 'ItalianBizDir/7.0'
      }
    };
    const req = https.request(opts, res => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => {
        if (res.statusCode === 429) { reject(new Error('RATE_LIMIT')); return; }
        if (res.statusCode >= 400) { reject(new Error(`HTTP ${res.statusCode}`)); return; }
        try { resolve(JSON.parse(data)); } catch { reject(new Error('JSON')); }
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
  return `[out:json][timeout:60];\n(\n  node["${tagQuery.key}"="${tagQuery.val}"](${bbox});\n  way["${tagQuery.key}"="${tagQuery.val}"](${bbox});\n);\nout center tags;`;
}

function makeRecord(el, city, catId) {
  const tags = el.tags || {};
  if (!tags.name) return null;
  const lat = el.lat ?? el.center?.lat;
  const lon = el.lon ?? el.center?.lon;
  if (!lat || !lon) return null;
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
    const key = `${r.name}|${r.city}|${r.latitude?.toFixed(4)}|${r.longitude?.toFixed(4)}`;
    if (seen.has(key)) continue;
    seen.add(key);
    records.push(r);
  }
  if (!records.length) return 0;

  let inserted = 0;
  for (let i = 0; i < records.length; i += 200) {
    const batch = records.slice(i, i + 200);
    const { error } = await supabase.from('unclaimed_business_locations').insert(batch);
    if (!error) {
      inserted += batch.length;
    } else if (error.code === '23505') {
      for (const rec of batch) {
        const { error: e2 } = await supabase.from('unclaimed_business_locations').insert(rec);
        if (!e2) inserted++;
      }
    }
  }
  totalImported += inserted;
  return inserted;
}

async function main() {
  console.log(`\n=== IMPORTAZIONE PROVINCE VUOTE/SCARSE ===`);
  console.log(`${TAG_QUERIES.length} tag OSM x ${CITIES.length} citta' mirate\n`);
  await loadCategories();

  for (let t = 0; t < TAG_QUERIES.length; t++) {
    const tq = TAG_QUERIES[t];
    let tagTotal = 0;
    process.stdout.write(`[${t+1}/${TAG_QUERIES.length}] ${tq.key}=${tq.val} -> ${tq.cat}: `);

    for (const city of CITIES) {
      const n = await runTagQuery(tq, city);
      if (n > 0) { process.stdout.write(`${city.name}(+${n}) `); tagTotal += n; }
      await sleep(1200);
    }

    const mins = ((Date.now() - startTime) / 60000).toFixed(1);
    console.log(`\n   Tag totale: +${tagTotal} | Sessione: ${totalImported.toLocaleString()} (${mins}min)`);
    await sleep(2000);
  }

  const { count } = await supabase.from('unclaimed_business_locations').select('*', { count: 'exact', head: true });
  console.log(`\n=== COMPLETATO ===`);
  console.log(`Importati questa sessione: ${totalImported.toLocaleString()}`);
  console.log(`Totale nel DB: ${count?.toLocaleString()}`);
}

main().catch(console.error);
