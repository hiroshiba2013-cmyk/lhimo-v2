/*
  # Sistema Referral "Ti presenta un amico?"

  1. Modifiche
    - Aggiunge colonna `referred_by_nickname` alla tabella `profiles`
    - Aggiunge colonna `referral_count` alla tabella `profiles`
    - Crea funzione `process_referral` per elaborare i referral
    - Assegna automaticamente 30 punti all'utente che ha invitato

  2. Funzionalità
    - Quando un nuovo utente si registra con un nickname referral:
      - Verifica che il nickname esista
      - Salva il nickname nella colonna `referred_by_nickname`
      - Incrementa il contatore `referral_count` dell'utente che ha invitato
      - Assegna 30 punti automaticamente tramite la funzione `award_points`
*/

-- Aggiungi colonne per il sistema referral
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'referred_by_nickname'
  ) THEN
    ALTER TABLE profiles ADD COLUMN referred_by_nickname text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'referral_count'
  ) THEN
    ALTER TABLE profiles ADD COLUMN referral_count integer DEFAULT 0 NOT NULL;
  END IF;
END $$;

-- Elimina la funzione esistente se presente
DROP FUNCTION IF EXISTS process_referral(uuid, text);

-- Crea funzione per elaborare il referral
CREATE OR REPLACE FUNCTION process_referral(
  p_new_user_id uuid,
  p_referrer_nickname text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_referrer_id uuid;
BEGIN
  -- Trova l'ID dell'utente che ha invitato tramite nickname
  SELECT id INTO v_referrer_id
  FROM profiles
  WHERE nickname = p_referrer_nickname
  LIMIT 1;

  -- Se il referrer esiste
  IF v_referrer_id IS NOT NULL THEN
    -- Salva il nickname del referrer nel profilo del nuovo utente
    UPDATE profiles
    SET referred_by_nickname = p_referrer_nickname
    WHERE id = p_new_user_id;

    -- Incrementa il contatore di referral del referrer
    UPDATE profiles
    SET referral_count = referral_count + 1
    WHERE id = v_referrer_id;

    -- Assegna 30 punti al referrer usando la funzione esistente
    PERFORM award_points(
      v_referrer_id,
      30,
      'referral',
      'Nuovo amico registrato: ' || (SELECT nickname FROM profiles WHERE id = p_new_user_id)
    );
  END IF;
END;
$$;