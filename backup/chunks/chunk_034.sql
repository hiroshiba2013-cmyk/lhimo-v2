-- ============================================================
-- FILE: 20260302205151_fix_handle_new_user_trigger.sql
-- ============================================================
/*
  # Fix handle_new_user trigger to handle admin registration
  
  1. Changes
    - Update handle_new_user function to better extract full_name from metadata
    - Handle both user_metadata and raw_user_meta_data
    - Provide better fallback for full_name (use email if nothing else available)
    
  2. Security
    - Maintains SECURITY DEFINER for proper permissions
    - Preserves ON CONFLICT behavior
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  extracted_full_name text;
BEGIN
  -- Try to extract full_name from metadata (check both locations)
  extracted_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'fullName',
    split_part(NEW.email, '@', 1) -- Fallback to email username
  );
  
  -- Ensure we have a non-empty string
  IF extracted_full_name = '' OR extracted_full_name IS NULL THEN
    extracted_full_name := split_part(NEW.email, '@', 1);
  END IF;

  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    extracted_full_name,
    'user', -- Default to user type, will be updated by admin registration function
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;


-- ============================================================
-- FILE: 20260302205511_fix_handle_new_user_use_customer_type.sql
-- ============================================================
/*
  # Fix handle_new_user trigger to use correct user_type
  
  1. Changes
    - Change default user_type from 'user' to 'customer' (valid according to CHECK constraint)
    - This will fix the "Database error creating new user" issue
    
  2. Security
    - Maintains SECURITY DEFINER for proper permissions
    - Preserves all other functionality
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  extracted_full_name text;
BEGIN
  -- Try to extract full_name from metadata (check both locations)
  extracted_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'fullName',
    split_part(NEW.email, '@', 1) -- Fallback to email username
  );
  
  -- Ensure we have a non-empty string
  IF extracted_full_name = '' OR extracted_full_name IS NULL THEN
    extracted_full_name := split_part(NEW.email, '@', 1);
  END IF;

  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    extracted_full_name,
    'customer', -- Changed from 'user' to 'customer' to match CHECK constraint
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;


-- ============================================================
-- FILE: 20260303084527_create_charity_organizations_table.sql
-- ============================================================
/*
  # Create Charity Organizations Table

  1. New Tables
    - `charity_organizations`
      - `id` (uuid, primary key)
      - `name` (text) - Nome dell'organizzazione
      - `description` (text) - Descrizione dell'organizzazione
      - `category` (text) - Categoria (no-profit, beneficenza, sociale, etc)
      - `website` (text) - Sito web
      - `logo_url` (text) - Logo dell'organizzazione
      - `contact_email` (text) - Email di contatto
      - `contact_phone` (text) - Telefono di contatto
      - `address` (text) - Indirizzo
      - `is_active` (boolean) - Attiva o meno
      - `total_received` (numeric) - Totale ricevuto
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS
    - Public can view active organizations
    - Only admins can manage organizations
*/

-- Create charity_organizations table
CREATE TABLE IF NOT EXISTS charity_organizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  category text NOT NULL DEFAULT 'no-profit',
  website text,
  logo_url text,
  contact_email text,
  contact_phone text,
  address text,
  is_active boolean DEFAULT true,
  total_received numeric(10, 2) DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_charity_organizations_active ON charity_organizations(is_active);
CREATE INDEX IF NOT EXISTS idx_charity_organizations_category ON charity_organizations(category);

-- Enable RLS
ALTER TABLE charity_organizations ENABLE ROW LEVEL SECURITY;

-- Public can view active organizations
CREATE POLICY "Public can view active charity organizations"
  ON charity_organizations
  FOR SELECT
  TO public
  USING (is_active = true);

-- Admins can insert organizations
CREATE POLICY "Admins can insert charity organizations"
  ON charity_organizations
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );

-- Admins can update organizations
CREATE POLICY "Admins can update charity organizations"
  ON charity_organizations
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );

-- Admins can delete organizations
CREATE POLICY "Admins can delete charity organizations"
  ON charity_organizations
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_charity_organizations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER charity_organizations_updated_at
  BEFORE UPDATE ON charity_organizations
  FOR EACH ROW
  EXECUTE FUNCTION update_charity_organizations_updated_at();


-- ============================================================
-- FILE: 20260303085754_add_avatar_and_nickname_to_admins.sql
-- ============================================================
/*
  # Add Avatar and Nickname to Admin Profiles

  1. Changes
    - Add avatar_url field to admins table
    - Add nickname field to admins table
    - Allow admins to update their own profile fields

  2. Security
    - Admins can update their own avatar and nickname
    - Public can view admin avatars and nicknames (for display purposes)
*/

-- Add avatar_url and nickname to admins table
ALTER TABLE admins ADD COLUMN IF NOT EXISTS avatar_url text;
ALTER TABLE admins ADD COLUMN IF NOT EXISTS nickname text;

-- Update RLS policies to allow admins to update their own profile
DROP POLICY IF EXISTS "Admins can update own profile" ON admins;
CREATE POLICY "Admins can update own profile"
  ON admins FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());


-- ============================================================
-- FILE: 20260303151023_add_auto_trial_for_customer_registration.sql
-- ============================================================
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

-- ============================================================
-- FILE: 20260303153219_fix_trial_trigger_use_customer_id.sql
-- ============================================================
/*
  # Fix Trial Trigger to Use customer_id

  1. Cambiamenti
    - Corregge il trigger per usare customer_id invece di user_id
    - Questo risolve il problema del caricamento subscription nella dashboard

  2. Sicurezza
    - Mantiene SECURITY DEFINER per le stesse funzionalità
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
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Non bloccare la registrazione se c'è un errore
    RETURN NEW;
END;
$$;

-- ============================================================
-- FILE: 20260303153729_fix_trial_trigger_use_max_persons.sql
-- ============================================================
/*
  # Fix Trial Trigger to Use max_persons

  1. Cambiamenti
    - Corregge il trigger per usare max_persons invece di max_people
    - Questo risolve il problema della creazione subscription

  2. Sicurezza
    - Mantiene SECURITY DEFINER per le stesse funzionalità
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
  WHERE max_persons = 1
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

-- ============================================================
-- FILE: 20260303155448_fix_reviews_rls_unclaimed_businesses.sql
-- ============================================================
/*
  # Fix Reviews RLS Policy for Unclaimed Businesses

  1. Changes
    - Drop old INSERT policy that doesn't handle unclaimed businesses
    - Create new INSERT policy that includes unclaimed_business_location_id
    - Allows customers and family members to create reviews for all business types including unclaimed
  
  2. Security
    - Customer must be authenticated
    - Customer must own the customer_id
    - If family_member_id is provided, it must belong to the customer
    - Review must have exactly one business reference (business_id, imported_business_id, user_added_business_id, OR unclaimed_business_location_id)
*/

-- Drop the old restrictive policy
DROP POLICY IF EXISTS "Customers and family members can create reviews" ON reviews;

-- Create new comprehensive policy that includes unclaimed businesses
CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    -- Must be the customer creating the review
    customer_id = auth.uid()
    AND
    -- If family_member_id is provided, it must belong to this customer
    (
      family_member_id IS NULL
      OR
      EXISTS (
        SELECT 1
        FROM customer_family_members
        WHERE customer_family_members.id = reviews.family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
    AND
    -- Must reference exactly one type of business
    (
      (business_type = 'imported' AND imported_business_id IS NOT NULL)
      OR
      (business_type = 'user_added' AND user_added_business_id IS NOT NULL)
      OR
      (business_type = 'registered' AND business_id IS NOT NULL)
      OR
      (unclaimed_business_location_id IS NOT NULL)
    )
  );


-- ============================================================
-- FILE: 20260303161627_fix_review_points_remove_obsolete_trigger.sql
-- ============================================================
/*
  # Fix Review Points System - Remove Obsolete Trigger

  1. Changes
    - Remove obsolete trigger that assigns points on review INSERT
    - Points should only be awarded when review is APPROVED by staff
    - This ensures correct point values: 25 for basic, 50 with proof

  2. Notes
    - The old trigger awarded 10 points immediately on insert
    - This conflicted with the approval system that awards 25-50 points
    - After this fix, all points are awarded during review approval only
*/

-- Drop the obsolete trigger that awards points on review insert
DROP TRIGGER IF EXISTS trigger_update_user_activity_on_review ON reviews;

-- Drop the obsolete function
DROP FUNCTION IF EXISTS update_user_activity();

-- Sync existing user activity to fix any incorrect point values
-- This recalculates points based on approved reviews only
UPDATE user_activity ua
SET 
  total_points = COALESCE((
    SELECT SUM(r.points_awarded)
    FROM reviews r
    WHERE r.customer_id = ua.user_id 
      AND r.review_status = 'approved'
  ), 0),
  reviews_count = COALESCE((
    SELECT COUNT(*)
    FROM reviews r
    WHERE r.customer_id = ua.user_id 
      AND r.review_status = 'approved'
  ), 0);


-- ============================================================
-- FILE: 20260303162934_fix_favorite_businesses_trigger_remove_job_seeker.sql
-- ============================================================
/*
  # Fix favorite_businesses trigger - remove job_seeker_id reference

  1. Changes
    - Update notify_favorite_created function to remove references to job_seeker_id
    - The favorite_businesses table doesn't have a job_seeker_id column
    - Keep only business-related notifications

  2. Notes
    - Job seeker favorites should be handled in a separate table if needed
    - This fixes the error: record "new" has no field "job_seeker_id"
*/

-- Update the notification trigger to only handle businesses
CREATE OR REPLACE FUNCTION notify_favorite_created()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
  v_business_owner_id uuid;
  v_favoriter_name text;
  v_location_name text;
  v_location_owner_id uuid;
BEGIN
  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.nickname, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Check if it's a legacy business favorite (old structure)
  IF NEW.business_id IS NOT NULL THEN
    SELECT b.name, b.owner_id
    INTO v_business_name, v_business_owner_id
    FROM businesses b
    WHERE b.id = NEW.business_id;

    IF v_business_owner_id IS NOT NULL AND v_business_owner_id != NEW.user_id THEN
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        v_business_owner_id,
        'business_favorited',
        'Attività aggiunta ai preferiti',
        format('La tua attività "%s" è stata aggiunta ai preferiti da %s', v_business_name, v_favoriter_name),
        jsonb_build_object(
          'business_id', NEW.business_id,
          'favorited_by', NEW.user_id,
          'url', '/business/' || NEW.business_id
        )
      );
    END IF;
  END IF;

  -- Check if it's a claimed business location favorite (new structure)
  IF NEW.business_location_id IS NOT NULL THEN
    SELECT bl.internal_name, bl.owner_id
    INTO v_location_name, v_location_owner_id
    FROM business_locations bl
    WHERE bl.id = NEW.business_location_id;

    IF v_location_owner_id IS NOT NULL AND v_location_owner_id != NEW.user_id THEN
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        v_location_owner_id,
        'business_favorited',
        'Attività aggiunta ai preferiti',
        format('La tua attività "%s" è stata aggiunta ai preferiti da %s', COALESCE(v_location_name, 'Sede'), v_favoriter_name),
        jsonb_build_object(
          'business_location_id', NEW.business_location_id,
          'favorited_by', NEW.user_id,
          'url', '/business/' || NEW.business_location_id
        )
      );
    END IF;
  END IF;

  -- For unclaimed businesses, no notification is sent (no owner to notify)

  RETURN NEW;
END;
$$;


-- ============================================================
-- FILE: 20260303213406_subtract_points_on_delete.sql
-- ============================================================
/*
  # Sottrai Punti quando Attività o Annunci vengono Eliminati

  ## Panoramica
  Aggiunge trigger per sottrarre automaticamente i punti dalla classifica quando:
  - Un annuncio classificato viene eliminato (sottrae 5 punti)
  - Un'attività unclaimed viene eliminata (sottrae 10-25 punti in base ai dati)

  ## Modifiche
  1. Crea funzione per sottrarre punti quando un annuncio classificato viene eliminato
  2. Crea trigger per annunci classificati eliminati
  3. Crea funzione per sottrarre punti quando un'attività unclaimed viene eliminata
  4. Crea trigger per attività unclaimed eliminate

  ## Note
  - I punti vengono sottratti automaticamente per mantenere la classifica accurata
  - Gli annunci danno 5 punti, quindi vengono sottratti 5 punti
  - Le attività danno 10 punti (base) o 25 punti (con email/telefono)
*/

-- Funzione per sottrarre punti quando viene eliminato un annuncio classificato
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_classified_ad()
RETURNS TRIGGER AS $$
BEGIN
  -- Sottrai 5 punti al proprietario dell'annuncio
  PERFORM award_points(OLD.user_id, -5, 'classified_ad_deleted', OLD.id::text);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per annunci classificati eliminati
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_classified_ad ON classified_ads;
CREATE TRIGGER trigger_subtract_points_deleted_classified_ad
  BEFORE DELETE ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_classified_ad();

-- Funzione per sottrarre punti quando viene eliminata un'attività unclaimed
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_unclaimed_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
BEGIN
  -- Calcola i punti in base ai dati presenti
  IF (OLD.email IS NOT NULL AND OLD.email != '') OR (OLD.phone IS NOT NULL AND OLD.phone != '') THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  -- Sottrai i punti all'utente che ha aggiunto l'attività
  PERFORM award_points(OLD.added_by, -points_to_subtract, 'business_deleted', OLD.id::text);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per attività unclaimed eliminate
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_unclaimed_business ON unclaimed_business_locations;
CREATE TRIGGER trigger_subtract_points_deleted_unclaimed_business
  BEFORE DELETE ON unclaimed_business_locations
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_unclaimed_business();


-- ============================================================
-- FILE: 20260303213436_subtract_points_on_review_delete.sql
-- ============================================================
/*
  # Sottrai Punti quando Recensioni vengono Eliminate

  ## Panoramica
  Aggiunge trigger per sottrarre automaticamente i punti dalla classifica quando una recensione viene eliminata.
  - Recensione con prova: 50 punti
  - Recensione senza prova: 25 punti

  ## Modifiche
  1. Crea funzione per sottrarre punti quando una recensione viene eliminata
  2. Crea trigger per recensioni eliminate

  ## Note
  - I punti vengono sottratti automaticamente per mantenere la classifica accurata
  - Controlla se la recensione aveva una prova (proof_url) per determinare i punti da sottrarre
*/

-- Funzione per sottrarre punti quando viene eliminata una recensione
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_review()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
BEGIN
  -- Calcola i punti in base alla presenza di prova
  IF OLD.proof_url IS NOT NULL AND OLD.proof_url != '' THEN
    points_to_subtract := 50;
  ELSE
    points_to_subtract := 25;
  END IF;

  -- Sottrai i punti all'utente che ha scritto la recensione
  PERFORM award_points(OLD.customer_id, -points_to_subtract, 'review_deleted', OLD.id::text);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per recensioni eliminate
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_review ON reviews;
CREATE TRIGGER trigger_subtract_points_deleted_review
  BEFORE DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_review();


