/*
  # Blocco Cambio Piano Durante Periodo di Prova

  1. Cambiamenti
    - Aggiunge trigger per impedire cambio piano durante trial
    - Previene aggiornamenti alla tabella `subscriptions` se status è 'trial'
    - Permette solo aggiornamenti a `payment_method_added` e `reminder_sent`
    - Blocca completamente insert/delete di subscriptions durante trial attivo
    
  2. Sicurezza
    - Gli admin possono sempre modificare
    - Solo il sistema può creare subscriptions durante trial
    - Gli utenti non possono cancellare o modificare subscriptions in trial
    
  3. Note
    - Questo protegge il diritto alla prova gratuita
    - Una volta in trial, l'utente deve completarlo o farlo scadere
    - Dopo la scadenza del trial, l'utente può scegliere un nuovo piano
*/

-- Funzione per bloccare cambio piano durante trial
CREATE OR REPLACE FUNCTION prevent_trial_plan_changes()
RETURNS TRIGGER AS $$
BEGIN
  -- Permetti agli admin di fare qualsiasi cosa
  IF EXISTS (
    SELECT 1 FROM admins 
    WHERE user_id = auth.uid()
  ) THEN
    RETURN NEW;
  END IF;

  -- Blocca DELETE durante trial
  IF TG_OP = 'DELETE' THEN
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

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Applica il trigger alla tabella subscriptions
DROP TRIGGER IF EXISTS enforce_trial_plan_restrictions ON subscriptions;
CREATE TRIGGER enforce_trial_plan_restrictions
  BEFORE INSERT OR UPDATE OR DELETE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION prevent_trial_plan_changes();

-- Aggiungi una funzione helper per verificare se un utente può cambiare piano
CREATE OR REPLACE FUNCTION can_change_subscription_plan(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  -- Admin possono sempre
  IF EXISTS (SELECT 1 FROM admins WHERE admins.user_id = $1) THEN
    RETURN true;
  END IF;

  -- Controlla se ha un trial attivo
  IF EXISTS (
    SELECT 1 FROM subscriptions
    WHERE customer_id = $1
      AND status = 'trial'
      AND trial_end_date > NOW()
  ) THEN
    RETURN false;
  END IF;

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Commento sulla tabella
COMMENT ON FUNCTION prevent_trial_plan_changes() IS 'Impedisce agli utenti di cambiare piano durante il periodo di prova per proteggere il diritto alla prova gratuita di 30 giorni';
COMMENT ON FUNCTION can_change_subscription_plan(UUID) IS 'Verifica se un utente può cambiare il proprio piano abbonamento (false se in trial attivo)';
