/*
  # Crea tabella di esempio Tasks

  1. Nuove Tabelle
    - `tasks`
      - `id` (uuid, primary key)
      - `title` (text, titolo del task)
      - `description` (text, descrizione)
      - `completed` (boolean, completato o no)
      - `created_at` (timestamp)
      - `user_id` (uuid, riferimento all'utente)
  
  2. Sicurezza
    - Abilita RLS sulla tabella `tasks`
    - Policy per permettere agli utenti autenticati di vedere solo i propri tasks
    - Policy per permettere agli utenti di inserire i propri tasks
    - Policy per permettere agli utenti di aggiornare i propri tasks
    - Policy per permettere agli utenti di eliminare i propri tasks
*/

CREATE TABLE IF NOT EXISTS tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text DEFAULT '',
  completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE
);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own tasks"
  ON tasks
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tasks"
  ON tasks
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks"
  ON tasks
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks"
  ON tasks
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);