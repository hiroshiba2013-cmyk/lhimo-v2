import { useState, useEffect, useMemo } from 'react';
import { User, Star, Plus, X, Package, LogOut, Trophy, TrendingUp, Briefcase, MapPin, FileEdit as Edit2, Trash2, Tag } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { ProfileClassifiedAdCard } from '../components/classifieds/ProfileClassifiedAdCard';
import { FavoriteClassifiedAdCard } from '../components/classifieds/FavoriteClassifiedAdCard';
import { ClassifiedAdForm } from '../components/classifieds/ClassifiedAdForm';
import { AvatarUpload } from '../components/profile/AvatarUpload';
import { FamilyMemberAvatarUpload } from '../components/profile/FamilyMemberAvatarUpload';
import { EditProfileForm } from '../components/profile/EditProfileForm';
import { JobRequestForm } from '../components/profile/JobRequestForm';
import { EditFamilyMembersForm } from '../components/profile/EditFamilyMembersForm';
import { AddUnclaimedBusinessForm } from '../components/profile/AddUnclaimedBusinessForm';
import { CreateBusinessForm } from '../components/business/CreateBusinessForm';
import { EditBusinessForm } from '../components/business/EditBusinessForm';
import { BusinessJobPostingForm } from '../components/business/BusinessJobPostingForm';
import { EditBusinessLocationsForm } from '../components/business/EditBusinessLocationsForm';
import { SubscriptionManagement } from '../components/subscription/SubscriptionManagement';
import TrialStatusBanner from '../components/subscription/TrialStatusBanner';
import { DeleteAccountButton } from '../components/profile/DeleteAccountButton';
import { PinSetup } from '../components/profile/PinSetup';
import { ReviewForm } from '../components/reviews/ReviewForm';
import { UserAuctionsSection } from '../components/auctions/UserAuctionsSection';
import { useToast } from '../components/common/Toast';

interface Profile {
  id: string;
  email: string;
  full_name: string;
  first_name: string;
  last_name: string;
  nickname: string;
  relationship: string;
  date_of_birth: string;
  fiscal_code: string;
  phone: string;
  billing_street: string;
  billing_street_number: string;
  billing_postal_code: string;
  billing_city: string;
  billing_province: string;
  billing_address: string;
  avatar_url: string | null;
  resume_url: string | null;
  user_type: 'customer' | 'business';
  subscription_type: string | null;
  subscription_status: string;
  subscription_expires_at: string | null;
  pin_enabled?: boolean;
  company_name?: string;
  vat_number?: string;
  unique_code?: string;
  pec_email?: string;
  ateco_code?: string;
  website_url?: string;
  office_street?: string;
  office_street_number?: string;
  office_postal_code?: string;
  office_city?: string;
  office_province?: string;
  office_address?: string;
  business_category_id?: string;
  category_id?: string;
  description?: string;
}

interface Review {
  id: string;
  rating: number;
  price_rating?: number | null;
  service_rating?: number | null;
  quality_rating?: number | null;
  overall_rating?: number;
  title: string;
  content: string;
  created_at: string;
  business_id?: string | null;
  imported_business_id?: string | null;
  user_added_business_id?: string | null;
  family_member_id?: string;
  business_location_id?: string | null;
  review_status: 'pending' | 'approved' | 'rejected';
  proof_image_url?: string | null;
  points_awarded?: number;
  business?: {
    name: string;
  };
  customer?: {
    full_name: string;
  };
  family_member?: {
    nickname: string;
  };
  business_location?: {
    id: string;
    name: string | null;
    address: string;
    city: string;
  } | null;
  location_info?: {
    name?: string;
    city: string;
  } | null;
}


interface Business {
  id: string;
  name: string;
  vat_number: string;
  unique_code: string;
  ateco_code: string;
  pec_email: string;
  phone: string;
  billing_address: string;
  office_address: string;
  website_url: string;
}

interface BusinessLocation {
  id: string;
  name: string | null;
  internal_name: string | null;
  address: string;
  city: string;
  province: string;
  description?: string;
  avatar_url?: string;
  phone?: string;
  email?: string;
  business?: {
    name: string;
  };
  rating?: number;
  reviews_count?: number;
}

interface ClassifiedAd {
  id: string;
  user_id: string;
  ad_type: 'sell' | 'buy' | 'gift';
  title: string;
  description: string;
  price: number | null;
  location: string;
  city: string;
  province: string;
  images: string[] | null;
  views_count: number;
  created_at: string;
  expires_at: string | null;
  status: string;
  profiles: {
    full_name: string;
    avatar_url: string | null;
  };
  classified_categories: {
    name: string;
    icon: string;
  };
}

interface JobPosting {
  id: string;
  title: string;
  description: string;
  position_type: string;
  location: string;
  experience_level: string;
  education_level: string;
  status: string;
  created_at: string;
  business_location_id?: string | null;
}

interface UserRank {
  rank: number;
  total_points: number;
  reviews_count: number;
}

interface FamilyMember {
  id: string;
  first_name: string;
  last_name: string;
  nickname: string;
  avatar_url: string | null;
  pin_enabled?: boolean;
  reviews_count: number;
  total_points: number;
  rank: number;
}

export function ProfilePage() {
  const { showToast } = useToast();
  const { user, signOut, activeProfile, selectedBusinessLocationId, setActiveProfile, updateFamilyMemberAvatar } = useAuth();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [business, setBusiness] = useState<Business | null>(null);
  const [isRegisteredBusiness, setIsRegisteredBusiness] = useState(false);
  const [businessLocations, setBusinessLocations] = useState<BusinessLocation[]>([]);
  const [jobPostings, setJobPostings] = useState<JobPosting[]>([]);
  const [classifiedAds, setClassifiedAds] = useState<ClassifiedAd[]>([]);
  const [favoriteAds, setFavoriteAds] = useState<ClassifiedAd[]>([]);
  const [favoriteBusinesses, setFavoriteBusinesses] = useState<BusinessLocation[]>([]);
  const [userRank, setUserRank] = useState<UserRank | null>(null);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [selectedFamilyMember, setSelectedFamilyMember] = useState<FamilyMember | null>(null);
  const [loading, setLoading] = useState(true);
  const [reviewFilters, setReviewFilters] = useState({
    nickname: '',
    rating: '',
    businessName: '',
    locationId: '',
  });
  const [editingReview, setEditingReview] = useState<Review | null>(null);

  const selectedLocationName = useMemo(() => {
    if (!selectedBusinessLocationId || businessLocations.length === 0) {
      return null;
    }
    const location = businessLocations.find(loc => loc.id === selectedBusinessLocationId);
    console.log('Computing selectedLocationName:', {
      selectedBusinessLocationId,
      location: JSON.parse(JSON.stringify(location)),
      internal_name: location?.internal_name,
      name: location?.name,
      allLocations: JSON.parse(JSON.stringify(businessLocations))
    });
    return location?.internal_name || location?.name || 'Sede Selezionata';
  }, [selectedBusinessLocationId, businessLocations]);
  const [showEditAdForm, setShowEditAdForm] = useState(false);
  const [editingAdId, setEditingAdId] = useState<string | null>(null);

  useEffect(() => {
    if (user) {
      loadProfileData();
    }
  }, [user, activeProfile]);

  const loadProfileData = async () => {
    if (!user) return;

    setLoading(true);
    try {
      const { data: profileData } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .maybeSingle();

      if (profileData) {
        setProfile(profileData);

        if (profileData.user_type === 'customer') {
          if (activeProfile?.isOwner === false && activeProfile?.id) {
            await loadFamilyMemberData(activeProfile.id);
          } else {
            await loadCustomerData();
          }
        } else {
          await loadBusinessData();
        }
      }
    } catch (error) {
      console.error('Error loading profile:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadCustomerData = async () => {
    // Query per ottenere SOLO le recensioni del titolare principale (non dei family members)
    const reviewsQuery = supabase
      .from('reviews')
      .select(`
        *,
        family_member:customer_family_members(nickname)
      `)
      .eq('customer_id', user?.id)
      .is('family_member_id', null)
      .order('created_at', { ascending: false });

    const { data: reviewsData } = await reviewsQuery;

    if (reviewsData) {
      const reviewsWithBusinessNames = await Promise.allSettled(
        reviewsData.map(async (review) => {
          let businessName = 'Attività';
          let locationInfo = null;

          if (review.unclaimed_business_location_id) {
            const { data: location } = await supabase
              .from('unclaimed_business_locations')
              .select('name, city')
              .eq('id', review.unclaimed_business_location_id)
              .maybeSingle();
            if (location) {
              businessName = location.name;
              locationInfo = { city: location.city };
            }
          } else if (review.business_id) {
            const { data: business } = await supabase
              .from('businesses')
              .select('name, city')
              .eq('id', review.business_id)
              .maybeSingle();
            if (business) {
              businessName = business.name;
              if (business.city) locationInfo = { city: business.city };
            }
          } else if (review.imported_business_id) {
            const { data: business } = await supabase
              .from('imported_businesses')
              .select('name, city')
              .eq('id', review.imported_business_id)
              .maybeSingle();
            if (business) {
              businessName = business.name;
              if (business.city) locationInfo = { city: business.city };
            }
          } else if (review.user_added_business_id) {
            const { data: business } = await supabase
              .from('user_added_businesses')
              .select('name, city')
              .eq('id', review.user_added_business_id)
              .maybeSingle();
            if (business) {
              businessName = business.name;
              if (business.city) locationInfo = { city: business.city };
            }
          }

          if (review.business_location_id) {
            const { data: location } = await supabase
              .from('business_locations')
              .select('internal_name, name, city, business_id, business:businesses(name)')
              .eq('id', review.business_location_id)
              .maybeSingle();
            if (location) {
              const biz = location.business as { name?: string } | null;
              if (biz?.name) businessName = biz.name;
              locationInfo = { name: location.internal_name || location.name, city: location.city };
            }
          }

          return { ...review, business: { name: businessName }, location_info: locationInfo };
        })
      );
      const resolved = reviewsWithBusinessNames
        .filter((r): r is PromiseFulfilledResult<typeof r extends PromiseFulfilledResult<infer T> ? T : never> => r.status === 'fulfilled')
        .map(r => r.value);
      setReviews(resolved);
    }

    await loadClassifiedAds();
    await loadFavoriteAds();
    await loadFavoriteBusinesses();
    await loadLeaderboardData();
    await loadFamilyMembersData();
  };

  const loadFamilyMemberData = async (familyMemberId: string) => {
    const { data: memberData } = await supabase
      .from('customer_family_members')
      .select('*')
      .eq('id', familyMemberId)
      .maybeSingle();

    if (memberData) {
      setSelectedFamilyMember(memberData);
    }

    const { data: reviewsData } = await supabase
      .from('reviews')
      .select('*')
      .eq('family_member_id', familyMemberId)
      .order('created_at', { ascending: false });

    if (reviewsData) {
      console.log('📝 Loading family member reviews:', reviewsData.length);
      const reviewsWithBusinessNames = await Promise.all(
        reviewsData.map(async (review) => {
          let businessName = 'Attività';
          let locationInfo = null;

          console.log('🔍 Family Review IDs:', {
            business_id: review.business_id,
            imported_business_id: review.imported_business_id,
            user_added_business_id: review.user_added_business_id,
            unclaimed_business_location_id: review.unclaimed_business_location_id,
            business_location_id: review.business_location_id
          });

          // Prova prima con unclaimed_business_location_id (nuovo sistema)
          if (review.unclaimed_business_location_id) {
            const { data: location } = await supabase
              .from('unclaimed_business_locations')
              .select('name, city')
              .eq('id', review.unclaimed_business_location_id)
              .maybeSingle();
            if (location) {
              businessName = location.name;
              locationInfo = { city: location.city };
            }
          } else if (review.business_id) {
            const { data: business } = await supabase
              .from('businesses')
              .select('name, city')
              .eq('id', review.business_id)
              .maybeSingle();
            if (business) {
              businessName = business.name;
              if (business.city) {
                locationInfo = { city: business.city };
              }
            }
          } else if (review.imported_business_id) {
            const { data: business } = await supabase
              .from('imported_businesses')
              .select('name, city')
              .eq('id', review.imported_business_id)
              .maybeSingle();
            if (business) {
              businessName = business.name;
              if (business.city) {
                locationInfo = { city: business.city };
              }
            }
          } else if (review.user_added_business_id) {
            const { data: business } = await supabase
              .from('user_added_businesses')
              .select('name, city')
              .eq('id', review.user_added_business_id)
              .maybeSingle();
            if (business) {
              businessName = business.name;
              if (business.city) {
                locationInfo = { city: business.city };
              }
            }
          }

          // Recupera info sulla sede specifica se disponibile
          if (review.business_location_id) {
            const { data: location } = await supabase
              .from('business_locations')
              .select('internal_name, name, city, business_id, business:businesses(name)')
              .eq('id', review.business_location_id)
              .maybeSingle();
            if (location) {
              // Usa il nome del business se disponibile
              if (location.business && location.business.name) {
                businessName = location.business.name;
              }
              locationInfo = {
                name: location.internal_name || location.name,
                city: location.city
              };
            }
          }

          console.log('✅ Family Business name resolved:', businessName);

          return {
            ...review,
            business: { name: businessName },
            location_info: locationInfo
          };
        })
      );
      setReviews(reviewsWithBusinessNames);
    }

    const { data: adsData, error: adsError } = await supabase
      .from('classified_ads')
      .select(`
        *,
        classified_categories(name, icon)
      `)
      .eq('user_id', user?.id)
      .eq('family_member_id', familyMemberId)
      .order('created_at', { ascending: false });

    if (adsError) {
      console.error('Error loading family member ads:', adsError);
      return;
    }

    if (adsData) {
      let profileInfo;
      if (familyMemberId) {
        const { data: fmData } = await supabase
          .from('customer_family_members')
          .select('nickname, avatar_url')
          .eq('id', familyMemberId)
          .single();

        profileInfo = fmData
          ? { full_name: fmData.nickname, avatar_url: fmData.avatar_url }
          : { full_name: 'Utente', avatar_url: null };
      } else {
        const { data: profData } = await supabase
          .from('profiles')
          .select('full_name, nickname, avatar_url')
          .eq('id', user?.id)
          .single();

        profileInfo = profData
          ? { full_name: profData.nickname || profData.full_name, avatar_url: profData.avatar_url }
          : { full_name: 'Utente', avatar_url: null };
      }

      const formattedAds = adsData.map(ad => ({
        ...ad,
        price: ad.price ? parseFloat(ad.price) : null,
        profiles: profileInfo
      }));
      setClassifiedAds(formattedAds);
    }

    const { data: memberActivity } = await supabase
      .from('user_activity')
      .select('total_points, reviews_count')
      .eq('family_member_id', familyMemberId)
      .maybeSingle();

    const total_points = memberActivity?.total_points || 0;
    const reviews_count = memberActivity?.reviews_count || 0;

    const { count: betterUsersCount } = await supabase
      .from('user_activity')
      .select('*', { count: 'exact', head: true })
      .gt('total_points', total_points);

    const rank = (betterUsersCount || 0) + 1;

    setUserRank({
      rank,
      total_points,
      reviews_count,
    });

    await loadFavoriteAds();
    await loadFavoriteBusinesses();
  };

  const loadLeaderboardData = async () => {
    if (!user) return;

    const { data: userActivity } = await supabase
      .from('user_activity')
      .select('total_points, reviews_count')
      .eq('user_id', user.id)
      .is('family_member_id', null)
      .maybeSingle();

    const totalPoints = userActivity?.total_points || 0;
    const reviewsCount = userActivity?.reviews_count || 0;

    const { count } = await supabase
      .from('user_activity')
      .select('*', { count: 'exact', head: true })
      .gt('total_points', totalPoints);

    setUserRank({
      rank: (count || 0) + 1,
      total_points: totalPoints,
      reviews_count: reviewsCount,
    });
  };

  const loadFamilyMembersData = async () => {
    if (!user) return;

    const { data: membersData } = await supabase
      .from('customer_family_members')
      .select('id, first_name, last_name, nickname, avatar_url')
      .eq('customer_id', user.id);

    if (membersData) {
      const membersWithStats = await Promise.all(
        membersData.map(async (member) => {
          const { data: activityData } = await supabase
            .from('user_activity')
            .select('total_points, reviews_count')
            .eq('family_member_id', member.id)
            .maybeSingle();

          const total_points = activityData?.total_points || 0;
          const reviews_count = activityData?.reviews_count || 0;

          const { count: betterUsersCount } = await supabase
            .from('user_activity')
            .select('*', { count: 'exact', head: true })
            .gt('total_points', total_points);

          const rank = (betterUsersCount || 0) + 1;

          return {
            ...member,
            reviews_count,
            total_points,
            rank,
          };
        })
      );

      setFamilyMembers(membersWithStats);
    }
  };

  const loadClassifiedAds = async () => {
    let query = supabase
      .from('classified_ads')
      .select(`*, classified_categories(name, icon)`)
      .eq('user_id', user?.id)
      .is('family_member_id', null)
      .order('created_at', { ascending: false });

    // For business users: filter by selected location (sede), or show all if "tutte le sedi"
    if (profile?.user_type === 'business' && selectedBusinessLocationId) {
      if (isRegisteredBusiness) {
        query = query.eq('registered_business_location_id', selectedBusinessLocationId);
      } else {
        query = query.eq('business_location_id', selectedBusinessLocationId);
      }
    }

    const { data: adsData, error } = await query;

    if (error) {
      console.error('Error loading classified ads:', error);
      return;
    }

    if (adsData) {
      const { data: profData } = await supabase
        .from('profiles')
        .select('full_name, nickname, avatar_url')
        .eq('id', user?.id)
        .maybeSingle();

      const profileInfo = profData
        ? { full_name: profData.nickname || profData.full_name, avatar_url: profData.avatar_url }
        : { full_name: 'Utente', avatar_url: null };

      const formattedAds = adsData.map(ad => ({
        ...ad,
        price: ad.price ? parseFloat(ad.price) : null,
        profiles: profileInfo
      }));
      setClassifiedAds(formattedAds);
    }
  };

  const loadFavoriteAds = async () => {
    if (!user) return;

    const familyMemberId = activeProfile?.isOwner === false ? activeProfile?.id : null;

    let favoritesQuery = supabase
      .from('favorite_classified_ads')
      .select(`
        ad_id,
        classified_ads(
          *,
          classified_categories(name, icon)
        )
      `)
      .eq('user_id', user.id);

    if (familyMemberId) {
      favoritesQuery = favoritesQuery.eq('family_member_id', familyMemberId);
    } else {
      favoritesQuery = favoritesQuery.is('family_member_id', null);
    }

    const { data: favoritesData, error } = await favoritesQuery;

    if (error) {
      console.error('Error loading favorite ads:', error);
      return;
    }

    if (favoritesData) {
      const ads = favoritesData
        .filter(fav => fav.classified_ads)
        .map(fav => fav.classified_ads as any);

      if (ads.length > 0) {
        const userIds = [...new Set(ads.map((ad: any) => ad.user_id))];
        const familyMemberIds = [...new Set(ads.map((ad: any) => ad.family_member_id).filter(Boolean))];

        const { data: profilesData } = await supabase
          .from('profiles')
          .select('id, full_name, nickname, avatar_url')
          .in('id', userIds);

        let familyMembersData: any[] = [];
        if (familyMemberIds.length > 0) {
          const { data: fmData } = await supabase
            .from('customer_family_members')
            .select('id, nickname, avatar_url')
            .in('id', familyMemberIds);

          familyMembersData = fmData || [];
        }

        const profilesMap = new Map(profilesData?.map(p => [p.id, p]) || []);
        const familyMembersMap = new Map(familyMembersData.map(fm => [fm.id, fm]));

        const formattedAds = ads.map((ad: any) => {
          let profileInfo;
          if (ad.family_member_id) {
            const familyMember = familyMembersMap.get(ad.family_member_id);
            profileInfo = familyMember
              ? { full_name: familyMember.nickname, avatar_url: familyMember.avatar_url }
              : { full_name: 'Utente', avatar_url: null };
          } else {
            const profile = profilesMap.get(ad.user_id);
            profileInfo = profile
              ? { full_name: profile.nickname || profile.full_name, avatar_url: profile.avatar_url }
              : { full_name: 'Utente', avatar_url: null };
          }

          return {
            ...ad,
            price: ad.price ? parseFloat(ad.price) : null,
            profiles: profileInfo
          };
        });

        setFavoriteAds(formattedAds);
      } else {
        setFavoriteAds([]);
      }
    }
  };

  const loadFavoriteBusinesses = async () => {
    if (!user) return;

    const familyMemberId = activeProfile?.isOwner === false ? activeProfile?.id : null;

    console.log('🔍 LOADING FAVORITE BUSINESSES');
    console.log('👤 User ID:', user.id);
    console.log('👨‍👩‍👧 Family Member ID:', familyMemberId);

    try {
      // Query base per i preferiti
      let baseQuery = supabase
        .from('favorite_businesses')
        .select('business_id, business_location_id, unclaimed_business_location_id')
        .eq('user_id', user.id);

      if (familyMemberId) {
        baseQuery = baseQuery.eq('family_member_id', familyMemberId);
      } else {
        baseQuery = baseQuery.is('family_member_id', null);
      }

      const { data: favoritesData, error: favError } = await baseQuery;

      if (favError) {
        console.error('Error loading favorites:', favError);
        return;
      }

      console.log('📊 Favorites found:', favoritesData?.length);

      const allLocations = [];

      // Carica business locations per i business registrati (vecchio metodo con business_id)
      const claimedBusinessIds = favoritesData
        ?.filter(f => f.business_id && !f.business_location_id)
        .map(f => f.business_id) || [];

      if (claimedBusinessIds.length > 0) {
        const { data: claimedLocations } = await supabase
          .from('business_locations')
          .select(`
            id,
            name,
            internal_name,
            address,
            city,
            province,
            description,
            avatar_url,
            phone,
            email,
            business_id,
            business:businesses(name)
          `)
          .in('business_id', claimedBusinessIds);

        if (claimedLocations) {
          allLocations.push(...claimedLocations);
        }
      }

      // Carica business locations specifiche (nuovo metodo con business_location_id)
      const claimedLocationIds = favoritesData
        ?.filter(f => f.business_location_id)
        .map(f => f.business_location_id) || [];

      if (claimedLocationIds.length > 0) {
        const { data: specificLocations } = await supabase
          .from('business_locations')
          .select(`
            id,
            name,
            internal_name,
            address,
            city,
            province,
            description,
            avatar_url,
            phone,
            email,
            business_id,
            business:businesses(name)
          `)
          .in('id', claimedLocationIds);

        if (specificLocations) {
          allLocations.push(...specificLocations);
        }
      }

      // Carica unclaimed business locations
      const unclaimedIds = favoritesData
        ?.filter(f => f.unclaimed_business_location_id)
        .map(f => f.unclaimed_business_location_id) || [];

      if (unclaimedIds.length > 0) {
        const { data: unclaimedLocations } = await supabase
          .from('unclaimed_business_locations')
          .select(`
            id,
            name,
            street,
            city,
            province,
            description,
            phone,
            email
          `)
          .in('id', unclaimedIds);

        if (unclaimedLocations) {
          allLocations.push(...unclaimedLocations.map(loc => ({
            ...loc,
            address: loc.street,
            avatar_url: null,
            internal_name: null,
            business_id: null,
            businesses: null
          })));
        }
      }

      console.log('🏢 All locations loaded:', allLocations.length);

      // Ottieni i rating per tutte le locations in una sola chiamata
      const locationIds = allLocations.map(loc => loc.id);
      console.log('📍 Location IDs to fetch ratings for:', locationIds);

      const { data: ratingsData, error: ratingsError } = await supabase
        .rpc('get_location_ratings', { location_ids: locationIds });

      if (ratingsError) {
        console.error('❌ Error fetching ratings:', ratingsError);
      }
      console.log('📊 Ratings data:', ratingsData);

      // Mappa i rating alle locations
      const locationsWithRatings = allLocations.map(location => {
        const rating = ratingsData?.find(r => r.id === location.id);
        return {
          ...location,
          rating: rating?.avg_rating || 0,
          reviews_count: rating?.review_count || 0
        };
      });

      console.log('⭐ Locations with ratings:', locationsWithRatings);
      console.log('🔍 First business details:', locationsWithRatings[0]);
      setFavoriteBusinesses(locationsWithRatings);
    } catch (error) {
      console.error('Error in loadFavoriteBusinesses:', error);
      setFavoriteBusinesses([]);
    }
  };

  const loadBusinessData = async () => {
    // Cerca prima nei business registrati (nuovo sistema)
    const { data: registeredBusinessData } = await supabase
      .from('registered_businesses')
      .select('*')
      .eq('owner_id', user?.id)
      .maybeSingle();

    if (registeredBusinessData) {
      setBusiness(registeredBusinessData);
      setIsRegisteredBusiness(true);

      const { data: locationsData } = await supabase
        .from('registered_business_locations')
        .select('id, name, internal_name, street, city, province')
        .eq('business_id', registeredBusinessData.id)
        .order('created_at', { ascending: true });

      if (locationsData) {
        console.log('Loading registered business locations:', JSON.parse(JSON.stringify(locationsData)));
        // Trasforma i dati per compatibilità con il formato esistente
        const transformedLocations = locationsData.map(loc => ({
          ...loc,
          address: loc.street
        }));
        setBusinessLocations(transformedLocations);
      }

      const { data: reviewsData } = await supabase
        .from('reviews')
        .select(`
          *,
          customer:profiles!customer_id(full_name),
          family_member:customer_family_members(nickname)
        `)
        .eq('business_id', registeredBusinessData.id)
        .order('created_at', { ascending: false });

      if (reviewsData) {
        setReviews(reviewsData);
      }

      const { data: jobPostingsData } = await supabase
        .from('job_postings')
        .select('id, title, description, position_type, location, experience_level, education_level, status, created_at, business_location_id')
        .eq('business_id', registeredBusinessData.id)
        .order('created_at', { ascending: false });

      if (jobPostingsData) {
        setJobPostings(jobPostingsData);
      }

      await loadClassifiedAds();
      return;
    }

    // Fallback: cerca nei business vecchi (per compatibilità)
    setIsRegisteredBusiness(false);
    const { data: businessData } = await supabase
      .from('businesses')
      .select('*')
      .eq('owner_id', user?.id)
      .maybeSingle();

    if (businessData) {
      setBusiness(businessData);

      const { data: locationsData } = await supabase
        .from('business_locations')
        .select('id, name, internal_name, address, city, province')
        .eq('business_id', businessData.id)
        .order('created_at', { ascending: true });

      if (locationsData) {
        console.log('Loading business locations:', JSON.parse(JSON.stringify(locationsData)));
        setBusinessLocations(locationsData);
      }

      const { data: reviewsData } = await supabase
        .from('reviews')
        .select(`
          *,
          customer:profiles!customer_id(full_name),
          family_member:customer_family_members(nickname),
          business_location:business_locations(id, name, address, city)
        `)
        .eq('business_id', businessData.id)
        .order('created_at', { ascending: false });

      if (reviewsData) {
        setReviews(reviewsData);
      }

      const { data: jobPostingsData } = await supabase
        .from('job_postings')
        .select('id, title, description, position_type, location, experience_level, education_level, status, created_at, business_location_id')
        .eq('business_id', businessData.id)
        .order('created_at', { ascending: false });

      if (jobPostingsData) {
        setJobPostings(jobPostingsData);
      }
    }

    await loadClassifiedAds();
  };


  const handleEditReview = (review: Review) => {
    setEditingReview(review);
  };

  const handleReviewUpdateSuccess = () => {
    setEditingReview(null);
    loadProfileData();
  };

  const handleDeleteReview = async (reviewId: string) => {
    if (!confirm('Sei sicuro di voler eliminare questa recensione? Questa azione non può essere annullata.')) return;

    try {
      const { error } = await supabase
        .from('reviews')
        .delete()
        .eq('id', reviewId);

      if (error) throw error;

      showToast('Recensione eliminata con successo!', 'success');
      loadProfileData();
    } catch (error) {
      console.error('Error deleting review:', error);
      showToast('Errore durante l\'eliminazione della recensione', 'error');
    }
  };

  const handleEditAd = (ad: ClassifiedAd) => {
    setEditingAdId(ad.id);
    setShowEditAdForm(true);
  };

  const handleDeleteAd = async (adId: string) => {
    try {
      const { error } = await supabase
        .from('classified_ads')
        .delete()
        .eq('id', adId);

      if (error) throw error;

      showToast('Annuncio eliminato con successo!', 'success');
      loadClassifiedAds();
    } catch (error) {
      console.error('Error deleting ad:', error);
      showToast('Errore durante l\'eliminazione dell\'annuncio', 'error');
    }
  };

  const handleAdFormSuccess = () => {
    setShowEditAdForm(false);
    setEditingAdId(null);
    loadClassifiedAds();
  };

  const filteredReviews = reviews.filter((review) => {
    const nicknameMatch = !reviewFilters.nickname ||
      review.family_member?.nickname?.toLowerCase().includes(reviewFilters.nickname.toLowerCase());

    const ratingMatch = !reviewFilters.rating ||
      review.rating === Number(reviewFilters.rating);

    const businessNameMatch = !reviewFilters.businessName ||
      review.business?.name?.toLowerCase().includes(reviewFilters.businessName.toLowerCase()) ||
      review.customer?.full_name?.toLowerCase().includes(reviewFilters.businessName.toLowerCase());

    const locationMatch = !reviewFilters.locationId ||
      (reviewFilters.locationId === 'general' && !review.business_location_id) ||
      review.business_location_id === reviewFilters.locationId;

    const businessLocationMatch = !selectedBusinessLocationId ||
      review.business_location_id === selectedBusinessLocationId;

    return nicknameMatch && ratingMatch && businessNameMatch && locationMatch && businessLocationMatch;
  });

  const filteredJobPostings = jobPostings.filter((job) => {
    if (!selectedBusinessLocationId) return true;
    return job.business_location_id === selectedBusinessLocationId;
  });

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!profile) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <p className="text-gray-600">Profilo non trovato</p>
      </div>
    );
  }

  const handleSignOut = async () => {
    try {
      await signOut();
      window.location.href = '/';
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  const handleAccountDeleted = async () => {
    await signOut();
    window.location.href = '/';
  };

  const isOwner = activeProfile?.isOwner ?? true;
  const isFamilyMember = !isOwner && profile?.user_type === 'customer';

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 via-white to-purple-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-gradient-to-r from-white to-blue-50 rounded-2xl shadow-lg p-8 mb-8 border-2 border-blue-200">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-6">
              {isFamilyMember && selectedFamilyMember ? (
                <>
                  <FamilyMemberAvatarUpload
                    memberId={selectedFamilyMember.id}
                    currentAvatarUrl={selectedFamilyMember.avatar_url ?? null}
                    onAvatarUpdate={(url) => {
                      setSelectedFamilyMember(prev => prev ? { ...prev, avatar_url: url } : prev);
                      updateFamilyMemberAvatar(selectedFamilyMember.id, url);
                    }}
                  />
                  <div>
                    <h1 className="text-3xl font-bold text-gray-900">
                      {selectedFamilyMember.nickname || `${selectedFamilyMember.first_name} ${selectedFamilyMember.last_name}`}
                    </h1>
                    <p className="text-gray-600 mt-1">
                      {selectedFamilyMember.first_name} {selectedFamilyMember.last_name}
                    </p>
                    <span className="inline-block mt-2 px-4 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-semibold">
                      Membro della Famiglia
                    </span>
                  </div>
                </>
              ) : (
                <>
                  <AvatarUpload
                    userId={profile.id}
                    currentAvatarUrl={profile.avatar_url}
                    onAvatarUpdate={() => loadProfileData()}
                  />
                  <div>
                    <h1 className="text-3xl font-bold text-gray-900">{profile.full_name}</h1>
                    <p className="text-gray-600 mt-1">{profile.email}</p>
                    <span className="inline-block mt-2 px-4 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-semibold">
                      {profile.user_type === 'customer' ? 'Cliente' : 'Azienda'}
                    </span>
                  </div>
                </>
              )}
            </div>
            <button
              onClick={handleSignOut}
              className="flex items-center gap-2 bg-red-600 text-white px-6 py-3 rounded-lg hover:bg-red-700 transition-colors font-semibold shadow-md"
              title="Esci"
            >
              <LogOut className="w-5 h-5" />
              Esci
            </button>
          </div>
        </div>

        {isOwner && profile.user_type === 'business' && (
          <TrialStatusBanner
            onUpgradeClick={() => {
              const subscriptionSection = document.querySelector('.subscription-management');
              if (subscriptionSection) {
                subscriptionSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
              }
            }}
          />
        )}

        {isOwner && (
          <div className="subscription-management">
            <SubscriptionManagement
              userId={profile.id}
              userType={profile.user_type}
              currentSubscriptionStatus={profile.subscription_status}
              onUpdate={loadProfileData}
            />
          </div>
        )}

        {profile.user_type === 'customer' && isOwner && userRank && (
          <div className="bg-gradient-to-r from-yellow-100 via-yellow-50 to-orange-100 rounded-2xl shadow-lg p-8 mb-8 border-4 border-yellow-300">
            <div className="flex items-center gap-4 mb-6">
              <div className="bg-gradient-to-br from-yellow-400 to-orange-400 p-4 rounded-xl shadow-lg">
                <Trophy className="w-8 h-8 text-white" />
              </div>
              <div>
                <h2 className="text-3xl font-bold text-gray-900">La Tua Posizione in Classifica</h2>
                <p className="text-gray-700 mt-1">Continua così per scalare la classifica!</p>
              </div>
            </div>

            <div className="bg-white rounded-xl p-8 mb-6 shadow-md border-2 border-yellow-200">
              <div className="grid md:grid-cols-3 gap-8">
                <div className="text-center bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-6 border-2 border-yellow-300">
                  <div className="text-5xl font-bold text-yellow-600 mb-3">#{userRank.rank}</div>
                  <p className="text-gray-700 font-bold text-lg">Posizione</p>
                </div>
                <div className="text-center bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-6 border-2 border-blue-300">
                  <div className="text-5xl font-bold text-blue-600 mb-3">{userRank.total_points}</div>
                  <p className="text-gray-700 font-bold text-lg">Punti Totali</p>
                </div>
                <div className="text-center bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-6 border-2 border-green-300">
                  <div className="text-5xl font-bold text-green-600 mb-3">{userRank.reviews_count}</div>
                  <p className="text-gray-700 font-bold text-lg">Recensioni</p>
                </div>
              </div>
            </div>

            <div className="mt-4 text-center">
              <a
                href="/leaderboard"
                className="inline-flex items-center gap-3 bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-8 py-4 rounded-xl hover:from-yellow-600 hover:to-orange-600 transition-all font-bold shadow-lg text-lg transform hover:scale-105"
              >
                <Trophy className="w-6 h-6" />
                Vedi Classifica Completa
              </a>
            </div>
          </div>
        )}

        {profile.user_type === 'customer' ? (
          <>
            {isOwner ? (
              <>
                <div className="bg-gradient-to-r from-blue-100 via-blue-50 to-white rounded-2xl p-6 mb-6 border-4 border-blue-300 shadow-md">
                  <div className="flex items-center gap-3">
                    <div className="bg-gradient-to-br from-blue-500 to-blue-600 p-3 rounded-xl shadow-lg">
                      <User className="w-7 h-7 text-white" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold text-gray-900">Dati Personali Account Principale</h2>
                      <p className="text-sm text-gray-600 mt-1">Informazioni del titolare dell'account</p>
                    </div>
                  </div>
                </div>

                <EditProfileForm
                  profile={profile}
                  onUpdate={loadProfileData}
                />

                <div className="bg-gradient-to-r from-green-100 via-green-50 to-white rounded-2xl p-6 mb-6 mt-8 border-4 border-green-300 shadow-md">
                  <div className="flex items-center gap-3">
                    <div className="bg-gradient-to-br from-green-500 to-green-600 p-3 rounded-xl shadow-lg">
                      <User className="w-7 h-7 text-white" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold text-gray-900">Membri della Famiglia</h2>
                      <p className="text-sm text-gray-600 mt-1">Gestisci i membri collegati al tuo account</p>
                    </div>
                  </div>
                </div>

                <EditFamilyMembersForm
                  customerId={profile.id}
                  onUpdate={loadProfileData}
                />

                <div className="mt-8">
                  <PinSetup
                    profileId={profile.id}
                    profileName={profile.full_name}
                    isOwner={true}
                    userType={profile.user_type}
                    currentPinEnabled={profile.pin_enabled || false}
                    onSuccess={loadProfileData}
                  />
                </div>
              </>
            ) : isFamilyMember && selectedFamilyMember && (
              <div className="bg-white rounded-xl shadow-md p-8 mb-8">
                <div className="border-t-4 border-blue-500 bg-gradient-to-r from-blue-50 to-white rounded-lg p-4 mb-6">
                  <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                    <User className="w-6 h-6 text-blue-600" />
                    Protezione Profilo
                  </h2>
                  <p className="text-sm text-gray-600 mt-1">Gestisci la sicurezza del tuo profilo</p>
                </div>

                <div className="bg-blue-50 border-2 border-blue-200 rounded-lg p-6 mb-6">
                  <div className="flex items-center gap-3 mb-3">
                    <User className="w-8 h-8 text-blue-600" />
                    <div>
                      <h3 className="font-bold text-lg text-gray-900">
                        {selectedFamilyMember.nickname || `${selectedFamilyMember.first_name} ${selectedFamilyMember.last_name}`}
                      </h3>
                      <p className="text-sm text-gray-600">Membro della Famiglia</p>
                    </div>
                  </div>
                  <p className="text-sm text-gray-700 leading-relaxed">
                    I tuoi dati personali sono gestiti dal profilo principale.
                    Solo tu puoi vedere le tue attività (recensioni, annunci).
                  </p>
                </div>

                <PinSetup
                  profileId={selectedFamilyMember.id}
                  profileName={`${selectedFamilyMember.first_name} ${selectedFamilyMember.last_name}`}
                  isOwner={false}
                  userType="customer"
                  currentPinEnabled={selectedFamilyMember.pin_enabled || false}
                  onSuccess={loadProfileData}
                />
              </div>
            )}

            {isFamilyMember && userRank && (
              <div className="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-xl shadow-md p-6 mb-8 border-2 border-yellow-200">
                <div className="flex items-center gap-3 mb-4">
                  <Trophy className="w-7 h-7 text-yellow-600" />
                  <h2 className="text-2xl font-bold text-gray-900">La Tua Posizione in Classifica</h2>
                </div>

                <div className="bg-white rounded-lg p-6 mb-4">
                  <div className="grid md:grid-cols-3 gap-6">
                    <div className="text-center">
                      <div className="text-4xl font-bold text-yellow-600 mb-2">#{userRank.rank}</div>
                      <p className="text-gray-600 font-medium">Posizione</p>
                    </div>
                    <div className="text-center">
                      <div className="text-4xl font-bold text-blue-600 mb-2">{userRank.total_points}</div>
                      <p className="text-gray-600 font-medium">Punti Totali</p>
                    </div>
                    <div className="text-center">
                      <div className="text-4xl font-bold text-green-600 mb-2">{userRank.reviews_count}</div>
                      <p className="text-gray-600 font-medium">Recensioni</p>
                    </div>
                  </div>
                </div>

                <div className="text-center">
                  <a
                    href="/leaderboard"
                    className="inline-flex items-center gap-2 bg-yellow-600 text-white px-6 py-3 rounded-lg hover:bg-yellow-700 transition-colors font-semibold shadow-md"
                  >
                    <Trophy className="w-5 h-5" />
                    Vedi Classifica Completa
                  </a>
                </div>
              </div>
            )}

            <AddUnclaimedBusinessForm
              customerId={profile.id}
              activeFamilyMemberId={isFamilyMember ? selectedFamilyMember?.id : undefined}
              onSuccess={loadProfileData}
            />

            <JobRequestForm customerId={profile.id} familyMemberId={isFamilyMember ? selectedFamilyMember?.id : undefined} />

            <div className="bg-white rounded-2xl shadow-xl p-8 mb-8 border border-gray-100 overflow-hidden relative">
              <div className="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-yellow-400 via-orange-400 to-red-400"></div>

              <div className="flex items-center justify-between mb-8">
                <div className="flex items-center gap-4">
                  <div className="bg-gradient-to-br from-yellow-400 to-orange-500 p-4 rounded-2xl shadow-lg">
                    <Star className="w-8 h-8 text-white" />
                  </div>
                  <div>
                    <h2 className="text-3xl font-bold bg-gradient-to-r from-yellow-600 to-orange-600 bg-clip-text text-transparent">
                      {isFamilyMember ? 'Recensioni di ' + (selectedFamilyMember?.nickname || `${selectedFamilyMember?.first_name}`) : 'Le Tue Recensioni'}
                    </h2>
                    <p className="text-gray-600 mt-1 font-medium">Condividi le tue esperienze con la community</p>
                  </div>
                </div>
                <a
                  href="/"
                  className="flex items-center gap-3 bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-8 py-4 rounded-xl hover:from-yellow-600 hover:to-orange-600 transition-all font-bold shadow-xl transform hover:scale-105 hover:shadow-2xl"
                >
                  <Plus className="w-5 h-5" />
                  Scrivi Recensione
                </a>
              </div>

              {isOwner && (
                <div className="mb-8 bg-gradient-to-br from-yellow-50 via-orange-50 to-yellow-50 border-2 border-yellow-300 rounded-2xl p-6 shadow-md">
                  <div className="flex items-center gap-3 mb-5">
                    <div className="bg-gradient-to-br from-yellow-400 to-yellow-500 p-3 rounded-xl shadow-md">
                      <Trophy className="w-6 h-6 text-white" />
                    </div>
                    <p className="text-gray-900 font-bold text-xl">Guadagna Punti Scrivendo Recensioni!</p>
                  </div>
                  <div className="grid md:grid-cols-2 gap-4">
                    <div className="bg-white rounded-xl p-5 border-2 border-yellow-200 shadow-sm hover:shadow-md transition-shadow">
                      <div className="flex items-center gap-3 mb-2">
                        <Star className="w-6 h-6 text-yellow-500" />
                        <span className="text-gray-800 font-semibold text-lg">Recensione Base</span>
                      </div>
                      <div className="flex items-baseline gap-2">
                        <span className="text-4xl font-bold bg-gradient-to-r from-yellow-500 to-yellow-600 bg-clip-text text-transparent">25</span>
                        <span className="text-gray-600 font-medium">punti</span>
                      </div>
                    </div>
                    <div className="bg-white rounded-xl p-5 border-2 border-orange-200 shadow-sm hover:shadow-md transition-shadow">
                      <div className="flex items-center gap-3 mb-2">
                        <Star className="w-6 h-6 text-orange-500 fill-orange-500" />
                        <span className="text-gray-800 font-semibold text-lg">Con Prova</span>
                      </div>
                      <div className="flex items-baseline gap-2">
                        <span className="text-4xl font-bold bg-gradient-to-r from-orange-500 to-red-500 bg-clip-text text-transparent">50</span>
                        <span className="text-gray-600 font-medium">punti</span>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {reviews.length > 0 && (
                <div className="mb-8 p-6 bg-gradient-to-br from-gray-50 to-white rounded-xl border border-gray-200 shadow-sm">
                  <h3 className="text-base font-bold text-gray-800 mb-4 flex items-center gap-2">
                    <div className="w-1 h-6 bg-gradient-to-b from-yellow-400 to-orange-400 rounded-full"></div>
                    Filtra Recensioni
                  </h3>
                  <div className="grid md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-2">Valutazione</label>
                      <select
                        value={reviewFilters.rating}
                        onChange={(e) => setReviewFilters({ ...reviewFilters, rating: e.target.value })}
                        className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 transition-all bg-white"
                      >
                        <option value="">Tutte le valutazioni</option>
                        <option value="5">⭐⭐⭐⭐⭐ 5 stelle</option>
                        <option value="4">⭐⭐⭐⭐ 4 stelle</option>
                        <option value="3">⭐⭐⭐ 3 stelle</option>
                        <option value="2">⭐⭐ 2 stelle</option>
                        <option value="1">⭐ 1 stella</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-2">Nome Azienda</label>
                      <input
                        type="text"
                        value={reviewFilters.businessName}
                        onChange={(e) => setReviewFilters({ ...reviewFilters, businessName: e.target.value })}
                        placeholder="Cerca per azienda..."
                        className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 transition-all"
                      />
                    </div>
                  </div>
                  {(reviewFilters.rating || reviewFilters.businessName) && (
                    <button
                      onClick={() => setReviewFilters({ nickname: '', rating: '', businessName: '', locationId: '' })}
                      className="mt-4 px-4 py-2 bg-yellow-100 text-yellow-700 rounded-lg hover:bg-yellow-200 font-semibold transition-colors"
                    >
                      Resetta Filtri
                    </button>
                  )}
                </div>
              )}

              {editingReview && (
                <ReviewForm
                  businessId={editingReview.business_id || editingReview.imported_business_id || editingReview.user_added_business_id || ''}
                  businessName={editingReview.business?.name}
                  businessLocationId={editingReview.business_location_id || undefined}
                  reviewToEdit={{
                    id: editingReview.id,
                    rating: editingReview.rating,
                    price_rating: editingReview.price_rating,
                    service_rating: editingReview.service_rating,
                    quality_rating: editingReview.quality_rating,
                    overall_rating: editingReview.overall_rating,
                    title: editingReview.title,
                    content: editingReview.content,
                    business_location_id: editingReview.business_location_id,
                    proof_image_url: editingReview.proof_image_url,
                  }}
                  onClose={() => setEditingReview(null)}
                  onSuccess={handleReviewUpdateSuccess}
                />
              )}

              {reviews.length === 0 ? (
                <div className="text-center py-16 bg-gradient-to-br from-gray-50 to-white rounded-2xl border-2 border-dashed border-gray-200">
                  <Star className="w-20 h-20 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-600 text-lg font-medium mb-2">
                    {isFamilyMember ? 'Nessuna recensione scritta da questo membro' : 'Non hai ancora scritto recensioni'}
                  </p>
                  <p className="text-gray-500 text-sm">Inizia a condividere le tue esperienze!</p>
                </div>
              ) : filteredReviews.length === 0 ? (
                <div className="text-center py-16 bg-gradient-to-br from-gray-50 to-white rounded-2xl border-2 border-dashed border-gray-200">
                  <Star className="w-20 h-20 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-600 text-lg font-medium">Nessuna recensione trovata con questi filtri</p>
                </div>
              ) : (
                <div className="space-y-5">
                  {filteredReviews.map((review) => (
                    <div key={review.id} className={`rounded-2xl p-6 transition-all shadow-md hover:shadow-lg ${
                      review.review_status === 'pending'
                        ? 'border-2 border-yellow-300 bg-gradient-to-br from-yellow-50 to-yellow-100'
                        : review.review_status === 'rejected'
                        ? 'border-2 border-red-300 bg-gradient-to-br from-red-50 to-red-100'
                        : 'border-2 border-gray-200 bg-white hover:border-yellow-300'
                    }`}>
                      <div className="flex items-start justify-between mb-4">
                        <div className="flex-1">
                          <div className="flex items-start gap-3 mb-3">
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-2">
                                <h3 className="font-bold text-xl text-gray-900">{review.business?.name || 'Attività'}</h3>
                                {review.review_status === 'pending' && (
                                  <span className="px-3 py-1 bg-yellow-200 text-yellow-800 text-xs font-semibold rounded-full">
                                    In attesa di approvazione
                                  </span>
                                )}
                                {review.review_status === 'rejected' && (
                                  <span className="px-3 py-1 bg-red-200 text-red-800 text-xs font-semibold rounded-full">
                                    Rifiutata
                                  </span>
                                )}
                              </div>
                              {review.location_info && (
                                <p className="text-sm text-gray-600 flex items-center gap-1 mb-2">
                                  <MapPin className="w-4 h-4" />
                                  {review.location_info.name && `${review.location_info.name} - `}{review.location_info.city}
                                </p>
                              )}
                              <h4 className="font-semibold text-base text-gray-700">{review.title}</h4>
                            </div>
                          </div>
                          {review.review_status === 'pending' && (
                            <p className="text-xs text-yellow-700 mt-2 font-medium">
                              La tua recensione sarà visibile dopo la verifica dello staff.
                              {review.proof_image_url ? ' Riceverai 50 punti' : ' Riceverai 25 punti'} dopo l'approvazione.
                            </p>
                          )}
                          {review.review_status === 'approved' && review.points_awarded && (
                            <p className="text-xs text-green-700 mt-2 font-medium">
                              Recensione approvata - Hai guadagnato {review.points_awarded} punti!
                            </p>
                          )}
                        </div>
                        <div className="flex items-center gap-3">
                          <div className="flex items-center gap-1">
                            {Array.from({ length: 5 }).map((_, i) => (
                              <Star
                                key={i}
                                className={`w-5 h-5 ${
                                  i < review.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'
                                }`}
                              />
                            ))}
                          </div>
                          {review.review_status !== 'rejected' && (
                            <div className="flex gap-2">
                              <button
                                onClick={() => handleEditReview(review)}
                                className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                                title="Modifica recensione"
                              >
                                <Edit2 className="w-4 h-4" />
                              </button>
                              <button
                                onClick={() => handleDeleteReview(review.id)}
                                className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                title="Elimina recensione"
                              >
                                <Trash2 className="w-4 h-4" />
                              </button>
                            </div>
                          )}
                        </div>
                      </div>
                      <p className="text-gray-700 leading-relaxed">{review.content}</p>
                      <p className="text-sm text-gray-500 mt-3">
                        {new Date(review.created_at).toLocaleDateString('it-IT')}
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl shadow-lg p-8 mb-8 border-4 border-green-200">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <div className="bg-gradient-to-br from-green-500 to-emerald-500 p-3 rounded-xl shadow-lg">
                    <Package className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h2 className="text-3xl font-bold text-gray-900">
                      {isFamilyMember ? 'Annunci di ' + (selectedFamilyMember?.nickname || `${selectedFamilyMember?.first_name}`) : 'I Tuoi Annunci'}
                    </h2>
                    <p className="text-sm text-gray-600 mt-1">Compra, vendi e scambia</p>
                  </div>
                </div>
                <a
                  href="/classified?action=create"
                  className="flex items-center gap-2 bg-gradient-to-r from-green-500 to-emerald-500 text-white px-8 py-4 rounded-xl hover:from-green-600 hover:to-emerald-600 transition-all font-bold shadow-lg transform hover:scale-105"
                >
                  <Plus className="w-5 h-5" />
                  Crea Annuncio
                </a>
              </div>

              {isOwner && (
                <div className="mb-6 bg-gradient-to-r from-blue-50 to-green-50 border-2 border-blue-200 rounded-lg p-4">
                  <div className="flex items-center gap-3">
                    <TrendingUp className="w-6 h-6 text-green-600" />
                    <p className="text-gray-800 font-semibold">
                      Guadagna <span className="text-green-600 font-bold">5 punti</span> in classifica per ogni annuncio approvato!
                    </p>
                  </div>
                </div>
              )}

              {classifiedAds.length === 0 ? (
                <div className="text-center py-8">
                  <Package className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-4">
                    {isFamilyMember ? 'Nessun annuncio pubblicato da questo membro' : 'Non hai ancora pubblicato annunci'}
                  </p>
                  <a
                    href="/classified?action=create"
                    className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    Pubblica il tuo primo annuncio
                  </a>
                </div>
              ) : (
                <>
                  {showEditAdForm && (
                    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 overflow-y-auto">
                      <div className="bg-white rounded-xl p-8 max-w-4xl w-full my-8">
                        <h2 className="text-2xl font-bold text-gray-900 mb-6">Modifica Annuncio</h2>
                        <ClassifiedAdForm
                          adId={editingAdId || undefined}
                          onSuccess={handleAdFormSuccess}
                          onCancel={() => {
                            setShowEditAdForm(false);
                            setEditingAdId(null);
                          }}
                        />
                      </div>
                    </div>
                  )}
                  <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {classifiedAds.map((ad) => (
                      <ProfileClassifiedAdCard
                        key={ad.id}
                        ad={ad}
                        onEdit={handleEditAd}
                        onDelete={handleDeleteAd}
                      />
                    ))}
                  </div>
                </>
              )}
            </div>

            <UserAuctionsSection />

            <div className="bg-white rounded-xl shadow-md p-8 mb-8">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <Star className="w-6 h-6 text-yellow-600" />
                  <h2 className="text-2xl font-bold text-gray-900">
                    {isFamilyMember ? 'Annunci Preferiti di ' + (selectedFamilyMember?.nickname || `${selectedFamilyMember?.first_name}`) : 'Annunci Preferiti'}
                  </h2>
                </div>
              </div>

              {favoriteAds.length === 0 ? (
                <div className="text-center py-8">
                  <Star className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-4">
                    {isFamilyMember ? 'Nessun annuncio salvato da questo membro' : 'Non hai ancora salvato annunci'}
                  </p>
                  <a
                    href="/classified"
                    className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    Esplora gli annunci
                  </a>
                </div>
              ) : (
                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {favoriteAds.map((ad) => (
                    <FavoriteClassifiedAdCard
                      key={ad.id}
                      ad={ad}
                      familyMemberId={activeProfile?.isOwner === false ? activeProfile?.id : null}
                      onRemove={loadFavoriteAds}
                    />
                  ))}
                </div>
              )}
            </div>

            <div className="bg-white rounded-xl shadow-md p-8 mb-8">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <Star className="w-6 h-6 text-blue-600 fill-blue-600" />
                  <h2 className="text-2xl font-bold text-gray-900">
                    {isFamilyMember ? 'Attività Preferite di ' + (selectedFamilyMember?.nickname || `${selectedFamilyMember?.first_name}`) : 'Attività Preferite'}
                  </h2>
                </div>
              </div>

              {favoriteBusinesses.length === 0 ? (
                <div className="text-center py-8">
                  <Star className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-4">
                    {isFamilyMember ? 'Nessuna attività salvata da questo membro' : 'Non hai ancora salvato attività'}
                  </p>
                  <a
                    href="/"
                    className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    Cerca attività
                  </a>
                </div>
              ) : (
                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {favoriteBusinesses.map((business) => (
                    <div key={business.id} className="bg-white border-2 border-gray-200 rounded-xl hover:shadow-lg transition-all duration-300">
                      <div className="p-6">
                        <div className="flex items-start justify-between mb-4">
                          <div className="flex-1">
                            {business.avatar_url ? (
                              <img
                                src={business.avatar_url}
                                alt={business.business?.name || business.name || 'Attività'}
                                className="w-16 h-16 rounded-lg object-cover mb-3"
                              />
                            ) : (
                              <div className="w-16 h-16 rounded-lg bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center mb-3">
                                <Briefcase className="w-8 h-8 text-white" />
                              </div>
                            )}
                            <h3 className="text-lg font-bold text-gray-900 mb-1">
                              {business.business?.name || business.name || 'Attività'}
                            </h3>
                            {business.business?.name && (business.internal_name || business.name) && business.business.name !== (business.internal_name || business.name) && (
                              <p className="text-sm text-gray-600 mb-2">Sede: {business.internal_name || business.name}</p>
                            )}
                            <div className="flex items-center gap-2 text-sm text-gray-600 mb-2">
                              <MapPin className="w-4 h-4" />
                              <span>{business.city}, {business.province}</span>
                            </div>
                            {business.rating > 0 && (
                              <div className="flex items-center gap-2 mb-3">
                                <div className="flex items-center gap-1">
                                  {[...Array(5)].map((_, i) => (
                                    <Star
                                      key={i}
                                      className={`w-4 h-4 ${
                                        i < Math.round(business.rating)
                                          ? 'text-yellow-400 fill-yellow-400'
                                          : 'text-gray-300'
                                      }`}
                                    />
                                  ))}
                                </div>
                                <span className="text-sm text-gray-600">
                                  {business.rating.toFixed(1)} ({business.reviews_count} recensioni)
                                </span>
                              </div>
                            )}
                          </div>
                        </div>

                        {business.description && (
                          <p className="text-sm text-gray-600 mb-4 line-clamp-2">
                            {business.description}
                          </p>
                        )}

                        <div className="flex gap-2">
                          <a
                            href={business.business_id
                              ? `/business/${business.business_id}?locationId=${business.id}`
                              : `/business/${business.id}`}
                            className="flex-1 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors text-center text-sm font-semibold"
                          >
                            Visualizza
                          </a>
                          <button
                            onClick={async () => {
                              const familyMemberId = activeProfile?.isOwner === false ? activeProfile?.id : null;

                              // Costruisci la query in base al tipo di attività
                              let deleteQuery = supabase
                                .from('favorite_businesses')
                                .delete()
                                .eq('user_id', user?.id);

                              if (business.business_id) {
                                // Business claimed - usa business_location_id
                                deleteQuery = deleteQuery.eq('business_location_id', business.id);
                              } else {
                                // Unclaimed business
                                deleteQuery = deleteQuery.eq('unclaimed_business_location_id', business.id);
                              }

                              if (familyMemberId) {
                                deleteQuery = deleteQuery.eq('family_member_id', familyMemberId);
                              } else {
                                deleteQuery = deleteQuery.is('family_member_id', null);
                              }

                              await deleteQuery;
                              await loadFavoriteBusinesses();
                            }}
                            className="px-4 py-2 border-2 border-red-200 text-red-600 rounded-lg hover:bg-red-50 transition-colors"
                          >
                            <X className="w-5 h-5" />
                          </button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </>
        ) : (
          <>
            {!business && user && (
              <div className="bg-yellow-50 border-2 border-yellow-400 rounded-xl p-8 mb-8">
                <h3 className="text-xl font-bold text-gray-900 mb-4">Completa la Registrazione Aziendale</h3>
                <p className="text-gray-700 mb-6">
                  Per accedere a tutte le funzionalità business (gestione sedi, annunci di lavoro, ecc.)
                  devi prima completare i dati della tua azienda.
                </p>
                <div className="border-t-4 border-green-500 bg-gradient-to-r from-green-50 to-white rounded-lg p-4 mb-6">
                  <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                    <User className="w-6 h-6 text-green-600" />
                    Crea la Tua Azienda
                  </h2>
                  <p className="text-sm text-gray-600 mt-1">Inserisci i dati della tua azienda per iniziare</p>
                </div>
                <CreateBusinessForm
                  ownerId={user.id}
                  onSuccess={loadBusinessData}
                  onCancel={() => {}}
                />
              </div>
            )}

            {business && (
              <>
                {businessLocations.length > 1 && (
                  <div className="bg-gradient-to-r from-blue-50 to-slate-50 rounded-xl shadow-lg p-6 mb-8 border-2 border-blue-300">
                    <div className="flex items-center gap-3 mb-4">
                      <MapPin className="w-6 h-6 text-blue-600" />
                      <h2 className="text-xl font-bold text-gray-900">Seleziona Sede da Gestire</h2>
                    </div>
                    <p className="text-sm text-gray-600 mb-4">
                      Seleziona una sede specifica per visualizzare e gestire solo i dati di quella sede
                      (recensioni, annunci di lavoro). Lascia "Tutte le Sedi" per vedere tutto.
                    </p>
                    <select
                      value={selectedBusinessLocationId || ''}
                      onChange={(e) => {
                        if (e.target.value) {
                          setActiveProfile(e.target.value, false);
                        } else {
                          setActiveProfile(user!.id, true);
                        }
                      }}
                      className="w-full px-4 py-3 border-2 border-blue-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-base font-medium bg-white"
                    >
                      <option value="">Tutte le Sedi</option>
                      {businessLocations.map((location, index) => (
                        <option key={location.id} value={location.id}>
                          {location.internal_name || `Sede ${index + 1}`} - {location.name || location.city}
                        </option>
                      ))}
                    </select>
                    {selectedBusinessLocationId && (
                      <div className="mt-4 p-3 bg-blue-100 border border-blue-300 rounded-lg">
                        <p className="text-sm text-blue-800 font-medium">
                          Stai visualizzando solo i dati della sede selezionata
                        </p>
                      </div>
                    )}
                  </div>
                )}

                <div className="border-t-4 border-green-500 bg-gradient-to-r from-green-50 to-white rounded-lg p-4 mb-6 mt-8">
                  <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                    <User className="w-6 h-6 text-green-600" />
                    Dati Aziendali
                  </h2>
                  <p className="text-sm text-gray-600 mt-1">Informazioni generali dell'azienda</p>
                </div>

                <EditBusinessForm
                  businessId={business.id}
                  selectedLocationId={selectedBusinessLocationId}
                  onUpdate={loadBusinessData}
                />

                <div className="border-t-4 border-orange-500 bg-gradient-to-r from-orange-50 to-white rounded-lg p-4 mb-6 mt-8">
                  <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                    <User className="w-6 h-6 text-orange-600" />
                    {selectedLocationName ? (
                      <>
                        Punto Vendita: {selectedLocationName}
                      </>
                    ) : (
                      'Punti Vendita'
                    )}
                  </h2>
                  <p className="text-sm text-gray-600 mt-1">
                    {selectedLocationName
                      ? 'Visualizzazione e modifica del punto vendita selezionato'
                      : 'Gestisci i punti vendita dell\'azienda'
                    }
                  </p>
                </div>

                <EditBusinessLocationsForm
                  businessId={business.id}
                  selectedLocationId={selectedBusinessLocationId}
                  onUpdate={loadBusinessData}
                />

                <div className="border-t-4 border-slate-500 bg-gradient-to-r from-slate-50 to-white rounded-lg p-4 mb-6 mt-8">
                  <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                    <Briefcase className="w-6 h-6 text-slate-600" />
                    Annunci di Lavoro
                  </h2>
                  <p className="text-sm text-gray-600 mt-1">Pubblica e gestisci i tuoi annunci di ricerca personale</p>
                </div>

                <BusinessJobPostingForm
                  businessId={business.id}
                  selectedLocationId={selectedBusinessLocationId || ''}
                />
              </>
            )}

            <UserAuctionsSection
              businessLocationId={selectedBusinessLocationId}
              isRegisteredBusiness={isRegisteredBusiness}
            />

            <div className="bg-white rounded-xl shadow-md overflow-hidden mb-6">
              {/* Section header with green accent */}
              <div className="bg-gradient-to-r from-green-600 to-emerald-500 px-5 py-3 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Tag className="w-5 h-5 text-white" />
                  <div>
                    <h2 className="text-base font-bold text-white">
                      {selectedBusinessLocationId ? `Annunci — ${selectedLocationName}` : 'I Miei Annunci'}
                    </h2>
                    <p className="text-xs text-green-100 mt-0.5">
                      {selectedBusinessLocationId ? 'Annunci di questa sede' : 'Tutte le sedi'}
                    </p>
                  </div>
                </div>
                <button
                  onClick={() => { setEditingAdId(null); setShowEditAdForm(true); }}
                  className="flex items-center gap-2 bg-white/20 hover:bg-white/30 text-white px-3 py-1.5 rounded-lg text-sm font-semibold transition-colors border border-white/30"
                >
                  <Plus className="w-4 h-4" />
                  Nuovo
                </button>
              </div>

              {/* Body */}
              <div className="p-5">

              {showEditAdForm && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
                  <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
                    <ClassifiedAdForm
                      adId={editingAdId || undefined}
                      businessLocationId={selectedBusinessLocationId}
                      isRegisteredBusiness={isRegisteredBusiness}
                      onSuccess={() => { setShowEditAdForm(false); loadClassifiedAds(); }}
                      onCancel={() => setShowEditAdForm(false)}
                    />
                  </div>
                </div>
              )}

              {classifiedAds.length === 0 ? (
                <div className="text-center py-10">
                  <Tag className="w-14 h-14 text-gray-300 mx-auto mb-4" />
                  <h3 className="text-lg font-semibold text-gray-700 mb-2">Nessun annuncio</h3>
                  <p className="text-gray-500 text-sm mb-6">Pubblica annunci di vendita, acquisto o regalo.</p>
                  <button
                    onClick={() => { setEditingAdId(null); setShowEditAdForm(true); }}
                    className="inline-flex items-center gap-2 bg-green-600 text-white px-6 py-3 rounded-xl hover:bg-green-700 transition-colors font-semibold"
                  >
                    <Plus className="w-5 h-5" />
                    Crea il primo annuncio
                  </button>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {classifiedAds.map((ad) => (
                    <ProfileClassifiedAdCard
                      key={ad.id}
                      ad={ad}
                      onEdit={handleEditAd}
                      onDelete={handleDeleteAd}
                    />
                  ))}
                </div>
              )}
              </div>{/* end body */}
            </div>

            <div className="bg-white rounded-xl shadow-md p-8 mb-8">
              <div className="flex items-center gap-3 mb-6">
                <Star className="w-6 h-6 text-yellow-500" />
                <h2 className="text-2xl font-bold text-gray-900">Recensioni Ricevute</h2>
              </div>

              {reviews.length > 0 && (
                <div className="mb-6 p-4 bg-gray-50 rounded-lg">
                  <h3 className="text-sm font-semibold text-gray-700 mb-3">Filtra Recensioni</h3>
                  <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <div>
                      <label className="block text-sm text-gray-600 mb-1">Nickname</label>
                      <input
                        type="text"
                        value={reviewFilters.nickname}
                        onChange={(e) => setReviewFilters({ ...reviewFilters, nickname: e.target.value })}
                        placeholder="Cerca per nickname"
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>
                    <div>
                      <label className="block text-sm text-gray-600 mb-1">Valutazione</label>
                      <select
                        value={reviewFilters.rating}
                        onChange={(e) => setReviewFilters({ ...reviewFilters, rating: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      >
                        <option value="">Tutte le valutazioni</option>
                        <option value="5">5 stelle</option>
                        <option value="4">4 stelle</option>
                        <option value="3">3 stelle</option>
                        <option value="2">2 stelle</option>
                        <option value="1">1 stella</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm text-gray-600 mb-1">Nome Cliente</label>
                      <input
                        type="text"
                        value={reviewFilters.businessName}
                        onChange={(e) => setReviewFilters({ ...reviewFilters, businessName: e.target.value })}
                        placeholder="Cerca per cliente"
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>
                    <div>
                      <label className="block text-sm text-gray-600 mb-1">Sede</label>
                      <select
                        value={reviewFilters.locationId}
                        onChange={(e) => setReviewFilters({ ...reviewFilters, locationId: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      >
                        <option value="">Tutte le sedi</option>
                        <option value="general">Recensioni generali</option>
                        {businessLocations.map((location) => (
                          <option key={location.id} value={location.id}>
                            {location.name || `${location.address}, ${location.city}`}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                  {(reviewFilters.nickname || reviewFilters.rating || reviewFilters.businessName || reviewFilters.locationId) && (
                    <button
                      onClick={() => setReviewFilters({ nickname: '', rating: '', businessName: '', locationId: '' })}
                      className="mt-3 text-sm text-blue-600 hover:text-blue-700 font-semibold"
                    >
                      Resetta Filtri
                    </button>
                  )}
                </div>
              )}

              {reviews.length === 0 ? (
                <p className="text-gray-600 text-center py-8">Nessuna recensione ricevuta</p>
              ) : filteredReviews.length === 0 ? (
                <p className="text-gray-600 text-center py-8">Nessuna recensione trovata con questi filtri</p>
              ) : (
                <div className="space-y-4">
                  {filteredReviews.map((review) => (
                    <div key={review.id} className="border border-gray-200 rounded-lg p-6 hover:border-blue-300 transition-colors">
                      <div className="flex items-start justify-between mb-3">
                        <div>
                          <h3 className="font-semibold text-lg text-gray-900">{review.title}</h3>
                          <p className="text-sm text-gray-600 mt-1">
                            Da: {review.customer?.full_name}
                          </p>
                          {review.family_member?.nickname && (
                            <p className="text-xs text-blue-600 mt-1">
                              Scritta da: {review.family_member.nickname}
                            </p>
                          )}
                          {review.business_location ? (
                            <p className="text-xs text-green-600 mt-1 flex items-center gap-1">
                              <MapPin className="w-3 h-3" />
                              Sede: {review.business_location.name || `${review.business_location.address}, ${review.business_location.city}`}
                            </p>
                          ) : (
                            <p className="text-xs text-gray-500 mt-1">
                              Recensione generale
                            </p>
                          )}
                        </div>
                        <div className="flex items-center gap-1">
                          {Array.from({ length: 5 }).map((_, i) => (
                            <Star
                              key={i}
                              className={`w-5 h-5 ${
                                i < review.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'
                              }`}
                            />
                          ))}
                        </div>
                      </div>
                      <p className="text-gray-700 leading-relaxed">{review.content}</p>
                      <p className="text-sm text-gray-500 mt-3">
                        {new Date(review.created_at).toLocaleDateString('it-IT')}
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>

          </>
        )}

        {isOwner && <DeleteAccountButton onAccountDeleted={handleAccountDeleted} />}
      </div>
    </div>
  );
}
