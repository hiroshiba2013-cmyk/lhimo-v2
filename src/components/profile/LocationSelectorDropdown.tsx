import { useState, useRef, useEffect } from 'react';
import { Building2, ChevronDown, Check } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import { supabase } from '../../lib/supabase';

export function LocationSelectorDropdown() {
  const { businessLocations, activeProfile, setActiveProfile, profile } = useAuth();
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const selectedLocation = activeProfile?.isOwner
    ? null
    : businessLocations.find(loc => loc.id === activeProfile?.id);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  if (businessLocations.length <= 1) {
    return null;
  }

  const handleSelectLocation = (locationId: string | null, isOwner: boolean) => {
    if (!profile?.id) return;

    if (isOwner) {
      setActiveProfile(profile.id, true);
    } else {
      const location = businessLocations.find(l => l.id === locationId);
      if (location) {
        setActiveProfile(locationId!, false);
      }
    }
    setIsOpen(false);
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white border-2 border-blue-300 text-gray-700 rounded-lg hover:bg-blue-50 transition-colors"
      >
        <Building2 className="w-4 h-4 text-blue-600" />
        <span className="text-sm font-medium">
          {selectedLocation ? selectedLocation.internal_name || selectedLocation.name : 'Tutte le Sedi'}
        </span>
        <ChevronDown className={`w-4 h-4 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 py-2 z-50">
          <button
            onClick={() => handleSelectLocation(null, true)}
            className="w-full px-4 py-2 text-left hover:bg-blue-50 transition-colors flex items-center justify-between"
          >
            <div className="flex items-center gap-2">
              <Building2 className="w-4 h-4 text-blue-600" />
              <span className="text-sm font-medium">Tutte le Sedi</span>
            </div>
            {activeProfile?.isOwner && (
              <Check className="w-4 h-4 text-blue-600" />
            )}
          </button>

          <div className="border-t border-gray-200 my-2"></div>

          {businessLocations.map((location) => (
            <button
              key={location.id}
              onClick={() => handleSelectLocation(location.id, false)}
              className="w-full px-4 py-2 text-left hover:bg-blue-50 transition-colors flex items-center justify-between"
            >
              <div className="flex items-center gap-2">
                {location.avatar_url ? (
                  <img
                    src={location.avatar_url}
                    alt={location.name}
                    className="w-6 h-6 rounded-full object-cover"
                  />
                ) : (
                  <div className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center">
                    <Building2 className="w-3 h-3 text-gray-500" />
                  </div>
                )}
                <div className="flex flex-col">
                  <span className="text-sm font-medium text-gray-900">
                    {location.internal_name || `Sede ${location.city}`}
                  </span>
                  <span className="text-xs text-gray-500">
                    {location.name || `${location.city}, ${location.province}`}
                  </span>
                </div>
              </div>
              {!activeProfile?.isOwner && activeProfile?.id === location.id && (
                <Check className="w-4 h-4 text-blue-600" />
              )}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
