-- ============================================================
-- FILE: 20260112162250_update_delete_account_add_discount_redemptions.sql
-- ============================================================
/*
  # Aggiorna Eliminazione Account - Aggiungi Discount Redemptions

  1. Problema Risolto
    - Aggiungi eliminazione delle discount_redemptions quando si elimina l'account
  
  2. Sicurezza
    - Mantiene SECURITY DEFINER per accesso completo
    - Verifica autenticazione utente
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione aggiornata
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- IMPORTANTE: Gestisci le recensioni approvate da questo utente
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le redemptions degli sconti
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina i messaggi degli annunci classificati dell'utente
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT c.id FROM ad_conversations c
    JOIN classified_ads ca ON c.ad_id = ca.id
    WHERE ca.user_id = user_profile_id
  );
  
  -- Elimina i messaggi inviati dall'utente negli annunci
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni degli annunci
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;
  
  -- Elimina i messaggi generici dell'utente
  DELETE FROM messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni generiche
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;
  
  -- Elimina gli annunci classificati
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_offer_messages WHERE conversation_id IN (
      SELECT id FROM job_offer_conversations WHERE job_posting_id IN (
        SELECT id FROM job_postings WHERE business_id = user_business_id
      )
    );
    
    -- Elimina le conversazioni degli annunci di lavoro
    DELETE FROM job_offer_conversations WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le visualizzazioni degli annunci di lavoro
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le application agli annunci di lavoro
    DELETE FROM job_applications WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker (come employer o seeker)
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;
  
  -- Elimina i messaggi nelle conversazioni di job offer
  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni di job offer
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20260112211131_update_points_system_new_scale.sql
-- ============================================================
/*
  # Aggiornamento Sistema Punti - Nuova Scala

  ## Modifiche
  
  1. Aggiorna la funzione `approve_review` per nuova scala punti:
     - 50 punti: Recensione completa (con tutti i rating dettagliati)
     - 25 punti: Recensione base (solo voto finale)
  
  2. Crea trigger per assegnare punti automaticamente:
     - 5 punti: Annuncio pubblicato (classified_ads)
     - 10 punti: Prodotto inserito (products)
     - 20 punti: Attività inserita (business_locations non reclamate)
  
  3. Aggiorna sistema referral:
     - 30 punti: Presenta un amico (quando l'amico si abbona)
  
  ## Note
  - I punti vengono assegnati solo per azioni valide
  - Il sistema supporta sia utenti principali che membri della famiglia
*/

-- Aggiorna funzione approve_review con nuova scala punti
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Ottieni i dettagli della recensione
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Calcola i punti da assegnare
  IF review_record.price_rating IS NOT NULL AND 
     review_record.service_rating IS NOT NULL AND 
     review_record.quality_rating IS NOT NULL THEN
    points_to_award := 50; -- Recensione completa
  ELSE
    points_to_award := 25; -- Recensione base (solo voto finale)
  END IF;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Cancella l'immagine dopo l'approvazione
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente (customer_id o family_member_id)
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', review_id_param::text);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Funzione per assegnare punti quando viene inserito un annuncio
CREATE OR REPLACE FUNCTION award_points_for_classified_ad()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 5 punti al proprietario dell'annuncio
  PERFORM award_points(NEW.owner_id, 5, 'classified_ad', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per annunci pubblicati
DROP TRIGGER IF EXISTS trigger_award_points_classified_ad ON classified_ads;
CREATE TRIGGER trigger_award_points_classified_ad
  AFTER INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_classified_ad();

-- Funzione per assegnare punti quando viene inserito un prodotto
CREATE OR REPLACE FUNCTION award_points_for_product()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 10 punti al business che inserisce il prodotto
  PERFORM award_points(NEW.business_id, 10, 'product', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per prodotti inseriti
DROP TRIGGER IF EXISTS trigger_award_points_product ON products;
CREATE TRIGGER trigger_award_points_product
  AFTER INSERT ON products
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_product();

-- Funzione per assegnare punti quando viene inserita un'attività non reclamata
CREATE OR REPLACE FUNCTION award_points_for_business_location()
RETURNS TRIGGER AS $$
BEGIN
  -- Assegna 20 punti all'utente che ha inserito l'attività (se specificato)
  IF NEW.created_by IS NOT NULL THEN
    PERFORM award_points(NEW.created_by, 20, 'business_location', NEW.id::text);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aggiungi colonna created_by se non esiste
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'business_locations' AND column_name = 'created_by'
  ) THEN
    ALTER TABLE business_locations ADD COLUMN created_by uuid REFERENCES profiles(id);
    CREATE INDEX IF NOT EXISTS idx_business_locations_created_by ON business_locations(created_by);
  END IF;
END $$;

-- Trigger per attività inserite
DROP TRIGGER IF EXISTS trigger_award_points_business_location ON business_locations;
CREATE TRIGGER trigger_award_points_business_location
  AFTER INSERT ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_business_location();

-- Aggiorna funzione referral per assegnare 30 punti
CREATE OR REPLACE FUNCTION process_referral_on_subscription()
RETURNS TRIGGER AS $$
DECLARE
  referrer_id uuid;
BEGIN
  -- Verifica se l'utente è stato referito
  SELECT referred_by INTO referrer_id
  FROM profiles
  WHERE id = NEW.user_id AND referred_by IS NOT NULL;
  
  IF referrer_id IS NOT NULL THEN
    -- Assegna 30 punti al referrer
    PERFORM award_points(referrer_id, 30, 'referral', NEW.user_id::text);
    
    -- Registra il referral come completato
    UPDATE referrals
    SET status = 'completed',
        completed_at = now()
    WHERE referrer_id = referrer_id
      AND referred_user_id = NEW.user_id
      AND status = 'pending';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per referral
DROP TRIGGER IF EXISTS trigger_process_referral ON subscriptions;
CREATE TRIGGER trigger_process_referral
  AFTER INSERT ON subscriptions
  FOR EACH ROW
  WHEN (NEW.status = 'active')
  EXECUTE FUNCTION process_referral_on_subscription();


-- ============================================================
-- FILE: 20260112212346_add_profile_pin_protection.sql
-- ============================================================
/*
  # Add PIN Protection for Profiles

  1. Changes
    - Add `pin_code` column to `profiles` table (optional, encrypted)
    - Add `pin_code` column to `customer_family_members` table (optional, encrypted)
    - Add `pin_enabled` boolean flags to enable/disable PIN protection
    
  2. Security
    - PIN codes are stored as text (will be hashed on client side before storage)
    - Users can optionally enable PIN protection for their profiles
    - Family members can also have individual PIN protection
*/

-- Add PIN protection to profiles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'pin_enabled'
  ) THEN
    ALTER TABLE profiles ADD COLUMN pin_enabled boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'pin_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN pin_code text;
  END IF;
END $$;

-- Add PIN protection to customer_family_members table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'pin_enabled'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN pin_enabled boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'pin_code'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN pin_code text;
  END IF;
END $$;

-- Add comments for documentation
COMMENT ON COLUMN profiles.pin_enabled IS 'Whether PIN protection is enabled for this profile';
COMMENT ON COLUMN profiles.pin_code IS 'Hashed PIN code for profile protection (optional)';
COMMENT ON COLUMN customer_family_members.pin_enabled IS 'Whether PIN protection is enabled for this family member';
COMMENT ON COLUMN customer_family_members.pin_code IS 'Hashed PIN code for family member protection (optional)';


-- ============================================================
-- FILE: 20260113110358_add_business_location_to_reviews.sql
-- ============================================================
/*
  # Add Business Location to Reviews

  1. Changes
    - Add `business_location_id` column to `reviews` table (nullable)
    - Add foreign key constraint to `business_locations` table
    - Add index for performance on location-based queries
    - Update RLS policies to handle location-based reviews

  2. Notes
    - The field is nullable to allow reviews for the business in general
    - Existing reviews will have NULL for this field
    - New reviews can optionally specify a specific location
*/

-- Add business_location_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'business_location_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN business_location_id uuid REFERENCES business_locations(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_reviews_business_location_id ON reviews(business_location_id);

-- Add comment for documentation
COMMENT ON COLUMN reviews.business_location_id IS 'Optional reference to specific business location being reviewed. NULL means review is for the business in general.';

-- ============================================================
-- FILE: 20260113223512_add_discount_verification_system.sql
-- ============================================================
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


