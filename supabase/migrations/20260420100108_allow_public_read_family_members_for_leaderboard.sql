/*
  # Allow public read of family members for leaderboard

  ## Summary
  La classifica deve poter mostrare i membri della famiglia di tutti gli utenti.
  Aggiungiamo una policy che permette a tutti gli utenti autenticati di leggere
  i dati base (nome, nickname, avatar) dei membri famiglia per la classifica.
*/

CREATE POLICY "Authenticated users can view family members for leaderboard"
  ON customer_family_members
  FOR SELECT
  TO authenticated
  USING (true);
