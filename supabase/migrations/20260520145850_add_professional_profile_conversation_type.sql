/*
  # Add professional_profile conversation type

  Adds 'professional_profile' to the allowed conversation_type values in the
  conversations table so that business users can start a chat from a
  professional profile page.
*/

ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_conversation_type_check;

ALTER TABLE conversations ADD CONSTRAINT conversations_conversation_type_check
  CHECK (conversation_type = ANY (ARRAY[
    'classified_ad'::text,
    'job_seeker'::text,
    'job_posting'::text,
    'auction'::text,
    'professional_profile'::text
  ]));
