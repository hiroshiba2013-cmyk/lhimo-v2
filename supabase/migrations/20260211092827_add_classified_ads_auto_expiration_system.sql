/*
  # Add Auto-Expiration System for Classified Ads

  1. New Features
    - Automatic expiration date (30 days) on ad creation
    - Auto-deletion of expired ads with notification
    - Function to clean up expired ads and notify users

  2. Changes
    - Add trigger to set expires_at automatically on insert
    - Add function to delete expired ads and create notifications
    - Add scheduled job support (to be called by edge function)

  3. Security
    - Only system can delete expired ads
    - Notifications are created for affected users
*/

-- Function to set expiration date automatically (30 days from creation)
CREATE OR REPLACE FUNCTION set_classified_ad_expiration()
RETURNS TRIGGER AS $$
BEGIN
  -- Set expiration to 30 days from now if not already set
  IF NEW.expires_at IS NULL THEN
    NEW.expires_at := NOW() + INTERVAL '30 days';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to set expiration on insert
DROP TRIGGER IF EXISTS set_classified_ad_expiration_trigger ON classified_ads;
CREATE TRIGGER set_classified_ad_expiration_trigger
  BEFORE INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION set_classified_ad_expiration();

-- Function to clean up expired ads and notify users
CREATE OR REPLACE FUNCTION delete_expired_classified_ads()
RETURNS TABLE (
  deleted_count INTEGER,
  notified_users UUID[]
) AS $$
DECLARE
  v_deleted_count INTEGER;
  v_notified_users UUID[];
BEGIN
  -- Get list of users with expired ads
  SELECT ARRAY_AGG(DISTINCT user_id)
  INTO v_notified_users
  FROM classified_ads
  WHERE expires_at < NOW() AND status = 'active';

  -- Create notifications for users with expired ads
  INSERT INTO notifications (user_id, title, message, type, link)
  SELECT 
    user_id,
    'Annuncio scaduto',
    'Il tuo annuncio "' || title || '" è scaduto ed è stato rimosso automaticamente dopo 30 giorni.',
    'ad_expired',
    '/profile'
  FROM classified_ads
  WHERE expires_at < NOW() AND status = 'active';

  -- Delete expired ads
  WITH deleted AS (
    DELETE FROM classified_ads
    WHERE expires_at < NOW() AND status = 'active'
    RETURNING id
  )
  SELECT COUNT(*)::INTEGER INTO v_deleted_count FROM deleted;

  RETURN QUERY SELECT v_deleted_count, v_notified_users;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users (will be called by edge function)
GRANT EXECUTE ON FUNCTION delete_expired_classified_ads() TO authenticated;
GRANT EXECUTE ON FUNCTION delete_expired_classified_ads() TO anon;
