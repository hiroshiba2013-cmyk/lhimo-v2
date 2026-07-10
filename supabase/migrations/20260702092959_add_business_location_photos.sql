-- Create business_location_photos table
CREATE TABLE business_location_photos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  location_id uuid NOT NULL REFERENCES registered_business_locations(id) ON DELETE CASCADE,
  url text NOT NULL,
  storage_path text NOT NULL,
  display_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE business_location_photos ENABLE ROW LEVEL SECURITY;

-- Anyone can view photos
CREATE POLICY "select_business_location_photos" ON business_location_photos
  FOR SELECT TO anon, authenticated USING (true);

-- Only the location owner can insert
CREATE POLICY "insert_business_location_photos" ON business_location_photos
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM registered_business_locations rbl
      JOIN registered_businesses rb ON rb.id = rbl.business_id
      WHERE rbl.id = location_id AND rb.owner_id = auth.uid()
    )
  );

-- Only the location owner can update
CREATE POLICY "update_business_location_photos" ON business_location_photos
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM registered_business_locations rbl
      JOIN registered_businesses rb ON rb.id = rbl.business_id
      WHERE rbl.id = location_id AND rb.owner_id = auth.uid()
    )
  );

-- Only the location owner can delete
CREATE POLICY "delete_business_location_photos" ON business_location_photos
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM registered_business_locations rbl
      JOIN registered_businesses rb ON rb.id = rbl.business_id
      WHERE rbl.id = location_id AND rb.owner_id = auth.uid()
    )
  );

-- Create storage bucket for business location photos
INSERT INTO storage.buckets (id, name, public)
VALUES ('business-location-photos', 'business-location-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies
CREATE POLICY "public_read_business_location_photos"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'business-location-photos');

CREATE POLICY "authenticated_upload_business_location_photos"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'business-location-photos');

CREATE POLICY "authenticated_delete_business_location_photos"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'business-location-photos');
