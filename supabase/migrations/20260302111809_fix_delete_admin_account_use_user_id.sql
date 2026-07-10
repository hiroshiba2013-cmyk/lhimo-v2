/*
  # Fix Delete Admin Account Function - Usa user_id

  1. Problema
    - La funzione delete_admin_account() usa "id" ma la colonna nella tabella admins si chiama "user_id"
    - Anche admin_login_logs usa "admin_id" che è una foreign key a admins(user_id)

  2. Soluzione
    - Aggiorna la funzione per usare la colonna corretta: user_id
*/

-- Ricrea la funzione con le colonne corrette
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

  -- Verifica che l'utente sia un admin (usa user_id)
  SELECT EXISTS (
    SELECT 1 FROM admins WHERE user_id = user_profile_id
  ) INTO is_user_admin;

  IF NOT is_user_admin THEN
    RAISE EXCEPTION 'Solo gli admin possono eliminare account admin';
  END IF;

  -- Elimina i log di accesso admin
  DELETE FROM admin_login_logs WHERE admin_id = user_profile_id;

  -- Elimina il record dalla tabella admins (usa user_id)
  DELETE FROM admins WHERE user_id = user_profile_id;

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
