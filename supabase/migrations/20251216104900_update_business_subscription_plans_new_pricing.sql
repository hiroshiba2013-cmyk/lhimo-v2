/*
  # Aggiorna prezzi abbonamenti Business
  
  1. Modifiche
    - Elimina i vecchi piani Business
    - Crea nuovi piani Business con la nuova struttura prezzi:
      - 1 sede: €2,49/mese, €24,90/anno
      - 2 sedi: €3,99/mese, €39,90/anno
      - 3 sedi: €5,49/mese, €54,90/anno
      - 4 sedi: €7,99/mese, €79,90/anno
      - 5 sedi: €9,99/mese, €99,90/anno
      - 6-10 sedi: €12,99/mese, €129,90/anno
      - 10+ sedi: €14,99/mese, €149,90/anno
  
  2. Note
    - I prezzi sono esclusi IVA
    - max_persons rappresenta il numero di sedi per i piani Business
    - Il piano viene selezionato automaticamente in base al numero di sedi durante la registrazione
*/

-- Elimina i vecchi piani Business
DELETE FROM subscription_plans 
WHERE name LIKE 'Piano Business%';

-- Crea i nuovi piani Business
INSERT INTO subscription_plans (name, price, billing_period, max_persons) VALUES
  -- 1 sede
  ('Piano Business Mensile - 1 Sede', 2.49, 'monthly', 1),
  ('Piano Business Annuale - 1 Sede', 24.90, 'yearly', 1),
  
  -- 2 sedi
  ('Piano Business Mensile - 2 Sedi', 3.99, 'monthly', 2),
  ('Piano Business Annuale - 2 Sedi', 39.90, 'yearly', 2),
  
  -- 3 sedi
  ('Piano Business Mensile - 3 Sedi', 5.49, 'monthly', 3),
  ('Piano Business Annuale - 3 Sedi', 54.90, 'yearly', 3),
  
  -- 4 sedi
  ('Piano Business Mensile - 4 Sedi', 7.99, 'monthly', 4),
  ('Piano Business Annuale - 4 Sedi', 79.90, 'yearly', 4),
  
  -- 5 sedi
  ('Piano Business Mensile - 5 Sedi', 9.99, 'monthly', 5),
  ('Piano Business Annuale - 5 Sedi', 99.90, 'yearly', 5),
  
  -- 6-10 sedi
  ('Piano Business Mensile - 6-10 Sedi', 12.99, 'monthly', 10),
  ('Piano Business Annuale - 6-10 Sedi', 129.90, 'yearly', 10),
  
  -- 10+ sedi
  ('Piano Business Mensile - Oltre 10 Sedi', 14.99, 'monthly', 999),
  ('Piano Business Annuale - Oltre 10 Sedi', 149.90, 'yearly', 999);
