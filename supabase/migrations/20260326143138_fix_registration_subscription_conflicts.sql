/*
  # Fix Registration Subscription Conflicts
  
  1. Problema
    - Durante la registrazione vengono creati doppi abbonamenti:
      * Uno dal RegisterForm (frontend)
      * Uno dai trigger create_trial_for_customer/business (database)
    - Questo causa confusione e l'abbonamento non viene visualizzato
    
  2. Soluzione
    - Disattiva i trigger automatici di creazione trial
    - Lascia che sia solo il frontend a creare l'abbonamento
    - Il trigger sync_subscription_type_from_plan si occuperà di aggiornare il nome del piano
    
  3. Note
    - Il frontend gestirà la creazione completa dell'abbonamento
    - I trigger saranno solo di sincronizzazione, non di creazione
*/

-- Disabilita il trigger di creazione automatica trial per customer
DROP TRIGGER IF EXISTS trigger_create_trial_subscription_customer ON profiles;

-- Disabilita il trigger di creazione automatica trial per business
DROP TRIGGER IF EXISTS trigger_create_trial_subscription_business ON profiles;

-- Mantieni SOLO il trigger di sincronizzazione del subscription_type
-- (questo rimane attivo e funzionante)

-- Aggiungi commento per chiarezza
COMMENT ON FUNCTION create_trial_for_customer IS 'DISABILITATA - La creazione del trial è gestita dal frontend durante la registrazione';
COMMENT ON FUNCTION create_trial_for_business IS 'DISABILITATA - La creazione del trial è gestita dal frontend durante la registrazione';
