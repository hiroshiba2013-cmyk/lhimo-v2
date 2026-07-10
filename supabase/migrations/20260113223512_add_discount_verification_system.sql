/*
  # Add Discount Verification System

  1. Changes to Tables
    - `discounts`
      - Add `max_redemptions_per_user` (integer, default 1)
      - Add `requires_verification` (boolean, default true)

    - `discount_redemptions`
      - Add `redemption_code` (text, unique code for verification)
      - Add `status` (text, enum: pending, confirmed, expired, cancelled)
      - Add `confirmed_at` (timestamptz, when business confirmed)
      - Add `confirmed_by_location_id` (uuid, which location confirmed)
      - Add `expires_at` (timestamptz, when the redemption code expires)

  2. New Functions
    - `generate_redemption_code()` - Generates unique 6-character code
    - `verify_discount_redemption()` - Verifies and confirms redemption

  3. Security
    - Business locations can verify redemptions for their discounts
    - Customers can create pending redemptions
    - Only confirmed redemptions count as used

  4. Business Logic
    - When customer "uses" discount, create pending redemption with code
    - Customer shows code to business
    - Business verifies code and confirms redemption
    - Code expires after 2 hours if not confirmed
    - Can check max uses per user before creating redemption
*/

-- Add new columns to discounts table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discounts' AND column_name = 'max_redemptions_per_user'
  ) THEN
    ALTER TABLE discounts ADD COLUMN max_redemptions_per_user integer DEFAULT 1;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discounts' AND column_name = 'requires_verification'
  ) THEN
    ALTER TABLE discounts ADD COLUMN requires_verification boolean DEFAULT true;
  END IF;
END $$;

-- Add new columns to discount_redemptions table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discount_redemptions' AND column_name = 'redemption_code'
  ) THEN
    ALTER TABLE discount_redemptions ADD COLUMN redemption_code text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discount_redemptions' AND column_name = 'status'
  ) THEN
    ALTER TABLE discount_redemptions ADD COLUMN status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'expired', 'cancelled'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discount_redemptions' AND column_name = 'confirmed_at'
  ) THEN
    ALTER TABLE discount_redemptions ADD COLUMN confirmed_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discount_redemptions' AND column_name = 'confirmed_by_location_id'
  ) THEN
    ALTER TABLE discount_redemptions ADD COLUMN confirmed_by_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'discount_redemptions' AND column_name = 'expires_at'
  ) THEN
    ALTER TABLE discount_redemptions ADD COLUMN expires_at timestamptz;
  END IF;
END $$;

-- Create unique index on redemption_code
CREATE UNIQUE INDEX IF NOT EXISTS idx_discount_redemptions_code_unique
  ON discount_redemptions(redemption_code)
  WHERE redemption_code IS NOT NULL;

-- Function to generate random redemption code
CREATE OR REPLACE FUNCTION generate_redemption_code()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  chars text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result text := '';
  i integer;
  code_exists boolean;
BEGIN
  LOOP
    result := '';
    FOR i IN 1..6 LOOP
      result := result || substr(chars, floor(random() * length(chars) + 1)::integer, 1);
    END LOOP;

    -- Check if code already exists
    SELECT EXISTS(
      SELECT 1 FROM discount_redemptions
      WHERE redemption_code = result
    ) INTO code_exists;

    EXIT WHEN NOT code_exists;
  END LOOP;

  RETURN result;
END;
$$;

-- Function to create discount redemption with verification
CREATE OR REPLACE FUNCTION create_discount_redemption(
  p_discount_id uuid,
  p_customer_id uuid,
  p_family_member_id uuid DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_discount record;
  v_redemption_count integer;
  v_redemption_code text;
  v_redemption_id uuid;
  v_expires_at timestamptz;
BEGIN
  -- Get discount info
  SELECT * INTO v_discount
  FROM discounts
  WHERE id = p_discount_id
    AND active = true
    AND valid_until > now();

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Sconto non valido o scaduto'
    );
  END IF;

  -- Check max redemptions per user (only count confirmed redemptions)
  SELECT COUNT(*) INTO v_redemption_count
  FROM discount_redemptions
  WHERE discount_id = p_discount_id
    AND customer_id = p_customer_id
    AND status = 'confirmed';

  IF v_redemption_count >= v_discount.max_redemptions_per_user THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Hai già utilizzato questo sconto il numero massimo di volte'
    );
  END IF;

  -- Check if there's already a pending redemption
  IF EXISTS(
    SELECT 1 FROM discount_redemptions
    WHERE discount_id = p_discount_id
      AND customer_id = p_customer_id
      AND status = 'pending'
      AND expires_at > now()
  ) THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Hai già un codice di riscatto attivo per questo sconto'
    );
  END IF;

  -- Generate redemption code
  v_redemption_code := generate_redemption_code();
  v_expires_at := now() + interval '2 hours';

  -- Create redemption
  INSERT INTO discount_redemptions (
    discount_id,
    customer_id,
    family_member_id,
    redemption_code,
    status,
    expires_at
  ) VALUES (
    p_discount_id,
    p_customer_id,
    p_family_member_id,
    v_redemption_code,
    'pending',
    v_expires_at
  )
  RETURNING id INTO v_redemption_id;

  RETURN json_build_object(
    'success', true,
    'redemption_id', v_redemption_id,
    'redemption_code', v_redemption_code,
    'expires_at', v_expires_at
  );
END;
$$;

-- Function to verify and confirm discount redemption
CREATE OR REPLACE FUNCTION verify_discount_redemption(
  p_redemption_code text,
  p_location_id uuid
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_redemption record;
  v_business_id uuid;
BEGIN
  -- Get business_id from location
  SELECT business_id INTO v_business_id
  FROM business_locations
  WHERE id = p_location_id;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Sede non trovata'
    );
  END IF;

  -- Get redemption with discount info
  SELECT
    dr.*,
    d.business_id as discount_business_id,
    d.title as discount_title,
    d.discount_percentage,
    p.full_name as customer_name
  INTO v_redemption
  FROM discount_redemptions dr
  JOIN discounts d ON dr.discount_id = d.id
  JOIN profiles p ON dr.customer_id = p.id
  WHERE dr.redemption_code = p_redemption_code;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Codice di riscatto non valido'
    );
  END IF;

  -- Check if redemption belongs to this business
  IF v_redemption.discount_business_id != v_business_id THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Questo sconto non appartiene alla tua attività'
    );
  END IF;

  -- Check if already confirmed
  IF v_redemption.status = 'confirmed' THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Questo sconto è già stato utilizzato',
      'confirmed_at', v_redemption.confirmed_at
    );
  END IF;

  -- Check if expired
  IF v_redemption.expires_at < now() THEN
    UPDATE discount_redemptions
    SET status = 'expired'
    WHERE id = v_redemption.id;

    RETURN json_build_object(
      'success', false,
      'error', 'Il codice di riscatto è scaduto'
    );
  END IF;

  -- Confirm redemption
  UPDATE discount_redemptions
  SET
    status = 'confirmed',
    confirmed_at = now(),
    confirmed_by_location_id = p_location_id
  WHERE id = v_redemption.id;

  RETURN json_build_object(
    'success', true,
    'discount_title', v_redemption.discount_title,
    'discount_percentage', v_redemption.discount_percentage,
    'customer_name', v_redemption.customer_name,
    'confirmed_at', now()
  );
END;
$$;

-- Update existing redemptions to be confirmed (backward compatibility)
UPDATE discount_redemptions
SET status = 'confirmed', confirmed_at = redeemed_at
WHERE status IS NULL OR status = 'pending';

-- Add RLS policy for businesses to verify redemptions
CREATE POLICY "Business owners can verify discount redemptions"
  ON discount_redemptions
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM discounts d
      JOIN businesses b ON d.business_id = b.id
      WHERE d.id = discount_redemptions.discount_id
        AND b.owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM discounts d
      JOIN businesses b ON d.business_id = b.id
      WHERE d.id = discount_redemptions.discount_id
        AND b.owner_id = auth.uid()
    )
  );

-- Create index for faster verification lookups
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_status ON discount_redemptions(status);
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_expires_at ON discount_redemptions(expires_at);
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_location ON discount_redemptions(confirmed_by_location_id);
