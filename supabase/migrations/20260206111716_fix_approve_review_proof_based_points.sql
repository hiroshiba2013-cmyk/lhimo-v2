/*
  # Fix approve_review to use proof-based points

  1. Changes
    - Update approve_review function to award points based on proof_image_url presence
    - 50 points: Reviews with proof of purchase (receipt/invoice)
    - 25 points: Reviews without proof
    - Points are awarded only when staff approves the review

  2. Notes
    - All reviews start as 'pending' regardless of proof
    - Staff must approve all reviews before they become public
    - Points are awarded during approval based on proof presence
*/

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
  
  -- Award points based on proof presence
  IF review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '' THEN
    points_to_award := 50; -- With proof of purchase
  ELSE
    points_to_award := 25; -- Without proof
  END IF;
  
  -- Update review
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Delete image after approval
  WHERE id = review_id_param;
  
  -- Award points to user
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
