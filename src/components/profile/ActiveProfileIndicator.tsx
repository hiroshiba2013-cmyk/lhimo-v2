import { useState, useRef, useEffect } from 'react';
import { CircleUser as UserCircle2, ChevronDown, Building2, Lock, X, Camera } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import { supabase } from '../../lib/supabase';
import { BusinessLocationAvatarUpload } from '../business/BusinessLocationAvatarUpload';

async function hashPin(pin: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(pin);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  return hashHex;
}

export function ActiveProfileIndicator() {
  const { profile, activeProfile, familyMembers, businessLocations, setActiveProfile, refreshBusinessLocations } = useAuth();
  const [showDropdown, setShowDropdown] = useState(false);
  const [showPinModal, setShowPinModal] = useState(false);
  const [selectedProfile, setSelectedProfile] = useState<any>(null);
  const [pinInput, setPinInput] = useState('');
  const [pinError, setPinError] = useState('');
  const [loading, setLoading] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleProfileClick = async (prof: any) => {
    if (!profile) return;
    if (activeProfile?.id === prof.id) { setShowDropdown(false); return; }

    try {
      if (prof.isOwner) {
        const { data } = await supabase
          .from('profiles')
          .select('pin_enabled, pin_code')
          .eq('id', prof.id)
          .maybeSingle();
        if (data?.pin_enabled && data?.pin_code) {
          setSelectedProfile(prof); setShowPinModal(true); setShowDropdown(false); return;
        }
      } else if (profile.user_type === 'customer') {
        const { data } = await supabase
          .from('customer_family_members')
          .select('pin_enabled, pin_code')
          .eq('id', prof.id)
          .maybeSingle();
        if (data?.pin_enabled && data?.pin_code) {
          setSelectedProfile(prof); setShowPinModal(true); setShowDropdown(false); return;
        }
      }
      setActiveProfile(prof.id, prof.isOwner);
      setShowDropdown(false);
    } catch (error) {
      console.error('Error checking PIN:', error);
      setActiveProfile(prof.id, prof.isOwner);
      setShowDropdown(false);
    }
  };

  const handlePinSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedProfile || !pinInput || !profile) return;
    setLoading(true); setPinError('');
    try {
      const hashedInput = await hashPin(pinInput);
      if (selectedProfile.isOwner) {
        const { data } = await supabase.from('profiles').select('pin_code').eq('id', selectedProfile.id).maybeSingle();
        if (data?.pin_code === hashedInput) {
          setActiveProfile(selectedProfile.id, selectedProfile.isOwner);
          setShowPinModal(false); setPinInput(''); setPinError(''); setSelectedProfile(null);
        } else { setPinError('PIN non corretto'); }
      } else if (profile.user_type === 'customer') {
        const { data } = await supabase.from('customer_family_members').select('pin_code').eq('id', selectedProfile.id).maybeSingle();
        if (data?.pin_code === hashedInput) {
          setActiveProfile(selectedProfile.id, selectedProfile.isOwner);
          setShowPinModal(false); setPinInput(''); setPinError(''); setSelectedProfile(null);
        } else { setPinError('PIN non corretto'); }
      }
    } catch (error) {
      console.error('Error verifying PIN:', error);
      setPinError('Errore durante la verifica del PIN');
    } finally { setLoading(false); }
  };

  const handleClosePinModal = () => {
    setShowPinModal(false); setSelectedProfile(null); setPinInput(''); setPinError('');
  };

  if (!activeProfile || !profile) return null;

  const isCustomer = profile.user_type === 'customer';
  const isBusiness = profile.user_type === 'business';

  // Customer: nascondi se nessun familiare
  if (isCustomer && familyMembers.length === 0) return null;

  // Business: nascondi il dropdown se c'è solo 1 sede (tutto gestito dal profilo principale)
  if (isBusiness && businessLocations.length <= 1) return null;

  const profiles = [
    {
      id: profile.id,
      name: profile.full_name,
      nickname: (profile as any)?.nickname,
      avatarUrl: (profile as any)?.avatar_url,
      isOwner: true,
    },
    ...(isCustomer ? familyMembers.map(member => ({
      id: member.id,
      name: `${member.first_name} ${member.last_name}`,
      nickname: member.nickname,
      avatarUrl: member.avatar_url,
      isOwner: false,
    })) : businessLocations.map((location, index) => ({
      id: location.id,
      name: (location as any).internal_name || `Sede ${index + 1}`,
      nickname: location.name,
      avatarUrl: location.avatar_url,
      isOwner: false,
      _table: (location as any)._table ?? 'registered_business_locations',
    }))),
  ];

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setShowDropdown(!showDropdown)}
        className="flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors"
      >
        {activeProfile.avatarUrl ? (
          <img src={activeProfile.avatarUrl} alt={activeProfile.name} className="w-8 h-8 rounded-full object-cover" />
        ) : (
          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
            {isBusiness && !activeProfile.isOwner ? (
              <Building2 className="w-5 h-5 text-white" />
            ) : (
              <UserCircle2 className="w-5 h-5 text-white" />
            )}
          </div>
        )}
        <div className="hidden md:block text-left">
          <div className="text-sm font-semibold text-gray-900">
            {activeProfile.nickname || activeProfile.name}
          </div>
        </div>
        <ChevronDown className="w-4 h-4 text-gray-600" />
      </button>

      {showDropdown && (
        <div className="absolute right-0 mt-2 w-72 bg-white rounded-xl shadow-lg border border-gray-200 py-2 z-50">
          <div className="px-4 py-2 border-b border-gray-100">
            <p className="text-xs text-gray-500 font-semibold uppercase tracking-wide">
              {isCustomer ? 'Cambia Profilo' : 'Sedi Aziendali'}
            </p>
          </div>

          {profiles.map((prof) => {
            const isBusinessLoc = isBusiness && !prof.isOwner;
            return (
              <div
                key={prof.id}
                className={`flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors ${
                  activeProfile.id === prof.id ? 'bg-blue-50' : ''
                }`}
              >
                {/* Avatar: per sedi business mostra l'upload, per gli altri solo l'immagine */}
                {isBusinessLoc ? (
                  <div
                    onClick={(e) => e.stopPropagation()}
                    className="flex-shrink-0"
                    title="Clicca per cambiare la foto"
                  >
                    <BusinessLocationAvatarUpload
                      locationId={prof.id}
                      currentAvatarUrl={prof.avatarUrl ?? null}
                      table={(prof as any)._table ?? 'registered_business_locations'}
                      size="sm"
                      onAvatarUpdate={async () => {
                        await refreshBusinessLocations();
                      }}
                    />
                  </div>
                ) : (
                  <div className="flex-shrink-0">
                    {prof.avatarUrl ? (
                      <img src={prof.avatarUrl} alt={prof.name} className="w-10 h-10 rounded-full object-cover" />
                    ) : (
                      <div className="w-10 h-10 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                        <UserCircle2 className="w-7 h-7 text-white" />
                      </div>
                    )}
                  </div>
                )}

                {/* Testo + bottone selezione */}
                <button
                  onClick={() => handleProfileClick(prof)}
                  className="flex-1 text-left min-w-0"
                >
                  <div className="font-semibold text-gray-900 text-sm truncate">{prof.name}</div>
                  {prof.nickname && (
                    <div className="text-xs text-gray-500 truncate">"{prof.nickname}"</div>
                  )}
                  {prof.isOwner && (
                    <span className="inline-block mt-0.5 px-2 py-0.5 bg-blue-100 text-blue-700 text-xs font-semibold rounded">
                      {isBusiness ? 'Tutte le Sedi' : 'Principale'}
                    </span>
                  )}
                  {isBusinessLoc && (
                    <div className="flex items-center gap-1 mt-0.5">
                      <Camera className="w-3 h-3 text-gray-400" />
                      <span className="text-xs text-gray-400">Tocca foto per cambiarla</span>
                    </div>
                  )}
                </button>

                {activeProfile.id === prof.id && (
                  <div className="w-2 h-2 rounded-full bg-blue-600 flex-shrink-0"></div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {showPinModal && selectedProfile && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                  <Lock className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-gray-900">PIN Richiesto</h2>
                  <p className="text-sm text-gray-600">{selectedProfile.name}</p>
                </div>
              </div>
              <button onClick={handleClosePinModal} className="text-gray-400 hover:text-gray-600 transition-colors">
                <X className="w-6 h-6" />
              </button>
            </div>
            <form onSubmit={handlePinSubmit}>
              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">Inserisci il PIN</label>
                <input
                  type="password"
                  value={pinInput}
                  onChange={(e) => { setPinInput(e.target.value); setPinError(''); }}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-center text-2xl tracking-widest"
                  placeholder="••••" maxLength={4} inputMode="numeric" pattern="[0-9]*" autoFocus disabled={loading}
                />
                {pinError && <p className="mt-2 text-sm text-red-600">{pinError}</p>}
              </div>
              <div className="flex gap-3">
                <button type="button" onClick={handleClosePinModal} className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium" disabled={loading}>Annulla</button>
                <button type="submit" className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-medium disabled:opacity-50" disabled={loading || !pinInput}>{loading ? 'Verifica...' : 'Conferma'}</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
