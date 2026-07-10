
/*
  # Fix user_type e abbonamenti utenti business

  ## Problema
  I 3 utenti proprietari di attività registrate (Anna Moretti, Giuseppe Napoli, Roberto Ferrari)
  avevano user_type = 'customer' invece di 'business'. Questo causava:
  - Comparsa nella classifica (sia admin che piattaforma)
  - Ricezione di notifiche punti/classifica
  - Abbonamento con status = 'active' invece di 'trial'
  - Non distinguibili dagli utenti privati nella sezione Utenti admin

  ## Modifiche
  1. user_type = 'business' per i 3 proprietari di attività registrate
  2. subscription status = 'trial' per i 3 utenti business
  3. Rimozione punti da user_activity per utenti business (non partecipano alla classifica)
  4. Rimozione notifiche points_earned per utenti business
*/

-- 1. Aggiorna user_type per i proprietari di attività registrate
UPDATE profiles
SET user_type = 'business'
WHERE id IN (
  SELECT DISTINCT owner_id FROM registered_businesses
)
AND user_type = 'customer';

-- 2. Aggiorna subscriptions: status = 'trial' per utenti business
--    e imposta trial_end_date a 30 giorni dalla data di creazione
UPDATE subscriptions s
SET 
  status = 'trial',
  trial_end_date = CASE 
    WHEN s.trial_end_date IS NULL THEN (s.start_date + interval '30 days')
    ELSE s.trial_end_date
  END
WHERE s.customer_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND s.status = 'active';

-- 3. Azzera i punti in user_activity per gli utenti business
--    (non partecipano alla classifica punti)
UPDATE user_activity
SET 
  total_points = 0,
  reviews_count = 0,
  ads_count = 0,
  ads_posted_count = 0,
  job_postings_count = 0,
  referrals_count = 0,
  businesses_added_count = 0,
  auctions_count = 0,
  updated_at = now()
WHERE user_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND family_member_id IS NULL;

-- 4. Elimina notifiche di tipo points_earned per utenti business
DELETE FROM notifications
WHERE user_id IN (
  SELECT id FROM profiles WHERE user_type = 'business'
)
AND type = 'points_earned';
