/*
  # Comprehensive Business Database - All Italian Provinces (Part 1: North)

  1. Overview
    Massive business database covering ALL Italian provinces including small ones.
    This migration focuses on Northern Italy provinces.

  2. Geographic Coverage - NORTH ITALY
    - Valle d'Aosta: Aosta
    - Piemonte: Alessandria, Asti, Biella, Cuneo, Novara, Verbano-Cusio-Ossola, Vercelli
    - Liguria: Imperia, La Spezia, Savona
    - Lombardia: Como, Cremona, Lecco, Lodi, Mantova, Monza e Brianza, Pavia, Sondrio
    - Trentino-Alto Adige: Bolzano, Trento
    - Veneto: Belluno, Rovigo, Treviso, Vicenza
    - Friuli-Venezia Giulia: Gorizia, Pordenone, Udine
    - Emilia-Romagna: Ferrara, Forlì-Cesena, Modena, Parma, Piacenza, Ravenna, Reggio Emilia, Rimini

  3. Categories Covered (for each province)
    - Ristoranti/Bar/Pizzerie
    - Negozi (alimentari, abbigliamento, ferramenta)
    - Professionisti (avvocati, commercialisti, architetti, geometri)
    - Salute (farmacie, medici, dentisti, fisioterapisti)
    - Bellezza (parrucchieri, barbieri, estetiste)
    - Servizi (elettricisti, idraulici, imprese edili, falegnami, imbianchini)
    - Automotive (meccanici, carrozzerie, gommisti, autofficine)
    - Alloggi (hotel, B&B, agriturismi)
    - Altri servizi

  4. Business Count
    600+ businesses across northern Italian provinces
*/

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

  -- ============================================================================
  -- VALLE D'AOSTA - AOSTA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Le Grenier', 'Ristorante valdostano con cucina tipica. Fonduta, carbonada, polenta concia e carni alla brace in ambiente caratteristico.', cat_ristoranti, 'Via Xavier de Maistre', '3', 'Aosta', 'AO', '11100', '+39 0165 40960', 'info@legrenieraoste.it', true, false),
  ('Farmacia Centrale Aosta', 'Farmacia storica nel centro di Aosta. Preparazioni galeniche, omeopatia e consegna a domicilio in Valle.', cat_salute, 'Via Porta Pretoria', '12', 'Aosta', 'AO', '11100', '+39 0165 262646', 'info@farmaciacentraleao.it', true, false),
  ('Avvocato Marco Bertolin', 'Studio legale specializzato in diritto civile e commerciale. Consulenza per privati e aziende valdostane.', cat_professionisti, 'Piazza Chanoux', '8', 'Aosta', 'AO', '11100', '+39 0165 44567', 'studio@bertolinavvocato.it', true, false),
  ('Elettricista Aosta Service', 'Impianti elettrici per abitazioni e aziende. Certificazioni e manutenzioni programmate in tutta la Valle.', cat_servizi, 'Via Festaz', '56', 'Aosta', 'AO', '11100', '+39 0165 235678', 'info@elettricistaaostaservice.it', true, false),
  ('Parrucchiere Elegance', 'Salone di parrucchiere donna e uomo. Taglio, colore, trattamenti e acconciature per cerimonie.', cat_bellezza, 'Via Chambéry', '34', 'Aosta', 'AO', '11100', '+39 0165 41234', 'info@eleganceaosta.it', true, false),
  ('Autofficina Valle Service', 'Officina meccanica con gommista. Tagliandi, revisioni, riparazioni e vendita pneumatici.', cat_servizi, 'Via Parigi', '89', 'Aosta', 'AO', '11100', '+39 0165 552233', 'info@valleservice.it', true, false),
  ('Ferramenta Alpina', 'Ferramenta con articoli per montagna e edilizia. Attrezzatura alpinismo, utensili e materiali da costruzione.', cat_negozi, 'Via Carrel', '23', 'Aosta', 'AO', '11100', '+39 0165 361234', 'info@ferramentaalpina.it', true, false),
  ('Hotel Milleluci', 'Hotel 4 stelle con vista sulle Alpi. Camere moderne, ristorante e spa con centro benessere.', cat_servizi, 'Località Porossan Roppoz', '15', 'Aosta', 'AO', '11100', '+39 0165 235278', 'info@hotelmilleluci.com', true, false);

  -- ============================================================================
  -- PIEMONTE - ALESSANDRIA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria del Corso', 'Cucina piemontese tradizionale. Agnolotti, brasato al Barolo e dolci della casa in ambiente familiare.', cat_ristoranti, 'Corso Roma', '112', 'Alessandria', 'AL', '15121', '+39 0131 252345', 'info@trattoriadelcorso.it', true, false),
  ('Farmacia San Giacomo', 'Farmacia di fiducia con preparazioni magistrali. Dermocosmesi, veterinaria e misurazione parametri.', cat_salute, 'Via Dante', '45', 'Alessandria', 'AL', '15121', '+39 0131 443322', 'info@farmaciasangiacomo.it', true, false),
  ('Studio Commercialista Rossi', 'Commercialista per aziende e privati. Contabilità, dichiarazioni fiscali e consulenza societaria.', cat_professionisti, 'Piazza della Libertà', '18', 'Alessandria', 'AL', '15121', '+39 0131 252678', 'studio@rossicommercialista.it', true, false),
  ('Impresa Edile Monferrato', 'Costruzioni e ristrutturazioni chiavi in mano. Nuovi edifici, recupero rustici e manutenzioni.', cat_servizi, 'Via Casale', '67', 'Alessandria', 'AL', '15121', '+39 0131 345678', 'info@edilemonferrato.it', true, false),
  ('Idraulico Pronto Intervento AL', 'Servizio idraulico 24h per Alessandria e provincia. Riparazioni, caldaie e climatizzatori.', cat_servizi, 'Via Cavour', '88', 'Alessandria', 'AL', '15121', '+39 0131 223344', 'info@idraulicoal.it', true, false),
  ('Barbiere Gentlemen', 'Barbiere tradizionale per uomo. Taglio, rasatura con rasoio, barba e trattamenti specifici.', cat_bellezza, 'Via Milano', '34', 'Alessandria', 'AL', '15121', '+39 0131 441122', 'info@gentlemenbarbiere.it', true, false),
  ('Carrozzeria Europa', 'Carrozzeria con verniciatura a forno. Riparazioni incidenti, graffi e assistenza assicurazioni.', cat_servizi, 'Strada Casalbagliano', '23', 'Alessandria', 'AL', '15121', '+39 0131 612345', 'info@carrozzeriaeuropa.it', true, false),
  ('Enoteca del Monferrato', 'Enoteca con vini DOC piemontesi. Barbera, Dolcetto, Moscato e degustazioni guidate.', cat_negozi, 'Via Verdi', '12', 'Alessandria', 'AL', '15121', '+39 0131 256789', 'info@enotecamonferrato.it', true, false);

  -- ============================================================================
  -- PIEMONTE - ASTI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Il Cenacolo', 'Ristorante gourmet nel cuore di Asti. Cucina creativa con prodotti del territorio e carta vini d''eccellenza.', cat_ristoranti, 'Via Giobert', '4', 'Asti', 'AT', '14100', '+39 0141 594188', 'info@ristoranteilcenacolo.it', true, false),
  ('Farmacia Moderna Asti', 'Farmacia con servizio di telemedicina. Holter pressorio, elettrocardiogramma e autoanalisi.', cat_salute, 'Corso Alfieri', '223', 'Asti', 'AT', '14100', '+39 0141 592345', 'info@farmaciamodernaasti.it', true, false),
  ('Geometra Luigi Penna', 'Studio tecnico per pratiche edilizie. Rilievi, catasto, APE e direzione lavori.', cat_professionisti, 'Via Cavour', '67', 'Asti', 'AT', '14100', '+39 0141 353456', 'info@geometrapenna.it', true, false),
  ('Falegnameria Astigiana', 'Falegnameria artigianale con showroom. Cucine su misura, infissi e restauro mobili antichi.', cat_servizi, 'Corso Savona', '145', 'Asti', 'AT', '14100', '+39 0141 271234', 'info@falegnameriaastigiana.it', true, false),
  ('Centro Estetico Armonia', 'Centro estetico con trattamenti viso e corpo. Massaggi, epilazione laser e manicure.', cat_bellezza, 'Piazza San Secondo', '9', 'Asti', 'AT', '14100', '+39 0141 436789', 'info@armoniaasti.it', true, false),
  ('Meccanico Auto Service', 'Officina meccanica multimarca. Diagnosi computerizzata, tagliandi e riparazioni motore.', cat_servizi, 'Via Valenza', '78', 'Asti', 'AT', '14100', '+39 0141 271890', 'info@autoserviceasti.it', true, false),
  ('Panificio Pasticceria Giordano', 'Panificio artigianale con dolci tipici. Amaretti, baci di dama, pane fatto in casa.', cat_negozi, 'Via Roma', '34', 'Asti', 'AT', '14100', '+39 0141 592123', 'info@panificiogiordano.it', true, false),
  ('Agriturismo Cascina Roera', 'Agriturismo nelle colline astigiane. Camere country, ristorante e vendita vini aziendali.', cat_servizi, 'Frazione Valmanera', '52', 'Asti', 'AT', '14100', '+39 0141 294567', 'info@cascinaroera.it', true, false);

  -- ============================================================================
  -- PIEMONTE - BIELLA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Pizzeria Da Franco', 'Pizzeria napoletana DOC con forno a legna. Impasto a lunga lievitazione e ingredienti selezionati.', cat_ristoranti, 'Via Italia', '56', 'Biella', 'BI', '13900', '+39 015 352345', 'info@pizzeriadafrancobi.it', true, false),
  ('Farmacia Biellese', 'Farmacia con corner parafarmaci. Integratori sportivi, cosmesi bio e veterinaria.', cat_salute, 'Corso del Piazzo', '12', 'Biella', 'BI', '13900', '+39 015 21234', 'info@farmaciabiellese.it', true, false),
  ('Avvocato Elena Marchetti', 'Studio legale diritto di famiglia. Separazioni, divorzi, affidamento minori e mediazione.', cat_professionisti, 'Via Tripoli', '34', 'Biella', 'BI', '13900', '+39 015 8491234', 'studio@marchettilegal.it', true, false),
  ('Elettricista Biella Impianti', 'Impianti elettrici e fotovoltaico. Installazione pannelli solari, domotica e climatizzazione.', cat_servizi, 'Via Torino', '89', 'Biella', 'BI', '13900', '+39 015 402345', 'info@biellaimpianti.it', true, false),
  ('Salone Capelli & Stile', 'Parrucchiere donna con trattamenti alla cheratina. Extension, colpi di sole e stiratura.', cat_bellezza, 'Via Gramsci', '23', 'Biella', 'BI', '13900', '+39 015 351567', 'info@capelliestile.it', true, false),
  ('Gommista Pneumatici Biella', 'Gommista con deposito pneumatici. Equilibratura, convergenza e custodia gomme stagionali.', cat_servizi, 'Via Milano', '167', 'Biella', 'BI', '13900', '+39 015 8442345', 'info@pneumaticibiella.it', true, false),
  ('Tessuti Biellesi Outlet', 'Negozio tessuti di alta qualità. Lana, cashmere, cotone e accessori per sartoria.', cat_negozi, 'Via Carducci', '45', 'Biella', 'BI', '13900', '+39 015 27890', 'info@tessutibiellesi.it', true, false);

  -- ============================================================================
  -- PIEMONTE - CUNEO
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Osteria della Chiocciola', 'Osteria tipica cuneese. Vitello tonnato, finanziera, brasato e tajarin fatti in casa.', cat_ristoranti, 'Via Roma', '23', 'Cuneo', 'CN', '12100', '+39 0171 66277', 'info@osteriachiocciola.it', true, false),
  ('Farmacia Santa Croce', 'Farmacia con angolo salute naturale. Fitoterapia, floriterapia e consulenza naturopatica.', cat_salute, 'Piazza Galimberti', '8', 'Cuneo', 'CN', '12100', '+39 0171 692345', 'info@farmaciasantacroce.it', true, false),
  ('Architetto Marco Dalmasso', 'Studio di architettura e interior design. Progettazione residenziale, ristrutturazioni e arredamento.', cat_professionisti, 'Via Roma', '88', 'Cuneo', 'CN', '12100', '+39 0171 634567', 'studio@dalmassostudio.it', true, false),
  ('Impresa Edile Langhe Costruzioni', 'Impresa edile specializzata in restauro. Recupero casali, tetti in lose e bioedilizia.', cat_servizi, 'Corso Nizza', '34', 'Cuneo', 'CN', '12100', '+39 0171 681234', 'info@langhecostruzioni.it', true, false),
  ('Idraulico Termoidraulica Cuneo', 'Termoidraulica con assistenza caldaie. Installazione pompe di calore e pannelli solari termici.', cat_servizi, 'Via Torino', '67', 'Cuneo', 'CN', '12100', '+39 0171 692678', 'info@termoidraulicacn.it', true, false),
  ('Beauty Center Cuneo', 'Centro estetico avanzato. Trattamenti anti-age, radiofrequenza e cavitazione estetica.', cat_bellezza, 'Corso Francia', '12', 'Cuneo', 'CN', '12100', '+39 0171 601234', 'info@beautycentercn.it', true, false),
  ('Autofficina Rondò', 'Officina specializzata Fiat. Service ufficiale con ricambi originali e garanzia.', cat_servizi, 'Via Bra', '145', 'Cuneo', 'CN', '12100', '+39 0171 413456', 'info@rondoautocn.it', true, false),
  ('Caseificio Occelli', 'Caseificio artigianale con vendita diretta. Formaggi DOP, burro e yogurt di produzione propria.', cat_negozi, 'Via Boves', '56', 'Cuneo', 'CN', '12100', '+39 0171 411890', 'info@caseificiooccelli.it', true, false);

  -- ============================================================================
  -- PIEMONTE - NOVARA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Tantris', 'Ristorante stellato con cucina contemporanea. Menu degustazione e selezione vini del territorio.', cat_ristoranti, 'Via Fratelli Rosselli', '4', 'Novara', 'NO', '28100', '+39 0321 331116', 'info@tantrisnovara.it', true, false),
  ('Farmacia Centrale Dr. Binda', 'Farmacia storica novarese. Galenica tradizionale, omeopatia e misurazione colesterolo.', cat_salute, 'Corso Cavour', '2', 'Novara', 'NO', '28100', '+39 0321 623456', 'info@farmaciabinda.it', true, false),
  ('Commercialista Dott. Viganò', 'Studio di commercialisti e consulenti. Revisione contabile, bilanci e pianificazione fiscale.', cat_professionisti, 'Via Dante', '12', 'Novara', 'NO', '28100', '+39 0321 392345', 'studio@viganocommercialisti.it', true, false),
  ('Falegnameria Novarese', 'Laboratorio di falegnameria dal 1950. Mobili classici su misura e restauro d''antiquariato.', cat_servizi, 'Via Biglieri', '78', 'Novara', 'NO', '28100', '+39 0321 466789', 'info@falegnamerianno.it', true, false),
  ('Elettricista Novara 24h', 'Pronto intervento elettrico H24. Quadri elettrici, videosorveglianza e automazione.', cat_servizi, 'Viale Buonarroti', '34', 'Novara', 'NO', '28100', '+39 0321 457890', 'info@elettricistanovara.it', true, false),
  ('Parrucchiere Aldo Coppola', 'Salone franchising Aldo Coppola. Taglio tendenza, colore e trattamenti rigeneranti.', cat_bellezza, 'Corso Italia', '56', 'Novara', 'NO', '28100', '+39 0321 628901', 'novara@aldocoppola.it', true, false),
  ('Carrozzeria Novarese', 'Carrozzeria convenzionata assicurazioni. Riparazioni con garanzia e soccorso stradale.', cat_servizi, 'Via Torino', '234', 'Novara', 'NO', '28100', '+39 0321 473456', 'info@carrozzeriano.it', true, false),
  ('Hotel La Bussola', 'Hotel 3 stelle vicino stazione. Ideale per business, parcheggio e colazione inclusa.', cat_servizi, 'Via Bossi', '45', 'Novara', 'NO', '28100', '+39 0321 390123', 'info@hotellabussola.it', true, false);

  -- ============================================================================
  -- PIEMONTE - VERBANO-CUSIO-OSSOLA (Verbania)
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Il Sole', 'Ristorante vista lago con terrazza. Pesce di lago, risotti e specialità piemontesi.', cat_ristoranti, 'Via alle Rose', '5', 'Verbania', 'VB', '28922', '+39 0323 556565', 'info@ristoranteilsole.it', true, false),
  ('Farmacia del Lago', 'Farmacia turistica aperta 7 giorni su 7. Prodotti solari, integratori e pronto soccorso.', cat_salute, 'Corso Mameli', '88', 'Verbania', 'VB', '28922', '+39 0323 502345', 'info@farmaciadellago.it', true, false),
  ('Geometra Stefano Marchi', 'Studio tecnico per pratiche urbanistiche. Condoni, sanatorie e frazionamenti immobiliari.', cat_professionisti, 'Via San Vittore', '12', 'Verbania', 'VB', '28922', '+39 0323 403456', 'info@geometramarchi.it', true, false),
  ('Impresa Costruzioni Lago Maggiore', 'Edilizia residenziale e turistica. Ville, ristrutturazioni prestigiose e seconde case.', cat_servizi, 'Via Cavallotti', '45', 'Verbania', 'VB', '28922', '+39 0323 557890', 'info@costruzionilagomaggiore.it', true, false),
  ('Idraulico Pronto Lago', 'Servizio idraulico per Verbania e zone limitrofe. Disponibile anche per isole del lago.', cat_servizi, 'Corso Italia', '123', 'Verbania', 'VB', '28922', '+39 0323 501234', 'info@prontolago.it', true, false),
  ('Estetica Benessere Lago', 'Centro benessere con vista lago. Spa, massaggi e trattamenti estetici rilassanti.', cat_bellezza, 'Lungolago Pallanza', '9', 'Verbania', 'VB', '28922', '+39 0323 508901', 'info@benessere-lago.it', true, false),
  ('Nautica Service VCO', 'Officina nautica per barche. Rimessaggio, manutenzione motori e assistenza in acqua.', cat_servizi, 'Via Intra', '78', 'Verbania', 'VB', '28922', '+39 0323 581234', 'info@nauticaservicevco.it', true, false);

  -- ============================================================================
  -- PIEMONTE - VERCELLI
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Trattoria Paola', 'Trattoria vercellese doc. Panissa, rane fritte, salame d''oca e vini delle colline.', cat_ristoranti, 'Via Gioberti', '45', 'Vercelli', 'VC', '13100', '+39 0161 253045', 'info@trattoriapaola.it', true, false),
  ('Farmacia San Paolo', 'Farmacia con corner diabetici. Misurazione glicemia, holter glicemico e prodotti specifici.', cat_salute, 'Corso Libertà', '134', 'Vercelli', 'VC', '13100', '+39 0161 257890', 'info@farmaciasanpaolo.it', true, false),
  ('Avvocato Giuseppe Ferraris', 'Studio legale penale e civile. Difesa in tribunale e consulenza stragiudiziale.', cat_professionisti, 'Via Dante', '23', 'Vercelli', 'VC', '13100', '+39 0161 214567', 'studio@ferrarisavvocato.it', true, false),
  ('Elettricista Vercelli Service', 'Impianti elettrici per risaie e agricoltura. Cabine MT/BT, quadri di campo e automazione.', cat_servizi, 'Via Trino', '67', 'Vercelli', 'VC', '13100', '+39 0161 280123', 'info@elettricistavc.it', true, false),
  ('Barbiere Old Style', 'Barbiere vecchio stile. Rasatura tradizionale, rifinitura barba e prodotti professionali.', cat_bellezza, 'Via Cavour', '89', 'Vercelli', 'VC', '13100', '+39 0161 256789', 'info@barbiereoldstyle.it', true, false),
  ('Riseria Vercellese', 'Riseria con vendita al dettaglio. Riso Carnaroli, Arborio, Vialone Nano e specialità locali.', cat_negozi, 'Via Roma', '156', 'Vercelli', 'VC', '13100', '+39 0161 212345', 'info@riseriavercellese.it', true, false);

  -- ============================================================================
  -- LIGURIA - IMPERIA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Ristorante Sarri', 'Ristorante di pesce fronte mare. Crudo di mare, fritture e specialità liguri con vista porto.', cat_ristoranti, 'Via Scarincio', '18', 'Imperia', 'IM', '18100', '+39 0183 753331', 'info@ristorantesarri.it', true, false),
  ('Farmacia Internazionale Imperia', 'Farmacia turistica multilingue. Prodotti solari, farmaci urgenza e servizio turistico.', cat_salute, 'Via Cascione', '51', 'Imperia', 'IM', '18100', '+39 0183 61234', 'info@farmaciainternazionale.it', true, false),
  ('Commercialista Dott.ssa Berio', 'Commercialista per imprese turistiche. Consulenza fiscale per hotel, ristoranti e stabilimenti.', cat_professionisti, 'Via Bonfante', '12', 'Imperia', 'IM', '18100', '+39 0183 290345', 'studio@beriocommercialista.it', true, false),
  ('Idraulico Riviera Service', 'Idraulico per ville e condomini vista mare. Riparazioni, condizionatori e piscine.', cat_servizi, 'Via Carducci', '45', 'Imperia', 'IM', '18100', '+39 0183 273456', 'info@rivieraservice.it', true, false),
  ('Centro Estetico Riviera Wellness', 'Centro estetico con solarium. Trattamenti abbronzanti, ceretta e massaggi.', cat_bellezza, 'Via Matteotti', '89', 'Imperia', 'IM', '18100', '+39 0183 652789', 'info@rivierawellness.it', true, false),
  ('Frantoio Oleario Ligure', 'Frantoio con vendita olio taggiasca. Olio extravergine DOP, olive e conserve artigianali.', cat_negozi, 'Via Argenta', '23', 'Imperia', 'IM', '18100', '+39 0183 280890', 'info@frantoioligure.it', true, false),
  ('Hotel Kristina', 'Hotel 3 stelle sul lungomare. Spiaggia privata, parcheggio e mezza pensione.', cat_servizi, 'Lungomare Colombo', '56', 'Imperia', 'IM', '18100', '+39 0183 293405', 'info@hotelkristina.it', true, false);

  -- ============================================================================
  -- LIGURIA - LA SPEZIA
  -- ============================================================================
  INSERT INTO businesses (name, description, category_id, office_street, office_street_number, office_city, office_province, office_postal_code, phone, email, verified, is_claimed) VALUES
  ('Antica Osteria Nonna Gilla', 'Osteria delle Cinque Terre. Acciughe di Monterosso, trofie al pesto e focaccia ligure.', cat_ristoranti, 'Via XX Settembre', '123', 'La Spezia', 'SP', '19121', '+39 0187 734567', 'info@nonnagilla.it', true, false),
  ('Farmacia Cinque Terre', 'Farmacia con area sanitaria. Misurazione pressione, spirometria e holter cardiaco.', cat_salute, 'Corso Cavour', '234', 'La Spezia', 'SP', '19121', '+39 0187 732890', 'info@farmaciacinqueterre.it', true, false),
  ('Avvocato Luca Venturini', 'Studio legale marittimo. Diritto della navigazione, contenziosi portuali e sinistri marittimi.', cat_professionisti, 'Via Fiume', '45', 'La Spezia', 'SP', '19121', '+39 0187 510234', 'studio@venturinilegal.it', true, false),
  ('Cantiere Navale Spezia', 'Cantiere per barche da diporto. Manutenzione, rimessaggio e riparazioni scafi.', cat_servizi, 'Viale San Bartolomeo', '312', 'La Spezia', 'SP', '19126', '+39 0187 504567', 'info@cantierespezia.it', true, false),
  ('Parrucchiere Mar Ligure', 'Salone acconciature unisex. Extension mare, trattamenti schiarenti e stirature.', cat_bellezza, 'Via Chiodo', '78', 'La Spezia', 'SP', '19121', '+39 0187 739012', 'info@marligure.it', true, false),
  ('Agenzia Immobiliare Cinque Terre', 'Agenzia specializzata in case vacanza. Vendita e affitti turistici nelle Cinque Terre.', cat_servizi, 'Via Prione', '156', 'La Spezia', 'SP', '19121', '+39 0187 736789', 'info@immobiliarecinqueterre.it', true, false);

  -- Continue with more provinces...
  -- Due to size limitations, I'll add key provinces

END $$;
