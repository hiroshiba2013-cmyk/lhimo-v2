import { useState, useEffect, useRef } from 'react';
import { Building2, CheckCircle, UserPlus, MapPin, Eye, Trash2, X, Search, ShieldCheck, Clock } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { AdminLocationFilter, LocationFilterState } from './AdminLocationFilter';
import { useToast } from '../common/Toast';

interface BusinessActivity {
  id: string;
  name: string;
  city: string;
  province: string;
  region?: string;
  street?: string;
  type: 'claimed' | 'user_added' | 'imported' | 'registered';
  created_at: string;
  verified?: boolean;
  approval_status?: string;
  category_name?: string;
  owner_name?: string;
  owner_email?: string;
  added_by_name?: string;
  added_by_email?: string;
}

interface Props { onReload: () => void; }

export function BusinessTrackingSection({ onReload }: Props) {
  const { showToast } = useToast();
  const [activities, setActivities] = useState<BusinessActivity[]>([]);
  const [loading, setLoading] = useState(true);
  const [typeFilter, setTypeFilter] = useState<'all' | 'claimed' | 'user_added' | 'imported' | 'registered'>('all');
  const [locationFilter, setLocationFilter] = useState<LocationFilterState>({ region: '', province: '', provinceCode: '', city: '' });
  const [nameSearch, setNameSearch] = useState('');
  const [selectedBusiness, setSelectedBusiness] = useState<BusinessActivity | null>(null);
  const [debugInfo, setDebugInfo] = useState<string>('');
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => { loadActivities(); }, 300);
    return () => { if (debounceRef.current) clearTimeout(debounceRef.current); };
  }, [typeFilter, locationFilter, nameSearch]);

  const loadActivities = async () => {
    setLoading(true);
    const params = {
      p_type: typeFilter,
      p_province: locationFilter.provinceCode || null,
      p_city: locationFilter.city || null,
      p_region: locationFilter.region || null,
      p_name: nameSearch || null,
      p_limit: 300,
    };
    setDebugInfo(`Chiamata RPC con: ${JSON.stringify(params)}`);
    try {
      const { data, error } = await supabase.rpc('search_business_tracking', params);
      if (error) {
        setDebugInfo(`ERRORE RPC: ${error.message} | codice: ${error.code} | dettaglio: ${error.details}`);
        setActivities([]);
      } else {
        setDebugInfo(`OK - ${(data || []).length} risultati | params: ${JSON.stringify(params)}`);
        setActivities(data || []);
      }
    } catch (err: any) {
      setDebugInfo(`ECCEZIONE: ${err?.message}`);
      setActivities([]);
    } finally {
      setLoading(false);
    }
  };

  const getTypeBadge = (type: string) => {
    switch (type) {
      case 'registered': return { bg: 'bg-blue-100 text-blue-700', label: 'Registrata', icon: <Building2 className="w-3.5 h-3.5" /> };
      case 'claimed':    return { bg: 'bg-green-100 text-green-700', label: 'Rivendicata', icon: <CheckCircle className="w-3.5 h-3.5" /> };
      case 'user_added': return { bg: 'bg-amber-100 text-amber-700', label: 'Aggiunta Utente', icon: <UserPlus className="w-3.5 h-3.5" /> };
      case 'imported':   return { bg: 'bg-gray-100 text-gray-700', label: 'Importata', icon: <MapPin className="w-3.5 h-3.5" /> };
      default:           return { bg: 'bg-gray-100 text-gray-700', label: type, icon: null };
    }
  };

  const deleteBusiness = async (business: BusinessActivity) => {
    if (!confirm(`Eliminare "${business.name}"?`)) return;
    try {
      const table = business.type === 'registered' ? 'registered_businesses' : 'unclaimed_business_locations';
      const { error } = await supabase.from(table).delete().eq('id', business.id);
      if (error) throw error;
      loadActivities();
      onReload();
      setSelectedBusiness(null);
    } catch (err: any) {
      showToast(`Errore: ${err.message}`, 'error');
    }
  };

  const resetFilters = () => {
    setLocationFilter({ region: '', province: '', provinceCode: '', city: '' });
    setNameSearch('');
  };

  const hasActiveFilter = !!(locationFilter.region || locationFilter.provinceCode || locationFilter.city || nameSearch);

  return (
    <div>
      {/* Hero Banner */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6 mb-6">
        <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(circle, #fff 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
        <div className="relative z-10">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <p className="text-xs font-semibold uppercase tracking-widest text-gray-400 mb-1">Monitoraggio</p>
              <div className="flex items-center gap-3">
                <h2 className="text-2xl font-bold text-white">Attività Commerciali</h2>
                <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-white/10 text-white border border-white/20">
                  {loading ? '...' : activities.length}
                </span>
              </div>
            </div>
            <div className="flex gap-2 flex-wrap">
              {(['all', 'claimed', 'user_added', 'imported', 'registered'] as const).map(t => (
                <button key={t} onClick={() => setTypeFilter(t)}
                  className={`rounded-xl px-4 py-2 text-sm font-medium transition-all ${typeFilter === t ? 'bg-white text-gray-900 shadow' : 'bg-white/10 text-white hover:bg-white/20'}`}>
                  {{ all: 'Tutte', claimed: 'Rivendicate', user_added: 'Aggiunte', imported: 'Importate', registered: 'Registrate' }[t]}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* DEBUG PANEL - rimuovere dopo il fix */}
      {debugInfo && (
        <div className="bg-yellow-50 border border-yellow-300 rounded-xl p-3 mb-4 text-xs font-mono text-yellow-900 break-all">
          {debugInfo}
        </div>
      )}

      {/* Filters */}
      <div className="bg-white rounded-xl border border-gray-200 p-4 mb-4 space-y-3">
        <div className="flex items-center justify-between">
          <span className="text-sm font-medium text-gray-700">Filtri di ricerca</span>
          {hasActiveFilter && (
            <button onClick={resetFilters} className="flex items-center gap-1 text-xs text-gray-500 hover:text-gray-700 transition-colors">
              <X className="w-3.5 h-3.5" /> Rimuovi filtri
            </button>
          )}
        </div>
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
          <input
            type="text"
            placeholder="Cerca per nome attività..."
            value={nameSearch}
            onChange={e => setNameSearch(e.target.value)}
            className="w-full pl-9 pr-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
        <AdminLocationFilter value={locationFilter} onChange={setLocationFilter} />
      </div>

      {/* Results */}
      {loading ? (
        <div className="text-center py-12">
          <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-gray-700 mx-auto mb-3" />
          <p className="text-sm text-gray-500">Caricamento attività...</p>
        </div>
      ) : activities.length === 0 ? (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-10 text-center">
          <Building2 className="w-10 h-10 text-gray-300 mx-auto mb-3" />
          <p className="text-sm font-medium text-gray-600">Nessuna attività trovata</p>
          <p className="text-xs text-gray-400 mt-1">
            {hasActiveFilter ? 'Prova a modificare o rimuovere i filtri' : 'Non ci sono attività da visualizzare'}
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {activities.map(activity => {
            const badge = getTypeBadge(activity.type);
            const person = activity.owner_name || activity.added_by_name;
            const personEmail = activity.owner_email || activity.added_by_email;
            return (
              <div key={`${activity.type}-${activity.id}`} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 hover:shadow-md transition-shadow">
                <div className="flex flex-col sm:flex-row sm:items-center gap-3">
                  <div className="flex items-start gap-3 flex-1 min-w-0">
                    {activity.verified && <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0 mt-0.5" />}
                    <div className="min-w-0">
                      <div className="text-sm font-semibold text-gray-900 truncate">{activity.name}</div>
                      {activity.category_name && <div className="text-xs text-blue-600 font-medium mt-0.5">{activity.category_name}</div>}
                      {activity.street && <div className="text-xs text-gray-500 mt-0.5 truncate">{activity.street}</div>}
                    </div>
                  </div>
                  <span className={`inline-flex items-center gap-1.5 px-3 py-1 text-xs font-semibold rounded-full flex-shrink-0 ${badge.bg}`}>
                    {badge.icon}{badge.label}
                  </span>
                  {/* Approval status badge for user-added businesses */}
                  {activity.type === 'user_added' && (
                    activity.approval_status === 'approved' ? (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0 bg-green-100 text-green-700">
                        <ShieldCheck className="w-3 h-3" />
                        Approvata
                      </span>
                    ) : activity.approval_status === 'rejected' ? (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0 bg-red-100 text-red-700">
                        <X className="w-3 h-3" />
                        Rifiutata
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0 bg-yellow-100 text-yellow-700">
                        <Clock className="w-3 h-3" />
                        In attesa
                      </span>
                    )
                  )}
                  <div className="flex-shrink-0 hidden md:block text-right">
                    <div className="text-sm text-gray-900">{activity.city || '—'}</div>
                    <div className="text-xs text-gray-500">{activity.province || '—'}</div>
                  </div>
                  {person && (
                    <div className="flex-shrink-0 hidden lg:block">
                      <div className="text-sm font-medium text-gray-900">{person}</div>
                      <div className="text-xs text-gray-500">{personEmail}</div>
                    </div>
                  )}
                  {!person && <span className="text-sm text-gray-400 hidden lg:block flex-shrink-0">Sistema</span>}
                  <span className="text-sm text-gray-500 flex-shrink-0 hidden sm:block">
                    {new Date(activity.created_at).toLocaleDateString('it-IT')}
                  </span>
                  <div className="flex items-center gap-2 flex-shrink-0">
                    <button onClick={() => setSelectedBusiness(activity)} className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-all" title="Dettagli">
                      <Eye className="w-4 h-4" />
                    </button>
                    <button onClick={() => deleteBusiness(activity)} className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-all" title="Elimina">
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Detail modal */}
      {selectedBusiness && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-xl">
            <div className="bg-gradient-to-r from-gray-800 to-gray-900 text-white px-6 py-5 rounded-t-2xl flex items-center justify-between">
              <h3 className="text-xl font-bold">Dettagli Attività</h3>
              <button onClick={() => setSelectedBusiness(null)} className="text-white/70 hover:text-white text-2xl font-bold leading-none">×</button>
            </div>
            <div className="p-6 space-y-4">
              <div><label className="text-sm font-semibold text-gray-700">Nome</label><p className="text-gray-900 mt-0.5">{selectedBusiness.name}</p></div>
              <div>
                <label className="text-sm font-semibold text-gray-700">Tipo</label>
                <div className="mt-1">
                  {(() => { const b = getTypeBadge(selectedBusiness.type); return <span className={`inline-flex items-center gap-1.5 px-3 py-1 text-xs font-semibold rounded-full ${b.bg}`}>{b.icon}{b.label}</span>; })()}
                </div>
              </div>
              {selectedBusiness.category_name && <div><label className="text-sm font-semibold text-gray-700">Categoria</label><p className="text-gray-900 mt-0.5">{selectedBusiness.category_name}</p></div>}
              <div>
                <label className="text-sm font-semibold text-gray-700">Localita</label>
                <p className="text-gray-900 mt-0.5">{[selectedBusiness.city, selectedBusiness.province].filter(Boolean).join(', ') || '—'}</p>
                {selectedBusiness.street && <p className="text-sm text-gray-600 mt-1">{selectedBusiness.street}</p>}
              </div>
              {selectedBusiness.approval_status && (
                <div>
                  <label className="text-sm font-semibold text-gray-700">Stato approvazione</label>
                  <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium mt-1 ${selectedBusiness.approval_status === 'approved' ? 'bg-green-100 text-green-700' : selectedBusiness.approval_status === 'rejected' ? 'bg-red-100 text-red-700' : 'bg-yellow-100 text-yellow-700'}`}>
                    {selectedBusiness.approval_status === 'approved' ? 'Approvata' : selectedBusiness.approval_status === 'rejected' ? 'Rifiutata' : 'In attesa'}
                  </span>
                </div>
              )}
              {selectedBusiness.owner_name && <div><label className="text-sm font-semibold text-gray-700">Proprietario</label><p className="text-gray-900 mt-0.5">{selectedBusiness.owner_name}</p><p className="text-sm text-gray-600">{selectedBusiness.owner_email}</p></div>}
              {selectedBusiness.added_by_name && <div><label className="text-sm font-semibold text-gray-700">Aggiunto da</label><p className="text-gray-900 mt-0.5">{selectedBusiness.added_by_name}</p><p className="text-sm text-gray-600">{selectedBusiness.added_by_email}</p></div>}
              {selectedBusiness.verified !== undefined && selectedBusiness.verified !== null && (
                <div><label className="text-sm font-semibold text-gray-700">Verificato</label><p className={`font-medium mt-0.5 ${selectedBusiness.verified ? 'text-green-600' : 'text-gray-600'}`}>{selectedBusiness.verified ? 'Sì' : 'No'}</p></div>
              )}
              <div><label className="text-sm font-semibold text-gray-700">Data Creazione</label><p className="text-gray-900 mt-0.5">{new Date(selectedBusiness.created_at).toLocaleString('it-IT')}</p></div>
              <div className="flex gap-3 pt-2">
                <button onClick={() => deleteBusiness(selectedBusiness)} className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 font-medium">Elimina</button>
                <button onClick={() => setSelectedBusiness(null)} className="flex-1 px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 font-medium">Chiudi</button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
