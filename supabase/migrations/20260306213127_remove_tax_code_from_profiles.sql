/*
  # Rimuove colonna tax_code obsoleta da profiles

  Questa migrazione rimuove la colonna `tax_code` dalla tabella `profiles` 
  poiché ora usiamo solo la colonna `fiscal_code`.

  ## Cambiamenti

  1. Rimuove colonna `tax_code` dalla tabella `profiles`

  ## Note

  - La colonna `fiscal_code` è già presente e contiene i dati corretti
  - La tabella `customer_family_members` usa già `fiscal_code` (rinominata nella migrazione precedente)
*/

-- Rimuove colonna tax_code dalla tabella profiles
ALTER TABLE profiles DROP COLUMN IF EXISTS tax_code;
