import { Check } from 'lucide-react';

interface SubscriptionPlan {
  type: 'monthly' | 'annual';
  price: number;
  features: string[];
}

interface SubscriptionCardProps {
  plan: SubscriptionPlan;
  userType: 'customer' | 'business';
  onSelect: () => void;
}

export function SubscriptionCard({ plan, userType, onSelect }: SubscriptionCardProps) {
  const isAnnual = plan.type === 'annual';
  const monthlyPrice = isAnnual ? plan.price / 12 : plan.price;

  return (
    <div className="bg-white rounded-xl shadow-lg p-8 border-2 border-gray-200 hover:border-blue-500 transition-all">
      <h3 className="text-2xl font-bold text-gray-900 mb-2">
        {isAnnual ? 'Piano Annuale' : 'Piano Mensile'}
      </h3>

      <div className="mb-6">
        <div className="flex items-baseline gap-2">
          <span className="text-4xl font-bold text-blue-600">€{plan.price}</span>
          <span className="text-gray-600">/{isAnnual ? 'anno' : 'mese'}</span>
        </div>
        {isAnnual && (
          <p className="text-sm text-green-600 mt-1">
            Risparmi €{((monthlyPrice * 12) - plan.price).toFixed(2)} all'anno
          </p>
        )}
      </div>

      <ul className="space-y-3 mb-8">
        {plan.features.map((feature, index) => (
          <li key={index} className="flex items-start gap-2">
            <Check className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
            <span className="text-gray-700">{feature}</span>
          </li>
        ))}
      </ul>

      <button
        onClick={onSelect}
        className="w-full bg-blue-600 text-white py-3 px-6 rounded-lg hover:bg-blue-700 transition-colors font-semibold"
      >
        Seleziona Piano
      </button>
    </div>
  );
}

export const CUSTOMER_PLANS: SubscriptionPlan[] = [
  {
    type: 'monthly',
    price: 0.99,
    features: [
      'Scrivi recensioni illimitate',
      'Accesso a tutti gli sconti disponibili',
      'Salva le tue attività preferite',
      'Notifiche sui nuovi sconti',
      'Supporto clienti prioritario',
    ],
  },
  {
    type: 'annual',
    price: 9.90,
    features: [
      'Scrivi recensioni illimitate',
      'Accesso a tutti gli sconti disponibili',
      'Salva le tue attività preferite',
      'Notifiche sui nuovi sconti',
      'Supporto clienti prioritario',
      'Sconti esclusivi per abbonati annuali',
    ],
  },
];

export const BUSINESS_PLANS: SubscriptionPlan[] = [
  {
    type: 'monthly',
    price: 2.49,
    features: [
      'Profilo aziendale completo',
      'Visualizza e rispondi alle recensioni',
      'Crea sconti illimitati',
      'Statistiche sulle recensioni',
      'Badge di verifica',
      'Supporto dedicato',
      'Prezzo escluso IVA',
    ],
  },
  {
    type: 'annual',
    price: 24.90,
    features: [
      'Profilo aziendale completo',
      'Visualizza e rispondi alle recensioni',
      'Crea sconti illimitati',
      'Statistiche sulle recensioni avanzate',
      'Badge di verifica',
      'Supporto dedicato prioritario',
      'Posizionamento in evidenza',
      'Report mensili dettagliati',
      'Prezzo escluso IVA',
    ],
  },
];
