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
    console.log(
    'MULTISELECT:',
    'options =',
    options.length,
    'selected =',
    selected.length,
    options
  );
  const [open, setOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        containerRef.current &&
        !containerRef.current.contains(event.target as Node)
      ) {
        setOpen(false);
        setSearchTerm('');
      }
    };

    document.addEventListener('mousedown', handleClickOutside);

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  const toggle = (id: string) => {
    if (selected.includes(id)) {
      onChange(selected.filter(item => item !== id));
    } else {
      onChange([...selected, id]);
    }
  };

  const filteredOptions = options.filter(option =>
    option.name
      .toLowerCase()
      .includes(searchTerm.toLowerCase())
  );

  const selectedNames = selected
    .map(id => options.find(option => option.id === id)?.name)
    .filter((name): name is string => Boolean(name));

  return (
    <div
      ref={containerRef}
      className="relative w-full"
    >

      {/* CAMPO PRINCIPALE */}
      <button
        type="button"
        onClick={() => setOpen(prev => !prev)}
        className={`w-full min-h-[42px] px-4 py-2 border border-gray-300 rounded-lg bg-white flex items-center justify-between gap-2 text-left transition-colors ${
          open
            ? 'ring-2 ring-blue-500 border-transparent'
            : 'hover:border-gray-400'
        }`}
      >
        <div className="flex-1 flex flex-wrap gap-1.5 min-w-0">

          {selectedNames.length === 0 ? (
            <span className="text-sm text-gray-400">
              {placeholder}
            </span>
          ) : (
            <>
              {selectedNames
                .slice(0, maxDisplay)
                .map((name, index) => (
                  <span
                    key={`${name}-${index}`}
                    className="inline-flex items-center gap-1 px-2 py-0.5 bg-blue-100 text-blue-800 text-xs rounded-full"
                  >
                    {name}

                    <span
                      role="button"
                      tabIndex={0}
                      onClick={(event) => {
                        event.stopPropagation();

                        const option = options.find(
                          item => item.name === name
                        );

                        if (option) {
                          toggle(option.id);
                        }
                      }}
                      onKeyDown={(event) => {
                        if (
                          event.key === 'Enter' ||
                          event.key === ' '
                        ) {
                          event.preventDefault();
                          event.stopPropagation();

                          const option = options.find(
                            item => item.name === name
                          );

                          if (option) {
                            toggle(option.id);
                          }
                        }
                      }}
                      className="cursor-pointer hover:text-blue-900"
                    >
                      <X className="w-3 h-3" />
                    </span>
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

        <ChevronDown
          className={`w-4 h-4 text-gray-400 shrink-0 transition-transform ${
            open ? 'rotate-180' : ''
          }`}
        />
      </button>


      {/* LISTA */}
      {open && (
        <div className="relative w-full mt-2 bg-white border border-gray-200 rounded-xl shadow-lg overflow-hidden">

          {/* RICERCA */}
          <div className="p-2 border-b border-gray-100">
            <div className="relative">

              <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />

              <input
                type="text"
                value={searchTerm}
                onChange={(event) =>
                  setSearchTerm(event.target.value)
                }
                onClick={(event) =>
                  event.stopPropagation()
                }
                placeholder="Cerca..."
                className="w-full pl-8 pr-3 py-2 text-sm border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                autoFocus
              />

            </div>
          </div>


          {/* CONTENUTO */}
          <div className="max-h-60 overflow-y-auto">

            {loading ? (
              <div className="px-4 py-3 text-sm text-gray-500">
                Caricamento...
              </div>
            ) : filteredOptions.length === 0 ? (
              <div className="px-4 py-3 text-sm text-gray-500">
                Nessun risultato
              </div>
            ) : (
              filteredOptions.map(option => (
                <label
                  key={option.id}
                  className="flex items-center gap-2.5 px-4 py-2.5 hover:bg-blue-50 cursor-pointer transition-colors"
                >

                  <input
                    type="checkbox"
                    checked={selected.includes(option.id)}
                    onChange={() => toggle(option.id)}
                    className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                  />

                  <span className="text-sm text-gray-800 flex-1">
                    {option.name}
                  </span>

                  {selected.includes(option.id) && (
                    <Check className="w-4 h-4 text-blue-600 shrink-0" />
                  )}

                </label>
              ))
            )}

          </div>

        </div>
      )}

    </div>
  );
}