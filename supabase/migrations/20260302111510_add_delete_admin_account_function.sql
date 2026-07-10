/*
  # Funzione per Eliminare Account Admin

  1. Nuova Funzione
    - `delete_admin_account()` - Funzione che elimina l'account admin corrente e tutti i dati associati
  
  2. Cosa Viene Eliminato
    - Log di accesso admin (admin_login_logs)
    - Record dalla tabella admins
    - Profilo (profiles)
    - Account auth (auth.users)

  3. Sicurezza
    - La funzione può essere eseguita solo da utenti autenticati con ruolo admin
    - Verifica che l'utente sia effettivamente un admin prima di procedere
    - Tutti i dati vengono eliminati in modo irreversibile
    - L'admin può eliminare solo il proprio account, non altri admin
*/

-- Funzione per eliminare l'account admin corrente
CREATE OR REPLACE FUNCTION delete_admin_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  is_user_admin boolean;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Verifica che l'utente sia un admin
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE id = user_profile_id
  ) INTO is_user_admin;

  IF NOT is_user_admin THEN
    RAISE EXCEPTION 'Solo gli admin possono eliminare account admin';
  END IF;

  -- Elimina i log di accesso admin
  DELETE FROM admin_login_logs WHERE admin_id = user_profile_id;

  -- Elimina il record dalla tabella admins
  DELETE FROM admins WHERE id = user_profile_id;

  -- Gestisci riferimenti che devono restare nelle altre tabelle
  -- Rimuovi il riferimento all'admin nelle recensioni approvate
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Rimuovi il riferimento all'admin nei report revisionati
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina il profilo
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth
  DELETE FROM auth.users WHERE id = user_profile_id;

  RAISE NOTICE 'Account admin eliminato completamente: %', user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_admin_account() TO authenticated;

-- Commento sulla funzione
COMMENT ON FUNCTION delete_admin_account() IS 'Elimina completamente l''account admin corrente e tutti i dati associati. Solo gli admin possono usare questa funzione. Eliminazione PERMANENTE e IRREVERSIBILE.';
