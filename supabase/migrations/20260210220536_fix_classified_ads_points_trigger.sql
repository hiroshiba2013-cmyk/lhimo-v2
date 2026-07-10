/*
  # Fix Classified Ads Points Trigger

  ## Overview
  Fixes the award_points_for_classified_ad function to use the correct column name user_id instead of owner_id.

  ## Changes
  1. Update the function award_points_for_classified_ad to use NEW.user_id instead of NEW.owner_id
  
  ## Notes
  - The classified_ads table uses user_id, not owner_id
  - This was causing an error when users tried to publish classified ads
*/

-- Fix the function to use the correct column name
CREATE OR REPLACE FUNCTION award_points_for_classified_ad()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 5 punti al proprietario dell'annuncio usando user_id
  PERFORM award_points(NEW.user_id, 5, 'classified_ad', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
