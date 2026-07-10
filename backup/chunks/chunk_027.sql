-- ============================================================
-- FILE: 20260213102032_fix_get_location_ratings_column_name.sql
-- ============================================================
/*
  # Fix get_location_ratings function column name
  
  1. Changes
    - Update get_location_ratings function to use correct column name
    - Change `r.unclaimed_business_id` to `r.unclaimed_business_location_id`
  
  2. Notes
    - The reviews table uses `unclaimed_business_location_id` not `unclaimed_business_id`
*/

CREATE OR REPLACE FUNCTION get_location_ratings(location_ids uuid[])
RETURNS TABLE (
  id uuid,
  avg_rating numeric,
  review_count bigint
)
AS $$
BEGIN
  RETURN QUERY
  WITH location_reviews AS (
    -- Get reviews for business locations
    SELECT
      bl.id as location_id,
      r.overall_rating
    FROM unnest(location_ids) AS loc(id)
    LEFT JOIN business_locations bl ON bl.id = loc.id
    LEFT JOIN reviews r ON r.business_location_id = bl.id AND r.review_status = 'approved'
    
    UNION ALL
    
    -- Get reviews for unclaimed business locations
    SELECT
      ubl.id as location_id,
      r.overall_rating
    FROM unnest(location_ids) AS loc(id)
    LEFT JOIN unclaimed_business_locations ubl ON ubl.id = loc.id
    LEFT JOIN reviews r ON r.unclaimed_business_location_id = ubl.id AND r.review_status = 'approved'
  )
  SELECT
    location_id as id,
    COALESCE(AVG(overall_rating), 0)::numeric as avg_rating,
    COUNT(overall_rating) as review_count
  FROM location_reviews
  GROUP BY location_id;
END;
$$ LANGUAGE plpgsql STABLE;


-- ============================================================
-- FILE: 20260213111238_auto_update_trial_plan_on_family_changes.sql
-- ============================================================
/*
  # Aggiornamento Automatico Piano Trial con Membri Famiglia

  1. Nuove Funzioni
    - `update_trial_plan_on_family_change`: Aggiorna automaticamente il piano del trial quando vengono aggiunti o rimossi membri della famiglia
    - Calcola il numero totale di persone (titolare + membri famiglia)
    - Trova e assegna il piano corretto per quel numero di persone

  2. Trigger
    - Trigger AFTER INSERT su customer_family_members
    - Trigger AFTER DELETE su customer_family_members
    - Aggiorna automaticamente il piano del trial se l'utente ha un abbonamento trial attivo

  3. Comportamento
    - Se l'utente ha 1 membro famiglia (2 persone totali), passa al piano per 2 persone
    - Se l'utente ha 2 membri famiglia (3 persone totali), passa al piano per 3 persone
    - E così via fino a 4 persone
    - Funziona solo per abbonamenti in stato 'trial', non modifica abbonamenti pagati

  4. Note
    - Questo trigger mantiene il periodo di trial originale
    - Non cambia le date di scadenza
    - È completamente automatico e trasparente per l'utente
*/

-- Funzione per aggiornare il piano del trial in base al numero di membri della famiglia
CREATE OR REPLACE FUNCTION update_trial_plan_on_family_change()
RETURNS TRIGGER AS $$
DECLARE
  v_customer_id uuid;
  v_family_count integer;
  v_total_persons integer;
  v_new_plan_id uuid;
  v_current_subscription_id uuid;
  v_billing_period text;
BEGIN
  -- Determina l'ID del cliente (valido sia per INSERT che DELETE)
  IF TG_OP = 'DELETE' THEN
    v_customer_id := OLD.customer_id;
  ELSE
    v_customer_id := NEW.customer_id;
  END IF;

  -- Conta i membri della famiglia attuali
  SELECT COUNT(*) INTO v_family_count
  FROM customer_family_members
  WHERE customer_id = v_customer_id;

  -- Calcola il numero totale di persone (1 titolare + membri famiglia)
  v_total_persons := 1 + v_family_count;

  -- Verifica se l'utente ha un abbonamento trial attivo
  SELECT s.id, sp.billing_period
  INTO v_current_subscription_id, v_billing_period
  FROM subscriptions s
  JOIN subscription_plans sp ON sp.id = s.plan_id
  WHERE s.customer_id = v_customer_id
    AND s.status = 'trial'
  LIMIT 1;

  -- Se non c'è un trial attivo, non fare nulla
  IF v_current_subscription_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Trova il piano corretto per il numero di persone e il periodo di fatturazione
  SELECT id INTO v_new_plan_id
  FROM subscription_plans
  WHERE max_persons = v_total_persons
    AND billing_period = v_billing_period
    AND name NOT LIKE '%Business%'
  LIMIT 1;

  -- Se esiste un piano adatto, aggiorna l'abbonamento
  IF v_new_plan_id IS NOT NULL THEN
    UPDATE subscriptions
    SET plan_id = v_new_plan_id,
        updated_at = now()
    WHERE id = v_current_subscription_id;
    
    RAISE NOTICE 'Piano trial aggiornato automaticamente per % persone (piano: %)', v_total_persons, v_new_plan_id;
  END IF;

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger per l'inserimento di membri della famiglia
DROP TRIGGER IF EXISTS trigger_update_trial_on_family_insert ON customer_family_members;
CREATE TRIGGER trigger_update_trial_on_family_insert
  AFTER INSERT ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_trial_plan_on_family_change();

-- Trigger per la cancellazione di membri della famiglia
DROP TRIGGER IF EXISTS trigger_update_trial_on_family_delete ON customer_family_members;
CREATE TRIGGER trigger_update_trial_on_family_delete
  AFTER DELETE ON customer_family_members
  FOR EACH ROW
  EXECUTE FUNCTION update_trial_plan_on_family_change();

-- Commento sulle funzioni e trigger
COMMENT ON FUNCTION update_trial_plan_on_family_change() IS 'Aggiorna automaticamente il piano del trial quando vengono aggiunti o rimossi membri della famiglia';
COMMENT ON TRIGGER trigger_update_trial_on_family_insert ON customer_family_members IS 'Aggiorna il piano trial quando viene aggiunto un membro della famiglia';
COMMENT ON TRIGGER trigger_update_trial_on_family_delete ON customer_family_members IS 'Aggiorna il piano trial quando viene rimosso un membro della famiglia';


-- ============================================================
-- FILE: 20260213112257_complete_account_deletion_with_family_members.sql
-- ============================================================
/*
  # Eliminazione Completa Account con Membri Famiglia
  
  1. Cosa Viene Eliminato Automaticamente (vincoli CASCADE)
    Quando si eliminano i membri della famiglia, i seguenti contenuti vengono eliminati automaticamente:
    - Annunci classificati creati dai membri della famiglia
    - Redemptions sconti dei membri della famiglia
    - Preferiti (businesses, classified ads, job postings) dei membri della famiglia
    - Job requests dei membri della famiglia
    
    I seguenti campi vengono impostati a NULL:
    - family_member_id nelle recensioni (review rimane ma non è più associata al membro)
    - added_by_family_member_id in unclaimed_business_locations
  
  2. Aggiornamento Funzione
    - Aggiunge eliminazione esplicita delle recensioni dei membri della famiglia
    - Aggiunge eliminazione dei prodotti business
    - Migliora l'ordine delle eliminazioni per evitare errori di foreign key
    - Aggiunge commenti più chiari su cosa viene eliminato

  3. Garanzie di Eliminazione Completa
    Quando un utente elimina il suo account, vengono eliminati PERMANENTEMENTE:
    
    UTENTE CUSTOMER:
    - Profilo utente
    - Membri della famiglia
    - Tutte le recensioni (proprie e dei membri della famiglia)
    - Tutti gli annunci classificati (propri e dei membri della famiglia)
    - Tutte le job requests (proprie e dei membri della famiglia)
    - Tutti i preferiti (businesses, ads, job postings)
    - Tutte le conversazioni e messaggi
    - Tutti i job seeker ads
    - Tutte le job applications
    - Activity log e user activity
    - Notifiche
    - Segnalazioni fatte
    - Abbonamenti
    - Discount redemptions
    
    UTENTE BUSINESS:
    - Tutto quanto sopra +
    - Azienda
    - Tutte le sedi aziendali
    - Tutti gli annunci di lavoro
    - Tutte le application ricevute
    - Tutte le conversazioni con candidati
    - Tutti gli sconti creati
    - Tutte le risposte alle recensioni
    - Tutti i prodotti
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS delete_user_account();

-- Crea la funzione completa e migliorata
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

  -- ========================================
  -- GESTIONE RIFERIMENTI CHE DEVONO RESTARE
  -- ========================================
  
  -- Gestisci le recensioni approvate da questo utente (mantieni la review ma rimuovi il riferimento all'admin)
  UPDATE reviews SET approved_by = NULL WHERE approved_by = user_profile_id;

  -- Gestisci i report revisionati da questo utente (mantieni il report ma rimuovi il riferimento all'admin)
  UPDATE reports SET reviewed_by = NULL WHERE reviewed_by = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE CONTENUTI UTENTE CUSTOMER
  -- ========================================

  -- Elimina i preferiti dell'utente E dei membri della famiglia
  -- (anche se i membri della famiglia verranno eliminati dopo, eliminiamo i loro preferiti prima per pulizia)
  DELETE FROM favorite_businesses WHERE user_id = user_profile_id;
  DELETE FROM favorite_classified_ads WHERE user_id = user_profile_id;
  DELETE FROM favorite_job_postings WHERE user_id = user_profile_id;

  -- Elimina le redemptions degli sconti dell'utente E dei membri della famiglia
  DELETE FROM discount_redemptions WHERE customer_id = user_profile_id;

  -- Elimina TUTTE le recensioni dell'utente (proprie e dei membri della famiglia)
  -- Importante: eliminiamo esplicitamente anche quelle dei membri della famiglia
  DELETE FROM reviews WHERE customer_id = user_profile_id;
  DELETE FROM reviews WHERE family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = user_profile_id
  );

  -- Elimina tutti i messaggi degli annunci classificati
  DELETE FROM ad_messages WHERE conversation_id IN (
    SELECT c.id FROM ad_conversations c
    JOIN classified_ads ca ON c.ad_id = ca.id
    WHERE ca.user_id = user_profile_id
  );
  
  DELETE FROM ad_messages WHERE sender_id = user_profile_id;
  DELETE FROM ad_conversations WHERE buyer_id = user_profile_id OR seller_id = user_profile_id;
  
  -- Elimina i messaggi generici
  DELETE FROM messages WHERE sender_id = user_profile_id;
  DELETE FROM conversations WHERE participant1_id = user_profile_id OR participant2_id = user_profile_id;
  
  -- Elimina TUTTI gli annunci classificati (propri e dei membri della famiglia)
  DELETE FROM classified_ads WHERE user_id = user_profile_id;

  -- Elimina le visualizzazioni degli annunci classificati
  DELETE FROM classified_ad_views WHERE user_id = user_profile_id;

  -- Elimina l'attività utente e i log
  DELETE FROM user_activity WHERE user_id = user_profile_id;
  DELETE FROM activity_log WHERE user_id = user_profile_id;
  
  -- Elimina i rewards
  DELETE FROM user_rewards WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE CONTENUTI BUSINESS
  -- ========================================

  IF user_business_id IS NOT NULL THEN
    -- Elimina le risposte alle recensioni
    DELETE FROM review_responses WHERE business_id = user_business_id;
    
    -- Elimina i messaggi relativi agli annunci di lavoro
    DELETE FROM job_offer_messages WHERE conversation_id IN (
      SELECT id FROM job_offer_conversations WHERE job_posting_id IN (
        SELECT id FROM job_postings WHERE business_id = user_business_id
      )
    );
    
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
    
    -- Elimina i prodotti dell'azienda
    DELETE FROM products WHERE business_id = user_business_id;
    
    -- Elimina gli annunci di lavoro
    DELETE FROM job_postings WHERE business_id = user_business_id;
    
    -- Elimina gli sconti
    DELETE FROM discounts WHERE business_id = user_business_id;
    
    -- Elimina le sedi aziendali
    DELETE FROM business_locations WHERE business_id = user_business_id;
    
    -- Elimina l'azienda
    DELETE FROM businesses WHERE id = user_business_id;
  END IF;

  -- ========================================
  -- ELIMINAZIONE JOB SEEKING
  -- ========================================

  -- Elimina le richieste di lavoro (proprie e dei membri della famiglia)
  DELETE FROM job_requests WHERE customer_id = user_profile_id;
  
  -- Elimina i messaggi dei job seeker
  DELETE FROM job_seeker_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni dei job seeker
  DELETE FROM job_seeker_conversations WHERE employer_id = user_profile_id OR seeker_id = user_profile_id;
  
  -- Elimina gli annunci job seeker
  DELETE FROM job_seekers WHERE user_id = user_profile_id;
  
  -- Elimina i messaggi nelle conversazioni di job offer
  DELETE FROM job_offer_messages WHERE sender_id = user_profile_id;
  
  -- Elimina le conversazioni di job offer
  DELETE FROM job_offer_conversations WHERE applicant_id = user_profile_id OR employer_id = user_profile_id;
  
  -- Elimina le application inviate dall'utente
  DELETE FROM job_applications WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE SEGNALAZIONI E NOTIFICHE
  -- ========================================

  -- Elimina le segnalazioni fatte dall'utente
  DELETE FROM reports WHERE reporter_id = user_profile_id;

  -- Elimina le notifiche
  DELETE FROM notifications WHERE user_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE ABBONAMENTI E FAMIGLIA
  -- ========================================

  -- Elimina gli abbonamenti
  DELETE FROM subscriptions WHERE customer_id = user_profile_id;

  -- Elimina i membri della famiglia
  -- IMPORTANTE: Quando eliminiamo i membri della famiglia, i seguenti contenuti vengono
  -- eliminati AUTOMATICAMENTE grazie ai vincoli ON DELETE CASCADE:
  -- - classified_ads con family_member_id (quelli creati dai membri)
  -- - discount_redemptions con family_member_id
  -- - favorite_businesses con family_member_id
  -- - favorite_classified_ads con family_member_id
  -- - favorite_job_postings con family_member_id
  -- - job_requests con family_member_id
  DELETE FROM customer_family_members WHERE customer_id = user_profile_id;

  -- ========================================
  -- ELIMINAZIONE PROFILO E ACCOUNT AUTH
  -- ========================================

  -- Elimina il profilo (questo potrebbe eliminare l'utente auth grazie a ON DELETE CASCADE)
  DELETE FROM profiles WHERE id = user_profile_id;

  -- Elimina l'utente auth (se profiles non lo ha già fatto)
  DELETE FROM auth.users WHERE id = user_profile_id;

  RAISE NOTICE 'Account eliminato completamente: %', user_profile_id;

END;
$$;

-- Permetti agli utenti autenticati di eseguire questa funzione
GRANT EXECUTE ON FUNCTION delete_user_account() TO authenticated;

-- Commento sulla funzione
COMMENT ON FUNCTION delete_user_account() IS 'Elimina completamente l''account utente e TUTTI i contenuti associati, inclusi membri della famiglia, recensioni, annunci, messaggi, preferiti, e tutto il resto. Eliminazione PERMANENTE e IRREVERSIBILE.';


-- ============================================================
-- FILE: 20260217094919_add_top_businesses_by_positive_reviews_function.sql
-- ============================================================
/*
  # Funzione per Recuperare Attività con Più Recensioni Positive

  1. Nuova Funzione
    - `get_top_businesses_by_positive_reviews(limit_count)` ritorna le attività con più recensioni positive
    - Considera "positive" le recensioni con overall_rating >= 4
    - Ordina per numero di recensioni positive (discendente)
    - Include anche il rating medio e il totale recensioni
  
  2. Utilizzo
    - Nella homepage per mostrare "Attività in Evidenza"
    - Mostra le attività locali che hanno ricevuto più feedback positivi
  
  3. Performance
    - Utilizza indici esistenti su reviews(business_location_id, overall_rating)
    - Filtra solo recensioni approvate
*/

-- Crea la funzione per ottenere le attività con più recensioni positive
CREATE OR REPLACE FUNCTION get_top_businesses_by_positive_reviews(
  limit_count INTEGER DEFAULT 8
)
RETURNS TABLE (
  business_id uuid,
  business_name text,
  category_id uuid,
  category_name text,
  city text,
  province text,
  region text,
  address text,
  avatar_url text,
  positive_review_count bigint,
  total_review_count bigint,
  avg_rating numeric
)
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
  RETURN QUERY
  WITH positive_reviews AS (
    -- Conta le recensioni positive (rating >= 4) per ogni business_location_id
    SELECT 
      COALESCE(r.business_location_id, r.unclaimed_business_location_id) as location_id,
      COUNT(*) FILTER (WHERE r.overall_rating >= 4) as positive_count,
      COUNT(*) as total_count,
      AVG(r.overall_rating) as avg_rating
    FROM reviews r
    WHERE r.review_status = 'approved'
    GROUP BY COALESCE(r.business_location_id, r.unclaimed_business_location_id)
    HAVING COUNT(*) FILTER (WHERE r.overall_rating >= 4) > 0
  ),
  -- Prendi dalle business_locations (attività verificate)
  verified_businesses AS (
    SELECT 
      bl.business_id,
      b.name as business_name,
      b.category_id,
      bc.name as category_name,
      bl.city,
      bl.province,
      bl.region,
      bl.address,
      bl.avatar_url,
      pr.positive_count,
      pr.total_count,
      pr.avg_rating
    FROM business_locations bl
    JOIN businesses b ON b.id = bl.business_id
    LEFT JOIN business_categories bc ON bc.id = b.category_id
    JOIN positive_reviews pr ON pr.location_id = bl.id
    WHERE b.is_claimed = true
  ),
  -- Prendi dalle unclaimed_business_locations (attività non verificate)
  unverified_businesses AS (
    SELECT 
      ubl.id as business_id,
      ubl.name as business_name,
      ubl.category_id,
      bc.name as category_name,
      ubl.city,
      ubl.province,
      ubl.region,
      ubl.address,
      ubl.avatar_url,
      pr.positive_count,
      pr.total_count,
      pr.avg_rating
    FROM unclaimed_business_locations ubl
    LEFT JOIN business_categories bc ON bc.id = ubl.category_id
    JOIN positive_reviews pr ON pr.location_id = ubl.id
  ),
  -- Unisci entrambe le fonti
  all_businesses AS (
    SELECT * FROM verified_businesses
    UNION ALL
    SELECT * FROM unverified_businesses
  )
  -- Seleziona e ordina per recensioni positive
  SELECT 
    ab.business_id,
    ab.business_name,
    ab.category_id,
    ab.category_name,
    ab.city,
    ab.province,
    ab.region,
    ab.address,
    ab.avatar_url,
    ab.positive_count as positive_review_count,
    ab.total_count as total_review_count,
    ROUND(ab.avg_rating, 1) as avg_rating
  FROM all_businesses ab
  ORDER BY ab.positive_count DESC, ab.avg_rating DESC
  LIMIT limit_count;
END;
$$;

-- Permetti l'esecuzione pubblica (dati già filtrati)
GRANT EXECUTE ON FUNCTION get_top_businesses_by_positive_reviews TO authenticated, anon;

COMMENT ON FUNCTION get_top_businesses_by_positive_reviews IS 
'Ritorna le attività (verificate e non) con il maggior numero di recensioni positive (rating >= 4). 
Include sia business_locations che unclaimed_business_locations.';


-- ============================================================
-- FILE: 20260217095103_fix_top_businesses_function_column_names.sql
-- ============================================================
/*
  # Correggi Funzione Top Businesses - Nomi Colonne

  1. Problema Risolto
    - unclaimed_business_locations non ha colonna 'address' ma 'street'
    - unclaimed_business_locations non ha colonna 'avatar_url'
  
  2. Modifiche
    - Usa 'street' per unclaimed_business_locations
    - Imposta avatar_url a NULL per unclaimed_business_locations
*/

-- Elimina la vecchia funzione
DROP FUNCTION IF EXISTS get_top_businesses_by_positive_reviews(INTEGER);

-- Crea la funzione corretta
CREATE OR REPLACE FUNCTION get_top_businesses_by_positive_reviews(
  limit_count INTEGER DEFAULT 8
)
RETURNS TABLE (
  business_id uuid,
  business_name text,
  category_id uuid,
  category_name text,
  city text,
  province text,
  region text,
  address text,
  avatar_url text,
  positive_review_count bigint,
  total_review_count bigint,
  avg_rating numeric
)
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
  RETURN QUERY
  WITH positive_reviews AS (
    -- Conta le recensioni positive (rating >= 4) per ogni business_location_id
    SELECT 
      COALESCE(r.business_location_id, r.unclaimed_business_location_id) as location_id,
      COUNT(*) FILTER (WHERE r.overall_rating >= 4) as positive_count,
      COUNT(*) as total_count,
      AVG(r.overall_rating) as avg_rating
    FROM reviews r
    WHERE r.review_status = 'approved'
    GROUP BY COALESCE(r.business_location_id, r.unclaimed_business_location_id)
    HAVING COUNT(*) FILTER (WHERE r.overall_rating >= 4) > 0
  ),
  -- Prendi dalle business_locations (attività verificate)
  verified_businesses AS (
    SELECT 
      bl.business_id,
      b.name as business_name,
      b.category_id,
      bc.name as category_name,
      bl.city,
      bl.province,
      bl.region,
      bl.address,
      bl.avatar_url,
      pr.positive_count,
      pr.total_count,
      pr.avg_rating
    FROM business_locations bl
    JOIN businesses b ON b.id = bl.business_id
    LEFT JOIN business_categories bc ON bc.id = b.category_id
    JOIN positive_reviews pr ON pr.location_id = bl.id
    WHERE b.is_claimed = true
  ),
  -- Prendi dalle unclaimed_business_locations (attività non verificate)
  unverified_businesses AS (
    SELECT 
      ubl.id as business_id,
      ubl.name as business_name,
      ubl.category_id,
      bc.name as category_name,
      ubl.city,
      ubl.province,
      ubl.region,
      ubl.street as address,
      NULL::text as avatar_url,
      pr.positive_count,
      pr.total_count,
      pr.avg_rating
    FROM unclaimed_business_locations ubl
    LEFT JOIN business_categories bc ON bc.id = ubl.category_id
    JOIN positive_reviews pr ON pr.location_id = ubl.id
  ),
  -- Unisci entrambe le fonti
  all_businesses AS (
    SELECT * FROM verified_businesses
    UNION ALL
    SELECT * FROM unverified_businesses
  )
  -- Seleziona e ordina per recensioni positive
  SELECT 
    ab.business_id,
    ab.business_name,
    ab.category_id,
    ab.category_name,
    ab.city,
    ab.province,
    ab.region,
    ab.address,
    ab.avatar_url,
    ab.positive_count as positive_review_count,
    ab.total_count as total_review_count,
    ROUND(ab.avg_rating, 1) as avg_rating
  FROM all_businesses ab
  ORDER BY ab.positive_count DESC, ab.avg_rating DESC
  LIMIT limit_count;
END;
$$;

-- Permetti l'esecuzione pubblica (dati già filtrati)
GRANT EXECUTE ON FUNCTION get_top_businesses_by_positive_reviews TO authenticated, anon;

COMMENT ON FUNCTION get_top_businesses_by_positive_reviews IS 
'Ritorna le attività (verificate e non) con il maggior numero di recensioni positive (rating >= 4). 
Include sia business_locations che unclaimed_business_locations.';


-- ============================================================
-- FILE: 20260217101331_add_public_profile_view_policy.sql
-- ============================================================
/*
  # Add Public Profile View Policy

  ## Changes
  - Add policy to allow authenticated users to view basic profile information of other users
  - This is needed for job_seekers listings where we need to display the name of the person who created the ad

  ## Security
  - Only allows SELECT operations
  - Only for authenticated users
  - Users can see basic profile info (full_name, nickname) of others
*/

-- Allow authenticated users to view all profiles (basic info)
-- This is needed for job seekers, reviews, and other features where we display user names
CREATE POLICY "Authenticated users can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);


-- ============================================================
-- FILE: 20260217144718_fix_job_seekers_foreign_key_to_profiles.sql
-- ============================================================
/*
  # Fix job_seekers foreign key to profiles

  1. Changes
    - Add foreign key constraint from job_seekers.user_id to profiles.id
    - This enables Supabase queries to properly join job_seekers with profiles data
  
  2. Security
    - No RLS changes needed - existing policies remain unchanged
*/

-- Add foreign key constraint if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'job_seekers_user_id_fkey' 
    AND table_name = 'job_seekers'
  ) THEN
    ALTER TABLE job_seekers 
    ADD CONSTRAINT job_seekers_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
  END IF;
END $$;


-- ============================================================
-- FILE: 20260217161908_fix_job_seekers_profiles_visibility.sql
-- ============================================================
/*
  # Fix Job Seekers Profile Visibility

  1. Changes
    - Add policy to allow public to view basic profile info (nickname, full_name) for users with active job seeker ads
    - This fixes the issue where job seeker cards don't display because the profiles join is blocked by RLS

  2. Security
    - Only allows viewing basic profile information (nickname, full_name)
    - Only for profiles that have active job seeker ads
    - Does not expose sensitive profile data
*/

-- Drop existing policy if it exists, then create new one
DO $$
BEGIN
  DROP POLICY IF EXISTS "Public can view profiles with active job seeker ads" ON profiles;
END $$;

-- Allow public to view profiles of users with active job seeker ads
CREATE POLICY "Public can view profiles with active job seeker ads"
  ON profiles
  FOR SELECT
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM job_seekers
      WHERE job_seekers.user_id = profiles.id
      AND job_seekers.status = 'active'
    )
  );


-- ============================================================
-- FILE: 20260217162547_add_category_to_job_postings.sql
-- ============================================================
/*
  # Add Category to Job Postings

  1. Changes
    - Add category_id column to job_postings table to categorize job offers
    - Add foreign key constraint to business_categories
    - Create index for performance

  2. Security
    - No RLS changes needed, inherits existing policies
*/

-- Add category_id to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN category_id uuid REFERENCES business_categories(id);
    CREATE INDEX IF NOT EXISTS idx_job_postings_category_id ON job_postings(category_id);
  END IF;
END $$;


