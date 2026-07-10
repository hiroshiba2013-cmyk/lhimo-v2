/*
  # Disable points triggers for products and user_added_businesses

  ## Rationale

  The official points system is:
    - +50  Recensione con prova (approvazione staff)
    - +25  Recensione senza prova (approvazione staff)
    - +30  Referral (amico si abbona)
    - +25  Attività aggiunta con contatto (approvazione staff, unclaimed_business_locations)
    - +10  Attività aggiunta senza contatto (approvazione staff, unclaimed_business_locations)
    - +5   Annuncio pubblicato approvato (vendita/regalo/cerco)
    - Solo utenti privati (customer) partecipano

  ## What is disabled

  ### products triggers
  - `trigger_award_points_for_product` — products are not in the points system
  - `trigger_subtract_points_deleted_product` — corresponding subtraction

  ### user_added_businesses triggers
  - `trigger_award_points_user_added_business` — obsolete table; points would fire
    immediately on insert without staff approval, and without business-user guard
  - `trigger_subtract_points_user_added_business` — corresponding subtraction
*/

-- Disable product points triggers
ALTER TABLE products DISABLE TRIGGER trigger_award_points_for_product;
ALTER TABLE products DISABLE TRIGGER trigger_subtract_points_deleted_product;

-- Disable user_added_businesses points triggers (obsolete/incorrect)
ALTER TABLE user_added_businesses DISABLE TRIGGER trigger_award_points_user_added_business;
ALTER TABLE user_added_businesses DISABLE TRIGGER trigger_subtract_points_user_added_business;
