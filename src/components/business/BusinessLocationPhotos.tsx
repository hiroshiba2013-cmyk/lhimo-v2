import { useState, useEffect, useRef } from 'react';
import { Camera, X, Upload, LayoutGrid } from 'lucide-react';
import { supabase } from '../../lib/supabase';

const MAX_PHOTOS = 20;

interface Photo {
  id: string;
  url: string;
  storage_path: string;
  display_order: number;
}

interface BusinessLocationPhotosProps {
  locationId: string;
  readOnly?: boolean;
}

export function BusinessLocationPhotos({ locationId, readOnly = false }: BusinessLocationPhotosProps) {
  const [photos, setPhotos] = useState<Photo[]>([]);
  const [uploading, setUploading] = useState(false);
  const [lightboxIndex, setLightboxIndex] = useState<number | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    loadPhotos();
  }, [locationId]);

  const loadPhotos = async () => {
    const { data } = await supabase
      .from('business_location_photos')
      .select('id, url, storage_path, display_order')
      .eq('location_id', locationId)
      .order('display_order', { ascending: true });
    setPhotos(data || []);
  };

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    if (!files.length) return;

    const remaining = MAX_PHOTOS - photos.length;
    const toUpload = files.slice(0, remaining);

    setUploading(true);
    try {
      for (let i = 0; i < toUpload.length; i++) {
        const file = toUpload[i];
        const ext = file.name.split('.').pop() || 'jpg';
        const path = `${locationId}/${Date.now()}-${i}.${ext}`;

        const { error: uploadError } = await supabase.storage
          .from('business-location-photos')
          .upload(path, file, { upsert: false });

        if (uploadError) throw uploadError;

        const { data: { publicUrl } } = supabase.storage
          .from('business-location-photos')
          .getPublicUrl(path);

        const { error: dbError } = await supabase
          .from('business_location_photos')
          .insert({
            location_id: locationId,
            url: publicUrl,
            storage_path: path,
            display_order: photos.length + i,
          });

        if (dbError) throw dbError;
      }
      await loadPhotos();
    } catch (err) {
      console.error('Upload error:', err);
    } finally {
      setUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const handleDelete = async (photo: Photo) => {
    if (!confirm('Eliminare questa foto?')) return;

    await supabase.storage
      .from('business-location-photos')
      .remove([photo.storage_path]);

    await supabase
      .from('business_location_photos')
      .delete()
      .eq('id', photo.id);

    setPhotos(prev => prev.filter(p => p.id !== photo.id));
  };

  const canUpload = !readOnly && photos.length < MAX_PHOTOS;

  if (readOnly && photos.length === 0) return null;

  return (
    <div>
      {!readOnly && (
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <LayoutGrid className="w-5 h-5 text-blue-600" />
            <span className="text-sm font-semibold text-gray-700">
              Foto ({photos.length}/{MAX_PHOTOS})
            </span>
          </div>
          {canUpload && (
            <>
              <button
                type="button"
                onClick={() => fileInputRef.current?.click()}
                disabled={uploading}
                className="flex items-center gap-2 text-sm bg-blue-600 text-white px-3 py-1.5 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
              >
                {uploading ? (
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                ) : (
                  <Upload className="w-4 h-4" />
                )}
                {uploading ? 'Caricamento...' : 'Aggiungi foto'}
              </button>
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                multiple
                className="hidden"
                onChange={handleFileChange}
              />
            </>
          )}
        </div>
      )}

      {readOnly && photos.length > 0 && (
        <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
          <Camera className="w-5 h-5 text-blue-600" />
          Foto ({photos.length})
        </h3>
      )}

      {photos.length > 0 ? (
        <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-2">
          {photos.map((photo, idx) => (
            <div key={photo.id} className="relative group aspect-square">
              <img
                src={photo.url}
                alt={`Foto ${idx + 1}`}
                className="w-full h-full object-cover rounded-lg cursor-pointer hover:opacity-90 transition-opacity"
                onClick={() => setLightboxIndex(idx)}
              />
              {!readOnly && (
                <button
                  type="button"
                  onClick={() => handleDelete(photo)}
                  className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-0.5 opacity-0 group-hover:opacity-100 transition-opacity shadow"
                >
                  <X className="w-3 h-3" />
                </button>
              )}
            </div>
          ))}
          {!readOnly && canUpload && (
            <button
              type="button"
              onClick={() => fileInputRef.current?.click()}
              className="aspect-square border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center gap-1 text-gray-400 hover:border-blue-400 hover:text-blue-500 transition-colors"
            >
              <Upload className="w-5 h-5" />
              <span className="text-xs">Aggiungi</span>
            </button>
          )}
        </div>
      ) : (
        !readOnly && (
          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            className="w-full border-2 border-dashed border-gray-300 rounded-lg p-8 flex flex-col items-center gap-2 text-gray-400 hover:border-blue-400 hover:text-blue-500 transition-colors"
          >
            <Camera className="w-10 h-10" />
            <span className="text-sm font-medium">Clicca per aggiungere foto della tua attività</span>
            <span className="text-xs">Puoi caricare fino a {MAX_PHOTOS} foto</span>
          </button>
        )
      )}

      {lightboxIndex !== null && (
        <div
          className="fixed inset-0 bg-black/90 z-50 flex items-center justify-center p-4"
          onClick={() => setLightboxIndex(null)}
        >
          <button
            className="absolute top-4 right-4 text-white bg-white/20 hover:bg-white/30 rounded-full p-2 transition-colors"
            onClick={() => setLightboxIndex(null)}
          >
            <X className="w-6 h-6" />
          </button>
          {lightboxIndex > 0 && (
            <button
              className="absolute left-4 text-white bg-white/20 hover:bg-white/30 rounded-full p-3 transition-colors"
              onClick={(e) => { e.stopPropagation(); setLightboxIndex(lightboxIndex - 1); }}
            >
              ‹
            </button>
          )}
          <img
            src={photos[lightboxIndex]?.url}
            alt=""
            className="max-h-[85vh] max-w-[90vw] object-contain rounded-lg"
            onClick={(e) => e.stopPropagation()}
          />
          {lightboxIndex < photos.length - 1 && (
            <button
              className="absolute right-4 text-white bg-white/20 hover:bg-white/30 rounded-full p-3 transition-colors"
              onClick={(e) => { e.stopPropagation(); setLightboxIndex(lightboxIndex + 1); }}
            >
              ›
            </button>
          )}
          <div className="absolute bottom-4 text-white/70 text-sm">
            {lightboxIndex + 1} / {photos.length}
          </div>
        </div>
      )}
    </div>
  );
}
