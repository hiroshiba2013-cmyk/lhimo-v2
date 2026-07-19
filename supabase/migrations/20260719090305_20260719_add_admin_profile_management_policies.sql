
/*
# Aggiungi policy admin per aggiornamento profili e DELETE

## Modifiche
1. Admin può aggiornare qualsiasi profilo (gestione utenti)
2. Admin può eliminare profili (ban/rimozione utenti)
*/

DROP POLICY IF EXISTS "Admins can update any profile" ON public.profiles;
CREATE POLICY "Admins can update any profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any profile" ON public.profiles;
CREATE POLICY "Admins can delete any profile"
  ON public.profiles FOR DELETE
  TO authenticated
  USING (is_admin());
