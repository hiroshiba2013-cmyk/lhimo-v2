import { useState } from 'react';
import { X, Flag, AlertTriangle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useToast } from '../common/Toast';

interface ReportModalProps {
  entityType: string;
  entityId: string;
  onClose: () => void;
}

const REPORT_REASONS: Record<string, Array<{ value: string; label: string }>> = {
  review: [
    { value: 'false_review', label: 'Recensione falsa o incentivata' },
    { value: 'offensive', label: 'Linguaggio offensivo, volgare o discriminatorio' },
    { value: 'defamation', label: 'Diffamazione o accuse infondate' },
    { value: 'privacy', label: 'Violazione privacy (dati personali di terzi)' },
    { value: 'spam', label: 'Spam o pubblicità ingannevole' },
    { value: 'inappropriate', label: 'Contenuto inappropriato' },
    { value: 'harassment', label: 'Molestie o bullismo' },
    { value: 'other', label: 'Altro' },
  ],
  business: [
    { value: 'fake_business', label: 'Attività inesistente o informazioni false' },
    { value: 'duplicate', label: 'Attività duplicata' },
    { value: 'wrong_info', label: 'Informazioni errate (indirizzo, telefono, orari)' },
    { value: 'closed', label: 'Attività chiusa definitivamente' },
    { value: 'wrong_category', label: 'Categoria errata' },
    { value: 'illegal', label: 'Attività illegale o non autorizzata' },
    { value: 'inappropriate', label: 'Contenuti inappropriati nella descrizione o foto' },
    { value: 'other', label: 'Altro' },
  ],
  classified_ad: [
    { value: 'fake', label: 'Annuncio falso o truffa' },
    { value: 'illegal_product', label: 'Prodotto illegale o contraffatto' },
    { value: 'prohibited', label: 'Prodotto vietato (armi, droga, farmaci)' },
    { value: 'offensive', label: 'Contenuto offensivo o inappropriato' },
    { value: 'spam', label: 'Spam o pubblicità ingannevole' },
    { value: 'wrong_category', label: 'Categoria errata' },
    { value: 'already_sold', label: 'Prodotto già venduto ma non rimosso' },
    { value: 'other', label: 'Altro' },
  ],
  job_posting: [
    { value: 'fake', label: 'Offerta di lavoro falsa' },
    { value: 'scam', label: 'Truffa o schema piramidale' },
    { value: 'illegal', label: 'Condizioni illegali o sfruttamento' },
    { value: 'offensive', label: 'Contenuto offensivo o discriminatorio' },
    { value: 'spam', label: 'Spam o pubblicità' },
    { value: 'wrong_category', label: 'Categoria errata' },
    { value: 'other', label: 'Altro' },
  ],
};

export default function ReportModal({ entityType, entityId, onClose }: ReportModalProps) {
  const { showToast } = useToast();
  const { user, profile, activeProfile } = useAuth();
  const activeFamilyMemberId = activeProfile && !activeProfile.isOwner && profile?.user_type === 'customer'
    ? activeProfile.id
    : null;
  const [reason, setReason] = useState('');
  const [description, setDescription] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);

  const reasons = REPORT_REASONS[entityType] || REPORT_REASONS.review;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!user || !reason) return;

    try {
      setSubmitting(true);

      const { error } = await supabase.from('reports').insert({
        reporter_id: user.id,
        family_member_id: activeFamilyMemberId,
        reported_entity_type: entityType,
        reported_entity_id: entityId,
        reason,
        description: description.trim() || null,
      });

      if (error) throw error;

      setSuccess(true);
      setTimeout(() => {
        onClose();
      }, 2000);
    } catch (error) {
      console.error('Error submitting report:', error);
      showToast('Errore durante l\'invio della segnalazione', 'error');
    } finally {
      setSubmitting(false);
    }
  }

  if (success) {
    return (
      <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div className="bg-white rounded-lg p-8 max-w-md w-full text-center">
          <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
            <Flag className="w-8 h-8 text-green-600" />
          </div>
          <h3 className="text-xl font-bold text-gray-900 mb-2">
            Segnalazione Inviata
          </h3>
          <p className="text-gray-600">
            Grazie per la segnalazione. Il nostro team la esaminerà al più presto.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-md w-full max-h-[90vh] overflow-y-auto">
        <div className="p-6 border-b border-gray-200 flex items-center justify-between sticky top-0 bg-white">
          <div className="flex items-center gap-3">
            <div className="bg-red-100 p-2 rounded-lg">
              <AlertTriangle className="w-6 h-6 text-red-600" />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Segnala Contenuto</h2>
          </div>
          <button
            onClick={onClose}
            className="p-2 text-gray-400 hover:text-gray-600 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Motivo della segnalazione *
            </label>
            <div className="space-y-2 max-h-80 overflow-y-auto">
              {reasons.map((r) => (
                <label
                  key={r.value}
                  className="flex items-center gap-3 p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors"
                >
                  <input
                    type="radio"
                    name="reason"
                    value={r.value}
                    checked={reason === r.value}
                    onChange={(e) => setReason(e.target.value)}
                    className="w-4 h-4 text-red-600 border-gray-300 focus:ring-red-500"
                  />
                  <span className="text-sm text-gray-700">{r.label}</span>
                </label>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Descrizione (opzionale)
            </label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={4}
              placeholder="Fornisci maggiori dettagli sulla tua segnalazione..."
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent resize-none"
            />
          </div>

          <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4">
            <p className="text-sm text-yellow-800">
              Le segnalazioni false o abusive possono comportare la sospensione del tuo account.
            </p>
          </div>

          <div className="flex gap-3">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium"
            >
              Annulla
            </button>
            <button
              type="submit"
              disabled={!reason || submitting}
              className="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium disabled:bg-gray-300 disabled:cursor-not-allowed"
            >
              {submitting ? 'Invio...' : 'Invia Segnalazione'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
