
/*
# Aggiungi policy admin per conversations, messages e altri fix

## Modifiche
1. Policy SELECT admin su conversations e messages (per sezione admin messaggistica)
2. Policy DELETE admin su conversations (per pulizia moderazione)
3. Fix policy INSERT notifiche per service role (trigger SECURITY DEFINER)
*/

-- Admin può vedere tutte le conversazioni
DROP POLICY IF EXISTS "Admins can view all conversations" ON public.conversations;
CREATE POLICY "Admins can view all conversations"
  ON public.conversations FOR SELECT
  TO authenticated
  USING (is_admin());

-- Admin può vedere tutti i messaggi
DROP POLICY IF EXISTS "Admins can view all messages" ON public.messages;
CREATE POLICY "Admins can view all messages"
  ON public.messages FOR SELECT
  TO authenticated
  USING (is_admin());

-- Admin può eliminare conversazioni (moderazione)
DROP POLICY IF EXISTS "Admins can delete conversations" ON public.conversations;
CREATE POLICY "Admins can delete conversations"
  ON public.conversations FOR DELETE
  TO authenticated
  USING (is_admin());

-- Assicura che le notifiche possano essere inserite da funzioni SECURITY DEFINER (service role bypassa RLS)
-- Ma aggiungiamo policy per anon nel caso non sia SECURITY DEFINER
DROP POLICY IF EXISTS "System can insert notifications" ON public.notifications;
CREATE POLICY "System can insert notifications"
  ON public.notifications FOR INSERT
  TO authenticated
  WITH CHECK (true);
