-- ============================================================
-- MIGRAZIONE: Ricrea trigger mancanti dal vecchio progetto
-- Generato automaticamente dal confronto backup vs nuovo progetto
-- ============================================================

-- ============================================================
-- TRIGGER: businesses_search_vector_trigger
-- ============================================================
CREATE OR REPLACE FUNCTION businesses_search_vector_update()
RETURNS trigger AS $$
BEGIN
  NEW.search_vector := 
    setweight(to_tsvector('italian', COALESCE(NEW.name, '')), 'A') ||
    setweight(to_tsvector('italian', COALESCE(NEW.description, '')), 'B');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS businesses_search_vector_trigger ON businesses;
CREATE TRIGGER businesses_search_vector_trigger
BEFORE INSERT OR UPDATE ON businesses
FOR EACH ROW
EXECUTE FUNCTION businesses_search_vector_update();


-- ============================================================
-- TRIGGER: calculate_overall_rating_trigger
-- ============================================================
CREATE OR REPLACE FUNCTION calculate_overall_rating_for_service_used()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.review_type = 'service_used' AND
     NEW.booking_management_rating IS NOT NULL AND
     NEW.reliability_rating IS NOT NULL AND
     NEW.organization_rating IS NOT NULL AND
     NEW.experience_rating IS NOT NULL AND
     NEW.price_rating IS NOT NULL THEN
    NEW.overall_rating := ROUND(
      (NEW.booking_management_rating +
       NEW.reliability_rating +
       NEW.organization_rating +
       NEW.experience_rating +
       NEW.price_rating) / 5.0
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS calculate_overall_rating_trigger ON reviews;
CREATE TRIGGER calculate_overall_rating_trigger
  BEFORE INSERT OR UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION calculate_overall_rating_for_service_used();


-- ============================================================
-- TRIGGER: on_auth_user_created_create_profile
-- ============================================================
DROP TRIGGER IF EXISTS on_auth_user_created_create_profile ON auth.users;
CREATE TRIGGER on_auth_user_created_create_profile
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- TRIGGER: sync_business_claimed_on_location_change
-- ============================================================
CREATE OR REPLACE FUNCTION sync_business_claimed_status()
RETURNS TRIGGER AS $$
BEGIN
  -- If any location is claimed, mark the business as claimed
  UPDATE businesses
  SET is_claimed = true
  WHERE id = NEW.business_id
    AND is_claimed = false;
  
  -- If all locations are unclaimed, mark the business as unclaimed
  IF NEW.is_claimed = false THEN
    UPDATE businesses
    SET is_claimed = false
    WHERE id = NEW.business_id
      AND NOT EXISTS (
        SELECT 1 FROM business_locations
        WHERE business_id = NEW.business_id
          AND is_claimed = true
      );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS sync_business_claimed_on_location_change ON business_locations;
CREATE TRIGGER sync_business_claimed_on_location_change
  AFTER INSERT OR UPDATE OF is_claimed ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION sync_business_claimed_status();


-- ============================================================
-- TRIGGER: trg_update_auction_current_bidder
-- ============================================================
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

DROP TRIGGER IF EXISTS trg_update_auction_current_bidder ON auction_bids;
CREATE TRIGGER trg_update_auction_current_bidder
  AFTER INSERT ON auction_bids
  FOR EACH ROW
  EXECUTE FUNCTION update_auction_current_bidder();


-- ============================================================
-- TRIGGER: trigger_award_points_business_location
-- ============================================================
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

DROP TRIGGER IF EXISTS trigger_award_points_business_location ON business_locations;
CREATE TRIGGER trigger_award_points_business_location
  AFTER INSERT ON business_locations
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_business_location();


-- ============================================================
-- TRIGGER: trigger_award_points_for_product
-- ============================================================
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

DROP TRIGGER IF EXISTS trigger_award_points_for_product ON products;
CREATE TRIGGER trigger_award_points_for_product
  AFTER INSERT ON products
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_product();


-- ============================================================
-- TRIGGER: trigger_award_points_unclaimed_business
-- ============================================================
CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  is_complete := (
    (NEW.email IS NOT NULL AND NEW.email != '') OR 
    (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
    (NEW.website IS NOT NULL AND NEW.website != '')
  );

  IF is_complete THEN
    points_to_award := 25;
  ELSE
    points_to_award := 10;
  END IF;

  v_family_member_id := NEW.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, v_family_member_id, points_to_award, 1, now(), now(), now())
    ON CONFLICT (user_id, family_member_id)
    DO UPDATE SET
      total_points = user_activity.total_points + points_to_award,
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, NULL, points_to_award, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      total_points = user_activity.total_points + points_to_award,
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  END IF;

  INSERT INTO activity_log (
    user_id,
    family_member_id,
    activity_type,
    title,
    description,
    points_earned,
    icon,
    color,
    metadata,
    created_at
  ) VALUES (
    NEW.added_by,
    v_family_member_id,
    'business_added',
    'Attivita'' aggiunta',
    CASE 
      WHEN is_complete THEN 'Hai aggiunto "' || NEW.name || '" con dati completi'
      ELSE 'Hai aggiunto "' || NEW.name || '"'
    END,
    points_to_award,
    'building',
    'green',
    jsonb_build_object(
      'business_id', NEW.id,
      'business_name', NEW.name,
      'is_complete', is_complete,
      'family_member_id', v_family_member_id
    ),
    now()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_award_points_unclaimed_business ON unclaimed_business_locations;
CREATE TRIGGER trigger_award_points_unclaimed_business
  AFTER INSERT ON unclaimed_business_locations
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION award_points_for_unclaimed_business();


-- ============================================================
-- TRIGGER: trigger_award_points_unclaimed_business_on_approval
-- ============================================================
CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business_on_approval()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  IF NEW.approval_status = 'approved' 
  AND (OLD.approval_status IS DISTINCT FROM 'approved')
  AND (NEW.points_awarded IS NOT TRUE) THEN

    is_complete := (
      (NEW.email IS NOT NULL AND NEW.email != '') OR 
      (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
      (NEW.website IS NOT NULL AND NEW.website != '')
    );

    IF is_complete THEN
      points_to_award := 25;
    ELSE
      points_to_award := 10;
    END IF;

    v_family_member_id := NEW.added_by_family_member_id;

    IF NEW.added_by IS NOT NULL THEN
      IF v_family_member_id IS NOT NULL THEN
        INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
        VALUES (NEW.added_by, v_family_member_id, points_to_award, 1, now(), now(), now())
        ON CONFLICT (user_id, family_member_id)
        DO UPDATE SET
          total_points = user_activity.total_points + points_to_award,
          businesses_added_count = user_activity.businesses_added_count + 1,
          last_activity_at = now(),
          updated_at = now();
      ELSE
        INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
        VALUES (NEW.added_by, NULL, points_to_award, 1, now(), now(), now())
        ON CONFLICT (user_id) WHERE family_member_id IS NULL
        DO UPDATE SET
          total_points = user_activity.total_points + points_to_award,
          businesses_added_count = user_activity.businesses_added_count + 1,
          last_activity_at = now(),
          updated_at = now();
      END IF;

      INSERT INTO activity_log (
        user_id, activity_type, title, description, points_earned, icon, color, metadata, created_at
      ) VALUES (
        NEW.added_by,
        'business_added',
        'Attivita'' approvata',
        CASE 
          WHEN is_complete THEN 'La tua attivita'' "' || NEW.name || '" e'' stata approvata (con dati completi)'
          ELSE 'La tua attivita'' "' || NEW.name || '" e'' stata approvata'
        END,
        points_to_award,
        'building',
        'green',
        jsonb_build_object(
          'business_id', NEW.id,
          'business_name', NEW.name,
          'is_complete', is_complete,
          'family_member_id', v_family_member_id
        ),
        now()
      );

      INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
      VALUES (
        NEW.added_by,
        v_family_member_id,
        'business_approved',
        'Attivita'' Approvata',
        'La tua attivita'' "' || NEW.name || '" e'' stata approvata. Hai guadagnato ' || points_to_award || ' punti in classifica!',
        jsonb_build_object('business_id', NEW.id, 'business_name', NEW.name, 'points_awarded', points_to_award)
      );

      NEW.points_awarded := true;
    END IF;
  END IF;

  IF NEW.approval_status = 'rejected'
  AND (OLD.approval_status IS DISTINCT FROM 'rejected')
  AND NEW.added_by IS NOT NULL THEN

    v_family_member_id := NEW.added_by_family_member_id;

    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      NEW.added_by,
      v_family_member_id,
      'business_rejected',
      'Attivita'' Rifiutata',
      'La tua attivita'' "' || NEW.name || '" non e'' stata approvata. Verifica i dati inseriti e riprova.',
      jsonb_build_object('business_id', NEW.id, 'business_name', NEW.name)
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_award_points_unclaimed_business_on_approval ON unclaimed_business_locations;
CREATE TRIGGER trigger_award_points_unclaimed_business_on_approval
  BEFORE UPDATE ON unclaimed_business_locations
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_unclaimed_business_on_approval();


-- ============================================================
-- TRIGGER: trigger_award_points_user_added_business
-- ============================================================
CREATE OR REPLACE FUNCTION award_points_for_user_added_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
BEGIN
  -- Determina se l'attività è completa
  is_complete := (
    (NEW.email IS NOT NULL AND NEW.email != '') OR 
    (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
    (NEW.website IS NOT NULL AND NEW.website != '')
  );

  -- Assegna punti
  IF is_complete THEN
    points_to_award := 25;
  ELSE
    points_to_award := 10;
  END IF;

  -- Aggiorna i punti totali
  UPDATE user_activity
  SET 
    total_points = total_points + points_to_award,
    updated_at = now()
  WHERE user_id = NEW.added_by;

  -- Crea un log
  INSERT INTO activity_log (
    user_id,
    activity_type,
    title,
    description,
    points_earned,
    icon,
    color,
    metadata,
    created_at
  ) VALUES (
    NEW.added_by,
    'business_added',
    'Attività aggiunta',
    CASE 
      WHEN is_complete THEN 'Hai aggiunto "' || NEW.name || '" con dati completi'
      ELSE 'Hai aggiunto "' || NEW.name || '"'
    END,
    points_to_award,
    'building',
    'green',
    jsonb_build_object(
      'business_id', NEW.id,
      'business_name', NEW.name,
      'is_complete', is_complete
    ),
    now()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_award_points_user_added_business ON user_added_businesses;
CREATE TRIGGER trigger_award_points_user_added_business
  AFTER INSERT ON user_added_businesses
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION award_points_for_user_added_business();


-- ============================================================
-- TRIGGER: trigger_check_family_trial_eligibility
-- ============================================================
CREATE OR REPLACE FUNCTION check_family_member_trial_eligibility()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_blocked_cf text;
BEGIN
  -- Controlla solo se il CF è fornito
  IF NEW.fiscal_code IS NULL OR NEW.fiscal_code = '' THEN
    RETURN NEW;
  END IF;

  -- Controlla se questo CF ha già usato il trial
  SELECT fiscal_code INTO v_blocked_cf
  FROM trial_usage_history
  WHERE fiscal_code = NEW.fiscal_code;

  IF v_blocked_cf IS NOT NULL THEN
    RAISE EXCEPTION 'Il codice fiscale % ha già usufruito del periodo di prova', NEW.fiscal_code
      USING ERRCODE = '23514';
  END IF;

  -- Registra il CF del nuovo membro se l'account è in trial
  IF EXISTS (
    SELECT 1 FROM profiles
    WHERE id = NEW.customer_id
      AND subscription_status = 'trial'
  ) THEN
    INSERT INTO trial_usage_history (fiscal_code, first_user_id, first_trial_date)
    VALUES (NEW.fiscal_code, NEW.customer_id, now())
    ON CONFLICT (fiscal_code) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_check_family_trial_eligibility ON customer_family_members;
CREATE TRIGGER trigger_check_family_trial_eligibility
  BEFORE INSERT OR UPDATE OF tax_code ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION check_family_member_trial_eligibility();


-- ============================================================
-- TRIGGER: trigger_create_trial_for_business
-- ============================================================
CREATE OR REPLACE FUNCTION create_trial_for_business_profile()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles
  IF NEW.user_type = 'business' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';
    
    -- Set trial fields on NEW instead of doing UPDATE to avoid recursion
    NEW.subscription_status := 'trial';
    NEW.subscription_type := 'monthly';
    NEW.subscription_expires_at := trial_end;
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%Mensile%1 Sede%'
    LIMIT 1;
    
    -- Create trial subscription if plan exists
    -- This happens in AFTER INSERT trigger, not in BEFORE INSERT
    -- We'll create a separate AFTER INSERT trigger for this
  END IF;
  
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_create_trial_for_business ON profiles;
CREATE TRIGGER trigger_create_trial_for_business
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_trial_for_business_profile();


-- ============================================================
-- TRIGGER: trigger_decrement_ads_posted_count
-- ============================================================
CREATE OR REPLACE FUNCTION decrement_ads_posted_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrementa il contatore
  UPDATE user_activity
  SET 
    ads_posted_count = GREATEST(0, ads_posted_count - 1),
    last_activity_at = now(),
    updated_at = now()
  WHERE user_id = OLD.user_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_decrement_ads_posted_count ON classified_ads;
CREATE TRIGGER trigger_decrement_ads_posted_count
  AFTER DELETE ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION decrement_ads_posted_count();


-- ============================================================
-- TRIGGER: trigger_decrement_unclaimed_business_count
-- ============================================================
CREATE OR REPLACE FUNCTION decrement_unclaimed_business_count()
RETURNS TRIGGER AS $$
DECLARE
  v_family_member_id uuid;
BEGIN
  v_family_member_id := OLD.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET businesses_added_count = GREATEST(0, businesses_added_count - 1),
        last_activity_at = now(),
        updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id = v_family_member_id;
  ELSE
    UPDATE user_activity
    SET businesses_added_count = GREATEST(0, businesses_added_count - 1),
        last_activity_at = now(),
        updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_decrement_unclaimed_business_count ON unclaimed_business_locations;
CREATE TRIGGER trigger_decrement_unclaimed_business_count
  AFTER DELETE ON unclaimed_business_locations
  FOR EACH ROW
  WHEN (OLD.added_by IS NOT NULL)
  EXECUTE FUNCTION decrement_unclaimed_business_count();


-- ============================================================
-- TRIGGER: trigger_decrement_user_added_business_count
-- ============================================================
CREATE OR REPLACE FUNCTION decrement_user_added_business_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrementa il contatore
  UPDATE user_activity
  SET 
    businesses_added_count = GREATEST(0, businesses_added_count - 1),
    last_activity_at = now(),
    updated_at = now()
  WHERE user_id = OLD.added_by;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_decrement_user_added_business_count ON user_added_businesses;
CREATE TRIGGER trigger_decrement_user_added_business_count
  AFTER DELETE ON user_added_businesses
  FOR EACH ROW
  WHEN (OLD.added_by IS NOT NULL)
  EXECUTE FUNCTION decrement_user_added_business_count();


-- ============================================================
-- TRIGGER: trigger_increment_ads_posted_count
-- ============================================================
CREATE OR REPLACE FUNCTION increment_ads_posted_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF NEW.family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.user_id AND family_member_id = NEW.family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.user_id AND family_member_id = NEW.family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.user_id, NEW.family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.user_id, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_increment_ads_posted_count ON classified_ads;
CREATE TRIGGER trigger_increment_ads_posted_count
  AFTER INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION increment_ads_posted_count();


-- ============================================================
-- TRIGGER: trigger_increment_unclaimed_business_count
-- ============================================================
CREATE OR REPLACE FUNCTION increment_unclaimed_business_count()
RETURNS TRIGGER AS $$
DECLARE
  v_family_member_id uuid;
BEGIN
  v_family_member_id := NEW.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, v_family_member_id, 1, now(), now(), now())
    ON CONFLICT (user_id, family_member_id)
    DO UPDATE SET
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, NULL, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_increment_unclaimed_business_count ON unclaimed_business_locations;
CREATE TRIGGER trigger_increment_unclaimed_business_count
  AFTER INSERT ON unclaimed_business_locations
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION increment_unclaimed_business_count();


-- ============================================================
-- TRIGGER: trigger_increment_user_added_business_count
-- ============================================================
CREATE OR REPLACE FUNCTION increment_user_added_business_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF NEW.added_by_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.added_by AND family_member_id = NEW.added_by_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        businesses_added_count = businesses_added_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.added_by AND family_member_id = NEW.added_by_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.added_by, NEW.added_by_family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.added_by AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        businesses_added_count = businesses_added_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.added_by AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.added_by, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_increment_user_added_business_count ON user_added_businesses;
CREATE TRIGGER trigger_increment_user_added_business_count
  AFTER INSERT ON user_added_businesses
  FOR EACH ROW
  WHEN (NEW.added_by IS NOT NULL)
  EXECUTE FUNCTION increment_user_added_business_count();


-- ============================================================
-- TRIGGER: trigger_insert_business_trial_subscription
-- ============================================================
CREATE OR REPLACE FUNCTION insert_business_trial_subscription()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  basic_plan_id uuid;
  trial_end timestamptz;
BEGIN
  -- Only process for business profiles with trial status
  IF NEW.user_type = 'business' AND NEW.subscription_status = 'trial' THEN
    -- Calculate trial end date (30 days from now)
    trial_end := now() + interval '30 days';
    
    -- Get the basic business plan (1 location, monthly)
    SELECT id INTO basic_plan_id
    FROM subscription_plans
    WHERE name LIKE '%Business%Mensile%1 Sede%'
    LIMIT 1;
    
    -- Create trial subscription if plan exists
    IF basic_plan_id IS NOT NULL THEN
      INSERT INTO subscriptions (
        customer_id,
        plan_id,
        status,
        start_date,
        end_date,
        trial_end_date,
        payment_method_added
      ) VALUES (
        NEW.id,
        basic_plan_id,
        'trial',
        now(),
        trial_end,
        trial_end,
        false
      )
      ON CONFLICT (customer_id) DO NOTHING;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_insert_business_trial_subscription ON profiles;
CREATE TRIGGER trigger_insert_business_trial_subscription
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION insert_business_trial_subscription();


-- ============================================================
-- TRIGGER: trigger_notify_report_submitted
-- ============================================================
CREATE OR REPLACE FUNCTION notify_report_submitted()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_entity_label text;
BEGIN
  v_entity_label := CASE NEW.reported_entity_type
    WHEN 'classified_ad' THEN 'annuncio'
    WHEN 'review' THEN 'recensione'
    WHEN 'business' THEN 'attività'
    WHEN 'auction' THEN 'asta'
    WHEN 'job_posting' THEN 'offerta di lavoro'
    ELSE 'contenuto'
  END;

  -- Notify the reporter that their report was received
  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    NEW.reporter_id,
    NEW.family_member_id,
    'report_submitted',
    'Segnalazione inviata',
    'La tua segnalazione per questo ' || v_entity_label || ' è stata ricevuta e verrà esaminata dal nostro staff.',
    jsonb_build_object(
      'entity_type', NEW.reported_entity_type,
      'entity_id', NEW.reported_entity_id,
      'report_id', NEW.id
    )
  );

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_notify_report_submitted ON reports;
CREATE TRIGGER trigger_notify_report_submitted
  AFTER INSERT ON reports
  FOR EACH ROW
  EXECUTE FUNCTION notify_report_submitted();


-- ============================================================
-- TRIGGER: trigger_prevent_trial_abuse
-- ============================================================
CREATE OR REPLACE FUNCTION prevent_trial_abuse()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_profile_fiscal_code text;
  v_family_fiscal_codes text[];
  v_existing_count int;
BEGIN
  -- Solo per nuove sottoscrizioni trial
  IF NEW.status = 'trial' AND (OLD IS NULL OR OLD.status != 'trial') THEN
    
    -- Ottieni il CF del profilo
    SELECT fiscal_code INTO v_profile_fiscal_code
    FROM profiles
    WHERE id = NEW.customer_id;

    -- Verifica se questo CF ha già avuto un trial
    IF v_profile_fiscal_code IS NOT NULL AND v_profile_fiscal_code != '' THEN
      SELECT COUNT(*) INTO v_existing_count
      FROM trial_usage_history
      WHERE fiscal_code = v_profile_fiscal_code;

      IF v_existing_count > 0 THEN
        RAISE EXCEPTION 'Questo codice fiscale è già stato utilizzato per un periodo di prova';
      END IF;
    END IF;

    -- Controlla anche i CF della famiglia
    SELECT array_agg(fiscal_code)
    INTO v_family_fiscal_codes
    FROM customer_family_members
    WHERE customer_id = NEW.customer_id
      AND fiscal_code IS NOT NULL;

    IF v_family_fiscal_codes IS NOT NULL THEN
      UPDATE trial_usage_history
      SET subsequent_attempts = array_append(subsequent_attempts, NEW.customer_id)
      WHERE fiscal_code = ANY(v_family_fiscal_codes);

      SELECT COUNT(*) INTO v_existing_count
      FROM trial_usage_history
      WHERE fiscal_code = ANY(v_family_fiscal_codes);

      IF v_existing_count > 0 THEN
        RAISE EXCEPTION 'Uno o più codici fiscali dei membri della famiglia sono già stati utilizzati per un periodo di prova';
      END IF;
    END IF;

    -- Registra l'uso del trial
    PERFORM register_trial_usage(NEW.customer_id);
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_prevent_trial_abuse ON subscriptions;
CREATE TRIGGER trigger_prevent_trial_abuse
  BEFORE INSERT ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION prevent_trial_abuse();


-- ============================================================
-- TRIGGER: trigger_process_referral
-- ============================================================
CREATE OR REPLACE FUNCTION process_referral_on_subscription()
RETURNS TRIGGER AS $$
BEGIN
  -- Non fare nulla automaticamente
  -- I punti verranno assegnati dal frontend dopo conferma pagamento
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_process_referral ON subscriptions;
CREATE TRIGGER trigger_process_referral
  AFTER INSERT ON subscriptions
  FOR EACH ROW
  WHEN (NEW.status = 'active')
  EXECUTE FUNCTION process_referral_on_subscription();


-- ============================================================
-- TRIGGER: trigger_set_auction_deposit_amount
-- ============================================================
CREATE OR REPLACE FUNCTION set_auction_deposit_amount()
RETURNS TRIGGER AS $$
BEGIN
  -- Il ticket è il 10% della base d'asta, arrotondato a 2 decimali
  NEW.deposit_amount := ROUND(NEW.base_price * 0.10, 2);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_auction_deposit_amount ON auctions;
CREATE TRIGGER trigger_set_auction_deposit_amount
  BEFORE INSERT OR UPDATE OF base_price ON auctions
  FOR EACH ROW
  EXECUTE FUNCTION set_auction_deposit_amount();


-- ============================================================
-- TRIGGER: trigger_set_business_claimed_at
-- ============================================================
CREATE OR REPLACE FUNCTION set_business_claimed_at()
RETURNS TRIGGER AS $$
BEGIN
  -- Imposta claimed_at solo se is_claimed = true E owner_id non è NULL
  IF NEW.is_claimed = true AND NEW.owner_id IS NOT NULL AND NEW.claimed_at IS NULL THEN
    NEW.claimed_at := now();
  END IF;
  
  -- Rimuovi claimed_at se is_claimed = false o owner_id è NULL
  IF NEW.is_claimed = false OR NEW.owner_id IS NULL THEN
    NEW.claimed_at := NULL;
    NEW.verification_badge := NULL;
  END IF;
  
  -- Imposta verification_badge solo se is_claimed = true E owner_id non è NULL
  IF NEW.is_claimed = true AND NEW.owner_id IS NOT NULL AND NEW.verification_badge IS NULL THEN
    NEW.verification_badge := CASE 
      WHEN NEW.verified = true THEN 'verified'
      ELSE 'claimed'
    END;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_business_claimed_at ON businesses;
CREATE TRIGGER trigger_set_business_claimed_at
  BEFORE INSERT OR UPDATE ON businesses
  FOR EACH ROW
  EXECUTE FUNCTION set_business_claimed_at();


-- ============================================================
-- TRIGGER: trigger_subtract_points_deleted_classified_ad
-- ============================================================
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

DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_classified_ad ON classified_ads;
CREATE TRIGGER trigger_subtract_points_deleted_classified_ad
  BEFORE DELETE ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_classified_ad();


-- ============================================================
-- TRIGGER: trigger_subtract_points_deleted_job_posting
-- ============================================================
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'ID del proprietario dalla business location
  SELECT owner_id INTO v_owner_id
  FROM business_locations
  WHERE id = OLD.business_location_id;

  -- Sottrai 3 punti al proprietario dell'attività
  IF v_owner_id IS NOT NULL THEN
    PERFORM award_points(v_owner_id, -3, 'job_posting_deleted', OLD.id::text);
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_job_posting ON job_postings;
CREATE TRIGGER trigger_subtract_points_deleted_job_posting
  BEFORE DELETE ON job_postings
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_job_posting();


-- ============================================================
-- TRIGGER: trigger_subtract_points_deleted_product
-- ============================================================
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

DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_product ON products;
CREATE TRIGGER trigger_subtract_points_deleted_product
  BEFORE DELETE ON products
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_product();


-- ============================================================
-- TRIGGER: trigger_subtract_points_deleted_review
-- ============================================================
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

DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_review ON reviews;
CREATE TRIGGER trigger_subtract_points_deleted_review
  BEFORE DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_review();


-- ============================================================
-- TRIGGER: trigger_subtract_points_deleted_unclaimed_business
-- ============================================================
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_unclaimed_business()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  points_to_subtract INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  is_complete := (
    (OLD.email IS NOT NULL AND OLD.email != '') OR 
    (OLD.phone IS NOT NULL AND OLD.phone != '') OR 
    (OLD.website IS NOT NULL AND OLD.website != '')
  );

  IF is_complete THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  v_family_member_id := OLD.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points = GREATEST(0, total_points - points_to_subtract),
      businesses_added_count = GREATEST(0, businesses_added_count - 1),
      updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id = v_family_member_id;
  ELSE
    UPDATE user_activity
    SET
      total_points = GREATEST(0, total_points - points_to_subtract),
      businesses_added_count = GREATEST(0, businesses_added_count - 1),
      updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_unclaimed_business ON unclaimed_business_locations;
CREATE TRIGGER trigger_subtract_points_deleted_unclaimed_business
  BEFORE DELETE ON unclaimed_business_locations
  FOR EACH ROW
  EXECUTE FUNCTION subtract_points_for_deleted_unclaimed_business();


-- ============================================================
-- TRIGGER: trigger_subtract_points_user_added_business
-- ============================================================
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_user_added_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_subtract INTEGER;
  is_complete BOOLEAN;
BEGIN
  is_complete := (
    (OLD.email IS NOT NULL AND OLD.email != '') OR 
    (OLD.phone IS NOT NULL AND OLD.phone != '') OR 
    (OLD.website IS NOT NULL AND OLD.website != '')
  );

  IF is_complete THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  UPDATE user_activity
  SET 
    total_points = GREATEST(0, total_points - points_to_subtract),
    updated_at = now()
  WHERE user_id = OLD.added_by;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_subtract_points_user_added_business ON user_added_businesses;
CREATE TRIGGER trigger_subtract_points_user_added_business
  BEFORE DELETE ON user_added_businesses
  FOR EACH ROW
  WHEN (OLD.added_by IS NOT NULL)
  EXECUTE FUNCTION subtract_points_for_deleted_user_added_business();


-- ============================================================
-- TRIGGER: trigger_update_auction_current_price
-- ============================================================
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

DROP TRIGGER IF EXISTS trigger_update_auction_current_price ON auction_bids;
CREATE TRIGGER trigger_update_auction_current_price
  AFTER INSERT ON auction_bids
  FOR EACH ROW
  EXECUTE FUNCTION update_auction_current_price();


-- ============================================================
-- TRIGGER: trigger_update_profile_subscription_status
-- ============================================================
CREATE OR REPLACE FUNCTION update_profile_subscription_status()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  subscription_type_value text;
  plan_billing_period text;
BEGIN
  -- Get the billing period from the subscription plan
  SELECT billing_period INTO plan_billing_period
  FROM subscription_plans
  WHERE id = NEW.plan_id;
  
  -- Map billing_period to subscription_type
  subscription_type_value := CASE 
    WHEN plan_billing_period = 'monthly' THEN 'monthly'
    WHEN plan_billing_period = 'yearly' THEN 'annual'
    ELSE 'monthly'
  END;
  
  -- Update the profile with subscription info
  UPDATE profiles
  SET 
    subscription_status = NEW.status,
    subscription_type = subscription_type_value,
    subscription_expires_at = NEW.end_date
  WHERE id = NEW.customer_id;
  
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_update_profile_subscription_status ON subscriptions;
CREATE TRIGGER trigger_update_profile_subscription_status
  AFTER INSERT OR UPDATE OF status ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_profile_subscription_status();


-- ============================================================
-- TRIGGER: trigger_update_user_activity_on_review
-- ============================================================
CREATE OR REPLACE FUNCTION update_user_activity()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  VALUES (
    NEW.customer_id,
    15,
    1,
    now(),
    now()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    total_points = user_activity.total_points + 15,
    reviews_count = user_activity.reviews_count + 1,
    last_activity_at = now(),
    updated_at = now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_update_user_activity_on_review ON reviews;
CREATE TRIGGER trigger_update_user_activity_on_review
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_user_activity();

