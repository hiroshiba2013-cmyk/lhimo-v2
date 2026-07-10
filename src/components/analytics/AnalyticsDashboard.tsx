import { useState, useEffect } from 'react';
import { Users, Building2, Star, TrendingUp, MapPin, Award } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import StatCard from './StatCard';
import BarChart from './BarChart';

interface AnalyticsData {
  totalUsers: number;
  totalBusinesses: number;
  totalReviews: number;
  avgRating: number;
  topCategories: Array<{ name: string; count: number }>;
  topCities: Array<{ name: string; count: number }>;
  recentActivity: Array<{ type: string; count: number }>;
}

export default function AnalyticsDashboard() {
  const [data, setData] = useState<AnalyticsData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadAnalytics();
  }, []);

  async function loadAnalytics() {
    try {
      setLoading(true);

      const [
        usersResult,
        businessesResult,
        reviewsResult,
        categoriesResult,
        citiesResult,
      ] = await Promise.all([
        supabase.from('profiles').select('id', { count: 'exact', head: true }),
        supabase.from('businesses').select('id', { count: 'exact', head: true }),
        supabase.from('reviews').select('overall_rating'),
        supabase
          .from('business_categories')
          .select('name, businesses(count)')
          .limit(10),
        supabase
          .from('business_locations')
          .select('city')
          .limit(1000),
      ]);

      const totalUsers = usersResult.count || 0;
      const totalBusinesses = businessesResult.count || 0;
      const reviews = reviewsResult.data || [];
      const totalReviews = reviews.length;
      const avgRating = totalReviews > 0
        ? reviews.reduce((sum, r) => sum + r.overall_rating, 0) / totalReviews
        : 0;

      const categoriesData = categoriesResult.data || [];
      const topCategories = categoriesData
        .map(cat => ({
          name: cat.name,
          count: (cat as any).businesses?.[0]?.count || 0,
        }))
        .sort((a, b) => b.count - a.count)
        .slice(0, 10);

      const citiesData = citiesResult.data || [];
      const cityCount = citiesData.reduce((acc, loc) => {
        acc[loc.city] = (acc[loc.city] || 0) + 1;
        return acc;
      }, {} as Record<string, number>);

      const topCities = Object.entries(cityCount)
        .map(([name, count]) => ({ name, count }))
        .sort((a, b) => b.count - a.count)
        .slice(0, 10);

      setData({
        totalUsers,
        totalBusinesses,
        totalReviews,
        avgRating,
        topCategories,
        topCities,
        recentActivity: [
          { type: 'Nuove Recensioni', count: totalReviews },
          { type: 'Nuove Attività', count: totalBusinesses },
          { type: 'Nuovi Utenti', count: totalUsers },
        ],
      });
    } catch (error) {
      console.error('Error loading analytics:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!data) return null;

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-gray-900 mb-2">Dashboard Analytics</h2>
        <p className="text-gray-600">Panoramica completa delle statistiche della piattaforma</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Utenti Totali"
          value={data.totalUsers}
          icon={Users}
          color="blue"
        />
        <StatCard
          title="Attività Totali"
          value={data.totalBusinesses}
          icon={Building2}
          color="green"
        />
        <StatCard
          title="Recensioni"
          value={data.totalReviews}
          icon={Star}
          color="purple"
        />
        <StatCard
          title="Rating Medio"
          value={data.avgRating.toFixed(1)}
          icon={Award}
          color="orange"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <BarChart
          title="Top 10 Categorie"
          data={data.topCategories.map(cat => ({
            label: cat.name,
            value: cat.count,
            color: 'bg-blue-600',
          }))}
        />
        <BarChart
          title="Top 10 Città"
          data={data.topCities.map(city => ({
            label: city.name,
            value: city.count,
            color: 'bg-green-600',
          }))}
        />
      </div>

      <div className="bg-white rounded-lg shadow p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
          <TrendingUp className="w-5 h-5" />
          Statistiche Geografiche
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="p-4 bg-blue-50 rounded-lg">
            <div className="flex items-center gap-2 text-blue-600 mb-2">
              <MapPin className="w-5 h-5" />
              <span className="font-semibold">Città Coperte</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{data.topCities.length}+</p>
          </div>
          <div className="p-4 bg-green-50 rounded-lg">
            <div className="flex items-center gap-2 text-green-600 mb-2">
              <Building2 className="w-5 h-5" />
              <span className="font-semibold">Media per Città</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">
              {Math.round(data.totalBusinesses / (data.topCities.length || 1))}
            </p>
          </div>
          <div className="p-4 bg-purple-50 rounded-lg">
            <div className="flex items-center gap-2 text-purple-600 mb-2">
              <Star className="w-5 h-5" />
              <span className="font-semibold">Recensioni Medie</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">
              {Math.round(data.totalReviews / (data.totalBusinesses || 1))}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
