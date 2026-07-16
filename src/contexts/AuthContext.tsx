import { createContext, useContext, useEffect, useState, useRef, ReactNode } from 'react';
import { User } from '@supabase/supabase-js';
import { supabase, Profile, FamilyMember } from '../lib/supabase';
import { storageGet, storageSet, storageRemove } from '../lib/storage';

export interface CustomerData {
  firstName: string;
  lastName: string;
  nickname?: string;
  relationship?: string;
  dateOfBirth: string;
  fiscalCode: string;
  phone: string;
  billingStreet: string;
  billingStreetNumber: string;
  billingPostalCode: string;
  billingCity: string;
  billingProvince: string;
}

export interface BusinessData {
  companyName: string;
  vatNumber: string;
  uniqueCode: string;
  atecoCode: string;
  pecEmail: string;
  phone: string;
  website?: string;
  description?: string;
  billingStreet: string;
  billingStreetNumber: string;
  billingPostalCode: string;
  billingCity: string;
  billingProvince: string;
  officeStreet?: string;
  officeStreetNumber?: string;
  officePostalCode?: string;
  officeCity?: string;
  officeProvince?: string;
  categoryId?: string;
}

export interface BusinessLocation {
  id: string;
  name: string;
  internal_name?: string | null;
  address: string;
  city: string;
  province: string;
  avatar_url?: string | null;
  description?: string | null;
  _table?: 'registered_business_locations' | 'business_locations';
}

export interface ActiveProfile {
  id: string;
  name: string;
  internal_name?: string | null;
  nickname?: string;
  avatarUrl?: string | null;
  isOwner: boolean;
}

interface AuthContextType {
  user: User | null;
  profile: Profile | null;
  loading: boolean;
  familyMembers: FamilyMember[];
  businessLocations: BusinessLocation[];
  activeProfile: ActiveProfile | null;
  needsProfileSelection: boolean;
  selectedBusinessLocationId: string | null;
  signUpCustomer: (email: string, password: string, data: CustomerData) => Promise<void>;
  signUpBusiness: (email: string, password: string, data: BusinessData) => Promise<void>;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  setActiveProfile: (profileId: string, isOwner: boolean) => void;
  loadFamilyMembers: () => Promise<void>;
  refreshBusinessLocations: () => Promise<void>;
  updateFamilyMemberAvatar: (memberId: string, avatarUrl: string) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [businessLocations, setBusinessLocations] = useState<BusinessLocation[]>([]);
  const [activeProfile, setActiveProfileState] = useState<ActiveProfile | null>(null);
  const [needsProfileSelection, setNeedsProfileSelection] = useState(false);
  const mountedRef = useRef(true);

  useEffect(() => {
    mountedRef.current = true;

    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!mountedRef.current) return;
      setUser(session?.user ?? null);
      if (session?.user) {
        loadProfile(session.user.id);
      } else {
        setLoading(false);
      }
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      if (!mountedRef.current) return;
      (async () => {
        if (!mountedRef.current) return;
        if (event === 'SIGNED_OUT' || !session?.user) {
          if (!mountedRef.current) return;
          setUser(null);
          setProfile(null);
          setFamilyMembers([]);
          setBusinessLocations([]);
          setActiveProfileState(null);
          setNeedsProfileSelection(false);
          setLoading(false);
        } else {
          if (!mountedRef.current) return;
          setUser(session.user);
          await loadProfile(session.user.id);
        }
      })();
    });

    return () => {
      mountedRef.current = false;
      subscription.unsubscribe();
    };
  }, []);

  const loadProfile = async (userId: string) => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();

      if (!mountedRef.current) return;
      if (error) throw error;
      setProfile(data);

      if (data && data.user_type === 'admin') {
        setLoading(false);
        return;
      }

      if (data && data.user_type === 'customer') {
        await loadFamilyMembersInternal(userId, data);
      } else if (data && data.user_type === 'business') {
        await loadBusinessLocationsInternal(userId, data);
      } else {
        const ownerProfile: ActiveProfile = {
          id: userId,
          name: data?.full_name || '',
          nickname: data?.nickname,
          avatarUrl: data?.avatar_url,
          isOwner: true,
        };
        setActiveProfileState(ownerProfile);
        setLoading(false);
      }
    } catch (error) {
      console.error('Error loading profile:', error);
      setLoading(false);
    }
  };

  const loadFamilyMembersInternal = async (userId: string, profileData: Profile) => {
    try {
      const { data: members } = await supabase
        .from('customer_family_members')
        .select('*')
        .eq('customer_id', userId);

      if (!mountedRef.current) return;
      setFamilyMembers(members || []);

      const savedProfileId = storageGet(`activeProfile_${userId}`);
      const savedIsOwner = storageGet(`activeProfileIsOwner_${userId}`) === 'true';

      if (savedProfileId) {
        if (savedIsOwner) {
          setActiveProfileState({
            id: userId,
            name: profileData.full_name,
            nickname: profileData?.nickname,
            avatarUrl: profileData?.avatar_url,
            isOwner: true,
          });
          setNeedsProfileSelection(false);
        } else {
          const member = members?.find(m => m.id === savedProfileId);
          if (member) {
            setActiveProfileState({
              id: member.id,
              name: `${member.first_name} ${member.last_name}`,
              nickname: member.nickname,
              avatarUrl: member.avatar_url,
              isOwner: false,
            });
            setNeedsProfileSelection(false);
          } else {
            setNeedsProfileSelection((members?.length || 0) > 0);
          }
        }
      } else {
        if ((members?.length || 0) > 0) {
          setNeedsProfileSelection(true);
        } else {
          setActiveProfileState({
            id: userId,
            name: profileData.full_name,
            nickname: profileData?.nickname,
            avatarUrl: profileData?.avatar_url,
            isOwner: true,
          });
        }
      }
    } catch (error) {
      console.error('Error loading family members:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadFamilyMembers = async () => {
    if (!user?.id) return;
    try {
      const { data: members } = await supabase
        .from('customer_family_members')
        .select('*')
        .eq('customer_id', user.id);
      if (!mountedRef.current) return;
      setFamilyMembers(members || []);
    } catch {
      // silent
    }
  };

  const loadBusinessLocationsInternal = async (userId: string, profileData: Profile) => {
    try {
      // Prova prima registered_businesses
      let { data: business } = await supabase
        .from('registered_businesses')
        .select('id')
        .eq('owner_id', userId)
        .maybeSingle();

      // Fallback a businesses
      if (!business) {
        const result = await supabase
          .from('businesses')
          .select('id')
          .eq('owner_id', userId)
          .maybeSingle();
        business = result.data;
      }

      if (!business) {
        const ownerProfile: ActiveProfile = {
          id: userId,
          name: profileData.full_name,
          nickname: profileData?.nickname,
          avatarUrl: profileData?.avatar_url,
          isOwner: true,
        };
        setActiveProfileState(ownerProfile);
        setLoading(false);
        return;
      }

      let locationsTable: 'registered_business_locations' | 'business_locations' = 'registered_business_locations';
      let { data: locations } = await supabase
        .from('registered_business_locations')
        .select('id, name, internal_name, street, city, province, avatar_url, description')
        .eq('business_id', business.id);

      if (!locations || locations.length === 0) {
        locationsTable = 'business_locations';
        const result = await supabase
          .from('business_locations')
          .select('id, name, internal_name, address, city, province, avatar_url, description')
          .eq('business_id', business.id);
        locations = result.data;
      }

      setBusinessLocations((locations || []).map(l => ({ ...l, _table: locationsTable })));

      if (locations && locations.length === 1) {
        setActiveProfileState({
          id: userId,
          name: profileData.full_name,
          nickname: profileData?.nickname,
          avatarUrl: profileData?.avatar_url,
          isOwner: true,
        });
        storageSet(`activeLocation_${userId}`, userId);
        storageSet(`activeLocationIsOwner_${userId}`, 'true');
        setNeedsProfileSelection(false);
      } else if ((locations?.length || 0) > 1) {
        const savedLocationId = storageGet(`activeLocation_${userId}`);
        const savedIsOwner = storageGet(`activeLocationIsOwner_${userId}`) === 'true';

        if (savedLocationId) {
          if (savedIsOwner) {
            setActiveProfileState({
              id: userId,
              name: profileData.full_name,
              nickname: profileData?.nickname,
              avatarUrl: profileData?.avatar_url,
              isOwner: true,
            });
            setNeedsProfileSelection(false);
          } else {
            const location = locations?.find(l => l.id === savedLocationId);
            if (location) {
              setActiveProfileState({
                id: location.id,
                name: location.name,
                internal_name: location.internal_name,
                nickname: `${location.city}, ${location.province}`,
                avatarUrl: location.avatar_url,
                isOwner: false,
              });
              setNeedsProfileSelection(false);
            } else {
              setNeedsProfileSelection(true);
            }
          }
        } else {
          setNeedsProfileSelection(true);
        }
      } else {
        setActiveProfileState({
          id: userId,
          name: profileData.full_name,
          nickname: profileData?.nickname,
          avatarUrl: profileData?.avatar_url,
          isOwner: true,
        });
      }
    } catch (error) {
      console.error('Error loading business locations:', error);
    } finally {
      setLoading(false);
    }
  };

  const signUpCustomer = async (email: string, password: string, data: CustomerData) => {
    console.log('[signUpCustomer] before signUp, email:', email);
    const { data: authData, error } = await supabase.auth.signUp({
      email,
      password,
    });
    console.log('[signUpCustomer] after signUp, email:', email, 'data:', authData, 'error:', error);

    if (error) throw error;

    if (authData.user) {
      const billingAddress = `${data.billingStreet} ${data.billingStreetNumber}, ${data.billingPostalCode} ${data.billingCity}, ${data.billingProvince}`;

      const profileData: any = {
        full_name: `${data.firstName} ${data.lastName}`,
        first_name: data.firstName,
        last_name: data.lastName,
        date_of_birth: data.dateOfBirth,
        fiscal_code: data.fiscalCode,
        phone: data.phone,
        billing_street: data.billingStreet,
        billing_street_number: data.billingStreetNumber,
        billing_postal_code: data.billingPostalCode,
        billing_city: data.billingCity,
        billing_province: data.billingProvince.toUpperCase(),
        billing_address: billingAddress,
        user_type: 'customer',
        subscription_status: 'trial',
      };

      if (data.nickname) {
        profileData.nickname = data.nickname;
      }

      if (data.relationship) {
        profileData.relationship = data.relationship;
      }

      const { error: profileError } = await supabase
        .from('profiles')
        .update(profileData)
        .eq('id', authData.user.id);

      if (profileError) throw profileError;
    }
  };

  const signUpBusiness = async (email: string, password: string, data: BusinessData) => {
    console.log('[signUpBusiness] before signUp, email:', email);
    const { data: authData, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          user_type: 'business',
          full_name: data.companyName,
        }
      }
    });
    console.log('[signUpBusiness] after signUp, email:', email, 'data:', authData, 'error:', error);

    if (error) throw error;

    if (authData.user) {
      // Wait briefly for the handle_new_user trigger to create the profile
      await new Promise(r => setTimeout(r, 500));

      // Save all business data to profile as fallback
      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          full_name: data.companyName,
          user_type: 'business',
          company_name: data.companyName,
          vat_number: data.vatNumber || null,
          unique_code: data.uniqueCode || null,
          ateco_code: data.atecoCode || null,
          pec_email: data.pecEmail || null,
          website_url: data.website || null,
          phone: data.phone || null,
          description: data.description || null,
          category_id: data.categoryId || null,
          billing_street: data.billingStreet || null,
          billing_street_number: data.billingStreetNumber || null,
          billing_postal_code: data.billingPostalCode || null,
          billing_city: data.billingCity || null,
          billing_province: data.billingProvince || null,
          office_street: data.officeStreet || null,
          office_street_number: data.officeStreetNumber || null,
          office_postal_code: data.officePostalCode || null,
          office_city: data.officeCity || null,
          office_province: data.officeProvince || null,
        })
        .eq('id', authData.user.id);

      if (profileError) {
        console.error('[signUpBusiness] profile update error:', profileError);
        // Retry once after another delay (trigger might not have run yet)
        await new Promise(r => setTimeout(r, 1000));
        const { error: retryError } = await supabase
          .from('profiles')
          .update({
            full_name: data.companyName,
            user_type: 'business',
            company_name: data.companyName,
          })
          .eq('id', authData.user.id);
        if (retryError) throw retryError;
      }
    }
  };

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) throw error;
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    if (user?.id) {
      storageRemove(`activeProfile_${user.id}`);
      storageRemove(`activeProfileIsOwner_${user.id}`);
      storageRemove(`activeLocation_${user.id}`);
      storageRemove(`activeLocationIsOwner_${user.id}`);
    }
  };

  const refreshBusinessLocations = async () => {
    if (!user?.id || !profile) return;
    await loadBusinessLocationsInternal(user.id, profile);
  };

  const setActiveProfile = (profileId: string, isOwner: boolean) => {
    if (!user?.id || !profile) return;

    if (isOwner) {
      const ownerProfile: ActiveProfile = {
        id: user.id,
        name: profile.full_name,
        nickname: profile?.nickname,
        avatarUrl: profile?.avatar_url,
        isOwner: true,
      };
      setActiveProfileState(ownerProfile);

      if (profile.user_type === 'customer') {
        storageSet(`activeProfile_${user.id}`, user.id);
        storageSet(`activeProfileIsOwner_${user.id}`, 'true');
      } else if (profile.user_type === 'business') {
        storageSet(`activeLocation_${user.id}`, user.id);
        storageSet(`activeLocationIsOwner_${user.id}`, 'true');
      }
    } else {
      if (profile.user_type === 'customer') {
        const member = familyMembers.find(m => m.id === profileId);
        if (member) {
          const memberProfile: ActiveProfile = {
            id: member.id,
            name: `${member.first_name} ${member.last_name}`,
            nickname: member.nickname,
            avatarUrl: member.avatar_url,
            isOwner: false,
          };
          setActiveProfileState(memberProfile);
        }
        storageSet(`activeProfile_${user.id}`, profileId);
        storageSet(`activeProfileIsOwner_${user.id}`, String(isOwner));
      } else if (profile.user_type === 'business') {
        const location = businessLocations.find(l => l.id === profileId);
        if (location) {
          const locationProfile: ActiveProfile = {
            id: location.id,
            name: location.name,
            internal_name: location.internal_name,
            nickname: `${location.city}, ${location.province}`,
            avatarUrl: location.avatar_url,
            isOwner: false,
          };
          setActiveProfileState(locationProfile);
        }
        storageSet(`activeLocation_${user.id}`, profileId);
        storageSet(`activeLocationIsOwner_${user.id}`, String(isOwner));
      }
    }

    setNeedsProfileSelection(false);
  };

  const selectedBusinessLocationId =
    profile?.user_type === 'business' && activeProfile && !activeProfile.isOwner
      ? activeProfile.id
      : null;

  const updateFamilyMemberAvatar = (memberId: string, avatarUrl: string) => {
    setFamilyMembers(prev => prev.map(m => m.id === memberId ? { ...m, avatar_url: avatarUrl } : m));
    setActiveProfileState(prev => {
      if (prev && !prev.isOwner && prev.id === memberId) {
        return { ...prev, avatarUrl };
      }
      return prev;
    });
  };

  const value = {
    user,
    profile,
    loading,
    familyMembers,
    businessLocations,
    activeProfile,
    needsProfileSelection,
    selectedBusinessLocationId,
    signUpCustomer,
    signUpBusiness,
    signIn,
    signOut,
    setActiveProfile,
    loadFamilyMembers,
    refreshBusinessLocations,
    updateFamilyMemberAvatar,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
