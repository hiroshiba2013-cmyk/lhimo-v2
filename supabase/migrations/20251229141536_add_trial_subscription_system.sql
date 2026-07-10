/*
  # Aggiorna Sistema di Abbonamento con Trial di 2 Mesi

  1. Modifiche
    - Aggiunge 'trial' come stato valido per le subscriptions
    - Aggiunge campo 'payment_method_added' per tracciare se l'utente ha aggiunto un metodo di pagamento
    - Aggiunge campo 'reminder_sent' per tracciare se è stata inviata l'email di promemoria
    - Aggiunge campo 'trial_end_date' per distinguere la fine del trial dalla fine del periodo pagato
    - Periodo di trial: 60 giorni (2 mesi) gratuiti

  2. Sicurezza
    - Mantiene le policy RLS esistenti
*/

-- Modifica il check constraint per includere 'trial'
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage 
    WHERE table_name = 'subscriptions' AND constraint_name LIKE '%status_check%'
  ) THEN
    ALTER TABLE subscriptions DROP CONSTRAINT IF EXISTS subscriptions_status_check;
  END IF;
END $$;

ALTER TABLE subscriptions 
ADD CONSTRAINT subscriptions_status_check 
CHECK (status IN ('trial', 'active', 'expired', 'cancelled'));

-- Aggiungi nuovi campi se non esistono già
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'subscriptions' AND column_name = 'payment_method_added'
  ) THEN
    ALTER TABLE subscriptions ADD COLUMN payment_method_added boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'subscriptions' AND column_name = 'reminder_sent'
  ) THEN
    ALTER TABLE subscriptions ADD COLUMN reminder_sent boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'subscriptions' AND column_name = 'trial_end_date'
  ) THEN
    ALTER TABLE subscriptions ADD COLUMN trial_end_date timestamptz;
  END IF;
END $$;