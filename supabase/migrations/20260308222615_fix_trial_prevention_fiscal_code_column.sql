/*
  # Fix Trial Prevention - Correct Column Name

  ## Problem
  The trial prevention system references 'tax_code' which doesn't exist.
  The correct column name is 'fiscal_code'.
  
  ## Solution
  Replace all references to 'tax_code' with 'fiscal_code' in the prevention functions.
*/

-- Fix check_trial_eligibility function
CREATE OR REPLACE FUNCTION check_trial_eligibility(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_fiscal_codes text[];
  v_used_fiscal_codes text[];
  v_is_eligible boolean := true;
  v_reason text := null;
BEGIN
  -- Ottieni il CF del profilo
  SELECT fiscal_code INTO v_profile_fiscal_code
  FROM profiles
  WHERE id = p_user_id;

  -- Controlla se il CF del titolare è già stato usato per un trial
  IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
    IF EXISTS (
      SELECT 1 FROM trial_usage_history
      WHERE fiscal_code = v_profile_fiscal_code
    ) THEN
      v_is_eligible := false;
      v_reason := 'Codice fiscale già utilizzato per un periodo di prova';
    END IF;
  END IF;

  -- Ottieni tutti i CF dei membri della famiglia
  SELECT array_agg(fiscal_code)
  INTO v_family_fiscal_codes
  FROM customer_family_members
  WHERE customer_id = p_user_id
    AND fiscal_code IS NOT NULL
    AND fiscal_code != '';

  -- Controlla se qualche CF della famiglia è già stato usato
  IF v_family_fiscal_codes IS NOT NULL THEN
    SELECT array_agg(fiscal_code)
    INTO v_used_fiscal_codes
    FROM trial_usage_history
    WHERE fiscal_code = ANY(v_family_fiscal_codes);

    IF v_used_fiscal_codes IS NOT NULL AND array_length(v_used_fiscal_codes, 1) > 0 THEN
      v_is_eligible := false;
      v_reason := 'Uno o più codici fiscali dei membri della famiglia sono già stati utilizzati per un periodo di prova';
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'eligible', v_is_eligible,
    'reason', v_reason
  );
END;
$$;

-- Fix register_trial_usage function
CREATE OR REPLACE FUNCTION register_trial_usage(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_member RECORD;
BEGIN
  -- Registra il CF del titolare
  SELECT fiscal_code INTO v_profile_fiscal_code
  FROM profiles
  WHERE id = p_user_id;

  IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_profile_fiscal_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  -- Registra i CF di tutti i membri della famiglia
  FOR v_family_member IN
    SELECT fiscal_code
    FROM customer_family_members
    WHERE customer_id = p_user_id
      AND fiscal_code IS NOT NULL
      AND fiscal_code != ''
  LOOP
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (v_family_member.fiscal_code, p_user_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END LOOP;
END;
$$;

-- Fix prevent_trial_abuse function
CREATE OR REPLACE FUNCTION prevent_trial_abuse()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_fiscal_codes text[];
  v_existing_count int;
BEGIN
  -- Solo per nuove sottoscrizioni trial
  IF NEW.status = 'trial' AND (OLD IS NULL OR OLD.status != 'trial') THEN
    
    -- Ottieni il CF del profilo
    SELECT fiscal_code INTO v_profile_fiscal_code
    FROM profiles
    WHERE id = NEW.customer_id;

    -- Verifica se questo CF ha già avuto un trial
    IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
      SELECT COUNT(*) INTO v_existing_count
      FROM trial_usage_history
      WHERE fiscal_code = v_profile_fiscal_code;

      IF v_existing_count > 0 THEN
        RAISE EXCEPTION 'Questo codice fiscale è già stato utilizzato per un periodo di prova';
      END IF;
    END IF;

    -- Controlla anche i CF della famiglia
    SELECT array_agg(fiscal_code)
    INTO v_family_fiscal_codes
    FROM customer_family_members
    WHERE customer_id = NEW.customer_id
      AND fiscal_code IS NOT NULL;

    IF v_family_fiscal_codes IS NOT NULL THEN
      UPDATE trial_usage_history
      SET subsequent_attempts = array_append(subsequent_attempts, NEW.customer_id)
      WHERE fiscal_code = ANY(v_family_fiscal_codes);

      SELECT COUNT(*) INTO v_existing_count
      FROM trial_usage_history
      WHERE fiscal_code = ANY(v_family_fiscal_codes);

      IF v_existing_count > 0 THEN
        RAISE EXCEPTION 'Uno o più codici fiscali dei membri della famiglia sono già stati utilizzati per un periodo di prova';
      END IF;
    END IF;

    -- Registra l'uso del trial
    PERFORM register_trial_usage(NEW.customer_id);
  END IF;

  RETURN NEW;
END;
$$;
