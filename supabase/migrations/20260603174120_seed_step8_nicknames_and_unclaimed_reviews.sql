/*
  # Seed Step 8: Aggiunta nickname a tutti gli utenti e recensioni attività non reclamate

  - Aggiunge nickname univoci a tutti i profili test
  - Aggiunge recensioni di Mario e Laura sulle attività da loro aggiunte (Bar Lo Stivale, Farmacia)
  - Aggiunge recensione di Roberto (business) su un'attività non reclamata
*/

-- =============================================
-- NICKNAME per tutti gli utenti test
-- =============================================
UPDATE profiles SET nickname = 'mario_rossi_86' WHERE id = 'a1000001-0000-0000-0000-000000000001';
UPDATE profiles SET nickname = 'laura_b_roma' WHERE id = 'a1000002-0000-0000-0000-000000000002';
UPDATE profiles SET nickname = 'pizzeria_napoli' WHERE id = 'b2000001-0000-0000-0000-000000000001';
UPDATE profiles SET nickname = 'officina_ferrari' WHERE id = 'b2000002-0000-0000-0000-000000000002';
UPDATE profiles SET nickname = 'hotel_bellavista' WHERE id = 'b2000003-0000-0000-0000-000000000003';

-- Nickname per Sofia (membro famiglia)
UPDATE customer_family_members 
SET nickname = 'sofia_b' 
WHERE id = 'c3000001-0000-0000-0000-000000000001';

-- =============================================
-- RECENSIONI su attività non reclamate
-- (Bar Lo Stivale aggiunto da Mario, Farmacia aggiunta da Laura)
-- =============================================

ALTER TABLE reviews DISABLE TRIGGER calculate_overall_rating_trigger;
ALTER TABLE reviews DISABLE TRIGGER notify_business_on_review;
ALTER TABLE reviews DISABLE TRIGGER trigger_log_review_submission;
ALTER TABLE reviews DISABLE TRIGGER trigger_notify_admins_new_review;
ALTER TABLE reviews DISABLE TRIGGER trigger_subtract_points_deleted_review;

-- Laura recensisce Bar Lo Stivale (aggiunto da Mario) - senza prova
INSERT INTO reviews (
  id, customer_id,
  unclaimed_business_location_id,
  rating, overall_rating, title, content,
  price_rating, service_rating, quality_rating,
  review_status, points_awarded, created_at
) VALUES (
  'd4d4d4d4-e5e5-f6f6-a7a7-b8b8b8b80001',
  'a1000002-0000-0000-0000-000000000002',
  'c4d5e6f7-a8b9-0123-4567-890abcdef001',
  4, 4,
  'Bar carino, caffè ottimo',
  'Ho provato il Bar Lo Stivale per caso passando da Milano. Il caffè è eccellente, preparato a regola d arte. Ambiente pulito e personale cordiale. Prezzi in linea con la zona.',
  4, 4, 4,
  'approved', 25,
  NOW() - INTERVAL '7 days'
);

-- Mario recensisce Farmacia Centrale Roma (aggiunta da Laura) - con prova
INSERT INTO reviews (
  id, customer_id,
  unclaimed_business_location_id,
  rating, overall_rating, title, content,
  price_rating, service_rating, quality_rating,
  proof_image_url,
  review_status, points_awarded, created_at
) VALUES (
  'd4d4d4d4-e5e5-f6f6-a7a7-b8b8b8b80002',
  'a1000001-0000-0000-0000-000000000001',
  'c4d5e6f7-a8b9-0123-4567-890abcdef002',
  5, 5,
  'Farmacia ben fornita, personale preparatissimo',
  'Farmacia Centrale Roma è una delle migliori che abbia frequentato. Il farmacista è molto competente e ha risposto a tutte le mie domande in modo chiaro. Ampia scelta di prodotti, anche parafarmaceutici. Consigliata.',
  4, 5, 5,
  'https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg',
  'approved', 50,
  NOW() - INTERVAL '3 days'
);

-- Sofia recensisce Bar Lo Stivale (con prova, via account Laura)
INSERT INTO reviews (
  id, customer_id, family_member_id,
  unclaimed_business_location_id,
  rating, overall_rating, title, content,
  price_rating, service_rating, quality_rating,
  proof_image_url,
  review_status, points_awarded, created_at
) VALUES (
  'd4d4d4d4-e5e5-f6f6-a7a7-b8b8b8b80003',
  'a1000002-0000-0000-0000-000000000002',
  'c3000001-0000-0000-0000-000000000001',
  'c4d5e6f7-a8b9-0123-4567-890abcdef001',
  3, 3,
  'Carino ma un po caotico',
  'Bar piacevole ma nelle ore di punta diventa molto affollato e il servizio rallenta notevolmente. Prodotti da forno buoni, prezzi nella media. Da migliorare la gestione della fila.',
  3, 2, 4,
  'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg',
  'approved', 50,
  NOW() - INTERVAL '2 days'
);

ALTER TABLE reviews ENABLE TRIGGER calculate_overall_rating_trigger;
ALTER TABLE reviews ENABLE TRIGGER notify_business_on_review;
ALTER TABLE reviews ENABLE TRIGGER trigger_log_review_submission;
ALTER TABLE reviews ENABLE TRIGGER trigger_notify_admins_new_review;
ALTER TABLE reviews ENABLE TRIGGER trigger_subtract_points_deleted_review;

-- Aggiorna punti utenti per le nuove recensioni
UPDATE user_activity
SET
  reviews_count = reviews_count + 1,
  total_points = total_points + 50
WHERE user_id = 'a1000001-0000-0000-0000-000000000001'
  AND family_member_id IS NULL;

UPDATE user_activity
SET
  reviews_count = reviews_count + 1,
  total_points = total_points + 25
WHERE user_id = 'a1000002-0000-0000-0000-000000000002'
  AND family_member_id IS NULL;

UPDATE user_activity
SET
  reviews_count = reviews_count + 1,
  total_points = total_points + 50
WHERE user_id = 'a1000002-0000-0000-0000-000000000002'
  AND family_member_id = 'c3000001-0000-0000-0000-000000000001';
