
/*
# Crea funzioni RPC mancanti: mark_notification_read, increment_ad_views, get_trial_status, confirm_auction_deal

## Problemi
Queste funzioni sono chiamate dal frontend ma non esistevano nel database,
causando errori silenziosi in notifiche, visualizzazioni annunci, banner trial e conferma aste.

## Funzioni create
1. mark_notification_read(notification_id) — imposta read=true su una notifica dell'utente corrente
2. increment_ad_views(ad_uuid) — incrementa views_count su classified_ads
3. get_trial_status(user_id_param) — restituisce is_trial, days_remaining, trial_end_date, is_expired
4. confirm_auction_deal(p_auction_id, p_user_id, p_is_seller) — conferma deal asta bilaterale
*/

-- ============================================================
-- mark_notification_read
-- ============================================================
CREATE OR REPLACE FUNCTION public.mark_notification_read(notification_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  UPDATE notifications SET read = true
  WHERE id = notification_id AND user_id = auth.uid();
END;
$$;

-- ============================================================
-- increment_ad_views
-- ============================================================
CREATE OR REPLACE FUNCTION public.increment_ad_views(ad_uuid uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  UPDATE classified_ads SET views_count = COALESCE(views_count, 0) + 1 WHERE id = ad_uuid;
END;
$$;

-- ============================================================
-- get_trial_status
-- Returns is_trial, days_remaining, trial_end_date, is_expired
-- ============================================================
CREATE OR REPLACE FUNCTION public.get_trial_status(user_id_param uuid)
RETURNS TABLE(
  is_trial boolean,
  days_remaining integer,
  trial_end_date timestamptz,
  is_expired boolean
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  v_sub RECORD;
BEGIN
  SELECT s.status, s.end_date INTO v_sub
  FROM subscriptions s
  WHERE s.customer_id = user_id_param AND s.status = 'trial'
  ORDER BY s.created_at DESC LIMIT 1;

  IF v_sub IS NULL THEN
    RETURN QUERY SELECT false, 0, NULL::timestamptz, false;
    RETURN;
  END IF;

  RETURN QUERY SELECT
    true AS is_trial,
    GREATEST(0, EXTRACT(DAY FROM (v_sub.end_date - now()))::integer) AS days_remaining,
    v_sub.end_date AS trial_end_date,
    (v_sub.end_date < now()) AS is_expired;
END;
$$;

-- ============================================================
-- confirm_auction_deal
-- Gestisce conferma bilaterale: venditore e acquirente confermano l'affare
-- ============================================================
CREATE OR REPLACE FUNCTION public.confirm_auction_deal(
  p_auction_id uuid,
  p_user_id uuid,
  p_is_seller boolean
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  v_auction RECORD;
  v_completion RECORD;
  v_now timestamptz := now();
BEGIN
  SELECT * INTO v_auction FROM auctions WHERE id = p_auction_id;
  IF NOT FOUND THEN
    RETURN jsonb_build_object('error', 'Asta non trovata');
  END IF;

  -- Verifica che l'utente sia il venditore o l'acquirente
  IF p_is_seller AND v_auction.user_id != p_user_id THEN
    RETURN jsonb_build_object('error', 'Non sei il venditore di questa asta');
  END IF;
  IF NOT p_is_seller AND v_auction.winner_id != p_user_id THEN
    RETURN jsonb_build_object('error', 'Non sei l''acquirente di questa asta');
  END IF;

  -- Crea o aggiorna il record di completion
  SELECT * INTO v_completion FROM auction_completions WHERE auction_id = p_auction_id;

  IF v_completion IS NULL THEN
    INSERT INTO auction_completions (auction_id, seller_confirmed, seller_confirmed_at, buyer_confirmed, buyer_confirmed_at, completion_deadline)
    VALUES (
      p_auction_id,
      p_is_seller, CASE WHEN p_is_seller THEN v_now ELSE NULL END,
      NOT p_is_seller, CASE WHEN NOT p_is_seller THEN v_now ELSE NULL END,
      v_now + interval '7 days'
    )
    RETURNING * INTO v_completion;
  ELSE
    IF p_is_seller THEN
      UPDATE auction_completions SET seller_confirmed = true, seller_confirmed_at = v_now WHERE auction_id = p_auction_id;
    ELSE
      UPDATE auction_completions SET buyer_confirmed = true, buyer_confirmed_at = v_now WHERE auction_id = p_auction_id;
    END IF;
    SELECT * INTO v_completion FROM auction_completions WHERE auction_id = p_auction_id;
  END IF;

  -- Se entrambi confermati, chiudi l'asta
  IF v_completion.seller_confirmed AND v_completion.buyer_confirmed THEN
    UPDATE auctions SET status = 'completed', completed_at = v_now WHERE id = p_auction_id;

    -- Notifica entrambi
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES
      (v_auction.user_id, 'auction_concluded', 'Affare Concluso',
       'L''affare per l''asta "'||v_auction.title||'" è stato confermato da entrambe le parti!',
       jsonb_build_object('auction_id', p_auction_id)),
      (v_auction.winner_id, 'auction_won', 'Affare Concluso',
       'L''affare per l''asta "'||v_auction.title||'" è stato confermato! Congratulazioni.',
       jsonb_build_object('auction_id', p_auction_id));

    RETURN jsonb_build_object('status', 'fully_confirmed');
  END IF;

  RETURN jsonb_build_object('status', 'awaiting_other_party');
END;
$$;
