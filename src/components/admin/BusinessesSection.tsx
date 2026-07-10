import { useState, useEffect, useRef } from 'react';
import { Building2, CheckCircle, MapPin, Mail, Phone, FileEdit as Edit2, Search, Filter, Download, Upload, UserPlus, X, FileText, Briefcase, Clock, ShieldCheck, ShieldX, XCircle, Hash } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { AdminLocationFilter } from './AdminLocationFilter';
import { useToast } from '../common/Toast';

const DAYS_IT: { [key: string]: string } = {
  monday: 'Lunedì',
  tuesday: 'Martedì',
  wednesday: 'Mercoledì',
  thursday: 'Giovedì',
  friday: 'Venerdì',
  saturday: 'Sabato',
  sunday: 'Domenica'
};

const formatBusinessHours = (hours: any) => {
  if (!hours || typeof hours !== 'object') {
    return <p className="text-gray-500 italic">Orari non disponibili</p>;
  }

  const daysOrder = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

  return (
    <div className="space-y-1">
      {daysOrder.map(day => {
        const dayHours = hours[day];
        if (!dayHours || typeof dayHours !== 'object') return null;

        return (
          <div key={day} className="flex items-center justify-between py-2 border-b border-gray-100 last:border-0">
            <span className="font-medium text-gray-700 w-32">{DAYS_IT[day]}</span>
            {dayHours.closed === true ? (
              <span className="text-red-600 font-medium">Chiuso</span>
            ) : (
              <span className="text-gray-900 font-mono">
                {dayHours.open || '--:--'} - {dayHours.close || '--:--'}
              </span>
            )}
          </div>
        );
      })}
    </div>
  );
};

interface BusinessLocation {
  id: string;
  business_id: string | null;
  unclaimed_business_id: string | null;
  name: string;
  business_name?: string;
  address: string;
  city: string;
  province: string;
  region: string;
  postal_code: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  vat_number: string | null;
  is_verified: boolean;
  is_main: boolean;
  created_at: string;
  description?: string | null;
  business_hours?: any;
  services?: string[] | null;
  services_description?: string | null;
  category: {
    name: string;
  } | null;
  category_id?: string | null;
  business?: {
    owner_id: string;
    owner: {
      full_name: string;
      email: string;
    };
  };
  unclaimed_business?: {
    added_by: string | null;
    added_by_profile?: {
      full_name: string;
      email: string;
    };
  };
  added_by_profile?: {
    full_name: string;
    nickname: string | null;
    email: string;
  } | null;
  source: 'imported' | 'user_added' | 'claimed' | 'self_registered';
  approval_status?: 'pending' | 'approved' | 'rejected' | null;
  points_awarded?: boolean;
  added_by?: string | null;
  added_by_family_member_id?: string | null;
}

interface BusinessesSectionProps {
  onReload: () => Promise<void>;
}

type TabType = 'all' | 'imported' | 'user_added' | 'claimed' | 'self_registered';

interface Category {
  id: string;
  name: string;
}

export function BusinessesSection({ onReload }: BusinessesSectionProps) {
  const { showToast } = useToast();
  const [activeTab, setActiveTab] = useState<TabType>('all');
  const [businesses, setBusinesses] = useState<BusinessLocation[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedBusiness, setSelectedBusiness] = useState<BusinessLocation | null>(null);
  const [editingBusiness, setEditingBusiness] = useState<BusinessLocation | null>(null);
  const [allLocations, setAllLocations] = useState<BusinessLocation[]>([]);
  const [allCategories, setAllCategories] = useState<Category[]>([]);
  const [pendingUserAddedCount, setPendingUserAddedCount] = useState(0);

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const [totalCount, setTotalCount] = useState(0);
  const itemsPerPage = 50;

  // Advanced filters — province is display name, provinceCode is the 2-letter code stored in DB
  const [filters, setFilters] = useState({
    name: '',
    address: '',
    postalCode: '',
    city: '',
    province: '',
    provinceCode: '',
    region: '',
    category: '',
    verified: 'all' as 'all' | 'verified' | 'unverified' | 'rejected'
  });

  const loadBusinessesRef = useRef<(page?: number) => Promise<void>>(async () => {});

  useEffect(() => {
    supabase.from('business_categories').select('id, name').order('name').then(({ data }) => {
      if (data) setAllCategories(data);
    });
    supabase
      .from('unclaimed_business_locations')
      .select('id', { count: 'exact', head: true })
      .not('added_by', 'is', null)
      .eq('approval_status', 'pending')
      .then(({ count }) => setPendingUserAddedCount(count || 0));
  }, []);

  const loadBusinesses = async (page = currentPage) => {
    setLoading(true);
    try {
      let allBusinesses: BusinessLocation[] = [];
      let count = 0;

      const from = (page - 1) * itemsPerPage;
      const to = from + itemsPerPage - 1;

      if (activeTab === 'all') {
        // Build unclaimed query with filters — exclude already claimed ones
        let unclaimedQ = supabase
          .from('unclaimed_business_locations')
          .select(`*, category:category_id(name)`, { count: 'exact' })
          .eq('is_claimed', false)
          .order('created_at', { ascending: false });
        if (filters.name) unclaimedQ = unclaimedQ.ilike('name', `%${filters.name}%`);
        if (filters.address) unclaimedQ = unclaimedQ.ilike('street', `%${filters.address}%`);
        if (filters.postalCode) unclaimedQ = unclaimedQ.ilike('postal_code', `%${filters.postalCode}%`);
        if (filters.city) unclaimedQ = unclaimedQ.ilike('city', `%${filters.city}%`);
        if (filters.provinceCode) unclaimedQ = unclaimedQ.eq('province', filters.provinceCode);
        if (filters.region) unclaimedQ = unclaimedQ.eq('region', filters.region);

        // Build registered query with filters
        let registeredQ = supabase
          .from('registered_businesses')
          .select(`*, category:category_id(name), owner:owner_id(full_name, email), locations:registered_business_locations(*)`, { count: 'exact' })
          .order('created_at', { ascending: false });
        if (filters.name) registeredQ = registeredQ.ilike('name', `%${filters.name}%`);

        const [unclaimedResult, claimedResult] = await Promise.all([
          unclaimedQ.range(from, to),
          registeredQ.range(from, to)
        ]);

        const unclaimedBusinesses = (unclaimedResult.data || []).map(business => ({
          id: business.id,
          business_id: null,
          unclaimed_business_id: business.id,
          name: business.name,
          address: business.street || '',
          city: business.city,
          province: business.province,
          region: business.region,
          postal_code: business.postal_code,
          phone: business.phone,
          email: business.email,
          website: business.website,
          vat_number: null,
          is_verified: business.verification_badge === 'verified',
          is_main: false,
          created_at: business.created_at,
          description: business.description,
          business_hours: business.business_hours,
          services: business.services,
          services_description: business.services_description,
          category: business.category,
          source: (business.added_by ? 'user_added' : 'imported') as 'user_added' | 'imported',
          approval_status: business.approval_status,
          points_awarded: business.points_awarded,
          added_by: business.added_by,
          added_by_family_member_id: business.added_by_family_member_id,
        }));

        const registeredBusinesses = (claimedResult.data || []).flatMap(business => {
          const primaryLocation = business.locations?.find((l: any) => l.is_primary) || business.locations?.[0];

          // Use business name as the main name for self-registered businesses
          const displayName = business.source_type === 'direct_registration' ? business.name : (primaryLocation?.name || business.name);

          const displayLocation = primaryLocation || {
            name: business.name,
            street: business.billing_street || '',
            city: business.billing_city || '',
            province: business.billing_province || '',
            region: '',
            postal_code: business.billing_postal_code,
            phone: null,
            email: null,
            website: business.website,
            description: business.description,
            business_hours: null,
            services: null,
            services_description: null,
            is_primary: true
          };

          return [{
            id: primaryLocation?.id || business.id,
            business_id: business.id,
            unclaimed_business_id: null,
            name: displayName,
            business_name: business.name,
            address: displayLocation.street || '',
            city: displayLocation.city || '',
            province: displayLocation.province || '',
            region: displayLocation.region || '',
            postal_code: displayLocation.postal_code,
            phone: displayLocation.phone,
            email: displayLocation.email,
            website: displayLocation.website || business.website,
            vat_number: business.vat_number,
            is_verified: business.verified,
            is_main: displayLocation.is_primary || true,
            created_at: business.created_at,
            description: displayLocation.description,
            business_hours: displayLocation.business_hours,
            services: displayLocation.services,
            services_description: displayLocation.services_description,
            category: business.category,
            business: business.owner ? {
              owner_id: business.owner_id,
              owner: business.owner
            } : undefined,
            source: (business.source_type === 'claimed_imported' || business.source_type === 'claimed_user_added') ? 'claimed' as const : 'self_registered' as const
          }];
        });

        allBusinesses = [...unclaimedBusinesses, ...registeredBusinesses]
          .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

        count = (unclaimedResult.count || 0) + (claimedResult.count || 0);

      } else if (activeTab === 'imported' || activeTab === 'user_added') {
        // Build query for unclaimed_business_locations
        let query = supabase
          .from('unclaimed_business_locations')
          .select(`
            *,
            category:category_id(name),
            added_by_profile:added_by(full_name, nickname, email)
          `, { count: 'exact' });

        // Filter by source (imported vs user_added) — exclude claimed ones
        if (activeTab === 'imported') {
          query = query.is('added_by', null).eq('is_claimed', false);
        } else {
          query = query.not('added_by', 'is', null).eq('is_claimed', false);
        }

        // Apply advanced filters
        if (filters.name) query = query.ilike('name', `%${filters.name}%`);
        if (filters.address) query = query.ilike('street', `%${filters.address}%`);
        if (filters.postalCode) query = query.ilike('postal_code', `%${filters.postalCode}%`);
        if (filters.city) query = query.ilike('city', `%${filters.city}%`);
        if (filters.provinceCode) query = query.eq('province', filters.provinceCode);
        if (filters.region) query = query.eq('region', filters.region);
        if (filters.category) query = query.eq('category_id', filters.category);
        if (filters.verified === 'verified') {
          query = query.eq('approval_status', 'approved');
        } else if (filters.verified === 'unverified') {
          query = query.eq('approval_status', 'pending');
        } else if (filters.verified === 'rejected') {
          query = query.eq('approval_status', 'rejected');
        }

        const { data: unclaimedData, error: unclaimedError, count: totalCount } = await query
          .order('created_at', { ascending: false })
          .range(from, to);

        if (unclaimedError) throw unclaimedError;

        count = totalCount || 0;
        allBusinesses = (unclaimedData || []).map(business => ({
          id: business.id,
          business_id: null,
          unclaimed_business_id: business.id,
          name: business.name,
          address: business.street || '',
          city: business.city,
          province: business.province,
          region: business.region,
          postal_code: business.postal_code,
          phone: business.phone,
          email: business.email,
          website: business.website,
          vat_number: null,
          is_verified: business.verification_badge === 'verified',
          is_main: false,
          created_at: business.created_at,
          description: business.description,
          business_hours: business.business_hours,
          services: business.services,
          services_description: business.services_description,
          category: business.category,
          source: activeTab,
          approval_status: business.approval_status,
          points_awarded: business.points_awarded,
          added_by: business.added_by,
          added_by_family_member_id: business.added_by_family_member_id,
          added_by_profile: business.added_by_profile ?? null,
        }));

      } else if (activeTab === 'claimed' || activeTab === 'self_registered') {
        // Build query for registered_businesses
        let query = supabase
          .from('registered_businesses')
          .select(`
            *,
            category:category_id(name),
            owner:owner_id(full_name, email),
            locations:registered_business_locations(*)
          `, { count: 'exact' });

        // Filter by source_type
        if (activeTab === 'claimed') {
          query = query.or('source_type.eq.claimed_imported,source_type.eq.claimed_user_added');
        } else {
          query = query.eq('source_type', 'direct_registration');
        }

        // Apply verified filter
        if (filters.verified === 'verified') {
          query = query.eq('verified', true);
        } else if (filters.verified === 'unverified') {
          query = query.eq('verified', false);
        }

        if (filters.name) query = query.ilike('name', `%${filters.name}%`);

        const { data: claimedData, error: claimedError, count: totalCount } = await query
          .order('created_at', { ascending: false })
          .range(from, to);

        if (claimedError) throw claimedError;

        count = totalCount || 0;
        // Flatten businesses with their locations, applying location filters client-side
        allBusinesses = (claimedData || []).flatMap(business => {
          const primaryLocation = business.locations?.find((l: any) => l.is_primary) || business.locations?.[0];
          const displayName = activeTab === 'self_registered' ? business.name : (primaryLocation?.name || business.name);
          const displayLocation = primaryLocation || {
            name: business.name, street: business.billing_street || '',
            city: business.billing_city || '', province: business.billing_province || '',
            region: '', postal_code: business.billing_postal_code,
            phone: null, email: null, website: business.website,
            description: business.description, business_hours: null,
            services: null, services_description: null, is_primary: true
          };

          const city = displayLocation.city || '';
          const province = displayLocation.province || '';
          const region = displayLocation.region || '';

          // Apply location filters client-side
          const street = displayLocation.street || '';
          const postalCode = displayLocation.postal_code || '';
          if (filters.address && !street.toLowerCase().includes(filters.address.toLowerCase())) return [];
          if (filters.postalCode && !postalCode.includes(filters.postalCode)) return [];
          if (filters.city && !city.toLowerCase().includes(filters.city.toLowerCase())) return [];
          if (filters.provinceCode && province.toUpperCase() !== filters.provinceCode.toUpperCase()) return [];
          if (filters.region && region !== filters.region) return [];

          return [{
            id: primaryLocation?.id || business.id,
            business_id: business.id,
            unclaimed_business_id: null,
            name: displayName,
            business_name: business.name,
            address: displayLocation.street || '',
            city, province, region,
            postal_code: displayLocation.postal_code,
            phone: displayLocation.phone,
            email: displayLocation.email,
            website: displayLocation.website || business.website,
            vat_number: business.vat_number,
            is_verified: business.verified,
            is_main: displayLocation.is_primary || true,
            created_at: business.created_at,
            description: displayLocation.description,
            business_hours: displayLocation.business_hours,
            services: displayLocation.services,
            services_description: displayLocation.services_description,
            category: business.category,
            business: business.owner ? { owner_id: business.owner_id, owner: business.owner } : undefined,
            source: (business.source_type === 'claimed_imported' || business.source_type === 'claimed_user_added') ? 'claimed' as const : 'self_registered' as const
          }];
        });
      }

      setBusinesses(allBusinesses);
      setTotalCount(count);
    } catch (error) {
      console.error('Error loading businesses:', error);
    } finally {
      setLoading(false);
    }
  };

  // Keep ref always pointing to latest loadBusinesses (avoids stale closure in effects)
  loadBusinessesRef.current = loadBusinesses;

  // Single effect — always calls via ref so it gets the latest filters/state
  const prevFiltersKey = useRef('');
  useEffect(() => {
    const key = `${activeTab}|${JSON.stringify(filters)}`;
    const filtersChanged = prevFiltersKey.current !== key;
    prevFiltersKey.current = key;

    if (filtersChanged) {
      if (currentPage !== 1) {
        setCurrentPage(1); // triggers this effect again with page=1
      } else {
        loadBusinessesRef.current(1);
      }
    } else {
      loadBusinessesRef.current(currentPage);
    }
  }, [activeTab, filters, currentPage]); // eslint-disable-line react-hooks/exhaustive-deps

  const refreshPendingCount = async () => {
    const { count } = await supabase
      .from('unclaimed_business_locations')
      .select('id', { count: 'exact', head: true })
      .not('added_by', 'is', null)
      .eq('approval_status', 'pending');
    setPendingUserAddedCount(count || 0);
  };

  const handleApproveUserBusiness = async (business: BusinessLocation) => {
    if (!confirm(`Approva l'attività "${business.name}"?\n\nL'attivita' sara' visibile nella ricerca e l'utente ricevera' i punti.`)) return;

    try {
      // The DB trigger handles points assignment, activity_log, and notifications automatically
      const { error } = await supabase
        .from('unclaimed_business_locations')
        .update({
          verification_badge: 'verified',
          approval_status: 'approved',
        })
        .eq('id', business.id);

      if (error) throw error;

      showToast(`Attivita' approvata!`, 'info');
      await Promise.all([loadBusinesses(), refreshPendingCount()]);
    } catch (error: any) {
      console.error('Error approving business:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleRejectUserBusiness = async (business: BusinessLocation) => {
    const reason = prompt(`Motivo del rifiuto per "${business.name}" (opzionale):`);
    if (reason === null) return;

    try {
      const { error } = await supabase
        .from('unclaimed_business_locations')
        .update({
          verification_badge: null,
          approval_status: 'rejected',
          rejection_reason: reason || null,
        })
        .eq('id', business.id);

      if (error) throw error;

      if (business.added_by) {
        const rejectMsg = reason
          ? `La tua attivita\' "${business.name}" e\' stata rifiutata dallo staff. Motivazione: ${reason}`
          : `La tua attivita\' "${business.name}" e\' stata rifiutata dallo staff.`;
        await supabase.rpc('send_notification', {
          target_user_id: business.added_by,
          notif_type: 'business_rejected',
          notif_title: 'Attivita\' non approvata',
          notif_message: rejectMsg,
          notif_data: { business_id: business.id, reason: reason || null },
          target_family_member_id: business.added_by_family_member_id || null,
        });
      }

      showToast(`Attivita' rifiutata.`, 'info');
      await Promise.all([loadBusinesses(), refreshPendingCount()]);
    } catch (error: any) {
      console.error('Error rejecting business:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleToggleVerification = async (businessId: string, currentStatus: boolean) => {
    const action = currentStatus
      ? 'nascondere dalla ricerca pubblica'
      : 'approvare e rendere visibile nella ricerca';

    if (!confirm(`Sei sicuro di voler ${action} questa attività?\n\n${currentStatus ? 'L\'attività non sarà più visibile nelle ricerche pubbliche.' : 'L\'attività sarà visibile a tutti gli utenti nella ricerca.'}`)) return;

    try {
      const tableName = activeTab === 'imported' || activeTab === 'user_added'
        ? 'unclaimed_business_locations'
        : 'registered_businesses';

      let updateData: any;
      if (tableName === 'unclaimed_business_locations') {
        updateData = { verification_badge: !currentStatus ? 'verified' : null };
      } else {
        updateData = { verified: !currentStatus };
      }

      const { error } = await supabase
        .from(tableName)
        .update(updateData)
        .eq('id', businessId);

      if (error) throw error;

      showToast(`Attività ${!currentStatus ? 'approvata e ora visibile' : 'nascosta dalla ricerca'}!`, 'info');
      await loadBusinesses();
    } catch (error: any) {
      console.error('Error updating verification:', error);
      showToast(`Errore nell'aggiornamento: ${error.message}`, 'error');
    }
  };

  const handleSaveEdit = async () => {
    if (!editingBusiness) return;

    try {
      const tableName = activeTab === 'imported' || activeTab === 'user_added'
        ? 'unclaimed_business_locations'
        : 'registered_businesses';

      let updateData: any = {
        city: editingBusiness.city,
        province: editingBusiness.province,
        region: editingBusiness.region,
        postal_code: editingBusiness.postal_code,
        phone: editingBusiness.phone,
        email: editingBusiness.email,
        website: editingBusiness.website,
        description: editingBusiness.description,
        business_hours: editingBusiness.business_hours,
        services: editingBusiness.services,
        services_description: editingBusiness.services_description,
      };

      if (tableName === 'unclaimed_business_locations') {
        updateData.name = editingBusiness.name;
        updateData.street = editingBusiness.address;
        updateData.category_id = (editingBusiness as any).editing_category_id || null;
      } else {
        updateData.name = editingBusiness.name;
        updateData.street = editingBusiness.address;
        updateData.vat_number = editingBusiness.vat_number;
        updateData.category_id = (editingBusiness as any).editing_category_id || null;
      }

      const { error } = await supabase
        .from(tableName)
        .update(updateData)
        .eq('id', editingBusiness.id);

      if (error) throw error;

      showToast('Attività aggiornata con successo', 'success');
      setEditingBusiness(null);
      await loadBusinesses();
    } catch (error: any) {
      console.error('Error updating business:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleDelete = async (businessId: string) => {
    if (!confirm('Sei sicuro di voler eliminare questa attività? Questa azione non può essere annullata.')) return;

    try {
      const tableName = activeTab === 'imported' || activeTab === 'user_added'
        ? 'unclaimed_business_locations'
        : 'registered_businesses';

      const { error } = await supabase
        .from(tableName)
        .delete()
        .eq('id', businessId);

      if (error) throw error;

      showToast('Attività eliminata con successo', 'success');
      await loadBusinesses();
    } catch (error: any) {
      console.error('Error deleting business:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const loadAllLocations = async (business: BusinessLocation) => {
    if (!business.business_id) {
      setAllLocations([business]);
      return;
    }

    try {
      // For claimed, self-registered, or "all" tab with business_id, load from registered_business_locations
      if (business.business_id && (activeTab === 'claimed' || activeTab === 'self_registered' || activeTab === 'all')) {
        const { data: businessData, error: businessError } = await supabase
          .from('registered_businesses')
          .select(`
            *,
            category:category_id(name),
            owner:owner_id(full_name, email),
            locations:registered_business_locations(*)
          `)
          .eq('id', business.business_id)
          .maybeSingle();

        if (businessError) throw businessError;

        if (!businessData) {
          setAllLocations([business]);
          return;
        }

        const locations = (businessData.locations || []).map((loc: any) => ({
          id: loc.id,
          business_id: businessData.id,
          unclaimed_business_id: null,
          name: loc.name || businessData.name,
          business_name: businessData.name,
          address: loc.street || '',
          city: loc.city,
          province: loc.province,
          region: loc.region,
          postal_code: loc.postal_code,
          phone: loc.phone,
          email: loc.email,
          website: loc.website || businessData.website,
          vat_number: businessData.vat_number,
          is_verified: businessData.verified,
          is_main: loc.is_primary || false,
          created_at: businessData.created_at,
          description: loc.description,
          business_hours: loc.business_hours,
          services: loc.services,
          services_description: loc.services_description,
          category: businessData.category,
          business: businessData.owner ? {
            owner_id: businessData.owner_id,
            owner: businessData.owner
          } : undefined,
          source: (business.source || ((businessData.source_type === 'claimed_imported' || businessData.source_type === 'claimed_user_added') ? 'claimed' : 'self_registered')) as 'claimed' | 'self_registered'
        }));

        setAllLocations(locations.length > 0 ? locations : [business]);
      } else {
        // For old system (if needed)
        const { data, error } = await supabase
          .from('business_locations')
          .select(`
            *,
            category:business_category_id(name),
            business:business_id(
              owner_id,
              owner:owner_id(full_name, email)
            )
          `)
          .eq('business_id', business.business_id)
          .order('is_main', { ascending: false })
          .order('created_at', { ascending: true });

        if (error) throw error;

        const locations = (data || []).map(loc => ({
          id: loc.id,
          business_id: loc.business_id,
          unclaimed_business_id: null,
          name: loc.name,
          address: loc.address,
          city: loc.city,
          province: loc.province,
          region: loc.region,
          postal_code: loc.postal_code,
          phone: loc.phone,
          email: loc.email,
          website: loc.website,
          vat_number: loc.vat_number,
          is_verified: loc.is_verified,
          is_main: loc.is_main,
          created_at: loc.created_at,
          description: loc.description,
          business_hours: loc.business_hours,
          services: loc.services,
          services_description: loc.services_description,
          category: loc.category,
          business: loc.business,
          source: activeTab
        }));

        setAllLocations(locations);
      }
    } catch (error: any) {
      console.error('Error loading locations:', error);
      setAllLocations([business]);
    }
  };

  const totalPages = Math.ceil(totalCount / itemsPerPage);

  const tabs = [
    { id: 'all' as TabType, label: 'Tutte le Attività', icon: Building2, pendingBadge: null as number | null },
    { id: 'imported' as TabType, label: 'Importate', icon: Download, pendingBadge: null as number | null },
    { id: 'user_added' as TabType, label: 'Aggiunte da Utenti', icon: UserPlus, pendingBadge: pendingUserAddedCount > 0 ? pendingUserAddedCount : null },
    { id: 'claimed' as TabType, label: 'Rivendicate', icon: CheckCircle, pendingBadge: null as number | null },
    { id: 'self_registered' as TabType, label: 'Iscritte da Sole', icon: Briefcase, pendingBadge: null as number | null },
  ];

  return (
    <div className="space-y-6">
      {/* Tabs */}
      <div className="bg-white rounded-lg shadow">
        <div className="border-b border-gray-200">
          <nav className="flex -mb-px">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`relative flex items-center gap-2 px-6 py-4 text-sm font-medium border-b-2 transition-colors ${
                    activeTab === tab.id
                      ? 'border-blue-500 text-blue-600'
                      : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                  }`}
                >
                  <Icon className="w-5 h-5" />
                  {tab.label}
                  {tab.pendingBadge !== null && (
                    <span className="absolute -top-1 -right-1 min-w-[18px] h-[18px] flex items-center justify-center px-1 bg-red-600 text-white text-[10px] font-bold rounded-full">
                      {tab.pendingBadge}
                    </span>
                  )}
                  {activeTab === tab.id && tab.id !== 'user_added' && (
                    <span className="ml-2 px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded-full">
                      {totalCount.toLocaleString()}
                    </span>
                  )}
                  {activeTab === tab.id && tab.id === 'user_added' && (
                    <span className="ml-2 px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded-full">
                      {totalCount.toLocaleString()} totali
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Search Bar and Filters */}
        <div className="p-4 border-b border-gray-200 space-y-4">
          {/* Text search filters */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
              <input
                type="text"
                placeholder="Cerca per nome..."
                value={filters.name}
                onChange={(e) => setFilters({ ...filters, name: e.target.value })}
                className="w-full pl-9 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
              />
            </div>
            <div className="relative">
              <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
              <input
                type="text"
                placeholder="Cerca per indirizzo..."
                value={filters.address}
                onChange={(e) => setFilters({ ...filters, address: e.target.value })}
                className="w-full pl-9 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
              />
            </div>
            <div className="relative">
              <Hash className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
              <input
                type="text"
                placeholder="CAP..."
                value={filters.postalCode}
                onChange={(e) => setFilters({ ...filters, postalCode: e.target.value })}
                className="w-full pl-9 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
              />
            </div>
          </div>

          {/* Location + status filters */}
          <div className="space-y-3">
            <AdminLocationFilter
              value={{ region: filters.region, province: filters.province, provinceCode: filters.provinceCode, city: filters.city }}
              onChange={loc => setFilters({ ...filters, region: loc.region, province: loc.province, provinceCode: loc.provinceCode, city: loc.city })}
            />
            {(activeTab === 'imported' || activeTab === 'user_added') && (
              <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Categoria</label>
                  <select
                    value={filters.category}
                    onChange={(e) => setFilters({ ...filters, category: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                  >
                    <option value="">Tutte le categorie</option>
                    {allCategories.map(cat => (
                      <option key={cat.id} value={cat.id}>{cat.name}</option>
                    ))}
                  </select>
                </div>
                {activeTab === 'user_added' && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Stato Approvazione</label>
                    <select
                      value={filters.verified}
                      onChange={(e) => setFilters({ ...filters, verified: e.target.value as any })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                    >
                      <option value="all">Tutte</option>
                      <option value="unverified">In Attesa</option>
                      <option value="verified">Approvate</option>
                      <option value="rejected">Rifiutate</option>
                    </select>
                  </div>
                )}
              </div>
            )}
          </div>

          {/* Stats and Reset */}
          <div className="flex items-center justify-between text-sm">
            <div className="text-gray-600">
              Visualizzazione {((currentPage - 1) * itemsPerPage) + 1}-{Math.min(currentPage * itemsPerPage, totalCount)} di {totalCount.toLocaleString()} attività
            </div>
            {(filters.name || filters.address || filters.postalCode || filters.city || filters.province || filters.region || filters.provinceCode || filters.category || filters.verified !== 'all') && (
              <button
                onClick={() => setFilters({ name: '', address: '', postalCode: '', city: '', province: '', provinceCode: '', region: '', category: '', verified: 'all' })}
                className="text-blue-600 hover:text-blue-700 font-medium"
              >
                Ripristina filtri
              </button>
            )}
          </div>
        </div>

        {/* Business List */}
        <div className="p-4">
          {loading ? (
            <div className="text-center py-8">
              <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
              <p className="mt-2 text-gray-600">Caricamento...</p>
            </div>
          ) : businesses.length === 0 ? (
            <div className="text-center py-8">
              <Building2 className="w-16 h-16 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">Nessuna attività trovata</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Attività
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Indirizzo
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Contatti
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Sedi
                    </th>
                    {activeTab === 'all' && (
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Fonte
                      </th>
                    )}
                    {(activeTab === 'user_added' || activeTab === 'claimed' || activeTab === 'self_registered') && (
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        {activeTab === 'self_registered' ? 'Proprietario' : 'Aggiunto da'}
                      </th>
                    )}
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Badge
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Azioni
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {businesses.map((business) => (
                    <tr key={business.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <Building2 className="w-5 h-5 text-gray-400 flex-shrink-0" />
                          <div>
                            <div className="text-sm font-medium text-gray-900">{business.name}</div>
                            {business.category?.name && (
                              <div className="text-xs text-blue-600 font-medium mt-0.5">{business.category.name}</div>
                            )}
                            {business.vat_number && (
                              <div className="text-xs text-gray-500">P.IVA: {business.vat_number}</div>
                            )}
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-start gap-2">
                          <MapPin className="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5" />
                          <div className="text-sm text-gray-900">
                            <div>{business.address}</div>
                            <div className="text-gray-500">
                              {business.city}, {business.province} {business.postal_code}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="space-y-1">
                          {business.phone && (
                            <div className="flex items-center gap-2 text-sm text-gray-900">
                              <Phone className="w-4 h-4 text-gray-400" />
                              {business.phone}
                            </div>
                          )}
                          {business.email && (
                            <div className="flex items-center gap-2 text-sm text-gray-900">
                              <Mail className="w-4 h-4 text-gray-400" />
                              {business.email}
                            </div>
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <MapPin className="w-4 h-4 text-gray-400" />
                          <span className="text-sm font-medium text-gray-900">
                            {business.business_id ? (
                              <button
                                onClick={() => {
                                  setSelectedBusiness(business);
                                  loadAllLocations(business);
                                }}
                                className="text-blue-600 hover:text-blue-800 underline"
                              >
                                Vedi sedi
                              </button>
                            ) : (
                              '1 sede'
                            )}
                          </span>
                        </div>
                      </td>
                      {activeTab === 'all' && (
                        <td className="px-6 py-4">
                          <span className={`px-2 py-1 text-xs rounded-full ${
                            business.source === 'imported' ? 'bg-purple-100 text-purple-800' :
                            business.source === 'user_added' ? 'bg-blue-100 text-blue-800' :
                            business.source === 'claimed' ? 'bg-green-100 text-green-800' :
                            'bg-orange-100 text-orange-800'
                          }`}>
                            {business.source === 'imported' ? 'Importata' :
                             business.source === 'user_added' ? 'Aggiunta da Utente' :
                             business.source === 'claimed' ? 'Rivendicata' :
                             'Iscritta da Sola'}
                          </span>
                        </td>
                      )}
                      {(activeTab === 'user_added' || activeTab === 'claimed' || activeTab === 'self_registered') && (
                        <td className="px-6 py-4">
                          {activeTab === 'self_registered' && business.business?.owner ? (
                            <div>
                              <div className="text-sm font-medium text-gray-900">
                                {business.business.owner.full_name}
                              </div>
                              <div className="text-xs text-gray-500">
                                {business.business.owner.email}
                              </div>
                            </div>
                          ) : activeTab === 'claimed' && business.business?.owner ? (
                            <div>
                              <div className="text-sm font-medium text-gray-900">
                                {business.business.owner.full_name}
                              </div>
                              <div className="text-xs text-gray-500">
                                {business.business.owner.email}
                              </div>
                            </div>
                          ) : activeTab === 'user_added' && business.added_by_profile ? (
                            <div>
                              {business.added_by_profile.nickname && (
                                <div className="text-xs font-bold text-blue-600 mb-0.5">@{business.added_by_profile.nickname}</div>
                              )}
                              <div className="text-sm font-medium text-gray-900">
                                {business.added_by_profile.full_name}
                              </div>
                              <div className="text-xs text-gray-500">
                                {business.added_by_profile.email}
                              </div>
                            </div>
                          ) : business.unclaimed_business?.added_by_profile ? (
                            <div>
                              <div className="text-sm font-medium text-gray-900">
                                {business.unclaimed_business.added_by_profile.full_name}
                              </div>
                              <div className="text-xs text-gray-500">
                                {business.unclaimed_business.added_by_profile.email}
                              </div>
                            </div>
                          ) : (
                            <span className="text-sm text-gray-500">N/A</span>
                          )}
                        </td>
                      )}
                      <td className="px-6 py-4">
                        {business.source === 'imported' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-800">
                            <Download className="w-3 h-3" />
                            Importata
                          </span>
                        ) : business.source === 'claimed' || business.source === 'self_registered' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                            <CheckCircle className="w-3 h-3" />
                            Verificata
                          </span>
                        ) : business.approval_status === 'approved' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                            <ShieldCheck className="w-3 h-3" />
                            Approvata
                          </span>
                        ) : business.approval_status === 'rejected' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-full bg-red-100 text-red-800">
                            <XCircle className="w-3 h-3" />
                            Rifiutata
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-700">
                            <Clock className="w-3 h-3" />
                            In Attesa
                          </span>
                        )}
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <button
                            onClick={() => {
                              setSelectedBusiness(business);
                              loadAllLocations(business);
                            }}
                            className="text-blue-600 hover:text-blue-800 p-1"
                            title="Visualizza dettagli"
                          >
                            <Search className="w-4 h-4" />
                          </button>
                          <button
                            onClick={() => setEditingBusiness({ ...business, ['editing_category_id' as any]: allCategories.find(c => c.name === business.category?.name)?.id ?? '' } as any)}
                            className="text-gray-600 hover:text-gray-800 p-1"
                            title="Modifica"
                          >
                            <Edit2 className="w-4 h-4" />
                          </button>
                          {/* Approval buttons for user-added businesses */}
                          {activeTab === 'user_added' && (
                            <>
                              {business.approval_status === 'pending' || !business.approval_status ? (
                                <>
                                  <button
                                    onClick={() => handleApproveUserBusiness(business)}
                                    className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium rounded-lg transition-colors bg-green-100 text-green-700 hover:bg-green-200"
                                    title="Approva attivita' e assegna punti"
                                  >
                                    <ShieldCheck className="w-3.5 h-3.5" />
                                    Approva
                                  </button>
                                  <button
                                    onClick={() => handleRejectUserBusiness(business)}
                                    className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium rounded-lg transition-colors bg-red-100 text-red-700 hover:bg-red-200"
                                    title="Rifiuta attivita'"
                                  >
                                    <XCircle className="w-3.5 h-3.5" />
                                    Rifiuta
                                  </button>
                                </>
                              ) : business.approval_status === 'approved' ? (
                                <span className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium rounded-lg bg-green-50 text-green-700 border border-green-200">
                                  <ShieldCheck className="w-3.5 h-3.5" />
                                  Approvata
                                </span>
                              ) : business.approval_status === 'rejected' ? (
                                <button
                                  onClick={() => handleApproveUserBusiness(business)}
                                  className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium rounded-lg transition-colors bg-blue-100 text-blue-700 hover:bg-blue-200"
                                  title="Approva comunque"
                                >
                                  <ShieldCheck className="w-3.5 h-3.5" />
                                  Approva
                                </button>
                              ) : null}
                            </>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          {/* Pagination */}
          {!loading && businesses.length > 0 && totalPages > 1 && (
            <div className="flex items-center justify-between mt-6 pt-6 border-t border-gray-200">
              <div className="text-sm text-gray-600">
                Pagina {currentPage} di {totalPages}
              </div>
              <div className="flex gap-2">
                <button
                  onClick={() => setCurrentPage(1)}
                  disabled={currentPage === 1}
                  className="px-3 py-2 text-sm border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Prima
                </button>
                <button
                  onClick={() => setCurrentPage(currentPage - 1)}
                  disabled={currentPage === 1}
                  className="px-3 py-2 text-sm border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Precedente
                </button>

                {/* Page numbers */}
                <div className="flex gap-1">
                  {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                    let pageNum;
                    if (totalPages <= 5) {
                      pageNum = i + 1;
                    } else if (currentPage <= 3) {
                      pageNum = i + 1;
                    } else if (currentPage >= totalPages - 2) {
                      pageNum = totalPages - 4 + i;
                    } else {
                      pageNum = currentPage - 2 + i;
                    }

                    return (
                      <button
                        key={pageNum}
                        onClick={() => setCurrentPage(pageNum)}
                        className={`px-3 py-2 text-sm border rounded-lg ${
                          currentPage === pageNum
                            ? 'bg-blue-600 text-white border-blue-600'
                            : 'border-gray-300 hover:bg-gray-50'
                        }`}
                      >
                        {pageNum}
                      </button>
                    );
                  })}
                </div>

                <button
                  onClick={() => setCurrentPage(currentPage + 1)}
                  disabled={currentPage === totalPages}
                  className="px-3 py-2 text-sm border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Successiva
                </button>
                <button
                  onClick={() => setCurrentPage(totalPages)}
                  disabled={currentPage === totalPages}
                  className="px-3 py-2 text-sm border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Ultima
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* View Modal */}
      {selectedBusiness && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b border-gray-200 flex justify-between items-center sticky top-0 bg-white z-10">
              <div>
                <h3 className="text-xl font-bold text-gray-900">Dettagli Attività</h3>
                {allLocations.length > 1 && (
                  <p className="text-sm text-gray-600 mt-1">{allLocations.length} sedi totali</p>
                )}
              </div>
              <button
                onClick={() => {
                  setSelectedBusiness(null);
                  setAllLocations([]);
                }}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="p-6 space-y-6">
              {allLocations.length > 1 ? (
                <>
                  {/* Business Name */}
                  {allLocations[0]?.business_name && (
                    <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                      <h4 className="text-sm font-semibold text-gray-900 mb-2">Ragione Sociale</h4>
                      <p className="text-lg font-bold text-gray-900">{allLocations[0].business_name}</p>
                      {allLocations[0]?.vat_number && (
                        <p className="text-sm text-gray-600 mt-1">P.IVA: {allLocations[0].vat_number}</p>
                      )}
                    </div>
                  )}

                  {/* Business Owner Info */}
                  {allLocations[0]?.business?.owner && (
                    <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                      <h4 className="text-sm font-semibold text-gray-900 mb-2">Informazioni Proprietario</h4>
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-xs font-medium text-gray-600 mb-1">Nome</label>
                          <p className="text-sm text-gray-900">{allLocations[0].business.owner.full_name}</p>
                        </div>
                        <div>
                          <label className="block text-xs font-medium text-gray-600 mb-1">Email</label>
                          <p className="text-sm text-gray-900">{allLocations[0].business.owner.email}</p>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Multiple locations */}
                  {allLocations.map((location, index) => (
                  <div key={location.id} className="border border-gray-200 rounded-lg p-6 space-y-4">
                    <div className="flex items-center justify-between border-b border-gray-200 pb-3">
                      <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                        <MapPin className="w-5 h-5 text-blue-600" />
                        Sede {index + 1}
                        {location.is_main && (
                          <span className="ml-2 px-2 py-1 text-xs bg-blue-100 text-blue-800 rounded-full">
                            Principale
                          </span>
                        )}
                      </h4>
                      {location.is_verified && (
                        <CheckCircle className="w-5 h-5 text-green-600" />
                      )}
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Nome</label>
                      <p className="text-gray-900">{location.name}</p>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Indirizzo</label>
                      <p className="text-gray-900">{location.address}</p>
                      <p className="text-gray-600">
                        {location.city}, {location.province} {location.postal_code}
                      </p>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Telefono</label>
                        <p className="text-gray-900">{location.phone || 'N/A'}</p>
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                        <p className="text-gray-900">{location.email || 'N/A'}</p>
                      </div>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Sito Web</label>
                        <p className="text-gray-900">{location.website || 'N/A'}</p>
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">P.IVA</label>
                        <p className="text-gray-900">{location.vat_number || 'N/A'}</p>
                      </div>
                    </div>
                    {location.category && (
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Categoria</label>
                        <p className="text-gray-900">{location.category.name}</p>
                      </div>
                    )}
                    {location.description && (
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Descrizione</label>
                        <p className="text-gray-900 whitespace-pre-wrap">{location.description}</p>
                      </div>
                    )}
                    {location.business_hours && (
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-3 flex items-center gap-2">
                          <Clock className="w-4 h-4" />
                          Orari di Apertura
                        </label>
                        <div className="bg-gray-50 rounded-lg p-4">
                          {formatBusinessHours(location.business_hours)}
                        </div>
                      </div>
                    )}
                    {location.services && (
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Servizi Offerti</label>
                        <p className="text-gray-900 whitespace-pre-wrap">{location.services}</p>
                      </div>
                    )}
                  </div>
                  ))}
                </>
              ) : (
                // Single location view
                <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Nome</label>
                <p className="text-gray-900">{selectedBusiness.name}</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Indirizzo</label>
                <p className="text-gray-900">{selectedBusiness.address}</p>
                <p className="text-gray-600">
                  {selectedBusiness.city}, {selectedBusiness.province} {selectedBusiness.postal_code}
                </p>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Telefono</label>
                  <p className="text-gray-900">{selectedBusiness.phone || 'N/A'}</p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                  <p className="text-gray-900">{selectedBusiness.email || 'N/A'}</p>
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Sito Web</label>
                <p className="text-gray-900">{selectedBusiness.website || 'N/A'}</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">P.IVA</label>
                <p className="text-gray-900">{selectedBusiness.vat_number || 'N/A'}</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Categoria</label>
                <p className="text-gray-900">{selectedBusiness.category?.name || 'N/A'}</p>
              </div>
              {selectedBusiness.description && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Descrizione</label>
                  <p className="text-gray-900 whitespace-pre-wrap">{selectedBusiness.description}</p>
                </div>
              )}
              {selectedBusiness.services_description && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Servizi Disponibili</label>
                  <p className="text-gray-900 whitespace-pre-wrap">{selectedBusiness.services_description}</p>
                </div>
              )}
              {selectedBusiness.business_hours && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-3 flex items-center gap-2">
                    <Clock className="w-4 h-4" />
                    Orari di Apertura
                  </label>
                  <div className="bg-gray-50 rounded-lg p-4">
                    {formatBusinessHours(selectedBusiness.business_hours)}
                  </div>
                </div>
              )}
              {selectedBusiness.services && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Servizi Offerti</label>
                  <p className="text-gray-900 whitespace-pre-wrap">{selectedBusiness.services}</p>
                </div>
              )}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Stato Attività</label>
                <span
                  className={`inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-full ${
                    activeTab === 'self_registered' || activeTab === 'claimed'
                      ? 'bg-green-100 text-green-800'
                      : activeTab === 'imported'
                      ? 'bg-purple-100 text-purple-800'
                      : selectedBusiness.is_verified
                      ? 'bg-blue-100 text-blue-800'
                      : 'bg-gray-100 text-gray-600'
                  }`}
                >
                  {activeTab === 'self_registered' || activeTab === 'claimed' ? (
                    <>
                      <CheckCircle className="w-3 h-3" />
                      Verificata (Iscritta)
                    </>
                  ) : activeTab === 'imported' ? (
                    <>
                      <Download className="w-3 h-3" />
                      Importata
                    </>
                  ) : selectedBusiness.is_verified ? (
                    <>
                      <ShieldCheck className="w-3 h-3" />
                      Approvata (Aggiunta da Utente)
                    </>
                  ) : (
                    <>
                      <Clock className="w-3 h-3" />
                      In Attesa di Approvazione
                    </>
                  )}
                </span>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Data Creazione</label>
                <p className="text-gray-900">{new Date(selectedBusiness.created_at).toLocaleString('it-IT')}</p>
              </div>
                </div>
              )}
            </div>
            <div className="p-6 border-t border-gray-200 flex justify-end gap-3">
              <button
                onClick={() => {
                  setSelectedBusiness(null);
                  setAllLocations([]);
                }}
                className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
              >
                Chiudi
              </button>
              {allLocations.length === 1 && (
                <button
                  onClick={() => {
                    setEditingBusiness({ ...selectedBusiness, ['editing_category_id' as any]: allCategories.find(c => c.name === selectedBusiness.category?.name)?.id ?? '' } as any);
                    setSelectedBusiness(null);
                    setAllLocations([]);
                  }}
                  className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                >
                  Modifica
                </button>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Edit Modal */}
      {editingBusiness && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b border-gray-200 flex justify-between items-center sticky top-0 bg-white z-10">
              <h3 className="text-xl font-bold text-gray-900">Modifica Attività</h3>
              <button
                onClick={() => setEditingBusiness(null)}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="p-6 space-y-6">
              {/* Informazioni Base */}
              <div className="space-y-4">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <Building2 className="w-5 h-5" />
                  Informazioni Base
                </h4>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Nome Attività</label>
                  <input
                    type="text"
                    value={editingBusiness.name}
                    onChange={(e) => setEditingBusiness({ ...editingBusiness, name: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    <span className="flex items-center gap-2">
                      <FileText className="w-4 h-4" />
                      Descrizione
                    </span>
                  </label>
                  <textarea
                    value={editingBusiness.description || ''}
                    onChange={(e) => setEditingBusiness({ ...editingBusiness, description: e.target.value })}
                    rows={4}
                    placeholder="Inserisci una descrizione dell'attività..."
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    <span className="flex items-center gap-2">
                      <Briefcase className="w-4 h-4" />
                      Servizi Disponibili
                    </span>
                  </label>
                  <textarea
                    value={editingBusiness.services_description || ''}
                    onChange={(e) => setEditingBusiness({ ...editingBusiness, services_description: e.target.value })}
                    rows={4}
                    placeholder="Descrivi i servizi offerti (es. WiFi gratuito, parcheggio, consegna a domicilio, ecc.)"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>

              {/* Indirizzo */}
              <div className="space-y-4">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <MapPin className="w-5 h-5" />
                  Indirizzo
                </h4>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Via e Numero</label>
                  <input
                    type="text"
                    value={editingBusiness.address}
                    onChange={(e) => setEditingBusiness({ ...editingBusiness, address: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div className="grid grid-cols-3 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Città</label>
                    <input
                      type="text"
                      value={editingBusiness.city}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, city: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Provincia</label>
                    <input
                      type="text"
                      value={editingBusiness.province}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, province: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">CAP</label>
                    <input
                      type="text"
                      value={editingBusiness.postal_code || ''}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, postal_code: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Regione</label>
                  <input
                    type="text"
                    value={editingBusiness.region}
                    onChange={(e) => setEditingBusiness({ ...editingBusiness, region: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>

              {/* Contatti */}
              <div className="space-y-4">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <Phone className="w-5 h-5" />
                  Contatti
                </h4>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Telefono</label>
                    <input
                      type="text"
                      value={editingBusiness.phone || ''}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, phone: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                    <input
                      type="email"
                      value={editingBusiness.email || ''}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, email: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Sito Web</label>
                    <input
                      type="url"
                      value={editingBusiness.website || ''}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, website: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">P.IVA</label>
                    <input
                      type="text"
                      value={editingBusiness.vat_number || ''}
                      onChange={(e) => setEditingBusiness({ ...editingBusiness, vat_number: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Categoria Attivita</label>
                  <select
                    value={(editingBusiness as any).editing_category_id ?? ''}
                    onChange={(e) => setEditingBusiness({ ...editingBusiness, ['editing_category_id' as any]: e.target.value } as any)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="">Nessuna categoria</option>
                    {allCategories.map((cat) => (
                      <option key={cat.id} value={cat.id}>{cat.name}</option>
                    ))}
                  </select>
                </div>
              </div>

              {/* Orari */}
              <div className="space-y-4">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <Clock className="w-5 h-5" />
                  Orari di Apertura
                </h4>
                <div className="space-y-2">
                  {['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'].map((day) => {
                    const dayLabels: Record<string, string> = {
                      monday: 'Lunedì',
                      tuesday: 'Martedì',
                      wednesday: 'Mercoledì',
                      thursday: 'Giovedì',
                      friday: 'Venerdì',
                      saturday: 'Sabato',
                      sunday: 'Domenica'
                    };
                    const hours = editingBusiness.business_hours?.[day] || { open: '', close: '', closed: false };
                    return (
                      <div key={day} className="grid grid-cols-12 gap-4 items-center">
                        <div className="col-span-3">
                          <label className="text-sm font-medium text-gray-700">{dayLabels[day]}</label>
                        </div>
                        <div className="col-span-3">
                          <input
                            type="time"
                            value={hours.open || ''}
                            disabled={hours.closed}
                            onChange={(e) => {
                              const newHours = { ...editingBusiness.business_hours };
                              if (!newHours[day]) newHours[day] = { open: '', close: '', closed: false };
                              newHours[day].open = e.target.value;
                              setEditingBusiness({ ...editingBusiness, business_hours: newHours });
                            }}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 text-sm disabled:bg-gray-100"
                          />
                        </div>
                        <div className="col-span-3">
                          <input
                            type="time"
                            value={hours.close || ''}
                            disabled={hours.closed}
                            onChange={(e) => {
                              const newHours = { ...editingBusiness.business_hours };
                              if (!newHours[day]) newHours[day] = { open: '', close: '', closed: false };
                              newHours[day].close = e.target.value;
                              setEditingBusiness({ ...editingBusiness, business_hours: newHours });
                            }}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 text-sm disabled:bg-gray-100"
                          />
                        </div>
                        <div className="col-span-3">
                          <label className="flex items-center gap-2">
                            <input
                              type="checkbox"
                              checked={hours.closed || false}
                              onChange={(e) => {
                                const newHours = { ...editingBusiness.business_hours };
                                if (!newHours[day]) newHours[day] = { open: '', close: '', closed: false };
                                newHours[day].closed = e.target.checked;
                                setEditingBusiness({ ...editingBusiness, business_hours: newHours });
                              }}
                              className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                            />
                            <span className="text-sm text-gray-700">Chiuso</span>
                          </label>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Servizi */}
              <div className="space-y-4">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <Briefcase className="w-5 h-5" />
                  Servizi Offerti
                </h4>
                <div>
                  <textarea
                    value={(editingBusiness.services || []).join(', ')}
                    onChange={(e) => {
                      const services = e.target.value.split(',').map(s => s.trim()).filter(s => s);
                      setEditingBusiness({ ...editingBusiness, services });
                    }}
                    rows={3}
                    placeholder="Inserisci i servizi separati da virgola (es: Consegna a domicilio, Wifi gratuito, Parcheggio)"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                  <p className="mt-1 text-sm text-gray-500">
                    Servizi attuali: {(editingBusiness.services || []).length > 0 ? (editingBusiness.services || []).join(', ') : 'Nessun servizio inserito'}
                  </p>
                </div>
              </div>
            </div>
            <div className="p-6 border-t border-gray-200 flex justify-between sticky bottom-0 bg-white">
              <button
                onClick={() => handleDelete(editingBusiness.id)}
                className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 font-medium"
              >
                Elimina Attività
              </button>
              <div className="flex gap-3">
                <button
                  onClick={() => setEditingBusiness(null)}
                  className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 font-medium"
                >
                  Annulla
                </button>
                <button
                  onClick={handleSaveEdit}
                  className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium"
                >
                  Salva Modifiche
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
