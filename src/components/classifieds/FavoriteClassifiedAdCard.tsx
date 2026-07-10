import { MapPin, Eye, Calendar, MessageCircle } from 'lucide-react';
import { FavoriteButton } from '../favorites/FavoriteButton';
import ReportButton from '../moderation/ReportButton';
import { useAuth } from '../../contexts/AuthContext';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface ClassifiedAd {
  id: string;
  user_id: string;
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
  expires_at: string | null;
  status: string;
  profiles: {
    full_name: string;
    avatar_url: string | null;
  };
  classified_categories: {
    name: string;
    icon: string;
  };
}

interface FavoriteClassifiedAdCardProps {
  ad: ClassifiedAd;
  familyMemberId?: string | null;
  onRemove?: () => void;
}

export function FavoriteClassifiedAdCard({ ad, familyMemberId = null, onRemove }: FavoriteClassifiedAdCardProps) {
  const { showToast } = useToast();
  const { user } = useAuth();

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
      const { data: conversationId, error: funcError } = await supabase
        .rpc('get_or_create_conversation', {
          p_user1_id: user.id,
          p_user2_id: ad.user_id,
          p_conversation_type: 'classified_ad',
          p_reference_id: ad.id,
          p_user1_family_member_id: familyMemberId,
        });

      if (funcError) throw funcError;

      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (error) {
      console.error('Error creating conversation:', error);
      showToast('Errore nell\'avvio della conversazione', 'error');
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('it-IT');
  };

  const truncateText = (text: string, maxLength: number) => {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  };

  const firstImage = ad.images && ad.images.length > 0 ? ad.images[0] : null;

  return (
    <div className="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-200">
      <div className="relative h-40 bg-gray-200">
        {firstImage ? (
          <img
            src={firstImage}
            alt={ad.title}
            className="w-full h-full object-cover"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-gray-400">
            <span className="text-3xl">{ad.classified_categories.icon}</span>
          </div>
        )}

        <div className={`absolute top-2 left-2 px-2 py-1 rounded-full text-xs font-bold shadow-sm ${
          ad.ad_type === 'sell'
            ? 'bg-blue-600 text-white'
            : ad.ad_type === 'buy'
            ? 'bg-green-600 text-white'
            : 'bg-orange-600 text-white'
        }`}>
          {ad.ad_type === 'sell' ? '💰 Vendo' : ad.ad_type === 'buy' ? '🔍 Cerco' : '🎁 Regalo'}
        </div>

        <div className="absolute bottom-2 left-2 bg-white px-2 py-1 rounded-full text-xs font-medium text-gray-900 shadow-sm">
          {ad.classified_categories.name}
        </div>

        {ad.price && (
          <div className="absolute top-2 right-2 bg-white text-gray-900 px-2 py-1 rounded-full text-xs font-bold shadow-sm">
            €{ad.price.toLocaleString('it-IT')}
          </div>
        )}
      </div>

      <div className="p-3">
        <h3 className="text-base font-semibold text-gray-900 mb-1">
          {truncateText(ad.title, 40)}
        </h3>

        <p className="text-gray-600 text-xs mb-2 line-clamp-2">
          {truncateText(ad.description, 80)}
        </p>

        <div className="flex items-center gap-1 text-gray-500 text-xs mb-2">
          <MapPin className="w-3 h-3" />
          <span>
            {ad.city}, {ad.province}
          </span>
        </div>

        <div className="pt-2 border-t border-gray-100 mb-2">
          <div className="flex items-center gap-2 text-gray-500 text-xs">
            <div className="flex items-center gap-1">
              <Eye className="w-3 h-3" />
              <span>{ad.views_count}</span>
            </div>
            <div className="flex items-center gap-1">
              <Calendar className="w-3 h-3" />
              <span>{formatDate(ad.created_at)}</span>
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-2">
          <div className="flex gap-2">
            <a
              href={`/classified/${ad.id}`}
              className="flex-1 bg-blue-600 text-white px-3 py-2 rounded-lg hover:bg-blue-700 transition-colors text-center text-xs font-semibold"
            >
              Visualizza
            </a>
            {user && user.id !== ad.user_id && (
              <button
                onClick={startConversation}
                className="flex items-center justify-center gap-1 bg-green-600 text-white px-3 py-2 rounded-lg hover:bg-green-700 transition-colors text-xs font-semibold"
              >
                <MessageCircle className="w-3 h-3" />
                Contatta
              </button>
            )}
          </div>
          <div className="flex gap-2">
            <FavoriteButton
              type="ad"
              itemId={ad.id}
              familyMemberId={familyMemberId}
              className="flex-1 text-xs"
              onToggle={(isFavorite) => {
                if (!isFavorite && onRemove) {
                  onRemove();
                }
              }}
            />
            <ReportButton
              entityType="classified_ad"
              entityId={ad.id}
              compact={false}
            />
          </div>
        </div>
      </div>
    </div>
  );
}
