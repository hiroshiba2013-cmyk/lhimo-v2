
-- Aggiunge i piani abbonamento presenti nel backup ma mancanti nel DB attuale
-- Usa ON CONFLICT DO NOTHING per non toccare quelli esistenti

INSERT INTO subscription_plans (id, name, price, billing_period, max_persons, plan_type, created_at)
VALUES
  ('a3fbba4c-29e4-4bb7-8316-7387547cfb68','Piano Mensile - 1 Persona',0.49,'monthly',1,'customer','2025-12-09 16:30:06+00'),
  ('cb8bad67-1ffa-4c81-bace-76322ead3165','Piano Annuale - 1 Persona',4.90,'yearly',1,'customer','2025-12-09 16:30:06+00'),
  ('91907577-c01b-4a3d-99b7-f90c13587064','Piano Mensile - 2 Persone',0.79,'monthly',2,'customer','2025-12-09 16:30:06+00'),
  ('6bb74deb-e3e6-44ca-a242-2e301e5d69bf','Piano Annuale - 2 Persone',7.90,'yearly',2,'customer','2025-12-09 16:30:06+00'),
  ('3fa50626-3457-4a6e-85aa-9d635e6a6fdb','Piano Mensile - 3 Persone',1.09,'monthly',3,'customer','2025-12-09 16:30:06+00'),
  ('175a7837-f5bf-4df2-ac27-103ec0c5d25d','Piano Annuale - 3 Persone',10.90,'yearly',3,'customer','2025-12-09 16:30:06+00'),
  ('f326f222-f3c1-40c7-b3e1-2afea5bc17ac','Piano Mensile - 4 Persone',1.49,'monthly',4,'customer','2025-12-09 16:30:06+00'),
  ('f4284146-ea3e-4230-bd25-6023b381b50e','Piano Annuale - 4 Persone',14.90,'yearly',4,'customer','2025-12-09 16:30:06+00')
ON CONFLICT (id) DO NOTHING;

-- Aggiorna plan_type sui piani business esistenti
UPDATE subscription_plans SET plan_type = 'business'
WHERE name LIKE '%Business%' OR name LIKE '%Punto Vendita%' OR name LIKE '%Sede%';

UPDATE subscription_plans SET plan_type = 'customer'
WHERE plan_type IS NULL OR plan_type = '';
