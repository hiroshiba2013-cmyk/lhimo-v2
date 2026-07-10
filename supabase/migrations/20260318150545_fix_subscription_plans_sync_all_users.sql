/*
  # Sincronizza tutti gli abbonamenti con il numero corretto di persone
  
  1. Funzione
    - `sync_all_subscription_plans`: Corregge tutti gli abbonamenti esistenti
    - `get_correct_plan_for_customer`: Ottiene il piano corretto basato sui membri
  
  2. Correzioni
    - Aggiorna tutti gli abbonamenti customer con il piano corretto
    - Aggiorna tutti gli abbonamenti business con il piano corretto
    - Aggiorna anche il trigger per essere più robusto
  
  3. Esecuzione
    - Esegue automaticamente la sincronizzazione di tutti gli utenti
*/

-- Funzione per ottenere il piano corretto per un customer
CREATE OR REPLACE FUNCTION get_correct_plan_for_customer(
  p_customer_id uuid,
  p_current_plan_id uuid
)
RETURNS uuid AS $$
DECLARE
  v_family_count integer;
  v_total_persons integer;
  v_billing_period text;
  v_new_plan_id uuid;
BEGIN
  -- Conta i membri della famiglia
  SELECT COUNT(*) INTO v_family_count
  FROM customer_family_members
  WHERE customer_id = p_customer_id;
  
  -- Totale persone = utente principale + membri famiglia
  v_total_persons := v_family_count + 1;
  
  -- Ottieni il periodo di fatturazione attuale
  SELECT billing_period INTO v_billing_period
  FROM subscription_plans
  WHERE id = p_current_plan_id;
  
  -- Se non trovato, usa mensile come default
  IF v_billing_period IS NULL THEN
    v_billing_period := 'monthly';
  END IF;
  
  -- Trova il piano corretto
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_total_persons
  AND billing_period = v_billing_period
  AND name NOT LIKE '%Business%'
  LIMIT 1;
  
  -- Se non esiste un piano esatto, prendi quello più grande disponibile
  IF v_new_plan_id IS NULL THEN
    SELECT id INTO v_new_plan_id
    FROM subscription_plans
    WHERE max_persons >= v_total_persons
    AND billing_period = v_billing_period
    AND name NOT LIKE '%Business%'
    ORDER BY max_persons ASC
    LIMIT 1;
  END IF;
  
  RETURN v_new_plan_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per ottenere il piano corretto per un business
CREATE OR REPLACE FUNCTION get_correct_plan_for_business(
  p_business_id uuid,
  p_current_plan_id uuid
)
RETURNS uuid AS $$
DECLARE
  v_locations_count integer;
  v_billing_period text;
  v_new_plan_id uuid;
BEGIN
  -- Conta le sedi business
  SELECT COUNT(*) INTO v_locations_count
  FROM business_locations
  WHERE business_id = p_business_id;
  
  -- Se nessuna sede, almeno 1
  IF v_locations_count = 0 THEN
    v_locations_count := 1;
  END IF;
  
  -- Ottieni il periodo di fatturazione attuale
  SELECT billing_period INTO v_billing_period
  FROM subscription_plans
  WHERE id = p_current_plan_id;
  
  -- Se non trovato, usa mensile come default
  IF v_billing_period IS NULL THEN
    v_billing_period := 'monthly';
  END IF;
  
  -- Trova il piano corretto
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_locations_count
  AND billing_period = v_billing_period
  AND name LIKE '%Business%'
  LIMIT 1;
  
  -- Se non esiste un piano esatto, prendi quello più grande disponibile
  IF v_new_plan_id IS NULL THEN
    SELECT id INTO v_new_plan_id
    FROM subscription_plans
    WHERE max_persons >= v_locations_count
    AND billing_period = v_billing_period
    AND name LIKE '%Business%'
    ORDER BY max_persons ASC
    LIMIT 1;
  END IF;
  
  RETURN v_new_plan_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per sincronizzare tutti gli abbonamenti
CREATE OR REPLACE FUNCTION sync_all_subscription_plans()
RETURNS TABLE(
  customer_email text,
  old_plan text,
  new_plan text,
  updated boolean
) AS $$
DECLARE
  v_subscription record;
  v_new_plan_id uuid;
  v_old_plan_name text;
  v_new_plan_name text;
  v_profile record;
BEGIN
  -- Loop attraverso tutte le subscriptions attive o trial
  FOR v_subscription IN 
    SELECT s.*, p.email, p.user_type
    FROM subscriptions s
    JOIN profiles p ON p.id = s.customer_id
    WHERE s.status IN ('active', 'trial')
  LOOP
    -- Ottieni il nome del piano attuale
    SELECT name INTO v_old_plan_name
    FROM subscription_plans
    WHERE id = v_subscription.plan_id;
    
    -- Determina il piano corretto in base al tipo di utente
    IF v_subscription.user_type = 'customer' THEN
      v_new_plan_id := get_correct_plan_for_customer(
        v_subscription.customer_id,
        v_subscription.plan_id
      );
    ELSIF v_subscription.user_type = 'business' THEN
      v_new_plan_id := get_correct_plan_for_business(
        v_subscription.customer_id,
        v_subscription.plan_id
      );
    ELSE
      v_new_plan_id := v_subscription.plan_id;
    END IF;
    
    -- Ottieni il nome del nuovo piano
    SELECT name INTO v_new_plan_name
    FROM subscription_plans
    WHERE id = v_new_plan_id;
    
    -- Se il piano è diverso, aggiorna
    IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_subscription.plan_id THEN
      UPDATE subscriptions
      SET plan_id = v_new_plan_id,
          updated_at = now()
      WHERE id = v_subscription.id;
      
      RETURN QUERY SELECT 
        v_subscription.email::text,
        v_old_plan_name::text,
        v_new_plan_name::text,
        true;
    ELSE
      RETURN QUERY SELECT 
        v_subscription.email::text,
        v_old_plan_name::text,
        v_new_plan_name::text,
        false;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aggiorna la funzione del trigger per essere più robusta
CREATE OR REPLACE FUNCTION update_subscription_plan_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  v_customer_id uuid;
  v_new_plan_id uuid;
  v_current_subscription record;
BEGIN
  -- Determina l'ID del customer
  IF (TG_OP = 'DELETE') THEN
    v_customer_id := OLD.customer_id;
  ELSE
    v_customer_id := NEW.customer_id;
  END IF;

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

  -- Ottieni il piano corretto usando la funzione helper
  v_new_plan_id := get_correct_plan_for_customer(
    v_customer_id,
    v_current_subscription.plan_id
  );

  -- Aggiorna la subscription solo se il piano è diverso
  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per business locations (INSERT/DELETE)
CREATE OR REPLACE FUNCTION update_subscription_plan_on_location_change()
RETURNS TRIGGER AS $$
DECLARE
  v_business_id uuid;
  v_new_plan_id uuid;
  v_current_subscription record;
BEGIN
  -- Determina l'ID del business
  IF (TG_OP = 'DELETE') THEN
    v_business_id := OLD.business_id;
  ELSE
    v_business_id := NEW.business_id;
  END IF;

  -- Ottieni la subscription attuale
  SELECT * INTO v_current_subscription
  FROM subscriptions
  WHERE customer_id = v_business_id
  AND status IN ('active', 'trial')
  ORDER BY created_at DESC
  LIMIT 1;

  -- Se non c'è subscription, esci
  IF v_current_subscription.id IS NULL THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Ottieni il piano corretto usando la funzione helper
  v_new_plan_id := get_correct_plan_for_business(
    v_business_id,
    v_current_subscription.plan_id
  );

  -- Aggiorna la subscription solo se il piano è diverso
  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per business locations INSERT
DROP TRIGGER IF EXISTS trigger_update_plan_on_location_insert ON business_locations;
CREATE TRIGGER trigger_update_plan_on_location_insert
  AFTER INSERT ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_location_change();

-- Trigger per business locations DELETE
DROP TRIGGER IF EXISTS trigger_update_plan_on_location_delete ON business_locations;
CREATE TRIGGER trigger_update_plan_on_location_delete
  AFTER DELETE ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_plan_on_location_change();

-- Esegui la sincronizzazione di tutti gli abbonamenti esistenti
SELECT * FROM sync_all_subscription_plans();
