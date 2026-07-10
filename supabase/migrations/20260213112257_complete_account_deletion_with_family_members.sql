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
