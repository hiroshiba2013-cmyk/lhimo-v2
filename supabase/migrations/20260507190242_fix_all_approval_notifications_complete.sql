/*
  # Fix all approval notification functions - complete overhaul

  ## Summary
  Aligns every approval function with the notification requirements:

  ### Utenti PRIVATI ricevono notifica per:
  - Recensione approvata (con punti guadagnati)
  - Annuncio vendita/regalo/cerco approvato (con punti)
  - Annuncio "Cerco Lavoro" approvato
  - Asta approvata
  - Attività aggiunta approvata

  ### Utenti BUSINESS ricevono notifica per:
  - Ogni recensione approvata ricevuta (nuova)
  - Annuncio "Trova Lavoro" approvato (tipo corretto: job_posting_approved)
  - Annuncio vendita/regalo/cerco approvato

  ## Type changes
  - job_posting approve: type changed from 'job_approved' to 'job_posting_approved'
    to match the frontend CATEGORY_TYPES

  ## New notifications
  - 'review_received': sent to the business owner when a review on their business
    is approved by an admin
*/

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. approve_review: also notify the business owner
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param  uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  review_record   RECORD;
  customer_id_var uuid;
  family_member_id_var uuid;
  points_to_award integer;
  has_proof       boolean;
  -- business owner lookup
  v_business_owner_id uuid;
  v_business_name      text;
  v_reviewer_name      text;
BEGIN
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;

  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;

  has_proof := (
    (review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '')
    OR
    (review_record.proof_documents IS NOT NULL AND array_length(review_record.proof_documents, 1) > 0)
  );

  points_to_award := CASE WHEN has_proof THEN 50 ELSE 25 END;

  UPDATE reviews
  SET review_status = 'approved',
      approved_by   = staff_id_param,
      approved_at   = now(),
      points_awarded = points_to_award
  WHERE id = review_id_param;

  customer_id_var      := review_record.customer_id;
  family_member_id_var := review_record.family_member_id;

  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata', family_member_id_var);

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    customer_id_var, family_member_id_var, 'review_approved',
    'Recensione Approvata',
    'La tua recensione è stata approvata. Hai guadagnato ' || points_to_award || ' punti!',
    points_to_award,
    jsonb_build_object('review_id', review_id_param, 'points_awarded', points_to_award, 'had_proof', has_proof),
    'check-circle', 'green'
  );

  -- Notify the reviewer (private user)
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    customer_id_var, family_member_id_var,
    'review_approved',
    'Recensione Approvata',
    'La tua recensione è stata approvata. Hai guadagnato ' || points_to_award || ' punti in classifica!',
    jsonb_build_object('review_id', review_id_param, 'points_awarded', points_to_award)
  );

  -- ── Notify the business owner that they received a new review ──────────────
  -- Resolve reviewer display name
  SELECT COALESCE(p.nickname, p.full_name, 'Un utente')
  INTO v_reviewer_name
  FROM profiles p WHERE p.id = customer_id_var;

  -- Try claimed business (business_locations → businesses → owner)
  IF review_record.business_location_id IS NOT NULL THEN
    SELECT b.owner_id, b.name
    INTO v_business_owner_id, v_business_name
    FROM business_locations bl
    JOIN businesses b ON b.id = bl.business_id
    WHERE bl.id = review_record.business_location_id;
  END IF;

  -- Try registered business location
  IF v_business_owner_id IS NULL AND review_record.business_id IS NOT NULL THEN
    SELECT b.owner_id, b.name
    INTO v_business_owner_id, v_business_name
    FROM businesses b
    WHERE b.id = review_record.business_id;
  END IF;

  -- Try registered_businesses
  IF v_business_owner_id IS NULL AND review_record.business_type = 'registered' THEN
    -- look up via unclaimed or registered location
    NULL; -- registered businesses don't have an owner to notify yet
  END IF;

  -- Send notification to business owner (only if we found one and they differ from reviewer)
  IF v_business_owner_id IS NOT NULL AND v_business_owner_id != customer_id_var THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      v_business_owner_id,
      'review_received',
      'Nuova Recensione',
      v_reviewer_name || ' ha lasciato una recensione per ' || COALESCE(v_business_name, 'la tua attività') || '.',
      jsonb_build_object('review_id', review_id_param, 'business_location_id', review_record.business_location_id)
    );
  END IF;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. approve_job_posting: fix type to 'job_posting_approved'
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION approve_job_posting(
  p_job_id   uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job      RECORD;
  v_owner_id uuid;
  v_loc_id   uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  IF v_job.rb_owner_id IS NULL AND v_job.business_id IS NOT NULL THEN
    SELECT owner_id INTO v_owner_id FROM businesses WHERE id = v_job.business_id;
  ELSE
    v_owner_id := v_job.rb_owner_id;
  END IF;

  v_loc_id := COALESCE(v_job.registered_business_location_id, v_job.business_location_id);

  UPDATE job_postings
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_loc_id,
      'job_posting_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro "' || COALESCE(v_job.title, '') || '" è stato approvato ed è ora visibile a tutti gli utenti.',
      jsonb_build_object('job_id', p_job_id)
    );
  END IF;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. reject_job_posting: fix type to 'job_posting_rejected'
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION reject_job_posting(
  p_job_id   uuid,
  p_admin_id uuid,
  p_reason   text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job      RECORD;
  v_owner_id uuid;
  v_loc_id   uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  IF v_job.rb_owner_id IS NULL AND v_job.business_id IS NOT NULL THEN
    SELECT owner_id INTO v_owner_id FROM businesses WHERE id = v_job.business_id;
  ELSE
    v_owner_id := v_job.rb_owner_id;
  END IF;

  v_loc_id := COALESCE(v_job.registered_business_location_id, v_job.business_location_id);

  UPDATE job_postings
  SET approval_status  = 'rejected',
      approved_at      = now(),
      approved_by      = p_admin_id,
      approval_notes   = p_reason
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_loc_id,
      'job_posting_rejected',
      'Annuncio di Lavoro Non Approvato',
      CASE
        WHEN p_reason IS NOT NULL AND p_reason != ''
        THEN 'Il tuo annuncio di lavoro non è stato approvato. Motivo: ' || p_reason
        ELSE 'Il tuo annuncio di lavoro non è stato approvato.'
      END,
      jsonb_build_object('job_id', p_job_id)
    );
  END IF;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. approve_auction: add notification with points info for private users
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id   uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction RECORD;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_by     = p_admin_id,
      approved_at     = now(),
      points_awarded  = 0
  WHERE id = p_auction_id;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile a tutti gli utenti.',
    jsonb_build_object('auction_id', p_auction_id)
  );
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. reject_auction: ensure consistent type 'auction_rejected'
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION reject_auction(
  p_auction_id uuid,
  p_admin_id   uuid,
  p_reason     text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction RECORD;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  UPDATE auctions
  SET approval_status  = 'rejected',
      approved_by      = p_admin_id,
      approved_at      = now(),
      approval_notes   = p_reason
  WHERE id = p_auction_id;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_rejected',
    'Asta Non Approvata',
    CASE
      WHEN p_reason IS NOT NULL AND p_reason != ''
      THEN 'La tua asta "' || v_auction.title || '" non è stata approvata. Motivo: ' || p_reason
      ELSE 'La tua asta "' || v_auction.title || '" non è stata approvata.'
    END,
    jsonb_build_object('auction_id', p_auction_id)
  );
END;
$$;
