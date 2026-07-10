import { MapPin, Eye, Calendar, FileEdit as Edit2, Trash2, Clock, Tag } from 'lucide-react';
import { useState } from 'react';

interface ClassifiedAd {
  id: string;
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
  approval_status?: string;
  profiles: {
    full_name: string;
    avatar_url: string | null;
  };
  classified_categories: {
    name: string;
    icon: string;
  };
}

interface ProfileClassifiedAdCardProps {
  ad: ClassifiedAd;
  onEdit: (ad: ClassifiedAd) => void;
  onDelete: (adId: string) => void;
}

const AD_TYPE_CONFIG = {
  sell: {
    label: 'Vendo',
    badgeCls: 'bg-blue-600 text-white',
    borderCls: 'border-l-blue-500',
    bgCls: 'bg-blue-50',
    titleCls: 'text-blue-900',
  },
  buy: {
    label: 'Cerco',
    badgeCls: 'bg-emerald-600 text-white',
    borderCls: 'border-l-emerald-500',
    bgCls: 'bg-emerald-50',
    titleCls: 'text-emerald-900',
  },
  gift: {
    label: 'Regalo',
    badgeCls: 'bg-orange-500 text-white',
    borderCls: 'border-l-orange-400',
    bgCls: 'bg-orange-50',
    titleCls: 'text-orange-900',
  },
};

export function ProfileClassifiedAdCard({ ad, onEdit, onDelete }: ProfileClassifiedAdCardProps) {
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  if (!ad) return null;

  const getDaysRemaining = () => {
    const base = ad.expires_at
      ? new Date(ad.expires_at)
      : new Date(new Date(ad.created_at).getTime() + 30 * 24 * 60 * 60 * 1000);
    return Math.ceil((base.getTime() - Date.now()) / (1000 * 60 * 60 * 24));
  };

  const formatDate = (dateString: string) =>
    new Date(dateString).toLocaleDateString('it-IT', { day: '2-digit', month: 'short' });

  const firstImage = ad.images && ad.images.length > 0 ? ad.images[0] : null;
  const daysRemaining = getDaysRemaining();
  const typeConfig = AD_TYPE_CONFIG[ad.ad_type] ?? AD_TYPE_CONFIG.sell;

  const isPending = ad.approval_status === 'pending';
  const isRejected = ad.approval_status === 'rejected';

  return (
    <div className={`rounded-xl border-l-4 border border-gray-200 overflow-hidden flex shadow-sm hover:shadow-md transition-shadow ${typeConfig.borderCls} ${typeConfig.bgCls} ${
      isPending ? 'ring-1 ring-amber-300' :
      isRejected ? 'ring-1 ring-red-300' : ''
    }`}>
      {/* Image — compact square */}
      <div className="relative w-[88px] flex-shrink-0 bg-gray-200 self-stretch">
        {firstImage ? (
          <img src={firstImage} alt={ad.title} className="w-full h-full object-cover" />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-2xl min-h-[88px]">
            {ad.classified_categories?.icon || '📦'}
          </div>
        )}
        {/* Ad type badge over image */}
        <span className={`absolute bottom-1 left-1 right-1 text-center px-1 py-0.5 rounded text-[10px] font-bold ${typeConfig.badgeCls}`}>
          {typeConfig.label}
        </span>
      </div>

      {/* Content */}
      <div className="flex-1 flex flex-col p-3 min-w-0">
        {/* Status banners */}
        {isPending && (
          <div className="flex items-center gap-1 mb-1.5 text-amber-700">
            <Clock className="w-3 h-3 flex-shrink-0" />
            <span className="text-[10px] font-semibold">In attesa di approvazione</span>
          </div>
        )}
        {isRejected && (
          <span className="text-[10px] font-semibold text-red-700 mb-1.5 block">Annuncio rifiutato</span>
        )}

        {/* Title + price */}
        <div className="flex items-start justify-between gap-2 mb-1">
          <h3 className={`text-sm font-bold leading-tight line-clamp-1 ${typeConfig.titleCls}`}>
            {ad.title}
          </h3>
          {ad.price !== null && ad.price !== undefined && (
            <span className="text-sm font-bold text-gray-800 flex-shrink-0 whitespace-nowrap">
              €{ad.price.toLocaleString('it-IT')}
            </span>
          )}
        </div>

        {/* Category + location */}
        <div className="flex items-center gap-2 mb-2">
          <span className="flex items-center gap-0.5 text-[11px] text-gray-500 bg-white/70 px-1.5 py-0.5 rounded-full border border-gray-200">
            <Tag className="w-2.5 h-2.5" />
            {ad.classified_categories?.name || 'Annuncio'}
          </span>
          <span className="flex items-center gap-0.5 text-[11px] text-gray-500">
            <MapPin className="w-2.5 h-2.5" />
            {ad.city}, {ad.province}
          </span>
        </div>

        {/* Stats row */}
        <div className="flex items-center gap-3 text-[11px] text-gray-400 mb-2.5">
          <span className="flex items-center gap-0.5">
            <Eye className="w-3 h-3" />
            {ad.views_count} visite
          </span>
          <span className="flex items-center gap-0.5">
            <Calendar className="w-3 h-3" />
            {formatDate(ad.created_at)}
          </span>
          <span className={`flex items-center gap-0.5 font-semibold ${
            daysRemaining <= 3 ? 'text-red-600' :
            daysRemaining <= 7 ? 'text-orange-500' :
            'text-green-600'
          }`}>
            <Clock className="w-3 h-3" />
            {daysRemaining > 0 ? `${daysRemaining}gg` : 'Scaduto'}
          </span>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-1.5 mt-auto">
          <a
            href={`/classified/${ad.id}`}
            className="flex-1 bg-white border border-gray-300 text-gray-700 px-2 py-1.5 rounded-lg text-center text-xs font-semibold hover:bg-gray-50 transition-colors"
          >
            Vedi
          </a>
          <button
            onClick={() => onEdit(ad)}
            className="flex items-center gap-1 bg-white border border-gray-300 text-gray-700 px-2 py-1.5 rounded-lg text-xs font-semibold hover:bg-gray-50 transition-colors"
          >
            <Edit2 className="w-3 h-3" />
            Modifica
          </button>
          {showDeleteConfirm ? (
            <>
              <button
                onClick={() => { onDelete(ad.id); setShowDeleteConfirm(false); }}
                className="flex items-center gap-1 bg-red-600 text-white px-2 py-1.5 rounded-lg text-xs font-semibold hover:bg-red-700 transition-colors"
              >
                <Trash2 className="w-3 h-3" />
                Conferma
              </button>
              <button
                onClick={() => setShowDeleteConfirm(false)}
                className="px-2 py-1.5 text-gray-500 hover:text-gray-700 text-xs"
              >
                Annulla
              </button>
            </>
          ) : (
            <button
              onClick={() => setShowDeleteConfirm(true)}
              className="flex items-center gap-1 bg-white border border-red-200 text-red-600 px-2 py-1.5 rounded-lg text-xs font-semibold hover:bg-red-50 transition-colors"
            >
              <Trash2 className="w-3 h-3" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
