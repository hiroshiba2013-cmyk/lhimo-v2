import React, { useState } from 'react';
import { Download, MapPin, Loader2, CheckCircle, AlertCircle } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface ImportBusinessesFormProps {
  onImportComplete?: () => void;
}

type ImportSource = 'osm' | 'google';

export function ImportBusinessesForm({ onImportComplete }: ImportBusinessesFormProps) {
  const [source, setSource] = useState<ImportSource>('osm');
  const [city, setCity] = useState('');
  const [province, setProvince] = useState('');
  const [googleApiKey, setGoogleApiKey] = useState('');
  const [radius, setRadius] = useState('5000');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<{ success: boolean; message: string; count?: number } | null>(null);

  const handleImport = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setResult(null);

    try {
      const session = await supabase.auth.getSession();
      if (!session.data.session) {
        throw new Error('Devi essere autenticato per importare attività');
      }

      const functionName = source === 'osm' ? 'import-businesses-osm' : 'import-businesses-google';
      const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/${functionName}`;

      const body: any = {
        city,
        province,
        radius: parseInt(radius),
      };

      if (source === 'google') {
        if (!googleApiKey.trim()) {
          throw new Error('API Key di Google è richiesta per questa fonte');
        }
        body.apiKey = googleApiKey;
      }

      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${session.data.session.access_token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Errore durante l\'importazione');
      }

      setResult({
        success: true,
        message: data.message,
        count: data.imported,
      });

      if (onImportComplete) {
        onImportComplete();
      }

      setCity('');
      setProvince('');
      setGoogleApiKey('');
    } catch (err: any) {
      setResult({
        success: false,
        message: err.message,
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center gap-2 mb-6">
        <Download className="w-5 h-5 text-blue-600" />
        <h2 className="text-xl font-semibold text-gray-900">Importa Attività Reali</h2>
      </div>

      <form onSubmit={handleImport} className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Fonte dei Dati
          </label>
          <div className="grid grid-cols-2 gap-4">
            <button
              type="button"
              onClick={() => setSource('osm')}
              className={`p-4 rounded-lg border-2 transition-all ${
                source === 'osm'
                  ? 'border-blue-500 bg-blue-50'
                  : 'border-gray-200 hover:border-gray-300'
              }`}
            >
              <div className="flex items-center gap-2 mb-2">
                <MapPin className="w-5 h-5" />
                <span className="font-medium">OpenStreetMap</span>
              </div>
              <p className="text-xs text-gray-600">
                Gratuito, dati open source
              </p>
            </button>
            <button
              type="button"
              onClick={() => setSource('google')}
              className={`p-4 rounded-lg border-2 transition-all ${
                source === 'google'
                  ? 'border-blue-500 bg-blue-50'
                  : 'border-gray-200 hover:border-gray-300'
              }`}
            >
              <div className="flex items-center gap-2 mb-2">
                <MapPin className="w-5 h-5" />
                <span className="font-medium">Google Places</span>
              </div>
              <p className="text-xs text-gray-600">
                Richiede API key, più completo
              </p>
            </button>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label htmlFor="city" className="block text-sm font-medium text-gray-700 mb-1">
              Città *
            </label>
            <input
              type="text"
              id="city"
              value={city}
              onChange={(e) => setCity(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="es. Varese"
              required
            />
          </div>
          <div>
            <label htmlFor="province" className="block text-sm font-medium text-gray-700 mb-1">
              Provincia *
            </label>
            <input
              type="text"
              id="province"
              value={province}
              onChange={(e) => setProvince(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="es. VA"
              maxLength={2}
              required
            />
          </div>
        </div>

        <div>
          <label htmlFor="radius" className="block text-sm font-medium text-gray-700 mb-1">
            Raggio di Ricerca (metri)
          </label>
          <input
            type="number"
            id="radius"
            value={radius}
            onChange={(e) => setRadius(e.target.value)}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            min="1000"
            max="50000"
            step="1000"
          />
          <p className="mt-1 text-xs text-gray-500">
            Distanza dal centro della città (consigliato: 5000-10000m)
          </p>
        </div>

        {source === 'google' && (
          <div>
            <label htmlFor="googleApiKey" className="block text-sm font-medium text-gray-700 mb-1">
              Google Places API Key *
            </label>
            <input
              type="password"
              id="googleApiKey"
              value={googleApiKey}
              onChange={(e) => setGoogleApiKey(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="Inserisci la tua API key di Google"
              required
            />
            <p className="mt-1 text-xs text-gray-500">
              Ottieni una chiave API su{' '}
              <a
                href="https://console.cloud.google.com/apis/credentials"
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-600 hover:underline"
              >
                Google Cloud Console
              </a>
            </p>
          </div>
        )}

        {result && (
          <div
            className={`p-4 rounded-lg flex items-start gap-3 ${
              result.success
                ? 'bg-green-50 border border-green-200'
                : 'bg-red-50 border border-red-200'
            }`}
          >
            {result.success ? (
              <CheckCircle className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
            ) : (
              <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
            )}
            <div>
              <p className={`font-medium ${result.success ? 'text-green-900' : 'text-red-900'}`}>
                {result.message}
              </p>
              {result.count !== undefined && (
                <p className="text-sm text-green-700 mt-1">
                  {result.count} attività importate con successo
                </p>
              )}
            </div>
          </div>
        )}

        <button
          type="submit"
          disabled={loading}
          className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
        >
          {loading ? (
            <>
              <Loader2 className="w-5 h-5 animate-spin" />
              Importazione in corso...
            </>
          ) : (
            <>
              <Download className="w-5 h-5" />
              Importa Attività
            </>
          )}
        </button>
      </form>

      <div className="mt-6 p-4 bg-blue-50 rounded-lg">
        <h3 className="font-medium text-blue-900 mb-2">Informazioni sull'Importazione</h3>
        <ul className="text-sm text-blue-800 space-y-1">
          <li>• Le attività importate saranno marcate come "non reclamate"</li>
          <li>• I titolari potranno reclamarle e gestirle</li>
          <li>• OpenStreetMap è gratuito ma può avere meno dati</li>
          <li>• Google Places è più completo ma richiede API key con limiti di utilizzo</li>
          <li>• L'importazione può richiedere alcuni minuti per città grandi</li>
        </ul>
      </div>
    </div>
  );
}
