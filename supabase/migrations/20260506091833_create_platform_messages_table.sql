/*
  # Crea tabella platform_messages

  ## Descrizione
  Tabella per i messaggi inviati dagli utenti tramite il form nella pagina Contatti.
  Gli admin possono visualizzare, rispondere e archiviare i messaggi.

  ## Tabella
  - `platform_messages`: messaggi di contatto dalla pagina pubblica
    - id, name, email, subject, message (dati del mittente)
    - user_id (opzionale, se l'utente è loggato)
    - status: 'unread' | 'read' | 'replied' | 'archived'
    - admin_reply: risposta dell'admin
    - replied_at, replied_by (user_id dell'admin)
    - created_at

  ## Sicurezza
  - Chiunque può inserire messaggi (form pubblico)
  - Solo gli admin possono leggere e aggiornare
*/

CREATE TABLE IF NOT EXISTS platform_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  subject text NOT NULL,
  message text NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  status text NOT NULL DEFAULT 'unread' CHECK (status IN ('unread', 'read', 'replied', 'archived')),
  admin_reply text,
  replied_at timestamptz,
  replied_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE platform_messages ENABLE ROW LEVEL SECURITY;

-- Chiunque può inserire un messaggio (form pubblico)
CREATE POLICY "Anyone can send a platform message"
  ON platform_messages FOR INSERT
  TO public
  WITH CHECK (true);

-- Solo admin possono leggere i messaggi
CREATE POLICY "Admins can read all platform messages"
  ON platform_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
  );

-- Solo admin possono aggiornare (rispondere, archiviare)
CREATE POLICY "Admins can update platform messages"
  ON platform_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
  );

CREATE INDEX IF NOT EXISTS idx_platform_messages_status ON platform_messages(status);
CREATE INDEX IF NOT EXISTS idx_platform_messages_created_at ON platform_messages(created_at DESC);
