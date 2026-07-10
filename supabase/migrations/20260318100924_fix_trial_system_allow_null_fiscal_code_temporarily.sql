/*
  # Fix Trial System - Permetti Fiscal Code NULL Temporaneamente

  1. Problema
    - Durante la registrazione, il profilo viene creato SENZA fiscal_code
    - Il trigger create_trial_for_customer() cerca di creare il trial subito
    - Il trigger prevent_trial_abuse() blocca perché fiscal_code è NULL
    - Il frontend aggiorna il fiscal_code DOPO, ma è troppo tardi
    - Questo causa errore 422 durante la registrazione

  2. Soluzione Opzione A (scelta)
    - Disabilita completamente il trigger create_trial_for_customer()
    - Il trial viene creato SOLO dal frontend dopo aver aggiunto il fiscal_code
    - Questo garantisce che prevent_trial_abuse abbia sempre il fiscal_code disponibile

  3. Perché questa soluzione
    - Il frontend già gestisce la creazione del trial manualmente
    - Evita problemi di sincronizzazione
    - Il fiscal_code sarà sempre presente quando il trial viene creato
*/

-- Rimuovi il trigger automatico per creare trial
DROP TRIGGER IF EXISTS trigger_create_trial_for_customer ON profiles;

-- Commenta la funzione per indicare che non è più usata
COMMENT ON FUNCTION create_trial_for_customer() IS 'DEPRECATA: Il trial viene ora creato manualmente dal frontend dopo aver impostato il fiscal_code';
