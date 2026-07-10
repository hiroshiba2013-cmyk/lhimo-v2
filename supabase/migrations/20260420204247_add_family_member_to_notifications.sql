/*
  # Add family member support to notifications

  ## Problem
  Notifications are currently tied only to user_id. In accounts with family members,
  all members see ALL notifications for the account. Each member should only see
  their own notifications.

  ## Changes
  1. Add `family_member_id` column to `notifications` table (nullable, for main account owner)
  2. Update `send_notification` function to accept optional family_member_id
  3. Update `get_unread_notification_count` to accept family_member_id parameter
  4. Update `mark_notification_read` - no changes needed (works by notification id)
  5. Update `mark_all_notifications_read` to accept family_member_id parameter
  6. Add index for efficient querying

  ## Important notes
  - family_member_id = NULL means the notification belongs to the main account owner
  - Existing notifications remain with family_member_id = NULL (main owner)
  - RLS stays the same (user_id based) since family members share the same auth user
*/

-- 1. Add family_member_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'notifications' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE notifications ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- 2. Add index for efficient queries
CREATE INDEX IF NOT EXISTS idx_notifications_user_family_member
  ON notifications (user_id, family_member_id);

-- 3. Update send_notification to support family_member_id
CREATE OR REPLACE FUNCTION send_notification(
  target_user_id uuid,
  notif_type text,
  notif_title text,
  notif_message text,
  notif_data jsonb DEFAULT '{}'::jsonb,
  target_family_member_id uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT (is_admin() OR auth.uid() = target_user_id) THEN
    RAISE EXCEPTION 'Non autorizzato a inviare notifiche ad altri utenti';
  END IF;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (target_user_id, target_family_member_id, notif_type, notif_title, notif_message, notif_data);
END;
$$;

-- 4. Update get_unread_notification_count to filter by family_member_id
CREATE OR REPLACE FUNCTION get_unread_notification_count(
  p_family_member_id uuid DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  count integer;
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    SELECT COUNT(*)::integer INTO count
    FROM notifications
    WHERE user_id = auth.uid() AND family_member_id = p_family_member_id AND read = false;
  ELSE
    SELECT COUNT(*)::integer INTO count
    FROM notifications
    WHERE user_id = auth.uid() AND family_member_id IS NULL AND read = false;
  END IF;

  RETURN count;
END;
$$;

-- 5. Update mark_all_notifications_read to filter by family_member_id
CREATE OR REPLACE FUNCTION mark_all_notifications_read(
  p_family_member_id uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    UPDATE notifications
    SET read = true
    WHERE user_id = auth.uid() AND family_member_id = p_family_member_id AND read = false;
  ELSE
    UPDATE notifications
    SET read = true
    WHERE user_id = auth.uid() AND family_member_id IS NULL AND read = false;
  END IF;
END;
$$;

-- 6. Update the unclaimed business approval trigger to include family_member_id in notifications
-- The trigger award_points_for_unclaimed_business_on_approval already handles family_member_id
-- for points. Now we also need to make the frontend pass family_member_id when sending notifications.
-- This is handled in the frontend code changes.
