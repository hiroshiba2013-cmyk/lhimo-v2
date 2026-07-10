/*
  # Aggiungi indici per chiavi esterne

  ## Modifiche
  
  Questo migration aggiunge gli indici mancanti per tutte le chiavi esterne per migliorare
  le prestazioni delle query.
  
  1. Indici per la tabella `businesses`
    - `idx_businesses_category_id` - per chiave esterna category_id
    - `idx_businesses_owner_id` - per chiave esterna owner_id
  
  2. Indici per la tabella `discounts`
    - `idx_discounts_business_id` - per chiave esterna business_id
  
  3. Indici per la tabella `job_requests`
    - `idx_job_requests_customer_id` - per chiave esterna customer_id
  
  4. Indici per la tabella `review_responses`
    - `idx_review_responses_business_id` - per chiave esterna business_id
    - `idx_review_responses_review_id` - per chiave esterna review_id
  
  5. Indici per la tabella `reviews`
    - `idx_reviews_business_id` - per chiave esterna business_id
    - `idx_reviews_customer_id` - per chiave esterna customer_id
  
  6. Indici per la tabella `subscriptions`
    - `idx_subscriptions_customer_id` - per chiave esterna customer_id
    - `idx_subscriptions_plan_id` - per chiave esterna plan_id
  
  ## Note
  
  Gli indici sulle chiavi esterne migliorano significativamente le prestazioni delle query
  che fanno JOIN o filtrano su queste colonne.
*/

-- Indici per businesses
CREATE INDEX IF NOT EXISTS idx_businesses_category_id ON businesses(category_id);
CREATE INDEX IF NOT EXISTS idx_businesses_owner_id ON businesses(owner_id);

-- Indici per discounts
CREATE INDEX IF NOT EXISTS idx_discounts_business_id ON discounts(business_id);

-- Indici per job_requests
CREATE INDEX IF NOT EXISTS idx_job_requests_customer_id ON job_requests(customer_id);

-- Indici per review_responses
CREATE INDEX IF NOT EXISTS idx_review_responses_business_id ON review_responses(business_id);
CREATE INDEX IF NOT EXISTS idx_review_responses_review_id ON review_responses(review_id);

-- Indici per reviews
CREATE INDEX IF NOT EXISTS idx_reviews_business_id ON reviews(business_id);
CREATE INDEX IF NOT EXISTS idx_reviews_customer_id ON reviews(customer_id);

-- Indici per subscriptions
CREATE INDEX IF NOT EXISTS idx_subscriptions_customer_id ON subscriptions(customer_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_plan_id ON subscriptions(plan_id);