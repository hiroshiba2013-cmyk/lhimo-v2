/*
  # Fix approve/reject_job_seeker notification insert

  The previous version used a non-existent column `related_id`.
  The notifications table has `business_location_id` and `data` (jsonb) but no `related_id`.
  This migration recreates both functions using only the correct columns.
*/

CREATE OR REPLACE FUNCTION approve_job_seeker(
  p_seeker_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid;
  v_family_member_id uuid;
BEGIN
  SELECT user_id, family_member_id INTO v_user_id, v_family_member_id
  FROM job_seekers WHERE id = p_seeker_id;

  UPDATE job_seekers
  SET
    approval_status = 'approved',
    approved_by = p_admin_id,
    approved_at = now(),
    status = 'active'
  WHERE id = p_seeker_id;

  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      v_user_id,
      v_family_member_id,
      'job_seeker_approved',
      'Annuncio approvato',
      'Il tuo annuncio "Cerco Lavoro" è stato approvato ed è ora visibile.',
      jsonb_build_object('seeker_id', p_seeker_id)
    );
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION reject_job_seeker(
  p_seeker_id uuid,
  p_admin_id uuid,
  p_reason text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid;
  v_family_member_id uuid;
BEGIN
  SELECT user_id, family_member_id INTO v_user_id, v_family_member_id
  FROM job_seekers WHERE id = p_seeker_id;

  UPDATE job_seekers
  SET
    approval_status = 'rejected',
    approved_by = p_admin_id,
    approved_at = now(),
    approval_notes = p_reason,
    status = 'closed'
  WHERE id = p_seeker_id;

  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      v_user_id,
      v_family_member_id,
      'job_seeker_rejected',
      'Annuncio non approvato',
      CASE
        WHEN p_reason IS NOT NULL AND p_reason != ''
        THEN 'Il tuo annuncio "Cerco Lavoro" non è stato approvato. Motivo: ' || p_reason
        ELSE 'Il tuo annuncio "Cerco Lavoro" non è stato approvato.'
      END,
      jsonb_build_object('seeker_id', p_seeker_id)
    );
  END IF;
END;
$$;
