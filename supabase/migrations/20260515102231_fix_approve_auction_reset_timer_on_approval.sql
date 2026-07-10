/*
  # Fix approve_auction: timer starts at approval time

  ## Problem
  When an auction is created, ends_at is set immediately (e.g. now() + duration_days).
  But if the admin approves it days later, the timer has already partially (or fully) elapsed.

  ## Fix
  Update approve_auction to recalculate ends_at = now() + duration_days at approval time,
  so the auction's full duration starts from the moment it is approved and made public.
*/

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
  v_duration_days integer;
BEGIN
  SELECT user_id, family_member_id, duration_days
  INTO v_user_id, v_family_member_id, v_duration_days
  FROM auctions WHERE id = p_auction_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Auction not found';
  END IF;

  -- Reset ends_at from now so the full duration runs after approval
  UPDATE auctions
  SET approval_status = 'approved',
      status = 'active',
      approved_at = now(),
      approved_by = p_admin_id,
      ends_at = now() + (COALESCE(v_duration_days, 7) || ' days')::interval
  WHERE id = p_auction_id;

  -- Award 15 points for auction creation
  INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count)
  VALUES (v_user_id, v_family_member_id, 15, 1)
  ON CONFLICT (user_id, COALESCE(family_member_id, '00000000-0000-0000-0000-000000000000'))
  DO UPDATE SET
    total_points = user_activity.total_points + 15,
    auctions_count = COALESCE(user_activity.auctions_count, 0) + 1;

  INSERT INTO activity_log (user_id, family_member_id, action, details, points_awarded)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    jsonb_build_object('auction_id', p_auction_id), 15);

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v_user_id, v_family_member_id, 'auction_approved',
    'Asta approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti gli utenti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id', p_auction_id, 'points_awarded', 15));
END;
$$;
