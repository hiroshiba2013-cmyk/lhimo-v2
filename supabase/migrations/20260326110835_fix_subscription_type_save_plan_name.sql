/*
  # Fix Subscription Type - Salva Nome Piano Completo
  
  1. Problema Risolto
    - Il campo subscription_type salvava solo "monthly" o "annual"
    - Causava confusione tra piani business e customer nel pannello admin
    
  2. Soluzione
    - Aggiorna i trigger per salvare il nome completo del piano
    - Aggiunge il sync automatico del subscription_type quando viene creato/aggiornato un abbonamento
    
  3. Note
    - Funziona sia per customer che per business
    - Il nome del piano viene preso dalla tabella subscription_plans
*/

-- Funzione per sincronizzare subscription_type con il piano selezionato
CREATE OR REPLACE FUNCTION public.sync_subscription_type_from_plan()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  plan_name text;
BEGIN
  -- Ottieni il nome del piano
  SELECT name INTO plan_name
  FROM subscription_plans
  WHERE id = NEW.plan_id;
  
  -- Aggiorna il profilo con il nome del piano
  IF plan_name IS NOT NULL THEN
    UPDATE profiles
    SET 
      subscription_type = plan_name,
      subscription_status = NEW.status
    WHERE id = NEW.customer_id;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Elimina trigger esistente se presente
DROP TRIGGER IF EXISTS trigger_sync_subscription_type ON subscriptions;

-- Crea trigger per sincronizzare subscription_type
CREATE TRIGGER trigger_sync_subscription_type
  AFTER INSERT OR UPDATE ON subscriptions
  FOR EACH ROW
  WHEN (NEW.status IN ('active', 'trial'))
  EXECUTE FUNCTION sync_subscription_type_from_plan();

-- Aggiorna la funzione trial per customer
CREATE OR REPLACE FUNCTION public.create_trial_for_customer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_plan_id uuid;
  base_plan_name text;
BEGIN
  -- Solo per utenti customer, non per business o admin
  IF NEW.user_type != 'customer' THEN
    RETURN NEW;
  END IF;

  -- Ottieni l'ID e il nome del piano base (1 persona, mensile, più economico, NON business)
  SELECT id, name INTO base_plan_id, base_plan_name
  FROM subscription_plans
  WHERE max_persons = 1 
    AND billing_period = 'monthly'
    AND name NOT LIKE '%Business%'
  ORDER BY price ASC
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano disponibile non business
  IF base_plan_id IS NULL THEN
    SELECT id, name INTO base_plan_id, base_plan_name
    FROM subscription_plans
    WHERE name NOT LIKE '%Business%'
    ORDER BY price ASC
    LIMIT 1;
  END IF;

  -- Crea l'abbonamento trial solo se esiste un piano e non ci sono già abbonamenti
  IF base_plan_id IS NOT NULL THEN
    INSERT INTO subscriptions (
      customer_id,
      plan_id,
      status,
      start_date,
      end_date,
      trial_end_date,
      payment_method_added,
      reminder_sent
    )
    VALUES (
      NEW.id,
      base_plan_id,
      'trial',
      NOW(),
      NOW() + INTERVAL '30 days',
      NOW() + INTERVAL '30 days',
      false,
      false
    )
    ON CONFLICT DO NOTHING;
    
    -- Aggiorna il profilo con il nome del piano e lo status trial
    UPDATE profiles
    SET 
      subscription_type = base_plan_name,
      subscription_status = 'trial',
      subscription_expires_at = NOW() + INTERVAL '30 days'
    WHERE id = NEW.id;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Aggiorna la funzione trial per business
CREATE OR REPLACE FUNCTION public.create_trial_for_business()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_plan_id uuid;
  base_plan_name text;
BEGIN
  -- Solo per utenti business, non per customer o admin
  IF NEW.user_type != 'business' THEN
    RETURN NEW;
  END IF;

  -- Ottieni l'ID e il nome del piano base business (1 sede, mensile, più economico)
  SELECT id, name INTO base_plan_id, base_plan_name
  FROM subscription_plans
  WHERE max_persons = 1 
    AND billing_period = 'monthly'
    AND name LIKE '%Business%'
  ORDER BY price ASC
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano business disponibile
  IF base_plan_id IS NULL THEN
    SELECT id, name INTO base_plan_id, base_plan_name
    FROM subscription_plans
    WHERE name LIKE '%Business%'
    ORDER BY price ASC
    LIMIT 1;
  END IF;

  -- Crea l'abbonamento trial solo se esiste un piano e non ci sono già abbonamenti
  IF base_plan_id IS NOT NULL THEN
    INSERT INTO subscriptions (
      customer_id,
      plan_id,
      status,
      start_date,
      end_date,
      trial_end_date,
      payment_method_added,
      reminder_sent
    )
    VALUES (
      NEW.id,
      base_plan_id,
      'trial',
      NOW(),
      NOW() + INTERVAL '30 days',
      NOW() + INTERVAL '30 days',
      false,
      false
    )
    ON CONFLICT DO NOTHING;
    
    -- Aggiorna il profilo con il nome del piano e lo status trial
    UPDATE profiles
    SET 
      subscription_type = base_plan_name,
      subscription_status = 'trial',
      subscription_expires_at = NOW() + INTERVAL '30 days'
    WHERE id = NEW.id;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;
