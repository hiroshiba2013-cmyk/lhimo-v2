-- ============================================================
-- FILE: 20260303213455_subtract_points_on_job_posting_delete.sql
-- ============================================================
/*
  # Sottrai Punti quando Annunci di Lavoro vengono Eliminati

  ## Panoramica
  Aggiunge trigger per sottrarre automaticamente i punti dalla classifica quando un annuncio di lavoro viene eliminato.
  Gli annunci di lavoro assegnano 3 punti alla creazione.

  ## Modifiche
  1. Crea funzione per sottrarre punti quando un annuncio di lavoro viene eliminato
  2. Crea trigger per annunci di lavoro eliminati

  ## Note
  - I punti vengono sottratti automaticamente per mantenere la classifica accurata
  - Gli annunci di lavoro danno 3 punti, quindi vengono sottratti 3 punti
*/

-- Funzione per sottrarre punti quando viene eliminato un annuncio di lavoro
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'ID del proprietario dalla business location
  SELECT owner_id INTO v_owner_id
  FROM business_locations
  WHERE id = OLD.business_location_id;

  -- Sottrai 3 punti al proprietario dell'attività
  IF v_owner_id IS NOT NULL THEN
    PERFORM award_points(v_owner_id, -3, 'job_posting_deleted', OLD.id::text);
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per annunci di lavoro eliminati
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_job_posting ON job_postings;
CREATE TRIGGER trigger_subtract_points_deleted_job_posting
  BEFORE DELETE ON job_postings
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_job_posting();

-- Grant necessari
GRANT EXECUTE ON FUNCTION subtract_points_for_deleted_job_posting() TO authenticated;


-- ============================================================
-- FILE: 20260303213802_remove_job_posting_points_system.sql
-- ============================================================
/*
  # Rimuovi Sistema Punti per Annunci di Lavoro

  ## Panoramica
  Rimuove completamente il sistema di punti per gli annunci di lavoro.
  Gli annunci di lavoro non dovrebbero assegnare né sottrarre punti.

  ## Modifiche
  1. Rimuove il trigger per l'assegnazione punti alla creazione
  2. Rimuove il trigger per la sottrazione punti all'eliminazione
  3. Rimuove le funzioni associate

  ## Note
  - Gli annunci di lavoro sono ora completamente esclusi dal sistema punti
  - Questo non influisce sugli altri sistemi di punti (recensioni, attività, annunci classificati)
*/

-- Rimuovi il trigger per l'assegnazione punti alla creazione di annunci di lavoro
DROP TRIGGER IF EXISTS trigger_award_points_job_posting ON job_postings;

-- Rimuovi il trigger per la sottrazione punti all'eliminazione di annunci di lavoro
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_job_posting ON job_postings;

-- Rimuovi le funzioni associate
DROP FUNCTION IF EXISTS award_points_for_job_posting();
DROP FUNCTION IF EXISTS subtract_points_for_deleted_job_posting();


-- ============================================================
-- FILE: 20260303214823_fix_user_activity_tracking_system_final.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260303215649_fix_business_addition_points_system.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260303220617_fix_solidarity_counters_exclude_trials.sql
-- ============================================================
/*
  # Correzione Contatori Solidarietà - Esclusione Trial

  ## Problema
  I contatori di fatturato e solidarietà mostrano valori anche per abbonamenti in prova gratuita (status='trial').
  Gli abbonamenti in trial NON devono essere contati nel fatturato perché sono gratuiti.

  ## Soluzione
  1. Aggiorna `get_total_revenue` per contare SOLO abbonamenti attivi (status='active')
  2. Aggiorna `get_subscription_stats` per sincronizzarsi con la tabella subscriptions
  3. I trial devono essere mostrati separatamente, non nel fatturato

  ## Logica
  - Fatturato = somma dei prezzi di abbonamenti con status='active' 
  - Trial = abbonamenti con status='trial' (mostrati separatamente)
  - Expired = abbonamenti con status='expired' o 'cancelled' (non contati)
*/

-- ========================================
-- FUNZIONE CORRETTA: get_total_revenue
-- ========================================

CREATE OR REPLACE FUNCTION get_total_revenue()
RETURNS DECIMAL(12, 2) AS $$
DECLARE
  total_revenue DECIMAL(12, 2);
BEGIN
  -- Somma solo i prezzi dei piani di abbonamenti ATTIVI (non trial, non expired)
  SELECT COALESCE(SUM(sp.price), 0)
  INTO total_revenue
  FROM subscriptions s
  INNER JOIN subscription_plans sp ON s.plan_id = sp.id
  WHERE s.status = 'active';  -- SOLO abbonamenti attivi

  RETURN total_revenue;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- FUNZIONE CORRETTA: get_subscription_stats
-- ========================================

CREATE OR REPLACE FUNCTION get_subscription_stats()
RETURNS JSONB AS $$
DECLARE
  stats JSONB;
BEGIN
  SELECT jsonb_build_object(
    'totalActive',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active'
    ),
    'customerMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'customer' 
        AND sp.billing_period = 'monthly'
    ),
    'customerYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'customer' 
        AND sp.billing_period = 'annual'
    ),
    'businessMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'business' 
        AND sp.billing_period = 'monthly'
    ),
    'businessYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'business' 
        AND sp.billing_period = 'annual'
    ),
    'trialUsers',
    (
      SELECT COUNT(*)
      FROM subscriptions
      WHERE status = 'trial'
    )
  ) INTO stats;

  RETURN stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- COMMENTI E NOTE
-- ========================================

-- Questa migrazione corregge i contatori nella sezione solidarietà:
-- 
-- PRIMA:
-- - Fatturato Totale: €0,49 (include trial gratuiti)
-- - Solidarietà: €0,05 (10% di €0,49)
-- - Abbonamenti Attivi: valori non sincronizzati
--
-- DOPO:
-- - Fatturato Totale: €0,00 (nessun abbonamento attivo pagante)
-- - Solidarietà: €0,00 (10% di €0,00)
-- - Abbonamenti Attivi: 0 (solo trial, mostrati separatamente)
-- - Utenti in Trial: 1 (mostrato nella card purple)


