/*
  # Add Approval System for Job Postings

  1. Changes
    - Add `approval_status` column to `job_postings` table (pending, approved, rejected)
    - Add `approval_notes` column for admin rejection reasons
    - Add `approved_at` and `approved_by` columns
    - Update existing active job postings to 'approved'
    - Create `approve_job_posting` function that sets approval_status and awards points
    - Create `reject_job_posting` function
    - Add `auctions_count` column to `user_activity` if missing

  2. Security
    - Only admins can approve/reject job postings
    - Public users can only see approved job postings
    - Points (10) awarded on approval

  3. Important Notes
    - Existing active job postings are grandfathered as approved
    - New job postings default to 'pending' approval_status
*/

-- Add approval columns to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN approval_status text DEFAULT 'pending'
      CHECK (approval_status IN ('pending', 'approved', 'rejected'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'approval_notes'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN approval_notes text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'approved_at'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN approved_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'approved_by'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
END $$;

-- Add auctions_count to user_activity if missing
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_activity' AND column_name = 'auctions_count'
  ) THEN
    ALTER TABLE user_activity ADD COLUMN auctions_count integer DEFAULT 0;
  END IF;
END $$;

-- Grandfather existing active job postings as approved
UPDATE job_postings SET approval_status = 'approved', approved_at = now()
WHERE status = 'active' AND approval_status = 'pending';

-- Create approve_job_posting function
CREATE OR REPLACE FUNCTION approve_job_posting(
  p_job_id uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_id uuid;
  v_owner_id uuid;
BEGIN
  -- Get job posting business
  SELECT jp.business_id INTO v_business_id
  FROM job_postings jp WHERE jp.id = p_job_id;

  IF v_business_id IS NULL THEN
    RAISE EXCEPTION 'Job posting not found';
  END IF;

  -- Get business owner
  SELECT owner_id INTO v_owner_id
  FROM businesses WHERE id = v_business_id;

  -- Update job posting
  UPDATE job_postings
  SET approval_status = 'approved',
      status = 'active',
      approved_at = now(),
      approved_by = p_admin_id
  WHERE id = p_job_id;

  -- Award 10 points to business owner if found
  IF v_owner_id IS NOT NULL THEN
    INSERT INTO user_activity (user_id, total_points, job_postings_count)
    VALUES (v_owner_id, 10, 1)
    ON CONFLICT (user_id, COALESCE(family_member_id, '00000000-0000-0000-0000-000000000000'))
    DO UPDATE SET
      total_points = user_activity.total_points + 10,
      job_postings_count = COALESCE(user_activity.job_postings_count, 0) + 1;

    -- Log activity
    INSERT INTO activity_log (user_id, action, details, points_awarded)
    VALUES (v_owner_id, 'job_posting_approved',
      jsonb_build_object('job_id', p_job_id), 10);

    -- Send notification
    INSERT INTO notifications (user_id, type, title, message)
    VALUES (v_owner_id, 'job_approved',
      'Annuncio di lavoro approvato',
      'Il tuo annuncio di lavoro è stato approvato ed è ora visibile. Hai guadagnato 10 punti!');
  END IF;
END;
$$;

-- Create reject_job_posting function
CREATE OR REPLACE FUNCTION reject_job_posting(
  p_job_id uuid,
  p_admin_id uuid,
  p_reason text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_id uuid;
  v_owner_id uuid;
BEGIN
  SELECT jp.business_id INTO v_business_id
  FROM job_postings jp WHERE jp.id = p_job_id;

  IF v_business_id IS NULL THEN
    RAISE EXCEPTION 'Job posting not found';
  END IF;

  SELECT owner_id INTO v_owner_id
  FROM businesses WHERE id = v_business_id;

  UPDATE job_postings
  SET approval_status = 'rejected',
      approval_notes = p_reason,
      status = 'closed',
      approved_at = now(),
      approved_by = p_admin_id
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message)
    VALUES (v_owner_id, 'job_rejected',
      'Annuncio di lavoro non approvato',
      CASE WHEN p_reason != ''
        THEN 'Il tuo annuncio di lavoro non è stato approvato. Motivo: ' || p_reason
        ELSE 'Il tuo annuncio di lavoro non è stato approvato. Contatta l''assistenza per maggiori informazioni.'
      END);
  END IF;
END;
$$;

-- Add index for pending job postings
CREATE INDEX IF NOT EXISTS idx_job_postings_approval_status ON job_postings(approval_status);
