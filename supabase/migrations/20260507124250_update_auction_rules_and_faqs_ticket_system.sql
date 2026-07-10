/*
  # Aggiornamento Regole e FAQ Aste - Sistema Ticket 10%

  Aggiorna il contenuto del regolamento della sezione "aste" e le FAQ correlate
  per riflettere le nuove regole:
  - Ticket pari al 10% della base d'asta (non più deposito fisso)
  - Offerte irrevocabili
  - Flusso 48h con scalabilità vincitori
  - Pulsante conferma conclusione asta
*/

-- Aggiorna il regolamento della sezione aste
UPDATE rules_content
SET
  content_text = E'## Come Funzionano le Aste\n\nLe aste su Trovafacile permettono a tutti gli utenti (privati e aziende) di vendere e acquistare oggetti attraverso un sistema di offerte competitive.\n\n### Creazione Asta\n- Ogni utente autenticato può creare un''asta\n- È necessario fornire: titolo, descrizione, immagini, base d''asta, categoria, condizioni e località\n- La durata dell''asta può essere da 1 a 14 giorni\n- Le aste richiedono l''approvazione dell''amministratore prima di diventare visibili\n\n### Ticket di Partecipazione\n- Per partecipare a un''asta è necessario acquistare un **ticket pari al 10% della base d''asta**\n- Esempio: base d''asta 200 € → ticket 20 €; base 500 € → ticket 50 €\n- Il ticket viene trattenuto dalla piattaforma se l''acquirente vincitore conferma l''affare\n- Se perdi l''asta, il ticket ti viene rimborsato\n- Se vinci ma **non confermi entro 48 ore**, il ticket viene **trattenuto** e l''asta passa al classificato successivo\n\n### Offerte — Regola Fondamentale\n- Le offerte sono **irrevocabili**: una volta inviata un''offerta, non è possibile ritirarla\n- Le offerte devono essere superiori all''offerta attuale (o alla base d''asta se non ci sono offerte)\n- Chi fa l''offerta più alta alla scadenza è il vincitore provvisorio\n\n### Conclusione Asta\n- L''asta termina automaticamente alla scadenza\n- Il vincitore (chi ha fatto l''offerta più alta) riceve una notifica e ha **48 ore** per confermare l''affare\n- Anche il venditore deve confermare entro le stesse 48 ore\n- La transazione si considera conclusa quando **entrambe le parti** premono il pulsante "Conferma Affare"\n\n### Scalabilità dei Vincitori\n- Se il vincitore **non conferma entro 48 ore**, perde il ticket e l''asta passa automaticamente al **secondo classificato**\n- Il secondo classificato riceve una notifica e ha a sua volta 48 ore per confermare\n- Questo meccanismo continua fino a che qualcuno conferma o non ci sono più partecipanti disponibili\n- In quest''ultimo caso l''asta si chiude definitivamente senza conclusione\n\n### Responsabilità\n- La piattaforma NON gestisce pagamenti o spedizioni: le transazioni avvengono direttamente tra venditore e acquirente\n- Si consiglia di utilizzare metodi di pagamento sicuri e tracciabili\n- La piattaforma non ha alcuna responsabilità sulle transazioni tra utenti',
  updated_at = now()
WHERE section_key = 'auctions';

-- Se la sezione non esiste ancora (primo inserimento), inseriscila
INSERT INTO rules_content (section_key, section_title, content_text, display_order, is_active)
SELECT
  'auctions',
  'Sistema Aste',
  E'## Come Funzionano le Aste\n\nLe aste su Trovafacile permettono a tutti gli utenti (privati e aziende) di vendere e acquistare oggetti attraverso un sistema di offerte competitive.\n\n### Creazione Asta\n- Ogni utente autenticato può creare un''asta\n- È necessario fornire: titolo, descrizione, immagini, base d''asta, categoria, condizioni e località\n- La durata dell''asta può essere da 1 a 14 giorni\n- Le aste richiedono l''approvazione dell''amministratore prima di diventare visibili\n\n### Ticket di Partecipazione\n- Per partecipare a un''asta è necessario acquistare un **ticket pari al 10% della base d''asta**\n- Esempio: base d''asta 200 € → ticket 20 €; base 500 € → ticket 50 €\n- Il ticket viene trattenuto dalla piattaforma se l''acquirente vincitore conferma l''affare\n- Se perdi l''asta, il ticket ti viene rimborsato\n- Se vinci ma **non confermi entro 48 ore**, il ticket viene **trattenuto** e l''asta passa al classificato successivo\n\n### Offerte — Regola Fondamentale\n- Le offerte sono **irrevocabili**: una volta inviata un''offerta, non è possibile ritirarla\n- Le offerte devono essere superiori all''offerta attuale (o alla base d''asta se non ci sono offerte)\n- Chi fa l''offerta più alta alla scadenza è il vincitore provvisorio\n\n### Conclusione Asta\n- L''asta termina automaticamente alla scadenza\n- Il vincitore (chi ha fatto l''offerta più alta) riceve una notifica e ha **48 ore** per confermare l''affare\n- Anche il venditore deve confermare entro le stesse 48 ore\n- La transazione si considera conclusa quando **entrambe le parti** premono il pulsante "Conferma Affare"\n\n### Scalabilità dei Vincitori\n- Se il vincitore **non conferma entro 48 ore**, perde il ticket e l''asta passa automaticamente al **secondo classificato**\n- Il secondo classificato riceve una notifica e ha a sua volta 48 ore per confermare\n- Questo meccanismo continua fino a che qualcuno conferma o non ci sono più partecipanti disponibili\n- In quest''ultimo caso l''asta si chiude definitivamente senza conclusione\n\n### Responsabilità\n- La piattaforma NON gestisce pagamenti o spedizioni: le transazioni avvengono direttamente tra venditore e acquirente\n- Si consiglia di utilizzare metodi di pagamento sicuri e tracciabili\n- La piattaforma non ha alcuna responsabilità sulle transazioni tra utenti',
  10,
  true
WHERE NOT EXISTS (
  SELECT 1 FROM rules_content WHERE section_key = 'auctions'
);

-- Aggiorna le FAQ esistenti sulle aste
UPDATE faqs SET answer = 'Tutti gli utenti autenticati possono partecipare alle aste, sia utenti privati che aziende. È necessario acquistare un ticket di partecipazione per poter fare offerte.', updated_at = now()
WHERE category = 'Aste' AND question ILIKE '%chi può partecipare%';

UPDATE faqs SET answer = 'Il ticket è pari al 10% della base d''asta. Ad esempio: base d''asta 100 € → ticket 10 €; base 500 € → ticket 50 €. Il ticket viene trattenuto dalla piattaforma se sei il vincitore e confermi l''affare. Se perdi, il ticket viene rimborsato.', updated_at = now()
WHERE category = 'Aste' AND question ILIKE '%quanto costa il deposito%';

UPDATE faqs SET answer = 'Se perdi l''asta il ticket viene rimborsato. Se vinci e confermi l''affare, il ticket resta alla piattaforma. Se vinci ma non confermi entro 48 ore, perdi il ticket e l''asta passa al secondo classificato.', updated_at = now()
WHERE category = 'Aste' AND question ILIKE '%quando viene restituito%';

UPDATE faqs SET answer = 'Dopo aver acquistato il ticket, puoi inserire l''importo della tua offerta. L''offerta deve essere superiore all''offerta attuale o alla base d''asta se non ci sono ancora offerte. Attenzione: le offerte sono irrevocabili, non è possibile ritirarle una volta inviate.', updated_at = now()
WHERE category = 'Aste' AND question ILIKE '%come faccio un''offerta%';

UPDATE faqs SET answer = 'Se vinci l''asta, ricevi una notifica e hai 48 ore per confermare l''affare premendo il pulsante "Conferma Affare" nella pagina dell''asta. Anche il venditore deve confermare. Se non confermi entro 48 ore, perdi il ticket e l''asta passa automaticamente al secondo classificato.', updated_at = now()
WHERE category = 'Aste' AND question ILIKE '%se vinco l''asta%';

UPDATE faqs SET answer = 'Dopo la chiusura dell''asta, sia venditore che acquirente devono premere il pulsante "Conferma Affare" nella pagina dell''asta. Avete 48 ore per farlo. La transazione si considera conclusa solo quando entrambi confermano.', updated_at = now()
WHERE category = 'Aste' AND question ILIKE '%come confermare%';

-- Elimina la FAQ obsoleta sul deposito fisso e aggiorna/aggiungi nuove FAQ
DELETE FROM faqs
WHERE category = 'Aste' AND question ILIKE '%deposito viene restituito automaticamente alla scadenza%';

-- Aggiunge le nuove FAQ se non esistono
INSERT INTO faqs (category, question, answer, display_order, is_active)
SELECT 'Aste', q, a, o, true
FROM (VALUES
  (
    'Posso ritirare la mia offerta?',
    'No, le offerte sono assolutamente irrevocabili. Una volta inviata un''offerta non è possibile ritirarla in nessun caso. Assicurati di essere certo prima di confermare.',
    10
  ),
  (
    'Cosa succede se il vincitore non conferma entro 48 ore?',
    'Se il vincitore non conferma l''affare entro 48 ore dalla chiusura dell''asta, perde il suo ticket (trattenuto dalla piattaforma) e l''asta passa automaticamente al secondo classificato, che riceve una notifica e ha a sua volta 48 ore per confermare.',
    11
  ),
  (
    'Come funziona il ticket di partecipazione?',
    'Il ticket è pari al 10% della base d''asta e viene pagato una volta per asta. Dà diritto a fare tutte le offerte che vuoi su quell''asta. Se non vinci, il ticket viene rimborsato. Se vinci e confermi l''affare, il ticket viene trattenuto dalla piattaforma.',
    12
  ),
  (
    'Cosa succede se nessun vincitore conferma?',
    'Se nessun partecipante conferma l''affare (tutti perdono il ticket passando al successivo), l''asta si chiude definitivamente senza conclusione. Il venditore riceve una notifica.',
    13
  )
) AS new_faqs(q, a, o)
WHERE NOT EXISTS (
  SELECT 1 FROM faqs WHERE category = 'Aste' AND question = new_faqs.q
);
