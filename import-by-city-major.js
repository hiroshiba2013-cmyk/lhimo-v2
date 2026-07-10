import { createClient } from '@supabase/supabase-js';
import fetch from 'node-fetch';
import * as dotenv from 'dotenv';
import { writeFileSync } from 'fs';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Città italiane con almeno 20.000 abitanti (circa 350 città)
const MAJOR_CITIES = [
  // Città > 100.000 abitanti
  { name: 'Roma', region: 'Lazio', province: 'Roma' },
  { name: 'Milano', region: 'Lombardia', province: 'Milano' },
  { name: 'Napoli', region: 'Campania', province: 'Napoli' },
  { name: 'Torino', region: 'Piemonte', province: 'Torino' },
  { name: 'Palermo', region: 'Sicilia', province: 'Palermo' },
  { name: 'Genova', region: 'Liguria', province: 'Genova' },
  { name: 'Bologna', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'Firenze', region: 'Toscana', province: 'Firenze' },
  { name: 'Bari', region: 'Puglia', province: 'Bari' },
  { name: 'Catania', region: 'Sicilia', province: 'Catania' },
  { name: 'Venezia', region: 'Veneto', province: 'Venezia' },
  { name: 'Verona', region: 'Veneto', province: 'Verona' },
  { name: 'Messina', region: 'Sicilia', province: 'Messina' },
  { name: 'Padova', region: 'Veneto', province: 'Padova' },
  { name: 'Trieste', region: 'Friuli-Venezia Giulia', province: 'Trieste' },
  { name: 'Brescia', region: 'Lombardia', province: 'Brescia' },
  { name: 'Parma', region: 'Emilia-Romagna', province: 'Parma' },
  { name: 'Taranto', region: 'Puglia', province: 'Taranto' },
  { name: 'Prato', region: 'Toscana', province: 'Prato' },
  { name: 'Modena', region: 'Emilia-Romagna', province: 'Modena' },
  { name: 'Reggio Calabria', region: 'Calabria', province: 'Reggio Calabria' },
  { name: 'Reggio Emilia', region: 'Emilia-Romagna', province: 'Reggio Emilia' },
  { name: 'Perugia', region: 'Umbria', province: 'Perugia' },
  { name: 'Ravenna', region: 'Emilia-Romagna', province: 'Ravenna' },
  { name: 'Livorno', region: 'Toscana', province: 'Livorno' },
  { name: 'Cagliari', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Foggia', region: 'Puglia', province: 'Foggia' },
  { name: 'Rimini', region: 'Emilia-Romagna', province: 'Rimini' },
  { name: 'Salerno', region: 'Campania', province: 'Salerno' },
  { name: 'Ferrara', region: 'Emilia-Romagna', province: 'Ferrara' },
  { name: 'Sassari', region: 'Sardegna', province: 'Sassari' },
  { name: 'Latina', region: 'Lazio', province: 'Latina' },
  { name: 'Giugliano in Campania', region: 'Campania', province: 'Napoli' },
  { name: 'Monza', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Siracusa', region: 'Sicilia', province: 'Siracusa' },
  { name: 'Pescara', region: 'Abruzzo', province: 'Pescara' },
  { name: 'Bergamo', region: 'Lombardia', province: 'Bergamo' },
  { name: 'Trento', region: 'Trentino-Alto Adige', province: 'Trento' },
  { name: 'Forlì', region: 'Emilia-Romagna', province: 'Forlì-Cesena' },
  { name: 'Vicenza', region: 'Veneto', province: 'Vicenza' },
  { name: 'Terni', region: 'Umbria', province: 'Terni' },
  { name: 'Bolzano', region: 'Trentino-Alto Adige', province: 'Bolzano' },
  { name: 'Novara', region: 'Piemonte', province: 'Novara' },
  { name: 'Piacenza', region: 'Emilia-Romagna', province: 'Piacenza' },
  { name: 'Ancona', region: 'Marche', province: 'Ancona' },
  { name: 'Andria', region: 'Puglia', province: 'Barletta-Andria-Trani' },
  { name: 'Arezzo', region: 'Toscana', province: 'Arezzo' },
  { name: 'Udine', region: 'Friuli-Venezia Giulia', province: 'Udine' },
  { name: 'Cesena', region: 'Emilia-Romagna', province: 'Forlì-Cesena' },
  { name: 'Lecce', region: 'Puglia', province: 'Lecce' },
  { name: 'Pesaro', region: 'Marche', province: 'Pesaro e Urbino' },
  { name: 'Barletta', region: 'Puglia', province: 'Barletta-Andria-Trani' },
  { name: 'Alessandria', region: 'Piemonte', province: 'Alessandria' },
  { name: 'La Spezia', region: 'Liguria', province: 'La Spezia' },
  { name: 'Pisa', region: 'Toscana', province: 'Pisa' },
  { name: 'Catanzaro', region: 'Calabria', province: 'Catanzaro' },
  { name: 'Pistoia', region: 'Toscana', province: 'Pistoia' },
  { name: 'Lucca', region: 'Toscana', province: 'Lucca' },
  { name: 'Brindisi', region: 'Puglia', province: 'Brindisi' },
  { name: 'Como', region: 'Lombardia', province: 'Como' },
  { name: 'Varese', region: 'Lombardia', province: 'Varese' },
  { name: 'Treviso', region: 'Veneto', province: 'Treviso' },
  { name: 'Busto Arsizio', region: 'Lombardia', province: 'Varese' },
  { name: 'Marsala', region: 'Sicilia', province: 'Trapani' },
  { name: 'Pozzuoli', region: 'Campania', province: 'Napoli' },
  { name: 'Grosseto', region: 'Toscana', province: 'Grosseto' },
  { name: 'Sesto San Giovanni', region: 'Lombardia', province: 'Milano' },
  { name: 'Varesotto', region: 'Lombardia', province: 'Varese' },
  { name: 'Casoria', region: 'Campania', province: 'Napoli' },
  { name: 'Asti', region: 'Piemonte', province: 'Asti' },
  { name: 'Cinisello Balsamo', region: 'Lombardia', province: 'Milano' },
  { name: 'Ragusa', region: 'Sicilia', province: 'Ragusa' },
  { name: 'Gela', region: 'Sicilia', province: 'Caltanissetta' },
  { name: 'Pavia', region: 'Lombardia', province: 'Pavia' },
  { name: 'Carrara', region: 'Toscana', province: 'Massa-Carrara' },
  { name: 'Guidonia Montecelio', region: 'Lazio', province: 'Roma' },
  { name: 'Quartu Sant\'Elena', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Aprilia', region: 'Lazio', province: 'Latina' },
  { name: 'Cremona', region: 'Lombardia', province: 'Cremona' },
  { name: 'Fiumicino', region: 'Lazio', province: 'Roma' },
  { name: 'Massa', region: 'Toscana', province: 'Massa-Carrara' },
  { name: 'Cosenza', region: 'Calabria', province: 'Cosenza' },
  { name: 'Caserta', region: 'Campania', province: 'Caserta' },
  { name: 'Viterbo', region: 'Lazio', province: 'Viterbo' },
  { name: 'Altamura', region: 'Puglia', province: 'Bari' },
  { name: 'Trapani', region: 'Sicilia', province: 'Trapani' },
  { name: 'Agrigento', region: 'Sicilia', province: 'Agrigento' },
  { name: 'Potenza', region: 'Basilicata', province: 'Potenza' },
  { name: 'Matera', region: 'Basilicata', province: 'Matera' },
  { name: 'Benevento', region: 'Campania', province: 'Benevento' },
  { name: 'Caltanissetta', region: 'Sicilia', province: 'Caltanissetta' },
  { name: 'Afragola', region: 'Campania', province: 'Napoli' },
  { name: 'Mantova', region: 'Lombardia', province: 'Mantova' },
  { name: 'Molfetta', region: 'Puglia', province: 'Bari' },
  { name: 'Marano di Napoli', region: 'Campania', province: 'Napoli' },
  { name: 'Savona', region: 'Liguria', province: 'Savona' },
  { name: 'Imola', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'Velletri', region: 'Lazio', province: 'Roma' },
  { name: 'Acerra', region: 'Campania', province: 'Napoli' },
  { name: 'Rovigo', region: 'Veneto', province: 'Rovigo' },
  { name: 'Crotone', region: 'Calabria', province: 'Crotone' },
  { name: 'L\'Aquila', region: 'Abruzzo', province: 'L\'Aquila' },
  { name: 'Pordenone', region: 'Friuli-Venezia Giulia', province: 'Pordenone' },
  { name: 'Moncalieri', region: 'Piemonte', province: 'Torino' },
  { name: 'Siena', region: 'Toscana', province: 'Siena' },
  { name: 'Avellino', region: 'Campania', province: 'Avellino' },
  { name: 'Campobasso', region: 'Molise', province: 'Campobasso' },
  { name: 'Rieti', region: 'Lazio', province: 'Rieti' },
  { name: 'Chieti', region: 'Abruzzo', province: 'Chieti' },
  { name: 'Vercelli', region: 'Piemonte', province: 'Vercelli' },
  { name: 'Cuneo', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Enna', region: 'Sicilia', province: 'Enna' },
  { name: 'Lodi', region: 'Lombardia', province: 'Lodi' },
  { name: 'Lecco', region: 'Lombardia', province: 'Lecco' },
  { name: 'Belluno', region: 'Veneto', province: 'Belluno' },
  { name: 'Sondrio', region: 'Lombardia', province: 'Sondrio' },
  { name: 'Verbania', region: 'Piemonte', province: 'Verbano-Cusio-Ossola' },
  { name: 'Biella', region: 'Piemonte', province: 'Biella' },
  { name: 'Gorizia', region: 'Friuli-Venezia Giulia', province: 'Gorizia' },
  { name: 'Imperia', region: 'Liguria', province: 'Imperia' },
  { name: 'Oristano', region: 'Sardegna', province: 'Oristano' },
  { name: 'Nuoro', region: 'Sardegna', province: 'Nuoro' },
  { name: 'Isernia', region: 'Molise', province: 'Isernia' },
  { name: 'Vibo Valentia', region: 'Calabria', province: 'Vibo Valentia' },
  { name: 'Carbonia', region: 'Sardegna', province: 'Sud Sardegna' },

  // Altre città > 20.000 abitanti
  { name: 'Cinisello Balsamo', region: 'Lombardia', province: 'Milano' },
  { name: 'Gallarate', region: 'Lombardia', province: 'Varese' },
  { name: 'Seregno', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Desio', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Lissone', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Collegno', region: 'Piemonte', province: 'Torino' },
  { name: 'Rivoli', region: 'Piemonte', province: 'Torino' },
  { name: 'Nichelino', region: 'Piemonte', province: 'Torino' },
  { name: 'Settimo Torinese', region: 'Piemonte', province: 'Torino' },
  { name: 'Rho', region: 'Lombardia', province: 'Milano' },
  { name: 'Legnano', region: 'Lombardia', province: 'Milano' },
  { name: 'Pomezia', region: 'Lazio', province: 'Roma' },
  { name: 'Tivoli', region: 'Lazio', province: 'Roma' },
  { name: 'Anzio', region: 'Lazio', province: 'Roma' },
  { name: 'Torre del Greco', region: 'Campania', province: 'Napoli' },
  { name: 'Castellammare di Stabia', region: 'Campania', province: 'Napoli' },
  { name: 'Portici', region: 'Campania', province: 'Napoli' },
  { name: 'Ercolano', region: 'Campania', province: 'Napoli' },
  { name: 'Cava de\' Tirreni', region: 'Campania', province: 'Salerno' },
  { name: 'Battipaglia', region: 'Campania', province: 'Salerno' },
  { name: 'Eboli', region: 'Campania', province: 'Salerno' },
  { name: 'Scafati', region: 'Campania', province: 'Salerno' },
  { name: 'Nocera Inferiore', region: 'Campania', province: 'Salerno' },
  { name: 'Pagani', region: 'Campania', province: 'Salerno' },
  { name: 'Aversa', region: 'Campania', province: 'Caserta' },
  { name: 'Marcianise', region: 'Campania', province: 'Caserta' },
  { name: 'Maddaloni', region: 'Campania', province: 'Caserta' },
  { name: 'Santa Maria Capua Vetere', region: 'Campania', province: 'Caserta' },
  { name: 'Cerignola', region: 'Puglia', province: 'Foggia' },
  { name: 'Manfredonia', region: 'Puglia', province: 'Foggia' },
  { name: 'San Severo', region: 'Puglia', province: 'Foggia' },
  { name: 'Monopoli', region: 'Puglia', province: 'Bari' },
  { name: 'Bitonto', region: 'Puglia', province: 'Bari' },
  { name: 'Corato', region: 'Puglia', province: 'Bari' },
  { name: 'Trani', region: 'Puglia', province: 'Barletta-Andria-Trani' },
  { name: 'Bisceglie', region: 'Puglia', province: 'Barletta-Andria-Trani' },
  { name: 'Martina Franca', region: 'Puglia', province: 'Taranto' },
  { name: 'Manduria', region: 'Puglia', province: 'Taranto' },
  { name: 'Massafra', region: 'Puglia', province: 'Taranto' },
  { name: 'Grottaglie', region: 'Puglia', province: 'Taranto' },
  { name: 'Fasano', region: 'Puglia', province: 'Brindisi' },
  { name: 'Francavilla Fontana', region: 'Puglia', province: 'Brindisi' },
  { name: 'Ostuni', region: 'Puglia', province: 'Brindisi' },
  { name: 'Mesagne', region: 'Puglia', province: 'Brindisi' },
  { name: 'Nardò', region: 'Puglia', province: 'Lecce' },
  { name: 'Copertino', region: 'Puglia', province: 'Lecce' },
  { name: 'Galatina', region: 'Puglia', province: 'Lecce' },
  { name: 'Casarano', region: 'Puglia', province: 'Lecce' },
  { name: 'Gallipoli', region: 'Puglia', province: 'Lecce' },
  { name: 'Acireale', region: 'Sicilia', province: 'Catania' },
  { name: 'Misterbianco', region: 'Sicilia', province: 'Catania' },
  { name: 'Paternò', region: 'Sicilia', province: 'Catania' },
  { name: 'Adrano', region: 'Sicilia', province: 'Catania' },
  { name: 'Mascalucia', region: 'Sicilia', province: 'Catania' },
  { name: 'Belpasso', region: 'Sicilia', province: 'Catania' },
  { name: 'Giarre', region: 'Sicilia', province: 'Catania' },
  { name: 'Bagheria', region: 'Sicilia', province: 'Palermo' },
  { name: 'Carini', region: 'Sicilia', province: 'Palermo' },
  { name: 'Partinico', region: 'Sicilia', province: 'Palermo' },
  { name: 'Monreale', region: 'Sicilia', province: 'Palermo' },
  { name: 'Termini Imerese', region: 'Sicilia', province: 'Palermo' },
  { name: 'Mazara del Vallo', region: 'Sicilia', province: 'Trapani' },
  { name: 'Alcamo', region: 'Sicilia', province: 'Trapani' },
  { name: 'Castelvetrano', region: 'Sicilia', province: 'Trapani' },
  { name: 'Augusta', region: 'Sicilia', province: 'Siracusa' },
  { name: 'Avola', region: 'Sicilia', province: 'Siracusa' },
  { name: 'Noto', region: 'Sicilia', province: 'Siracusa' },
  { name: 'Lentini', region: 'Sicilia', province: 'Siracusa' },
  { name: 'Vittoria', region: 'Sicilia', province: 'Ragusa' },
  { name: 'Modica', region: 'Sicilia', province: 'Ragusa' },
  { name: 'Comiso', region: 'Sicilia', province: 'Ragusa' },
  { name: 'Scicli', region: 'Sicilia', province: 'Ragusa' },
  { name: 'Barcellona Pozzo di Gotto', region: 'Sicilia', province: 'Messina' },
  { name: 'Milazzo', region: 'Sicilia', province: 'Messina' },
  { name: 'Patti', region: 'Sicilia', province: 'Messina' },
  { name: 'Licata', region: 'Sicilia', province: 'Agrigento' },
  { name: 'Canicattì', region: 'Sicilia', province: 'Agrigento' },
  { name: 'Sciacca', region: 'Sicilia', province: 'Agrigento' },
  { name: 'Favara', region: 'Sicilia', province: 'Agrigento' },
  { name: 'Niscemi', region: 'Sicilia', province: 'Caltanissetta' },
  { name: 'Mussomeli', region: 'Sicilia', province: 'Caltanissetta' },
  { name: 'San Cataldo', region: 'Sicilia', province: 'Caltanissetta' },
  { name: 'Piazza Armerina', region: 'Sicilia', province: 'Enna' },
  { name: 'Leonforte', region: 'Sicilia', province: 'Enna' },
  { name: 'Rende', region: 'Calabria', province: 'Cosenza' },
  { name: 'Corigliano-Rossano', region: 'Calabria', province: 'Cosenza' },
  { name: 'Castrovillari', region: 'Calabria', province: 'Cosenza' },
  { name: 'Paola', region: 'Calabria', province: 'Cosenza' },
  { name: 'Acri', region: 'Calabria', province: 'Cosenza' },
  { name: 'Lamezia Terme', region: 'Calabria', province: 'Catanzaro' },
  { name: 'Soverato', region: 'Calabria', province: 'Catanzaro' },
  { name: 'Gioia Tauro', region: 'Calabria', province: 'Reggio Calabria' },
  { name: 'Palmi', region: 'Calabria', province: 'Reggio Calabria' },
  { name: 'Siderno', region: 'Calabria', province: 'Reggio Calabria' },
  { name: 'Villa San Giovanni', region: 'Calabria', province: 'Reggio Calabria' },
  { name: 'Locri', region: 'Calabria', province: 'Reggio Calabria' },
  { name: 'Melfi', region: 'Basilicata', province: 'Potenza' },
  { name: 'Lavello', region: 'Basilicata', province: 'Potenza' },
  { name: 'Rionero in Vulture', region: 'Basilicata', province: 'Potenza' },
  { name: 'Pisticci', region: 'Basilicata', province: 'Matera' },
  { name: 'Policoro', region: 'Basilicata', province: 'Matera' },
  { name: 'Termoli', region: 'Molise', province: 'Campobasso' },
  { name: 'Venafro', region: 'Molise', province: 'Isernia' },
  { name: 'Vasto', region: 'Abruzzo', province: 'Chieti' },
  { name: 'Lanciano', region: 'Abruzzo', province: 'Chieti' },
  { name: 'Ortona', region: 'Abruzzo', province: 'Chieti' },
  { name: 'Francavilla al Mare', region: 'Abruzzo', province: 'Chieti' },
  { name: 'Montesilvano', region: 'Abruzzo', province: 'Pescara' },
  { name: 'Giulianova', region: 'Abruzzo', province: 'Teramo' },
  { name: 'Roseto degli Abruzzi', region: 'Abruzzo', province: 'Teramo' },
  { name: 'Teramo', region: 'Abruzzo', province: 'Teramo' },
  { name: 'Avezzano', region: 'Abruzzo', province: 'L\'Aquila' },
  { name: 'Sulmona', region: 'Abruzzo', province: 'L\'Aquila' },
  { name: 'Foligno', region: 'Umbria', province: 'Perugia' },
  { name: 'Spoleto', region: 'Umbria', province: 'Perugia' },
  { name: 'Città di Castello', region: 'Umbria', province: 'Perugia' },
  { name: 'Gubbio', region: 'Umbria', province: 'Perugia' },
  { name: 'Assisi', region: 'Umbria', province: 'Perugia' },
  { name: 'Fano', region: 'Marche', province: 'Pesaro e Urbino' },
  { name: 'Senigallia', region: 'Marche', province: 'Ancona' },
  { name: 'Jesi', region: 'Marche', province: 'Ancona' },
  { name: 'Fabriano', region: 'Marche', province: 'Ancona' },
  { name: 'Osimo', region: 'Marche', province: 'Ancona' },
  { name: 'Civitanova Marche', region: 'Marche', province: 'Macerata' },
  { name: 'Macerata', region: 'Marche', province: 'Macerata' },
  { name: 'Corridonia', region: 'Marche', province: 'Macerata' },
  { name: 'Recanati', region: 'Marche', province: 'Macerata' },
  { name: 'Tolentino', region: 'Marche', province: 'Macerata' },
  { name: 'San Benedetto del Tronto', region: 'Marche', province: 'Ascoli Piceno' },
  { name: 'Ascoli Piceno', region: 'Marche', province: 'Ascoli Piceno' },
  { name: 'Grottammare', region: 'Marche', province: 'Ascoli Piceno' },
  { name: 'Porto Sant\'Elpidio', region: 'Marche', province: 'Fermo' },
  { name: 'Fermo', region: 'Marche', province: 'Fermo' },
  { name: 'Empoli', region: 'Toscana', province: 'Firenze' },
  { name: 'Scandicci', region: 'Toscana', province: 'Firenze' },
  { name: 'Sesto Fiorentino', region: 'Toscana', province: 'Firenze' },
  { name: 'Campi Bisenzio', region: 'Toscana', province: 'Firenze' },
  { name: 'Pontedera', region: 'Toscana', province: 'Pisa' },
  { name: 'Cascina', region: 'Toscana', province: 'Pisa' },
  { name: 'San Giuliano Terme', region: 'Toscana', province: 'Pisa' },
  { name: 'Viareggio', region: 'Toscana', province: 'Lucca' },
  { name: 'Capannori', region: 'Toscana', province: 'Lucca' },
  { name: 'Montecatini Terme', region: 'Toscana', province: 'Pistoia' },
  { name: 'Quarrata', region: 'Toscana', province: 'Pistoia' },
  { name: 'Piombino', region: 'Toscana', province: 'Livorno' },
  { name: 'Cecina', region: 'Toscana', province: 'Livorno' },
  { name: 'Rosignano Marittimo', region: 'Toscana', province: 'Livorno' },
  { name: 'Follonica', region: 'Toscana', province: 'Grosseto' },
  { name: 'Orbetello', region: 'Toscana', province: 'Grosseto' },
  { name: 'Montevarchi', region: 'Toscana', province: 'Arezzo' },
  { name: 'Cortona', region: 'Toscana', province: 'Arezzo' },
  { name: 'San Giovanni Valdarno', region: 'Toscana', province: 'Arezzo' },
  { name: 'Poggibonsi', region: 'Toscana', province: 'Siena' },
  { name: 'Colle di Val d\'Elsa', region: 'Toscana', province: 'Siena' },
  { name: 'Montepulciano', region: 'Toscana', province: 'Siena' },
  { name: 'Chioggia', region: 'Veneto', province: 'Venezia' },
  { name: 'San Donà di Piave', region: 'Veneto', province: 'Venezia' },
  { name: 'Mestre', region: 'Veneto', province: 'Venezia' },
  { name: 'Marghera', region: 'Veneto', province: 'Venezia' },
  { name: 'Mira', region: 'Veneto', province: 'Venezia' },
  { name: 'Spinea', region: 'Veneto', province: 'Venezia' },
  { name: 'Mirano', region: 'Veneto', province: 'Venezia' },
  { name: 'San Giovanni Lupatoto', region: 'Veneto', province: 'Verona' },
  { name: 'Villafranca di Verona', region: 'Veneto', province: 'Verona' },
  { name: 'Legnago', region: 'Veneto', province: 'Verona' },
  { name: 'Bussolengo', region: 'Veneto', province: 'Verona' },
  { name: 'San Bonifacio', region: 'Veneto', province: 'Verona' },
  { name: 'Abano Terme', region: 'Veneto', province: 'Padova' },
  { name: 'Cittadella', region: 'Veneto', province: 'Padova' },
  { name: 'Monselice', region: 'Veneto', province: 'Padova' },
  { name: 'Piove di Sacco', region: 'Veneto', province: 'Padova' },
  { name: 'Este', region: 'Veneto', province: 'Padova' },
  { name: 'Conegliano', region: 'Veneto', province: 'Treviso' },
  { name: 'Castelfranco Veneto', region: 'Veneto', province: 'Treviso' },
  { name: 'Vittorio Veneto', region: 'Veneto', province: 'Treviso' },
  { name: 'Montebelluna', region: 'Veneto', province: 'Treviso' },
  { name: 'Mogliano Veneto', region: 'Veneto', province: 'Treviso' },
  { name: 'Bassano del Grappa', region: 'Veneto', province: 'Vicenza' },
  { name: 'Schio', region: 'Veneto', province: 'Vicenza' },
  { name: 'Arzignano', region: 'Veneto', province: 'Vicenza' },
  { name: 'Valdagno', region: 'Veneto', province: 'Vicenza' },
  { name: 'Thiene', region: 'Veneto', province: 'Vicenza' },
  { name: 'Adria', region: 'Veneto', province: 'Rovigo' },
  { name: 'Porto Viro', region: 'Veneto', province: 'Rovigo' },
  { name: 'Feltre', region: 'Veneto', province: 'Belluno' },
  { name: 'Merano', region: 'Trentino-Alto Adige', province: 'Bolzano' },
  { name: 'Bressanone', region: 'Trentino-Alto Adige', province: 'Bolzano' },
  { name: 'Brunico', region: 'Trentino-Alto Adige', province: 'Bolzano' },
  { name: 'Laives', region: 'Trentino-Alto Adige', province: 'Bolzano' },
  { name: 'Rovereto', region: 'Trentino-Alto Adige', province: 'Trento' },
  { name: 'Pergine Valsugana', region: 'Trentino-Alto Adige', province: 'Trento' },
  { name: 'Arco', region: 'Trentino-Alto Adige', province: 'Trento' },
  { name: 'Riva del Garda', region: 'Trentino-Alto Adige', province: 'Trento' },
  { name: 'Monfalcone', region: 'Friuli-Venezia Giulia', province: 'Gorizia' },
  { name: 'Cividale del Friuli', region: 'Friuli-Venezia Giulia', province: 'Udine' },
  { name: 'Codroipo', region: 'Friuli-Venezia Giulia', province: 'Udine' },
  { name: 'Gemona del Friuli', region: 'Friuli-Venezia Giulia', province: 'Udine' },
  { name: 'Sacile', region: 'Friuli-Venezia Giulia', province: 'Pordenone' },
  { name: 'Chiavari', region: 'Liguria', province: 'Genova' },
  { name: 'Rapallo', region: 'Liguria', province: 'Genova' },
  { name: 'Sestri Levante', region: 'Liguria', province: 'Genova' },
  { name: 'Lavagna', region: 'Liguria', province: 'Genova' },
  { name: 'Sanremo', region: 'Liguria', province: 'Imperia' },
  { name: 'Ventimiglia', region: 'Liguria', province: 'Imperia' },
  { name: 'Bordighera', region: 'Liguria', province: 'Imperia' },
  { name: 'Sarzana', region: 'Liguria', province: 'La Spezia' },
  { name: 'Lerici', region: 'Liguria', province: 'La Spezia' },
  { name: 'Albenga', region: 'Liguria', province: 'Savona' },
  { name: 'Cairo Montenotte', region: 'Liguria', province: 'Savona' },
  { name: 'Varazze', region: 'Liguria', province: 'Savona' },
  { name: 'Casalecchio di Reno', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'San Lazzaro di Savena', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'Castel San Pietro Terme', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'Castel Maggiore', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'San Giovanni in Persiceto', region: 'Emilia-Romagna', province: 'Bologna' },
  { name: 'Carpi', region: 'Emilia-Romagna', province: 'Modena' },
  { name: 'Sassuolo', region: 'Emilia-Romagna', province: 'Modena' },
  { name: 'Formigine', region: 'Emilia-Romagna', province: 'Modena' },
  { name: 'Vignola', region: 'Emilia-Romagna', province: 'Modena' },
  { name: 'Castelfranco Emilia', region: 'Emilia-Romagna', province: 'Modena' },
  { name: 'Fidenza', region: 'Emilia-Romagna', province: 'Parma' },
  { name: 'Collecchio', region: 'Emilia-Romagna', province: 'Parma' },
  { name: 'Salsomaggiore Terme', region: 'Emilia-Romagna', province: 'Parma' },
  { name: 'Correggio', region: 'Emilia-Romagna', province: 'Reggio Emilia' },
  { name: 'Scandiano', region: 'Emilia-Romagna', province: 'Reggio Emilia' },
  { name: 'Guastalla', region: 'Emilia-Romagna', province: 'Reggio Emilia' },
  { name: 'Casalgrande', region: 'Emilia-Romagna', province: 'Reggio Emilia' },
  { name: 'Faenza', region: 'Emilia-Romagna', province: 'Ravenna' },
  { name: 'Lugo', region: 'Emilia-Romagna', province: 'Ravenna' },
  { name: 'Cervia', region: 'Emilia-Romagna', province: 'Ravenna' },
  { name: 'Cesenatico', region: 'Emilia-Romagna', province: 'Forlì-Cesena' },
  { name: 'Forlimpopoli', region: 'Emilia-Romagna', province: 'Forlì-Cesena' },
  { name: 'Riccione', region: 'Emilia-Romagna', province: 'Rimini' },
  { name: 'Cattolica', region: 'Emilia-Romagna', province: 'Rimini' },
  { name: 'Bellaria-Igea Marina', region: 'Emilia-Romagna', province: 'Rimini' },
  { name: 'Santarcangelo di Romagna', region: 'Emilia-Romagna', province: 'Rimini' },
  { name: 'Cento', region: 'Emilia-Romagna', province: 'Ferrara' },
  { name: 'Comacchio', region: 'Emilia-Romagna', province: 'Ferrara' },
  { name: 'Argenta', region: 'Emilia-Romagna', province: 'Ferrara' },
  { name: 'Casalpusterlengo', region: 'Lombardia', province: 'Lodi' },
  { name: 'Sant\'Angelo Lodigiano', region: 'Lombardia', province: 'Lodi' },
  { name: 'Codogno', region: 'Lombardia', province: 'Lodi' },
  { name: 'Merate', region: 'Lombardia', province: 'Lecco' },
  { name: 'Calolziocorte', region: 'Lombardia', province: 'Lecco' },
  { name: 'Vigevano', region: 'Lombardia', province: 'Pavia' },
  { name: 'Voghera', region: 'Lombardia', province: 'Pavia' },
  { name: 'Mortara', region: 'Lombardia', province: 'Pavia' },
  { name: 'Stradella', region: 'Lombardia', province: 'Pavia' },
  { name: 'Castiglione delle Stiviere', region: 'Lombardia', province: 'Mantova' },
  { name: 'Suzzara', region: 'Lombardia', province: 'Mantova' },
  { name: 'Viadana', region: 'Lombardia', province: 'Mantova' },
  { name: 'Asola', region: 'Lombardia', province: 'Mantova' },
  { name: 'Crema', region: 'Lombardia', province: 'Cremona' },
  { name: 'Casalmaggiore', region: 'Lombardia', province: 'Cremona' },
  { name: 'Desenzano del Garda', region: 'Lombardia', province: 'Brescia' },
  { name: 'Montichiari', region: 'Lombardia', province: 'Brescia' },
  { name: 'Lumezzane', region: 'Lombardia', province: 'Brescia' },
  { name: 'Palazzolo sull\'Oglio', region: 'Lombardia', province: 'Brescia' },
  { name: 'Manerbio', region: 'Lombardia', province: 'Brescia' },
  { name: 'Chiari', region: 'Lombardia', province: 'Brescia' },
  { name: 'Treviglio', region: 'Lombardia', province: 'Bergamo' },
  { name: 'Seriate', region: 'Lombardia', province: 'Bergamo' },
  { name: 'Dalmine', region: 'Lombardia', province: 'Bergamo' },
  { name: 'Romano di Lombardia', region: 'Lombardia', province: 'Bergamo' },
  { name: 'Albino', region: 'Lombardia', province: 'Bergamo' },
  { name: 'Cantù', region: 'Lombardia', province: 'Como' },
  { name: 'Erba', region: 'Lombardia', province: 'Como' },
  { name: 'Mariano Comense', region: 'Lombardia', province: 'Como' },
  { name: 'Olgiate Comasco', region: 'Lombardia', province: 'Como' },
  { name: 'Saronno', region: 'Lombardia', province: 'Varese' },
  { name: 'Tradate', region: 'Lombardia', province: 'Varese' },
  { name: 'Cassano Magnago', region: 'Lombardia', province: 'Varese' },
  { name: 'Luino', region: 'Lombardia', province: 'Varese' },
  { name: 'Malnate', region: 'Lombardia', province: 'Varese' },
  { name: 'Somma Lombardo', region: 'Lombardia', province: 'Varese' },
  { name: 'Limbiate', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Cesano Maderno', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Vimercate', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Muggiò', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Brugherio', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Giussano', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Meda', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Carate Brianza', region: 'Lombardia', province: 'Monza e Brianza' },
  { name: 'Cologno Monzese', region: 'Lombardia', province: 'Milano' },
  { name: 'Paderno Dugnano', region: 'Lombardia', province: 'Milano' },
  { name: 'Bollate', region: 'Lombardia', province: 'Milano' },
  { name: 'Corsico', region: 'Lombardia', province: 'Milano' },
  { name: 'Pioltello', region: 'Lombardia', province: 'Milano' },
  { name: 'Vimodrone', region: 'Lombardia', province: 'Milano' },
  { name: 'Segrate', region: 'Lombardia', province: 'Milano' },
  { name: 'Novate Milanese', region: 'Lombardia', province: 'Milano' },
  { name: 'Cernusco sul Naviglio', region: 'Lombardia', province: 'Milano' },
  { name: 'Buccinasco', region: 'Lombardia', province: 'Milano' },
  { name: 'Lainate', region: 'Lombardia', province: 'Milano' },
  { name: 'Gorgonzola', region: 'Lombardia', province: 'Milano' },
  { name: 'Cesano Boscone', region: 'Lombardia', province: 'Milano' },
  { name: 'Baranzate', region: 'Lombardia', province: 'Milano' },
  { name: 'Bresso', region: 'Lombardia', province: 'Milano' },
  { name: 'Pero', region: 'Lombardia', province: 'Milano' },
  { name: 'Settimo Milanese', region: 'Lombardia', province: 'Milano' },
  { name: 'San Donato Milanese', region: 'Lombardia', province: 'Milano' },
  { name: 'Peschiera Borromeo', region: 'Lombardia', province: 'Milano' },
  { name: 'Chieri', region: 'Piemonte', province: 'Torino' },
  { name: 'Ivrea', region: 'Piemonte', province: 'Torino' },
  { name: 'Pinerolo', region: 'Piemonte', province: 'Torino' },
  { name: 'Grugliasco', region: 'Piemonte', province: 'Torino' },
  { name: 'Orbassano', region: 'Piemonte', province: 'Torino' },
  { name: 'Venaria Reale', region: 'Piemonte', province: 'Torino' },
  { name: 'Alpignano', region: 'Piemonte', province: 'Torino' },
  { name: 'Piossasco', region: 'Piemonte', province: 'Torino' },
  { name: 'Druento', region: 'Piemonte', province: 'Torino' },
  { name: 'San Mauro Torinese', region: 'Piemonte', province: 'Torino' },
  { name: 'Volpiano', region: 'Piemonte', province: 'Torino' },
  { name: 'Beinasco', region: 'Piemonte', province: 'Torino' },
  { name: 'Carmagnola', region: 'Piemonte', province: 'Torino' },
  { name: 'Caselle Torinese', region: 'Piemonte', province: 'Torino' },
  { name: 'Chivasso', region: 'Piemonte', province: 'Torino' },
  { name: 'Leini', region: 'Piemonte', province: 'Torino' },
  { name: 'Cirié', region: 'Piemonte', province: 'Torino' },
  { name: 'Pianezza', region: 'Piemonte', province: 'Torino' },
  { name: 'Borgaro Torinese', region: 'Piemonte', province: 'Torino' },
  { name: 'Alba', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Bra', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Fossano', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Mondovì', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Savigliano', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Saluzzo', region: 'Piemonte', province: 'Cuneo' },
  { name: 'Casale Monferrato', region: 'Piemonte', province: 'Alessandria' },
  { name: 'Novi Ligure', region: 'Piemonte', province: 'Alessandria' },
  { name: 'Tortona', region: 'Piemonte', province: 'Alessandria' },
  { name: 'Acqui Terme', region: 'Piemonte', province: 'Alessandria' },
  { name: 'Valenza', region: 'Piemonte', province: 'Alessandria' },
  { name: 'Canelli', region: 'Piemonte', province: 'Asti' },
  { name: 'Nizza Monferrato', region: 'Piemonte', province: 'Asti' },
  { name: 'Borgomanero', region: 'Piemonte', province: 'Novara' },
  { name: 'Arona', region: 'Piemonte', province: 'Novara' },
  { name: 'Galliate', region: 'Piemonte', province: 'Novara' },
  { name: 'Trecate', region: 'Piemonte', province: 'Novara' },
  { name: 'Oleggio', region: 'Piemonte', province: 'Novara' },
  { name: 'Cossato', region: 'Piemonte', province: 'Biella' },
  { name: 'Candelo', region: 'Piemonte', province: 'Biella' },
  { name: 'Domodossola', region: 'Piemonte', province: 'Verbano-Cusio-Ossola' },
  { name: 'Omegna', region: 'Piemonte', province: 'Verbano-Cusio-Ossola' },
  { name: 'Gravellona Toce', region: 'Piemonte', province: 'Verbano-Cusio-Ossola' },
  { name: 'Borgosesia', region: 'Piemonte', province: 'Vercelli' },
  { name: 'Santhià', region: 'Piemonte', province: 'Vercelli' },
  { name: 'Trino', region: 'Piemonte', province: 'Vercelli' },
  { name: 'Assemini', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Selargius', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Capoterra', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Sestu', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Monserrato', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Quartucciu', region: 'Sardegna', province: 'Cagliari' },
  { name: 'Alghero', region: 'Sardegna', province: 'Sassari' },
  { name: 'Olbia', region: 'Sardegna', province: 'Sassari' },
  { name: 'Tempio Pausania', region: 'Sardegna', province: 'Sassari' },
  { name: 'Porto Torres', region: 'Sardegna', province: 'Sassari' },
  { name: 'Sorso', region: 'Sardegna', province: 'Sassari' },
  { name: 'Siniscola', region: 'Sardegna', province: 'Nuoro' },
  { name: 'Macomer', region: 'Sardegna', province: 'Nuoro' },
  { name: 'Terralba', region: 'Sardegna', province: 'Oristano' },
  { name: 'Cabras', region: 'Sardegna', province: 'Oristano' },
  { name: 'Iglesias', region: 'Sardegna', province: 'Sud Sardegna' },
  { name: 'Guspini', region: 'Sardegna', province: 'Sud Sardegna' },
  { name: 'Portoscuso', region: 'Sardegna', province: 'Sud Sardegna' },
  { name: 'Sant\'Antioco', region: 'Sardegna', province: 'Sud Sardegna' }
];

// Categorie OSM da importare
const CATEGORIES = [
  { name: 'Supermercati', tags: { shop: 'supermarket' } },
  { name: 'Alimentari', tags: { shop: 'convenience' } },
  { name: 'Panifici', tags: { shop: 'bakery' } },
  { name: 'Farmacie', tags: { amenity: 'pharmacy' } },
  { name: 'Ristoranti', tags: { amenity: 'restaurant' } },
  { name: 'Bar e Caffè', tags: { amenity: 'cafe' } },
  { name: 'Bar', tags: { amenity: 'bar' } },
  { name: 'Pizzerie', tags: { amenity: 'restaurant', cuisine: 'pizza' } },
  { name: 'Gelaterie', tags: { amenity: 'ice_cream' } },
  { name: 'Parrucchieri', tags: { shop: 'hairdresser' } },
  { name: 'Centri Estetici', tags: { shop: 'beauty' } },
  { name: 'Palestre', tags: { leisure: 'fitness_centre' } },
  { name: 'Stazioni di Servizio', tags: { amenity: 'fuel' } },
  { name: 'Banche', tags: { amenity: 'bank' } },
  { name: 'Uffici Postali', tags: { amenity: 'post_office' } },
  { name: 'Tabaccherie', tags: { shop: 'tobacco' } },
  { name: 'Edicole', tags: { shop: 'newsagent' } },
  { name: 'Librerie', tags: { shop: 'books' } },
  { name: 'Fiorai', tags: { shop: 'florist' } },
  { name: 'Ferramenta', tags: { shop: 'hardware' } },
  { name: 'Autofficine', tags: { shop: 'car_repair' } },
  { name: 'Lavanderie', tags: { shop: 'laundry' } },
  { name: 'Hotel', tags: { tourism: 'hotel' } },
  { name: 'B&B', tags: { tourism: 'guest_house' } },
  { name: 'Agenzie Immobiliari', tags: { office: 'estate_agent' } },
  { name: 'Dentisti', tags: { amenity: 'dentist' } },
  { name: 'Medici', tags: { amenity: 'doctors' } },
  { name: 'Veterinari', tags: { amenity: 'veterinary' } },
  { name: 'Ottici', tags: { shop: 'optician' } },
  { name: 'Negozi di Abbigliamento', tags: { shop: 'clothes' } },
  { name: 'Negozi di Scarpe', tags: { shop: 'shoes' } },
  { name: 'Gioiellerie', tags: { shop: 'jewelry' } },
  { name: 'Negozi di Elettronica', tags: { shop: 'electronics' } },
  { name: 'Negozi di Mobile', tags: { shop: 'furniture' } },
  { name: 'Macellerie', tags: { shop: 'butcher' } },
  { name: 'Pescherie', tags: { shop: 'seafood' } },
  { name: 'Frutta e Verdura', tags: { shop: 'greengrocer' } },
  { name: 'Enoteche', tags: { shop: 'wine' } },
  { name: 'Pasticcerie', tags: { shop: 'pastry' } },
  { name: 'Rosticcerie', tags: { shop: 'deli' } }
];

const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function fetchWithTimeout(url, options, timeoutMs = 30000) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, {
      ...options,
      signal: controller.signal
    });
    clearTimeout(timeoutId);
    return response;
  } catch (error) {
    clearTimeout(timeoutId);
    if (error.name === 'AbortError') {
      throw new Error('TIMEOUT');
    }
    throw error;
  }
}

async function fetchFromOverpass(city, category, retries = 2) {
  const overpassUrl = 'https://overpass-api.de/api/interpreter';

  let filters = Object.entries(category.tags)
    .map(([key, value]) => `["${key}"="${value}"]`)
    .join('');

  const query = `
    [out:json][timeout:60];
    area["name"="${city.name}"]["admin_level"~"^(8|9)$"]->.searchArea;
    (
      node${filters}(area.searchArea);
      way${filters}(area.searchArea);
      relation${filters}(area.searchArea);
    );
    out center;
  `;

  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const response = await fetchWithTimeout(overpassUrl, {
        method: 'POST',
        body: `data=${encodeURIComponent(query)}`,
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
      }, 35000);

      if (!response.ok) {
        if (response.status === 429 || response.status === 504) {
          if (attempt < retries) {
            await delay(10000);
            continue;
          }
        }
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      return { success: true, data: data.elements || [] };

    } catch (error) {
      if (error.message === 'TIMEOUT') {
        if (attempt < retries) {
          await delay(5000);
          continue;
        }
        return { success: false, error: 'TIMEOUT' };
      }
      if (attempt === retries) {
        return { success: false, error: error.message };
      }
      await delay(5000);
    }
  }

  return { success: false, error: 'MAX_RETRIES' };
}

// Trova o crea categoria
async function findOrCreateCategory(categoryName) {
  let { data: existing } = await supabase
    .from('business_categories')
    .select('id')
    .eq('name', categoryName)
    .maybeSingle();

  if (existing) return existing.id;

  const { data: created } = await supabase
    .from('business_categories')
    .insert({ name: categoryName, description: `Categoria: ${categoryName}` })
    .select('id')
    .single();

  return created?.id;
}

// Salva le attività nel database
async function saveBusinesses(businesses, categoryId, city) {
  if (businesses.length === 0) return 0;

  const records = businesses.map(b => ({
    name: b.tags?.name || b.tags?.brand || 'Senza nome',
    category_id: categoryId,
    street: b.tags?.['addr:street']
      ? `${b.tags['addr:street']} ${b.tags['addr:housenumber'] || ''}`.trim()
      : null,
    city: b.tags?.['addr:city'] || city.name,
    region: city.region,
    province: city.province,
    postal_code: b.tags?.['addr:postcode'] || null,
    country: 'Italia',
    latitude: b.lat || b.center?.lat,
    longitude: b.lon || b.center?.lon,
    phone: b.tags?.phone || b.tags?.['contact:phone'] || null,
    website: b.tags?.website || b.tags?.['contact:website'] || null,
    email: b.tags?.email || b.tags?.['contact:email'] || null,
    is_claimed: false
  }));

  const { error } = await supabase
    .from('unclaimed_business_locations')
    .insert(records);

  if (error) {
    console.log(`   ⚠️  Errore: ${error.message}`);
    return 0;
  }

  return records.length;
}

async function main() {
  console.log('\n╔════════════════════════════════════════════════════════════════════╗');
  console.log('║      IMPORTAZIONE OSM PER CATEGORIA - CITTÀ PRINCIPALI            ║');
  console.log('║                                                                    ║');
  console.log(`║ Categorie: ${CATEGORIES.length.toString().padStart(3)}  Città: ${MAJOR_CITIES.length.toString().padStart(3)}                                        ║`);
  console.log('╚════════════════════════════════════════════════════════════════════╝\n');

  const startTime = Date.now();
  let totalImported = 0;
  const results = [];
  const failedCities = [];

  for (let catIndex = 0; catIndex < CATEGORIES.length; catIndex++) {
    const category = CATEGORIES[catIndex];

    console.log('\n' + '='.repeat(70));
    console.log(`📦 CATEGORIA [${catIndex + 1}/${CATEGORIES.length}]: ${category.name}`);
    console.log('='.repeat(70));

    const categoryId = await findOrCreateCategory(category.name);
    let categoryTotal = 0;

    for (let cityIndex = 0; cityIndex < MAJOR_CITIES.length; cityIndex++) {
      const city = MAJOR_CITIES[cityIndex];

      process.stdout.write(`   [${(cityIndex + 1).toString().padStart(3)}/${MAJOR_CITIES.length}] ${city.name.padEnd(30)} `);

      const result = await fetchFromOverpass(city, category);

      if (result.success) {
        const saved = await saveBusinesses(result.data, categoryId, city);
        categoryTotal += saved;
        totalImported += saved;

        if (saved > 0) {
          console.log(`✅ ${saved}`);
        } else {
          console.log(`⚪ 0`);
        }
      } else {
        console.log(`⏭️  SKIP (${result.error})`);
        failedCities.push({
          city: city.name,
          category: category.name,
          error: result.error,
          categoryId
        });
      }

      await delay(1500);
    }

    results.push({
      category: category.name,
      total: categoryTotal
    });

    console.log(`\n   📊 Totale categoria: ${categoryTotal} attività`);
    await delay(3000);
  }

  if (failedCities.length > 0) {
    console.log('\n' + '='.repeat(70));
    console.log(`🔄 RIPROVO ${failedCities.length} CITTÀ FALLITE`);
    console.log('='.repeat(70));

    const stillFailed = [];
    let retryImported = 0;

    for (let i = 0; i < failedCities.length; i++) {
      const { city, category, categoryId } = failedCities[i];
      const cityData = MAJOR_CITIES.find(c => c.name === city);
      const categoryData = CATEGORIES.find(c => c.name === category);

      process.stdout.write(`   [${(i + 1).toString().padStart(3)}/${failedCities.length}] ${city.padEnd(25)} (${category.substring(0, 15).padEnd(15)}) `);

      const result = await fetchFromOverpass(cityData, categoryData);

      if (result.success) {
        const saved = await saveBusinesses(result.data, categoryId, cityData);
        retryImported += saved;
        totalImported += saved;
        console.log(`✅ ${saved}`);
      } else {
        console.log(`❌ ${result.error}`);
        stillFailed.push(failedCities[i]);
      }

      await delay(2000);
    }

    console.log(`\n   📊 Recuperate: ${retryImported} attività aggiuntive`);

    if (stillFailed.length > 0) {
      writeFileSync('failed-cities.json', JSON.stringify(stillFailed, null, 2));
      console.log(`   ⚠️  ${stillFailed.length} città ancora problematiche (salvate in failed-cities.json)`);
    }
  }

  const elapsed = ((Date.now() - startTime) / 1000 / 60).toFixed(1);

  console.log('\n' + '='.repeat(70));
  console.log('✅ IMPORTAZIONE COMPLETATA');
  console.log('='.repeat(70));
  console.log(`📊 Totale attività importate: ${totalImported}`);
  console.log(`⏱️  Tempo impiegato: ${elapsed} minuti`);
  console.log('\n📋 RIEPILOGO PER CATEGORIA:\n');

  results.forEach(r => {
    console.log(`   ${r.category.padEnd(35)} ${r.total.toString().padStart(6)} attività`);
  });

  writeFileSync('import-by-city-major-report.json', JSON.stringify(results, null, 2));
  console.log('\n💾 Report salvato in: import-by-city-major-report.json\n');
}

main().catch(console.error);
