/*
  # Add Approval System for Auctions

  1. Changes
    - Add `approval_status` column to `auctions` table (pending, approved, rejected)
    - Add `approval_notes` column for admin rejection reasons
    - Add `approved_at` and `approved_by` columns
    - Update existing active auctions to 'approved' so they remain visible
    - Create `approve_auction` function that sets approval_status and awards points
    - Create `reject_auction` function that sets rejection status and sends notification
    - Update RLS so only approved auctions are publicly visible

  2. Security
    - Only admins can approve/reject auctions
    - Public users can only see approved auctions
    - Points (15) awarded on approval

  3. Important Notes
    - Existing active auctions are grandfathered as approved
    - New auctions default to 'pending' approval_status
*/

-- Add approval columns to auctions
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE auctions ADD COLUMN approval_status text DEFAULT 'pending'
      CHECK (approval_status IN ('pending', 'approved', 'rejected'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'approval_notes'
  ) THEN
    ALTER TABLE auctions ADD COLUMN approval_notes text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'approved_at'
  ) THEN
    ALTER TABLE auctions ADD COLUMN approved_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'approved_by'
  ) THEN
    ALTER TABLE auctions ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
END $$;

-- Grandfather existing active/completed auctions as approved
UPDATE auctions SET approval_status = 'approved', approved_at = now()
WHERE status IN ('active', 'completed') AND approval_status = 'pending';

-- Create approve_auction function
CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
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
  -- Get auction owner
  SELECT user_id, family_member_id INTO v_user_id, v_family_member_id
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Update auction approval status and set to active
  UPDATE auctions
  SET approval_status = 'approved',
      status = 'active',
      approved_at = now(),
      approved_by = p_admin_id
  WHERE id = p_auction_id;

  -- Award 15 points for auction creation
  INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
  VALUES (v_user_id, v_family_member_id, 15, 1)
  ON CONFLICT (user_id, COALESCE(family_member_id, '00000000-0000-0000-0000-000000000000'))
  DO UPDATE SET
    total_points = user_activity.total_points + 15,
    auctions_count = COALESCE(user_activity.auctions_count, 0) + 1;

  -- Log activity
  INSERT INTO activity_log (user_id, family_member_id, action, details, points_awarded)
  VALUES (v_user_id, v_family_member_id, 'auction_approved', 
    jsonb_build_object('auction_id', p_auction_id), 15);

  -- Send notification to owner
  INSERT INTO notifications (user_id, family_member_id, type, title, message)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!');
END;
$$;

-- Create reject_auction function
CREATE OR REPLACE FUNCTION reject_auction(
  p_auction_id uuid,
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
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  UPDATE auctions
  SET approval_status = 'rejected',
      approval_notes = p_reason,
      status = 'cancelled',
      approved_at = now(),
      approved_by = p_admin_id
  WHERE id = p_auction_id;

  -- Send notification to owner
  INSERT INTO notifications (user_id, family_member_id, type, title, message)
  VALUES (v_user_id, v_family_member_id, 'auction_rejected',
    'Asta non approvata',
    CASE WHEN p_reason != '' 
      THEN 'La tua asta non è stata approvata. Motivo: ' || p_reason
      ELSE 'La tua asta non è stata approvata. Contatta l''assistenza per maggiori informazioni.'
    END);
END;
$$;

-- Add index for pending auctions
CREATE INDEX IF NOT EXISTS idx_auctions_approval_status ON auctions(approval_status);
