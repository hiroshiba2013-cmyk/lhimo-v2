/*
  # Cancella tutte le attività fittizie inserite dai seed
  
  1. Operazioni
    - Cancella tutte le business_locations collegate a businesses non reclamate
    - Cancella tutte le businesses non reclamate (is_claimed = false)
    - Mantiene eventuali attività reali create dagli utenti
  
  2. Sicurezza
    - Cancella solo le attività con is_claimed = false (tutte fittizie)
    - Mantiene le categorie e altri dati strutturali
    - Mantiene eventuali attività reclamate da utenti reali
  
  3. Note
    - Le foreign key con ON DELETE CASCADE gestiranno automaticamente
      la cancellazione delle tabelle collegate (reviews, job_postings, etc.)
*/

-- Cancella prima le business_locations collegate a businesses non reclamate
DELETE FROM business_locations 
WHERE business_id IN (
  SELECT id FROM businesses WHERE is_claimed = false
);

-- Cancella tutte le businesses non reclamate (attività fittizie)
DELETE FROM businesses WHERE is_claimed = false;
