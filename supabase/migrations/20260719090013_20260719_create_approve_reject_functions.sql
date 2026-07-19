
/*
# Aggiungi colonne mancanti e crea funzioni approve/reject

## Problema
Le funzioni approve/reject dell'admin non esistono nel database.
Mancano anche colonne necessarie nelle tabelle auctions, job_seekers, user_activity.

## Modifiche alle tabelle
- auctions: + approved_at, approved_by, approval_notes, duration_days
- job_seekers: + approved_by, approved_at, approval_notes
- user_activity: + auctions_count, family_member_id

## Funzioni create
approve_review, reject_review, approve_classified_ad, reject_classified_ad,
approve_auction, reject_auction, approve_job_posting, reject_job_posting,
approve_job_seeker, reject_job_seeker
*/

-- ============================================================
-- COLONNE MANCANTI
-- ============================================================
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='auctions' AND column_name='approved_at') THEN
    ALTER TABLE public.auctions ADD COLUMN approved_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='auctions' AND column_name='approved_by') THEN
    ALTER TABLE public.auctions ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='auctions' AND column_name='approval_notes') THEN
    ALTER TABLE public.auctions ADD COLUMN approval_notes text;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='auctions' AND column_name='duration_days') THEN
    ALTER TABLE public.auctions ADD COLUMN duration_days integer DEFAULT 7;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_seekers' AND column_name='approved_by') THEN
    ALTER TABLE public.job_seekers ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_seekers' AND column_name='approved_at') THEN
    ALTER TABLE public.job_seekers ADD COLUMN approved_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_seekers' AND column_name='approval_notes') THEN
    ALTER TABLE public.job_seekers ADD COLUMN approval_notes text;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='user_activity' AND column_name='auctions_count') THEN
    ALTER TABLE public.user_activity ADD COLUMN auctions_count integer DEFAULT 0;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='user_activity' AND column_name='family_member_id') THEN
    ALTER TABLE public.user_activity ADD COLUMN family_member_id uuid REFERENCES public.customer_family_members(id) ON DELETE SET NULL;
  END IF;
END $$;

-- ============================================================
-- approve_review
-- ============================================================
CREATE OR REPLACE FUNCTION public.approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  r RECORD;
  pts integer;
  has_proof boolean;
  v_biz_owner uuid;
  v_biz_name text;
  v_reviewer_name text;
BEGIN
  SELECT * INTO r FROM reviews WHERE id = review_id_param;
  IF NOT FOUND THEN RAISE EXCEPTION 'Recensione non trovata'; END IF;
  IF r.review_status != 'pending' THEN RAISE EXCEPTION 'Recensione già processata'; END IF;

  has_proof := (r.proof_image_url IS NOT NULL AND r.proof_image_url != '')
               OR (r.proof_documents IS NOT NULL AND array_length(r.proof_documents,1) > 0);
  pts := CASE WHEN has_proof THEN 50 ELSE 25 END;

  UPDATE reviews SET review_status='approved', approved_by=staff_id_param, approved_at=now(), points_awarded=pts WHERE id=review_id_param;

  PERFORM award_points(r.customer_id, pts, 'review', 'Recensione approvata', r.family_member_id);

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (r.customer_id, r.family_member_id, 'review_approved', 'Recensione Approvata',
    'La tua recensione è stata approvata. Hai guadagnato '||pts||' punti!',
    pts, jsonb_build_object('review_id',review_id_param,'points_awarded',pts,'had_proof',has_proof), 'check-circle','green');

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (r.customer_id, r.family_member_id, 'review_approved', 'Recensione Approvata',
    'La tua recensione è stata approvata. Hai guadagnato '||pts||' punti!',
    jsonb_build_object('review_id',review_id_param,'points_awarded',pts));

  SELECT COALESCE(p.nickname, p.full_name, 'Un utente') INTO v_reviewer_name FROM profiles p WHERE p.id=r.customer_id;

  IF r.business_location_id IS NOT NULL THEN
    SELECT b.owner_id, b.name INTO v_biz_owner, v_biz_name
    FROM business_locations bl JOIN businesses b ON b.id=bl.business_id WHERE bl.id=r.business_location_id;
  END IF;
  IF v_biz_owner IS NULL AND r.business_id IS NOT NULL THEN
    SELECT b.owner_id, b.name INTO v_biz_owner, v_biz_name FROM businesses b WHERE b.id=r.business_id;
  END IF;
  IF v_biz_owner IS NOT NULL AND v_biz_owner != r.customer_id THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (v_biz_owner, 'review_received', 'Nuova Recensione',
      v_reviewer_name||' ha lasciato una recensione per '||COALESCE(v_biz_name,'la tua attività')||'.',
      jsonb_build_object('review_id',review_id_param,'business_location_id',r.business_location_id));
  END IF;
END;
$$;

-- ============================================================
-- reject_review
-- ============================================================
CREATE OR REPLACE FUNCTION public.reject_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE r RECORD; BEGIN
  SELECT * INTO r FROM reviews WHERE id=review_id_param;
  IF NOT FOUND THEN RAISE EXCEPTION 'Recensione non trovata'; END IF;
  IF r.review_status != 'pending' THEN RAISE EXCEPTION 'Recensione già processata'; END IF;

  UPDATE reviews SET review_status='rejected', approved_by=staff_id_param, approved_at=now(),
    points_awarded=0, proof_image_url=NULL WHERE id=review_id_param;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (r.customer_id, r.family_member_id, 'review_rejected', 'Recensione Rifiutata',
    'La tua recensione non è stata approvata.',
    0, jsonb_build_object('review_id',review_id_param,'had_proof',r.proof_image_url IS NOT NULL), 'x-circle','red');

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (r.customer_id, r.family_member_id, 'review_rejected', 'Recensione Rifiutata',
    'La tua recensione non è stata approvata. Verifica le linee guida e riprova.',
    jsonb_build_object('review_id',review_id_param));
END;
$$;

-- ============================================================
-- approve_classified_ad
-- ============================================================
CREATE OR REPLACE FUNCTION public.approve_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  ad RECORD;
  pts integer := 5;
  v_user_type text;
  v_exists boolean;
BEGIN
  SELECT * INTO ad FROM classified_ads WHERE id=ad_id_param;
  IF NOT FOUND THEN RAISE EXCEPTION 'Annuncio non trovato'; END IF;
  IF ad.approval_status != 'pending' THEN RAISE EXCEPTION 'Annuncio già processato'; END IF;

  SELECT user_type INTO v_user_type FROM profiles WHERE id=ad.user_id;
  UPDATE classified_ads SET approval_status='approved', status='active', approved_by=staff_id_param,
    approved_at=now(), points_awarded=CASE WHEN v_user_type='business' THEN 0 ELSE pts END WHERE id=ad_id_param;

  IF v_user_type != 'business' THEN
    PERFORM award_points(ad.user_id, pts, 'classified_ad', 'Annuncio approvato', ad.family_member_id);
    SELECT EXISTS(SELECT 1 FROM user_activity WHERE user_id=ad.user_id AND
      (family_member_id=ad.family_member_id OR (family_member_id IS NULL AND ad.family_member_id IS NULL))
    ) INTO v_exists;
    IF v_exists THEN
      UPDATE user_activity SET ads_posted_count=ads_posted_count+1, last_activity_at=now(), updated_at=now()
      WHERE user_id=ad.user_id AND (family_member_id=ad.family_member_id OR (family_member_id IS NULL AND ad.family_member_id IS NULL));
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at)
      VALUES (ad.user_id, ad.family_member_id, 1, now());
    END IF;
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (ad.user_id, ad.family_member_id, 'classified_ad_approved', 'Annuncio Approvato',
    'Il tuo annuncio "'||ad.title||'" è stato approvato',
    CASE WHEN v_user_type='business' THEN 0 ELSE pts END,
    jsonb_build_object('ad_id',ad_id_param,'ad_title',ad.title,'approved_by',staff_id_param), 'check-circle','green');

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (ad.user_id, ad.family_member_id, 'classified_ad_approved', 'Annuncio Approvato',
    CASE WHEN v_user_type='business'
      THEN 'Il tuo annuncio "'||ad.title||'" è stato approvato e pubblicato.'
      ELSE 'Il tuo annuncio "'||ad.title||'" è stato approvato. Hai guadagnato '||pts||' punti!'
    END,
    jsonb_build_object('ad_id',ad_id_param,'ad_title',ad.title,'points_awarded',CASE WHEN v_user_type='business' THEN 0 ELSE pts END));
END;
$$;

-- ============================================================
-- reject_classified_ad
-- ============================================================
CREATE OR REPLACE FUNCTION public.reject_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE ad RECORD; BEGIN
  SELECT * INTO ad FROM classified_ads WHERE id=ad_id_param;
  IF NOT FOUND THEN RAISE EXCEPTION 'Annuncio non trovato'; END IF;
  IF ad.approval_status != 'pending' THEN RAISE EXCEPTION 'Annuncio già processato'; END IF;

  UPDATE classified_ads SET approval_status='rejected', approved_by=staff_id_param,
    approved_at=now(), points_awarded=0 WHERE id=ad_id_param;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (ad.user_id, ad.family_member_id, 'classified_ad_rejected', 'Annuncio Rifiutato',
    'Il tuo annuncio "'||ad.title||'" non è stato approvato.',
    0, jsonb_build_object('ad_id',ad_id_param,'ad_title',ad.title), 'x-circle','red');

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (ad.user_id, ad.family_member_id, 'classified_ad_rejected', 'Annuncio Rifiutato',
    'Il tuo annuncio "'||ad.title||'" non è stato approvato. Verifica le linee guida e riprova.',
    jsonb_build_object('ad_id',ad_id_param,'ad_title',ad.title));
END;
$$;

-- ============================================================
-- approve_auction
-- ============================================================
CREATE OR REPLACE FUNCTION public.approve_auction(
  p_auction_id uuid,
  p_admin_id uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  v RECORD;
  v_existing uuid;
BEGIN
  SELECT * INTO v FROM auctions WHERE id=p_auction_id;
  IF v.user_id IS NULL THEN RAISE EXCEPTION 'Asta non trovata'; END IF;

  UPDATE auctions SET approval_status='approved', status='active',
    approved_at=now(), approved_by=p_admin_id,
    ends_at=now() + (COALESCE(v.duration_days,7)||' days')::interval
  WHERE id=p_auction_id;

  IF v.family_member_id IS NULL THEN
    SELECT id INTO v_existing FROM user_activity WHERE user_id=v.user_id AND family_member_id IS NULL;
  ELSE
    SELECT id INTO v_existing FROM user_activity WHERE user_id=v.user_id AND family_member_id=v.family_member_id;
  END IF;
  IF v_existing IS NOT NULL THEN
    UPDATE user_activity SET total_points=total_points+15, auctions_count=COALESCE(auctions_count,0)+1, updated_at=now() WHERE id=v_existing;
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, total_points, auctions_count) VALUES (v.user_id, v.family_member_id, 15, 1);
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (v.user_id, v.family_member_id, 'auction_approved', 'Asta Approvata',
    'La tua asta "'||v.title||'" è stata approvata. Hai guadagnato 15 punti!',
    15, jsonb_build_object('auction_id',p_auction_id), 'check-circle','green');

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v.user_id, v.family_member_id, 'auction_approved', 'Asta Approvata',
    'La tua asta è stata approvata ed è ora visibile a tutti. Hai guadagnato 15 punti!',
    jsonb_build_object('auction_id',p_auction_id,'points_awarded',15));

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v.user_id, v.family_member_id, 'points_earned', 'Punti Guadagnati',
    'Hai guadagnato 15 punti per la pubblicazione della tua asta!',
    jsonb_build_object('points_awarded',15,'reason','auction_approved','auction_id',p_auction_id));
END;
$$;

-- ============================================================
-- reject_auction
-- ============================================================
CREATE OR REPLACE FUNCTION public.reject_auction(
  p_auction_id uuid,
  p_admin_id uuid,
  p_reason text DEFAULT ''
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE v RECORD; BEGIN
  SELECT * INTO v FROM auctions WHERE id=p_auction_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asta non trovata'; END IF;
  IF v.approval_status != 'pending' THEN RAISE EXCEPTION 'Asta già processata'; END IF;

  UPDATE auctions SET approval_status='rejected', approved_by=p_admin_id, approved_at=now(), approval_notes=p_reason WHERE id=p_auction_id;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (v.user_id, v.family_member_id, 'auction_rejected', 'Asta Non Approvata',
    CASE WHEN p_reason IS NOT NULL AND p_reason!=''
      THEN 'La tua asta "'||v.title||'" non è stata approvata. Motivo: '||p_reason
      ELSE 'La tua asta "'||v.title||'" non è stata approvata.'
    END,
    jsonb_build_object('auction_id',p_auction_id));
END;
$$;

-- ============================================================
-- approve_job_posting
-- ============================================================
CREATE OR REPLACE FUNCTION public.approve_job_posting(
  p_job_id uuid,
  p_admin_id uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  v_job RECORD;
  v_owner_id uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id=jp.registered_business_id
  WHERE jp.id=p_job_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Offerta di lavoro non trovata'; END IF;

  v_owner_id := COALESCE(v_job.rb_owner_id, v_job.user_id);

  UPDATE job_postings SET approval_status='approved', status='active', approved_at=now(), approved_by=p_admin_id WHERE id=p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (v_owner_id, 'job_posting_approved', 'Offerta di Lavoro Approvata',
      'La tua offerta di lavoro "'||COALESCE(v_job.title,'')||'" è stata approvata ed è ora visibile.',
      jsonb_build_object('job_id',p_job_id));
  END IF;
END;
$$;

-- ============================================================
-- reject_job_posting
-- ============================================================
CREATE OR REPLACE FUNCTION public.reject_job_posting(
  p_job_id uuid,
  p_admin_id uuid,
  p_reason text DEFAULT ''
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  v_job RECORD;
  v_owner_id uuid;
BEGIN
  SELECT jp.*, rb.owner_id AS rb_owner_id INTO v_job
  FROM job_postings jp
  LEFT JOIN registered_businesses rb ON rb.id=jp.registered_business_id
  WHERE jp.id=p_job_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Offerta non trovata'; END IF;

  v_owner_id := COALESCE(v_job.rb_owner_id, v_job.user_id);

  UPDATE job_postings SET approval_status='rejected', approved_at=now(), approved_by=p_admin_id, approval_notes=p_reason WHERE id=p_job_id;

  IF v_owner_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (v_owner_id, 'job_posting_rejected', 'Offerta Non Approvata',
      CASE WHEN p_reason IS NOT NULL AND p_reason!=''
        THEN 'La tua offerta di lavoro non è stata approvata. Motivo: '||p_reason
        ELSE 'La tua offerta di lavoro non è stata approvata.'
      END,
      jsonb_build_object('job_id',p_job_id));
  END IF;
END;
$$;

-- ============================================================
-- approve_job_seeker
-- ============================================================
CREATE OR REPLACE FUNCTION public.approve_job_seeker(
  p_seeker_id uuid,
  p_admin_id uuid
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE v_user_id uuid; BEGIN
  SELECT user_id INTO v_user_id FROM job_seekers WHERE id=p_seeker_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Annuncio non trovato'; END IF;

  UPDATE job_seekers SET approval_status='approved', approved_by=p_admin_id, approved_at=now(), status='active' WHERE id=p_seeker_id;

  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (v_user_id, 'job_seeker_approved', 'Annuncio Approvato',
      'Il tuo annuncio "Cerco Lavoro" è stato approvato ed è ora visibile.',
      jsonb_build_object('seeker_id',p_seeker_id));
  END IF;
END;
$$;

-- ============================================================
-- reject_job_seeker
-- ============================================================
CREATE OR REPLACE FUNCTION public.reject_job_seeker(
  p_seeker_id uuid,
  p_admin_id uuid,
  p_reason text DEFAULT ''
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE v_user_id uuid; BEGIN
  SELECT user_id INTO v_user_id FROM job_seekers WHERE id=p_seeker_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Annuncio non trovato'; END IF;

  UPDATE job_seekers SET approval_status='rejected', approved_by=p_admin_id, approved_at=now(), approval_notes=p_reason, status='closed' WHERE id=p_seeker_id;

  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (v_user_id, 'job_seeker_rejected', 'Annuncio Non Approvato',
      CASE WHEN p_reason IS NOT NULL AND p_reason!=''
        THEN 'Il tuo annuncio "Cerco Lavoro" non è stato approvato. Motivo: '||p_reason
        ELSE 'Il tuo annuncio "Cerco Lavoro" non è stato approvato.'
      END,
      jsonb_build_object('seeker_id',p_seeker_id));
  END IF;
END;
$$;
