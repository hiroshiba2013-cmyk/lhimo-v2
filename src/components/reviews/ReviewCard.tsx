import { useState } from 'react';
import { Star, Clock, CheckCircle, MapPin, FileText, User, Tag, ChevronDown, ChevronUp, Building2 } from 'lucide-react';
import { Review } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import ReportButton from '../moderation/ReportButton';

interface ReviewCardProps {
  review: Review;
  hideProof?: boolean;
}

const reviewTypeConfig: Record<string, { label: string; icon: string; bg: string; border: string; pill: string }> = {
  service_used:           { label: 'Servizio Fruito',              icon: '✓', bg: 'from-emerald-50 to-green-50',   border: 'border-emerald-200', pill: 'bg-emerald-100 text-emerald-800' },
  booking_not_completed:  { label: 'Prenotazione Non Completata',  icon: '✗', bg: 'from-red-50 to-rose-50',         border: 'border-red-200',     pill: 'bg-red-100 text-red-800' },
  quote_request:          { label: 'Richiesta Preventivo',         icon: '?', bg: 'from-blue-50 to-sky-50',         border: 'border-blue-200',    pill: 'bg-blue-100 text-blue-800' },
  customer_service:       { label: 'Assistenza Clienti',           icon: '☎', bg: 'from-teal-50 to-cyan-50',        border: 'border-teal-200',    pill: 'bg-teal-100 text-teal-800' },
  problem_before_service: { label: 'Problema Pre-Servizio',        icon: '⚠', bg: 'from-amber-50 to-yellow-50',     border: 'border-amber-200',   pill: 'bg-amber-100 text-amber-800' },
};

const TYPE_CRITERIA: Record<string, { label: string; field: string }[]> = {
  service_used: [
    { label: 'Gestione Prenotazione', field: 'booking_management_rating' },
    { label: 'Affidabilità', field: 'reliability_rating' },
    { label: 'Organizzazione', field: 'organization_rating' },
    { label: 'Esperienza/Servizio', field: 'experience_rating' },
    { label: 'Prezzo', field: 'price_rating' },
  ],
  booking_not_completed: [
    { label: 'Gestione Prenotazione', field: 'booking_gestione_prenotazione' },
    { label: 'Affidabilità', field: 'booking_affidabilita' },
    { label: 'Organizzazione', field: 'booking_organizzazione' },
    { label: 'Comunicazione', field: 'booking_comunicazione' },
  ],
  quote_request: [
    { label: 'Chiarezza', field: 'quote_chiarezza' },
    { label: 'Trasparenza', field: 'quote_trasparenza' },
    { label: 'Tempistiche Risposta', field: 'quote_tempistiche_risposta' },
    { label: 'Disponibilità', field: 'quote_disponibilita' },
  ],
  customer_service: [
    { label: 'Cortesia', field: 'cs_cortesia' },
    { label: 'Competenza', field: 'cs_competenza' },
    { label: 'Rapidità', field: 'cs_rapidita' },
    { label: 'Risoluzione Problema', field: 'cs_risoluzione_problema' },
  ],
  problem_before_service: [
    { label: 'Affidabilità', field: 'problem_affidabilita' },
    { label: 'Organizzazione', field: 'problem_organizzazione' },
    { label: 'Gestione Problema', field: 'problem_gestione_problema' },
    { label: 'Comunicazione', field: 'problem_comunicazione' },
  ],
};

export function ReviewCard({ review, hideProof = false }: ReviewCardProps) {
  const { user } = useAuth();
  const [responseExpanded, setResponseExpanded] = useState(false);
  const isOwnReview = user?.id === review.customer_id;

  const formatDate = (date: string) =>
    new Date(date).toLocaleDateString('it-IT', { year: 'numeric', month: 'long', day: 'numeric' });

  const getRatingLabel = (rating: number) =>
    ['', 'Pessimo', 'Discreto', 'Buono', 'Eccellente', 'Ottimo'][Math.round(rating)] ?? '';

  const renderStars = (rating: number, size: 'xs' | 'sm' | 'md' = 'sm') => {
    const sz = { xs: 'w-3 h-3', sm: 'w-4 h-4', md: 'w-5 h-5' }[size];
    return (
      <div className="flex">
        {[...Array(5)].map((_, i) => (
          <Star key={i} className={`${sz} ${i < Math.round(rating) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-200'}`} />
        ))}
      </div>
    );
  };

  const reviewType = (review as any).review_type as string | undefined;
  const tc = reviewType ? reviewTypeConfig[reviewType] : null;
  const criteria = reviewType ? TYPE_CRITERIA[reviewType] : null;
  const hasCriteriaRatings = criteria?.some(c => (review as any)[c.field] > 0);
  const proofDocs: string[] = (review as any).proof_documents ?? [];

  const reviewerName = review.family_member
    ? review.family_member.nickname
    : review.customer?.nickname || review.customer?.full_name;

  return (
    <div className={`relative bg-white rounded-2xl border shadow-sm overflow-hidden transition-shadow hover:shadow-md ${tc?.border ?? 'border-gray-100'}`}>

      {/* Accent strip top */}
      {tc && (
        <div className={`h-1 w-full bg-gradient-to-r ${tc.bg}`} />
      )}

      <div className="p-5">
        {/* Row 1: reviewer + date + status badges */}
        <div className="flex items-start justify-between gap-3 mb-4">
          <div className="flex items-center gap-3 min-w-0">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-gray-700 to-gray-900 flex items-center justify-center flex-shrink-0">
              <User className="w-5 h-5 text-white" />
            </div>
            <div className="min-w-0">
              <p className="font-semibold text-gray-900 text-sm truncate">{reviewerName ?? 'Utente'}</p>
              <p className="text-xs text-gray-400">{formatDate(review.created_at)}</p>
            </div>
          </div>
          <div className="flex flex-wrap items-center gap-1.5 flex-shrink-0">
            {tc && (
              <span className={`inline-flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full ${tc.pill}`}>
                <span>{tc.icon}</span>
                {tc.label}
              </span>
            )}
            {isOwnReview && review.review_status === 'pending' && (
              <span className="flex items-center gap-1 text-xs bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full">
                <Clock className="w-3 h-3" />
                In attesa
              </span>
            )}
            {review.review_status === 'approved' && review.points_awarded > 0 && (
              <span className="flex items-center gap-1 text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full font-semibold">
                <CheckCircle className="w-3 h-3" />
                +{review.points_awarded} pt
              </span>
            )}
          </div>
        </div>

        {/* Overall rating prominent */}
        <div className="flex items-center gap-2 mb-4">
          {renderStars(review.overall_rating, 'md')}
          <span className="text-2xl font-black text-gray-900 leading-none">{(review.overall_rating || 0).toFixed(1)}</span>
          <span className="text-sm font-medium text-gray-500">{getRatingLabel(review.overall_rating)}</span>
        </div>

        {/* Category badge */}
        {(review as any).category_name && (
          <div className="flex items-center gap-1.5 mb-3">
            <Tag className="w-3.5 h-3.5 text-gray-400 flex-shrink-0" />
            <span className="text-xs font-medium text-gray-600 bg-gray-100 px-2.5 py-1 rounded-full">
              {(review as any).category_name}
            </span>
          </div>
        )}

        {/* Business / location info */}
        {(() => {
          const r = review as any;
          const bizName =
            r.business?.name ||
            r.unclaimed_business?.name ||
            r.rbl?.rb?.name ||
            r.registered_business?.name ||
            r.location_info?.name ||
            null;
          if (!bizName) return null;
          return (
            <div className="flex items-center gap-1.5 mb-3 px-3 py-2 bg-amber-50 border border-amber-100 rounded-xl">
              <MapPin className="w-3.5 h-3.5 text-amber-500 flex-shrink-0" />
              <p className="text-xs text-gray-700 truncate">
                <span className="text-amber-600 font-semibold text-xs mr-1">Recensione per:</span>
                <span className="font-bold text-gray-900">{bizName}</span>
                {r.location_info?.city && <span className="text-gray-500"> &mdash; {r.location_info.city}</span>}
              </p>
            </div>
          );
        })()}

        {/* Title */}
        {review.title && (
          <h4 className="font-bold text-gray-900 text-base mb-2">{review.title}</h4>
        )}

        {/* Content */}
        <p className="text-gray-600 text-sm leading-relaxed mb-4">{review.content}</p>

        {/* Criteria ratings grid */}
        {hasCriteriaRatings && criteria && (
          <div className={`rounded-xl border p-4 mb-4 bg-gradient-to-br ${tc?.bg ?? 'from-gray-50 to-gray-50'} ${tc?.border ?? 'border-gray-100'}`}>
            <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-3">Valutazioni dettagliate</p>
            <div className="grid grid-cols-2 gap-x-4 gap-y-3">
              {criteria.map((c) => {
                const val = (review as any)[c.field];
                if (!val || val === 0) return null;
                return (
                  <div key={c.field} className="flex items-center justify-between gap-2">
                    <span className="text-xs text-gray-600 truncate">{c.label}</span>
                    <div className="flex items-center gap-1 flex-shrink-0">
                      {renderStars(val, 'xs')}
                      <span className="text-xs font-bold text-gray-700">{val}</span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Proof documents indicator — hidden for business owners */}
        {proofDocs.length > 0 && !hideProof && (
          <div className="flex items-center gap-2 mb-4 px-3 py-2 bg-blue-50 border border-blue-100 rounded-lg">
            <FileText className="w-4 h-4 text-blue-500 flex-shrink-0" />
            <span className="text-xs font-semibold text-blue-800">
              Documentazione fornita
            </span>
            <span className="text-xs text-blue-600 ml-auto">
              {proofDocs.length} {proofDocs.length === 1 ? 'documento' : 'documenti'}
            </span>
          </div>
        )}

        {/* Business response (collapsible) */}
        {review.responses && review.responses.length > 0 && (
          <div className="mt-3">
            <button
              type="button"
              onClick={() => setResponseExpanded(v => !v)}
              className="w-full flex items-center justify-between px-3 py-2 bg-gray-100 hover:bg-gray-200 rounded-xl transition-colors border border-gray-200"
            >
              <div className="flex items-center gap-2">
                <Building2 className="w-3.5 h-3.5 text-gray-500" />
                <span className="text-xs font-semibold text-gray-600">Risposta dell'attività</span>
              </div>
              {responseExpanded ? <ChevronUp className="w-3.5 h-3.5 text-gray-400" /> : <ChevronDown className="w-3.5 h-3.5 text-gray-400" />}
            </button>
            {responseExpanded && (
              <div className="mt-1.5 pl-4 border-l-2 border-gray-300 bg-gray-50 rounded-r-xl py-3 pr-3">
                <p className="text-sm text-gray-700 leading-relaxed">{review.responses[0].content}</p>
                <p className="text-xs text-gray-400 mt-1">{formatDate(review.responses[0].created_at)}</p>
              </div>
            )}
          </div>
        )}

        {/* Report button */}
        {!isOwnReview && (
          <div className="mt-4 pt-3 border-t border-gray-100 flex justify-end">
            <ReportButton entityType="review" entityId={review.id} />
          </div>
        )}
      </div>
    </div>
  );
}
