import { useState, useRef } from 'react';
import { Camera, Upload, Loader, MapPin } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface BusinessLocationAvatarUploadProps {
  locationId: string;
  currentAvatarUrl: string | null;
  onAvatarUpdate: (url: string) => void;
  table?: 'business_locations' | 'registered_business_locations';
  size?: 'sm' | 'md';
}

export function BusinessLocationAvatarUpload({
  locationId,
  currentAvatarUrl,
  onAvatarUpdate,
  table = 'business_locations',
  size = 'md',
}: BusinessLocationAvatarUploadProps) {
  const { showToast } = useToast();
  const [uploading, setUploading] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    try {
      const file = event.target.files?.[0];
      if (!file) return;

      if (!file.type.startsWith('image/')) {
        showToast('Per favore seleziona un file immagine', 'info');
        return;
      }
      if (file.size > 5 * 1024 * 1024) {
        showToast('Il file è troppo grande. Massimo 5MB', 'info');
        return;
      }

      setUploading(true);

      const fileExt = file.name.split('.').pop();
      const fileName = `business-locations/${locationId}/${Date.now()}.${fileExt}`;

      const { error: uploadError } = await supabase.storage
        .from('avatars')
        .upload(fileName, file, { upsert: true });
      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage.from('avatars').getPublicUrl(fileName);
      const url = `${publicUrl}?t=${Date.now()}`;

      const { error: updateError } = await supabase
        .from(table)
        .update({ avatar_url: url })
        .eq('id', locationId);
      if (updateError) throw updateError;

      onAvatarUpdate(url);
      showToast('Foto aggiornata', 'success');
    } catch (error) {
      console.error('Error uploading avatar:', error);
      showToast('Errore durante il caricamento', 'error');
    } finally {
      setUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const isSmall = size === 'sm';
  const circleSize = isSmall ? 'w-10 h-10' : 'w-24 h-24';
  const iconSize = isSmall ? 'w-5 h-5' : 'w-10 h-10';
  const overlayIconSize = isSmall ? 'w-4 h-4' : 'w-6 h-6';
  const badgeSize = isSmall ? 'p-1' : 'p-1.5';
  const badgeIconSize = isSmall ? 'w-2.5 h-2.5' : 'w-3 h-3';

  return (
    <div
      className="relative group cursor-pointer"
      onClick={() => !uploading && fileInputRef.current?.click()}
    >
      <div className={`${circleSize} rounded-full overflow-hidden bg-gradient-to-br from-blue-500 to-blue-700 flex items-center justify-center shadow-md ring-2 ring-white`}>
        {currentAvatarUrl ? (
          <img src={currentAvatarUrl} alt="Foto sede" className="w-full h-full object-cover" />
        ) : (
          <MapPin className={`${iconSize} text-white`} />
        )}
      </div>

      {/* Hover overlay */}
      <div className="absolute inset-0 rounded-full bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
        {uploading ? (
          <Loader className={`${overlayIconSize} text-white animate-spin`} />
        ) : (
          <Camera className={`${overlayIconSize} text-white`} />
        )}
      </div>

      {/* Badge upload sempre visibile */}
      <div className={`absolute bottom-0 right-0 bg-blue-600 hover:bg-blue-700 text-white rounded-full ${badgeSize} shadow-lg ring-2 ring-white transition-colors`}>
        {uploading ? (
          <Loader className={`${badgeIconSize} animate-spin`} />
        ) : (
          <Upload className={badgeIconSize} />
        )}
      </div>

      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        onChange={handleFileSelect}
        className="hidden"
      />
    </div>
  );
}
