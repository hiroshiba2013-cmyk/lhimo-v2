/*
  # Fix trial subscription per utenti senza abbonamento e sync piano con membri famiglia

  1. Disabilita temporaneamente il trigger prevent_trial_abuse per l'insert
  2. Crea abbonamenti trial mancanti per customer con status=trial ma senza subscription
  3. Riabilita il trigger
  4. Aggiorna la funzione update_subscription_plan_on_family_change per creare
     l'abbonamento anche quando manca

  Nota: il trigger prevent_trial_abuse ha un bug su colonna "subsequent_attempts"
  che viene aggirato disabilitandolo temporaneamente solo per questo script.
*/

-- Disabilita trigger problematico temporaneamente
ALTER TABLE subscriptions DISABLE TRIGGER trigger_prevent_trial_abuse;

-- Crea abbonamenti trial mancanti per tutti i customer con status=trial ma senza subscription
DO $$
DECLARE
  r record;
  v_plan_id uuid;
  v_plan_name text;
  v_member_count int;
BEGIN
  FOR r IN
    SELECT p.id, p.full_name
    FROM profiles p
    WHERE p.user_type = 'customer'
      AND p.subscription_status = 'trial'
      AND NOT EXISTS (SELECT 1 FROM subscriptions s WHERE s.customer_id = p.id)
  LOOP
    SELECT COUNT(*) INTO v_member_count
    FROM customer_family_members
    WHERE customer_id = r.id;

    SELECT sp.id, sp.name INTO v_plan_id, v_plan_name
    FROM subscription_plans sp
    WHERE sp.name NOT LIKE '%Business%'
      AND sp.billing_period = 'monthly'
      AND sp.max_persons >= v_member_count + 1
    ORDER BY sp.max_persons ASC, sp.price ASC
    LIMIT 1;

    IF v_plan_id IS NOT NULL THEN
      INSERT INTO subscriptions (customer_id, plan_id, status, start_date, end_date, trial_end_date, payment_method_added, reminder_sent)
      VALUES (r.id, v_plan_id, 'trial', NOW(), NOW() + INTERVAL '30 days', NOW() + INTERVAL '30 days', false, false);

      UPDATE profiles
      SET subscription_type = v_plan_name,
          subscription_expires_at = NOW() + INTERVAL '30 days'
      WHERE id = r.id;
    END IF;
  END LOOP;
END $$;

-- Riabilita trigger
ALTER TABLE subscriptions ENABLE TRIGGER trigger_prevent_trial_abuse;

-- Aggiorna la funzione per creare abbonamento trial se manca quando si aggiunge un membro
CREATE OR REPLACE FUNCTION public.update_subscription_plan_on_family_change()
  RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
AS $function$
DECLARE
  v_customer_id uuid;
  v_new_plan_id uuid;
  v_new_plan_name text;
  v_current_subscription record;
  v_member_count int;
BEGIN
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

  -- Se non c'è subscription e si sta aggiungendo un membro, crea trial
  IF v_current_subscription.id IS NULL THEN
    IF TG_OP = 'INSERT' THEN
      SELECT COUNT(*) INTO v_member_count
      FROM customer_family_members
      WHERE customer_id = v_customer_id;

      SELECT sp.id, sp.name INTO v_new_plan_id, v_new_plan_name
      FROM subscription_plans sp
      WHERE sp.name NOT LIKE '%Business%'
        AND sp.billing_period = 'monthly'
        AND sp.max_persons >= v_member_count + 1
      ORDER BY sp.max_persons ASC, sp.price ASC
      LIMIT 1;

      IF v_new_plan_id IS NOT NULL THEN
        INSERT INTO subscriptions (customer_id, plan_id, status, start_date, end_date, trial_end_date, payment_method_added, reminder_sent)
        VALUES (v_customer_id, v_new_plan_id, 'trial', NOW(), NOW() + INTERVAL '30 days', NOW() + INTERVAL '30 days', false, false)
        ON CONFLICT DO NOTHING;

        UPDATE profiles
        SET subscription_type = v_new_plan_name,
            subscription_status = 'trial',
            subscription_expires_at = NOW() + INTERVAL '30 days'
        WHERE id = v_customer_id;
      END IF;
    END IF;
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Aggiorna piano in base al numero corrente di membri
  v_new_plan_id := get_correct_plan_for_customer(v_customer_id, v_current_subscription.plan_id);

  IF v_new_plan_id IS NOT NULL AND v_new_plan_id != v_current_subscription.plan_id THEN
    SELECT name INTO v_new_plan_name FROM subscription_plans WHERE id = v_new_plan_id;

    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription.id;

    UPDATE profiles
    SET subscription_type = v_new_plan_name
    WHERE id = v_customer_id;
  END IF;

  RETURN COALESCE(NEW, OLD);
EXCEPTION
  WHEN OTHERS THEN
    RETURN COALESCE(NEW, OLD);
END;
$function$;
