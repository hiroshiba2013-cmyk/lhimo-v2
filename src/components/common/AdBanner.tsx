import { useState, useEffect } from 'react';
import { fetchActiveBanners, AdvertisingBanner, BannerPosition } from '../../lib/advertising-service';

interface AdBannerProps {
  position?: BannerPosition;
}

export function AdBanner({ position }: AdBannerProps = {}) {
  const [banners, setBanners] = useState<AdvertisingBanner[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!position) {
      setLoading(false);
      return;
    }
    let active = true;
    fetchActiveBanners(position)
      .then(data => { if (active) setBanners(data); })
      .catch(() => { /* silent fallback to placeholder */ })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [position]);

  useEffect(() => {
    if (banners.length <= 1) return;
    const interval = setInterval(() => {
      setCurrentIndex(prev => (prev + 1) % banners.length);
    }, 5000);
    return () => clearInterval(interval);
  }, [banners.length]);

  if (loading) return null;

  const banner = banners[currentIndex];

  if (banner) {
    return (
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="relative w-full aspect-[4/1] rounded-2xl overflow-hidden border border-gray-200 group">
          <a href={banner.link_url || '#'} target="_blank" rel="noopener noreferrer" className="block w-full h-full">
            <img src={banner.image_url} alt={banner.alt_text || 'Pubblicità'} className="w-full h-full object-cover transition-transform group-hover:scale-[1.01]" />
          </a>
          <span className="absolute top-2 right-2 bg-black/40 text-white text-[10px] uppercase tracking-[0.15em] px-2 py-0.5 rounded">Pubblicità</span>
          {banners.length > 1 && (
            <div className="absolute bottom-2 left-1/2 -translate-x-1/2 flex gap-1">
              {banners.map((_, i) => (
                <span key={i} className={`w-1.5 h-1.5 rounded-full transition-all ${i === currentIndex ? 'bg-white w-4' : 'bg-white/50'}`} />
              ))}
            </div>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
      <div className="relative w-full aspect-[4/1] bg-gradient-to-r from-gray-100 to-gray-200 rounded-2xl border border-dashed border-gray-300 flex items-center justify-center overflow-hidden hover:border-gray-400 transition-colors">
        <div className="text-center">
          <p className="text-[10px] text-gray-400 uppercase tracking-[0.2em] mb-1">Pubblicità</p>
          <p className="text-sm text-gray-500 font-medium">Spazio pubblicitario 1200 × 300 px</p>
        </div>
      </div>
    </div>
  );
}
