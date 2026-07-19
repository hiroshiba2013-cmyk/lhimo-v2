
/*
# Crea tabelle conversations e messages (sistema messaggistica unificato)

## Problema
Le tabelle `conversations` e `messages` non esistono nel database.
Tutto il sistema di messaggistica dell'app era non funzionante.

## Tabelle create
- `conversations`: contiene le conversazioni tra utenti, con supporto per:
  - tipo (classified_ad, job_seeker, job_posting, auction, professional_profile)
  - family member partecipanti
  - business location partecipanti
- `messages`: messaggi dentro una conversazione, con allegati

## Funzione creata
- `get_or_create_conversation`: trova o crea una conversazione tra due utenti per un dato contesto

## Security
- RLS abilitato su entrambe le tabelle
- Policies per SELECT/INSERT/UPDATE solo ai partecipanti
*/

-- =====================================================
-- TABELLA conversations
-- =====================================================
CREATE TABLE IF NOT EXISTS public.conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  participant1_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  participant2_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  participant1_family_member_id uuid REFERENCES public.customer_family_members(id) ON DELETE SET NULL,
  participant2_family_member_id uuid REFERENCES public.customer_family_members(id) ON DELETE SET NULL,
  participant1_location_id uuid REFERENCES public.registered_business_locations(id) ON DELETE SET NULL,
  participant2_location_id uuid REFERENCES public.registered_business_locations(id) ON DELETE SET NULL,
  conversation_type text NOT NULL DEFAULT 'classified_ad',
  reference_id uuid,
  last_message_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  CONSTRAINT conversations_different_participants CHECK (participant1_id != participant2_id),
  CONSTRAINT conversations_type_check CHECK (conversation_type IN (
    'classified_ad','job_seeker','job_posting','auction','professional_profile'
  ))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_conversations_unique_nulls
  ON public.conversations (participant1_id, participant2_id, conversation_type, reference_id)
  NULLS NOT DISTINCT;

CREATE INDEX IF NOT EXISTS idx_conversations_participant1 ON public.conversations(participant1_id);
CREATE INDEX IF NOT EXISTS idx_conversations_participant2 ON public.conversations(participant2_id);
CREATE INDEX IF NOT EXISTS idx_conversations_last_message ON public.conversations(last_message_at DESC);
CREATE INDEX IF NOT EXISTS idx_conversations_type ON public.conversations(conversation_type);

-- RLS
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Participants can view their conversations" ON public.conversations;
CREATE POLICY "Participants can view their conversations"
  ON public.conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

DROP POLICY IF EXISTS "Users can create conversations" ON public.conversations;
CREATE POLICY "Users can create conversations"
  ON public.conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);

DROP POLICY IF EXISTS "Participants can update conversations" ON public.conversations;
CREATE POLICY "Participants can update conversations"
  ON public.conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

-- =====================================================
-- TABELLA messages
-- =====================================================
CREATE TABLE IF NOT EXISTS public.messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content text NOT NULL DEFAULT '',
  is_read boolean DEFAULT false,
  attachment_url text,
  attachment_type text CHECK (attachment_type IN ('cv','image')),
  attachment_name text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_messages_conversation ON public.messages(conversation_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_unread ON public.messages(conversation_id) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_messages_sender ON public.messages(sender_id);

-- RLS
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Participants can view messages" ON public.messages;
CREATE POLICY "Participants can view messages"
  ON public.messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = messages.conversation_id
      AND (c.participant1_id = auth.uid() OR c.participant2_id = auth.uid())
    )
  );

DROP POLICY IF EXISTS "Participants can send messages" ON public.messages;
CREATE POLICY "Participants can send messages"
  ON public.messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = conversation_id
      AND (c.participant1_id = auth.uid() OR c.participant2_id = auth.uid())
    )
  );

DROP POLICY IF EXISTS "Users can mark messages read" ON public.messages;
CREATE POLICY "Users can mark messages read"
  ON public.messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.conversations c
      WHERE c.id = messages.conversation_id
      AND (c.participant1_id = auth.uid() OR c.participant2_id = auth.uid())
    )
  );

-- =====================================================
-- FUNZIONE get_or_create_conversation
-- =====================================================
CREATE OR REPLACE FUNCTION public.get_or_create_conversation(
  p_user1_id uuid,
  p_user2_id uuid,
  p_conversation_type text DEFAULT 'classified_ad',
  p_reference_id uuid DEFAULT NULL,
  p_user1_family_member_id uuid DEFAULT NULL,
  p_user2_family_member_id uuid DEFAULT NULL,
  p_user2_location_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_conv_id uuid;
BEGIN
  -- Cerca conversazione esistente (bidirezionale)
  SELECT id INTO v_conv_id
  FROM public.conversations
  WHERE (
    (participant1_id = p_user1_id AND participant2_id = p_user2_id)
    OR
    (participant1_id = p_user2_id AND participant2_id = p_user1_id)
  )
  AND conversation_type = p_conversation_type
  AND (
    (reference_id IS NULL AND p_reference_id IS NULL)
    OR reference_id = p_reference_id
  )
  LIMIT 1;

  -- Se non esiste, creala
  IF v_conv_id IS NULL THEN
    INSERT INTO public.conversations (
      participant1_id,
      participant2_id,
      participant1_family_member_id,
      participant2_family_member_id,
      participant2_location_id,
      conversation_type,
      reference_id,
      last_message_at
    ) VALUES (
      p_user1_id,
      p_user2_id,
      p_user1_family_member_id,
      p_user2_family_member_id,
      p_user2_location_id,
      p_conversation_type,
      p_reference_id,
      now()
    )
    RETURNING id INTO v_conv_id;
  END IF;

  RETURN v_conv_id;
END;
$$;
