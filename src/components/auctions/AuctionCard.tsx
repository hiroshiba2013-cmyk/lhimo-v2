import { Clock, MapPin, Tag, TrendingUp, User } from 'lucide-react';
import { useNavigate } from '../Router';
import { useLanguage } from '../../contexts/LanguageContext';

interface AuctionCardProps {
  auction: {
    id: string;
    title: string;
    description: string;
    base_price: number;
    current_price: number;
    deposit_amount: number;
    images: string[];
    category: string;
    condition: string;
    city: string;
    province: string;
    status: string;
    ends_at: string;
    created_at: string;
    current_bidder_nickname?: string;
    user?: {
      full_name?: string;
      nickname?: string;
    };
    bid_count?: number;
  };
}

export default function AuctionCard({ auction }: AuctionCardProps) {
  const navigate = useNavigate();
  const { t } = useLanguage();

  const getTimeRemaining = () => {
    const now = new Date();
    const endDate = new Date(auction.ends_at);
    const diff = endDate.getTime() - now.getTime();

    if (diff <= 0) return t('auction_ended');

    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

    if (days > 0) return `${days}g ${hours}h`;
    if (hours > 0) return `${hours}h ${minutes}m`;
    return `${minutes}m`;
  };

  const getConditionLabel = (condition: string) => {
    const labels: Record<string, string> = {
      new: t('condition_new'),
      like_new: t('condition_like_new'),
      good: t('condition_good'),
      fair: t('condition_fair'),
      poor: t('condition_poor')
    };
    return labels[condition] || condition;
  };

  const mainImage = auction.images && auction.images.length > 0
    ? auction.images[0]
    : 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=300&fit=crop';

  return (
    <div
      onClick={() => navigate(`/auctions/${auction.id}`)}
      className="bg-white rounded-lg shadow-sm hover:shadow-md transition-all duration-200 overflow-hidden cursor-pointer border border-gray-200"
    >
      <div className="relative h-36 overflow-hidden">
        <img
          src={mainImage}
          alt={auction.title}
          className="w-full h-full object-cover transition-transform duration-300 hover:scale-105"
        />
        <div className="absolute top-2 right-2 flex gap-1.5">
          <span className="bg-blue-600 text-white px-2 py-0.5 rounded-full text-xs font-medium">
            {auction.category}
          </span>
          {auction.status === 'active' && (
            <span className="bg-green-600 text-white px-2 py-0.5 rounded-full text-xs font-medium flex items-center gap-1">
              <Clock className="w-3 h-3" />
              {getTimeRemaining()}
            </span>
          )}
        </div>
        <div className="absolute bottom-2 left-2">
          <span className="bg-white/90 backdrop-blur-sm px-2 py-0.5 rounded text-xs font-medium text-gray-700">
            {getConditionLabel(auction.condition)}
          </span>
        </div>
      </div>

      <div className="p-3">
        <h3 className="font-semibold text-sm text-gray-900 mb-1 line-clamp-1">
          {auction.title}
        </h3>

        <p className="text-xs text-gray-500 mb-2 line-clamp-1">
          {auction.description}
        </p>

        <div className="flex items-center justify-between mb-2">
          <div>
            <div className="text-xs text-gray-400">{t('base_price')}</div>
            <div className="text-sm font-bold text-gray-900">
              {auction.base_price.toFixed(2)} €
            </div>
          </div>
          <div className="text-right">
            <div className="text-xs text-gray-400">{t('current_bid')}</div>
            {auction.current_price > 0 ? (
              <>
                <div className="text-sm font-bold text-blue-600 flex items-center justify-end gap-1">
                  <TrendingUp className="w-3 h-3" />
                  {auction.current_price.toFixed(2)} €
                </div>
                {auction.current_bidder_nickname && (
                  <div className="flex items-center justify-end gap-1 mt-0.5">
                    <User className="w-3 h-3 text-blue-500" />
                    <span className="text-xs font-medium text-blue-600 truncate max-w-[100px]">
                      {auction.current_bidder_nickname}
                    </span>
                  </div>
                )}
              </>
            ) : (
              <div className="text-sm font-bold text-gray-400">{t('no_bids')}</div>
            )}
          </div>
        </div>

        <div className="flex items-center justify-between pt-2 border-t border-gray-200">
          <div className="flex items-center gap-1 text-xs text-gray-500">
            <MapPin className="w-3 h-3" />
            <span className="truncate max-w-[110px]">{auction.city}, {auction.province}</span>
          </div>
          <div className="flex items-center gap-1 text-xs text-gray-500">
            <Tag className="w-3 h-3" />
            <span>{t('deposit')}: {Number(auction.deposit_amount || 0).toFixed(0)}€</span>
          </div>
        </div>

        {auction.bid_count !== undefined && auction.bid_count > 0 && (
          <div className="mt-1.5 text-xs text-gray-400 text-center">
            {auction.bid_count} {auction.bid_count === 1 ? t('bid') : t('bids')}
          </div>
        )}
      </div>
    </div>
  );
}
