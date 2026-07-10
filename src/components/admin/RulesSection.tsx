import { useState, useEffect } from 'react';
import { Shield, HelpCircle, Cookie, FileText, ChevronDown, ChevronUp, Pencil, Save, X, Plus, Trash2 } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface FAQ {
  id: string;
  category: string;
  question: string;
  answer: string;
  display_order: number;
  is_active: boolean;
}

interface RulesContent {
  id: string;
  section_key: string;
  section_title: string;
  content_text: string;
  display_order: number;
  is_active: boolean;
}

interface RulesSectionProps {
  adminId: string;
}

const LAST_UPDATED = 'maggio 2026';
const PLATFORM_NAME = 'Lhimo';
const CONTACT_EMAIL = 'privacy@lhimo.it';
const COMPANY_NAME = '[Ragione Sociale]';
const COMPANY_ADDRESS = '[Indirizzo, CAP, Città]';
const VAT_NUMBER = '[P.IVA]';

const FAQ_CATEGORIES = [
  'Iscrizione e Account',
  'Punti e Classifica',
  'Recensioni',
  'Annunci',
  'Lavoro',
  'Solidarietà',
  'Aziende',
  'Abbonamenti',
  'Aste',
  'Privacy e Sicurezza',
  'Generale',
];

function AccordionFAQ({
  faq,
  onEdit,
  onDelete,
}: {
  faq: FAQ;
  onEdit: (faq: FAQ) => void;
  onDelete: (id: string) => void;
}) {
  const [open, setOpen] = useState(false);
  return (
    <div className="border border-gray-200 rounded-xl overflow-hidden group relative">
      <button
        onClick={() => setOpen(o => !o)}
        className="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-gray-50 transition-colors"
      >
        <span className="font-semibold text-gray-900 text-sm pr-4">{faq.question}</span>
        {open ? <ChevronUp className="w-4 h-4 text-gray-400 flex-shrink-0" /> : <ChevronDown className="w-4 h-4 text-gray-400 flex-shrink-0" />}
      </button>
      {open && (
        <div className="px-5 pb-5 border-t border-gray-100">
          <p className="text-gray-600 text-sm leading-relaxed pt-4">{faq.answer}</p>
        </div>
      )}
      {/* Admin edit overlay */}
      <div className="absolute top-2 right-10 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
        <button
          onClick={(e) => { e.stopPropagation(); onEdit(faq); }}
          className="flex items-center gap-1 bg-blue-600 text-white text-xs px-2 py-1 rounded-lg hover:bg-blue-700 transition-colors shadow-sm"
        >
          <Pencil className="w-3 h-3" />
          Modifica
        </button>
        <button
          onClick={(e) => { e.stopPropagation(); onDelete(faq.id); }}
          className="flex items-center gap-1 bg-red-500 text-white text-xs px-2 py-1 rounded-lg hover:bg-red-600 transition-colors shadow-sm"
        >
          <Trash2 className="w-3 h-3" />
        </button>
      </div>
      {!faq.is_active && (
        <div className="absolute top-2 left-2">
          <span className="bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Disattivata</span>
        </div>
      )}
    </div>
  );
}

function RulesSectionCard({
  section,
  index,
  onEdit,
  onDelete,
}: {
  section: RulesContent;
  index: number;
  onEdit: (rule: RulesContent) => void;
  onDelete: (id: string) => void;
}) {
  return (
    <div className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden group relative">
      <div className="flex items-center gap-4 px-6 py-4 border-b border-gray-100 bg-gray-50/50">
        <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
          {index + 1}
        </div>
        <h3 className="font-bold text-gray-900 flex-1">{section.section_title}</h3>
        <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <button
            onClick={() => onEdit(section)}
            className="flex items-center gap-1 bg-blue-600 text-white text-xs px-2.5 py-1.5 rounded-lg hover:bg-blue-700 transition-colors shadow-sm"
          >
            <Pencil className="w-3 h-3" />
            Modifica
          </button>
          <button
            onClick={() => onDelete(section.id)}
            className="flex items-center gap-1 bg-red-500 text-white text-xs px-2 py-1.5 rounded-lg hover:bg-red-600 transition-colors shadow-sm"
          >
            <Trash2 className="w-3 h-3" />
          </button>
        </div>
      </div>
      <div className="px-6 py-5">
        <p className="text-gray-600 text-sm leading-relaxed whitespace-pre-line">{section.content_text}</p>
      </div>
      {!section.is_active && (
        <div className="absolute top-3 right-3">
          <span className="bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Disattivata</span>
        </div>
      )}
    </div>
  );
}

export function RulesSection({ adminId }: RulesSectionProps) {
  const { showToast } = useToast();
  const [activeTab, setActiveTab] = useState<'regolamento' | 'faq' | 'cookie' | 'termini'>('regolamento');
  const [faqs, setFaqs] = useState<FAQ[]>([]);
  const [rulesContent, setRulesContent] = useState<RulesContent[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCategory, setSelectedCategory] = useState<string>('Tutte');

  // Edit state
  const [editingFAQ, setEditingFAQ] = useState<FAQ | null>(null);
  const [isNewFAQ, setIsNewFAQ] = useState(false);
  const [editingRule, setEditingRule] = useState<RulesContent | null>(null);
  const [isNewRule, setIsNewRule] = useState(false);
  const [saving, setSaving] = useState(false);

  useEffect(() => { loadData(); }, []);

  const loadData = async () => {
    setLoading(true);
    try {
      const [rulesResult, faqsResult] = await Promise.all([
        supabase.from('rules_content').select('*').order('display_order'),
        supabase.from('faqs').select('*').order('category').order('display_order'),
      ]);
      setRulesContent(rulesResult.data || []);
      setFaqs(faqsResult.data || []);
    } catch (err) {
      console.error('Error loading rules data:', err);
    } finally {
      setLoading(false);
    }
  };

  const saveFAQ = async () => {
    if (!editingFAQ) return;
    setSaving(true);
    try {
      if (isNewFAQ) {
        const { error } = await supabase.from('faqs').insert({
          category: editingFAQ.category,
          question: editingFAQ.question,
          answer: editingFAQ.answer,
          display_order: editingFAQ.display_order,
          is_active: editingFAQ.is_active,
          updated_by: adminId,
        });
        if (error) throw error;
      } else {
        const { error } = await supabase.from('faqs').update({
          category: editingFAQ.category,
          question: editingFAQ.question,
          answer: editingFAQ.answer,
          display_order: editingFAQ.display_order,
          is_active: editingFAQ.is_active,
          updated_by: adminId,
          updated_at: new Date().toISOString(),
        }).eq('id', editingFAQ.id);
        if (error) throw error;
      }
      setEditingFAQ(null);
      setIsNewFAQ(false);
      loadData();
    } catch (err: any) {
      showToast(`Errore: ${err.message}`, 'error');
    } finally {
      setSaving(false);
    }
  };

  const deleteFAQ = async (id: string) => {
    if (!confirm('Eliminare questa FAQ?')) return;
    const { error } = await supabase.from('faqs').delete().eq('id', id);
    if (error) { showToast(`Errore: ${error.message}`, 'error'); return; }
    loadData();
  };

  const saveRule = async () => {
    if (!editingRule) return;
    setSaving(true);
    try {
      if (isNewRule) {
        const { error } = await supabase.from('rules_content').insert({
          section_key: editingRule.section_key,
          section_title: editingRule.section_title,
          content_text: editingRule.content_text,
          display_order: editingRule.display_order,
          is_active: editingRule.is_active,
          updated_by: adminId,
        });
        if (error) throw error;
      } else {
        const { error } = await supabase.from('rules_content').update({
          section_key: editingRule.section_key,
          section_title: editingRule.section_title,
          content_text: editingRule.content_text,
          display_order: editingRule.display_order,
          is_active: editingRule.is_active,
          updated_by: adminId,
          updated_at: new Date().toISOString(),
        }).eq('id', editingRule.id);
        if (error) throw error;
      }
      setEditingRule(null);
      setIsNewRule(false);
      loadData();
    } catch (err: any) {
      showToast(`Errore: ${err.message}`, 'error');
    } finally {
      setSaving(false);
    }
  };

  const deleteRule = async (id: string) => {
    if (!confirm('Eliminare questa sezione del regolamento?')) return;
    const { error } = await supabase.from('rules_content').delete().eq('id', id);
    if (error) { showToast(`Errore: ${error.message}`, 'error'); return; }
    loadData();
  };

  const categories = ['Tutte', ...Array.from(new Set(faqs.map(f => f.category)))];
  const filteredFAQs = selectedCategory === 'Tutte' ? faqs : faqs.filter(f => f.category === selectedCategory);
  const groupedFAQs = filteredFAQs.reduce((acc, faq) => {
    if (!acc[faq.category]) acc[faq.category] = [];
    acc[faq.category].push(faq);
    return acc;
  }, {} as Record<string, FAQ[]>);

  const tabs = [
    { key: 'regolamento' as const, label: 'Regolamento', icon: Shield },
    { key: 'faq' as const, label: 'FAQ', icon: HelpCircle },
    { key: 'cookie' as const, label: 'Cookie Policy', icon: Cookie },
    { key: 'termini' as const, label: 'Termini & Privacy', icon: FileText },
  ];

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Admin banner */}
      <div className="bg-amber-50 border border-amber-200 rounded-xl px-4 py-3 flex items-center gap-3">
        <Pencil className="w-4 h-4 text-amber-600 flex-shrink-0" />
        <p className="text-amber-800 text-sm font-medium">
          Modalità admin — passa il mouse su una sezione per vedere il pulsante Modifica
        </p>
      </div>

      {/* Tab bar — same as user-facing */}
      <div className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
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
        <div className="space-y-4">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 bg-blue-100 rounded-xl flex items-center justify-center">
                <Shield className="w-5 h-5 text-blue-600" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900">Regolamento della Piattaforma</h2>
                <p className="text-sm text-gray-500">Aggiornato il {LAST_UPDATED}</p>
              </div>
            </div>
            <button
              onClick={() => {
                setEditingRule({ id: '', section_key: '', section_title: '', content_text: '', display_order: rulesContent.length + 1, is_active: true });
                setIsNewRule(true);
              }}
              className="flex items-center gap-2 bg-blue-600 text-white text-sm font-semibold px-4 py-2 rounded-xl hover:bg-blue-700 transition-colors"
            >
              <Plus className="w-4 h-4" />
              Aggiungi sezione
            </button>
          </div>

          {rulesContent.length === 0 ? (
            <div className="bg-white rounded-2xl border border-gray-200 p-10 text-center">
              <Shield className="w-12 h-12 text-gray-200 mx-auto mb-3" />
              <p className="text-gray-500 text-sm">Nessun contenuto disponibile.</p>
            </div>
          ) : (
            rulesContent.map((section, index) => (
              <RulesSectionCard
                key={section.id}
                section={section}
                index={index}
                onEdit={(r) => { setEditingRule(r); setIsNewRule(false); }}
                onDelete={deleteRule}
              />
            ))
          )}
        </div>
      )}

      {/* FAQ */}
      {activeTab === 'faq' && (
        <div className="space-y-6">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 bg-green-100 rounded-xl flex items-center justify-center">
                <HelpCircle className="w-5 h-5 text-green-600" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900">Domande Frequenti</h2>
                <p className="text-sm text-gray-500">Trova risposta alle domande più comuni</p>
              </div>
            </div>
            <button
              onClick={() => {
                setEditingFAQ({ id: '', category: 'Generale', question: '', answer: '', display_order: faqs.length + 1, is_active: true });
                setIsNewFAQ(true);
              }}
              className="flex items-center gap-2 bg-blue-600 text-white text-sm font-semibold px-4 py-2 rounded-xl hover:bg-blue-700 transition-colors"
            >
              <Plus className="w-4 h-4" />
              Aggiungi FAQ
            </button>
          </div>

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
              <p className="text-gray-500 text-sm">Nessuna FAQ{selectedCategory !== 'Tutte' ? ' in questa categoria' : ''}.</p>
            </div>
          ) : (
            Object.entries(groupedFAQs).map(([category, categoryFaqs]) => (
              <div key={category}>
                {selectedCategory === 'Tutte' && (
                  <h3 className="text-sm font-bold text-gray-500 uppercase tracking-wide mb-3 pl-1">{category}</h3>
                )}
                <div className="space-y-2">
                  {categoryFaqs.map(faq => (
                    <AccordionFAQ
                      key={faq.id}
                      faq={faq}
                      onEdit={(f) => { setEditingFAQ(f); setIsNewFAQ(false); }}
                      onDelete={deleteFAQ}
                    />
                  ))}
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {/* Cookie Policy — read-only, same as user */}
      {activeTab === 'cookie' && (
        <div className="space-y-4">
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
                { label: 'Autenticazione (Supabase)', desc: "Gestiti da Supabase, mantengono la tua sessione attiva dopo il login. Strettamente necessari al funzionamento del sito, non richiedono consenso. I server Supabase sono localizzati nell'Unione Europea." },
                { label: 'Preferenze locali', desc: 'Memorizzano impostazioni locali come la lingua selezionata o il profilo attivo. Non contengono dati personali identificativi e sono salvati solo nel tuo browser (localStorage).' },
              ]
            },
            {
              title: 'Cookie di terze parti',
              items: [
                { label: 'Stripe (pagamenti)', desc: 'Durante il checkout per acquistare un piano, Stripe Inc. può impostare cookie propri necessari per la sicurezza della transazione. Stripe è certificato PCI-DSS Level 1.' },
                { label: 'Brevo (email transazionali)', desc: 'Utilizziamo Brevo per invio email automatiche di servizio. Brevo non imposta cookie sul tuo browser ma riceve il tuo indirizzo email per la consegna.' },
              ]
            },
            {
              title: 'Cosa NON facciamo',
              items: [
                { label: 'Nessun tracciamento pubblicitario', desc: 'Non utilizziamo Google Ads, Meta Pixel, TikTok Pixel o sistemi analoghi.' },
                { label: 'Nessuna vendita di dati', desc: 'I tuoi dati non vengono mai venduti o condivisi con terze parti per scopi commerciali.' },
                { label: 'Nessuna analytics invasiva', desc: 'Non utilizziamo Google Analytics, Hotjar o sistemi di analisi comportamentale.' },
              ]
            },
            {
              title: 'Come gestire i cookie',
              items: [
                { label: 'Impostazioni del browser', desc: 'Puoi configurare il browser per bloccare o eliminare i cookie.' },
                { label: 'Cancellazione', desc: 'Puoi eliminare i cookie salvati dal browser in qualsiasi momento dalle impostazioni.' },
                { label: 'Revoca consenso', desc: `Scrivi a ${CONTACT_EMAIL} per revocare il consenso.` },
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
        </div>
      )}

      {/* Termini & Privacy — read-only, same as user */}
      {activeTab === 'termini' && (
        <div className="space-y-4">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-9 h-9 bg-teal-100 rounded-xl flex items-center justify-center">
              <FileText className="w-5 h-5 text-teal-600" />
            </div>
            <div>
              <h2 className="text-xl font-bold text-gray-900">Termini di Servizio e Privacy</h2>
              <p className="text-sm text-gray-500">Aggiornati il {LAST_UPDATED} · {COMPANY_NAME}</p>
            </div>
          </div>

          <div className="bg-blue-50 border border-blue-200 rounded-2xl px-5 py-4">
            <p className="text-blue-900 text-xs font-semibold mb-1">Titolare del Trattamento</p>
            <p className="text-blue-800 text-sm">
              <strong>{COMPANY_NAME}</strong> — {COMPANY_ADDRESS}<br />
              P.IVA: {VAT_NUMBER} — Email: <strong>{CONTACT_EMAIL}</strong>
            </p>
          </div>

          {[
            {
              title: 'Termini di Servizio',
              items: [
                { label: 'Accettazione dei termini', text: `Utilizzando ${PLATFORM_NAME} accetti integralmente i presenti Termini di Servizio.` },
                { label: 'Descrizione del servizio', text: `${PLATFORM_NAME} è una piattaforma italiana che consente agli utenti di cercare, recensire e scoprire attività commerciali locali.` },
                { label: 'Registrazione e account', text: 'Sei responsabile della sicurezza del tuo account e di tutte le attività svolte con esso.' },
                { label: "Contenuti pubblicati dall'utente", text: 'Sei l\'unico responsabile dei contenuti che pubblichi.' },
                { label: 'Sospensione e chiusura account', text: 'Ci riserviamo il diritto di sospendere account che violino i Termini o la normativa.' },
                { label: 'Legge applicabile', text: 'I presenti Termini sono regolati dalla legge italiana.' },
              ],
            },
            {
              title: 'Privacy Policy',
              items: [
                { label: 'Base giuridica del trattamento', text: 'Il trattamento avviene sulla base del consenso (art. 6 lett. a GDPR) e dell\'esecuzione del contratto (art. 6 lett. b GDPR).' },
                { label: 'Dati raccolti', text: 'Raccogliamo: dati di registrazione, contenuti pubblicati, dati tecnici necessari al servizio.' },
                { label: 'Finalità del trattamento', text: 'I dati vengono utilizzati esclusivamente per erogare e migliorare il servizio.' },
                { label: 'I tuoi diritti (GDPR)', text: `Hai diritto di accesso, rettifica, cancellazione e portabilità. Scrivi a ${CONTACT_EMAIL}.` },
              ],
            },
            {
              title: "Condizioni d'uso",
              items: [
                { label: 'Uso lecito', text: 'La piattaforma deve essere usata in conformità con la legislazione italiana ed europea.' },
                { label: 'Recensioni', text: 'Le recensioni devono essere veritiere e basate su esperienze dirette.' },
                { label: 'Annunci e aste', text: 'Gli annunci devono riguardare prodotti o servizi reali e legali.' },
                { label: 'Rispetto della community', text: 'Sono vietati insulti, discriminazioni, molestie e spam.' },
              ],
            },
          ].map(({ title, items }) => (
            <div key={title} className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
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
        </div>
      )}

      {/* Edit FAQ modal */}
      {editingFAQ && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-center justify-between rounded-t-2xl">
              <h3 className="text-lg font-bold text-gray-900">
                {isNewFAQ ? 'Aggiungi FAQ' : 'Modifica FAQ'}
              </h3>
              <button onClick={() => { setEditingFAQ(null); setIsNewFAQ(false); }} className="text-gray-400 hover:text-gray-600">
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Categoria</label>
                <select
                  value={editingFAQ.category}
                  onChange={(e) => setEditingFAQ({ ...editingFAQ, category: e.target.value })}
                  className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  {FAQ_CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Domanda</label>
                <input
                  type="text"
                  value={editingFAQ.question}
                  onChange={(e) => setEditingFAQ({ ...editingFAQ, question: e.target.value })}
                  className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Risposta</label>
                <textarea
                  value={editingFAQ.answer}
                  onChange={(e) => setEditingFAQ({ ...editingFAQ, answer: e.target.value })}
                  rows={6}
                  className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                />
              </div>
              <div className="flex items-center gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700 mb-1">Ordine</label>
                  <input
                    type="number"
                    value={editingFAQ.display_order}
                    onChange={(e) => setEditingFAQ({ ...editingFAQ, display_order: parseInt(e.target.value) || 0 })}
                    className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Stato</label>
                  <button
                    onClick={() => setEditingFAQ({ ...editingFAQ, is_active: !editingFAQ.is_active })}
                    className={`px-4 py-2 rounded-full text-sm font-semibold transition-colors ${
                      editingFAQ.is_active ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                    }`}
                  >
                    {editingFAQ.is_active ? 'Attiva' : 'Disattivata'}
                  </button>
                </div>
              </div>
              <div className="flex gap-3 pt-2">
                <button
                  onClick={() => { setEditingFAQ(null); setIsNewFAQ(false); }}
                  className="flex-1 border border-gray-300 text-gray-700 py-2.5 rounded-xl hover:bg-gray-50 font-semibold text-sm"
                >
                  Annulla
                </button>
                <button
                  onClick={saveFAQ}
                  disabled={saving || !editingFAQ.question || !editingFAQ.answer}
                  className="flex-1 bg-blue-600 text-white py-2.5 rounded-xl hover:bg-blue-700 disabled:opacity-50 font-semibold text-sm flex items-center justify-center gap-2"
                >
                  <Save className="w-4 h-4" />
                  {saving ? 'Salvo...' : isNewFAQ ? 'Aggiungi' : 'Salva'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Edit Rule modal */}
      {editingRule && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-center justify-between rounded-t-2xl">
              <h3 className="text-lg font-bold text-gray-900">
                {isNewRule ? 'Aggiungi Sezione Regolamento' : 'Modifica Sezione'}
              </h3>
              <button onClick={() => { setEditingRule(null); setIsNewRule(false); }} className="text-gray-400 hover:text-gray-600">
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Chiave Sezione</label>
                <input
                  type="text"
                  value={editingRule.section_key}
                  onChange={(e) => setEditingRule({ ...editingRule, section_key: e.target.value })}
                  placeholder="es: intro, reviews_rules, auctions"
                  className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
                <p className="text-xs text-gray-400 mt-1">Tutto minuscolo, underscore al posto degli spazi</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Titolo Sezione</label>
                <input
                  type="text"
                  value={editingRule.section_title}
                  onChange={(e) => setEditingRule({ ...editingRule, section_title: e.target.value })}
                  placeholder="es: Regole sulle Recensioni"
                  className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Contenuto</label>
                <textarea
                  value={editingRule.content_text}
                  onChange={(e) => setEditingRule({ ...editingRule, content_text: e.target.value })}
                  rows={18}
                  className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm font-mono focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                />
                <p className="text-xs text-gray-400 mt-1">Usa righe vuote per separare paragrafi. Supporta simboli (✓, ❌, •).</p>
              </div>
              <div className="flex items-center gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700 mb-1">Ordine</label>
                  <input
                    type="number"
                    value={editingRule.display_order}
                    onChange={(e) => setEditingRule({ ...editingRule, display_order: parseInt(e.target.value) || 0 })}
                    className="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Stato</label>
                  <button
                    onClick={() => setEditingRule({ ...editingRule, is_active: !editingRule.is_active })}
                    className={`px-4 py-2 rounded-full text-sm font-semibold transition-colors ${
                      editingRule.is_active ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                    }`}
                  >
                    {editingRule.is_active ? 'Attiva' : 'Disattivata'}
                  </button>
                </div>
              </div>
              <div className="flex gap-3 pt-2">
                <button
                  onClick={() => { setEditingRule(null); setIsNewRule(false); }}
                  className="flex-1 border border-gray-300 text-gray-700 py-2.5 rounded-xl hover:bg-gray-50 font-semibold text-sm"
                >
                  Annulla
                </button>
                <button
                  onClick={saveRule}
                  disabled={saving || !editingRule.section_key || !editingRule.section_title || !editingRule.content_text}
                  className="flex-1 bg-blue-600 text-white py-2.5 rounded-xl hover:bg-blue-700 disabled:opacity-50 font-semibold text-sm flex items-center justify-center gap-2"
                >
                  <Save className="w-4 h-4" />
                  {saving ? 'Salvo...' : isNewRule ? 'Aggiungi' : 'Salva'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
