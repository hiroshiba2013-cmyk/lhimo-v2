/*
  # Correzione Prezzi Abbonamenti

  1. Modifica
    - Aggiorna correttamente i prezzi per tutti i piani cliente usando gli ID
    - Nuovi prezzi mensili: €0.49, €0.79, €1.09, €1.49
    - Nuovi prezzi annuali: €4.90, €7.90, €10.90, €14.90
*/

-- Aggiorna Piano Mensile - 1 Persona
UPDATE subscription_plans
SET price = 0.49
WHERE id = 'a3fbba4c-29e4-4bb7-8316-7387547cfb68';

-- Aggiorna Piano Annuale - 1 Persona
UPDATE subscription_plans
SET price = 4.90
WHERE id = 'cb8bad67-1ffa-4c81-bace-76322ead3165';

-- Aggiorna Piano Mensile - 2 Persone
UPDATE subscription_plans
SET price = 0.79
WHERE id = '91907577-c01b-4a3d-99b7-f90c13587064';

-- Aggiorna Piano Annuale - 2 Persone
UPDATE subscription_plans
SET price = 7.90
WHERE id = '6bb74deb-e3e6-44ca-a242-2e301e5d69bf';

-- Aggiorna Piano Mensile - 3 Persone
UPDATE subscription_plans
SET price = 1.09
WHERE id = '3fa50626-3457-4a6e-85aa-9d635e6a6fdb';

-- Aggiorna Piano Annuale - 3 Persone
UPDATE subscription_plans
SET price = 10.90
WHERE id = '175a7837-f5bf-4df2-ac27-103ec0c5d25d';

-- Aggiorna Piano Mensile - 4+ Persone
UPDATE subscription_plans
SET price = 1.49
WHERE id = 'f326f222-f3c1-40c7-b3e1-2afea5bc17ac';

-- Aggiorna Piano Annuale - 4+ Persone
UPDATE subscription_plans
SET price = 14.90
WHERE id = 'a88a0e2b-968f-4e79-8e6e-53bf0994ad69';