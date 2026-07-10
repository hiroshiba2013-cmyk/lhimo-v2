/*
  # Rimozione del "+" dai piani abbonamento da 4 persone/sedi

  ## Descrizione

  Aggiorna i nomi dei piani abbonamento per rimuovere il simbolo "+" dal piano per 4 persone/sedi.
  Questo rende i nomi più puliti e coerenti.

  ## Modifiche

  - Piano Mensile - 4+ Persone → Piano Mensile - 4 Persone
  - Piano Annuale - 4+ Persone → Piano Annuale - 4 Persone
  - Piano Business Mensile - 4+ Punti Vendita → Piano Business Mensile - 4 Punti Vendita
  - Piano Business Annuale - 4+ Punti Vendita → Piano Business Annuale - 4 Punti Vendita

  ## Note

  - I prezzi e le altre impostazioni rimangono invariati
  - Solo i nomi vengono aggiornati per una migliore visualizzazione
*/

-- Aggiorna i piani per privati
UPDATE subscription_plans
SET name = 'Piano Mensile - 4 Persone'
WHERE name = 'Piano Mensile - 4+ Persone';

UPDATE subscription_plans
SET name = 'Piano Annuale - 4 Persone'
WHERE name = 'Piano Annuale - 4+ Persone';

-- Aggiorna i piani per business
UPDATE subscription_plans
SET name = 'Piano Business Mensile - 4 Punti Vendita'
WHERE name = 'Piano Business Mensile - 4+ Punti Vendita';

UPDATE subscription_plans
SET name = 'Piano Business Annuale - 4 Punti Vendita'
WHERE name = 'Piano Business Annuale - 4+ Punti Vendita';
