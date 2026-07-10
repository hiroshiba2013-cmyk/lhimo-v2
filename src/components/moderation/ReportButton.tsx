import { useState } from 'react';
import { Flag } from 'lucide-react';
import ReportModal from './ReportModal';

interface ReportButtonProps {
  entityType: 'review' | 'business' | 'classified_ad' | 'job_posting';
  entityId: string;
  compact?: boolean;
}

export default function ReportButton({ entityType, entityId, compact = false }: ReportButtonProps) {
  const [showModal, setShowModal] = useState(false);

  const getButtonText = () => {
    switch (entityType) {
      case 'review':
        return 'Segnala recensione';
      case 'classified_ad':
        return 'Segnala annuncio';
      case 'business':
        return 'Segnala attività';
      case 'job_posting':
        return 'Segnala offerta';
      default:
        return 'Segnala';
    }
  };

  const handleClick = () => {
    console.log('🚩 Report button clicked:', { entityType, entityId });
    setShowModal(true);
  };

  return (
    <>
      <button
        onClick={handleClick}
        className={`flex items-center gap-2 ${
          compact
            ? 'text-xs text-white hover:text-red-300 cursor-pointer'
            : 'text-sm px-3 py-1.5 rounded-lg border border-gray-300 text-gray-600 hover:bg-red-50 hover:text-red-600 hover:border-red-300'
        } transition-all duration-200`}
        title="Segnala contenuto inappropriato"
      >
        <Flag className={compact ? 'w-4 h-4' : 'w-4 h-4'} />
        {!compact && <span>{getButtonText()}</span>}
      </button>

      {showModal && (
        <ReportModal
          entityType={entityType}
          entityId={entityId}
          onClose={() => setShowModal(false)}
        />
      )}
    </>
  );
}
