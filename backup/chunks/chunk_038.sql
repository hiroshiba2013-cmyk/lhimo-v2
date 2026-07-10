-- ============================================================
-- FILE: 20260306095535_create_trial_prevention_system.sql
-- ============================================================
/*
  # Sistema di Prevenzione Abuso Trial

  ## Scopo
  Previene che gli utenti possano usufruire più volte del periodo di prova gratuito
  cambiando email o creando nuovi account. Il sistema traccia i codici fiscali di:
  - Titolare dell'account (profiles.fiscal_code)
  - Tutti i membri della famiglia (customer_family_members.tax_code)

  ## 1. Nuove Tabelle

  ### `trial_usage_history`
  Traccia tutti i codici fiscali che hanno già usufruito del trial:
  - `id` (uuid, primary key)
  - `fiscal_code` (text, unique, not null) - Codice fiscale già utilizzato
  - `first_user_id` (uuid) - Primo utente che ha usato questo CF per il trial
  - `first_trial_date` (timestamptz) - Data del primo trial
  - `attempts_blocked` (integer) - Numero di tentativi bloccati
  - `last_attempt_date` (timestamptz) - Data ultimo tentativo bloccato
  - `created_at` (timestamptz)

  ## 2. Funzioni

  ### `check_trial_eligibility(user_id uuid)`
  Controlla se un utente è idoneo per il trial verificando:
  - Il codice fiscale del titolare non sia stato già usato
  - Nessun codice fiscale dei membri della famiglia sia stato già usato
  - Restituisce: { eligible: boolean, reason: text }

  ### `register_trial_usage(user_id uuid)`
  Registra l'uso del trial salvando:
  - Il codice fiscale del titolare
  - Tutti i codici fiscali dei membri della famiglia (se presenti)

  ## 3. Triggers

  ### `prevent_trial_abuse_trigger`
  - Si attiva BEFORE INSERT su subscriptions quando status = 'trial'
  - Blocca la creazione se l'utente non è idoneo
  - Incrementa il contatore attempts_blocked

  ## 4. Security
  - RLS abilitato su trial_usage_history
  - Solo gli admin possono vedere i dati (per privacy GDPR)
  - Gli utenti NON possono vedere chi ha già usato il trial

  ## Note Importanti
  - Il sistema è retroattivo: utenti esistenti con trial attivo vengono registrati
  - GDPR compliant: tracciamo solo CF, non altri dati personali
  - Il titolare deve inserire il proprio CF per attivare il trial
  - I membri della famiglia possono avere CF, ma è opzionale
*/

-- 1. Crea la tabella per tracciare l'uso dei trial
CREATE TABLE IF NOT EXISTS trial_usage_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fiscal_code text UNIQUE NOT NULL,
  first_user_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  first_trial_date timestamptz NOT NULL DEFAULT now(),
  attempts_blocked integer DEFAULT 0,
  last_attempt_date timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Abilita RLS (solo admin possono vedere per privacy)
ALTER TABLE trial_usage_history ENABLE ROW LEVEL SECURITY;

-- Indici per performance
CREATE INDEX IF NOT EXISTS idx_trial_usage_fiscal_code ON trial_usage_history(fiscal_code);
CREATE INDEX IF NOT EXISTS idx_trial_usage_first_user ON trial_usage_history(first_user_id);

-- Policy: solo admin possono vedere (GDPR compliant)
CREATE POLICY "Only admins can view trial history"
  ON trial_usage_history
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins WHERE user_id = auth.uid()
    )
  );

-- 2. Funzione per controllare l'idoneità al trial
CREATE OR REPLACE FUNCTION check_trial_eligibility(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_fiscal_code text;
  v_family_fiscal_codes text[];
  v_blocked_cf text;
  v_result jsonb;
BEGIN
  -- Ottieni il codice fiscale del titolare
  SELECT fiscal_code INTO v_fiscal_code
  FROM profiles
  WHERE id = p_user_id;

  -- Se non ha codice fiscale, non può attivare il trial
  IF v_fiscal_code IS NULL OR v_fiscal_code = '' THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'reason', 'fiscal_code_required',
      'message', 'Il codice fiscale è obbligatorio per attivare il periodo di prova'
    );
  END IF;

  -- Controlla se il CF del titolare è già stato usato
  SELECT fiscal_code INTO v_blocked_cf
  FROM trial_usage_history
  WHERE fiscal_code = v_fiscal_code;

  IF v_blocked_cf IS NOT NULL THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'reason', 'trial_already_used',
      'message', 'Questo codice fiscale ha già usufruito del periodo di prova'
    );
  END IF;

  -- Ottieni tutti i CF dei membri della famiglia
  SELECT array_agg(tax_code)
  INTO v_family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = p_user_id
    AND tax_code IS NOT NULL
    AND tax_code != '';

  -- Controlla se qualche CF della famiglia è già stato usato
  IF v_family_fiscal_codes IS NOT NULL THEN
    SELECT fiscal_code INTO v_blocked_cf
    FROM trial_usage_history
    WHERE fiscal_code = ANY(v_family_fiscal_codes)
    LIMIT 1;

    IF v_blocked_cf IS NOT NULL THEN
      RETURN jsonb_build_object(
        'eligible', false,
        'reason', 'family_member_trial_used',
        'message', 'Un membro della famiglia ha già usufruito del periodo di prova'
      );
    END IF;
  END IF;

  -- Tutto ok, l'utente è idoneo
  RETURN jsonb_build_object(
    'eligible', true,
    'reason', 'eligible',
    'message', 'Idoneo al periodo di prova'
  );
END;
$$;

-- 3. Funzione per registrare l'uso del trial
CREATE OR REPLACE FUNCTION register_trial_usage(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_fiscal_code text;
  v_family_member record;
BEGIN
  -- Registra il CF del titolare
  SELECT fiscal_code INTO v_fiscal_code
  FROM profiles
  WHERE id = p_user_id;

  IF v_fiscal_code IS NOT NULL AND v_fiscal_code != '' THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_fiscal_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  -- Registra i CF di tutti i membri della famiglia
  FOR v_family_member IN
    SELECT tax_code
    FROM customer_family_members
    WHERE customer_id = p_user_id
      AND tax_code IS NOT NULL
      AND tax_code != ''
  LOOP
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_family_member.tax_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END LOOP;
END;
$$;

-- 4. Funzione trigger per prevenire abusi
CREATE OR REPLACE FUNCTION prevent_trial_abuse()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_eligibility jsonb;
  v_fiscal_code text;
  v_family_fiscal_codes text[];
BEGIN
  -- Controlla solo per i trial
  IF NEW.status != 'trial' THEN
    RETURN NEW;
  END IF;

  -- Verifica l'idoneità
  v_eligibility := check_trial_eligibility(NEW.customer_id);

  -- Se non idoneo, blocca e incrementa il contatore
  IF NOT (v_eligibility->>'eligible')::boolean THEN
    -- Ottieni CF per incrementare attempts_blocked
    SELECT fiscal_code INTO v_fiscal_code
    FROM profiles
    WHERE id = NEW.customer_id;

    -- Incrementa tentativi bloccati
    IF v_fiscal_code IS NOT NULL THEN
      UPDATE trial_usage_history
      SET
        attempts_blocked = attempts_blocked + 1,
        last_attempt_date = now()
      WHERE fiscal_code = v_fiscal_code;
    END IF;

    -- Controlla anche i CF della famiglia
    SELECT array_agg(tax_code)
    INTO v_family_fiscal_codes
    FROM customer_family_members
    WHERE customer_id = NEW.customer_id
      AND tax_code IS NOT NULL;

    IF v_family_fiscal_codes IS NOT NULL THEN
      UPDATE trial_usage_history
      SET
        attempts_blocked = attempts_blocked + 1,
        last_attempt_date = now()
      WHERE fiscal_code = ANY(v_family_fiscal_codes);
    END IF;

    -- Blocca l'inserimento
    RAISE EXCEPTION 'Trial non disponibile: %', v_eligibility->>'message'
      USING ERRCODE = '23514';
  END IF;

  -- Se idoneo, registra l'uso del trial
  PERFORM register_trial_usage(NEW.customer_id);

  RETURN NEW;
END;
$$;

-- 5. Crea il trigger su subscriptions
DROP TRIGGER IF EXISTS trigger_prevent_trial_abuse ON subscriptions;

CREATE TRIGGER trigger_prevent_trial_abuse
  BEFORE INSERT ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION prevent_trial_abuse();

-- 6. Registra retroattivamente i trial esistenti
DO $$
DECLARE
  v_user record;
BEGIN
  FOR v_user IN
    SELECT DISTINCT s.customer_id
    FROM subscriptions s
    WHERE s.status = 'trial'
      AND s.end_date > now()
  LOOP
    BEGIN
      PERFORM register_trial_usage(v_user.customer_id);
    EXCEPTION WHEN OTHERS THEN
      CONTINUE;
    END;
  END LOOP;
END $$;

-- Grant permessi
GRANT EXECUTE ON FUNCTION check_trial_eligibility(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION register_trial_usage(uuid) TO authenticated;

-- Commento per documentazione
COMMENT ON TABLE trial_usage_history IS 'Traccia i codici fiscali che hanno già usato il trial per prevenire abusi';
COMMENT ON FUNCTION check_trial_eligibility(uuid) IS 'Verifica se un utente può attivare il periodo di prova controllando CF titolare e famiglia';
COMMENT ON FUNCTION register_trial_usage(uuid) IS 'Registra CF del titolare e famiglia quando attivano un trial';


-- ============================================================
-- FILE: 20260306095602_update_trial_triggers_with_prevention.sql
-- ============================================================
/*
  # Aggiorna Trigger Trial con Sistema di Prevenzione

  ## Modifiche
  
  1. Aggiorna `create_trial_for_business_profile()` 
     - Controlla l'idoneità prima di creare il trial
     - Registra i CF se idoneo
     - Mostra messaggio chiaro se non idoneo
  
  2. Aggiorna `create_trial_for_customer()`
     - Stesso controllo di idoneità
     - Registra i CF se idoneo
  
  3. Rende obbligatorio il codice fiscale per attivare il trial
  
  ## Note
  - Il trigger su subscriptions già blocca i trial non autorizzati
  - Questi aggiornamenti migliorano l'esperienza utente mostrando l'errore prima
*/

-- 1. Aggiorna funzione trial per business
CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_plan_id uuid;
  v_trial_end timestamptz;
  v_eligibility jsonb;
BEGIN
  -- Solo per profili business
  IF NEW.user_type != 'business' THEN
    RETURN NEW;
  END IF;

  -- Controlla idoneità al trial
  v_eligibility := check_trial_eligibility(NEW.id);
  
  -- Se non idoneo, registra ma non blocca (il trigger su subscriptions lo farà)
  IF NOT (v_eligibility->>'eligible')::boolean THEN
    -- Log l'errore ma non bloccare la registrazione
    RAISE WARNING 'Utente non idoneo al trial: %', v_eligibility->>'message';
    RETURN NEW;
  END IF;

  BEGIN
    -- Calcola fine trial (30 giorni)
    v_trial_end := now() + interval '30 days';

    -- Aggiorna profilo con status trial
    UPDATE profiles
    SET
      subscription_status = 'trial',
      trial_end_date = v_trial_end,
      updated_at = now(),
      subscription_expires_at = v_trial_end
    WHERE id = NEW.id;

    -- Trova piano base business
    SELECT id INTO v_plan_id
    FROM subscription_plans
    WHERE plan_type = 'business'
      AND name = 'Base'
    LIMIT 1;

    -- Crea subscription trial (il trigger prevent_trial_abuse registrerà i CF)
    IF v_plan_id IS NOT NULL THEN
      INSERT INTO subscriptions (
        customer_id,
        plan_id,
        status,
        start_date,
        end_date,
        trial_end_date,
        payment_method_added,
        reminder_sent
      ) VALUES (
        NEW.id,
        v_plan_id,
        'trial',
        now(),
        v_trial_end,
        v_trial_end,
        false,
        false
      );
    END IF;

  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Errore creazione trial: %', SQLERRM;
  END;

  RETURN NEW;
END;
$$;

-- 2. Aggiorna funzione trial per customer
CREATE OR REPLACE FUNCTION create_trial_for_customer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_plan_id uuid;
  v_trial_end timestamptz;
  v_eligibility jsonb;
BEGIN
  -- Solo per profili customer
  IF NEW.user_type != 'customer' THEN
    RETURN NEW;
  END IF;

  -- Controlla idoneità al trial
  v_eligibility := check_trial_eligibility(NEW.id);
  
  -- Se non idoneo, registra ma non blocca
  IF NOT (v_eligibility->>'eligible')::boolean THEN
    RAISE WARNING 'Utente non idoneo al trial: %', v_eligibility->>'message';
    RETURN NEW;
  END IF;

  BEGIN
    -- Calcola fine trial (30 giorni)
    v_trial_end := now() + interval '30 days';

    -- Aggiorna profilo
    UPDATE profiles
    SET
      subscription_status = 'trial',
      trial_end_date = v_trial_end,
      subscription_expires_at = v_trial_end,
      updated_at = now()
    WHERE id = NEW.id;

    -- Trova piano base customer (1 persona)
    SELECT id INTO v_plan_id
    FROM subscription_plans
    WHERE plan_type = 'customer'
      AND max_persons = 1
    ORDER BY price ASC
    LIMIT 1;

    -- Crea subscription trial
    IF v_plan_id IS NOT NULL THEN
      INSERT INTO subscriptions (
        customer_id,
        plan_id,
        status,
        start_date,
        end_date,
        trial_end_date,
        payment_method_added,
        reminder_sent
      ) VALUES (
        NEW.id,
        v_plan_id,
        'trial',
        now(),
        v_trial_end,
        v_trial_end,
        false,
        false
      );
    END IF;

  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Errore creazione trial customer: %', SQLERRM;
  END;

  RETURN NEW;
END;
$$;

-- 3. Aggiorna trigger anche quando si aggiunge un membro della famiglia
-- Se si aggiunge un membro con CF già usato, blocca
CREATE OR REPLACE FUNCTION check_family_member_trial_eligibility()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_blocked_cf text;
BEGIN
  -- Controlla solo se il CF è fornito
  IF NEW.tax_code IS NULL OR NEW.tax_code = '' THEN
    RETURN NEW;
  END IF;

  -- Controlla se questo CF ha già usato il trial
  SELECT fiscal_code INTO v_blocked_cf
  FROM trial_usage_history
  WHERE fiscal_code = NEW.tax_code;

  IF v_blocked_cf IS NOT NULL THEN
    RAISE EXCEPTION 'Il codice fiscale % ha già usufruito del periodo di prova', NEW.tax_code
      USING ERRCODE = '23514';
  END IF;

  -- Registra il CF del nuovo membro se l'account è in trial
  IF EXISTS (
    SELECT 1 FROM profiles
    WHERE id = NEW.customer_id
      AND subscription_status = 'trial'
  ) THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (NEW.tax_code, NEW.customer_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

-- Crea trigger per controllo membri famiglia
DROP TRIGGER IF EXISTS trigger_check_family_trial_eligibility ON customer_family_members;

CREATE TRIGGER trigger_check_family_trial_eligibility
  BEFORE INSERT OR UPDATE OF tax_code ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION check_family_member_trial_eligibility();

-- Grant permessi
GRANT EXECUTE ON FUNCTION check_family_member_trial_eligibility() TO authenticated;


-- ============================================================
-- FILE: 20260306095629_add_trial_check_frontend_functions.sql
-- ============================================================
/*
  # Funzioni Frontend per Controllo Trial

  ## Nuove Funzioni
  
  ### `check_fiscal_code_trial_eligibility(fiscal_code text)`
  Permette al frontend di controllare se un codice fiscale è idoneo
  prima della registrazione. Utile per mostrare messaggi immediati.
  
  - Input: codice fiscale da verificare
  - Output: { eligible: boolean, message: text }
  - Accessibile a tutti (anche non autenticati)
  
  ### `get_trial_statistics()` 
  Statistiche per gli admin sul sistema trial:
  - Totale CF registrati
  - Tentativi bloccati totali
  - Trial attivi
  - Ultimi tentativi bloccati
  
  ## Security
  - La prima funzione è pubblica (necessaria per registrazione)
  - La seconda solo per admin
  - Non rivela informazioni personali
*/

-- 1. Funzione pubblica per controllare CF prima della registrazione
CREATE OR REPLACE FUNCTION check_fiscal_code_trial_eligibility(p_fiscal_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  -- Valida input
  IF p_fiscal_code IS NULL OR p_fiscal_code = '' THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'message', 'Il codice fiscale è obbligatorio'
    );
  END IF;

  -- Controlla se esiste nella history
  SELECT EXISTS (
    SELECT 1 FROM trial_usage_history
    WHERE fiscal_code = UPPER(TRIM(p_fiscal_code))
  ) INTO v_exists;

  IF v_exists THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'message', 'Questo codice fiscale ha già usufruito del periodo di prova'
    );
  END IF;

  RETURN jsonb_build_object(
    'eligible', true,
    'message', 'Codice fiscale idoneo per il periodo di prova'
  );
END;
$$;

-- 2. Funzione per statistiche trial (solo admin)
CREATE OR REPLACE FUNCTION get_trial_statistics()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total_registered bigint;
  v_total_blocked bigint;
  v_active_trials bigint;
  v_recent_blocks jsonb;
BEGIN
  -- Verifica che sia admin
  IF NOT EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()) THEN
    RAISE EXCEPTION 'Accesso negato: solo admin'
      USING ERRCODE = '42501';
  END IF;

  -- Conta CF registrati
  SELECT COUNT(*) INTO v_total_registered
  FROM trial_usage_history;

  -- Somma tentativi bloccati
  SELECT COALESCE(SUM(attempts_blocked), 0) INTO v_total_blocked
  FROM trial_usage_history;

  -- Conta trial attivi
  SELECT COUNT(*) INTO v_active_trials
  FROM subscriptions
  WHERE status = 'trial'
    AND end_date > now();

  -- Ultimi 10 tentativi bloccati
  SELECT jsonb_agg(
    jsonb_build_object(
      'fiscal_code', SUBSTRING(fiscal_code, 1, 6) || '***', -- Privacy
      'attempts', attempts_blocked,
      'last_attempt', last_attempt_date
    )
  ) INTO v_recent_blocks
  FROM (
    SELECT fiscal_code, attempts_blocked, last_attempt_date
    FROM trial_usage_history
    WHERE attempts_blocked > 0
    ORDER BY last_attempt_date DESC NULLS LAST
    LIMIT 10
  ) recent;

  RETURN jsonb_build_object(
    'total_registered_fiscal_codes', v_total_registered,
    'total_attempts_blocked', v_total_blocked,
    'active_trials', v_active_trials,
    'recent_blocked_attempts', COALESCE(v_recent_blocks, '[]'::jsonb)
  );
END;
$$;

-- 3. Funzione per gli admin per vedere dettagli di un utente specifico
CREATE OR REPLACE FUNCTION get_user_trial_details(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result jsonb;
  v_user_cf text;
  v_family_cfs text[];
  v_blocked_cfs text[];
BEGIN
  -- Verifica che sia admin
  IF NOT EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()) THEN
    RAISE EXCEPTION 'Accesso negato: solo admin'
      USING ERRCODE = '42501';
  END IF;

  -- Ottieni CF utente
  SELECT fiscal_code INTO v_user_cf
  FROM profiles
  WHERE id = p_user_id;

  -- Ottieni CF famiglia
  SELECT array_agg(tax_code)
  INTO v_family_cfs
  FROM customer_family_members
  WHERE customer_id = p_user_id
    AND tax_code IS NOT NULL;

  -- Controlla quali CF sono bloccati
  IF v_family_cfs IS NOT NULL THEN
    SELECT array_agg(fiscal_code)
    INTO v_blocked_cfs
    FROM trial_usage_history
    WHERE fiscal_code = ANY(v_family_cfs) OR fiscal_code = v_user_cf;
  ELSE
    SELECT array_agg(fiscal_code)
    INTO v_blocked_cfs
    FROM trial_usage_history
    WHERE fiscal_code = v_user_cf;
  END IF;

  RETURN jsonb_build_object(
    'user_id', p_user_id,
    'user_fiscal_code', v_user_cf,
    'family_fiscal_codes', COALESCE(v_family_cfs, ARRAY[]::text[]),
    'blocked_fiscal_codes', COALESCE(v_blocked_cfs, ARRAY[]::text[]),
    'is_eligible', (v_blocked_cfs IS NULL OR array_length(v_blocked_cfs, 1) IS NULL),
    'eligibility_check', check_trial_eligibility(p_user_id)
  );
END;
$$;

-- Grant permessi
GRANT EXECUTE ON FUNCTION check_fiscal_code_trial_eligibility(text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_trial_statistics() TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_trial_details(uuid) TO authenticated;

-- Commenti
COMMENT ON FUNCTION check_fiscal_code_trial_eligibility(text) IS 'Controlla se un CF può usare il trial - accessibile anche a utenti non autenticati';
COMMENT ON FUNCTION get_trial_statistics() IS 'Statistiche sistema trial per admin';
COMMENT ON FUNCTION get_user_trial_details(uuid) IS 'Dettagli completi trial di un utente specifico per admin';


-- ============================================================
-- FILE: 20260306110838_add_admin_view_all_profiles_policy.sql
-- ============================================================
/*
  # Allow admins to view all profiles

  1. Changes
    - Add RLS policy to allow admin users to view all profiles in the system
    - This enables the admin dashboard to display all users for management purposes
  
  2. Security
    - Only users in the admins table can view all profiles
    - Regular users can still only view their own profile or public profile info
*/

-- Allow admins to view all profiles
CREATE POLICY "Admins can view all profiles"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins 
      WHERE admins.user_id = auth.uid()
    )
  );


