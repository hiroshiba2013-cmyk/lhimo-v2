
/*
# Fix permessi schema public: grants per anon, authenticated, service_role, supabase_auth_admin

## Problema
Tutti i ruoli Supabase (anon, authenticated, service_role, supabase_auth_admin, authenticator)
mancano dei grant necessari per accedere allo schema public, alle tabelle e alle funzioni.

Questo causa:
- "permission denied for schema public" durante la registrazione admin (service_role)
- Comuni non caricati nel form di registrazione (anon non può eseguire get_comuni_by_provincia)
- Qualsiasi operazione di lettura/scrittura dal frontend fallisce silenziosamente

## Correzioni
1. GRANT USAGE ON SCHEMA public a tutti i ruoli necessari
2. GRANT SELECT/INSERT/UPDATE/DELETE ON ALL TABLES a anon, authenticated, service_role
3. GRANT EXECUTE ON ALL FUNCTIONS a tutti i ruoli
4. GRANT USAGE/SELECT ON ALL SEQUENCES
5. DEFAULT PRIVILEGES per tabelle future
6. Grant specifico a supabase_auth_admin per il trigger on_auth_user_created

## Nota sicurezza
I GRANT consentono l'accesso a livello di tabella. Le RLS policies (già configurate)
continuano a controllare l'accesso a livello di riga. La combinazione
grant + RLS è il modello di sicurezza corretto in Supabase.
*/

-- ============================================================
-- 1. SCHEMA USAGE
-- ============================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT USAGE ON SCHEMA public TO supabase_auth_admin, authenticator;

-- ============================================================
-- 2. TABLE GRANTS
-- ============================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public 
  TO anon, authenticated, service_role;

-- supabase_auth_admin needs access for trigger execution context
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public
  TO supabase_auth_admin;

-- ============================================================
-- 3. SEQUENCE GRANTS (per le colonne serial/identity)
-- ============================================================
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public 
  TO anon, authenticated, service_role, supabase_auth_admin;

-- ============================================================
-- 4. FUNCTION EXECUTE GRANTS
-- ============================================================
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public 
  TO anon, authenticated, service_role, supabase_auth_admin;

-- ============================================================
-- 5. DEFAULT PRIVILEGES per oggetti futuri
-- ============================================================
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
  TO anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES
  TO anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT EXECUTE ON FUNCTIONS
  TO anon, authenticated, service_role;
