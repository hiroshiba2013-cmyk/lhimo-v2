/*
  # Aggiorna funzione approve_review per gestione immagini proof

  ## Panoramica
  Migliora la funzione approve_review per gestire correttamente le immagini di prova:
  - L'immagine viene eliminata dopo approvazione/rifiuto
  - Se l'immagine viene rimossa PRIMA dell'approvazione, assegna 25 punti
  - Se l'immagine è presente durante l'approvazione, assegna 50 punti

  ## Modifiche
  1. La funzione controlla proof_image_url al momento dell'approvazione
  2. Punti: 50 se c'è immagine, 25 se non c'è
  3. L'immagine viene sempre rimossa dopo l'approvazione

  ## Note
  - L'eliminazione fisica del file è gestita dal frontend
  - Il database rimuove solo il riferimento
  - Questo permette di approvare una recensione con prova ma dare solo 25 punti
    (utile quando l'immagine non è valida)
*/

-- Aggiorna la funzione approve_review per gestire correttamente le immagini
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
  -- Get review details
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- IMPORTANTE: Controlla proof_image_url AL MOMENTO DELL'APPROVAZIONE
  -- Se il frontend ha già rimosso l'immagine (approveReviewWithoutProof), 
  -- proof_image_url sarà NULL e assegnerà 25 punti
  -- Se l'immagine è ancora presente, assegnerà 50 punti
  IF review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '' THEN
    points_to_award := 50; -- With valid proof of purchase
  ELSE
    points_to_award := 25; -- Without proof or proof rejected
  END IF;
  
  -- Update review status and remove image reference
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Always remove image reference after approval
  WHERE id = review_id_param;
  
  -- Award points to user
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
  
  -- Log activity
  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'review_approved',
    jsonb_build_object(
      'review_id', review_id_param,
      'points_awarded', points_to_award,
      'had_proof', (review_record.proof_image_url IS NOT NULL)
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aggiorna anche la funzione reject_review per eliminare l'immagine
CREATE OR REPLACE FUNCTION reject_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
BEGIN
  -- Get review details
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Update review status and remove image reference
  UPDATE reviews 
  SET review_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = 0,
      proof_image_url = NULL -- Remove image reference on rejection
  WHERE id = review_id_param;
  
  -- Log activity
  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'review_rejected',
    jsonb_build_object(
      'review_id', review_id_param,
      'had_proof', (review_record.proof_image_url IS NOT NULL)
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Commento esplicativo
COMMENT ON FUNCTION approve_review IS 
'Approva una recensione e assegna punti: 50 se c''è prova valida, 25 altrimenti. L''immagine viene sempre rimossa dopo l''approvazione.';

COMMENT ON FUNCTION reject_review IS 
'Rifiuta una recensione e rimuove l''immagine di prova se presente. Non assegna punti.';
