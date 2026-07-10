import { useState } from 'react';
import { Trash2, AlertTriangle, Shield } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface DeleteAdminAccountButtonProps {
  adminId: string;
  adminEmail: string;
}

export function DeleteAdminAccountButton({ adminId, adminEmail }: DeleteAdminAccountButtonProps) {
  const { showToast } = useToast();
  const [showModal, setShowModal] = useState(false);
  const [confirmEmail, setConfirmEmail] = useState('');
  const [confirmText, setConfirmText] = useState('');
  const [isDeleting, setIsDeleting] = useState(false);
  const [error, setError] = useState('');

  const handleDelete = async () => {
    if (confirmEmail !== adminEmail) {
      setError('L\'email inserita non corrisponde');
      return;
    }

    if (confirmText !== 'ELIMINA ACCOUNT ADMIN') {
      setError('Il testo di conferma non corrisponde');
      return;
    }

    if (!confirm('ATTENZIONE: Questa azione è IRREVERSIBILE. Sei assolutamente sicuro di voler eliminare questo account admin?')) {
      return;
    }

    setIsDeleting(true);
    setError('');

    try {
      const { error: deleteError } = await supabase.rpc('delete_admin_account');

      if (deleteError) throw deleteError;

      showToast('Account admin eliminato con successo', 'success');

      await supabase.auth.signOut();
      localStorage.clear();
      window.location.href = '/';
    } catch (err: any) {
      console.error('Error deleting admin account:', err);
      setError(err.message || 'Errore durante l\'eliminazione dell\'account');
      setIsDeleting(false);
    }
  };

  return (
    <>
      <button
        onClick={() => setShowModal(true)}
        className="flex items-center gap-2 px-4 py-2.5 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium shadow-md hover:shadow-lg"
      >
        <Trash2 className="w-4 h-4" />
        Elimina Account Admin
      </button>

      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b border-gray-200 bg-red-50">
              <div className="flex items-center gap-3">
                <div className="p-3 bg-red-600 rounded-lg">
                  <AlertTriangle className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h2 className="text-2xl font-bold text-gray-900">Elimina Account Admin</h2>
                  <p className="text-sm text-red-700 font-semibold">ATTENZIONE: Azione Irreversibile!</p>
                </div>
              </div>
            </div>

            <div className="p-6 space-y-6">
              <div className="bg-red-50 border-l-4 border-red-600 p-4 rounded-lg">
                <div className="flex items-start gap-3">
                  <Shield className="w-6 h-6 text-red-600 flex-shrink-0 mt-0.5" />
                  <div className="space-y-2">
                    <p className="font-bold text-red-900">Questa azione eliminerà permanentemente:</p>
                    <ul className="list-disc list-inside space-y-1 text-sm text-red-800">
                      <li>Il tuo profilo amministratore</li>
                      <li>Tutti i dati associati al tuo account</li>
                      <li>I log di accesso e attività</li>
                      <li>Tutte le tue impostazioni</li>
                    </ul>
                    <p className="font-bold text-red-900 mt-3">NON POTRAI RECUPERARE QUESTI DATI!</p>
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Per confermare, inserisci la tua email: <span className="text-red-600">*</span>
                  </label>
                  <input
                    type="email"
                    value={confirmEmail}
                    onChange={(e) => {
                      setConfirmEmail(e.target.value);
                      setError('');
                    }}
                    placeholder={adminEmail}
                    className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
                    disabled={isDeleting}
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Scrivi esattamente: <span className="font-mono bg-red-100 px-2 py-1 rounded text-red-700">ELIMINA ACCOUNT ADMIN</span>
                  </label>
                  <input
                    type="text"
                    value={confirmText}
                    onChange={(e) => {
                      setConfirmText(e.target.value);
                      setError('');
                    }}
                    placeholder="ELIMINA ACCOUNT ADMIN"
                    className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent font-mono"
                    disabled={isDeleting}
                  />
                </div>
              </div>

              {error && (
                <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg">
                  {error}
                </div>
              )}

              <div className="flex gap-3 pt-4">
                <button
                  onClick={handleDelete}
                  disabled={isDeleting || !confirmEmail || !confirmText}
                  className="flex-1 flex items-center justify-center gap-2 px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-bold disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isDeleting ? (
                    <>
                      <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                      Eliminazione in corso...
                    </>
                  ) : (
                    <>
                      <Trash2 className="w-5 h-5" />
                      Elimina Definitivamente
                    </>
                  )}
                </button>
                <button
                  onClick={() => {
                    setShowModal(false);
                    setConfirmEmail('');
                    setConfirmText('');
                    setError('');
                  }}
                  disabled={isDeleting}
                  className="px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Annulla
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
