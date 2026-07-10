/*
  # Update review points: 25 base, 50 with proof

  1. Changes
    - Update approve_review function to award 50 points for reviews with proof
    - Award 25 points for reviews without proof
    - Simplifies the point system to just two tiers based on proof presence

  2. Notes
    - Reviews with proof (receipt/invoice): 50 points after approval
    - Reviews without proof: 25 points, published immediately
*/

-- Aggiorna la funzione per approvare una recensione
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
  
  -- Assegna punti in base alla presenza di prova d'acquisto
  IF review_record.proof_image_url IS NOT NULL THEN
    points_to_award := 50; -- Con prova d'acquisto
  ELSE
    points_to_award := 25; -- Senza prova d'acquisto
  END IF;
  
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
