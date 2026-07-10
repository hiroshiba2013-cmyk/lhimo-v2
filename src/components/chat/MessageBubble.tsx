import { Check, CheckCheck } from 'lucide-react';

interface MessageBubbleProps {
  message: string;
  isOwn: boolean;
  timestamp: string;
  isRead?: boolean;
  senderName?: string;
}

export default function MessageBubble({
  message,
  isOwn,
  timestamp,
  isRead,
  senderName,
}: MessageBubbleProps) {
  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'} mb-4`}>
      <div className={`max-w-[70%] ${isOwn ? 'order-2' : 'order-1'}`}>
        {!isOwn && senderName && (
          <p className="text-xs text-gray-500 mb-1 ml-2">{senderName}</p>
        )}
        <div
          className={`rounded-2xl px-4 py-2 ${
            isOwn
              ? 'bg-blue-600 text-white rounded-br-sm'
              : 'bg-gray-200 text-gray-900 rounded-bl-sm'
          }`}
        >
          <p className="text-sm break-words">{message}</p>
          <div className={`flex items-center gap-1 mt-1 ${isOwn ? 'justify-end' : 'justify-start'}`}>
            <span className={`text-xs ${isOwn ? 'text-blue-100' : 'text-gray-500'}`}>
              {formatTime(timestamp)}
            </span>
            {isOwn && (
              <span className="ml-1">
                {isRead ? (
                  <CheckCheck className="w-3 h-3 text-blue-100" />
                ) : (
                  <Check className="w-3 h-3 text-blue-100" />
                )}
              </span>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
