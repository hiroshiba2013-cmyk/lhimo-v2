/*
  # Fix Eliminazione Abbonamenti per Admin
  
  1. Problema
    - Il trigger `prevent_trial_plan_changes` blocca la DELETE anche quando chiamata da admin
    - Gli abbonamenti non vengono eliminati quando l'admin cancella un utente
    
  2. Soluzione
    - Modifica il trigger per permettere DELETE se chiamata nel contesto SECURITY DEFINER
    - Gli admin possono eliminare abbonamenti anche in trial
    
  3. Note
    - La funzione admin_delete_user_account ora può eliminare correttamente gli abbonamenti
    - Il trigger protegge ancora gli utenti normali dal cancellare abbonamenti trial
*/

-- Modifica la funzione per permettere DELETE da funzioni SECURITY DEFINER
CREATE OR REPLACE FUNCTION prevent_trial_plan_changes()
RETURNS TRIGGER AS $$
BEGIN
  -- Permetti agli admin di fare qualsiasi cosa
  IF EXISTS (
    SELECT 1 FROM admins 
    WHERE user_id = auth.uid()
  ) THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  -- Blocca DELETE durante trial solo se non viene da una funzione SECURITY DEFINER
  IF TG_OP = 'DELETE' THEN
    -- Permetti DELETE se il profilo dell'utente sta per essere eliminato
    -- (la funzione admin_delete_user_account usa SECURITY DEFINER)
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = OLD.customer_id) THEN
      RETURN OLD;
    END IF;
    
    IF OLD.status = 'trial' THEN
      RAISE EXCEPTION 'Non puoi cancellare un abbonamento durante il periodo di prova. Devi attendere la scadenza del trial.';
    END IF;
    RETURN OLD;
  END IF;

  -- Blocca INSERT se esiste già un trial attivo
  IF TG_OP = 'INSERT' THEN
    IF EXISTS (
      SELECT 1 FROM subscriptions
      WHERE customer_id = NEW.customer_id
        AND status = 'trial'
        AND trial_end_date > NOW()
    ) THEN
      RAISE EXCEPTION 'Hai già un periodo di prova attivo. Non puoi attivare un nuovo abbonamento fino alla scadenza del trial.';
    END IF;
    RETURN NEW;
  END IF;

  -- Blocca UPDATE del piano durante trial
  IF TG_OP = 'UPDATE' THEN
    IF OLD.status = 'trial' AND OLD.trial_end_date > NOW() THEN
      -- Permetti solo aggiornamenti a campi non-critici
      IF NEW.plan_id != OLD.plan_id THEN
        RAISE EXCEPTION 'Non puoi cambiare piano durante il periodo di prova. Se cambi piano perdi il diritto alla prova gratuita di 30 giorni.';
      END IF;
      
      -- Permetti solo modifica di payment_method_added, reminder_sent, status
      IF NEW.customer_id != OLD.customer_id OR
         NEW.start_date != OLD.start_date OR
         NEW.end_date != OLD.end_date OR
         NEW.trial_end_date != OLD.trial_end_date THEN
        RAISE EXCEPTION 'Non puoi modificare i dettagli dell''abbonamento durante il periodo di prova.';
      END IF;
    END IF;
    RETURN NEW;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
