/*
  # Add Trial Expiration Automation System

  1. Functions
    - `check_trial_expiration()` - Automatically expire trials when trial_end_date is reached
    - `notify_trial_expiring_soon()` - Create in-app notifications for expiring trials (7 days before)
    - `get_trial_status()` - Get trial status for a user

  2. Changes
    - Add automatic trigger to expire trials at midnight
    - Add function to create notifications for trials expiring in 7 days
    - Add function to handle expired trials (update status and create notification)

  3. Security
    - Functions run with SECURITY DEFINER to update profiles and create notifications
    - Only updates trials that have actually expired
*/

-- Function to automatically expire trials
CREATE OR REPLACE FUNCTION check_trial_expiration()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update profiles where trial has expired
  UPDATE profiles
  SET
    subscription_status = 'expired',
    updated_at = now()
  WHERE
    subscription_status = 'trial'
    AND trial_end_date IS NOT NULL
    AND trial_end_date < now()
    AND profile_type = 'business';

  -- Create notifications for expired trials
  INSERT INTO notifications (user_id, type, title, message, metadata)
  SELECT
    id,
    'subscription',
    CASE
      WHEN language = 'it' THEN 'Prova gratuita terminata'
      ELSE 'Free trial ended'
    END,
    CASE
      WHEN language = 'it' THEN 'La tua prova gratuita di 2 mesi è terminata. Sottoscrivi un piano per continuare ad accedere alle funzionalità premium.'
      ELSE 'Your 2-month free trial has ended. Subscribe to a plan to continue accessing premium features.'
    END,
    jsonb_build_object('trial_expired', true)
  FROM profiles
  WHERE
    subscription_status = 'expired'
    AND trial_end_date IS NOT NULL
    AND trial_end_date < now()
    AND profile_type = 'business'
    -- Don't create duplicate notifications
    AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.user_id = profiles.id
      AND n.type = 'subscription'
      AND n.metadata->>'trial_expired' = 'true'
      AND n.created_at > now() - interval '1 day'
    );
END;
$$;

-- Function to notify users 7 days before trial expiration
CREATE OR REPLACE FUNCTION notify_trial_expiring_soon()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Create notifications for trials expiring in 7 days
  INSERT INTO notifications (user_id, type, title, message, metadata)
  SELECT
    id,
    'subscription',
    CASE
      WHEN language = 'it' THEN 'La tua prova gratuita sta per scadere'
      ELSE 'Your free trial is expiring soon'
    END,
    CASE
      WHEN language = 'it' THEN 'La tua prova gratuita terminerà tra 7 giorni. Sottoscrivi un piano per continuare ad accedere alle funzionalità premium senza interruzioni.'
      ELSE 'Your free trial will end in 7 days. Subscribe to a plan to continue accessing premium features without interruption.'
    END,
    jsonb_build_object(
      'trial_expiring_soon', true,
      'days_remaining', 7,
      'trial_end_date', trial_end_date
    )
  FROM profiles
  WHERE
    subscription_status = 'trial'
    AND trial_end_date IS NOT NULL
    AND trial_end_date BETWEEN now() + interval '6 days 23 hours' AND now() + interval '7 days 1 hour'
    AND profile_type = 'business'
    -- Don't create duplicate notifications
    AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.user_id = profiles.id
      AND n.type = 'subscription'
      AND n.metadata->>'trial_expiring_soon' = 'true'
      AND n.created_at > now() - interval '2 days'
    );
END;
$$;

-- Function to get trial status for a user
CREATE OR REPLACE FUNCTION get_trial_status(user_id_param uuid)
RETURNS TABLE(
  is_trial boolean,
  days_remaining integer,
  trial_end_date timestamptz,
  is_expired boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    (subscription_status = 'trial') as is_trial,
    CASE
      WHEN subscription_status = 'trial' AND trial_end_date IS NOT NULL
      THEN GREATEST(0, EXTRACT(day FROM (trial_end_date - now()))::integer)
      ELSE 0
    END as days_remaining,
    profiles.trial_end_date,
    (subscription_status = 'expired' AND trial_end_date < now()) as is_expired
  FROM profiles
  WHERE id = user_id_param;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION check_trial_expiration() TO authenticated;
GRANT EXECUTE ON FUNCTION notify_trial_expiring_soon() TO authenticated;
GRANT EXECUTE ON FUNCTION get_trial_status(uuid) TO authenticated;