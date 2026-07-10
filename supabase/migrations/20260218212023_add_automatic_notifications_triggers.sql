/*
  # Add Automatic Notification Triggers

  1. New Functions
    - Function to check and notify subscription expiration (7 days, 3 days, 1 day before)
    - Function to notify when ad is favorited (classified ads)
    - Function to notify when job seeker ad is favorited

  2. Triggers
    - Trigger on favorite_classified_ads insert
    - Scheduled check for subscription expiration (via cron or manual call)

  3. Security
    - Functions execute with proper permissions
*/

-- Function to create notification
CREATE OR REPLACE FUNCTION create_notification(
  p_user_id uuid,
  p_type text,
  p_title text,
  p_message text,
  p_data jsonb DEFAULT '{}'
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (p_user_id, p_type, p_title, p_message, p_data);
END;
$$;

-- Function to notify when classified ad is favorited
CREATE OR REPLACE FUNCTION notify_ad_favorited()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_ad_title text;
  v_ad_owner_id uuid;
  v_favoriter_name text;
BEGIN
  -- Get ad details and owner
  SELECT ca.title, ca.user_id
  INTO v_ad_title, v_ad_owner_id
  FROM classified_ads ca
  WHERE ca.id = NEW.ad_id;

  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Create notification for ad owner
  IF v_ad_owner_id IS NOT NULL AND v_ad_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      v_ad_owner_id,
      'ad_favorited',
      'Annuncio aggiunto ai preferiti',
      format('Il tuo annuncio "%s" è stato aggiunto ai preferiti da %s', v_ad_title, v_favoriter_name),
      jsonb_build_object(
        'ad_id', NEW.ad_id,
        'favorited_by', NEW.user_id,
        'url', '/classified-ads/' || NEW.ad_id
      )
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Function to notify when job seeker ad is viewed/favorited
CREATE OR REPLACE FUNCTION notify_job_seeker_favorited()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job_title text;
  v_job_owner_id uuid;
  v_favoriter_name text;
BEGIN
  -- Get job seeker details
  SELECT js.title, js.user_id
  INTO v_job_title, v_job_owner_id
  FROM job_seekers js
  WHERE js.id = NEW.job_seeker_id;

  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Create notification for job seeker owner
  IF v_job_owner_id IS NOT NULL AND v_job_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      v_job_owner_id,
      'job_favorited',
      'Annuncio lavoro nei preferiti',
      format('Il tuo annuncio "%s" è stato aggiunto ai preferiti da %s', v_job_title, v_favoriter_name),
      jsonb_build_object(
        'job_seeker_id', NEW.job_seeker_id,
        'favorited_by', NEW.user_id,
        'url', '/jobs'
      )
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Function to check and notify subscription expiration
CREATE OR REPLACE FUNCTION check_subscription_expiration()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_subscription RECORD;
  v_days_until_expiry integer;
  v_notification_exists boolean;
BEGIN
  -- Loop through active subscriptions
  FOR v_subscription IN
    SELECT 
      s.id,
      s.business_id,
      s.end_date,
      b.name as business_name,
      p.id as user_id,
      p.full_name,
      p.email
    FROM business_subscriptions s
    JOIN businesses b ON b.id = s.business_id
    JOIN profiles p ON p.id = b.owner_id
    WHERE s.status = 'active'
      AND s.end_date IS NOT NULL
      AND s.end_date > now()
      AND s.end_date <= now() + interval '7 days'
  LOOP
    -- Calculate days until expiry
    v_days_until_expiry := EXTRACT(DAY FROM (v_subscription.end_date - now()))::integer;
    
    -- Check if we should notify (7, 3, or 1 day before)
    IF v_days_until_expiry IN (7, 3, 1) THEN
      -- Check if notification already sent today for this subscription
      SELECT EXISTS (
        SELECT 1 FROM notifications
        WHERE user_id = v_subscription.user_id
          AND type = 'subscription_expiring'
          AND data->>'subscription_id' = v_subscription.id::text
          AND created_at >= now() - interval '1 day'
      ) INTO v_notification_exists;
      
      -- Send notification if not already sent
      IF NOT v_notification_exists THEN
        INSERT INTO notifications (user_id, type, title, message, data)
        VALUES (
          v_subscription.user_id,
          'subscription_expiring',
          'Abbonamento in scadenza',
          format(
            'Il tuo abbonamento per "%s" scadrà tra %s %s. Rinnova ora per non perdere i vantaggi!',
            v_subscription.business_name,
            v_days_until_expiry,
            CASE WHEN v_days_until_expiry = 1 THEN 'giorno' ELSE 'giorni' END
          ),
          jsonb_build_object(
            'subscription_id', v_subscription.id,
            'business_id', v_subscription.business_id,
            'days_until_expiry', v_days_until_expiry,
            'end_date', v_subscription.end_date,
            'url', '/subscription'
          )
        );
      END IF;
    END IF;
  END LOOP;
END;
$$;

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS trigger_notify_ad_favorited ON favorite_classified_ads;
DROP TRIGGER IF EXISTS trigger_notify_job_favorited ON favorite_businesses;

-- Create trigger for classified ad favorites
CREATE TRIGGER trigger_notify_ad_favorited
  AFTER INSERT ON favorite_classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION notify_ad_favorited();

-- Create trigger for job seeker favorites (using favorite_businesses table)
-- Note: We need to check if it's a job seeker being favorited
CREATE OR REPLACE FUNCTION notify_favorite_created()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
  v_business_owner_id uuid;
  v_favoriter_name text;
  v_job_title text;
  v_job_owner_id uuid;
BEGIN
  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Check if it's a business favorite
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

  -- Check if it's a job seeker favorite
  IF NEW.job_seeker_id IS NOT NULL THEN
    SELECT js.title, js.user_id
    INTO v_job_title, v_job_owner_id
    FROM job_seekers js
    WHERE js.id = NEW.job_seeker_id;

    IF v_job_owner_id IS NOT NULL AND v_job_owner_id != NEW.user_id THEN
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        v_job_owner_id,
        'job_favorited',
        'Annuncio lavoro nei preferiti',
        format('Il tuo annuncio "%s" è stato aggiunto ai preferiti da %s', v_job_title, v_favoriter_name),
        jsonb_build_object(
          'job_seeker_id', NEW.job_seeker_id,
          'favorited_by', NEW.user_id,
          'url', '/jobs'
        )
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

-- Create unified trigger for favorites
DROP TRIGGER IF EXISTS trigger_notify_favorite_created ON favorite_businesses;
CREATE TRIGGER trigger_notify_favorite_created
  AFTER INSERT ON favorite_businesses
  FOR EACH ROW
  EXECUTE FUNCTION notify_favorite_created();
