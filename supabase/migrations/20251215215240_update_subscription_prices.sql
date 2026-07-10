/*
  # Aggiornamento Prezzi Abbonamenti

  1. Modifiche ai Piani
    - Aggiorna i prezzi per i piani cliente (1-4 persone)
    - Nuovi prezzi mensili: €0.49, €0.79, €1.09, €1.49
    - Nuovi prezzi annuali: €4.90, €7.90, €10.90, €14.90
*/

-- Aggiorna i prezzi dei piani mensili per clienti
UPDATE subscription_plans
SET price = 0.49
WHERE max_persons = 1 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 0.79
WHERE max_persons = 2 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 1.09
WHERE max_persons = 3 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 1.49
WHERE max_persons = 4 AND billing_period = 'monthly' AND name LIKE 'Piano Base%';

-- Aggiorna i prezzi dei piani annuali per clienti
UPDATE subscription_plans
SET price = 4.90
WHERE max_persons = 1 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 7.90
WHERE max_persons = 2 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 10.90
WHERE max_persons = 3 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';

UPDATE subscription_plans
SET price = 14.90
WHERE max_persons = 4 AND billing_period = 'yearly' AND name LIKE 'Piano Base%';