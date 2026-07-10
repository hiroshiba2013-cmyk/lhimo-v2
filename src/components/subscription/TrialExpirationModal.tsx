import React, { useEffect, useState } from 'react';
import { AlertTriangle, Check, X } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useLanguage } from '../../contexts/LanguageContext';
import { useNavigate } from '../../components/Router';

interface TrialStatus {
  is_trial: boolean;
  days_remaining: number;
  trial_end_date: string | null;
  is_expired: boolean;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  billing_period: string;
  features: string[];
}

export default function TrialExpirationModal() {
  const { user, profile } = useAuth();
  const { t } = useLanguage();
  const navigate = useNavigate();
  const [trialStatus, setTrialStatus] = useState<TrialStatus | null>(null);
  const [plans, setPlans] = useState<SubscriptionPlan[]>([]);
  const [loading, setLoading] = useState(true);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    if (user && profile?.profile_type === 'business') {
      checkTrialStatus();
      fetchPlans();
    }
  }, [user, profile]);

  const checkTrialStatus = async () => {
    try {
      const { data, error } = await supabase.rpc('get_trial_status', {
        user_id_param: user!.id
      });

      if (error) throw error;

      if (data && data.length > 0) {
        const status = data[0];
        setTrialStatus(status);

        if (status.is_expired) {
          const modalShown = sessionStorage.getItem('trial-modal-shown');
          if (!modalShown) {
            setIsOpen(true);
            sessionStorage.setItem('trial-modal-shown', 'true');
          }
        }
      }
    } catch (error) {
      console.error('Error checking trial status:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchPlans = async () => {
    try {
      const { data, error } = await supabase
        .from('subscription_plans')
        .select('*')
        .eq('active', true)
        .order('price', { ascending: true });

      if (error) throw error;
      setPlans(data || []);
    } catch (error) {
      console.error('Error fetching plans:', error);
    }
  };

  const handleSubscribe = (planId: string) => {
    navigate('/subscription', { planId });
    setIsOpen(false);
  };

  const handleClose = () => {
    setIsOpen(false);
  };

  if (loading || !trialStatus?.is_expired || !isOpen) {
    return null;
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center">
                <AlertTriangle className="w-6 h-6 text-red-600" />
              </div>
              <div>
                <h2 className="text-2xl font-bold text-gray-900">
                  {t.trial_expired_title || 'Prova gratuita terminata'}
                </h2>
                <p className="text-sm text-gray-600">
                  {t.trial_expired_subtitle || 'Scegli un piano per continuare ad accedere alle funzionalità premium'}
                </p>
              </div>
            </div>
            <button
              onClick={handleClose}
              className="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>
        </div>

        <div className="p-6">
          <div className="mb-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              {t.trial_expired_message || 'La tua prova gratuita di 1 mese è terminata'}
            </h3>
            <p className="text-gray-600">
              {t.trial_expired_description || 'Per continuare a utilizzare tutte le funzionalità premium della piattaforma, seleziona uno dei nostri piani di abbonamento.'}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {plans.map((plan) => (
              <div
                key={plan.id}
                className="border-2 border-gray-200 rounded-lg p-6 hover:border-blue-500 transition-colors"
              >
                <div className="mb-4">
                  <h4 className="text-xl font-bold text-gray-900 mb-2">
                    {plan.name}
                  </h4>
                  <div className="flex items-baseline gap-1">
                    <span className="text-3xl font-bold text-gray-900">
                      €{plan.price}
                    </span>
                    <span className="text-gray-600">
                      /{plan.billing_period === 'monthly' ? t.month || 'mese' : t.year || 'anno'}
                    </span>
                  </div>
                </div>

                <ul className="space-y-3 mb-6">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start gap-2">
                      <Check className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
                      <span className="text-sm text-gray-700">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  onClick={() => handleSubscribe(plan.id)}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 rounded-lg transition-colors"
                >
                  {t.subscribe_now || 'Sottoscrivi ora'}
                </button>
              </div>
            ))}
          </div>

          <div className="mt-6 p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600 text-center">
              {t.trial_expired_note || 'Non preoccuparti, i tuoi dati sono al sicuro. Sottoscrivi ora per riprendere da dove hai lasciato.'}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
