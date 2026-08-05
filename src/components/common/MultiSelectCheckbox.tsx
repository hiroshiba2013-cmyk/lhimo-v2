import { useState, useRef, useEffect } from 'react';
import { ChevronDown, X, Search, Check } from 'lucide-react';

interface MultiSelectCheckboxProps {
  options: { id: string; name: string }[];
  selected: string[];
  onChange: (selected: string[]) => void;
  placeholder?: string;
  loading?: boolean;
  maxDisplay?: number;
}

export function MultiSelectCheckbox({
  options,
  selected,
  onChange,
  placeholder = 'Seleziona...',
  loading = false,
  maxDisplay = 3,
}: MultiSelectCheckboxProps) {
  const [showSearch, setShowSearch] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const containerRef = useRef<HTMLDivElement>(null);

  const needsSearch = options.length > 15;

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setShowSearch(false);
        setSearchTerm('');
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const toggle = (id: string) => {
    if (selected.includes(id)) {
      onChange(selected.filter(s => s !== id));
    } else {
      onChange([...selected, id]);
    }
  };

  const filteredOptions = searchTerm
    ? options.filter(o => o.name.toLowerCase().includes(searchTerm.toLowerCase()))
    : options;

  const selectedNames = selected
    .map(id => options.find(o => o.id === id)?.name)
    .filter(Boolean);

  return (
    <div ref={containerRef} className="relative">
      <div
        onClick={() => needsSearch ? setShowSearch(!showSearch) : undefined}
        className={`w-full px-4 py-2 border border-gray-300 rounded-lg bg-white ${needsSearch ? 'cursor-pointer' : ''} min-h-[42px] flex items-center justify-between gap-2 ${showSearch ? 'ring-2 ring-blue-500 border-transparent' : 'hover:border-gray-400'}`}
      >
        <div className="flex-1 flex flex-wrap gap-1.5 min-w-0">
          {selected.length === 0 ? (
            <span className="text-sm text-gray-400">{placeholder}</span>
          ) : (
            <>
              {selectedNames.slice(0, maxDisplay).map((name, i) => (
                <span key={i} className="inline-flex items-center gap-1 px-2 py-0.5 bg-blue-100 text-blue-800 text-xs rounded-full">
                  {name}
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      const id = options.find(o => o.name === name)?.id;
                      if (id) toggle(id);
                    }}
                    className="hover:text-blue-900"
                  >
                    <X className="w-3 h-3" />
                  </button>
                </span>
              ))}
              {selectedNames.length > maxDisplay && (
                <span className="inline-flex items-center px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded-full">
                  +{selectedNames.length - maxDisplay}
                </span>
              )}
            </>
          )}
        </div>
        {needsSearch && (
          <ChevronDown className={`w-4 h-4 text-gray-400 shrink-0 transition-transform ${showSearch ? 'rotate-180' : ''}`} />
        )}
      </div>

      {needsSearch && showSearch && (
        <div className="absolute z-50 w-full mt-1 bg-white border border-gray-200 rounded-xl shadow-xl max-h-64 overflow-hidden">
          <div className="p-2 border-b border-gray-100">
            <div className="relative">
              <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Cerca..."
                className="w-full pl-8 pr-3 py-1.5 text-sm border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                autoFocus
              />
            </div>
          </div>
          <div className="overflow-y-auto max-h-48">
            {loading ? (
              <div className="px-4 py-3 text-sm text-gray-500">Caricamento...</div>
            ) : filteredOptions.length === 0 ? (
              <div className="px-4 py-3 text-sm text-gray-500">Nessun risultato</div>
            ) : (
              filteredOptions.map(option => (
                <label
                  key={option.id}
                  className="flex items-center gap-2.5 px-4 py-2 hover:bg-blue-50 cursor-pointer transition-colors"
                >
                  <input
                    type="checkbox"
                    checked={selected.includes(option.id)}
                    onChange={() => toggle(option.id)}
                    className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                  />
                  <span className="text-sm text-gray-800">{option.name}</span>
                  {selected.includes(option.id) && (
                    <Check className="w-3.5 h-3.5 text-blue-600 ml-auto" />
                  )}
                </label>
              ))
            )}
          </div>
        </div>
      )}

      {!needsSearch && (
        <div className="mt-2 space-y-1.5 max-h-48 overflow-y-auto">
          {loading ? (
            <div className="px-4 py-2 text-sm text-gray-500">Caricamento...</div>
          ) : options.length === 0 ? (
            <div className="px-4 py-2 text-sm text-gray-400">Nessun elemento disponibile</div>
          ) : (
            options.map(option => (
              <label
                key={option.id}
                className="flex items-center gap-2.5 px-3 py-1.5 hover:bg-blue-50 cursor-pointer rounded-lg transition-colors"
              >
                <input
                  type="checkbox"
                  checked={selected.includes(option.id)}
                  onChange={() => toggle(option.id)}
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <span className="text-sm text-gray-800">{option.name}</span>
              </label>
            ))
          )}
        </div>
      )}
    </div>
  );
}
