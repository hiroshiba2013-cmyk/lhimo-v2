/*
  # Fix trigger sync abbonamenti — usa trial_end_date per subscription_expires_at in trial

  Il trigger sincronizza profiles quando cambia subscriptions.
  Bug: per gli utenti in trial, subscription_expires_at veniva impostato a end_date
  invece che a trial_end_date, causando discrepanza tra admin e piattaforma.

  Fix:
  - Se status = 'trial' e trial_end_date IS NOT NULL → usa trial_end_date
  - Altrimenti → usa end_date
  - Aggiunge anche sync quando status diventa 'expired' o 'cancelled'
    (il trigger prima ignorava questi stati, lasciando profiles stale)
*/

CREATE OR REPLACE FUNCTION public.sync_subscription_type_from_plan()
  RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
AS $function$
DECLARE
  v_plan_name text;
  v_expires_at timestamptz;
BEGIN
  -- Recupera il nome del piano
  SELECT name INTO v_plan_name
  FROM subscription_plans
  WHERE id = NEW.plan_id;

  -- Determina la data di scadenza corretta
  IF NEW.status = 'trial' AND NEW.trial_end_date IS NOT NULL THEN
    v_expires_at := NEW.trial_end_date;
  ELSE
    v_expires_at := NEW.end_date;
  END IF;

  -- Aggiorna il profilo con tutti i dati sincronizzati
  UPDATE profiles
  SET
    subscription_type    = COALESCE(v_plan_name, subscription_type),
    subscription_status  = NEW.status,
    subscription_expires_at = v_expires_at
  WHERE id = NEW.customer_id;

  RETURN NEW;
END;
$function$;

-- Aggiorna il trigger per scattare su TUTTI gli stati (non solo active/trial)
DROP TRIGGER IF EXISTS trigger_sync_subscription_type ON subscriptions;

CREATE TRIGGER trigger_sync_subscription_type
  AFTER INSERT OR UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION sync_subscription_type_from_plan();

-- Riallinea tutti i profili esistenti con i dati reali dalla tabella subscriptions
UPDATE profiles p
SET
  subscription_type    = sp.name,
  subscription_status  = s.status,
  subscription_expires_at = CASE
    WHEN s.status = 'trial' AND s.trial_end_date IS NOT NULL THEN s.trial_end_date
    ELSE s.end_date
  END
FROM subscriptions s
JOIN subscription_plans sp ON sp.id = s.plan_id
WHERE s.customer_id = p.id
  AND s.id = (
    SELECT id FROM subscriptions s2
    WHERE s2.customer_id = p.id
    ORDER BY start_date DESC
    LIMIT 1
  );
