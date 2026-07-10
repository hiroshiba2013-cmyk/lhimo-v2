/*
  # Add Auction Rules and FAQs

  1. New Data
    - Add auction rules section
    - Add auction FAQs

  2. Content
    - How auctions work
    - Deposit system
    - Completion confirmation
    - User responsibilities
*/

-- Add auction rules section
INSERT INTO rules_content (section_key, section_title, content_text, display_order, is_active)
VALUES
  ('auctions', 'Sistema Aste', E'## Come Funzionano le Aste\n\nLe aste su Trovafacile permettono a tutti gli utenti (privati e aziende) di vendere e acquistare oggetti attraverso un sistema di offerte competitive.\n\n### Creazione Asta\n- Ogni utente autenticato può creare un''asta\n- È necessario fornire: titolo, descrizione, immagini, base d''asta, categoria, condizioni e località\n- La durata dell''asta può essere da 1 a 14 giorni\n- Il sistema calcola automaticamente il deposito richiesto (5€ per basi d''asta fino a 500€, 10€ oltre)\n\n### Partecipazione\n- Per partecipare a un''asta è necessario pagare un deposito\n- Il deposito viene restituito automaticamente alla fine dell''asta\n- Le offerte devono essere superiori all''offerta attuale o alla base d''asta\n- L''offerta più alta viene evidenziata in grassetto\n\n### Conclusione Asta\n- L''asta termina automaticamente alla scadenza\n- Il vincitore è chi ha fatto l''offerta più alta\n- Venditore e acquirente hanno 48 ore per confermare la transazione\n- La transazione si considera conclusa quando entrambi confermano\n\n### Responsabilità\n- La piattaforma NON gestisce pagamenti o spedizioni\n- Le transazioni avvengono direttamente tra venditore e acquirente\n- La piattaforma non ha alcuna responsabilità sulla transazione\n- Si consiglia di utilizzare metodi di pagamento sicuri e tracciabili', 10, true);

-- Add auction FAQs
INSERT INTO faqs (category, question, answer, display_order, is_active)
VALUES
  ('Aste', 'Chi può partecipare alle aste?', 'Tutti gli utenti autenticati possono partecipare alle aste, sia utenti privati che aziende. È necessario pagare un deposito per poter fare offerte.', 1, true),
  ('Aste', 'Quanto costa il deposito per partecipare?', 'Il deposito è di 5€ per aste con base fino a 500€, e 10€ per aste con base superiore a 500€. Il deposito viene restituito automaticamente alla fine dell''asta.', 2, true),
  ('Aste', 'Quando viene restituito il deposito?', 'Il deposito viene restituito automaticamente alla scadenza dell''asta, sia che tu vinca sia che perda.', 3, true),
  ('Aste', 'Come faccio un''offerta?', 'Dopo aver pagato il deposito, puoi inserire l''importo della tua offerta. L''offerta deve essere superiore all''offerta attuale o alla base d''asta se non ci sono ancora offerte.', 4, true),
  ('Aste', 'Cosa succede se vinco l''asta?', 'Se vinci l''asta, hai 48 ore di tempo per completare la transazione con il venditore. Dovrai contattare il venditore per accordarvi su pagamento e consegna.', 5, true),
  ('Aste', 'La piattaforma gestisce i pagamenti?', 'No, la piattaforma NON gestisce pagamenti o spedizioni. Le transazioni avvengono direttamente tra venditore e acquirente. La piattaforma non ha alcuna responsabilità sulla transazione.', 6, true),
  ('Aste', 'Come confermare la conclusione della transazione?', 'Dopo la chiusura dell''asta, sia venditore che acquirente devono confermare che la transazione è stata completata (oggetto ricevuto e pagamento effettuato). Avete 48 ore per confermare.', 7, true),
  ('Aste', 'Posso annullare un''asta?', 'Puoi eliminare un''asta solo se non ci sono ancora offerte. Una volta che qualcuno ha fatto un''offerta, l''asta non può più essere annullata.', 8, true),
  ('Aste', 'Posso creare aste come azienda?', 'Sì, anche le aziende possono creare e partecipare alle aste. Il sistema è aperto a tutti gli utenti autenticati.', 9, true);