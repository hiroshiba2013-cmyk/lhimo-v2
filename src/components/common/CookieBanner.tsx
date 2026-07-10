import { useState, useEffect } from 'react';
import { Cookie, X } from 'lucide-react';

const STORAGE_KEY = 'cookie_consent_v1';

export function CookieBanner() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) setVisible(true);
  }, []);

  const accept = () => {
    localStorage.setItem(STORAGE_KEY, 'accepted');
    setVisible(false);
  };

  const decline = () => {
    localStorage.setItem(STORAGE_KEY, 'declined');
    setVisible(false);
  };

  if (!visible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 p-4 sm:p-6">
      <div className="max-w-4xl mx-auto bg-slate-900 text-white rounded-2xl shadow-2xl border border-slate-700 overflow-hidden">
        <div className="flex items-start gap-4 p-5">
          <div className="w-9 h-9 bg-amber-500/20 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5">
            <Cookie className="w-5 h-5 text-amber-400" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-white text-sm mb-1">Utilizziamo i cookie</p>
            <p className="text-slate-400 text-xs leading-relaxed">
              Utilizziamo solo cookie tecnici necessari al funzionamento del sito (autenticazione, preferenze).
              Non utilizziamo cookie di profilazione o tracciamento pubblicitario.{' '}
              <a href="/rules#cookie-policy" className="text-amber-400 hover:text-amber-300 underline underline-offset-2">
                Leggi la Cookie Policy
              </a>
            </p>
          </div>
          <button onClick={decline} className="text-slate-500 hover:text-slate-300 transition-colors flex-shrink-0 mt-0.5">
            <X className="w-4 h-4" />
          </button>
        </div>
        <div className="px-5 pb-5 flex flex-col sm:flex-row gap-2 sm:justify-end">
          <button
            onClick={decline}
            className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-400 hover:text-white hover:bg-slate-700 transition-colors border border-slate-700"
          >
            Solo necessari
          </button>
          <button
            onClick={accept}
            className="px-5 py-2 rounded-xl text-xs font-semibold bg-amber-500 hover:bg-amber-400 text-slate-900 transition-colors"
          >
            Accetta
          </button>
        </div>
      </div>
    </div>
  );
}
