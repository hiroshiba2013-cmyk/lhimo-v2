import { useState, useRef, useEffect } from 'react';
import { ChevronDown, ChevronRight, X, Tag } from 'lucide-react';

interface Category {
  id: string;
  name: string;
  parent_id: string | null;
  parent_name?: string;
}

interface CategoryHierarchySelectProps {
  value: string;
  onChange: (value: string) => void;
  categories: Category[];
  placeholder?: string;
  disabled?: boolean;
  className?: string;
}

export function CategoryHierarchySelect({
  value,
  onChange,
  categories,
  placeholder = 'Seleziona una categoria...',
  disabled = false,
  className = '',
}: CategoryHierarchySelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [expandedParent, setExpandedParent] = useState<string | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  const parents = categories.filter(c => !c.parent_id);
  const childrenByParent = categories.reduce<Record<string, Category[]>>((acc, c) => {
    if (c.parent_id) {
      if (!acc[c.parent_id]) acc[c.parent_id] = [];
      acc[c.parent_id].push(c);
    }
    return acc;
  }, {});

  const selectedChild = categories.find(c => c.id === value && c.parent_id);
  const selectedParent = selectedChild
    ? parents.find(p => p.id === selectedChild.parent_id)
    : null;
  const displayLabel = selectedChild
    ? `${selectedParent?.name ?? ''} › ${selectedChild.name}`
    : '';

  useEffect(() => {
    if (isOpen && selectedChild) {
      setExpandedParent(selectedChild.parent_id);
    }
  }, [isOpen]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleToggle = () => {
    if (!disabled) setIsOpen(prev => !prev);
  };

  const handleParentClick = (parentId: string) => {
    setExpandedParent(prev => (prev === parentId ? null : parentId));
  };

  const handleChildClick = (childId: string) => {
    onChange(childId);
    setIsOpen(false);
  };

  const handleClear = (e: React.MouseEvent) => {
    e.stopPropagation();
    onChange('');
    setExpandedParent(null);
  };

  return (
    <div ref={containerRef} className={`relative ${className}`}>
      <div
        onClick={handleToggle}
        className={`w-full px-4 py-2 border border-gray-300 rounded-lg bg-white cursor-pointer flex items-center justify-between gap-2 min-h-[42px] ${
          isOpen ? 'ring-2 ring-blue-500 border-transparent' : ''
        } ${disabled ? 'bg-gray-100 cursor-not-allowed opacity-60' : 'hover:border-gray-400'}`}
      >
        <span className={`flex-1 text-sm truncate ${displayLabel ? 'text-gray-900' : 'text-gray-400'}`}>
          {displayLabel || placeholder}
        </span>
        <div className="flex items-center gap-1 shrink-0">
          {value && !disabled && (
            <button
              type="button"
              onClick={handleClear}
              className="text-gray-400 hover:text-gray-600 p-0.5 rounded"
            >
              <X className="w-4 h-4" />
            </button>
          )}
          <ChevronDown
            className={`w-4 h-4 text-gray-400 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`}
          />
        </div>
      </div>

      {isOpen && (
        <div className="absolute z-50 w-full mt-1 bg-white border border-gray-200 rounded-xl shadow-xl overflow-hidden max-h-80 overflow-y-auto">
          {parents.length === 0 ? (
            <div className="px-4 py-3 text-sm text-gray-500">Nessuna categoria disponibile</div>
          ) : (
            <div className="divide-y divide-gray-100">
              {parents.map(parent => {
                const children = childrenByParent[parent.id] ?? [];
                const isExpanded = expandedParent === parent.id;
                const hasSelected = selectedChild?.parent_id === parent.id;

                return (
                  <div key={parent.id}>
                    <button
                      type="button"
                      onClick={() => handleParentClick(parent.id)}
                      className={`w-full flex items-center justify-between px-4 py-2.5 text-left text-sm font-medium transition-colors ${
                        hasSelected
                          ? 'bg-blue-50 text-blue-800'
                          : 'text-gray-800 hover:bg-gray-50'
                      }`}
                    >
                      <span className="flex items-center gap-2">
                        <Tag className="w-3.5 h-3.5 text-gray-400 shrink-0" />
                        {parent.name}
                        {children.length > 0 && (
                          <span className="text-xs text-gray-400 font-normal">({children.length})</span>
                        )}
                      </span>
                      {children.length > 0 && (
                        <ChevronRight
                          className={`w-4 h-4 text-gray-400 transition-transform duration-200 ${isExpanded ? 'rotate-90' : ''}`}
                        />
                      )}
                    </button>

                    {isExpanded && children.length > 0 && (
                      <div className="bg-gray-50 border-t border-gray-100">
                        {children.map(child => (
                          <button
                            key={child.id}
                            type="button"
                            onClick={() => handleChildClick(child.id)}
                            className={`w-full text-left px-8 py-2 text-sm transition-colors ${
                              child.id === value
                                ? 'bg-blue-100 text-blue-900 font-medium'
                                : 'text-gray-700 hover:bg-blue-50 hover:text-blue-800'
                            }`}
                          >
                            {child.name}
                          </button>
                        ))}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
