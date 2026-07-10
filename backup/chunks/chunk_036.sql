-- ============================================================
-- FILE: 20260303220701_fix_subscription_stats_use_plan_name.sql
-- ============================================================
/*
  # Correzione Statistiche Abbonamenti - Usa Nome Piano

  ## Problema
  La funzione `get_subscription_stats` cercava di usare `sp.user_type` che non esiste.
  I piani si distinguono dal nome: quelli con "Business" sono per aziende.

  ## Soluzione
  Usa il nome del piano per distinguere tra piani business e customer:
  - Business: name LIKE '%Business%'
  - Customer: name NOT LIKE '%Business%'
*/

-- ========================================
-- FUNZIONE CORRETTA: get_subscription_stats
-- ========================================

CREATE OR REPLACE FUNCTION get_subscription_stats()
RETURNS JSONB AS $$
DECLARE
  stats JSONB;
BEGIN
  SELECT jsonb_build_object(
    'totalActive',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active'
    ),
    'customerMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name NOT LIKE '%Business%'
        AND sp.billing_period = 'monthly'
    ),
    'customerYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name NOT LIKE '%Business%'
        AND sp.billing_period = 'yearly'
    ),
    'businessMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name LIKE '%Business%'
        AND sp.billing_period = 'monthly'
    ),
    'businessYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name LIKE '%Business%'
        AND sp.billing_period = 'yearly'
    ),
    'trialUsers',
    (
      SELECT COUNT(*)
      FROM subscriptions
      WHERE status = 'trial'
    )
  ) INTO stats;

  RETURN stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260303221122_add_location_columns_to_job_seekers.sql
-- ============================================================
/*
  # Aggiunta Colonne Localizzazione a Job Seekers

  ## Problema
  La tabella job_seekers manca delle colonne region, province, city che vengono
  usate per filtrare nella pagina Lavoro. Questo causa errori silenziosi e gli
  annunci non vengono visualizzati correttamente.

  ## Soluzione
  Aggiungere le colonne:
  - region (regione)
  - province (provincia) 
  - city (città)
  
  E popolare i dati esistenti dalla colonna location.
*/

-- Aggiungi le colonne di localizzazione
ALTER TABLE job_seekers
ADD COLUMN IF NOT EXISTS region TEXT,
ADD COLUMN IF NOT EXISTS province TEXT,
ADD COLUMN IF NOT EXISTS city TEXT;

-- Popola la colonna city con i dati esistenti da location
UPDATE job_seekers
SET city = location
WHERE city IS NULL AND location IS NOT NULL;

-- Commento
COMMENT ON COLUMN job_seekers.region IS 'Regione dove si cerca lavoro';
COMMENT ON COLUMN job_seekers.province IS 'Provincia dove si cerca lavoro';
COMMENT ON COLUMN job_seekers.city IS 'Città dove si cerca lavoro';


-- ============================================================
-- FILE: 20260303221817_fix_job_seekers_user_id_foreign_key.sql
-- ============================================================
/*
  # Fix job_seekers foreign key to profiles

  1. Changes
    - Add missing foreign key constraint from job_seekers.user_id to profiles.id
    - This allows Supabase to properly join job_seekers with profiles table
  
  2. Security
    - No changes to RLS policies
*/

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE constraint_name = 'job_seekers_user_id_fkey'
    AND table_name = 'job_seekers'
  ) THEN
    ALTER TABLE job_seekers
    ADD CONSTRAINT job_seekers_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES profiles(id)
    ON DELETE CASCADE;
  END IF;
END $$;

-- Add index for better performance
CREATE INDEX IF NOT EXISTS idx_job_seekers_user_id ON job_seekers(user_id);


-- ============================================================
-- FILE: 20260303223032_fix_unclaimed_business_delete_rls.sql
-- ============================================================
/*
  # Fix Unclaimed Business Locations Delete RLS Policy

  1. Changes
    - Update DELETE policy to also allow admins
    - Ensure users can always delete their own added businesses
    - Add better error handling for edge cases

  2. Security
    - Maintain user ownership checks
    - Add admin override capability
*/

-- Drop existing policy
DROP POLICY IF EXISTS "Users can delete own added businesses" ON unclaimed_business_locations;

-- Recreate with admin support
CREATE POLICY "Users can delete own added businesses"
  ON unclaimed_business_locations
  FOR DELETE
  TO authenticated
  USING (
    -- Allow if user added it directly
    added_by = auth.uid()
    OR
    -- Allow if user added it via family member
    added_by_family_member_id IN (
      SELECT id FROM customer_family_members
      WHERE customer_id = auth.uid()
    )
    OR
    -- Allow admins
    EXISTS (
      SELECT 1 FROM admins
      WHERE user_id = auth.uid()
    )
  );


-- ============================================================
-- FILE: 20260304211704_add_review_uniqueness_constraints.sql
-- ============================================================
/*
  # Add Review Uniqueness Constraints

  1. Overview
    - Prevents duplicate reviews for the same business by the same profile
    - Each user (owner or family member) can review a business only once per 365 days
    - Multiple family members can review the same business independently

  2. Changes
    - Add unique partial indexes for each business type (registered, imported, user_added, unclaimed)
    - Each index ensures customer_id + family_member_id + business_id combination is unique
    - Separate indexes for owner reviews (family_member_id IS NULL) and family member reviews

  3. Notes
    - After 365 days, the frontend will delete the old review before creating a new one
    - This constraint prevents accidental duplicates at the database level
*/

-- Unique constraint for registered businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_registered_owner_unique
ON reviews (customer_id, business_id)
WHERE business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for registered businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_registered_family_unique
ON reviews (customer_id, family_member_id, business_id)
WHERE business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique constraint for imported businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_imported_owner_unique
ON reviews (customer_id, imported_business_id)
WHERE imported_business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for imported businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_imported_family_unique
ON reviews (customer_id, family_member_id, imported_business_id)
WHERE imported_business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique constraint for user_added businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_user_added_owner_unique
ON reviews (customer_id, user_added_business_id)
WHERE user_added_business_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for user_added businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_user_added_family_unique
ON reviews (customer_id, family_member_id, user_added_business_id)
WHERE user_added_business_id IS NOT NULL AND family_member_id IS NOT NULL;

-- Unique constraint for unclaimed businesses - owner reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_unclaimed_owner_unique
ON reviews (customer_id, unclaimed_business_location_id)
WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NULL;

-- Unique constraint for unclaimed businesses - family member reviews
CREATE UNIQUE INDEX IF NOT EXISTS reviews_unclaimed_family_unique
ON reviews (customer_id, family_member_id, unclaimed_business_location_id)
WHERE unclaimed_business_location_id IS NOT NULL AND family_member_id IS NOT NULL;


-- ============================================================
-- FILE: 20260305205607_add_missing_user_activity_columns.sql
-- ============================================================
/*
  # Add missing columns to user_activity table

  1. Changes
    - Add ads_count column to track classified ads
    - Add job_postings_count column to track job postings
    - Add referrals_count column to track referrals
    - Add function to populate existing user data
    - Add admin access policy for user_activity

  2. Notes
    - Populates data for existing users based on their activities
    - Creates indexes for performance
*/

-- Add missing columns to user_activity
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'ads_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN ads_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'job_postings_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN job_postings_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'referrals_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN referrals_count integer DEFAULT 0;
  END IF;
END $$;

-- Add admin policy for user_activity
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'user_activity' 
    AND policyname = 'Admins can view all user activity'
  ) THEN
    CREATE POLICY "Admins can view all user activity"
      ON user_activity FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admins
          WHERE admins.user_id = auth.uid()
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'user_activity' 
    AND policyname = 'Admins can update all user activity'
  ) THEN
    CREATE POLICY "Admins can update all user activity"
      ON user_activity FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admins
          WHERE admins.user_id = auth.uid()
        )
      )
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM admins
          WHERE admins.user_id = auth.uid()
        )
      );
  END IF;
END $$;

-- Function to populate user_activity for existing users
CREATE OR REPLACE FUNCTION populate_user_activity()
RETURNS void AS $$
DECLARE
  user_record RECORD;
  reviews_cnt INTEGER;
  ads_cnt INTEGER;
  jobs_cnt INTEGER;
  referrals_cnt INTEGER;
  points INTEGER;
BEGIN
  -- Iterate through all profiles
  FOR user_record IN
    SELECT id, referral_count FROM profiles WHERE user_type IN ('customer', 'business')
  LOOP
    -- Count reviews
    SELECT COUNT(*) INTO reviews_cnt
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    -- Count classified ads
    SELECT COUNT(*) INTO ads_cnt
    FROM classified_ads
    WHERE user_id = user_record.id AND status = 'active';

    -- Count job seekers
    SELECT COUNT(*) INTO jobs_cnt
    FROM job_seekers
    WHERE user_id = user_record.id AND status = 'active';

    -- Get referrals from profile
    referrals_cnt := COALESCE(user_record.referral_count, 0);

    -- Calculate points:
    -- Reviews with proof = 50 points
    -- Reviews without proof = 25 points
    -- Classified ads = 10 points
    -- Referrals = 100 points (from referral_count in profiles)
    SELECT
      COALESCE(SUM(
        CASE
          WHEN proof_image_url IS NOT NULL THEN 50
          ELSE 25
        END
      ), 0) INTO points
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    -- Add points for ads
    points := points + (ads_cnt * 10);

    -- Add points for referrals
    points := points + (referrals_cnt * 100);

    -- Insert or update user_activity
    INSERT INTO user_activity (
      user_id,
      total_points,
      reviews_count,
      ads_count,
      job_postings_count,
      referrals_count,
      last_activity_at,
      updated_at
    )
    VALUES (
      user_record.id,
      points,
      reviews_cnt,
      ads_cnt,
      jobs_cnt,
      referrals_cnt,
      now(),
      now()
    )
    ON CONFLICT (user_id) DO UPDATE SET
      total_points = EXCLUDED.total_points,
      reviews_count = EXCLUDED.reviews_count,
      ads_count = EXCLUDED.ads_count,
      job_postings_count = EXCLUDED.job_postings_count,
      referrals_count = EXCLUDED.referrals_count,
      last_activity_at = now(),
      updated_at = now();
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Execute the population function
SELECT populate_user_activity();

-- Create indexes for new columns
CREATE INDEX IF NOT EXISTS idx_user_activity_ads ON user_activity(ads_count DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_jobs ON user_activity(job_postings_count DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_referrals ON user_activity(referrals_count DESC);


-- ============================================================
-- FILE: 20260305205726_fix_user_activity_rls_for_leaderboard.sql
-- ============================================================
/*
  # Fix user_activity RLS policies for leaderboard

  1. Changes
    - Drop conflicting policies
    - Create single policy that allows all authenticated users to view all activity
    - Maintain admin update permissions

  2. Security
    - All authenticated users can view leaderboard data
    - Only admins can update any activity
    - Users can still update their own activity
*/

-- Drop ALL existing policies for user_activity
DROP POLICY IF EXISTS "Users can view their own activity" ON user_activity;
DROP POLICY IF EXISTS "Users can view all activity for leaderboard" ON user_activity;
DROP POLICY IF EXISTS "Admins can view all user activity" ON user_activity;
DROP POLICY IF EXISTS "System can insert user activity" ON user_activity;
DROP POLICY IF EXISTS "Users can update their own activity" ON user_activity;
DROP POLICY IF EXISTS "Admins can update all user activity" ON user_activity;
DROP POLICY IF EXISTS "Users can insert their own activity" ON user_activity;

-- Create new clear policies
CREATE POLICY "All authenticated users can view leaderboard"
  ON user_activity FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert their own activity"
  ON user_activity FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own activity"
  ON user_activity FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can update any activity"
  ON user_activity FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );


-- ============================================================
-- FILE: 20260305215807_disable_obsolete_points_triggers.sql
-- ============================================================
/*
  # Disabilita Trigger Punti Obsoleti

  ## Panoramica
  Rimuove i trigger che assegnano punti per azioni che non dovrebbero più darli:
  - business_locations (tabella per attività reclamate, non dovrebbe dare punti)
  - products (sistema punti per prodotti è stato disabilitato)

  ## Modifiche
  1. Rimuove trigger per business_locations
  2. Rimuove trigger per products

  ## Note
  I trigger per unclaimed_business_locations e user_added_businesses rimangono attivi
  perché assegnano correttamente i punti (10/25 punti).
*/

-- Rimuovi trigger obsoleti per business_locations
DROP TRIGGER IF EXISTS trigger_award_points_business_location ON business_locations;

-- Rimuovi trigger obsoleti per products
DROP TRIGGER IF EXISTS trigger_award_points_product ON products;

-- Verifica trigger rimanenti (dovrebbero essere solo quelli corretti)
-- Query di verifica (non eseguita, solo per documentazione):
-- SELECT trigger_name, event_object_table
-- FROM information_schema.triggers
-- WHERE trigger_name LIKE '%points%' OR trigger_name LIKE '%award%';


-- ============================================================
-- FILE: 20260305221830_update_approve_review_handle_proof_image_deletion.sql
-- ============================================================
/*
  # Aggiorna funzione approve_review per gestione immagini proof

  ## Panoramica
  Migliora la funzione approve_review per gestire correttamente le immagini di prova:
  - L'immagine viene eliminata dopo approvazione/rifiuto
  - Se l'immagine viene rimossa PRIMA dell'approvazione, assegna 25 punti
  - Se l'immagine è presente durante l'approvazione, assegna 50 punti

  ## Modifiche
  1. La funzione controlla proof_image_url al momento dell'approvazione
  2. Punti: 50 se c'è immagine, 25 se non c'è
  3. L'immagine viene sempre rimossa dopo l'approvazione

  ## Note
  - L'eliminazione fisica del file è gestita dal frontend
  - Il database rimuove solo il riferimento
  - Questo permette di approvare una recensione con prova ma dare solo 25 punti
    (utile quando l'immagine non è valida)
*/

-- Aggiorna la funzione approve_review per gestire correttamente le immagini
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Get review details
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- IMPORTANTE: Controlla proof_image_url AL MOMENTO DELL'APPROVAZIONE
  -- Se il frontend ha già rimosso l'immagine (approveReviewWithoutProof), 
  -- proof_image_url sarà NULL e assegnerà 25 punti
  -- Se l'immagine è ancora presente, assegnerà 50 punti
  IF review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '' THEN
    points_to_award := 50; -- With valid proof of purchase
  ELSE
    points_to_award := 25; -- Without proof or proof rejected
  END IF;
  
  -- Update review status and remove image reference
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Always remove image reference after approval
  WHERE id = review_id_param;
  
  -- Award points to user
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
  
  -- Log activity
  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'review_approved',
    jsonb_build_object(
      'review_id', review_id_param,
      'points_awarded', points_to_award,
      'had_proof', (review_record.proof_image_url IS NOT NULL)
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aggiorna anche la funzione reject_review per eliminare l'immagine
CREATE OR REPLACE FUNCTION reject_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
BEGIN
  -- Get review details
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Update review status and remove image reference
  UPDATE reviews 
  SET review_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = 0,
      proof_image_url = NULL -- Remove image reference on rejection
  WHERE id = review_id_param;
  
  -- Log activity
  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'review_rejected',
    jsonb_build_object(
      'review_id', review_id_param,
      'had_proof', (review_record.proof_image_url IS NOT NULL)
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Commento esplicativo
COMMENT ON FUNCTION approve_review IS 
'Approva una recensione e assegna punti: 50 se c''è prova valida, 25 altrimenti. L''immagine viene sempre rimossa dopo l''approvazione.';

COMMENT ON FUNCTION reject_review IS 
'Rifiuta una recensione e rimuove l''immagine di prova se presente. Non assegna punti.';


-- ============================================================
-- FILE: 20260305222528_create_platform_settings_table_v2.sql
-- ============================================================
/*
  # Crea tabella impostazioni piattaforma

  ## Panoramica
  Tabella per gestire le impostazioni globali della piattaforma inclusi contatti e regole.

  ## Nuove Tabelle
  
  ### `platform_settings`
  - `id` (uuid, primary key)
  - `setting_key` (text, unique) - Chiave univoca per l'impostazione
  - `setting_value` (jsonb) - Valore dell'impostazione in formato JSON
  - `category` (text) - Categoria: 'contact', 'rules', 'general'
  - `description` (text) - Descrizione dell'impostazione
  - `updated_at` (timestamp)
  - `updated_by` (uuid) - Admin che ha fatto l'ultima modifica

  ## Sicurezza
  - RLS abilitato
  - Chiunque può leggere (pubblico)
  - Solo admin possono modificare

  ## Seed Data
  Dati iniziali per contatti e regole della piattaforma
*/

CREATE TABLE IF NOT EXISTS platform_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  setting_key text UNIQUE NOT NULL,
  setting_value jsonb NOT NULL DEFAULT '{}'::jsonb,
  category text NOT NULL CHECK (category IN ('contact', 'rules', 'general')),
  description text,
  updated_at timestamptz DEFAULT now(),
  updated_by uuid REFERENCES profiles(id)
);

-- Indici per performance
CREATE INDEX IF NOT EXISTS idx_platform_settings_category ON platform_settings(category);
CREATE INDEX IF NOT EXISTS idx_platform_settings_key ON platform_settings(setting_key);

-- RLS Policies
ALTER TABLE platform_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view platform settings"
  ON platform_settings FOR SELECT
  TO authenticated, anon
  USING (true);

CREATE POLICY "Only admins can update platform settings"
  ON platform_settings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Only admins can insert platform settings"
  ON platform_settings FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Only admins can delete platform settings"
  ON platform_settings FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Seed data iniziali
INSERT INTO platform_settings (setting_key, setting_value, category, description) VALUES
-- Contatti
('contact_email', '{"value": "info@piattaforma.it"}'::jsonb, 'contact', 'Email di contatto principale'),
('contact_phone', '{"value": "+39 123 456 7890"}'::jsonb, 'contact', 'Numero di telefono'),
('contact_address', '{"street": "Via Roma 123", "city": "Milano", "cap": "20100", "country": "Italia"}'::jsonb, 'contact', 'Indirizzo fisico'),
('contact_social_facebook', '{"value": "https://facebook.com/piattaforma"}'::jsonb, 'contact', 'Link Facebook'),
('contact_social_instagram', '{"value": "https://instagram.com/piattaforma"}'::jsonb, 'contact', 'Link Instagram'),
('contact_social_twitter', '{"value": "https://twitter.com/piattaforma"}'::jsonb, 'contact', 'Link Twitter'),
('contact_whatsapp', '{"value": "+39 123 456 7890"}'::jsonb, 'contact', 'Numero WhatsApp'),
('contact_support_hours', '{"value": "Lun-Ven 9:00-18:00"}'::jsonb, 'contact', 'Orari assistenza'),

-- Regole piattaforma
('rules_reviews', '{"rules": ["Le recensioni devono essere veritiere e basate su esperienze reali", "Non è consentito linguaggio offensivo o discriminatorio", "Le recensioni devono riguardare l''attività e non le persone", "Non sono ammesse recensioni duplicate", "Le recensioni con prova di acquisto valgono 50 punti, senza prova 25 punti"]}'::jsonb, 'rules', 'Regole per le recensioni'),
('rules_classified_ads', '{"rules": ["Gli annunci devono contenere informazioni veritiere", "Vietata la vendita di prodotti illegali o contraffatti", "Le immagini devono essere appropriate e pertinenti", "Non è consentito spam o duplicazione annunci", "Gli annunci scadono dopo 30 giorni"]}'::jsonb, 'rules', 'Regole per gli annunci'),
('rules_messaging', '{"rules": ["Rispetta sempre gli altri utenti", "Non inviare spam o messaggi non richiesti", "Non condividere informazioni personali sensibili", "Segnala comportamenti inappropriati", "Non utilizzare la piattaforma per truffe o frodi"]}'::jsonb, 'rules', 'Regole per la messaggistica'),
('rules_points', '{"rules": ["I punti vengono assegnati per attività verificate", "Non è possibile trasferire punti tra utenti", "I punti non hanno valore monetario", "Comportamenti scorretti possono portare alla perdita di punti", "La classifica viene aggiornata in tempo reale"]}'::jsonb, 'rules', 'Regole sistema punti'),
('rules_general', '{"rules": ["Ogni utente può avere un solo account", "Vietato impersonare altre persone", "Rispetta la privacy degli altri utenti", "Non pubblicare contenuti protetti da copyright", "La piattaforma si riserva il diritto di rimuovere contenuti inappropriati"]}'::jsonb, 'rules', 'Regole generali piattaforma'),

-- Impostazioni generali
('platform_name', '{"value": "Piattaforma Recensioni"}'::jsonb, 'general', 'Nome della piattaforma'),
('platform_description', '{"value": "La piattaforma italiana per recensire attività locali e connettersi con la comunità"}'::jsonb, 'general', 'Descrizione piattaforma'),
('platform_terms_url', '{"value": "/termini-servizio"}'::jsonb, 'general', 'URL termini di servizio'),
('platform_privacy_url', '{"value": "/privacy-policy"}'::jsonb, 'general', 'URL privacy policy')
ON CONFLICT (setting_key) DO NOTHING;

-- Trigger per aggiornare updated_at
CREATE OR REPLACE FUNCTION update_platform_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_platform_settings_updated_at
  BEFORE UPDATE ON platform_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_platform_settings_updated_at();

-- Commenti
COMMENT ON TABLE platform_settings IS 'Impostazioni globali della piattaforma';
COMMENT ON COLUMN platform_settings.setting_key IS 'Chiave univoca per identificare l''impostazione';
COMMENT ON COLUMN platform_settings.setting_value IS 'Valore dell''impostazione in formato JSON per flessibilità';
COMMENT ON COLUMN platform_settings.category IS 'Categoria: contact (contatti), rules (regole), general (generale)';


