
-- Drop the old permanent UNIQUE indexes (they blocked re-reviewing across all years)
DROP INDEX IF EXISTS reviews_registered_owner_unique;
DROP INDEX IF EXISTS reviews_registered_family_unique;
DROP INDEX IF EXISTS reviews_imported_owner_unique;
DROP INDEX IF EXISTS reviews_imported_family_unique;
DROP INDEX IF EXISTS reviews_user_added_owner_unique;
DROP INDEX IF EXISTS reviews_user_added_family_unique;
DROP INDEX IF EXISTS reviews_unclaimed_owner_unique;
DROP INDEX IF EXISTS reviews_unclaimed_family_unique;

-- Function: check if a review already exists for the same business in the current calendar year
-- Returns TRUE if the user CAN submit (no review found this year), FALSE if blocked
CREATE OR REPLACE FUNCTION check_review_allowed_this_year(
  p_customer_id uuid,
  p_family_member_id uuid,
  p_business_id uuid,
  p_imported_business_id uuid,
  p_user_added_business_id uuid,
  p_unclaimed_business_location_id uuid,
  p_registered_business_location_id uuid
) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_year int := EXTRACT(YEAR FROM NOW());
  v_count int;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM reviews
  WHERE customer_id = p_customer_id
    AND EXTRACT(YEAR FROM created_at) = v_year
    AND (
      (p_family_member_id IS NULL AND family_member_id IS NULL) OR
      (p_family_member_id IS NOT NULL AND family_member_id = p_family_member_id)
    )
    AND (
      (p_business_id IS NOT NULL AND business_id = p_business_id) OR
      (p_imported_business_id IS NOT NULL AND imported_business_id = p_imported_business_id) OR
      (p_user_added_business_id IS NOT NULL AND user_added_business_id = p_user_added_business_id) OR
      (p_unclaimed_business_location_id IS NOT NULL AND unclaimed_business_location_id = p_unclaimed_business_location_id) OR
      (p_registered_business_location_id IS NOT NULL AND registered_business_location_id = p_registered_business_location_id)
    );

  RETURN v_count = 0;
END;
$$;

GRANT EXECUTE ON FUNCTION check_review_allowed_this_year TO authenticated;

-- Function: get existing review for current year (for frontend to display to user)
CREATE OR REPLACE FUNCTION get_my_review_this_year(
  p_customer_id uuid,
  p_family_member_id uuid,
  p_business_id uuid,
  p_imported_business_id uuid,
  p_user_added_business_id uuid,
  p_unclaimed_business_location_id uuid,
  p_registered_business_location_id uuid
) RETURNS TABLE(id uuid, created_at timestamptz, review_status text, rating int)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_year int := EXTRACT(YEAR FROM NOW());
BEGIN
  RETURN QUERY
  SELECT r.id, r.created_at, r.review_status::text, r.rating
  FROM reviews r
  WHERE r.customer_id = p_customer_id
    AND EXTRACT(YEAR FROM r.created_at) = v_year
    AND (
      (p_family_member_id IS NULL AND r.family_member_id IS NULL) OR
      (p_family_member_id IS NOT NULL AND r.family_member_id = p_family_member_id)
    )
    AND (
      (p_business_id IS NOT NULL AND r.business_id = p_business_id) OR
      (p_imported_business_id IS NOT NULL AND r.imported_business_id = p_imported_business_id) OR
      (p_user_added_business_id IS NOT NULL AND r.user_added_business_id = p_user_added_business_id) OR
      (p_unclaimed_business_location_id IS NOT NULL AND r.unclaimed_business_location_id = p_unclaimed_business_location_id) OR
      (p_registered_business_location_id IS NOT NULL AND r.registered_business_location_id = p_registered_business_location_id)
    )
  LIMIT 1;
END;
$$;

GRANT EXECUTE ON FUNCTION get_my_review_this_year TO authenticated;
