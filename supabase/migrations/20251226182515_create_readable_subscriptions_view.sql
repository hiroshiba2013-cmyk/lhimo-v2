/*
  # Vista abbonamenti leggibile
  
  1. Nuove Viste
    - `subscriptions_readable` - Vista che mostra gli abbonamenti con dati leggibili
      - `nome_abbonato` - Nome completo per privati, ragione sociale per professionisti
      - `email_cliente` - Email usata in fase di registrazione
      - `piano_abbonamento` - Nome del piano sottoscritto
      - `tipo_utente` - customer o business
      - Altri campi utili (stato, date, periodo fatturazione, prezzo, ecc.)
      
  2. Sicurezza
    - La vista eredita le policy RLS dalla tabella subscriptions
*/

-- Crea una vista per gli abbonamenti con dati leggibili
CREATE OR REPLACE VIEW subscriptions_readable AS
SELECT 
  s.id,
  CASE 
    WHEN p.user_type = 'customer' THEN p.full_name
    WHEN p.user_type = 'business' THEN COALESCE(b.name, p.full_name)
    ELSE p.full_name
  END as nome_abbonato,
  p.email as email_cliente,
  sp.name as piano_abbonamento,
  p.user_type as tipo_utente,
  s.status as stato,
  s.start_date as data_inizio,
  s.end_date as data_fine,
  sp.billing_period as periodo_fatturazione,
  sp.max_persons as max_persone,
  sp.price as prezzo,
  s.created_at as creato_il,
  s.updated_at as aggiornato_il,
  s.customer_id,
  s.plan_id
FROM subscriptions s
JOIN profiles p ON s.customer_id = p.id
JOIN subscription_plans sp ON s.plan_id = sp.id
LEFT JOIN businesses b ON b.owner_id = p.id AND p.user_type = 'business'
ORDER BY s.created_at DESC;

-- Permetti a tutti gli utenti autenticati di vedere la vista
-- (la sicurezza è gestita dalle policy RLS delle tabelle sottostanti)
GRANT SELECT ON subscriptions_readable TO authenticated;
