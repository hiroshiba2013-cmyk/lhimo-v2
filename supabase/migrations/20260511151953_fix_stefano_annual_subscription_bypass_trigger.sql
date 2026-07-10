/*
  # Corregge abbonamento Stefano Mancini e cleanup subscription_type generici

  1. Disabilita temporaneamente prevent_trial_plan_changes per correzione admin
  2. Aggiorna Stefano Mancini al piano "Piano Annuale - 2 Persone" (corretto)
  3. Fix tutti i profili con subscription_type generico ('monthly'/'annual')
  4. Riabilita il trigger
*/

ALTER TABLE subscriptions DISABLE TRIGGER enforce_trial_plan_restrictions;

-- Fix subscription_type generici con il nome reale del piano
UPDATE profiles p
SET subscription_type = sp.name
FROM subscriptions s
JOIN subscription_plans sp ON sp.id = s.plan_id
WHERE s.customer_id = p.id
  AND p.subscription_type IN ('monthly', 'annual', 'mensile', 'annuale');

-- Correggi Stefano: aggiorna al piano annuale 2 persone
DO $$
DECLARE
  v_user_id uuid;
  v_sub_id uuid;
  v_plan_id uuid;
  v_plan_name text;
BEGIN
  SELECT id INTO v_user_id FROM profiles WHERE full_name ILIKE '%Stefano Mancini%' LIMIT 1;
  IF v_user_id IS NULL THEN RETURN; END IF;

  SELECT id INTO v_sub_id FROM subscriptions WHERE customer_id = v_user_id LIMIT 1;
  IF v_sub_id IS NULL THEN RETURN; END IF;

  SELECT id, name INTO v_plan_id, v_plan_name
  FROM subscription_plans
  WHERE name = 'Piano Annuale - 2 Persone'
  LIMIT 1;

  IF v_plan_id IS NULL THEN RETURN; END IF;

  UPDATE subscriptions
  SET plan_id = v_plan_id,
      end_date = NOW() + INTERVAL '1 year',
      trial_end_date = NOW() + INTERVAL '30 days'
  WHERE id = v_sub_id;

  UPDATE profiles
  SET subscription_type = v_plan_name
  WHERE id = v_user_id;
END $$;

ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;
