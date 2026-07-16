import { useState, useEffect } from 'react';
import { Image as ImageIcon, Euro, Calendar, TrendingUp, Info, ChevronDown, ChevronUp } from 'lucide-react';
import {
  AdvertisingPlan, BannerPosition, POSITION_LABELS, priceWithVat,
  fetchAllAdvertisingPlans,
} from '../../lib/advertising-service';

interface AdvertisingPlansDisplayProps {
  onPurchaseClick: () => void;
}

const POSITION_DESCRIPTIONS: Record<string, string> = {
  home_top: 'Banner in alto nella homepage - massima visibilità',
  home_bottom: 'Banner in basso nella homepage',
  search_top: 'Banner in alto nella pagina di ricerca attività',
  search_results_1_30: 'Banner tra i primi 30 risultati di ricerca',
  search_results_31_60: 'Banner tra i risultati 31-60 di ricerca',
};

const POSITION_ORDER: BannerPosition[] = [
  'home_top', 'home_bottom', 'search_top', 'search_results_1_30', 'search_results_31_60',
];

export function AdvertisingPlansDisplay({ onPurchaseClick }: AdvertisingPlansDisplayProps) {
  const [plans, setPlans] = useState<AdvertisingPlan[]>([]);
  const [loading, setLoading] = useState(true);
  const [expandedPosition, setExpandedPosition] = useState<string | null>('home_top');

  useEffect(() => {
    fetchAllAdvertisingPlans()
      .then(setPlans)
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  if (loading) return null;
  if (plans.length === 0) return null;

  const plansByPosition = POSITION_ORDER.map(pos => ({
    position: pos,
    plans: plans.filter(p => p.position === pos).sort((a, b) => a.duration_days - b.duration_days),
  })).filter(g => g.plans.length > 0);

  return (
    <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
      <div className="bg-gradient-to-r from-violet-600 to-purple-600 p-5">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center">
            <ImageIcon className="w-5 h-5 text-white" />
          </div>
          <div>
            <h3 className="text-base font-bold text-white">Banner Pubblicitari</h3>
            <p className="text-xs text-white/80">Promuovi la tua attività con banner visibili a tutti gli utenti</p>
          </div>
        </div>
      </div>

      <div className="p-5">
        <div className="bg-violet-50 border border-violet-200 rounded-xl p-3 flex items-start gap-2 mb-4">
          <Info className="w-4 h-4 text-violet-600 flex-shrink-0 mt-0.5" />
          <p className="text-xs text-violet-800">
            I prezzi sono indicati senza IVA (22%). I banner sono soggetti ad approvazione.
            Il periodo di visibilità decorre dall'approvazione.
          </p>
        </div>

        <div className="space-y-3">
          {plansByPosition.map(({ position, plans: posPlans }) => {
            const isExpanded = expandedPosition === position;
            return (
              <div key={position} className="border border-gray-200 rounded-xl overflow-hidden">
                <button
                  onClick={() => setExpandedPosition(isExpanded ? null : position)}
                  className="w-full flex items-center justify-between p-3 hover:bg-gray-50 transition-colors"
                >
                  <div className="flex items-center gap-2 text-left">
                    <TrendingUp className="w-4 h-4 text-violet-600 flex-shrink-0" />
                    <div>
                      <p className="text-sm font-semibold text-gray-900">{POSITION_LABELS[position]}</p>
                      <p className="text-xs text-gray-500">{POSITION_DESCRIPTIONS[position] || ''}</p>
                    </div>
                  </div>
                  {isExpanded ? <ChevronUp className="w-4 h-4 text-gray-400" /> : <ChevronDown className="w-4 h-4 text-gray-400" />}
                </button>

                {isExpanded && (
                  <div className="px-3 pb-3">
                    <div className="grid grid-cols-3 gap-2">
                      {posPlans.map(plan => (
                        <div key={plan.id} className="border border-gray-200 rounded-xl p-3 text-center bg-gray-50">
                          <div className="flex items-center justify-center gap-1 text-xs text-gray-500 mb-1">
                            <Calendar className="w-3 h-3" />
                            {plan.duration_days} giorni
                          </div>
                          <p className="text-lg font-bold text-gray-900">€{Number(plan.price).toFixed(2)}</p>
                          <p className="text-[10px] text-gray-400">+ IVA</p>
                          <div className="mt-1 pt-1 border-t border-gray-200">
                            <p className="text-[10px] text-gray-500">Totale</p>
                            <p className="text-xs font-semibold text-violet-700">€{priceWithVat(Number(plan.price)).toFixed(2)}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>

        <button
          onClick={onPurchaseClick}
          className="w-full mt-4 bg-violet-600 hover:bg-violet-700 text-white py-2.5 rounded-xl text-sm font-semibold transition-colors flex items-center justify-center gap-2"
        >
          <ImageIcon className="w-4 h-4" />
          Pubblica un banner
        </button>
      </div>
    </div>
  );
}
