/*
  # Sistema Completo di Tracciamento Attività

  ## Panoramica
  Aggiunge tutte le colonne mancanti per tracciare completamente le attività degli utenti
  nella classifica, incluse attività aggiunte e annunci classificati.

  ## Modifiche
  1. Aggiunge colonne a user_activity:
     - businesses_added_count: Numero di attività aggiunte (entrambe le tabelle)
     - ads_posted_count: Numero di annunci classificati pubblicati
  
  2. Crea trigger per:
     - Tracciare inserimento attività (unclaimed_business_locations e user_added_businesses)
     - Tracciare inserimento annunci classificati
     - Aggiornare i contatori quando vengono eliminati

  3. Aggiorna la funzione get_user_activity_summary per includere tutti i dati

  ## Sistema Punti (per riferimento)
  - Attività base (solo nome e indirizzo): +10 punti
  - Attività completa (con email/telefono/sito): +25 punti
  - Annuncio classificato: +5 punti
  - Recensione base: +25 punti
  - Recensione con valutazioni dettagliate: +50 punti
*/

-- Aggiungi colonne mancanti a user_activity
ALTER TABLE user_activity 
ADD COLUMN IF NOT EXISTS businesses_added_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS ads_posted_count INTEGER DEFAULT 0;

-- ========================================
-- TRIGGER PER UNCLAIMED_BUSINESS_LOCATIONS
-- ========================================

-- Funzione per incrementare il contatore quando viene aggiunta un'attività non reclamata
CREATE OR REPLACE FUNCTION increment_unclaimed_business_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Incrementa il contatore per l'utente che ha aggiunto l'attività
  INSERT INTO user_activity (user_id, businesses_added_count, last_activity_at, created_at, updated_at)
  VALUES (NEW.added_by, 1, now(), now(), now())
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    businesses_added_count = user_activity.businesses_added_count + 1,
    last_activity_at = now(),
    updated_at = now();

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per incrementare il contatore
DROP TRIGGER IF EXISTS trigger_increment_unclaimed_business_count ON unclaimed_business_locations;
CREATE TRIGGER trigger_increment_unclaimed_business_count
  AFTER INSERT ON unclaimed_business_locations
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION increment_unclaimed_business_count();

-- Funzione per decrementare il contatore
CREATE OR REPLACE FUNCTION decrement_unclaimed_business_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrementa il contatore
  UPDATE user_activity
  SET 
    businesses_added_count = GREATEST(0, businesses_added_count - 1),
    last_activity_at = now(),
    updated_at = now()
  WHERE user_id = OLD.added_by;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per decrementare il contatore
DROP TRIGGER IF EXISTS trigger_decrement_unclaimed_business_count ON unclaimed_business_locations;
CREATE TRIGGER trigger_decrement_unclaimed_business_count
  AFTER DELETE ON unclaimed_business_locations
  FOR EACH ROW
  WHEN (OLD.added_by IS NOT NULL)
  EXECUTE FUNCTION decrement_unclaimed_business_count();

-- ========================================
-- TRIGGER PER USER_ADDED_BUSINESSES
-- ========================================

-- Funzione per incrementare il contatore quando viene aggiunta un'attività dall'utente
CREATE OR REPLACE FUNCTION increment_user_added_business_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Incrementa il contatore per l'utente che ha aggiunto l'attività
  INSERT INTO user_activity (user_id, businesses_added_count, last_activity_at, created_at, updated_at)
  VALUES (NEW.added_by, 1, now(), now(), now())
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    businesses_added_count = user_activity.businesses_added_count + 1,
    last_activity_at = now(),
    updated_at = now();

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per incrementare il contatore
DROP TRIGGER IF EXISTS trigger_increment_user_added_business_count ON user_added_businesses;
CREATE TRIGGER trigger_increment_user_added_business_count
  AFTER INSERT ON user_added_businesses
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION increment_user_added_business_count();

-- Funzione per decrementare il contatore
CREATE OR REPLACE FUNCTION decrement_user_added_business_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrementa il contatore
  UPDATE user_activity
  SET 
    businesses_added_count = GREATEST(0, businesses_added_count - 1),
    last_activity_at = now(),
    updated_at = now()
  WHERE user_id = OLD.added_by;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per decrementare il contatore
DROP TRIGGER IF EXISTS trigger_decrement_user_added_business_count ON user_added_businesses;
CREATE TRIGGER trigger_decrement_user_added_business_count
  AFTER DELETE ON user_added_businesses
  FOR EACH ROW
  WHEN (OLD.added_by IS NOT NULL)
  EXECUTE FUNCTION decrement_user_added_business_count();

-- ========================================
-- TRIGGER PER CLASSIFIED_ADS
-- ========================================

-- Funzione per incrementare il contatore degli annunci
CREATE OR REPLACE FUNCTION increment_ads_posted_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Incrementa il contatore per l'utente che ha pubblicato l'annuncio
  INSERT INTO user_activity (user_id, ads_posted_count, last_activity_at, created_at, updated_at)
  VALUES (NEW.user_id, 1, now(), now(), now())
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    ads_posted_count = user_activity.ads_posted_count + 1,
    last_activity_at = now(),
    updated_at = now();

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per incrementare il contatore annunci
DROP TRIGGER IF EXISTS trigger_increment_ads_posted_count ON classified_ads;
CREATE TRIGGER trigger_increment_ads_posted_count
  AFTER INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION increment_ads_posted_count();

-- Funzione per decrementare il contatore degli annunci
CREATE OR REPLACE FUNCTION decrement_ads_posted_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrementa il contatore
  UPDATE user_activity
  SET 
    ads_posted_count = GREATEST(0, ads_posted_count - 1),
    last_activity_at = now(),
    updated_at = now()
  WHERE user_id = OLD.user_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per decrementare il contatore annunci
DROP TRIGGER IF EXISTS trigger_decrement_ads_posted_count ON classified_ads;
CREATE TRIGGER trigger_decrement_ads_posted_count
  AFTER DELETE ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION decrement_ads_posted_count();

-- ========================================
-- FUNZIONE SUMMARY
-- ========================================

-- Elimina la vecchia funzione e ricreala con la nuova struttura
DROP FUNCTION IF EXISTS get_user_activity_summary(UUID);

CREATE FUNCTION get_user_activity_summary(p_user_id UUID)
RETURNS TABLE (
  total_activities INTEGER,
  total_points_earned INTEGER,
  activities_this_week INTEGER,
  activities_this_month INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*)::INTEGER as total_activities,
    COALESCE(SUM(points_earned), 0)::INTEGER as total_points_earned,
    COUNT(CASE WHEN created_at >= NOW() - INTERVAL '7 days' THEN 1 END)::INTEGER as activities_this_week,
    COUNT(CASE WHEN created_at >= NOW() - INTERVAL '30 days' THEN 1 END)::INTEGER as activities_this_month
  FROM activity_log
  WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Popola i dati esistenti nei nuovi contatori
UPDATE user_activity ua
SET 
  businesses_added_count = COALESCE((
    SELECT COUNT(*)
    FROM unclaimed_business_locations ubl
    WHERE ubl.added_by = ua.user_id
  ), 0) + COALESCE((
    SELECT COUNT(*)
    FROM user_added_businesses uab
    WHERE uab.added_by = ua.user_id
  ), 0),
  ads_posted_count = COALESCE((
    SELECT COUNT(*)
    FROM classified_ads ca
    WHERE ca.user_id = ua.user_id
  ), 0),
  updated_at = now()
WHERE true;
