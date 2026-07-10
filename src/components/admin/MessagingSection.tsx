import { useState, useEffect } from 'react';
import { MessageSquare, Search, AlertTriangle, Eye, Trash2, Filter, User, Calendar, Clock, X } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface Message {
  id: string;
  content: string;
  created_at: string;
  sender_id: string;
  conversation_id: string;
  is_read: boolean;
  sender?: {
    full_name: string;
    email: string;
    nickname: string | null;
  };
  conversation?: {
    id: string;
    conversation_type: string;
    reference_id: string;
    participant1: {
      full_name: string;
      email: string;
      nickname: string | null;
    };
    participant2: {
      full_name: string;
      email: string;
      nickname: string | null;
    };
  };
}

interface MessagingSectionProps {
  adminId: string;
}

export function MessagingSection({ adminId }: MessagingSectionProps) {
  const { showToast } = useToast();
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState<string>('all');
  const [selectedMessage, setSelectedMessage] = useState<Message | null>(null);
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    loadMessages();
  }, []);

  const loadMessages = async () => {
    try {
      setLoading(true);

      const { data: messagesData, error: messagesError } = await supabase
        .from('messages')
        .select('id, content, created_at, sender_id, conversation_id, is_read')
        .order('created_at', { ascending: false })
        .limit(500);

      if (messagesError) throw messagesError;

      const messagesWithDetails = await Promise.all(
        (messagesData || []).map(async (msg) => {
          const { data: sender } = await supabase
            .from('profiles')
            .select('full_name, email, nickname')
            .eq('id', msg.sender_id)
            .single();

          const { data: conversation } = await supabase
            .from('conversations')
            .select('id, conversation_type, reference_id, participant1_id, participant2_id')
            .eq('id', msg.conversation_id)
            .single();

          let conversationDetails: any = null;
          if (conversation) {
            const { data: p1 } = await supabase
              .from('profiles')
              .select('full_name, email, nickname')
              .eq('id', conversation.participant1_id)
              .single();

            const { data: p2 } = await supabase
              .from('profiles')
              .select('full_name, email, nickname')
              .eq('id', conversation.participant2_id)
              .single();

            conversationDetails = {
              ...conversation,
              participant1: p1,
              participant2: p2,
            };
          }

          return {
            ...msg,
            sender,
            conversation: conversationDetails,
          };
        })
      );

      setMessages(messagesWithDetails);
    } catch (error: any) {
      console.error('Error loading messages:', error);
      showToast('Errore nel caricamento dei messaggi', 'error');
    } finally {
      setLoading(false);
    }
  };

  const filteredMessages = messages.filter(message => {
    const matchesSearch =
      searchTerm === '' ||
      message.content.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (message.sender && (
        message.sender.full_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        message.sender.email.toLowerCase().includes(searchTerm.toLowerCase())
      ));

    const matchesType =
      filterType === 'all' ||
      (message.conversation && message.conversation.conversation_type === filterType);

    return matchesSearch && matchesType;
  });

  const deleteMessage = async (messageId: string) => {
    if (!confirm('Sei sicuro di voler eliminare questo messaggio? Questa azione è irreversibile.')) {
      return;
    }

    try {
      const { error } = await supabase
        .from('messages')
        .delete()
        .eq('id', messageId);

      if (error) throw error;

      showToast('Messaggio eliminato con successo', 'success');
      loadMessages();
      setSelectedMessage(null);
    } catch (error: any) {
      console.error('Error deleting message:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const reportMessage = async (messageId: string) => {
    const reason = prompt('Inserisci la motivazione della segnalazione:');
    if (!reason || !reason.trim()) return;

    try {
      const { error } = await supabase.from('reports').insert({
        reporter_id: adminId,
        reported_content_type: 'message',
        reported_content_id: messageId,
        reason: reason.trim(),
        status: 'pending',
      });

      if (error) throw error;

      showToast('Messaggio segnalato con successo', 'success');
    } catch (error: any) {
      console.error('Error reporting message:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('it-IT', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  };

  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString('it-IT', {
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getContextLabel = (contextType: string) => {
    switch (contextType) {
      case 'classified_ad':
        return 'Annuncio';
      case 'job_posting':
        return 'Offerta Lavoro';
      case 'job_seeker':
        return 'Cerca Lavoro';
      case 'auction':
        return 'Asta';
      default:
        return contextType || 'Sconosciuto';
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Hero banner header */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6 mb-6">
        {/* Dot overlay */}
        <div
          className="absolute inset-0 opacity-5"
          style={{
            backgroundImage: 'radial-gradient(circle, white 1px, transparent 1px)',
            backgroundSize: '28px 28px',
          }}
        />
        {/* Content */}
        <div className="relative z-10 flex items-center justify-between">
          <div>
            <p className="text-gray-400 text-xs font-semibold uppercase tracking-widest mb-1">
              Messaggistica
            </p>
            <h2 className="text-2xl font-bold text-white">Messaggi</h2>
            <div className="mt-2">
              <span className="inline-flex items-center bg-white/10 text-white text-sm font-medium px-3 py-1 rounded-full border border-white/20">
                {messages.length} totali
              </span>
            </div>
          </div>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="flex items-center gap-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl px-4 py-2 transition-colors"
          >
            <Filter className="w-5 h-5" />
            {showFilters ? 'Nascondi Filtri' : 'Mostra Filtri'}
          </button>
        </div>
      </div>

      {showFilters && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                <Search className="w-4 h-4 inline mr-1" />
                Cerca
              </label>
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Cerca per contenuto, nome o email..."
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Tipo Conversazione
              </label>
              <select
                value={filterType}
                onChange={(e) => setFilterType(e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="all">Tutti</option>
                <option value="classified_ad">Annunci</option>
                <option value="job_posting">Offerte Lavoro</option>
                <option value="job_seeker">Cerca Lavoro</option>
                <option value="auction">Aste</option>
              </select>
            </div>
          </div>

          <div className="mt-4 pt-4 border-t border-gray-200">
            <p className="text-sm text-gray-600">
              <strong className="text-gray-900">{filteredMessages.length}</strong> messaggi trovati su <strong className="text-gray-900">{messages.length}</strong> totali
            </p>
          </div>
        </div>
      )}

      {filteredMessages.length === 0 ? (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-8 text-center">
          <MessageSquare className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <p className="text-gray-600">Nessun messaggio trovato</p>
        </div>
      ) : (
        <div className="grid gap-4">
          {filteredMessages.map((message) => (
            <div key={message.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow">
              <div className="flex justify-between items-start mb-4">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <User className="w-5 h-5 text-gray-500" />
                    <h3 className="font-bold text-lg text-gray-900">
                      {message.sender ? (message.sender.nickname || message.sender.full_name) : 'Utente Sconosciuto'}
                    </h3>
                    {message.conversation && (
                      <span className="px-3 py-1 text-xs rounded-full font-medium bg-blue-100 text-blue-800">
                        {getContextLabel(message.conversation.conversation_type)}
                      </span>
                    )}
                    {!message.is_read && (
                      <span className="flex items-center gap-1.5 px-3 py-1 text-xs rounded-full font-medium bg-green-100 text-green-800">
                        <span className="relative flex h-2 w-2">
                          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                          <span className="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
                        </span>
                        Non letto
                      </span>
                    )}
                  </div>

                  <div className="flex items-center gap-4 text-sm text-gray-600 mb-2">
                    <div className="flex items-center gap-1">
                      <Calendar className="w-4 h-4" />
                      <span>{formatDate(message.created_at)}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      <span>{formatTime(message.created_at)}</span>
                    </div>
                  </div>

                  <p className="text-gray-700 line-clamp-2">{message.content}</p>
                </div>

                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setSelectedMessage(message)}
                    className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    <Eye className="w-4 h-4" />
                    Visualizza
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {selectedMessage && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-gray-800 to-gray-900 text-white px-6 py-4 rounded-t-2xl flex items-center justify-between">
              <div>
                <h3 className="text-2xl font-bold text-white">Dettaglio Messaggio</h3>
                <p className="text-sm text-gray-300 mt-1">
                  {formatDate(selectedMessage.created_at)} alle {formatTime(selectedMessage.created_at)}
                </p>
              </div>
              <button
                onClick={() => setSelectedMessage(null)}
                className="text-gray-300 hover:text-white transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="p-6 space-y-6">
              <div className="bg-gray-50 rounded-lg p-4">
                <h4 className="font-semibold text-gray-900 mb-2">Mittente</h4>
                {selectedMessage.sender ? (
                  <>
                    <p className="text-gray-700">{selectedMessage.sender.nickname || selectedMessage.sender.full_name}</p>
                    <p className="text-sm text-gray-500">{selectedMessage.sender.email}</p>
                  </>
                ) : (
                  <p className="text-gray-500">Informazioni mittente non disponibili</p>
                )}
              </div>

              {selectedMessage.conversation && (
                <div className="bg-blue-50 rounded-lg p-4">
                  <h4 className="font-semibold text-gray-900 mb-2">Conversazione</h4>
                  <div className="space-y-2 text-sm">
                    <p>
                      <span className="font-medium">Tipo:</span> {getContextLabel(selectedMessage.conversation.conversation_type)}
                    </p>
                    {selectedMessage.conversation.participant1 && (
                      <p>
                        <span className="font-medium">Partecipante 1:</span>{' '}
                        {selectedMessage.conversation.participant1.nickname || selectedMessage.conversation.participant1.full_name}
                      </p>
                    )}
                    {selectedMessage.conversation.participant2 && (
                      <p>
                        <span className="font-medium">Partecipante 2:</span>{' '}
                        {selectedMessage.conversation.participant2.nickname || selectedMessage.conversation.participant2.full_name}
                      </p>
                    )}
                  </div>
                </div>
              )}

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Contenuto Messaggio
                </label>
                <p className="text-gray-700 whitespace-pre-wrap bg-gray-50 p-4 rounded-lg">
                  {selectedMessage.content}
                </p>
              </div>

              <div className="flex gap-3 pt-6 border-t">
                <button
                  onClick={() => reportMessage(selectedMessage.id)}
                  className="flex-1 bg-yellow-600 text-white px-6 py-3 rounded-lg hover:bg-yellow-700 transition-colors flex items-center justify-center gap-2 font-semibold"
                >
                  <AlertTriangle className="w-5 h-5" />
                  Segnala
                </button>
                <button
                  onClick={() => deleteMessage(selectedMessage.id)}
                  className="flex-1 bg-red-600 text-white px-6 py-3 rounded-lg hover:bg-red-700 transition-colors flex items-center justify-center gap-2 font-semibold"
                >
                  <Trash2 className="w-5 h-5" />
                  Elimina
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
