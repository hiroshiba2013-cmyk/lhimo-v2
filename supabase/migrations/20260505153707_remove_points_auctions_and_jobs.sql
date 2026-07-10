/*
  # Remove points for auctions and job postings

  Auctions and job postings do not award points to the leaderboard.
  Both approve_auction and approve_job_posting are updated to:
  - Skip all user_activity point updates
  - Skip activity_log point entries
  - Keep notifications (without points messaging)
*/

-- ─── approve_auction ────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id uuid
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

  -- Notification to owner (no points)
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

-- ─── approve_job_posting ────────────────────────────────────────────────────

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

  UPDATE job_postings
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    -- Notification (no points)
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_job.registered_business_location_id,
      'job_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro è stato approvato ed è ora visibile a tutti gli utenti.',
      jsonb_build_object('job_id', p_job_id)
    );
  END IF;
END;
$$;
