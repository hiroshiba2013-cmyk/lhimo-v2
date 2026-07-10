import { useState } from 'react';
import { CircleUser as UserCircle2, Building2, Lock, X } from 'lucide-react';
import { FamilyMember } from '../../lib/supabase';
import { BusinessLocation } from '../../contexts/AuthContext';
import { supabase } from '../../lib/supabase';
import { BusinessLocationAvatarUpload } from '../business/BusinessLocationAvatarUpload';

export interface ProfileOption {
  id: string;
  name: string;
  nickname?: string;
  avatarUrl?: string | null;
  isOwner: boolean;
  _table?: 'registered_business_locations' | 'business_locations';
}

interface ProfileSelectorProps {
  ownerProfile: ProfileOption;
  familyMembers?: FamilyMember[];
  businessLocations?: BusinessLocation[];
  userType: 'customer' | 'business';
  onSelectProfile: (profileId: string, isOwner: boolean) => void;
  onLocationAvatarUpdate?: (locationId: string, url: string) => void;
}

async function hashPin(pin: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(pin);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  return hashHex;
}

export function ProfileSelector({
  ownerProfile,
  familyMembers = [],
  businessLocations = [],
  userType,
  onSelectProfile,
  onLocationAvatarUpdate,
}: ProfileSelectorProps) {
  const [showPinModal, setShowPinModal] = useState(false);
  const [selectedProfile, setSelectedProfile] = useState<ProfileOption | null>(null);
  const [pinInput, setPinInput] = useState('');
  const [pinError, setPinError] = useState('');
  const [loading, setLoading] = useState(false);
  const [locationAvatars, setLocationAvatars] = useState<Record<string, string>>({});

  const profiles: ProfileOption[] = [
    ownerProfile,
    ...(userType === 'customer'
      ? familyMembers.map(member => ({
          id: member.id,
          name: `${member.first_name} ${member.last_name}`,
          nickname: member.nickname,
          avatarUrl: member.avatar_url,
          isOwner: false,
        }))
      : businessLocations.map((location, index) => ({
          id: location.id,
          name: (location as any).internal_name || `Sede ${index + 1}`,
          nickname: location.name,
          avatarUrl: location.avatar_url,
          isOwner: false,
          _table: (location as any)._table ?? 'registered_business_locations',
        }))),
  ];

  const handleProfileClick = async (profile: ProfileOption) => {
    try {
      if (profile.isOwner) {
        const { data } = await supabase
          .from('profiles')
          .select('pin_enabled, pin_code')
          .eq('id', profile.id)
          .maybeSingle();

        if (data?.pin_enabled && data?.pin_code) {
          setSelectedProfile(profile);
          setShowPinModal(true);
          return;
        }
      } else if (userType !== 'business') {
        const { data } = await supabase
          .from('customer_family_members')
          .select('pin_enabled, pin_code')
          .eq('id', profile.id)
          .maybeSingle();

        if (data?.pin_enabled && data?.pin_code) {
          setSelectedProfile(profile);
          setShowPinModal(true);
          return;
        }
      }
      onSelectProfile(profile.id, profile.isOwner);
    } catch (error) {
      console.error('Error checking PIN:', error);
      onSelectProfile(profile.id, profile.isOwner);
    }
  };

  const handlePinSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedProfile || !pinInput) return;
    setLoading(true);
    setPinError('');
    try {
      const hashedInput = await hashPin(pinInput);
      if (selectedProfile.isOwner) {
        const { data } = await supabase
          .from('profiles')
          .select('pin_code')
          .eq('id', selectedProfile.id)
          .maybeSingle();
        if (data?.pin_code === hashedInput) {
          onSelectProfile(selectedProfile.id, selectedProfile.isOwner);
          setShowPinModal(false);
        } else {
          setPinError('PIN non corretto');
        }
      } else if (userType !== 'business') {
        const { data } = await supabase
          .from('customer_family_members')
          .select('pin_code')
          .eq('id', selectedProfile.id)
          .maybeSingle();
        if (data?.pin_code === hashedInput) {
          onSelectProfile(selectedProfile.id, selectedProfile.isOwner);
          setShowPinModal(false);
        } else {
          setPinError('PIN non corretto');
        }
      }
    } catch (error) {
      console.error('Error verifying PIN:', error);
      setPinError('Errore durante la verifica del PIN');
    } finally {
      setLoading(false);
    }
  };

  const handleClosePinModal = () => {
    setShowPinModal(false);
    setSelectedProfile(null);
    setPinInput('');
    setPinError('');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-gray-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-2xl w-full">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            {userType === 'customer' ? 'Seleziona il Profilo' : 'Seleziona la Sede'}
          </h1>
          <p className="text-gray-600">
            {userType === 'customer'
              ? 'Con quale profilo desideri navigare?'
              : 'Con quale sede desideri navigare?'}
          </p>
          {userType === 'business' && (
            <p className="text-xs text-gray-400 mt-1">
              Clicca sull'avatar per cambiare la foto della sede, poi selezionala per entrare
            </p>
          )}
        </div>

        <div className="grid md:grid-cols-2 gap-4">
          {profiles.map((profile) => {
            const isBusinessLocation = userType === 'business' && !profile.isOwner;
            const currentAvatar = locationAvatars[profile.id] ?? profile.avatarUrl;

            return (
              <div
                key={profile.id}
                className="border-2 border-gray-200 rounded-xl hover:border-blue-500 hover:bg-blue-50 transition-all duration-200 group overflow-hidden"
              >
                <div className="flex flex-col items-center gap-4 p-6">
                  {/* Avatar — per sedi business usa il componente upload, per gli altri usa immagine statica */}
                  {isBusinessLocation ? (
                    <div
                      onClick={(e) => e.stopPropagation()}
                      className="cursor-default"
                    >
                      <BusinessLocationAvatarUpload
                        locationId={profile.id}
                        currentAvatarUrl={currentAvatar ?? null}
                        table={profile._table ?? 'registered_business_locations'}
                        onAvatarUpdate={(url) => {
                          setLocationAvatars(prev => ({ ...prev, [profile.id]: url }));
                          onLocationAvatarUpdate?.(profile.id, url);
                        }}
                      />
                    </div>
                  ) : (
                    <>
                      {currentAvatar ? (
                        <img
                          src={currentAvatar}
                          alt={profile.name}
                          className="w-24 h-24 rounded-full object-cover border-4 border-gray-200 group-hover:border-blue-500 transition-all"
                        />
                      ) : (
                        <div className="w-24 h-24 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center border-4 border-gray-200 group-hover:border-blue-500 transition-all">
                          {userType === 'business' ? (
                            <Building2 className="w-16 h-16 text-white" />
                          ) : (
                            <UserCircle2 className="w-16 h-16 text-white" />
                          )}
                        </div>
                      )}
                    </>
                  )}

                  {/* Testo e bottone selezione */}
                  <div className="text-center w-full">
                    <h3 className="font-bold text-lg text-gray-900 group-hover:text-blue-600 transition-colors">
                      {profile.name}
                    </h3>
                    {profile.nickname && (
                      <p className="text-sm text-gray-600 mt-1">"{profile.nickname}"</p>
                    )}
                    {profile.isOwner && (
                      <span className="inline-block mt-2 px-3 py-1 bg-blue-100 text-blue-700 text-xs font-semibold rounded-full">
                        {userType === 'customer' ? 'Account Principale' : 'Tutte le Sedi'}
                      </span>
                    )}
                    <button
                      onClick={() => handleProfileClick(profile)}
                      className="mt-3 w-full py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700 transition-colors"
                    >
                      {isBusinessLocation ? 'Entra nella sede' : profile.isOwner ? 'Seleziona' : 'Seleziona profilo'}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        <div className="mt-6 text-center text-sm text-gray-500">
          {userType === 'customer'
            ? 'Potrai cambiare profilo in qualsiasi momento dalle impostazioni'
            : 'Potrai cambiare sede in qualsiasi momento dalle impostazioni'}
        </div>
      </div>

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
                  placeholder="••••"
                  maxLength={4}
                  inputMode="numeric"
                  pattern="[0-9]*"
                  autoFocus
                  disabled={loading}
                />
                {pinError && <p className="mt-2 text-sm text-red-600">{pinError}</p>}
              </div>

              <div className="flex gap-3">
                <button
                  type="button"
                  onClick={handleClosePinModal}
                  className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium"
                  disabled={loading}
                >
                  Annulla
                </button>
                <button
                  type="submit"
                  className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
                  disabled={loading || !pinInput}
                >
                  {loading ? 'Verifica...' : 'Conferma'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
