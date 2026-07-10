import { useState } from 'react';
import { Shield, AlertTriangle } from 'lucide-react';
import { supabase } from '../lib/supabase';

export function AdminLoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const { data: authData, error: signInError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (signInError) throw signInError;

      if (!authData.user) {
        throw new Error('Errore durante l\'accesso');
      }

      console.log('User logged in:', authData.user.id);

      const { data: adminCheck, error: adminError } = await supabase
        .from('admins')
        .select('user_id')
        .eq('user_id', authData.user.id)
        .maybeSingle();

      console.log('Admin check:', { adminCheck, adminError });

      if (adminError) {
        console.error('Admin check error:', adminError);
        throw adminError;
      }

      if (!adminCheck) {
        console.log('Not an admin, signing out');
        await supabase.auth.signOut();
        throw new Error('Non hai i permessi di amministratore');
      }

      console.log('Admin verified, logging access');

      // Log the admin login
      await supabase.from('admin_login_logs').insert({
        admin_id: authData.user.id,
        login_time: new Date().toISOString(),
      });

      window.location.href = '/admin';
    } catch (err: any) {
      console.error('Error:', err);
      if (err.message?.includes('Invalid login credentials')) {
        setError('Email o password non validi');
      } else {
        setError(err.message || 'Errore durante l\'accesso');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-lg p-8 max-w-md w-full">
        <div className="flex items-center justify-center gap-3 mb-6">
          <Shield className="w-8 h-8 text-blue-600" />
          <h1 className="text-3xl font-bold text-gray-900">Accesso Admin</h1>
        </div>

        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
          <div className="flex gap-2">
            <AlertTriangle className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div className="text-sm text-blue-800">
              <p className="font-semibold mb-1">Area Amministratori</p>
              <p>Accesso riservato agli amministratori della piattaforma</p>
            </div>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
              Email Amministratore
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoComplete="email"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-1">
              Password
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              autoComplete="current-password"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          {error && (
            <div className="bg-red-50 border border-red-200 rounded-lg p-3">
              <p className="text-sm text-red-800">{error}</p>
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 transition-colors disabled:bg-gray-400 font-semibold"
          >
            {loading ? 'Accesso in corso...' : 'Accedi come Admin'}
          </button>

          <div className="text-center pt-4 space-y-2">
            <a
              href="/admin-secure-register-2024"
              className="block text-sm text-blue-600 hover:text-blue-800 font-medium"
            >
              Non hai un account admin? Registrati
            </a>
            <a
              href="/"
              className="block text-sm text-gray-600 hover:text-gray-900"
            >
              Torna alla Home
            </a>
          </div>
        </form>
      </div>
    </div>
  );
}
