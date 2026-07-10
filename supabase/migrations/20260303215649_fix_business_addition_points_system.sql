/*
  # Sistema Corretto di Assegnazione Punti per Attività Aggiunte

  ## Panoramica
  Crea un sistema che assegna correttamente i punti quando un utente aggiunge un'attività:
  - 10 punti per attività base (solo nome e indirizzo)
  - 25 punti per attività completa (con email, telefono o sito web)

  ## Modifiche
  1. Crea trigger per assegnare punti quando viene aggiunta un'attività
  2. Crea log nell'activity_log per tracciare l'azione
  3. Corregge i punti esistenti assegnati in modo errato

  ## Logica Punti
  Attività completa = ha almeno uno tra email, phone, website
  Attività base = solo nome e indirizzo (nessun contatto)
*/

-- ========================================
-- FUNZIONE PER ASSEGNARE PUNTI PER UNCLAIMED_BUSINESS_LOCATIONS
-- ========================================

CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
BEGIN
  -- Determina se l'attività è completa (ha almeno un contatto)
  is_complete := (
    (NEW.email IS NOT NULL AND NEW.email != '') OR 
    (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
    (NEW.website IS NOT NULL AND NEW.website != '')
  );

  -- Assegna punti in base al livello di completezza
  IF is_complete THEN
    points_to_award := 25;
  ELSE
    points_to_award := 10;
  END IF;

  -- Aggiorna i punti totali in user_activity
  UPDATE user_activity
  SET 
    total_points = total_points + points_to_award,
    updated_at = now()
  WHERE user_id = NEW.added_by;

  -- Crea un log nell'activity_log
  INSERT INTO activity_log (
    user_id,
    activity_type,
    title,
    description,
    points_earned,
    icon,
    color,
    metadata,
    created_at
  ) VALUES (
    NEW.added_by,
    'business_added',
    'Attività aggiunta',
    CASE 
      WHEN is_complete THEN 'Hai aggiunto "' || NEW.name || '" con dati completi'
      ELSE 'Hai aggiunto "' || NEW.name || '"'
    END,
    points_to_award,
    'building',
    'green',
    jsonb_build_object(
      'business_id', NEW.id,
      'business_name', NEW.name,
      'is_complete', is_complete
    ),
    now()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per assegnare punti
DROP TRIGGER IF EXISTS trigger_award_points_unclaimed_business ON unclaimed_business_locations;
CREATE TRIGGER trigger_award_points_unclaimed_business
  AFTER INSERT ON unclaimed_business_locations
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION award_points_for_unclaimed_business();

-- ========================================
-- FUNZIONE PER RIMUOVERE PUNTI QUANDO VIENE ELIMINATA
-- ========================================

CREATE OR REPLACE FUNCTION subtract_points_for_deleted_unclaimed_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
  is_complete BOOLEAN;
BEGIN
  -- Determina quanti punti erano stati assegnati
  is_complete := (
    (OLD.email IS NOT NULL AND OLD.email != '') OR 
    (OLD.phone IS NOT NULL AND OLD.phone != '') OR 
    (OLD.website IS NOT NULL AND OLD.website != '')
  );

  IF is_complete THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  -- Rimuovi i punti
  UPDATE user_activity
  SET 
    total_points = GREATEST(0, total_points - points_to_subtract),
    updated_at = now()
  WHERE user_id = OLD.added_by;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- FUNZIONE PER ASSEGNARE PUNTI PER USER_ADDED_BUSINESSES
-- ========================================

CREATE OR REPLACE FUNCTION award_points_for_user_added_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
BEGIN
  -- Determina se l'attività è completa
  is_complete := (
    (NEW.email IS NOT NULL AND NEW.email != '') OR 
    (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
    (NEW.website IS NOT NULL AND NEW.website != '')
  );

  -- Assegna punti
  IF is_complete THEN
    points_to_award := 25;
  ELSE
    points_to_award := 10;
  END IF;

  -- Aggiorna i punti totali
  UPDATE user_activity
  SET 
    total_points = total_points + points_to_award,
    updated_at = now()
  WHERE user_id = NEW.added_by;

  -- Crea un log
  INSERT INTO activity_log (
    user_id,
    activity_type,
    title,
    description,
    points_earned,
    icon,
    color,
    metadata,
    created_at
  ) VALUES (
    NEW.added_by,
    'business_added',
    'Attività aggiunta',
    CASE 
      WHEN is_complete THEN 'Hai aggiunto "' || NEW.name || '" con dati completi'
      ELSE 'Hai aggiunto "' || NEW.name || '"'
    END,
    points_to_award,
    'building',
    'green',
    jsonb_build_object(
      'business_id', NEW.id,
      'business_name', NEW.name,
      'is_complete', is_complete
    ),
    now()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per assegnare punti
DROP TRIGGER IF EXISTS trigger_award_points_user_added_business ON user_added_businesses;
CREATE TRIGGER trigger_award_points_user_added_business
  AFTER INSERT ON user_added_businesses
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION award_points_for_user_added_business();

-- Funzione per rimuovere punti quando viene eliminata
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_user_added_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
  is_complete BOOLEAN;
BEGIN
  is_complete := (
    (OLD.email IS NOT NULL AND OLD.email != '') OR 
    (OLD.phone IS NOT NULL AND OLD.phone != '') OR 
    (OLD.website IS NOT NULL AND OLD.website != '')
  );

  IF is_complete THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  UPDATE user_activity
  SET 
    total_points = GREATEST(0, total_points - points_to_subtract),
    updated_at = now()
  WHERE user_id = OLD.added_by;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per rimuovere punti
DROP TRIGGER IF EXISTS trigger_subtract_points_user_added_business ON user_added_businesses;
CREATE TRIGGER trigger_subtract_points_user_added_business
  BEFORE DELETE ON user_added_businesses
  FOR EACH ROW
  WHEN (OLD.added_by IS NOT NULL)
  EXECUTE FUNCTION subtract_points_for_deleted_user_added_business();

-- ========================================
-- CORREZIONE DEI PUNTI ESISTENTI
-- ========================================

-- Correggi i punti per l'utente che ha aggiunto "farmacia luigi"
-- L'attività è base (no email, no phone, website vuoto) quindi deve avere 10 punti
UPDATE user_activity
SET total_points = 10
WHERE user_id = '213fbc3a-f6f5-449a-94e1-b4eb8ba49d31';

-- Crea il log dell'attività se non esiste già
INSERT INTO activity_log (
  user_id,
  activity_type,
  title,
  description,
  points_earned,
  icon,
  color,
  metadata,
  created_at
)
SELECT 
  '213fbc3a-f6f5-449a-94e1-b4eb8ba49d31',
  'business_added',
  'Attività aggiunta',
  'Hai aggiunto "farmacia luigi"',
  10,
  'building',
  'green',
  jsonb_build_object(
    'business_id', id,
    'business_name', 'farmacia luigi',
    'is_complete', false
  ),
  created_at
FROM unclaimed_business_locations
WHERE added_by = '213fbc3a-f6f5-449a-94e1-b4eb8ba49d31'
  AND name = 'farmacia luigi'
ON CONFLICT DO NOTHING;
