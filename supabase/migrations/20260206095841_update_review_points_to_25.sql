/*
  # Update review points system to fixed 25 points

  1. Changes
    - Update approve_review function to award 25 points for all reviews regardless of details or proof
    - Simplify points logic: all approved reviews give 25 points

  2. Notes
    - This ensures consistent rewards for all user reviews
    - Encourages participation without complex calculations
*/

-- Aggiorna la funzione per approvare una recensione con 25 punti fissi
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
  
  -- Tutte le recensioni danno 25 punti
  points_to_award := 25;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
