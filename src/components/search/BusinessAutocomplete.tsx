import { useState, useEffect, useRef } from 'react';
import { Search, Building2, Loader2 } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface Business {
  id: string;
  name: string;
  city?: string;
  category?: {
    name: string;
  };
}

interface BusinessAutocompleteProps {
  value: string;
  onChange: (value: string) => void;
  onSelect?: (businessId: string) => void;
  placeholder?: string;
}

export default function BusinessAutocomplete({
  value,
  onChange,
  onSelect,
  placeholder = 'Cerca attività...',
}: BusinessAutocompleteProps) {
  const [suggestions, setSuggestions] = useState<Business[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const wrapperRef = useRef<HTMLDivElement>(null);
  const debounceTimer = useRef<NodeJS.Timeout>();

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target as Node)) {
        setShowSuggestions(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  useEffect(() => {
    if (debounceTimer.current) {
      clearTimeout(debounceTimer.current);
    }

    if (value.length < 2) {
      setSuggestions([]);
      setTotalCount(0);
      setShowSuggestions(false);
      return;
    }

    debounceTimer.current = setTimeout(() => {
      searchBusinesses(value);
    }, 300);

    return () => {
      if (debounceTimer.current) {
        clearTimeout(debounceTimer.current);
      }
    };
  }, [value]);

  async function searchBusinesses(query: string) {
    try {
      setLoading(true);

      const { data: claimedLocations } = await supabase
        .from('business_locations')
        .select(`
          id,
          business_id,
          name,
          city,
          business:businesses(
            id,
            name,
            category:business_categories(name)
          )
        `)
        .or(`name.ilike.%${query}%,business.name.ilike.%${query}%`)
        .limit(10);

      const { data: unclaimedData } = await supabase
        .from('unclaimed_business_locations')
        .select(`
          id,
          name,
          city,
          category:business_categories(name)
        `)
        .ilike('name', `%${query}%`)
        .limit(10);

      const claimed = (claimedLocations || [])
        .filter(loc => loc.business)
        .map(loc => ({
          id: loc.id,
          name: loc.name || loc.business?.name || 'Nome non disponibile',
          city: loc.city,
          category: loc.business?.category,
        }));

      const unclaimed = (unclaimedData || []).map(b => ({
        id: b.id,
        name: b.name,
        city: b.city,
        category: b.category,
      }));

      const combined = [...claimed, ...unclaimed];
      setTotalCount(combined.length);

      const uniqueByName = combined.reduce((acc: Business[], current) => {
        const existingIndex = acc.findIndex(
          item => item.name.toLowerCase() === current.name.toLowerCase() &&
                 item.city === current.city
        );
        if (existingIndex === -1) {
          acc.push(current);
        }
        return acc;
      }, []);

      setSuggestions(uniqueByName.slice(0, 10));
      setShowSuggestions(uniqueByName.length > 0);
    } catch (error) {
      console.error('Error searching businesses:', error);
    } finally {
      setLoading(false);
    }
  }

  function handleSelect(business: Business) {
    onChange(business.name);
    setShowSuggestions(false);
    if (onSelect) {
      onSelect(business.id);
    }
  }

  return (
    <div ref={wrapperRef} className="relative">
      <div className="relative">
        <input
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onFocus={() => {
            if (suggestions.length > 0) {
              setShowSuggestions(true);
            }
          }}
          placeholder={placeholder}
          className="w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white text-gray-900"
          autoComplete="off"
          spellCheck="false"
        />
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
        {loading && (
          <Loader2 className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 animate-spin" />
        )}
      </div>

      {showSuggestions && suggestions.length > 0 && (
        <div className="absolute z-50 w-full mt-2 bg-white rounded-lg shadow-lg border border-gray-200 max-h-96 overflow-y-auto">
          {totalCount > 0 && (
            <div className="px-4 py-2 bg-blue-50 border-b border-blue-200">
              <p className="text-sm font-semibold text-blue-900">
                {totalCount} {totalCount === 1 ? 'sede trovata' : 'sedi trovate'}
                {suggestions.length < totalCount && ` (mostrate ${suggestions.length})`}
              </p>
            </div>
          )}
          {suggestions.map((business) => (
            <button
              key={business.id}
              onClick={() => handleSelect(business)}
              className="w-full px-4 py-3 text-left hover:bg-blue-50 transition-colors border-b border-gray-100 last:border-b-0"
            >
              <div className="flex items-start gap-3">
                <div className="bg-blue-100 p-2 rounded-lg mt-0.5">
                  <Building2 className="w-4 h-4 text-blue-600" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="font-semibold text-gray-900 truncate">{business.name}</p>
                  <div className="flex items-center gap-2 mt-1">
                    {business.category && (
                      <span className="text-xs text-gray-500">{business.category.name}</span>
                    )}
                    {business.city && (
                      <>
                        {business.category && <span className="text-gray-300">•</span>}
                        <span className="text-xs text-gray-500">{business.city}</span>
                      </>
                    )}
                  </div>
                </div>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
