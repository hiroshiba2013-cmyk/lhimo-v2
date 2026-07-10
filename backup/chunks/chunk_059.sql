-- ============================================================
-- FILE: 20260507184823_fix_job_seeker_notification_insert_correct_columns.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260507190242_fix_all_approval_notifications_complete.sql
-- ============================================================
/*
  # Fix all approval notification functions - complete overhaul

  ## Summary
  Aligns every approval function with the notification requirements:

  ### Utenti PRIVATI ricevono notifica per:
  - Recensione approvata (con punti guadagnati)
  - Annuncio vendita/regalo/cerco approvato (con punti)
  - Annuncio "Cerco Lavoro" approvato
  - Asta approvata
  - Attività aggiunta approvata

  ### Utenti BUSINESS ricevono notifica per:
  - Ogni recensione approvata ricevuta (nuova)
  - Annuncio "Trova Lavoro" approvato (tipo corretto: job_posting_approved)
  - Annuncio vendita/regalo/cerco approvato

  ## Type changes
  - job_posting approve: type changed from 'job_approved' to 'job_posting_approved'
    to match the frontend CATEGORY_TYPES

  ## New notifications
  - 'review_received': sent to the business owner when a review on their business
    is approved by an admin
*/

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. approve_review: also notify the business owner
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param  uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  review_record   RECORD;
  customer_id_var uuid;
  family_member_id_var uuid;
  points_to_award integer;
  has_proof       boolean;
  -- business owner lookup
  v_business_owner_id uuid;
  v_business_name      text;
  v_reviewer_name      text;
BEGIN
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;

  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;

  has_proof := (
    (review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '')
    OR
    (review_record.proof_documents IS NOT NULL AND array_length(review_record.proof_documents, 1) > 0)
  );

  points_to_award := CASE WHEN has_proof THEN 50 ELSE 25 END;

  UPDATE reviews
  SET review_status = 'approved',
      approved_by   = staff_id_param,
      approved_at   = now(),
      points_awarded = points_to_award
  WHERE id = review_id_param;

  customer_id_var      := review_record.customer_id;
  family_member_id_var := review_record.family_member_id;

  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata', family_member_id_var);

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    customer_id_var, family_member_id_var, 'review_approved',
    'Recensione Approvata',
    'La tua recensione è stata approvata. Hai guadagnato ' || points_to_award || ' punti!',
    points_to_award,
    jsonb_build_object('review_id', review_id_param, 'points_awarded', points_to_award, 'had_proof', has_proof),
    'check-circle', 'green'
  );

  -- Notify the reviewer (private user)
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    customer_id_var, family_member_id_var,
    'review_approved',
    'Recensione Approvata',
    'La tua recensione è stata approvata. Hai guadagnato ' || points_to_award || ' punti in classifica!',
    jsonb_build_object('review_id', review_id_param, 'points_awarded', points_to_award)
  );

  -- ── Notify the business owner that they received a new review ──────────────
  -- Resolve reviewer display name
  SELECT COALESCE(p.nickname, p.full_name, 'Un utente')
  INTO v_reviewer_name
  FROM profiles p WHERE p.id = customer_id_var;

  -- Try claimed business (business_locations → businesses → owner)
  IF review_record.business_location_id IS NOT NULL THEN
    SELECT b.owner_id, b.name
    INTO v_business_owner_id, v_business_name
    FROM business_locations bl
    JOIN businesses b ON b.id = bl.business_id
    WHERE bl.id = review_record.business_location_id;
  END IF;

  -- Try registered business location
  IF v_business_owner_id IS NULL AND review_record.business_id IS NOT NULL THEN
    SELECT b.owner_id, b.name
    INTO v_business_owner_id, v_business_name
    FROM businesses b
    WHERE b.id = review_record.business_id;
  END IF;

  -- Try registered_businesses
  IF v_business_owner_id IS NULL AND review_record.business_type = 'registered' THEN
    -- look up via unclaimed or registered location
    NULL; -- registered businesses don't have an owner to notify yet
  END IF;

  -- Send notification to business owner (only if we found one and they differ from reviewer)
  IF v_business_owner_id IS NOT NULL AND v_business_owner_id != customer_id_var THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      v_business_owner_id,
      'review_received',
      'Nuova Recensione',
      v_reviewer_name || ' ha lasciato una recensione per ' || COALESCE(v_business_name, 'la tua attività') || '.',
      jsonb_build_object('review_id', review_id_param, 'business_location_id', review_record.business_location_id)
    );
  END IF;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. approve_job_posting: fix type to 'job_posting_approved'
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION approve_job_posting(
  p_job_id   uuid,
  p_admin_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job      RECORD;
  v_owner_id uuid;
  v_loc_id   uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  IF v_job.rb_owner_id IS NULL AND v_job.business_id IS NOT NULL THEN
    SELECT owner_id INTO v_owner_id FROM businesses WHERE id = v_job.business_id;
  ELSE
    v_owner_id := v_job.rb_owner_id;
  END IF;

  v_loc_id := COALESCE(v_job.registered_business_location_id, v_job.business_location_id);

  UPDATE job_postings
  SET approval_status = 'approved',
      status          = 'active',
      approved_at     = now(),
      approved_by     = p_admin_id
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_loc_id,
      'job_posting_approved',
      'Annuncio di Lavoro Approvato',
      'Il tuo annuncio di lavoro "' || COALESCE(v_job.title, '') || '" è stato approvato ed è ora visibile a tutti gli utenti.',
      jsonb_build_object('job_id', p_job_id)
    );
  END IF;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. reject_job_posting: fix type to 'job_posting_rejected'
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION reject_job_posting(
  p_job_id   uuid,
  p_admin_id uuid,
  p_reason   text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job      RECORD;
  v_owner_id uuid;
  v_loc_id   uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id
  INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id = jp.registered_business_id
  WHERE jp.id = p_job_id;

  IF NOT FOUND THEN RAISE EXCEPTION 'Job posting not found'; END IF;

  IF v_job.rb_owner_id IS NULL AND v_job.business_id IS NOT NULL THEN
    SELECT owner_id INTO v_owner_id FROM businesses WHERE id = v_job.business_id;
  ELSE
    v_owner_id := v_job.rb_owner_id;
  END IF;

  v_loc_id := COALESCE(v_job.registered_business_location_id, v_job.business_location_id);

  UPDATE job_postings
  SET approval_status  = 'rejected',
      approved_at      = now(),
      approved_by      = p_admin_id,
      approval_notes   = p_reason
  WHERE id = p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, business_location_id, type, title, message, data)
    VALUES (
      v_owner_id,
      v_loc_id,
      'job_posting_rejected',
      'Annuncio di Lavoro Non Approvato',
      CASE
        WHEN p_reason IS NOT NULL AND p_reason != ''
        THEN 'Il tuo annuncio di lavoro non è stato approvato. Motivo: ' || p_reason
        ELSE 'Il tuo annuncio di lavoro non è stato approvato.'
      END,
      jsonb_build_object('job_id', p_job_id)
    );
  END IF;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. approve_auction: add notification with points info for private users
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION approve_auction(
  p_auction_id uuid,
  p_admin_id   uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction RECORD;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  UPDATE auctions
  SET approval_status = 'approved',
      status          = 'active',
      approved_by     = p_admin_id,
      approved_at     = now(),
      points_awarded  = 0
  WHERE id = p_auction_id;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_approved',
    'Asta Approvata',
    'La tua asta "' || v_auction.title || '" è stata approvata ed è ora visibile a tutti gli utenti.',
    jsonb_build_object('auction_id', p_auction_id)
  );
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. reject_auction: ensure consistent type 'auction_rejected'
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION reject_auction(
  p_auction_id uuid,
  p_admin_id   uuid,
  p_reason     text DEFAULT ''
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_auction RECORD;
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v_auction.approval_status != 'pending' THEN RAISE EXCEPTION 'L''asta è già stata processata'; END IF;

  UPDATE auctions
  SET approval_status  = 'rejected',
      approved_by      = p_admin_id,
      approved_at      = now(),
      approval_notes   = p_reason
  WHERE id = p_auction_id;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    v_auction.user_id,
    v_auction.family_member_id,
    'auction_rejected',
    'Asta Non Approvata',
    CASE
      WHEN p_reason IS NOT NULL AND p_reason != ''
      THEN 'La tua asta "' || v_auction.title || '" non è stata approvata. Motivo: ' || p_reason
      ELSE 'La tua asta "' || v_auction.title || '" non è stata approvata.'
    END,
    jsonb_build_object('auction_id', p_auction_id)
  );
END;
$$;


-- ============================================================
-- FILE: 20260507191257_add_auction_conversation_type.sql
-- ============================================================
/*
  # Add 'auction' to conversations conversation_type constraint

  The conversations table had a CHECK constraint allowing only:
  'classified_ad', 'job_seeker', 'job_posting'

  This adds 'auction' to support direct messaging between auction
  winner and seller after an auction concludes.
*/

ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_conversation_type_check;

ALTER TABLE conversations ADD CONSTRAINT conversations_conversation_type_check
  CHECK (conversation_type = ANY (ARRAY[
    'classified_ad'::text,
    'job_seeker'::text,
    'job_posting'::text,
    'auction'::text
  ]));


-- ============================================================
-- FILE: 20260507192209_fix_points_subtraction_triggers.sql
-- ============================================================
/*
  # Fix points subtraction triggers

  ## Problems fixed:

  ### 1. subtract_points_for_deleted_review
  - Used `OLD.proof_url` but the column is named `proof_image_url`
  - This caused the proof check to always be false → always subtracted 25 pts
    instead of 50 for reviews that had proof documents
  - Also checks proof_documents array (like approve_review does)
  - Added GREATEST(0, ...) guard to prevent negative points

  ### 2. subtract_points_for_deleted_classified_ad
  - Called award_points(-5) without a floor, allowing negative total_points
  - Now uses direct UPDATE with GREATEST(0, total_points - 5) consistent
    with the unclaimed_business trigger style
  - Also respects family_member_id correctly

  Both triggers only subtract points if the item was already approved
  (points_awarded > 0), preventing double-subtraction on pending items.
*/

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. Fix review deletion trigger: correct column name + GREATEST guard
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_review()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  points_to_subtract INTEGER;
  has_proof BOOLEAN;
BEGIN
  -- Only subtract if points were actually awarded (review was approved)
  IF OLD.points_awarded IS NULL OR OLD.points_awarded = 0 THEN
    RETURN OLD;
  END IF;

  -- Match the same proof logic used in approve_review()
  has_proof := (
    (OLD.proof_image_url IS NOT NULL AND OLD.proof_image_url != '')
    OR
    (OLD.proof_documents IS NOT NULL AND array_length(OLD.proof_documents, 1) > 0)
  );

  points_to_subtract := CASE WHEN has_proof THEN 50 ELSE 25 END;

  IF OLD.family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points      = GREATEST(0, total_points - points_to_subtract),
      reviews_count     = GREATEST(0, reviews_count - 1),
      updated_at        = now()
    WHERE user_id = OLD.customer_id AND family_member_id = OLD.family_member_id;
  ELSE
    UPDATE user_activity
    SET
      total_points      = GREATEST(0, total_points - points_to_subtract),
      reviews_count     = GREATEST(0, reviews_count - 1),
      updated_at        = now()
    WHERE user_id = OLD.customer_id AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. Fix classified ad deletion trigger: GREATEST guard + family_member support
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_classified_ad()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Only subtract if points were actually awarded (ad was approved)
  IF OLD.points_awarded IS NULL OR OLD.points_awarded = 0 THEN
    RETURN OLD;
  END IF;

  IF OLD.family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points   = GREATEST(0, total_points - 5),
      ads_posted_count = GREATEST(0, ads_posted_count - 1),
      updated_at     = now()
    WHERE user_id = OLD.user_id AND family_member_id = OLD.family_member_id;
  ELSE
    UPDATE user_activity
    SET
      total_points   = GREATEST(0, total_points - 5),
      ads_posted_count = GREATEST(0, ads_posted_count - 1),
      updated_at     = now()
    WHERE user_id = OLD.user_id AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;


-- ============================================================
-- FILE: 20260507193044_add_owner_id_to_products_and_points_trigger.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260507201130_disable_product_and_user_added_business_points_triggers.sql
-- ============================================================
/*
  # Disable points triggers for products and user_added_businesses

  ## Rationale

  The official points system is:
    - +50  Recensione con prova (approvazione staff)
    - +25  Recensione senza prova (approvazione staff)
    - +30  Referral (amico si abbona)
    - +25  Attività aggiunta con contatto (approvazione staff, unclaimed_business_locations)
    - +10  Attività aggiunta senza contatto (approvazione staff, unclaimed_business_locations)
    - +5   Annuncio pubblicato approvato (vendita/regalo/cerco)
    - Solo utenti privati (customer) partecipano

  ## What is disabled

  ### products triggers
  - `trigger_award_points_for_product` — products are not in the points system
  - `trigger_subtract_points_deleted_product` — corresponding subtraction

  ### user_added_businesses triggers
  - `trigger_award_points_user_added_business` — obsolete table; points would fire
    immediately on insert without staff approval, and without business-user guard
  - `trigger_subtract_points_user_added_business` — corresponding subtraction
*/

-- Disable product points triggers
ALTER TABLE products DISABLE TRIGGER trigger_award_points_for_product;
ALTER TABLE products DISABLE TRIGGER trigger_subtract_points_deleted_product;

-- Disable user_added_businesses points triggers (obsolete/incorrect)
ALTER TABLE user_added_businesses DISABLE TRIGGER trigger_award_points_user_added_business;
ALTER TABLE user_added_businesses DISABLE TRIGGER trigger_subtract_points_user_added_business;


