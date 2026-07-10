/*
  # Piani Abbonamento per Professionisti

  ## Modifiche
  
  1. Aggiunta piani abbonamento business
    - Piani basati sul numero di punti vendita (1, 2, 3, 4+)
    - Prezzi mensili e annuali
    - Prezzi escluso IVA (IVA da applicare al checkout)
  
  ## Piani Business
  
  - 1 punto vendita: 2,49€/mese o 24,90€/anno (+ IVA)
  - 2 punti vendita: 3,99€/mese o 39,90€/anno (+ IVA)
  - 3 punti vendita: 4,99€/mese o 49,90€/anno (+ IVA)
  - 4+ punti vendita: 5,99€/mese o 59,90€/anno (+ IVA)
  
  ## Note
  
  - I prezzi sono escluso IVA
  - I piani business usano il campo max_persons per indicare il numero di punti vendita
  - L'abbonamento viene creato automaticamente durante la registrazione
*/

-- Inserisci i piani abbonamento business
INSERT INTO subscription_plans (name, price, billing_period, max_persons) VALUES
  ('Piano Business Mensile - 1 Punto Vendita', 2.49, 'monthly', 1),
  ('Piano Business Annuale - 1 Punto Vendita', 24.90, 'yearly', 1),
  ('Piano Business Mensile - 2 Punti Vendita', 3.99, 'monthly', 2),
  ('Piano Business Annuale - 2 Punti Vendita', 39.90, 'yearly', 2),
  ('Piano Business Mensile - 3 Punti Vendita', 4.99, 'monthly', 3),
  ('Piano Business Annuale - 3 Punti Vendita', 49.90, 'yearly', 3),
  ('Piano Business Mensile - 4 Punti Vendita', 5.99, 'monthly', 4),
  ('Piano Business Annuale - 4 Punti Vendita', 59.90, 'yearly', 4)
ON CONFLICT DO NOTHING;
