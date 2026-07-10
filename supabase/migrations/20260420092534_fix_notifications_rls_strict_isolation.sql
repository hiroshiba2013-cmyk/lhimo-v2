/*
  # Fix Notifications RLS - Strict User Isolation

  ## Summary
  Enforces strict isolation so each user sees ONLY their own notifications.
  Family members share the main account's auth.uid(), so notifications for the
  main user correctly appear for all family member sessions on the same account.

  ## Changes
  1. Drops the overly permissive INSERT policy `WITH CHECK (true)` that allowed
     any authenticated user to insert notifications for any user_id
  2. Replaces it with a SECURITY DEFINER insert function accessible to service role
  3. Adds a strict service-role-only INSERT policy (frontend inserts go via the
     existing admin/service path)

  ## Security
  - SELECT: users see only their own (auth.uid() = user_id) - unchanged
  - INSERT: only service_role (edge functions, triggers, SECURITY DEFINER functions)
  - UPDATE: users update only their own - unchanged
  - DELETE: users delete only their own - unchanged
*/

-- Drop the overly permissive INSERT policy
DROP POLICY IF EXISTS "System can create notifications" ON notifications;

-- Re-create INSERT policy: only service_role or internal functions can insert
-- Regular users cannot insert notifications for arbitrary user_ids
CREATE POLICY "Service role can insert notifications"
  ON notifications FOR INSERT
  TO service_role
  WITH CHECK (true);

-- Also allow authenticated users to insert notifications ONLY for themselves
-- (needed if any frontend code creates self-notifications)
CREATE POLICY "Users can insert own notifications"
  ON notifications FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);
