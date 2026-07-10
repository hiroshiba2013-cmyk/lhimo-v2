-- ============================================================
-- FILE: 20260104221310_fix_job_posting_points_trigger.sql
-- ============================================================
/*
  # Fix Trigger per Assegnare Punti alla Pubblicazione di Annunci di Lavoro

  1. Correzione
    - Rimosso il riferimento alla funzione award_points che usa tabelle inesistenti
    - Aggiorna direttamente la tabella user_activity esistente
    - Assegna 30 punti al proprietario dell'azienda quando pubblica un annuncio di lavoro

  2. Dettagli
    - Punti assegnati: 30
    - Aggiorna total_points e last_activity_at nella tabella user_activity
    - Crea il record se non esiste (INSERT ... ON CONFLICT)

  3. Sicurezza
    - Il trigger è SECURITY DEFINER per accedere alle tabelle necessarie
    - I punti vengono assegnati solo per nuovi annunci (non per aggiornamenti)
*/

-- Elimina il trigger precedente
DROP TRIGGER IF EXISTS trigger_award_points_job_posting ON job_postings;
DROP FUNCTION IF EXISTS award_points_for_job_posting();

-- Crea la funzione corretta per assegnare punti quando viene creato un annuncio di lavoro
CREATE OR REPLACE FUNCTION award_points_for_job_posting()
RETURNS TRIGGER AS $$
DECLARE
  v_owner_id uuid;
BEGIN
  -- Ottieni l'owner_id dell'azienda
  SELECT owner_id INTO v_owner_id
  FROM businesses
  WHERE id = NEW.business_id;

  -- Se l'owner esiste, assegna i punti
  IF v_owner_id IS NOT NULL THEN
    -- Inserisci o aggiorna l'attività dell'utente
    INSERT INTO user_activity (user_id, total_points, last_activity_at, updated_at)
    VALUES (v_owner_id, 30, now(), now())
    ON CONFLICT (user_id) DO UPDATE SET
      total_points = user_activity.total_points + 30,
      last_activity_at = now(),
      updated_at = now();

    -- Registra l'attività nel log
    INSERT INTO activity_log (user_id, activity_type, points_earned, description, created_at)
    VALUES (
      v_owner_id,
      'job_posting_created',
      30,
      'Annuncio di lavoro pubblicato: ' || NEW.title,
      now()
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crea il trigger sulla tabella job_postings
CREATE TRIGGER trigger_award_points_job_posting
AFTER INSERT ON job_postings
FOR EACH ROW
EXECUTE FUNCTION award_points_for_job_posting();

-- Grant necessari
GRANT EXECUTE ON FUNCTION award_points_for_job_posting() TO authenticated;

-- ============================================================
-- FILE: 20260104221944_update_delete_account_function_add_products.sql
-- ============================================================
/*
  # Aggiorna Funzione Eliminazione Account - Aggiungi Prodotti
  
  1. Modifiche
    - Aggiunta eliminazione prodotti business
    - Aggiunta eliminazione solidarity_requests
    - Migliorata gestione errori
  
  2. Sicurezza
    - Mantiene SECURITY DEFINER per accesso completo
    - Verifica autenticazione utente
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione aggiornata
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina gli annunci classificati e i messaggi associati
  DELETE FROM classified_ad_messages WHERE ad_id IN (
    SELECT id FROM classified_ads WHERE user_id = user_profile_id
  );
  DELETE FROM classified_ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina i prodotti business
    DELETE FROM products WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_seeker_messages WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i job seekers dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina le richieste di solidarietà
  DELETE FROM solidarity_requests WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM content_reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina i referral (sia come referrer che come referee)
  DELETE FROM referrals WHERE referrer_id = user_profile_id OR referee_id = user_profile_id;

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20260104222544_fix_delete_account_handle_review_approvals.sql
-- ============================================================
/*
  # Fix Eliminazione Account - Gestione Approvazioni Recensioni
  
  1. Problema Risolto
    - La foreign key reviews.approved_by ha delete_rule NO ACTION
    - Questo blocca l'eliminazione se l'utente ha approvato recensioni
    - Soluzione: impostare approved_by a NULL prima di eliminare il profilo
  
  2. Sicurezza
    - Mantiene SECURITY DEFINER per accesso completo
    - Verifica autenticazione utente
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione corretta
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- IMPORTANTE: Gestisci le recensioni approvate da questo utente
  -- Imposta approved_by a NULL per evitare violazione foreign key
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina gli annunci classificati e i messaggi associati
  DELETE FROM classified_ad_messages WHERE ad_id IN (
    SELECT id FROM classified_ads WHERE user_id = user_profile_id
  );
  DELETE FROM classified_ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina i prodotti business
    DELETE FROM products WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_seeker_messages WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i job seekers dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina le richieste di solidarietà
  DELETE FROM solidarity_requests WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM content_reports WHERE reporter_id = user_profile_id;
  
  -- Elimina i report fatti dall'utente (tabella vecchia)
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina i referral (sia come referrer che come referee)
  DELETE FROM referrals WHERE referrer_id = user_profile_id OR referee_id = user_profile_id;

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20260104222917_fix_delete_account_correct_table_names.sql
-- ============================================================
/*
  # Fix Eliminazione Account - Nomi Tabelle Corretti
  
  1. Problema Risolto
    - La funzione usava nomi di tabelle errati:
      - classified_ad_messages -> NON ESISTE (usare ad_messages e ad_conversations)
      - solidarity_requests -> NON ESISTE (rimuovere)
      - content_reports -> NON ESISTE (usare reports)
      - products.business_id -> NON ESISTE (rimuovere eliminazione prodotti)
  
  2. Modifiche
    - Corretto tutti i nomi delle tabelle
    - Eliminazione corretta di conversazioni e messaggi
    - Gestione corretta di tutte le relazioni
  
  3. Sicurezza
    - Mantiene SECURITY DEFINER per accesso completo
    - Verifica autenticazione utente
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione corretta con i nomi delle tabelle giusti
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- IMPORTANTE: Gestisci le recensioni approvate da questo utente
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina i messaggi degli annunci classificati dell'utente
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT c.id FROM ad_conversations c
    JOIN classified_ads ca ON c.ad_id = ca.id
    WHERE ca.user_id = user_profile_id
  );
  
  -- Elimina i messaggi inviati dall'utente negli annunci
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni degli annunci
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;
  
  -- Elimina i messaggi generici dell'utente
  DELETE FROM messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni generiche
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;
  
  -- Elimina gli annunci classificati
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_offer_messages WHERE conversation_id IN (
      SELECT id FROM job_offer_conversations WHERE job_posting_id IN (
        SELECT id FROM job_postings WHERE business_id = user_business_id
      )
    );
    
    -- Elimina le conversazioni degli annunci di lavoro
    DELETE FROM job_offer_conversations WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le visualizzazioni degli annunci di lavoro
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le application agli annunci di lavoro
    DELETE FROM job_applications WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker (come employer o seeker)
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;
  
  -- Elimina i messaggi nelle conversazioni di job offer
  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni di job offer
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina i referral (sia come referrer che come referee)
  DELETE FROM referrals WHERE referrer_id = user_profile_id OR referee_id = user_profile_id;

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20260104222954_fix_delete_account_remove_referrals.sql
-- ============================================================
/*
  # Fix Eliminazione Account - Rimozione Referral Inesistenti
  
  1. Problema Risolto
    - La tabella referrals non esiste nel database
    - Rimossa la riga che tenta di eliminare referrals
  
  2. Sicurezza
    - Mantiene SECURITY DEFINER per accesso completo
    - Verifica autenticazione utente
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione corretta senza referrals
CREATE OR REPLACE FUNCTION delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_profile_id uuid;
  user_business_id uuid;
BEGIN
  -- Ottieni l'ID dell'utente corrente
  user_profile_id := auth.uid();
  
  IF user_profile_id IS NULL THEN
    RAISE EXCEPTION 'Non autenticato';
  END IF;

  -- Ottieni l'ID dell'azienda se l'utente è un business
  SELECT id INTO user_business_id
  FROM businesses
  WHERE owner_id = user_profile_id;

  -- IMPORTANTE: Gestisci le recensioni approvate da questo utente
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- Elimina i preferiti dell'utente
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le recensioni dell'utente
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  
  -- Elimina le recensioni dei membri della famiglia
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina i messaggi degli annunci classificati dell'utente
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT c.id FROM ad_conversations c
    JOIN classified_ads ca ON c.ad_id = ca.id
    WHERE ca.user_id = user_profile_id
  );
  
  -- Elimina i messaggi inviati dall'utente negli annunci
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni degli annunci
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;
  
  -- Elimina i messaggi generici dell'utente
  DELETE FROM messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni generiche
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;
  
  -- Elimina gli annunci classificati
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina i membri della famiglia
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- Elimina l'attività utente
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  
  -- Elimina l'activity log
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- Se l'utente ha un'azienda, elimina tutti i dati business
  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro dell'azienda
    DELETE FROM job_offer_messages WHERE conversation_id IN (
      SELECT id FROM job_offer_conversations WHERE job_posting_id IN (
        SELECT id FROM job_postings WHERE business_id = user_business_id
      )
    );
    
    -- Elimina le conversazioni degli annunci di lavoro
    DELETE FROM job_offer_conversations WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le visualizzazioni degli annunci di lavoro
    DELETE FROM job_views WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina le application agli annunci di lavoro
    DELETE FROM job_applications WHERE job_posting_id IN (
      SELECT id FROM job_postings WHERE business_id = user_business_id
    );
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- Elimina le richieste di lavoro
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker (come employer o seeker)
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker dell'utente
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;
  
  -- Elimina i messaggi nelle conversazioni di job offer
  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni di job offer
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina il profilo (questo eliminerà anche l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- ============================================================
-- FILE: 20260112162141_create_discount_redemptions_system.sql
-- ============================================================
/*
  # Create Discount Redemptions System

  1. New Tables
    - `discount_redemptions`
      - `id` (uuid, primary key)
      - `discount_id` (uuid, references discounts)
      - `customer_id` (uuid, references profiles)
      - `family_member_id` (uuid, nullable, references customer_family_members)
      - `redeemed_at` (timestamptz, default now())
      - `notes` (text, nullable)
      
  2. Security
    - Enable RLS on `discount_redemptions` table
    - Add policies for authenticated users to:
      - View their own redemptions
      - Create new redemptions for themselves
    
  3. Indexes
    - Add index on discount_id for faster queries
    - Add index on customer_id for faster user queries
    - Add composite index on (customer_id, discount_id) for duplicate prevention
*/

-- Create discount_redemptions table
CREATE TABLE IF NOT EXISTS discount_redemptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  discount_id uuid NOT NULL REFERENCES discounts(id) ON DELETE CASCADE,
  customer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE,
  redeemed_at timestamptz DEFAULT now(),
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE discount_redemptions ENABLE ROW LEVEL SECURITY;

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_discount_id ON discount_redemptions(discount_id);
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_customer_id ON discount_redemptions(customer_id);
CREATE INDEX IF NOT EXISTS idx_discount_redemptions_customer_discount ON discount_redemptions(customer_id, discount_id);

-- RLS Policies
CREATE POLICY "Users can view own discount redemptions"
  ON discount_redemptions
  FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

CREATE POLICY "Users can create own discount redemptions"
  ON discount_redemptions
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = customer_id);

