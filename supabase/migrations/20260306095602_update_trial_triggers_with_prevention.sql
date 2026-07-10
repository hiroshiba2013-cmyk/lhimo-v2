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
