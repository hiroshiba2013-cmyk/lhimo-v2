/*
  # Aggiornamento Automatico Piano Trial con Membri Famiglia

  1. Nuove Funzioni
    - `update_trial_plan_on_family_change`: Aggiorna automaticamente il piano del trial quando vengono aggiunti o rimossi membri della famiglia
    - Calcola il numero totale di persone (titolare + membri famiglia)
    - Trova e assegna il piano corretto per quel numero di persone

  2. Trigger
    - Trigger AFTER INSERT su customer_family_members
    - Trigger AFTER DELETE su customer_family_members
    - Aggiorna automaticamente il piano del trial se l'utente ha un abbonamento trial attivo

  3. Comportamento
    - Se l'utente ha 1 membro famiglia (2 persone totali), passa al piano per 2 persone
    - Se l'utente ha 2 membri famiglia (3 persone totali), passa al piano per 3 persone
    - E così via fino a 4 persone
    - Funziona solo per abbonamenti in stato 'trial', non modifica abbonamenti pagati

  4. Note
    - Questo trigger mantiene il periodo di trial originale
    - Non cambia le date di scadenza
    - È completamente automatico e trasparente per l'utente
*/

-- Funzione per aggiornare il piano del trial in base al numero di membri della famiglia
CREATE OR REPLACE FUNCTION update_trial_plan_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  v_customer_id uuid;
  v_family_count integer;
  v_total_persons integer;
  v_new_plan_id uuid;
  v_current_subscription_id uuid;
  v_billing_period text;
BEGIN
  -- Determina l'ID del cliente (valido sia per INSERT che DELETE)
  IF TG_OP = 'DELETE' THEN
    v_customer_id := OLD.customer_id;
  ELSE
    v_customer_id := NEW.customer_id;
  END IF;

  -- Conta i membri della famiglia attuali
  SELECT COUNT(*) INTO v_family_count
  FROM customer_family_members
  WHERE customer_id = v_customer_id;

  -- Calcola il numero totale di persone (1 titolare + membri famiglia)
  v_total_persons := 1 + v_family_count;

  -- Verifica se l'utente ha un abbonamento trial attivo
  SELECT s.id, sp.billing_period
  INTO v_current_subscription_id, v_billing_period
  FROM subscriptions s
  JOIN subscription_plans sp ON sp.id = s.plan_id
  WHERE s.customer_id = v_customer_id
    AND s.status = 'trial'
  LIMIT 1;

  -- Se non c'è un trial attivo, non fare nulla
  IF v_current_subscription_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Trova il piano corretto per il numero di persone e il periodo di fatturazione
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_total_persons
    AND billing_period = v_billing_period
    AND name NOT LIKE '%Business%'
  LIMIT 1;

  -- Se esiste un piano adatto, aggiorna l'abbonamento
  IF v_new_plan_id IS NOT NULL THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription_id;
    
    RAISE NOTICE 'Piano trial aggiornato automaticamente per % persone (piano: %)', v_total_persons, v_new_plan_id;
  END IF;

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger per l'inserimento di membri della famiglia
DROP TRIGGER IF EXISTS trigger_update_trial_on_family_insert ON customer_family_members;
CREATE TRIGGER trigger_update_trial_on_family_insert
  AFTER INSERT ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_trial_plan_on_family_change();

-- Trigger per la cancellazione di membri della famiglia
DROP TRIGGER IF EXISTS trigger_update_trial_on_family_delete ON customer_family_members;
CREATE TRIGGER trigger_update_trial_on_family_delete
  AFTER DELETE ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_trial_plan_on_family_change();

-- Commento sulle funzioni e trigger
COMMENT ON FUNCTION update_trial_plan_on_family_change() IS 'Aggiorna automaticamente il piano del trial quando vengono aggiunti o rimossi membri della famiglia';
COMMENT ON TRIGGER trigger_update_trial_on_family_insert ON customer_family_members IS 'Aggiorna il piano trial quando viene aggiunto un membro della famiglia';
COMMENT ON TRIGGER trigger_update_trial_on_family_delete ON customer_family_members IS 'Aggiorna il piano trial quando viene rimosso un membro della famiglia';
