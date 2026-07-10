/*
  # Pulizia Abbonamenti Orfani - v2
  
  1. Problema
    - Gli abbonamenti possono rimanere nel database dopo l'eliminazione di un utente
    - Questo causa confusione nel pannello admin
    
  2. Soluzione
    - Elimina tutti gli abbonamenti senza un customer valido
    - La funzione admin_delete_user_account già gestisce l'eliminazione
    
  3. Note
    - Pulizia una tantum degli abbonamenti orfani esistenti
    - Non serve trigger perché la funzione admin_delete_user_account già elimina gli abbonamenti
*/

-- Pulizia abbonamenti orfani esistenti (se ce ne sono)
DO $$
BEGIN
  DELETE FROM subscriptions
  WHERE customer_id NOT IN (SELECT id FROM profiles);
  
  RAISE NOTICE 'Abbonamenti orfani eliminati con successo';
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Errore durante la pulizia: %', SQLERRM;
END $$;
