/*
  # Correzione Statistiche Abbonamenti - Usa Nome Piano

  ## Problema
  La funzione `get_subscription_stats` cercava di usare `sp.user_type` che non esiste.
  I piani si distinguono dal nome: quelli con "Business" sono per aziende.

  ## Soluzione
  Usa il nome del piano per distinguere tra piani business e customer:
  - Business: name LIKE '%Business%'
  - Customer: name NOT LIKE '%Business%'
*/

-- ========================================
-- FUNZIONE CORRETTA: get_subscription_stats
-- ========================================

CREATE OR REPLACE FUNCTION get_subscription_stats()
RETURNS JSONB AS $$
DECLARE
  stats JSONB;
BEGIN
  SELECT jsonb_build_object(
    'totalActive',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active'
    ),
    'customerMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name NOT LIKE '%Business%'
        AND sp.billing_period = 'monthly'
    ),
    'customerYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name NOT LIKE '%Business%'
        AND sp.billing_period = 'yearly'
    ),
    'businessMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name LIKE '%Business%'
        AND sp.billing_period = 'monthly'
    ),
    'businessYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.name LIKE '%Business%'
        AND sp.billing_period = 'yearly'
    ),
    'trialUsers',
    (
      SELECT COUNT(*)
      FROM subscriptions
      WHERE status = 'trial'
    )
  ) INTO stats;

  RETURN stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
