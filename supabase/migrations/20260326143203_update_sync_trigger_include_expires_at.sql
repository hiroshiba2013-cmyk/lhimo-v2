/*
  # Update Sync Trigger - Include Expires At
  
  1. Problema
    - Il trigger sync_subscription_type_from_plan aggiorna solo subscription_type e status
    - Non aggiorna subscription_expires_at
    - Questo causa inconsistenza nei dati del profilo
    
  2. Soluzione
    - Aggiorna il trigger per includere anche subscription_expires_at
    - Prende la data di fine abbonamento dalla tabella subscriptions
    
  3. Note
    - Mantiene la sincronizzazione completa tra subscriptions e profiles
*/

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
  
  -- Aggiorna il profilo con il nome del piano, lo status e la data di scadenza
  IF plan_name IS NOT NULL THEN
    UPDATE profiles
    SET 
      subscription_type = plan_name,
      subscription_status = NEW.status,
      subscription_expires_at = NEW.end_date
    WHERE id = NEW.customer_id;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Commento esplicativo
COMMENT ON FUNCTION sync_subscription_type_from_plan IS 'Sincronizza subscription_type, status e expires_at dal piano selezionato in subscriptions';
