/*
  # Fix approve_auction: colonne corrette di activity_log

  activity_log ha: activity_type, title, description, points_earned, metadata
  (non action, details, points_awarded)
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
  v_exists boolean;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at dal momento dell'approvazione
  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id,
      ends_at         = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Aggiorna punti con logica UPDATE/INSERT (user_activity ha PK composta, no id)
  IF v_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = v_user_id AND family_member_id = v_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points   = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at     = now()
      WHERE user_id = v_user_id AND family_member_id = v_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
      VALUES (v_user_id, v_family_member_id, 15, 1);
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = v_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points   = total_points + 15,
        auctions_count = COALESCE(auctions_count, 0) + 1,
        updated_at     = now()
      WHERE user_id = v_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
      VALUES (v_user_id, NULL, 15, 1);
    END IF;
  END IF;

  -- Log attività (colonne reali: activity_type, title, description, points_earned, metadata)
  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata)
  VALUES (
    v_user_id,
    v_family_member_id,
    'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata e pubblicata.',
    15,
    jsonb_build_object('auction_id', p_auction_id)
  );

  -- Notifica approvazione (sezione "Aste")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_user_id,
    v_family_member_id,
    'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', 15)
  );

  -- Notifica punti (sezione "Classifica")
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_user_id,
    v_family_member_id,
    'points_earned',
    'Punti guadagnati',
    'Hai guadagnato 15 punti per la pubblicazione della tua asta! Controlla la tua posizione in classifica.',
    jsonb_build_object('points_awarded', 15, 'reason', 'auction_approved', 'auction_id', p_auction_id)
  );
END;
$$;
