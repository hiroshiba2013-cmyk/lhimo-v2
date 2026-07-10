/*
  # Fix points upsert for auctions and job postings

  ## Problem
  - approve_auction: used ON CONFLICT (user_id, family_member_id) but family_member_id
    was hardcoded NULL, so it never matched the correct unique index
    (user_activity_user_id_null_family_unique).
  - approve_job_posting: same issue — used wrong ON CONFLICT syntax.

  ## Fix
  Both functions now branch on whether family_member_id is NULL or not,
  using the correct unique index in each case, matching the pattern used
  by other working functions (approve_classified_ad, approve_review, etc.).
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
  v_auction       RECORD;
  points_to_award integer := 15;
  v_user_type     text;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  SELECT user_type INTO v_user_type FROM profiles WHERE id = v_auction.user_id;
  IF v_user_type = 'business' THEN points_to_award := 0; END IF;

  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_by     = p_admin_id,
      approved_at     = now(),
      points_awarded  = points_to_award
  WHERE id = p_auction_id;

  -- Award points using the correct unique index branch
  IF points_to_award > 0 THEN
    IF v_auction.family_member_id IS NOT NULL THEN
      INSERT INTO user_activity (user_id, family_member_id, total_points, last_activity_at, created_at, updated_at)
      VALUES (v_auction.user_id, v_auction.family_member_id, points_to_award, now(), now(), now())
      ON CONFLICT (user_id, family_member_id)
      DO UPDATE SET
        total_points     = user_activity.total_points + points_to_award,
        last_activity_at = now(),
        updated_at       = now();
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, last_activity_at, created_at, updated_at)
      VALUES (v_auction.user_id, NULL, points_to_award, now(), now(), now())
      ON CONFLICT (user_id) WHERE family_member_id IS NULL
      DO UPDATE SET
        total_points     = user_activity.total_points + points_to_award,
        last_activity_at = now(),
        updated_at       = now();
    END IF;
  END IF;

  -- Activity log
  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    'La tua asta "' || v_auction.title || '" è stata approvata.',
    points_to_award,
    jsonb_build_object('auction_id', p_auction_id),
    'check-circle', 'green'
  );

  -- Notification to owner
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    CASE WHEN points_to_award > 0
      THEN 'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile. Hai guadagnato ' || points_to_award || ' punti in classifica!'
      ELSE 'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile a tutti gli utenti.'
    END,
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', points_to_award)
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
  points_to_award integer := 10;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  -- Determine the real owner
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
    -- Award points using correct unique index branch (jobs have no family_member_id)
    INSERT INTO user_activity (user_id, family_member_id, total_points, job_postings_count, last_activity_at, created_at, updated_at)
    VALUES (v_owner_id, NULL, points_to_award, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      total_points       = user_activity.total_points + points_to_award,
      job_postings_count = COALESCE(user_activity.job_postings_count, 0) + 1,
      last_activity_at   = now(),
      updated_at         = now();

    -- Activity log
    INSERT INTO activity_log (user_id, activity_type, title, description, points_earned, metadata, icon, color)
    VALUES (
      v_owner_id,
      'job_posting_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro è stato approvato.',
      points_to_award,
      jsonb_build_object('job_id', p_job_id),
      'check-circle', 'green'
    );

    -- Notification
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_job.registered_business_location_id,
      'job_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro è stato approvato ed è ora visibile. Hai guadagnato ' || points_to_award || ' punti in classifica!',
      jsonb_build_object('job_id', p_job_id, 'points_awarded', points_to_award)
    );
  END IF;
END;
$$;
