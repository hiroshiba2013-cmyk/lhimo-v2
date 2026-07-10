import { useState, useEffect } from 'react';
import { CreditCard, Check } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  billing_period: 'monthly' | 'yearly';
  max_persons: number;
}

interface Subscription {
  id: string;
  plan: SubscriptionPlan;
  status: string;
  start_date: string;
  end_date: string;
  trial_end_date?: string;
}

interface SubscriptionManagementProps {
  userId: string;
  userType: 'customer' | 'business';
  currentSubscriptionStatus: string;
  onUpdate: () => void;
}

export function SubscriptionManagement({
  userId,
  userType,
  currentSubscriptionStatus,
  onUpdate
}: SubscriptionManagementProps) {
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [currentSubscription, setCurrentSubscription] = useState<Subscription | null>(null);
  const [availablePlans, setAvailablePlans] = useState<SubscriptionPlan[]>([]);
  const [showPlans, setShowPlans] = useState(false);

  useEffect(() => {
    loadSubscription();
    loadPlans();
  }, [userId, userType]);

  const loadSubscription = async () => {
    const { data, error } = await supabase
      .from('subscriptions')
      .select('id, status, start_date, end_date, trial_end_date, plan:subscription_plans(id, name, price, billing_period, max_persons)')
      .eq('customer_id', userId)
      .in('status', ['active', 'trial'])
      .maybeSingle();

    if (!error && data) {
      setCurrentSubscription(data as any);
    }
  };

  const loadPlans = async () => {
    let query = supabase
      .from('subscription_plans')
      .select('*');

    // Filtra i piani in base al tipo di utente
    if (userType === 'business') {
      query = query.like('name', '%Business%');
    } else {
      query = query.not('name', 'like', '%Business%');
    }

    const { data } = await query
      .order('billing_period')
      .order('max_persons');

    if (data) {
      setAvailablePlans(data);
    }
  };

  const handleSelectPlan = async (planId: string) => {
    setLoading(true);
    setMessage('');

    try {
      // Verifica se l'utente è in trial
      if (currentSubscription?.status === 'trial') {
        const trialEndDate = new Date(currentSubscription.trial_end_date || currentSubscription.end_date);
        const today = new Date();

        if (trialEndDate > today) {
          setMessage('Non puoi cambiare piano durante il periodo di prova. Se cambi piano perdi il diritto alla prova gratuita di 30 giorni. Attendi la scadenza del trial per selezionare un piano.');
          setLoading(false);
          return;
        }
      }

      const selectedPlan = availablePlans.find(p => p.id === planId);
      if (!selectedPlan) throw new Error('Piano non trovato');

      const endDate = new Date();
      if (selectedPlan.billing_period === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else {
        endDate.setFullYear(endDate.getFullYear() + 1);
      }

      if (currentSubscription) {
        const { error: updateError } = await supabase
          .from('subscriptions')
          .update({
            plan_id: planId,
            start_date: new Date().toISOString(),
            end_date: endDate.toISOString(),
            status: 'active',
            payment_method_added: true,
          })
          .eq('id', currentSubscription.id);

        if (updateError) throw updateError;
      } else {
        const { error: insertError } = await supabase
          .from('subscriptions')
          .insert({
            customer_id: userId,
            plan_id: planId,
            status: 'active',
            start_date: new Date().toISOString(),
            end_date: endDate.toISOString(),
            payment_method_added: true,
            reminder_sent: false,
          });

        if (insertError) throw insertError;
      }

      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          subscription_type: selectedPlan.name,
          subscription_status: 'active',
          subscription_expires_at: endDate.toISOString(),
        })
        .eq('id', userId);

      if (profileError) throw profileError;

      setMessage('Abbonamento attivato con successo!');
      setShowPlans(false);

      setTimeout(() => {
        onUpdate();
        setMessage('');
      }, 2000);
    } catch (error) {
      console.error('Error updating subscription:', error);
      setMessage('Errore durante l\'attivazione dell\'abbonamento');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white rounded-xl shadow-md p-8 mb-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <CreditCard className="w-6 h-6 text-blue-600" />
          <h2 className="text-2xl font-bold text-gray-900">Gestione Abbonamento</h2>
        </div>
        <button
          onClick={() => setShowPlans(!showPlans)}
          className={`px-6 py-2 rounded-lg font-semibold transition-colors ${
            showPlans
              ? 'bg-gray-500 text-white hover:bg-gray-600'
              : currentSubscription
              ? currentSubscription.status === 'trial'
                ? 'bg-purple-600 text-white hover:bg-purple-700'
                : 'bg-blue-600 text-white hover:bg-blue-700'
              : 'bg-green-600 text-white hover:bg-green-700'
          }`}
        >
          {showPlans
            ? 'Nascondi Piani'
            : currentSubscription
              ? currentSubscription.status === 'trial'
                ? 'Visualizza Piani'
                : 'Cambia Piano'
              : 'Attiva Abbonamento'
          }
        </button>
      </div>

      {message && (
        <div className={`mb-6 p-4 rounded-lg ${
          message.includes('successo') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
        }`}>
          {message}
        </div>
      )}

      {currentSubscription && (
        <div className={`bg-gradient-to-br rounded-lg p-6 mb-6 ${
          currentSubscription.status === 'trial'
            ? 'from-purple-50 to-purple-100'
            : 'from-blue-50 to-blue-100'
        }`}>
          <div className="flex items-center justify-between mb-4">
            <div>
              <p className="text-sm text-gray-600 mb-1">
                {currentSubscription.status === 'trial' ? 'Prova Gratuita 1 Mese' : 'Piano Attuale'}
              </p>
              <p className="text-2xl font-bold text-gray-900">{currentSubscription.plan.name}</p>
              <p className="text-sm font-medium text-gray-700 mt-1">
                Abbonamento {currentSubscription.plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}
              </p>
            </div>
            <div className="text-right">
              {currentSubscription.status === 'trial' ? (
                <>
                  <p className="text-3xl font-bold text-purple-600">GRATIS</p>
                  <p className="text-sm text-gray-600">Primo mese gratuito</p>
                  <p className="text-xs text-gray-500 mt-1">
                    Poi €{Number(currentSubscription.plan.price).toFixed(2)}/{currentSubscription.plan.billing_period === 'monthly' ? 'mese' : 'anno'}
                  </p>
                </>
              ) : (
                <>
                  <p className="text-3xl font-bold text-blue-600">
                    €{Number(currentSubscription.plan.price).toFixed(2)}
                  </p>
                  <p className="text-sm text-gray-600">
                    {currentSubscription.plan.billing_period === 'monthly' ? 'al mese' : 'all\'anno'}
                  </p>
                </>
              )}
            </div>
          </div>

          <div className={`border rounded-lg p-4 ${
            currentSubscription.status === 'trial'
              ? 'bg-purple-50 border-purple-200'
              : 'bg-green-50 border-green-200'
          }`}>
            <div className="flex items-center justify-between">
              <div className="flex-1">
                <p className={`font-semibold ${
                  currentSubscription.status === 'trial' ? 'text-purple-800' : 'text-green-800'
                }`}>
                  {currentSubscription.status === 'trial' ? 'Periodo Gratuito Attivo' : 'Abbonamento Attivo'}
                </p>
                <p className={`text-sm ${
                  currentSubscription.status === 'trial' ? 'text-purple-700' : 'text-green-700'
                }`}>
                  {currentSubscription.status === 'trial'
                    ? (() => {
                        const endDate = new Date(currentSubscription.end_date);
                        const today = new Date();
                        const daysRemaining = Math.ceil((endDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
                        return `Giorni rimanenti: ${daysRemaining} - Termina il ${endDate.toLocaleDateString('it-IT')}`;
                      })()
                    : `Scade il ${new Date(currentSubscription.end_date).toLocaleDateString('it-IT')}`
                  }
                </p>
              </div>
              <div className={`w-3 h-3 rounded-full ${
                currentSubscription.status === 'trial' ? 'bg-purple-500' : 'bg-green-500'
              }`}></div>
            </div>
          </div>

          {currentSubscription.status === 'trial' && (
            <div className="mt-4 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
              <p className="text-sm font-semibold text-yellow-800 mb-1">
                Attenzione: Piano Bloccato Durante Trial
              </p>
              <p className="text-xs text-yellow-700">
                Durante il periodo di prova non puoi cambiare piano. Se cambi piano perdi il diritto alla prova gratuita di 30 giorni. Potrai scegliere un piano diverso dopo la scadenza del trial.
              </p>
            </div>
          )}

          <div className="mt-4 space-y-2">
            <h3 className="font-semibold text-gray-900">Incluso:</h3>
            <ul className="space-y-1 text-sm text-gray-700">
              {userType === 'customer' ? (
                <>
                  <li className="flex items-center gap-2">
                    <Check className="w-4 h-4 text-green-600" />
                    Recensioni illimitate
                  </li>
                  <li className="flex items-center gap-2">
                    <Check className="w-4 h-4 text-green-600" />
                    Accesso a tutti gli sconti
                  </li>
                  <li className="flex items-center gap-2">
                    <Check className="w-4 h-4 text-green-600" />
                    Supporto prioritario
                  </li>
                </>
              ) : (
                <>
                  <li className="flex items-center gap-2">
                    <Check className="w-4 h-4 text-green-600" />
                    Profilo aziendale completo
                  </li>
                  <li className="flex items-center gap-2">
                    <Check className="w-4 h-4 text-green-600" />
                    Gestione recensioni
                  </li>
                  <li className="flex items-center gap-2">
                    <Check className="w-4 h-4 text-green-600" />
                    Sconti illimitati
                  </li>
                </>
              )}
            </ul>
          </div>
        </div>
      )}

      {currentSubscription && currentSubscription.status === 'trial' && (
        <div className="bg-blue-50 border-l-4 border-blue-500 p-6 mb-6 rounded-r-lg">
          <h3 className="font-semibold text-blue-900 mb-2">Informazioni sul Periodo di Prova</h3>
          <ul className="space-y-2 text-sm text-blue-800">
            <li className="flex items-start gap-2">
              <Check className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <span>
                <strong>Durata:</strong> Il periodo di prova dura 30 giorni (1 mese) a partire dalla data di iscrizione
              </span>
            </li>
            <li className="flex items-start gap-2">
              <Check className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <span>
                <strong>Accesso completo:</strong> Durante la prova hai accesso a tutte le funzionalità incluse nel piano
              </span>
            </li>
            <li className="flex items-start gap-2">
              <Check className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <span>
                <strong>Nessun addebito:</strong> Non verrà addebitato alcun costo durante il periodo di prova
              </span>
            </li>
            <li className="flex items-start gap-2">
              <Check className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <span>
                <strong>Dopo la prova:</strong> Al termine del periodo di prova, potrai scegliere un piano a pagamento per continuare a utilizzare il servizio
              </span>
            </li>
          </ul>
        </div>
      )}

      {!currentSubscription && !showPlans && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-6 text-center mb-6">
          <p className="text-yellow-800 font-semibold mb-2">Nessun abbonamento attivo</p>
          <p className="text-yellow-700 text-sm">
            Clicca su "Attiva Abbonamento" per scegliere un piano
          </p>
        </div>
      )}

      {showPlans && availablePlans.length > 0 && (
        <div className="mt-6">
          <h3 className="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
            {currentSubscription ? 'Cambia Piano' : 'Piani Disponibili'}
          </h3>

          <div className="space-y-8">
            <div>
              <h4 className="text-lg font-semibold text-gray-700 mb-4">Piani Mensili</h4>
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
                {availablePlans
                  .filter(plan => plan.billing_period === 'monthly')
                  .map((plan) => (
                    <div
                      key={plan.id}
                      className={`border-2 rounded-xl p-6 transition-all ${
                        currentSubscription?.plan.id === plan.id
                          ? 'border-green-500 bg-green-50 shadow-lg'
                          : 'border-gray-200 hover:border-blue-500 hover:shadow-md'
                      }`}
                    >
                      <div className="text-center mb-4">
                        <h5 className="font-bold text-lg text-gray-900 mb-2">{plan.name}</h5>
                        <div className="mb-3">
                          <span className="text-4xl font-bold text-blue-600">
                            €{Number(plan.price).toFixed(2)}
                          </span>
                          <span className="text-sm text-gray-600">/mese</span>
                        </div>
                        <p className="text-sm text-gray-600">
                          Fino a {plan.max_persons} {userType === 'business' ? (plan.max_persons === 1 ? 'sede' : 'sedi') : (plan.max_persons === 1 ? 'persona' : 'persone')}
                        </p>
                      </div>

                      <div className="mb-4 space-y-2">
                        {userType === 'customer' ? (
                          <>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Recensioni illimitate</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Accesso agli sconti</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Supporto prioritario</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Sistema punti fedeltà</span>
                            </div>
                          </>
                        ) : (
                          <>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Gestione {plan.max_persons} {plan.max_persons === 1 ? 'sede' : 'sedi'}</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Sconti illimitati</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Offerte di lavoro</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Risposta alle recensioni</span>
                            </div>
                          </>
                        )}
                      </div>

                      {currentSubscription?.plan.id === plan.id ? (
                        <div className="w-full bg-green-600 text-white py-3 px-4 rounded-lg font-semibold text-center flex items-center justify-center gap-2">
                          <Check className="w-5 h-5" />
                          Piano Attuale
                        </div>
                      ) : (
                        <button
                          onClick={() => handleSelectPlan(plan.id)}
                          disabled={loading || (currentSubscription?.status === 'trial' && new Date(currentSubscription.trial_end_date || currentSubscription.end_date) > new Date())}
                          className={`w-full py-3 px-4 rounded-lg transition-colors font-semibold ${
                            currentSubscription?.status === 'trial' && new Date(currentSubscription.trial_end_date || currentSubscription.end_date) > new Date()
                              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                              : 'bg-blue-600 text-white hover:bg-blue-700 disabled:bg-gray-400'
                          }`}
                          title={currentSubscription?.status === 'trial' && new Date(currentSubscription.trial_end_date || currentSubscription.end_date) > new Date() ? 'Non puoi cambiare piano durante il periodo di prova' : ''}
                        >
                          {loading ? 'Attivazione...' : currentSubscription?.status === 'trial' ? 'Bloccato (Trial)' : 'Seleziona Piano'}
                        </button>
                      )}
                    </div>
                  ))}
              </div>
            </div>

            <div>
              <h4 className="text-lg font-semibold text-gray-700 mb-4">Piani Annuali</h4>
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
                {availablePlans
                  .filter(plan => plan.billing_period === 'yearly')
                  .map((plan) => (
                    <div
                      key={plan.id}
                      className={`border-2 rounded-xl p-6 transition-all relative ${
                        currentSubscription?.plan.id === plan.id
                          ? 'border-green-500 bg-green-50 shadow-lg'
                          : 'border-gray-200 hover:border-blue-500 hover:shadow-md'
                      }`}
                    >
                      <div className="absolute -top-3 right-4 bg-gradient-to-r from-yellow-400 to-orange-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                        RISPARMIA
                      </div>

                      <div className="text-center mb-4">
                        <h5 className="font-bold text-lg text-gray-900 mb-2">{plan.name}</h5>
                        <div className="mb-3">
                          <span className="text-4xl font-bold text-blue-600">
                            €{Number(plan.price).toFixed(2)}
                          </span>
                          <span className="text-sm text-gray-600">/anno</span>
                        </div>
                        <p className="text-xs text-gray-500 mb-1">
                          €{(Number(plan.price) / 12).toFixed(2)}/mese
                        </p>
                        <p className="text-sm text-gray-600">
                          Fino a {plan.max_persons} {userType === 'business' ? (plan.max_persons === 1 ? 'sede' : 'sedi') : (plan.max_persons === 1 ? 'persona' : 'persone')}
                        </p>
                      </div>

                      <div className="mb-4 space-y-2">
                        {userType === 'customer' ? (
                          <>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Recensioni illimitate</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Accesso agli sconti</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Supporto prioritario</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Sistema punti fedeltà</span>
                            </div>
                          </>
                        ) : (
                          <>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Gestione {plan.max_persons} {plan.max_persons === 1 ? 'sede' : 'sedi'}</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Sconti illimitati</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Offerte di lavoro</span>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-700">
                              <Check className="w-4 h-4 text-green-600" />
                              <span>Risposta alle recensioni</span>
                            </div>
                          </>
                        )}
                      </div>

                      {currentSubscription?.plan.id === plan.id ? (
                        <div className="w-full bg-green-600 text-white py-3 px-4 rounded-lg font-semibold text-center flex items-center justify-center gap-2">
                          <Check className="w-5 h-5" />
                          Piano Attuale
                        </div>
                      ) : (
                        <button
                          onClick={() => handleSelectPlan(plan.id)}
                          disabled={loading || (currentSubscription?.status === 'trial' && new Date(currentSubscription.trial_end_date || currentSubscription.end_date) > new Date())}
                          className={`w-full py-3 px-4 rounded-lg transition-colors font-semibold ${
                            currentSubscription?.status === 'trial' && new Date(currentSubscription.trial_end_date || currentSubscription.end_date) > new Date()
                              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                              : 'bg-blue-600 text-white hover:bg-blue-700 disabled:bg-gray-400'
                          }`}
                          title={currentSubscription?.status === 'trial' && new Date(currentSubscription.trial_end_date || currentSubscription.end_date) > new Date() ? 'Non puoi cambiare piano durante il periodo di prova' : ''}
                        >
                          {loading ? 'Attivazione...' : currentSubscription?.status === 'trial' ? 'Bloccato (Trial)' : 'Seleziona Piano'}
                        </button>
                      )}
                    </div>
                  ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
