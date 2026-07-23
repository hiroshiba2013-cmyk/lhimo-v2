import { useState, useEffect } from 'react';
import { Search, Building2, MapPin, CheckCircle, XCircle, ArrowRight, Plus, ChevronLeft, ChevronRight } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useItalianLocations } from '../hooks/useItalianLocations';
import { useToast } from '../components/common/Toast';

interface LocationResult {
  id: string;
  name: string;
  street: string | null;
  city: string;
  province: string;
  region: string | null;
  postal_code: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  category_id: string | null;
  is_claimed: boolean;
  added_by: string | null;
  total_count: number;
}

const PAGE_SIZE = 50;

export function ClaimBusinessPage() {
  const { showToast } = useToast();
  const { regions, allProvinces, loading: loadingLocations, getProvincesByRegion, getProvinceCode } = useItalianLocations();
  const [businessName, setBusinessName] = useState('');
  const [address, setAddress] = useState('');
  const [region, setRegion] = useState('');
  const [province, setProvince] = useState('');
  const [provinceCode, setProvinceCode] = useState('');
  const [city, setCity] = useState('');
  const [cities, setCities] = useState<string[]>([]);
  const [loadingCities, setLoadingCities] = useState(false);

  const availableProvinces = region ? getProvincesByRegion(region) : allProvinces;

  const [results, setResults] = useState<LocationResult[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [page, setPage] = useState(1);
  const [searched, setSearched] = useState(false);
  const [loading, setLoading] = useState(false);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  // Load cities when province code changes
  useEffect(() => {
    if (!provinceCode) { setCities([]); setCity(''); return; }
    setLoadingCities(true);
    setCity('');
    supabase.rpc('get_comuni_by_provincia', { p_provincia: provinceCode }).then(({ data }) => {
      setCities((data || []).map((r: { comune: string }) => r.comune));
      setLoadingCities(false);
    });
  }, [provinceCode]);

  const doSearch = async (p: number) => {
    if (!businessName && !address && !city && !provinceCode) {
      showToast('Inserisci almeno un campo per effettuare la ricerca', 'info');
      return;
    }
    setLoading(true);
    setSearched(true);
    setSelectedIds(new Set());

    const { data, error } = await supabase.rpc('search_unclaimed_businesses', {
      p_name: businessName || null,
      p_province: provinceCode || null,
      p_city: city || null,
      p_address: address || null,
      p_page: p,
      p_page_size: PAGE_SIZE,
    });

    if (error) {
      console.error(error);
      showToast(`Errore: ${error.message}`, 'error');
      setLoading(false);
      return;
    }

    const rows: LocationResult[] = data || [];
    setResults(rows);
    setTotalCount(rows.length > 0 ? Number(rows[0].total_count) : 0);
    setPage(p);
    setLoading(false);
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    doSearch(1);
  };

  const toggleSelect = (id: string) => {
    setSelectedIds(prev => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  const handleProceed = () => {
    if (selectedIds.size === 0) { showToast('Seleziona almeno una sede da rivendicare', 'info'); return; }
    const selected = results.filter(r => selectedIds.has(r.id));
    const withSource = selected.map(r => ({ id: r.id, source: r.added_by ? 'user_added' : 'imported' }));
    sessionStorage.setItem('claimLocationIds', JSON.stringify(Array.from(selectedIds)));
    sessionStorage.setItem('claimLocationsWithSource', JSON.stringify(withSource));
    sessionStorage.setItem('claimBusinessName', selected[0]?.name || '');
    window.location.href = '/?register=business';
  };

  const handleRegisterNew = () => {
    sessionStorage.removeItem('claimLocationIds');
    sessionStorage.removeItem('claimBusinessId');
    sessionStorage.removeItem('claimBusinessKey');
    sessionStorage.removeItem('claimBusinessName');
    window.location.href = '/?register=business';
  };

  const totalPages = Math.ceil(totalCount / PAGE_SIZE);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

        {/* Header */}
        <div className="text-center mb-10">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full mb-4">
            <Building2 className="w-8 h-8 text-blue-600" />
          </div>
          <h1 className="text-4xl font-bold text-gray-900 mb-3">Verifica la Tua Attività</h1>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Cerca la tua attività per nome, provincia, comune o indirizzo. Se è già nel nostro database puoi rivendicarla e gestirla.
          </p>
        </div>

        {/* Search form */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-8">
          <form onSubmit={handleSearch} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5">Nome Attività</label>
              <input
                type="text"
                value={businessName}
                onChange={e => setBusinessName(e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                placeholder="es. Bar Centrale, Pizzeria da Mario..."
              />
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {/* Regione */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">Regione</label>
                <select
                  value={region}
                  onChange={e => {
                    setRegion(e.target.value);
                    setProvince('');
                    setProvinceCode('');
                    setCity('');
                  }}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm bg-white"
                >
                  <option value="">Tutte le regioni</option>
                  {regions.map(r => <option key={r} value={r}>{r}</option>)}
                </select>
              </div>

              {/* Provincia */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">Provincia</label>
                <select
                  value={province}
                  onChange={e => {
                    const val = e.target.value;
                    setProvince(val);
                    setProvinceCode(val ? getProvinceCode(val) : '');
                  }}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm bg-white"
                >
                  <option value="">Tutte le province</option>
                  {availableProvinces.map(p => (
                    <option key={p.sigla} value={p.nome}>{p.nome} ({p.sigla})</option>
                  ))}
                </select>
              </div>

              {/* Comune */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">Comune</label>
                <select
                  value={city}
                  onChange={e => setCity(e.target.value)}
                  disabled={!provinceCode || loadingCities}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm bg-white disabled:bg-gray-50 disabled:cursor-not-allowed"
                >
                  <option value="">
                    {loadingCities ? 'Caricamento comuni...' : !provinceCode ? 'Seleziona prima la provincia' : `Tutti i comuni (${cities.length})`}
                  </option>
                  {cities.map(c => <option key={c} value={c}>{c}</option>)}
                </select>
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5">Indirizzo</label>
              <input
                type="text"
                value={address}
                onChange={e => setAddress(e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                placeholder="es. Via Roma, Corso Italia..."
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full flex items-center justify-center gap-2 bg-blue-600 text-white px-6 py-4 rounded-xl hover:bg-blue-700 transition-colors font-semibold text-base disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <><div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white" />Ricerca in corso...</>
              ) : (
                <><Search className="w-5 h-5" />Cerca Attività</>
              )}
            </button>
          </form>
        </div>

        {/* Results */}
        {searched && !loading && (
          <div className="space-y-4">
            {results.length === 0 ? (
              <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-10 text-center">
                <div className="inline-flex items-center justify-center w-16 h-16 bg-orange-100 rounded-full mb-4">
                  <XCircle className="w-8 h-8 text-orange-500" />
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">Nessuna Attività Trovata</h3>
                <p className="text-gray-500 mb-6">Non abbiamo trovato la tua attività. Registrati per aggiungerla!</p>
                <button onClick={handleRegisterNew} className="inline-flex items-center gap-2 bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 font-semibold">
                  Registrati e Aggiungi Attività <ArrowRight className="w-4 h-4" />
                </button>
              </div>
            ) : (
              <>
                {/* Result header */}
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-xl font-bold text-gray-900">
                      {totalCount.toLocaleString('it-IT')} {totalCount === 1 ? 'attività trovata' : 'attività trovate'}
                    </h3>
                    {totalPages > 1 && (
                      <p className="text-sm text-gray-500 mt-0.5">Pagina {page} di {totalPages} — {PAGE_SIZE} risultati per pagina</p>
                    )}
                  </div>
                  {selectedIds.size > 0 && (
                    <button onClick={handleProceed} className="flex items-center gap-2 bg-blue-600 text-white px-5 py-2.5 rounded-xl hover:bg-blue-700 font-semibold text-sm">
                      Rivendica {selectedIds.size} {selectedIds.size === 1 ? 'sede' : 'sedi'} <ArrowRight className="w-4 h-4" />
                    </button>
                  )}
                </div>

                {/* List */}
                <div className="space-y-3">
                  {results.map(loc => {
                    const selected = selectedIds.has(loc.id);
                    return (
                      <div
                        key={loc.id}
                        onClick={() => toggleSelect(loc.id)}
                        className={`bg-white rounded-xl border-2 p-5 cursor-pointer transition-all hover:shadow-md ${selected ? 'border-blue-500 bg-blue-50' : 'border-gray-100 hover:border-blue-200'}`}
                      >
                        <div className="flex items-start gap-4">
                          <div className={`flex-shrink-0 w-5 h-5 mt-0.5 rounded border-2 flex items-center justify-center transition-colors ${selected ? 'bg-blue-600 border-blue-600' : 'border-gray-300'}`}>
                            {selected && <CheckCircle className="w-3.5 h-3.5 text-white" />}
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="flex items-start justify-between gap-3">
                              <h4 className="font-semibold text-gray-900">{loc.name}</h4>
                              <span className="flex-shrink-0 inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-700">
                                Disponibile
                              </span>
                            </div>
                            <div className="flex items-center gap-1.5 text-sm text-gray-600 mt-1.5">
                              <MapPin className="w-3.5 h-3.5 flex-shrink-0 text-gray-400" />
                              <span>
                                {[loc.street, loc.city, loc.province ? `(${loc.province})` : ''].filter(Boolean).join(', ')}
                              </span>
                            </div>
                            {(loc.phone || loc.email || loc.website) && (
                              <div className="mt-1.5 text-xs text-gray-500 space-x-3">
                                {loc.phone && <span>Tel: {loc.phone}</span>}
                                {loc.email && <span>Email: {loc.email}</span>}
                                {loc.website && <span>Web: {loc.website}</span>}
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* Pagination */}
                {totalPages > 1 && (
                  <div className="flex items-center justify-center gap-3 pt-4">
                    <button
                      onClick={() => doSearch(page - 1)}
                      disabled={page === 1 || loading}
                      className="flex items-center gap-1.5 px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                      <ChevronLeft className="w-4 h-4" /> Precedente
                    </button>
                    <span className="text-sm text-gray-600 font-medium">
                      {page} / {totalPages}
                    </span>
                    <button
                      onClick={() => doSearch(page + 1)}
                      disabled={page === totalPages || loading}
                      className="flex items-center gap-1.5 px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                      Successiva <ChevronRight className="w-4 h-4" />
                    </button>
                  </div>
                )}

                {/* Sticky CTA */}
                {selectedIds.size > 0 && (
                  <div className="sticky bottom-4 z-10">
                    <div className="bg-blue-600 text-white rounded-2xl p-4 shadow-2xl flex items-center justify-between gap-4">
                      <p className="font-semibold">
                        {selectedIds.size} {selectedIds.size === 1 ? 'sede selezionata' : 'sedi selezionate'}
                      </p>
                      <button onClick={handleProceed} className="flex items-center gap-2 bg-white text-blue-600 px-5 py-2 rounded-xl font-bold hover:bg-blue-50 transition-colors flex-shrink-0">
                        Rivendica e Registrati <ArrowRight className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                )}

                {/* Register new */}
                <div className="bg-blue-50 rounded-2xl p-6 border border-blue-100 flex items-start gap-4">
                  <Plus className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
                  <div>
                    <h4 className="font-bold text-gray-900 mb-1">Non vedi la tua attività?</h4>
                    <p className="text-sm text-gray-600 mb-3">Puoi registrarti e aggiungere la tua attività manualmente.</p>
                    <button onClick={handleRegisterNew} className="inline-flex items-center gap-2 bg-white text-blue-600 px-4 py-2 rounded-lg border-2 border-blue-200 hover:bg-blue-50 font-semibold text-sm transition-colors">
                      <Plus className="w-4 h-4" /> Registra Nuova Attività
                    </button>
                  </div>
                </div>
              </>
            )}
          </div>
        )}

        {/* Benefits */}
        <div className="mt-10 bg-white rounded-2xl border border-gray-100 shadow-sm p-8">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Perché Rivendicare la Tua Attività?</h3>
          <ul className="space-y-2.5 text-sm text-gray-600">
            {[
              'Gestisci le informazioni della tua attività',
              'Rispondi alle recensioni dei clienti',
              'Pubblica offerte di lavoro',
              'Ottieni il badge di verifica',
              'Accedi alle statistiche e analitiche',
            ].map(t => (
              <li key={t} className="flex items-center gap-2.5">
                <CheckCircle className="w-4 h-4 text-blue-600 flex-shrink-0" />
                <span>{t}</span>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}
