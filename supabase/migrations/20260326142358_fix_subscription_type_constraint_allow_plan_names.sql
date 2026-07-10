/*
  # Fix Subscription Type Constraint - Permetti Nomi Piano
  
  1. Problema
    - Il CHECK constraint su profiles.subscription_type permette solo 'monthly' o 'annual'
    - I trigger salvano il nome completo del piano (es. "Trial Base", "Business Base")
    - Causa errore: "new row violates check constraint profiles_subscription_type_check"
    
  2. Soluzione
    - Rimuove il constraint esistente
    - Aggiunge un nuovo constraint che permette NULL o qualsiasi stringa
    
  3. Note
    - Mantiene la compatibilità con i dati esistenti
    - Permette flessibilità per salvare qualsiasi nome di piano
*/

-- Rimuovi il constraint esistente
ALTER TABLE profiles 
DROP CONSTRAINT IF EXISTS profiles_subscription_type_check;

-- Aggiungi un nuovo constraint che permette NULL o qualsiasi valore text
ALTER TABLE profiles
ADD CONSTRAINT profiles_subscription_type_check 
CHECK (subscription_type IS NULL OR length(subscription_type) > 0);

-- Commento
COMMENT ON CONSTRAINT profiles_subscription_type_check ON profiles IS 'Permette NULL o qualsiasi nome di piano valido';
