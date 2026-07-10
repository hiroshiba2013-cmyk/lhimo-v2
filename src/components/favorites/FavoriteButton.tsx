import { useState, useEffect, useRef } from 'react';
import { Heart } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useToast } from '../common/Toast';

type BusinessColumn = 'unclaimed' | 'registered' | 'registered_no_location' | 'legacy';

interface FavoriteButtonProps {
  type: 'business' | 'ad' | 'job';
  itemId: string;
  familyMemberId?: string | null;
  showLabel?: boolean;
  className?: string;
  onToggle?: (isFavorite: boolean) => void;
  businessColumn?: BusinessColumn;
  initialIsFavorite?: boolean;
}

function getBusinessColumnName(col: BusinessColumn): string {
  switch (col) {
    case 'unclaimed': return 'unclaimed_business_location_id';
    case 'registered': return 'registered_business_location_id';
    case 'registered_no_location': return 'registered_business_id';
    case 'legacy': return 'business_location_id';
  }
}

export function FavoriteButton({
  type,
  itemId,
  familyMemberId = null,
  showLabel = false,
  className = '',
  onToggle,
  businessColumn = 'registered',
  initialIsFavorite,
}: FavoriteButtonProps) {
  const { showToast } = useToast();
  const { user } = useAuth();
  const [isFavorite, setIsFavorite] = useState(initialIsFavorite ?? false);
  const [pending, setPending] = useState(false);
  // Tracks whether we've already fetched the real status from DB
  const fetchedRef = useRef(false);

  const tableName = type === 'business'
    ? 'favorite_businesses'
    : type === 'ad'
    ? 'favorite_classified_ads'
    : 'favorite_job_postings';

  const columnName = type === 'business'
    ? getBusinessColumnName(businessColumn)
    : type === 'ad'
    ? 'ad_id'
    : 'job_id';

  // Sync when initialIsFavorite changes (e.g. batch load in SearchResultsPage)
  useEffect(() => {
    if (initialIsFavorite !== undefined) {
      setIsFavorite(initialIsFavorite);
      fetchedRef.current = true;
    }
  }, [initialIsFavorite]);

  // Only fetch individually when initialIsFavorite is not provided
  useEffect(() => {
    if (!user || initialIsFavorite !== undefined) return;
    if (fetchedRef.current) return;
    let cancelled = false;

    const fetchStatus = async () => {
      try {
        let query = supabase
          .from(tableName)
          .select('id')
          .eq('user_id', user.id)
          .eq(columnName, itemId);

        if (familyMemberId) {
          query = query.eq('family_member_id', familyMemberId);
        } else {
          query = query.is('family_member_id', null);
        }

        const { data } = await query.maybeSingle();
        if (!cancelled) {
          setIsFavorite(!!data);
          fetchedRef.current = true;
        }
      } catch {
        // silently ignore — button will still work on click
      }
    };

    fetchStatus();
    return () => { cancelled = true; };
  }, [user, itemId, familyMemberId, businessColumn]);

  const toggleFavorite = async (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    if (!user) {
      showToast('Devi effettuare il login per aggiungere ai preferiti', 'info');
      return;
    }

    // Block concurrent clicks
    if (pending) return;
    setPending(true);

    // Optimistic update immediately
    const newValue = !isFavorite;
    setIsFavorite(newValue);

    try {
      if (!newValue) {
        // Remove from favorites
        let query = supabase
          .from(tableName)
          .delete()
          .eq('user_id', user.id)
          .eq(columnName, itemId);

        if (familyMemberId) {
          query = query.eq('family_member_id', familyMemberId);
        } else {
          query = query.is('family_member_id', null);
        }

        const { error } = await query;
        if (error) throw error;
        onToggle?.(false);
      } else {
        // Add to favorites — use upsert to avoid duplicate errors
        const payload: Record<string, any> = {
          user_id: user.id,
          [columnName]: itemId,
          family_member_id: familyMemberId,
        };

        const { error } = await supabase
          .from(tableName)
          .insert(payload);

        if (error) {
          // Already exists — treat as success
          if (error.code === '23505') {
            onToggle?.(true);
            return;
          }
          throw error;
        }
        onToggle?.(true);
      }
    } catch (error: any) {
      // Revert optimistic update on real error
      setIsFavorite(!newValue);
      console.error('Error toggling favorite:', error);
      showToast('Errore durante l\'operazione. Riprova.', 'error');
    } finally {
      setPending(false);
    }
  };

  if (!user) return null;

  return (
    <button
      onClick={toggleFavorite}
      disabled={pending}
      className={`flex items-center gap-2 px-3 py-2 rounded-lg transition-colors ${
        isFavorite
          ? 'bg-red-50 text-red-600 hover:bg-red-100'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
      } disabled:opacity-50 disabled:cursor-not-allowed ${className}`}
      title={isFavorite ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti'}
    >
      <Heart className={`w-5 h-5 ${isFavorite ? 'fill-current' : ''}`} />
      {showLabel && (
        <span className="text-sm font-medium">
          {isFavorite ? 'Preferito' : 'Aggiungi ai preferiti'}
        </span>
      )}
    </button>
  );
}
