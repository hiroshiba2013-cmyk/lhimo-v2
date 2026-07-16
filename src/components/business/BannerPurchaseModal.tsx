import { useState, useEffect, useRef } from 'react';
import { X, Image as ImageIcon, Upload, Check, Euro, Calendar, Info, ExternalLink } from 'lucide-react';
import { useToast } from '../common/Toast';
import {
  AdvertisingPlan, BannerPosition, POSITION_LABELS, priceWithVat,
  fetchPlansByPosition, createBanner, uploadBannerImage,
} from '../../lib/advertising-service';

interface BannerPurchaseModalProps {
  open: boolean;
  onClose: () => void;
  userId: string;
  businessLocationId?: string | null;
}

const POSITIONS: { value: BannerPosition; label: string; description: string }[] = [
  { value: 'home_top', label: 'Home - Banner in alto', description: 'Massima visibilità in homepage' },
  { value: 'home_bottom', label: 'Home - Banner in basso', description: 'Visibilità in fondo alla homepage' },
  { value: 'search_top', label: 'Ricerca - Banner in alto', description: 'In alto nella pagina di ricerca' },
  { value: 'search_results_1_30', label: 'Ricerca - Primi 30 risultati', description: 'Tra i primi 30 risultati di ricerca' },
  { value: 'search_results_31_60', label: 'Ricerca - Risultati 31-60', description: 'Tra i risultati 31-60 di ricerca' },
];

export function BannerPurchaseModal({ open, onClose, userId, businessLocationId }: BannerPurchaseModalProps) {
  const { showToast } = useToast();
  const [step, setStep] = useState<'select' | 'configure' | 'done'>('select');
  const [position, setPosition] = useState<BannerPosition>('home_top');
  const [plans, setPlans] = useState<AdvertisingPlan[]>([]);
  const [selectedPlan, setSelectedPlan] = useState<AdvertisingPlan | null>(null);
  const [loadingPlans, setLoadingPlans] = useState(false);
  const [imageUrl, setImageUrl] = useState('');
  const [linkUrl, setLinkUrl] = useState('');
  const [altText, setAltText] = useState('');
  const [uploading, setUploading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (!open) return;
    setStep('select');
    setPosition('home_top');
    setSelectedPlan(null);
    setImageUrl('');
    setLinkUrl('');
    setAltText('');
  }, [open]);

  useEffect(() => {
    if (!open) return;
    setLoadingPlans(true);
    fetchPlansByPosition(position)
      .then(setPlans)
      .catch(() => showToast('Errore nel caricamento dei piani', 'error'))
      .finally(() => setLoadingPlans(false));
  }, [open, position, showToast]);

  if (!open) return null;

  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) {
      showToast('L\'immagine non può superare i 2MB', 'error');
      return;
    }
    try {
      setUploading(true);
      const url = await uploadBannerImage(file, userId);
      setImageUrl(url);
      showToast('Immagine caricata', 'success');
    } catch {
      showToast('Errore nel caricamento dell\'immagine', 'error');
    } finally {
      setUploading(false);
    }
  };

  const handleSubmit = async () => {
    if (!selectedPlan) return;
    if (!imageUrl) {
      showToast('Carica un\'immagine per il banner', 'error');
      return;
    }
    try {
      setSubmitting(true);
      await createBanner({
        plan_id: selectedPlan.id,
        position: selectedPlan.position,
        image_url: imageUrl,
        link_url: linkUrl || null,
        alt_text: altText || null,
        business_location_id: businessLocationId || null,
        price_paid: selectedPlan.price,
      });
      setStep('done');
      showToast('Banner inviato per approvazione', 'success');
    } catch {
      showToast('Errore nella creazione del banner', 'error');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50" onClick={onClose}>
      <div className="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto" onClick={e => e.stopPropagation()}>
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-gray-200 sticky top-0 bg-white rounded-t-2xl z-10">
          <h3 className="text-lg font-bold text-gray-900 flex items-center gap-2">
            <ImageIcon className="w-5 h-5 text-blue-600" />
            Pubblica Banner Pubblicitario
          </h3>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-6">
          {step === 'select' && (
            <>
              <div className="mb-4">
                <p className="text-sm font-semibold text-gray-900 mb-3">1. Scegli la posizione</p>
                <div className="grid grid-cols-1 gap-2">
                  {POSITIONS.map(pos => (
                    <button key={pos.value} onClick={() => { setPosition(pos.value); setSelectedPlan(null); }}
                      className={`text-left p-3 rounded-xl border transition-all ${position === pos.value ? 'border-blue-500 bg-blue-50 ring-2 ring-blue-200' : 'border-gray-200 hover:border-gray-300'}`}>
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-sm font-semibold text-gray-900">{pos.label}</p>
                          <p className="text-xs text-gray-500">{pos.description}</p>
                        </div>
                        {position === pos.value && <Check className="w-4 h-4 text-blue-600 flex-shrink-0" />}
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              <div className="mb-4">
                <p className="text-sm font-semibold text-gray-900 mb-3">2. Scegli la durata</p>
                {loadingPlans ? (
                  <div className="flex items-center justify-center py-6">
                    <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
                  </div>
                ) : plans.length === 0 ? (
                  <p className="text-sm text-gray-500 italic">Nessun piano disponibile per questa posizione.</p>
                ) : (
                  <div className="grid grid-cols-3 gap-2">
                    {plans.map(plan => (
                      <button key={plan.id} onClick={() => { setSelectedPlan(plan); setStep('configure'); }}
                        className={`p-3 rounded-xl border text-center transition-all ${selectedPlan?.id === plan.id ? 'border-blue-500 bg-blue-50 ring-2 ring-blue-200' : 'border-gray-200 hover:border-gray-300'}`}>
                        <p className="text-xs text-gray-500 mb-1">{plan.duration_days} giorni</p>
                        <p className="text-lg font-bold text-gray-900">€{Number(plan.price).toFixed(2)}</p>
                        <p className="text-[10px] text-gray-400">+ IVA</p>
                        <p className="text-[10px] text-gray-400 mt-0.5">€{priceWithVat(Number(plan.price)).toFixed(2)} tot.</p>
                      </button>
                    ))}
                  </div>
                )}
              </div>

              <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 flex items-start gap-2">
                <Info className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
                <p className="text-xs text-amber-800">
                  I banner sono soggetti ad approvazione dell'amministrazione prima della pubblicazione.
                  Il periodo di visibilità decorre dall'approvazione. Formato consigliato: 1200×300 px.
                </p>
              </div>
            </>
          )}

          {step === 'configure' && selectedPlan && (
            <>
              <div className="bg-blue-50 border border-blue-200 rounded-xl p-3 mb-5 flex items-center justify-between">
                <div>
                  <p className="text-sm font-semibold text-gray-900">{POSITION_LABELS[selectedPlan.position]}</p>
                  <p className="text-xs text-gray-500">{selectedPlan.duration_days} giorni</p>
                </div>
                <div className="text-right">
                  <p className="text-lg font-bold text-gray-900">€{priceWithVat(Number(selectedPlan.price)).toFixed(2)}</p>
                  <p className="text-[10px] text-gray-400">IVA inclusa</p>
                </div>
              </div>

              {/* Image upload */}
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Immagine banner *</label>
                <div className="relative w-full aspect-[4/1] rounded-xl border-2 border-dashed border-gray-300 overflow-hidden bg-gray-50 flex items-center justify-center">
                  {imageUrl ? (
                    <img src={imageUrl} alt="Preview" className="w-full h-full object-cover" />
                  ) : (
                    <div className="text-center">
                      <ImageIcon className="w-8 h-8 text-gray-400 mx-auto mb-1" />
                      <p className="text-xs text-gray-500">1200 × 300 px consigliato</p>
                    </div>
                  )}
                </div>
                <input ref={fileRef} type="file" accept="image/*" className="hidden" onChange={handleUpload} />
                <button onClick={() => fileRef.current?.click()} disabled={uploading}
                  className="mt-2 flex items-center gap-2 text-sm font-medium text-blue-600 hover:text-blue-700 disabled:opacity-50">
                  {uploading ? <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600"></div> : <Upload className="w-4 h-4" />}
                  {imageUrl ? 'Cambia immagine' : 'Carica immagine'}
                </button>
              </div>

              {/* Link URL */}
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Link (opzionale)</label>
                <div className="relative">
                  <ExternalLink className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input type="url" value={linkUrl} onChange={e => setLinkUrl(e.target.value)} placeholder="https://..."
                    className="w-full border border-gray-300 rounded-lg pl-9 pr-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                </div>
              </div>

              {/* Alt text */}
              <div className="mb-5">
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Testo alternativo (opzionale)</label>
                <input type="text" value={altText} onChange={e => setAltText(e.target.value)} placeholder="Descrizione del banner"
                  className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
              </div>

              <div className="flex items-center justify-between gap-3">
                <button onClick={() => setStep('select')}
                  className="px-4 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 text-sm font-medium">
                  Indietro
                </button>
                <button onClick={handleSubmit} disabled={submitting || !imageUrl}
                  className="flex items-center gap-2 bg-blue-600 text-white px-5 py-2.5 rounded-lg hover:bg-blue-700 disabled:opacity-50 text-sm font-semibold">
                  {submitting ? <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div> : <Check className="w-4 h-4" />}
                  Invia per approvazione · €{priceWithVat(Number(selectedPlan.price)).toFixed(2)}
                </button>
              </div>
            </>
          )}

          {step === 'done' && (
            <div className="text-center py-8">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Check className="w-8 h-8 text-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-2">Banner inviato!</h3>
              <p className="text-sm text-gray-500 mb-1">Il tuo banner è in attesa di approvazione.</p>
              <p className="text-xs text-gray-400 mb-6">
                Riceverai una notifica non appena verrà approvato. Il periodo di visibilità
                inizierà dal momento dell'approvazione.
              </p>
              <button onClick={onClose}
                className="bg-blue-600 text-white px-5 py-2.5 rounded-lg hover:bg-blue-700 text-sm font-semibold">
                Chiudi
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
