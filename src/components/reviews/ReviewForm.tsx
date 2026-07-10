import { useState } from 'react';
import { Star, X, Upload, FileText, ChevronRight, ChevronLeft } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useToast } from '../common/Toast';

interface ReviewFormProps {
  businessId?: string;
  businessName?: string;
  businessType?: 'imported' | 'user_added' | 'registered';
  businessLocationId?: string;
  unclaimedBusinessLocationId?: string;
  registeredBusinessLocationId?: string;
  onClose: () => void;
  onSuccess: () => void;
}

type ReviewType = 'service_used' | 'booking_not_completed' | 'quote_request' | 'customer_service' | 'problem_before_service';

interface RatingGroup {
  key: string;
  label: string;
  value: number;
  setter: (v: number) => void;
}

export function ReviewForm({
  businessId,
  businessName,
  businessType,
  businessLocationId,
  unclaimedBusinessLocationId,
  registeredBusinessLocationId,
  onClose,
  onSuccess
}: ReviewFormProps) {
  const { showToast } = useToast();
  const { profile, activeProfile } = useAuth();

  const [step, setStep] = useState(1);
  const [reviewType, setReviewType] = useState<ReviewType | null>(null);

  // service_used ratings
  const [serviceGestionePrenotazione, setServiceGestionePrenotazione] = useState(0);
  const [serviceAffidabilita, setServiceAffidabilita] = useState(0);
  const [serviceOrganizzazione, setServiceOrganizzazione] = useState(0);
  const [serviceEsperienza, setServiceEsperienza] = useState(0);
  const [servicePrezzo, setServicePrezzo] = useState(0);

  // booking_not_completed ratings
  const [bookingGestionePrenotazione, setBookingGestionePrenotazione] = useState(0);
  const [bookingAffidabilita, setBookingAffidabilita] = useState(0);
  const [bookingOrganizzazione, setBookingOrganizzazione] = useState(0);
  const [bookingComunicazione, setBookingComunicazione] = useState(0);

  // quote_request ratings
  const [quoteChiarezza, setQuoteChiarezza] = useState(0);
  const [quoteTrasparenza, setQuoteTrasparenza] = useState(0);
  const [quoteTempisticheRisposta, setQuoteTempisticheRisposta] = useState(0);
  const [quoteDisponibilita, setQuoteDisponibilita] = useState(0);

  // customer_service ratings
  const [csCortesia, setCsCortesia] = useState(0);
  const [csCompetenza, setCsCompetenza] = useState(0);
  const [csRapidita, setCsRapidita] = useState(0);
  const [csRisoluzioneProblem, setCsRisoluzioneProblem] = useState(0);

  // problem_before_service ratings
  const [problemAffidabilita, setProblemAffidabilita] = useState(0);
  const [problemOrganizzazione, setProblemOrganizzazione] = useState(0);
  const [problemGestioneProblema, setProblemGestioneProblema] = useState(0);
  const [problemComunicazione, setProblemComunicazione] = useState(0);

  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [proofDocuments, setProofDocuments] = useState<File[]>([]);
  const [proofDocumentPreviews, setProofDocumentPreviews] = useState<string[]>([]);

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const reviewTypeOptions = [
    { value: 'service_used', label: 'Ho usufruito del servizio', icon: '✓', color: 'green' },
    { value: 'booking_not_completed', label: 'Ho prenotato ma il servizio non si è svolto', icon: '✗', color: 'red' },
    { value: 'quote_request', label: 'Ho richiesto preventivo/informazioni', icon: '?', color: 'blue' },
    { value: 'customer_service', label: 'Ho avuto un contatto con l\'assistenza', icon: '☎', color: 'teal' },
    { value: 'problem_before_service', label: 'Ho avuto un problema prima dell\'erogazione', icon: '⚠', color: 'amber' }
  ];

  const OPTIONAL_KEYS = new Set(['service_gestione', 'booking_gestione']);

  const getRatingGroupsForType = (type: ReviewType): RatingGroup[] => {
    switch (type) {
      case 'service_used':
        return [
          { key: 'service_gestione', label: 'Gestione Prenotazione (facoltativo)', value: serviceGestionePrenotazione, setter: setServiceGestionePrenotazione },
          { key: 'service_affidabilita', label: 'Affidabilità', value: serviceAffidabilita, setter: setServiceAffidabilita },
          { key: 'service_organizzazione', label: 'Organizzazione', value: serviceOrganizzazione, setter: setServiceOrganizzazione },
          { key: 'service_esperienza', label: 'Esperienza/Servizio', value: serviceEsperienza, setter: setServiceEsperienza },
          { key: 'service_prezzo', label: 'Prezzo', value: servicePrezzo, setter: setServicePrezzo },
        ];
      case 'booking_not_completed':
        return [
          { key: 'booking_gestione', label: 'Gestione Prenotazione (facoltativo)', value: bookingGestionePrenotazione, setter: setBookingGestionePrenotazione },
          { key: 'booking_affidabilita', label: 'Affidabilità', value: bookingAffidabilita, setter: setBookingAffidabilita },
          { key: 'booking_organizzazione', label: 'Organizzazione', value: bookingOrganizzazione, setter: setBookingOrganizzazione },
          { key: 'booking_comunicazione', label: 'Comunicazione', value: bookingComunicazione, setter: setBookingComunicazione },
        ];
      case 'quote_request':
        return [
          { key: 'quote_chiarezza', label: 'Chiarezza', value: quoteChiarezza, setter: setQuoteChiarezza },
          { key: 'quote_trasparenza', label: 'Trasparenza', value: quoteTrasparenza, setter: setQuoteTrasparenza },
          { key: 'quote_tempistiche', label: 'Tempistiche Risposta', value: quoteTempisticheRisposta, setter: setQuoteTempisticheRisposta },
          { key: 'quote_disponibilita', label: 'Disponibilità', value: quoteDisponibilita, setter: setQuoteDisponibilita },
        ];
      case 'customer_service':
        return [
          { key: 'cs_cortesia', label: 'Cortesia', value: csCortesia, setter: setCsCortesia },
          { key: 'cs_competenza', label: 'Competenza', value: csCompetenza, setter: setCsCompetenza },
          { key: 'cs_rapidita', label: 'Rapidità', value: csRapidita, setter: setCsRapidita },
          { key: 'cs_risoluzione', label: 'Risoluzione Problema', value: csRisoluzioneProblem, setter: setCsRisoluzioneProblem },
        ];
      case 'problem_before_service':
        return [
          { key: 'problem_affidabilita', label: 'Affidabilità', value: problemAffidabilita, setter: setProblemAffidabilita },
          { key: 'problem_organizzazione', label: 'Organizzazione', value: problemOrganizzazione, setter: setProblemOrganizzazione },
          { key: 'problem_gestione', label: 'Gestione Problema', value: problemGestioneProblema, setter: setProblemGestioneProblema },
          { key: 'problem_comunicazione', label: 'Comunicazione', value: problemComunicazione, setter: setProblemComunicazione },
        ];
      default:
        return [];
    }
  };

  const allRatingsFilledForType = (type: ReviewType): boolean => {
    const groups = getRatingGroupsForType(type);
    return groups.every(g => OPTIONAL_KEYS.has(g.key) || g.value > 0);
  };

  const getAverageRatingForType = (type: ReviewType): number => {
    const groups = getRatingGroupsForType(type);
    if (groups.length === 0 || !allRatingsFilledForType(type)) return 0;
    const filled = groups.filter(g => g.value > 0);
    if (filled.length === 0) return 0;
    return filled.reduce((sum, g) => sum + g.value, 0) / filled.length;
  };

  const handleDocumentChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const validFiles = files.filter(file => {
      if (file.size > 10 * 1024 * 1024) {
        setError('Ogni file deve essere massimo 10MB');
        return false;
      }
      return true;
    });

    if (validFiles.length > 0) {
      setProofDocuments(prev => [...prev, ...validFiles]);
      validFiles.forEach(file => {
        const reader = new FileReader();
        reader.onloadend = () => {
          setProofDocumentPreviews(prev => [...prev, reader.result as string]);
        };
        reader.readAsDataURL(file);
      });
    }
  };

  const removeDocument = (index: number) => {
    setProofDocuments(prev => prev.filter((_, i) => i !== index));
    setProofDocumentPreviews(prev => prev.filter((_, i) => i !== index));
  };

  const uploadDocuments = async (): Promise<string[]> => {
    if (proofDocuments.length === 0) return [];
    const uploadedUrls: string[] = [];
    for (const file of proofDocuments) {
      const fileExt = file.name.split('.').pop();
      const fileName = `${profile?.id}/${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
      const { error: uploadError } = await supabase.storage
        .from('review-proof-documents')
        .upload(fileName, file);
      if (uploadError) throw uploadError;
      const { data: { publicUrl } } = supabase.storage
        .from('review-proof-documents')
        .getPublicUrl(fileName);
      uploadedUrls.push(publicUrl);
    }
    return uploadedUrls;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!reviewType) {
      setError('Seleziona il tipo di esperienza');
      return;
    }

    if (content.length < 100) {
      setError('La descrizione deve essere di almeno 100 caratteri');
      return;
    }

    if (!allRatingsFilledForType(reviewType)) {
      setError('Completa tutte le valutazioni');
      return;
    }

    setLoading(true);
    setError('');

    try {
      // Check calendar-year limit before uploading anything
      const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;
      const { data: yearCheck, error: yearCheckError } = await supabase.rpc('check_review_allowed_this_year', {
        p_customer_id: profile?.id,
        p_family_member_id: familyMemberId,
        p_business_id: (businessType !== 'imported' && businessType !== 'user_added' && businessType !== 'registered') ? businessId ?? null : null,
        p_imported_business_id: businessType === 'imported' ? businessId ?? null : null,
        p_user_added_business_id: businessType === 'user_added' ? businessId ?? null : null,
        p_unclaimed_business_location_id: unclaimedBusinessLocationId ?? (businessType === 'imported' || businessType === 'user_added' ? businessId ?? null : null),
        p_registered_business_location_id: registeredBusinessLocationId ?? null,
      });

      if (yearCheckError) throw yearCheckError;

      if (!yearCheck) {
        showToast('Hai già recensito questa attività nel ' + new Date().getFullYear() + '. Potrai farlo di nuovo dal 1° gennaio ' + (new Date().getFullYear() + 1) + '.', 'error');
        onClose();
        return;
      }

      const documentUrls = await uploadDocuments();
      const avg = getAverageRatingForType(reviewType);

      const roundedRating = Math.max(1, Math.min(5, Math.round(avg)));

      const reviewData: any = {
        customer_id: profile?.id,
        family_member_id: activeProfile && !activeProfile.isOwner ? activeProfile.id : null,
        business_type: businessType || null,
        business_id: null,
        business_location_id: businessLocationId || null,
        imported_business_id: null,
        user_added_business_id: null,
        unclaimed_business_location_id: unclaimedBusinessLocationId || (businessType === 'imported' || businessType === 'user_added' ? businessId : null),
        registered_business_location_id: registeredBusinessLocationId || null,
        registered_business_id: (businessType === 'registered' && !registeredBusinessLocationId) ? businessId : null,
        review_type: reviewType,
        title,
        content,
        rating: roundedRating,
        overall_rating: roundedRating,
        proof_documents: documentUrls.length > 0 ? documentUrls : null,
        review_status: 'pending'
      };

      if (reviewType === 'service_used') {
        reviewData.booking_management_rating = serviceGestionePrenotazione > 0 ? serviceGestionePrenotazione : null;
        reviewData.reliability_rating = serviceAffidabilita;
        reviewData.organization_rating = serviceOrganizzazione;
        reviewData.experience_rating = serviceEsperienza;
        reviewData.price_rating = servicePrezzo;
      } else if (reviewType === 'booking_not_completed') {
        reviewData.booking_gestione_prenotazione = bookingGestionePrenotazione > 0 ? bookingGestionePrenotazione : null;
        reviewData.booking_affidabilita = bookingAffidabilita;
        reviewData.booking_organizzazione = bookingOrganizzazione;
        reviewData.booking_comunicazione = bookingComunicazione;
      } else if (reviewType === 'quote_request') {
        reviewData.quote_chiarezza = quoteChiarezza;
        reviewData.quote_trasparenza = quoteTrasparenza;
        reviewData.quote_tempistiche_risposta = quoteTempisticheRisposta;
        reviewData.quote_disponibilita = quoteDisponibilita;
      } else if (reviewType === 'customer_service') {
        reviewData.cs_cortesia = csCortesia;
        reviewData.cs_competenza = csCompetenza;
        reviewData.cs_rapidita = csRapidita;
        reviewData.cs_risoluzione_problema = csRisoluzioneProblem;
      } else if (reviewType === 'problem_before_service') {
        reviewData.problem_affidabilita = problemAffidabilita;
        reviewData.problem_organizzazione = problemOrganizzazione;
        reviewData.problem_gestione_problema = problemGestioneProblema;
        reviewData.problem_comunicazione = problemComunicazione;
      }

      const { error: insertError } = await supabase
        .from('reviews')
        .insert([reviewData]);

      if (insertError) {
        const isDuplicate = insertError.code === '23505' || insertError.code === '409' || insertError.message?.includes('duplicate') || insertError.message?.includes('unique');
        if (isDuplicate) {
          showToast('Hai già recensito questa attività quest\'anno.', 'error');
          onClose();
          return;
        }
        throw insertError;
      }

      showToast('Recensione inviata con successo! Sarà visibile dopo l\'approvazione da parte dell\'amministratore.', 'success');
      onSuccess();
    } catch (err: any) {
      console.error('Error submitting review:', err);
      setError(err.message || 'Errore durante l\'invio della recensione');
    } finally {
      setLoading(false);
    }
  };

  const renderStarRating = (rating: number, setRating: (r: number) => void, label: string) => (
    <div className="mb-5">
      <label className="block text-sm font-medium text-gray-700 mb-2">{label}</label>
      <div className="flex items-center gap-1">
        {[1, 2, 3, 4, 5].map((star) => (
          <button
            key={star}
            type="button"
            onClick={() => setRating(star)}
            className="focus:outline-none transition-transform hover:scale-110"
          >
            <Star
              className={`w-8 h-8 ${star <= rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`}
            />
          </button>
        ))}
        <span className="ml-2 text-sm text-gray-500">
          {rating > 0 ? `${rating}/5` : 'Non valutato'}
        </span>
      </div>
    </div>
  );

  const estimatedPoints = reviewType === 'service_used'
    ? (proofDocuments.length > 0 ? 50 : 25)
    : 25;

  const getStepTitle = (type: ReviewType | null): string => {
    if (!type) return 'Valuta la tua esperienza';
    switch (type) {
      case 'service_used': return 'Valuta il servizio ricevuto';
      case 'booking_not_completed': return 'Valuta la gestione della prenotazione';
      case 'quote_request': return 'Valuta la risposta al tuo preventivo';
      case 'customer_service': return 'Valuta il contatto con l\'assistenza';
      case 'problem_before_service': return 'Valuta la gestione del problema';
    }
  };

  const requiresProof = false;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl">
        <div className="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex justify-between items-center rounded-t-xl">
          <div>
            <h2 className="text-xl font-bold text-gray-900">Scrivi una recensione</h2>
            {businessName && <p className="text-sm text-gray-500">{businessName}</p>}
          </div>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600 transition-colors">
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="px-6 py-5">
          <div className="mb-6">
            <div className="flex items-center justify-between mb-3">
              {[1, 2, 3].map((s) => (
                <div key={s} className="flex items-center flex-1">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold shrink-0 transition-colors ${
                    step >= s ? 'bg-orange-600 text-white' : 'bg-gray-100 text-gray-400'
                  }`}>
                    {s}
                  </div>
                  {s < 3 && (
                    <div className={`flex-1 h-1 mx-2 rounded transition-colors ${step > s ? 'bg-orange-600' : 'bg-gray-200'}`} />
                  )}
                </div>
              ))}
            </div>
            <div className="flex justify-between text-xs text-gray-500 px-0">
              <span>Tipo esperienza</span>
              <span className="text-center">Valutazione</span>
              <span className="text-right">Descrizione</span>
            </div>
          </div>

          <form onSubmit={handleSubmit}>
            {step === 1 && (
              <div className="space-y-3">
                <h3 className="font-semibold text-lg mb-4 text-gray-900">Che tipo di esperienza hai avuto?</h3>
                {reviewTypeOptions.map((option) => (
                  <button
                    key={option.value}
                    type="button"
                    onClick={() => {
                      setReviewType(option.value as ReviewType);
                      setStep(2);
                    }}
                    className={`w-full p-4 border-2 rounded-xl text-left transition-all hover:border-orange-500 hover:bg-orange-50 ${
                      reviewType === option.value
                        ? 'border-orange-600 bg-orange-50'
                        : 'border-gray-200'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <span className="text-xl w-8 text-center">{option.icon}</span>
                      <span className="font-medium text-gray-800">{option.label}</span>
                    </div>
                  </button>
                ))}
              </div>
            )}

            {step === 2 && reviewType && (
              <div className="space-y-1">
                <h3 className="font-semibold text-lg mb-5 text-gray-900">{getStepTitle(reviewType)}</h3>

                {getRatingGroupsForType(reviewType).map((group) => (
                  <div key={group.key} className={OPTIONAL_KEYS.has(group.key) ? 'opacity-70' : ''}>
                    {renderStarRating(group.value, group.setter, group.label)}
                  </div>
                ))}

                {allRatingsFilledForType(reviewType) && (
                  <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg mb-2">
                    <p className="text-sm text-blue-900">
                      <strong>Media valutazioni:</strong>{' '}
                      {getAverageRatingForType(reviewType).toFixed(1)} / 5.0
                    </p>
                  </div>
                )}

                <div className="mt-4">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Carica documenti di prova{requiresProof ? <span className="text-red-500 ml-1">*</span> : <span className="text-gray-400 ml-1">(facoltativo)</span>}
                  </label>
                  {requiresProof && (
                    <p className="text-xs text-gray-500 mb-2">
                      Carica documenti che attestano la tua esperienza (screenshot, email, ricevuta, ecc.)
                    </p>
                  )}
                  <div className="border-2 border-dashed border-gray-300 rounded-lg p-4 hover:border-orange-400 transition-colors">
                    <input
                      type="file"
                      accept="image/*,.pdf"
                      multiple
                      onChange={handleDocumentChange}
                      className="hidden"
                      id="proof-documents"
                    />
                    <label htmlFor="proof-documents" className="cursor-pointer flex flex-col items-center">
                      <Upload className="w-8 h-8 text-gray-400 mb-2" />
                      <span className="text-sm text-gray-600">Clicca per caricare documenti</span>
                      <span className="text-xs text-gray-400 mt-1">PDF, JPG, PNG (max 10MB ciascuno)</span>
                    </label>
                  </div>

                  {proofDocumentPreviews.length > 0 && (
                    <div className="mt-3 grid grid-cols-3 gap-2">
                      {proofDocumentPreviews.map((preview, index) => (
                        <div key={index} className="relative">
                          {proofDocuments[index].type.includes('image') ? (
                            <img src={preview} alt="Documento" className="w-full h-24 object-cover rounded-lg" />
                          ) : (
                            <div className="w-full h-24 bg-gray-100 rounded-lg flex items-center justify-center">
                              <FileText className="w-8 h-8 text-gray-400" />
                            </div>
                          )}
                          <button
                            type="button"
                            onClick={() => removeDocument(index)}
                            className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                <div className="flex gap-3 pt-4">
                  <button
                    type="button"
                    onClick={() => setStep(1)}
                    className="flex items-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
                  >
                    <ChevronLeft className="w-4 h-4" />
                    Indietro
                  </button>
                  <button
                    type="button"
                    onClick={() => setStep(3)}
                    disabled={!allRatingsFilledForType(reviewType)}
                    className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
                  >
                    Avanti
                    <ChevronRight className="w-4 h-4" />
                  </button>
                </div>
              </div>
            )}

            {step === 3 && (
              <div className="space-y-4">
                <h3 className="font-semibold text-lg mb-4 text-gray-900">Descrivi la tua esperienza</h3>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Titolo <span className="text-gray-400 font-normal">(facoltativo)</span>
                  </label>
                  <input
                    type="text"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    placeholder="Es: Ottima esperienza"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                    maxLength={100}
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Descrizione <span className="text-red-500">*</span>
                  </label>
                  <textarea
                    value={content}
                    onChange={(e) => setContent(e.target.value)}
                    placeholder="Racconta la tua esperienza in dettaglio... (minimo 100 caratteri)"
                    rows={6}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent resize-none"
                    required
                  />
                  <div className="flex justify-between text-xs mt-1">
                    <span className="text-gray-400">{content.length} / 100 caratteri minimi</span>
                    {content.length >= 100 && (
                      <span className="text-green-600 font-medium">Requisito soddisfatto</span>
                    )}
                  </div>
                </div>

                <div className="bg-gradient-to-r from-green-50 to-blue-50 border border-green-200 rounded-lg p-4">
                  <div className="flex items-center gap-2 mb-1">
                    <Star className="w-5 h-5 text-yellow-500 fill-yellow-500" />
                    <span className="font-semibold text-gray-900 text-sm">Punti stimati</span>
                  </div>
                  <div className="text-2xl font-bold text-green-600">{estimatedPoints} punti</div>
                  <p className="text-xs text-gray-500 mt-1">
                    {reviewType === 'service_used' && proofDocuments.length > 0
                      ? 'Con prova documentale allegata'
                      : reviewType === 'service_used'
                      ? 'Aggiungi un documento per guadagnare 50 punti'
                      : 'Per recensioni con documento di prova'}
                  </p>
                </div>

                {error && (
                  <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
                    {error}
                  </div>
                )}

                <div className="flex gap-3">
                  <button
                    type="button"
                    onClick={() => setStep(2)}
                    className="flex items-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
                  >
                    <ChevronLeft className="w-4 h-4" />
                    Indietro
                  </button>
                  <button
                    type="submit"
                    disabled={loading || content.length < 100}
                    className="flex-1 bg-orange-600 text-white py-2 px-4 rounded-lg font-medium hover:bg-orange-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
                  >
                    {loading ? 'Invio in corso...' : 'Invia Recensione'}
                  </button>
                </div>
              </div>
            )}
          </form>
        </div>
      </div>
    </div>
  );
}
