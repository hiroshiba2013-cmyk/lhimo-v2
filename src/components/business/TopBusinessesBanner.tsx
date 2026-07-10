import { Star, MapPin, TrendingUp, ThumbsUp } from 'lucide-react';
import { useNavigate } from '../Router';

interface Business {
  id: string;
  name: string;
  business_categories: { name: string } | null;
  business_locations: Array<{
    city: string;
    province: string;
    address: string;
    avatar_url?: string;
  }>;
  avg_rating: number;
  review_count: number;
  positive_review_count?: number;
}

interface TopBusinessesBannerProps {
  businesses: Business[];
}

export default function TopBusinessesBanner({ businesses }: TopBusinessesBannerProps) {
  const navigate = useNavigate();

  if (!businesses || businesses.length === 0) {
    return null;
  }

  return (
    <section className="mb-12">
      <div className="flex items-center gap-3 mb-6">
        <div className="bg-yellow-100 p-3 rounded-lg">
          <ThumbsUp className="w-6 h-6 text-yellow-600" />
        </div>
        <div>
          <h2 className="text-3xl font-bold text-gray-900">Attività in Evidenza</h2>
          <p className="text-gray-600">Le attività con più recensioni positive della tua zona</p>
        </div>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
        {businesses.map((business) => (
          <div
            key={business.id}
            onClick={() => navigate(`/business/${business.id}`)}
            className="bg-white rounded-xl shadow-md hover:shadow-xl transition-all cursor-pointer overflow-hidden border-2 border-yellow-200 hover:border-yellow-400 transform hover:scale-105"
          >
            {business.business_locations?.[0]?.avatar_url ? (
              <div className="relative h-40 overflow-hidden">
                <img
                  src={business.business_locations[0].avatar_url}
                  alt={business.name}
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-3 right-3 bg-yellow-400 text-gray-900 px-3 py-1 rounded-full font-bold text-sm shadow-lg flex items-center gap-1">
                  <TrendingUp className="w-4 h-4" />
                  Top
                </div>
              </div>
            ) : (
              <div className="relative h-40 bg-gradient-to-br from-yellow-100 to-yellow-200 flex items-center justify-center">
                <div className="text-6xl font-bold text-yellow-300/50">
                  {business.name.charAt(0).toUpperCase()}
                </div>
                <div className="absolute top-3 right-3 bg-yellow-400 text-gray-900 px-3 py-1 rounded-full font-bold text-sm shadow-lg flex items-center gap-1">
                  <TrendingUp className="w-4 h-4" />
                  Top
                </div>
              </div>
            )}

            <div className="p-4">
              <h3 className="font-bold text-lg text-gray-900 mb-2 line-clamp-1">
                {business.name}
              </h3>

              {business.business_categories && (
                <p className="text-sm text-blue-600 font-medium mb-2">
                  {business.business_categories.name}
                </p>
              )}

              {business.business_locations?.[0] && (
                <div className="flex items-center gap-1 text-sm text-gray-600 mb-3">
                  <MapPin className="w-4 h-4 flex-shrink-0" />
                  <span className="line-clamp-1">
                    {business.business_locations[0].city}, {business.business_locations[0].province}
                  </span>
                </div>
              )}

              <div className="pt-3 border-t border-gray-200">
                {business.review_count > 0 ? (
                  <>
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-1">
                        <Star className="w-5 h-5 fill-yellow-400 text-yellow-400" />
                        <span className="font-bold text-gray-900">
                          {business.avg_rating.toFixed(1)}
                        </span>
                      </div>
                      <div className="text-sm text-gray-600 font-medium">
                        {business.review_count} {business.review_count === 1 ? 'recensione' : 'recensioni'}
                      </div>
                    </div>
                    {business.positive_review_count !== undefined && business.positive_review_count > 0 && (
                      <div className="flex items-center gap-1 bg-green-50 px-2 py-1 rounded-lg">
                        <ThumbsUp className="w-4 h-4 text-green-600" />
                        <span className="text-sm font-semibold text-green-700">
                          {business.positive_review_count} {business.positive_review_count === 1 ? 'recensione positiva' : 'recensioni positive'}
                        </span>
                      </div>
                    )}
                  </>
                ) : (
                  <div className="text-sm text-gray-500 italic w-full text-center">
                    Nessuna recensione ancora
                  </div>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
