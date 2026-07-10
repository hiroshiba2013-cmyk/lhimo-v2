/*
  # Aggiunta Colonne Localizzazione a Job Seekers

  ## Problema
  La tabella job_seekers manca delle colonne region, province, city che vengono
  usate per filtrare nella pagina Lavoro. Questo causa errori silenziosi e gli
  annunci non vengono visualizzati correttamente.

  ## Soluzione
  Aggiungere le colonne:
  - region (regione)
  - province (provincia) 
  - city (città)
  
  E popolare i dati esistenti dalla colonna location.
*/

-- Aggiungi le colonne di localizzazione
ALTER TABLE job_seekers
ADD COLUMN IF NOT EXISTS region TEXT,
ADD COLUMN IF NOT EXISTS province TEXT,
ADD COLUMN IF NOT EXISTS city TEXT;

-- Popola la colonna city con i dati esistenti da location
UPDATE job_seekers
SET city = location
WHERE city IS NULL AND location IS NOT NULL;

-- Commento
COMMENT ON COLUMN job_seekers.region IS 'Regione dove si cerca lavoro';
COMMENT ON COLUMN job_seekers.province IS 'Provincia dove si cerca lavoro';
COMMENT ON COLUMN job_seekers.city IS 'Città dove si cerca lavoro';
