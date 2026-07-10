/*
  # Create Auctions System

  1. New Tables
    - `auctions`
      - Complete auction listing with all details
      - Tracks base price, duration, status
      - Includes deposit requirement (5€ for base ≤500€, 10€ for >500€)
      - Status: active, completed, cancelled, expired

    - `auction_bids`
      - All bids placed on auctions
      - Tracks bid amount and timestamp
      - Links to user/family member who placed bid

    - `auction_deposits`
      - Tracks deposit payments for auction participation
      - Amount based on base price (5€ or 10€)
      - Refunded after auction completion or expiration

    - `auction_completions`
      - Tracks completion confirmations from both parties
      - 48-hour window to confirm transaction
      - Both buyer and seller must confirm

  2. Security
    - Enable RLS on all tables
    - Users can create their own auctions
    - Users can view active auctions
    - Users can place bids after paying deposit
    - Admins have full access

  3. Storage
    - Create bucket for auction images
    - Allow authenticated users to upload
    - Public read access
*/

-- Create auctions table
CREATE TABLE IF NOT EXISTS auctions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text NOT NULL,
  base_price numeric NOT NULL CHECK (base_price > 0),
  current_price numeric NOT NULL DEFAULT 0,
  deposit_amount numeric NOT NULL,
  images text[] DEFAULT '{}',
  category text NOT NULL,
  condition text CHECK (condition IN ('new', 'like_new', 'good', 'fair', 'poor')),
  city text NOT NULL,
  province text NOT NULL,
  region text NOT NULL,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled', 'expired')),
  ends_at timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  winner_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  winner_family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  completed_at timestamptz,
  CONSTRAINT valid_end_date CHECK (ends_at > created_at)
);

-- Create auction_bids table
CREATE TABLE IF NOT EXISTS auction_bids (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id uuid NOT NULL REFERENCES auctions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  bid_amount numeric NOT NULL CHECK (bid_amount > 0),
  created_at timestamptz DEFAULT now(),
  CONSTRAINT unique_user_bid_per_auction UNIQUE(auction_id, user_id, created_at)
);

-- Create auction_deposits table
CREATE TABLE IF NOT EXISTS auction_deposits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id uuid NOT NULL REFERENCES auctions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL,
  amount numeric NOT NULL CHECK (amount IN (5, 10)),
  paid_at timestamptz DEFAULT now(),
  refunded boolean DEFAULT false,
  refunded_at timestamptz,
  CONSTRAINT unique_deposit_per_user_auction UNIQUE(auction_id, user_id)
);

-- Create auction_completions table
CREATE TABLE IF NOT EXISTS auction_completions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id uuid NOT NULL REFERENCES auctions(id) ON DELETE CASCADE,
  seller_confirmed boolean DEFAULT false,
  seller_confirmed_at timestamptz,
  buyer_confirmed boolean DEFAULT false,
  buyer_confirmed_at timestamptz,
  completion_deadline timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  CONSTRAINT unique_completion_per_auction UNIQUE(auction_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_auctions_user_id ON auctions(user_id);
CREATE INDEX IF NOT EXISTS idx_auctions_status ON auctions(status);
CREATE INDEX IF NOT EXISTS idx_auctions_ends_at ON auctions(ends_at);
CREATE INDEX IF NOT EXISTS idx_auctions_category ON auctions(category);
CREATE INDEX IF NOT EXISTS idx_auctions_city ON auctions(city);
CREATE INDEX IF NOT EXISTS idx_auctions_province ON auctions(province);
CREATE INDEX IF NOT EXISTS idx_auctions_region ON auctions(region);
CREATE INDEX IF NOT EXISTS idx_auction_bids_auction_id ON auction_bids(auction_id);
CREATE INDEX IF NOT EXISTS idx_auction_bids_user_id ON auction_bids(user_id);
CREATE INDEX IF NOT EXISTS idx_auction_deposits_auction_id ON auction_deposits(auction_id);
CREATE INDEX IF NOT EXISTS idx_auction_deposits_user_id ON auction_deposits(user_id);
CREATE INDEX IF NOT EXISTS idx_auction_completions_auction_id ON auction_completions(auction_id);

-- Enable RLS
ALTER TABLE auctions ENABLE ROW LEVEL SECURITY;
ALTER TABLE auction_bids ENABLE ROW LEVEL SECURITY;
ALTER TABLE auction_deposits ENABLE ROW LEVEL SECURITY;
ALTER TABLE auction_completions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for auctions

-- Public can view active auctions
CREATE POLICY "Anyone can view active auctions"
  ON auctions FOR SELECT
  USING (status = 'active' OR auth.uid() = user_id OR auth.uid() IN (
    SELECT user_id FROM admins
  ));

-- Users can view their own auctions regardless of status
CREATE POLICY "Users can view own auctions"
  ON auctions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Authenticated users can create auctions
CREATE POLICY "Authenticated users can create auctions"
  ON auctions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own auctions
CREATE POLICY "Users can update own auctions"
  ON auctions FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own auctions if no bids yet
CREATE POLICY "Users can delete own auctions without bids"
  ON auctions FOR DELETE
  TO authenticated
  USING (
    auth.uid() = user_id AND
    NOT EXISTS (SELECT 1 FROM auction_bids WHERE auction_id = id)
  );

-- Admins can do everything
CREATE POLICY "Admins have full access to auctions"
  ON auctions FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- RLS Policies for auction_bids

-- Anyone can view bids on active auctions
CREATE POLICY "Anyone can view bids on active auctions"
  ON auction_bids FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.status = 'active' OR auctions.user_id = auth.uid())
    )
  );

-- Authenticated users can place bids if they paid deposit
CREATE POLICY "Users can place bids after paying deposit"
  ON auction_bids FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM auction_deposits
      WHERE auction_deposits.auction_id = auction_bids.auction_id
      AND auction_deposits.user_id = auth.uid()
      AND auction_deposits.refunded = false
    )
  );

-- Admins can do everything
CREATE POLICY "Admins have full access to bids"
  ON auction_bids FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- RLS Policies for auction_deposits

-- Users can view their own deposits
CREATE POLICY "Users can view own deposits"
  ON auction_deposits FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Auction owners can view deposits for their auctions
CREATE POLICY "Auction owners can view deposits"
  ON auction_deposits FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND auctions.user_id = auth.uid()
    )
  );

-- Users can create deposits
CREATE POLICY "Users can create deposits"
  ON auction_deposits FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Admins can do everything
CREATE POLICY "Admins have full access to deposits"
  ON auction_deposits FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- RLS Policies for auction_completions

-- Auction participants can view completions
CREATE POLICY "Auction participants can view completions"
  ON auction_completions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.user_id = auth.uid() OR auctions.winner_id = auth.uid())
    )
  );

-- System creates completion records (admins)
CREATE POLICY "Admins can create completions"
  ON auction_completions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- Sellers and buyers can update their confirmation
CREATE POLICY "Participants can confirm completion"
  ON auction_completions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.user_id = auth.uid() OR auctions.winner_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM auctions
      WHERE auctions.id = auction_id
      AND (auctions.user_id = auth.uid() OR auctions.winner_id = auth.uid())
    )
  );

-- Admins can do everything
CREATE POLICY "Admins have full access to completions"
  ON auction_completions FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT user_id FROM admins))
  WITH CHECK (auth.uid() IN (SELECT user_id FROM admins));

-- Create function to automatically set deposit amount based on base price
CREATE OR REPLACE FUNCTION set_auction_deposit_amount()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.base_price <= 500 THEN
    NEW.deposit_amount := 5;
  ELSE
    NEW.deposit_amount := 10;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to set deposit amount
DROP TRIGGER IF EXISTS trigger_set_auction_deposit_amount ON auctions;
CREATE TRIGGER trigger_set_auction_deposit_amount
  BEFORE INSERT OR UPDATE OF base_price ON auctions
  FOR EACH ROW
  EXECUTE FUNCTION set_auction_deposit_amount();

-- Create function to update current price when new bid is placed
CREATE OR REPLACE FUNCTION update_auction_current_price()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE auctions
  SET
    current_price = NEW.bid_amount,
    updated_at = now()
  WHERE id = NEW.auction_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to update current price
DROP TRIGGER IF EXISTS trigger_update_auction_current_price ON auction_bids;
CREATE TRIGGER trigger_update_auction_current_price
  AFTER INSERT ON auction_bids
  FOR EACH ROW
  EXECUTE FUNCTION update_auction_current_price();

-- Create function to automatically expire auctions
CREATE OR REPLACE FUNCTION expire_auctions()
RETURNS void AS $$
BEGIN
  -- Mark auctions as expired if end time has passed and no winner
  UPDATE auctions
  SET status = 'expired', updated_at = now()
  WHERE status = 'active'
  AND ends_at < now()
  AND winner_id IS NULL;

  -- Mark auctions as completed if they have a winner and end time has passed
  UPDATE auctions
  SET
    status = 'completed',
    winner_id = (
      SELECT user_id
      FROM auction_bids
      WHERE auction_id = auctions.id
      ORDER BY bid_amount DESC, created_at ASC
      LIMIT 1
    ),
    winner_family_member_id = (
      SELECT family_member_id
      FROM auction_bids
      WHERE auction_id = auctions.id
      ORDER BY bid_amount DESC, created_at ASC
      LIMIT 1
    ),
    completed_at = now(),
    updated_at = now()
  WHERE status = 'active'
  AND ends_at < now()
  AND current_price > 0;

  -- Create completion records for newly completed auctions
  INSERT INTO auction_completions (auction_id, completion_deadline)
  SELECT id, now() + interval '48 hours'
  FROM auctions
  WHERE status = 'completed'
  AND completed_at > now() - interval '1 minute'
  AND NOT EXISTS (
    SELECT 1 FROM auction_completions WHERE auction_id = auctions.id
  );

  -- Refund deposits for expired auctions
  UPDATE auction_deposits
  SET refunded = true, refunded_at = now()
  WHERE auction_id IN (
    SELECT id FROM auctions WHERE status = 'expired'
  )
  AND refunded = false;
END;
$$ LANGUAGE plpgsql;

-- Create storage bucket for auction images
INSERT INTO storage.buckets (id, name, public)
VALUES ('auction-images', 'auction-images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for auction images
CREATE POLICY "Authenticated users can upload auction images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'auction-images');

CREATE POLICY "Anyone can view auction images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'auction-images');

CREATE POLICY "Users can update own auction images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'auction-images' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own auction images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'auction-images' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Admins have full access to auction images"
  ON storage.objects FOR ALL
  TO authenticated
  USING (
    bucket_id = 'auction-images' AND
    auth.uid() IN (SELECT user_id FROM admins)
  );