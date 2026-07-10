export const ITALIAN_REGIONS = [
  'Abruzzo',
  'Basilicata',
  'Calabria',
  'Campania',
  'Emilia-Romagna',
  'Friuli-Venezia Giulia',
  'Lazio',
  'Liguria',
  'Lombardia',
  'Marche',
  'Molise',
  'Piemonte',
  'Puglia',
  'Sardegna',
  'Sicilia',
  'Toscana',
  'Trentino-Alto Adige',
  'Umbria',
  "Valle d'Aosta",
  'Veneto',
].sort();

export const PROVINCES_BY_REGION: Record<string, string[]> = {
  'Abruzzo': ['L\'Aquila', 'Teramo', 'Pescara', 'Chieti'],
  'Basilicata': ['Potenza', 'Matera'],
  'Calabria': ['Cosenza', 'Catanzaro', 'Reggio Calabria', 'Crotone', 'Vibo Valentia'],
  'Campania': ['Napoli', 'Salerno', 'Avellino', 'Benevento', 'Caserta'],
  'Emilia-Romagna': ['Bologna', 'Modena', 'Parma', 'Reggio Emilia', 'Ferrara', 'Ravenna', 'Forlì-Cesena', 'Rimini', 'Piacenza'],
  'Friuli-Venezia Giulia': ['Trieste', 'Udine', 'Pordenone', 'Gorizia'],
  'Lazio': ['Roma', 'Latina', 'Frosinone', 'Rieti', 'Viterbo'],
  'Liguria': ['Genova', 'La Spezia', 'Savona', 'Imperia'],
  'Lombardia': ['Milano', 'Bergamo', 'Brescia', 'Como', 'Cremona', 'Lecco', 'Lodi', 'Mantova', 'Monza e Brianza', 'Pavia', 'Sondrio', 'Varese'],
  'Marche': ['Ancona', 'Ascoli Piceno', 'Fermo', 'Macerata', 'Pesaro e Urbino'],
  'Molise': ['Campobasso', 'Isernia'],
  'Piemonte': ['Torino', 'Alessandria', 'Asti', 'Biella', 'Cuneo', 'Novara', 'Verbano-Cusio-Ossola', 'Vercelli'],
  'Puglia': ['Bari', 'Barletta-Andria-Trani', 'Brindisi', 'Foggia', 'Lecce', 'Taranto'],
  'Sardegna': ['Cagliari', 'Nuoro', 'Oristano', 'Sassari', 'Sud Sardegna'],
  'Sicilia': ['Palermo', 'Catania', 'Messina', 'Siracusa', 'Trapani', 'Agrigento', 'Caltanissetta', 'Enna', 'Ragusa'],
  'Toscana': ['Firenze', 'Arezzo', 'Grosseto', 'Livorno', 'Lucca', 'Massa-Carrara', 'Pisa', 'Pistoia', 'Prato', 'Siena'],
  'Trentino-Alto Adige': ['Trento', 'Bolzano'],
  'Umbria': ['Perugia', 'Terni'],
  "Valle d'Aosta": ['Aosta'],
  'Veneto': ['Venezia', 'Verona', 'Padova', 'Vicenza', 'Treviso', 'Belluno', 'Rovigo'],
};

export const ITALIAN_PROVINCES = [
  'Agrigento',
  'Alessandria',
  'Ancona',
  'Aosta',
  'Arezzo',
  'Ascoli Piceno',
  'Asti',
  'Avellino',
  'Bari',
  'Barletta-Andria-Trani',
  'Belluno',
  'Benevento',
  'Bergamo',
  'Biella',
  'Bologna',
  'Bolzano',
  'Brescia',
  'Brindisi',
  'Cagliari',
  'Caltanissetta',
  'Campobasso',
  'Caserta',
  'Catania',
  'Catanzaro',
  'Chieti',
  'Como',
  'Cosenza',
  'Cremona',
  'Crotone',
  'Cuneo',
  'Enna',
  'Fermo',
  'Ferrara',
  'Firenze',
  'Foggia',
  'Forlì-Cesena',
  'Frosinone',
  'Genova',
  'Gorizia',
  'Grosseto',
  'Imperia',
  'Isernia',
  'L\'Aquila',
  'La Spezia',
  'Latina',
  'Lecce',
  'Lecco',
  'Livorno',
  'Lodi',
  'Lucca',
  'Macerata',
  'Mantova',
  'Massa-Carrara',
  'Matera',
  'Messina',
  'Milano',
  'Modena',
  'Monza e Brianza',
  'Napoli',
  'Novara',
  'Nuoro',
  'Oristano',
  'Padova',
  'Palermo',
  'Parma',
  'Pavia',
  'Perugia',
  'Pesaro e Urbino',
  'Pescara',
  'Piacenza',
  'Pisa',
  'Pistoia',
  'Pordenone',
  'Potenza',
  'Prato',
  'Ragusa',
  'Ravenna',
  'Reggio Calabria',
  'Reggio Emilia',
  'Rieti',
  'Rimini',
  'Roma',
  'Rovigo',
  'Salerno',
  'Sassari',
  'Savona',
  'Siena',
  'Siracusa',
  'Sondrio',
  'Sud Sardegna',
  'Taranto',
  'Teramo',
  'Terni',
  'Torino',
  'Trapani',
  'Trento',
  'Treviso',
  'Trieste',
  'Udine',
  'Varese',
  'Venezia',
  'Verbano-Cusio-Ossola',
  'Vercelli',
  'Verona',
  'Vibo Valentia',
  'Vicenza',
  'Viterbo',
].sort();

export const CITIES_BY_PROVINCE: Record<string, string[]> = {
  'Agrigento': ['Agrigento', 'Licata', 'Canicattì', 'Sciacca', 'Favara', 'Palma di Montechiaro', 'Ribera', 'Porto Empedocle', 'Raffadali', 'Aragona', 'Menfi', 'Campobello di Licata', 'Ravanusa', 'Casteltermini', 'Naro', 'Racalmuto', 'Siculiana', 'Realmonte', 'Grotte', 'Cianciana', 'Montevago', 'Santa Margherita di Belice', 'Bivona', 'Sambuca di Sicilia', 'Cattolica Eraclea'].sort(),

  'Alessandria': ['Alessandria', 'Casale Monferrato', 'Novi Ligure', 'Tortona', 'Acqui Terme', 'Valenza', 'Ovada', 'Arquata Scrivia', 'Serravalle Scrivia', 'Castellazzo Bormida', 'Castelnuovo Scrivia', 'Sale', 'Cassine', 'Gavi', 'Nizza Monferrato', 'Canelli', 'Villanova Monferrato', 'Felizzano', 'Bosco Marengo', 'Frugarolo', 'Spinetta Marengo', 'Valmadonna', 'Fubine', 'Quattordio', 'Solero'].sort(),

  'Ancona': ['Ancona', 'Senigallia', 'Jesi', 'Fabriano', 'Osimo', 'Falconara Marittima', 'Castelfidardo', 'Chiaravalle', 'Loreto', 'Filottrano', 'Montemarciano', 'Agugliano', 'Camerano', 'Numana', 'Sirolo', 'Camerata Picena', 'Polverigi', 'Offagna', 'Staffolo', 'Cupramontana', 'Castelplanio', 'Monsano', 'Monte San Vito', 'Belvedere Ostrense', 'Morro d\'Alba'].sort(),

  'Aosta': ['Aosta', 'Saint-Vincent', 'Châtillon', 'Pont-Saint-Martin', 'Verrès', 'Courmayeur', 'Gressan', 'Sarre', 'Arnad', 'Quart', 'Donnas', 'Hône', 'Fénis', 'Nus', 'Gignod', 'Saint-Pierre', 'Pollein', 'Charvensod', 'Issogne', 'Champdepraz', 'La Salle', 'Morgex', 'Pré-Saint-Didier', 'Saint-Christophe', 'Brissogne'].sort(),

  'Arezzo': ['Arezzo', 'Cortona', 'San Giovanni Valdarno', 'Montevarchi', 'Bibbiena', 'Capolona', 'Sansepolcro', 'Castiglion Fiorentino', 'Foiano della Chiana', 'Monte San Savino', 'Terranuova Bracciolini', 'Loro Ciuffenna', 'Laterina Pergine Valdarno', 'Bucine', 'Cavriglia', 'Anghiari', 'Lucignano', 'Marciano della Chiana', 'Civitella in Val di Chiana', 'Castiglion Fibocchi', 'Subbiano', 'Chitignano', 'Chiusi della Verna', 'Talla', 'Ortignano Raggiolo'].sort(),

  'Ascoli Piceno': ['Ascoli Piceno', 'San Benedetto del Tronto', 'Grottammare', 'Montegranaro', 'Acquaviva Picena', 'Castel di Lama', 'Spinetoli', 'Folignano', 'Cupra Marittima', 'Colli del Tronto', 'Offida', 'Ripatransone', 'Monsampolo del Tronto', 'Monteprandone', 'Appignano del Tronto', 'Montalto delle Marche', 'Force', 'Arquata del Tronto', 'Roccafluvione', 'Venarotta', 'Palmiano', 'Castignano', 'Rotella', 'Comunanza', 'Montedinove'].sort(),

  'Asti': ['Asti', 'Canelli', 'Nizza Monferrato', 'Villanova d\'Asti', 'San Damiano d\'Asti', 'Costigliole d\'Asti', 'Castelnuovo Don Bosco', 'Incisa Scapaccino', 'Montegrosso d\'Asti', 'Moncalvo', 'Rocchetta Tanaro', 'Montechiaro d\'Asti', 'Castell\'Alfero', 'Portacomaro', 'Villafranca d\'Asti', 'Mombaruzzo', 'Tigliole', 'Dusino San Michele', 'Chiusano d\'Asti', 'Montemagno', 'Cortazzone', 'Cisterna d\'Asti', 'Castagnole delle Lanze', 'Calosso', 'Cassinasco'].sort(),

  'Avellino': ['Avellino', 'Ariano Irpino', 'Atripalda', 'Cervinara', 'Mercogliano', 'Monteforte Irpino', 'Solofra', 'Montoro', 'Grottaminarda', 'Avella', 'Mirabella Eclano', 'Montemiletto', 'Montella', 'Lauro', 'Baiano', 'Sperone', 'Mugnano del Cardinale', 'Forino', 'Contrada', 'Sant\'Angelo a Scala', 'Summonte', 'Castelvetere sul Calore', 'Gesualdo', 'Manocalzati', 'Pratola Serra'].sort(),

  'Bari': ['Bari', 'Altamura', 'Molfetta', 'Monopoli', 'Bitonto', 'Corato', 'Putignano', 'Gravina in Puglia', 'Triggiano', 'Modugno', 'Acquaviva delle Fonti', 'Ruvo di Puglia', 'Giovinazzo', 'Conversano', 'Noicàttaro', 'Gioia del Colle', 'Polignano a Mare', 'Capurso', 'Santeramo in Colle', 'Castellana Grotte', 'Valenzano', 'Grumo Appula', 'Palo del Colle', 'Casamassima', 'Turi'].sort(),

  'Barletta-Andria-Trani': ['Barletta', 'Andria', 'Trani', 'Bisceglie', 'Canosa di Puglia', 'Margherita di Savoia', 'Trinitapoli', 'San Ferdinando di Puglia', 'Minervino Murge', 'Spinazzola'].sort(),

  'Belluno': ['Belluno', 'Feltre', 'Sedico', 'Ponte nelle Alpi', 'Santa Giustina', 'Agordo', 'Longarone', 'Cortina d\'Ampezzo', 'Pieve di Cadore', 'Mel', 'Alpago', 'Auronzo di Cadore', 'Calalzo di Cadore', 'San Gregorio nelle Alpi', 'Sospirolo', 'Cesiomaggiore', 'Lamon', 'Fonzaso', 'Pedavena', 'Sovramonte', 'Limana', 'Borgo Valbelluna', 'Val di Zoldo', 'Colle Santa Lucia', 'Livinallongo del Col di Lana'].sort(),

  'Benevento': ['Benevento', 'Montesarchio', 'Sant\'Agata de\' Goti', 'Airola', 'Telese Terme', 'San Giorgio del Sannio', 'Apollosa', 'Dugenta', 'Moiano', 'Solopaca', 'San Marco dei Cavoti', 'San Bartolomeo in Galdo', 'Guardia Sanframondi', 'Paupisi', 'Castelvenere', 'Torrecuso', 'Bonea', 'Cautano', 'Paolisi', 'Ceppaloni', 'Arpaise', 'Forchia', 'Foglianise', 'Vitulano', 'San Leucio del Sannio'].sort(),

  'Bergamo': ['Bergamo', 'Treviglio', 'Seriate', 'Dalmine', 'Romano di Lombardia', 'Albino', 'Caravaggio', 'Alzano Lombardo', 'Stezzano', 'Osio Sotto', 'Nembro', 'Ponte San Pietro', 'Zogno', 'Clusone', 'Sarnico', 'Lovere', 'Grumello del Monte', 'Zanica', 'Trescore Balneario', 'Brembate', 'Scanzorosciate', 'Brusaporto', 'Calcinate', 'Grassobbio', 'Villa di Serio'].sort(),

  'Biella': ['Biella', 'Cossato', 'Candelo', 'Gaglianico', 'Valduggia', 'Andorno Micca', 'Cavaglià', 'Trivero', 'Vigliano Biellese', 'Mosso', 'Occhieppo Superiore', 'Occhieppo Inferiore', 'Ponderano', 'Sandigliano', 'Lessona', 'Masserano', 'Mongrando', 'Salussola', 'Crevacuore', 'Pray', 'Valdilana', 'Bioglio', 'Sostegno', 'Camburzano', 'Cerrione'].sort(),

  'Bologna': ['Bologna', 'Imola', 'Casalecchio di Reno', 'San Lazzaro di Savena', 'Castel San Pietro Terme', 'Castel Maggiore', 'Borgo Tossignano', 'Zola Predosa', 'San Giovanni in Persiceto', 'Molinella', 'Pianoro', 'Granarolo dell\'Emilia', 'Budrio', 'Anzola dell\'Emilia', 'Valsamoggia', 'Castenaso', 'Sasso Marconi', 'Medicina', 'Crevalcore', 'Sant\'Agata Bolognese', 'Calderara di Reno', 'Bentivoglio', 'Pieve di Cento', 'Malalbergo', 'Minerbio'].sort(),

  'Bolzano': ['Bolzano', 'Merano', 'Bressanone', 'Brunico', 'Laives', 'Egna', 'Vipiteno', 'Appiano sulla Strada del Vino', 'Chiusa', 'Silandro', 'Caldaro sulla Strada del Vino', 'Ortisei', 'Renon', 'Dobbiaco', 'San Candido', 'Selva di Val Gardena', 'Cortaccia sulla Strada del Vino', 'Naturno', 'Lana', 'Senales', 'Avelengo', 'Terlano', 'Marebbe', 'Corvara in Badia', 'Termeno sulla Strada del Vino'].sort(),

  'Brescia': ['Brescia', 'Desenzano del Garda', 'Montichiari', 'Lumezzane', 'Palazzolo sull\'Oglio', 'Manerbio', 'Chiari', 'Rezzato', 'Ghedi', 'Rovato', 'Gardone Val Trompia', 'Gussago', 'Concesio', 'Orzinuovi', 'Salò', 'Lonato del Garda', 'Castegnato', 'Nave', 'Ospitaletto', 'Leno', 'Botticino', 'Travagliato', 'Borgosatollo', 'Bagnolo Mella', 'Flero'].sort(),

  'Brindisi': ['Brindisi', 'Francavilla Fontana', 'Fasano', 'Ostuni', 'Mesagne', 'San Vito dei Normanni', 'Ceglie Messapica', 'Latiano', 'San Pietro Vernotico', 'Carovigno', 'Erchie', 'Oria', 'San Pancrazio Salentino', 'Torre Santa Susanna', 'Cellino San Marco', 'San Donaci', 'Cisternino', 'San Michele Salentino', 'Torchiarolo', 'Villa Castelli'].sort(),

  'Cagliari': ['Cagliari', 'Quartu Sant\'Elena', 'Assemini', 'Selargius', 'Capoterra', 'Sestu', 'Monserrato', 'Quartucciu', 'Sinnai', 'Elmas', 'Uta', 'Decimomannu', 'Maracalagonis', 'Villa San Pietro', 'Sarroch', 'Pula', 'Domus de Maria', 'Settimo San Pietro', 'Soleminis', 'Burcei'].sort(),

  'Caltanissetta': ['Caltanissetta', 'Gela', 'Niscemi', 'Mussomeli', 'San Cataldo', 'Mazzarino', 'Riesi', 'Sommatino', 'Serradifalco', 'Butera', 'Milena', 'Campofranco', 'Acquaviva Platani', 'Vallelunga Pratameno', 'Villalba', 'Marianopoli', 'Montedoro', 'Delia', 'Bompensiere', 'Resuttano'].sort(),

  'Campobasso': ['Campobasso', 'Termoli', 'Larino', 'Venafro', 'Bojano', 'Campomarino', 'Riccia', 'Guglionesi', 'Santa Croce di Magliano', 'Agnone', 'Petacciato', 'Montenero di Bisaccia', 'San Martino in Pensilis', 'Trivento', 'Casacalenda', 'Colletorto', 'Portocannone', 'Montorio nei Frentani', 'Ururi', 'Gambatesa'].sort(),

  'Caserta': ['Caserta', 'Aversa', 'Marcianise', 'Maddaloni', 'Santa Maria Capua Vetere', 'Mondragone', 'San Nicola la Strada', 'Capua', 'Orta di Atella', 'Recale', 'San Prisco', 'Casagiove', 'Macerata Campania', 'Gricignano di Aversa', 'Casal di Principe', 'Teverola', 'Succivo', 'Lusciano', 'Villa Literno', 'Cancello ed Arnone', 'Casapesenna', 'Teano', 'Sessa Aurunca', 'Piedimonte Matese', 'Sparanise'].sort(),

  'Catania': ['Catania', 'Acireale', 'Misterbianco', 'Paternò', 'Adrano', 'Mascalucia', 'Belpasso', 'Giarre', 'Gravina di Catania', 'Caltagirone', 'Tremestieri Etneo', 'San Giovanni La Punta', 'Aci Castello', 'Nicolosi', 'Pedara', 'Viagrande', 'Valverde', 'Aci Catena', 'San Pietro Clarenza', 'Sant\'Agata li Battiati', 'Biancavilla', 'Ramacca', 'Scordia', 'Militello in Val di Catania', 'Grammichele'].sort(),

  'Catanzaro': ['Catanzaro', 'Lamezia Terme', 'Soverato', 'Sellia Marina', 'Chiaravalle Centrale', 'Girifalco', 'Squillace', 'Cropani', 'Simeri Crichi', 'Davoli', 'Borgia', 'Gasperina', 'Montepaone', 'Stalettì', 'Montauro', 'Satriano', 'Guardavalle', 'Sant\'Andrea Apostolo dello Ionio', 'Isca sullo Ionio', 'Badolato', 'Santa Caterina dello Ionio', 'Cortale', 'Maida', 'Curinga', 'Jacurso'].sort(),

  'Chieti': ['Chieti', 'Vasto', 'Lanciano', 'Francavilla al Mare', 'Ortona', 'San Salvo', 'Guardiagrele', 'Atessa', 'San Giovanni Teatino', 'Casoli', 'Fossacesia', 'Casalbordino', 'Torino di Sangro', 'Bucchianico', 'Orsogna', 'Ripa Teatina', 'Miglianico', 'Tollo', 'Torrevecchia Teatina', 'Paglieta', 'Gissi', 'Cupello', 'Rocca San Giovanni', 'Pollutri', 'Mozzagrogna'].sort(),

  'Como': ['Como', 'Cantù', 'Erba', 'Mariano Comense', 'Olgiate Comasco', 'Lomazzo', 'Lurate Caccivio', 'Menaggio', 'Cernobbio', 'Lipomo', 'Grandate', 'Fino Mornasco', 'Inverigo', 'Cabiate', 'Locate Varesino', 'Lurago d\'Erba', 'Moltrasio', 'Laglio', 'Brienno', 'Argegno', 'Sala Comacina', 'Ossuccio', 'Tremezzina', 'Gravedona ed Uniti', 'Dongo'].sort(),

  'Cosenza': ['Cosenza', 'Rende', 'Corigliano-Rossano', 'Castrovillari', 'Paola', 'Montalto Uffugo', 'San Giovanni in Fiore', 'Acri', 'Cassano all\'Ionio', 'Corigliano Calabro', 'Rossano', 'Scalea', 'Cariati', 'Fagnano Castello', 'Amantea', 'Mendicino', 'Bisignano', 'San Marco Argentano', 'Trebisacce', 'Amendolara', 'Villapiana', 'Roggiano Gravina', 'Terranova da Sibari', 'Cetraro', 'Belvedere Marittimo'].sort(),

  'Cremona': ['Cremona', 'Crema', 'Casalmaggiore', 'Soresina', 'Castelleone', 'Pizzighettone', 'Pandino', 'Rivolta d\'Adda', 'Spino d\'Adda', 'Ostiano', 'Vaiano Cremasco', 'Izano', 'Offanengo', 'Romanengo', 'Agnadello', 'Sergnano', 'Bagnolo Cremasco', 'Montodine', 'Madignano', 'Vailate', 'Trescore Cremasco', 'Capergnanica', 'Salvirola', 'Torlino Vimercati', 'Campagnola Cremasca'].sort(),

  'Crotone': ['Crotone', 'Cirò Marina', 'Cutro', 'Isola di Capo Rizzuto', 'Petilia Policastro', 'Mesoraca', 'Rocca di Neto', 'Strongoli', 'Scandale', 'Cotronei', 'San Mauro Marchesato', 'Belvedere di Spinello', 'Santa Severina', 'Casabona', 'Umbriatico', 'Verzino', 'Pallagorio', 'San Nicola dell\'Alto', 'Rocca Bernarda', 'Carfizzi'].sort(),

  'Cuneo': ['Cuneo', 'Alba', 'Bra', 'Fossano', 'Mondovì', 'Savigliano', 'Saluzzo', 'Borgo San Dalmazzo', 'Racconigi', 'Busca', 'Cherasco', 'Dronero', 'Moretta', 'Caraglio', 'Sommariva del Bosco', 'Centallo', 'Boves', 'Limone Piemonte', 'Verzuolo', 'Carrù', 'Cavallermaggiore', 'Marene', 'Trinità', 'Sanfrè', 'Cervere'].sort(),

  'Enna': ['Enna', 'Piazza Armerina', 'Leonforte', 'Nicosia', 'Barrafranca', 'Agira', 'Centuripe', 'Valguarnera Caropepe', 'Aidone', 'Regalbuto', 'Troina', 'Calascibetta', 'Gagliano Castelferrato', 'Pietraperzia', 'Assoro', 'Catenanuova', 'Villarosa', 'Cerami', 'Sperlinga', 'Nissoria'].sort(),

  'Fermo': ['Fermo', 'Porto Sant\'Elpidio', 'Sant\'Elpidio a Mare', 'Porto San Giorgio', 'Montegranaro', 'Monte Urano', 'Montegiorgio', 'Civitanova Marche', 'Amandola', 'Grottazzolina', 'Montottone', 'Rapagnano', 'Magliano di Tenna', 'Francavilla d\'Ete', 'Torre San Patrizio', 'Santa Vittoria in Matenano', 'Belmonte Piceno', 'Massa Fermana', 'Servigliano', 'Ponzano di Fermo', 'Altidona', 'Campofilone', 'Lapedona', 'Moresco', 'Monterubbiano'].sort(),

  'Ferrara': ['Ferrara', 'Cento', 'Comacchio', 'Argenta', 'Bondeno', 'Codigoro', 'Copparo', 'Portomaggiore', 'Lido degli Estensi', 'Mesola', 'Vigarano Mainarda', 'Fiscaglia', 'Terre del Reno', 'Lagosanto', 'Tresigallo', 'Formignana', 'Jolanda di Savoia', 'Goro', 'Berra', 'Riva del Po', 'Ostellato', 'Voghiera', 'Poggio Renatico', 'Masi Torello', 'Sant\'Agostino'].sort(),

  'Firenze': ['Firenze', 'Sesto Fiorentino', 'Scandicci', 'Empoli', 'Campi Bisenzio', 'Figline e Incisa Valdarno', 'Bagno a Ripoli', 'Borgo San Lorenzo', 'Pontassieve', 'Lastra a Signa', 'Signa', 'Barberino di Mugello', 'Scarperia e San Piero', 'Calenzano', 'Greve in Chianti', 'Impruneta', 'Vinci', 'Fucecchio', 'Cerreto Guidi', 'Castelfiorentino', 'Certaldo', 'Montespertoli', 'Capraia e Limite', 'Montelupo Fiorentino', 'Rignano sull\'Arno'].sort(),

  'Foggia': ['Foggia', 'Cerignola', 'Manfredonia', 'San Severo', 'Lucera', 'Orta Nova', 'Apricena', 'San Giovanni Rotondo', 'Torremaggiore', 'Vieste', 'Foggia', 'Bovino', 'Ordona', 'Stornara', 'Stornarella', 'Castelluccio dei Sauri', 'San Marco in Lamis', 'Monte Sant\'Angelo', 'Mattinata', 'Rignano Garganico', 'San Nicandro Garganico', 'Cagnano Varano', 'Carpino', 'Ischitella', 'Vico del Gargano'].sort(),

  'Forlì-Cesena': ['Forlì', 'Cesena', 'Cesenatico', 'Forlimpopoli', 'Savignano sul Rubicone', 'Gatteo', 'Bertinoro', 'Meldola', 'San Mauro Pascoli', 'Castrocaro Terme', 'Longiano', 'Gambettola', 'Bagno di Romagna', 'Predappio', 'Santa Sofia', 'Rocca San Casciano', 'Modigliana', 'Portico e San Benedetto', 'Dovadola', 'Galeata', 'Civitella di Romagna', 'Montiano', 'Roncofreddo', 'Borghi', 'Sogliano al Rubicone'].sort(),

  'Frosinone': ['Frosinone', 'Cassino', 'Sora', 'Ceccano', 'Alatri', 'Ferentino', 'Anagni', 'Pontecorvo', 'Veroli', 'Monte San Giovanni Campano', 'Fiuggi', 'Aquino', 'Boville Ernica', 'Roccasecca', 'Isola del Liri', 'Castro dei Volsci', 'Cervaro', 'Paliano', 'Arnara', 'Piedimonte San Germano', 'Villa Santa Lucia', 'Supino', 'Patrica', 'Morolo', 'Fumone'].sort(),

  'Genova': ['Genova', 'Chiavari', 'Rapallo', 'Sestri Levante', 'Lavagna', 'Recco', 'Arenzano', 'Cogoleto', 'Camogli', 'Santa Margherita Ligure', 'Bogliasco', 'Pieve Ligure', 'Sori', 'Nervi', 'Sturla', 'Quarto', 'Voltri', 'Pegli', 'Busalla', 'Ronco Scrivia', 'Serra Riccò', 'Campomorone', 'Ceranesi', 'Mignanego', 'Sant\'Olcese'].sort(),

  'Gorizia': ['Gorizia', 'Monfalcone', 'Gradisca d\'Isonzo', 'Grado', 'Cormons', 'Ronchi dei Legionari', 'Staranzano', 'San Canzian d\'Isonzo', 'Fogliano Redipuglia', 'Turriaco', 'San Pier d\'Isonzo', 'Sagrado', 'Villesse', 'Farra d\'Isonzo', 'Mariano del Friuli', 'Capriva del Friuli', 'Mossa', 'San Lorenzo Isontino', 'Moraro', 'Doberdò del Lago', 'Savogna d\'Isonzo', 'Dolegna del Collio', 'San Floriano del Collio', 'Gorizia', 'Romans d\'Isonzo'].sort(),

  'Grosseto': ['Grosseto', 'Follonica', 'Orbetello', 'Massa Marittima', 'Castiglione della Pescaia', 'Roccastrada', 'Monte Argentario', 'Manciano', 'Gavorrano', 'Pitigliano', 'Capalbio', 'Monterotondo Marittimo', 'Scansano', 'Sorano', 'Arcidosso', 'Santa Fiora', 'Semproniano', 'Seggiano', 'Castell\'Azzara', 'Castel del Piano', 'Cinigiano', 'Roccalbegna', 'Campagnatico', 'Civitella Paganico', 'Scarlino'].sort(),

  'Imperia': ['Imperia', 'Sanremo', 'Ventimiglia', 'Bordighera', 'Taggia', 'Diano Marina', 'Camporosso', 'Arma di Taggia', 'Vallecrosia', 'Riva Ligure', 'San Bartolomeo al Mare', 'Cervo', 'Castellaro', 'Dolcedo', 'Pieve di Teco', 'Pontedassio', 'Airole', 'Apricale', 'Badalucco', 'Bajardo', 'Borghetto d\'Arroscia', 'Borgomaro', 'Caravonica', 'Castel Vittorio', 'Castellaro'].sort(),

  'Isernia': ['Isernia', 'Venafro', 'Agnone', 'Bojano', 'Miranda', 'Pozzilli', 'Macchia d\'Isernia', 'Pettoranello del Molise', 'Roccamandolfi', 'Santa Maria del Molise', 'Frosolone', 'Sessano del Molise', 'Castelpetroso', 'Colli a Volturno', 'Monteroduni', 'Vastogirardi', 'Pescolanciano', 'Pietrabbondante', 'Capracotta', 'Sant\'Elena Sannita', 'Carovilli', 'San Pietro Avellana', 'Scapoli', 'Filignano', 'Sesto Campano'].sort(),

  'L\'Aquila': ['L\'Aquila', 'Avezzano', 'Sulmona', 'Celano', 'Pratola Peligna', 'Tagliacozzo', 'Carsoli', 'Trasacco', 'Castel di Sangro', 'Luco dei Marsi', 'Rocca di Mezzo', 'Roccaraso', 'Ovindoli', 'Pescasseroli', 'Scanno', 'Villalago', 'Anversa degli Abruzzi', 'Barisciano', 'Calascio', 'Capitignano', 'Caporciano', 'Cappadocia', 'Carapelle Calvisio', 'Castel del Monte', 'Castelvecchio Calvisio'].sort(),

  'La Spezia': ['La Spezia', 'Sarzana', 'Lerici', 'Vezzano Ligure', 'Santo Stefano di Magra', 'Arcola', 'Ortonovo', 'Levanto', 'Portovenere', 'Castelnuovo Magra', 'Luni', 'Ameglia', 'Bolano', 'Follo', 'Beverino', 'Borghetto di Vara', 'Brugnato', 'Calice al Cornoviglio', 'Carro', 'Carrodano', 'Deiva Marina', 'Framura', 'Maissana', 'Monterosso al Mare', 'Vernazza'].sort(),

  'Latina': ['Latina', 'Aprilia', 'Terracina', 'Formia', 'Cisterna di Latina', 'Fondi', 'Sabaudia', 'Pontinia', 'Sezze', 'Gaeta', 'Priverno', 'Minturno', 'Sonnino', 'Cori', 'Sermoneta', 'Norma', 'Roccagorga', 'Maenza', 'Roccasecca dei Volsci', 'Bassiano', 'Prossedi', 'Lenola', 'Monte San Biagio', 'Spigno Saturnia', 'Itri'].sort(),

  'Lecce': ['Lecce', 'Nardò', 'Copertino', 'Galatina', 'Casarano', 'Gallipoli', 'Trepuzzi', 'Squinzano', 'Surbo', 'Tricase', 'Leverano', 'Carmiano', 'Cavallino', 'Lizzanello', 'Novoli', 'Veglie', 'Arnesano', 'San Pietro in Lama', 'Lecce', 'Monteroni di Lecce', 'Campi Salentina', 'San Donato di Lecce', 'Vernole', 'Calimera', 'Martano'].sort(),

  'Lecco': ['Lecco', 'Merate', 'Calolziocorte', 'Bellano', 'Mandello del Lario', 'Oggiono', 'Olginate', 'Barzanò', 'Casatenovo', 'Colico', 'Valmadrera', 'Osnago', 'Galbiate', 'Cernusco Lombardone', 'Malgrate', 'Brivio', 'Sirone', 'Dolzago', 'Missaglia', 'Montevecchia', 'Nibionno', 'Rogeno', 'Airuno', 'Verderio', 'La Valletta Brianza'].sort(),

  'Livorno': ['Livorno', 'Piombino', 'Cecina', 'Rosignano Marittimo', 'Portoferraio', 'Collesalvetti', 'Campiglia Marittima', 'Castagneto Carducci', 'San Vincenzo', 'Venturina Terme', 'Marciana', 'Campo nell\'Elba', 'Rio', 'Capoliveri', 'Porto Azzurro', 'Marciana Marina', 'Suvereto', 'Sassetta', 'Bibbona', 'Rosignano Solvay'].sort(),

  'Lodi': ['Lodi', 'Casalpusterlengo', 'Sant\'Angelo Lodigiano', 'Codogno', 'Lodi Vecchio', 'Tavazzano con Villavesco', 'Casaletto Lodigiano', 'Zelo Buon Persico', 'Massalengo', 'Borghetto Lodigiano', 'Somaglia', 'San Fiorano', 'Guardamiglio', 'Graffignana', 'Caselle Lurani', 'Ossago Lodigiano', 'Secugnago', 'Turano Lodigiano', 'Villanova del Sillaro', 'Galgagnano', 'Valera Fratta', 'Crespiatica', 'Cavenago d\'Adda', 'Mairago', 'Montanaso Lombardo'].sort(),

  'Lucca': ['Lucca', 'Viareggio', 'Capannori', 'Camaiore', 'Pietrasanta', 'Massarosa', 'Altopascio', 'Porcari', 'Forte dei Marmi', 'Borgo a Mozzano', 'Bagni di Lucca', 'Barga', 'Castelnuovo di Garfagnana', 'Seravezza', 'Stazzema', 'Pescaglia', 'Villa Basilica', 'Montecarlo', 'Villa Collemandina', 'Coreglia Antelminelli', 'Fabbriche di Vergemoli', 'Fosciandora', 'Gallicano', 'Giuncugnano', 'Minucciano'].sort(),

  'Macerata': ['Macerata', 'Civitanova Marche', 'Corridonia', 'Recanati', 'Tolentino', 'Potenza Picena', 'Porto Recanati', 'Morrovalle', 'Montecosaro', 'Mogliano', 'Pollenza', 'Treia', 'Appignano', 'Monte San Giusto', 'San Severino Marche', 'Camerino', 'Cingoli', 'Sarnano', 'Matelica', 'Belforte del Chienti', 'Colmurano', 'Monte San Martino', 'Loro Piceno', 'San Ginesio', 'Cessapalombo'].sort(),

  'Mantova': ['Mantova', 'Castiglione delle Stiviere', 'Suzzara', 'Viadana', 'Asola', 'Castel Goffredo', 'Gonzaga', 'Porto Mantovano', 'Guidizzolo', 'Virgilio', 'Volta Mantovana', 'Roncoferraro', 'Curtatone', 'Sermide e Felonica', 'San Benedetto Po', 'Pegognaga', 'Castelbelforte', 'Goito', 'Casaloldo', 'Ceresara', 'Castellucchio', 'Medole', 'Cavriana', 'Solferino', 'Castel d\'Ario'].sort(),

  'Massa-Carrara': ['Massa', 'Carrara', 'Montignoso', 'Fivizzano', 'Aulla', 'Pontremoli', 'Fosdinovo', 'Marina di Massa', 'Licciana Nardi', 'Villafranca in Lunigiana', 'Bagnone', 'Comano', 'Filattiera', 'Podenzana', 'Tresana', 'Zeri', 'Mulazzo'].sort(),

  'Matera': ['Matera', 'Pisticci', 'Policoro', 'Montalbano Jonico', 'Nova Siri', 'Bernalda', 'Scanzano Jonico', 'Tursi', 'Stigliano', 'Ferrandina', 'Irsina', 'Tricarico', 'Grassano', 'Montescaglioso', 'Rotondella', 'Colobraro', 'Valsinni', 'Accettura', 'Aliano', 'Cirigliano', 'Craco', 'Garaguso', 'Gorgoglione', 'Oliveto Lucano', 'Salandra'].sort(),

  'Messina': ['Messina', 'Barcellona Pozzo di Gotto', 'Milazzo', 'Patti', 'Sant\'Agata di Militello', 'Taormina', 'Lipari', 'Giardini-Naxos', 'Capo d\'Orlando', 'Spadafora', 'Pace del Mela', 'Villafranca Tirrena', 'Santa Teresa di Riva', 'Rometta', 'Gioiosa Marea', 'Tortorici', 'Santo Stefano di Camastra', 'Furnari', 'Terme Vigliatore', 'Roccalumera', 'Scaletta Zanclea', 'Alì Terme', 'Nizza di Sicilia', 'Letojanni', 'Casalvecchio Siculo'].sort(),

  'Milano': ['Milano', 'Sesto San Giovanni', 'Cinisello Balsamo', 'Rho', 'Cologno Monzese', 'Legnano', 'Paderno Dugnano', 'Bollate', 'Monza', 'Corsico', 'Pioltello', 'Vimodrone', 'Segrate', 'Novate Milanese', 'Cernusco sul Naviglio', 'Buccinasco', 'Lainate', 'Gorgonzola', 'Cesano Boscone', 'Baranzate', 'Bresso', 'Pero', 'Settimo Milanese', 'San Donato Milanese', 'Peschiera Borromeo'].sort(),

  'Modena': ['Modena', 'Carpi', 'Sassuolo', 'Formigine', 'Vignola', 'Castelfranco Emilia', 'Mirandola', 'Fiorano Modenese', 'Maranello', 'Pavullo nel Frignano', 'Novi di Modena', 'Castelnuovo Rangone', 'Spilamberto', 'San Felice sul Panaro', 'Finale Emilia', 'Campogalliano', 'Nonantola', 'Concordia sulla Secchia', 'San Cesario sul Panaro', 'Castelvetro di Modena', 'Ravarino', 'Savignano sul Panaro', 'San Possidonio', 'Soliera', 'Bomporto'].sort(),

  'Monza e Brianza': ['Monza', 'Desio', 'Seregno', 'Lissone', 'Limbiate', 'Cesano Maderno', 'Vimercate', 'Muggiò', 'Brugherio', 'Giussano', 'Meda', 'Carate Brianza', 'Nova Milanese', 'Arcore', 'Bovisio-Masciago', 'Seveso', 'Biassono', 'Vedano al Lambro', 'Besana in Brianza', 'Sovico', 'Concorezzo', 'Verano Brianza', 'Albiate', 'Agrate Brianza', 'Triuggio'].sort(),

  'Napoli': ['Napoli', 'Torre del Greco', 'Pozzuoli', 'Giugliano in Campania', 'Castellammare di Stabia', 'Afragola', 'Marano di Napoli', 'Portici', 'Ercolano', 'Acerra', 'Casoria', 'Qualiano', 'Arzano', 'Bacoli', 'Villaricca', 'Nola', 'San Giorgio a Cremano', 'Sant\'Antimo', 'Somma Vesuviana', 'Marigliano', 'Pomigliano d\'Arco', 'Monte di Procida', 'Quarto', 'Pompei', 'Vico Equense'].sort(),

  'Novara': ['Novara', 'Borgomanero', 'Arona', 'Galliate', 'Trecate', 'Oleggio', 'Cameri', 'Castelletto sopra Ticino', 'Granozzo con Monticello', 'Romentino', 'Cerano', 'Bellinzago Novarese', 'Carpignano Sesia', 'Ghemme', 'Biandrate', 'Sizzano', 'Romagnano Sesia', 'Suno', 'Vespolate', 'Vicolungo', 'Nibbiola', 'Novara', 'Gozzano', 'Briga Novarese', 'Dormelletto'].sort(),

  'Nuoro': ['Nuoro', 'Siniscola', 'Macomer', 'Dorgali', 'Orosei', 'Bitti', 'Tortolì', 'Fonni', 'Oliena', 'Orune', 'Ottana', 'Orgosolo', 'Onifai', 'Lula', 'Posada', 'Budoni', 'Lodè', 'Torpè', 'Irgoli', 'Galtellì', 'Onanì', 'Oniferi', 'Sarule', 'Ollolai', 'Gavoi'].sort(),

  'Oristano': ['Oristano', 'Terralba', 'Cabras', 'Ghilarza', 'Bosa', 'Marrubiu', 'Santa Giusta', 'Ales', 'Cuglieri', 'Abbasanta', 'Arborea', 'Oristano', 'Paulilatino', 'Narbolia', 'Riola Sardo', 'San Vero Milis', 'Tramatza', 'Zeddiani', 'Baratili San Pietro', 'Simaxis', 'Siamanna', 'Siapiccia', 'Solarussa', 'Zerfaliu', 'Nurachi'].sort(),

  'Padova': ['Padova', 'Abano Terme', 'Cittadella', 'Monselice', 'Piove di Sacco', 'Este', 'Cadoneghe', 'Vigonza', 'Selvazzano Dentro', 'Albignasego', 'Rubano', 'Limena', 'Noventa Padovana', 'Campodarsego', 'Montegrotto Terme', 'Saonara', 'Ponte San Nicolò', 'Vigodarzere', 'Villafranca Padovana', 'Mestrino', 'Teolo', 'Trebaseleghe', 'Camposampiero', 'Borgoricco', 'Massanzago'].sort(),

  'Palermo': ['Palermo', 'Bagheria', 'Carini', 'Partinico', 'Monreale', 'Termini Imerese', 'Misilmeri', 'Villabate', 'Ficarazzi', 'Cinisi', 'Altofonte', 'Capaci', 'Isola delle Femmine', 'Casteldaccia', 'Santa Flavia', 'Terrasini', 'Corleone', 'Petralia Sottana', 'Cefalù', 'Castelbuono', 'Gangi', 'Polizzi Generosa', 'Caccamo', 'Ciminna', 'Trabia'].sort(),

  'Parma': ['Parma', 'Fidenza', 'Collecchio', 'Salsomaggiore Terme', 'Langhirano', 'Noceto', 'Medesano', 'Traversetolo', 'Fontanellato', 'Fornovo di Taro', 'Sorbolo Mezzani', 'San Secondo Parmense', 'Felino', 'Montechiarugolo', 'Fontevivo', 'Busseto', 'Colorno', 'Soragna', 'Roccabianca', 'Polesine Zibello', 'Trecasali', 'Torrile', 'Parma', 'Sissa Trecasali', 'Bardi'].sort(),

  'Pavia': ['Pavia', 'Vigevano', 'Voghera', 'Mortara', 'Stradella', 'Casteggio', 'Broni', 'Garlasco', 'Siziano', 'Belgioioso', 'San Martino Siccomario', 'Certosa di Pavia', 'Torre d\'Isola', 'Cava Manara', 'Villanterio', 'Vidigulfo', 'Pieve Porto Morone', 'Bereguardo', 'Landriano', 'Zerbolò', 'Trivolzio', 'Marcignago', 'Borgarello', 'Carbonara al Ticino', 'Cassolnovo'].sort(),

  'Perugia': ['Perugia', 'Foligno', 'Città di Castello', 'Gubbio', 'Assisi', 'Spoleto', 'Bastia Umbra', 'Corciano', 'Terni', 'Umbertide', 'Todi', 'Marsciano', 'Gualdo Tadino', 'Castiglione del Lago', 'Deruta', 'Perugia', 'San Giustino', 'Passignano sul Trasimeno', 'Magione', 'Nocera Umbra', 'Spello', 'Bevagna', 'Trevi', 'Collazzone', 'Cannara'].sort(),

  'Pesaro e Urbino': ['Pesaro', 'Fano', 'Urbino', 'Fossombrone', 'Gabicce Mare', 'Mondolfo', 'Marotta', 'Cattolica', 'Pergola', 'Cagli', 'Sant\'Angelo in Vado', 'Sassocorvaro Auditore', 'Urbania', 'Montecalvo in Foglia', 'Tavullia', 'Gradara', 'Mombaroccio', 'Saltara', 'Montefelcino', 'Vallefoglia', 'Cartoceto', 'San Costanzo', 'Fratte Rosa', 'Acqualagna', 'Cantiano'].sort(),

  'Pescara': ['Pescara', 'Montesilvano', 'Spoltore', 'Città Sant\'Angelo', 'Penne', 'Popoli', 'Manoppello', 'Loreto Aprutino', 'Cappelle sul Tavo', 'Pianella', 'Alanno', 'Bussi sul Tirino', 'Tocco da Casauria', 'Cugnoli', 'Lettomanoppello', 'Abbateggio', 'Bolognano', 'Brittoli', 'Catignano', 'Civitaquana', 'Civitella Casanova', 'Collecorvino', 'Corvara', 'Elice', 'Farindola'].sort(),

  'Piacenza': ['Piacenza', 'Castel San Giovanni', 'Fiorenzuola d\'Arda', 'Rottofreno', 'Podenzano', 'Carpaneto Piacentino', 'Borgonovo Val Tidone', 'Cortemaggiore', 'Rivergaro', 'Cadeo', 'Pontenure', 'Alseno', 'Gossolengo', 'Monticelli d\'Ongina', 'Gragnano Trebbiense', 'Ziano Piacentino', 'Agazzano', 'Piozzano', 'Vigolzone', 'San Pietro in Cerro', 'Sarmato', 'Besenzone', 'Villanova sull\'Arda', 'Caorso', 'Castelvetro Piacentino'].sort(),

  'Pisa': ['Pisa', 'Pontedera', 'Volterra', 'San Giuliano Terme', 'Cascina', 'Vecchiano', 'Ponsacco', 'Santa Croce sull\'Arno', 'Calci', 'San Miniato', 'Vicopisano', 'Buti', 'Casciana Terme Lari', 'Capannoli', 'Palaia', 'Peccioli', 'Terricciola', 'Chianni', 'Lajatico', 'Montescudaio', 'Guardistallo', 'Casale Marittimo', 'Castellina Marittima', 'Fauglia', 'Crespina Lorenzana'].sort(),

  'Pistoia': ['Pistoia', 'Montecatini Terme', 'Quarrata', 'Agliana', 'Monsummano Terme', 'Pescia', 'Serravalle Pistoiese', 'Montale', 'Lamporecchio', 'Pieve a Nievole', 'Larciano', 'Massa e Cozzile', 'Ponte Buggianese', 'Uzzano', 'Buggiano', 'Marliana', 'Abetone Cutigliano', 'San Marcello Piteglio', 'Sambuca Pistoiese', 'Chiesina Uzzanese'].sort(),

  'Pordenone': ['Pordenone', 'Sacile', 'Maniago', 'Aviano', 'Azzano Decimo', 'Fontanafredda', 'Spilimbergo', 'Cordenons', 'San Vito al Tagliamento', 'Brugnera', 'Pravisdomini', 'Pasiano di Pordenone', 'Zoppola', 'Chions', 'Fiume Veneto', 'Roveredo in Piano', 'Prata di Pordenone', 'Casarsa della Delizia', 'Valvasone Arzene', 'San Quirino', 'Montereale Valcellina', 'Caneva', 'Polcenigo', 'Arba', 'Budoia'].sort(),

  'Potenza': ['Potenza', 'Melfi', 'Lavello', 'Lauria', 'Rionero in Vulture', 'Venosa', 'Avigliano', 'Senise', 'Pignola', 'Bella', 'Sant\'Arcangelo', 'Tito', 'Picerno', 'Maratea', 'Muro Lucano', 'Atella', 'Brienza', 'Genzano di Lucania', 'Palazzo San Gervasio', 'Viggiano', 'Chiaromonte', 'Francavilla in Sinni', 'San Fele', 'Rapolla', 'Barile'].sort(),

  'Prato': ['Prato', 'Montemurlo', 'Carmignano', 'Poggio a Caiano', 'Vaiano', 'Vernio', 'Cantagallo', 'Prato Centro', 'Galciana', 'Tavola'].sort(),

  'Ragusa': ['Ragusa', 'Vittoria', 'Modica', 'Comiso', 'Scicli', 'Pozzallo', 'Ispica', 'Acate', 'Santa Croce Camerina', 'Chiaramonte Gulfi', 'Giarratana', 'Monterosso Almo'].sort(),

  'Ravenna': ['Ravenna', 'Faenza', 'Lugo', 'Cervia', 'Russi', 'Bagnacavallo', 'Alfonsine', 'Brisighella', 'Castel Bolognese', 'Conselice', 'Massa Lombarda', 'Fusignano', 'Casola Valsenio', 'Cotignola', 'Riolo Terme', 'Solarolo'].sort(),

  'Reggio Calabria': ['Reggio Calabria', 'Gioia Tauro', 'Palmi', 'Siderno', 'Villa San Giovanni', 'Melito di Porto Salvo', 'Taurianova', 'Polistena', 'Bovalino', 'Locri', 'Rosarno', 'Cinquefrondi', 'Cittanova', 'Oppido Mamertina', 'Scilla', 'Bagnara Calabra', 'Seminara', 'Roccella Ionica', 'Marina di Gioiosa Ionica', 'Laureana di Borrello', 'Anoia', 'Delianuova', 'Rizziconi', 'San Ferdinando', 'Gioia Tauro'].sort(),

  'Reggio Emilia': ['Reggio Emilia', 'Correggio', 'Scandiano', 'Guastalla', 'Casalgrande', 'Castelnovo ne\' Monti', 'Rubiera', 'Montecchio Emilia', 'Novellara', 'Cavriago', 'Bibbiano', 'San Martino in Rio', 'Cadelbosco di Sopra', 'Brescello', 'Campagnola Emilia', 'Poviglio', 'Gattatico', 'Rio Saliceto', 'Campegine', 'Sant\'Ilario d\'Enza', 'Boretto', 'Gualtieri', 'Luzzara', 'Fabbrico', 'Rolo'].sort(),

  'Rieti': ['Rieti', 'Poggio Mirteto', 'Fara in Sabina', 'Cittaducale', 'Magliano Sabina', 'Leonessa', 'Amatrice', 'Cantalice', 'Borgorose', 'Stimigliano', 'Antrodoco', 'Cittareale', 'Accumoli', 'Casperia', 'Montopoli di Sabina', 'Monteleone Sabino', 'Poggio Moiano', 'Torricella in Sabina', 'Forano', 'Cantalupo in Sabina', 'Contigliano', 'Greccio', 'Rivodutri', 'Colli sul Velino', 'Rocca Sinibalda'].sort(),

  'Rimini': ['Rimini', 'Riccione', 'Cattolica', 'Bellaria-Igea Marina', 'Santarcangelo di Romagna', 'San Giovanni in Marignano', 'Misano Adriatico', 'Verucchio', 'Coriano', 'Morciano di Romagna', 'San Clemente', 'Poggio Torriana', 'Montescudo-Monte Colombo', 'Saludecio', 'Mondaino', 'Gemmano', 'Montegridolfo', 'Montefiore Conca', 'Casteldelci', 'Maiolo', 'Novafeltria', 'Pennabilli', 'San Leo', 'Sant\'Agata Feltria', 'Talamello'].sort(),

  'Roma': ['Roma', 'Fiumicino', 'Guidonia Montecelio', 'Ardea', 'Pomezia', 'Tivoli', 'Anzio', 'Ciampino', 'Velletri', 'Monterotondo', 'Bracciano', 'Marino', 'Albano Laziale', 'Ladispoli', 'Cerveteri', 'Nettuno', 'Mentana', 'Frascati', 'Grottaferrata', 'Rocca Priora', 'Castel Gandolfo', 'Ariccia', 'Genzano di Roma', 'Lanuvio', 'Lariano'].sort(),

  'Rovigo': ['Rovigo', 'Adria', 'Porto Viro', 'Lendinara', 'Badia Polesine', 'Occhiobello', 'Porto Tolle', 'Taglio di Po', 'Villamarzana', 'Loreo', 'Arquà Polesine', 'Castelmassa', 'Castelnovo Bariano', 'Ceneselli', 'Ficarolo', 'Gaiba', 'Pincara', 'Polesella', 'Pontecchio Polesine', 'Rosolina', 'Stienta', 'Trecenta', 'Ariano nel Polesine', 'Corbola', 'Crespino'].sort(),

  'Salerno': ['Salerno', 'Cava de\' Tirreni', 'Battipaglia', 'Eboli', 'Nocera Inferiore', 'Pagani', 'Scafati', 'Agropoli', 'Sarno', 'Pontecagnano Faiano', 'Nocera Superiore', 'Angri', 'Fisciano', 'Mercato San Severino', 'Capaccio Paestum', 'Baronissi', 'Campagna', 'Vietri sul Mare', 'Maiori', 'Minori', 'Ravello', 'Amalfi', 'Positano', 'Praiano', 'Cetara'].sort(),

  'Sassari': ['Sassari', 'Alghero', 'Olbia', 'Tempio Pausania', 'Porto Torres', 'Sorso', 'La Maddalena', 'Arzachena', 'Ozieri', 'Stintino', 'Valledoria', 'Santa Teresa Gallura', 'Castelsardo', 'Palau', 'Loiri Porto San Paolo', 'Golfo Aranci', 'Sant\'Antonio di Gallura', 'Perfugas', 'Badesi', 'Viddalba', 'Trinità d\'Agultu e Vignola', 'Aglientu', 'Luogosanto', 'Calangianus', 'Telti'].sort(),

  'Savona': ['Savona', 'Albenga', 'Cairo Montenotte', 'Varazze', 'Finale Ligure', 'Loano', 'Alassio', 'Carcare', 'Albisola Superiore', 'Pietra Ligure', 'Borghetto Santo Spirito', 'Ceriale', 'Albissola Marina', 'Andora', 'Spotorno', 'Noli', 'Celle Ligure', 'Quiliano', 'Vado Ligure', 'Millesimo', 'Altare', 'Calizzano', 'Pallare', 'Bormida', 'Dego'].sort(),

  'Siena': ['Siena', 'Poggibonsi', 'Colle di Val d\'Elsa', 'Montepulciano', 'Sinalunga', 'Abbadia San Salvatore', 'Sovicille', 'Montalcino', 'Chiusi', 'Asciano', 'San Gimignano', 'Monteroni d\'Arbia', 'Rapolano Terme', 'Monteriggioni', 'Castelnuovo Berardenga', 'Torrita di Siena', 'Piancastagnaio', 'Sarteano', 'Cetona', 'San Quirico d\'Orcia', 'Pienza', 'Casole d\'Elsa', 'Radda in Chianti', 'Gaiole in Chianti', 'Castellina in Chianti'].sort(),

  'Siracusa': ['Siracusa', 'Augusta', 'Avola', 'Noto', 'Lentini', 'Pachino', 'Floridia', 'Priolo Gargallo', 'Rosolini', 'Carlentini', 'Portopalo di Capo Passero', 'Solarino', 'Melilli', 'Palazzolo Acreide', 'Francofonte', 'Canicattini Bagni', 'Buccheri', 'Ferla', 'Sortino', 'Buscemi', 'Cassaro'].sort(),

  'Sondrio': ['Sondrio', 'Morbegno', 'Tirano', 'Livigno', 'Chiavenna', 'Bormio', 'Ponte in Valtellina', 'Berbenno di Valtellina', 'Sondalo', 'Teglio', 'Villa di Chiavenna', 'Campodolcino', 'Madesimo', 'Aprica', 'Valdidentro', 'Valdisotto', 'Valfurva', 'Grosio', 'Grosotto', 'Lovero', 'Montagna in Valtellina', 'Caspoggio', 'Chiesa in Valmalenco', 'Caiolo', 'Dubino'].sort(),

  'Sud Sardegna': ['Carbonia', 'Iglesias', 'Guspini', 'Portoscuso', 'Villasor', 'San Gavino Monreale', 'Sant\'Antioco', 'Domusnovas', 'Santadi', 'Musei', 'Pabillonis', 'Sanluri', 'Serramanna', 'Samassi', 'Gonnosfanadiga', 'Arbus', 'Villacidro', 'Carloforte', 'Calasetta', 'Narcao', 'Villamassargia', 'Buggerru', 'Fluminimaggiore', 'Gonnesa', 'Perdaxius'].sort(),

  'Taranto': ['Taranto', 'Martina Franca', 'Manduria', 'Massafra', 'Grottaglie', 'Castellaneta', 'Ginosa', 'Francavilla Fontana', 'Crispiano', 'Palagiano', 'Sava', 'Maruggio', 'Leporano', 'Pulsano', 'Lizzano', 'Torricella', 'Monteparano', 'Faggiano', 'Roccaforzata', 'San Giorgio Jonico', 'Monteiasi', 'Carosino', 'San Marzano di San Giuseppe', 'Fragagnano', 'Avetrana'].sort(),

  'Teramo': ['Teramo', 'Giulianova', 'Roseto degli Abruzzi', 'Pineto', 'Silvi', 'Atri', 'Alba Adriatica', 'Martinsicuro', 'Sant\'Egidio alla Vibrata', 'Tortoreto', 'Nereto', 'Sant\'Omero', 'Torano Nuovo', 'Colonnella', 'Controguerra', 'Corropoli', 'Campli', 'Bellante', 'Castellalto', 'Notaresco', 'Morro d\'Oro', 'Mosciano Sant\'Angelo', 'Montorio al Vomano', 'Isola del Gran Sasso d\'Italia', 'Pietracamela'].sort(),

  'Terni': ['Terni', 'Orvieto', 'Narni', 'Amelia', 'Spoleto', 'Foligno', 'Marsciano', 'San Gemini', 'Acquasparta', 'Fabro', 'Allerona', 'Alviano', 'Arrone', 'Attigliano', 'Baschi', 'Calvi dell\'Umbria', 'Castel Giorgio', 'Castel Viscardo', 'Ferentillo', 'Ficulle', 'Giove', 'Guardea', 'Lugnano in Teverina', 'Montecastrilli', 'Montecchio'].sort(),

  'Torino': ['Torino', 'Moncalieri', 'Rivoli', 'Collegno', 'Settimo Torinese', 'Nichelino', 'Chieri', 'Ivrea', 'Pinerolo', 'Grugliasco', 'Orbassano', 'Venaria Reale', 'Alpignano', 'Piossasco', 'Druento', 'San Mauro Torinese', 'Volpiano', 'Beinasco', 'Carmagnola', 'Caselle Torinese', 'Chivasso', 'Leini', 'Cirié', 'Pianezza', 'Borgaro Torinese'].sort(),

  'Trapani': ['Trapani', 'Marsala', 'Mazara del Vallo', 'Alcamo', 'Castelvetrano', 'Erice', 'Partanna', 'Salemi', 'Campobello di Mazara', 'Castellammare del Golfo', 'Valderice', 'Petrosino', 'Buseto Palizzolo', 'Calatafimi-Segesta', 'Paceco', 'Custonaci', 'San Vito Lo Capo', 'Gibellina', 'Poggioreale', 'Salaparuta', 'Santa Ninfa', 'Vita', 'Favignana', 'Pantelleria', 'Marettimo'].sort(),

  'Trento': ['Trento', 'Rovereto', 'Pergine Valsugana', 'Arco', 'Riva del Garda', 'Lavis', 'Mori', 'Ala', 'Levico Terme', 'Cles', 'Borgo Valsugana', 'Mezzolombardo', 'Mezzocorona', 'Nomi', 'Avio', 'Predaia', 'Malè', 'Tione di Trento', 'Cavalese', 'Fiera di Primiero', 'Storo', 'Cavedine', 'Tenno', 'Nago-Torbole', 'Dro'].sort(),

  'Treviso': ['Treviso', 'Conegliano', 'Vittorio Veneto', 'Montebelluna', 'Castelfranco Veneto', 'Mogliano Veneto', 'Paese', 'Oderzo', 'Preganziol', 'Villorba', 'Silea', 'Quinto di Treviso', 'Carbonera', 'Spresiano', 'Vedelago', 'Riese Pio X', 'Casale sul Sile', 'Roncade', 'Susegana', 'Pieve di Soligo', 'San Vendemiano', 'Cordignano', 'San Fior', 'Godega di Sant\'Urbano', 'Colle Umberto'].sort(),

  'Trieste': ['Trieste', 'Muggia', 'San Dorligo della Valle', 'Sgonico', 'Duino-Aurisina', 'Monrupino', 'San Giorgio di Nogaro', 'Grignano', 'Prosecco', 'Sistiana'].sort(),

  'Udine': ['Udine', 'Cividale del Friuli', 'Codroipo', 'Gemona del Friuli', 'Tavagnacco', 'Latisana', 'Tolmezzo', 'Palmanova', 'Lignano Sabbiadoro', 'San Daniele del Friuli', 'Cervignano del Friuli', 'Tarvisio', 'Pagnacco', 'Reana del Rojale', 'Tarcento', 'Amaro', 'Ampezzo', 'Aquileia', 'Arta Terme', 'Artegna', 'Attimis', 'Bagnaria Arsa', 'Basiliano', 'Bertiolo', 'Bicinicco'].sort(),

  'Varese': ['Varese', 'Busto Arsizio', 'Gallarate', 'Saronno', 'Tradate', 'Cassano Magnago', 'Luino', 'Malnate', 'Somma Lombardo', 'Gavirate', 'Laveno-Mombello', 'Arcisate', 'Bisuschio', 'Caronno Pertusella', 'Castellanza', 'Cairate', 'Jerago con Orago', 'Gorla Minore', 'Olgiate Olona', 'Solbiate Arno', 'Fagnano Olona', 'Vedano Olona', 'Venegono Inferiore', 'Venegono Superiore', 'Castiglione Olona'].sort(),

  'Venezia': ['Venezia', 'Mestre', 'Chioggia', 'San Donà di Piave', 'Marghera', 'Mira', 'Spinea', 'Mirano', 'Jesolo', 'Portogruaro', 'Dolo', 'Martellago', 'Caorle', 'Noale', 'Santa Maria di Sala', 'Scorzè', 'Camponogara', 'Favaro Veneto', 'Mogliano Veneto', 'Campagna Lupia', 'Eraclea', 'San Michele al Tagliamento', 'Musile di Piave', 'Fossalta di Piave', 'Noventa di Piave'].sort(),

  'Verbano-Cusio-Ossola': ['Verbania', 'Domodossola', 'Omegna', 'Gravellona Toce', 'Villadossola', 'Baveno', 'Cannobio', 'Stresa', 'Premosello-Chiovenda', 'Crevoladossola', 'Mergozzo', 'Ornavasso', 'Vogogna', 'Arona', 'Ghiffa', 'Cannero Riviera', 'Oggebbio', 'Verbania Intra', 'Verbania Pallanza', 'Borgomanero', 'Arizzano', 'Aurano', 'Bee', 'Belgirate', 'Bognanco'].sort(),

  'Vercelli': ['Vercelli', 'Borgosesia', 'Santhià', 'Trino', 'Gattinara', 'Cigliano', 'Crescentino', 'Varallo', 'Livorno Ferraris', 'Borgomanero', 'Roasio', 'Postua', 'Prarolo', 'Quarona', 'Quinto Vercellese', 'Rima San Giuseppe', 'Rimasco', 'Rimella', 'Riva Valdobbia', 'Roasio', 'Ronsecco', 'Rossa', 'Rovasenda', 'Salasco', 'Sali Vercellese'].sort(),

  'Verona': ['Verona', 'Villafranca di Verona', 'San Giovanni Lupatoto', 'Legnago', 'Bussolengo', 'San Bonifacio', 'Bardolino', 'Pescantina', 'Sommacampagna', 'Cerea', 'Nogara', 'Isola della Scala', 'Valeggio sul Mincio', 'Bovolone', 'Soave', 'Garda', 'Lazise', 'Peschiera del Garda', 'Castelnuovo del Garda', 'San Martino Buon Albergo', 'Zevio', 'Oppeano', 'San Pietro in Cariano', 'Negrar di Valpolicella', 'Marano di Valpolicella'].sort(),

  'Vibo Valentia': ['Vibo Valentia', 'Tropea', 'Pizzo', 'Serra San Bruno', 'Mileto', 'Soriano Calabro', 'Filadelfia', 'Nicotera', 'Briatico', 'Jonadi', 'Ricadi', 'Rombiolo', 'Vibo Valentia Marina', 'San Calogero', 'Maierato', 'Stefanaconi', 'Cessaniti', 'San Costantino Calabro', 'Drapia', 'Zaccanopoli', 'Zungri', 'Spilinga', 'Limbadi', 'Sant\'Onofrio', 'Francica'].sort(),

  'Vicenza': ['Vicenza', 'Bassano del Grappa', 'Schio', 'Arzignano', 'Valdagno', 'Thiene', 'Montecchio Maggiore', 'Lonigo', 'Nove', 'Torri di Quartesolo', 'Malo', 'Marostica', 'Sandrigo', 'Dueville', 'Montecchio Precalcino', 'Breganze', 'Cassola', 'Rosà', 'Pozzoleone', 'Caldogno', 'Sarcedo', 'Schio', 'Santorso', 'Zugliano', 'Zanè'].sort(),

  'Viterbo': ['Viterbo', 'Civita Castellana', 'Montefiascone', 'Tarquinia', 'Orte', 'Acquapendente', 'Tuscania', 'Vetralla', 'Sutri', 'Nepi', 'Ronciglione', 'Soriano nel Cimino', 'Bolsena', 'Bagnoregio', 'Capranica', 'Caprarola', 'Vignanello', 'Montalto di Castro', 'Canino', 'Valentano', 'Marta', 'Grotte di Castro', 'Gradoli', 'Bassano Romano', 'Bassano in Teverina'].sort(),
};

export const CITY_TO_PROVINCE: Record<string, string> = {};
Object.entries(CITIES_BY_PROVINCE).forEach(([province, cities]) => {
  cities.forEach(city => {
    CITY_TO_PROVINCE[city] = province;
  });
});

export const PROVINCE_TO_CODE: Record<string, string> = {
  'Agrigento': 'AG',
  'Alessandria': 'AL',
  'Ancona': 'AN',
  'Aosta': 'AO',
  'Arezzo': 'AR',
  'Ascoli Piceno': 'AP',
  'Asti': 'AT',
  'Avellino': 'AV',
  'Bari': 'BA',
  'Barletta-Andria-Trani': 'BT',
  'Belluno': 'BL',
  'Benevento': 'BN',
  'Bergamo': 'BG',
  'Biella': 'BI',
  'Bologna': 'BO',
  'Bolzano': 'BZ',
  'Brescia': 'BS',
  'Brindisi': 'BR',
  'Cagliari': 'CA',
  'Caltanissetta': 'CL',
  'Campobasso': 'CB',
  'Caserta': 'CE',
  'Catania': 'CT',
  'Catanzaro': 'CZ',
  'Chieti': 'CH',
  'Como': 'CO',
  'Cosenza': 'CS',
  'Cremona': 'CR',
  'Crotone': 'KR',
  'Cuneo': 'CN',
  'Enna': 'EN',
  'Fermo': 'FM',
  'Ferrara': 'FE',
  'Firenze': 'FI',
  'Foggia': 'FG',
  'Forlì-Cesena': 'FC',
  'Frosinone': 'FR',
  'Genova': 'GE',
  'Gorizia': 'GO',
  'Grosseto': 'GR',
  'Imperia': 'IM',
  'Isernia': 'IS',
  'L\'Aquila': 'AQ',
  'La Spezia': 'SP',
  'Latina': 'LT',
  'Lecce': 'LE',
  'Lecco': 'LC',
  'Livorno': 'LI',
  'Lodi': 'LO',
  'Lucca': 'LU',
  'Macerata': 'MC',
  'Mantova': 'MN',
  'Massa-Carrara': 'MS',
  'Matera': 'MT',
  'Messina': 'ME',
  'Milano': 'MI',
  'Modena': 'MO',
  'Monza e Brianza': 'MB',
  'Napoli': 'NA',
  'Novara': 'NO',
  'Nuoro': 'NU',
  'Oristano': 'OR',
  'Padova': 'PD',
  'Palermo': 'PA',
  'Parma': 'PR',
  'Pavia': 'PV',
  'Perugia': 'PG',
  'Pesaro e Urbino': 'PU',
  'Pescara': 'PE',
  'Piacenza': 'PC',
  'Pisa': 'PI',
  'Pistoia': 'PT',
  'Pordenone': 'PN',
  'Potenza': 'PZ',
  'Prato': 'PO',
  'Ragusa': 'RG',
  'Ravenna': 'RA',
  'Reggio Calabria': 'RC',
  'Reggio Emilia': 'RE',
  'Rieti': 'RI',
  'Rimini': 'RN',
  'Roma': 'RM',
  'Rovigo': 'RO',
  'Salerno': 'SA',
  'Sassari': 'SS',
  'Savona': 'SV',
  'Siena': 'SI',
  'Siracusa': 'SR',
  'Sondrio': 'SO',
  'Sud Sardegna': 'SU',
  'Taranto': 'TA',
  'Teramo': 'TE',
  'Terni': 'TR',
  'Torino': 'TO',
  'Trapani': 'TP',
  'Trento': 'TN',
  'Treviso': 'TV',
  'Trieste': 'TS',
  'Udine': 'UD',
  'Varese': 'VA',
  'Venezia': 'VE',
  'Verbano-Cusio-Ossola': 'VB',
  'Vercelli': 'VC',
  'Verona': 'VR',
  'Vibo Valentia': 'VV',
  'Vicenza': 'VI',
  'Viterbo': 'VT',
};
