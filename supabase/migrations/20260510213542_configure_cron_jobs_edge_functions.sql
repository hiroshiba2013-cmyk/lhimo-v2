/*
  # Configurazione cron job per edge functions

  Attiva l'estensione pg_cron e configura i job pianificati per:
  1. close-expired-auctions: ogni ora, chiude le aste scadute
  2. cleanup-expired-ads: ogni giorno a mezzanotte, elimina annunci scaduti
  3. check-subscription-expiration: ogni giorno alle 3:00, controlla abbonamenti scaduti
  4. send-trial-reminders: ogni giorno alle 9:00, invia promemoria trial
*/

-- Abilita pg_cron se non già attivo
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Rimuovi job esistenti per evitare duplicati
SELECT cron.unschedule('close-expired-auctions') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'close-expired-auctions'
);
SELECT cron.unschedule('cleanup-expired-ads') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'cleanup-expired-ads'
);
SELECT cron.unschedule('check-subscription-expiration') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'check-subscription-expiration'
);
SELECT cron.unschedule('send-trial-reminders') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'send-trial-reminders'
);

-- Asta scaduta: ogni ora
SELECT cron.schedule(
  'close-expired-auctions',
  '0 * * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/close-expired-auctions',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Annunci scaduti: ogni giorno a mezzanotte
SELECT cron.schedule(
  'cleanup-expired-ads',
  '0 0 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/cleanup-expired-ads',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Abbonamenti scaduti: ogni giorno alle 3:00
SELECT cron.schedule(
  'check-subscription-expiration',
  '0 3 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/check-subscription-expiration',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Promemoria trial: ogni giorno alle 9:00
SELECT cron.schedule(
  'send-trial-reminders',
  '0 9 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/send-trial-reminders',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);
