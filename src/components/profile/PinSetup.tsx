import { useState } from 'react';
import { Lock, Eye, EyeOff, Shield } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface PinSetupProps {
  profileId: string;
  profileName: string;
  isOwner: boolean;
  userType: 'customer' | 'business';
  currentPinEnabled?: boolean;
  onSuccess?: () => void;
}

async function hashPin(pin: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(pin);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  return hashHex;
}

export function PinSetup({ profileId, profileName, isOwner, userType, currentPinEnabled = false, onSuccess }: PinSetupProps) {
  const [pinEnabled, setPinEnabled] = useState(currentPinEnabled);
  const [newPin, setNewPin] = useState('');
  const [confirmPin, setConfirmPin] = useState('');
  const [showNewPin, setShowNewPin] = useState(false);
  const [showConfirmPin, setShowConfirmPin] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [loading, setLoading] = useState(false);

  const handleTogglePin = async () => {
    if (pinEnabled) {
      try {
        setLoading(true);
        setError('');

        const tableName = isOwner ? 'profiles' : (userType === 'customer' ? 'customer_family_members' : 'business_locations');

        const { error: updateError } = await supabase
          .from(tableName)
          .update({
            pin_enabled: false,
            pin_code: null
          })
          .eq('id', profileId);

        if (updateError) throw updateError;

        setPinEnabled(false);
        setNewPin('');
        setConfirmPin('');
        setSuccess('PIN disabilitato con successo');

        if (onSuccess) onSuccess();

        setTimeout(() => setSuccess(''), 3000);
      } catch (err) {
        console.error('Error disabling PIN:', err);
        setError('Errore durante la disabilitazione del PIN');
      } finally {
        setLoading(false);
      }
    } else {
      setPinEnabled(true);
    }
  };

  const handleSavePin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (newPin.length !== 4) {
      setError('Il PIN deve essere di 4 cifre');
      return;
    }

    if (!/^\d+$/.test(newPin)) {
      setError('Il PIN deve contenere solo numeri');
      return;
    }

    if (newPin !== confirmPin) {
      setError('I PIN non corrispondono');
      return;
    }

    try {
      setLoading(true);
      const hashedPin = await hashPin(newPin);

      const tableName = isOwner ? 'profiles' : (userType === 'customer' ? 'customer_family_members' : 'business_locations');

      const { error: updateError } = await supabase
        .from(tableName)
        .update({
          pin_enabled: true,
          pin_code: hashedPin
        })
        .eq('id', profileId);

      if (updateError) throw updateError;

      setSuccess('PIN impostato con successo');
      setNewPin('');
      setConfirmPin('');

      if (onSuccess) onSuccess();

      setTimeout(() => setSuccess(''), 3000);
    } catch (err) {
      console.error('Error saving PIN:', err);
      setError('Errore durante il salvataggio del PIN');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white rounded-xl shadow-md p-6">
      <div className="flex items-center gap-3 mb-6">
        <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
          <Shield className="w-6 h-6 text-blue-600" />
        </div>
        <div>
          <h3 className="text-lg font-bold text-gray-900">Protezione PIN</h3>
          <p className="text-sm text-gray-600">{profileName}</p>
        </div>
      </div>

      <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg mb-6">
        <div className="flex items-center gap-3">
          <Lock className="w-5 h-5 text-gray-600" />
          <div>
            <p className="font-medium text-gray-900">Abilita PIN</p>
            <p className="text-sm text-gray-600">Richiedi un PIN per accedere a questo profilo</p>
          </div>
        </div>
        <button
          onClick={handleTogglePin}
          disabled={loading}
          className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
            pinEnabled ? 'bg-blue-600' : 'bg-gray-300'
          } disabled:opacity-50`}
        >
          <span
            className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
              pinEnabled ? 'translate-x-6' : 'translate-x-1'
            }`}
          />
        </button>
      </div>

      {pinEnabled && (
        <form onSubmit={handleSavePin} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Nuovo PIN (4 cifre)
            </label>
            <div className="relative">
              <input
                type={showNewPin ? 'text' : 'password'}
                value={newPin}
                onChange={(e) => setNewPin(e.target.value.replace(/\D/g, '').slice(0, 4))}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pr-12 text-center text-2xl tracking-widest"
                placeholder="••••"
                maxLength={4}
                inputMode="numeric"
                pattern="[0-9]*"
                disabled={loading}
              />
              <button
                type="button"
                onClick={() => setShowNewPin(!showNewPin)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                {showNewPin ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Conferma PIN
            </label>
            <div className="relative">
              <input
                type={showConfirmPin ? 'text' : 'password'}
                value={confirmPin}
                onChange={(e) => setConfirmPin(e.target.value.replace(/\D/g, '').slice(0, 4))}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pr-12 text-center text-2xl tracking-widest"
                placeholder="••••"
                maxLength={4}
                inputMode="numeric"
                pattern="[0-9]*"
                disabled={loading}
              />
              <button
                type="button"
                onClick={() => setShowConfirmPin(!showConfirmPin)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                {showConfirmPin ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
          </div>

          {error && (
            <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
              <p className="text-sm text-red-600">{error}</p>
            </div>
          )}

          {success && (
            <div className="p-4 bg-green-50 border border-green-200 rounded-lg">
              <p className="text-sm text-green-600">{success}</p>
            </div>
          )}

          <button
            type="submit"
            disabled={loading || !newPin || !confirmPin}
            className="w-full px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? 'Salvataggio...' : 'Salva PIN'}
          </button>
        </form>
      )}

      <div className="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
        <p className="text-sm text-blue-800">
          <strong>Nota:</strong> Il PIN verrà richiesto ogni volta che selezioni questo profilo dopo il login.
          Assicurati di ricordarlo, poiché non sarà possibile recuperarlo.
        </p>
      </div>
    </div>
  );
}
