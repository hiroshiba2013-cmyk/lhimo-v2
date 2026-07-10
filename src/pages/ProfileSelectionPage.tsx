import { useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { ProfileSelector } from '../components/profile/ProfileSelector';

export function ProfileSelectionPage() {
  const { profile, familyMembers, businessLocations, setActiveProfile, needsProfileSelection, loading } = useAuth();

  useEffect(() => {
    if (!loading && !needsProfileSelection) {
      window.history.pushState({}, '', '/');
      window.dispatchEvent(new PopStateEvent('popstate'));
    }
  }, [loading, needsProfileSelection]);

  useEffect(() => {
    if (!loading && !profile) {
      window.history.pushState({}, '', '/');
      window.dispatchEvent(new PopStateEvent('popstate'));
    }
  }, [loading, profile]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!needsProfileSelection || !profile) {
    return null;
  }

  const ownerProfile = {
    id: profile.id,
    name: profile.full_name,
    nickname: (profile as any)?.nickname,
    avatarUrl: (profile as any)?.avatar_url,
    isOwner: true,
  };

  const handleSelectProfile = (profileId: string, isOwner: boolean) => {
    setActiveProfile(profileId, isOwner);
  };

  return (
    <ProfileSelector
      ownerProfile={ownerProfile}
      familyMembers={familyMembers}
      businessLocations={businessLocations}
      userType={profile.user_type}
      onSelectProfile={handleSelectProfile}
    />
  );
}
