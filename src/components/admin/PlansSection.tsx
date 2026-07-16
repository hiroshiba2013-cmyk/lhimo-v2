import { useState, useEffect } from 'react';
import {
  CreditCard, Save, X, CheckCircle, Users, Clock, Plus, Trash2,
  Star, Heart, MessageSquare, Bookmark, Briefcase, ShoppingBag,
  Trophy, Shield, Tag, Eye, TrendingUp, Bell,
  Flag, Building2,
} from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface FeatureDef {
  key: string;
  label: string;
  description: string;
  category: string;
  icon: React.ElementType;
  iconColor: string;
  fill?: boolean;
}

const PRIVATE_FEATURES: FeatureDef[] = [
  { key: 'reviews', label: 'Scrivi recensioni', description: 'Pubblica recensioni su attività locali', category: 'default', icon: Star, iconColor: 'text-yellow-500', fill: true },
  { key: 'classified_ads', label: 'Pubblica annunci', description: 'Inserisci annunci nella sezione classificati', category: 'default', icon: ShoppingBag, iconColor: 'text-blue-600' },
  { key: 'job_seeker', label: 'Cerca lavoro', description: 'Accedi alle offerte di lavoro e candidature', category: 'default', icon: Briefcase, iconColor: 'text-gray-700' },
  { key: 'leaderboard', label: 'Classifica punti', description: 'Partecipa alla classifica e guadagna premi', category: 'default', icon: Trophy, iconColor: 'text-yellow-600' },
  { key: 'solidarity', label: '10% Beneficenza annuale', description: "Il 10% del fatturato va in beneficenza", category: 'default', icon: Heart, iconColor: 'text-green-600', fill: true },
  { key: 'annual_discount', label: 'Sconto con piano annuale', description: 'Sconto speciale attivando un piano annuale', category: 'optional', icon: Star, iconColor: 'text-yellow-500', fill: true },
];

const BUSINESS_FEATURES: FeatureDef[] = [
  { key: 'claim_business', label: 'Profilo verificato', description: 'Rivendica e verifica la tua attività sulla piattaforma', category: 'default', icon: Shield, iconColor: 'text-blue-600' },
  { key: 'review_responses', label: 'Risposte alle recensioni', description: 'Rispondi pubblicamente alle recensioni dei clienti', category: 'default', icon: MessageSquare, iconColor: 'text-blue-500' },
  { key: 'view_reviews', label: 'Vedere recensioni altre aziende', description: 'Accedi alle recensioni di tutte le aziende', category: 'default', icon: Eye, iconColor: 'text-teal-600' },
  { key: 'priority_visibility', label: 'Priorità visibilità', description: 'La tua attività appare in cima ai risultati di ricerca', category: 'default', icon: TrendingUp, iconColor: 'text-orange-500' },
  { key: 'job_postings', label: 'Inserire annunci di lavoro', description: 'Pubblica offerte di lavoro per la tua azienda', category: 'default', icon: Briefcase, iconColor: 'text-gray-700' },
  { key: 'solidarity', label: '10% Beneficenza annuale', description: "Il 10% del fatturato va in beneficenza", category: 'default', icon: Heart, iconColor: 'text-green-600', fill: true },
  { key: 'discounts', label: 'Pubblica sconti e coupon', description: 'Crea offerte e sconti esclusivi per i tuoi clienti', category: 'optional', icon: Tag, iconColor: 'text-orange-600' },
  { key: 'messages', label: 'Messaggistica', description: 'Invia e ricevi messaggi privati con clienti e utenti', category: 'optional', icon: MessageSquare, iconColor: 'text-green-600' },
  { key: 'multiple_locations', label: 'Sedi multiple', description: 'Gestisci più sedi o filiali della tua attività', category: 'optional', icon: Building2, iconColor: 'text-gray-700' },
  { key: 'reports', label: 'Segnala recensioni/annunci', description: 'Segnala contenuti inappropriati o recensioni false', category: 'optional', icon: Flag, iconColor: 'text-red-500' },
  { key: 'notifications', label: 'Ricevi notifiche', description: 'Ricevi notifiche push in tempo reale', category: 'optional', icon: Bell, iconColor: 'text-blue-500' },
  { key: 'favorites', label: 'Salva preferiti', description: 'Salva attività e annunci nei preferiti', category: 'optional', icon: Bookmark, iconColor: 'text-purple-600' },
  { key: 'annual_discount', label: 'Sconto con piano annuale', description: 'Sconto speciale attivando un piano annuale', category: 'optional', icon: Star, iconColor: 'text-yellow-500', fill: true },
];

const CATEGORY_LABELS: Record<string, string> = {
  default: 'Funzionalità Incluse',
  optional: 'Funzionalità Aggiuntive',
};

interface Plan {
  id: string;
  name: string;
  price: number;
  billing_period: string;
  max_persons: number;
  features: string[];
  created_at: string;
}

function parsePlanFeatures(raw: any): string[] {
  if (!raw) return [];
  if (Array.isArray(raw)) return raw.map(String);
  if (typeof raw === 'string') {
    try { return JSON.parse(raw); } catch { return []; }
  }
  return [];
}

export function PlansSection() {
  const { showToast: addToast } = useToast();
  const [plans, setPlans] = useState<Plan[]>([]);
  const [loading, setLoading] = useState(true);
  const [editingPlan, setEditingPlan] = useState<Plan | null>(null);
  const [saving, setSaving] = useState(false);
  const [showAddForm, setShowAddForm] = useState(false);
  const [newPlan, setNewPlan] = useState<Partial<Plan>>({
    name: '',
    price: 0,
    max_persons: 1,
    billing_period: 'monthly',
    features: [],
  });

  useEffect(() => { loadPlans(); }, []);

  const loadPlans = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('subscription_plans')
        .select('*')
        .order('price', { ascending: true });
      if (error) throw error;
      setPlans((data || []).map((p: any) => ({ ...p, features: parsePlanFeatures(p.features) })));
    } catch {
      addToast('Errore nel caricamento dei piani', 'error');
    } finally {
      setLoading(false);
    }
  };

  const savePlan = async () => {
    if (!editingPlan) return;
    try {
      setSaving(true);
      const { error } = await supabase
        .from('subscription_plans')
        .update({
          name: editingPlan.name,
          price: editingPlan.price,
          max_persons: editingPlan.max_persons,
          billing_period: editingPlan.billing_period,
          features: editingPlan.features,
        })
        .eq('id', editingPlan.id);
      if (error) throw error;
      addToast('Piano salvato con successo', 'success');
      setEditingPlan(null);
      await loadPlans();
    } catch {
      addToast('Errore nel salvataggio', 'error');
    } finally {
      setSaving(false);
    }
  };

  const createPlan = async () => {
    try {
      setSaving(true);
      const { error } = await supabase
        .from('subscription_plans')
        .insert([{
          name: newPlan.name,
          price: newPlan.price,
          max_persons: newPlan.max_persons,
          billing_period: newPlan.billing_period,
          features: newPlan.features || [],
        }]);
      if (error) throw error;
      addToast('Piano creato con successo', 'success');
      setShowAddForm(false);
      setNewPlan({ name: '', price: 0, max_persons: 1, billing_period: 'monthly', features: [] });
      await loadPlans();
    } catch {
      addToast('Errore nella creazione', 'error');
    } finally {
      setSaving(false);
    }
  };

  const deletePlan = async (id: string) => {
    if (!confirm('Sei sicuro di voler eliminare questo piano?')) return;
    try {
      const { error } = await supabase.from('subscription_plans').delete().eq('id', id);
      if (error) throw error;
      addToast('Piano eliminato', 'success');
      await loadPlans();
    } catch {
      addToast("Errore nell'eliminazione", 'error');
    }
  };

  const toggleFeature = (key: string) => {
    setEditingPlan(prev => {
      if (!prev) return prev;
      const has = prev.features.includes(key);
      return { ...prev, features: has ? prev.features.filter(f => f !== key) : [...prev.features, key] };
    });
  };

  const toggleNewFeature = (key: string) => {
    setNewPlan(prev => {
      const features = prev.features || [];
      const has = features.includes(key);
      return { ...prev, features: has ? features.filter(f => f !== key) : [...features, key] };
    });
  };

  const planIsBusiness = (name: string) => name.toLowerCase().includes('business');

  const renderFeatureEditor = (
    features: string[],
    featureSet: FeatureDef[],
    onToggle: (key: string) => void
  ) => {
    const categories = [...new Set(featureSet.map(f => f.category))];
    return (
      <div className="space-y-3">
        {categories.map(cat => (
          <div key={cat}>
            <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5">{CATEGORY_LABELS[cat] || cat}</p>
            <div className="grid grid-cols-1 gap-1.5">
              {featureSet.filter(f => f.category === cat).map(f => {
                const Icon = f.icon;
                const checked = features.includes(f.key);
                return (
                  <label key={f.key} className={`flex items-start gap-2.5 p-2.5 rounded-lg border cursor-pointer transition-colors ${checked ? 'bg-blue-50 border-blue-200' : 'bg-gray-50 border-gray-200 hover:bg-gray-100'}`}>
                    <input type="checkbox" checked={checked} onChange={() => onToggle(f.key)}
                      className="mt-0.5 rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                    <div className="flex items-center gap-2 flex-1">
                      <Icon className={`w-4 h-4 flex-shrink-0 ${f.iconColor}`} {...(f.fill ? { fill: 'currentColor' } : {})} />
                      <div>
                        <p className="text-sm font-medium text-gray-900">{f.label}</p>
                        <p className="text-xs text-gray-500">{f.description}</p>
                      </div>
                    </div>
                  </label>
                );
              })}
            </div>
          </div>
        ))}
      </div>
    );
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
          <CreditCard className="w-6 h-6 text-blue-600" />
          Gestione Piani
          <span className="ml-2 text-sm font-normal text-gray-500">({plans.length} piani)</span>
        </h2>
        <button onClick={() => setShowAddForm(true)}
          className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors text-sm font-semibold">
          <Plus className="w-4 h-4" />Nuovo Piano
        </button>
      </div>

      {showAddForm && (
        <div className="bg-white rounded-xl border border-blue-200 shadow-lg p-6 mb-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-bold text-gray-900">Crea nuovo piano</h3>
            <button onClick={() => setShowAddForm(false)} className="text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Nome piano</label>
              <input type="text" value={newPlan.name || ''} onChange={e => setNewPlan(p => ({ ...p, name: e.target.value }))}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Prezzo (€)</label>
              <input type="number" step="0.01" value={newPlan.price || 0} onChange={e => setNewPlan(p => ({ ...p, price: parseFloat(e.target.value) }))}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Max persone / sedi</label>
              <input type="number" value={newPlan.max_persons || 1} onChange={e => setNewPlan(p => ({ ...p, max_persons: parseInt(e.target.value) }))}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Periodo fatturazione</label>
              <select value={newPlan.billing_period || 'monthly'} onChange={e => setNewPlan(p => ({ ...p, billing_period: e.target.value }))}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                <option value="monthly">Mensile</option>
                <option value="yearly">Annuale</option>
              </select>
            </div>
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-2">Funzionalità</label>
            {renderFeatureEditor(
              newPlan.features || [],
              planIsBusiness(newPlan.name || '') ? BUSINESS_FEATURES : PRIVATE_FEATURES,
              toggleNewFeature
            )}
          </div>
          <div className="flex justify-end gap-3">
            <button onClick={() => setShowAddForm(false)} className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 text-sm">Annulla</button>
            <button onClick={createPlan} disabled={saving}
              className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50 text-sm font-semibold">
              {saving ? <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div> : <Save className="w-4 h-4" />}
              Crea Piano
            </button>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
        {plans.map(plan => {
          const isEditing = editingPlan?.id === plan.id;
          const isB = planIsBusiness(plan.name);
          const featureSet = isB ? BUSINESS_FEATURES : PRIVATE_FEATURES;
          const currentFeatures = isEditing ? editingPlan!.features : plan.features;
          const isAnnual = plan.billing_period === 'yearly' || plan.billing_period === 'annual';

          return (
            <div key={plan.id} className={`bg-white rounded-2xl border shadow-sm overflow-hidden ${isEditing ? 'border-blue-400 ring-2 ring-blue-200' : 'border-gray-200'}`}>
              <div className={`p-4 ${isB ? 'bg-gradient-to-r from-blue-600 to-blue-700' : 'bg-gradient-to-r from-gray-700 to-gray-800'}`}>
                <div className="flex items-start justify-between gap-2">
                  <div className="flex-1 min-w-0">
                    {isEditing ? (
                      <input type="text" value={editingPlan!.name}
                        onChange={e => setEditingPlan(p => p ? { ...p, name: e.target.value } : p)}
                        className="text-white bg-white/20 border border-white/40 rounded px-2 py-1 text-base font-bold w-full mb-1" />
                    ) : (
                      <h3 className="text-base font-bold text-white leading-tight mb-1">{plan.name}</h3>
                    )}
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="flex items-center gap-1 text-white/70 text-xs">
                        <Users className="w-3 h-3" />Max {plan.max_persons === 999 ? '∞' : plan.max_persons}
                      </span>
                      <span className="flex items-center gap-1 text-white/70 text-xs">
                        <Clock className="w-3 h-3" />{isAnnual ? 'Annuale' : 'Mensile'}
                      </span>
                    </div>
                  </div>
                  <div className="text-right flex-shrink-0">
                    <div className="text-xl font-bold text-white">€{Number(plan.price).toFixed(2)}</div>
                    <div className="text-white/70 text-xs">{isAnnual ? '/anno' : '/mese'}</div>
                  </div>
                </div>
              </div>

              <div className="p-4">
                {isEditing ? (
                  <>
                    <div className="grid grid-cols-2 gap-3 mb-4">
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Prezzo (€)</label>
                        <input type="number" step="0.01" value={editingPlan!.price}
                          onChange={e => setEditingPlan(p => p ? { ...p, price: parseFloat(e.target.value) } : p)}
                          className="w-full border border-gray-300 rounded-lg px-2 py-1.5 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Max persone/sedi</label>
                        <input type="number" value={editingPlan!.max_persons}
                          onChange={e => setEditingPlan(p => p ? { ...p, max_persons: parseInt(e.target.value) } : p)}
                          className="w-full border border-gray-300 rounded-lg px-2 py-1.5 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                      </div>
                      <div className="col-span-2">
                        <label className="block text-xs font-medium text-gray-600 mb-1">Periodo</label>
                        <select value={editingPlan!.billing_period}
                          onChange={e => setEditingPlan(p => p ? { ...p, billing_period: e.target.value } : p)}
                          className="w-full border border-gray-300 rounded-lg px-2 py-1.5 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                          <option value="monthly">Mensile</option>
                          <option value="yearly">Annuale</option>
                        </select>
                      </div>
                    </div>
                    <div className="mb-4">
                      <label className="block text-xs font-medium text-gray-600 mb-2">Funzionalità</label>
                      {renderFeatureEditor(editingPlan!.features, featureSet, toggleFeature)}
                    </div>
                    <div className="flex gap-2">
                      <button onClick={savePlan} disabled={saving}
                        className="flex-1 flex items-center justify-center gap-2 bg-blue-600 text-white px-3 py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50 text-sm font-semibold">
                        {saving ? <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div> : <Save className="w-4 h-4" />}
                        Salva
                      </button>
                      <button onClick={() => setEditingPlan(null)}
                        className="px-3 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 text-sm">
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                  </>
                ) : (
                  <>
                    {(() => {
                      const categories = [...new Set(featureSet.map(f => f.category))];
                      const hasAny = currentFeatures.length > 0;
                      return (
                        <div className="space-y-2 mb-4">
                          {hasAny ? categories.map(cat => {
                            const catFeatures = featureSet.filter(f => f.category === cat && currentFeatures.includes(f.key));
                            if (catFeatures.length === 0) return null;
                            return (
                              <div key={cat}>
                                <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-1">{CATEGORY_LABELS[cat] || cat}</p>
                                <div className="space-y-1">
                                  {catFeatures.map(f => {
                                    const Icon = f.icon;
                                    return (
                                      <div key={f.key} className="flex items-center gap-2 text-sm text-gray-700">
                                        <Icon className={`w-3.5 h-3.5 ${f.iconColor} flex-shrink-0`} {...(f.fill ? { fill: 'currentColor' } : {})} />
                                        <span>{f.label}</span>
                                      </div>
                                    );
                                  })}
                                </div>
                              </div>
                            );
                          }) : (
                            <p className="text-xs text-gray-400 italic">Nessuna funzionalità selezionata</p>
                          )}
                        </div>
                      );
                    })()}

                    <div className="flex gap-2">
                      <button onClick={() => setEditingPlan({ ...plan })}
                        className="flex-1 flex items-center justify-center gap-2 bg-blue-50 text-blue-700 border border-blue-200 px-3 py-2 rounded-lg hover:bg-blue-100 text-sm font-medium transition-colors">
                        Modifica
                      </button>
                      <button onClick={() => deletePlan(plan.id)}
                        className="px-3 py-2 text-red-600 border border-red-200 bg-red-50 rounded-lg hover:bg-red-100 transition-colors">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {plans.length === 0 && (
        <div className="text-center py-12 text-gray-500">
          <CreditCard className="w-12 h-12 mx-auto mb-3 text-gray-300" />
          <p>Nessun piano trovato. Crea il primo piano!</p>
        </div>
      )}
    </div>
  );
}
