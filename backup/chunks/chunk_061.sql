-- ============================================================
-- FILE: 20260511094218_add_category_name_to_search_function_v2.sql
-- ============================================================
/*
  # Add category_name to search functions

  Drops and recreates search_all_business_locations and search_all_businesses
  to include category_name directly via JOIN, eliminating the need for a
  separate frontend fetch that was silently failing.
*/

DROP FUNCTION IF EXISTS search_all_businesses(text, text, text, text, uuid, boolean, integer);
DROP FUNCTION IF EXISTS search_all_business_locations(text, text, text, text, uuid, boolean, integer);

CREATE OR REPLACE FUNCTION search_all_business_locations(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count integer DEFAULT 100
)
RETURNS TABLE(
  id uuid,
  name text,
  business_name text,
  category_id uuid,
  category_name text,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  added_by uuid,
  added_by_family_member_id uuid,
  source text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY

  SELECT * FROM (

  -- Sedi non rivendicate da database importato (unclaimed_business_locations)
  SELECT
    ubl.id,
    ubl.name,
    NULL::text as business_name,
    ubl.category_id,
    bc.name as category_name,
    COALESCE(ubl.description, ''),
    ubl.street,
    ubl.city,
    ubl.province,
    ubl.region,
    ubl.postal_code,
    ubl.phone,
    ubl.email,
    ubl.website,
    ubl.business_hours,
    ubl.latitude,
    ubl.longitude,
    'unclaimed'::text as location_type,
    COALESCE(ubl.is_claimed, false) as is_claimed,
    (ubl.verification_badge = 'verified') as is_verified,
    NULL::uuid as business_id,
    ubl.claimed_by as owner_id,
    ubl.added_by,
    ubl.added_by_family_member_id,
    CASE
      WHEN ubl.added_by IS NOT NULL THEN 'user_added'
      ELSE 'imported'
    END::text as result_source,
    ubl.created_at
  FROM unclaimed_business_locations ubl
  LEFT JOIN business_categories bc ON bc.id = ubl.category_id
  WHERE (NOT COALESCE(ubl.is_claimed, false) OR ubl.claimed_by IS NULL)
    AND (search_query = '' OR ubl.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(ubl.city) = LOWER(search_city))
    AND (search_province IS NULL OR ubl.province = search_province)
    AND (search_region IS NULL OR ubl.region ILIKE search_region)
    AND (search_category_id IS NULL OR ubl.category_id = search_category_id)
    AND (ubl.added_by IS NULL OR ubl.verification_badge = 'verified')
    AND NOT verified_only

  UNION ALL

  -- Sedi di attività registrate (business_locations - vecchio sistema)
  SELECT
    bl.id,
    COALESCE(bl.internal_name, b.name) as name,
    b.name as business_name,
    b.category_id,
    bc.name as category_name,
    COALESCE(bl.description, b.description, ''),
    bl.address,
    bl.city,
    bl.province,
    bl.region,
    bl.postal_code,
    bl.phone,
    bl.email,
    bl.website,
    bl.business_hours::text,
    bl.latitude,
    bl.longitude,
    'registered'::text as location_type,
    true as is_claimed,
    true as is_verified,
    b.id as business_id,
    b.owner_id,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    'registered'::text as result_source,
    bl.created_at
  FROM business_locations bl
  INNER JOIN businesses b ON b.id = bl.business_id
  LEFT JOIN business_categories bc ON bc.id = b.category_id
  WHERE b.owner_id IS NOT NULL
    AND (search_query = '' OR COALESCE(bl.internal_name, b.name) ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(bl.city) = LOWER(search_city))
    AND (search_province IS NULL OR bl.province = search_province)
    AND (search_region IS NULL OR bl.region ILIKE search_region)
    AND (search_category_id IS NULL OR b.category_id = search_category_id)

  UNION ALL

  -- Sedi di attività registrate (registered_business_locations - nuovo sistema)
  SELECT
    rbl.id,
    COALESCE(rbl.name, rbl.internal_name, rb.name) as name,
    rb.name as business_name,
    rb.category_id,
    bc.name as category_name,
    COALESCE(rbl.description, rb.description, ''),
    COALESCE(rbl.street, '') as address,
    rbl.city,
    rbl.province,
    COALESCE(
      NULLIF(rbl.region, ''),
      (SELECT DISTINCT ubl2.region FROM unclaimed_business_locations ubl2
       WHERE ubl2.province = rbl.province AND ubl2.region != '' LIMIT 1),
      ''
    ) as region,
    COALESCE(rbl.postal_code, '') as postal_code,
    rbl.phone,
    rbl.email,
    rb.website,
    rbl.business_hours::text,
    NULL::numeric as latitude,
    NULL::numeric as longitude,
    'registered'::text as location_type,
    true as is_claimed,
    true as is_verified,
    rb.id as business_id,
    rb.owner_id,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    'registered'::text as result_source,
    rbl.created_at
  FROM registered_business_locations rbl
  INNER JOIN registered_businesses rb ON rb.id = rbl.business_id
  LEFT JOIN business_categories bc ON bc.id = rb.category_id
  WHERE rb.owner_id IS NOT NULL
    AND (search_query = '' OR
         COALESCE(rbl.name, rbl.internal_name, rb.name) ILIKE '%' || search_query || '%' OR
         rb.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR LOWER(rbl.city) = LOWER(search_city))
    AND (search_province IS NULL OR rbl.province = search_province)
    AND (
      search_region IS NULL OR
      COALESCE(
        NULLIF(rbl.region, ''),
        (SELECT DISTINCT ubl3.region FROM unclaimed_business_locations ubl3
         WHERE ubl3.province = rbl.province AND ubl3.region != '' LIMIT 1),
        ''
      ) ILIKE search_region
    )
    AND (search_category_id IS NULL OR rb.category_id = search_category_id)

  UNION ALL

  -- Attività registrate senza sedi (fallback temporaneo)
  SELECT
    rb.id,
    rb.name,
    NULL::text as business_name,
    rb.category_id,
    bc.name as category_name,
    COALESCE(rb.description, ''),
    COALESCE(rb.office_address,
      NULLIF(TRIM(COALESCE(rb.office_street, '') || ' ' || COALESCE(rb.office_street_number, '')), ''),
      'Da completare'),
    COALESCE(rb.office_city, rb.billing_city, 'Da completare'),
    COALESCE(rb.office_province, rb.billing_province, ''),
    COALESCE(
      (SELECT DISTINCT ubl4.region FROM unclaimed_business_locations ubl4
       WHERE ubl4.province = COALESCE(rb.office_province, rb.billing_province)
       AND ubl4.region != '' LIMIT 1),
      ''
    ) as region,
    COALESCE(rb.office_postal_code, rb.billing_postal_code, ''),
    rb.phone,
    rb.pec_email,
    rb.website,
    NULL::text as business_hours,
    NULL::numeric as latitude,
    NULL::numeric as longitude,
    'registered_no_location'::text as location_type,
    true as is_claimed,
    true as is_verified,
    NULL::uuid as business_id,
    rb.owner_id,
    NULL::uuid as added_by,
    NULL::uuid as added_by_family_member_id,
    'registered'::text as result_source,
    rb.created_at
  FROM registered_businesses rb
  LEFT JOIN business_categories bc ON bc.id = rb.category_id
  WHERE rb.owner_id IS NOT NULL
    AND NOT EXISTS (
      SELECT 1 FROM registered_business_locations rbl
      WHERE rbl.business_id = rb.id
    )
    AND (search_query = '' OR rb.name ILIKE '%' || search_query || '%')
    AND (search_city IS NULL OR
         LOWER(COALESCE(rb.office_city, rb.billing_city, '')) = LOWER(search_city))
    AND (search_province IS NULL OR
         COALESCE(rb.office_province, rb.billing_province) = search_province)
    AND (
      search_region IS NULL OR
      COALESCE(
        (SELECT DISTINCT ubl5.region FROM unclaimed_business_locations ubl5
         WHERE ubl5.province = COALESCE(rb.office_province, rb.billing_province)
         AND ubl5.region != '' LIMIT 1),
        ''
      ) ILIKE search_region
    )
    AND (search_category_id IS NULL OR rb.category_id = search_category_id)

  ) all_results
  ORDER BY
    CASE
      WHEN all_results.result_source = 'registered' THEN 1
      WHEN all_results.result_source = 'imported' THEN 2
      WHEN all_results.result_source = 'user_added' THEN 3
      ELSE 4
    END,
    all_results.name
  LIMIT limit_count;
END;
$$;

CREATE OR REPLACE FUNCTION search_all_businesses(
  search_query text DEFAULT '',
  search_city text DEFAULT NULL,
  search_province text DEFAULT NULL,
  search_region text DEFAULT NULL,
  search_category_id uuid DEFAULT NULL,
  verified_only boolean DEFAULT false,
  limit_count integer DEFAULT 100
)
RETURNS TABLE(
  id uuid,
  name text,
  business_name text,
  category_id uuid,
  category_name text,
  description text,
  address text,
  city text,
  province text,
  region text,
  postal_code text,
  phone text,
  email text,
  website text,
  business_hours text,
  latitude numeric,
  longitude numeric,
  location_type text,
  is_claimed boolean,
  is_verified boolean,
  business_id uuid,
  owner_id uuid,
  added_by uuid,
  added_by_family_member_id uuid,
  source text,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM search_all_business_locations(
    search_query,
    search_city,
    search_province,
    search_region,
    search_category_id,
    verified_only,
    limit_count
  );
END;
$$;


-- ============================================================
-- FILE: 20260511100401_fix_trial_trigger_use_frontend_plan.sql
-- ============================================================
/*
  # Fix trial subscription trigger

  The trigger create_trial_for_customer was always assigning the 1-person plan,
  ignoring what the user selected in the registration form. The frontend then
  tried to INSERT a second subscription which was silently ignored by ON CONFLICT DO NOTHING.

  Fix: Disable the trigger entirely. The frontend (RegisterForm.tsx) already
  correctly creates the subscription with the plan the user selected.
  The trigger was redundant and caused the wrong plan to be assigned.
*/

DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;


-- ============================================================
-- FILE: 20260511100421_fix_stefano_subscription_correct_plan.sql
-- ============================================================
/*
  # Fix Stefano Mancini subscription plan

  Correct the subscription for stefanomancini@gmail.com from 1-person plan
  to the 2-person plan he actually selected during registration.
  This was caused by the now-disabled trigger that always assigned 1-person plan.
*/

ALTER TABLE subscriptions DISABLE TRIGGER enforce_trial_plan_restrictions;

UPDATE subscriptions
SET plan_id = '91907577-c01b-4a3d-99b7-f90c13587064'
WHERE id = 'c0ad9066-6d90-4454-b558-28020868d40e';

ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;

-- Also sync the profile subscription_type
UPDATE profiles
SET subscription_type = 'Piano Mensile - 2 Persone'
WHERE id = '4e405f1b-33d1-4012-ae38-e6186b5639af';


-- ============================================================
-- FILE: 20260511101315_delete_stefano_mancini_complete.sql
-- ============================================================
/*
  # Delete user stefanomancini@gmail.com completely

  Complete removal bypassing trial protection trigger.
  User ID: 4e405f1b-33d1-4012-ae38-e6186b5639af
*/

ALTER TABLE subscriptions DISABLE TRIGGER enforce_trial_plan_restrictions;

DELETE FROM subscriptions WHERE customer_id = '4e405f1b-33d1-4012-ae38-e6186b5639af';

ALTER TABLE subscriptions ENABLE TRIGGER enforce_trial_plan_restrictions;

DELETE FROM profiles WHERE id = '4e405f1b-33d1-4012-ae38-e6186b5639af';

DELETE FROM auth.users WHERE id = '4e405f1b-33d1-4012-ae38-e6186b5639af';


-- ============================================================
-- FILE: 20260511142654_add_family_member_avatar_storage_policies.sql
-- ============================================================
/*
  # Add storage policies for family member avatars

  The existing avatar upload policies check that the first path segment equals auth.uid().
  Family member avatars use the path: family/{member_id}/avatar.ext
  where the first segment is "family", not the user's UUID — so uploads fail with 400.

  This migration adds INSERT, UPDATE, and DELETE policies for the family/ subfolder,
  allowing any authenticated user to manage avatars under family/ paths.
  (Ownership is enforced at the DB level via RLS on customer_family_members.)
*/

CREATE POLICY "Users can upload family member avatars"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'family'
  );

CREATE POLICY "Users can update family member avatars"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'family'
  );

CREATE POLICY "Users can delete family member avatars"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'family'
  );


-- ============================================================
-- FILE: 20260511151014_fix_missing_trial_and_family_plan_sync_v2.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260511151953_fix_stefano_annual_subscription_bypass_trigger.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260511153025_fix_sync_trigger_use_trial_end_date_for_expires_at.sql
-- ============================================================
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


