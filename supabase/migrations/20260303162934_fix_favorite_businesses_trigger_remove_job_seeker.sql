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
