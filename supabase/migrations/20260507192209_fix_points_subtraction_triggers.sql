/*
  # Fix points subtraction triggers

  ## Problems fixed:

  ### 1. subtract_points_for_deleted_review
  - Used `OLD.proof_url` but the column is named `proof_image_url`
  - This caused the proof check to always be false → always subtracted 25 pts
    instead of 50 for reviews that had proof documents
  - Also checks proof_documents array (like approve_review does)
  - Added GREATEST(0, ...) guard to prevent negative points

  ### 2. subtract_points_for_deleted_classified_ad
  - Called award_points(-5) without a floor, allowing negative total_points
  - Now uses direct UPDATE with GREATEST(0, total_points - 5) consistent
    with the unclaimed_business trigger style
  - Also respects family_member_id correctly

  Both triggers only subtract points if the item was already approved
  (points_awarded > 0), preventing double-subtraction on pending items.
*/

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. Fix review deletion trigger: correct column name + GREATEST guard
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_review()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  points_to_subtract INTEGER;
  has_proof BOOLEAN;
BEGIN
  -- Only subtract if points were actually awarded (review was approved)
  IF OLD.points_awarded IS NULL OR OLD.points_awarded = 0 THEN
    RETURN OLD;
  END IF;

  -- Match the same proof logic used in approve_review()
  has_proof := (
    (OLD.proof_image_url IS NOT NULL AND OLD.proof_image_url != '')
    OR
    (OLD.proof_documents IS NOT NULL AND array_length(OLD.proof_documents, 1) > 0)
  );

  points_to_subtract := CASE WHEN has_proof THEN 50 ELSE 25 END;

  IF OLD.family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points      = GREATEST(0, total_points - points_to_subtract),
      reviews_count     = GREATEST(0, reviews_count - 1),
      updated_at        = now()
    WHERE user_id = OLD.customer_id AND family_member_id = OLD.family_member_id;
  ELSE
    UPDATE user_activity
    SET
      total_points      = GREATEST(0, total_points - points_to_subtract),
      reviews_count     = GREATEST(0, reviews_count - 1),
      updated_at        = now()
    WHERE user_id = OLD.customer_id AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. Fix classified ad deletion trigger: GREATEST guard + family_member support
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_classified_ad()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Only subtract if points were actually awarded (ad was approved)
  IF OLD.points_awarded IS NULL OR OLD.points_awarded = 0 THEN
    RETURN OLD;
  END IF;

  IF OLD.family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points   = GREATEST(0, total_points - 5),
      ads_posted_count = GREATEST(0, ads_posted_count - 1),
      updated_at     = now()
    WHERE user_id = OLD.user_id AND family_member_id = OLD.family_member_id;
  ELSE
    UPDATE user_activity
    SET
      total_points   = GREATEST(0, total_points - 5),
      ads_posted_count = GREATEST(0, ads_posted_count - 1),
      updated_at     = now()
    WHERE user_id = OLD.user_id AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;
