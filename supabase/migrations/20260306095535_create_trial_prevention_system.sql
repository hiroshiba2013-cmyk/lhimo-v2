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
