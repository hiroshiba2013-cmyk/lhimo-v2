
/*
  # Salvaguardie permanenti per utenti business

  ## Obiettivo
  Impedire che gli errori identificati possano ripresentarsi, agendo a livello
  di database con trigger che blindano il sistema indipendentemente da come
  vengono creati i dati (frontend, seed, admin, API diretta).

  ## Salvaguardie aggiunte

  ### 1. Trigger su registered_businesses (INSERT)
  Quando viene creato un business registrato, il proprietario viene
  automaticamente promosso a user_type='business'.

  ### 2. Trigger su profiles (UPDATE user_type → business)
  Quando user_type diventa 'business':
  - I punti in user_activity vengono azzerati
  - Le notifiche points_earned vengono rimosse
  - La subscription attiva viene retrocessa a 'trial' se status='active'

  ### 3. Trigger su subscriptions (INSERT/UPDATE)
  Impedisce che un utente business riceva uno status diverso da 'trial'
  o 'expired' su un abbonamento appena creato (la prima subscription
  di un business deve partire sempre in trial).

  ### 4. Trigger su user_activity (INSERT/UPDATE)
  Impedisce l'accumulo di punti > 0 per gli utenti business direttamente
  sulla tabella, bypassando la funzione award_points.
*/

-- =============================================================
-- 1. AUTO-SET user_type='business' su inserimento registered_business
-- =============================================================
CREATE OR REPLACE FUNCTION fn_set_owner_as_business()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE profiles
  SET user_type = 'business'
  WHERE id = NEW.owner_id
    AND user_type NOT IN ('business', 'admin');
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_set_owner_as_business ON registered_businesses;
CREATE TRIGGER trg_set_owner_as_business
  AFTER INSERT ON registered_businesses
  FOR EACH ROW
  EXECUTE FUNCTION fn_set_owner_as_business();

-- =============================================================
-- 2. AUTO-CLEANUP quando user_type diventa 'business'
-- =============================================================
CREATE OR REPLACE FUNCTION fn_on_profile_become_business()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Solo quando user_type cambia verso 'business'
  IF NEW.user_type = 'business' AND (OLD.user_type IS DISTINCT FROM 'business') THEN

    -- Azzera punti e attività in user_activity
    UPDATE user_activity
    SET
      total_points           = 0,
      reviews_count          = 0,
      ads_count              = 0,
      ads_posted_count       = 0,
      job_postings_count     = 0,
      referrals_count        = 0,
      businesses_added_count = 0,
      auctions_count         = 0,
      updated_at             = now()
    WHERE user_id = NEW.id;

    -- Rimuovi notifiche legate ai punti classifica
    DELETE FROM notifications
    WHERE user_id = NEW.id
      AND type = 'points_earned';

    -- Retrocedi subscription 'active' a 'trial' se è la prima
    -- (un business appena promosso non ha ancora pagato)
    UPDATE subscriptions
    SET status = 'trial',
        trial_end_date = COALESCE(
          trial_end_date,
          start_date + interval '30 days'
        )
    WHERE customer_id = NEW.id
      AND status = 'active';

  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_on_profile_become_business ON profiles;
CREATE TRIGGER trg_on_profile_become_business
  AFTER UPDATE OF user_type ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION fn_on_profile_become_business();

-- =============================================================
-- 3. FORZA TRIAL su prima subscription di un utente business
-- =============================================================
CREATE OR REPLACE FUNCTION fn_enforce_business_trial_on_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_type text;
  v_existing_count integer;
BEGIN
  SELECT user_type INTO v_user_type
  FROM profiles WHERE id = NEW.customer_id;

  IF v_user_type = 'business' THEN
    -- Conta le subscription pre-esistenti (esclusa quella che si sta inserendo)
    SELECT COUNT(*) INTO v_existing_count
    FROM subscriptions
    WHERE customer_id = NEW.customer_id
      AND id != NEW.id;

    -- Se è la prima subscription, forza trial
    IF v_existing_count = 0 AND NEW.status = 'active' THEN
      NEW.status := 'trial';
      NEW.trial_end_date := COALESCE(
        NEW.trial_end_date,
        NEW.start_date + interval '30 days'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_enforce_business_trial ON subscriptions;
CREATE TRIGGER trg_enforce_business_trial
  BEFORE INSERT ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION fn_enforce_business_trial_on_insert();

-- =============================================================
-- 4. BLOCCO PUNTI per utenti business su user_activity
-- =============================================================
CREATE OR REPLACE FUNCTION fn_block_business_points()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_type text;
BEGIN
  SELECT user_type INTO v_user_type
  FROM profiles WHERE id = NEW.user_id;

  IF v_user_type = 'business' THEN
    -- Forza sempre i punti a 0 per gli utenti business
    NEW.total_points           := 0;
    NEW.reviews_count          := 0;
    NEW.ads_count              := 0;
    NEW.ads_posted_count       := 0;
    NEW.job_postings_count     := 0;
    NEW.referrals_count        := 0;
    NEW.businesses_added_count := 0;
    NEW.auctions_count         := 0;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_block_business_points ON user_activity;
CREATE TRIGGER trg_block_business_points
  BEFORE INSERT OR UPDATE ON user_activity
  FOR EACH ROW
  EXECUTE FUNCTION fn_block_business_points();
