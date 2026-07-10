/*
  # Auto-aggiornamento piano abbonamento in base a membri famiglia

  1. Funzione
    - `update_subscription_plan_on_family_change`: Aggiorna automaticamente il piano quando cambiano i membri della famiglia
    - Conta i membri + 1 (utente principale) e seleziona il piano adatto

  2. Trigger
    - Si attiva quando viene aggiunto/rimosso un membro della famiglia
    - Aggiorna sia la subscription che il profilo utente

  3. Logica
    - 1 persona = Piano da 1 persona
    - 2 persone = Piano da 2 persone
    - 3 persone = Piano da 3 persone
    - 4+ persone = Piano da 4 persone
*/

-- Funzione per aggiornare il piano quando cambiano i membri della famiglia
CREATE OR REPLACE FUNCTION update_subscription_plan_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  v_customer_id uuid;
  v_family_count integer;
  v_total_persons integer;
  v_current_subscription record;
  v_new_plan_id uuid;
  v_user_type text;
BEGIN
  -- Determina l'ID del customer e il tipo di operazione
  IF (TG_OP = 'DELETE') THEN
    v_customer_id := OLD.customer_id;
  ELSE
    v_customer_id := NEW.customer_id;
  END IF;

  -- Verifica il tipo di utente
  SELECT user_type INTO v_user_type
  FROM profiles
  WHERE id = v_customer_id;

  -- Procedi solo se è un customer
  IF v_user_type != 'customer' THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Conta i membri della famiglia dopo l'operazione
  SELECT COUNT(*) INTO v_family_count
  FROM customer_family_members
  WHERE customer_id = v_customer_id;

  -- Totale persone = utente principale + membri famiglia
  v_total_persons := v_family_count + 1;

  -- Ottieni la subscription attuale
  SELECT * INTO v_current_subscription
  FROM subscriptions
  WHERE customer_id = v_customer_id
  AND status IN ('active', 'trial')
  ORDER BY created_at DESC
  LIMIT 1;

  -- Se non c'è subscription, esci
  IF v_current_subscription.id IS NULL THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Trova il piano corretto basato sul numero di persone
  -- Mantieni lo stesso periodo di fatturazione (mensile o annuale)
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_total_persons
  AND billing_period = (
    SELECT billing_period
    FROM subscription_plans
    WHERE id = v_current_subscription.plan_id
  )
  AND name NOT LIKE '%Business%'
  LIMIT 1;

  -- Se non esiste un piano esatto, prendi quello più grande disponibile
  IF v_new_plan_id IS NULL THEN
    SELECT id INTO v_new_plan_id
    FROM subscription_plans
    WHERE max_persons >= v_total_persons
    AND billing_period = (
      SELECT billing_period
      FROM subscription_plans
      WHERE id = v_current_subscription.plan_id
    )
    AND name NOT LIKE '%Business%'
    ORDER BY max_persons ASC
    LIMIT 1;
  END IF;

  -- Aggiorna la subscription solo se il piano è diverso
  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;

    RAISE NOTICE 'Piano aggiornato per customer % da % a % persone', v_customer_id, v_family_count, v_total_persons;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per INSERT di nuovi membri
DROP TRIGGER IF EXISTS trigger_update_plan_on_family_insert ON customer_family_members;
CREATE TRIGGER trigger_update_plan_on_family_insert
  AFTER INSERT ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_family_change();

-- Trigger per DELETE di membri
DROP TRIGGER IF EXISTS trigger_update_plan_on_family_delete ON customer_family_members;
CREATE TRIGGER trigger_update_plan_on_family_delete
  AFTER DELETE ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_family_change();
