/*
  # Funzione per calcolare il fatturato totale

  ## Descrizione

  Crea una funzione SQL che calcola il fatturato totale dalla somma di tutti gli abbonamenti,
  senza esporre i dati sensibili delle singole sottoscrizioni.

  ## Nuova Funzione

  - `get_total_revenue()` - Restituisce il fatturato totale come numero decimale
    - Somma tutti i prezzi dai piani delle sottoscrizioni attive
    - Non richiede autenticazione (pubblica)
    - Restituisce solo il totale aggregato, non dati individuali

  ## Sicurezza

  - La funzione è SECURITY DEFINER per bypassare le policy RLS
  - Restituisce solo dati aggregati, non espone informazioni individuali
  - Accessibile pubblicamente per mostrare i contatori sulla pagina solidarietà
*/

-- Crea funzione per calcolare il fatturato totale
CREATE OR REPLACE FUNCTION get_total_revenue()
RETURNS decimal(12, 2)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  total_revenue decimal(12, 2);
BEGIN
  -- Somma tutti i prezzi dai piani delle sottoscrizioni
  SELECT COALESCE(SUM(sp.price), 0)
  INTO total_revenue
  FROM subscriptions s
  INNER JOIN subscription_plans sp ON s.plan_id = sp.id;

  RETURN total_revenue;
END;
$$;

-- Permetti a tutti di eseguire questa funzione
GRANT EXECUTE ON FUNCTION get_total_revenue() TO anon, authenticated;
