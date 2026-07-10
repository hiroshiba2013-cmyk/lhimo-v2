/*
  # Fix Referral System - Correggi Colonna referred_by
  
  ## Problema
  La funzione `process_referral_on_subscription` cerca di accedere alla colonna `referred_by`
  che non esiste nella tabella profiles. La colonna corretta è `referred_by_nickname`.
  
  ## Modifiche
  - Aggiorna la funzione per usare `referred_by_nickname` invece di `referred_by`
  - Elimina il riferimento alla tabella `referrals` che non sembra essere usata correttamente
*/

-- Ricrea la funzione corretta
CREATE OR REPLACE FUNCTION process_referral_on_subscription()
RETURNS TRIGGER AS $$
DECLARE
  referrer_nickname text;
  referrer_id uuid;
BEGIN
  -- Verifica se l'utente è stato referito
  SELECT referred_by_nickname INTO referrer_nickname
  FROM profiles
  WHERE id = NEW.customer_id AND referred_by_nickname IS NOT NULL;
  
  IF referrer_nickname IS NOT NULL THEN
    -- Trova l'ID del referrer tramite il nickname
    SELECT id INTO referrer_id
    FROM profiles
    WHERE nickname = referrer_nickname
    LIMIT 1;
    
    IF referrer_id IS NOT NULL THEN
      -- Assegna 30 punti al referrer
      PERFORM award_points(referrer_id, 30, 'referral', 'Amico abbonato: ' || (SELECT nickname FROM profiles WHERE id = NEW.customer_id));
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;