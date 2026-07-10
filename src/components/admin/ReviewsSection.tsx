import { useState } from 'react';
import { CheckCircle, XCircle, Eye, Star, Filter, MapPin, Building2, Calendar, Clock, User, Search, X, FileEdit as Edit, Save, X as CloseIcon, ChevronDown, ChevronUp, Image, FileText, Upload, Tag } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { AdminLocationFilter } from './AdminLocationFilter';
import { useToast } from '../common/Toast';

interface Review {
  id: string;
  title: string;
  content: string;
  overall_rating: number;
  price_rating: number | null;
  service_rating: number | null;
  quality_rating: number | null;
  review_type: string | null;
  proof_image_url: string | null;
  proof_documents: string[] | null;
  review_status: string;
  created_at: string;
  // service_used
  booking_management_rating: number | null;
  reliability_rating: number | null;
  organization_rating: number | null;
  experience_rating: number | null;
  // booking_not_completed
  booking_gestione_prenotazione: number | null;
  booking_affidabilita: number | null;
  booking_organizzazione: number | null;
  booking_comunicazione: number | null;
  // quote_request
  quote_chiarezza: number | null;
  quote_trasparenza: number | null;
  quote_tempistiche_risposta: number | null;
  quote_disponibilita: number | null;
  // customer_service
  cs_cortesia: number | null;
  cs_competenza: number | null;
  cs_rapidita: number | null;
  cs_risoluzione_problema: number | null;
  // problem_before_service
  problem_affidabilita: number | null;
  problem_organizzazione: number | null;
  problem_gestione_problema: number | null;
  problem_comunicazione: number | null;
  customer: {
    id: string;
    full_name: string;
    nickname: string | null;
    email: string;
  };
  customer_id: string;
  family_member_id?: string | null;
  family_member?: {
    nickname: string | null;
    full_name: string;
  } | null;
  business_id: string | null;
  business_location_id: string | null;
  unclaimed_business_location_id: string | null;
  registered_business_location_id: string | null;
  registered_business_id: string | null;
  business_location?: {
    name: string;
    internal_name: string | null;
    city: string;
    province: string | null;
    region: string | null;
    address: string;
    category: { name: string } | null;
  } | null;
  unclaimed_business_location?: {
    name: string;
    city: string;
    province: string | null;
    region: string | null;
    street: string;
    category: { name: string } | null;
  } | null;
  registered_business_location?: {
    name: string;
    internal_name: string | null;
    city: string;
    province: string | null;
    region: string | null;
    street: string;
    category: { name: string } | null;
    parent_business: { name: string } | null;
  } | null;
  registered_business?: {
    name: string;
  } | null;
  businesses?: {
    name: string;
  } | null;
  responses?: {
    id: string;
    content: string;
    created_at: string;
  }[] | null;
}

const RATING_OPTIONS = [
  { value: '', label: 'Qualsiasi' },
  { value: '1', label: '1 stella e piu' },
  { value: '2', label: '2 stelle e piu' },
  { value: '3', label: '3 stelle e piu' },
  { value: '4', label: '4 stelle e piu' },
  { value: '5', label: '5 stelle' },
];

const REVIEW_TYPE_OPTIONS = [
  { value: '', label: 'Tutti i tipi' },
  { value: 'service_used', label: 'Ho usufruito del servizio' },
  { value: 'booking_not_completed', label: 'Prenotazione non completata' },
  { value: 'quote_request', label: 'Preventivo / Informazioni' },
  { value: 'customer_service', label: 'Assistenza Clienti' },
  { value: 'problem_before_service', label: 'Problema pre-servizio' },
];

interface ReviewsSectionProps {
  reviews: Review[];
  onReload: () => void;
  adminId: string;
}

export function ReviewsSection({ reviews, onReload, adminId }: ReviewsSectionProps) {
  const { showToast } = useToast();
  const [selectedReview, setSelectedReview] = useState<Review | null>(null);
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [filterReviewType, setFilterReviewType] = useState<string>('');
  const [searchNickname, setSearchNickname] = useState('');
  const [searchBusinessName, setSearchBusinessName] = useState('');
  const [minOverallRating, setMinOverallRating] = useState<string>('');
  const [minServiceRating, setMinServiceRating] = useState<string>('');
  const [minBookingRating, setMinBookingRating] = useState<string>('');
  const [minQuoteRating, setMinQuoteRating] = useState<string>('');
  const [minCustomerServiceRating, setMinCustomerServiceRating] = useState<string>('');
  const [minProblemRating, setMinProblemRating] = useState<string>('');
  const [showRatingFilters, setShowRatingFilters] = useState(false);
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [rejectReason, setRejectReason] = useState('');
  const [reviewToReject, setReviewToReject] = useState<string | null>(null);
  const [showFilters, setShowFilters] = useState(false);
  const [locationFilter, setLocationFilter] = useState({ region: '', province: '', city: '' });
  const [editingReview, setEditingReview] = useState<Review | null>(null);
  const [editForm, setEditForm] = useState<Partial<Review> | null>(null);
  const [showResponseExpanded, setShowResponseExpanded] = useState(false);

  const getReviewerName = (review: Review) => {
    if (review.family_member) {
      return review.family_member.nickname || review.family_member.full_name;
    }
    return review.customer.nickname || review.customer.full_name;
  };

  const filteredReviews = reviews.filter(review => {
    if (filterStatus !== 'all' && review.review_status !== filterStatus) return false;
    if (filterReviewType && review.review_type !== filterReviewType) return false;

    if (searchNickname.trim()) {
      const reviewerName = getReviewerName(review).toLowerCase();
      if (!reviewerName.includes(searchNickname.toLowerCase())) return false;
    }

    if (searchBusinessName.trim()) {
      const businessName = getBusinessName(review).toLowerCase();
      if (!businessName.includes(searchBusinessName.toLowerCase())) return false;
    }

    if (minOverallRating && review.overall_rating < Number(minOverallRating)) return false;

    if (minServiceRating) {
      if (review.review_type !== 'service_used') return false;
      if (review.overall_rating < Number(minServiceRating)) return false;
    }
    if (minBookingRating) {
      if (review.review_type !== 'booking_not_completed') return false;
      if (review.overall_rating < Number(minBookingRating)) return false;
    }
    if (minQuoteRating) {
      if (review.review_type !== 'quote_request') return false;
      if (review.overall_rating < Number(minQuoteRating)) return false;
    }
    if (minCustomerServiceRating) {
      if (review.review_type !== 'customer_service') return false;
      if (review.overall_rating < Number(minCustomerServiceRating)) return false;
    }
    if (minProblemRating) {
      if (review.review_type !== 'problem_before_service') return false;
      if (review.overall_rating < Number(minProblemRating)) return false;
    }

    if (locationFilter.region) {
      const loc = review.registered_business_location || review.business_location || review.unclaimed_business_location;
      if (!loc || loc.region !== locationFilter.region) return false;
    }
    if (locationFilter.province) {
      const loc = review.registered_business_location || review.business_location || review.unclaimed_business_location;
      if (!loc || loc.province !== locationFilter.province) return false;
    }
    if (locationFilter.city) {
      const loc = review.registered_business_location || review.business_location || review.unclaimed_business_location;
      if (!loc || loc.city !== locationFilter.city) return false;
    }

    return true;
  });

  const hasActiveRatingFilters = minServiceRating || minBookingRating || minQuoteRating || minCustomerServiceRating || minProblemRating;

  const clearFilters = () => {
    setFilterStatus('all');
    setFilterReviewType('');
    setSearchNickname('');
    setSearchBusinessName('');
    setMinOverallRating('');
    setMinServiceRating('');
    setMinBookingRating('');
    setMinQuoteRating('');
    setMinCustomerServiceRating('');
    setMinProblemRating('');
    setLocationFilter({ region: '', province: '', city: '' });
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('it-IT', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  };

  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString('it-IT', {
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getBusinessName = (review: Review) => {
    if (review.registered_business_location) {
      return review.registered_business_location.parent_business?.name || review.registered_business?.name || review.registered_business_location.internal_name || review.registered_business_location.name || 'Attività';
    }
    if (review.registered_business) {
      return review.registered_business.name;
    }
    if (review.business_location) {
      return review.businesses?.name || review.business_location.internal_name || review.business_location.name || 'Attività';
    }
    if (review.unclaimed_business_location) {
      return review.unclaimed_business_location.name;
    }
    if (review.businesses) {
      return review.businesses.name;
    }
    return 'Attività non specificata';
  };

  const getLocationName = (review: Review): string | null => {
    if (review.registered_business_location) {
      const loc = review.registered_business_location;
      return loc.internal_name && loc.internal_name !== loc.name ? loc.internal_name : loc.city || null;
    }
    if (review.business_location) {
      const loc = review.business_location;
      return loc.internal_name || loc.city || null;
    }
    return null;
  };

  const getLocationInfo = (review: Review) => {
    if (review.registered_business_location) {
      return `${review.registered_business_location.street}, ${review.registered_business_location.city}`;
    }
    if (review.business_location) {
      return `${review.business_location.address}, ${review.business_location.city}`;
    }
    if (review.unclaimed_business_location) {
      return `${review.unclaimed_business_location.street}, ${review.unclaimed_business_location.city}`;
    }
    return 'Sede non specificata';
  };

  const getCategoryName = (review: Review): string | null => {
    if (review.registered_business_location?.category?.name) return review.registered_business_location.category.name;
    if (review.business_location?.category?.name) return review.business_location.category.name;
    if (review.unclaimed_business_location?.category?.name) return review.unclaimed_business_location.category.name;
    return null;
  };

  const reviewHasProof = (review: Review): boolean => {
    return !!(
      (review.proof_image_url && review.proof_image_url !== '') ||
      (review.proof_documents && review.proof_documents.length > 0)
    );
  };

  const getProofUrls = (review: Review): string[] => {
    const urls: string[] = [];
    if (review.proof_image_url) {
      urls.push(review.proof_image_url);
    }
    if (review.proof_documents && review.proof_documents.length > 0) {
      for (const doc of review.proof_documents) {
        if (doc.startsWith('http')) {
          urls.push(doc);
        } else {
          const { data } = supabase.storage.from('review-proof-documents').getPublicUrl(doc);
          urls.push(data.publicUrl);
        }
      }
    }
    return urls;
  };

  const approveReview = async (reviewId: string) => {
    try {
      const review = reviews.find(r => r.id === reviewId);
      if (!review) return;

      const hasProof = reviewHasProof(review);
      const pointsAwarded = hasProof ? 50 : 25;

      const { error } = await supabase.rpc('approve_review', {
        review_id_param: reviewId,
        staff_id_param: adminId,
      });

      if (error) throw error;

      showToast(`Recensione approvata con successo! ${pointsAwarded} punti assegnati.`, 'success');
      onReload();
      setSelectedReview(null);
    } catch (error: any) {
      console.error('Error approving review:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const approveReviewWithoutProof = async (reviewId: string) => {
    try {
      const review = reviews.find(r => r.id === reviewId);
      if (!review) return;

      await supabase
        .from('reviews')
        .update({ proof_image_url: null, proof_documents: null })
        .eq('id', reviewId);

      const { error } = await supabase.rpc('approve_review', {
        review_id_param: reviewId,
        staff_id_param: adminId,
      });

      if (error) throw error;

      showToast('Recensione approvata con 25 punti (prova rifiutata).', 'success');
      onReload();
      setSelectedReview(null);
    } catch (error: any) {
      console.error('Error approving review without proof:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const openRejectModal = (reviewId: string) => {
    setReviewToReject(reviewId);
    setRejectReason('');
    setShowRejectModal(true);
  };

  const startEditReview = (review: Review) => {
    setEditingReview(review);
    setEditForm({
      title: review.title,
      content: review.content,
      overall_rating: review.overall_rating,
      quality_rating: review.quality_rating,
      price_rating: review.price_rating,
      service_rating: review.service_rating,
    });
  };

  const cancelEditReview = () => {
    setEditingReview(null);
    setEditForm(null);
  };

  const saveReviewEdit = async () => {
    if (!editingReview || !editForm) return;

    try {
      const { error } = await supabase
        .from('reviews')
        .update({
          title: editForm.title,
          content: editForm.content,
          overall_rating: editForm.overall_rating,
          quality_rating: editForm.quality_rating,
          price_rating: editForm.price_rating,
          service_rating: editForm.service_rating,
        })
        .eq('id', editingReview.id);

      if (error) throw error;

      showToast('Recensione aggiornata con successo', 'success');
      setEditingReview(null);
      setEditForm(null);
      onReload();
      if (selectedReview?.id === editingReview.id) {
        setSelectedReview(null);
      }
    } catch (error: any) {
      console.error('Error updating review:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const confirmReject = async () => {
    if (!reviewToReject) return;

    if (!rejectReason.trim()) {
      showToast('Inserisci la motivazione del rifiuto', 'info');
      return;
    }

    try {
      const review = reviews.find(r => r.id === reviewToReject);

      const { error } = await supabase.rpc('reject_review', {
        review_id_param: reviewToReject,
        staff_id_param: adminId,
      });

      if (error) throw error;

      if (review) {
        const rejectUserId = review.customer_id || review.customer?.id;
        if (rejectUserId) {
          await supabase.rpc('send_notification', {
            target_user_id: rejectUserId,
            notif_type: 'review_rejected',
            notif_title: 'Recensione rifiutata',
            notif_message: `La tua recensione "${review.title}" è stata rifiutata. Motivazione: ${rejectReason}`,
            notif_data: {},
            target_family_member_id: review.family_member_id || null,
          });
        }
      }

      showToast('Recensione rifiutata.', 'info');
      setShowRejectModal(false);
      setRejectReason('');
      setReviewToReject(null);
      onReload();
      setSelectedReview(null);
    } catch (error: any) {
      console.error('Error rejecting review:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const counts = {
    all: reviews.length,
    pending: reviews.filter(r => r.review_status === 'pending').length,
    approved: reviews.filter(r => r.review_status === 'approved').length,
    rejected: reviews.filter(r => r.review_status === 'rejected').length,
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-2xl font-bold text-gray-900">Gestione Recensioni</h2>
        <button
          onClick={() => setShowFilters(!showFilters)}
          className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
        >
          <Filter className="w-5 h-5" />
          {showFilters ? 'Nascondi Filtri' : 'Mostra Filtri'}
        </button>
      </div>

      {/* Filtri rapidi per stato */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-2">
        <button
          onClick={() => setFilterStatus('all')}
          className={`rounded-xl border-2 p-4 text-left transition-all ${
            filterStatus === 'all'
              ? 'border-gray-700 bg-gray-700 text-white shadow-md'
              : 'border-gray-200 bg-white hover:border-gray-400 hover:shadow'
          }`}
        >
          <p className={`text-2xl font-bold mb-1 ${filterStatus === 'all' ? 'text-white' : 'text-gray-900'}`}>
            {counts.all}
          </p>
          <p className={`text-sm font-medium ${filterStatus === 'all' ? 'text-gray-200' : 'text-gray-500'}`}>
            Tutte
          </p>
        </button>

        <button
          onClick={() => setFilterStatus('pending')}
          className={`rounded-xl border-2 p-4 text-left transition-all ${
            filterStatus === 'pending'
              ? 'border-yellow-500 bg-yellow-500 text-white shadow-md'
              : 'border-yellow-200 bg-yellow-50 hover:border-yellow-400 hover:shadow'
          }`}
        >
          <p className={`text-2xl font-bold mb-1 ${filterStatus === 'pending' ? 'text-white' : 'text-yellow-700'}`}>
            {counts.pending}
          </p>
          <p className={`text-sm font-medium ${filterStatus === 'pending' ? 'text-yellow-100' : 'text-yellow-600'}`}>
            In attesa
          </p>
        </button>

        <button
          onClick={() => setFilterStatus('approved')}
          className={`rounded-xl border-2 p-4 text-left transition-all ${
            filterStatus === 'approved'
              ? 'border-green-600 bg-green-600 text-white shadow-md'
              : 'border-green-200 bg-green-50 hover:border-green-400 hover:shadow'
          }`}
        >
          <p className={`text-2xl font-bold mb-1 ${filterStatus === 'approved' ? 'text-white' : 'text-green-700'}`}>
            {counts.approved}
          </p>
          <p className={`text-sm font-medium ${filterStatus === 'approved' ? 'text-green-100' : 'text-green-600'}`}>
            Approvate
          </p>
        </button>

        <button
          onClick={() => setFilterStatus('rejected')}
          className={`rounded-xl border-2 p-4 text-left transition-all ${
            filterStatus === 'rejected'
              ? 'border-red-600 bg-red-600 text-white shadow-md'
              : 'border-red-200 bg-red-50 hover:border-red-400 hover:shadow'
          }`}
        >
          <p className={`text-2xl font-bold mb-1 ${filterStatus === 'rejected' ? 'text-white' : 'text-red-700'}`}>
            {counts.rejected}
          </p>
          <p className={`text-sm font-medium ${filterStatus === 'rejected' ? 'text-red-100' : 'text-red-600'}`}>
            Rifiutate
          </p>
        </button>
      </div>

      {showFilters && (
        <div className="bg-white rounded-lg shadow-lg p-6 mb-6">
          <div className="flex justify-between items-center mb-5">
            <h3 className="text-lg font-bold text-gray-900">Filtri di Ricerca</h3>
            <button
              onClick={clearFilters}
              className="flex items-center gap-2 text-red-600 hover:text-red-700 font-medium text-sm"
            >
              <X className="w-4 h-4" />
              Pulisci tutti
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                <Search className="w-4 h-4 inline mr-1" />
                Cerca per Nickname
              </label>
              <input
                type="text"
                value={searchNickname}
                onChange={(e) => setSearchNickname(e.target.value)}
                placeholder="Inserisci nickname..."
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                <Building2 className="w-4 h-4 inline mr-1" />
                Cerca per Nome Attivita'
              </label>
              <input
                type="text"
                value={searchBusinessName}
                onChange={(e) => setSearchBusinessName(e.target.value)}
                placeholder="Inserisci nome attivita'..."
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">Tipo di Esperienza</label>
              <select
                value={filterReviewType}
                onChange={(e) => setFilterReviewType(e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                {REVIEW_TYPE_OPTIONS.map(opt => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">Voto Generale Minimo</label>
              <select
                value={minOverallRating}
                onChange={(e) => setMinOverallRating(e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                {RATING_OPTIONS.map(opt => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </select>
            </div>
          </div>

          <div className="mt-4 pt-4 border-t border-gray-100">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              <MapPin className="w-4 h-4 inline mr-1" />
              Filtra per posizione attivita'
            </label>
            <AdminLocationFilter value={locationFilter} onChange={setLocationFilter} />
          </div>

          <div className="mt-5 border-t border-gray-100 pt-4">
            <button
              type="button"
              onClick={() => setShowRatingFilters(!showRatingFilters)}
              className="flex items-center gap-2 text-sm font-semibold text-gray-700 hover:text-blue-600 transition-colors"
            >
              {showRatingFilters ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
              Filtri per tipo di valutazione
              {hasActiveRatingFilters && (
                <span className="px-2 py-0.5 bg-orange-100 text-orange-700 text-xs rounded-full font-semibold">attivi</span>
              )}
            </button>

            {showRatingFilters && (
              <div className="mt-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
                <div className="bg-green-50 border border-green-200 rounded-lg p-3">
                  <p className="text-xs font-semibold text-green-800 mb-1">Servizio Fruito</p>
                  <p className="text-xs text-green-600 mb-2 leading-tight">Voto minimo per "Ho usufruito del servizio"</p>
                  <select
                    value={minServiceRating}
                    onChange={(e) => setMinServiceRating(e.target.value)}
                    className="w-full border border-green-300 rounded px-2 py-1.5 text-xs focus:ring-2 focus:ring-green-400 focus:border-transparent bg-white"
                  >
                    {RATING_OPTIONS.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
                  </select>
                </div>

                <div className="bg-red-50 border border-red-200 rounded-lg p-3">
                  <p className="text-xs font-semibold text-red-800 mb-1">Prenotazione Non Completata</p>
                  <p className="text-xs text-red-600 mb-2 leading-tight">Voto minimo per prenotazione</p>
                  <select
                    value={minBookingRating}
                    onChange={(e) => setMinBookingRating(e.target.value)}
                    className="w-full border border-red-300 rounded px-2 py-1.5 text-xs focus:ring-2 focus:ring-red-400 focus:border-transparent bg-white"
                  >
                    {RATING_OPTIONS.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
                  </select>
                </div>

                <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
                  <p className="text-xs font-semibold text-blue-800 mb-1">Preventivo / Info</p>
                  <p className="text-xs text-blue-600 mb-2 leading-tight">Voto minimo per preventivo</p>
                  <select
                    value={minQuoteRating}
                    onChange={(e) => setMinQuoteRating(e.target.value)}
                    className="w-full border border-blue-300 rounded px-2 py-1.5 text-xs focus:ring-2 focus:ring-blue-400 focus:border-transparent bg-white"
                  >
                    {RATING_OPTIONS.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
                  </select>
                </div>

                <div className="bg-teal-50 border border-teal-200 rounded-lg p-3">
                  <p className="text-xs font-semibold text-teal-800 mb-1">Assistenza Clienti</p>
                  <p className="text-xs text-teal-600 mb-2 leading-tight">Voto minimo per assistenza</p>
                  <select
                    value={minCustomerServiceRating}
                    onChange={(e) => setMinCustomerServiceRating(e.target.value)}
                    className="w-full border border-teal-300 rounded px-2 py-1.5 text-xs focus:ring-2 focus:ring-teal-400 focus:border-transparent bg-white"
                  >
                    {RATING_OPTIONS.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
                  </select>
                </div>

                <div className="bg-amber-50 border border-amber-200 rounded-lg p-3">
                  <p className="text-xs font-semibold text-amber-800 mb-1">Problema Pre-Servizio</p>
                  <p className="text-xs text-amber-600 mb-2 leading-tight">Voto minimo per problema</p>
                  <select
                    value={minProblemRating}
                    onChange={(e) => setMinProblemRating(e.target.value)}
                    className="w-full border border-amber-300 rounded px-2 py-1.5 text-xs focus:ring-2 focus:ring-amber-400 focus:border-transparent bg-white"
                  >
                    {RATING_OPTIONS.map(opt => <option key={opt.value} value={opt.value}>{opt.label}</option>)}
                  </select>
                </div>
              </div>
            )}
          </div>

          <div className="mt-4 pt-4 border-t border-gray-200">
            <p className="text-sm text-gray-600">
              <strong className="text-gray-900">{filteredReviews.length}</strong> recensioni trovate su <strong className="text-gray-900">{reviews.length}</strong> totali
            </p>
          </div>
        </div>
      )}

      {filteredReviews.length === 0 ? (
        <div className="bg-white rounded-lg shadow p-8 text-center">
          <Star className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <p className="text-gray-600">Nessuna recensione trovata</p>
        </div>
      ) : (
        <div className="grid gap-4">
          {filteredReviews.map((review) => (
            <div key={review.id} className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start mb-4">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <User className="w-5 h-5 text-gray-500" />
                    <h3 className="font-bold text-lg text-gray-900">{getReviewerName(review)}</h3>
                    <span
                      className={`px-3 py-1 text-xs rounded-full font-medium ${
                        review.review_status === 'approved'
                          ? 'bg-green-100 text-green-800'
                          : review.review_status === 'pending'
                          ? 'bg-yellow-100 text-yellow-800'
                          : 'bg-red-100 text-red-800'
                      }`}
                    >
                      {review.review_status === 'approved' ? 'Approvata' : review.review_status === 'pending' ? 'In attesa' : 'Rifiutata'}
                    </span>
                    {reviewHasProof(review) && (
                      <span className="flex items-center gap-1 px-2.5 py-1 text-xs rounded-full font-semibold bg-green-100 text-green-800 border border-green-300">
                        <Image className="w-3 h-3" />
                        Con prova
                      </span>
                    )}
                  </div>

                  <div className="flex items-center gap-4 text-sm text-gray-600 mb-2">
                    <div className="flex items-center gap-1">
                      <Calendar className="w-4 h-4" />
                      <span>{formatDate(review.created_at)}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      <span>{formatTime(review.created_at)}</span>
                    </div>
                  </div>

                  <div className="flex items-start gap-2 mb-2">
                    <Building2 className="w-5 h-5 text-blue-600 mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="font-semibold text-blue-900">{getBusinessName(review)}</p>
                      {getLocationName(review) && (
                        <p className="text-xs font-medium text-blue-700 mb-0.5">Sede: {getLocationName(review)}</p>
                      )}
                      <div className="flex items-center gap-1 text-sm text-gray-600">
                        <MapPin className="w-3 h-3" />
                        <span>{getLocationInfo(review)}</span>
                      </div>
                      {getCategoryName(review) && (
                        <div className="flex items-center gap-1 mt-1">
                          <Tag className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">{getCategoryName(review)}</span>
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <button
                    onClick={() => startEditReview(review)}
                    className="flex items-center gap-2 bg-amber-600 text-white px-4 py-2 rounded-lg hover:bg-amber-700 transition-colors"
                    title="Modifica recensione"
                  >
                    <Edit className="w-4 h-4" />
                    Modifica
                  </button>
                  <button
                    onClick={() => { setSelectedReview(review); setShowResponseExpanded(false); }}
                    className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    <Eye className="w-4 h-4" />
                    Visualizza
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modal Dettaglio Recensione — replica fedele del form utente */}
      {selectedReview && (() => {
        const proofUrls = getProofUrls(selectedReview);

        // Mappa tipo → config colore e label
        const typeConfig: Record<string, { label: string; icon: string; bg: string; border: string; text: string; badge: string }> = {
          service_used:           { label: 'Ho usufruito del servizio',               icon: '✓', bg: 'bg-green-50',  border: 'border-green-400',  text: 'text-green-800',  badge: 'bg-green-100 text-green-800 border-green-300' },
          booking_not_completed:  { label: 'Ho prenotato ma il servizio non si è svolto', icon: '✗', bg: 'bg-red-50',    border: 'border-red-400',    text: 'text-red-800',    badge: 'bg-red-100 text-red-800 border-red-300' },
          quote_request:          { label: 'Ho richiesto preventivo/informazioni',    icon: '?', bg: 'bg-blue-50',  border: 'border-blue-400',  text: 'text-blue-800',  badge: 'bg-blue-100 text-blue-800 border-blue-300' },
          customer_service:       { label: "Ho avuto un contatto con l'assistenza",   icon: '☎', bg: 'bg-teal-50',  border: 'border-teal-400',  text: 'text-teal-800',  badge: 'bg-teal-100 text-teal-800 border-teal-300' },
          problem_before_service: { label: "Ho avuto un problema prima dell'erogazione", icon: '⚠', bg: 'bg-amber-50', border: 'border-amber-400', text: 'text-amber-800', badge: 'bg-amber-100 text-amber-800 border-amber-300' },
        };
        const tc = selectedReview.review_type ? typeConfig[selectedReview.review_type] : null;

        // Valutazioni per tipo
        type RatingEntry = { label: string; value: number | null };
        const getRatings = (): RatingEntry[] => {
          switch (selectedReview.review_type) {
            case 'service_used': return [
              { label: 'Gestione Prenotazione', value: selectedReview.booking_management_rating },
              { label: 'Affidabilità',          value: selectedReview.reliability_rating },
              { label: 'Organizzazione',         value: selectedReview.organization_rating },
              { label: 'Esperienza/Servizio',    value: selectedReview.experience_rating },
              { label: 'Prezzo',                 value: selectedReview.price_rating },
            ];
            case 'booking_not_completed': return [
              { label: 'Gestione Prenotazione', value: selectedReview.booking_gestione_prenotazione },
              { label: 'Affidabilità',          value: selectedReview.booking_affidabilita },
              { label: 'Organizzazione',         value: selectedReview.booking_organizzazione },
              { label: 'Comunicazione',          value: selectedReview.booking_comunicazione },
            ];
            case 'quote_request': return [
              { label: 'Chiarezza',           value: selectedReview.quote_chiarezza },
              { label: 'Trasparenza',          value: selectedReview.quote_trasparenza },
              { label: 'Tempistiche Risposta', value: selectedReview.quote_tempistiche_risposta },
              { label: 'Disponibilità',        value: selectedReview.quote_disponibilita },
            ];
            case 'customer_service': return [
              { label: 'Cortesia',            value: selectedReview.cs_cortesia },
              { label: 'Competenza',          value: selectedReview.cs_competenza },
              { label: 'Rapidità',            value: selectedReview.cs_rapidita },
              { label: 'Risoluzione Problema', value: selectedReview.cs_risoluzione_problema },
            ];
            case 'problem_before_service': return [
              { label: 'Affidabilità',        value: selectedReview.problem_affidabilita },
              { label: 'Organizzazione',       value: selectedReview.problem_organizzazione },
              { label: 'Gestione Problema',    value: selectedReview.problem_gestione_problema },
              { label: 'Comunicazione',        value: selectedReview.problem_comunicazione },
            ];
            default: return [];
          }
        };
        const ratings = getRatings();
        const ratingLabel = (v: number) => ['', 'Pessimo', 'Discreto', 'Buono', 'Eccellente', 'Ottimo'][v] ?? '';

        const StarRow = ({ value, label }: { value: number | null; label: string }) => (
          <div className="mb-5">
            <label className="block text-sm font-medium text-gray-700 mb-2">{label}</label>
            <div className="flex items-center gap-1">
              {[1, 2, 3, 4, 5].map((s) => (
                <Star key={s} className={`w-8 h-8 ${s <= (value ?? 0) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
              ))}
              <span className="ml-2 text-sm text-gray-500">
                {value ? `${value}/5 — ${ratingLabel(value)}` : 'Non valutato'}
              </span>
            </div>
          </div>
        );

        return (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">

              {/* Header */}
              <div className="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex justify-between items-center rounded-t-xl z-10">
                <div>
                  <h2 className="text-xl font-bold text-gray-900">Scrivi una recensione</h2>
                  <p className="text-sm text-gray-500">{getBusinessName(selectedReview)}</p>
                </div>
                <button onClick={() => setSelectedReview(null)} className="text-gray-400 hover:text-gray-600 transition-colors">
                  <XCircle className="w-6 h-6" />
                </button>
              </div>

              <div className="px-6 py-5 space-y-0">

                {/* Intestazione admin: recensore + azienda + data */}
                <div className="mb-5 grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div className="bg-gray-50 rounded-lg px-4 py-3 flex items-start gap-3">
                    <User className="w-4 h-4 text-gray-500 mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-xs text-gray-500 font-medium uppercase tracking-wide mb-0.5">Recensore</p>
                      <p className="font-semibold text-gray-900 text-sm">{getReviewerName(selectedReview)}</p>
                      <p className="text-xs text-gray-500">{selectedReview.customer.email}</p>
                    </div>
                  </div>
                  <div className="bg-blue-50 rounded-lg px-4 py-3 flex items-start gap-3">
                    <Building2 className="w-4 h-4 text-blue-600 mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-xs text-blue-600 font-medium uppercase tracking-wide mb-0.5">Attività</p>
                      <p className="font-semibold text-blue-900 text-sm">{getBusinessName(selectedReview)}</p>
                      {getLocationName(selectedReview) && (
                        <p className="text-xs font-medium text-blue-700 mt-0.5">Sede: {getLocationName(selectedReview)}</p>
                      )}
                      <p className="text-xs text-gray-500 flex items-center gap-1 mt-0.5">
                        <MapPin className="w-3 h-3" />{getLocationInfo(selectedReview)}
                      </p>
                      {getCategoryName(selectedReview) && (
                        <p className="text-xs text-blue-700 flex items-center gap-1 mt-1">
                          <Tag className="w-3 h-3" />{getCategoryName(selectedReview)}
                        </p>
                      )}
                    </div>
                  </div>
                </div>

                {/* Step indicatori (visualizzazione statica) */}
                <div className="mb-6">
                  <div className="flex items-center justify-between mb-3">
                    {[1, 2, 3].map((s) => (
                      <div key={s} className="flex items-center flex-1">
                        <div className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold shrink-0 bg-orange-600 text-white">{s}</div>
                        {s < 3 && <div className="flex-1 h-1 mx-2 rounded bg-orange-600" />}
                      </div>
                    ))}
                  </div>
                  <div className="flex justify-between text-xs text-gray-500 px-0">
                    <span>Tipo esperienza</span>
                    <span className="text-center">Valutazione</span>
                    <span className="text-right">Descrizione</span>
                  </div>
                </div>

                {/* Step 1: Tipo esperienza */}
                <div className="mb-6">
                  <h3 className="font-semibold text-lg mb-4 text-gray-900">Che tipo di esperienza hai avuto?</h3>
                  {tc && (
                    <div className={`w-full p-4 border-2 rounded-xl ${tc.border} ${tc.bg}`}>
                      <div className="flex items-center gap-3">
                        <span className="text-xl w-8 text-center">{tc.icon}</span>
                        <span className={`font-medium ${tc.text}`}>{tc.label}</span>
                      </div>
                    </div>
                  )}
                  {!tc && (
                    <p className="text-sm text-gray-400 italic">Tipo non specificato</p>
                  )}
                </div>

                {/* Step 2: Valutazioni */}
                {ratings.length > 0 && (
                  <div className="mb-6">
                    <h3 className="font-semibold text-lg mb-5 text-gray-900">
                      {selectedReview.review_type === 'service_used' && 'Valuta il servizio ricevuto'}
                      {selectedReview.review_type === 'booking_not_completed' && 'Valuta la gestione della prenotazione'}
                      {selectedReview.review_type === 'quote_request' && 'Valuta la risposta al tuo preventivo'}
                      {selectedReview.review_type === 'customer_service' && "Valuta il contatto con l'assistenza"}
                      {selectedReview.review_type === 'problem_before_service' && 'Valuta la gestione del problema'}
                    </h3>
                    {ratings.map((r) => (
                      <StarRow key={r.label} value={r.value} label={r.label} />
                    ))}

                    {/* Media */}
                    {ratings.every(r => r.value) && (
                      <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg mb-2">
                        <p className="text-sm text-blue-900">
                          <strong>Media valutazioni:</strong>{' '}
                          {(ratings.reduce((s, r) => s + (r.value ?? 0), 0) / ratings.length).toFixed(1)} / 5.0
                          &nbsp;—&nbsp;
                          <strong>Voto generale archiviato:</strong> {selectedReview.overall_rating}/5 ({ratingLabel(selectedReview.overall_rating)})
                        </p>
                      </div>
                    )}

                    {/* Upload placeholder (documenti gia' allegati mostrati sotto) */}
                    <div className="mt-4">
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Carica documenti di prova <span className="text-gray-400">(facoltativo)</span>
                      </label>
                      {reviewHasProof(selectedReview) ? (
                        <div className="flex items-center gap-2 px-4 py-3 border-2 border-dashed border-green-400 rounded-lg bg-green-50">
                          <Image className="w-5 h-5 text-green-600" />
                          <span className="text-sm font-semibold text-green-800">
                            {proofUrls.length} {proofUrls.length === 1 ? 'documento allegato' : 'documenti allegati'}
                          </span>
                        </div>
                      ) : (
                        <div className="flex items-center gap-2 px-4 py-3 border-2 border-dashed border-gray-300 rounded-lg">
                          <Upload className="w-5 h-5 text-gray-400" />
                          <span className="text-sm text-gray-400">Nessun documento allegato</span>
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Step 3: Titolo e Descrizione */}
                <div className="mb-6">
                  <h3 className="font-semibold text-lg mb-4 text-gray-900">Descrivi la tua esperienza</h3>

                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Titolo <span className="text-gray-400 font-normal">(facoltativo)</span>
                    </label>
                    <div className="w-full px-3 py-2 border border-gray-200 rounded-lg bg-gray-50 text-gray-900">
                      {selectedReview.title || <span className="text-gray-400 italic">Nessun titolo</span>}
                    </div>
                  </div>

                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Descrizione <span className="text-red-500">*</span>
                    </label>
                    <div className="w-full px-3 py-2 border border-gray-200 rounded-lg bg-gray-50 text-gray-700 whitespace-pre-wrap min-h-[120px]">
                      {selectedReview.content}
                    </div>
                    <div className="flex justify-between text-xs mt-1">
                      <span className="text-gray-400">{selectedReview.content?.length ?? 0} caratteri</span>
                      {(selectedReview.content?.length ?? 0) >= 100 && (
                        <span className="text-green-600 font-medium">Requisito soddisfatto</span>
                      )}
                    </div>
                  </div>

                  {/* Punti stimati */}
                  <div className="bg-gradient-to-r from-green-50 to-blue-50 border border-green-200 rounded-lg p-4 mb-4">
                    <div className="flex items-center gap-2 mb-1">
                      <Star className="w-5 h-5 text-yellow-500 fill-yellow-500" />
                      <span className="font-semibold text-gray-900 text-sm">Punti stimati</span>
                    </div>
                    <div className="text-2xl font-bold text-green-600">
                      {reviewHasProof(selectedReview) ? 50 : 25} punti
                    </div>
                    <p className="text-xs text-gray-500 mt-1">
                      {reviewHasProof(selectedReview) ? 'Con prova documentale allegata' : 'Aggiungi un documento per guadagnare 50 punti'}
                    </p>
                  </div>
                </div>

                {/* Prove allegate (visibile solo admin) */}
                {reviewHasProof(selectedReview) && (
                  <div className="bg-gradient-to-br from-green-50 to-teal-50 border-2 border-green-400 rounded-lg p-5 mb-6">
                    <div className="flex items-center gap-2 mb-4">
                      <Image className="w-5 h-5 text-green-700" />
                      <span className="text-base font-bold text-green-900">Documenti di Prova Allegati</span>
                      <span className="ml-auto px-2.5 py-0.5 bg-green-200 text-green-800 text-xs font-bold rounded-full">
                        {proofUrls.length} {proofUrls.length === 1 ? 'documento' : 'documenti'}
                      </span>
                    </div>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      {proofUrls.map((url, idx) => (
                        <div key={idx} className="bg-white rounded-lg p-2 border border-green-200">
                          {url.match(/\.(jpg|jpeg|png|gif|webp)/i) ? (
                            <a href={url} target="_blank" rel="noopener noreferrer">
                              <img src={url} alt={`Prova ${idx + 1}`} className="w-full rounded-lg cursor-pointer hover:opacity-90 transition-opacity" />
                            </a>
                          ) : (
                            <a href={url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-3 p-3 hover:bg-gray-50 rounded-lg transition-colors">
                              <FileText className="w-8 h-8 text-green-600" />
                              <span className="text-sm font-medium text-green-800">Documento {idx + 1}</span>
                            </a>
                          )}
                        </div>
                      ))}
                    </div>
                    <p className="text-xs text-green-700 mt-3 italic">Clicca sulle immagini per aprirle a dimensione completa.</p>
                  </div>
                )}

                {/* Risposta dell'attività (collassabile) */}
                {selectedReview.responses && selectedReview.responses.length > 0 && (
                  <div className="mb-6">
                    <button
                      type="button"
                      onClick={() => setShowResponseExpanded(v => !v)}
                      className="w-full flex items-center justify-between px-4 py-3 bg-gray-100 hover:bg-gray-200 rounded-xl transition-colors border border-gray-200"
                    >
                      <div className="flex items-center gap-2">
                        <Building2 className="w-4 h-4 text-gray-600" />
                        <span className="text-sm font-semibold text-gray-700">Risposta dell'attività</span>
                        <span className="text-xs bg-gray-300 text-gray-700 px-2 py-0.5 rounded-full font-medium">
                          {selectedReview.responses.length}
                        </span>
                      </div>
                      {showResponseExpanded ? <ChevronUp className="w-4 h-4 text-gray-500" /> : <ChevronDown className="w-4 h-4 text-gray-500" />}
                    </button>
                    {showResponseExpanded && (
                      <div className="mt-2 space-y-2">
                        {selectedReview.responses.map((resp) => (
                          <div key={resp.id} className="pl-4 border-l-4 border-gray-300 bg-gray-50 rounded-r-xl py-3 pr-4">
                            <p className="text-sm text-gray-800 leading-relaxed">{resp.content}</p>
                            <p className="text-xs text-gray-400 mt-1">
                              {new Date(resp.created_at).toLocaleDateString('it-IT', { year: 'numeric', month: 'long', day: 'numeric' })}
                              {' alle '}
                              {new Date(resp.created_at).toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' })}
                            </p>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                )}

                {/* Stato badge */}
                <div className="flex items-center gap-2 mb-4">
                  <span className="text-sm font-medium text-gray-600">Stato:</span>
                  <span className={`px-3 py-1 text-xs rounded-full font-semibold ${
                    selectedReview.review_status === 'approved' ? 'bg-green-100 text-green-800' :
                    selectedReview.review_status === 'pending'  ? 'bg-yellow-100 text-yellow-800' :
                    'bg-red-100 text-red-800'
                  }`}>
                    {selectedReview.review_status === 'approved' ? 'Approvata' :
                     selectedReview.review_status === 'pending'  ? 'In attesa' : 'Rifiutata'}
                  </span>
                  <span className="ml-auto text-xs text-gray-400">{formatDate(selectedReview.created_at)} alle {formatTime(selectedReview.created_at)}</span>
                </div>

                {/* Azioni */}
                {selectedReview.review_status === 'pending' && (
                  <div className="space-y-3 pt-4 border-t">
                    <div className="flex gap-3">
                      <button
                        onClick={() => approveReview(selectedReview.id)}
                        className="flex-1 bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors flex items-center justify-center gap-2 font-semibold"
                      >
                        <CheckCircle className="w-5 h-5" />
                        Approva {reviewHasProof(selectedReview) ? '(50 punti con prova)' : '(25 punti)'}
                      </button>
                      <button
                        onClick={() => openRejectModal(selectedReview.id)}
                        className="flex-1 bg-red-600 text-white px-6 py-3 rounded-lg hover:bg-red-700 transition-colors flex items-center justify-center gap-2 font-semibold"
                      >
                        <XCircle className="w-5 h-5" />
                        Rifiuta Completamente
                      </button>
                    </div>
                    {reviewHasProof(selectedReview) && (
                      <div className="bg-yellow-50 border-2 border-yellow-400 rounded-lg p-4">
                        <p className="text-sm text-yellow-800 font-medium mb-3">
                          Se la prova non è valida ma la recensione è corretta, puoi approvarla comunque con 25 punti:
                        </p>
                        <button
                          onClick={() => approveReviewWithoutProof(selectedReview.id)}
                          className="w-full bg-yellow-600 text-white px-6 py-3 rounded-lg hover:bg-yellow-700 transition-colors flex items-center justify-center gap-2 font-semibold"
                        >
                          <CheckCircle className="w-5 h-5" />
                          Approva senza prova (25 punti)
                        </button>
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>
        );
      })()}

      {/* Modal Rifiuto con Motivazione */}
      {showRejectModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[60] p-4">
          <div className="bg-white rounded-xl shadow-xl max-w-md w-full">
            <div className="p-6">
              <h3 className="text-xl font-bold text-gray-900 mb-4">Rifiuta Recensione</h3>
              <p className="text-gray-600 mb-4">
                Inserisci la motivazione del rifiuto. L'utente riceverà una notifica con questa spiegazione.
              </p>
              <textarea
                value={rejectReason}
                onChange={(e) => setRejectReason(e.target.value)}
                placeholder="Es: La recensione contiene linguaggio inappropriato..."
                rows={4}
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-red-500 focus:border-transparent resize-none"
              />
              <div className="flex gap-3 mt-6">
                <button
                  onClick={confirmReject}
                  disabled={!rejectReason.trim()}
                  className="flex-1 bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors font-semibold disabled:bg-gray-400 disabled:cursor-not-allowed"
                >
                  Conferma Rifiuto
                </button>
                <button
                  onClick={() => {
                    setShowRejectModal(false);
                    setRejectReason('');
                    setReviewToReject(null);
                  }}
                  className="flex-1 bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
                >
                  Annulla
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal Modifica Recensione */}
      {editingReview && editForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-[70]">
          <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-amber-600 to-amber-700 px-6 py-4 flex items-center justify-between">
              <h3 className="text-xl font-bold text-white">Modifica Recensione</h3>
              <button
                onClick={cancelEditReview}
                className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              >
                <CloseIcon className="w-5 h-5 text-white" />
              </button>
            </div>

            <div className="p-6 space-y-4">
              {/* Info Recensore (sola lettura) */}
              <div className="bg-gray-50 rounded-lg p-4">
                <h4 className="font-semibold text-gray-900 mb-2">Informazioni Recensore</h4>
                <div className="text-sm space-y-1">
                  <p>
                    <span className="text-gray-600">Nome:</span>
                    <span className="ml-2 font-medium">{getReviewerName(editingReview)}</span>
                  </p>
                  <p>
                    <span className="text-gray-600">Email:</span>
                    <span className="ml-2 font-medium">{editingReview.customer.email}</span>
                  </p>
                  <p>
                    <span className="text-gray-600">Attività:</span>
                    <span className="ml-2 font-medium">{getBusinessName(editingReview)}</span>
                  </p>
                  <p>
                    <span className="text-gray-600">Data:</span>
                    <span className="ml-2 font-medium">
                      {formatDate(editingReview.created_at)} alle {formatTime(editingReview.created_at)}
                    </span>
                  </p>
                </div>
              </div>

              {/* Titolo */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Titolo Recensione *
                </label>
                <input
                  type="text"
                  value={editForm.title || ''}
                  onChange={(e) => setEditForm({ ...editForm, title: e.target.value })}
                  className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-amber-500 focus:border-transparent"
                  maxLength={100}
                />
              </div>

              {/* Contenuto */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Contenuto Recensione *
                </label>
                <textarea
                  value={editForm.content || ''}
                  onChange={(e) => setEditForm({ ...editForm, content: e.target.value })}
                  rows={6}
                  className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-amber-500 focus:border-transparent resize-none"
                />
              </div>

              {/* Valutazioni */}
              <div className="space-y-3">
                <h4 className="font-semibold text-gray-900">Valutazioni</h4>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    1. Qualità *
                  </label>
                  <select
                    value={editForm.quality_rating || ''}
                    onChange={(e) => setEditForm({ ...editForm, quality_rating: Number(e.target.value) })}
                    className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-amber-500 focus:border-transparent"
                  >
                    <option value="">Seleziona...</option>
                    <option value="1">⭐ Pessimo (1)</option>
                    <option value="2">⭐⭐ Discreto (2)</option>
                    <option value="3">⭐⭐⭐ Buono (3)</option>
                    <option value="4">⭐⭐⭐⭐ Eccellente (4)</option>
                    <option value="5">⭐⭐⭐⭐⭐ Ottimo (5)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    2. Prezzo *
                  </label>
                  <select
                    value={editForm.price_rating || ''}
                    onChange={(e) => setEditForm({ ...editForm, price_rating: Number(e.target.value) })}
                    className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-amber-500 focus:border-transparent"
                  >
                    <option value="">Seleziona...</option>
                    <option value="1">⭐ Pessimo (1)</option>
                    <option value="2">⭐⭐ Discreto (2)</option>
                    <option value="3">⭐⭐⭐ Buono (3)</option>
                    <option value="4">⭐⭐⭐⭐ Eccellente (4)</option>
                    <option value="5">⭐⭐⭐⭐⭐ Ottimo (5)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    3. Esperienza / Servizio *
                  </label>
                  <select
                    value={editForm.service_rating || ''}
                    onChange={(e) => setEditForm({ ...editForm, service_rating: Number(e.target.value) })}
                    className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-amber-500 focus:border-transparent"
                  >
                    <option value="">Seleziona...</option>
                    <option value="1">⭐ Pessimo (1)</option>
                    <option value="2">⭐⭐ Discreto (2)</option>
                    <option value="3">⭐⭐⭐ Buono (3)</option>
                    <option value="4">⭐⭐⭐⭐ Eccellente (4)</option>
                    <option value="5">⭐⭐⭐⭐⭐ Ottimo (5)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    4. Voto Generale *
                  </label>
                  <select
                    value={editForm.overall_rating || ''}
                    onChange={(e) => setEditForm({ ...editForm, overall_rating: Number(e.target.value) })}
                    className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-amber-500 focus:border-transparent"
                  >
                    <option value="">Seleziona...</option>
                    <option value="1">⭐ Pessimo (1)</option>
                    <option value="2">⭐⭐ Discreto (2)</option>
                    <option value="3">⭐⭐⭐ Buono (3)</option>
                    <option value="4">⭐⭐⭐⭐ Eccellente (4)</option>
                    <option value="5">⭐⭐⭐⭐⭐ Ottimo (5)</option>
                  </select>
                </div>
              </div>

              {/* Stato Recensione (sola lettura) */}
              <div className="bg-gray-50 rounded-lg p-4">
                <h4 className="font-semibold text-gray-900 mb-2">Stato</h4>
                <span
                  className={`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${
                    editingReview.review_status === 'approved'
                      ? 'bg-green-100 text-green-700'
                      : editingReview.review_status === 'rejected'
                      ? 'bg-red-100 text-red-700'
                      : 'bg-yellow-100 text-yellow-700'
                  }`}
                >
                  {editingReview.review_status === 'approved'
                    ? 'Approvata'
                    : editingReview.review_status === 'rejected'
                    ? 'Rifiutata'
                    : 'In Attesa'}
                </span>
              </div>
            </div>

            <div className="sticky bottom-0 bg-gray-50 px-6 py-4 flex justify-end gap-3 border-t border-gray-200">
              <button
                onClick={cancelEditReview}
                className="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition-colors font-medium"
              >
                Annulla
              </button>
              <button
                onClick={saveReviewEdit}
                disabled={!editForm.title || !editForm.content || !editForm.overall_rating}
                className="px-6 py-2 bg-amber-600 text-white rounded-lg hover:bg-amber-700 transition-colors font-medium flex items-center gap-2 disabled:bg-gray-400 disabled:cursor-not-allowed"
              >
                <Save className="w-4 h-4" />
                Salva Modifiche
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
