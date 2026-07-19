
/*
# Fix registrazione: constraint, trigger, user_type admin

## Problemi identificati
1. `handle_new_user()` inserisce `subscription_status = 'none'` → non è nei valori ammessi → TUTTE le registrazioni falliscono.
2. `profiles_subscription_status_check` non include `'trial'` → `create_trial_for_customer` non può impostare lo status trial.
3. `subscriptions_status_check` non include `'trial'` → INSERT nella tabella subscriptions fallisce.
4. `profiles_user_type_check` non include `'admin'` → l'edge function non può creare profili admin.

## Correzioni
1. Fix `handle_new_user`: usa NULL per subscription_status invece di 'none'.
2. Aggiunge 'trial' a `profiles_subscription_status_check`.
3. Aggiunge 'trial' a `subscriptions_status_check`.
4. Aggiunge 'admin' a `profiles_user_type_check`.
*/

-- 1. Fix handle_new_user: usa NULL invece di 'none' per subscription_status
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    user_type,
    subscription_status
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'customer',
    NULL
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;

-- 2. Fix profiles_subscription_status_check: aggiungi 'trial'
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_subscription_status_check;

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_subscription_status_check
  CHECK (subscription_status IS NULL OR subscription_status = ANY (
    ARRAY['active'::text, 'expired'::text, 'cancelled'::text, 'trial'::text]
  ));

-- 3. Fix subscriptions_status_check: aggiungi 'trial'
ALTER TABLE public.subscriptions
  DROP CONSTRAINT IF EXISTS subscriptions_status_check;

ALTER TABLE public.subscriptions
  ADD CONSTRAINT subscriptions_status_check
  CHECK (status = ANY (
    ARRAY['active'::text, 'expired'::text, 'cancelled'::text, 'trial'::text]
  ));

-- 4. Fix profiles_user_type_check: aggiungi 'admin'
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_user_type_check;

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_user_type_check
  CHECK (user_type = ANY (ARRAY['customer'::text, 'business'::text, 'admin'::text]));
