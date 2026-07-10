/*
  # Correzione Contatori Solidarietà - Esclusione Trial

  ## Problema
  I contatori di fatturato e solidarietà mostrano valori anche per abbonamenti in prova gratuita (status='trial').
  Gli abbonamenti in trial NON devono essere contati nel fatturato perché sono gratuiti.

  ## Soluzione
  1. Aggiorna `get_total_revenue` per contare SOLO abbonamenti attivi (status='active')
  2. Aggiorna `get_subscription_stats` per sincronizzarsi con la tabella subscriptions
  3. I trial devono essere mostrati separatamente, non nel fatturato

  ## Logica
  - Fatturato = somma dei prezzi di abbonamenti con status='active' 
  - Trial = abbonamenti con status='trial' (mostrati separatamente)
  - Expired = abbonamenti con status='expired' o 'cancelled' (non contati)
*/

-- ========================================
-- FUNZIONE CORRETTA: get_total_revenue
-- ========================================

CREATE OR REPLACE FUNCTION get_total_revenue()
RETURNS DECIMAL(12, 2) AS $$
DECLARE
  total_revenue DECIMAL(12, 2);
BEGIN
  -- Somma solo i prezzi dei piani di abbonamenti ATTIVI (non trial, non expired)
  SELECT COALESCE(SUM(sp.price), 0)
  INTO total_revenue
  FROM subscriptions s
  INNER JOIN subscription_plans sp ON s.plan_id = sp.id
  WHERE s.status = 'active';  -- SOLO abbonamenti attivi

  RETURN total_revenue;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

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
        AND sp.user_type = 'customer' 
        AND sp.billing_period = 'monthly'
    ),
    'customerYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'customer' 
        AND sp.billing_period = 'annual'
    ),
    'businessMonthly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'business' 
        AND sp.billing_period = 'monthly'
    ),
    'businessYearly',
    (
      SELECT COUNT(*)
      FROM subscriptions s
      INNER JOIN subscription_plans sp ON s.plan_id = sp.id
      WHERE s.status = 'active' 
        AND sp.user_type = 'business' 
        AND sp.billing_period = 'annual'
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

-- ========================================
-- COMMENTI E NOTE
-- ========================================

-- Questa migrazione corregge i contatori nella sezione solidarietà:
-- 
-- PRIMA:
-- - Fatturato Totale: €0,49 (include trial gratuiti)
-- - Solidarietà: €0,05 (10% di €0,49)
-- - Abbonamenti Attivi: valori non sincronizzati
--
-- DOPO:
-- - Fatturato Totale: €0,00 (nessun abbonamento attivo pagante)
-- - Solidarietà: €0,00 (10% di €0,00)
-- - Abbonamenti Attivi: 0 (solo trial, mostrati separatamente)
-- - Utenti in Trial: 1 (mostrato nella card purple)
