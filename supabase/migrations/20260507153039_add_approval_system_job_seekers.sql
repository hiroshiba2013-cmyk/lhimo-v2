/*
  # Add Approval System to Job Seekers

  ## Summary
  Adds the same approval workflow used by job_postings, classified_ads, and auctions
  to the job_seekers table, so "Cerco Lavoro" ads require admin approval before
  being visible to other users.

  ## Changes
  - `job_seekers` table: adds `approval_status` (pending/approved/rejected),
    `approved_by`, `approved_at`, `approval_notes` columns
  - Default for new rows is 'pending'
  - New RPC functions: `approve_job_seeker`, `reject_job_seeker`
  - Notification sent to user on approval/rejection
*/

-- Add approval columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_seekers' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE job_seekers
      ADD COLUMN approval_status text NOT NULL DEFAULT 'pending'
        CHECK (approval_status IN ('pending', 'approved', 'rejected')),
      ADD COLUMN approved_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
      ADD COLUMN approved_at timestamptz,
      ADD COLUMN approval_notes text;
  END IF;
END $$;

-- Approve function
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
BEGIN
  SELECT user_id INTO v_user_id FROM job_seekers WHERE id = p_seeker_id;

  UPDATE job_seekers
  SET
    approval_status = 'approved',
    approved_by = p_admin_id,
    approved_at = now(),
    status = 'active'
  WHERE id = p_seeker_id;

  -- Notify the owner
  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, related_id)
    VALUES (
      v_user_id,
      'job_seeker_approved',
      'Annuncio approvato',
      'Il tuo annuncio "Cerco Lavoro" è stato approvato ed è ora visibile.',
      p_seeker_id
    );
  END IF;
END;
$$;

-- Reject function
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
  v_title text;
BEGIN
  SELECT user_id, title INTO v_user_id, v_title FROM job_seekers WHERE id = p_seeker_id;

  UPDATE job_seekers
  SET
    approval_status = 'rejected',
    approved_by = p_admin_id,
    approved_at = now(),
    approval_notes = p_reason,
    status = 'closed'
  WHERE id = p_seeker_id;

  -- Notify the owner
  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, related_id)
    VALUES (
      v_user_id,
      'job_seeker_rejected',
      'Annuncio non approvato',
      CASE
        WHEN p_reason IS NOT NULL AND p_reason != ''
        THEN 'Il tuo annuncio "Cerco Lavoro" non è stato approvato. Motivo: ' || p_reason
        ELSE 'Il tuo annuncio "Cerco Lavoro" non è stato approvato.'
      END,
      p_seeker_id
    );
  END IF;
END;
$$;
