
/*
  # Fix notifica admin nuova attivita'

  Problema: il trigger notify_admins_new_unclaimed_business generava una notifica
  per OGNI attivita' importata da OSM (146.000+), intasando completamente la tabella
  notifications degli admin.

  Soluzione: la funzione ora notifica l'admin SOLO quando l'attivita' e' aggiunta
  da un utente reale (added_by IS NOT NULL e osm_id IS NULL).
  Le importazioni automatiche da OSM vengono ignorate.
*/

CREATE OR REPLACE FUNCTION notify_admins_new_unclaimed_business()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_admin RECORD;
  v_author_name text;
BEGIN
  -- Notifica solo per attivita' aggiunte da utenti reali, non da import OSM
  IF NEW.added_by IS NULL OR NEW.osm_id IS NOT NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.added_by_family_member_id IS NOT NULL THEN
    SELECT COALESCE(nickname, first_name || ' ' || last_name)
    INTO v_author_name
    FROM customer_family_members WHERE id = NEW.added_by_family_member_id;
  ELSE
    SELECT COALESCE(nickname, full_name, email)
    INTO v_author_name
    FROM profiles WHERE id = NEW.added_by;
  END IF;

  FOR v_admin IN SELECT user_id FROM admins LOOP
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      v_admin.user_id,
      NULL,
      'admin_new_business',
      'Nuova Attivita''',
      'Una nuova attivita'' "' || NEW.name || '" e'' stata aggiunta da ' || COALESCE(v_author_name, 'un utente') || ' ed e'' in attesa di approvazione.',
      jsonb_build_object('business_id', NEW.id, 'url', '/admin')
    );
  END LOOP;

  RETURN NEW;
END;
$$;
