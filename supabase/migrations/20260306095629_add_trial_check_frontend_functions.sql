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
