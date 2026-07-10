import { MapPin, Eye, Calendar, MessageCircle } from 'lucide-react';
import { FavoriteButton } from '../favorites/FavoriteButton';
import ReportButton from '../moderation/ReportButton';
import { useAuth } from '../../contexts/AuthContext';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface ClassifiedAd {
  id: string;
  user_id: string;
  family_member_id?: string | null;
  registered_business_location_id?: string | null;
  ad_type: 'sell' | 'buy' | 'gift';
  title: string;
  description: string;
  price: number | null;
  location: string;
  city: string;
  province: string;
  images: string[] | null;
  views_count: number;
  created_at: string;
  profiles: {
    full_name: string;
    nickname: string | null;
    avatar_url: string | null;
  };
  family_member?: {
    nickname: string;
    first_name: string;
    last_name: string;
    avatar_url: string | null;
  } | null;
  classified_categories: {
    name: string;
    icon: string;
  };
}

interface ClassifiedAdCardProps {
  ad: ClassifiedAd;
}

export function ClassifiedAdCard({ ad }: ClassifiedAdCardProps) {
  const { showToast } = useToast();
  const { user, activeProfile } = useAuth();

  const startConversation = async (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    if (!user) {
      window.location.href = '/';
      return;
    }

    if (user.id === ad.user_id) {
      showToast('Non puoi contattarti da solo', 'error');
      return;
    }

    try {
      const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;

      const { data: conversationId, error: funcError } = await supabase
        .rpc('get_or_create_conversation', {
          p_user1_id: user.id,
          p_user2_id: ad.user_id,
          p_conversation_type: 'classified_ad',
          p_reference_id: ad.id,
          p_user1_family_member_id: familyMemberId,
          p_user2_family_member_id: ad.family_member_id || null,
          p_user2_location_id: ad.registered_business_location_id || null,
        });

      if (funcError) throw funcError;

      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (error) {
      console.error('Error starting conversation:', error);
      showToast('Errore nell\'avvio della conversazione', 'error');
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now.getTime() - date.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays === 0) return 'Oggi';
    if (diffDays === 1) return 'Ieri';
    if (diffDays < 7) return `${diffDays} giorni fa`;
    if (diffDays < 30) return `${Math.floor(diffDays / 7)} settimane fa`;
    return date.toLocaleDateString('it-IT');
  };

  const truncateText = (text: string, maxLength: number) => {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  };

  const firstImage = ad.images && ad.images.length > 0 ? ad.images[0] : null;

  return (
    <div className="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow overflow-hidden group">
      <a href={`/classified/${ad.id}`}>
        {/* Image */}
        <div className="relative h-40 bg-gray-200">
          {firstImage ? (
            <img
              src={firstImage}
              alt={ad.title}
              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-400">
              <span className="text-3xl">{ad.classified_categories.icon}</span>
            </div>
          )}

          {/* Ad Type Badge */}
          <div className={`absolute top-2 left-2 px-2 py-0.5 rounded-full text-xs font-bold shadow-sm ${
            ad.ad_type === 'sell'
              ? 'bg-blue-600 text-white'
              : ad.ad_type === 'buy'
              ? 'bg-green-600 text-white'
              : 'bg-orange-600 text-white'
          }`}>
            {ad.ad_type === 'sell' ? 'Vendo' : ad.ad_type === 'buy' ? 'Cerco' : 'Regalo'}
          </div>

          {/* Category Badge */}
          <div className="absolute bottom-2 left-2 bg-white px-2 py-0.5 rounded-full text-xs font-medium text-gray-900 shadow-sm">
            {ad.classified_categories.name}
          </div>

          {/* Price Badge */}
          {ad.price && (
            <div className="absolute top-2 right-2 bg-white text-gray-900 px-2 py-0.5 rounded-full text-xs font-bold shadow-sm">
              €{ad.price.toLocaleString('it-IT')}
            </div>
          )}
        </div>

        {/* Content */}
        <div className="p-3">
          <h3 className="text-sm font-semibold text-gray-900 mb-1 group-hover:text-blue-600 transition-colors leading-snug">
            {truncateText(ad.title, 50)}
          </h3>

          <p className="text-gray-500 text-xs mb-2 line-clamp-2">
            {truncateText(ad.description, 80)}
          </p>

          {/* Location */}
          <div className="flex items-center gap-1 text-gray-400 text-xs mb-2">
            <MapPin className="w-3 h-3" />
            <span>{ad.city}, {ad.province}</span>
          </div>

          {/* Footer */}
          <div className="flex items-center justify-between pt-2 border-t border-gray-100">
            <div className="flex items-center gap-1.5">
              {ad.family_member ? (
                <>
                  {ad.family_member.avatar_url ? (
                    <img
                      src={ad.family_member.avatar_url}
                      alt={ad.family_member.nickname}
                      className="w-6 h-6 rounded-full object-cover"
                    />
                  ) : (
                    <div className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center">
                      <span className="text-xs font-medium text-gray-600">
                        {ad.family_member.nickname.charAt(0)}
                      </span>
                    </div>
                  )}
                  <span className="text-xs text-gray-600 font-medium">
                    {ad.family_member.nickname}
                  </span>
                </>
              ) : (
                <>
                  {ad.profiles.avatar_url ? (
                    <img
                      src={ad.profiles.avatar_url}
                      alt={ad.profiles.nickname || ad.profiles.full_name}
                      className="w-6 h-6 rounded-full object-cover"
                    />
                  ) : (
                    <div className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center">
                      <span className="text-xs font-medium text-gray-600">
                        {(ad.profiles.nickname || ad.profiles.full_name).charAt(0)}
                      </span>
                    </div>
                  )}
                  <span className="text-xs text-gray-600 font-medium">
                    {ad.profiles.nickname || ad.profiles.full_name}
                  </span>
                </>
              )}
            </div>

            <div className="flex items-center gap-2 text-gray-400 text-xs">
              <div className="flex items-center gap-0.5">
                <Eye className="w-3 h-3" />
                <span>{ad.views_count}</span>
              </div>
              <div className="flex items-center gap-0.5">
                <Calendar className="w-3 h-3" />
                <span>{formatDate(ad.created_at)}</span>
              </div>
            </div>
          </div>
        </div>
      </a>

      {/* Action Buttons */}
      <div className="px-3 pb-3 flex gap-2">
        {user && user.id !== ad.user_id && (
          <button
            onClick={startConversation}
            className="flex-1 flex items-center justify-center gap-1.5 bg-blue-600 text-white px-3 py-1.5 rounded-lg hover:bg-blue-700 transition-colors text-xs font-medium"
          >
            <MessageCircle className="w-3.5 h-3.5" />
            Invia Messaggio
          </button>
        )}
      </div>
    </div>
  );
}
