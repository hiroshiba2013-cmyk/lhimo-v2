/*
  # Add storage policies for business location avatars

  Adds INSERT, UPDATE, DELETE policies on the avatars bucket
  for files under the locations/ prefix, matching the pattern
  used by family member avatar policies.
*/

CREATE POLICY "Users can upload location avatars"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'locations'
  );

CREATE POLICY "Users can update location avatars"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'locations'
  );

CREATE POLICY "Users can delete location avatars"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'locations'
  );
