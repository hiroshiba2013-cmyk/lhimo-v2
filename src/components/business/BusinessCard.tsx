import { useState } from 'react';
import { Star, MapPin, ExternalLink, MessageSquare, Building2 } from 'lucide-react';
import { Business } from '../../lib/supabase';
import { ReviewForm } from '../reviews/ReviewForm';
import { useAuth } from '../../contexts/AuthContext';
import { VerificationBadge } from './VerificationBadge';
import { useNavigate } from '../Router';
import { FavoriteButton } from '../favorites/FavoriteButton';
import ReportButton from '../moderation/ReportButton';

interface BusinessCardProps {
  business: Business & {
    avg_rating?: number;
    review_count?: number;
    location_count?: number;
    cities?: string[];
    main_location?: {
      avatar_url?: string | null;
      address?: string;
      city?: string;
    };
    added_by?: string | null;
    source?: string | null;
    owner_id?: string | null;
    location_type?: string | null;
  };
}

export function BusinessCard({ business }: BusinessCardProps) {
  const { profile, activeProfile } = useAuth();
  const navigate = useNavigate();
  const [showReviewForm, setShowReviewForm] = useState(false);

  const canWriteReview = profile && profile.user_type === 'customer' && (profile.subscription_status === 'active' || profile.subscription_status === 'trial');
  const isCustomer = profile && profile.user_type === 'customer';
  const familyMemberId = activeProfile?.isOwner === false ? activeProfile?.id : null;

  // Determine favorite column based on source/location_type from search results
  const favoriteBusinessColumn = (business.source === 'imported' || business.source === 'user_added')
    ? 'unclaimed'
    : business.location_type === 'registered_no_location'
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
    sessionStorage.setItem('searchReturnUrl', window.location.pathname + window.location.search);
    sessionStorage.setItem('searchScrollPosition', window.scrollY.toString());
    navigate(`/business/${business.id}`);
  };

  const avatarUrl = business.main_location?.avatar_url || business.logo_url;

  return (
    <div
      onClick={handleCardClick}
      className="bg-white rounded-xl shadow-sm hover:shadow-md transition-all cursor-pointer overflow-hidden border border-gray-100"
    >
      <div className="relative h-48 bg-gradient-to-br from-blue-100 to-blue-50 flex items-center justify-center">
        {avatarUrl ? (
          <img src={avatarUrl} alt={business.name} className="w-full h-full object-cover" />
        ) : (
          <div className="text-6xl font-bold text-blue-200">
            {business.name.charAt(0).toUpperCase()}
          </div>
        )}

        {/* Quick-action overlay buttons */}
        <div className="absolute top-2 right-2 flex flex-col gap-1.5" onClick={(e) => e.stopPropagation()}>
          {isCustomer && (
            <FavoriteButton
              type="business"
              itemId={business.id}
              familyMemberId={familyMemberId}
              businessColumn={favoriteBusinessColumn as any}
              className="!px-2 !py-2 bg-white/90 backdrop-blur-sm shadow-sm hover:bg-white border-0 rounded-lg"
            />
          )}
          {profile && (
            <div className="px-2 py-2 bg-white/90 backdrop-blur-sm shadow-sm hover:bg-white rounded-lg transition-colors [&_button]:!text-gray-500 [&_button:hover]:!text-red-500">
              <ReportButton entityType="business" entityId={business.id} compact={true} />
            </div>
          )}
        </div>
      </div>

      <div className="p-6">
        <div className="flex items-start justify-between mb-2 gap-2">
          <h3 className="text-xl font-semibold text-gray-900 flex-1">{business.name}</h3>
          <VerificationBadge
            isClaimed={!!business.is_claimed}
            isUserAdded={business.source === 'user_added' || (!!business.added_by && !business.is_claimed && !business.source)}
            isImported={business.source === 'imported'}
            isSelfRegistered={!!business.owner_id && !business.is_claimed && business.source !== 'user_added'}
            size="sm"
          />
        </div>

        {business.category && (
          <span className="inline-block px-3 py-1 bg-gray-100 text-gray-600 text-sm rounded-full mb-3">
            {business.category.name}
          </span>
        )}

        <p className="text-gray-600 text-sm mb-4 line-clamp-2">
          {business.description || 'Nessuna descrizione disponibile'}
        </p>

        <div className="space-y-2 mb-4">
          {business.location_count && business.location_count > 1 && (
            <div className="flex items-center gap-2 text-sm">
              <Building2 className="w-4 h-4 text-blue-600" />
              <span className="font-semibold text-blue-600">
                {business.location_count} {business.location_count === 1 ? 'sede' : 'sedi'}
              </span>
            </div>
          )}

          {business.cities && business.cities.length > 0 && (
            <div className="flex items-start gap-2 text-sm text-gray-700">
              <MapPin className="w-4 h-4 mt-0.5 flex-shrink-0 text-blue-600" />
              <span className="font-medium">
                {business.cities.slice(0, 3).join(', ')}
                {business.cities.length > 3 && ` +${business.cities.length - 3}`}
              </span>
            </div>
          )}
        </div>

        <div className="flex items-center gap-4 text-sm text-gray-500">
          {business.avg_rating !== undefined && business.review_count !== undefined && business.review_count > 0 && (
            <div className="flex items-center gap-1 px-3 py-1 bg-yellow-50 rounded-full">
              <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
              <span className="font-medium text-gray-900">{business.avg_rating.toFixed(1)}</span>
              <span className="text-xs">({business.review_count})</span>
            </div>
          )}

          {business.website && (
            <a
              href={business.website}
              target="_blank"
              rel="noopener noreferrer"
              onClick={(e) => e.stopPropagation()}
              className="ml-auto text-blue-600 hover:text-blue-700"
            >
              <ExternalLink className="w-4 h-4" />
            </a>
          )}
        </div>

        {canWriteReview && (
          <div className="mt-4 pt-4 border-t border-gray-100">
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

      {showReviewForm && (
        <ReviewForm
          businessId={business.id}
          businessName={business.name}
          businessType={
            (business.source === 'imported' || business.source === 'user_added')
              ? (business.source as 'imported' | 'user_added')
              : 'registered'
          }
          registeredBusinessLocationId={
            business.source !== 'imported' && business.source !== 'user_added' && business.location_type === 'registered'
              ? business.id
              : undefined
          }
          onClose={() => setShowReviewForm(false)}
          onSuccess={() => {
            setShowReviewForm(false);
          }}
        />
      )}
    </div>
  );
}
