import { useState, useEffect } from 'react';
import { Star, Search, Award, Tag, Briefcase, Heart, Users, MapPin, Euro, ArrowRight, Check, Building2, Gavel, Shield, Gift, Lock, User, Volume2 } from 'lucide-react';
import { AdvancedSearch } from '../components/search/AdvancedSearch';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import { useNavigate } from '../components/Router';
import TopBusinessesBanner from '../components/business/TopBusinessesBanner';
import AuctionCard from '../components/auctions/AuctionCard';
import { usePageCustomization } from '../hooks/usePageCustomization';

export function HomePage() {
  const { user, profile, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Caricamento...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <LandingPage />;
  }

  return <AuthenticatedHomePage />;
}

function PricingPreviewSection({ plans, onNavigate }: { plans: any[]; onNavigate: () => void }) {
  const [expanded, setExpanded] = useState(false);

  const isBizPlan = (p: any) => p.name?.toLowerCase().includes('business');
  const privatePlan = plans.find(p => !isBizPlan(p));
  const businessPlan = plans.find(p => isBizPlan(p));

  if (!privatePlan && !businessPlan) return null;

  return (
    <section className="py-16 bg-white">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-10">
          <h2 className="text-3xl font-bold text-gray-900 mb-2">Piani di Abbonamento</h2>
          <p className="text-gray-500">Scegli il piano più adatto alle tue esigenze</p>
        </div>

        <div className="grid md:grid-cols-2 gap-6 mb-8">
          {privatePlan && (
            <div className="bg-white rounded-2xl border border-gray-200 p-7 shadow-sm hover:shadow-md transition-shadow">
              <div className="mb-5">
                <p className="text-xs font-semibold text-blue-600 uppercase tracking-widest mb-1">Utenti Privati</p>
                <h3 className="text-xl font-bold text-gray-900">{privatePlan.name}</h3>
              </div>
              <p className="text-xs text-gray-400 mb-1">A partire da</p>
              <div className="flex items-baseline gap-1 mb-1">
                <span className="text-4xl font-extrabold text-blue-600">{parseFloat(privatePlan.price || 0).toFixed(2)}€</span>
                <span className="text-gray-400 text-sm">/mese</span>
              </div>
              <p className="text-xs text-gray-400 mb-6">30 giorni di prova gratuita inclusi</p>
              <ul className="space-y-2.5 mb-7">
                {['Cerca attività locali verificate', 'Scrivi recensioni e guadagna punti', 'Pubblica annunci e partecipa alle aste'].map((f, i) => (
                  <li key={i} className="flex items-center gap-2.5 text-sm text-gray-700">
                    <Check className="w-4 h-4 text-blue-500 flex-shrink-0" />
                    {f}
                  </li>
                ))}
                <li className="text-xs text-blue-500 font-medium pl-6">+ molte altre funzionalità...</li>
              </ul>
              <button onClick={onNavigate} className="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-xl font-semibold text-sm transition-colors">
                Inizia Gratis
              </button>
            </div>
          )}

          {businessPlan && (
            <div className="relative bg-white rounded-2xl border-2 border-green-500 p-7 shadow-md">
              <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                <span className="bg-green-500 text-white text-xs font-bold px-4 py-1 rounded-full">Piu scelto</span>
              </div>
              <div className="mb-5">
                <p className="text-xs font-semibold text-green-600 uppercase tracking-widest mb-1">Utenti Business</p>
                <h3 className="text-xl font-bold text-gray-900">{businessPlan.name}</h3>
              </div>
              <p className="text-xs text-gray-400 mb-1">A partire da</p>
              <div className="flex items-baseline gap-1 mb-1">
                <span className="text-4xl font-extrabold text-green-600">{parseFloat(businessPlan.price || 0).toFixed(2)}€</span>
                <span className="text-gray-400 text-sm">/mese</span>
              </div>
              <p className="text-xs text-gray-400 mb-6">30 giorni di prova gratuita inclusi</p>
              <ul className="space-y-2.5 mb-7">
                {['Registra o rivendica la tua attività', 'Gestisci sedi e offerte di lavoro', 'Rispondi alle recensioni dei clienti'].map((f, i) => (
                  <li key={i} className="flex items-center gap-2.5 text-sm text-gray-700">
                    <Check className="w-4 h-4 text-green-500 flex-shrink-0" />
                    {f}
                  </li>
                ))}
                <li className="text-xs text-green-500 font-medium pl-6">+ molte altre funzionalità...</li>
              </ul>
              <button onClick={onNavigate} className="w-full bg-green-600 hover:bg-green-700 text-white py-3 rounded-xl font-semibold text-sm transition-colors">
                Inizia Gratis
              </button>
            </div>
          )}
        </div>

        {!expanded ? (
          <div className="text-center">
            <button
              onClick={() => setExpanded(true)}
              className="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 font-semibold text-sm border border-gray-300 hover:border-gray-400 px-6 py-3 rounded-xl bg-white hover:bg-gray-50 transition-all shadow-sm"
            >
              Scopri tutti gli abbonamenti <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        ) : (
          <div>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-5 mb-8">
              {plans
                .filter(p => p.id !== privatePlan?.id && p.id !== businessPlan?.id)
                .map(plan => (
                  <div key={plan.id} className="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-md transition-shadow">
                    <p className="text-xs font-semibold uppercase tracking-widest mb-1 text-gray-400">
                      {isBizPlan(plan) ? 'Business' : 'Privati'}
                    </p>
                    <h3 className="font-bold text-gray-900 mb-3">{plan.name}</h3>
                    <p className="text-xs text-gray-400 mb-0.5">A partire da</p>
                    <div className="flex items-baseline gap-1 mb-4">
                      <span className="text-2xl font-extrabold text-gray-800">{parseFloat(plan.price || 0).toFixed(2)}€</span>
                      <span className="text-gray-400 text-xs">/mese</span>
                    </div>
                    <button onClick={onNavigate} className="w-full bg-gray-900 hover:bg-black text-white py-2 rounded-lg text-sm font-semibold transition-colors">
                      Scopri di più
                    </button>
                  </div>
                ))}
            </div>
            <div className="text-center">
              <button onClick={onNavigate} className="inline-flex items-center gap-2 bg-blue-600 text-white px-7 py-3 rounded-xl font-bold hover:bg-blue-700 transition-colors shadow-sm">
                Vai alla pagina abbonamenti <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        )}
      </div>
    </section>
  );
}

function LandingPage() {
  const navigate = useNavigate();
  const [subscriptionPlans, setSubscriptionPlans] = useState<any[]>([]);
  const customization = usePageCustomization('landing');

  useEffect(() => {
    supabase
      .from('subscription_plans')
      .select('*')
      .eq('billing_period', 'monthly')
      .order('price', { ascending: true })
      .then(({ data }) => { if (data) setSubscriptionPlans(data); });
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">

      {/* Announcement banner */}
      {customization?.announcement_active && customization.announcement_text && (
        <div className="bg-blue-600 text-white py-2.5 px-4 text-center text-sm font-medium flex items-center justify-center gap-2">
          <Volume2 className="w-4 h-4 flex-shrink-0" />
          {customization.announcement_text}
        </div>
      )}

      {/* HERO */}
      <section
        className="bg-white border-b border-gray-100"
        style={customization?.hero_image_url ? {
          backgroundImage: `linear-gradient(rgba(255,255,255,0.88), rgba(255,255,255,0.88)), url(${customization.hero_image_url})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        } : undefined}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24">
          <div className="max-w-2xl mx-auto text-center">
            <div>
              <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
                <div className="w-1.5 h-1.5 bg-blue-500 rounded-full"></div>
                La piattaforma che connette persone e attività
              </div>
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-5">
                {customization?.hero_title || (
                  <>Benvenuto su{' '}<span className="text-blue-600">Lhimo</span></>
                )}
              </h1>
              <p className="text-lg text-gray-500 mb-3 leading-relaxed">
                {customization?.hero_subtitle || 'La piattaforma che connette persone e attività locali in tutta Italia'}
              </p>
              <p className="text-sm text-gray-400 mb-8">
                Prova gratuita di 30 giorni per utenti privati e aziende
              </p>
              <div className="flex flex-col sm:flex-row justify-center gap-3">
                <button
                  onClick={() => window.location.href = '/?register=user'}
                  className="inline-flex items-center justify-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-7 py-3.5 rounded-xl font-bold text-base transition-colors shadow-sm hover:shadow-md"
                >
                  Inizia Gratis <ArrowRight className="w-5 h-5" />
                </button>
                <button
                  onClick={() => window.location.href = '/?login=true'}
                  className="inline-flex items-center justify-center gap-2 bg-white hover:bg-gray-50 text-gray-700 px-7 py-3.5 rounded-xl font-semibold text-base border border-gray-300 transition-colors"
                >
                  Accedi
                </button>
              </div>
              <div className="mt-8 flex flex-wrap justify-center gap-5">
                {[
                  { icon: Shield, text: '30 giorni di prova gratuita' },
                  { icon: Lock, text: 'Semplice e sicuro' },
                  { icon: Check, text: 'Attività verificate' },
                ].map(({ icon: Icon, text }) => (
                  <div key={text} className="flex items-center gap-2 text-sm text-gray-500">
                    <Icon className="w-4 h-4 text-blue-500" />
                    {text}
                  </div>
                ))}
              </div>
            </div>

          </div>
        </div>
      </section>

      {/* ACCOUNT TYPE */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-10">
            <h2 className="text-3xl font-bold text-gray-900 mb-2">Scegli il Tuo Account</h2>
            <p className="text-gray-500">Unisciti a Lhimo e scopri tutte le funzionalità della piattaforma</p>
          </div>
          <div className="grid md:grid-cols-2 gap-6">
            {/* Privato */}
            <div className="bg-white rounded-2xl border border-gray-200 p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="flex flex-col items-center text-center mb-6">
                <div className="w-16 h-16 bg-blue-100 rounded-2xl flex items-center justify-center mb-4">
                  <Users className="w-8 h-8 text-blue-600" />
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">Utente Privato</h3>
                <p className="text-gray-500 text-sm leading-relaxed">
                  Perfetto per famiglie e persone che vogliono trovare attività locali, lasciare recensioni e accedere a vantaggi esclusivi
                </p>
              </div>
              <div className="mb-6">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-3">Cosa puoi fare:</p>
                <ul className="space-y-2.5">
                  {['Cerca e scopri attività locali verificate', 'Scrivi recensioni e guadagna punti', 'Pubblica annunci di compravendita e cerca lavoro', 'Gestisci fino a 4 profili familiari', 'Partecipa alla classifica e vinci gift card'].map((item, i) => (
                    <li key={i} className="flex items-center gap-2.5 text-sm text-gray-700">
                      <Check className="w-4 h-4 text-blue-500 flex-shrink-0" />
                      {item}
                    </li>
                  ))}
                </ul>
              </div>
              <button onClick={() => window.location.href = '/?register=user'} className="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-xl font-bold transition-colors">
                Inizia Gratis
              </button>
              <p className="text-center text-xs text-gray-400 mt-2">30 giorni di prova gratuita</p>
            </div>

            {/* Business */}
            <div className="bg-white rounded-2xl border border-gray-200 p-8 shadow-sm hover:shadow-md transition-shadow">
              <div className="flex flex-col items-center text-center mb-6">
                <div className="w-16 h-16 bg-green-100 rounded-2xl flex items-center justify-center mb-4">
                  <Building2 className="w-8 h-8 text-green-600" />
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">Utente Business</h3>
                <p className="text-gray-500 text-sm leading-relaxed">
                  Ideale per aziende e attività commerciali che vogliono farsi trovare, gestire recensioni e pubblicare offerte di lavoro
                </p>
              </div>
              <div className="mb-6">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-3">Cosa puoi fare:</p>
                <ul className="space-y-2.5">
                  {['Rivendica o registra la tua attività', 'Gestisci più sedi aziendali', 'Rispondi alle recensioni dei clienti', 'Pubblica offerte di lavoro e trova candidati', 'Crea sconti e promozioni verificate'].map((item, i) => (
                    <li key={i} className="flex items-center gap-2.5 text-sm text-gray-700">
                      <Check className="w-4 h-4 text-green-500 flex-shrink-0" />
                      {item}
                    </li>
                  ))}
                </ul>
              </div>
              <button onClick={() => window.location.href = '/?register=business'} className="w-full bg-green-600 hover:bg-green-700 text-white py-3 rounded-xl font-bold transition-colors">
                Inizia Gratis
              </button>
              <p className="text-center text-xs text-gray-400 mt-2">30 giorni di prova gratuita</p>
            </div>
          </div>
        </div>
      </section>

      {/* PRICING */}
      <PricingPreviewSection plans={subscriptionPlans} onNavigate={() => navigate('/subscription')} />

      {/* ASTE */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-3">Aste Online</h2>
          <p className="text-gray-500 mb-10 max-w-2xl mx-auto">
            Partecipa alle aste e trova occasioni uniche. Metti all'asta oggetti che non usi più o aggiudica i migliori lotti pubblicati dagli utenti della piattaforma. Tutto in modo trasparente e sicuro.
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 sm:gap-4 max-w-xl mx-auto mb-8">
            {[
              { icon: Gavel, color: 'bg-orange-100 text-orange-600', label: '100%', sub: 'Aste verificate e approvate' },
              { icon: Gift, color: 'bg-amber-100 text-amber-600', label: 'Gratis', sub: 'Pubblicazione asta senza costi' },
              { icon: Lock, color: 'bg-blue-100 text-blue-600', label: 'Sicuro', sub: 'Deposito cauzionale a tutela' },
            ].map(({ icon: Icon, color, label, sub }) => (
              <div key={label} className="bg-white rounded-xl p-4 border border-gray-100 shadow-sm text-center">
                <div className={`w-10 h-10 ${color} rounded-xl flex items-center justify-center mx-auto mb-2`}>
                  <Icon className="w-5 h-5" />
                </div>
                <p className="font-bold text-gray-900 text-sm">{label}</p>
                <p className="text-xs text-gray-400 mt-0.5 leading-tight">{sub}</p>
              </div>
            ))}
          </div>
          <button onClick={() => navigate('/login')} className="inline-flex items-center gap-2 bg-orange-500 hover:bg-orange-600 text-white px-7 py-3 rounded-xl font-bold transition-colors shadow-sm">
            Accedi per partecipare <ArrowRight className="w-4 h-4" />
          </button>
          <p className="text-xs text-gray-400 mt-3 flex items-center justify-center gap-1.5">
            <Lock className="w-3.5 h-3.5" />
            Accedi o registrati per visualizzare le aste attive e fare offerte
          </p>
        </div>
      </section>

      {/* ANNUNCI */}
      <section className="py-16 bg-white">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-3">Annunci Classificati</h2>
          <p className="text-gray-500 mb-10 max-w-2xl mx-auto">
            Compra, vendi o regala oggetti usati direttamente tra privati. Pubblica annunci in modo gratuito e raggiungi migliaia di utenti nella tua zona. Nessuna commissione, nessuna intermediazione.
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 sm:gap-4 max-w-xl mx-auto mb-8">
            {[
              { icon: Tag, color: 'bg-green-100 text-green-600', label: 'Vendo', sub: 'Dai una seconda vita agli oggetti' },
              { icon: Search, color: 'bg-blue-100 text-blue-600', label: 'Cerco', sub: 'Trova ciò che stai cercando' },
              { icon: Gift, color: 'bg-pink-100 text-pink-600', label: 'Regalo', sub: 'Dona ciò che non usi più' },
            ].map(({ icon: Icon, color, label, sub }) => (
              <div key={label} className="bg-white rounded-xl p-4 border border-gray-100 shadow-sm text-center">
                <div className={`w-10 h-10 ${color} rounded-xl flex items-center justify-center mx-auto mb-2`}>
                  <Icon className="w-5 h-5" />
                </div>
                <p className="font-bold text-gray-900 text-sm">{label}</p>
                <p className="text-xs text-gray-400 mt-0.5 leading-tight">{sub}</p>
              </div>
            ))}
          </div>
          <button onClick={() => navigate('/login')} className="inline-flex items-center gap-2 bg-green-600 hover:bg-green-700 text-white px-7 py-3 rounded-xl font-bold transition-colors shadow-sm">
            Accedi per vedere gli annunci <ArrowRight className="w-4 h-4" />
          </button>
          <p className="text-xs text-gray-400 mt-3 flex items-center justify-center gap-1.5">
            <Lock className="w-3.5 h-3.5" />
            Accedi o registrati per sfogliare e pubblicare annunci
          </p>
        </div>
      </section>

      {/* SOLIDARIETA */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="w-14 h-14 bg-pink-100 rounded-2xl flex items-center justify-center mx-auto mb-5">
            <Heart className="w-7 h-7 text-pink-600" />
          </div>
          <h2 className="text-3xl font-bold text-gray-900 mb-3">Sezione Solidarietà</h2>
          <p className="text-gray-500 mb-6 leading-relaxed">
            Il 10% del fatturato di Lhimo viene devoluto in beneficenza ad associazioni e enti no profit che gli utenti sceglieranno attraverso un form dedicato.
          </p>
          <div className="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm text-left mb-6">
            <h3 className="font-bold text-gray-900 mb-3">Come Funziona</h3>
            <div className="flex items-start gap-3">
              <div className="w-8 h-8 bg-pink-100 rounded-lg flex items-center justify-center flex-shrink-0">
                <Award className="w-4 h-4 text-pink-600" />
              </div>
              <p className="text-sm text-gray-600">Tutti i documenti contabili e le donazioni effettuate sono pubblicamente consultabili</p>
            </div>
          </div>
          <button onClick={() => navigate('/solidarity')} className="inline-flex items-center gap-2 bg-pink-600 hover:bg-pink-700 text-white px-7 py-3 rounded-xl font-semibold transition-colors">
            Scopri di Più <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </section>

      {/* COSA PUOI FARE */}
      <section className="py-16 bg-white">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-2">Cosa Puoi Fare con Lhimo</h2>
            <p className="text-gray-500">Una piattaforma completa per connettere persone e attività</p>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 sm:gap-6">
            {[
              { step: '1', color: 'bg-blue-500', label: 'Registrati', desc: 'Crea il tuo account gratuito in pochi secondi' },
              { step: '2', color: 'bg-teal-500', label: 'Esplora', desc: 'Cerca attività, servizi, aste e annunci nella tua zona' },
              { step: '3', color: 'bg-orange-500', label: 'Interagisci', desc: 'Lascia recensioni, partecipa alle aste e pubblica annunci' },
              { step: '4', color: 'bg-green-500', label: 'Guadagna', desc: 'Ottieni vantaggi esclusivi e partecipa alla classifica' },
            ].map(({ step, color, label, desc }) => (
              <div key={step} className="text-center">
                <div className={`w-12 h-12 ${color} text-white rounded-full flex items-center justify-center text-lg font-bold mx-auto mb-3 shadow-sm`}>
                  {step}
                </div>
                <h3 className="font-bold text-gray-900 mb-1">{label}</h3>
                <p className="text-xs text-gray-500 leading-relaxed">{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

    </div>
  );
}

function AuthenticatedHomePage() {
  const { user, profile, activeProfile } = useAuth();
  const navigate = useNavigate();
  const [jobSeekers, setJobSeekers] = useState<any[]>([]);
  const [jobPostings, setJobPostings] = useState<any[]>([]);
  const [featuredSellAds, setFeaturedSellAds] = useState<any[]>([]);
  const [expiringAuctions, setExpiringAuctions] = useState<any[]>([]);
  const [featuredAuctions, setFeaturedAuctions] = useState<any[]>([]);
  const [topUsers, setTopUsers] = useState<any[]>([]);
  const [topBusinesses, setTopBusinesses] = useState<any[]>([]);
  const [featuredLocations, setFeaturedLocations] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const customization = usePageCustomization('home_authenticated');

  const isBusiness = profile?.user_type === 'business';

  // Determina il nome da mostrare nel benvenuto
  const displayName = activeProfile
    ? (activeProfile.nickname || activeProfile.name)
    : (profile?.full_name || 'Utente');

  useEffect(() => {
    loadHomeData();
  }, [user, profile?.user_type, profile?.business_id]);

  const loadHomeData = async () => {
    try {
      setLoading(true);

      const [jobSeekersResult, jobPostingsResult, sellAdsResult, topDataResult, auctionsResult, featuredAuctionsResult, featuredLocationsResult] = await Promise.all([
        // Business users see job seekers (private users looking for work)
        (async () => {
          if (!isBusiness) return [];

          let query = supabase
            .from('job_seekers')
            .select(`
              *,
              profiles:user_id(id, nickname, full_name, avatar_url),
              category:category_id(name)
            `)
            .eq('status', 'active')
            .order('created_at', { ascending: false });

          if (profile?.business_id) {
            const { data: businessData } = await supabase
              .from('businesses')
              .select('category_id')
              .eq('id', profile.business_id)
              .single();

            if (businessData?.category_id) {
              query = query.eq('category_id', businessData.category_id);
            }
          }

          const { data } = await query.limit(6);
          return data || [];
        })(),

        // Private users see job postings from businesses
        (async () => {
          if (isBusiness) return [];

          const { data } = await supabase
            .from('job_postings')
            .select(`
              *,
              business:businesses(id, name),
              registered_business:registered_businesses(id, name)
            `)
            .eq('status', 'active')
            .eq('approval_status', 'approved')
            .gt('expires_at', new Date().toISOString())
            .order('created_at', { ascending: false })
            .limit(6);

          return data || [];
        })(),

        supabase.rpc('get_featured_classified_ads', { ad_type_filter: 'sell', limit_count: 6 }),

        isBusiness
          ? supabase.rpc('get_top_business_locations', { limit_count: 20 })
          : supabase
              .from('user_activity')
              .select(`
                user_id,
                family_member_id,
                total_points,
                reviews_count,
                profiles:user_id(id, nickname, full_name, avatar_url),
                family_member:family_member_id(id, first_name, last_name, nickname, avatar_url)
              `)
              .gt('total_points', 0)
              .order('total_points', { ascending: false })
              .limit(20),

        supabase
          .from('auctions')
          .select(`
            *,
            user:user_id(full_name, nickname),
            bid_count:auction_bids(count)
          `)
          .eq('status', 'active')
          .eq('approval_status', 'approved')
          .gt('ends_at', new Date().toISOString())
          .order('ends_at', { ascending: true })
          .limit(6),

        supabase
          .from('auctions')
          .select(`
            *,
            user:user_id(full_name, nickname),
            bid_count:auction_bids(count)
          `)
          .eq('status', 'active')
          .eq('approval_status', 'approved')
          .order('ends_at', { ascending: true })
          .limit(6),

        supabase.rpc('get_top_business_locations', { limit_count: 8 })
      ]);

      if (jobSeekersResult) {
        setJobSeekers(jobSeekersResult);
      }

      if (jobPostingsResult) {
        setJobPostings(jobPostingsResult);
      }

      if (sellAdsResult.data && sellAdsResult.data.length > 0) {
        const adsWithProfiles = sellAdsResult.data.map((ad: any) => ({
          ...ad,
          profiles: {
            id: ad.user_id,
            full_name: ad.user_full_name,
            nickname: ad.user_nickname,
            avatar_url: ad.user_avatar_url
          }
        }));
        setFeaturedSellAds(adsWithProfiles);
      } else {
        setFeaturedSellAds([]);
      }

      if (isBusiness && topDataResult.data) {
        setTopBusinesses(topDataResult.data);
      } else if (!isBusiness && topDataResult.data) {
        setTopUsers(topDataResult.data);
      }

      if (auctionsResult.data) {
        setExpiringAuctions(auctionsResult.data.map((a: any) => ({
          ...a,
          bid_count: a.bid_count?.[0]?.count || 0
        })));
      }

      if (featuredAuctionsResult.data) {
        setFeaturedAuctions(featuredAuctionsResult.data.map((a: any) => ({
          ...a,
          bid_count: a.bid_count?.[0]?.count || 0
        })));
      }

      if (featuredLocationsResult.data) {
        setFeaturedLocations(featuredLocationsResult.data);
      }
    } catch (error) {
      console.error('Error loading home data:', error);
    } finally {
      setLoading(false);
    }
  };

  // Determina il nome per il benvenuto nella hero section
  // Per i profili sede usa l'etichetta privata (internal_name) se disponibile
  const heroDisplayName = activeProfile
    ? (activeProfile.internal_name || activeProfile.nickname || activeProfile.name?.split(' ')[0])
    : (profile?.nickname || profile?.full_name?.split(' ')[0] || 'Utente');

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Announcement banner */}
      {customization?.announcement_active && customization.announcement_text && (
        <div className="bg-blue-600 text-white py-2.5 px-4 text-center text-sm font-medium flex items-center justify-center gap-2">
          <Volume2 className="w-4 h-4 flex-shrink-0" />
          {customization.announcement_text}
        </div>
      )}

      {/* Hero */}
      <section
        className="bg-white border-b border-gray-100"
        style={customization?.hero_image_url ? {
          backgroundImage: `linear-gradient(rgba(255,255,255,0.88), rgba(255,255,255,0.88)), url(${customization.hero_image_url})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        } : undefined}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20">
          <div className="max-w-2xl mx-auto text-center">
            <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
              <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse"></div>
              Online
            </div>
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-4">
              Ciao, <span className="text-blue-600">{heroDisplayName}</span>!
            </h1>
            <p className="text-lg text-gray-500">
              {customization?.hero_subtitle || 'Esplora attività locali, trova candidati, vendi e compra oggetti'}
            </p>
          </div>
          <div className="mt-10 max-w-4xl">
            <div className="flex items-center gap-3 mb-6">
              <div className="bg-gradient-to-br from-blue-500 to-blue-600 p-3 rounded-xl shadow-lg">
                <Search className="w-6 h-6 text-white" />
              </div>
              <div>
                <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Recensioni</h2>
                <p className="text-sm text-gray-600">Cerca e scopri le attività locali recensite dagli utenti</p>
              </div>
            </div>
            <AdvancedSearch
              onSearch={() => {}}
              isLoading={false}
              navigateToSearchPage={true}
            />
          </div>
        </div>
      </section>

      <TopBusinessesBanner />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {loading ? (
          <div className="text-center py-20">
            <div className="inline-block">
              <div className="animate-spin rounded-full h-16 w-16 border-4 border-blue-600 border-t-transparent"></div>
              <p className="mt-4 text-gray-600 font-medium">Caricamento contenuti...</p>
            </div>
          </div>
        ) : (
          <div className="space-y-12">
            {/* Attività in Evidenza */}
            <section>
              <div className="flex items-center justify-between mb-8">
                <div className="flex items-center gap-3">
                  <div className="bg-gradient-to-br from-green-500 to-emerald-600 p-3 rounded-xl shadow-lg">
                    <Star className="w-6 h-6 text-white fill-white" />
                  </div>
                  <div>
                    <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Attività in Evidenza</h2>
                    <p className="text-sm text-gray-600">Le sedi con le valutazioni globali più alte</p>
                  </div>
                </div>
                <button
                  onClick={() => navigate('/search?sort=rating_desc')}
                  className="group flex items-center gap-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white px-5 py-2.5 rounded-xl hover:shadow-lg font-semibold transition-all hover:scale-105"
                >
                  Vedi tutte
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </button>
              </div>
              {featuredLocations.length > 0 ? (
                <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
                  {featuredLocations.slice(0, 8).map((loc: any, index: number) => (
                    <FeaturedLocationCard
                      key={loc.id}
                      location={loc}
                      rank={index + 1}
                      onClick={() => navigate(`/business/${loc.id}`)}
                    />
                  ))}
                </div>
              ) : (
                <div className="text-center py-12 bg-white rounded-2xl">
                  <Star className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500">Nessuna attività disponibile</p>
                </div>
              )}
            </section>

            <section>
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <div className="bg-gradient-to-br from-yellow-400 to-orange-500 p-3 rounded-xl shadow-lg">
                    {isBusiness ? <Building2 className="w-6 h-6 text-white" /> : <Award className="w-6 h-6 text-white" />}
                  </div>
                  <div>
                    <h2 className="text-2xl md:text-3xl font-bold text-gray-900">
                      {isBusiness ? 'Top 20 Aziende' : 'Top Utenti'}
                    </h2>
                    <p className="text-sm text-gray-600">
                      {isBusiness ? 'Le più votate' : 'I primi 20 vincono gift card'}
                    </p>
                  </div>
                </div>
                {!isBusiness && (
                  <button
                    onClick={() => navigate('/leaderboard')}
                    className="group flex items-center gap-2 bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-5 py-2.5 rounded-xl hover:shadow-lg font-semibold transition-all hover:scale-105"
                  >
                    Vedi tutti
                    <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                  </button>
                )}
              </div>

              {isBusiness ? (
                topBusinesses.length > 0 ? (
                  <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    {topBusinesses.slice(0, 8).map((business: any, index: number) => (
                      <TopBusinessCard
                        key={business.id}
                        business={business}
                        rank={index + 1}
                        onClick={() => navigate(`/business/${business.id}`)}
                      />
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12 bg-white rounded-2xl">
                    <Building2 className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                    <p className="text-gray-500">Nessuna azienda disponibile</p>
                  </div>
                )
              ) : (
                topUsers.length > 0 ? (
                  <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    {topUsers.slice(0, 8).map((userActivity: any, index: number) => (
                      <TopUserCard key={`${userActivity.user_id}-${userActivity.family_member_id ?? 'main'}`} userActivity={userActivity} rank={index + 1} />
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12 bg-white rounded-2xl">
                    <Award className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                    <p className="text-gray-500">Nessun utente in classifica</p>
                  </div>
                )
              )}
            </section>

            <section>
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <div className="bg-gradient-to-br from-blue-500 to-cyan-500 p-3 rounded-xl shadow-lg">
                    <Briefcase className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h2 className="text-2xl md:text-3xl font-bold text-gray-900">
                      {isBusiness ? 'Cerco Lavoro' : 'Offerte di Lavoro'}
                    </h2>
                    <p className="text-sm text-gray-600">
                      {isBusiness ? 'Candidati disponibili nella tua categoria' : 'Annunci di lavoro dalle aziende'}
                    </p>
                  </div>
                </div>
                <button
                  onClick={() => navigate('/jobs')}
                  className="group flex items-center gap-2 bg-gradient-to-r from-blue-500 to-cyan-500 text-white px-5 py-2.5 rounded-xl hover:shadow-lg font-semibold transition-all hover:scale-105"
                >
                  Vedi tutti
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </button>
              </div>

              {isBusiness ? (
                jobSeekers.length > 0 ? (
                  <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    {jobSeekers.map((seeker) => (
                      <JobSeekerCard key={seeker.id} seeker={seeker} onClick={() => navigate('/jobs')} />
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12 bg-white rounded-2xl">
                    <Briefcase className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                    <p className="text-gray-500">Nessun candidato disponibile nella tua categoria</p>
                  </div>
                )
              ) : (
                jobPostings.length > 0 ? (
                  <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    {jobPostings.map((job) => {
                      const businessName = job.business?.name || job.registered_business?.name || 'Azienda';
                      return (
                        <div
                          key={job.id}
                          onClick={() => navigate(`/jobs?job=${job.id}`)}
                          className="bg-white rounded-2xl border border-gray-200 p-5 hover:shadow-lg transition-all cursor-pointer hover:-translate-y-1"
                        >
                          <div className="flex items-start justify-between mb-3">
                            <div className="bg-blue-100 p-2 rounded-lg">
                              <Briefcase className="w-5 h-5 text-blue-600" />
                            </div>
                            {job.contract_type && (
                              <span className="text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded-full font-medium">
                                {job.contract_type}
                              </span>
                            )}
                          </div>
                          <h3 className="font-semibold text-gray-900 mb-1 line-clamp-2">{job.title}</h3>
                          <p className="text-sm text-blue-600 font-medium mb-2">{businessName}</p>
                          {job.location && (
                            <div className="flex items-center gap-1 text-xs text-gray-500">
                              <MapPin className="w-3 h-3" />
                              <span>{job.location}</span>
                            </div>
                          )}
                          {job.salary_min && (
                            <div className="flex items-center gap-1 text-xs text-gray-500 mt-1">
                              <Euro className="w-3 h-3" />
                              <span>{job.salary_min.toLocaleString('it-IT')}€{job.salary_max ? ` - ${job.salary_max.toLocaleString('it-IT')}€` : '+'}</span>
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>
                ) : (
                  <div className="text-center py-12 bg-white rounded-2xl">
                    <Briefcase className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                    <p className="text-gray-500">Nessuna offerta di lavoro disponibile</p>
                  </div>
                )
              )}
            </section>

            <section>
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <div className="bg-gradient-to-br from-green-500 to-emerald-500 p-3 rounded-xl shadow-lg">
                    <Tag className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Annunci in Evidenza</h2>
                    <p className="text-sm text-gray-600">Dagli utenti più attivi</p>
                  </div>
                </div>
                <button
                  onClick={() => navigate('/classified-ads?type=sell')}
                  className="group flex items-center gap-2 bg-gradient-to-r from-green-500 to-emerald-500 text-white px-5 py-2.5 rounded-xl hover:shadow-lg font-semibold transition-all hover:scale-105"
                >
                  Vedi tutti
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </button>
              </div>

              {featuredSellAds.length > 0 ? (
                <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
                  {featuredSellAds.map((ad) => (
                    <div
                      key={ad.id}
                      onClick={() => navigate(`/classified-ads/${ad.id}`)}
                      className="bg-white rounded-lg shadow-sm hover:shadow-md transition-all duration-200 overflow-hidden cursor-pointer border border-gray-200"
                    >
                      <div className="relative h-36 overflow-hidden">
                        {ad.images && ad.images.length > 0 ? (
                          <img
                            src={ad.images[0]}
                            alt={ad.title}
                            className="w-full h-full object-cover transition-transform duration-300 hover:scale-105"
                          />
                        ) : (
                          <div className="w-full h-full bg-gray-100 flex items-center justify-center">
                            <Tag className="w-10 h-10 text-gray-300" />
                          </div>
                        )}
                        <div className="absolute top-2 left-2">
                          <span className={`px-2 py-0.5 rounded-full text-xs font-bold shadow-sm ${
                            ad.ad_type === 'sell' ? 'bg-blue-600 text-white'
                            : ad.ad_type === 'buy' ? 'bg-green-600 text-white'
                            : 'bg-orange-600 text-white'
                          }`}>
                            {ad.ad_type === 'sell' ? 'Vendo' : ad.ad_type === 'buy' ? 'Cerco' : 'Regalo'}
                          </span>
                        </div>
                        {ad.category && (
                          <div className="absolute bottom-2 left-2 bg-white/90 backdrop-blur-sm px-2 py-0.5 rounded text-xs font-medium text-gray-700">
                            {ad.category}
                          </div>
                        )}
                        {ad.price != null && (
                          <div className="absolute top-2 right-2 bg-white text-gray-900 px-2 py-0.5 rounded-full text-xs font-bold shadow-sm">
                            €{Number(ad.price).toLocaleString('it-IT')}
                          </div>
                        )}
                      </div>

                      <div className="p-3">
                        <h3 className="font-semibold text-sm text-gray-900 mb-1 line-clamp-1 hover:text-blue-600 transition-colors">
                          {ad.title}
                        </h3>
                        <p className="text-xs text-gray-500 mb-2 line-clamp-1">
                          {ad.description}
                        </p>

                        <div className="flex items-center justify-between pt-2 border-t border-gray-200">
                          <div className="flex items-center gap-1 text-xs text-gray-500">
                            <MapPin className="w-3 h-3" />
                            <span className="truncate max-w-[80px]">{ad.city}{ad.province ? `, ${ad.province}` : ''}</span>
                          </div>
                          <div className="flex items-center gap-1 text-xs text-gray-400">
                            {ad.user_avatar_url ? (
                              <img src={ad.user_avatar_url} alt={ad.user_nickname || ad.user_full_name} className="w-4 h-4 rounded-full object-cover" />
                            ) : (
                              <div className="w-4 h-4 rounded-full bg-gray-200 flex items-center justify-center">
                                <User className="w-2.5 h-2.5 text-gray-500" />
                              </div>
                            )}
                            <span className="truncate max-w-[70px]">{ad.user_nickname || ad.user_full_name}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-12 bg-white rounded-2xl">
                  <Tag className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500">Nessun annuncio disponibile</p>
                </div>
              )}
            </section>

            <section>
                <div className="flex items-center justify-between mb-6">
                  <div className="flex items-center gap-3">
                    <div className="bg-gradient-to-br from-amber-500 to-orange-500 p-3 rounded-xl shadow-lg">
                      <Gavel className="w-6 h-6 text-white" />
                    </div>
                    <div>
                      <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Aste in Evidenza</h2>
                      <p className="text-sm text-gray-600">Le aste più recenti sulla piattaforma</p>
                    </div>
                  </div>
                  <button
                    onClick={() => navigate('/auctions')}
                    className="group flex items-center gap-2 bg-gradient-to-r from-amber-500 to-orange-500 text-white px-5 py-2.5 rounded-xl hover:shadow-lg font-semibold transition-all hover:scale-105"
                  >
                    Vedi tutte
                    <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                  </button>
                </div>

                {featuredAuctions.length > 0 ? (
                  <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
                    {featuredAuctions.map((auction) => (
                      <AuctionCard key={auction.id} auction={auction} />
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12 bg-white rounded-2xl">
                    <Gavel className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                    <p className="text-gray-500">Nessuna asta disponibile al momento</p>
                  </div>
                )}
              </section>

            {expiringAuctions.length > 0 && (
              <section>
                <div className="flex items-center justify-between mb-6">
                  <div className="flex items-center gap-3">
                    <div className="bg-gradient-to-br from-orange-500 to-red-500 p-3 rounded-xl shadow-lg relative">
                      <Gavel className="w-6 h-6 text-white" />
                      <span className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full animate-ping"></span>
                      <span className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full"></span>
                    </div>
                    <div>
                      <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Aste in Scadenza</h2>
                      <p className="text-sm text-gray-600">Non perdere queste occasioni, stanno per terminare!</p>
                    </div>
                  </div>
                  <button
                    onClick={() => navigate('/auctions')}
                    className="group flex items-center gap-2 bg-gradient-to-r from-orange-500 to-red-500 text-white px-5 py-2.5 rounded-xl hover:shadow-lg font-semibold transition-all hover:scale-105"
                  >
                    Tutte le Aste
                    <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                  </button>
                </div>

                <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
                  {expiringAuctions.map((auction) => {
                    const now = new Date();
                    const endDate = new Date(auction.ends_at);
                    const diff = endDate.getTime() - now.getTime();
                    const hoursLeft = diff / (1000 * 60 * 60);
                    const isUrgent = hoursLeft <= 24;

                    return (
                      <div key={auction.id} className="relative group">
                        {isUrgent && (
                          <div className="absolute -top-2 -left-2 z-10 bg-red-600 text-white text-xs font-bold px-3 py-1 rounded-full shadow-lg animate-pulse">
                            ULTIME ORE!
                          </div>
                        )}
                        <div className={`rounded-2xl overflow-hidden transition-all duration-300 group-hover:shadow-xl ${isUrgent ? 'ring-2 ring-red-400 ring-offset-2' : 'ring-1 ring-gray-200'}`}>
                          <AuctionCard auction={auction} />
                        </div>
                      </div>
                    );
                  })}
                </div>
              </section>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

function FeaturedLocationCard({ location, rank, onClick }: { location: any; rank: number; onClick: () => void }) {
  const name = location.name || 'Sede';
  const avgRating = location.avg_rating || 0;
  const reviewCount = location.review_count || 0;
  const fillFn = (star: number) => Math.min(1, Math.max(0, avgRating - (star - 1)));

  return (
    <div
      onClick={onClick}
      className="bg-white rounded-2xl border border-gray-100 shadow-sm hover:shadow-lg transition-all cursor-pointer overflow-hidden hover:-translate-y-1 group"
    >
      <div className="relative h-36 bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center overflow-hidden">
        {location.avatar_url ? (
          <img src={location.avatar_url} alt={name} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
        ) : (
          <span className="text-5xl font-extrabold text-emerald-200 group-hover:scale-110 transition-transform duration-300">
            {name.charAt(0).toUpperCase()}
          </span>
        )}
        <div className="absolute top-2.5 left-2.5 bg-emerald-500 text-white text-xs font-bold w-6 h-6 rounded-full flex items-center justify-center shadow">
          {rank}
        </div>
        {location.is_claimed && (
          <div className="absolute top-2.5 right-2.5 bg-blue-600 text-white text-xs font-semibold px-2 py-0.5 rounded-full shadow">
            Verificata
          </div>
        )}
      </div>
      <div className="p-4">
        <h3 className="font-bold text-gray-900 mb-0.5 line-clamp-1 text-sm">{name}</h3>
        {location.category_name && (
          <p className="text-xs text-blue-600 font-medium mb-2 line-clamp-1">{location.category_name}</p>
        )}
        {location.city && (
          <div className="flex items-center gap-1 text-xs text-gray-500 mb-3">
            <MapPin className="w-3 h-3 flex-shrink-0" />
            <span className="truncate">{location.city}{location.province ? `, ${location.province}` : ''}</span>
          </div>
        )}
        {reviewCount > 0 ? (
          <div className="flex items-center gap-1.5 pt-2 border-t border-gray-100">
            <div className="flex items-center gap-0.5">
              {[1, 2, 3, 4, 5].map((star) => {
                const fill = fillFn(star);
                const uid = `fl-${location.id}-${star}`;
                return (
                  <svg key={star} width={14} height={14} viewBox="0 0 24 24">
                    <defs><clipPath id={uid}><rect x="0" y="0" width={24 * fill} height="24" /></clipPath></defs>
                    <polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26" fill="#e5e7eb" stroke="#e5e7eb" strokeWidth="1" />
                    <polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26" fill="#22c55e" stroke="#22c55e" strokeWidth="1" clipPath={`url(#${uid})`} />
                  </svg>
                );
              })}
            </div>
            <span className="font-bold text-xs text-gray-900">{avgRating.toFixed(1)}</span>
            <span className="text-xs text-gray-400">({reviewCount})</span>
          </div>
        ) : (
          <p className="text-xs text-gray-400 italic pt-2 border-t border-gray-100">Nessuna recensione</p>
        )}
      </div>
    </div>
  );
}

function TopUserCard({ userActivity, rank }: { userActivity: any; rank: number }) {
  const fm = userActivity.family_member;
  const displayName = fm
    ? (fm.nickname || `${fm.first_name} ${fm.last_name}`)
    : (userActivity.profiles?.nickname || userActivity.profiles?.full_name || 'Utente');
  const avatarUrl = fm?.avatar_url || userActivity.profiles?.avatar_url;
  const isTopThree = rank <= 3;

  return (
    <div className={`relative bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all p-5 border-2 ${
      isTopThree ? 'border-yellow-300 bg-gradient-to-br from-yellow-50 to-white' : 'border-gray-200'
    }`}>
      {isTopThree && (
        <div className="absolute -top-3 -right-3 w-10 h-10 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full flex items-center justify-center shadow-lg animate-pulse">
          <Award className="w-5 h-5 text-white" />
        </div>
      )}

      <div className="flex items-center gap-3 mb-4">
        <div className={`relative w-12 h-12 rounded-full flex items-center justify-center font-bold text-white shadow-md ${
          rank === 1 ? 'bg-gradient-to-br from-yellow-400 to-yellow-600' :
          rank === 2 ? 'bg-gradient-to-br from-gray-300 to-gray-500' :
          rank === 3 ? 'bg-gradient-to-br from-orange-400 to-orange-600' :
          'bg-gradient-to-br from-blue-400 to-blue-600'
        }`}>
          <span className="text-lg">{rank}</span>
        </div>

        {avatarUrl ? (
          <img
            src={avatarUrl}
            alt={displayName}
            className="w-14 h-14 rounded-full object-cover border-2 border-white shadow-md"
          />
        ) : (
          <div className="w-14 h-14 rounded-full bg-gradient-to-br from-gray-200 to-gray-300 flex items-center justify-center border-2 border-white shadow-md">
            <Users className="w-7 h-7 text-gray-500" />
          </div>
        )}
      </div>

      <h3 className="font-bold text-gray-900 text-lg mb-4 truncate">{displayName}</h3>

      <div className="space-y-2">
        <div className="flex items-center justify-between bg-yellow-50 rounded-lg px-3 py-2">
          <span className="text-sm text-gray-700 font-medium">Punti</span>
          <span className="font-bold text-yellow-600 text-lg">{userActivity.total_points}</span>
        </div>
        <div className="flex items-center justify-between bg-blue-50 rounded-lg px-3 py-2">
          <span className="text-sm text-gray-700 font-medium">Recensioni</span>
          <span className="font-bold text-blue-600">{userActivity.reviews_count}</span>
        </div>
      </div>
    </div>
  );
}

function TopBusinessCard({ business, rank, onClick }: { business: any; rank: number; onClick: () => void }) {
  const isTopThree = rank <= 3;

  return (
    <div
      onClick={onClick}
      className={`relative bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all p-5 border-2 cursor-pointer ${
        isTopThree ? 'border-yellow-300 bg-gradient-to-br from-yellow-50 to-white' : 'border-gray-200'
      }`}
    >
      {isTopThree && (
        <div className="absolute -top-3 -right-3 w-10 h-10 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full flex items-center justify-center shadow-lg animate-pulse">
          <Award className="w-5 h-5 text-white" />
        </div>
      )}

      <div className="flex items-center gap-3 mb-4">
        <div className={`relative w-12 h-12 rounded-full flex items-center justify-center font-bold text-white shadow-md ${
          rank === 1 ? 'bg-gradient-to-br from-yellow-400 to-yellow-600' :
          rank === 2 ? 'bg-gradient-to-br from-gray-300 to-gray-500' :
          rank === 3 ? 'bg-gradient-to-br from-orange-400 to-orange-600' :
          'bg-gradient-to-br from-blue-400 to-blue-600'
        }`}>
          <span className="text-lg">{rank}</span>
        </div>

        {business.avatar_url ? (
          <img
            src={business.avatar_url}
            alt={business.name}
            className="w-14 h-14 rounded-full object-cover border-2 border-white shadow-md"
          />
        ) : (
          <div className="w-14 h-14 rounded-full bg-gradient-to-br from-blue-200 to-blue-300 flex items-center justify-center border-2 border-white shadow-md">
            <Building2 className="w-7 h-7 text-blue-600" />
          </div>
        )}
      </div>

      <h3 className="font-bold text-gray-900 text-lg mb-2 truncate">{business.name}</h3>
      <p className="text-sm text-gray-600 mb-4 flex items-center gap-1">
        <MapPin className="w-4 h-4" />
        <span className="truncate">{business.city}, {business.province}</span>
      </p>

      <div className="space-y-2">
        <div className="flex items-center justify-between bg-blue-50 rounded-lg px-3 py-2">
          <span className="text-sm text-gray-700 font-medium">Recensioni</span>
          <span className="font-bold text-blue-600 text-lg">{business.review_count}</span>
        </div>
        <div className="flex items-center justify-between bg-yellow-50 rounded-lg px-3 py-2">
          <span className="text-sm text-gray-700 font-medium">Valutazione</span>
          <div className="flex items-center gap-1">
            <Star className="w-4 h-4 text-yellow-500 fill-yellow-500" />
            <span className="font-bold text-yellow-600">{business.avg_rating?.toFixed(1) || 'N/A'}</span>
          </div>
        </div>
      </div>
    </div>
  );
}

function JobSeekerCard({ seeker, onClick }: { seeker: any; onClick: () => void }) {
  const displayName = seeker.profiles?.nickname || seeker.profiles?.full_name || 'Utente';

  return (
    <div
      onClick={onClick}
      className="group bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all p-6 cursor-pointer border-2 border-blue-100 hover:border-blue-300 transform hover:-translate-y-1"
    >
      <div className="flex items-start gap-4 mb-4">
        {seeker.profiles?.avatar_url ? (
          <img
            src={seeker.profiles.avatar_url}
            alt={displayName}
            className="w-16 h-16 rounded-full object-cover border-2 border-blue-200"
          />
        ) : (
          <div className="w-16 h-16 rounded-full bg-gradient-to-br from-blue-100 to-cyan-100 flex items-center justify-center border-2 border-blue-200">
            <Users className="w-8 h-8 text-blue-600" />
          </div>
        )}
        <div className="flex-1 min-w-0">
          <h3 className="font-bold text-lg text-gray-900 line-clamp-1 group-hover:text-blue-600 transition-colors mb-1">
            {seeker.title}
          </h3>
          <p className="text-sm text-gray-600 font-medium line-clamp-1">
            {displayName}
          </p>
        </div>
      </div>

      <p className="text-sm text-gray-600 line-clamp-2 mb-4">
        {seeker.description}
      </p>

      <div className="space-y-2 mb-4">
        <div className="flex items-center gap-2 text-sm text-gray-600 bg-gray-50 px-3 py-2 rounded-lg">
          <MapPin className="w-4 h-4 text-blue-500 flex-shrink-0" />
          <span className="line-clamp-1">{seeker.city || seeker.location}</span>
        </div>

        {seeker.desired_salary_min && (
          <div className="flex items-center gap-2 text-sm bg-gradient-to-r from-green-50 to-emerald-50 px-3 py-2 rounded-lg border border-green-200">
            <Euro className="w-4 h-4 text-green-600" />
            <span className="font-bold text-green-700">
              {seeker.desired_salary_min.toLocaleString()}
              {seeker.desired_salary_max && ` - ${seeker.desired_salary_max.toLocaleString()}`} €
            </span>
          </div>
        )}
      </div>

      <div className="flex items-center gap-2 flex-wrap">
        <span className="px-3 py-1 bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700 text-xs font-semibold rounded-full">
          {seeker.contract_type}
        </span>
        {seeker.experience_years > 0 && (
          <span className="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">
            {seeker.experience_years} {seeker.experience_years === 1 ? 'anno' : 'anni'}
          </span>
        )}
        {seeker.category?.name && (
          <span className="px-3 py-1 bg-purple-100 text-purple-700 text-xs font-medium rounded-full">
            {seeker.category.name}
          </span>
        )}
      </div>
    </div>
  );
}
