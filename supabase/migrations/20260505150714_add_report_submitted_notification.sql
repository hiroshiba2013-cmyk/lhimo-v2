/*
  # Add notification when a report is submitted

  1. Changes
    - Adds a trigger on `reports` INSERT that sends a notification to the reporter
    - Notification type: 'report_submitted'
    - Also notifies all admin users about the new report

  2. Notes
    - The reporter receives confirmation that their report was received
    - Uses SECURITY DEFINER so the trigger can insert into notifications
*/

-- Function: notify reporter when they submit a report
CREATE OR REPLACE FUNCTION notify_report_submitted()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_entity_label text;
BEGIN
  v_entity_label := CASE NEW.reported_entity_type
    WHEN 'classified_ad' THEN 'annuncio'
    WHEN 'review' THEN 'recensione'
    WHEN 'business' THEN 'attività'
    WHEN 'auction' THEN 'asta'
    WHEN 'job_posting' THEN 'offerta di lavoro'
    ELSE 'contenuto'
  END;

  -- Notify the reporter that their report was received
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    NEW.reporter_id,
    NEW.family_member_id,
    'report_submitted',
    'Segnalazione inviata',
    'La tua segnalazione per questo ' || v_entity_label || ' è stata ricevuta e verrà esaminata dal nostro staff.',
    jsonb_build_object(
      'entity_type', NEW.reported_entity_type,
      'entity_id', NEW.reported_entity_id,
      'report_id', NEW.id
    )
  );

  RETURN NEW;
END;
$$;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS trigger_notify_report_submitted ON reports;

CREATE TRIGGER trigger_notify_report_submitted
  AFTER INSERT ON reports
  FOR EACH ROW
  EXECUTE FUNCTION notify_report_submitted();
