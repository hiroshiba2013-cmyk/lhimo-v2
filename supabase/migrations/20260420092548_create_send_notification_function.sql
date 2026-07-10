/*
  # Create send_notification function for admin use

  ## Summary
  Creates a SECURITY DEFINER function that allows admins to send notifications
  to any user. This is needed because admin frontend code inserts notifications
  for other users (e.g., review approval notifications).

  ## Function
  - `send_notification(target_user_id, type, title, message, data)` - inserts a
    notification bypassing RLS, only callable by admins or service role

  ## Security
  - Checks that the caller is an admin via is_admin() before inserting
  - Uses SECURITY DEFINER to bypass RLS for the insert
*/

CREATE OR REPLACE FUNCTION send_notification(
  target_user_id uuid,
  notif_type text,
  notif_title text,
  notif_message text,
  notif_data jsonb DEFAULT '{}'
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT (is_admin() OR auth.uid() = target_user_id) THEN
    RAISE EXCEPTION 'Non autorizzato a inviare notifiche ad altri utenti';
  END IF;

  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (target_user_id, notif_type, notif_title, notif_message, notif_data);
END;
$$;

GRANT EXECUTE ON FUNCTION send_notification TO authenticated;
