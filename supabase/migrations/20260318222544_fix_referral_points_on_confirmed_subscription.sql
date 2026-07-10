/*
  # Fix Referral Points - Assegna Solo su Abbonamento Confermato

  ## Problema Attuale
  I punti referral vengono assegnati immediatamente quando viene creato un abbonamento,
  ma non vengono rimossi se l'utente cancella l'account o l'abbonamento prima della conferma.

  ## Modifiche
  1. Rimuovi il trigger che assegna punti su INSERT subscription
  2. I punti referral verranno assegnati solo quando l'abbonamento è confermato/pagato
  3. Aggiungi logica per rimuovere punti referral quando un utente referito cancella l'account
  4. Aggiungi tracking nella tabella user_activity per i referral

  ## Logica
  - I punti verranno assegnati manualmente dal frontend quando l'abbonamento è confermato
  - Se un utente cancella l'account, rimuoviamo i punti dal referrer
*/

-- Drop il trigger esistente che assegna punti automaticamente
DROP TRIGGER IF EXISTS trigger_process_referral ON subscriptions;

-- Aggiorna la funzione process_referral_on_subscription per NON assegnare punti automaticamente
-- Questa funzione ora serve solo per logging, i punti verranno assegnati manualmente
CREATE OR REPLACE FUNCTION process_referral_on_subscription()
RETURNS TRIGGER AS $$
BEGIN
  -- Non fare nulla automaticamente
  -- I punti verranno assegnati dal frontend dopo conferma pagamento
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crea funzione per confermare referral e assegnare punti
CREATE OR REPLACE FUNCTION confirm_referral_reward(
  p_referred_user_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  referrer_nickname text;
  referrer_id uuid;
  v_result jsonb;
BEGIN
  -- Verifica se l'utente è stato referito
  SELECT referred_by_nickname INTO referrer_nickname
  FROM profiles
  WHERE id = p_referred_user_id AND referred_by_nickname IS NOT NULL;

  IF referrer_nickname IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'message', 'Utente non referito'
    );
  END IF;

  -- Trova l'ID del referrer tramite il nickname
  SELECT id INTO referrer_id
  FROM profiles
  WHERE nickname = referrer_nickname
  LIMIT 1;

  IF referrer_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'message', 'Referrer non trovato'
    );
  END IF;

  -- Verifica se il referrer ha già ricevuto i punti per questo utente
  IF EXISTS (
    SELECT 1 FROM activity_log
    WHERE user_id = referrer_id
      AND activity_type = 'referral_reward'
      AND metadata->>'referred_user_id' = p_referred_user_id::text
  ) THEN
    RETURN jsonb_build_object(
      'success', false,
      'message', 'Punti già assegnati'
    );
  END IF;

  -- Assegna 30 punti al referrer
  PERFORM award_points(
    referrer_id,
    30,
    'referral',
    'Amico abbonato: ' || (SELECT COALESCE(nickname, email) FROM profiles WHERE id = p_referred_user_id)
  );

  -- Incrementa il contatore referrals_count in user_activity
  UPDATE user_activity
  SET referrals_count = referrals_count + 1
  WHERE user_id = referrer_id;

  -- Crea activity log
  INSERT INTO activity_log (
    user_id,
    activity_type,
    title,
    description,
    points_earned,
    metadata,
    icon,
    color
  ) VALUES (
    referrer_id,
    'referral_reward',
    'Bonus Amico Ricevuto!',
    'Hai guadagnato 30 punti grazie all''abbonamento del tuo amico',
    30,
    jsonb_build_object(
      'referred_user_id', p_referred_user_id
    ),
    'gift',
    'text-green-600'
  );

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Punti referral assegnati',
    'referrer_id', referrer_id,
    'points_awarded', 30
  );
END;
$$;

-- Crea funzione per rimuovere punti referral quando un utente cancella l'account
CREATE OR REPLACE FUNCTION remove_referral_points_on_delete()
RETURNS TRIGGER AS $$
DECLARE
  referrer_nickname text;
  referrer_id uuid;
  points_to_remove integer;
BEGIN
  -- Verifica se l'utente era stato referito
  SELECT referred_by_nickname INTO referrer_nickname
  FROM profiles
  WHERE id = OLD.id AND referred_by_nickname IS NOT NULL;

  IF referrer_nickname IS NOT NULL THEN
    -- Trova l'ID del referrer
    SELECT id INTO referrer_id
    FROM profiles
    WHERE nickname = referrer_nickname
    LIMIT 1;

    IF referrer_id IS NOT NULL THEN
      -- Verifica se i punti erano stati assegnati
      SELECT points_earned INTO points_to_remove
      FROM activity_log
      WHERE user_id = referrer_id
        AND activity_type = 'referral_reward'
        AND metadata->>'referred_user_id' = OLD.id::text
      LIMIT 1;

      IF points_to_remove IS NOT NULL THEN
        -- Rimuovi i punti dal referrer
        UPDATE user_activity
        SET total_points = GREATEST(0, total_points - points_to_remove),
            referrals_count = GREATEST(0, referrals_count - 1)
        WHERE user_id = referrer_id;

        -- Rimuovi il contatore referral_count dal profilo
        UPDATE profiles
        SET referral_count = GREATEST(0, referral_count - 1)
        WHERE id = referrer_id;

        -- Crea activity log per la rimozione punti
        INSERT INTO activity_log (
          user_id,
          activity_type,
          title,
          description,
          points_earned,
          metadata,
          icon,
          color
        ) VALUES (
          referrer_id,
          'points_removed',
          'Punti Referral Rimossi',
          'I punti referral sono stati rimossi perché l''amico ha cancellato l''account',
          -points_to_remove,
          jsonb_build_object(
            'reason', 'referred_user_deleted',
            'referred_user_id', OLD.id
          ),
          'alert-triangle',
          'text-red-600'
        );

        -- Elimina l'activity log del referral originale
        DELETE FROM activity_log
        WHERE user_id = referrer_id
          AND activity_type = 'referral_reward'
          AND metadata->>'referred_user_id' = OLD.id::text;
      END IF;
    END IF;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crea trigger per rimuovere punti quando un utente cancella l'account
DROP TRIGGER IF EXISTS trigger_remove_referral_points ON profiles;
CREATE TRIGGER trigger_remove_referral_points
  BEFORE DELETE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION remove_referral_points_on_delete();

-- Grant execute permission
GRANT EXECUTE ON FUNCTION confirm_referral_reward(uuid) TO authenticated;
