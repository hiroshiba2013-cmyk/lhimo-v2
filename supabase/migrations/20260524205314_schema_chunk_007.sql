DO $$
DECLARE
  cat_ristoranti uuid;
  cat_negozi uuid;
  cat_professionisti uuid;
  cat_salute uuid;
  cat_bellezza uuid;
  cat_servizi uuid;
BEGIN
  SELECT id INTO cat_ristoranti FROM business_categories WHERE slug = 'ristoranti-bar';
  SELECT id INTO cat_negozi FROM business_categories WHERE slug = 'negozi-retail';
  SELECT id INTO cat_professionisti FROM business_categories WHERE slug = 'professionisti';
  SELECT id INTO cat_salute FROM business_categories WHERE slug = 'salute-benessere';
  SELECT id INTO cat_bellezza FROM business_categories WHERE slug = 'bellezza';
  SELECT id INTO cat_servizi FROM business_categories WHERE slug = 'servizi';

  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Elettricista Milano Pronto Intervento', 'Servizio di pronto intervento elettrico 24 ore su 24, 7 giorni su 7. Riparazione guasti elettrici, installazione impianti e manutenzione.', cat_servizi, 'Via Privata Pietro Martinetti', '25/23', 'Milano', 'MI', '20147', '+39 02 40702135', 'info@elettricistamilano.it', true, false),
  ('SuperMario24 Elettricista', 'Pronto intervento elettricista disponibile H24 a Milano e provincia. Riparazioni urgenti, installazioni e certificazioni impianti.', cat_servizi, 'Via Stamira d''Ancona', '15', 'Milano', 'MI', '20127', '+39 339 6056976', 'info@supermario24.it', true, false),
  ('Artigiani di Milano - Elettricista', 'Servizio elettricista professionale con sopralluogo gratuito. Installazione impianti elettrici civili e industriali, domotica.', cat_servizi, 'Corso Buenos Aires', '77', 'Milano', 'MI', '20124', '+39 02 58304860', 'info@artigianidimilano.com', true, false),
  ('Idraulico Milano Pronto Intervento', 'Servizio idraulico 24 ore su 24 per Milano e provincia. Riparazione perdite, spurgo, installazione sanitari e caldaie.', cat_servizi, 'Via Larga', '6', 'Milano', 'MI', '20122', '+39 02 82196928', 'info@idraulicomilano.it', true, false),
  ('SK Idraulica Milano', 'Idraulico professionista dal 2014. Manutenzione impianti, riparazione tubature, installazione caldaie e climatizzatori.', cat_servizi, 'Via Padova', '182', 'Milano', 'MI', '20127', '+39 346 3210471', 'info@skidraulica.it', true, false),
  ('Idraulica Service Erlini', 'Impresa idraulica con esperienza trentennale. Ristrutturazioni bagni, impianti termoidraulici e assistenza caldaie.', cat_servizi, 'Via Padova', '276', 'Milano', 'MI', '20132', '+39 340 0892574', 'info@idraulicaservice.it', true, false),
  ('IP Stazione di Servizio Piazza Repubblica', 'Distributore IP nel centro di Milano con servizio self service e assistito. Benzina, diesel, GPL e servizi lavaggio auto.', cat_servizi, 'Piazza della Repubblica', '5a', 'Milano', 'MI', '20121', '+39 02 6269 8501', 'info@iprepubblica.it', true, false),
  ('Michedil Ristrutturazioni', 'Impresa edile specializzata in ristrutturazioni complete di appartamenti, ville e uffici. Progettazione e direzione lavori.', cat_servizi, 'Via Prenestina', '285', 'Roma', 'RM', '00171', '+39 338 6408658', 'info@michedil.it', true, false),
  ('Consud Impresa Edile', 'Società di costruzioni con esperienza pluriennale. Nuove costruzioni, ristrutturazioni e manutenzioni straordinarie.', cat_servizi, 'Via Buccari', '4', 'Roma', 'RM', '00195', '+39 06 97277790', 'info@consudimpresa.it', true, false),
  ('Farmacia Internazionale Roma', 'Farmacia centrale a Roma Termini aperta H24. Ampio assortimento farmaci, parafarmaci e servizi sanitari.', cat_salute, 'Piazza della Repubblica', '67', 'Roma', 'RM', '00185', '+39 06 488 0754', 'info@farmaciainternazionale.it', true, false),
  ('Farmacia Pantheon', 'Farmacia nel centro storico di Roma. Preparazioni galeniche, omeopatia e cosmesi naturale.', cat_salute, 'Via della Rotonda', '8-9', 'Roma', 'RM', '00186', '+39 06 6880 3273', 'info@farmaciapantheon.it', true, false),
  ('Farmacia Prati', 'Farmacia di fiducia in zona Prati. Dermocosmesi, fitoterapia e assistenza domiciliare per anziani.', cat_salute, 'Viale Giulio Cesare', '89', 'Roma', 'RM', '00192', '+39 06 3972 1234', 'info@farmaciaprati.it', true, false),
  ('Falegnameria Depetro Antonino', 'Falegnameria artigianale torinese. Mobili su misura, restauro mobili antichi e serramenti in legno.', cat_servizi, 'Via Giuseppe Fagnano', '25', 'Torino', 'TO', '10144', '+39 011 480076', 'info@falegnameria-depetro.it', true, false),
  ('Falegnameria Di Fazio Pasquale', 'Laboratorio di falegnameria per arredi personalizzati. Cucine, armadi, porte interne e complementi d''arredo.', cat_servizi, 'Via Frinco', '26', 'Torino', 'TO', '10136', '+39 320 8336735', 'info@difaziofalegname.it', true, false),
  ('Elettricista Torino Pronto Intervento', 'Servizio elettricista 24 ore su 24 per emergenze elettriche. Riparazioni rapide e installazione impianti a norma.', cat_servizi, 'Corso Vittorio Emanuele II', '94', 'Torino', 'TO', '10121', '+39 011 5620789', 'info@elettricistatorino.it', true, false),
  ('Sandri Ferramenta', 'Ferramenta storica bolognese con vasto assortimento. Utensileria, minuteria metallica, articoli per la casa e duplicazione chiavi.', cat_negozi, 'Via del Sostegno', '6', 'Bologna', 'BO', '40131', '+39 051 6343200', 'info@ferramenta-sandri.com', true, false),
  ('Ferramenta Roma Bologna', 'Ferramenta nel centro storico di Bologna. Utensileria professionale, colori, serrature e materiale elettrico.', cat_negozi, 'Via delle Lame', '31', 'Bologna', 'BO', '40122', '+39 051 231735', 'info@ferramentaroma.com', true, false),
  ('Notaio Cristiano Di Maio', 'Studio notarile a Castellammare di Stabia. Compravendite immobiliari, atti societari e successioni.', cat_professionisti, 'Piazza Principe Umberto', '3', 'Castellammare di Stabia', 'NA', '80053', '+39 081 8718287', 'studio@notaiodimaio.it', true, false),
  ('Farmacia Centrale Napoli', 'Farmacia storica nel centro di Napoli. Preparazioni galeniche magistrali, omeopatia e consegna a domicilio.', cat_salute, 'Via Toledo', '156', 'Napoli', 'NA', '80134', '+39 081 5522341', 'info@farmaciacentralenapoli.it', true, false),
  ('Avvocato Erica Aprile', 'Studio legale specializzato in diritto di famiglia, separazioni e divorzi. Mediazione familiare e tutela minori.', cat_professionisti, 'Piazza Cesare Beccaria', '7', 'Firenze', 'FI', '50121', '+39 055 577707', 'studio@avvocatoaprile.it', true, false),
  ('Ferramenta Bargellini', 'Ferramenta storica fiorentina dal 1920. Utensileria, serramenti, casalinghi e duplicazione chiavi mentre aspetti.', cat_negozi, 'Via dei Servi', '52r', 'Firenze', 'FI', '50122', '+39 055 289281', 'info@ferramentabargellini.it', true, false),
  ('Elettricista Genova SOS', 'Pronto intervento elettricista 24h per Genova e provincia. Risoluzione guasti, manutenzione e certificazioni.', cat_servizi, 'Via XX Settembre', '14', 'Genova', 'GE', '16121', '+39 010 5957834', 'info@elettricista-genova.it', true, false),
  ('Impresa Edile Siciliana', 'Impresa edile palermitana per nuove costruzioni e ristrutturazioni. Lavori chiavi in mano con garanzia decennale.', cat_servizi, 'Via Notarbartolo', '44', 'Palermo', 'PA', '90141', '+39 091 6124567', 'info@impresaedile-siciliana.it', true, false),
  ('Elettricista Bari 24h', 'Elettricista professionista per pronto intervento su Bari e provincia. Disponibile h24 anche festivi.', cat_servizi, 'Via Dante Alighieri', '120', 'Bari', 'BA', '70122', '+39 080 5213456', 'info@elettricistabari.it', true, false),
  ('Ferramenta Pugliese', 'Grande ferramenta barese con utensileria professionale, casalinghi e materiali edili. Consegne a domicilio.', cat_negozi, 'Corso Vittorio Emanuele II', '67', 'Bari', 'BA', '70122', '+39 080 5217890', 'info@ferramentapugliese.it', true, false),
  ('Idraulico Verona Service', 'Servizio idraulico completo per Verona città e provincia. Manutenzione caldaie, impianti termici e sanitari.', cat_servizi, 'Via Santa Teresa', '12', 'Verona', 'VR', '37135', '+39 045 8001234', 'info@idraulicoverona.it', true, false),
  ('Elettricista Padova Elettrotek', 'Impiantistica elettrica civile e industriale. Installazione impianti fotovoltaici e sistemi di videosorveglianza.', cat_servizi, 'Via Vicenza', '34', 'Padova', 'PD', '35138', '+39 049 8761234', 'info@elettrotekpadova.it', true, false),
  ('Impresa Edile Bresciana Costruzioni', 'Impresa costruttrice per nuovi edifici residenziali e commerciali. Ristrutturazioni e ampliamenti con progettazione.', cat_servizi, 'Via Milano', '45', 'Brescia', 'BS', '25126', '+39 030 2201567', 'info@edilebresciana.it', true, false),
  ('Elettricista Bergamo Impianti', 'Impianti elettrici civili e industriali. Manutenzioni programmate, domotica e automazione cancelli.', cat_servizi, 'Via Carnovali', '88', 'Bergamo', 'BG', '24126', '+39 035 4120987', 'info@elettricistabergamo.it', true, false),
  ('Farmacia Etnea', 'Farmacia centrale sulla Via Etnea. Ampio assortimento, parafarmaci, cosmetica e assistenza domiciliare.', cat_salute, 'Via Etnea', '234', 'Catania', 'CT', '95124', '+39 095 317890', 'info@farmaciaetnea.it', true, false),
  ('Elettricista Trieste Impianti FVG', 'Impresa installatrice impianti elettrici. Assistenza 24h, fotovoltaico e colonnine ricarica auto elettriche.', cat_servizi, 'Via Miramare', '43', 'Trieste', 'TS', '34135', '+39 040 410234', 'info@impiantifvg.it', true, false),
  ('Idraulico Cagliari Sardegna Service', 'Servizio idraulico per Cagliari e hinterland. Emergenze 24h, installazione climatizzatori e caldaie.', cat_servizi, 'Via Roma', '145', 'Cagliari', 'CA', '09124', '+39 070 6789123', 'info@idraulicocagliari.it', true, false),
  ('Ferramenta Sarda Cagliari', 'Ferramenta completa con reparto giardinaggio. Attrezzatura edile a noleggio e vendita materiali.', cat_negozi, 'Via Sonnino', '178', 'Cagliari', 'CA', '09127', '+39 070 6543210', 'info@ferramentasarda.it', true, false),
  ('Farmacia Perugina', 'Farmacia storica perugina con preparazioni galeniche. Fitoterapia, omeopatia e analisi del capello.', cat_salute, 'Corso Vannucci', '67', 'Perugia', 'PG', '06121', '+39 075 5724567', 'info@farmaciaperugina.it', true, false);

END $$;

DO $$
DECLARE
  cat_ristoranti uuid;
  cat_negozi uuid;
  cat_professionisti uuid;
  cat_salute uuid;
  cat_bellezza uuid;
  cat_servizi uuid;
BEGIN
  SELECT id INTO cat_ristoranti FROM business_categories WHERE slug = 'ristoranti-bar';
  SELECT id INTO cat_negozi FROM business_categories WHERE slug = 'negozi-retail';
  SELECT id INTO cat_professionisti FROM business_categories WHERE slug = 'professionisti';
  SELECT id INTO cat_salute FROM business_categories WHERE slug = 'salute-benessere';
  SELECT id INTO cat_bellezza FROM business_categories WHERE slug = 'bellezza';
  SELECT id INTO cat_servizi FROM business_categories WHERE slug = 'servizi';

  -- VALLE D AOSTA
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Le Grenier', 'Ristorante valdostano con cucina tipica. Fonduta, carbonada, polenta concia e carni alla brace in ambiente caratteristico.', cat_ristoranti, 'Via Xavier de Maistre', '3', 'Aosta', 'AO', '11100', '+39 0165 40960', 'info@legrenieraoste.it', true, false),
  ('Farmacia Centrale Aosta', 'Farmacia storica nel centro di Aosta. Preparazioni galeniche, omeopatia e consegna a domicilio in Valle.', cat_salute, 'Via Porta Pretoria', '12', 'Aosta', 'AO', '11100', '+39 0165 262646', 'info@farmaciacentraleao.it', true, false),
  ('Avvocato Marco Bertolin', 'Studio legale specializzato in diritto civile e commerciale. Consulenza per privati e aziende valdostane.', cat_professionisti, 'Piazza Chanoux', '8', 'Aosta', 'AO', '11100', '+39 0165 44567', 'studio@bertolinavvocato.it', true, false),
  ('Elettricista Aosta Service', 'Impianti elettrici per abitazioni e aziende. Certificazioni e manutenzioni programmate in tutta la Valle.', cat_servizi, 'Via Festaz', '56', 'Aosta', 'AO', '11100', '+39 0165 235678', 'info@elettricistaaostaservice.it', true, false),
  ('Parrucchiere Elegance Aosta', 'Salone di parrucchiere donna e uomo. Taglio, colore, trattamenti e acconciature per cerimonie.', cat_bellezza, 'Via Chambery', '34', 'Aosta', 'AO', '11100', '+39 0165 41234', 'info@eleganceaosta.it', true, false),
  -- PIEMONTE - ALESSANDRIA
  ('Trattoria del Corso Alessandria', 'Cucina piemontese tradizionale. Agnolotti, brasato al Barolo e dolci della casa in ambiente familiare.', cat_ristoranti, 'Corso Roma', '112', 'Alessandria', 'AL', '15121', '+39 0131 252345', 'info@trattoriadelcorso.it', true, false),
  ('Farmacia San Giacomo Alessandria', 'Farmacia di fiducia con preparazioni magistrali. Dermocosmesi, veterinaria e misurazione parametri.', cat_salute, 'Via Dante', '45', 'Alessandria', 'AL', '15121', '+39 0131 443322', 'info@farmaciasangiacomo.it', true, false),
  ('Impresa Edile Monferrato', 'Costruzioni e ristrutturazioni chiavi in mano. Nuovi edifici, recupero rustici e manutenzioni.', cat_servizi, 'Via Casale', '67', 'Alessandria', 'AL', '15121', '+39 0131 345678', 'info@edilemonferrato.it', true, false),
  -- PIEMONTE - ASTI
  ('Ristorante Il Cenacolo Asti', 'Ristorante gourmet nel cuore di Asti. Cucina creativa con prodotti del territorio e carta vini d''eccellenza.', cat_ristoranti, 'Via Giobert', '4', 'Asti', 'AT', '14100', '+39 0141 594188', 'info@ristoranteilcenacolo.it', true, false),
  ('Farmacia Moderna Asti', 'Farmacia con servizio di telemedicina. Holter pressorio, elettrocardiogramma e autoanalisi.', cat_salute, 'Corso Alfieri', '223', 'Asti', 'AT', '14100', '+39 0141 592345', 'info@farmaciamodernaasti.it', true, false),
  ('Falegnameria Astigiana', 'Falegnameria artigianale con showroom. Cucine su misura, infissi e restauro mobili antichi.', cat_servizi, 'Corso Savona', '145', 'Asti', 'AT', '14100', '+39 0141 271234', 'info@falegnameriaastigiana.it', true, false),
  ('Panificio Pasticceria Giordano', 'Panificio artigianale con dolci tipici. Amaretti, baci di dama, pane fatto in casa.', cat_negozi, 'Via Roma', '34', 'Asti', 'AT', '14100', '+39 0141 592123', 'info@panificiogiordano.it', true, false),
  -- PIEMONTE - CUNEO
  ('Osteria della Chiocciola Cuneo', 'Osteria tipica cuneese. Vitello tonnato, finanziera, brasato e tajarin fatti in casa.', cat_ristoranti, 'Via Roma', '23', 'Cuneo', 'CN', '12100', '+39 0171 66277', 'info@osteriachiocciola.it', true, false),
  ('Farmacia Santa Croce Cuneo', 'Farmacia con angolo salute naturale. Fitoterapia, floriterapia e consulenza naturopatica.', cat_salute, 'Piazza Galimberti', '8', 'Cuneo', 'CN', '12100', '+39 0171 692345', 'info@farmaciasantacroce.it', true, false),
  -- PIEMONTE - NOVARA
  ('Ristorante Tantris Novara', 'Ristorante stellato con cucina contemporanea. Menu degustazione e selezione vini del territorio.', cat_ristoranti, 'Via Fratelli Rosselli', '4', 'Novara', 'NO', '28100', '+39 0321 331116', 'info@tantrisnovara.it', true, false),
  -- LIGURIA - IMPERIA
  ('Ristorante Sarri Imperia', 'Ristorante di pesce fronte mare. Crudo di mare, fritture e specialità liguri con vista porto.', cat_ristoranti, 'Via Scarincio', '18', 'Imperia', 'IM', '18100', '+39 0183 753331', 'info@ristorantesarri.it', true, false),
  -- LIGURIA - LA SPEZIA
  ('Antica Osteria Nonna Gilla La Spezia', 'Osteria delle Cinque Terre. Acciughe di Monterosso, trofie al pesto e focaccia ligure.', cat_ristoranti, 'Via XX Settembre', '123', 'La Spezia', 'SP', '19121', '+39 0187 734567', 'info@nonnagilla.it', true, false),
  -- LIGURIA - SAVONA
  ('Ristorante A Spurcacciuna Savona', 'Ristorante storico savonese. Brandacujun, torta di riso e farinata ligure in ambiente tradizionale.', cat_ristoranti, 'Via Pia', '15r', 'Savona', 'SV', '17100', '+39 019 821871', 'info@spurcacciuna.it', true, false),
  -- LOMBARDIA - COMO
  ('Ristorante Navedano Como', 'Ristorante vista lago. Pesce di lago, risotto al pesce persico e specialità lariane.', cat_ristoranti, 'Via Pannilani', '5', 'Como', 'CO', '22100', '+39 031 308080', 'info@navedano.it', true, false),
  ('Seta Como Outlet', 'Negozio tessuti di seta comaschi. Sciarpe, cravatte e tessuti al metro di alta qualità.', cat_negozi, 'Via Vittorio Emanuele II', '56', 'Como', 'CO', '22100', '+39 031 267890', 'info@setacomo.it', true, false),
  -- LOMBARDIA - CREMONA
  ('Trattoria Cerresola Cremona', 'Cucina cremonese tradizionale. Marubini, tortelli di zucca, bollito misto e mostarda.', cat_ristoranti, 'Via Cerresola', '4', 'Cremona', 'CR', '26100', '+39 0372 30990', 'info@trattoriacerresola.it', true, false),
  ('Sperlari Store Cremona', 'Negozio storico di torroni e dolci. Torrone classico, mostarda e prodotti tipici cremonesi.', cat_negozi, 'Via Solferino', '25', 'Cremona', 'CR', '26100', '+39 0372 22329', 'info@sperlari.it', true, false),
  -- LOMBARDIA - LECCO
  ('Osteria Casa Manzoni Lecco', 'Osteria lecchese. Missoltini, polenta e formaggio, lavarello del Lario.', cat_ristoranti, 'Via Bovara', '23', 'Lecco', 'LC', '23900', '+39 0341 285175', 'info@casamanzoni.it', true, false),
  -- LOMBARDIA - MANTOVA
  ('Ristorante Il Cigno Mantova', 'Ristorante stellato mantovano. Tortelli di zucca, risotto alla pilota e luccio in salsa.', cat_ristoranti, 'Piazza Carlo d''Arco', '1', 'Mantova', 'MN', '46100', '+39 0376 327101', 'info@ilcignomantova.it', true, false),
  -- LOMBARDIA - PAVIA
  ('Locanda Vecchia Pavia', 'Ristorante storico pavese. Risotto alla certosina, zuppa pavese e rane fritte.', cat_ristoranti, 'Via Cardinal Riboldi', '2', 'Pavia', 'PV', '27100', '+39 0382 304132', 'info@vecchiapavia.it', true, false),
  -- LOMBARDIA - SONDRIO
  ('Trattoria Valtellinese Sondrio', 'Cucina montana. Pizzoccheri, sciatt, bresaola della Valtellina e formaggi alpini.', cat_ristoranti, 'Via Scarpatetti', '7', 'Sondrio', 'SO', '23100', '+39 0342 214121', 'info@trattoriavaltellinese.it', true, false),
  -- TRENTINO - BOLZANO
  ('Restaurant Vogele Bolzano', 'Ristorante tradizionale altoatesino. Canederli, speck, strudel e vini dell''Alto Adige.', cat_ristoranti, 'Via Goethe', '3', 'Bolzano', 'BZ', '39100', '+39 0471 973938', 'info@vogele.it', true, false),
  ('Speck Stube Shop Bolzano', 'Negozio prodotti tipici Alto Adige. Speck IGP, formaggi alpini, strudel e vini DOC.', cat_negozi, 'Via dei Portici', '89', 'Bolzano', 'BZ', '39100', '+39 0471 300890', 'info@speckstube.it', true, false),
  -- TRENTINO - TRENTO
  ('Scrigno del Duomo Trento', 'Ristorante nel centro storico. Carne salada, strangolapreti, polenta e funghi di montagna.', cat_ristoranti, 'Piazza Duomo', '29', 'Trento', 'TN', '38122', '+39 0461 220030', 'info@scrignoduomo.it', true, false),
  -- TOSCANA - AREZZO
  ('Antica Trattoria da Guido Arezzo', 'Cucina aretina tradizionale. Pici all''aglione, scottiglia aretina e peposo alla fornacina.', cat_ristoranti, 'Via Madonna del Prato', '85', 'Arezzo', 'AR', '52100', '+39 0575 23760', 'info@trattoriaguido.it', true, false),
  -- TOSCANA - GROSSETO
  ('Osteria del Mare Grosseto', 'Cucina maremmana e di mare. Acquacotta, cinghiale, cacciucco e pesci freschi.', cat_ristoranti, 'Via Mazzini', '23', 'Grosseto', 'GR', '58100', '+39 0564 25546', 'info@osteriadelmare.it', true, false),
  -- TOSCANA - LIVORNO
  ('Ristorante Il Sottomarino Livorno', 'Ristorante pesce fronte mare. Cacciucco livornese, triglie, frittura e crostacei.', cat_ristoranti, 'Via dei Pensieri', '67', 'Livorno', 'LI', '57123', '+39 0586 887025', 'info@ilsottomarino.it', true, false),
  -- TOSCANA - LUCCA
  ('Buca di Sant''Antonio Lucca', 'Ristorante storico lucchese dal 1782. Tordelli lucchesi, rovelline e farro della Garfagnana.', cat_ristoranti, 'Via della Cervia', '3', 'Lucca', 'LU', '55100', '+39 0583 55881', 'info@bucadisantantonio.it', true, false),
  -- TOSCANA - CARRARA
  ('Trattoria Omobono Carrara', 'Cucina apuana. Lardo di Colonnata, testaroli, agnello e funghi delle Apuane.', cat_ristoranti, 'Piazza Palestro', '3', 'Carrara', 'MS', '54033', '+39 0585 74245', 'info@trattoriaomobono.it', true, false),
  -- UMBRIA - TERNI
  ('Osteria della Mal''Ora Terni', 'Cucina umbra casalinga. Strangozzi al tartufo, palombacci e carne chianina.', cat_ristoranti, 'Via del Leone', '4', 'Terni', 'TR', '05100', '+39 0744 58763', 'info@malloraterni.it', true, false),
  -- MARCHE - ANCONA
  ('Ristorante La Moretta Ancona', 'Ristorante pesce sul porto. Brodetto anconetano, moscioli e stoccafisso all''anconetana.', cat_ristoranti, 'Piazza Plebiscito', '52', 'Ancona', 'AN', '60121', '+39 071 202317', 'info@lamoretta.it', true, false),
  -- LAZIO - FROSINONE
  ('Trattoria Ciociara Frosinone', 'Cucina ciociara tradizionale. Fettuccine, abbacchio, pampanella e dolci tipici.', cat_ristoranti, 'Via Aldo Moro', '45', 'Frosinone', 'FR', '03100', '+39 0775 270301', 'info@trattoriaciociara.it', true, false),
  -- LAZIO - LATINA
  ('Ristorante Il Fungo Latina', 'Ristorante pontino. Mozzarella di bufala, spaghetti alle telline e pesce di Terracina.', cat_ristoranti, 'Viale dello Statuto', '34', 'Latina', 'LT', '04100', '+39 0773 662749', 'info@ilfungolatina.it', true, false),
  -- ABRUZZO - PESCARA
  ('Ristorante Taverna 58 Pescara', 'Ristorante pesce fronte mare. Brodetto pescarese, scampi e crudi di mare.', cat_ristoranti, 'Corso Umberto', '83', 'Pescara', 'PE', '65122', '+39 085 690724', 'info@taverna58.it', true, false),
  -- CAMPANIA - SALERNO
  ('Ristorante Cicirinella Salerno', 'Cucina salernitana. Scialatielli ai frutti di mare, pizza cilentana e limoncello.', cat_ristoranti, 'Via Roma', '182', 'Salerno', 'SA', '84121', '+39 089 252054', 'info@cicirinella.it', true, false),
  -- PUGLIA - LECCE
  ('Alle Due Corti Lecce', 'Ristorante barocco leccese. Pasticciotto salato, ciceri e tria, rustico leccese.', cat_ristoranti, 'Corte dei Giugni', '1', 'Lecce', 'LE', '73100', '+39 0832 242223', 'info@alleduecorti.it', true, false),
  ('Laboratorio Pasticciotto Lecce', 'Pasticceria artigianale. Pasticciotti caldi, fruttoni e dolci salentini.', cat_negozi, 'Via Trinchese', '56', 'Lecce', 'LE', '73100', '+39 0832 241234', 'info@pasticciottolecce.it', true, false);

END $$;
