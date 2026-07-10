-- ============================================================
-- FILE: 20260104180549_create_activity_log_system.sql
-- ============================================================
/*
  # Create Activity Log System

  1. New Tables
    - `activity_log`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles)
      - `activity_type` (text) - Type of activity
      - `title` (text) - Activity title
      - `description` (text) - Activity description
      - `points_earned` (integer) - Points earned from this activity
      - `metadata` (jsonb) - Additional data (entity_id, discount_amount, etc.)
      - `icon` (text) - Icon name for display
      - `color` (text) - Color class for styling
      - `created_at` (timestamptz)

  2. Activity Types
    - points_earned - General points earned
    - review_created - Review submitted
    - review_approved - Review approved by staff
    - ad_created - Classified ad created
    - ad_viewed - Classified ad received views
    - product_created - Product added
    - business_added - Business added to platform
    - discount_received - Discount received
    - discount_used - Discount used
    - referral_reward - Referral bonus received
    - badge_earned - Badge unlocked
    - subscription_started - Subscription activated
    - subscription_renewed - Subscription renewed

  3. Security
    - Enable RLS
    - Users can view their own activity log
    - System can create activity logs
*/

-- Create activity_log table
CREATE TABLE IF NOT EXISTS activity_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  activity_type text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  points_earned integer DEFAULT 0,
  metadata jsonb DEFAULT '{}',
  icon text DEFAULT 'activity',
  color text DEFAULT 'text-blue-600',
  created_at timestamptz DEFAULT now()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_activity_log_user_id ON activity_log(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_created_at ON activity_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_created ON activity_log(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_type ON activity_log(activity_type);

-- Enable RLS
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own activity log"
  ON activity_log FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "System can create activity logs"
  ON activity_log FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Function to log activity
CREATE OR REPLACE FUNCTION log_user_activity(
  p_user_id uuid,
  p_activity_type text,
  p_title text,
  p_description text,
  p_points_earned integer DEFAULT 0,
  p_metadata jsonb DEFAULT '{}',
  p_icon text DEFAULT 'activity',
  p_color text DEFAULT 'text-blue-600'
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_activity_id uuid;
BEGIN
  INSERT INTO activity_log (
    user_id,
    activity_type,
    title,
    description,
    points_earned,
    metadata,
    icon,
    color
  )
  VALUES (
    p_user_id,
    p_activity_type,
    p_title,
    p_description,
    p_points_earned,
    p_metadata,
    p_icon,
    p_color
  )
  RETURNING id INTO v_activity_id;

  RETURN v_activity_id;
END;
$$;

-- Function to track ad views in activity log
CREATE OR REPLACE FUNCTION log_ad_view_milestone()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_ad classified_ads%ROWTYPE;
  v_total_views integer;
BEGIN
  -- Get the ad details
  SELECT * INTO v_ad
  FROM classified_ads
  WHERE id = NEW.ad_id;

  -- Count total views for this ad
  SELECT COUNT(*) INTO v_total_views
  FROM classified_ad_views
  WHERE ad_id = NEW.ad_id;

  -- Log milestone views (every 10 views)
  IF v_total_views % 10 = 0 THEN
    PERFORM log_user_activity(
      v_ad.user_id,
      'ad_viewed',
      'Il tuo annuncio ha raggiunto ' || v_total_views || ' visualizzazioni!',
      'L''annuncio "' || v_ad.title || '" continua a ricevere attenzione.',
      0,
      jsonb_build_object('ad_id', v_ad.id, 'total_views', v_total_views),
      'eye',
      'text-green-600'
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger for ad view milestones
DROP TRIGGER IF EXISTS trigger_log_ad_view_milestone ON classified_ad_views;
CREATE TRIGGER trigger_log_ad_view_milestone
  AFTER INSERT ON classified_ad_views
  FOR EACH ROW
  EXECUTE FUNCTION log_ad_view_milestone();

-- Function to log classified ad creation
CREATE OR REPLACE FUNCTION log_ad_creation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  PERFORM log_user_activity(
    NEW.user_id,
    'ad_created',
    'Annuncio pubblicato',
    'Hai pubblicato l''annuncio "' || NEW.title || '"',
    5,
    jsonb_build_object('ad_id', NEW.id),
    'file-text',
    'text-blue-600'
  );

  RETURN NEW;
END;
$$;

-- Create trigger for ad creation
DROP TRIGGER IF EXISTS trigger_log_ad_creation ON classified_ads;
CREATE TRIGGER trigger_log_ad_creation
  AFTER INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION log_ad_creation();

-- Function to log review submission
CREATE OR REPLACE FUNCTION log_review_submission()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
BEGIN
  -- Get business name
  SELECT name INTO v_business_name
  FROM business_locations
  WHERE business_id = NEW.business_id
  LIMIT 1;

  PERFORM log_user_activity(
    NEW.customer_id,
    'review_created',
    'Recensione inviata',
    'Hai recensito "' || COALESCE(v_business_name, 'un''attività') || '". In attesa di approvazione.',
    0,
    jsonb_build_object('review_id', NEW.id, 'business_id', NEW.business_id),
    'star',
    'text-yellow-600'
  );

  RETURN NEW;
END;
$$;

-- Create trigger for review submission
DROP TRIGGER IF EXISTS trigger_log_review_submission ON reviews;
CREATE TRIGGER trigger_log_review_submission
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION log_review_submission();

-- Function to log subscription start
CREATE OR REPLACE FUNCTION log_subscription_start()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_plan_name text;
BEGIN
  -- Get plan name
  SELECT name INTO v_plan_name
  FROM subscription_plans
  WHERE id = NEW.plan_id;

  PERFORM log_user_activity(
    NEW.customer_id,
    'subscription_started',
    'Abbonamento attivato',
    'Hai attivato l''abbonamento "' || COALESCE(v_plan_name, 'Premium') || '"',
    0,
    jsonb_build_object('subscription_id', NEW.id, 'plan_id', NEW.plan_id),
    'credit-card',
    'text-purple-600'
  );

  RETURN NEW;
END;
$$;

-- Create trigger for subscription start
DROP TRIGGER IF EXISTS trigger_log_subscription_start ON subscriptions;
CREATE TRIGGER trigger_log_subscription_start
  AFTER INSERT ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION log_subscription_start();

-- Function to get user activity summary
CREATE OR REPLACE FUNCTION get_user_activity_summary(p_user_id uuid)
RETURNS TABLE (
  total_activities bigint,
  total_points_earned bigint,
  activities_this_week bigint,
  activities_this_month bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*)::bigint as total_activities,
    COALESCE(SUM(points_earned), 0)::bigint as total_points_earned,
    COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '7 days')::bigint as activities_this_week,
    COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '30 days')::bigint as activities_this_month
  FROM activity_log
  WHERE user_id = p_user_id;
END;
$$;

-- ============================================================
-- FILE: 20260104180727_add_review_approval_and_referral_activity_logs.sql
-- ============================================================
/*
  # Add Activity Logs for Review Approval and Referrals

  1. Triggers
    - Log when review is approved (awards points)
    - Log referral rewards

  2. Updates
    - Track when users receive points from review approval
    - Track when users receive referral bonuses
*/

-- Function to log review approval
CREATE OR REPLACE FUNCTION log_review_approval()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
  v_points integer;
BEGIN
  -- Only log if status changes to approved
  IF NEW.review_status = 'approved' AND OLD.review_status != 'approved' THEN
    -- Get business name
    SELECT name INTO v_business_name
    FROM business_locations
    WHERE business_id = NEW.business_id
    LIMIT 1;

    -- Determine points based on proof image
    v_points := CASE 
      WHEN NEW.proof_image_url IS NOT NULL AND NEW.proof_image_url != '' THEN 50
      ELSE 25
    END;

    -- Log the activity
    PERFORM log_user_activity(
      NEW.customer_id,
      'review_approved',
      'Recensione approvata!',
      'La tua recensione per "' || COALESCE(v_business_name, 'un''attività') || '" è stata approvata',
      v_points,
      jsonb_build_object(
        'review_id', NEW.id,
        'business_id', NEW.business_id,
        'has_proof', NEW.proof_image_url IS NOT NULL
      ),
      'star',
      'text-green-600'
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger for review approval
DROP TRIGGER IF EXISTS trigger_log_review_approval ON reviews;
CREATE TRIGGER trigger_log_review_approval
  AFTER UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION log_review_approval();

-- Function to log referral rewards
CREATE OR REPLACE FUNCTION log_referral_reward()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_referrer_id uuid;
  v_referrer_name text;
BEGIN
  -- Only process if this is a new subscription (not trial)
  IF NEW.status = 'active' AND OLD.status IS DISTINCT FROM 'active' THEN
    -- Get the referrer info from the customer's profile
    SELECT p.id, p.full_name INTO v_referrer_id, v_referrer_name
    FROM profiles p
    WHERE p.nickname = (
      SELECT referred_by_nickname
      FROM profiles
      WHERE id = NEW.customer_id
    );

    -- If there's a referrer, log the reward
    IF v_referrer_id IS NOT NULL THEN
      -- Log activity for the referrer
      PERFORM log_user_activity(
        v_referrer_id,
        'referral_reward',
        'Bonus Amico Ricevuto!',
        'Hai guadagnato 30 punti grazie all''abbonamento del tuo amico',
        30,
        jsonb_build_object(
          'referred_user_id', NEW.customer_id,
          'subscription_id', NEW.id
        ),
        'gift',
        'text-yellow-600'
      );

      -- Update referral count
      UPDATE profiles
      SET referral_count = COALESCE(referral_count, 0) + 1
      WHERE id = v_referrer_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger for referral rewards
DROP TRIGGER IF EXISTS trigger_log_referral_reward ON subscriptions;
CREATE TRIGGER trigger_log_referral_reward
  AFTER UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION log_referral_reward();

-- ============================================================
-- FILE: 20260104211357_add_business_fields_to_profiles.sql
-- ============================================================
/*
  # Add Business Fields to Profiles

  1. Changes
    - Add company_name field to profiles
    - Add vat_number field to profiles  
    - Add unique_code field to profiles
    - Add pec_email field to profiles

  2. Purpose
    - Store business information directly in profiles table for business accounts
    - Allow business users to manage their company data in the personal information section
*/

-- Add business fields to profiles table
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'company_name'
  ) THEN
    ALTER TABLE profiles ADD COLUMN company_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'vat_number'
  ) THEN
    ALTER TABLE profiles ADD COLUMN vat_number text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'unique_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN unique_code text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'pec_email'
  ) THEN
    ALTER TABLE profiles ADD COLUMN pec_email text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20260104212652_add_complete_business_fields_to_profiles.sql
-- ============================================================
/*
  # Add Complete Business Fields to Profiles

  1. Changes
    - Add ateco_code field to profiles
    - Add website_url field to profiles
    - Add office_street field to profiles
    - Add office_street_number field to profiles
    - Add office_postal_code field to profiles
    - Add office_city field to profiles
    - Add office_province field to profiles
    - Add office_address field to profiles
    - Add business_category_id field to profiles with foreign key to business_categories
    - Add description field to profiles

  2. Purpose
    - Store all business information in profiles table for business accounts
    - Allow business users to manage complete company data including addresses and category
*/

-- Add additional business fields to profiles table
DO $$ 
BEGIN
  -- ateco_code
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'ateco_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN ateco_code text;
  END IF;

  -- website_url
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'website_url'
  ) THEN
    ALTER TABLE profiles ADD COLUMN website_url text;
  END IF;

  -- office_street
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_street'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_street text;
  END IF;

  -- office_street_number
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_street_number'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_street_number text;
  END IF;

  -- office_postal_code
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_postal_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_postal_code text;
  END IF;

  -- office_city
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_city'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_city text;
  END IF;

  -- office_province
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_province'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_province text;
  END IF;

  -- office_address (complete formatted address)
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'office_address'
  ) THEN
    ALTER TABLE profiles ADD COLUMN office_address text;
  END IF;

  -- business_category_id with foreign key
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'business_category_id'
  ) THEN
    ALTER TABLE profiles ADD COLUMN business_category_id uuid REFERENCES business_categories(id);
  END IF;

  -- description
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name = 'description'
  ) THEN
    ALTER TABLE profiles ADD COLUMN description text;
  END IF;
END $$;

-- ============================================================
-- FILE: 20260104220331_fix_delete_user_account_function.sql
-- ============================================================
/*
  # Fix Funzione Eliminazione Account Utente

  1. Correzioni
    - Corretto nome tabella da `user_subscriptions` a `subscriptions`
    - Corretto nome tabella da `business_subscriptions` (rimosso, non esiste)
    - Corretto nome colonna in subscriptions da `user_id` a `customer_id`
    - Aggiunti preferiti (favorite_businesses, favorite_classified_ads, favorite_job_postings)
    - Aggiunto activity_log
    - Rimosso riferimento a job_seekers che non ha relazione con business_id

  2. Sicurezza
    - La funzione può essere eseguita solo dall'utente proprietario dell'account
    - Tutti i dati vengono eliminati in modo irreversibile
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione corretta
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

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

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
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_seeker_messages WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i job seekers dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM content_reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina i referral (sia come referrer che come referee)
  DELETE FROM referrals WHERE referrer_id = user_profile_id OR referee_id = user_profile_id;

  -- Elimina gli abbonamenti (corrected table name)
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20260104221231_add_job_posting_points_trigger.sql
-- ============================================================
/*
  # Trigger per Assegnare Punti alla Pubblicazione di Annunci di Lavoro

  1. Trigger
    - Quando un professionista pubblica un annuncio di lavoro, riceve automaticamente 30 punti
    - Il trigger si attiva dopo l'inserimento di un nuovo record nella tabella job_postings
    - Usa la funzione award_points esistente per assegnare i punti

  2. Dettagli
    - Punti assegnati: 30
    - Tipo attività: 'job_posting_created'
    - I punti vengono assegnati al proprietario dell'azienda (owner_id)

  3. Sicurezza
    - Il trigger è SECURITY DEFINER per accedere alle tabelle necessarie
    - I punti vengono assegnati solo per nuovi annunci (non per aggiornamenti)
*/

-- Funzione trigger per assegnare punti quando viene creato un annuncio di lavoro
CREATE OR REPLACE FUNCTION award_points_for_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'owner_id dell'azienda
  SELECT owner_id INTO v_owner_id
  FROM businesses
  WHERE id = NEW.business_id;

  -- Se l'owner esiste, assegna i punti
  IF v_owner_id IS NOT NULL THEN
    PERFORM award_points(
      v_owner_id,
      30,
      'job_posting_created',
      'Annuncio di lavoro pubblicato: ' || NEW.title
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crea il trigger sulla tabella job_postings
DROP TRIGGER IF EXISTS trigger_award_points_job_posting ON job_postings;

CREATE TRIGGER trigger_award_points_job_posting
AFTER INSERT ON job_postings
FOR EACH ROW
EXECUTE FUNCTION award_points_for_job_posting();

-- Grant necessari
GRANT EXECUTE ON FUNCTION award_points_for_job_posting() TO authenticated;

