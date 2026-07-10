import React, { useEffect, useState } from 'react';
import { AlertCircle, Clock, X } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useLanguage } from '../../contexts/LanguageContext';

interface TrialStatus {
  is_trial: boolean;
  days_remaining: number;
  trial_end_date: string | null;
  is_expired: boolean;
}

interface TrialStatusBannerProps {
  onUpgradeClick: () => void;
}

export default function TrialStatusBanner({ onUpgradeClick }: TrialStatusBannerProps) {
  const { user, profile } = useAuth();
  const { t } = useLanguage();
  const [trialStatus, setTrialStatus] = useState<TrialStatus | null>(null);
  const [dismissed, setDismissed] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user && profile?.profile_type === 'business') {
      fetchTrialStatus();
    }
  }, [user, profile]);

  const fetchTrialStatus = async () => {
    try {
      const { data, error } = await supabase.rpc('get_trial_status', {
        user_id_param: user!.id
      });

      if (error) throw error;

      if (data && data.length > 0) {
        setTrialStatus(data[0]);
      }
    } catch (error) {
      console.error('Error fetching trial status:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDismiss = () => {
    setDismissed(true);
    sessionStorage.setItem('trial-banner-dismissed', 'true');
  };

  useEffect(() => {
    const wasDismissed = sessionStorage.getItem('trial-banner-dismissed');
    if (wasDismissed === 'true') {
      setDismissed(true);
    }
  }, []);

  if (loading || !trialStatus || dismissed) {
    return null;
  }

  if (!trialStatus.is_trial && !trialStatus.is_expired) {
    return null;
  }

  const getBannerContent = () => {
    if (trialStatus.is_expired) {
      return {
        title: t.trial_expired_title || 'Prova gratuita terminata',
        message: t.trial_expired_message || 'La tua prova gratuita è terminata. Sottoscrivi un piano per continuare.',
        color: 'red',
        icon: <AlertCircle className="w-5 h-5" />
      };
    }

    if (trialStatus.days_remaining <= 7) {
      return {
        title: t.trial_expiring_title || `Prova gratuita: ${trialStatus.days_remaining} ${trialStatus.days_remaining === 1 ? 'giorno' : 'giorni'} rimanenti`,
        message: t.trial_expiring_message || 'Sottoscrivi un piano ora per continuare senza interruzioni.',
        color: 'yellow',
        icon: <Clock className="w-5 h-5" />
      };
    }

    return {
      title: t.trial_active_title || `Prova gratuita attiva: ${trialStatus.days_remaining} giorni rimanenti`,
      message: t.trial_active_message || 'Stai usando la prova gratuita. Esplora tutte le funzionalità premium!',
      color: 'blue',
      icon: <Clock className="w-5 h-5" />
    };
  };

  const content = getBannerContent();

  const colorClasses = {
    red: {
      bg: 'bg-red-50',
      border: 'border-red-200',
      text: 'text-red-800',
      button: 'bg-red-600 hover:bg-red-700 text-white'
    },
    yellow: {
      bg: 'bg-yellow-50',
      border: 'border-yellow-200',
      text: 'text-yellow-800',
      button: 'bg-yellow-600 hover:bg-yellow-700 text-white'
    },
    blue: {
      bg: 'bg-blue-50',
      border: 'border-blue-200',
      text: 'text-blue-800',
      button: 'bg-blue-600 hover:bg-blue-700 text-white'
    }
  };

  const colors = colorClasses[content.color as keyof typeof colorClasses];

  return (
    <div className={`${colors.bg} ${colors.border} border rounded-lg p-4 mb-6`}>
      <div className="flex items-start gap-4">
        <div className={`${colors.text} mt-0.5`}>
          {content.icon}
        </div>

        <div className="flex-1 min-w-0">
          <h3 className={`font-semibold ${colors.text} mb-1`}>
            {content.title}
          </h3>
          <p className={`text-sm ${colors.text}`}>
            {content.message}
          </p>
        </div>

        <div className="flex items-center gap-2">
          {(trialStatus.is_expired || trialStatus.days_remaining <= 7) && (
            <button
              onClick={onUpgradeClick}
              className={`${colors.button} px-4 py-2 rounded-lg font-medium text-sm transition-colors whitespace-nowrap`}
            >
              {t.upgrade_now || 'Sottoscrivi ora'}
            </button>
          )}

          {!trialStatus.is_expired && (
            <button
              onClick={handleDismiss}
              className={`${colors.text} hover:opacity-70 transition-opacity`}
              aria-label="Dismiss"
            >
              <X className="w-5 h-5" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
