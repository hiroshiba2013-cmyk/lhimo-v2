/*
  # Sottrai Punti quando Attività o Annunci vengono Eliminati

  ## Panoramica
  Aggiunge trigger per sottrarre automaticamente i punti dalla classifica quando:
  - Un annuncio classificato viene eliminato (sottrae 5 punti)
  - Un'attività unclaimed viene eliminata (sottrae 10-25 punti in base ai dati)

  ## Modifiche
  1. Crea funzione per sottrarre punti quando un annuncio classificato viene eliminato
  2. Crea trigger per annunci classificati eliminati
  3. Crea funzione per sottrarre punti quando un'attività unclaimed viene eliminata
  4. Crea trigger per attività unclaimed eliminate

  ## Note
  - I punti vengono sottratti automaticamente per mantenere la classifica accurata
  - Gli annunci danno 5 punti, quindi vengono sottratti 5 punti
  - Le attività danno 10 punti (base) o 25 punti (con email/telefono)
*/

-- Funzione per sottrarre punti quando viene eliminato un annuncio classificato
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_classified_ad()
RETURNS TRIGGER AS $$
BEGIN
  -- Sottrai 5 punti al proprietario dell'annuncio
  PERFORM award_points(OLD.user_id, -5, 'classified_ad_deleted', OLD.id::text);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per annunci classificati eliminati
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_classified_ad ON classified_ads;
CREATE TRIGGER trigger_subtract_points_deleted_classified_ad
  BEFORE DELETE ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_classified_ad();

-- Funzione per sottrarre punti quando viene eliminata un'attività unclaimed
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_unclaimed_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
BEGIN
  -- Calcola i punti in base ai dati presenti
  IF (OLD.email IS NOT NULL AND OLD.email != '') OR (OLD.phone IS NOT NULL AND OLD.phone != '') THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  -- Sottrai i punti all'utente che ha aggiunto l'attività
  PERFORM award_points(OLD.added_by, -points_to_subtract, 'business_deleted', OLD.id::text);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per attività unclaimed eliminate
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_unclaimed_business ON unclaimed_business_locations;
CREATE TRIGGER trigger_subtract_points_deleted_unclaimed_business
  BEFORE DELETE ON unclaimed_business_locations
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_unclaimed_business();
