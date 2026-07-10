/*
  # Add current bidder tracking to auctions

  1. Changes
    - Add `current_bidder_id` (uuid) column to auctions table
    - Add `current_bidder_nickname` (text) column to auctions table
    - Create trigger that updates these fields when a new bid is placed
    - Backfill existing auctions with their current top bidder

  2. Important Notes
    - These denormalized columns are auto-updated by a trigger on auction_bids
    - Provides instant access to top bidder info without extra joins
*/

-- Add columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'current_bidder_id'
  ) THEN
    ALTER TABLE auctions ADD COLUMN current_bidder_id uuid REFERENCES auth.users(id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'current_bidder_nickname'
  ) THEN
    ALTER TABLE auctions ADD COLUMN current_bidder_nickname text;
  END IF;
END $$;

-- Create trigger function to update current bidder on new bids
CREATE OR REPLACE FUNCTION update_auction_current_bidder()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_nickname text;
  v_current_max numeric;
BEGIN
  -- Check if this bid is actually the highest
  SELECT MAX(bid_amount) INTO v_current_max
  FROM auction_bids
  WHERE auction_id = NEW.auction_id;

  IF NEW.bid_amount >= v_current_max THEN
    -- Get the bidder's nickname or full name
    SELECT COALESCE(nickname, full_name, 'Utente')
    INTO v_nickname
    FROM profiles
    WHERE id = NEW.user_id;

    -- If bid was placed by a family member, use their nickname instead
    IF NEW.family_member_id IS NOT NULL THEN
      SELECT COALESCE(nickname, first_name, 'Utente')
      INTO v_nickname
      FROM customer_family_members
      WHERE id = NEW.family_member_id;
    END IF;

    -- Update the auction
    UPDATE auctions
    SET current_bidder_id = NEW.user_id,
        current_bidder_nickname = v_nickname,
        current_price = NEW.bid_amount
    WHERE id = NEW.auction_id;
  END IF;

  RETURN NEW;
END;
$$;

-- Drop existing trigger if any
DROP TRIGGER IF EXISTS trg_update_auction_current_bidder ON auction_bids;

-- Create trigger
CREATE TRIGGER trg_update_auction_current_bidder
  AFTER INSERT ON auction_bids
  FOR EACH ROW
  EXECUTE FUNCTION update_auction_current_bidder();

-- Backfill existing auctions with their current top bidder
UPDATE auctions a
SET current_bidder_id = sub.user_id,
    current_bidder_nickname = sub.nickname
FROM (
  SELECT DISTINCT ON (ab.auction_id)
    ab.auction_id,
    ab.user_id,
    COALESCE(
      CASE WHEN ab.family_member_id IS NOT NULL
        THEN (SELECT COALESCE(cfm.nickname, cfm.first_name) FROM customer_family_members cfm WHERE cfm.id = ab.family_member_id)
        ELSE NULL
      END,
      p.nickname,
      p.full_name,
      'Utente'
    ) AS nickname
  FROM auction_bids ab
  LEFT JOIN profiles p ON p.id = ab.user_id
  ORDER BY ab.auction_id, ab.bid_amount DESC
) sub
WHERE a.id = sub.auction_id AND a.current_price > 0;
