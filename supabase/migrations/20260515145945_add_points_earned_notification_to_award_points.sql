/*
  # Aggiungi notifica 'points_earned' nella funzione award_points

  ## Scopo
  Ogni volta che vengono assegnati punti (recensione approvata, annuncio approvato, ecc.)
  l'utente riceve una notifica di tipo 'points_earned' visibile nella sezione
  "Classifica" della pagina notifiche.

  ## Nota
  La notifica specifica dell'azione (es. 'review_approved', 'auction_approved')
  rimane separata nella sua sezione. Questa notifica aggiuntiva appare solo in "Classifica".
*/

CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT '',
  p_family_member_id uuid DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_new_total integer;
  v_exists boolean;
  v_user_type text;
  v_notification_title text;
  v_notification_message text;
BEGIN
  -- Business users do not participate in the points system
  SELECT user_type INTO v_user_type FROM profiles WHERE id = p_user_id;
  IF v_user_type = 'business' THEN
    RETURN 0;
  END IF;

  IF p_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points  = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at    = now()
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (p_user_id, p_family_member_id, p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now());
    END IF;

    SELECT total_points INTO v_new_total FROM user_activity
    WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points  = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at    = now()
      WHERE user_id = p_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (p_user_id, NULL, p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now());
    END IF;

    SELECT total_points INTO v_new_total FROM user_activity
    WHERE user_id = p_user_id AND family_member_id IS NULL;
  END IF;

  -- Costruisci titolo e messaggio in base al tipo di attività
  v_notification_title := 'Punti guadagnati';
  v_notification_message := CASE p_activity_type
    WHEN 'review'            THEN 'Hai guadagnato ' || p_points || ' punti per la tua recensione approvata! Totale: ' || v_new_total || ' punti.'
    WHEN 'classified_ad'     THEN 'Hai guadagnato ' || p_points || ' punti per il tuo annuncio approvato! Totale: ' || v_new_total || ' punti.'
    WHEN 'business'          THEN 'Hai guadagnato ' || p_points || ' punti per aver aggiunto un''attività! Totale: ' || v_new_total || ' punti.'
    ELSE 'Hai guadagnato ' || p_points || ' punti. Totale: ' || v_new_total || ' punti.'
  END;

  -- Notifica punti in sezione "Classifica"
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    p_user_id,
    p_family_member_id,
    'points_earned',
    v_notification_title,
    v_notification_message,
    jsonb_build_object(
      'points_awarded', p_points,
      'total_points',   v_new_total,
      'reason',         p_activity_type
    )
  );

  RETURN v_new_total;
END;
$$;
