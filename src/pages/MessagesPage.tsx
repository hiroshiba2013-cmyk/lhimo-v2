import { useState, useEffect, useRef } from 'react';
import { Send, ArrowLeft, MessageCircle, Tag, Briefcase, Building2, Gavel, Paperclip, X, FileText, Image, Download, ChevronLeft, ChevronRight } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useToast } from '../components/common/Toast';

interface Profile {
  full_name: string;
  avatar_url: string | null;
}

interface Message {
  id: string;
  content: string;
  sender_id: string;
  created_at: string;
  is_read: boolean;
  attachment_url: string | null;
  attachment_type: 'cv' | 'image' | null;
  attachment_name: string | null;
}

interface Conversation {
  id: string;
  ad_id: string | null;
  conversation_type: string;
  reference_id: string;
  participant1_id: string;
  participant2_id: string;
  last_message_at: string;
  profiles?: Profile;
  classified_ads?: { title: string; images: string[] | null };
  job_seekers?: { title: string };
  job_postings?: { title: string; company_name: string | null };
  auctions?: { title: string };
  professional_profiles?: { profession: string | null };
  unread_count?: number;
}

const MAX_IMAGES = 5;

function isJobConversation(type: string) {
  return type === 'job_seeker' || type === 'job_posting' || type === 'professional_profile';
}
function isClassifiedConversation(type: string) {
  return type === 'classified_ad';
}

export function MessagesPage() {
  const { showToast } = useToast();
  const { user, loading: authLoading, activeProfile, profile, selectedBusinessLocationId } = useAuth();
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [selectedConversation, setSelectedConversation] = useState<string | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Attachment state
  const [cvFile, setCvFile] = useState<File | null>(null);
  const [imageFiles, setImageFiles] = useState<File[]>([]);
  const [uploadingAttachment, setUploadingAttachment] = useState(false);
  const cvInputRef = useRef<HTMLInputElement>(null);
  const imageInputRef = useRef<HTMLInputElement>(null);
  const [lightboxUrl, setLightboxUrl] = useState<string | null>(null);
  const [lightboxIndex, setLightboxIndex] = useState(0);

  const [selectedConv, setSelectedConv] = useState<Conversation | null>(null);
  const [filter, setFilter] = useState<'all' | 'classified_ad' | 'job_seeker' | 'job_posting' | 'auction'>('all');

  // Tipi di conversazione raggruppati per filtro
  const FILTER_TYPES: Record<string, string[]> = {
    classified_ad: ['classified_ad'],
    job_seeker: ['job_seeker', 'professional_profile'],
    job_posting: ['job_posting'],
    auction: ['auction'],
  };

  const matchesFilter = (convType: string, filterKey: string) => {
    if (filterKey === 'all') return true;
    return (FILTER_TYPES[filterKey] || [filterKey]).includes(convType);
  };

  useEffect(() => {
    if (authLoading) return;
    if (!user) { window.location.href = '/'; return; }

    const urlParams = new URLSearchParams(window.location.search);
    const conversationId = urlParams.get('conversation');

    loadConversations().then(() => {
      if (conversationId) setSelectedConversation(conversationId);
    });

    const channel = supabase
      .channel('conversations-changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'conversations', filter: `participant1_id=eq.${user.id}` }, () => loadConversations())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'conversations', filter: `participant2_id=eq.${user.id}` }, () => loadConversations())
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [user, authLoading, activeProfile, selectedBusinessLocationId]);

  useEffect(() => {
    if (!selectedConversation) return;
    loadMessages(selectedConversation);
    markMessagesAsRead(selectedConversation);

    const channel = supabase
      .channel(`conv-messages-${selectedConversation}`)
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'messages', filter: `conversation_id=eq.${selectedConversation}` }, () => {
        loadMessages(selectedConversation);
        markMessagesAsRead(selectedConversation);
      })
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [selectedConversation]);

  useEffect(() => { messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' }); }, [messages]);

  // Clear attachments when switching conversation
  useEffect(() => {
    setCvFile(null);
    setImageFiles([]);
  }, [selectedConversation]);

  const loadConversations = async () => {
    if (!user) return;
    try {
      setLoading(true);
      let query = supabase.from('conversations').select('*');

      if (profile?.user_type === 'customer') {
        const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;
        if (familyMemberId) {
          query = query.or(`and(participant1_id.eq.${user.id},participant1_family_member_id.eq.${familyMemberId}),and(participant2_id.eq.${user.id},participant2_family_member_id.eq.${familyMemberId})`);
        } else {
          query = query.or(`and(participant1_id.eq.${user.id},participant1_family_member_id.is.null),and(participant2_id.eq.${user.id},participant2_family_member_id.is.null)`);
        }
      } else if (profile?.user_type === 'business') {
        if (selectedBusinessLocationId) {
          // Conversazioni per la sede selezionata + senza sede + SEMPRE tutte le candidature/profili lavoro
          query = query.or(
            `and(participant1_id.eq.${user.id},participant1_location_id.eq.${selectedBusinessLocationId}),` +
            `and(participant2_id.eq.${user.id},participant2_location_id.eq.${selectedBusinessLocationId}),` +
            `and(participant1_id.eq.${user.id},participant1_location_id.is.null),` +
            `and(participant2_id.eq.${user.id},participant2_location_id.is.null),` +
            `and(participant1_id.eq.${user.id},conversation_type.in.(job_seeker,job_posting,professional_profile)),` +
            `and(participant2_id.eq.${user.id},conversation_type.in.(job_seeker,job_posting,professional_profile))`
          );
        } else {
          query = query.or(`participant1_id.eq.${user.id},participant2_id.eq.${user.id}`);
        }
      } else {
        query = query.or(`participant1_id.eq.${user.id},participant2_id.eq.${user.id}`);
      }

      query = query.order('last_message_at', { ascending: false });
      const { data, error } = await query;
      if (error) throw error;

      const conversationsWithDetails = await Promise.all(
        (data || []).map(async (conv) => {
          const otherUserId = conv.participant1_id === user.id ? conv.participant2_id : conv.participant1_id;
          const { data: profileData } = await supabase.from('profiles').select('full_name, nickname, avatar_url').eq('id', otherUserId).maybeSingle();

          let referenceData = null;
          if (conv.conversation_type === 'classified_ad') {
            const { data: adData } = await supabase.from('classified_ads').select('title, images').eq('id', conv.reference_id).maybeSingle();
            referenceData = { classified_ads: adData };
          } else if (conv.conversation_type === 'job_seeker') {
            const { data: jobSeekerData } = await supabase.from('job_seekers').select('title').eq('id', conv.reference_id).maybeSingle();
            referenceData = { job_seekers: jobSeekerData };
          } else if (conv.conversation_type === 'job_posting') {
            const { data: jobPostingData } = await supabase.from('job_postings').select('title, company_name').eq('id', conv.reference_id).maybeSingle();
            referenceData = { job_postings: jobPostingData };
          } else if (conv.conversation_type === 'auction') {
            const { data: auctionData } = await supabase.from('auctions').select('title').eq('id', conv.reference_id).maybeSingle();
            referenceData = { auctions: auctionData };
          } else if (conv.conversation_type === 'professional_profile') {
            const { data: ppData } = await supabase.from('professional_profiles').select('profession').eq('id', conv.reference_id).maybeSingle();
            referenceData = { professional_profiles: ppData };
          }

          const { count } = await supabase.from('messages').select('*', { count: 'exact', head: true }).eq('conversation_id', conv.id).eq('is_read', false).neq('sender_id', user.id);
          const displayName = profileData?.nickname || profileData?.full_name || 'Utente';

          return { ...conv, ...referenceData, profiles: profileData ? { ...profileData, full_name: displayName } : null, unread_count: count || 0 };
        })
      );

      setConversations(conversationsWithDetails);
    } catch (error) {
      console.error('Error loading conversations:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadMessages = async (conversationId: string) => {
    try {
      const { data, error } = await supabase
        .from('messages')
        .select('id, sender_id, content, created_at, is_read, attachment_url, attachment_type, attachment_name')
        .eq('conversation_id', conversationId)
        .order('created_at', { ascending: true });
      if (error) throw error;
      setMessages(data || []);
    } catch (error) {
      console.error('Error loading messages:', error);
    }
  };

  const markMessagesAsRead = async (conversationId: string) => {
    if (!user) return;
    try {
      await supabase.from('messages').update({ is_read: true }).eq('conversation_id', conversationId).neq('sender_id', user.id);
    } catch (error) {
      console.error('Error marking messages as read:', error);
    }
  };

  const uploadFile = async (file: File, bucket: string, folder: string): Promise<string> => {
    const ext = file.name.split('.').pop();
    const path = `${folder}/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
    const { error } = await supabase.storage.from(bucket).upload(path, file);
    if (error) throw error;

    if (bucket === 'chat-images') {
      const { data } = supabase.storage.from(bucket).getPublicUrl(path);
      return data.publicUrl;
    } else {
      // For CVs return the path, we'll create signed URLs on read
      const { data } = await supabase.storage.from(bucket).createSignedUrl(path, 60 * 60 * 24 * 7); // 7 days
      return data?.signedUrl || path;
    }
  };

  const sendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if ((!newMessage.trim() && !cvFile && imageFiles.length === 0) || !selectedConversation || !user) return;

    setSending(true);
    setUploadingAttachment(true);

    try {
      const convType = selectedConv?.conversation_type || '';
      const isJob = isJobConversation(convType);

      if (isJob && cvFile) {
        // Send CV as a message
        const url = await uploadFile(cvFile, 'chat-cvs', user.id);
        await supabase.from('messages').insert([{
          conversation_id: selectedConversation,
          sender_id: user.id,
          content: newMessage.trim() || '',
          attachment_url: url,
          attachment_type: 'cv',
          attachment_name: cvFile.name,
        }]);
        setCvFile(null);
      } else if (!isJob && imageFiles.length > 0) {
        // Send each image as a separate message; text goes with the first
        for (let i = 0; i < imageFiles.length; i++) {
          const url = await uploadFile(imageFiles[i], 'chat-images', user.id);
          await supabase.from('messages').insert([{
            conversation_id: selectedConversation,
            sender_id: user.id,
            content: i === 0 ? newMessage.trim() : '',
            attachment_url: url,
            attachment_type: 'image',
            attachment_name: imageFiles[i].name,
          }]);
        }
        setImageFiles([]);
      } else if (newMessage.trim()) {
        await supabase.from('messages').insert([{
          conversation_id: selectedConversation,
          sender_id: user.id,
          content: newMessage.trim(),
        }]);
      }

      await supabase.from('conversations').update({ last_message_at: new Date().toISOString() }).eq('id', selectedConversation);
      setNewMessage('');
      loadMessages(selectedConversation);
      loadConversations();
    } catch (error) {
      console.error('Error sending message:', error);
      showToast('Errore nell\'invio del messaggio', 'error');
    } finally {
      setSending(false);
      setUploadingAttachment(false);
    }
  };

  const handleCvChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const allowed = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    if (!allowed.includes(file.type)) { showToast('Formato non supportato. Usa PDF o DOCX.', 'info'); return; }
    if (file.size > 10 * 1024 * 1024) { showToast('Il file supera i 10MB.', 'info'); return; }
    setCvFile(file);
    e.target.value = '';
  };

  const handleImagesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const remaining = MAX_IMAGES - imageFiles.length;
    if (remaining <= 0) { showToast(`Puoi allegare massimo ${MAX_IMAGES} immagini.`, 'info'); return; }
    const toAdd = files.slice(0, remaining);
    const invalid = toAdd.filter(f => !f.type.startsWith('image/'));
    if (invalid.length > 0) { showToast('Sono supportati solo file immagine.', 'info'); return; }
    const tooBig = toAdd.filter(f => f.size > 5 * 1024 * 1024);
    if (tooBig.length > 0) { showToast('Ogni immagine deve essere inferiore a 5MB.', 'info'); return; }
    setImageFiles(prev => [...prev, ...toAdd]);
    e.target.value = '';
  };

  const formatMessageTime = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now.getTime() - date.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if (diffDays === 0) return date.toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' });
    if (diffDays === 1) return 'Ieri';
    return date.toLocaleDateString('it-IT');
  };

  // Image lightbox images array from current message chain
  const lightboxImages = messages
    .filter(m => m.attachment_type === 'image' && m.attachment_url)
    .map(m => m.attachment_url as string);

  useEffect(() => {
    if (!selectedConversation) { setSelectedConv(null); return; }
    const found = conversations.find((c) => c.id === selectedConversation);
    if (found) { setSelectedConv(found); return; }
    if (!user || loading) return;

    (async () => {
      try {
        const { data: conv, error } = await supabase.from('conversations').select('*').eq('id', selectedConversation).maybeSingle();
        if (error || !conv) return;
        const otherUserId = conv.participant1_id === user.id ? conv.participant2_id : conv.participant1_id;
        const { data: profileData } = await supabase.from('profiles').select('full_name, nickname, avatar_url').eq('id', otherUserId).maybeSingle();
        let referenceData: any = null;
        if (conv.conversation_type === 'classified_ad') {
          const { data: adData } = await supabase.from('classified_ads').select('title, images').eq('id', conv.reference_id).maybeSingle();
          referenceData = { classified_ads: adData };
        } else if (conv.conversation_type === 'job_seeker') {
          const { data: jsData } = await supabase.from('job_seekers').select('title').eq('id', conv.reference_id).maybeSingle();
          referenceData = { job_seekers: jsData };
        } else if (conv.conversation_type === 'job_posting') {
          const { data: jpData } = await supabase.from('job_postings').select('title, company_name').eq('id', conv.reference_id).maybeSingle();
          referenceData = { job_postings: jpData };
        } else if (conv.conversation_type === 'auction') {
          const { data: auctionData } = await supabase.from('auctions').select('title').eq('id', conv.reference_id).maybeSingle();
          referenceData = { auctions: auctionData };
        }
        const displayName = profileData?.nickname || profileData?.full_name || 'Utente';
        const enriched: Conversation = { ...conv, ...referenceData, profiles: profileData ? { ...profileData, full_name: displayName } : undefined, unread_count: 0 };
        setSelectedConv(enriched);
        setConversations(prev => [enriched, ...prev]);
      } catch (err) {
        console.error('Error loading conversation details:', err);
      }
    })();
  }, [selectedConversation, conversations, user, loading]);

  if (authLoading || loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600" />
      </div>
    );
  }

  const convType = selectedConv?.conversation_type || '';
  const showCvButton = isJobConversation(convType);
  const showImagesButton = isClassifiedConversation(convType);
  const canSend = newMessage.trim() || cvFile || imageFiles.length > 0;

  return (
    <div className="flex flex-col" style={{ height: 'calc(100vh - 0px)' }}>
      {/* Hero */}
      <section className="bg-white border-b border-gray-100 flex-shrink-0">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
          <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-4">
            <div className="w-1.5 h-1.5 bg-blue-500 rounded-full" />
            Le tue conversazioni
          </div>
          <h1 className="text-4xl md:text-5xl font-extrabold text-gray-900 leading-tight mb-2">Messaggi</h1>
          <p className="text-lg text-gray-500">Gestisci tutte le tue conversazioni in un unico posto</p>
        </div>
      </section>

      <div className="flex flex-1 overflow-hidden bg-gray-50">
        {/* Conversations list */}
        <div className={`w-full md:w-96 bg-white border-r border-gray-200 flex flex-col ${selectedConversation ? 'hidden md:flex' : 'flex'}`}>
          <div className="p-4 border-b border-gray-200">
            <h1 className="text-xl font-bold text-gray-900 mb-3">Conversazioni</h1>
            <div className="flex flex-col gap-0.5">
              {([
                { key: 'all', label: 'Tutte', icon: null },
                { key: 'classified_ad', label: 'Annunci', icon: Tag },
                { key: 'job_seeker', label: 'Candidature', icon: Briefcase },
                { key: 'job_posting', label: 'Offerte', icon: Building2 },
                { key: 'auction', label: 'Aste', icon: Gavel },
              ] as const).map(({ key, label, icon: Icon }) => {
                const count = key === 'all' ? conversations.length : conversations.filter((c) => matchesFilter(c.conversation_type, key)).length;
                const isActive = filter === key;
                return (
                  <button
                    key={key}
                    onClick={() => setFilter(key)}
                    className={`w-full flex items-center justify-between gap-1.5 px-2.5 py-1.5 rounded-lg text-xs font-medium transition-all ${isActive ? 'bg-blue-600 text-white shadow-sm' : 'text-gray-700 hover:bg-gray-100'}`}
                  >
                    <div className="flex items-center gap-2 min-w-0">
                      {Icon ? <Icon className={`w-3.5 h-3.5 flex-shrink-0 ${isActive ? 'text-white' : 'text-gray-400'}`} /> : <MessageCircle className={`w-3.5 h-3.5 flex-shrink-0 ${isActive ? 'text-white' : 'text-gray-400'}`} />}
                      <span className="truncate">{label}</span>
                    </div>
                    <span className={`text-xs flex-shrink-0 ${isActive ? 'text-blue-100' : 'text-gray-400'}`}>{count}</span>
                  </button>
                );
              })}
            </div>
          </div>

          <div className="flex-1 overflow-y-auto">
            {(() => {
              const filtered = filter === 'all' ? conversations : conversations.filter((c) => matchesFilter(c.conversation_type, filter));
              return filtered.length === 0 ? (
                <div className="flex flex-col items-center justify-center h-full text-center p-6">
                  <MessageCircle className="w-16 h-16 text-gray-400 mb-4" />
                  <h3 className="text-lg font-semibold text-gray-900 mb-2">{filter === 'all' ? 'Nessun messaggio' : 'Nessuna conversazione'}</h3>
                  {filter !== 'all' && <p className="text-gray-600">Nessuna conversazione in questa categoria</p>}
                </div>
              ) : filtered.map((conv) => {
                const hasUnread = (conv.unread_count || 0) > 0;
                const isSelected = selectedConversation === conv.id;
                return (
                  <button
                    key={conv.id}
                    onClick={() => setSelectedConversation(conv.id)}
                    className={`w-full p-4 flex items-start gap-3 transition-colors border-b border-gray-100 relative ${isSelected ? 'bg-blue-50' : hasUnread ? 'bg-blue-50/60 hover:bg-blue-100/60' : 'hover:bg-gray-50'}`}
                  >
                    {hasUnread && !isSelected && <div className="absolute left-0 top-0 bottom-0 w-1 bg-blue-600 rounded-r" />}
                    <div className="relative flex-shrink-0">
                      {conv.profiles?.avatar_url ? (
                        <img src={conv.profiles.avatar_url} alt={conv.profiles.full_name} className={`w-12 h-12 rounded-full object-cover ${hasUnread ? 'ring-2 ring-blue-500 ring-offset-1' : ''}`} />
                      ) : (
                        <div className={`w-12 h-12 rounded-full flex items-center justify-center ${hasUnread ? 'bg-blue-100 ring-2 ring-blue-500 ring-offset-1' : 'bg-gray-200'}`}>
                          <span className={`text-lg font-medium ${hasUnread ? 'text-blue-700' : 'text-gray-600'}`}>{conv.profiles?.full_name.charAt(0) || '?'}</span>
                        </div>
                      )}
                      {hasUnread && <span className="absolute -top-1 -right-1 w-3 h-3 bg-blue-600 rounded-full ring-2 ring-white" />}
                    </div>
                    <div className="flex-1 min-w-0 text-left">
                      <div className="flex items-center justify-between mb-1">
                        <span className={`truncate ${hasUnread ? 'font-bold text-gray-900' : 'font-semibold text-gray-700'}`}>{conv.profiles?.full_name || 'Utente'}</span>
                        {hasUnread && <span className="ml-2 flex-shrink-0 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-sm">{conv.unread_count}</span>}
                      </div>
                      {conv.classified_ads && <div className={`text-sm truncate ${hasUnread ? 'text-gray-800 font-medium' : 'text-gray-600'}`}>{conv.classified_ads.title}</div>}
                      {conv.job_seekers && <div className={`text-sm truncate ${hasUnread ? 'text-gray-800 font-medium' : 'text-gray-600'}`}>{conv.job_seekers.title}</div>}
                      {conv.job_postings && <div className={`text-sm truncate ${hasUnread ? 'text-gray-800 font-medium' : 'text-gray-600'}`}>{conv.job_postings.title}</div>}
                      {conv.auctions && <div className={`text-sm truncate ${hasUnread ? 'text-gray-800 font-medium' : 'text-gray-600'}`}>{conv.auctions.title}</div>}
                      {conv.professional_profiles && <div className={`text-sm truncate ${hasUnread ? 'text-gray-800 font-medium' : 'text-gray-600'}`}>{conv.professional_profiles.profession || 'Profilo professionale'}</div>}
                      {conv.conversation_type === 'professional_profile' && !conv.professional_profiles && <div className={`text-sm truncate ${hasUnread ? 'text-gray-800 font-medium' : 'text-gray-600'}`}>Profilo professionale</div>}
                      <div className={`text-xs mt-1 ${hasUnread ? 'text-blue-600 font-semibold' : 'text-gray-500'}`}>{formatMessageTime(conv.last_message_at)}</div>
                    </div>
                  </button>
                );
              });
            })()}
          </div>
        </div>

        {/* Chat area */}
        <div className={`flex-1 flex flex-col ${selectedConversation ? 'flex' : 'hidden md:flex'}`}>
          {selectedConversation && selectedConv ? (
            <>
              {/* Chat header */}
              <div className="bg-white border-b border-gray-200 p-4 flex items-center gap-3">
                <button onClick={() => setSelectedConversation(null)} className="md:hidden text-gray-600 hover:text-gray-900">
                  <ArrowLeft className="w-6 h-6" />
                </button>
                {selectedConv.profiles?.avatar_url ? (
                  <img src={selectedConv.profiles.avatar_url} alt={selectedConv.profiles.full_name} className="w-10 h-10 rounded-full object-cover" />
                ) : (
                  <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center">
                    <span className="text-sm font-medium text-gray-600">{selectedConv.profiles?.full_name.charAt(0) || '?'}</span>
                  </div>
                )}
                <div>
                  <div className="font-semibold text-gray-900">{selectedConv.profiles?.full_name || 'Utente'}</div>
                  {selectedConv.classified_ads && <div className="flex items-center gap-1 text-sm text-gray-600"><Tag className="w-3.5 h-3.5 text-green-500 flex-shrink-0" /><span className="truncate">{selectedConv.classified_ads.title}</span></div>}
                  {selectedConv.job_seekers && <div className="flex items-center gap-1 text-sm text-gray-600"><Briefcase className="w-3.5 h-3.5 text-blue-500 flex-shrink-0" /><span className="truncate">{selectedConv.job_seekers.title}</span></div>}
                  {selectedConv.job_postings && <div className="flex items-center gap-1 text-sm text-gray-600"><Building2 className="w-3.5 h-3.5 text-orange-500 flex-shrink-0" /><span className="truncate">{selectedConv.job_postings.title}</span></div>}
                  {selectedConv.auctions && <div className="flex items-center gap-1 text-sm text-gray-600"><Gavel className="w-3.5 h-3.5 text-amber-500 flex-shrink-0" /><span className="truncate">{selectedConv.auctions.title}</span></div>}
                </div>
              </div>

              {/* Messages */}
              <div className="flex-1 overflow-y-auto p-4 space-y-4">
                {messages.map((message) => {
                  const isSender = message.sender_id === user?.id;
                  return (
                    <div key={message.id} className={`flex ${isSender ? 'justify-end' : 'justify-start'}`}>
                      <div className={`max-w-xs md:max-w-md rounded-2xl overflow-hidden ${isSender ? 'bg-blue-600 text-white' : 'bg-white text-gray-900 border border-gray-200'}`}>
                        {/* Image attachment */}
                        {message.attachment_type === 'image' && message.attachment_url && (
                          <button
                            onClick={() => { setLightboxUrl(message.attachment_url!); setLightboxIndex(lightboxImages.indexOf(message.attachment_url!)); }}
                            className="block w-full"
                          >
                            <img src={message.attachment_url} alt="immagine" className="w-full max-h-60 object-cover" />
                          </button>
                        )}
                        {/* CV attachment */}
                        {message.attachment_type === 'cv' && message.attachment_url && (
                          <a
                            href={message.attachment_url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className={`flex items-center gap-3 px-4 py-3 hover:opacity-90 transition-opacity ${isSender ? '' : 'border-b border-gray-100'}`}
                          >
                            <div className={`p-2 rounded-lg flex-shrink-0 ${isSender ? 'bg-blue-500' : 'bg-blue-50'}`}>
                              <FileText className={`w-5 h-5 ${isSender ? 'text-white' : 'text-blue-600'}`} />
                            </div>
                            <div className="flex-1 min-w-0">
                              <p className={`text-sm font-semibold truncate ${isSender ? 'text-white' : 'text-gray-900'}`}>{message.attachment_name || 'Curriculum Vitae'}</p>
                              <p className={`text-xs ${isSender ? 'text-blue-200' : 'text-gray-500'}`}>Curriculum Vitae</p>
                            </div>
                            <Download className={`w-4 h-4 flex-shrink-0 ${isSender ? 'text-blue-200' : 'text-blue-600'}`} />
                          </a>
                        )}
                        {/* Text content */}
                        {message.content && (
                          <div className="px-4 py-2">
                            <div className="break-words">{message.content}</div>
                          </div>
                        )}
                        <div className={`px-4 pb-2 text-xs ${message.content || message.attachment_type ? '' : 'pt-2'} ${isSender ? 'text-blue-100' : 'text-gray-500'}`}>
                          {formatMessageTime(message.created_at)}
                        </div>
                      </div>
                    </div>
                  );
                })}
                <div ref={messagesEndRef} />
              </div>

              {/* Attachment preview area */}
              {(cvFile || imageFiles.length > 0) && (
                <div className="bg-gray-50 border-t border-gray-200 px-4 pt-3 pb-2">
                  {cvFile && (
                    <div className="flex items-center gap-3 bg-white border border-gray-200 rounded-xl px-3 py-2 w-fit max-w-xs">
                      <div className="p-1.5 bg-blue-50 rounded-lg">
                        <FileText className="w-4 h-4 text-blue-600" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-gray-900 truncate">{cvFile.name}</p>
                        <p className="text-xs text-gray-500">{(cvFile.size / 1024).toFixed(0)} KB</p>
                      </div>
                      <button onClick={() => setCvFile(null)} className="text-gray-400 hover:text-red-500 flex-shrink-0">
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                  )}
                  {imageFiles.length > 0 && (
                    <div className="flex gap-2 flex-wrap">
                      {imageFiles.map((f, i) => (
                        <div key={i} className="relative group">
                          <img src={URL.createObjectURL(f)} alt="" className="w-16 h-16 object-cover rounded-lg border border-gray-200" />
                          <button
                            onClick={() => setImageFiles(prev => prev.filter((_, idx) => idx !== i))}
                            className="absolute -top-1.5 -right-1.5 w-5 h-5 bg-red-500 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity"
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </div>
                      ))}
                      {imageFiles.length < MAX_IMAGES && (
                        <button
                          onClick={() => imageInputRef.current?.click()}
                          className="w-16 h-16 rounded-lg border-2 border-dashed border-gray-300 flex items-center justify-center text-gray-400 hover:border-blue-400 hover:text-blue-500 transition-colors"
                        >
                          <Image className="w-5 h-5" />
                        </button>
                      )}
                    </div>
                  )}
                </div>
              )}

              {/* Message input */}
              <form onSubmit={sendMessage} className="bg-white border-t border-gray-200 p-3">
                <div className="flex items-end gap-2">
                  {/* Attachment buttons */}
                  {showCvButton && (
                    <>
                      <input ref={cvInputRef} type="file" accept=".pdf,.doc,.docx" onChange={handleCvChange} className="hidden" />
                      <button
                        type="button"
                        onClick={() => cvInputRef.current?.click()}
                        title="Allega Curriculum"
                        className={`flex-shrink-0 p-2.5 rounded-xl transition-colors ${cvFile ? 'bg-blue-100 text-blue-700' : 'text-gray-500 hover:bg-gray-100 hover:text-gray-700'}`}
                      >
                        <FileText className="w-5 h-5" />
                      </button>
                    </>
                  )}
                  {showImagesButton && (
                    <>
                      <input ref={imageInputRef} type="file" accept="image/*" multiple onChange={handleImagesChange} className="hidden" />
                      <button
                        type="button"
                        onClick={() => imageInputRef.current?.click()}
                        disabled={imageFiles.length >= MAX_IMAGES}
                        title={`Allega immagini (max ${MAX_IMAGES})`}
                        className={`flex-shrink-0 p-2.5 rounded-xl transition-colors ${imageFiles.length > 0 ? 'bg-green-100 text-green-700' : 'text-gray-500 hover:bg-gray-100 hover:text-gray-700'} disabled:opacity-40 disabled:cursor-not-allowed`}
                      >
                        <Image className="w-5 h-5" />
                        {imageFiles.length > 0 && <span className="sr-only">{imageFiles.length}</span>}
                      </button>
                    </>
                  )}

                  <div className="flex-1 relative">
                    <input
                      type="text"
                      value={newMessage}
                      onChange={(e) => setNewMessage(e.target.value)}
                      placeholder={
                        cvFile ? 'Aggiungi un messaggio al CV (opzionale)...' :
                        imageFiles.length > 0 ? 'Aggiungi un messaggio alle immagini (opzionale)...' :
                        'Scrivi un messaggio...'
                      }
                      className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-gray-50 text-sm"
                    />
                  </div>

                  <button
                    type="submit"
                    disabled={!canSend || sending || uploadingAttachment}
                    className="flex-shrink-0 bg-blue-600 text-white p-2.5 rounded-xl hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    {sending || uploadingAttachment ? (
                      <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    ) : (
                      <Send className="w-5 h-5" />
                    )}
                  </button>
                </div>

                {/* Hint */}
                {(showCvButton || showImagesButton) && !cvFile && imageFiles.length === 0 && (
                  <p className="text-xs text-gray-400 mt-2 flex items-center gap-1">
                    <Paperclip className="w-3 h-3" />
                    {showCvButton ? 'Puoi allegare il tuo CV (PDF, DOCX, max 10MB)' : `Puoi allegare fino a ${MAX_IMAGES} immagini (max 5MB ciascuna)`}
                  </p>
                )}
              </form>
            </>
          ) : (
            <div className="flex-1 flex items-center justify-center text-center p-6">
              <div>
                <MessageCircle className="w-20 h-20 text-gray-400 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-900 mb-2">Seleziona una conversazione</h3>
                <p className="text-gray-600">Scegli una conversazione dalla lista per iniziare a chattare</p>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Image lightbox */}
      {lightboxUrl && (
        <div
          className="fixed inset-0 z-50 bg-black/90 flex items-center justify-center"
          onClick={() => setLightboxUrl(null)}
        >
          <button onClick={() => setLightboxUrl(null)} className="absolute top-4 right-4 text-white/80 hover:text-white">
            <X className="w-8 h-8" />
          </button>
          {lightboxImages.length > 1 && lightboxIndex > 0 && (
            <button
              onClick={(e) => { e.stopPropagation(); const ni = lightboxIndex - 1; setLightboxIndex(ni); setLightboxUrl(lightboxImages[ni]); }}
              className="absolute left-4 text-white/80 hover:text-white p-2 bg-black/30 rounded-full"
            >
              <ChevronLeft className="w-7 h-7" />
            </button>
          )}
          <img src={lightboxUrl} alt="immagine ingrandita" className="max-w-[90vw] max-h-[90vh] object-contain rounded-lg" onClick={e => e.stopPropagation()} />
          {lightboxImages.length > 1 && lightboxIndex < lightboxImages.length - 1 && (
            <button
              onClick={(e) => { e.stopPropagation(); const ni = lightboxIndex + 1; setLightboxIndex(ni); setLightboxUrl(lightboxImages[ni]); }}
              className="absolute right-4 text-white/80 hover:text-white p-2 bg-black/30 rounded-full"
            >
              <ChevronRight className="w-7 h-7" />
            </button>
          )}
          {lightboxImages.length > 1 && (
            <div className="absolute bottom-4 text-white/60 text-sm">{lightboxIndex + 1} / {lightboxImages.length}</div>
          )}
        </div>
      )}
    </div>
  );
}
