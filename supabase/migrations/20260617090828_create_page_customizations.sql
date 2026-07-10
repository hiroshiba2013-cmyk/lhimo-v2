
CREATE TABLE IF NOT EXISTS page_customizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  page_key text UNIQUE NOT NULL,
  page_name text NOT NULL,
  hero_title text,
  hero_subtitle text,
  hero_image_url text,
  announcement_text text,
  announcement_active boolean DEFAULT false,
  custom_content jsonb DEFAULT '{}'::jsonb,
  updated_at timestamptz DEFAULT now(),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE page_customizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "admin_select_page_customizations" ON page_customizations FOR SELECT
  TO authenticated USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

CREATE POLICY "admin_insert_page_customizations" ON page_customizations FOR INSERT
  TO authenticated WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

CREATE POLICY "admin_update_page_customizations" ON page_customizations FOR UPDATE
  TO authenticated USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND user_type = 'admin'
    )
  ) WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

CREATE POLICY "admin_delete_page_customizations" ON page_customizations FOR DELETE
  TO authenticated USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE id = auth.uid() AND user_type = 'admin'
    )
  );

-- Public read for landing/home pages
CREATE POLICY "public_select_page_customizations" ON page_customizations FOR SELECT
  TO anon USING (true);

-- Allow authenticated non-admin users to read (for applying customizations)
CREATE POLICY "authenticated_select_page_customizations" ON page_customizations FOR SELECT
  TO authenticated USING (true);

-- Seed default pages
INSERT INTO page_customizations (page_key, page_name) VALUES
  ('landing', 'Home (senza login)'),
  ('home_authenticated', 'Home (con login)'),
  ('dashboard_private', 'Dashboard Utenti Privati'),
  ('dashboard_business', 'Dashboard Utenti Business'),
  ('jobs', 'Pagina Lavoro'),
  ('search', 'Pagina Ricerca')
ON CONFLICT (page_key) DO NOTHING;
