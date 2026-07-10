import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';

config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// 🇮🇹 TUTTE LE 107 PROVINCE ITALIANE CON BOUNDING BOX
const ALL_PROVINCES = {
  // Valle d'Aosta (1)
  'Aosta': { region: "Valle d'Aosta", bbox: [45.4, 6.7, 46.0, 7.9], code: 'AO' },

  // Piemonte (8)
  'Torino': { region: 'Piemonte', bbox: [44.8, 6.9, 45.4, 8.0], code: 'TO' },
  'Alessandria': { region: 'Piemonte', bbox: [44.5, 8.3, 45.2, 9.2], code: 'AL' },
  'Asti': { region: 'Piemonte', bbox: [44.7, 8.0, 45.1, 8.6], code: 'AT' },
  'Biella': { region: 'Piemonte', bbox: [45.4, 7.9, 45.7, 8.4], code: 'BI' },
  'Cuneo': { region: 'Piemonte', bbox: [44.0, 7.1, 44.8, 8.2], code: 'CN' },
  'Novara': { region: 'Piemonte', bbox: [45.3, 8.3, 45.8, 8.8], code: 'NO' },
  'Verbano-Cusio-Ossola': { region: 'Piemonte', bbox: [45.7, 7.9, 46.4, 8.7], code: 'VB' },
  'Vercelli': { region: 'Piemonte', bbox: [45.2, 8.0, 45.6, 8.5], code: 'VC' },

  // Lombardia (12)
  'Milano': { region: 'Lombardia', bbox: [45.3, 8.8, 45.7, 9.5], code: 'MI' },
  'Varese': { region: 'Lombardia', bbox: [45.6, 8.5, 46.0, 9.0], code: 'VA' },
  'Como': { region: 'Lombardia', bbox: [45.6, 8.9, 46.1, 9.5], code: 'CO' },
  'Lecco': { region: 'Lombardia', bbox: [45.7, 9.2, 46.0, 9.6], code: 'LC' },
  'Bergamo': { region: 'Lombardia', bbox: [45.5, 9.4, 46.0, 10.2], code: 'BG' },
  'Brescia': { region: 'Lombardia', bbox: [45.3, 9.8, 46.0, 10.7], code: 'BS' },
  'Sondrio': { region: 'Lombardia', bbox: [46.0, 9.5, 46.5, 10.4], code: 'SO' },
  'Monza e Brianza': { region: 'Lombardia', bbox: [45.5, 9.1, 45.7, 9.4], code: 'MB' },
  'Pavia': { region: 'Lombardia', bbox: [44.9, 8.6, 45.4, 9.5], code: 'PV' },
  'Lodi': { region: 'Lombardia', bbox: [45.2, 9.3, 45.5, 9.8], code: 'LO' },
  'Cremona': { region: 'Lombardia', bbox: [45.0, 9.6, 45.3, 10.2], code: 'CR' },
  'Mantova': { region: 'Lombardia', bbox: [44.9, 10.4, 45.3, 11.2], code: 'MN' },

  // Trentino-Alto Adige (2)
  'Bolzano': { region: 'Trentino-Alto Adige', bbox: [46.2, 10.4, 47.1, 12.5], code: 'BZ' },
  'Trento': { region: 'Trentino-Alto Adige', bbox: [45.7, 10.4, 46.5, 11.9], code: 'TN' },

  // Veneto (7)
  'Venezia': { region: 'Veneto', bbox: [45.2, 12.0, 45.7, 13.0], code: 'VE' },
  'Verona': { region: 'Veneto', bbox: [45.2, 10.7, 45.8, 11.3], code: 'VR' },
  'Padova': { region: 'Veneto', bbox: [45.2, 11.6, 45.6, 12.2], code: 'PD' },
  'Vicenza': { region: 'Veneto', bbox: [45.4, 11.3, 45.9, 11.8], code: 'VI' },
  'Treviso': { region: 'Veneto', bbox: [45.5, 11.9, 46.0, 12.5], code: 'TV' },
  'Belluno': { region: 'Veneto', bbox: [46.0, 11.8, 46.6, 12.6], code: 'BL' },
  'Rovigo': { region: 'Veneto', bbox: [44.8, 11.5, 45.2, 12.2], code: 'RO' },

  // Friuli-Venezia Giulia (4)
  'Udine': { region: 'Friuli-Venezia Giulia', bbox: [45.8, 12.9, 46.7, 13.6], code: 'UD' },
  'Pordenone': { region: 'Friuli-Venezia Giulia', bbox: [45.7, 12.4, 46.2, 13.1], code: 'PN' },
  'Gorizia': { region: 'Friuli-Venezia Giulia', bbox: [45.7, 13.3, 46.0, 13.7], code: 'GO' },
  'Trieste': { region: 'Friuli-Venezia Giulia', bbox: [45.5, 13.6, 45.8, 13.9], code: 'TS' },

  // Liguria (4)
  'Genova': { region: 'Liguria', bbox: [44.2, 8.7, 44.6, 9.3], code: 'GE' },
  'Imperia': { region: 'Liguria', bbox: [43.8, 7.6, 44.1, 8.2], code: 'IM' },
  'Savona': { region: 'Liguria', bbox: [44.2, 8.1, 44.5, 8.6], code: 'SV' },
  'La Spezia': { region: 'Liguria', bbox: [44.0, 9.5, 44.4, 10.0], code: 'SP' },

  // Emilia-Romagna (9)
  'Bologna': { region: 'Emilia-Romagna', bbox: [44.2, 11.0, 44.7, 11.7], code: 'BO' },
  'Modena': { region: 'Emilia-Romagna', bbox: [44.4, 10.6, 44.8, 11.3], code: 'MO' },
  'Parma': { region: 'Emilia-Romagna', bbox: [44.5, 9.7, 44.9, 10.4], code: 'PR' },
  'Reggio Emilia': { region: 'Emilia-Romagna', bbox: [44.5, 10.3, 44.8, 10.8], code: 'RE' },
  'Piacenza': { region: 'Emilia-Romagna', bbox: [44.7, 9.3, 45.1, 9.9], code: 'PC' },
  'Ferrara': { region: 'Emilia-Romagna', bbox: [44.6, 11.4, 45.1, 12.4], code: 'FE' },
  'Ravenna': { region: 'Emilia-Romagna', bbox: [44.2, 11.8, 44.6, 12.4], code: 'RA' },
  'Forlì-Cesena': { region: 'Emilia-Romagna', bbox: [43.9, 11.9, 44.3, 12.3], code: 'FC' },
  'Rimini': { region: 'Emilia-Romagna', bbox: [43.9, 12.3, 44.1, 12.7], code: 'RN' },

  // Toscana (10)
  'Firenze': { region: 'Toscana', bbox: [43.6, 11.0, 44.0, 11.5], code: 'FI' },
  'Pisa': { region: 'Toscana', bbox: [43.5, 10.2, 43.9, 10.7], code: 'PI' },
  'Livorno': { region: 'Toscana', bbox: [42.9, 10.2, 43.3, 10.7], code: 'LI' },
  'Lucca': { region: 'Toscana', bbox: [43.7, 10.2, 44.2, 10.8], code: 'LU' },
  'Prato': { region: 'Toscana', bbox: [43.8, 11.0, 44.0, 11.3], code: 'PO' },
  'Pistoia': { region: 'Toscana', bbox: [43.8, 10.7, 44.1, 11.2], code: 'PT' },
  'Arezzo': { region: 'Toscana', bbox: [43.2, 11.6, 43.7, 12.2], code: 'AR' },
  'Siena': { region: 'Toscana', bbox: [42.9, 11.1, 43.5, 11.9], code: 'SI' },
  'Grosseto': { region: 'Toscana', bbox: [42.5, 10.8, 43.0, 11.6], code: 'GR' },
  'Massa-Carrara': { region: 'Toscana', bbox: [44.0, 9.9, 44.3, 10.3], code: 'MS' },

  // Umbria (2)
  'Perugia': { region: 'Umbria', bbox: [42.7, 11.9, 43.3, 13.0], code: 'PG' },
  'Terni': { region: 'Umbria', bbox: [42.4, 12.1, 42.8, 12.8], code: 'TR' },

  // Marche (5)
  'Ancona': { region: 'Marche', bbox: [43.3, 13.0, 43.8, 13.6], code: 'AN' },
  'Macerata': { region: 'Marche', bbox: [42.9, 13.1, 43.4, 13.7], code: 'MC' },
  'Ascoli Piceno': { region: 'Marche', bbox: [42.7, 13.4, 43.1, 13.9], code: 'AP' },
  'Fermo': { region: 'Marche', bbox: [42.9, 13.5, 43.2, 13.9], code: 'FM' },
  'Pesaro e Urbino': { region: 'Marche', bbox: [43.5, 12.4, 43.9, 13.0], code: 'PU' },

  // Lazio (5)
  'Roma': { region: 'Lazio', bbox: [41.6, 12.2, 42.2, 13.0], code: 'RM' },
  'Latina': { region: 'Lazio', bbox: [41.2, 12.9, 41.7, 13.6], code: 'LT' },
  'Frosinone': { region: 'Lazio', bbox: [41.4, 13.3, 41.9, 14.0], code: 'FR' },
  'Viterbo': { region: 'Lazio', bbox: [42.2, 11.5, 42.7, 12.2], code: 'VT' },
  'Rieti': { region: 'Lazio', bbox: [42.2, 12.6, 42.7, 13.3], code: 'RI' },

  // Abruzzo (4)
  'L\'Aquila': { region: 'Abruzzo', bbox: [42.0, 13.0, 42.5, 14.1], code: 'AQ' },
  'Teramo': { region: 'Abruzzo', bbox: [42.4, 13.5, 42.9, 14.0], code: 'TE' },
  'Pescara': { region: 'Abruzzo', bbox: [42.2, 13.8, 42.6, 14.3], code: 'PE' },
  'Chieti': { region: 'Abruzzo', bbox: [41.9, 14.0, 42.4, 14.7], code: 'CH' },

  // Molise (2)
  'Campobasso': { region: 'Molise', bbox: [41.4, 14.3, 41.9, 15.0], code: 'CB' },
  'Isernia': { region: 'Molise', bbox: [41.4, 13.9, 41.8, 14.5], code: 'IS' },

  // Campania (5)
  'Napoli': { region: 'Campania', bbox: [40.7, 14.0, 41.1, 14.6], code: 'NA' },
  'Salerno': { region: 'Campania', bbox: [40.2, 14.7, 40.9, 15.6], code: 'SA' },
  'Caserta': { region: 'Campania', bbox: [40.9, 13.8, 41.4, 14.5], code: 'CE' },
  'Avellino': { region: 'Campania', bbox: [40.7, 14.7, 41.2, 15.2], code: 'AV' },
  'Benevento': { region: 'Campania', bbox: [41.0, 14.5, 41.4, 15.0], code: 'BN' },

  // Puglia (6)
  'Bari': { region: 'Puglia', bbox: [40.8, 16.8, 41.3, 17.3], code: 'BA' },
  'Foggia': { region: 'Puglia', bbox: [41.2, 15.0, 41.9, 16.2], code: 'FG' },
  'Taranto': { region: 'Puglia', bbox: [40.3, 16.9, 40.8, 17.7], code: 'TA' },
  'Lecce': { region: 'Puglia', bbox: [39.8, 17.9, 40.4, 18.6], code: 'LE' },
  'Brindisi': { region: 'Puglia', bbox: [40.4, 17.5, 40.8, 18.2], code: 'BR' },
  'Barletta-Andria-Trani': { region: 'Puglia', bbox: [41.0, 16.0, 41.4, 16.6], code: 'BT' },

  // Basilicata (2)
  'Potenza': { region: 'Basilicata', bbox: [40.1, 15.4, 40.7, 16.5], code: 'PZ' },
  'Matera': { region: 'Basilicata', bbox: [40.3, 16.2, 40.8, 16.9], code: 'MT' },

  // Calabria (5)
  'Cosenza': { region: 'Calabria', bbox: [39.2, 15.8, 39.8, 16.5], code: 'CS' },
  'Catanzaro': { region: 'Calabria', bbox: [38.7, 16.3, 39.1, 16.8], code: 'CZ' },
  'Reggio Calabria': { region: 'Calabria', bbox: [37.9, 15.6, 38.3, 16.2], code: 'RC' },
  'Crotone': { region: 'Calabria', bbox: [38.9, 16.7, 39.3, 17.2], code: 'KR' },
  'Vibo Valentia': { region: 'Calabria', bbox: [38.5, 15.9, 38.8, 16.4], code: 'VV' },

  // Sicilia (9)
  'Palermo': { region: 'Sicilia', bbox: [37.9, 13.0, 38.3, 13.6], code: 'PA' },
  'Catania': { region: 'Sicilia', bbox: [37.3, 14.9, 37.7, 15.3], code: 'CT' },
  'Messina': { region: 'Sicilia', bbox: [37.9, 14.8, 38.3, 15.7], code: 'ME' },
  'Siracusa': { region: 'Sicilia', bbox: [36.7, 14.7, 37.3, 15.3], code: 'SR' },
  'Ragusa': { region: 'Sicilia', bbox: [36.7, 14.3, 37.1, 14.9], code: 'RG' },
  'Trapani': { region: 'Sicilia', bbox: [37.5, 12.3, 38.2, 12.9], code: 'TP' },
  'Agrigento': { region: 'Sicilia', bbox: [37.0, 13.0, 37.5, 13.8], code: 'AG' },
  'Caltanissetta': { region: 'Sicilia', bbox: [37.2, 13.8, 37.6, 14.4], code: 'CL' },
  'Enna': { region: 'Sicilia', bbox: [37.3, 14.1, 37.7, 14.7], code: 'EN' },

  // Sardegna (5 + nuova provincia)
  'Cagliari': { region: 'Sardegna', bbox: [38.9, 8.8, 39.4, 9.3], code: 'CA' },
  'Sassari': { region: 'Sardegna', bbox: [40.5, 8.2, 41.0, 9.1], code: 'SS' },
  'Nuoro': { region: 'Sardegna', bbox: [39.8, 8.9, 40.5, 9.7], code: 'NU' },
  'Oristano': { region: 'Sardegna', bbox: [39.7, 8.4, 40.2, 9.0], code: 'OR' },
  'Sud Sardegna': { region: 'Sardegna', bbox: [38.9, 8.4, 39.5, 9.7], code: 'SU' },
};

// 🏷️ CATEGORIE COMPREHENSIVE - Include tutto!
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

  // Abbigliamento e accessori
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

  // Bellezza e cura persona
  { osm: 'shop=hairdresser', db: 'Parrucchieri e Barbieri' },
  { osm: 'shop=beauty', db: 'Centri Estetici' },
  { osm: 'shop=cosmetics', db: 'Profumerie' },
  { osm: 'shop=perfumery', db: 'Profumerie' },
  { osm: 'shop=massage', db: 'Centri Massaggi' },
  { osm: 'shop=tattoo', db: 'Tatuatori' },
  { osm: 'shop=hairdresser_supply', db: 'Forniture Parrucchieri' },

  // Casa e giardino
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

  // Elettronica e tecnologia
  { osm: 'shop=electronics', db: 'Elettronica' },
  { osm: 'shop=computer', db: 'Negozi di Computer' },
  { osm: 'shop=mobile_phone', db: 'Negozi di Telefonia' },
  { osm: 'shop=hifi', db: 'Hi-Fi' },
  { osm: 'shop=video', db: 'Videonoleggi' },
  { osm: 'shop=photo', db: 'Fotografia' },
  { osm: 'shop=video_games', db: 'Videogiochi' },
  { osm: 'shop=camera', db: 'Fotocamere' },

  // Libri, cultura e hobby
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

  // Salute
  { osm: 'shop=pharmacy', db: 'Farmacie' },
  { osm: 'shop=chemist', db: 'Farmacie' },
  { osm: 'shop=optician', db: 'Ottici' },
  { osm: 'shop=medical_supply', db: 'Sanitaria' },
  { osm: 'shop=hearing_aids', db: 'Apparecchi Acustici' },

  // Sport e tempo libero
  { osm: 'shop=sports', db: 'Negozi di Sport' },
  { osm: 'shop=bicycle', db: 'Negozi di Biciclette' },
  { osm: 'shop=fishing', db: 'Pesca e Caccia' },
  { osm: 'shop=hunting', db: 'Pesca e Caccia' },
  { osm: 'shop=outdoor', db: 'Outdoor e Camping' },
  { osm: 'shop=golf', db: 'Golf' },
  { osm: 'shop=scuba_diving', db: 'Sub e Diving' },
  { osm: 'shop=swimming_pool', db: 'Piscine' },
  { osm: 'shop=ski', db: 'Sci e Snowboard' },

  // Animali
  { osm: 'shop=pet', db: 'Negozi per Animali' },
  { osm: 'shop=pet_grooming', db: 'Toelettatura Animali' },

  // Auto e moto
  { osm: 'shop=car', db: 'Concessionarie Auto' },
  { osm: 'shop=car_repair', db: 'Autofficine' },
  { osm: 'shop=car_parts', db: 'Ricambi Auto' },
  { osm: 'shop=motorcycle', db: 'Moto' },
  { osm: 'shop=tyres', db: 'Pneumatici' },
  { osm: 'shop=car_wash', db: 'Autolavaggi' },

  // Altri negozi
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
  { osm: 'amenity=fuel', db: 'Stazioni di Servizio' },
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
  { osm: 'amenity=pharmacy', db: 'Farmacie' },
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
  byProvince: {},
  byRegion: {},
  byCategory: {},
  errors: 0,
  skippedProvinces: 0,
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

  // Retry logic per errori di rete
  let retries = 0;
  const maxRetries = 3;

  while (retries < maxRetries) {
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        body: query,
        headers: { 'Content-Type': 'text/plain' },
        signal: AbortSignal.timeout(60000) // timeout 60 secondi (aumentato)
      });

      if (!response.ok) {
        if (response.status === 429) {
          console.log('   ⏳ Rate limit, attendo 60 secondi...');
          await sleep(60000);
          return queryOverpass(bbox, osmTag);
        }
        if (response.status === 504) {
          throw new Error('Gateway timeout - server sovraccarico');
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
        const waitTime = retries * 15000; // 15s, 30s, 45s (aumentato)
        console.log(`   ⚠️  Errore (tentativo ${retries}/${maxRetries}): ${error.message}`);
        console.log(`   ⏳ Riprovo tra ${waitTime/1000} secondi...`);
        await sleep(waitTime);
      } else {
        console.log(`   ⏹️  Categoria saltata dopo ${maxRetries} tentativi`);
        return [];
      }
    }
  }

  return [];
}

function extractData(element, provinceName, provinceData) {
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
  const city = tags['addr:city'] || tags['addr:town'] || tags['addr:village'] || provinceName;
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
    province: provinceData.code,
    region: provinceData.region,
    postal_code: postcode,
    latitude: lat,
    longitude: lon,
    phone: (tags.phone || tags['contact:phone'] || '').replace(/\s+/g, ''),
    website: tags.website || tags['contact:website'] || '',
    email: tags.email || tags['contact:email'] || '',
    business_hours: tags.opening_hours || null,
  };
}

async function importProvince(provinceName, provinceData) {
  console.log(`\n${'='.repeat(70)}`);
  console.log(`📍 PROVINCIA: ${provinceName} (${provinceData.region}) - [${provinceData.code}]`);
  console.log('='.repeat(70));

  let provinceTotal = 0;
  let categoryCount = 0;
  let skippedCategories = 0;

  for (const category of COMPREHENSIVE_CATEGORIES) {
    categoryCount++;
    process.stdout.write(`   [${categoryCount}/${COMPREHENSIVE_CATEGORIES.length}] ${category.db.padEnd(35)} `);

    try {
      const categoryId = await getCategoryId(category.db);
      if (!categoryId) {
        console.log('⚠️  categoria non trovata - SKIP');
        skippedCategories++;
        await sleep(500);
        continue;
      }

      const elements = await queryOverpass(provinceData.bbox, category.osm);

      if (elements.length === 0) {
        console.log('⚪ 0');
        await sleep(1500);
        continue;
      }
    } catch (error) {
      console.log(`❌ Errore - SKIP`);
      skippedCategories++;
      stats.errors++;
      await sleep(2000);
      continue;
    }

    let imported = 0;
    let insertErrors = 0;

    for (const element of elements) {
      const businessData = extractData(element, provinceName, provinceData);
      if (!businessData) continue;

      try {
        // Controlla duplicato
        const { data: existing } = await supabase
          .from('unclaimed_business_locations')
          .select('id')
          .eq('name', businessData.name)
          .eq('city', businessData.city)
          .eq('address', businessData.address)
          .maybeSingle();

        if (existing) continue;

        // Inserisci direttamente in unclaimed_business_locations
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

          // Statistiche
          stats.byCategory[category.db] = (stats.byCategory[category.db] || 0) + 1;
          stats.byRegion[provinceData.region] = (stats.byRegion[provinceData.region] || 0) + 1;
        } else {
          insertErrors++;
          stats.errors++;
        }
      } catch (error) {
        insertErrors++;
        stats.errors++;
        // Continua con il prossimo elemento senza fermarsi
      }
    }

    if (imported > 0) {
      console.log(`✅ ${imported}`);
    } else {
      console.log(`⚪ 0`);
    }

    provinceTotal += imported;
    stats.totalProcessed += elements.length;

    // Pausa tra categorie
    await sleep(2000);
  }

  stats.byProvince[provinceName] = provinceTotal;

  console.log(`\n   🎯 TOTALE ${provinceName}: ${provinceTotal} attività importate`);
  if (skippedCategories > 0) {
    console.log(`   ⚠️  Categorie saltate per errori: ${skippedCategories}`);
  }
  console.log(`   📊 Totale complessivo finora: ${stats.totalImported.toLocaleString()}\n`);

  return provinceTotal;
}

function printProgressSummary() {
  console.log('\n' + '='.repeat(70));
  console.log('📊 RIEPILOGO PROGRESSIVO');
  console.log('='.repeat(70));
  console.log(`Totale importate: ${stats.totalImported.toLocaleString()}`);
  console.log(`Errori: ${stats.errors}`);

  console.log(`\n🏆 Top 10 Province:`);
  Object.entries(stats.byProvince)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 10)
    .forEach(([prov, count], i) => {
      console.log(`   ${(i+1).toString().padStart(2)}. ${prov.padEnd(30)} ${count.toLocaleString()}`);
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
  console.log('║' + ' IMPORTAZIONE COMPLETA OSM - TUTTE LE PROVINCE ITALIANE '.padEnd(68) + '║');
  console.log('║' + ' '.repeat(68) + '║');
  console.log('║' + ` Totale province: ${Object.keys(ALL_PROVINCES).length}`.padEnd(68) + '║');
  console.log('║' + ` Totale categorie: ${COMPREHENSIVE_CATEGORIES.length}`.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  let grandTotal = 0;
  let provinceCount = 0;
  const totalProvinces = Object.keys(ALL_PROVINCES).length;

  for (const [provinceName, provinceData] of Object.entries(ALL_PROVINCES)) {
    try {
      const count = await importProvince(provinceName, provinceData);
      grandTotal += count;
      provinceCount++;

      // Stampa riepilogo ogni 10 province
      if (provinceCount % 10 === 0) {
        printProgressSummary();
      }

      console.log(`⏳ Pausa 10 secondi prima della prossima provincia... (${provinceCount}/${totalProvinces})\n`);
      await sleep(10000);

    } catch (error) {
      console.error(`\n❌ ERRORE CRITICO in ${provinceName}:`, error.message);
      console.error(`   Provincia SALTATA - continuo con la prossima...\n`);
      stats.errors++;
      stats.skippedProvinces++;
      stats.byProvince[provinceName] = 0;
      provinceCount++;
      await sleep(10000); // Pausa anche in caso di errore
    }
  }

  console.log('\n' + '╔' + '═'.repeat(68) + '╗');
  console.log('║' + ' ✅ IMPORTAZIONE COMPLETATA '.padEnd(68) + '║');
  console.log('╚' + '═'.repeat(68) + '╝\n');

  printProgressSummary();

  console.log('\n' + '='.repeat(70));
  console.log('🎉 STATISTICHE FINALI');
  console.log('='.repeat(70));
  console.log(`Province processate: ${provinceCount}/${totalProvinces}`);
  console.log(`Province completate: ${provinceCount - stats.skippedProvinces}`);
  console.log(`Province saltate: ${stats.skippedProvinces}`);
  console.log(`Totale attività importate: ${grandTotal.toLocaleString()}`);
  console.log(`Errori totali: ${stats.errors}`);
  console.log('='.repeat(70) + '\n');
}

main().catch(console.error);
