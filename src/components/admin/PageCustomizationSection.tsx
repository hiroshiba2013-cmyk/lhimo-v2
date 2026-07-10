import { useState, useEffect, useRef } from 'react';
import { FileEdit as Edit2, Check, X, Image, Volume2, VolumeX, RefreshCw, Eye, Monitor, Smartphone, ChevronRight, AlertCircle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';
import type { PageCustomization } from '../../hooks/usePageCustomization';

const PAGES = [
  {
    key: 'landing',
    label: 'Home pubblica',
    icon: '🏠',
    description: 'Visitatori non autenticati',
    defaultTitle: 'Benvenuto su Lhimo',
    defaultSubtitle: 'La piattaforma che connette persone e attività locali in tutta Italia',
    hasHero: true,
    hasAnnouncement: true,
  },
  {
    key: 'home_authenticated',
    label: 'Home (con login)',
    icon: '👤',
    description: 'Utenti autenticati',
    defaultTitle: 'Ciao, [nome]!',
    defaultSubtitle: 'Esplora attività locali, trova candidati, vendi e compra oggetti',
    hasHero: true,
    hasAnnouncement: true,
  },
  {
    key: 'dashboard_private',
    label: 'Dashboard Privati',
    icon: '📋',
    description: 'Utenti privati',
    defaultTitle: 'La tua Dashboard',
    defaultSubtitle: 'Gestisci il tuo profilo, recensioni e attività',
    hasHero: true,
    hasAnnouncement: true,
  },
  {
    key: 'dashboard_business',
    label: 'Dashboard Business',
    icon: '🏢',
    description: 'Utenti business',
    defaultTitle: 'Dashboard Business',
    defaultSubtitle: 'Gestisci la tua attività, annunci e candidati',
    hasHero: true,
    hasAnnouncement: true,
  },
  {
    key: 'jobs',
    label: 'Sezione Lavoro',
    icon: '💼',
    description: 'Pagina annunci lavoro',
    defaultTitle: 'Annunci di Lavoro',
    defaultSubtitle: 'Trova opportunità di lavoro o pubblica la tua candidatura',
    hasHero: true,
    hasAnnouncement: true,
  },
  {
    key: 'search',
    label: 'Ricerca',
    icon: '🔍',
    description: 'Pagina ricerca attività',
    defaultTitle: 'Cerca Attività',
    defaultSubtitle: 'Trova le migliori attività locali nella tua zona',
    hasHero: true,
    hasAnnouncement: true,
  },
];

type EditingField = 'announcement' | 'hero_title' | 'hero_subtitle' | 'hero_image' | null;

interface InlineEditProps {
  field: EditingField;
  customization: PageCustomization | null;
  page: typeof PAGES[0];
  onSave: (updates: Partial<PageCustomization>) => Promise<void>;
  onClose: () => void;
}

function InlineEditPanel({ field, customization, page, onSave, onClose }: InlineEditProps) {
  const [value, setValue] = useState('');
  const [active, setActive] = useState(false);
  const [saving, setSaving] = useState(false);
  const inputRef = useRef<HTMLInputElement | HTMLTextAreaElement>(null);

  useEffect(() => {
    if (field === 'announcement') {
      setValue(customization?.announcement_text ?? '');
      setActive(customization?.announcement_active ?? false);
    } else if (field === 'hero_title') {
      setValue(customization?.hero_title ?? '');
    } else if (field === 'hero_subtitle') {
      setValue(customization?.hero_subtitle ?? '');
    } else if (field === 'hero_image') {
      setValue(customization?.hero_image_url ?? '');
    }
    setTimeout(() => inputRef.current?.focus(), 50);
  }, [field, customization]);

  const handleSave = async () => {
    setSaving(true);
    try {
      let updates: Partial<PageCustomization> = {};
      if (field === 'announcement') {
        updates = { announcement_text: value || null, announcement_active: active };
      } else if (field === 'hero_title') {
        updates = { hero_title: value || null };
      } else if (field === 'hero_subtitle') {
        updates = { hero_subtitle: value || null };
      } else if (field === 'hero_image') {
        updates = { hero_image_url: value || null };
      }
      await onSave(updates);
      onClose();
    } finally {
      setSaving(false);
    }
  };

  const handleClear = async () => {
    setSaving(true);
    try {
      let updates: Partial<PageCustomization> = {};
      if (field === 'announcement') updates = { announcement_text: null, announcement_active: false };
      else if (field === 'hero_title') updates = { hero_title: null };
      else if (field === 'hero_subtitle') updates = { hero_subtitle: null };
      else if (field === 'hero_image') updates = { hero_image_url: null };
      await onSave(updates);
      onClose();
    } finally {
      setSaving(false);
    }
  };

  const titles: Record<NonNullable<EditingField>, string> = {
    announcement: 'Banner annuncio',
    hero_title: 'Titolo hero',
    hero_subtitle: 'Sottotitolo hero',
    hero_image: 'Immagine di sfondo',
  };

  const placeholders: Record<NonNullable<EditingField>, string> = {
    announcement: 'Es: Novità! Scopri le nuove funzionalità disponibili...',
    hero_title: `Default: "${page.defaultTitle}"`,
    hero_subtitle: `Default: "${page.defaultSubtitle}"`,
    hero_image: 'https://images.pexels.com/...',
  };

  if (!field) return null;

  return (
    <div className="bg-white border-t-2 border-blue-500 rounded-b-2xl p-5 shadow-lg">
      <div className="flex items-center justify-between mb-4">
        <h4 className="font-semibold text-gray-900 flex items-center gap-2">
          <Edit2 className="w-4 h-4 text-blue-500" />
          Modifica: {titles[field]}
        </h4>
        <button onClick={onClose} className="p-1 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100 transition-colors">
          <X className="w-4 h-4" />
        </button>
      </div>

      {field === 'announcement' ? (
        <div className="space-y-3">
          <textarea
            ref={inputRef as React.RefObject<HTMLTextAreaElement>}
            value={value}
            onChange={e => setValue(e.target.value)}
            placeholder={placeholders[field]}
            rows={2}
            className="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none transition-colors"
          />
          <label className="flex items-center gap-3 cursor-pointer select-none">
            <button
              type="button"
              onClick={() => setActive(!active)}
              className={`relative w-11 h-6 rounded-full transition-colors flex-shrink-0 ${active ? 'bg-blue-600' : 'bg-gray-300'}`}
            >
              <span className={`absolute top-0.5 left-0.5 w-5 h-5 rounded-full bg-white shadow transition-transform ${active ? 'translate-x-5' : 'translate-x-0'}`} />
            </button>
            <span className="text-sm font-medium text-gray-700 flex items-center gap-1.5">
              {active ? <><Volume2 className="w-4 h-4 text-amber-500" /> Banner attivo</> : <><VolumeX className="w-4 h-4 text-gray-400" /> Banner disattivato</>}
            </span>
          </label>
        </div>
      ) : field === 'hero_image' ? (
        <div className="space-y-3">
          <input
            ref={inputRef as React.RefObject<HTMLInputElement>}
            type="url"
            value={value}
            onChange={e => setValue(e.target.value)}
            placeholder={placeholders[field]}
            className="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          />
          {value && (
            <div className="relative rounded-xl overflow-hidden h-24 bg-gray-100">
              <img
                src={value}
                alt="Preview"
                className="w-full h-full object-cover"
                onError={e => { (e.target as HTMLImageElement).style.opacity = '0'; }}
              />
              <div className="absolute inset-0 flex items-center justify-center text-gray-400 text-xs">
                Preview immagine
              </div>
            </div>
          )}
          <p className="text-xs text-gray-400">L'immagine sarà usata come sfondo con overlay bianco semitrasparente</p>
        </div>
      ) : (
        <input
          ref={inputRef as React.RefObject<HTMLInputElement>}
          type="text"
          value={value}
          onChange={e => setValue(e.target.value)}
          placeholder={placeholders[field]}
          className="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
          onKeyDown={e => e.key === 'Enter' && handleSave()}
        />
      )}

      <div className="flex items-center justify-between mt-4">
        {(customization?.[field === 'announcement' ? 'announcement_text' :
          field === 'hero_title' ? 'hero_title' :
          field === 'hero_subtitle' ? 'hero_subtitle' : 'hero_image_url']) ? (
          <button
            onClick={handleClear}
            disabled={saving}
            className="text-xs text-red-500 hover:text-red-700 font-medium transition-colors"
          >
            Ripristina default
          </button>
        ) : <div />}
        <div className="flex items-center gap-2">
          <button onClick={onClose} className="px-4 py-2 text-sm text-gray-600 hover:text-gray-800 border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors">
            Annulla
          </button>
          <button
            onClick={handleSave}
            disabled={saving}
            className="flex items-center gap-2 px-5 py-2 bg-blue-600 text-white text-sm font-semibold rounded-xl hover:bg-blue-700 transition-colors disabled:opacity-60"
          >
            {saving ? <RefreshCw className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
            Salva
          </button>
        </div>
      </div>
    </div>
  );
}

function EditOverlay({ label, onClick }: { label: string; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="group absolute inset-0 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity bg-blue-600/10 border-2 border-dashed border-blue-400 rounded-xl"
    >
      <span className="flex items-center gap-1.5 bg-blue-600 text-white text-xs font-bold px-3 py-1.5 rounded-full shadow-lg">
        <Edit2 className="w-3.5 h-3.5" />
        {label}
      </span>
    </button>
  );
}

interface PagePreviewProps {
  page: typeof PAGES[0];
  customization: PageCustomization | null;
  onSave: (updates: Partial<PageCustomization>) => Promise<void>;
}

function PagePreview({ page, customization, onSave }: PagePreviewProps) {
  const [editingField, setEditingField] = useState<EditingField>(null);

  const heroTitle = customization?.hero_title || page.defaultTitle;
  const heroSubtitle = customization?.hero_subtitle || page.defaultSubtitle;
  const heroBg = customization?.hero_image_url;
  const announcementActive = customization?.announcement_active;
  const announcementText = customization?.announcement_text;

  const isCustomTitle = !!customization?.hero_title;
  const isCustomSubtitle = !!customization?.hero_subtitle;
  const isCustomImage = !!customization?.hero_image_url;

  return (
    <div className="space-y-3">
      {/* Announcement preview */}
      <div className="relative group">
        <div className={`rounded-xl overflow-hidden ${editingField === 'announcement' ? 'ring-2 ring-blue-500' : ''}`}>
          {announcementActive && announcementText ? (
            <div className="bg-blue-600 text-white py-2.5 px-4 text-center text-sm font-medium flex items-center justify-center gap-2 rounded-t-xl">
              <Volume2 className="w-4 h-4 flex-shrink-0" />
              {announcementText}
            </div>
          ) : (
            <div className="bg-gray-100 border-2 border-dashed border-gray-300 py-2.5 px-4 text-center rounded-xl">
              <span className="text-gray-400 text-sm flex items-center justify-center gap-2">
                <VolumeX className="w-4 h-4" />
                Banner annuncio non attivo
              </span>
            </div>
          )}
        </div>
        {editingField !== 'announcement' && (
          <button
            onClick={() => setEditingField('announcement')}
            className="absolute right-2 top-1/2 -translate-y-1/2 flex items-center gap-1.5 bg-white text-blue-600 border border-blue-200 text-xs font-semibold px-3 py-1.5 rounded-full shadow-sm hover:bg-blue-50 hover:border-blue-400 transition-colors opacity-0 group-hover:opacity-100"
          >
            <Edit2 className="w-3 h-3" />
            Modifica banner
          </button>
        )}
      </div>

      {editingField === 'announcement' && (
        <InlineEditPanel field="announcement" customization={customization} page={page} onSave={onSave} onClose={() => setEditingField(null)} />
      )}

      {/* Hero section preview */}
      <div
        className={`relative rounded-2xl overflow-hidden border-2 transition-colors ${editingField && editingField !== 'announcement' ? 'border-blue-500' : 'border-gray-100'}`}
        style={heroBg ? {
          backgroundImage: `linear-gradient(rgba(255,255,255,0.9), rgba(255,255,255,0.9)), url(${heroBg})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        } : { backgroundColor: '#ffffff' }}
      >
        <div className="px-6 py-8">
          {/* Title row */}
          <div className="relative group/title mb-3">
            <h1 className={`text-2xl font-extrabold text-gray-900 text-center ${isCustomTitle ? 'text-blue-900' : ''}`}>
              {heroTitle}
              {isCustomTitle && <span className="ml-2 text-xs font-normal text-blue-500 align-middle">(personalizzato)</span>}
            </h1>
            {editingField !== 'hero_title' && (
              <button
                onClick={() => setEditingField('hero_title')}
                className="absolute right-0 top-1/2 -translate-y-1/2 flex items-center gap-1.5 bg-white text-blue-600 border border-blue-200 text-xs font-semibold px-3 py-1.5 rounded-full shadow-sm hover:bg-blue-50 hover:border-blue-400 transition-colors opacity-0 group-hover/title:opacity-100"
              >
                <Edit2 className="w-3 h-3" />
                Modifica titolo
              </button>
            )}
          </div>

          {/* Subtitle row */}
          <div className="relative group/sub mb-5">
            <p className={`text-sm text-center ${isCustomSubtitle ? 'text-blue-700' : 'text-gray-500'}`}>
              {heroSubtitle}
              {isCustomSubtitle && <span className="ml-1 text-xs text-blue-400">(personalizzato)</span>}
            </p>
            {editingField !== 'hero_subtitle' && (
              <button
                onClick={() => setEditingField('hero_subtitle')}
                className="absolute right-0 top-1/2 -translate-y-1/2 flex items-center gap-1.5 bg-white text-blue-600 border border-blue-200 text-xs font-semibold px-3 py-1.5 rounded-full shadow-sm hover:bg-blue-50 hover:border-blue-400 transition-colors opacity-0 group-hover/sub:opacity-100"
              >
                <Edit2 className="w-3 h-3" />
                Modifica sottotitolo
              </button>
            )}
          </div>

          {/* Background image row */}
          <div className="relative group/img flex items-center justify-center gap-3">
            <div className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-medium border ${isCustomImage ? 'bg-blue-50 border-blue-200 text-blue-700' : 'bg-gray-50 border-gray-200 text-gray-500'}`}>
              <Image className="w-3.5 h-3.5" />
              {isCustomImage ? 'Immagine di sfondo personalizzata' : 'Sfondo predefinito (bianco)'}
            </div>
            {editingField !== 'hero_image' && (
              <button
                onClick={() => setEditingField('hero_image')}
                className="flex items-center gap-1.5 bg-white text-blue-600 border border-blue-200 text-xs font-semibold px-3 py-1.5 rounded-full shadow-sm hover:bg-blue-50 hover:border-blue-400 transition-colors opacity-0 group-hover/img:opacity-100"
              >
                <Edit2 className="w-3 h-3" />
                {isCustomImage ? 'Cambia immagine' : 'Aggiungi immagine'}
              </button>
            )}
          </div>
        </div>

        {/* Simulated page content blocks */}
        <div className="px-6 pb-6 space-y-2 border-t border-gray-100 pt-4">
          <div className="h-3 bg-gray-100 rounded-full w-1/3" />
          <div className="grid grid-cols-3 gap-2">
            {[1, 2, 3].map(i => (
              <div key={i} className="h-16 bg-gray-50 border border-gray-100 rounded-xl" />
            ))}
          </div>
          <div className="h-3 bg-gray-100 rounded-full w-1/4 mt-2" />
          <div className="grid grid-cols-4 gap-2">
            {[1, 2, 3, 4].map(i => (
              <div key={i} className="h-12 bg-gray-50 border border-gray-100 rounded-lg" />
            ))}
          </div>
        </div>
      </div>

      {(editingField === 'hero_title' || editingField === 'hero_subtitle' || editingField === 'hero_image') && (
        <InlineEditPanel field={editingField} customization={customization} page={page} onSave={onSave} onClose={() => setEditingField(null)} />
      )}

      {/* Status summary */}
      <div className="flex flex-wrap gap-2 pt-1">
        {customization?.hero_title && (
          <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-100">
            <Check className="w-3 h-3" /> Titolo personalizzato
          </span>
        )}
        {customization?.hero_subtitle && (
          <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-100">
            <Check className="w-3 h-3" /> Sottotitolo personalizzato
          </span>
        )}
        {customization?.hero_image_url && (
          <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-100">
            <Check className="w-3 h-3" /> Immagine di sfondo
          </span>
        )}
        {customization?.announcement_active && (
          <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-amber-50 text-amber-700 text-xs font-medium rounded-full border border-amber-100">
            <Volume2 className="w-3 h-3" /> Banner attivo
          </span>
        )}
        {!customization?.hero_title && !customization?.hero_subtitle && !customization?.hero_image_url && !customization?.announcement_active && (
          <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-gray-50 text-gray-400 text-xs font-medium rounded-full border border-gray-100">
            <AlertCircle className="w-3 h-3" /> Nessuna personalizzazione attiva
          </span>
        )}
      </div>
    </div>
  );
}

export function PageCustomizationSection({ adminId }: { adminId: string }) {
  const { showToast } = useToast();
  const [customizations, setCustomizations] = useState<Record<string, PageCustomization>>({});
  const [loading, setLoading] = useState(true);
  const [selectedPage, setSelectedPage] = useState(PAGES[0].key);

  useEffect(() => {
    loadCustomizations();
  }, []);

  const loadCustomizations = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase.from('page_customizations').select('*');
      if (error) throw error;
      const map: Record<string, PageCustomization> = {};
      for (const item of data ?? []) map[item.page_key] = item as PageCustomization;
      setCustomizations(map);
    } catch (err) {
      console.error(err);
      showToast('Errore nel caricamento', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async (pageKey: string, updates: Partial<PageCustomization>) => {
    const existing = customizations[pageKey];
    const pageMeta = PAGES.find(p => p.key === pageKey);
    try {
      if (existing) {
        const { error } = await supabase
          .from('page_customizations')
          .update({ ...updates, updated_at: new Date().toISOString(), updated_by: adminId })
          .eq('page_key', pageKey);
        if (error) throw error;
        setCustomizations(prev => ({
          ...prev,
          [pageKey]: { ...prev[pageKey], ...updates, updated_at: new Date().toISOString() },
        }));
      } else {
        const { data, error } = await supabase
          .from('page_customizations')
          .insert({ page_key: pageKey, page_name: pageMeta?.label ?? pageKey, ...updates, updated_by: adminId })
          .select()
          .single();
        if (error) throw error;
        setCustomizations(prev => ({ ...prev, [pageKey]: data as PageCustomization }));
      }
      showToast('Salvato', 'success');
    } catch (err) {
      console.error(err);
      showToast('Errore nel salvataggio', 'error');
    }
  };

  const currentPage = PAGES.find(p => p.key === selectedPage)!;
  const currentCustomization = customizations[selectedPage] ?? null;

  const activeCount = Object.values(customizations).filter(c =>
    c.hero_title || c.hero_subtitle || c.hero_image_url || c.announcement_active
  ).length;

  return (
    <div className="flex gap-6 items-start">
      {/* Sidebar: page list */}
      <div className="w-56 flex-shrink-0 space-y-1.5">
        <div className="flex items-center gap-2 px-3 py-2 mb-3">
          <Monitor className="w-4 h-4 text-gray-400" />
          <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Pagine piattaforma</span>
        </div>
        {PAGES.map(page => {
          const c = customizations[page.key];
          const customCount = [c?.hero_title, c?.hero_subtitle, c?.hero_image_url, c?.announcement_active ? c.announcement_text : null].filter(Boolean).length;
          return (
            <button
              key={page.key}
              onClick={() => setSelectedPage(page.key)}
              className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-left transition-all ${
                selectedPage === page.key
                  ? 'bg-blue-600 text-white shadow-md'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <span className="text-base leading-none">{page.icon}</span>
              <div className="flex-1 min-w-0">
                <div className="text-sm font-semibold truncate">{page.label}</div>
                <div className={`text-xs truncate ${selectedPage === page.key ? 'text-blue-200' : 'text-gray-400'}`}>
                  {page.description}
                </div>
              </div>
              <div className="flex flex-col items-end gap-1">
                {customCount > 0 && (
                  <span className={`text-xs font-bold px-1.5 py-0.5 rounded-full ${selectedPage === page.key ? 'bg-white/20 text-white' : 'bg-blue-100 text-blue-700'}`}>
                    {customCount}
                  </span>
                )}
                <ChevronRight className={`w-3.5 h-3.5 ${selectedPage === page.key ? 'text-white' : 'text-gray-300'}`} />
              </div>
            </button>
          );
        })}

        <div className="mt-4 px-3 py-3 bg-gray-50 rounded-xl border border-gray-100">
          <div className="text-xs text-gray-500 mb-1">Pagine con modifiche</div>
          <div className="text-2xl font-bold text-gray-900">{activeCount} <span className="text-sm font-normal text-gray-400">/ {PAGES.length}</span></div>
        </div>
      </div>

      {/* Main area: visual editor */}
      <div className="flex-1 min-w-0">
        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600" />
          </div>
        ) : (
          <div>
            {/* Page header */}
            <div className="flex items-center justify-between mb-4">
              <div>
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-2xl">{currentPage.icon}</span>
                  <h2 className="text-xl font-bold text-gray-900">{currentPage.label}</h2>
                  {currentCustomization?.updated_at && (
                    <span className="text-xs text-gray-400">
                      — aggiornata il {new Date(currentCustomization.updated_at).toLocaleDateString('it-IT')}
                    </span>
                  )}
                </div>
                <p className="text-sm text-gray-500 flex items-center gap-1.5">
                  <Eye className="w-3.5 h-3.5" />
                  Passa il cursore su ogni sezione per vedere i tasti di modifica
                </p>
              </div>
              <span className="flex items-center gap-1.5 text-xs text-gray-400 bg-gray-100 px-3 py-1.5 rounded-full">
                <Smartphone className="w-3.5 h-3.5" />
                Anteprima desktop
              </span>
            </div>

            {/* Visual page preview */}
            <div className="bg-gray-50 rounded-2xl border border-gray-200 p-4">
              <PagePreview
                page={currentPage}
                customization={currentCustomization}
                onSave={(updates) => handleSave(selectedPage, updates)}
              />
            </div>

            <p className="text-xs text-center text-gray-400 mt-3">
              Le modifiche sono visibili immediatamente sulla pagina pubblica
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
