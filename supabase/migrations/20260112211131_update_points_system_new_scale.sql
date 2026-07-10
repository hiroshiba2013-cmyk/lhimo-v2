/*
  # Aggiornamento Sistema Punti - Nuova Scala

  ## Modifiche
  
  1. Aggiorna la funzione `approve_review` per nuova scala punti:
     - 50 punti: Recensione completa (con tutti i rating dettagliati)
     - 25 punti: Recensione base (solo voto finale)
  
  2. Crea trigger per assegnare punti automaticamente:
     - 5 punti: Annuncio pubblicato (classified_ads)
     - 10 punti: Prodotto inserito (products)
     - 20 punti: Attività inserita (business_locations non reclamate)
  
  3. Aggiorna sistema referral:
     - 30 punti: Presenta un amico (quando l'amico si abbona)
  
  ## Note
  - I punti vengono assegnati solo per azioni valide
  - Il sistema supporta sia utenti principali che membri della famiglia
*/

-- Aggiorna funzione approve_review con nuova scala punti
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Ottieni i dettagli della recensione
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Calcola i punti da assegnare
  IF review_record.price_rating IS NOT NULL AND 
     review_record.service_rating IS NOT NULL AND 
     review_record.quality_rating IS NOT NULL THEN
    points_to_award := 50; -- Recensione completa
  ELSE
    points_to_award := 25; -- Recensione base (solo voto finale)
  END IF;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Cancella l'immagine dopo l'approvazione
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente (customer_id o family_member_id)
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', review_id_param::text);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per assegnare punti quando viene inserito un annuncio
CREATE OR REPLACE FUNCTION award_points_for_classified_ad()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 5 punti al proprietario dell'annuncio
  PERFORM award_points(NEW.owner_id, 5, 'classified_ad', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per annunci pubblicati
DROP TRIGGER IF EXISTS trigger_award_points_classified_ad ON classified_ads;
CREATE TRIGGER trigger_award_points_classified_ad
  AFTER INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_classified_ad();

-- Funzione per assegnare punti quando viene inserito un prodotto
CREATE OR REPLACE FUNCTION award_points_for_product()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 10 punti al business che inserisce il prodotto
  PERFORM award_points(NEW.business_id, 10, 'product', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per prodotti inseriti
DROP TRIGGER IF EXISTS trigger_award_points_product ON products;
CREATE TRIGGER trigger_award_points_product
  AFTER INSERT ON products
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_product();

-- Funzione per assegnare punti quando viene inserita un'attività non reclamata
CREATE OR REPLACE FUNCTION award_points_for_business_location()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 20 punti all'utente che ha inserito l'attività (se specificato)
  IF NEW.created_by IS NOT NULL THEN
    PERFORM award_points(NEW.created_by, 20, 'business_location', NEW.id::text);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aggiungi colonna created_by se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'created_by'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN created_by uuid REFERENCES profiles(id);
    CREATE INDEX IF NOT EXISTS idx_business_locations_created_by ON business_locations(created_by);
  END IF;
END $$;

-- Trigger per attività inserite
DROP TRIGGER IF EXISTS trigger_award_points_business_location ON business_locations;
CREATE TRIGGER trigger_award_points_business_location
  AFTER INSERT ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_business_location();

-- Aggiorna funzione referral per assegnare 30 punti
CREATE OR REPLACE FUNCTION process_referral_on_subscription()
RETURNS TRIGGER AS $$
DECLARE
  referrer_id uuid;
BEGIN
  -- Verifica se l'utente è stato referito
  SELECT referred_by INTO referrer_id
  FROM profiles
  WHERE id = NEW.user_id AND referred_by IS NOT NULL;
  
  IF referrer_id IS NOT NULL THEN
    -- Assegna 30 punti al referrer
    PERFORM award_points(referrer_id, 30, 'referral', NEW.user_id::text);
    
    -- Registra il referral come completato
    UPDATE referrals
    SET status = 'completed',
        completed_at = now()
    WHERE referrer_id = referrer_id
      AND referred_user_id = NEW.user_id
      AND status = 'pending';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per referral
DROP TRIGGER IF EXISTS trigger_process_referral ON subscriptions;
CREATE TRIGGER trigger_process_referral
  AFTER INSERT ON subscriptions
  FOR EACH ROW
  WHEN (NEW.status = 'active')
  EXECUTE FUNCTION process_referral_on_subscription();
