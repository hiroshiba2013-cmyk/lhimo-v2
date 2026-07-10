/*
  # Create Discount Redemptions System

  1. New Tables
    - `discount_redemptions`
      - `id` (uuid, primary key)
      - `discount_id` (uuid, references discounts)
      - `customer_id` (uuid, references profiles)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `redeemed_at` (timestamptz, default now())
      - `notes` (text, nullable)
      
  2. Security
    - Enable RLS on `discount_redemptions` table
    - Add policies for authenticated users to:
      - View their own redemptions
      - Create new redemptions for themselves
    
  3. Indexes
    - Add index on discount_id for faster queries
    - Add index on customer_id for faster user queries
    - Add composite index on (customer_id, discount_id) for duplicate prevention
*/

-- Create discount_redemptions table
CREATE TABLE IF NOT EXISTS discount_redemptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  discount_id uuid NOT NULL REFERENCES discounts(id) ON DELETE CASCADE,
  customer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  redeemed_at timestamptz DEFAULT now(),
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE discount_redemptions ENABLE ROW LEVEL SECURITY;

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_discount_id ON discount_redemptions(discount_id);
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_customer_id ON discount_redemptions(customer_id);
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_customer_discount ON discount_redemptions(customer_id, discount_id);

-- RLS Policies
CREATE POLICY "Users can view own discount redemptions"
  ON discount_redemptions
  FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

CREATE POLICY "Users can create own discount redemptions"
  ON discount_redemptions
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = customer_id);