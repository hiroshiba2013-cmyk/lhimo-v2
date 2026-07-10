import { useState, useEffect } from 'react';
import { useNavigate } from '../components/Router';
import { Clock, MapPin, Tag, TrendingUp, User, AlertCircle, CheckCircle, Euro, Shield, Trophy, AlertTriangle, MessageCircle } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

interface Bid {
  id: string;
  user_id: string;
  family_member_id: string | null;
  bid_amount: number;
  created_at: string;
  user: {
    full_name?: string;
    nickname?: string;
  };
}

export default function AuctionDetailPage() {
  const navigate = useNavigate();
  const id = window.location.pathname.split('/auctions/')[1];
  const { user, activeProfile, profile } = useAuth();
  const [auction, setAuction] = useState<any>(null);
  const [bids, setBids] = useState<Bid[]>([]);
  const [loading, setLoading] = useState(true);
  const [bidAmount, setBidAmount] = useState('');
  const [hasDeposit, setHasDeposit] = useState(false);
  const [depositData, setDepositData] = useState<any>(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [selectedImage, setSelectedImage] = useState(0);
  const [completion, setCompletion] = useState<any>(null);
  const [hasPlacedBid, setHasPlacedBid] = useState(false);
  const [contactingAuction, setContactingAuction] = useState(false);

  useEffect(() => {
    loadAuction();
    loadBids();
    if (user) {
      checkDeposit();
      loadCompletion();
    }
  }, [id, user?.id]);

  // Ricava il family_member_id attivo (null = account owner)
  function getFamilyMemberId(): string | null {
    if (!profile || profile.user_type === 'business') return null;
    if (!activeProfile || activeProfile.isOwner) return null;
    return activeProfile.id;
  }

  const loadAuction = async () => {
    try {
      const { data, error } = await supabase
        .from('auctions')
        .select('*, user:user_id(full_name, nickname)')
        .eq('id', id)
        .maybeSingle();
      if (error) throw error;
      setAuction(data);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const loadBids = async () => {
    try {
      const { data, error } = await supabase
        .from('auction_bids')
        .select('*, user:user_id(full_name, nickname)')
        .eq('auction_id', id)
        .order('bid_amount', { ascending: false });
      if (error) throw error;
      setBids(data || []);

      // Controlla se l'utente corrente ha già fatto un'offerta (irrevocabile)
      if (user) {
        const fmId = getFamilyMemberId();
        const myBid = (data || []).find(b => {
          if (b.user_id !== user.id) return false;
          if (fmId) return b.family_member_id === fmId;
          return !b.family_member_id;
        });
        setHasPlacedBid(!!myBid);
      }
    } catch (err: any) {
      console.error('Error loading bids:', err);
    }
  };

  const checkDeposit = async () => {
    if (!user) return;
    try {
      const { data } = await supabase
        .from('auction_deposits')
        .select('*')
        .eq('auction_id', id)
        .eq('user_id', user.id)
        .eq('refunded', false)
        .maybeSingle();
      setHasDeposit(!!data);
      setDepositData(data);
    } catch {
      setHasDeposit(false);
    }
  };

  const loadCompletion = async () => {
    if (!user) return;
    try {
      const { data } = await supabase
        .from('auction_completions')
        .select('*')
        .eq('auction_id', id)
        .maybeSingle();
      setCompletion(data);
    } catch (err) {
      console.error('Error loading completion:', err);
    }
  };

  const handlePayDeposit = async () => {
    if (!user) { navigate('/login'); return; }
    setSubmitting(true);
    setError('');
    setSuccess('');
    try {
      const ticketAmount = Math.round(auction.base_price * 0.10 * 100) / 100;
      const { error: depositError } = await supabase
        .from('auction_deposits')
        .insert({
          auction_id: id,
          user_id: user.id,
          family_member_id: getFamilyMemberId(),
          amount: ticketAmount,
        });
      if (depositError) throw depositError;
      setSuccess('Ticket pagato! Ora puoi fare offerte su questa asta.');
      setHasDeposit(true);
      checkDeposit();
    } catch (err: any) {
      if (err.message?.includes('unique') || err.code === '23505') {
        setError('Hai già pagato il ticket per questa asta.');
        setHasDeposit(true);
      } else {
        setError(err.message);
      }
    } finally {
      setSubmitting(false);
    }
  };

  const handlePlaceBid = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) { navigate('/login'); return; }
    if (!hasDeposit) { setError("Devi pagare il ticket prima di fare un'offerta."); return; }

    const amount = parseFloat(bidAmount);
    const minBid = auction.current_price > 0 ? auction.current_price + 0.01 : auction.base_price;

    if (isNaN(amount) || amount < minBid) {
      setError(`L'offerta minima è ${minBid.toFixed(2)} €`);
      return;
    }

    setSubmitting(true);
    setError('');
    setSuccess('');

    try {
      const { error: bidError } = await supabase
        .from('auction_bids')
        .insert({
          auction_id: id,
          user_id: user.id,
          family_member_id: getFamilyMemberId(),
          bid_amount: amount,
        });
      if (bidError) throw bidError;

      setSuccess('Offerta inviata! Ricorda: le offerte sono irrevocabili.');
      setBidAmount('');
      setHasPlacedBid(true);
      loadAuction();
      loadBids();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setSubmitting(false);
    }
  };

  const handleConfirmDeal = async (isSeller: boolean) => {
    if (!user) return;
    setSubmitting(true);
    setError('');
    setSuccess('');
    try {
      const { data, error } = await supabase.rpc('confirm_auction_deal', {
        p_auction_id: id,
        p_user_id: user.id,
        p_is_seller: isSeller,
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);
      setSuccess(
        data?.status === 'fully_confirmed'
          ? 'Affare confermato da entrambe le parti!'
          : 'Conferma registrata. In attesa della conferma della controparte.'
      );
      loadCompletion();
      loadAuction();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setSubmitting(false);
    }
  };

  const handleContactAuction = async (otherUserId: string) => {
    if (!user) { navigate('/'); return; }
    setContactingAuction(true);
    try {
      const familyMemberId = getFamilyMemberId();
      const { data: conversationId, error } = await supabase.rpc('get_or_create_conversation', {
        p_user1_id: user.id,
        p_user2_id: otherUserId,
        p_conversation_type: 'auction',
        p_reference_id: id,
        p_user1_family_member_id: familyMemberId,
      });
      if (error) throw error;
      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (err: any) {
      setError(err.message || 'Errore nell\'apertura della chat');
      setContactingAuction(false);
    }
  };

  const getTimeRemaining = () => {
    if (!auction) return '';
    const diff = new Date(auction.ends_at).getTime() - Date.now();
    if (diff <= 0) return 'Terminata';
    const days = Math.floor(diff / 86400000);
    const hours = Math.floor((diff % 86400000) / 3600000);
    const minutes = Math.floor((diff % 3600000) / 60000);
    if (days > 0) return `${days} giorni, ${hours} ore`;
    if (hours > 0) return `${hours} ore, ${minutes} minuti`;
    return `${minutes} minuti`;
  };

  const getDeadlineRemaining = (deadline: string) => {
    const diff = new Date(deadline).getTime() - Date.now();
    if (diff <= 0) return 'Scaduta';
    const hours = Math.floor(diff / 3600000);
    const minutes = Math.floor((diff % 3600000) / 60000);
    if (hours > 0) return `${hours}h ${minutes}m`;
    return `${minutes} minuti`;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto" />
          <p className="mt-4 text-gray-600">Caricamento...</p>
        </div>
      </div>
    );
  }

  if (!auction) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-xl text-gray-600">Asta non trovata</p>
          <button onClick={() => navigate('/auctions')} className="mt-4 text-blue-600 hover:underline">
            Torna alle aste
          </button>
        </div>
      </div>
    );
  }

  const ticketAmount = Math.round(auction.base_price * 0.10 * 100) / 100;
  const minBid = auction.current_price > 0 ? auction.current_price + 0.01 : auction.base_price;
  const isOwner = user?.id === auction.user_id;
  const isActive = auction.status === 'active' && new Date(auction.ends_at) > new Date();
  const isCompleted = auction.status === 'completed';
  const isWinner = user?.id === auction.winner_id;
  const highestBid = bids[0];
  const isCurrentLeader = highestBid && user && highestBid.user_id === user.id;

  // Scadenza 48h per la completion corrente
  const completionDeadline = completion?.completion_deadline || auction.current_completion_deadline;

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4">
        <button onClick={() => navigate('/auctions')} className="mb-6 text-blue-600 hover:underline flex items-center gap-1">
          ← Torna alle aste
        </button>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Colonna immagini */}
          <div>
            <div className="bg-white rounded-xl shadow-sm overflow-hidden mb-4">
              <img
                src={auction.images?.[selectedImage] || 'https://images.pexels.com/photos/5632402/pexels-photo-5632402.jpeg?auto=compress&cs=tinysrgb&w=600'}
                alt={auction.title}
                className="w-full h-96 object-cover"
              />
            </div>
            {auction.images?.length > 1 && (
              <div className="grid grid-cols-5 gap-2">
                {auction.images.map((img: string, idx: number) => (
                  <button
                    key={idx}
                    onClick={() => setSelectedImage(idx)}
                    className={`rounded-lg overflow-hidden border-2 transition-all ${selectedImage === idx ? 'border-blue-600' : 'border-transparent hover:border-gray-300'}`}
                  >
                    <img src={img} alt={`${auction.title} ${idx + 1}`} className="w-full h-20 object-cover" />
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Colonna dettagli */}
          <div className="space-y-4">
            <div className="bg-white rounded-xl shadow-sm p-6">
              {/* Titolo e status */}
              <div className="flex items-start justify-between mb-4 gap-3">
                <h1 className="text-2xl font-bold text-gray-900 leading-tight">{auction.title}</h1>
                <span className={`flex-shrink-0 px-3 py-1 rounded-full text-sm font-semibold ${
                  auction.status === 'active' ? 'bg-green-100 text-green-800' :
                  auction.status === 'completed' ? 'bg-blue-100 text-blue-800' :
                  'bg-gray-100 text-gray-700'
                }`}>
                  {auction.status === 'active' ? 'Attiva' :
                   auction.status === 'completed' ? 'Conclusa' :
                   auction.status === 'expired' ? 'Scaduta' : auction.status}
                </span>
              </div>

              {/* Venditore */}
              <div className="flex items-center gap-2 text-gray-600 mb-4 text-sm">
                <User className="w-4 h-4" />
                <span>Venditore: <strong>{auction.user?.nickname || auction.user?.full_name || 'Utente'}</strong></span>
              </div>

              <p className="text-gray-700 mb-5 leading-relaxed">{auction.description}</p>

              {/* Prezzi */}
              <div className="grid grid-cols-2 gap-4 mb-5 p-4 bg-gray-50 rounded-xl">
                <div>
                  <div className="text-xs text-gray-500 uppercase tracking-wide mb-1">Base d'asta</div>
                  <div className="text-xl font-bold text-gray-900">{Number(auction.base_price).toFixed(2)} €</div>
                </div>
                <div>
                  <div className="text-xs text-gray-500 uppercase tracking-wide mb-1">Offerta attuale</div>
                  {auction.current_price > 0 ? (
                    <>
                      <div className="text-xl font-bold text-blue-600 flex items-center gap-1.5">
                        <TrendingUp className="w-5 h-5" />
                        {Number(auction.current_price).toFixed(2)} €
                      </div>
                      {(auction.current_bidder_nickname || highestBid) && (
                        <div className="flex items-center gap-1 mt-1">
                          <User className="w-3.5 h-3.5 text-blue-500" />
                          <span className="text-xs font-semibold text-blue-700">
                            {auction.current_bidder_nickname || highestBid?.user?.nickname || highestBid?.user?.full_name || 'Utente'}
                          </span>
                          {isCurrentLeader && <span className="text-xs text-green-600 font-bold ml-1">(tu)</span>}
                        </div>
                      )}
                    </>
                  ) : (
                    <div className="text-xl font-bold text-gray-400">Nessuna offerta</div>
                  )}
                </div>
              </div>

              {/* Info asta */}
              <div className="space-y-2.5 mb-5">
                {isActive && (
                  <div className="flex items-center gap-2 text-gray-700 text-sm">
                    <Clock className="w-4 h-4 text-orange-500" />
                    <span>Termina tra: <strong className="text-orange-600">{getTimeRemaining()}</strong></span>
                  </div>
                )}
                <div className="flex items-center gap-2 text-gray-700 text-sm">
                  <MapPin className="w-4 h-4" />
                  <span>{auction.city}, {auction.province}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-700 text-sm">
                  <Tag className="w-4 h-4" />
                  <span>Categoria: {auction.category}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-700 text-sm">
                  <Shield className="w-4 h-4 text-blue-500" />
                  <span>Ticket di partecipazione: <strong className="text-blue-700">{ticketAmount.toFixed(2)} €</strong> <span className="text-gray-500 text-xs">(10% della base d'asta)</span></span>
                </div>
              </div>

              {/* Avvisi e messaggi */}
              {error && (
                <div className="mb-4 bg-red-50 border border-red-200 rounded-lg p-3 flex items-start gap-2">
                  <AlertCircle className="w-4 h-4 text-red-600 flex-shrink-0 mt-0.5" />
                  <p className="text-sm text-red-700">{error}</p>
                </div>
              )}
              {success && (
                <div className="mb-4 bg-green-50 border border-green-200 rounded-lg p-3 flex items-start gap-2">
                  <CheckCircle className="w-4 h-4 text-green-600 flex-shrink-0 mt-0.5" />
                  <p className="text-sm text-green-700">{success}</p>
                </div>
              )}

              {/* ── Azioni per l'acquirente ── */}

              {/* Paga ticket */}
              {isActive && !isOwner && user && !hasDeposit && (
                <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-4">
                  <h4 className="font-semibold text-blue-900 mb-1 text-sm">Ticket di Partecipazione</h4>
                  <p className="text-sm text-blue-800 mb-3">
                    Per partecipare paga il ticket pari al <strong>10% della base d'asta: {ticketAmount.toFixed(2)} €</strong>.
                    Il ticket viene trattenuto dalla piattaforma in caso di vittoria. Se perdi, viene rimborsato.
                  </p>
                  <button
                    onClick={handlePayDeposit}
                    disabled={submitting}
                    className="w-full bg-blue-600 text-white py-2.5 rounded-lg font-semibold hover:bg-blue-700 disabled:opacity-50 transition-colors"
                  >
                    {submitting ? 'Elaborazione...' : `Paga Ticket (${ticketAmount.toFixed(2)} €)`}
                  </button>
                </div>
              )}

              {/* Ticket pagato — avviso irrevocabilità */}
              {isActive && !isOwner && user && hasDeposit && !hasPlacedBid && (
                <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 mb-4 flex items-start gap-2">
                  <AlertTriangle className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
                  <p className="text-sm text-amber-800">
                    <strong>Attenzione:</strong> una volta inviata, un'offerta non può essere ritirata.
                  </p>
                </div>
              )}

              {/* Form offerta */}
              {isActive && !isOwner && user && hasDeposit && (
                <form onSubmit={handlePlaceBid} className="mb-4">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    {hasPlacedBid
                      ? `Migliora la tua offerta (minimo ${minBid.toFixed(2)} €)`
                      : `Fai un'offerta (minimo ${minBid.toFixed(2)} €)`}
                  </label>
                  <div className="flex gap-2">
                    <input
                      type="number"
                      required
                      min={minBid}
                      step="0.01"
                      value={bidAmount}
                      onChange={(e) => setBidAmount(e.target.value)}
                      placeholder={minBid.toFixed(2)}
                      className="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                    <button
                      type="submit"
                      disabled={submitting}
                      className="px-6 py-2.5 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 disabled:opacity-50 transition-colors"
                    >
                      {submitting ? 'Invio...' : 'Offri'}
                    </button>
                  </div>
                  {hasPlacedBid && (
                    <p className="mt-2 text-xs text-gray-500">Hai già un'offerta su questa asta. Puoi aumentarla, ma non ritirarla.</p>
                  )}
                </form>
              )}

              {/* Non loggato */}
              {isActive && !user && (
                <button
                  onClick={() => navigate('/login')}
                  className="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
                >
                  Accedi per partecipare
                </button>
              )}

              {/* Ticket perso (forfeited) */}
              {depositData?.forfeited && (
                <div className="bg-red-50 border border-red-200 rounded-xl p-4 mb-4">
                  <div className="flex items-start gap-2">
                    <AlertCircle className="w-4 h-4 text-red-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-semibold text-red-800">Ticket perso</p>
                      <p className="text-sm text-red-700 mt-1">
                        Non hai confermato l'affare entro 48 ore. Il tuo ticket di {ticketAmount.toFixed(2)} € è stato trattenuto dalla piattaforma.
                      </p>
                    </div>
                  </div>
                </div>
              )}

              {/* ── Sezione Conferma Conclusione Asta ── */}
              {isCompleted && (isOwner || isWinner) && (
                <div className="mt-2 p-4 bg-gradient-to-br from-amber-50 to-yellow-50 border border-amber-200 rounded-xl">
                  <div className="flex items-center gap-2 mb-3">
                    <Trophy className="w-5 h-5 text-amber-600" />
                    <h3 className="font-bold text-amber-900">Conferma Conclusione Asta</h3>
                  </div>

                  {isWinner && (
                    <div className="bg-white border border-amber-200 rounded-lg p-3 mb-3 space-y-2">
                      <p className="text-sm font-semibold text-green-700">Sei il vincitore con {Number(auction.current_price).toFixed(2)} €</p>
                      <p className="text-xs text-gray-600">
                        Contatta il venditore per organizzare il pagamento e il ritiro/spedizione dell'oggetto.
                      </p>
                      <button
                        onClick={() => handleContactAuction(auction.user_id)}
                        disabled={contactingAuction}
                        className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium disabled:opacity-50"
                      >
                        <MessageCircle className="w-4 h-4" />
                        {contactingAuction ? 'Apertura chat...' : 'Contatta il Venditore'}
                      </button>
                    </div>
                  )}
                  {isOwner && auction.winner_id && (
                    <div className="bg-white border border-amber-200 rounded-lg p-3 mb-3">
                      <button
                        onClick={() => handleContactAuction(auction.winner_id)}
                        disabled={contactingAuction}
                        className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium disabled:opacity-50"
                      >
                        <MessageCircle className="w-4 h-4" />
                        {contactingAuction ? 'Apertura chat...' : 'Contatta il Vincitore'}
                      </button>
                    </div>
                  )}

                  {completionDeadline && (
                    <div className="flex items-center gap-2 mb-3 text-sm">
                      <Clock className="w-4 h-4 text-amber-600" />
                      <span className="text-amber-800">
                        Tempo rimasto per confermare: <strong>{getDeadlineRemaining(completionDeadline)}</strong>
                      </span>
                    </div>
                  )}

                  {!completion && (
                    <p className="text-sm text-amber-800 mb-3">Caricamento stato conferma...</p>
                  )}

                  {completion && (
                    <>
                      <div className="space-y-2 mb-4">
                        <div className="flex items-center gap-2 text-sm">
                          {completion.seller_confirmed ? (
                            <CheckCircle className="w-4 h-4 text-green-600" />
                          ) : (
                            <div className="w-4 h-4 border-2 border-gray-300 rounded-full" />
                          )}
                          <span className={completion.seller_confirmed ? 'text-green-700 font-semibold' : 'text-gray-600'}>
                            Venditore confermato {completion.seller_confirmed_at && `(${new Date(completion.seller_confirmed_at).toLocaleString('it-IT')})`}
                          </span>
                        </div>
                        <div className="flex items-center gap-2 text-sm">
                          {completion.buyer_confirmed ? (
                            <CheckCircle className="w-4 h-4 text-green-600" />
                          ) : (
                            <div className="w-4 h-4 border-2 border-gray-300 rounded-full" />
                          )}
                          <span className={completion.buyer_confirmed ? 'text-green-700 font-semibold' : 'text-gray-600'}>
                            Acquirente confermato {completion.buyer_confirmed_at && `(${new Date(completion.buyer_confirmed_at).toLocaleString('it-IT')})`}
                          </span>
                        </div>
                      </div>

                      {completion.seller_confirmed && completion.buyer_confirmed ? (
                        <div className="flex items-center gap-2 bg-green-100 border border-green-200 rounded-lg p-3">
                          <CheckCircle className="w-5 h-5 text-green-600" />
                          <p className="text-sm font-semibold text-green-800">Affare concluso con successo da entrambe le parti!</p>
                        </div>
                      ) : (
                        <>
                          {isOwner && !completion.seller_confirmed && (
                            <button
                              onClick={() => handleConfirmDeal(true)}
                              disabled={submitting}
                              className="w-full bg-green-600 text-white py-2.5 rounded-lg font-semibold hover:bg-green-700 disabled:opacity-50 transition-colors"
                            >
                              {submitting ? 'Conferma in corso...' : 'Conferma Affare (come Venditore)'}
                            </button>
                          )}
                          {isWinner && !completion.buyer_confirmed && (
                            <button
                              onClick={() => handleConfirmDeal(false)}
                              disabled={submitting}
                              className="w-full bg-green-600 text-white py-2.5 rounded-lg font-semibold hover:bg-green-700 disabled:opacity-50 transition-colors mt-2"
                            >
                              {submitting ? 'Conferma in corso...' : 'Conferma Affare (come Acquirente)'}
                            </button>
                          )}
                          <p className="text-xs text-amber-700 mt-2 text-center">
                            Se il vincitore non conferma entro 48 ore, perde il ticket e l'asta passa al secondo classificato.
                          </p>
                        </>
                      )}
                    </>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Storico offerte */}
        <div className="mt-8 bg-white rounded-xl shadow-sm p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Offerte ({bids.length})</h2>
          {bids.length === 0 ? (
            <p className="text-gray-500 text-center py-8">Nessuna offerta ancora. Sii il primo!</p>
          ) : (
            <div className="space-y-2">
              {bids.map((bid, index) => {
                const isMyBid = user && bid.user_id === user.id;
                return (
                  <div
                    key={bid.id}
                    className={`flex items-center justify-between p-4 rounded-xl ${
                      index === 0
                        ? 'bg-blue-50 border-2 border-blue-200'
                        : isMyBid
                        ? 'bg-green-50 border border-green-200'
                        : 'bg-gray-50 border border-gray-100'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <User className={`w-5 h-5 ${index === 0 ? 'text-blue-600' : 'text-gray-500'}`} />
                      <div>
                        <span className={`font-semibold ${index === 0 ? 'text-blue-900' : 'text-gray-800'}`}>
                          {bid.user?.nickname || bid.user?.full_name || 'Utente'}
                          {isMyBid && <span className="text-xs text-green-600 ml-1">(tu)</span>}
                        </span>
                        {index === 0 && (
                          <span className="ml-2 text-xs bg-blue-600 text-white px-2 py-0.5 rounded-full">In testa</span>
                        )}
                      </div>
                    </div>
                    <div className="text-right">
                      <div className={`text-lg font-bold ${index === 0 ? 'text-blue-600' : 'text-gray-800'}`}>
                        {Number(bid.bid_amount).toFixed(2)} €
                      </div>
                      <div className="text-xs text-gray-400">
                        {new Date(bid.created_at).toLocaleString('it-IT')}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          {/* Nota irrevocabilità */}
          {isActive && (
            <div className="mt-4 flex items-start gap-2 p-3 bg-amber-50 border border-amber-200 rounded-lg">
              <AlertTriangle className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
              <p className="text-xs text-amber-800">
                Le offerte sono <strong>irrevocabili</strong>. Una volta inviata un'offerta non è possibile ritirarla.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
