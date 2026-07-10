/*
  # Fix Trial Trigger - Usa customer_id invece di user_id

  1. Problema
    - Il trigger create_trial_for_customer() usa user_id invece di customer_id
    - La tabella subscriptions usa customer_id come colonna
    - Questo causa un errore durante la registrazione

  2. Soluzione
    - Aggiorna il trigger per usare customer_id
    - Mantieni il constraint ON CONFLICT per gestire duplicati
*/

CREATE OR REPLACE FUNCTION public.create_trial_for_customer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_plan_id uuid;
BEGIN
  -- Solo per utenti customer, non per business o admin
  IF NEW.user_type != 'customer' THEN
    RETURN NEW;
  END IF;

  -- Ottieni l'ID del piano base (1 persona)
  SELECT id INTO base_plan_id
  FROM subscription_plans
  WHERE max_people = 1
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano disponibile
  IF base_plan_id IS NULL THEN
    SELECT id INTO base_plan_id
    FROM subscription_plans
    ORDER BY price_monthly ASC
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
    ON CONFLICT (customer_id) DO NOTHING;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Commento
COMMENT ON FUNCTION create_trial_for_customer() IS 'Crea automaticamente un abbonamento trial di 30 giorni per i nuovi utenti customer alla registrazione';
