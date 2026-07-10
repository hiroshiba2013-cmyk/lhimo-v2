import { useState, useRef } from 'react';
import { Camera, Upload, Loader } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';
import { useAuth } from '../../contexts/AuthContext';

interface FamilyMemberAvatarUploadProps {
  memberId: string;
  currentAvatarUrl: string | null;
  onAvatarUpdate: (url: string) => void;
}

export function FamilyMemberAvatarUpload({
  memberId,
  currentAvatarUrl,
  onAvatarUpdate
}: FamilyMemberAvatarUploadProps) {
  const { showToast } = useToast();
  const { updateFamilyMemberAvatar } = useAuth();
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
      const fileName = `family/${memberId}/avatar.${fileExt}`;

      const { error: uploadError } = await supabase.storage
        .from('avatars')
        .upload(fileName, file, { upsert: true });

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('avatars')
        .getPublicUrl(fileName);

      const url = `${publicUrl}?t=${Date.now()}`;

      const { error: updateError } = await supabase
        .from('customer_family_members')
        .update({ avatar_url: url })
        .eq('id', memberId);

      if (updateError) throw updateError;

      updateFamilyMemberAvatar(memberId, url);
      onAvatarUpdate(url);
    } catch (error) {
      console.error('Error uploading avatar:', error);
      showToast('Errore durante il caricamento dell\'immagine', 'error');
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="relative group">
      <div className="w-20 h-20 rounded-full overflow-hidden bg-gradient-to-br from-green-500 to-green-700 flex items-center justify-center">
        {currentAvatarUrl ? (
          <img
            src={currentAvatarUrl}
            alt="Avatar membro famiglia"
            className="w-full h-full object-cover"
          />
        ) : (
          <Camera className="w-10 h-10 text-white" />
        )}
      </div>

      <button
        onClick={() => fileInputRef.current?.click()}
        disabled={uploading}
        type="button"
        className="absolute bottom-0 right-0 bg-green-600 hover:bg-green-700 text-white rounded-full p-2 shadow-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        title="Carica foto"
      >
        {uploading ? (
          <Loader className="w-3 h-3 animate-spin" />
        ) : (
          <Upload className="w-3 h-3" />
        )}
      </button>

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
