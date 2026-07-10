import { Globe } from 'lucide-react';
import { useLanguage, Language } from '../../contexts/LanguageContext';

export function LanguageSelector() {
  const { language, setLanguage } = useLanguage();

  return (
    <div className="relative group">
      <button className="flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors">
        <Globe className="w-5 h-5 text-gray-600" />
        <span className="text-sm font-medium text-gray-700 uppercase">{language}</span>
      </button>

      <div className="absolute right-0 top-full mt-2 w-40 bg-white rounded-lg shadow-lg border border-gray-200 opacity-0 invisible group-hover:opacity-100 group-hover:visible group-focus-within:opacity-100 group-focus-within:visible transition-all z-50">
        <button
          onClick={() => setLanguage('it')}
          className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors rounded-t-lg ${
            language === 'it' ? 'bg-blue-50 text-blue-600 font-semibold' : 'text-gray-700'
          }`}
        >
          <span className="text-2xl">🇮🇹</span>
          <span>Italiano</span>
        </button>
        <button
          onClick={() => setLanguage('en')}
          className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors rounded-b-lg ${
            language === 'en' ? 'bg-blue-50 text-blue-600 font-semibold' : 'text-gray-700'
          }`}
        >
          <span className="text-2xl">🇬🇧</span>
          <span>English</span>
        </button>
      </div>
    </div>
  );
}
