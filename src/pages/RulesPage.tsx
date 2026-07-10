import { Shield, HelpCircle, Cookie, FileText, ChevronDown, ChevronUp } from 'lucide-react';
import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

interface RulesContent {
  id: string;
  section_key: string;
  section_title: string;
  content_text: string;
  display_order: number;
  is_active: boolean;
}

interface FAQ {
  id: string;
  category: string;
  question: string;
  answer: string;
  display_order: number;
  is_active: boolean;
}

const LAST_UPDATED = 'maggio 2026';
const PLATFORM_NAME = 'Lhimo';
const CONTACT_EMAIL = 'privacy@lhimo.it';
// TODO: sostituire con i dati legali reali prima del go-live
const COMPANY_NAME = 'Lhimo S.r.l.';
const COMPANY_ADDRESS = 'da definire';
const VAT_NUMBER = 'da definire';

function AccordionItem({ question, answer }: { question: string; answer: string }) {
  const [open, setOpen] = useState(false);
  return (
    <div className="border border-gray-200 rounded-xl overflow-hidden">
      <button
        onClick={() => setOpen(o => !o)}
        className="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-gray-50 transition-colors"
      >
        <span className="font-semibold text-gray-900 text-sm pr-4">{question}</span>
        {open ? <ChevronUp className="w-4 h-4 text-gray-400 flex-shrink-0" /> : <ChevronDown className="w-4 h-4 text-gray-400 flex-shrink-0" />}
      </button>
      {open && (
        <div className="px-5 pb-5 border-t border-gray-100">
          <p className="text-gray-600 text-sm leading-relaxed pt-4">{answer}</p>
        </div>
      )}
    </div>
  );
}

export function RulesPage() {
  const [rulesContent, setRulesContent] = useState<RulesContent[]>([]);
  const [faqs, setFaqs] = useState<FAQ[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCategory, setSelectedCategory] = useState<string>('Tutte');
  const [activeTab, setActiveTab] = useState<'regolamento' | 'faq' | 'cookie' | 'termini'>('regolamento');
  const [pendingScrollId, setPendingScrollId] = useState<string | null>(null);

  const hashToTab = (hash: string): typeof activeTab | null => {
    if (hash === 'faq') return 'faq';
    if (hash === 'cookie-policy') return 'cookie';
    if (hash === 'termini' || hash === 'termini-servizio' || hash === 'privacy-policy' || hash === 'condizioni-uso') return 'termini';
    if (hash === 'regolamento') return 'regolamento';
    return null;
  };

  const applyHash = () => {
    const hash = window.location.hash.replace('#', '');
    if (!hash) return;
    const tab = hashToTab(hash);
    if (tab) setActiveTab(tab);
    setPendingScrollId(hash);
  };

  // scroll after tab renders — wait for DOM paint, offset for sticky header
  useEffect(() => {
    if (!pendingScrollId) return;
    let raf: number;
    const tryScroll = () => {
      const el = document.getElementById(pendingScrollId);
      if (el) {
        const headerEl = document.querySelector('header');
        const headerHeight = headerEl ? headerEl.getBoundingClientRect().height : 64;
        const top = el.getBoundingClientRect().top + window.scrollY - headerHeight - 88;
        window.scrollTo({ top, behavior: 'smooth' });
        setPendingScrollId(null);
      } else {
        raf = requestAnimationFrame(tryScroll);
      }
    };
    raf = requestAnimationFrame(tryScroll);
    return () => cancelAnimationFrame(raf);
  }, [pendingScrollId, activeTab, loading]);

  useEffect(() => {
    loadData();
    applyHash();
    window.addEventListener('hashchange', applyHash);
    return () => window.removeEventListener('hashchange', applyHash);
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      const [rulesResult, faqsResult] = await Promise.all([
        supabase.from('rules_content').select('*').eq('is_active', true).order('display_order'),
        supabase.from('faqs').select('*').eq('is_active', true).order('category').order('display_order'),
      ]);
      setRulesContent(rulesResult.data || []);
      setFaqs(faqsResult.data || []);
    } catch (error) {
      console.error('Error loading rules:', error);
    } finally {
      setLoading(false);
    }
  };

  const categories = ['Tutte', ...Array.from(new Set(faqs.map(f => f.category)))];
  const filteredFAQs = selectedCategory === 'Tutte' ? faqs : faqs.filter(f => f.category === selectedCategory);
  const groupedFAQs = filteredFAQs.reduce((acc, faq) => {
    if (!acc[faq.category]) acc[faq.category] = [];
    acc[faq.category].push(faq);
    return acc;
  }, {} as Record<string, FAQ[]>);

  const tabs = [
    { key: 'regolamento' as const, label: 'Regolamento', icon: Shield, color: 'blue' },
    { key: 'faq' as const, label: 'FAQ', icon: HelpCircle, color: 'green' },
    { key: 'cookie' as const, label: 'Cookie Policy', icon: Cookie, color: 'amber' },
    { key: 'termini' as const, label: 'Termini & Privacy', icon: FileText, color: 'teal' },
  ];

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600 mx-auto mb-3"></div>
          <p className="text-gray-500 text-sm">Caricamento...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Hero */}
      <section className="bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 border-b border-slate-700">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12 text-center">
          <div className="inline-flex items-center gap-2 bg-white/10 text-white/70 text-xs font-semibold px-3 py-1.5 rounded-full mb-5 backdrop-blur">
            <div className="w-1.5 h-1.5 bg-emerald-400 rounded-full"></div>
            Documenti legali e regolamento
          </div>
          <h1 className="text-3xl md:text-4xl font-bold text-white mb-3">Regolamento, FAQ e Documenti Legali</h1>
          <p className="text-slate-400 text-base max-w-xl mx-auto">
            Tutto quello che devi sapere per utilizzare {PLATFORM_NAME} in modo corretto e sicuro.
          </p>
        </div>
      </section>

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        {/* Tab bar */}
        <div className="bg-white rounded-2xl border border-gray-200 shadow-sm mb-6 overflow-hidden">
          <div className="flex overflow-x-auto">
            {tabs.map(({ key, label, icon: Icon }) => (
              <button
                key={key}
                onClick={() => setActiveTab(key)}
                className={`flex-1 min-w-[120px] flex items-center justify-center gap-2 px-4 py-4 text-sm font-semibold border-b-2 transition-colors ${
                  activeTab === key
                    ? 'border-blue-600 text-blue-600 bg-blue-50/50'
                    : 'border-transparent text-gray-500 hover:text-gray-800 hover:bg-gray-50'
                }`}
              >
                <Icon className="w-4 h-4" />
                <span className="hidden sm:inline">{label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Regolamento */}
        {activeTab === 'regolamento' && (
          <div id="regolamento" className="space-y-4">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-9 h-9 bg-blue-100 rounded-xl flex items-center justify-center">
                <Shield className="w-5 h-5 text-blue-600" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900">Regolamento della Piattaforma</h2>
                <p className="text-sm text-gray-500">Aggiornato il {LAST_UPDATED}</p>
              </div>
            </div>

            {rulesContent.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-200 p-10 text-center">
                <Shield className="w-12 h-12 text-gray-200 mx-auto mb-3" />
                <p className="text-gray-500 text-sm">Nessun contenuto disponibile al momento.</p>
                <p className="text-gray-400 text-xs mt-1">Il regolamento viene gestito dall'admin dalla sezione apposita.</p>
              </div>
            ) : (
              rulesContent.map((section, index) => (
                <div key={section.id} id={section.section_key} className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
                  <div className="flex items-center gap-4 px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                    <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
                      {index + 1}
                    </div>
                    <h3 className="font-bold text-gray-900">{section.section_title}</h3>
                  </div>
                  <div className="px-6 py-5">
                    <p className="text-gray-600 text-sm leading-relaxed whitespace-pre-line">{section.content_text}</p>
                  </div>
                </div>
              ))
            )}
          </div>
        )}

        {/* FAQ */}
        {activeTab === 'faq' && (
          <div id="faq" className="space-y-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-9 h-9 bg-green-100 rounded-xl flex items-center justify-center">
                <HelpCircle className="w-5 h-5 text-green-600" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900">Domande Frequenti</h2>
                <p className="text-sm text-gray-500">Trova risposta alle domande più comuni</p>
              </div>
            </div>

            {/* Filtro categoria */}
            {categories.length > 2 && (
              <div className="bg-white rounded-2xl border border-gray-200 p-4">
                <div className="flex flex-wrap gap-2">
                  {categories.map(cat => (
                    <button
                      key={cat}
                      onClick={() => setSelectedCategory(cat)}
                      className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors ${
                        selectedCategory === cat ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                      }`}
                    >
                      {cat}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {filteredFAQs.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-200 p-10 text-center">
                <HelpCircle className="w-12 h-12 text-gray-200 mx-auto mb-3" />
                <p className="text-gray-500 text-sm">Nessuna FAQ disponibile{selectedCategory !== 'Tutte' ? ' in questa categoria' : ''}.</p>
              </div>
            ) : (
              Object.entries(groupedFAQs).map(([category, categoryFaqs]) => (
                <div key={category}>
                  {selectedCategory === 'Tutte' && (
                    <h3 className="text-sm font-bold text-gray-500 uppercase tracking-wide mb-3 pl-1">{category}</h3>
                  )}
                  <div className="space-y-2">
                    {categoryFaqs.map(faq => (
                      <AccordionItem key={faq.id} question={faq.question} answer={faq.answer} />
                    ))}
                  </div>
                </div>
              ))
            )}
          </div>
        )}

        {/* Cookie Policy */}
        {activeTab === 'cookie' && (
          <div id="cookie-policy" className="space-y-4">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-9 h-9 bg-amber-100 rounded-xl flex items-center justify-center">
                <Cookie className="w-5 h-5 text-amber-600" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900">Cookie Policy</h2>
                <p className="text-sm text-gray-500">Aggiornata il {LAST_UPDATED}</p>
              </div>
            </div>

            <div className="bg-amber-50 border border-amber-200 rounded-2xl px-5 py-4">
              <p className="text-amber-900 font-semibold text-sm mb-1">Informativa trasparente</p>
              <p className="text-amber-800 text-sm leading-relaxed">
                {PLATFORM_NAME} utilizza esclusivamente cookie tecnici necessari al funzionamento della piattaforma.
                Non utilizziamo cookie di profilazione, non facciamo pubblicità comportamentale e non vendiamo
                né condividiamo i tuoi dati con terze parti a scopo commerciale.
              </p>
            </div>

            {[
              {
                title: 'Cookie tecnici e di sessione',
                items: [
                  { label: 'Autenticazione (Supabase)', desc: 'Gestiti da Supabase, mantengono la tua sessione attiva dopo il login. Strettamente necessari al funzionamento del sito, non richiedono consenso. I server Supabase sono localizzati nell\'Unione Europea.' },
                  { label: 'Preferenze locali', desc: 'Memorizzano impostazioni locali come la lingua selezionata o il profilo attivo. Non contengono dati personali identificativi e sono salvati solo nel tuo browser (localStorage).' },
                ]
              },
              {
                title: 'Cookie di terze parti',
                items: [
                  { label: 'Stripe (pagamenti)', desc: 'Durante il checkout per acquistare un piano, Stripe Inc. può impostare cookie propri necessari per la sicurezza della transazione e la prevenzione delle frodi. Stripe è certificato PCI-DSS Level 1. Privacy policy: stripe.com/privacy.' },
                  { label: 'Brevo (email transazionali)', desc: 'Utilizziamo Brevo (ex Sendinblue, sede legale in Francia - UE) per l\'invio di email automatiche di servizio (conferme di registrazione, notifiche, avvisi). Brevo non imposta cookie sul tuo browser ma riceve il tuo indirizzo email per la consegna dei messaggi. Privacy policy: brevo.com/legal/privacypolicy.' },
                ]
              },
              {
                title: 'Cosa NON facciamo',
                items: [
                  { label: 'Nessun tracciamento pubblicitario', desc: 'Non utilizziamo Google Ads, Meta Pixel, TikTok Pixel o sistemi analoghi di tracciamento per la pubblicità comportamentale.' },
                  { label: 'Nessuna vendita di dati', desc: 'I tuoi dati non vengono mai venduti, ceduti o condivisi con terze parti per scopi commerciali.' },
                  { label: 'Nessuna analytics invasiva', desc: 'Non utilizziamo Google Analytics, Hotjar o sistemi di analisi comportamentale di terze parti che tracciano i tuoi movimenti sul sito.' },
                ]
              },
              {
                title: 'Come gestire i cookie',
                items: [
                  { label: 'Impostazioni del browser', desc: 'Puoi configurare il browser per bloccare o eliminare i cookie. Disabilitare i cookie tecnici può compromettere il funzionamento del sito (es. impossibilità di restare connesso).' },
                  { label: 'Cancellazione', desc: 'Puoi eliminare i cookie salvati dal browser in qualsiasi momento dalle impostazioni del browser stesso (Chrome: Impostazioni > Privacy > Cancella dati di navigazione).' },
                  { label: 'Reclamo al Garante', desc: 'Se ritieni che il trattamento dei dati connessi ai cookie violi la normativa, puoi proporre reclamo al Garante per la Protezione dei Dati Personali (garante.privacy.it) o scrivere a ' + CONTACT_EMAIL + '.' },
                ]
              },
            ].map(({ title, items }) => (
              <div key={title} className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
                <div className="px-5 py-4 border-b border-gray-100 bg-gray-50/50">
                  <h3 className="font-bold text-gray-900 text-sm">{title}</h3>
                </div>
                <div className="px-5 py-4 space-y-3">
                  {items.map(({ label, desc }) => (
                    <div key={label} className="flex gap-3">
                      <div className="w-1.5 h-1.5 rounded-full bg-amber-400 flex-shrink-0 mt-2"></div>
                      <div className="text-sm">
                        <span className="font-semibold text-gray-800">{label}: </span>
                        <span className="text-gray-600">{desc}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}

            <div className="bg-white rounded-2xl border border-gray-200 p-5 text-center">
              <p className="text-gray-500 text-xs">
                Per domande sui cookie scrivi a <strong>{CONTACT_EMAIL}</strong>
              </p>
            </div>
          </div>
        )}

        {/* Termini & Privacy */}
        {activeTab === 'termini' && (
          <div id="termini" className="space-y-4">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-9 h-9 bg-teal-100 rounded-xl flex items-center justify-center">
                <FileText className="w-5 h-5 text-teal-600" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900">Termini di Servizio e Privacy</h2>
                <p className="text-sm text-gray-500">Aggiornati il {LAST_UPDATED} · {COMPANY_NAME}</p>
              </div>
            </div>

            {/* Info azienda - placeholder */}
            <div className="bg-blue-50 border border-blue-200 rounded-2xl px-5 py-4">
              <p className="text-blue-900 text-xs font-semibold mb-1">Titolare del Trattamento</p>
              <p className="text-blue-800 text-sm">
                <strong>{COMPANY_NAME}</strong> — {COMPANY_ADDRESS}<br />
                P.IVA: {VAT_NUMBER} — Email: <strong>{CONTACT_EMAIL}</strong>
              </p>
            </div>

            {[
              {
                id: 'termini-servizio',
                title: 'Termini di Servizio',
                items: [
                  {
                    label: 'Accettazione dei termini',
                    text: `Utilizzando ${PLATFORM_NAME} accetti integralmente i presenti Termini di Servizio. Se non li accetti, ti chiediamo di non utilizzare il servizio. L'accettazione avviene al momento della registrazione tramite apposita checkbox.`,
                  },
                  {
                    label: 'Descrizione del servizio',
                    text: `${PLATFORM_NAME} è una piattaforma italiana che consente agli utenti di cercare, recensire e scoprire attività commerciali locali, pubblicare annunci, partecipare ad aste online e trovare opportunità di lavoro. Il servizio è riservato a maggiorenni residenti in Italia. I dati geografici delle attività commerciali sono parzialmente derivati da OpenStreetMap (© OpenStreetMap contributors, licenza ODbL) e da Geofabrik GmbH.`,
                  },
                  {
                    label: 'Registrazione e account',
                    text: 'Sei responsabile della sicurezza del tuo account e di tutte le attività svolte con esso. Devi fornire informazioni veritiere e aggiornate durante la registrazione. Non è consentito condividere le credenziali di accesso con terzi.',
                  },
                  {
                    label: 'Contenuti pubblicati dall\'utente',
                    text: 'Sei l\'unico responsabile dei contenuti che pubblichi (recensioni, annunci, offerte di lavoro, immagini). Non è consentito pubblicare contenuti falsi, diffamatori, offensivi, illegali o che violino i diritti di proprietà intellettuale di terzi.',
                  },
                  {
                    label: 'Sospensione e chiusura account',
                    text: `Ci riserviamo il diritto di sospendere o eliminare account che violino i presenti Termini, le regole della community o la normativa vigente. In caso di violazioni gravi, la sospensione può avvenire senza preavviso.`,
                  },
                  {
                    label: 'Modifiche al servizio',
                    text: `${PLATFORM_NAME} può modificare, sospendere o interrompere il servizio in qualsiasi momento. Le modifiche sostanziali verranno comunicate agli utenti registrati con ragionevole preavviso via email o notifica in-app.`,
                  },
                  {
                    label: 'Legge applicabile e foro competente',
                    text: 'I presenti Termini sono regolati dalla legge italiana. Per qualsiasi controversia è competente in via esclusiva il Tribunale del luogo di sede legale della società.',
                  },
                ],
              },
              {
                id: 'privacy-policy',
                title: 'Privacy Policy',
                items: [
                  {
                    label: 'Base giuridica del trattamento',
                    text: 'Il trattamento dei tuoi dati avviene sulla base del tuo consenso esplicito (art. 6 lett. a GDPR), dell\'esecuzione del contratto di servizio (art. 6 lett. b GDPR) e degli obblighi legali (art. 6 lett. c GDPR).',
                  },
                  {
                    label: 'Dati raccolti',
                    text: 'Raccogliamo: dati forniti in fase di registrazione (nome, email, tipologia di profilo, codice fiscale opzionale); contenuti pubblicati sulla piattaforma; dati tecnici necessari al servizio (log di accesso, indirizzo IP, dispositivo). Non raccogliamo dati bancari o di carta di credito.',
                  },
                  {
                    label: 'Finalità del trattamento',
                    text: 'I tuoi dati vengono utilizzati esclusivamente per: erogare e migliorare il servizio, gestire il tuo account e abbonamento, inviare comunicazioni di servizio (notifiche, conferme, avvisi di sicurezza), adempiere a obblighi legali e fiscali.',
                  },
                  {
                    label: 'Fornitori di servizio (responsabili del trattamento)',
                    text: 'Ai sensi dell\'art. 28 GDPR, ci avvaliamo dei seguenti responsabili del trattamento: (1) Supabase Inc. — database, autenticazione e archiviazione file; server localizzati nell\'Unione Europea; DPA disponibile su supabase.com/privacy. (2) Stripe Inc. — gestione pagamenti; certificato PCI-DSS Level 1; non archiviamo né riceviamo i dati della carta di credito; DPA e privacy policy su stripe.com/privacy. (3) Brevo SAS (ex Sendinblue) — invio email transazionali di servizio (conferme, notifiche, avvisi); sede legale in Francia (UE); riceve l\'indirizzo email degli utenti per la consegna dei messaggi; DPA e privacy policy su brevo.com/legal/privacypolicy. (4) OpenStreetMap Foundation / Geofabrik GmbH — utilizzati esclusivamente come fonte di dati geografici pubblici (Open Database License 1.0) per popolare il database delle attività commerciali; non ricevono dati personali degli utenti della piattaforma.',
                  },
                  {
                    label: 'Conservazione dei dati',
                    text: 'I dati vengono conservati per il tempo necessario all\'erogazione del servizio e nel rispetto degli obblighi di legge (es. dati fiscali: 10 anni). Alla cancellazione dell\'account i dati personali vengono eliminati entro 30 giorni, salvo obblighi di conservazione.',
                  },
                  {
                    label: 'I tuoi diritti (GDPR)',
                    text: `Hai diritto di: accesso ai tuoi dati (art. 15), rettifica (art. 16), cancellazione ("diritto all'oblio", art. 17), portabilità (art. 20), opposizione al trattamento (art. 21), limitazione (art. 18). Per esercitare questi diritti scrivi a ${CONTACT_EMAIL}. Hai anche il diritto di proporre reclamo al Garante per la Protezione dei Dati Personali (garante.privacy.it).`,
                  },
                  {
                    label: 'Trasferimento dati extra-UE',
                    text: 'I dati possono essere trasferiti verso paesi extra-UE esclusivamente attraverso fornitori certificati che garantiscono un livello di protezione adeguato tramite Clausole Contrattuali Standard (Standard Contractual Clauses) approvate dalla Commissione Europea.',
                  },
                  {
                    label: 'Minori',
                    text: `${PLATFORM_NAME} è riservato a persone di età superiore ai 18 anni. Non raccogliamo consapevolmente dati personali di minori. Se rilevi che un minore ha fornito dati senza consenso, contattaci a ${CONTACT_EMAIL}.`,
                  },
                ],
              },
              {
                id: 'condizioni-uso',
                title: "Condizioni d'uso",
                items: [
                  {
                    label: 'Uso lecito',
                    text: 'La piattaforma deve essere utilizzata esclusivamente per scopi leciti e in conformità con la legislazione italiana ed europea vigente, inclusi il Codice del Consumo (D.Lgs. 206/2005), il GDPR (Reg. UE 2016/679), il D.Lgs. 70/2003 sul commercio elettronico e il Digital Services Act (Reg. UE 2022/2065).',
                  },
                  {
                    label: 'Recensioni',
                    text: 'Le recensioni devono essere veritiere e basate su esperienze dirette e personali. È vietato pubblicare recensioni false, acquistare recensioni, manipolare il sistema di valutazione o recensire attività con cui si ha un conflitto di interesse.',
                  },
                  {
                    label: 'Annunci e aste',
                    text: 'Gli annunci devono riguardare prodotti o servizi reali, legali e di proprietà del pubblicante. Per le aste, la partecipazione richiede l\'acquisto di un ticket (pari al 10% della base d\'asta): il ticket è rimborsato in caso di sconfitta, trattenuto dalla piattaforma in caso di aggiudicazione confermata. Le transazioni tra utenti avvengono direttamente tra le parti: la piattaforma non gestisce spedizioni né garantisce le transazioni. È vietato pubblicare offerte fraudolente, prodotti contraffatti o materiale illegale.',
                  },
                  {
                    label: 'Rispetto della community',
                    text: 'È richiesto un comportamento rispettoso verso tutti gli utenti. Sono vietati insulti, discriminazioni per qualsiasi motivo, molestie, spam, comportamenti intimidatori o qualsiasi forma di abuso della piattaforma.',
                  },
                  {
                    label: 'Proprietà intellettuale',
                    text: `Il marchio ${PLATFORM_NAME}, il design, il codice e i contenuti originali della piattaforma sono di proprietà esclusiva del titolare. È vietata qualsiasi riproduzione, distribuzione o utilizzo non autorizzato.`,
                  },
                  {
                    label: 'Limitazione di responsabilità',
                    text: `${PLATFORM_NAME} non è responsabile per i contenuti pubblicati dagli utenti, per le transazioni dirette tra utenti (incluse quelle originate dalle aste), per l'accuratezza delle informazioni sulle attività commerciali, o per eventuali danni derivanti dall'uso della piattaforma da parte di terzi. Il servizio è fornito "così com'è". Il sistema di ticket per le aste è gestito direttamente dalla piattaforma; l'esito della transazione successiva alla conclusione dell'asta è responsabilità esclusiva delle parti.`,
                  },
                  {
                    label: 'Diritto di recesso',
                    text: `Ai sensi degli artt. 52-59 del D.Lgs. 206/2005 (Codice del Consumo), hai diritto di recedere dall'abbonamento entro 14 giorni dalla sottoscrizione senza motivazione. Per esercitare il diritto di recesso scrivi a recesso@lhimo.it indicando nome, email, data di sottoscrizione e numero abbonamento. Il rimborso avviene entro 14 giorni sulla stessa modalità di pagamento.`,
                  },
                ],
              },
            ].map(({ id, title, items }) => (
              <div key={id} id={id} className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
                <div className="px-5 py-4 border-b border-gray-100 bg-gray-50/50">
                  <h3 className="font-bold text-gray-900">{title}</h3>
                </div>
                <div className="px-5 py-4 space-y-4">
                  {items.map(({ label, text }) => (
                    <div key={label} className="flex gap-3">
                      <div className="w-1.5 h-1.5 rounded-full bg-teal-400 flex-shrink-0 mt-2"></div>
                      <div className="text-sm">
                        <span className="font-semibold text-gray-800">{label}: </span>
                        <span className="text-gray-600 leading-relaxed">{text}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}

            <div className="bg-gray-100 rounded-2xl p-5 text-center">
              <p className="text-gray-500 text-xs leading-relaxed">
                Ultimo aggiornamento: {LAST_UPDATED}. Per domande su privacy, termini o cookie contatta{' '}
                <strong className="text-gray-700">{CONTACT_EMAIL}</strong>
              </p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
