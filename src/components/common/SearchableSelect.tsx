import { useState, useRef, useEffect } from 'react';
import { ChevronDown, X } from 'lucide-react';

interface Option {
  value: string;
  label: string;
  isGroupHeader?: boolean;
  group?: string;
}

interface SearchableSelectProps {
  value: string;
  onChange: (value: string) => void;
  options: Option[];
  placeholder?: string;
  disabled?: boolean;
  className?: string;
  required?: boolean;
  name?: string;
}

export function SearchableSelect({
  value,
  onChange,
  options,
  placeholder = 'Seleziona...',
  disabled = false,
  className = '',
  required = false,
  name,
}: SearchableSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const containerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const selectableOptions = options.filter(o => !o.isGroupHeader);
  const selectedOption = selectableOptions.find(opt => opt.value === value);
  const displayValue = selectedOption ? selectedOption.label : '';

  const filteredOptions = searchTerm
    ? options.filter(option =>
        option.isGroupHeader
          ? options.some(
              o => !o.isGroupHeader && o.group === option.label &&
              o.label.toLowerCase().includes(searchTerm.toLowerCase())
            )
          : option.label.toLowerCase().includes(searchTerm.toLowerCase())
      )
    : options;

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchTerm('');
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  useEffect(() => {
    if (isOpen && inputRef.current) inputRef.current.focus();
  }, [isOpen]);

  const handleToggle = () => {
    if (!disabled) { setIsOpen(!isOpen); setSearchTerm(''); }
  };

  const handleSelect = (option: Option) => {
    if (option.isGroupHeader) return;
    onChange(option.value);
    setIsOpen(false);
    setSearchTerm('');
  };

  const handleClear = (e: React.MouseEvent) => {
    e.stopPropagation();
    onChange('');
    setSearchTerm('');
  };

  return (
    <div ref={containerRef} className="relative">
      <input type="hidden" name={name} value={value} required={required} />

      <div
        onClick={handleToggle}
        className={`w-full px-4 py-2 border border-gray-300 rounded-lg focus-within:ring-2 focus-within:ring-blue-500 focus-within:border-transparent bg-white cursor-pointer flex items-center justify-between ${
          disabled ? 'bg-gray-100 cursor-not-allowed' : ''
        } ${className}`}
      >
        {isOpen ? (
          <input
            ref={inputRef}
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Cerca..."
            className="flex-1 outline-none bg-transparent"
            onClick={(e) => e.stopPropagation()}
          />
        ) : (
          <span className={displayValue ? 'text-gray-900' : 'text-gray-500'}>
            {displayValue || placeholder}
          </span>
        )}

        <div className="flex items-center gap-1">
          {value && !disabled && !isOpen && (
            <button type="button" onClick={handleClear} className="text-gray-400 hover:text-gray-600 p-1">
              <X className="w-4 h-4" />
            </button>
          )}
          <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform ${isOpen ? 'transform rotate-180' : ''}`} />
        </div>
      </div>

      {isOpen && (
        <div className="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-64 overflow-y-auto">
          {filteredOptions.length === 0 ? (
            <div className="px-4 py-3 text-gray-500 text-sm">Nessun risultato trovato</div>
          ) : (
            <div className="py-1">
              {filteredOptions.map((option, idx) =>
                option.isGroupHeader ? (
                  <div
                    key={`group-${idx}`}
                    className="px-3 py-1.5 text-xs font-bold text-gray-500 uppercase tracking-wider bg-gray-50 border-t border-gray-100 first:border-t-0 select-none"
                  >
                    {option.label}
                  </div>
                ) : (
                  <div
                    key={option.value}
                    onClick={() => handleSelect(option)}
                    className={`pl-5 pr-4 py-2 cursor-pointer hover:bg-blue-50 transition-colors text-sm ${
                      option.value === value ? 'bg-blue-100 text-blue-900 font-medium' : 'text-gray-900'
                    }`}
                  >
                    {option.label}
                  </div>
                )
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
