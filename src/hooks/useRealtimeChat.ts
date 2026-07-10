import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { RealtimeChannel } from '@supabase/supabase-js';

interface Message {
  id: string;
  sender_id: string;
  message: string;
  created_at: string;
  is_read: boolean;
}

interface UseRealtimeChatOptions {
  conversationId: string;
  table: string;
  userId: string | null;
}

export function useRealtimeChat({ conversationId, table, userId }: UseRealtimeChatOptions) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [typing, setTyping] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!conversationId || !userId) return;

    loadMessages();

    const channel = supabase
      .channel(`chat:${conversationId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table,
          filter: `conversation_id=eq.${conversationId}`,
        },
        (payload) => {
          const newMessage = payload.new as Message;
          setMessages((prev) => {
            if (prev.some(m => m.id === newMessage.id)) {
              return prev;
            }
            return [...prev, newMessage];
          });

          if (newMessage.sender_id !== userId) {
            markAsRead(newMessage.id);
          }
        }
      )
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table,
          filter: `conversation_id=eq.${conversationId}`,
        },
        (payload) => {
          const updatedMessage = payload.new as Message;
          setMessages((prev) =>
            prev.map((msg) =>
              msg.id === updatedMessage.id ? updatedMessage : msg
            )
          );
        }
      )
      .on('presence', { event: 'sync' }, () => {
        const state = channel.presenceState();
        const typingUsers = new Set<string>();

        Object.entries(state).forEach(([key, presences]) => {
          presences.forEach((presence: any) => {
            if (presence.typing && presence.user_id !== userId) {
              typingUsers.add(presence.user_name || 'Someone');
            }
          });
        });

        setTyping(typingUsers);
      })
      .subscribe(async (status) => {
        if (status === 'SUBSCRIBED') {
          await channel.track({
            user_id: userId,
            online_at: new Date().toISOString(),
          });
        }
      });

    return () => {
      channel.unsubscribe().then(() => supabase.removeChannel(channel));
    };
  }, [conversationId, table, userId]);

  const loadMessages = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from(table)
        .select('*')
        .eq('conversation_id', conversationId)
        .order('created_at', { ascending: true });

      if (error) throw error;
      setMessages(data || []);

      const unreadMessages = data?.filter(
        (m) => m.sender_id !== userId && !m.is_read
      ) || [];

      if (unreadMessages.length > 0) {
        await supabase
          .from(table)
          .update({ is_read: true })
          .in('id', unreadMessages.map((m) => m.id));
      }
    } catch (error) {
      console.error('Error loading messages:', error);
    } finally {
      setLoading(false);
    }
  };

  const markAsRead = async (messageId: string) => {
    try {
      await supabase
        .from(table)
        .update({ is_read: true })
        .eq('id', messageId);
    } catch (error) {
      console.error('Error marking message as read:', error);
    }
  };

  const sendMessage = async (message: string) => {
    if (!message.trim() || !userId) return;

    try {
      const { error } = await supabase.from(table).insert({
        conversation_id: conversationId,
        sender_id: userId,
        message: message.trim(),
      });

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error sending message:', error);
      return false;
    }
  };

  const setTypingStatus = useCallback(
    async (isTyping: boolean, userName: string) => {
      const channel = supabase.channel(`chat:${conversationId}`);

      await channel.track({
        user_id: userId,
        user_name: userName,
        typing: isTyping,
        online_at: new Date().toISOString(),
      });
    },
    [conversationId, userId]
  );

  return {
    messages,
    typing: Array.from(typing),
    loading,
    sendMessage,
    setTypingStatus,
    refreshMessages: loadMessages,
  };
}
