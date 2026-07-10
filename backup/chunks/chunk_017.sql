-- ============================================================
-- FILE: 20251229175405_create_notifications_and_reports_system.sql
-- ============================================================
/*
  # Create Notifications and Reports System

  1. New Tables
    - `notifications`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles)
      - `type` (text) - notification type (review, message, job_request, etc.)
      - `title` (text) - notification title
      - `message` (text) - notification content
      - `data` (jsonb) - additional data (entity_id, etc.)
      - `read` (boolean) - read status
      - `created_at` (timestamptz)
    
    - `reports`
      - `id` (uuid, primary key)
      - `reporter_id` (uuid, references profiles)
      - `reported_entity_type` (text) - type of entity (review, business, classified_ad, etc.)
      - `reported_entity_id` (uuid) - ID of reported entity
      - `reason` (text) - report reason
      - `description` (text) - detailed description
      - `status` (text) - pending, reviewed, resolved, dismissed
      - `reviewed_by` (uuid, references profiles, nullable)
      - `reviewed_at` (timestamptz, nullable)
      - `resolution_notes` (text, nullable)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Users can view their own notifications
    - Users can create reports
    - Users can view their own reports
    - Admin access for reviewing reports
*/

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type text NOT NULL,
  title text NOT NULL,
  message text NOT NULL,
  data jsonb DEFAULT '{}',
  read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create reports table
CREATE TABLE IF NOT EXISTS reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reported_entity_type text NOT NULL,
  reported_entity_id uuid NOT NULL,
  reason text NOT NULL,
  description text,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
  reviewed_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  reviewed_at timestamptz,
  resolution_notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(user_id, read);

CREATE INDEX IF NOT EXISTS idx_reports_reporter_id ON reports(reporter_id);
CREATE INDEX IF NOT EXISTS idx_reports_status ON reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_entity ON reports(reported_entity_type, reported_entity_id);
CREATE INDEX IF NOT EXISTS idx_reports_created_at ON reports(created_at DESC);

-- Enable RLS
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Notifications policies
CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "System can create notifications"
  ON notifications FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own notifications"
  ON notifications FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Reports policies
CREATE POLICY "Users can view own reports"
  ON reports FOR SELECT
  TO authenticated
  USING (auth.uid() = reporter_id OR auth.uid() = reviewed_by);

CREATE POLICY "Authenticated users can create reports"
  ON reports FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "Reviewers can update reports"
  ON reports FOR UPDATE
  TO authenticated
  USING (auth.uid() = reviewed_by)
  WITH CHECK (auth.uid() = reviewed_by);

-- Create function to mark notification as read
CREATE OR REPLACE FUNCTION mark_notification_read(notification_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE notifications
  SET read = true
  WHERE id = notification_id AND user_id = auth.uid();
END;
$$;

-- Create function to mark all notifications as read
CREATE OR REPLACE FUNCTION mark_all_notifications_read()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE notifications
  SET read = true
  WHERE user_id = auth.uid() AND read = false;
END;
$$;

-- Create function to get unread notification count
CREATE OR REPLACE FUNCTION get_unread_notification_count()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  count integer;
BEGIN
  SELECT COUNT(*)::integer INTO count
  FROM notifications
  WHERE user_id = auth.uid() AND read = false;
  
  RETURN count;
END;
$$;

-- Create trigger to update reports updated_at
CREATE OR REPLACE FUNCTION update_reports_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_update_reports_updated_at
  BEFORE UPDATE ON reports
  FOR EACH ROW
  EXECUTE FUNCTION update_reports_updated_at();

-- ============================================================
-- FILE: 20251229221503_add_referral_system.sql
-- ============================================================
/*
  # Sistema Referral "Ti presenta un amico?"

  1. Modifiche
    - Aggiunge colonna `referred_by_nickname` alla tabella `profiles`
    - Aggiunge colonna `referral_count` alla tabella `profiles`
    - Crea funzione `process_referral` per elaborare i referral
    - Assegna automaticamente 30 punti all'utente che ha invitato

  2. Funzionalità
    - Quando un nuovo utente si registra con un nickname referral:
      - Verifica che il nickname esista
      - Salva il nickname nella colonna `referred_by_nickname`
      - Incrementa il contatore `referral_count` dell'utente che ha invitato
      - Assegna 30 punti automaticamente tramite la funzione `award_points`
*/

-- Aggiungi colonne per il sistema referral
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'referred_by_nickname'
  ) THEN
    ALTER TABLE profiles ADD COLUMN referred_by_nickname text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'referral_count'
  ) THEN
    ALTER TABLE profiles ADD COLUMN referral_count integer DEFAULT 0 NOT NULL;
  END IF;
END $$;

-- Elimina la funzione esistente se presente
DROP FUNCTION IF EXISTS process_referral(uuid, text);

-- Crea funzione per elaborare il referral
CREATE OR REPLACE FUNCTION process_referral(
  p_new_user_id uuid,
  p_referrer_nickname text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_referrer_id uuid;
BEGIN
  -- Trova l'ID dell'utente che ha invitato tramite nickname
  SELECT id INTO v_referrer_id
  FROM profiles
  WHERE nickname = p_referrer_nickname
  LIMIT 1;

  -- Se il referrer esiste
  IF v_referrer_id IS NOT NULL THEN
    -- Salva il nickname del referrer nel profilo del nuovo utente
    UPDATE profiles
    SET referred_by_nickname = p_referrer_nickname
    WHERE id = p_new_user_id;

    -- Incrementa il contatore di referral del referrer
    UPDATE profiles
    SET referral_count = referral_count + 1
    WHERE id = v_referrer_id;

    -- Assegna 30 punti al referrer usando la funzione esistente
    PERFORM award_points(
      v_referrer_id,
      30,
      'referral',
      'Nuovo amico registrato: ' || (SELECT nickname FROM profiles WHERE id = p_new_user_id)
    );
  END IF;
END;
$$;

-- ============================================================
-- FILE: 20251230104707_add_delete_account_function.sql
-- ============================================================
/*
  # Funzione per Eliminare Account Utente

  1. Nuove Funzioni
    - `delete_user_account()` - Funzione che elimina l'account utente e tutti i dati associati
  
  2. Cosa Viene Eliminato
    - Recensioni dell'utente (reviews)
    - Annunci classificati (classified_ads)
    - Membri della famiglia (customer_family_members)
    - Attività utente (user_activity)
    - Sconti creati dall'azienda (discounts)
    - Annunci di lavoro dell'azienda (job_postings)
    - Azienda e sedi (businesses, business_locations)
    - Richieste di lavoro (job_requests)
    - Messaggi (classified_ad_messages, job_seeker_messages)
    - Segnalazioni (content_reports)
    - Notifiche (notifications)
    - Referral (referrals come referrer e come referee)
    - Abbonamenti (business_subscriptions, user_subscriptions)
    - Profilo (profiles)
    - Account auth (auth.users)

  3. Sicurezza
    - La funzione può essere eseguita solo dall'utente proprietario dell'account
    - Tutti i dati vengono eliminati in modo irreversibile
*/

-- Funzione per eliminare l'account utente e tutti i dati associati
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina gli annunci classificati e i messaggi associati
  DELETE FROM classified_ad_messages WHERE ad_id IN (
    SELECT id FROM classified_ads WHERE user_id = user_profile_id
  );
  DELETE FROM classified_ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_seeker_messages WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina i job seekers
    DELETE FROM job_seekers WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina gli abbonamenti business
    DELETE FROM business_subscriptions WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM content_reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina i referral (sia come referrer che come referee)
  DELETE FROM referrals WHERE referrer_id = user_profile_id OR referee_id = user_profile_id;

  -- Elimina gli abbonamenti utente
  DELETE FROM user_subscriptions WHERE user_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20251230173006_create_favorites_system.sql
-- ============================================================
/*
  # Create Favorites System

  1. New Tables
    - `favorite_businesses`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `business_id` (uuid, references business_locations)
      - `created_at` (timestamptz)
      - Unique constraint on (user_id, family_member_id, business_id)
    
    - `favorite_classified_ads`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `ad_id` (uuid, references classified_ads)
      - `created_at` (timestamptz)
      - Unique constraint on (user_id, family_member_id, ad_id)
    
    - `favorite_job_postings`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `job_id` (uuid, references job_postings)
      - `created_at` (timestamptz)
      - Unique constraint on (user_id, family_member_id, job_id)

  2. Security
    - Enable RLS on all tables
    - Users can manage their own favorites
    - Users can view favorites count for businesses/ads/jobs

  3. Important Notes
    - Each user can favorite the same item once (as themselves)
    - Each family member can favorite the same item once (separately from main user)
    - The combination of user_id + family_member_id + item_id must be unique
*/

-- Create favorite_businesses table
CREATE TABLE IF NOT EXISTS favorite_businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  business_id uuid NOT NULL REFERENCES business_locations(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create unique constraint that treats NULL family_member_id properly
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_business_user 
  ON favorite_businesses(user_id, business_id) 
  WHERE family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_business_family 
  ON favorite_businesses(user_id, family_member_id, business_id) 
  WHERE family_member_id IS NOT NULL;

-- Create favorite_classified_ads table
CREATE TABLE IF NOT EXISTS favorite_classified_ads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  ad_id uuid NOT NULL REFERENCES classified_ads(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create unique constraint for ads
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_ad_user 
  ON favorite_classified_ads(user_id, ad_id) 
  WHERE family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_ad_family 
  ON favorite_classified_ads(user_id, family_member_id, ad_id) 
  WHERE family_member_id IS NOT NULL;

-- Create favorite_job_postings table
CREATE TABLE IF NOT EXISTS favorite_job_postings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  job_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

-- Create unique constraint for jobs
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_job_user 
  ON favorite_job_postings(user_id, job_id) 
  WHERE family_member_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_favorite_job_family 
  ON favorite_job_postings(user_id, family_member_id, job_id) 
  WHERE family_member_id IS NOT NULL;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_user ON favorite_businesses(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_family ON favorite_businesses(family_member_id);
CREATE INDEX IF NOT EXISTS idx_favorite_businesses_business ON favorite_businesses(business_id);

CREATE INDEX IF NOT EXISTS idx_favorite_ads_user ON favorite_classified_ads(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_ads_family ON favorite_classified_ads(family_member_id);
CREATE INDEX IF NOT EXISTS idx_favorite_ads_ad ON favorite_classified_ads(ad_id);

CREATE INDEX IF NOT EXISTS idx_favorite_jobs_user ON favorite_job_postings(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_jobs_family ON favorite_job_postings(family_member_id);
CREATE INDEX IF NOT EXISTS idx_favorite_jobs_job ON favorite_job_postings(job_id);

-- Enable RLS
ALTER TABLE favorite_businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_classified_ads ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_job_postings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for favorite_businesses

CREATE POLICY "Users can view their own favorite businesses"
  ON favorite_businesses FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorite businesses"
  ON favorite_businesses FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id 
    AND (
      family_member_id IS NULL 
      OR EXISTS (
        SELECT 1 FROM customer_family_members 
        WHERE id = family_member_id 
        AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can remove their own favorite businesses"
  ON favorite_businesses FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies for favorite_classified_ads

CREATE POLICY "Users can view their own favorite ads"
  ON favorite_classified_ads FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorite ads"
  ON favorite_classified_ads FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id 
    AND (
      family_member_id IS NULL 
      OR EXISTS (
        SELECT 1 FROM customer_family_members 
        WHERE id = family_member_id 
        AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can remove their own favorite ads"
  ON favorite_classified_ads FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies for favorite_job_postings

CREATE POLICY "Users can view their own favorite jobs"
  ON favorite_job_postings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorite jobs"
  ON favorite_job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id 
    AND (
      family_member_id IS NULL 
      OR EXISTS (
        SELECT 1 FROM customer_family_members 
        WHERE id = family_member_id 
        AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can remove their own favorite jobs"
  ON favorite_job_postings FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);


-- ============================================================
-- FILE: 20260104091224_add_get_total_revenue_function.sql
-- ============================================================
/*
  # Funzione per calcolare il fatturato totale

  ## Descrizione

  Crea una funzione SQL che calcola il fatturato totale dalla somma di tutti gli abbonamenti,
  senza esporre i dati sensibili delle singole sottoscrizioni.

  ## Nuova Funzione

  - `get_total_revenue()` - Restituisce il fatturato totale come numero decimale
    - Somma tutti i prezzi dai piani delle sottoscrizioni attive
    - Non richiede autenticazione (pubblica)
    - Restituisce solo il totale aggregato, non dati individuali

  ## Sicurezza

  - La funzione è SECURITY DEFINER per bypassare le policy RLS
  - Restituisce solo dati aggregati, non espone informazioni individuali
  - Accessibile pubblicamente per mostrare i contatori sulla pagina solidarietà
*/

-- Crea funzione per calcolare il fatturato totale
CREATE OR REPLACE FUNCTION get_total_revenue()
RETURNS decimal(12, 2)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  total_revenue decimal(12, 2);
BEGIN
  -- Somma tutti i prezzi dai piani delle sottoscrizioni
  SELECT COALESCE(SUM(sp.price), 0)
  INTO total_revenue
  FROM subscriptions s
  INNER JOIN subscription_plans sp ON s.plan_id = sp.id;

  RETURN total_revenue;
END;
$$;

-- Permetti a tutti di eseguire questa funzione
GRANT EXECUTE ON FUNCTION get_total_revenue() TO anon, authenticated;


-- ============================================================
-- FILE: 20260104104442_update_subscription_plans_remove_plus.sql
-- ============================================================
/*
  # Rimozione del "+" dai piani abbonamento da 4 persone/sedi

  ## Descrizione

  Aggiorna i nomi dei piani abbonamento per rimuovere il simbolo "+" dal piano per 4 persone/sedi.
  Questo rende i nomi più puliti e coerenti.

  ## Modifiche

  - Piano Mensile - 4+ Persone → Piano Mensile - 4 Persone
  - Piano Annuale - 4+ Persone → Piano Annuale - 4 Persone
  - Piano Business Mensile - 4+ Punti Vendita → Piano Business Mensile - 4 Punti Vendita
  - Piano Business Annuale - 4+ Punti Vendita → Piano Business Annuale - 4 Punti Vendita

  ## Note

  - I prezzi e le altre impostazioni rimangono invariati
  - Solo i nomi vengono aggiornati per una migliore visualizzazione
*/

-- Aggiorna i piani per privati
UPDATE subscription_plans
SET name = 'Piano Mensile - 4 Persone'
WHERE name = 'Piano Mensile - 4+ Persone';

UPDATE subscription_plans
SET name = 'Piano Annuale - 4 Persone'
WHERE name = 'Piano Annuale - 4+ Persone';

-- Aggiorna i piani per business
UPDATE subscription_plans
SET name = 'Piano Business Mensile - 4 Punti Vendita'
WHERE name = 'Piano Business Mensile - 4+ Punti Vendita';

UPDATE subscription_plans
SET name = 'Piano Business Annuale - 4 Punti Vendita'
WHERE name = 'Piano Business Annuale - 4+ Punti Vendita';


