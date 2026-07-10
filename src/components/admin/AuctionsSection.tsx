import { useState, useEffect } from 'react';
import { Gavel, Search, Filter, Eye, Trash2, CheckCircle, XCircle, Clock, TrendingUp, Users, ShieldCheck, AlertCircle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { AdminLocationFilter } from './AdminLocationFilter';
import { useToast } from '../common/Toast';

const AUCTION_CATEGORIES = [
  'Elettronica',
  'Abbigliamento',
  'Casa e Giardino',
  'Sport',
  'Collezionismo',
  'Auto e Moto',
  'Libri',
  'Giocattoli',
  'Arte',
  'Altro'
];

interface Auction {
  id: string;
  title: string;
  description: string;
  base_price: number;
  current_price: number;
  deposit_amount: number;
  category: string;
  condition: string;
  city: string;
  province: string;
  region: string;
  status: string;
  approval_status: string;
  current_bidder_nickname?: string;
  ends_at: string;
  created_at: string;
  images: string[];
  user: {
    full_name?: string;
    nickname?: string;
    email?: string;
  };
  bid_count?: number;
  winner?: {
    full_name?: string;
    nickname?: string;
  };
}

export default function AuctionsSection() {
  const { showToast } = useToast();
  const { user } = useAuth();
  const [auctions, setAuctions] = useState<Auction[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [approvalFilter, setApprovalFilter] = useState<string>('all');
  const [categoryFilter, setCategoryFilter] = useState<string>('all');
  const [priceRangeFilter, setPriceRangeFilter] = useState<string>('all');
  const [locationFilter, setLocationFilter] = useState({ region: '', province: '', city: '' });
  const [showFilters, setShowFilters] = useState(false);
  const [rejectingId, setRejectingId] = useState<string | null>(null);
  const [rejectReason, setRejectReason] = useState('');
  const [processing, setProcessing] = useState<string | null>(null);
  const [stats, setStats] = useState({
    total: 0,
    pending: 0,
    approved: 0,
    rejected: 0,
    totalBids: 0,
    totalDeposits: 0
  });

  useEffect(() => {
    loadAuctions();
    loadStats();
  }, [approvalFilter]);

  const loadAuctions = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from('auctions')
        .select(`
          *,
          user:profiles!auctions_user_id_fkey(full_name, nickname, email),
          winner:profiles!auctions_winner_id_fkey(full_name, nickname),
          bid_count:auction_bids(count)
        `)
        .order('created_at', { ascending: false });

      if (approvalFilter !== 'all') {
        query = query.eq('approval_status', approvalFilter);
      }

      const { data, error } = await query;
      if (error) throw error;

      const auctionsWithBidCount = (data || []).map(auction => ({
        ...auction,
        bid_count: auction.bid_count?.[0]?.count || 0
      }));

      setAuctions(auctionsWithBidCount);
    } catch (err: any) {
      console.error('Error loading auctions:', err);
    } finally {
      setLoading(false);
    }
  };

  const loadStats = async () => {
    try {
      const { data: allAuctions } = await supabase
        .from('auctions')
        .select('status, approval_status');

      const { data: allBids } = await supabase
        .from('auction_bids')
        .select('id');

      const { data: allDeposits } = await supabase
        .from('auction_deposits')
        .select('amount');

      const pending = allAuctions?.filter(a => a.approval_status === 'pending').length || 0;
      const approved = allAuctions?.filter(a => a.approval_status === 'approved').length || 0;
      const rejected = allAuctions?.filter(a => a.approval_status === 'rejected').length || 0;
      const totalDeposits = allDeposits?.reduce((sum, d) => sum + Number(d.amount), 0) || 0;

      setStats({
        total: allAuctions?.length || 0,
        pending,
        approved,
        rejected,
        totalBids: allBids?.length || 0,
        totalDeposits
      });
    } catch (err) {
      console.error('Error loading stats:', err);
    }
  };

  const handleApprove = async (auctionId: string) => {
    if (!user) return;
    setProcessing(auctionId);
    try {
      const { error } = await supabase.rpc('approve_auction', {
        p_auction_id: auctionId,
        p_admin_id: user.id
      });
      if (error) throw error;
      loadAuctions();
      loadStats();
    } catch (err: any) {
      showToast('Errore durante l\'approvazione: ' + err.message, 'error');
    } finally {
      setProcessing(null);
    }
  };

  const handleReject = async () => {
    if (!rejectingId || !user) return;
    setProcessing(rejectingId);
    try {
      const { error } = await supabase.rpc('reject_auction', {
        p_auction_id: rejectingId,
        p_admin_id: user.id,
        p_reason: rejectReason
      });
      if (error) throw error;
      setRejectingId(null);
      setRejectReason('');
      loadAuctions();
      loadStats();
    } catch (err: any) {
      showToast('Errore durante il rifiuto: ' + err.message, 'error');
    } finally {
      setProcessing(null);
    }
  };

  const handleDeleteAuction = async (auctionId: string) => {
    if (!confirm('Sei sicuro di voler eliminare questa asta? Questa azione è irreversibile.')) return;
    try {
      const { error } = await supabase.from('auctions').delete().eq('id', auctionId);
      if (error) throw error;
      loadAuctions();
      loadStats();
    } catch (err: any) {
      showToast('Errore durante l\'eliminazione: ' + err.message, 'error');
    }
  };

  const filteredAuctions = auctions.filter(auction => {
    const matchesSearch = !searchTerm ||
      auction.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      auction.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
      auction.user?.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      auction.user?.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      auction.user?.nickname?.toLowerCase().includes(searchTerm.toLowerCase());

    const matchesCategory = categoryFilter === 'all' || auction.category === categoryFilter;

    const matchesPriceRange = priceRangeFilter === 'all' || (() => {
      const price = auction.current_price > 0 ? auction.current_price : auction.base_price;
      switch (priceRangeFilter) {
        case '0-100': return price <= 100;
        case '100-500': return price > 100 && price <= 500;
        case '500-1000': return price > 500 && price <= 1000;
        case '1000-5000': return price > 1000 && price <= 5000;
        case '5000+': return price > 5000;
        default: return true;
      }
    })();

    const matchesRegion = !locationFilter.region || auction.region === locationFilter.region;
    const matchesProvince = !locationFilter.province || auction.province === locationFilter.province;
    const matchesCity = !locationFilter.city || auction.city === locationFilter.city;

    return matchesSearch && matchesCategory && matchesPriceRange && matchesRegion && matchesProvince && matchesCity;
  });


  const getTimeRemaining = (endsAt: string) => {
    const now = new Date();
    const endDate = new Date(endsAt);
    const diff = endDate.getTime() - now.getTime();
    if (diff <= 0) return 'Terminata';
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    if (days > 0) return `${days}g ${hours}h`;
    return `${hours}h`;
  };

  const getApprovalBadge = (approvalStatus: string) => {
    const badges: Record<string, { bg: string; text: string; label: string }> = {
      pending: { bg: 'bg-yellow-100', text: 'text-yellow-800', label: 'In attesa' },
      approved: { bg: 'bg-green-100', text: 'text-green-800', label: 'Approvata' },
      rejected: { bg: 'bg-red-100', text: 'text-red-800', label: 'Rifiutata' }
    };
    const badge = badges[approvalStatus] || badges.pending;
    return (
      <span className={`rounded-full px-3 py-1 text-xs font-semibold ${badge.bg} ${badge.text}`}>
        {badge.label}
      </span>
    );
  };

  return (
    <div className="space-y-6">
      {/* Hero Header */}
      <div className="relative bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6 mb-6 overflow-hidden">
        {/* Dot overlay */}
        <div
          className="absolute inset-0 opacity-20"
          style={{
            backgroundImage: 'radial-gradient(circle, #ffffff 1px, transparent 1px)',
            backgroundSize: '24px 24px'
          }}
        />
        <div className="relative flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          {/* Left: label, title, stats chips */}
          <div>
            <p className="text-xs font-semibold uppercase tracking-widest text-gray-400 mb-1">
              Pannello Admin
            </p>
            <h2 className="text-3xl font-bold text-white mb-4">Aste</h2>
            <div className="flex flex-wrap gap-2">
              <span className="inline-flex items-center gap-1.5 bg-white/10 border border-white/20 text-white text-xs font-semibold px-3 py-1.5 rounded-full">
                <Gavel className="w-3.5 h-3.5" />
                Totali: {stats.total}
              </span>
              <span className="inline-flex items-center gap-1.5 bg-yellow-500/20 border border-yellow-400/30 text-yellow-300 text-xs font-semibold px-3 py-1.5 rounded-full">
                <AlertCircle className="w-3.5 h-3.5" />
                In attesa: {stats.pending}
              </span>
              <span className="inline-flex items-center gap-1.5 bg-green-500/20 border border-green-400/30 text-green-300 text-xs font-semibold px-3 py-1.5 rounded-full">
                <ShieldCheck className="w-3.5 h-3.5" />
                Approvate: {stats.approved}
              </span>
              <span className="inline-flex items-center gap-1.5 bg-red-500/20 border border-red-400/30 text-red-300 text-xs font-semibold px-3 py-1.5 rounded-full">
                <XCircle className="w-3.5 h-3.5" />
                Rifiutate: {stats.rejected}
              </span>
            </div>
          </div>
          {/* Right: filter toggle */}
          <div className="flex-shrink-0">
            <button
              onClick={() => setShowFilters(!showFilters)}
              className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium transition-colors whitespace-nowrap border border-white/20 text-white ${
                showFilters ? 'bg-white/20 hover:bg-white/30' : 'bg-white/10 hover:bg-white/20'
              }`}
            >
              <Filter className="w-4 h-4" />
              Filtri Avanzati
            </button>
          </div>
        </div>
      </div>

      {/* Main content card */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <div className="flex flex-col gap-4 mb-6">
          {/* Search bar */}
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Cerca per titolo, descrizione, utente..."
              className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:border-transparent"
            />
          </div>

          {/* Approval status tabs */}
          <div className="flex gap-2 overflow-x-auto pb-2">
            {[
              { key: 'pending', label: 'Da Approvare', count: stats.pending },
              { key: 'approved', label: 'Approvate', count: stats.approved },
              { key: 'rejected', label: 'Rifiutate', count: stats.rejected },
              { key: 'all', label: 'Tutte', count: stats.total },
            ].map(tab => (
              <button
                key={tab.key}
                onClick={() => setApprovalFilter(tab.key)}
                className={`relative px-4 py-2 rounded-xl font-medium transition-colors whitespace-nowrap text-sm ${
                  approvalFilter === tab.key
                    ? 'bg-gray-900 text-white'
                    : 'bg-white border border-gray-200 text-gray-600 hover:border-gray-300'
                }`}
              >
                {tab.label}
                {tab.key === 'pending' && tab.count > 0 && approvalFilter !== 'pending' && (
                  <span className="absolute -top-2 -right-2 min-w-[20px] h-[20px] flex items-center justify-center px-1 bg-red-600 text-white text-xs font-bold rounded-full">
                    {tab.count}
                  </span>
                )}
              </button>
            ))}
          </div>

          {/* Filter panel */}
          {showFilters && (
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-5">
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Categoria</label>
                  <select
                    value={categoryFilter}
                    onChange={(e) => setCategoryFilter(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:border-transparent"
                  >
                    <option value="all">Tutte le categorie</option>
                    {AUCTION_CATEGORIES.map(cat => (
                      <option key={cat} value={cat}>{cat}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Fascia di Prezzo</label>
                  <select
                    value={priceRangeFilter}
                    onChange={(e) => setPriceRangeFilter(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:border-transparent"
                  >
                    <option value="all">Tutti i prezzi</option>
                    <option value="0-100">0 - 100 EUR</option>
                    <option value="100-500">100 - 500 EUR</option>
                    <option value="500-1000">500 - 1.000 EUR</option>
                    <option value="1000-5000">1.000 - 5.000 EUR</option>
                    <option value="5000+">Oltre 5.000 EUR</option>
                  </select>
                </div>
                <div className="col-span-full">
                  <AdminLocationFilter
                    value={locationFilter}
                    onChange={setLocationFilter}
                    accentColor="orange"
                  />
                </div>
                <div className="flex items-end">
                  <button
                    onClick={() => {
                      setCategoryFilter('all');
                      setPriceRangeFilter('all');
                      setLocationFilter({ region: '', province: '', city: '' });
                    }}
                    className="w-full px-4 py-2 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 transition-colors font-medium"
                  >
                    Cancella Filtri
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* Result count */}
          <div className="flex items-center justify-between text-sm text-gray-600">
            <span>
              Risultati: <strong className="text-gray-900">{filteredAuctions.length}</strong> di <strong className="text-gray-900">{auctions.length}</strong> aste
            </span>
          </div>
        </div>

        {/* Auction list */}
        {loading ? (
          <div className="flex items-center justify-center py-16">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-gray-900"></div>
          </div>
        ) : filteredAuctions.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-gray-500">
            <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center mb-4">
              <Gavel className="w-8 h-8 text-gray-400" />
            </div>
            <p className="text-base font-medium text-gray-600">
              {approvalFilter === 'pending' ? 'Nessuna asta da approvare' : 'Nessuna asta trovata'}
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {filteredAuctions.map(auction => (
              <div
                key={auction.id}
                className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow"
              >
                <div className="flex gap-4">
                  <img
                    src={auction.images?.[0] || 'https://images.pexels.com/photos/5632388/pexels-photo-5632388.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&fit=crop'}
                    alt={auction.title}
                    className="w-32 h-32 object-cover rounded-xl flex-shrink-0"
                  />

                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-4 mb-2">
                      <div className="flex-1 min-w-0">
                        <h3 className="text-lg font-semibold text-gray-900 truncate">
                          {auction.title}
                        </h3>
                        <p className="text-sm text-gray-600 line-clamp-2">
                          {auction.description}
                        </p>
                      </div>
                      <div className="flex gap-2 flex-shrink-0 flex-wrap">
                        {getApprovalBadge(auction.approval_status)}
                      </div>
                    </div>

                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-3">
                      <div>
                        <div className="text-xs text-gray-500">Venditore</div>
                        <div className="text-sm font-medium text-gray-900">
                          {auction.user?.nickname || auction.user?.full_name || 'N/A'}
                        </div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Base d'Asta</div>
                        <div className="text-sm font-medium text-gray-900">
                          {auction.base_price.toFixed(2)} EUR
                        </div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Offerta Attuale</div>
                        <div className="text-sm font-medium text-orange-600">
                          {auction.current_price > 0 ? `${auction.current_price.toFixed(2)} EUR` : 'Nessuna'}
                        </div>
                        {auction.current_bidder_nickname && (
                          <div className="text-xs text-gray-500 mt-0.5">
                            di <span className="font-semibold text-gray-700">{auction.current_bidder_nickname}</span>
                          </div>
                        )}
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Offerte</div>
                        <div className="text-sm font-medium text-gray-900">
                          {auction.bid_count || 0}
                        </div>
                      </div>
                    </div>

                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-3">
                      <div>
                        <div className="text-xs text-gray-500">Categoria</div>
                        <div className="text-sm font-medium text-gray-900">{auction.category}</div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Localita</div>
                        <div className="text-sm font-medium text-gray-900">
                          {auction.city}, {auction.province}
                        </div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Scadenza</div>
                        <div className="text-sm font-medium text-gray-900">
                          {getTimeRemaining(auction.ends_at)}
                        </div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Deposito</div>
                        <div className="text-sm font-medium text-gray-900">
                          {auction.deposit_amount} EUR
                        </div>
                      </div>
                    </div>

                    {auction.winner && (
                      <div className="mb-3 p-2 bg-blue-50 rounded-xl border border-blue-200">
                        <span className="text-sm text-blue-900">
                          <strong>Vincitore:</strong> {auction.winner.nickname || auction.winner.full_name}
                        </span>
                      </div>
                    )}

                    <div className="flex flex-wrap gap-2">
                      {auction.approval_status === 'pending' && (
                        <>
                          <button
                            onClick={() => handleApprove(auction.id)}
                            disabled={processing === auction.id}
                            className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white text-sm rounded-xl hover:bg-green-700 transition-colors disabled:opacity-50 font-medium"
                          >
                            <ShieldCheck className="w-4 h-4" />
                            {processing === auction.id ? 'Approvando...' : 'Approva'}
                          </button>
                          <button
                            onClick={() => setRejectingId(auction.id)}
                            disabled={processing === auction.id}
                            className="flex items-center gap-2 px-4 py-2 bg-red-600 text-white text-sm rounded-xl hover:bg-red-700 transition-colors disabled:opacity-50 font-medium"
                          >
                            <XCircle className="w-4 h-4" />
                            Rifiuta
                          </button>
                        </>
                      )}

                      <a
                        href={`/auctions/${auction.id}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-center gap-2 px-3 py-1.5 bg-orange-600 text-white text-sm rounded-xl hover:bg-orange-700 transition-colors"
                      >
                        <Eye className="w-4 h-4" />
                        Visualizza
                      </a>

                      <button
                        onClick={() => handleDeleteAuction(auction.id)}
                        className="flex items-center gap-2 px-3 py-1.5 bg-gray-600 text-white text-sm rounded-xl hover:bg-gray-700 transition-colors ml-auto"
                      >
                        <Trash2 className="w-4 h-4" />
                        Elimina
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Reject modal */}
      {rejectingId && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-xl max-w-md w-full overflow-hidden">
            <div className="bg-gradient-to-r from-gray-800 to-gray-900 px-6 py-5">
              <h3 className="text-lg font-bold text-white">Rifiuta Asta</h3>
              <p className="text-sm text-gray-400 mt-1">
                Inserisci il motivo del rifiuto (opzionale). L'utente ricevera una notifica.
              </p>
            </div>
            <div className="p-6">
              <div className="bg-gray-50 rounded-xl p-4 mb-4">
                <textarea
                  value={rejectReason}
                  onChange={(e) => setRejectReason(e.target.value)}
                  placeholder="Motivo del rifiuto..."
                  className="w-full bg-transparent text-sm text-gray-700 placeholder-gray-400 focus:outline-none resize-none"
                  rows={3}
                />
              </div>
              <div className="flex gap-3">
                <button
                  onClick={handleReject}
                  disabled={processing !== null}
                  className="flex-1 bg-red-600 text-white py-2.5 rounded-xl hover:bg-red-700 transition-colors font-medium disabled:opacity-50"
                >
                  {processing ? 'Rifiutando...' : 'Conferma Rifiuto'}
                </button>
                <button
                  onClick={() => { setRejectingId(null); setRejectReason(''); }}
                  className="flex-1 bg-gray-100 text-gray-700 py-2.5 rounded-xl hover:bg-gray-200 transition-colors font-medium"
                >
                  Annulla
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
