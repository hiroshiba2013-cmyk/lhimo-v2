-- ============================================================
-- FILE: 20260506080949_add_auto_populate_job_posting_location_trigger.sql
-- ============================================================
/*
  # Auto-populate region/province/city on job_postings from linked location

  When a job posting is inserted or updated with a business_location_id or
  registered_business_location_id, automatically copy region/province/city
  from the linked location if they are not already set.
*/

CREATE OR REPLACE FUNCTION sync_job_posting_location()
RETURNS TRIGGER AS $$
BEGIN
  -- Try registered_business_locations first
  IF NEW.registered_business_location_id IS NOT NULL AND (NEW.region IS NULL OR NEW.region = '') THEN
    SELECT region, province, city
    INTO NEW.region, NEW.province, NEW.city
    FROM registered_business_locations
    WHERE id = NEW.registered_business_location_id;
  END IF;

  -- Try business_locations if still empty
  IF NEW.business_location_id IS NOT NULL AND (NEW.region IS NULL OR NEW.region = '') THEN
    SELECT region, province, city
    INTO NEW.region, NEW.province, NEW.city
    FROM business_locations
    WHERE id = NEW.business_location_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_job_posting_location ON job_postings;

CREATE TRIGGER trg_sync_job_posting_location
  BEFORE INSERT OR UPDATE ON job_postings
  FOR EACH ROW
  EXECUTE FUNCTION sync_job_posting_location();


-- ============================================================
-- FILE: 20260506091833_create_platform_messages_table.sql
-- ============================================================
/*
  # Crea tabella platform_messages

  ## Descrizione
  Tabella per i messaggi inviati dagli utenti tramite il form nella pagina Contatti.
  Gli admin possono visualizzare, rispondere e archiviare i messaggi.

  ## Tabella
  - `platform_messages`: messaggi di contatto dalla pagina pubblica
    - id, name, email, subject, message (dati del mittente)
    - user_id (opzionale, se l'utente è loggato)
    - status: 'unread' | 'read' | 'replied' | 'archived'
    - admin_reply: risposta dell'admin
    - replied_at, replied_by (user_id dell'admin)
    - created_at

  ## Sicurezza
  - Chiunque può inserire messaggi (form pubblico)
  - Solo gli admin possono leggere e aggiornare
*/

CREATE TABLE IF NOT EXISTS platform_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  subject text NOT NULL,
  message text NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  status text NOT NULL DEFAULT 'unread' CHECK (status IN ('unread', 'read', 'replied', 'archived')),
  admin_reply text,
  replied_at timestamptz,
  replied_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE platform_messages ENABLE ROW LEVEL SECURITY;

-- Chiunque può inserire un messaggio (form pubblico)
CREATE POLICY "Anyone can send a platform message"
  ON platform_messages FOR INSERT
  TO public
  WITH CHECK (true);

-- Solo admin possono leggere i messaggi
CREATE POLICY "Admins can read all platform messages"
  ON platform_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
  );

-- Solo admin possono aggiornare (rispondere, archiviare)
CREATE POLICY "Admins can update platform messages"
  ON platform_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
  );

CREATE INDEX IF NOT EXISTS idx_platform_messages_status ON platform_messages(status);
CREATE INDEX IF NOT EXISTS idx_platform_messages_created_at ON platform_messages(created_at DESC);


-- ============================================================
-- FILE: 20260507123538_update_auctions_ticket_system.sql
-- ============================================================
/*
  # Sistema Ticket Aste - Aggiornamento Completo

  ## Descrizione
  Sostituisce il sistema di deposito fisso (5€/10€) con un ticket pari al 10% della base d'asta.
  Aggiunge la logica di scalabilità vincitori: se il vincitore non conferma entro 48 ore, perde
  il ticket e l'asta passa automaticamente al secondo classificato (e così via).

  ## Modifiche alle tabelle

  ### auctions
  - Aggiunta colonna `winner_index` (int, default 0): indica quale vincitore corrente si sta gestendo
    (0 = primo classificato, 1 = secondo, ecc.)
  - Aggiunta colonna `current_completion_deadline` (timestamptz): scadenza attuale per il vincitore corrente

  ### auction_deposits → rinominato concettualmente a "ticket"
  - Modifica vincolo amount: rimuove CHECK (amount IN (5, 10)) perché ora è il 10% della base
  - Aggiunta colonna `forfeited` (boolean, default false): ticket perso per mancata conferma
  - Aggiunta colonna `forfeited_at` (timestamptz)

  ### auction_completions
  - Aggiunta colonna `winner_user_id` (uuid): chi è il vincitore corrente per questa completion
  - Aggiunta colonna `winner_family_member_id` (uuid): family member del vincitore corrente
  - Aggiunta colonna `attempt_number` (int): numero del tentativo (1 = primo vincitore, 2 = secondo, ecc.)

  ## Nuove funzioni
  - `calculate_auction_ticket_amount(base_price)`: calcola il 10% della base d'asta
  - `advance_to_next_winner(auction_id)`: se il vincitore corrente non ha confermato, scala al prossimo
  - `check_auction_completion_deadlines()`: job schedulabile che controlla le scadenze 48h

  ## Sicurezza
  - RLS aggiornata per i nuovi campi
  - Solo il sistema (SECURITY DEFINER) può fare forfeit di un ticket
*/

-- =============================================
-- 1. Aggiorna il calcolo del deposito/ticket
-- =============================================

-- Rimuovi il vecchio vincolo sull'importo del deposito
ALTER TABLE auction_deposits
  DROP CONSTRAINT IF EXISTS auction_deposits_amount_check;

-- Aggiungi colonne per il ticket system
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auction_deposits' AND column_name = 'forfeited'
  ) THEN
    ALTER TABLE auction_deposits ADD COLUMN forfeited boolean DEFAULT false;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auction_deposits' AND column_name = 'forfeited_at'
  ) THEN
    ALTER TABLE auction_deposits ADD COLUMN forfeited_at timestamptz;
  END IF;
END $$;

-- Aggiungi nuovo vincolo: importo deve essere > 0
ALTER TABLE auction_deposits
  ADD CONSTRAINT auction_deposits_amount_positive CHECK (amount > 0);

-- =============================================
-- 2. Aggiorna la tabella auctions
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'winner_index'
  ) THEN
    ALTER TABLE auctions ADD COLUMN winner_index integer DEFAULT 0;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'current_completion_deadline'
  ) THEN
    ALTER TABLE auctions ADD COLUMN current_completion_deadline timestamptz;
  END IF;
END $$;

-- =============================================
-- 3. Aggiorna la tabella auction_completions
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auction_completions' AND column_name = 'winner_user_id'
  ) THEN
    ALTER TABLE auction_completions ADD COLUMN winner_user_id uuid REFERENCES profiles(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auction_completions' AND column_name = 'winner_family_member_id_completion'
  ) THEN
    ALTER TABLE auction_completions ADD COLUMN winner_family_member_id_completion uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auction_completions' AND column_name = 'attempt_number'
  ) THEN
    ALTER TABLE auction_completions ADD COLUMN attempt_number integer DEFAULT 1;
  END IF;
END $$;

-- =============================================
-- 4. Aggiorna il trigger del deposito: 10% base_price
-- =============================================

CREATE OR REPLACE FUNCTION set_auction_deposit_amount()
RETURNS TRIGGER AS $$
BEGIN
  -- Il ticket è il 10% della base d'asta, arrotondato a 2 decimali
  NEW.deposit_amount := ROUND(NEW.base_price * 0.10, 2);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- 5. Funzione per avanzare al prossimo vincitore
-- =============================================

CREATE OR REPLACE FUNCTION advance_to_next_winner(p_auction_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction record;
  v_current_winner_index integer;
  v_next_bid record;
  v_new_completion_id uuid;
BEGIN
  -- Carica l'asta
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Asta non trovata');
  END IF;

  v_current_winner_index := COALESCE(v_auction.winner_index, 0);

  -- Marca il ticket del vincitore corrente come perso (forfeited)
  UPDATE auction_deposits
  SET
    forfeited = true,
    forfeited_at = now()
  WHERE
    auction_id = p_auction_id
    AND user_id = v_auction.winner_id
    AND forfeited = false
    AND refunded = false;

  -- Trova il prossimo bidder (per importo decrescente, escludendo chi ha già perso il ticket)
  SELECT
    ab.user_id,
    ab.family_member_id,
    ab.bid_amount,
    p.nickname,
    p.full_name
  INTO v_next_bid
  FROM auction_bids ab
  JOIN profiles p ON p.id = ab.user_id
  WHERE ab.auction_id = p_auction_id
    AND ab.user_id != v_auction.winner_id
    AND ab.user_id NOT IN (
      SELECT user_id FROM auction_deposits
      WHERE auction_id = p_auction_id AND forfeited = true
    )
  ORDER BY ab.bid_amount DESC, ab.created_at ASC
  LIMIT 1;

  IF NOT FOUND THEN
    -- Nessun altro bidder disponibile: asta terminata senza conclusione
    UPDATE auctions
    SET status = 'expired', updated_at = now()
    WHERE id = p_auction_id;

    -- Notifica il venditore
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    SELECT
      a.user_id,
      a.family_member_id,
      'auction_concluded',
      'Asta Terminata Senza Conclusione',
      'Nessun acquirente ha confermato l''affare per la tua asta "' || a.title || '". L''asta è stata chiusa.',
      json_build_object('auction_id', p_auction_id)
    FROM auctions a WHERE a.id = p_auction_id;

    RETURN json_build_object('success', true, 'status', 'no_more_bidders');
  END IF;

  -- Aggiorna l'asta con il nuovo vincitore
  UPDATE auctions
  SET
    winner_id = v_next_bid.user_id,
    winner_family_member_id = v_next_bid.family_member_id,
    winner_index = v_current_winner_index + 1,
    current_completion_deadline = now() + interval '48 hours',
    status = 'completed',
    updated_at = now()
  WHERE id = p_auction_id;

  -- Chiudi la vecchia completion e crea la nuova
  UPDATE auction_completions
  SET buyer_confirmed = false, seller_confirmed = false
  WHERE auction_id = p_auction_id;

  DELETE FROM auction_completions WHERE auction_id = p_auction_id;

  INSERT INTO auction_completions (
    auction_id,
    winner_user_id,
    winner_family_member_id_completion,
    completion_deadline,
    attempt_number
  ) VALUES (
    p_auction_id,
    v_next_bid.user_id,
    v_next_bid.family_member_id,
    now() + interval '48 hours',
    v_current_winner_index + 2
  );

  -- Notifica il nuovo vincitore
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_next_bid.user_id,
    v_next_bid.family_member_id,
    'auction_won',
    'Sei il Nuovo Vincitore!',
    'Il vincitore precedente non ha confermato l''affare. Ora sei il vincitore dell''asta "' ||
      v_auction.title || '" con un''offerta di ' || v_next_bid.bid_amount || ' EUR. Hai 48 ore per confermare.',
    json_build_object('auction_id', p_auction_id, 'bid_amount', v_next_bid.bid_amount)
  );

  -- Notifica il venditore del cambio vincitore
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  SELECT
    a.user_id,
    a.family_member_id,
    'auction_concluded',
    'Nuovo Acquirente per la Tua Asta',
    'Il vincitore precedente non ha confermato. Il nuovo acquirente è ' ||
      COALESCE(v_next_bid.nickname, v_next_bid.full_name) ||
      ' per la tua asta "' || a.title || '". Hai 48 ore per confermare.',
    json_build_object('auction_id', p_auction_id)
  FROM auctions a WHERE a.id = p_auction_id;

  RETURN json_build_object('success', true, 'status', 'advanced', 'new_winner_id', v_next_bid.user_id);
END;
$$;

-- =============================================
-- 6. Funzione per controllare scadenze 48h
-- =============================================

CREATE OR REPLACE FUNCTION check_auction_completion_deadlines()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_completion record;
BEGIN
  -- Trova completions scadute dove l'acquirente non ha confermato
  FOR v_completion IN
    SELECT ac.*, a.user_id AS seller_id, a.winner_id, a.title, a.family_member_id AS seller_family_member_id
    FROM auction_completions ac
    JOIN auctions a ON a.id = ac.auction_id
    WHERE ac.completion_deadline < now()
      AND ac.buyer_confirmed = false
      AND a.status = 'completed'
  LOOP
    -- Avanza al prossimo vincitore
    PERFORM advance_to_next_winner(v_completion.auction_id);
  END LOOP;
END;
$$;

-- =============================================
-- 7. Funzione per conferma conclusione asta (usata dal frontend)
-- =============================================

CREATE OR REPLACE FUNCTION confirm_auction_deal(
  p_auction_id uuid,
  p_user_id uuid,
  p_is_seller boolean
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction record;
  v_completion record;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Asta non trovata');
  END IF;

  SELECT * INTO v_completion FROM auction_completions WHERE auction_id = p_auction_id;
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Nessuna completion attiva per questa asta');
  END IF;

  -- Verifica che l'utente sia il venditore o il vincitore corrente
  IF p_is_seller THEN
    IF v_auction.user_id != p_user_id THEN
      RETURN json_build_object('success', false, 'error', 'Non sei il venditore di questa asta');
    END IF;
    UPDATE auction_completions
    SET seller_confirmed = true, seller_confirmed_at = now()
    WHERE auction_id = p_auction_id;
  ELSE
    IF v_auction.winner_id != p_user_id THEN
      RETURN json_build_object('success', false, 'error', 'Non sei il vincitore corrente di questa asta');
    END IF;
    UPDATE auction_completions
    SET buyer_confirmed = true, buyer_confirmed_at = now()
    WHERE auction_id = p_auction_id;
  END IF;

  -- Ricarica la completion aggiornata
  SELECT * INTO v_completion FROM auction_completions WHERE auction_id = p_auction_id;

  -- Se entrambi hanno confermato, rimborsa i ticket ai perdenti e chiudi definitivamente
  IF v_completion.seller_confirmed AND v_completion.buyer_confirmed THEN
    -- Rimborsa tutti i ticket tranne il vincitore (il suo ticket va alla piattaforma)
    -- I perdenti vengono rimborsati
    UPDATE auction_deposits
    SET refunded = true, refunded_at = now()
    WHERE auction_id = p_auction_id
      AND user_id != v_auction.winner_id
      AND refunded = false
      AND forfeited = false;

    -- Notifica entrambi
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES
      (v_auction.user_id, 'auction_concluded', 'Affare Confermato!',
       'L''affare per l''asta "' || v_auction.title || '" è stato confermato da entrambe le parti.',
       json_build_object('auction_id', p_auction_id)),
      (v_auction.winner_id, 'auction_won', 'Affare Confermato!',
       'L''affare per l''asta "' || v_auction.title || '" è stato confermato. Buona fortuna!',
       json_build_object('auction_id', p_auction_id));

    RETURN json_build_object('success', true, 'status', 'fully_confirmed');
  END IF;

  RETURN json_build_object('success', true, 'status', 'partial_confirmed');
END;
$$;

-- =============================================
-- 8. Policy: acquirente vincitore può vedere la propria completion
-- =============================================

DROP POLICY IF EXISTS "Auction participants can view completions" ON auction_completions;
CREATE POLICY "Auction participants can view completions"
  ON auction_completions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (
        auctions.user_id = auth.uid()
        OR auctions.winner_id = auth.uid()
        OR winner_user_id = auth.uid()
      )
    )
  );

-- =============================================
-- 9. Indici aggiuntivi
-- =============================================

CREATE INDEX IF NOT EXISTS idx_auction_deposits_forfeited ON auction_deposits(auction_id, forfeited);
CREATE INDEX IF NOT EXISTS idx_auctions_winner_index ON auctions(id, winner_index);
CREATE INDEX IF NOT EXISTS idx_auction_completions_deadline ON auction_completions(completion_deadline, buyer_confirmed);


-- ============================================================
-- FILE: 20260507124250_update_auction_rules_and_faqs_ticket_system.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260507153039_add_approval_system_job_seekers.sql
-- ============================================================
/*
  # Add Approval System to Job Seekers

  ## Summary
  Adds the same approval workflow used by job_postings, classified_ads, and auctions
  to the job_seekers table, so "Cerco Lavoro" ads require admin approval before
  being visible to other users.

  ## Changes
  - `job_seekers` table: adds `approval_status` (pending/approved/rejected),
    `approved_by`, `approved_at`, `approval_notes` columns
  - Default for new rows is 'pending'
  - New RPC functions: `approve_job_seeker`, `reject_job_seeker`
  - Notification sent to user on approval/rejection
*/

-- Add approval columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE job_seekers
      ADD COLUMN approval_status text NOT NULL DEFAULT 'pending'
        CHECK (approval_status IN ('pending', 'approved', 'rejected')),
      ADD COLUMN approved_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
      ADD COLUMN approved_at timestamptz,
      ADD COLUMN approval_notes text;
  END IF;
END $$;

-- Approve function
CREATE OR REPLACE FUNCTION approve_job_seeker(
  p_seeker_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid;
BEGIN
  SELECT user_id INTO v_user_id FROM job_seekers WHERE id = p_seeker_id;

  UPDATE job_seekers
  SET
    approval_status = 'approved',
    approved_by = p_admin_id,
    approved_at = now(),
    status = 'active'
  WHERE id = p_seeker_id;

  -- Notify the owner
  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, related_id)
    VALUES (
      v_user_id,
      'job_seeker_approved',
      'Annuncio approvato',
      'Il tuo annuncio "Cerco Lavoro" è stato approvato ed è ora visibile.',
      p_seeker_id
    );
  END IF;
END;
$$;

-- Reject function
CREATE OR REPLACE FUNCTION reject_job_seeker(
  p_seeker_id uuid,
  p_admin_id uuid,
  p_reason text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid;
  v_title text;
BEGIN
  SELECT user_id, title INTO v_user_id, v_title FROM job_seekers WHERE id = p_seeker_id;

  UPDATE job_seekers
  SET
    approval_status = 'rejected',
    approved_by = p_admin_id,
    approved_at = now(),
    approval_notes = p_reason,
    status = 'closed'
  WHERE id = p_seeker_id;

  -- Notify the owner
  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, related_id)
    VALUES (
      v_user_id,
      'job_seeker_rejected',
      'Annuncio non approvato',
      CASE
        WHEN p_reason IS NOT NULL AND p_reason != ''
        THEN 'Il tuo annuncio "Cerco Lavoro" non è stato approvato. Motivo: ' || p_reason
        ELSE 'Il tuo annuncio "Cerco Lavoro" non è stato approvato.'
      END,
      p_seeker_id
    );
  END IF;
END;
$$;


