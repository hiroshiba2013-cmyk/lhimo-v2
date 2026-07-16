import { useState, useEffect, useCallback } from 'react';
import {
  Image as ImageIcon, CheckCircle, XCircle, Clock, PauseCircle, PlayCircle,
  Trash2, Eye, RefreshCw, Filter, ExternalLink, Calendar, Euro,
} from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';
import {
  AdvertisingBanner, AdvertisingPlan, POSITION_LABELS, priceWithVat,
} from '../../lib/advertising-service';

const STATUS_CONFIG: Record<string, { label: string; icon: React.ElementType; color: string; bg: string }> = {
  pending:  { label: 'In attesa',  icon: Clock,        color: 'text-amber-700',  bg: 'bg-amber-100' },
  approved: { label: 'Approvato',  icon: CheckCircle,  color: 'text-green-700',  bg: 'bg-green-100' },
  rejected: { label: 'Rifiutato',  icon: XCircle,       color: 'text-red-700',    bg: 'bg-red-100' },
  expired:  { label: 'Scaduto',    icon: Clock,         color: 'text-gray-600',   bg: 'bg-gray-100' },
  paused:   { label: 'In pausa',   icon: PauseCircle,   color: 'text-blue-700',   bg: 'bg-blue-100' },
};

function formatDate(d: string | null): string {
  if (!d) return '—';
  return new Date(d).toLocaleDateString('it-IT', { day: '2-digit', month: 'short', year: 'numeric' });
}

function isBannerActive(b: AdvertisingBanner): boolean {
  if (b.status !== 'approved') return false;
  const now = new Date();
  if (b.start_date && new Date(b.start_date) > now) return false;
  if (b.end_date && new Date(b.end_date) < now) return false;
  return true;
}

export function AdBannersSection() {
  const { showToast } = useToast();
  const [banners, setBanners] = useState<AdvertisingBanner[]>([]);
  const [plans, setPlans] = useState<AdvertisingPlan[]>([]);
  const [loading, setLoading] = useState(true);
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [filterPosition, setFilterPosition] = useState<string>('all');
  const [selectedBanner, setSelectedBanner] = useState<AdvertisingBanner | null>(null);

  const loadBanners = useCallback(async () => {
    try {
      setLoading(true);
      let query = supabase
        .from('advertising_banners')
        .select('*, plan:plan_id(*)')
        .order('created_at', { ascending: false });
      if (filterStatus !== 'all') query = query.eq('status', filterStatus);
      if (filterPosition !== 'all') query = query.eq('position', filterPosition);
      const { data, error } = await query;
      if (error) throw error;
      setBanners((data || []) as AdvertisingBanner[]);
    } catch {
      showToast('Errore nel caricamento dei banner', 'error');
    } finally {
      setLoading(false);
    }
  }, [filterStatus, filterPosition, showToast]);

  const loadPlans = useCallback(async () => {
    const { data, error } = await supabase
      .from('advertising_plans')
      .select('*')
      .order('sort_order', { ascending: true });
    if (error) return;
    setPlans((data || []) as AdvertisingPlan[]);
  }, []);

  useEffect(() => { loadBanners(); loadPlans(); }, [loadBanners, loadPlans]);

  const updateBannerStatus = async (id: string, status: string, notes?: string) => {
    try {
      const updates: Record<string, any> = { status, updated_at: new Date().toISOString() };
      if (notes !== undefined) updates.admin_notes = notes;
      if (status === 'approved' && !banners.find(b => b.id === id)?.start_date) {
        const plan = banners.find(b => b.id === id)?.plan;
        const days = plan?.duration_days || 7;
        const start = new Date();
        const end = new Date();
        end.setDate(end.getDate() + days);
        updates.start_date = start.toISOString();
        updates.end_date = end.toISOString();
      }
      const { error } = await supabase.from('advertising_banners').update(updates).eq('id', id);
      if (error) throw error;
      showToast(`Banner ${status === 'approved' ? 'approvato' : status === 'rejected' ? 'rifiutato' : 'aggiornato'}`, 'success');
      setSelectedBanner(null);
      await loadBanners();
    } catch {
      showToast('Errore nell\'aggiornamento', 'error');
    }
  };

  const deleteBanner = async (id: string) => {
    if (!confirm('Eliminare definitivamente questo banner?')) return;
    try {
      const { error } = await supabase.from('advertising_banners').delete().eq('id', id);
      if (error) throw error;
      showToast('Banner eliminato', 'success');
      await loadBanners();
    } catch {
      showToast('Errore nell\'eliminazione', 'error');
    }
  };

  const togglePlanActive = async (plan: AdvertisingPlan) => {
    try {
      const { error } = await supabase
        .from('advertising_plans')
        .update({ is_active: !plan.is_active })
        .eq('id', plan.id);
      if (error) throw error;
      await loadPlans();
    } catch {
      showToast('Errore nell\'aggiornamento del piano', 'error');
    }
  };

  const filtered = banners;
  const pendingCount = banners.filter(b => b.status === 'pending').length;
  const activeCount = banners.filter(isBannerActive).length;

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
          <ImageIcon className="w-6 h-6 text-blue-600" />
          Banner Pubblicitari
          <span className="ml-2 text-sm font-normal text-gray-500">({banners.length} totali)</span>
        </h2>
        <button onClick={loadBanners}
          className="flex items-center gap-2 bg-white border border-gray-300 text-gray-700 px-3 py-2 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium">
          <RefreshCw className="w-4 h-4" /> Aggiorna
        </button>
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <div className="bg-white rounded-xl border border-gray-200 p-4">
          <p className="text-xs text-gray-500 uppercase tracking-wide">Totale</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{banners.length}</p>
        </div>
        <div className="bg-amber-50 rounded-xl border border-amber-200 p-4">
          <p className="text-xs text-amber-700 uppercase tracking-wide">In attesa</p>
          <p className="text-2xl font-bold text-amber-800 mt-1">{pendingCount}</p>
        </div>
        <div className="bg-green-50 rounded-xl border border-green-200 p-4">
          <p className="text-xs text-green-700 uppercase tracking-wide">Attivi ora</p>
          <p className="text-2xl font-bold text-green-800 mt-1">{activeCount}</p>
        </div>
        <div className="bg-blue-50 rounded-xl border border-blue-200 p-4">
          <p className="text-xs text-blue-700 uppercase tracking-wide">Piani attivi</p>
          <p className="text-2xl font-bold text-blue-800 mt-1">{plans.filter(p => p.is_active).length}</p>
        </div>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap items-center gap-3 mb-6">
        <div className="flex items-center gap-2 text-sm text-gray-600">
          <Filter className="w-4 h-4" />
        </div>
        <select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500">
          <option value="all">Tutti gli stati</option>
          <option value="pending">In attesa</option>
          <option value="approved">Approvati</option>
          <option value="rejected">Rifiutati</option>
          <option value="expired">Scaduti</option>
          <option value="paused">In pausa</option>
        </select>
        <select value={filterPosition} onChange={e => setFilterPosition(e.target.value)}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500">
          <option value="all">Tutte le posizioni</option>
          {Object.entries(POSITION_LABELS).map(([key, label]) => (
            <option key={key} value={key}>{label}</option>
          ))}
        </select>
      </div>

      {/* Plans overview */}
      <div className="bg-white rounded-2xl border border-gray-200 p-5 mb-6">
        <h3 className="text-sm font-bold text-gray-900 mb-3">Piani Banner ({plans.length})</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
          {plans.map(plan => (
            <div key={plan.id} className={`rounded-xl border p-3 flex items-center justify-between ${plan.is_active ? 'border-gray-200 bg-gray-50' : 'border-gray-200 opacity-60'}`}>
              <div>
                <p className="text-xs font-semibold text-gray-900">{plan.position_label}</p>
                <p className="text-xs text-gray-500">{plan.duration_days} giorni · €{Number(plan.price).toFixed(2)} + IVA</p>
              </div>
              <button onClick={() => togglePlanActive(plan)}
                className={`px-2.5 py-1 rounded-lg text-xs font-semibold transition-colors ${plan.is_active ? 'bg-green-100 text-green-700 hover:bg-green-200' : 'bg-gray-200 text-gray-600 hover:bg-gray-300'}`}>
                {plan.is_active ? 'Attivo' : 'Disattivato'}
              </button>
            </div>
          ))}
        </div>
      </div>

      {/* Banners list */}
      {loading ? (
        <div className="flex items-center justify-center py-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        </div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-12 text-gray-500">
          <ImageIcon className="w-12 h-12 mx-auto mb-3 text-gray-300" />
          <p>Nessun banner trovato.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map(banner => {
            const sc = STATUS_CONFIG[banner.status] || STATUS_CONFIG.pending;
            const SIcon = sc.icon;
            const active = isBannerActive(banner);
            return (
              <div key={banner.id} className="bg-white rounded-xl border border-gray-200 p-4 flex flex-col md:flex-row gap-4 items-start">
                {/* Thumbnail */}
                <div className="w-full md:w-48 flex-shrink-0">
                  <div className="relative w-full aspect-[4/1] rounded-lg overflow-hidden bg-gray-100 border border-gray-200">
                    {banner.image_url ? (
                      <img src={banner.image_url} alt={banner.alt_text || 'Banner'} className="w-full h-full object-cover" />
                    ) : (
                      <div className="flex items-center justify-center h-full"><ImageIcon className="w-6 h-6 text-gray-400" /></div>
                    )}
                    {active && (
                      <span className="absolute top-1 right-1 bg-green-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full">LIVE</span>
                    )}
                  </div>
                </div>

                {/* Info */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap mb-1">
                    <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-semibold ${sc.bg} ${sc.color}`}>
                      <SIcon className="w-3 h-3" /> {sc.label}
                    </span>
                    <span className="text-xs text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">
                      {POSITION_LABELS[banner.position] || banner.position}
                    </span>
                    {banner.plan && (
                      <span className="text-xs text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">
                        {banner.plan.duration_days} giorni
                      </span>
                    )}
                  </div>
                  {banner.alt_text && <p className="text-sm text-gray-900 font-medium truncate">{banner.alt_text}</p>}
                  {banner.link_url && (
                    <a href={banner.link_url} target="_blank" rel="noopener noreferrer"
                      className="text-xs text-blue-600 hover:text-blue-700 flex items-center gap-1 mt-0.5 truncate">
                      <ExternalLink className="w-3 h-3" /> {banner.link_url}
                    </a>
                  )}
                  <div className="flex items-center gap-3 text-xs text-gray-500 mt-1.5">
                    <span className="flex items-center gap-1"><Calendar className="w-3 h-3" /> {formatDate(banner.start_date)} → {formatDate(banner.end_date)}</span>
                    <span className="flex items-center gap-1"><Euro className="w-3 h-3" /> €{Number(banner.price_paid).toFixed(2)}</span>
                  </div>
                  {banner.admin_notes && (
                    <p className="text-xs text-gray-500 mt-1 italic">Note admin: {banner.admin_notes}</p>
                  )}
                </div>

                {/* Actions */}
                <div className="flex items-center gap-2 flex-shrink-0">
                  <button onClick={() => setSelectedBanner(banner)}
                    className="p-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-600 transition-colors" title="Anteprima">
                    <Eye className="w-4 h-4" />
                  </button>
                  {banner.status === 'pending' && (
                    <>
                      <button onClick={() => updateBannerStatus(banner.id, 'approved')}
                        className="p-2 rounded-lg bg-green-100 hover:bg-green-200 text-green-700 transition-colors" title="Approva">
                        <CheckCircle className="w-4 h-4" />
                      </button>
                      <button onClick={() => {
                        const notes = prompt('Motivo del rifiuto (opzionale):') || '';
                        updateBannerStatus(banner.id, 'rejected', notes);
                      }}
                        className="p-2 rounded-lg bg-red-100 hover:bg-red-200 text-red-700 transition-colors" title="Rifiuta">
                        <XCircle className="w-4 h-4" />
                      </button>
                    </>
                  )}
                  {banner.status === 'approved' && (
                    <button onClick={() => updateBannerStatus(banner.id, 'paused')}
                      className="p-2 rounded-lg bg-blue-100 hover:bg-blue-200 text-blue-700 transition-colors" title="Metti in pausa">
                      <PauseCircle className="w-4 h-4" />
                    </button>
                  )}
                  {banner.status === 'paused' && (
                    <button onClick={() => updateBannerStatus(banner.id, 'approved')}
                      className="p-2 rounded-lg bg-green-100 hover:bg-green-200 text-green-700 transition-colors" title="Riattiva">
                      <PlayCircle className="w-4 h-4" />
                    </button>
                  )}
                  <button onClick={() => deleteBanner(banner.id)}
                    className="p-2 rounded-lg bg-red-50 hover:bg-red-100 text-red-600 transition-colors" title="Elimina">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Preview modal */}
      {selectedBanner && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50" onClick={() => setSelectedBanner(null)}>
          <div className="bg-white rounded-2xl max-w-3xl w-full p-6" onClick={e => e.stopPropagation()}>
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-bold text-gray-900">Anteprima Banner</h3>
              <button onClick={() => setSelectedBanner(null)} className="text-gray-400 hover:text-gray-600 text-xl">✕</button>
            </div>
            <div className="w-full aspect-[4/1] rounded-xl overflow-hidden bg-gray-100 border border-gray-200 mb-4">
              <img src={selectedBanner.image_url} alt={selectedBanner.alt_text || 'Banner'} className="w-full h-full object-cover" />
            </div>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div><span className="text-gray-500">Posizione:</span> <span className="font-medium">{POSITION_LABELS[selectedBanner.position]}</span></div>
              <div><span className="text-gray-500">Stato:</span> <span className="font-medium">{STATUS_CONFIG[selectedBanner.status]?.label}</span></div>
              <div><span className="text-gray-500">Inizio:</span> <span className="font-medium">{formatDate(selectedBanner.start_date)}</span></div>
              <div><span className="text-gray-500">Fine:</span> <span className="font-medium">{formatDate(selectedBanner.end_date)}</span></div>
              <div><span className="text-gray-500">Prezzo:</span> <span className="font-medium">€{Number(selectedBanner.price_paid).toFixed(2)} + IVA</span></div>
              <div><span className="text-gray-500">Link:</span> <span className="font-medium truncate">{selectedBanner.link_url || '—'}</span></div>
            </div>
            {selectedBanner.status === 'pending' && (
              <div className="flex gap-3 mt-5">
                <button onClick={() => updateBannerStatus(selectedBanner.id, 'approved')}
                  className="flex-1 flex items-center justify-center gap-2 bg-green-600 text-white px-4 py-2.5 rounded-lg hover:bg-green-700 font-semibold text-sm">
                  <CheckCircle className="w-4 h-4" /> Approva
                </button>
                <button onClick={() => {
                  const notes = prompt('Motivo del rifiuto (opzionale):') || '';
                  updateBannerStatus(selectedBanner.id, 'rejected', notes);
                }}
                  className="flex-1 flex items-center justify-center gap-2 bg-red-600 text-white px-4 py-2.5 rounded-lg hover:bg-red-700 font-semibold text-sm">
                  <XCircle className="w-4 h-4" /> Rifiuta
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
