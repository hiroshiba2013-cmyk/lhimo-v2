import { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { supabase } from '../lib/supabase';
import {
  Check, Heart, Star, Shield, TrendingUp, Users, Gift,
  Trophy, MessageSquare, Bookmark, Megaphone, Briefcase,
  ShoppingBag, Eye, Tag, Map, Bell, Flag, CreditCard, Building2,
} from 'lucide-react';
import type { LucideIcon } from 'lucide-react';

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  billing_period: 'monthly' | 'yearly';
  max_persons: number;
  features: string[];
}

interface Subscription {
  id: string;
  plan: SubscriptionPlan;
  status: string;
  start_date: string;
  end_date: string;
  trial_end_date?: string;
  payment_method_added?: boolean;
  reminder_sent?: boolean;
}

interface FeatureDisplay {
  key: string;
  label: string;
  icon: LucideIcon;
  iconColor: string;
  fill?: boolean;
}

const PRIVATE_FEATURE_MAP: FeatureDisplay[] = [
  { key: 'reviews', label: 'Recensioni illimitate', icon: MessageSquare, iconColor: 'text-blue-600' },
  { key: 'classified_ads', label: 'Cerca, vendi, regala oggetti', icon: ShoppingBag, iconColor: 'text-teal-600' },
  { key: 'job_seeker', label: 'Ricerca offerte di lavoro', icon: Briefcase, iconColor: 'text-gray-700' },
  { key: 'leaderboard', label: 'Classifica a premi', icon: Trophy, iconColor: 'text-yellow-500' },
  { key: 'solidarity', label: '10% Beneficenza annuale', icon: Heart, iconColor: 'text-green-600', fill: true },
  { key: 'discounts', label: 'Sconti e coupon', icon: Tag, iconColor: 'text-orange-500' },
  { key: 'messages', label: 'Messaggistica privata', icon: MessageSquare, iconColor: 'text-green-600' },
  { key: 'favorites', label: 'Salva preferiti', icon: Bookmark, iconColor: 'text-purple-600' },
  { key: 'map', label: 'Mappa interattiva', icon: Map, iconColor: 'text-teal-600' },
  { key: 'notifications', label: 'Ricevi notifiche', icon: Bell, iconColor: 'text-blue-500' },
  { key: 'reports', label: 'Segnala recensioni/annunci', icon: Flag, iconColor: 'text-red-500' },
  { key: 'family_members', label: 'Membri della famiglia', icon: Users, iconColor: 'text-blue-600' },
  { key: 'annual_discount', label: 'Sconto con piano annuale', icon: Star, iconColor: 'text-yellow-500', fill: true },
];

const BUSINESS_FEATURE_MAP: FeatureDisplay[] = [
  { key: 'claim_business', label: 'Profilo verificato', icon: Shield, iconColor: 'text-blue-600' },
  { key: 'review_responses', label: 'Risposte alle recensioni', icon: MessageSquare, iconColor: 'text-blue-500' },
  { key: 'view_reviews', label: 'Vedere recensioni altre aziende', icon: Eye, iconColor: 'text-teal-600' },
  { key: 'priority_visibility', label: 'Priorità visibilità', icon: TrendingUp, iconColor: 'text-orange-500' },
  { key: 'job_postings', label: 'Inserire annunci di lavoro', icon: Briefcase, iconColor: 'text-gray-700' },
  { key: 'solidarity', label: '10% Beneficenza annuale', icon: Heart, iconColor: 'text-green-600', fill: true },
  { key: 'discounts', label: 'Pubblica sconti e coupon', icon: Tag, iconColor: 'text-orange-600' },
  { key: 'messages', label: 'Messaggistica', icon: MessageSquare, iconColor: 'text-green-600' },
  { key: 'multiple_locations', label: 'Sedi multiple', icon: Building2, iconColor: 'text-gray-700' },
  { key: 'reports', label: 'Segnala recensioni/annunci', icon: Flag, iconColor: 'text-red-500' },
  { key: 'notifications', label: 'Ricevi notifiche', icon: Bell, iconColor: 'text-blue-500' },
  { key: 'favorites', label: 'Salva preferiti', icon: Bookmark, iconColor: 'text-purple-600' },
  { key: 'annual_discount', label: 'Sconto con piano annuale', icon: Star, iconColor: 'text-yellow-500', fill: true },
];

function parsePlanFeatures(raw: any): string[] {
  if (Array.isArray(raw)) return raw.map(f => (typeof f === 'string' ? f : String(f)));
  if (typeof raw === 'string') { try { return JSON.parse(raw); } catch { return []; } }
  return [];
}

function PlanFeatureList({ plan }: { plan: SubscriptionPlan }) {
  const isBusiness = plan.name.toLowerCase().includes('business');
  const featureMap = isBusiness ? BUSINESS_FEATURE_MAP : PRIVATE_FEATURE_MAP;
  const enabledFeatures = featureMap.filter(f => plan.features.includes(f.key));

  if (enabledFeatures.length === 0) return null;

  return (
    <div className="space-y-2">
      {enabledFeatures.map(f => {
        const Icon = f.icon;
        return (
          <div key={f.key} className="flex items-center gap-2 text-sm text-gray-700">
            <Icon
              className={`w-4 h-4 flex-shrink-0 ${f.iconColor}`}
              {...(f.fill ? { fill: 'currentColor' } : {})}
            />
            <span>{f.label}</span>
          </div>
        );
      })}
    </div>
  );
}

function PlanCard({
  plan,
  isCurrent,
  onSelect,
  loading,
  showPriceNote,
}: {
  plan: SubscriptionPlan;
  isCurrent?: boolean;
  onSelect: (id: string) => void;
  loading: boolean;
  showPriceNote?: boolean;
}) {
  const isAnnual = plan.billing_period === 'yearly';
  const isBusiness = plan.name.toLowerCase().includes('business');

  return (
    <div
      className={`bg-white rounded-xl shadow-lg p-6 border-2 transition-all relative flex flex-col ${
        isCurrent
          ? 'border-yellow-500 bg-yellow-50'
          : isAnnual
          ? 'border-green-400 ring-2 ring-green-200'
          : 'border-gray-200 hover:border-blue-500'
      }`}
    >
      {isAnnual && !isCurrent && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
          <span className="inline-flex items-center gap-1 bg-green-500 text-white text-xs font-bold px-3 py-1 rounded-full shadow-lg">
            <Star className="w-3 h-3" fill="currentColor" />
            RISPARMIO
          </span>
        </div>
      )}

      <h3 className="text-xl font-bold text-gray-900 mb-1">{plan.name}</h3>
      <p className="text-xs text-gray-500 mb-4">
        Fino a {plan.max_persons}{' '}
        {isBusiness
          ? plan.max_persons === 1 ? 'sede' : 'sedi'
          : plan.max_persons === 1 ? 'persona' : 'persone'}
      </p>

      <div className="mb-5">
        <div className="flex items-baseline gap-2">
          <span className="text-4xl font-bold text-blue-600">€{Number(plan.price).toFixed(2)}</span>
          <span className="text-gray-600">/{plan.billing_period === 'monthly' ? 'mese' : 'anno'}</span>
        </div>
        {isBusiness && <p className="text-xs text-gray-500 mt-1">+ IVA</p>}
        {showPriceNote && !isAnnual && (
          <p className="text-xs text-gray-500 mt-1">€{(Number(plan.price) * 12).toFixed(2)} all'anno</p>
        )}
      </div>

      <div className="flex-1 mb-6">
        <PlanFeatureList plan={plan} />
      </div>

      {isCurrent ? (
        <div className="w-full bg-green-600 text-white py-3 px-6 rounded-lg font-semibold text-center">
          Piano Attuale
        </div>
      ) : (
        <button
          onClick={() => onSelect(plan.id)}
          disabled={loading}
          className={`w-full py-3 px-6 rounded-lg transition-colors font-semibold disabled:bg-gray-400 ${
            isAnnual
              ? 'bg-green-600 text-white hover:bg-green-700'
              : 'bg-blue-600 text-white hover:bg-blue-700'
          }`}
        >
          {loading ? 'Attivazione...' : 'Seleziona Piano'}
        </button>
      )}
    </div>
  );
}

function CharityBanner() {
  return (
    <div className="bg-gradient-to-br from-green-50 to-blue-50 border-2 border-green-400 rounded-2xl shadow-xl p-10 mb-12">
      <div className="flex items-center justify-center mb-5">
        <div className="w-14 h-14 bg-green-500 rounded-full flex items-center justify-center mr-4">
          <Heart className="w-7 h-7 text-white" fill="currentColor" />
        </div>
        <h2 className="text-3xl md:text-4xl font-bold text-gray-900">10% di Beneficenza</h2>
      </div>
      <p className="text-lg text-gray-800 max-w-3xl mx-auto leading-relaxed text-center mb-6">
        Il tuo abbonamento fa la differenza! Ogni anno Lhimo donerà il{' '}
        <strong>10% del fatturato totale</strong> ad associazioni di beneficenza scelte dagli utenti.
      </p>
      <div className="grid md:grid-cols-3 gap-4 max-w-4xl mx-auto">
        <div className="bg-white/80 backdrop-blur rounded-xl p-4 text-center">
          <Gift className="w-7 h-7 text-green-600 mx-auto mb-2" />
          <p className="text-sm font-semibold text-gray-900">Trasparenza Totale</p>
          <p className="text-xs text-gray-600 mt-1">Documenti certificati pubblici</p>
        </div>
        <div className="bg-white/80 backdrop-blur rounded-xl p-4 text-center">
          <Users className="w-7 h-7 text-green-600 mx-auto mb-2" />
          <p className="text-sm font-semibold text-gray-900">Voti degli Utenti</p>
          <p className="text-xs text-gray-600 mt-1">Tu scegli le associazioni</p>
        </div>
        <div className="bg-white/80 backdrop-blur rounded-xl p-4 text-center">
          <TrendingUp className="w-7 h-7 text-green-600 mx-auto mb-2" />
          <p className="text-sm font-semibold text-gray-900">Impatto Reale</p>
          <p className="text-xs text-gray-600 mt-1">Aiuto concreto ogni anno</p>
        </div>
      </div>
    </div>
  );
}

export function SubscriptionPage() {
  const { profile, loading: authLoading } = useAuth();
  const { t } = useLanguage();
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [currentSubscription, setCurrentSubscription] = useState<Subscription | null>(null);
  const [availablePlans, setAvailablePlans] = useState<SubscriptionPlan[]>([]);
  const [customerPlans, setCustomerPlans] = useState<SubscriptionPlan[]>([]);
  const [businessPlans, setBusinessPlans] = useState<SubscriptionPlan[]>([]);
  const [familyMembersCount, setFamilyMembersCount] = useState(0);
  const [businessLocationsCount, setBusinessLocationsCount] = useState(0);

  const calculateSavings = (plan: SubscriptionPlan) => {
    if (plan.billing_period !== 'yearly') return null;
    const allPlans = [...availablePlans, ...customerPlans, ...businessPlans];
    const monthlyPlan = allPlans.find(
      p =>
        p.max_persons === plan.max_persons &&
        p.billing_period === 'monthly' &&
        p.name.toLowerCase().includes('business') === plan.name.toLowerCase().includes('business'),
    );
    if (!monthlyPlan) return null;
    return monthlyPlan.price * 12 - plan.price;
  };

  useEffect(() => {
    if (!profile) {
      loadAllPlansForGuest();
      return;
    }
    if (profile.user_type === 'customer') {
      loadSubscription();
      loadFamilyMembers();
      loadCustomerPlans();
    } else if (profile.user_type === 'business') {
      loadSubscription();
      loadBusinessLocations();
      loadBusinessPlans();
    }
  }, [profile]);

  const normalizePlans = (data: any[]): SubscriptionPlan[] =>
    data.map(p => ({ ...p, features: parsePlanFeatures(p.features) }));

  const loadSubscription = async () => {
    if (!profile) return;
    const { data, error } = await supabase
      .from('subscriptions')
      .select(
        'id, status, start_date, end_date, trial_end_date, payment_method_added, reminder_sent, plan:subscription_plans(id, name, price, billing_period, max_persons, features)',
      )
      .eq('customer_id', profile.id)
      .in('status', ['active', 'trial'])
      .maybeSingle();
    if (error) { console.error('Error loading subscription:', error); return; }
    if (data) {
      const sub = { ...data, plan: { ...data.plan, features: parsePlanFeatures((data.plan as any)?.features) } };
      setCurrentSubscription(sub as any);
    }
  };

  const loadAllPlansForGuest = async () => {
    const [{ data: cd }, { data: bd }] = await Promise.all([
      supabase.from('subscription_plans').select('*').not('name', 'like', '%Business%').order('max_persons').order('billing_period'),
      supabase.from('subscription_plans').select('*').like('name', '%Business%').order('max_persons').order('billing_period'),
    ]);
    if (cd) setCustomerPlans(normalizePlans(cd));
    if (bd) setBusinessPlans(normalizePlans(bd));
  };

  const loadCustomerPlans = async () => {
    const { data } = await supabase
      .from('subscription_plans')
      .select('*')
      .not('name', 'like', '%Business%')
      .order('max_persons')
      .order('billing_period');
    if (data) setAvailablePlans(normalizePlans(data));
  };

  const loadBusinessPlans = async () => {
    const { data } = await supabase
      .from('subscription_plans')
      .select('*')
      .like('name', '%Business%')
      .order('billing_period')
      .order('max_persons');
    if (data) setAvailablePlans(normalizePlans(data));
  };

  const loadFamilyMembers = async () => {
    if (!profile) return;
    const { data } = await supabase.from('customer_family_members').select('id').eq('customer_id', profile.id);
    setFamilyMembersCount((data?.length || 0) + 1);
  };

  const loadBusinessLocations = async () => {
    if (!profile) return;
    const { data: biz } = await supabase.from('businesses').select('id').eq('owner_id', profile.id).maybeSingle();
    if (!biz) { setBusinessLocationsCount(0); return; }
    const { data } = await supabase.from('business_locations').select('id').eq('business_id', biz.id);
    setBusinessLocationsCount(data?.length || 0);
  };

  const handleSelectPlan = async (planId: string) => {
    if (!profile) {
      localStorage.setItem('selectedPlanId', planId);
      window.location.href = '/';
      return;
    }

    setLoading(true);
    setMessage('');

    try {
      const selectedPlan = availablePlans.find(p => p.id === planId);
      if (!selectedPlan) throw new Error('Piano non trovato');

      const endDate = new Date();
      if (selectedPlan.billing_period === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else {
        endDate.setFullYear(endDate.getFullYear() + 1);
      }

      if (currentSubscription) {
        const { error } = await supabase
          .from('subscriptions')
          .update({ plan_id: planId, start_date: new Date().toISOString(), end_date: endDate.toISOString(), status: 'active', payment_method_added: true })
          .eq('id', currentSubscription.id);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('subscriptions')
          .insert({ customer_id: profile.id, plan_id: planId, status: 'active', start_date: new Date().toISOString(), end_date: endDate.toISOString(), payment_method_added: true, reminder_sent: false });
        if (error) throw error;
      }

      const { error: profileError } = await supabase
        .from('profiles')
        .update({ subscription_type: selectedPlan.name, subscription_status: 'active', subscription_expires_at: endDate.toISOString() })
        .eq('id', profile.id);
      if (profileError) throw profileError;

      try {
        await supabase.rpc('confirm_referral_reward', { p_referred_user_id: profile.id });
      } catch {}

      setMessage('Abbonamento attivato con successo! In un ambiente di produzione, qui si integrerebbe un sistema di pagamento come Stripe.');
      setTimeout(() => window.location.reload(), 2000);
    } catch (error) {
      console.error('Error updating subscription:', error);
      setMessage("Errore durante l'attivazione dell'abbonamento");
    } finally {
      setLoading(false);
    }
  };

  if (authLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mb-4"></div>
          <p className="text-gray-600">Caricamento...</p>
        </div>
      </div>
    );
  }

  const HeroSection = ({ subtitle }: { subtitle: string }) => (
    <section className="bg-white border-b border-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20 text-center">
        <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
          <CreditCard className="w-3.5 h-3.5" />
          Abbonamenti
        </div>
        <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-4">Piani e Prezzi</h1>
        <p className="text-lg text-gray-500 max-w-2xl mx-auto">{subtitle}</p>
      </div>
    </section>
  );

  const MessageBanner = () =>
    message ? (
      <div className={`max-w-2xl mx-auto mb-8 p-4 rounded-lg ${message.includes('successo') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
        {message}
      </div>
    ) : null;

  /* ==================== GUEST VIEW ==================== */
  if (!profile) {
    return (
      <div className="min-h-screen bg-gray-50">
        <HeroSection subtitle="Scegli il piano perfetto per te o per la tua attività" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <CharityBanner />

          <div className="max-w-3xl mx-auto mb-12 bg-blue-50 border-2 border-blue-200 rounded-xl p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-blue-600 rounded-full flex items-center justify-center flex-shrink-0">
                <Check className="w-6 h-6 text-white" />
              </div>
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-1">Accedi per sottoscrivere un abbonamento</h3>
                <p className="text-gray-600">Registrati o accedi per attivare il tuo abbonamento e iniziare a usufruire di tutte le funzionalità.</p>
              </div>
            </div>
          </div>

          <MessageBanner />

          <div className="space-y-16">
            <div>
              <div className="text-center mb-8">
                <h2 className="text-3xl font-bold text-gray-900 mb-2">Piani per Privati</h2>
                <p className="text-gray-600">Perfetto per te e la tua famiglia</p>
              </div>
              {customerPlans.length === 0 ? (
                <p className="text-center text-gray-500">Caricamento piani...</p>
              ) : (
                <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                  {customerPlans.map(plan => (
                    <PlanCard key={plan.id} plan={plan} onSelect={handleSelectPlan} loading={loading} showPriceNote />
                  ))}
                </div>
              )}
            </div>

            <div>
              <div className="text-center mb-8">
                <h2 className="text-3xl font-bold text-gray-900 mb-2">Piani per Professionisti</h2>
                <p className="text-gray-600">Ideale per attività commerciali e professionisti</p>
              </div>
              {businessPlans.length === 0 ? (
                <p className="text-center text-gray-500">Caricamento piani...</p>
              ) : (
                <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                  {businessPlans.map(plan => (
                    <PlanCard key={plan.id} plan={plan} onSelect={handleSelectPlan} loading={loading} showPriceNote />
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  }

  /* ==================== CUSTOMER VIEW ==================== */
  if (profile.user_type === 'customer') {
    return (
      <div className="min-h-screen bg-gray-50">
        <HeroSection subtitle="Gestisci il tuo abbonamento e accedi a sconti esclusivi" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <CharityBanner />

          {currentSubscription && (
            <div className="max-w-3xl mx-auto mb-12">
              <div className="bg-white rounded-xl shadow-lg p-8 border-2 border-green-500">
                <div className="flex items-center justify-between mb-6">
                  <div>
                    <h2 className="text-2xl font-bold text-gray-900 mb-1">{currentSubscription.plan.name}</h2>
                    <p className="text-gray-600">Per {familyMembersCount} {familyMembersCount === 1 ? 'persona' : 'persone'}</p>
                    <p className="text-sm font-medium text-gray-700 mt-1">Abbonamento {currentSubscription.plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}</p>
                  </div>
                  <div className="text-right">
                    <div className="text-3xl font-bold text-blue-600">
                      {currentSubscription.status === 'trial' ? 'GRATIS' : `€${currentSubscription.plan.price.toFixed(2)}`}
                    </div>
                    <div className="text-sm text-gray-600">
                      {currentSubscription.status === 'trial' ? 'per 1 mese' : currentSubscription.plan.billing_period === 'monthly' ? 'al mese' : "all'anno"}
                    </div>
                  </div>
                </div>

                {currentSubscription.status === 'trial' ? (
                  <div className="bg-gradient-to-r from-blue-50 to-green-50 border-2 border-blue-300 rounded-lg p-5 mb-4">
                    <p className="font-semibold text-blue-900 mb-2">Periodo di Prova Gratuita Attivo</p>
                    <p className="text-sm text-gray-700 mb-1">Il tuo periodo di prova scade il <strong>{new Date(currentSubscription.end_date).toLocaleDateString('it-IT')}</strong></p>
                    {!currentSubscription.payment_method_added && (
                      <button onClick={() => setMessage("La funzionalità di pagamento sarà disponibile a breve.")} className="mt-3 w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 text-sm font-medium">
                        Aggiungi Metodo di Pagamento
                      </button>
                    )}
                    {currentSubscription.payment_method_added && (
                      <div className="flex items-center gap-2 text-green-700 text-sm mt-2">
                        <Check className="w-5 h-5" />
                        <span>Metodo di pagamento aggiunto</span>
                      </div>
                    )}
                  </div>
                ) : (
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-semibold text-green-800">Abbonamento Attivo</p>
                        <p className="text-sm text-green-700">Scade il {new Date(currentSubscription.end_date).toLocaleDateString('it-IT')}</p>
                      </div>
                      <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                    </div>
                  </div>
                )}

                <div className="mt-2">
                  <h3 className="font-semibold text-gray-900 mb-3">Incluso nel tuo piano:</h3>
                  <PlanFeatureList plan={currentSubscription.plan} />
                </div>
              </div>
            </div>
          )}

          <MessageBanner />

          {!currentSubscription && availablePlans.length === 0 && (
            <p className="text-center text-gray-500 mb-8">Caricamento dei piani in corso...</p>
          )}

          {availablePlans.length > 0 && (
            <div className="mt-12">
              <h2 className="text-3xl font-bold text-gray-900 text-center mb-8">
                {currentSubscription ? 'Cambia Piano' : 'Scegli il Tuo Piano'}
              </h2>
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                {availablePlans.map(plan => {
                  const savings = calculateSavings(plan);
                  const isAnnual = plan.billing_period === 'yearly';
                  const isCurrent = currentSubscription?.plan.id === plan.id;
                  return (
                    <div key={plan.id} className="relative">
                      {isAnnual && !isCurrent && savings && savings > 0 && (
                        <div className="absolute -top-1 left-0 right-0 flex justify-center z-10 pointer-events-none" style={{ top: '-2.5rem' }}>
                          <div className="bg-green-50 border border-green-200 rounded-lg px-3 py-1.5 text-sm font-bold text-green-700">
                            Risparmi €{savings.toFixed(2)}
                          </div>
                        </div>
                      )}
                      <PlanCard plan={plan} isCurrent={isCurrent} onSelect={handleSelectPlan} loading={loading} showPriceNote />
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>
      </div>
    );
  }

  /* ==================== BUSINESS VIEW ==================== */
  return (
    <div className="min-h-screen bg-gray-50">
      <HeroSection subtitle="Gestisci la tua attività, rispondi alle recensioni e offri sconti ai clienti" />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="bg-gradient-to-br from-green-50 to-blue-50 border-2 border-green-200 rounded-2xl shadow-lg p-10 mb-12 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Il tuo abbonamento vale il 10% di beneficenza</h2>
          <p className="text-lg text-gray-700 max-w-3xl mx-auto leading-relaxed">
            Lhimo ogni anno donerà il 10% del proprio fatturato, visibile con documenti certificati, ad associazioni che voterete voi utenti.
          </p>
        </div>

        {currentSubscription && (
          <div className="max-w-3xl mx-auto mb-12">
            <div className="bg-white rounded-xl shadow-lg p-8 border-2 border-green-500">
              <div className="flex items-center justify-between mb-6">
                <div>
                  <h2 className="text-2xl font-bold text-gray-900 mb-1">{currentSubscription.plan.name}</h2>
                  <p className="text-gray-600">Per {businessLocationsCount} {businessLocationsCount === 1 ? 'punto vendita' : 'punti vendita'}</p>
                  <p className="text-sm font-medium text-gray-700 mt-1">Abbonamento {currentSubscription.plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}</p>
                </div>
                <div className="text-right">
                  <div className="text-3xl font-bold text-blue-600">
                    {currentSubscription.status === 'trial' ? 'GRATIS' : `€${Number(currentSubscription.plan.price).toFixed(2)}`}
                  </div>
                  <div className="text-sm text-gray-600">
                    {currentSubscription.status === 'trial' ? 'per 1 mese' : `${currentSubscription.plan.billing_period === 'monthly' ? 'al mese' : "all'anno"} + IVA`}
                  </div>
                </div>
              </div>

              {currentSubscription.status === 'trial' ? (
                <div className="bg-gradient-to-r from-blue-50 to-green-50 border-2 border-blue-300 rounded-lg p-5 mb-4">
                  <p className="font-semibold text-blue-900 mb-2">Periodo di Prova Gratuita Attivo</p>
                  <p className="text-sm text-gray-700">Il tuo periodo di prova scade il <strong>{new Date(currentSubscription.end_date).toLocaleDateString('it-IT')}</strong></p>
                </div>
              ) : (
                <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-semibold text-green-800">Abbonamento Attivo</p>
                      <p className="text-sm text-green-700">Scade il {new Date(currentSubscription.end_date).toLocaleDateString('it-IT')}</p>
                    </div>
                    <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                  </div>
                </div>
              )}

              <div className="mt-2">
                <h3 className="font-semibold text-gray-900 mb-3">Incluso nel tuo piano:</h3>
                <PlanFeatureList plan={currentSubscription.plan} />
              </div>
            </div>
          </div>
        )}

        <MessageBanner />

        {availablePlans.length > 0 && (
          <div className="mt-12">
            <h2 className="text-3xl font-bold text-gray-900 text-center mb-8">
              {currentSubscription ? 'Cambia Piano' : 'Scegli il Tuo Piano'}
            </h2>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {availablePlans.map(plan => (
                <PlanCard
                  key={plan.id}
                  plan={plan}
                  isCurrent={currentSubscription?.plan.id === plan.id}
                  onSelect={handleSelectPlan}
                  loading={loading}
                  showPriceNote
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
