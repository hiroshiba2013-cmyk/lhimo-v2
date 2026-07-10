import { useState } from 'react';
import { Star, MapPin, MessageSquare, Phone, Mail, Clock, Globe, Instagram, Facebook } from 'lucide-react';
import { ReviewForm } from '../reviews/ReviewForm';
import { useAuth } from '../../contexts/AuthContext';
import { VerificationBadge } from './VerificationBadge';
import { FavoriteButton } from '../favorites/FavoriteButton';
import ReportButton from '../moderation/ReportButton';

function PartialStars({ rating, size = 16 }: { rating: number; size?: number }) {
  return (
    <div className="flex items-center gap-0.5">
      {[1, 2, 3, 4, 5].map((star) => {
        const fill = Math.min(1, Math.max(0, rating - (star - 1)));
        const uid = `star-${star}-${Math.round(rating * 10)}`;
        return (
          <svg key={star} width={size} height={size} viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <defs>
              <clipPath id={uid}>
                <rect x="0" y="0" width={24 * fill} height="24" />
              </clipPath>
            </defs>
            {/* empty star */}
            <polygon
              points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"
              fill="#e5e7eb"
              stroke="#e5e7eb"
              strokeWidth="1"
            />
            {/* filled star (clipped) */}
            <polygon
              points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"
              fill="#22c55e"
              stroke="#22c55e"
              strokeWidth="1"
              clipPath={`url(#${uid})`}
            />
          </svg>
        );
      })}
    </div>
  );
}

interface BusinessLocation {
  id: string;
  business_id: string;
  name: string | null;
  location_label?: string | null;
  address: string;
  city: string;
  province: string;
  region: string;
  postal_code: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  business_hours: any;
  avatar_url: string | null;
  is_claimed: boolean;
  verification_badge: boolean;
  description?: string | null;
  business?: {
    id: string;
    name: string;
    category_id: string;
    verified: boolean;
    category?: {
      id: string;
      name: string;
      icon: string;
    };
  };
  added_by?: string | null;
  source?: string | null;
  location_type?: string | null;
  category_name?: string | null;
  avg_rating?: number;
  review_count?: number;
  service_avg_rating?: number;
  service_review_count?: number;
  management_avg_rating?: number;
  management_review_count?: number;
  instagram_url?: string | null;
  facebook_url?: string | null;
  tiktok_url?: string | null;
}

interface OpeningHours {
  [key: string]: { open: string; close: string } | null;
}

interface LocationCardProps {
  location: BusinessLocation;
  initialIsFavorite?: boolean;
  onFavoriteToggle?: (locationId: string, isFavorite: boolean) => void;
}

const DAY_NAMES: { [key: string]: string } = {
  'monday': 'Lunedì',
  'tuesday': 'Martedì',
  'wednesday': 'Mercoledì',
  'thursday': 'Giovedì',
  'friday': 'Venerdì',
  'saturday': 'Sabato',
  'sunday': 'Domenica'
};

function formatBusinessHours(hours: any): string | null {
  if (!hours || typeof hours !== 'object') return null;

  const today = new Date().toLocaleDateString('en-US', { weekday: 'long' }).toLowerCase();
  const todayHours = hours[today];

  if (!todayHours) return null;

  if (todayHours.closed === true) {
    return 'Chiuso oggi';
  }

  if (todayHours.open && todayHours.close) {
    return `Oggi: ${todayHours.open} - ${todayHours.close}`;
  }

  return null;
}

function hasValidBusinessHours(hours: any): boolean {
  if (!hours || typeof hours !== 'object') return false;

  const daysOfWeek = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

  return daysOfWeek.some(day => {
    const dayHours = hours[day];
    return dayHours && dayHours.open && dayHours.close;
  });
}

export function LocationCard({ location, initialIsFavorite, onFavoriteToggle }: LocationCardProps) {
  const { profile, activeProfile } = useAuth();
  const [showReviewForm, setShowReviewForm] = useState(false);

  const canWriteReview = profile && profile.user_type === 'customer' && (profile.subscription_status === 'active' || profile.subscription_status === 'trial');
  const isCustomer = profile && profile.user_type === 'customer';
  const familyMemberId = activeProfile?.isOwner === false ? activeProfile?.id : null;

  const favoriteBusinessColumn: 'unclaimed' | 'registered' | 'registered_no_location' | 'legacy' =
    (location.source === 'unclaimed' || location.source === 'user_added' || location.source === 'imported' || location.location_type === 'unclaimed')
      ? 'unclaimed'
      : location.location_type === 'registered_no_location'
      ? 'registered_no_location'
      : 'registered';

  const handleReviewClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    e.preventDefault();
    setShowReviewForm(true);
  };

  const handleCardClick = (e: React.MouseEvent) => {
    if (e.target !== e.currentTarget && (e.target as HTMLElement).closest('button, a')) {
      return;
    }
    e.preventDefault();
    e.stopPropagation();

    const isUnclaimed = location.source === 'unclaimed' || location.source === 'user_added' || location.source === 'imported' || location.location_type === 'unclaimed';

    let url: string;
    if (isUnclaimed) {
      url = `/business/unclaimed/${location.id}`;
    } else if (location.business_id) {
      url = `/business/${location.business_id}?locationId=${location.id}`;
    } else {
      url = `/business/${location.id}`;
    }

    sessionStorage.setItem('searchReturnUrl', window.location.pathname + window.location.search);
    sessionStorage.setItem('searchScrollPosition', window.scrollY.toString());
    window.history.pushState({}, '', url);
    window.dispatchEvent(new PopStateEvent('popstate'));
  };

  const displayName = location.name || location.business?.name || 'Attività';
  const locationLabel = location.location_label || '';
  const hoursText = formatBusinessHours(location.business_hours);

  return (
    <div
      onClick={handleCardClick}
      className="bg-white rounded-xl shadow-sm hover:shadow-md transition-all cursor-pointer overflow-hidden border border-gray-100"
    >
      <div className="relative h-48 bg-gradient-to-br from-blue-100 to-blue-50 flex items-center justify-center">
        {location.avatar_url ? (
          <img src={location.avatar_url} alt={displayName} className="w-full h-full object-cover" />
        ) : (
          <div className="text-6xl font-bold text-blue-200">
            {displayName.charAt(0).toUpperCase()}
          </div>
        )}

        {/* Quick-action overlay buttons */}
        <div className="absolute top-2 right-2 flex flex-col gap-1.5" onClick={(e) => e.stopPropagation()}>
          {isCustomer && (
            <FavoriteButton
              type="business"
              itemId={location.id}
              familyMemberId={familyMemberId}
              businessColumn={favoriteBusinessColumn}
              initialIsFavorite={initialIsFavorite}
              onToggle={(isFav) => onFavoriteToggle?.(location.id, isFav)}
              className="!px-2 !py-2 bg-white/90 backdrop-blur-sm shadow-sm hover:bg-white border-0 rounded-lg"
            />
          )}
          {profile && (
            <div className="px-2 py-2 bg-white/90 backdrop-blur-sm shadow-sm hover:bg-white rounded-lg transition-colors [&_button]:!text-gray-500 [&_button:hover]:!text-red-500">
              <ReportButton entityType="business" entityId={location.id} compact={true} />
            </div>
          )}
        </div>
      </div>

      <div className="p-6">
        <div className="flex items-start justify-between mb-1 gap-2">
          <div className="flex-1">
            <h3 className="text-xl font-semibold text-gray-900">{displayName}</h3>
            {locationLabel && (
              <p className="text-sm text-gray-500 mt-0.5">{locationLabel}</p>
            )}
          </div>
          <VerificationBadge
            isClaimed={!!location.is_claimed}
            isImported={!location.is_claimed && !location.added_by && location.location_type === 'unclaimed'}
            isUserAdded={!!location.added_by && !location.is_claimed}
            size="sm"
          />
        </div>

        <div className="mb-3">
          <span className="inline-flex items-center gap-1.5 px-3 py-1 bg-blue-50 border border-blue-200 text-blue-700 text-sm rounded-full font-semibold">
            {location.category_name || location.business?.category?.name || 'Categoria non disponibile'}
          </span>
        </div>

        <div className="flex flex-wrap items-center gap-2 mb-3">
          {(location.review_count || 0) > 0 ? (
            <div className="w-full">
              <div className="flex items-center gap-2 mb-1.5">
                <PartialStars rating={location.avg_rating || 0} size={16} />
                <span className="font-bold text-sm text-gray-900">{(location.avg_rating || 0).toFixed(1)}</span>
                <span className="text-xs text-gray-500">
                  · {location.review_count} {location.review_count === 1 ? 'recensione' : 'recensioni'}
                </span>
              </div>
              <div className="flex flex-wrap gap-1.5">
                {(location.service_review_count || 0) > 0 && (
                  <div className="flex items-center gap-1 px-2 py-0.5 bg-blue-50 rounded-full border border-blue-200" title="Media servizi usufruiti">
                    <Star className="w-3 h-3 fill-blue-400 text-blue-400" />
                    <span className="text-xs font-semibold text-blue-700">{(location.service_avg_rating || 0).toFixed(1)}</span>
                    <span className="text-xs text-blue-500">serv.</span>
                  </div>
                )}
                {(location.management_review_count || 0) > 0 && (
                  <div className="flex items-center gap-1 px-2 py-0.5 bg-green-50 rounded-full border border-green-200" title="Media gestione/preventivi/assistenza">
                    <Star className="w-3 h-3 fill-green-400 text-green-400" />
                    <span className="text-xs font-semibold text-green-700">{(location.management_avg_rating || 0).toFixed(1)}</span>
                    <span className="text-xs text-green-500">gest.</span>
                  </div>
                )}
              </div>
            </div>
          ) : (
            <span className="text-xs text-gray-400 italic">Nessuna recensione ancora</span>
          )}
        </div>

        {location.description && (
          <p className="text-sm text-gray-600 mb-4 line-clamp-2">
            {location.description}
          </p>
        )}

        <div className="space-y-2 mb-4">
          <div className="flex items-start gap-2 text-sm text-gray-700">
            <MapPin className="w-4 h-4 mt-0.5 flex-shrink-0 text-blue-600" />
            <span className="font-medium">{location.address}, {location.city} ({location.province})</span>
          </div>

          {hasValidBusinessHours(location.business_hours) && hoursText && (
            <div className="flex items-center gap-2 text-sm text-gray-700">
              <Clock className="w-4 h-4 flex-shrink-0 text-green-600" />
              <span className="font-medium">{hoursText}</span>
            </div>
          )}

          {location.website && (
            <div className="flex items-center gap-2 text-sm">
              <Globe className="w-4 h-4 flex-shrink-0 text-blue-600" />
              <a
                href={location.website}
                target="_blank"
                rel="noopener noreferrer"
                onClick={(e) => e.stopPropagation()}
                className="text-blue-600 hover:text-blue-700 hover:underline font-medium truncate"
              >
                Visita il sito web
              </a>
            </div>
          )}

          {location.phone && (
            <div className="flex items-center gap-2 text-sm text-gray-700">
              <Phone className="w-4 h-4 flex-shrink-0 text-blue-600" />
              <a
                href={`tel:${location.phone}`}
                onClick={(e) => e.stopPropagation()}
                className="font-medium hover:text-blue-600"
              >
                {location.phone}
              </a>
            </div>
          )}

          {location.email && (
            <div className="flex items-center gap-2 text-sm text-gray-700">
              <Mail className="w-4 h-4 flex-shrink-0 text-blue-600" />
              <a
                href={`mailto:${location.email}`}
                onClick={(e) => e.stopPropagation()}
                className="font-medium hover:text-blue-600 truncate"
              >
                {location.email}
              </a>
            </div>
          )}

          <div className="flex items-center gap-3 pt-1">
            {location.instagram_url ? (
              <a
                href={location.instagram_url}
                target="_blank"
                rel="noopener noreferrer"
                onClick={(e) => e.stopPropagation()}
                title="Instagram"
                className="text-pink-500 hover:text-pink-600 transition-colors"
              >
                <Instagram className="w-4 h-4" />
              </a>
            ) : (
              <span title="Instagram non disponibile" className="text-gray-300 cursor-default">
                <Instagram className="w-4 h-4" />
              </span>
            )}
            {location.facebook_url ? (
              <a
                href={location.facebook_url}
                target="_blank"
                rel="noopener noreferrer"
                onClick={(e) => e.stopPropagation()}
                title="Facebook"
                className="text-blue-600 hover:text-blue-700 transition-colors"
              >
                <Facebook className="w-4 h-4" />
              </a>
            ) : (
              <span title="Facebook non disponibile" className="text-gray-300 cursor-default">
                <Facebook className="w-4 h-4" />
              </span>
            )}
            {location.tiktok_url ? (
              <a
                href={location.tiktok_url}
                target="_blank"
                rel="noopener noreferrer"
                onClick={(e) => e.stopPropagation()}
                title="TikTok"
                className="text-gray-800 hover:text-gray-900 transition-colors"
              >
                <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.97a8.27 8.27 0 004.84 1.55V7.07a4.85 4.85 0 01-1.07-.38z"/></svg>
              </a>
            ) : (
              <span title="TikTok non disponibile" className="text-gray-300 cursor-default">
                <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.97a8.27 8.27 0 004.84 1.55V7.07a4.85 4.85 0 01-1.07-.38z"/></svg>
              </span>
            )}
          </div>
        </div>

        {canWriteReview && (
          <div className="pt-4 border-t border-gray-100">
            <button
              onClick={handleReviewClick}
              className="w-full flex items-center justify-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors font-semibold text-sm"
            >
              <MessageSquare className="w-4 h-4" />
              Scrivi una recensione
            </button>
          </div>
        )}
      </div>

      {showReviewForm && location.business_id && (
        <ReviewForm
          businessId={location.business_id}
          businessLocationId={location.id}
          onClose={() => setShowReviewForm(false)}
          onSuccess={() => {
            setShowReviewForm(false);
            window.dispatchEvent(new PopStateEvent('popstate'));
          }}
        />
      )}
    </div>
  );
}
