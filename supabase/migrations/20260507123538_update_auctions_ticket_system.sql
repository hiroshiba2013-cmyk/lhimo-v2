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
