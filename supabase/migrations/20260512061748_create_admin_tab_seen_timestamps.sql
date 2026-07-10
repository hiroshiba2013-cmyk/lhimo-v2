/*
  # Create admin_tab_seen table

  ## Summary
  Stores per-admin, per-tab "last seen" timestamps so that informational badges
  (new users, new subscriptions) reflect items created AFTER the admin last
  visited that tab — persisted in the DB so it survives browser changes.

  ## New Table
  - `admin_tab_seen`
    - `admin_id` (uuid, FK → admins.user_id)
    - `tab` (text) — tab key e.g. 'users', 'subscriptions'
    - `seen_at` (timestamptz) — when the admin last opened this tab
    - Primary key: (admin_id, tab)

  ## Security
  - RLS enabled
  - Admins can only read/write their own rows
*/

CREATE TABLE IF NOT EXISTS admin_tab_seen (
  admin_id uuid NOT NULL REFERENCES admins(user_id) ON DELETE CASCADE,
  tab text NOT NULL,
  seen_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (admin_id, tab)
);

ALTER TABLE admin_tab_seen ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can read own tab seen"
  ON admin_tab_seen FOR SELECT
  TO authenticated
  USING (admin_id = auth.uid());

CREATE POLICY "Admin can insert own tab seen"
  ON admin_tab_seen FOR INSERT
  TO authenticated
  WITH CHECK (admin_id = auth.uid());

CREATE POLICY "Admin can update own tab seen"
  ON admin_tab_seen FOR UPDATE
  TO authenticated
  USING (admin_id = auth.uid())
  WITH CHECK (admin_id = auth.uid());
