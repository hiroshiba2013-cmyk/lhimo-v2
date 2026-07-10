/*
  # Rinomina tax_code in fiscal_code

  Questa migrazione standardizza il nome della colonna del codice fiscale 
  da `tax_code` a `fiscal_code` in tutte le tabelle per coerenza.

  ## Cambiamenti

  1. Rinomina `tax_code` in `fiscal_code` nella tabella `customer_family_members`
  2. Aggiorna la funzione `check_family_member_trial_eligibility` per usare `fiscal_code`
  3. Aggiorna il trigger corrispondente

  ## Note

  - La colonna `fiscal_code` esiste già nella tabella `profiles`
  - Tutti i riferimenti nel codice frontend sono stati aggiornati
*/

-- Rinomina la colonna nella tabella customer_family_members
ALTER TABLE customer_family_members 
RENAME COLUMN tax_code TO fiscal_code;

-- Aggiorna la funzione per usare fiscal_code
CREATE OR REPLACE FUNCTION check_family_member_trial_eligibility()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_blocked_cf text;
BEGIN
  -- Controlla solo se il CF è fornito
  IF NEW.fiscal_code IS NULL OR NEW.fiscal_code = '' THEN
    RETURN NEW;
  END IF;

  -- Controlla se questo CF ha già usato il trial
  SELECT fiscal_code INTO v_blocked_cf
  FROM trial_usage_history
  WHERE fiscal_code = NEW.fiscal_code;

  IF v_blocked_cf IS NOT NULL THEN
    RAISE EXCEPTION 'Il codice fiscale % ha già usufruito del periodo di prova', NEW.fiscal_code
      USING ERRCODE = '23514';
  END IF;

  -- Registra il CF del nuovo membro se l'account è in trial
  IF EXISTS (
    SELECT 1 FROM profiles
    WHERE id = NEW.customer_id
      AND subscription_status = 'trial'
  ) THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (NEW.fiscal_code, NEW.customer_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

-- Ricrea il trigger per usare fiscal_code
DROP TRIGGER IF EXISTS trigger_check_family_trial_eligibility ON customer_family_members;

CREATE TRIGGER trigger_check_family_trial_eligibility
  BEFORE INSERT OR UPDATE OF fiscal_code ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION check_family_member_trial_eligibility();
