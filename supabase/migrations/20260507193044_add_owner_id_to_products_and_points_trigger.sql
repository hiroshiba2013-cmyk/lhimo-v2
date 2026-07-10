/*
  # Add owner_id to products + points triggers

  ## Changes

  ### products table
  - Add `owner_id` column (uuid, FK → profiles) — tracks who inserted the product
  - Add index on owner_id

  ### Points triggers
  - `award_points_for_product`: awards 10 pts to owner_id on INSERT (only for customer users)
  - `subtract_points_for_deleted_product`: subtracts 10 pts on DELETE with GREATEST(0,...)
  - Both triggers attached to the products table

  ### Notes
  - Business users are blocked by award_points() which returns 0 for user_type='business'
  - Products are inserted by business owners who are customer-type profiles
    (registered_businesses.owner_id → profiles.id where user_type may be 'business')
  - The trigger still calls award_points which guards against business accounts
*/

-- Add owner_id column to products
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'products' AND column_name = 'owner_id'
  ) THEN
    ALTER TABLE products ADD COLUMN owner_id uuid REFERENCES profiles(id) ON DELETE SET NULL;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_products_owner_id ON products(owner_id);

-- RLS: owner can manage their own products
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'products' AND policyname = 'Owner can insert products'
  ) THEN
    CREATE POLICY "Owner can insert products"
      ON products FOR INSERT
      TO authenticated
      WITH CHECK (auth.uid() = owner_id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'products' AND policyname = 'Owner can update own products'
  ) THEN
    CREATE POLICY "Owner can update own products"
      ON products FOR UPDATE
      TO authenticated
      USING (auth.uid() = owner_id)
      WITH CHECK (auth.uid() = owner_id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'products' AND policyname = 'Owner can delete own products'
  ) THEN
    CREATE POLICY "Owner can delete own products"
      ON products FOR DELETE
      TO authenticated
      USING (auth.uid() = owner_id);
  END IF;
END $$;

-- Award 10 pts on product insert
CREATE OR REPLACE FUNCTION award_points_for_product()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NEW.owner_id IS NOT NULL THEN
    PERFORM award_points(NEW.owner_id, 10, 'product', 'Prodotto inserito');

    INSERT INTO activity_log (
      user_id, activity_type, title, description,
      points_earned, metadata, icon, color
    )
    VALUES (
      NEW.owner_id, 'product_added',
      'Prodotto Inserito',
      'Hai inserito il prodotto "' || NEW.name || '". Hai guadagnato 10 punti!',
      10,
      jsonb_build_object('product_id', NEW.id, 'product_name', NEW.name),
      'package', 'blue'
    );
  END IF;
  RETURN NEW;
END;
$$;

-- Subtract 10 pts on product delete
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_product()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF OLD.owner_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points = GREATEST(0, total_points - 10),
      updated_at   = now()
    WHERE user_id = OLD.owner_id AND family_member_id IS NULL;
  END IF;
  RETURN OLD;
END;
$$;

-- Attach triggers to products table
DROP TRIGGER IF EXISTS trigger_award_points_for_product ON products;
CREATE TRIGGER trigger_award_points_for_product
  AFTER INSERT ON products
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_product();

DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_product ON products;
CREATE TRIGGER trigger_subtract_points_deleted_product
  BEFORE DELETE ON products
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_product();
