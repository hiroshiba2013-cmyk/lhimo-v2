/*
  # Funzione per Statistiche Abbonamenti

  1. Funzione
    - `get_subscription_stats()` - Restituisce statistiche aggregate sugli abbonamenti

  2. Sicurezza
    - La funzione è pubblica ma restituisce solo dati aggregati
    - Non espone informazioni personali degli utenti

  3. Note
    - Conta gli abbonamenti attivi per tipo di utente e periodo di fatturazione
    - Include anche il conteggio degli utenti in prova gratuita
*/

-- Crea funzione per ottenere statistiche aggregate degli abbonamenti
CREATE OR REPLACE FUNCTION get_subscription_stats()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  stats jsonb;
BEGIN
  SELECT jsonb_build_object(
    'totalActive',
    (SELECT COUNT(*) FROM profiles WHERE subscription_status = 'active'),
    'customerMonthly',
    (SELECT COUNT(*) FROM profiles WHERE subscription_status = 'active' AND user_type = 'customer' AND subscription_type = 'monthly'),
    'customerYearly',
    (SELECT COUNT(*) FROM profiles WHERE subscription_status = 'active' AND user_type = 'customer' AND subscription_type = 'annual'),
    'businessMonthly',
    (SELECT COUNT(*) FROM profiles WHERE subscription_status = 'active' AND user_type = 'business' AND subscription_type = 'monthly'),
    'businessYearly',
    (SELECT COUNT(*) FROM profiles WHERE subscription_status = 'active' AND user_type = 'business' AND subscription_type = 'annual'),
    'trialUsers',
    (SELECT COUNT(*) FROM profiles WHERE subscription_status = 'trial')
  ) INTO stats;

  RETURN stats;
END;
$$;

-- Permetti a tutti gli utenti autenticati di chiamare questa funzione
GRANT EXECUTE ON FUNCTION get_subscription_stats() TO authenticated;
GRANT EXECUTE ON FUNCTION get_subscription_stats() TO anon;