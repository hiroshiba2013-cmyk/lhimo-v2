import { useState, useEffect } from 'react';
import { Mail, MailOpen, Archive, Reply, Search, ChevronDown, ChevronUp, Send, Clock, User, X, RefreshCw, Filter } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { format } from 'date-fns';
import { it } from 'date-fns/locale';
import { useToast } from '../common/Toast';

const SUBJECT_FILTERS = [
  'Informazioni generali',
  'Problemi tecnici',
  'Segnalazione contenuto',
  'Richiesta rimborso',
  'Collaborazione / Partnership',
  'Altro',
];

interface PlatformMessage {
  id: string;
  name: string;
  email: string;
  subject: string;
  message: string;
  user_id: string | null;
  status: 'unread' | 'read' | 'replied' | 'archived';
  admin_reply: string | null;
  replied_at: string | null;
  created_at: string;
}

const STATUS_LABELS: Record<string, string> = {
  unread: 'Non letto',
  read: 'Letto',
  replied: 'Risposto',
  archived: 'Archiviato',
};

const STATUS_COLORS: Record<string, string> = {
  unread: 'bg-blue-100 text-blue-700',
  read: 'bg-gray-100 text-gray-600',
  replied: 'bg-green-100 text-green-700',
  archived: 'bg-amber-100 text-amber-700',
};

interface Props {
  adminId: string;
}

export function PlatformMessagesSection({ adminId }: Props) {
  const { showToast } = useToast();
  const [messages, setMessages] = useState<PlatformMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<string>('all');
  const [subjectFilter, setSubjectFilter] = useState<string>('');
  const [nameFilter, setNameFilter] = useState('');
  const [emailFilter, setEmailFilter] = useState('');
  const [search, setSearch] = useState('');
  const [expanded, setExpanded] = useState<string | null>(null);
  const [replyText, setReplyText] = useState<Record<string, string>>({});
  const [replying, setReplying] = useState<string | null>(null);
  const [counts, setCounts] = useState({ unread: 0, read: 0, replied: 0, archived: 0 });
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    loadMessages();
  }, [filter]);

  const loadMessages = async () => {
    setLoading(true);
    let query = supabase
      .from('platform_messages')
      .select('*')
      .order('created_at', { ascending: false });

    if (filter !== 'all') query = query.eq('status', filter);

    const { data } = await query;
    setMessages(data || []);

    // Load counts
    const { data: all } = await supabase.from('platform_messages').select('status');
    if (all) {
      setCounts({
        unread: all.filter(m => m.status === 'unread').length,
        read: all.filter(m => m.status === 'read').length,
        replied: all.filter(m => m.status === 'replied').length,
        archived: all.filter(m => m.status === 'archived').length,
      });
    }

    setLoading(false);
  };

  const openMessage = async (msg: PlatformMessage) => {
    const isOpen = expanded === msg.id;
    setExpanded(isOpen ? null : msg.id);

    if (!isOpen && msg.status === 'unread') {
      await supabase.from('platform_messages').update({ status: 'read' }).eq('id', msg.id);
      setMessages(prev => prev.map(m => m.id === msg.id ? { ...m, status: 'read' } : m));
      setCounts(prev => ({ ...prev, unread: prev.unread - 1, read: prev.read + 1 }));
    }
  };

  const sendReply = async (msg: PlatformMessage) => {
    const text = replyText[msg.id]?.trim();
    if (!text) return;

    setReplying(msg.id);
    const { error } = await supabase.from('platform_messages').update({
      status: 'replied',
      admin_reply: text,
      replied_at: new Date().toISOString(),
      replied_by: adminId,
    }).eq('id', msg.id);

    setReplying(null);
    if (error) { showToast('Errore durante il salvataggio della risposta.', 'error'); return; }

    setMessages(prev => prev.map(m => m.id === msg.id
      ? { ...m, status: 'replied', admin_reply: text, replied_at: new Date().toISOString() }
      : m
    ));
    setReplyText(prev => ({ ...prev, [msg.id]: '' }));
    await loadMessages();
  };

  const updateStatus = async (id: string, status: PlatformMessage['status']) => {
    await supabase.from('platform_messages').update({ status }).eq('id', id);
    setMessages(prev => prev.map(m => m.id === id ? { ...m, status } : m));
    await loadMessages();
  };

  const activeFiltersCount = [nameFilter, emailFilter, subjectFilter].filter(Boolean).length;

  const filtered = messages.filter(m => {
    if (search) {
      const q = search.toLowerCase();
      if (!m.name.toLowerCase().includes(q) && !m.email.toLowerCase().includes(q) && !m.subject.toLowerCase().includes(q) && !m.message.toLowerCase().includes(q)) return false;
    }
    if (nameFilter && !m.name.toLowerCase().includes(nameFilter.toLowerCase())) return false;
    if (emailFilter && !m.email.toLowerCase().includes(emailFilter.toLowerCase())) return false;
    if (subjectFilter && m.subject !== subjectFilter) return false;
    return true;
  });

  const clearAllFilters = () => {
    setNameFilter('');
    setEmailFilter('');
    setSubjectFilter('');
    setSearch('');
    setFilter('all');
  };

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
        <div className="relative z-10 flex items-center justify-between flex-wrap gap-4">
          <div>
            <p className="text-gray-400 text-xs font-semibold uppercase tracking-widest mb-1">
              Comunicazioni
            </p>
            <h2 className="text-2xl font-bold text-white mb-3">Messaggi Piattaforma</h2>
            <div className="flex flex-wrap gap-2">
              <span className="inline-flex items-center gap-1.5 bg-blue-500/20 text-blue-300 text-xs font-semibold px-3 py-1 rounded-full border border-blue-500/30">
                <Mail className="w-3 h-3" />
                {counts.unread} non letti
              </span>
              <span className="inline-flex items-center gap-1.5 bg-gray-500/20 text-gray-300 text-xs font-semibold px-3 py-1 rounded-full border border-gray-500/30">
                <MailOpen className="w-3 h-3" />
                {counts.read} letti
              </span>
              <span className="inline-flex items-center gap-1.5 bg-green-500/20 text-green-300 text-xs font-semibold px-3 py-1 rounded-full border border-green-500/30">
                <Reply className="w-3 h-3" />
                {counts.replied} risposti
              </span>
              <span className="inline-flex items-center gap-1.5 bg-amber-500/20 text-amber-300 text-xs font-semibold px-3 py-1 rounded-full border border-amber-500/30">
                <Archive className="w-3 h-3" />
                {counts.archived} archiviati
              </span>
            </div>
          </div>
          <button
            onClick={loadMessages}
            className="flex items-center gap-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl px-4 py-2 text-sm transition-colors"
          >
            <RefreshCw className="w-4 h-4" />
            Aggiorna
          </button>
        </div>
      </div>

      {/* Status filter tabs */}
      <div className="flex flex-wrap gap-2">
        {[
          { key: 'all', label: 'Tutti' },
          { key: 'unread', label: 'Non letto' },
          { key: 'read', label: 'Letto' },
          { key: 'replied', label: 'Risposto' },
          { key: 'archived', label: 'Archiviato' },
        ].map(({ key, label }) => (
          <button
            key={key}
            onClick={() => setFilter(key)}
            className={`rounded-xl px-3 py-1.5 text-sm font-medium transition-colors ${
              filter === key
                ? 'bg-gray-900 text-white'
                : 'bg-white border border-gray-200 text-gray-600 hover:border-gray-300 hover:bg-gray-50'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {/* Search bar + toggle filtri */}
      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="Ricerca rapida per nome, email, oggetto, testo..."
            value={search}
            onChange={e => setSearch(e.target.value)}
            className="w-full pl-9 pr-4 py-2.5 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none bg-white"
          />
          {search && (
            <button onClick={() => setSearch('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
              <X className="w-4 h-4" />
            </button>
          )}
        </div>
        <button
          onClick={() => setShowFilters(v => !v)}
          className={`flex items-center gap-2 px-4 py-2.5 rounded-lg border text-sm font-medium transition-colors ${
            showFilters || activeFiltersCount > 0
              ? 'bg-blue-50 border-blue-300 text-blue-700'
              : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'
          }`}
        >
          <Filter className="w-4 h-4" />
          Filtri
          {activeFiltersCount > 0 && (
            <span className="bg-blue-600 text-white text-xs font-bold px-1.5 py-0.5 rounded-full">
              {activeFiltersCount}
            </span>
          )}
        </button>
      </div>

      {/* Pannello filtri avanzati */}
      {showFilters && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-4 space-y-5">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-semibold text-gray-700 flex items-center gap-2">
              <Filter className="w-4 h-4 text-gray-400" />
              Filtri avanzati
            </h3>
            {activeFiltersCount > 0 && (
              <button
                onClick={clearAllFilters}
                className="text-xs text-red-600 hover:text-red-700 font-medium flex items-center gap-1"
              >
                <X className="w-3 h-3" />
                Azzera filtri
              </button>
            )}
          </div>

          {/* Nome e Email */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-medium text-gray-500 uppercase tracking-wide mb-1.5">
                Nome utente
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
                <input
                  type="text"
                  placeholder="Filtra per nome..."
                  value={nameFilter}
                  onChange={e => setNameFilter(e.target.value)}
                  className="w-full pl-8 pr-8 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none bg-white"
                />
                {nameFilter && (
                  <button onClick={() => setNameFilter('')} className="absolute right-2.5 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                    <X className="w-3.5 h-3.5" />
                  </button>
                )}
              </div>
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 uppercase tracking-wide mb-1.5">
                Email
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
                <input
                  type="text"
                  placeholder="Filtra per email..."
                  value={emailFilter}
                  onChange={e => setEmailFilter(e.target.value)}
                  className="w-full pl-8 pr-8 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none bg-white"
                />
                {emailFilter && (
                  <button onClick={() => setEmailFilter('')} className="absolute right-2.5 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                    <X className="w-3.5 h-3.5" />
                  </button>
                )}
              </div>
            </div>
          </div>

          {/* Oggetto — pill buttons */}
          <div>
            <label className="block text-xs font-medium text-gray-500 uppercase tracking-wide mb-2">
              Oggetto del messaggio
            </label>
            <div className="flex flex-wrap gap-2">
              <button
                onClick={() => setSubjectFilter('')}
                className={`px-3 py-1.5 rounded-full text-sm font-medium border transition-colors ${
                  subjectFilter === ''
                    ? 'bg-gray-800 text-white border-gray-800'
                    : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'
                }`}
              >
                Tutti
              </button>
              {SUBJECT_FILTERS.map(s => (
                <button
                  key={s}
                  onClick={() => setSubjectFilter(subjectFilter === s ? '' : s)}
                  className={`px-3 py-1.5 rounded-full text-sm font-medium border transition-colors ${
                    subjectFilter === s
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'bg-white text-gray-600 border-gray-200 hover:border-blue-300 hover:text-blue-600'
                  }`}
                >
                  {s}
                </button>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Riepilogo filtri attivi */}
      {(activeFiltersCount > 0 || search) && (
        <div className="flex items-center gap-2 flex-wrap text-sm">
          <span className="text-gray-500">Filtri attivi:</span>
          {search && (
            <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-700 px-2.5 py-1 rounded-full text-xs font-medium">
              Testo: "{search}"
              <button onClick={() => setSearch('')}><X className="w-3 h-3" /></button>
            </span>
          )}
          {nameFilter && (
            <span className="inline-flex items-center gap-1 bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full text-xs font-medium">
              Nome: "{nameFilter}"
              <button onClick={() => setNameFilter('')}><X className="w-3 h-3" /></button>
            </span>
          )}
          {emailFilter && (
            <span className="inline-flex items-center gap-1 bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full text-xs font-medium">
              Email: "{emailFilter}"
              <button onClick={() => setEmailFilter('')}><X className="w-3 h-3" /></button>
            </span>
          )}
          {subjectFilter && (
            <span className="inline-flex items-center gap-1 bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full text-xs font-medium">
              Oggetto: "{subjectFilter}"
              <button onClick={() => setSubjectFilter('')}><X className="w-3 h-3" /></button>
            </span>
          )}
          <span className="text-gray-400 text-xs ml-auto">{filtered.length} risultati</span>
        </div>
      )}

      {/* Message list */}
      {loading ? (
        <div className="flex items-center justify-center py-16">
          <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white border border-gray-200 rounded-xl p-12 text-center">
          <Mail className="w-10 h-10 text-gray-300 mx-auto mb-3" />
          <p className="text-gray-500 font-medium">Nessun messaggio trovato</p>
          {search && <p className="text-sm text-gray-400 mt-1">Prova a modificare la ricerca</p>}
        </div>
      ) : (
        <div className="space-y-2">
          {filtered.map(msg => {
            const isExpanded = expanded === msg.id;
            const isUnread = msg.status === 'unread';

            return (
              <div
                key={msg.id}
                className="bg-white rounded-2xl border border-gray-100 shadow-sm mb-3 overflow-hidden"
              >
                {/* Row header */}
                <button
                  onClick={() => openMessage(msg)}
                  className="w-full text-left px-5 py-4 flex items-center gap-4 hover:bg-gray-50 transition-colors"
                >
                  {/* Status dot */}
                  <div className={`w-2 h-2 rounded-full flex-shrink-0 ${isUnread ? 'bg-blue-500' : 'bg-transparent'}`} />

                  {/* Avatar */}
                  <div className="w-9 h-9 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center flex-shrink-0">
                    <span className="text-white text-sm font-bold">{msg.name.charAt(0).toUpperCase()}</span>
                  </div>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className={`text-sm font-semibold ${isUnread ? 'text-gray-900' : 'text-gray-700'}`}>{msg.name}</span>
                      <span className="text-xs text-gray-400">{msg.email}</span>
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${STATUS_COLORS[msg.status]}`}>
                        {STATUS_LABELS[msg.status]}
                      </span>
                    </div>
                    <p className={`text-sm mt-0.5 truncate ${isUnread ? 'font-medium text-gray-800' : 'text-gray-500'}`}>
                      {msg.subject} — <span className="font-normal text-gray-400">{msg.message}</span>
                    </p>
                  </div>

                  <div className="flex items-center gap-3 flex-shrink-0">
                    <span className="text-xs text-gray-400 whitespace-nowrap hidden sm:block">
                      {format(new Date(msg.created_at), 'd MMM yyyy', { locale: it })}
                    </span>
                    {isExpanded ? <ChevronUp className="w-4 h-4 text-gray-400" /> : <ChevronDown className="w-4 h-4 text-gray-400" />}
                  </div>
                </button>

                {/* Expanded content */}
                {isExpanded && (
                  <div className="bg-gray-50 border-t border-gray-100 p-5 space-y-5">
                    {/* Message body */}
                    <div className="bg-white rounded-lg border border-gray-200 p-4 space-y-3">
                      <div className="flex items-center gap-2 text-xs text-gray-500 flex-wrap">
                        <User className="w-3.5 h-3.5" />
                        <span className="font-medium text-gray-700">{msg.name}</span>
                        <span>&lt;{msg.email}&gt;</span>
                        <span>·</span>
                        <Clock className="w-3.5 h-3.5" />
                        <span>{format(new Date(msg.created_at), 'd MMMM yyyy, HH:mm', { locale: it })}</span>
                        {msg.user_id && (
                          <span className="ml-auto bg-blue-50 text-blue-600 px-2 py-0.5 rounded text-xs font-medium">Utente registrato</span>
                        )}
                      </div>
                      <div className="border-t border-gray-100 pt-3">
                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Oggetto</p>
                        <p className="text-sm font-medium text-gray-900">{msg.subject}</p>
                      </div>
                      <div>
                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Messaggio</p>
                        <p className="text-sm text-gray-700 whitespace-pre-wrap leading-relaxed">{msg.message}</p>
                      </div>
                    </div>

                    {/* Previous reply */}
                    {msg.admin_reply && (
                      <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                        <div className="flex items-center gap-2 text-xs text-green-700 font-semibold mb-2">
                          <Reply className="w-3.5 h-3.5" />
                          Risposta admin — {msg.replied_at ? format(new Date(msg.replied_at), 'd MMMM yyyy, HH:mm', { locale: it }) : ''}
                        </div>
                        <p className="text-sm text-green-900 whitespace-pre-wrap">{msg.admin_reply}</p>
                      </div>
                    )}

                    {/* Reply form */}
                    {msg.status !== 'archived' && (
                      <div className="space-y-3">
                        <label className="block text-sm font-medium text-gray-700">
                          {msg.admin_reply ? 'Aggiorna risposta' : 'Rispondi'}
                        </label>
                        <textarea
                          rows={4}
                          placeholder={`Scrivi una risposta a ${msg.name}...`}
                          value={replyText[msg.id] || msg.admin_reply || ''}
                          onChange={e => setReplyText(prev => ({ ...prev, [msg.id]: e.target.value }))}
                          className="w-full px-3 py-2.5 border border-gray-200 rounded-lg text-sm resize-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500 outline-none bg-white"
                        />
                        <div className="flex items-center gap-2 flex-wrap">
                          <button
                            onClick={() => sendReply(msg)}
                            disabled={replying === msg.id || !replyText[msg.id]?.trim()}
                            className="flex items-center gap-2 bg-green-600 hover:bg-green-700 text-white rounded-xl px-5 py-2 font-semibold text-sm transition-colors disabled:opacity-50"
                          >
                            {replying === msg.id
                              ? <div className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                              : <Send className="w-3.5 h-3.5" />
                            }
                            {msg.admin_reply ? 'Aggiorna risposta' : 'Invia risposta'}
                          </button>

                          {msg.status !== 'read' && (
                            <button
                              onClick={() => updateStatus(msg.id, 'read')}
                              className="flex items-center gap-1.5 text-sm text-gray-600 border border-gray-200 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors"
                            >
                              <MailOpen className="w-3.5 h-3.5" />
                              Segna come letto
                            </button>
                          )}

                          <button
                            onClick={() => updateStatus(msg.id, 'archived')}
                            className="flex items-center gap-1.5 text-sm text-gray-600 border border-gray-200 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors ml-auto"
                          >
                            <Archive className="w-3.5 h-3.5" />
                            Archivia
                          </button>
                        </div>
                      </div>
                    )}

                    {/* Restore from archive */}
                    {msg.status === 'archived' && (
                      <button
                        onClick={() => updateStatus(msg.id, 'read')}
                        className="text-sm text-amber-700 hover:text-amber-800 font-medium"
                      >
                        Ripristina dalla raccolta archiviata
                      </button>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
