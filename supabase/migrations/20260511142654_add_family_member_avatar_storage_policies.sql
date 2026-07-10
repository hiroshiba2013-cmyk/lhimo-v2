/*
  # Add storage policies for family member avatars

  The existing avatar upload policies check that the first path segment equals auth.uid().
  Family member avatars use the path: family/{member_id}/avatar.ext
  where the first segment is "family", not the user's UUID — so uploads fail with 400.

  This migration adds INSERT, UPDATE, and DELETE policies for the family/ subfolder,
  allowing any authenticated user to manage avatars under family/ paths.
  (Ownership is enforced at the DB level via RLS on customer_family_members.)
*/

CREATE POLICY "Users can upload family member avatars"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'family'
  );

CREATE POLICY "Users can update family member avatars"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'family'
  );

CREATE POLICY "Users can delete family member avatars"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = 'family'
  );
