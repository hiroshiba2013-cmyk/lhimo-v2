/*
  # Cleanup Duplicate Subscriptions
  
  1. Problema
    - Gli utenti potrebbero avere abbonamenti duplicati creati dai trigger e dal frontend
    - Questo causa confusione nella dashboard
    
  2. Soluzione
    - Identifica e rimuovi abbonamenti duplicati
    - Mantieni solo l'abbonamento più recente per ogni utente
    
  3. Sicurezza
    - Opera solo su abbonamenti trial
    - Non tocca abbonamenti attivi pagati
*/

-- Rimuovi abbonamenti duplicati, mantenendo solo il più recente per ogni utente
WITH duplicates AS (
  SELECT 
    id,
    customer_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id 
      ORDER BY created_at DESC, id DESC
    ) as rn
  FROM subscriptions
  WHERE status IN ('trial', 'active')
)
DELETE FROM subscriptions
WHERE id IN (
  SELECT id 
  FROM duplicates 
  WHERE rn > 1
);

-- Aggiorna i profili che non hanno subscription_type impostato
-- ma hanno un abbonamento attivo
UPDATE profiles p
SET 
  subscription_type = sp.name,
  subscription_status = s.status,
  subscription_expires_at = s.end_date
FROM subscriptions s
JOIN subscription_plans sp ON s.plan_id = sp.id
WHERE p.id = s.customer_id
  AND s.status IN ('trial', 'active')
  AND (p.subscription_type IS NULL OR p.subscription_status IS NULL);
