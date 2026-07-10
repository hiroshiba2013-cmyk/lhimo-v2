import { CheckCircle2, UserPlus, Download, Building2 } from 'lucide-react';

interface VerificationBadgeProps {
  isClaimed: boolean;
  isUserAdded?: boolean;
  isImported?: boolean;
  isSelfRegistered?: boolean;
  size?: 'sm' | 'md' | 'lg';
  showText?: boolean;
}

export function VerificationBadge({
  isClaimed,
  isUserAdded = false,
  isImported = false,
  isSelfRegistered = false,
  size = 'md',
  showText = true
}: VerificationBadgeProps) {
  // Se non c'è nessun badge, non mostrare nulla
  if (!isClaimed && !isUserAdded && !isImported && !isSelfRegistered) return null;

  // Determina l'icona, il testo e i colori in base al tipo
  let Icon, text, bgColor, iconColor;

  if (isSelfRegistered || isClaimed) {
    // Attività iscritte da sole o rivendicate (stesso badge)
    Icon = CheckCircle2;
    text = isClaimed ? 'Attività Verificata' : 'Attività Iscritta';
    bgColor = 'bg-gradient-to-r from-green-50 to-emerald-50 border-green-300 text-green-700';
    iconColor = 'text-green-600 fill-green-100';
  } else if (isImported) {
    // Attività importate
    Icon = Download;
    text = 'Importata';
    bgColor = 'bg-gradient-to-r from-purple-50 to-violet-50 border-purple-300 text-purple-700';
    iconColor = 'text-purple-600 fill-purple-100';
  } else if (isUserAdded) {
    // Attività aggiunta da utenti (solo se approvata)
    Icon = UserPlus;
    text = 'Aggiunta da Utente';
    bgColor = 'bg-gradient-to-r from-blue-50 to-sky-50 border-blue-300 text-blue-700';
    iconColor = 'text-blue-600 fill-blue-100';
  }

  const sizeClasses = {
    sm: {
      container: 'px-2.5 py-1 text-xs',
      icon: 'w-3.5 h-3.5',
      gap: 'gap-1',
    },
    md: {
      container: 'px-3 py-1.5 text-sm',
      icon: 'w-4 h-4',
      gap: 'gap-1.5',
    },
    lg: {
      container: 'px-4 py-2 text-base',
      icon: 'w-5 h-5',
      gap: 'gap-2',
    },
  };

  const currentSize = sizeClasses[size];

  if (!showText) {
    return (
      <div
        className={`inline-flex items-center justify-center rounded-full ${bgColor} border-2 p-1 shadow-sm`}
        title={text}
      >
        <Icon className={`${currentSize.icon} ${iconColor}`} />
      </div>
    );
  }

  return (
    <div
      className={`inline-flex items-center ${currentSize.gap} ${currentSize.container} rounded-full ${bgColor} border-2 font-bold shadow-sm`}
    >
      <Icon className={`${currentSize.icon} ${iconColor}`} />
      <span>{text}</span>
    </div>
  );
}
