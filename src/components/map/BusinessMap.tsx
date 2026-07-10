import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import InteractiveMap from './InteractiveMap';
import { MapPin, Loader2 } from 'lucide-react';

interface BusinessLocation {
  id: string;
  business_name: string;
  address: string;
  city: string;
  latitude: number | null;
  longitude: number | null;
}

interface BusinessMapProps {
  businessId?: string;
  city?: string;
  category?: string;
  limit?: number;
  height?: string;
  showSearch?: boolean;
}

export default function BusinessMap({
  businessId,
  city,
  category,
  limit = 20,
  height = '500px',
  showSearch = false,
}: BusinessMapProps) {
  const [locations, setLocations] = useState<BusinessLocation[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadLocations();
  }, [businessId, city, category]);

  async function loadLocations() {
    try {
      setLoading(true);
      setError(null);

      let query = supabase
        .from('business_locations')
        .select('id, business_name, address, city, latitude, longitude')
        .not('latitude', 'is', null)
        .not('longitude', 'is', null);

      if (businessId) {
        query = query.eq('business_id', businessId);
      }

      if (city) {
        query = query.eq('city', city);
      }

      if (category) {
        const { data: businesses } = await supabase
          .from('businesses')
          .select('id')
          .eq('category_id', category);

        if (businesses) {
          const businessIds = businesses.map(b => b.id);
          query = query.in('business_id', businessIds);
        }
      }

      const { data, error: fetchError } = await query.limit(limit);

      if (fetchError) throw fetchError;

      setLocations(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load locations');
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8 bg-gray-50 rounded-lg" style={{ height }}>
        <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center p-8 bg-red-50 rounded-lg" style={{ height }}>
        <p className="text-red-600">{error}</p>
      </div>
    );
  }

  if (locations.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center p-8 bg-gray-50 rounded-lg" style={{ height }}>
        <MapPin className="w-12 h-12 text-gray-400 mb-2" />
        <p className="text-gray-600">Nessuna posizione disponibile</p>
      </div>
    );
  }

  const mapLocations = locations.map(loc => ({
    id: loc.id,
    lat: loc.latitude!,
    lng: loc.longitude!,
    title: loc.business_name,
    description: `${loc.address}, ${loc.city}`,
    onClick: () => {
      if (!businessId) {
        window.location.href = `/business/${loc.id}`;
      }
    },
  }));

  return (
    <div className="space-y-4">
      {showSearch && locations.length > 1 && (
        <div className="bg-white p-4 rounded-lg border">
          <p className="text-sm text-gray-600">
            Visualizzando {locations.length} {locations.length === 1 ? 'attività' : 'attività'}
          </p>
        </div>
      )}
      <InteractiveMap
        locations={mapLocations}
        height={height}
        zoom={locations.length === 1 ? 15 : 12}
      />
    </div>
  );
}
