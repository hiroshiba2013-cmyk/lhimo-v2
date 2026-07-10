/*
  # Make review-proof-documents bucket public

  ## Problem
  The bucket is private, so getPublicUrl returns URLs that are not accessible.
  Admins need to view proof documents when reviewing submissions.

  ## Changes
  1. Set the bucket to public so uploaded proof images are viewable via public URL
  2. Keep existing RLS policies for upload/delete control
*/

UPDATE storage.buckets
SET public = true
WHERE id = 'review-proof-documents';
