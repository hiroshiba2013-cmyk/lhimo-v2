/*
  # Disabilita Trigger Punti Obsoleti

  ## Panoramica
  Rimuove i trigger che assegnano punti per azioni che non dovrebbero più darli:
  - business_locations (tabella per attività reclamate, non dovrebbe dare punti)
  - products (sistema punti per prodotti è stato disabilitato)

  ## Modifiche
  1. Rimuove trigger per business_locations
  2. Rimuove trigger per products

  ## Note
  I trigger per unclaimed_business_locations e user_added_businesses rimangono attivi
  perché assegnano correttamente i punti (10/25 punti).
*/

-- Rimuovi trigger obsoleti per business_locations
DROP TRIGGER IF EXISTS trigger_award_points_business_location ON business_locations;

-- Rimuovi trigger obsoleti per products
DROP TRIGGER IF EXISTS trigger_award_points_product ON products;

-- Verifica trigger rimanenti (dovrebbero essere solo quelli corretti)
-- Query di verifica (non eseguita, solo per documentazione):
-- SELECT trigger_name, event_object_table
-- FROM information_schema.triggers
-- WHERE trigger_name LIKE '%points%' OR trigger_name LIKE '%award%';
