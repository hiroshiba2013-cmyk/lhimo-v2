/*
  # Add Comprehensive Business Categories

  1. Overview
    Adding extensive business categories to cover all types of Italian businesses and services.

  2. New Categories (16 additional categories)
    - Trasporti e Logistica
    - Assicurazioni e Finanza
    - Immobiliare
    - Sport e Tempo Libero
    - Istruzione e Formazione
    - Animali
    - Fotografia e Video
    - Informatica e Tecnologia
    - Lavanderie e Tintorie
    - Giardinaggio e Agricoltura
    - Wedding e Eventi
    - Pulizie e Servizi Domestici
    - Sicurezza
    - Noleggio
    - Pompe Funebri
    - Associazioni e No-Profit

  3. Security
    Public read access for all users maintained
*/

INSERT INTO business_categories (name, slug, description, ateco_code) VALUES
  ('Trasporti e Logistica', 'trasporti-logistica', 'Servizi di trasporto merci, corrieri, spedizioni, traslochi e logistica', '49.41.00'),
  ('Assicurazioni e Finanza', 'assicurazioni-finanza', 'Assicurazioni, banche, consulenza finanziaria, intermediazione creditizia', '64.19.10'),
  ('Immobiliare', 'immobiliare', 'Agenzie immobiliari, amministrazione condomini, valutazione immobili', '68.31.00'),
  ('Sport e Tempo Libero', 'sport-tempo-libero', 'Palestre, centri sportivi, piscine, campi da tennis, attività ricreative', '93.11.30'),
  ('Istruzione e Formazione', 'istruzione-formazione', 'Scuole private, centri di formazione, corsi professionali, lezioni private', '85.59.20'),
  ('Animali', 'animali', 'Negozi per animali, veterinari, toelettatura, pensioni per animali', '75.00.00'),
  ('Fotografia e Video', 'fotografia-video', 'Fotografi, studi fotografici, videomaker, servizi foto e video per eventi', '74.20.11'),
  ('Informatica e Tecnologia', 'informatica-tecnologia', 'Assistenza informatica, riparazione computer, web agency, software house', '62.01.00'),
  ('Lavanderie e Tintorie', 'lavanderie-tintorie', 'Lavanderie self-service, tintorie, stirerie, lavaggio e pulizia tessuti', '96.01.10'),
  ('Giardinaggio e Agricoltura', 'giardinaggio-agricoltura', 'Servizi di giardinaggio, vivai, manutenzione giardini, consulenze agricole', '81.30.00'),
  ('Wedding e Eventi', 'wedding-eventi', 'Wedding planner, organizzazione eventi, catering, noleggio attrezzature per feste', '96.09.09'),
  ('Pulizie e Servizi Domestici', 'pulizie-domestici', 'Imprese di pulizia, servizi domestici, pulizia uffici e condomini', '81.21.00'),
  ('Sicurezza', 'sicurezza', 'Servizi di vigilanza, installazione allarmi, videosorveglianza, sicurezza privata', '80.10.00'),
  ('Noleggio', 'noleggio', 'Autonoleggio, noleggio attrezzature, noleggio mezzi da lavoro', '77.11.00'),
  ('Pompe Funebri', 'pompe-funebri', 'Servizi funebri, onoranze funebri, cremazione, trasporti funebri', '96.03.00'),
  ('Associazioni e No-Profit', 'associazioni-no-profit', 'Associazioni culturali, sportive, di volontariato, organizzazioni non profit', '94.99.90')
ON CONFLICT (slug) DO NOTHING;
