/*
  # Fix Creazione Automatica Trial per Nuovi Utenti Customer

  1. Problema Risolto
    - Il trigger per creare trial automatici non era attivo
    - I nomi delle colonne erano errati (user_id invece di customer_id, max_people invece di max_persons)
    
  2. Soluzione
    - Ricrea la funzione con i nomi di colonna corretti
    - Ricrea il trigger per attivarla automaticamente alla registrazione
    - Aggiunge trial di 30 giorni per ogni nuovo utente customer
    
  3. Note
    - Funziona solo per user_type = 'customer'
    - Seleziona il piano più economico con 1 persona
    - Non blocca la registrazione se ci sono errori
*/

-- Ricrea la funzione con i nomi di colonna corretti
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

  -- Ottieni l'ID del piano base (1 persona, mensile, più economico)
  SELECT id INTO base_plan_id
  FROM subscription_plans
  WHERE max_persons = 1 
    AND billing_period = 'monthly'
  ORDER BY price ASC
  LIMIT 1;

  -- Se non troviamo il piano, usa il primo piano disponibile
  IF base_plan_id IS NULL THEN
    SELECT id INTO base_plan_id
    FROM subscription_plans
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
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- Elimina il trigger esistente se presente
DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;

-- Ricrea il trigger
CREATE TRIGGER trigger_create_trial_for_customer
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_customer();
