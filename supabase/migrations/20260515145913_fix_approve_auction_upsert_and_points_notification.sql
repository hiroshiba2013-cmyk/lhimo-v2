/*
  # Fix approve_auction: corretto upsert user_activity e notifica punti separata

  ## Problemi risolti

  1. ON CONFLICT con COALESCE non funziona — sostituito con logica UPDATE/INSERT
     manuale (come fa award_points) compatibile con i constraint esistenti:
     - user_activity_user_id_null_family_unique (family_member_id IS NULL)
     - user_activity_user_family_unique (user_id, family_member_id)

  2. Aggiunta notifica separata di tipo 'points_earned' dopo l'approvazione,
     visibile nella sezione "Classifica" della pagina notifiche.
*/

CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid;
  v_family_member_id uuid;
  v_duration_days integer;
  v_existing_activity uuid;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at from now so the full duration runs after approval
  UPDATE auctions
  SET approval_status = 'approved',
      status = 'active',
      approved_at = now(),
      approved_by = p_admin_id,
      ends_at = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Award 15 points: UPDATE esistente oppure INSERT nuovo
  IF v_family_member_id IS NULL THEN
    SELECT id INTO v_existing_activity FROM user_activity
    WHERE user_id = v_user_id AND family_member_id IS NULL;
  ELSE
    SELECT id INTO v_existing_activity FROM user_activity
    WHERE user_id = v_user_id AND family_member_id = v_family_member_id;
  END IF;

  IF v_existing_activity IS NOT NULL THEN
    UPDATE user_activity
    SET total_points  = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at    = now()
    WHERE id = v_existing_activity;
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
    VALUES (v_user_id, v_family_member_id, 15, 1);
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, action, details, points_awarded)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    jsonb_build_object('auction_id', p_auction_id), 15);

  -- Notifica approvazione asta (sezione "Aste")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', 15));

  -- Notifica punti guadagnati (sezione "Classifica")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'points_earned',
    'Punti guadagnati',
    'Hai guadagnato 15 punti per la pubblicazione della tua asta!',
    jsonb_build_object('points_awarded', 15, 'reason', 'auction_approved', 'auction_id', p_auction_id));
END;
$$;
