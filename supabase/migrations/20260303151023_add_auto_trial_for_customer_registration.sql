/*
  # Aggiungi Trial Automatico per Nuovi Utenti Customer

  1. Cambiamenti
    - Crea automaticamente un abbonamento trial di 30 giorni per tutti i nuovi utenti customer
    - Il trial include fino a 1 persona (piano base gratuito)
    - Imposta trial_end_date a 30 giorni dalla registrazione
    - Funziona solo per utenti con user_type = 'customer'

  2. Sicurezza
    - Usa SECURITY DEFINER per permettere inserimento in subscriptions
    - Controlla che non esistano già abbonamenti per l'utente
    - Gestisce errori silenziosamente per non bloccare la registrazione
*/

-- Crea la funzione per creare trial automatico per customer
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
      user_id,
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
    ON CONFLICT (user_id) DO NOTHING;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Crea il trigger
DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;

CREATE TRIGGER trigger_create_trial_for_customer
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_customer();