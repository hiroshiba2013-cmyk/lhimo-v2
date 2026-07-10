/*
  # Seed Varese Province Businesses
  
  1. New Data
    - Insert unclaimed businesses in Varese province
    - Covers various categories and cities
    - Includes realistic business information
    
  2. Categories
    - Restaurants, bars, shops, professional services
    - Healthcare, beauty, automotive, etc.
    
  3. Locations
    - Varese, Busto Arsizio, Gallarate, Saronno, and other cities
*/

-- Insert businesses in Varese province
INSERT INTO businesses (
  name,
  description,
  city,
  office_province,
  office_city,
  office_street,
  phone,
  email,
  category_id,
  verified,
  is_claimed
) VALUES
  -- Restaurants in Varese
  (
    'Ristorante Al Vecchio Convento',
    'Ristorante tradizionale con cucina italiana e specialità regionali. Ambiente elegante e accogliente.',
    'Varese',
    'VA',
    'Varese',
    'Via Sacco 5',
    '+39 0332 261005',
    'info@vecchioconvento.it',
    (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1),
    true,
    false
  ),
  (
    'Trattoria Da Mario',
    'Trattoria familiare con piatti casalinghi e prodotti locali. Ambiente informale e cordiale.',
    'Varese',
    'VA',
    'Varese',
    'Corso Matteotti 18',
    '+39 0332 283456',
    'trattoriadamario@email.it',
    (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1),
    true,
    false
  ),
  
  -- Bar e Caffè
  (
    'Bar Centrale',
    'Bar nel centro di Varese, ideale per colazione e aperitivo. Servizio veloce e cordiale.',
    'Varese',
    'VA',
    'Varese',
    'Piazza Monte Grappa 2',
    '+39 0332 234567',
    'barcentrale@email.it',
    (SELECT id FROM business_categories WHERE name = 'Bar e Caffè' LIMIT 1),
    true,
    false
  ),
  
  -- Busto Arsizio
  (
    'Pizzeria La Napoletana',
    'Pizzeria con forno a legna e ingredienti di qualità. Pizze napoletane doc.',
    'Busto Arsizio',
    'VA',
    'Busto Arsizio',
    'Via Milano 45',
    '+39 0331 622334',
    'lanapoletana@email.it',
    (SELECT id FROM business_categories WHERE name = 'Pizzerie' LIMIT 1),
    true,
    false
  ),
  (
    'Farmacia San Michele',
    'Farmacia con ampio assortimento di prodotti farmaceutici e parafarmaceutici.',
    'Busto Arsizio',
    'VA',
    'Busto Arsizio',
    'Via Volta 12',
    '+39 0331 625789',
    'farmaciasanmichele@email.it',
    (SELECT id FROM business_categories WHERE name = 'Farmacie' LIMIT 1),
    true,
    false
  ),
  
  -- Gallarate
  (
    'Parrucchiere Eleganza',
    'Salone di parrucchiera con servizi di taglio, colore e trattamenti. Staff qualificato.',
    'Gallarate',
    'VA',
    'Gallarate',
    'Via Mazzini 8',
    '+39 0331 792345',
    'eleganza@email.it',
    (SELECT id FROM business_categories WHERE name = 'Parrucchieri' LIMIT 1),
    true,
    false
  ),
  (
    'Officina Meccanica Rossi',
    'Officina specializzata in riparazioni auto e manutenzione. Servizio rapido e affidabile.',
    'Gallarate',
    'VA',
    'Gallarate',
    'Via Torino 32',
    '+39 0331 771234',
    'officinarossi@email.it',
    (SELECT id FROM business_categories WHERE name = 'Officine Meccaniche' LIMIT 1),
    true,
    false
  ),
  
  -- Saronno
  (
    'Ristorante Il Gabbiano',
    'Ristorante di pesce con specialità di mare. Ambiente raffinato e menu ricercato.',
    'Saronno',
    'VA',
    'Saronno',
    'Via Roma 24',
    '+39 02 9621234',
    'ilgabbiano@email.it',
    (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1),
    true,
    false
  ),
  (
    'Centro Estetico Bellezza',
    'Centro estetico con trattamenti viso e corpo. Personale specializzato.',
    'Saronno',
    'VA',
    'Saronno',
    'Via Garibaldi 15',
    '+39 02 9625678',
    'centrobellezza@email.it',
    (SELECT id FROM business_categories WHERE name = 'Centri Estetici' LIMIT 1),
    true,
    false
  ),
  
  -- Tradate
  (
    'Ferramenta Moderna',
    'Ferramenta con vasto assortimento di articoli per casa e giardino.',
    'Tradate',
    'VA',
    'Tradate',
    'Via Cavour 22',
    '+39 0331 841234',
    'ferramentamoderna@email.it',
    (SELECT id FROM business_categories WHERE name = 'Ferramenta' LIMIT 1),
    true,
    false
  ),
  
  -- Luino
  (
    'Hotel Lago Maggiore',
    'Hotel con vista sul lago, camere confortevoli e ristorante interno.',
    'Luino',
    'VA',
    'Luino',
    'Lungolago 5',
    '+39 0332 530123',
    'hotellagomaggiore@email.it',
    (SELECT id FROM business_categories WHERE name = 'Hotel' LIMIT 1),
    true,
    false
  ),
  (
    'Gelateria Dolce Vita',
    'Gelateria artigianale con gusti tradizionali e innovativi. Prodotti freschi.',
    'Luino',
    'VA',
    'Luino',
    'Piazza Libertà 8',
    '+39 0332 532456',
    'dolcevita@email.it',
    (SELECT id FROM business_categories WHERE name = 'Gelaterie' LIMIT 1),
    true,
    false
  ),
  
  -- Malnate
  (
    'Panificio Pane Quotidiano',
    'Panificio artigianale con pane fatto in casa e prodotti da forno.',
    'Malnate',
    'VA',
    'Malnate',
    'Via Roma 45',
    '+39 0332 427123',
    'panequotidiano@email.it',
    (SELECT id FROM business_categories WHERE name = 'Panifici' LIMIT 1),
    true,
    false
  ),
  
  -- Cassano Magnago
  (
    'Studio Dentistico Dr. Bianchi',
    'Studio dentistico con servizi di odontoiatria generale e specialistica.',
    'Cassano Magnago',
    'VA',
    'Cassano Magnago',
    'Via Verdi 7',
    '+39 0331 280456',
    'studiobianchi@email.it',
    (SELECT id FROM business_categories WHERE name = 'Dentisti' LIMIT 1),
    true,
    false
  ),
  
  -- Somma Lombardo
  (
    'Libreria Mondadori',
    'Libreria con ampia scelta di libri, edicola e cartoleria.',
    'Somma Lombardo',
    'VA',
    'Somma Lombardo',
    'Via Mazzini 33',
    '+39 0331 250789',
    'libreriamondadori@email.it',
    (SELECT id FROM business_categories WHERE name = 'Librerie' LIMIT 1),
    true,
    false
  ),
  
  -- Gavirate
  (
    'Ristorante Camin Hotel',
    'Ristorante elegante con cucina creativa e vista panoramica sul lago.',
    'Gavirate',
    'VA',
    'Gavirate',
    'Via De Magistris 5',
    '+39 0332 745200',
    'caminhotel@email.it',
    (SELECT id FROM business_categories WHERE name = 'Ristoranti' LIMIT 1),
    true,
    false
  ),
  
  -- More businesses in Varese
  (
    'Negozio di Abbigliamento Fashion Point',
    'Boutique di abbigliamento con le ultime tendenze moda.',
    'Varese',
    'VA',
    'Varese',
    'Corso Matteotti 25',
    '+39 0332 287654',
    'fashionpoint@email.it',
    (SELECT id FROM business_categories WHERE name = 'Abbigliamento' LIMIT 1),
    true,
    false
  ),
  (
    'Supermercato Conad',
    'Supermercato con vasta scelta di prodotti alimentari e non.',
    'Varese',
    'VA',
    'Varese',
    'Via Sanvito Silvestro 2',
    '+39 0332 220123',
    'conadvarese@email.it',
    (SELECT id FROM business_categories WHERE name = 'Supermercati' LIMIT 1),
    true,
    false
  ),
  (
    'Studio Legale Avv. Lombardi',
    'Studio legale specializzato in diritto civile e commerciale.',
    'Varese',
    'VA',
    'Varese',
    'Via Como 14',
    '+39 0332 242567',
    'studiolombardi@email.it',
    (SELECT id FROM business_categories WHERE name = 'Avvocati' LIMIT 1),
    true,
    false
  ),
  (
    'Palestra FitLife',
    'Palestra attrezzata con corsi fitness e personal trainer.',
    'Busto Arsizio',
    'VA',
    'Busto Arsizio',
    'Via Bellini 18',
    '+39 0331 634567',
    'fitlife@email.it',
    (SELECT id FROM business_categories WHERE name = 'Palestre' LIMIT 1),
    true,
    false
  ),
  (
    'Agenzia Immobiliare Casa Facile',
    'Agenzia immobiliare con servizi di compravendita e locazione.',
    'Gallarate',
    'VA',
    'Gallarate',
    'Piazza Libertà 3',
    '+39 0331 783456',
    'casafacile@email.it',
    (SELECT id FROM business_categories WHERE name = 'Agenzie Immobiliari' LIMIT 1),
    true,
    false
  );
