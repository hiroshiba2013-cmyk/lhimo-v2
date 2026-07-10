/*
  # Create function to get business ratings broken down by review type

  ## Summary
  Creates a function `get_business_ratings_by_type` that returns:
  - Per review-type averages (service_used, booking_not_completed, quote_request, customer_service, problem_before_service)
  - Each type has its own criteria averages
  - An overall `total_avg` across all types
  - Count per type

  This supports the new filtering system where users can filter by any specific rating dimension.
*/

CREATE OR REPLACE FUNCTION get_business_ratings_by_type(p_business_id uuid, p_business_type text DEFAULT 'registered')
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result jsonb;
  v_total_sum numeric := 0;
  v_total_count integer := 0;
BEGIN
  SELECT jsonb_build_object(
    'total_avg', CASE WHEN COUNT(*) > 0 THEN ROUND(AVG(overall_rating)::numeric, 1) ELSE 0 END,
    'total_count', COUNT(*),

    -- service_used
    'service_used', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'service_used'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1)
        ELSE 0 END,
      'gestione_prenotazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND booking_management_rating IS NOT NULL) > 0
        THEN ROUND(AVG(booking_management_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND reliability_rating IS NOT NULL) > 0
        THEN ROUND(AVG(reliability_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND organization_rating IS NOT NULL) > 0
        THEN ROUND(AVG(organization_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'esperienza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND experience_rating IS NOT NULL) > 0
        THEN ROUND(AVG(experience_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END,
      'prezzo', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'service_used' AND price_rating IS NOT NULL) > 0
        THEN ROUND(AVG(price_rating) FILTER (WHERE review_type = 'service_used')::numeric, 1) ELSE 0 END
    ),

    -- booking_not_completed
    'booking_not_completed', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'booking_not_completed'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1)
        ELSE 0 END,
      'gestione_prenotazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_gestione_prenotazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_gestione_prenotazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_affidabilita IS NOT NULL) > 0
        THEN ROUND(AVG(booking_affidabilita) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_organizzazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_organizzazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END,
      'comunicazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'booking_not_completed' AND booking_comunicazione IS NOT NULL) > 0
        THEN ROUND(AVG(booking_comunicazione) FILTER (WHERE review_type = 'booking_not_completed')::numeric, 1) ELSE 0 END
    ),

    -- quote_request
    'quote_request', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'quote_request'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'quote_request')::numeric, 1)
        ELSE 0 END,
      'chiarezza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_chiarezza IS NOT NULL) > 0
        THEN ROUND(AVG(quote_chiarezza) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'trasparenza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_trasparenza IS NOT NULL) > 0
        THEN ROUND(AVG(quote_trasparenza) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'tempistiche_risposta', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_tempistiche_risposta IS NOT NULL) > 0
        THEN ROUND(AVG(quote_tempistiche_risposta) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END,
      'disponibilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'quote_request' AND quote_disponibilita IS NOT NULL) > 0
        THEN ROUND(AVG(quote_disponibilita) FILTER (WHERE review_type = 'quote_request')::numeric, 1) ELSE 0 END
    ),

    -- customer_service
    'customer_service', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'customer_service'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'customer_service')::numeric, 1)
        ELSE 0 END,
      'cortesia', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_cortesia IS NOT NULL) > 0
        THEN ROUND(AVG(cs_cortesia) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'competenza', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_competenza IS NOT NULL) > 0
        THEN ROUND(AVG(cs_competenza) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'rapidita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_rapidita IS NOT NULL) > 0
        THEN ROUND(AVG(cs_rapidita) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END,
      'risoluzione_problema', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'customer_service' AND cs_risoluzione_problema IS NOT NULL) > 0
        THEN ROUND(AVG(cs_risoluzione_problema) FILTER (WHERE review_type = 'customer_service')::numeric, 1) ELSE 0 END
    ),

    -- problem_before_service
    'problem_before_service', jsonb_build_object(
      'count', COUNT(*) FILTER (WHERE review_type = 'problem_before_service'),
      'avg', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service') > 0
        THEN ROUND(AVG(overall_rating) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1)
        ELSE 0 END,
      'affidabilita', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_affidabilita IS NOT NULL) > 0
        THEN ROUND(AVG(problem_affidabilita) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'organizzazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_organizzazione IS NOT NULL) > 0
        THEN ROUND(AVG(problem_organizzazione) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'gestione_problema', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_gestione_problema IS NOT NULL) > 0
        THEN ROUND(AVG(problem_gestione_problema) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END,
      'comunicazione', CASE WHEN COUNT(*) FILTER (WHERE review_type = 'problem_before_service' AND problem_comunicazione IS NOT NULL) > 0
        THEN ROUND(AVG(problem_comunicazione) FILTER (WHERE review_type = 'problem_before_service')::numeric, 1) ELSE 0 END
    )
  ) INTO v_result
  FROM reviews
  WHERE review_status = 'approved'
    AND (
      (p_business_type = 'registered' AND (business_id = p_business_id OR registered_business_id = p_business_id))
      OR (p_business_type = 'imported' AND (imported_business_id = p_business_id OR unclaimed_business_location_id = p_business_id))
      OR (p_business_type = 'user_added' AND user_added_business_id = p_business_id)
    );

  RETURN COALESCE(v_result, '{}'::jsonb);
END;
$$;
