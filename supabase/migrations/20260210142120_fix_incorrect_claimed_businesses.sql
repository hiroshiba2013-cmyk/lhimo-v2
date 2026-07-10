/*
  # Fix Incorrect Claimed Businesses
  
  ## Problema Risolto
  Una migrazione precedente aveva erroneamente marcato tutte le businesses come rivendicate (is_claimed = true),
  anche se non avevano un proprietario (owner_id = NULL). Questo ha causato confusione nel sistema.
  
  ## Modifiche
  1. Correzione Dati
    - Imposta is_claimed = false per tutte le businesses senza owner_id
    - Rimuove claimed_at per businesses non rivendicate
    - Rimuove verification_badge per businesses non rivendicate
  
  2. Regola di Integrità
    - Una business può essere is_claimed = true SOLO se ha un owner_id
    - Aggiunge un constraint per garantire questa regola
  
  ## Nota di Sicurezza
  Questo fix garantisce che solo le attività effettivamente rivendicate da un utente
  siano marcate come tali nel sistema.
*/

-- Correggi le businesses erroneamente marcate come rivendicate
UPDATE businesses
SET 
  is_claimed = false,
  claimed_at = NULL,
  verification_badge = NULL
WHERE owner_id IS NULL AND is_claimed = true;

-- Aggiungi un constraint per garantire l'integrità dei dati
-- Una business può essere claimed solo se ha un owner_id
ALTER TABLE businesses
DROP CONSTRAINT IF EXISTS check_claimed_requires_owner;

ALTER TABLE businesses
ADD CONSTRAINT check_claimed_requires_owner 
CHECK (
  (is_claimed = false OR is_claimed IS NULL) OR 
  (is_claimed = true AND owner_id IS NOT NULL)
);

-- Aggiorna il trigger per rispettare questa regola
CREATE OR REPLACE FUNCTION set_business_claimed_at()
RETURNS TRIGGER AS $$
BEGIN
  -- Imposta claimed_at solo se is_claimed = true E owner_id non è NULL
  IF NEW.is_claimed = true AND NEW.owner_id IS NOT NULL AND NEW.claimed_at IS NULL THEN
    NEW.claimed_at := now();
  END IF;
  
  -- Rimuovi claimed_at se is_claimed = false o owner_id è NULL
  IF NEW.is_claimed = false OR NEW.owner_id IS NULL THEN
    NEW.claimed_at := NULL;
    NEW.verification_badge := NULL;
  END IF;
  
  -- Imposta verification_badge solo se is_claimed = true E owner_id non è NULL
  IF NEW.is_claimed = true AND NEW.owner_id IS NOT NULL AND NEW.verification_badge IS NULL THEN
    NEW.verification_badge := CASE 
      WHEN NEW.verified = true THEN 'verified'
      ELSE 'claimed'
    END;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crea un indice per velocizzare le query sulle businesses rivendicate
CREATE INDEX IF NOT EXISTS idx_businesses_owner_claimed 
ON businesses(owner_id, is_claimed) 
WHERE owner_id IS NOT NULL AND is_claimed = true;

-- Commento sulla tabella per documentare la regola
COMMENT ON CONSTRAINT check_claimed_requires_owner ON businesses IS 
'Garantisce che una business possa essere marcata come rivendicata (is_claimed=true) solo se ha un proprietario (owner_id NOT NULL)';
