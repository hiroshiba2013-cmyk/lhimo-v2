/*
  # Aggiungi supporto family member per attività non rivendicate

  1. Modifiche
    - Aggiunge colonna added_by_family_member_id a unclaimed_business_locations
    - Permette di tracciare quale membro della famiglia ha aggiunto l'attività
    - Aggiorna RLS policy per permettere visualizzazione delle proprie attività

  2. Security
    - I membri della famiglia possono vedere le attività che hanno aggiunto loro
    - Il proprietario dell'account può vedere tutte le attività aggiunte dai family members
*/

-- Aggiungi colonna per tracciare quale family member ha aggiunto l'attività
ALTER TABLE unclaimed_business_locations
ADD COLUMN IF NOT EXISTS added_by_family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;

-- Crea indice per performance
CREATE INDEX IF NOT EXISTS idx_unclaimed_businesses_family_member 
ON unclaimed_business_locations(added_by_family_member_id);

-- Aggiorna policy per permettere ai family members di vedere le proprie attività
DROP POLICY IF EXISTS "Users can view own added businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can view own added businesses"
ON unclaimed_business_locations
FOR SELECT
TO authenticated
USING (
  added_by = auth.uid() 
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
);

-- Policy per inserimento con family member
DROP POLICY IF EXISTS "Users can add unclaimed businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can add unclaimed businesses"
ON unclaimed_business_locations
FOR INSERT
TO authenticated
WITH CHECK (
  added_by = auth.uid()
  OR (
    added_by_family_member_id IN (
      SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
    )
    AND added_by = auth.uid()
  )
);

-- Policy per aggiornamento
DROP POLICY IF EXISTS "Users can update own added businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can update own added businesses"
ON unclaimed_business_locations
FOR UPDATE
TO authenticated
USING (
  added_by = auth.uid()
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
)
WITH CHECK (
  added_by = auth.uid()
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
);

-- Policy per eliminazione
DROP POLICY IF EXISTS "Users can delete own added businesses" ON unclaimed_business_locations;

CREATE POLICY "Users can delete own added businesses"
ON unclaimed_business_locations
FOR DELETE
TO authenticated
USING (
  added_by = auth.uid()
  OR added_by_family_member_id IN (
    SELECT id FROM customer_family_members WHERE customer_id = auth.uid()
  )
);
