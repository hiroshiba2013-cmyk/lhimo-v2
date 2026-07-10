/*
  # Permetti visione pubblica delle sedi aziendali
  
  ## Problema
  Le RLS policies attuali permettono solo ai proprietari di vedere le proprie business_locations.
  Questo impedisce agli utenti di:
  - Cercare attività
  - Vedere i dettagli delle sedi
  - Lasciare recensioni
  
  ## Soluzione
  Aggiungiamo una policy che permette a tutti (authenticated e anonymous) di vedere 
  tutte le business_locations per permettere la ricerca e le recensioni.
  
  ## Sicurezza
  - SELECT: Tutti possono vedere tutte le locations (pubblico)
  - INSERT/UPDATE/DELETE: Solo i proprietari (già gestito dalle policy esistenti)
*/

-- Permetti a tutti di vedere tutte le business locations
CREATE POLICY "Anyone can view business locations"
  ON business_locations
  FOR SELECT
  TO anon, authenticated
  USING (true);