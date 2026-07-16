import { useState, useEffect } from 'react';
import { Users, Trash2, Eye, X as CloseIcon, FilterX, Save, FileEdit as Edit, CircleUser as UserCircle, MapPin, UserPlus, CreditCard, CheckCircle, Clock, AlertCircle, ChevronDown, Tag } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';
import { BusinessLocationPhotos } from '../business/BusinessLocationPhotos';

interface User {
  id: string;
  full_name: string;
  nickname?: string;
  email: string;
  user_type: string;
  subscription_status: string;
  subscription_type?: string;
  created_at: string;
  is_admin: boolean;
  phone?: string;
  fiscal_code?: string;
  billing_address?: string;
  billing_street?: string;
  billing_street_number?: string;
  billing_city?: string;
  billing_province?: string;
  billing_postal_code?: string;
  date_of_birth?: string;
  relationship?: string;
  company_name?: string;
  vat_number?: string;
  unique_code?: string;
  ateco_code?: string;
  pec_email?: string;
  website_url?: string;
  description?: string;
  category_id?: string;
  office_address?: string;
  office_street?: string;
  office_street_number?: string;
  office_city?: string;
  office_province?: string;
  office_postal_code?: string;
  // internal reference to registered_businesses id
  _rb_id?: string;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  billing_period: string;
  price: number;
  max_persons: number;
  status: string;
  start_date: string;
  end_date: string;
  trial_end_date: string | null;
  payment_method_added: boolean;
}

interface FamilyMember {
  id: string;
  first_name: string;
  last_name: string;
  nickname: string;
  date_of_birth: string;
  relationship: string;
  fiscal_code: string;
  customer_id?: string;
}

interface FamilyMemberRow {
  id: string;
  customer_id: string;
  owner_name: string;
  first_name: string;
  last_name: string;
  nickname: string;
  relationship: string;
}

interface BusinessLocation {
  id: string;
  name: string;
  internal_name?: string;
  address: string;
  street?: string;
  street_number?: string;
  city: string;
  province: string;
  postal_code?: string;
  phone?: string;
  email?: string;
  category_id?: string;
  vat_number?: string;
}

interface BusinessLocationRow {
  id: string;
  owner_id: string;
  name: string;
  internal_name?: string;
  city: string;
  province: string;
}

export default function UsersManagementSection() {
  const { showToast } = useToast();
  const [users, setUsers] = useState<User[]>([]);
  const [allFamilyRows, setAllFamilyRows] = useState<FamilyMemberRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [viewingUser, setViewingUser] = useState<User | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editedUser, setEditedUser] = useState<User | null>(null);
  const [saving, setSaving] = useState(false);
  const [subscriptionPlan, setSubscriptionPlan] = useState<SubscriptionPlan | null>(null);
  const [filterType, setFilterType] = useState<'all' | 'customer' | 'business' | 'admin'>('all');
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [businessLocations, setBusinessLocations] = useState<BusinessLocation[]>([]);
  const [editingMemberId, setEditingMemberId] = useState<string | null>(null);
  const [editedMember, setEditedMember] = useState<FamilyMember | null>(null);
  const [editingLocationId, setEditingLocationId] = useState<string | null>(null);
  const [editedLocation, setEditedLocation] = useState<BusinessLocation | null>(null);
  const [expandedFamilyUserId, setExpandedFamilyUserId] = useState<string | null>(null);
  const [allBusinessLocationRows, setAllBusinessLocationRows] = useState<BusinessLocationRow[]>([]);
  const [expandedBusinessLocationsUserId, setExpandedBusinessLocationsUserId] = useState<string | null>(null);
  const [showAddMemberForm, setShowAddMemberForm] = useState(false);
  const [newMember, setNewMember] = useState<Omit<FamilyMember, 'id'>>({ first_name: '', last_name: '', nickname: '', date_of_birth: '', relationship: '', fiscal_code: '' });
  const [categories, setCategories] = useState<{ id: string; name: string }[]>([]);

  useEffect(() => {
    loadUsers();
    supabase.from('business_categories').select('id, name').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, [filterType]);

  const loadUsers = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from('profiles')
        .select('*')
        .order('created_at', { ascending: false });

      if (filterType !== 'all') {
        if (filterType === 'admin') {
          query = query.eq('is_admin', true);
        } else {
          query = query.eq('user_type', filterType);
        }
      }

      const { data, error } = await query.limit(500);
      if (error) throw error;
      setUsers(data || []);

      // Carica tutti i membri famiglia per gli utenti customer visibili
      const customerIds = (data || [])
        .filter(u => u.user_type === 'customer')
        .map(u => u.id);

      if (customerIds.length > 0 && (filterType === 'all' || filterType === 'customer')) {
        const { data: fmData } = await supabase
          .from('customer_family_members')
          .select('id, customer_id, first_name, last_name, nickname, relationship')
          .in('customer_id', customerIds)
          .order('first_name');

        if (fmData && fmData.length > 0) {
          const rows: FamilyMemberRow[] = fmData.map(fm => {
            const owner = (data || []).find(u => u.id === fm.customer_id);
            return {
              id: fm.id,
              customer_id: fm.customer_id,
              owner_name: owner?.full_name || owner?.nickname || '—',
              first_name: fm.first_name,
              last_name: fm.last_name,
              nickname: fm.nickname || '',
              relationship: fm.relationship || '',
            };
          });
          setAllFamilyRows(rows);
        } else {
          setAllFamilyRows([]);
        }
      } else {
        setAllFamilyRows([]);
      }

      // Carica le sedi per gli utenti business visibili
      const businessUserIds = (data || [])
        .filter(u => u.user_type === 'business')
        .map(u => u.id);

      if (businessUserIds.length > 0 && (filterType === 'all' || filterType === 'business')) {
        const { data: bizData } = await supabase
          .from('registered_businesses')
          .select('id, owner_id')
          .in('owner_id', businessUserIds);

        if (bizData && bizData.length > 0) {
          const bizIds = bizData.map(b => b.id);
          const { data: locData } = await supabase
            .from('registered_business_locations')
            .select('id, business_id, name, internal_name, city, province')
            .in('business_id', bizIds)
            .order('name');

          if (locData && locData.length > 0) {
            const rows: BusinessLocationRow[] = locData.map(loc => {
              const biz = bizData.find(b => b.id === loc.business_id);
              return {
                id: loc.id,
                owner_id: biz?.owner_id || '',
                name: loc.name || loc.internal_name || 'Sede',
                internal_name: loc.internal_name,
                city: loc.city,
                province: loc.province,
              };
            });
            setAllBusinessLocationRows(rows);
          } else {
            setAllBusinessLocationRows([]);
          }
        } else {
          setAllBusinessLocationRows([]);
        }
      } else {
        setAllBusinessLocationRows([]);
      }
    } catch (error) {
      console.error('[UsersManagement] Error:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadSubscriptionPlan = async (userId: string) => {
    try {
      const { data, error } = await supabase
        .from('subscriptions')
        .select(`
          id, status, start_date, end_date, trial_end_date, payment_method_added,
          plan:subscription_plans!subscriptions_plan_id_fkey(id, name, billing_period, price, max_persons)
        `)
        .eq('customer_id', userId)
        .order('start_date', { ascending: false })
        .limit(1)
        .maybeSingle();

      if (error) throw error;

      if (data && data.plan) {
        setSubscriptionPlan({
          id: (data.plan as any).id,
          name: (data.plan as any).name,
          billing_period: (data.plan as any).billing_period,
          price: (data.plan as any).price,
          max_persons: (data.plan as any).max_persons,
          status: data.status,
          start_date: data.start_date,
          end_date: data.end_date,
          trial_end_date: data.trial_end_date,
          payment_method_added: data.payment_method_added,
        });
      } else {
        setSubscriptionPlan(null);
      }
    } catch (error) {
      console.error('[UsersManagement] Error loading subscription plan:', error);
      setSubscriptionPlan(null);
    }
  };

  const loadFamilyMembers = async (userId: string) => {
    try {
      const { data, error } = await supabase
        .from('customer_family_members')
        .select('id, first_name, last_name, nickname, date_of_birth, relationship, fiscal_code')
        .eq('customer_id', userId)
        .order('first_name');

      if (error) throw error;

      setFamilyMembers(data || []);
    } catch (error) {
      console.error('[UsersManagement] Error loading family members:', error);
      setFamilyMembers([]);
    }
  };

  const loadBusinessLocations = async (userId: string) => {
    try {
      // Prima troviamo il business collegato all'utente
      const { data: business, error: businessError } = await supabase
        .from('registered_businesses')
        .select('id')
        .eq('owner_id', userId)
        .maybeSingle();

      if (businessError) throw businessError;

      if (!business) {
        setBusinessLocations([]);
        return;
      }

      // Poi carichiamo le location collegate al business
      const { data, error } = await supabase
        .from('registered_business_locations')
        .select('id, name, internal_name, street, street_number, city, province, postal_code, phone, email, category_id, vat_number')
        .eq('business_id', business.id)
        .order('name');

      if (error) throw error;

      const locations = (data || []).map(loc => ({
        ...loc,
        address: `${loc.street || ''}${loc.street_number ? ' ' + loc.street_number : ''}`.trim(),
        street: loc.street || '',
        street_number: loc.street_number || '',
      }));

      setBusinessLocations(locations);
    } catch (error) {
      console.error('[UsersManagement] Error loading business locations:', error);
      setBusinessLocations([]);
    }
  };

  const handleViewUser = async (user: User) => {
    let enrichedUser = { ...user };

    // Carica i dati business dalla tabella registered_businesses
    if (user.user_type === 'business') {
      try {
        const { data: businessData, error } = await supabase
          .from('registered_businesses')
          .select('*')
          .eq('owner_id', user.id)
          .maybeSingle();

        if (!error && businessData) {
          enrichedUser = {
            ...enrichedUser,
            _rb_id: businessData.id,
            company_name: businessData.name || user.company_name,
            vat_number: businessData.vat_number || user.vat_number,
            unique_code: businessData.unique_code || user.unique_code,
            ateco_code: businessData.ateco_code || user.ateco_code,
            pec_email: businessData.pec_email || user.pec_email,
            phone: businessData.phone || user.phone,
            website_url: businessData.website_url || businessData.website || user.website_url,
            description: businessData.description || user.description,
            category_id: businessData.category_id || user.category_id,
            billing_street: businessData.billing_street || '',
            billing_street_number: businessData.billing_street_number || '',
            billing_address: businessData.billing_street
              ? `${businessData.billing_street}${businessData.billing_street_number ? ' ' + businessData.billing_street_number : ''}`
              : (user.billing_address || ''),
            billing_city: businessData.billing_city || user.billing_city,
            billing_province: businessData.billing_province || user.billing_province,
            billing_postal_code: businessData.billing_postal_code || user.billing_postal_code,
            office_street: businessData.office_street || '',
            office_street_number: businessData.office_street_number || '',
            office_address: businessData.office_street
              ? `${businessData.office_street}${businessData.office_street_number ? ' ' + businessData.office_street_number : ''}`
              : (user.office_address || ''),
            office_city: businessData.office_city || user.office_city,
            office_province: businessData.office_province || user.office_province,
            office_postal_code: businessData.office_postal_code || user.office_postal_code,
          };
        }
      } catch (error) {
        console.error('[UsersManagement] Error loading business data:', error);
      }
    }

    setViewingUser(enrichedUser);
    setEditedUser(enrichedUser);
    setIsEditing(false);
    setEditingMemberId(null);
    setEditedMember(null);
    setEditingLocationId(null);
    setEditedLocation(null);
    await loadSubscriptionPlan(user.id);

    // Carica membri della famiglia se è un customer
    if (user.user_type === 'customer') {
      await loadFamilyMembers(user.id);
    }

    // Carica sedi se è un business
    if (user.user_type === 'business') {
      await loadBusinessLocations(user.id);
    }
  };

  const handleEditMember = (member: FamilyMember) => {
    setEditingMemberId(member.id);
    setEditedMember({ ...member });
  };

  const handleCancelEditMember = () => {
    setEditingMemberId(null);
    setEditedMember(null);
  };

  const handleSaveMember = async () => {
    if (!editedMember || !viewingUser) return;

    try {
      const { error } = await supabase
        .from('customer_family_members')
        .update({
          first_name: editedMember.first_name,
          last_name: editedMember.last_name,
          nickname: editedMember.nickname,
          date_of_birth: editedMember.date_of_birth,
          relationship: editedMember.relationship,
          fiscal_code: editedMember.fiscal_code,
        })
        .eq('id', editedMember.id);

      if (error) throw error;

      showToast('Membro della famiglia aggiornato con successo!', 'success');
      setEditingMemberId(null);
      setEditedMember(null);
      await loadFamilyMembers(viewingUser.id);
    } catch (error) {
      console.error('[UsersManagement] Error updating family member:', error);
      showToast('Errore durante l\'aggiornamento del membro della famiglia', 'error');
    }
  };

  const handleAddMember = async () => {
    if (!viewingUser || !newMember.first_name.trim() || !newMember.last_name.trim()) return;
    try {
      const { error } = await supabase
        .from('customer_family_members')
        .insert({
          customer_id: viewingUser.id,
          first_name: newMember.first_name.trim(),
          last_name: newMember.last_name.trim(),
          nickname: newMember.nickname.trim() || null,
          date_of_birth: newMember.date_of_birth || null,
          relationship: newMember.relationship || null,
          fiscal_code: newMember.fiscal_code.trim() || null,
        });
      if (error) throw error;
      showToast('Membro della famiglia aggiunto con successo!', 'success');
      setShowAddMemberForm(false);
      setNewMember({ first_name: '', last_name: '', nickname: '', date_of_birth: '', relationship: '', fiscal_code: '' });
      await loadFamilyMembers(viewingUser.id);
    } catch (error) {
      console.error('[UsersManagement] Error adding family member:', error);
      showToast('Errore durante l\'aggiunta del membro della famiglia', 'error');
    }
  };

  const handleEditLocation = (location: BusinessLocation) => {
    setEditingLocationId(location.id);
    setEditedLocation({ ...location });
  };

  const handleCancelEditLocation = () => {
    setEditingLocationId(null);
    setEditedLocation(null);
  };

  const handleSaveLocation = async () => {
    if (!editedLocation || !viewingUser) return;

    try {
      const { error } = await supabase
        .from('registered_business_locations')
        .update({
          name: editedLocation.name,
          internal_name: editedLocation.internal_name || null,
          street: editedLocation.street || null,
          street_number: editedLocation.street_number || null,
          city: editedLocation.city,
          province: editedLocation.province,
          postal_code: editedLocation.postal_code || null,
          phone: editedLocation.phone || null,
          email: editedLocation.email || null,
          category_id: editedLocation.category_id || null,
          vat_number: editedLocation.vat_number || null,
        })
        .eq('id', editedLocation.id);

      if (error) throw error;

      showToast('Sede aggiornata con successo!', 'success');
      setEditingLocationId(null);
      setEditedLocation(null);
      await loadBusinessLocations(viewingUser.id);
    } catch (error) {
      console.error('[UsersManagement] Error updating location:', error);
      showToast('Errore durante l\'aggiornamento della sede', 'error');
    }
  };

  const handleSaveUser = async () => {
    if (!editedUser) return;

    setSaving(true);
    try {
      // Always update profiles (works for all user types)
      const profileUpdate: Record<string, any> = {
        full_name: editedUser.full_name,
        nickname: editedUser.nickname,
        email: editedUser.email,
        phone: editedUser.phone,
        fiscal_code: editedUser.fiscal_code,
        billing_address: editedUser.billing_address,
        billing_city: editedUser.billing_city,
        billing_province: editedUser.billing_province,
        billing_postal_code: editedUser.billing_postal_code,
        date_of_birth: editedUser.date_of_birth,
        relationship: editedUser.relationship,
      };

      const { error: profileError } = await supabase
        .from('profiles')
        .update(profileUpdate)
        .eq('id', editedUser.id);

      if (profileError) throw profileError;

      // For business users, also update registered_businesses
      if (editedUser.user_type === 'business' && editedUser._rb_id) {
        const rbUpdate: Record<string, any> = {
          name: editedUser.company_name,
          vat_number: editedUser.vat_number || null,
          unique_code: editedUser.unique_code || null,
          ateco_code: editedUser.ateco_code || null,
          pec_email: editedUser.pec_email || null,
          phone: editedUser.phone || null,
          website_url: editedUser.website_url || null,
          description: editedUser.description || null,
          category_id: editedUser.category_id || null,
          billing_street: editedUser.billing_street || null,
          billing_street_number: editedUser.billing_street_number || null,
          billing_city: editedUser.billing_city || null,
          billing_province: editedUser.billing_province || null,
          billing_postal_code: editedUser.billing_postal_code || null,
          office_street: editedUser.office_street || null,
          office_street_number: editedUser.office_street_number || null,
          office_city: editedUser.office_city || null,
          office_province: editedUser.office_province || null,
          office_postal_code: editedUser.office_postal_code || null,
        };

        const { error: rbError } = await supabase
          .from('registered_businesses')
          .update(rbUpdate)
          .eq('id', editedUser._rb_id);

        if (rbError) throw rbError;
      }

      showToast('Utente aggiornato con successo!', 'success');
      setViewingUser(editedUser);
      setIsEditing(false);
      await loadUsers();
    } catch (error) {
      console.error('[UsersManagement] Error updating user:', error);
      showToast('Errore durante l\'aggiornamento dell\'utente', 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleDeleteUser = async (userId: string) => {
    if (!confirm('Sei sicuro di voler eliminare questo utente? Questa azione è irreversibile.')) {
      return;
    }

    try {
      const { error } = await supabase.rpc('admin_delete_user_account', {
        user_id_to_delete: userId
      });

      if (error) throw error;

      showToast('Utente eliminato con successo!', 'success');
      setViewingUser(null);
      await loadUsers();
    } catch (error: any) {
      console.error('[UsersManagement] Error deleting user:', error);
      showToast(`Errore durante l'eliminazione: ${error.message}`, 'error');
    }
  };

  const getUserTypeLabel = (type: string) => {
    switch (type) {
      case 'customer': return 'Privato';
      case 'business': return 'Business';
      case 'admin': return 'Admin';
      default: return type;
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'active': return 'Attivo';
      case 'trial': return 'Prova';
      case 'expired': return 'Scaduto';
      case 'cancelled': return 'Annullato';
      default: return status;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'bg-green-100 text-green-800 border-green-300';
      case 'trial': return 'bg-blue-100 text-blue-800 border-blue-300';
      case 'expired': return 'bg-red-100 text-red-800 border-red-300';
      case 'cancelled': return 'bg-gray-100 text-gray-800 border-gray-300';
      default: return 'bg-gray-100 text-gray-800 border-gray-300';
    }
  };

  const relationshipLabel = (r: string) => {
    switch (r) {
      case 'spouse': return 'Coniuge';
      case 'child': return 'Figlio/a';
      case 'parent': return 'Genitore';
      case 'sibling': return 'Fratello/Sorella';
      default: return r || 'Familiare';
    }
  };

  // Derived counts for hero stats
  const customerCount = users.filter(u => u.user_type === 'customer').length;
  const businessCount = users.filter(u => u.user_type === 'business').length;
  const adminCount = users.filter(u => u.is_admin).length;
  const totalWithFamily = users.length + allFamilyRows.length;

  return (
    <div className="max-w-7xl mx-auto">
      {/* Hero Banner */}
      <div
        className="relative mb-6 rounded-2xl overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900"
      >
        {/* Dot pattern overlay */}
        <div
          className="absolute inset-0 opacity-5 pointer-events-none"
          style={{
            backgroundImage: 'radial-gradient(circle at 1px 1px, white 1px, transparent 0)',
            backgroundSize: '28px 28px',
          }}
        />
        <div className="relative flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 px-8 py-6">
          {/* Left: label + title + stats chips */}
          <div>
            <p className="text-xs font-semibold uppercase tracking-widest text-gray-400 mb-1">
              Pannello di Amministrazione
            </p>
            <h2 className="text-2xl font-bold text-white mb-3">Gestione Utenti</h2>
            <div className="flex flex-wrap items-center gap-2">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/10 text-white text-sm font-medium border border-white/20">
                <Users className="w-3.5 h-3.5" />
                {totalWithFamily} {totalWithFamily === 1 ? 'profilo' : 'profili'}
              </span>
              <span className="inline-flex items-center px-3 py-1 rounded-full bg-white/10 text-gray-300 text-sm font-medium border border-white/20">
                Privati: {customerCount}
              </span>
              <span className="inline-flex items-center gap-1 px-3 py-1 rounded-full bg-white/10 text-gray-300 text-sm font-medium border border-white/20">
                <UserPlus className="w-3.5 h-3.5" />
                Familiari: {allFamilyRows.length}
              </span>
              <span className="inline-flex items-center px-3 py-1 rounded-full bg-white/10 text-gray-300 text-sm font-medium border border-white/20">
                Business: {businessCount}
              </span>
              <span className="inline-flex items-center px-3 py-1 rounded-full bg-white/10 text-gray-300 text-sm font-medium border border-white/20">
                Admin: {adminCount}
              </span>
            </div>
          </div>
          {/* Right: placeholder for future action buttons (area reserved) */}
          <div className="flex items-center gap-2 shrink-0" />
        </div>
      </div>

      {/* Filter pills */}
      <div className="mb-6 flex flex-wrap gap-2">
        <button
          onClick={() => setFilterType('all')}
          className={`px-4 py-2 rounded-lg font-medium transition-colors ${
            filterType === 'all'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:border-gray-300'
          }`}
        >
          Tutti ({users.length})
        </button>
        <button
          onClick={() => setFilterType('customer')}
          className={`px-4 py-2 rounded-lg font-medium transition-colors ${
            filterType === 'customer'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:border-gray-300'
          }`}
        >
          Privati
        </button>
        <button
          onClick={() => setFilterType('business')}
          className={`px-4 py-2 rounded-lg font-medium transition-colors ${
            filterType === 'business'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:border-gray-300'
          }`}
        >
          Business
        </button>
        <button
          onClick={() => setFilterType('admin')}
          className={`px-4 py-2 rounded-lg font-medium transition-colors ${
            filterType === 'admin'
              ? 'bg-gray-900 text-white'
              : 'bg-white border border-gray-200 text-gray-600 hover:border-gray-300'
          }`}
        >
          Admin
        </button>
        {filterType !== 'all' && (
          <button
            onClick={() => setFilterType('all')}
            className="px-4 py-2 rounded-lg font-medium bg-red-100 text-red-700 hover:bg-red-200 flex items-center gap-2"
          >
            <FilterX className="w-4 h-4" />
            Rimuovi Filtro
          </button>
        )}
      </div>

      {loading ? (
        <div className="text-center py-12">
          <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-gray-900"></div>
          <p className="mt-4 text-gray-600">Caricamento utenti...</p>
        </div>
      ) : users.length === 0 ? (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-12 text-center">
          <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Users className="w-8 h-8 text-gray-400" />
          </div>
          <p className="text-gray-900 font-semibold text-lg">Nessun utente trovato</p>
          <p className="text-gray-400 text-sm mt-1">Prova a cambiare i filtri di ricerca</p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-900">
                <tr>
                  <th className="px-6 py-4 text-left text-sm font-bold text-white">Nome</th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-white">Email</th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-white">Tipo</th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-white">Stato</th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-white">Registrato</th>
                  <th className="px-6 py-4 text-right text-sm font-bold text-white">Azioni</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {users.map((user) => {
                  const userFamilyRows = allFamilyRows.filter(fm => fm.customer_id === user.id);
                  const userLocationRows = allBusinessLocationRows.filter(loc => loc.owner_id === user.id);
                  return (
                    <>
                      <tr key={user.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-6 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-blue-700 flex items-center justify-center text-white font-bold flex-shrink-0">
                              {user.full_name?.charAt(0).toUpperCase() || 'U'}
                            </div>
                            <div>
                              <p className="font-semibold text-gray-900">{user.full_name}</p>
                              {user.nickname && (
                                <p className="text-sm text-gray-500">@{user.nickname}</p>
                              )}
                              {userFamilyRows.length > 0 && (
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    setExpandedFamilyUserId(
                                      expandedFamilyUserId === user.id ? null : user.id
                                    );
                                  }}
                                  className="mt-1 inline-flex items-center gap-1 text-xs text-blue-600 font-medium hover:text-blue-800 transition-colors group"
                                >
                                  <UserPlus className="w-3 h-3" />
                                  {userFamilyRows.length} {userFamilyRows.length === 1 ? 'familiare' : 'familiari'}
                                  <ChevronDown className={`w-3 h-3 transition-transform duration-200 ${expandedFamilyUserId === user.id ? 'rotate-180' : ''}`} />
                                </button>
                              )}
                              {user.user_type === 'business' && (
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    setExpandedBusinessLocationsUserId(
                                      expandedBusinessLocationsUserId === user.id ? null : user.id
                                    );
                                  }}
                                  className="mt-1 inline-flex items-center gap-1 text-xs text-blue-600 font-medium hover:text-blue-800 transition-colors"
                                >
                                  <MapPin className="w-3 h-3" />
                                  {userLocationRows.length} {userLocationRows.length === 1 ? 'sede' : 'sedi'}
                                  <ChevronDown className={`w-3 h-3 transition-transform duration-200 ${expandedBusinessLocationsUserId === user.id ? 'rotate-180' : ''}`} />
                                </button>
                              )}
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4 text-gray-700">{user.email}</td>
                        <td className="px-6 py-4">
                          <span className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${
                            user.user_type === 'customer' ? 'bg-green-100 text-green-800' :
                            user.user_type === 'business' ? 'bg-orange-100 text-orange-800' :
                            'bg-gray-100 text-gray-800'
                          }`}>
                            {getUserTypeLabel(user.user_type)}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <span className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium border ${getStatusColor(user.subscription_status)}`}>
                            {getStatusLabel(user.subscription_status)}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-gray-700 text-sm">
                          {new Date(user.created_at).toLocaleDateString('it-IT')}
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex items-center justify-end gap-2">
                            <button
                              onClick={() => handleViewUser(user)}
                              className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                              title="Visualizza dettagli"
                            >
                              <Eye className="w-5 h-5" />
                            </button>
                            <button
                              onClick={() => handleDeleteUser(user.id)}
                              className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                              title="Elimina utente"
                            >
                              <Trash2 className="w-5 h-5" />
                            </button>
                          </div>
                        </td>
                      </tr>
                      {expandedFamilyUserId === user.id && userFamilyRows.map(fm => (
                        <tr key={`fm-${fm.id}`} className="bg-blue-50/40 hover:bg-blue-50 transition-colors">
                          <td className="px-6 py-3 pl-16">
                            <div className="flex items-center gap-3">
                              <div className="w-8 h-8 rounded-full bg-gradient-to-br from-teal-400 to-teal-600 flex items-center justify-center text-white font-bold text-sm flex-shrink-0">
                                {fm.first_name?.charAt(0).toUpperCase()}
                              </div>
                              <div>
                                <p className="font-medium text-gray-800 text-sm">{fm.first_name} {fm.last_name}</p>
                                {fm.nickname && <p className="text-xs text-gray-500">"{fm.nickname}"</p>}
                              </div>
                            </div>
                          </td>
                          <td className="px-6 py-3 text-xs text-gray-500 italic">membro di {fm.owner_name}</td>
                          <td className="px-6 py-3">
                            <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-teal-100 text-teal-800">
                              <UserPlus className="w-3 h-3" />
                              {relationshipLabel(fm.relationship)}
                            </span>
                          </td>
                          <td className="px-6 py-3 text-xs text-gray-400">—</td>
                          <td className="px-6 py-3 text-xs text-gray-400">—</td>
                          <td className="px-6 py-3" />
                        </tr>
                      ))}
                      {expandedBusinessLocationsUserId === user.id && userLocationRows.map((loc, idx) => (
                        <tr key={`loc-${loc.id}`} className="bg-orange-50/40 hover:bg-orange-50 transition-colors">
                          <td className="px-6 py-3 pl-16">
                            <div className="flex items-center gap-3">
                              <div className="w-8 h-8 rounded-full bg-gradient-to-br from-orange-400 to-orange-600 flex items-center justify-center text-white font-bold text-sm flex-shrink-0">
                                {idx + 1}
                              </div>
                              <div>
                                <p className="font-medium text-gray-800 text-sm">{loc.name}</p>
                                {loc.internal_name && loc.internal_name !== loc.name && (
                                  <p className="text-xs text-gray-500">"{loc.internal_name}"</p>
                                )}
                              </div>
                            </div>
                          </td>
                          <td className="px-6 py-3 text-xs text-gray-600">
                            <span className="inline-flex items-center gap-1">
                              <MapPin className="w-3 h-3 text-gray-400" />
                              {loc.city} ({loc.province})
                            </span>
                          </td>
                          <td className="px-6 py-3">
                            <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-orange-100 text-orange-800">
                              <MapPin className="w-3 h-3" />
                              Sede
                            </span>
                          </td>
                          <td className="px-6 py-3 text-xs text-gray-400">—</td>
                          <td className="px-6 py-3 text-xs text-gray-400">—</td>
                          <td className="px-6 py-3" />
                        </tr>
                      ))}
                    </>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Modal Dettagli Utente */}
      {viewingUser && editedUser && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            {/* Header */}
            <div className="sticky top-0 bg-gradient-to-r from-gray-800 to-gray-900 text-white px-6 py-4 rounded-t-2xl flex items-center justify-between z-10">
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 rounded-full bg-white bg-opacity-20 backdrop-blur-sm flex items-center justify-center text-2xl font-bold">
                  {viewingUser.full_name?.charAt(0).toUpperCase() || 'U'}
                </div>
                <div>
                  <h3 className="text-2xl font-bold">{viewingUser.full_name}</h3>
                  <p className="text-gray-300">{viewingUser.email}</p>
                  {viewingUser.nickname && (
                    <p className="text-gray-400 text-sm">@{viewingUser.nickname}</p>
                  )}
                </div>
              </div>
              <div className="flex items-center gap-2">
                {!isEditing ? (
                  <button
                    onClick={() => setIsEditing(true)}
                    className="px-4 py-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl font-semibold transition-colors flex items-center gap-2"
                  >
                    <Edit className="w-4 h-4" />
                    Modifica
                  </button>
                ) : (
                  <>
                    <button
                      onClick={handleSaveUser}
                      disabled={saving}
                      className="px-4 py-2 bg-green-500 text-white rounded-xl font-semibold hover:bg-green-600 transition-colors flex items-center gap-2 disabled:opacity-50"
                    >
                      <Save className="w-4 h-4" />
                      {saving ? 'Salvataggio...' : 'Salva'}
                    </button>
                    <button
                      onClick={() => {
                        setIsEditing(false);
                        setEditedUser(viewingUser);
                      }}
                      className="px-4 py-2 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl font-semibold transition-colors"
                    >
                      Annulla
                    </button>
                  </>
                )}
                <button
                  onClick={() => {
                    setViewingUser(null);
                    setEditedUser(null);
                    setIsEditing(false);
                  }}
                  className="p-2 bg-white/10 hover:bg-white/20 border border-white/20 rounded-xl transition-colors"
                >
                  <CloseIcon className="w-6 h-6" />
                </button>
              </div>
            </div>

            {/* Body */}
            <div className="p-6">
              {/* FORM PRIVATO */}
              {viewingUser.user_type === 'customer' && (
                <div className="space-y-6">
                  {/* Dati Personali */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <h3 className="text-lg font-bold text-gray-900 mb-4">Dati Personali</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Nome Completo</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.full_name}
                            onChange={(e) => setEditedUser({ ...editedUser, full_name: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.full_name}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Nickname</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.nickname || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, nickname: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.nickname || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Email</label>
                        {isEditing ? (
                          <input
                            type="email"
                            value={editedUser.email}
                            onChange={(e) => setEditedUser({ ...editedUser, email: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.email}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Telefono</label>
                        {isEditing ? (
                          <input
                            type="tel"
                            value={editedUser.phone || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, phone: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.phone || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Data di Nascita</label>
                        {isEditing ? (
                          <input
                            type="date"
                            value={editedUser.date_of_birth || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, date_of_birth: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.date_of_birth ? new Date(viewingUser.date_of_birth).toLocaleDateString('it-IT') : '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Codice Fiscale</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.fiscal_code || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, fiscal_code: e.target.value.toUpperCase() })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                            maxLength={16}
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900 uppercase">
                            {viewingUser.fiscal_code || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Relazione</label>
                        {isEditing ? (
                          <select
                            value={editedUser.relationship || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, relationship: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          >
                            <option value="">Seleziona...</option>
                            <option value="single">Single</option>
                            <option value="married">Sposato/a</option>
                            <option value="divorced">Divorziato/a</option>
                            <option value="widowed">Vedovo/a</option>
                          </select>
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.relationship || '—'}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Indirizzo di Fatturazione */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <h3 className="text-lg font-bold text-gray-900 mb-4">Indirizzo di Fatturazione</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div className="md:col-span-2">
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Via e Numero Civico</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.billing_address || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, billing_address: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.billing_address || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">CAP</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.billing_postal_code || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, billing_postal_code: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            maxLength={5}
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.billing_postal_code || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Città</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.billing_city || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, billing_city: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.billing_city || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Provincia</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.billing_province || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, billing_province: e.target.value.toUpperCase() })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                            maxLength={2}
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900 uppercase">
                            {viewingUser.billing_province || '—'}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Membri della Famiglia */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <div className="flex items-center gap-2 mb-4">
                      <UserCircle className="w-6 h-6 text-blue-600" />
                      <h3 className="text-lg font-bold text-gray-900">Membri della Famiglia</h3>
                      <span className="ml-auto bg-blue-600 text-white text-xs font-bold px-2 py-1 rounded-full">
                        {familyMembers.length}
                      </span>
                      {viewingUser.user_type === 'customer' && (
                        <button
                          onClick={() => setShowAddMemberForm(v => !v)}
                          className="ml-2 flex items-center gap-1 bg-blue-600 text-white text-xs font-semibold px-3 py-1.5 rounded-lg hover:bg-blue-700 transition-colors"
                        >
                          {showAddMemberForm ? 'Annulla' : '+ Aggiungi'}
                        </button>
                      )}
                    </div>

                    {showAddMemberForm && (
                      <div className="mb-4 bg-white rounded-lg border border-blue-200 p-4 space-y-3">
                        <p className="text-sm font-semibold text-blue-700">Nuovo membro</p>
                        <div className="grid grid-cols-2 gap-3">
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Nome *</label>
                            <input type="text" value={newMember.first_name} onChange={e => setNewMember(m => ({ ...m, first_name: e.target.value }))}
                              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Cognome *</label>
                            <input type="text" value={newMember.last_name} onChange={e => setNewMember(m => ({ ...m, last_name: e.target.value }))}
                              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Nickname</label>
                            <input type="text" value={newMember.nickname} onChange={e => setNewMember(m => ({ ...m, nickname: e.target.value }))}
                              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Relazione</label>
                            <input type="text" value={newMember.relationship} onChange={e => setNewMember(m => ({ ...m, relationship: e.target.value }))}
                              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Data di nascita</label>
                            <input type="date" value={newMember.date_of_birth} onChange={e => setNewMember(m => ({ ...m, date_of_birth: e.target.value }))}
                              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Codice Fiscale</label>
                            <input type="text" value={newMember.fiscal_code} onChange={e => setNewMember(m => ({ ...m, fiscal_code: e.target.value.toUpperCase() }))}
                              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm font-mono focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
                          </div>
                        </div>
                        <button
                          onClick={handleAddMember}
                          disabled={!newMember.first_name.trim() || !newMember.last_name.trim()}
                          className="w-full bg-blue-600 text-white py-2 rounded-lg text-sm font-semibold hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                        >
                          Salva membro
                        </button>
                      </div>
                    )}

                    <div className="space-y-3">
                      {familyMembers.length === 0 ? (
                        <p className="text-gray-600 text-sm text-center py-4">Nessun membro della famiglia aggiunto</p>
                      ) : (
                        familyMembers.map((member) => {
                          const isEditingThisMember = editingMemberId === member.id;
                          const displayMember = isEditingThisMember ? editedMember! : member;

                          return (
                            <div key={member.id} className="bg-white rounded-lg p-4 border border-gray-200">
                              <div className="flex items-start justify-between gap-4">
                                <div className="flex-1 space-y-3">
                                  {/* Nome e Cognome */}
                                  <div className="grid grid-cols-2 gap-3">
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Nome</label>
                                      {isEditingThisMember ? (
                                        <input
                                          type="text"
                                          value={displayMember.first_name}
                                          onChange={(e) => setEditedMember({ ...displayMember, first_name: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="font-semibold text-gray-900">{displayMember.first_name}</p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Cognome</label>
                                      {isEditingThisMember ? (
                                        <input
                                          type="text"
                                          value={displayMember.last_name}
                                          onChange={(e) => setEditedMember({ ...displayMember, last_name: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="font-semibold text-gray-900">{displayMember.last_name}</p>
                                      )}
                                    </div>
                                  </div>

                                  {/* Nickname */}
                                  <div>
                                    <label className="block text-xs font-semibold text-gray-600 mb-1">Nickname</label>
                                    {isEditingThisMember ? (
                                      <input
                                        type="text"
                                        value={displayMember.nickname}
                                        onChange={(e) => setEditedMember({ ...displayMember, nickname: e.target.value })}
                                        className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                      />
                                    ) : (
                                      <p className="text-sm text-gray-700">{displayMember.nickname}</p>
                                    )}
                                  </div>

                                  {/* Codice Fiscale */}
                                  <div>
                                    <label className="block text-xs font-semibold text-gray-600 mb-1">Codice Fiscale</label>
                                    {isEditingThisMember ? (
                                      <input
                                        type="text"
                                        value={displayMember.fiscal_code}
                                        onChange={(e) => setEditedMember({ ...displayMember, fiscal_code: e.target.value.toUpperCase() })}
                                        className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-purple-500 focus:border-transparent uppercase"
                                        maxLength={16}
                                      />
                                    ) : (
                                      <p className="text-sm text-gray-700 uppercase">{displayMember.fiscal_code}</p>
                                    )}
                                  </div>

                                  {/* Data di Nascita e Relazione */}
                                  <div className="grid grid-cols-2 gap-3">
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Data di Nascita</label>
                                      {isEditingThisMember ? (
                                        <input
                                          type="date"
                                          value={displayMember.date_of_birth}
                                          onChange={(e) => setEditedMember({ ...displayMember, date_of_birth: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">
                                          {new Date(displayMember.date_of_birth).toLocaleDateString('it-IT')}
                                        </p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Relazione</label>
                                      {isEditingThisMember ? (
                                        <select
                                          value={displayMember.relationship}
                                          onChange={(e) => setEditedMember({ ...displayMember, relationship: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        >
                                          <option value="spouse">Coniuge</option>
                                          <option value="child">Figlio/a</option>
                                          <option value="parent">Genitore</option>
                                          <option value="sibling">Fratello/Sorella</option>
                                          <option value="other">Altro</option>
                                        </select>
                                      ) : (
                                        <p className="text-sm text-gray-700">
                                          {displayMember.relationship === 'spouse' ? 'Coniuge' :
                                           displayMember.relationship === 'child' ? 'Figlio/a' :
                                           displayMember.relationship === 'parent' ? 'Genitore' :
                                           displayMember.relationship === 'sibling' ? 'Fratello/Sorella' :
                                           'Altro'}
                                        </p>
                                      )}
                                    </div>
                                  </div>
                                </div>

                                {/* Pulsanti Azione */}
                                <div className="flex flex-col gap-2">
                                  {isEditingThisMember ? (
                                    <>
                                      <button
                                        onClick={handleSaveMember}
                                        className="px-3 py-1.5 bg-green-500 text-white rounded-lg text-sm font-semibold hover:bg-green-600 transition-colors flex items-center gap-1"
                                      >
                                        <Save className="w-4 h-4" />
                                        Salva
                                      </button>
                                      <button
                                        onClick={handleCancelEditMember}
                                        className="px-3 py-1.5 bg-gray-200 text-gray-700 rounded-lg text-sm font-semibold hover:bg-gray-300 transition-colors"
                                      >
                                        Annulla
                                      </button>
                                    </>
                                  ) : (
                                    <button
                                      onClick={() => handleEditMember(member)}
                                      className="px-3 py-1.5 bg-blue-500 text-white rounded-lg text-sm font-semibold hover:bg-blue-600 transition-colors flex items-center gap-1"
                                    >
                                      <Edit className="w-4 h-4" />
                                      Modifica
                                    </button>
                                  )}
                                </div>
                              </div>
                            </div>
                          );
                        })
                      )}
                    </div>
                  </div>

                  {/* Abbonamento */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <div className="flex items-center gap-2 mb-4">
                      <CreditCard className="w-5 h-5 text-blue-600" />
                      <h3 className="text-lg font-bold text-gray-900">Abbonamento</h3>
                      {subscriptionPlan && (
                        <span className={`ml-auto inline-flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full ${
                          subscriptionPlan.status === 'trial' ? 'bg-yellow-100 text-yellow-800' :
                          subscriptionPlan.status === 'active' ? 'bg-green-100 text-green-800' :
                          subscriptionPlan.status === 'expired' ? 'bg-red-100 text-red-700' :
                          'bg-gray-100 text-gray-600'
                        }`}>
                          {subscriptionPlan.status === 'trial' ? <><Clock className="w-3 h-3" />In Prova</> :
                           subscriptionPlan.status === 'active' ? <><CheckCircle className="w-3 h-3" />Attivo</> :
                           subscriptionPlan.status === 'expired' ? <><AlertCircle className="w-3 h-3" />Scaduto</> :
                           subscriptionPlan.status}
                        </span>
                      )}
                    </div>
                    {subscriptionPlan ? (
                      <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <div className="md:col-span-2">
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Piano</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900 font-medium">{subscriptionPlan.name}</div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Fatturazione</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900">
                            {subscriptionPlan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Prezzo</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900 font-semibold">
                            €{parseFloat(subscriptionPlan.price?.toString() || '0').toFixed(2)}
                            <span className="text-xs text-gray-400 font-normal">/{subscriptionPlan.billing_period === 'monthly' ? 'mese' : 'anno'}</span>
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">
                            {subscriptionPlan.status === 'trial' ? 'Fine prova' : 'Scadenza'}
                          </label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900">
                            {subscriptionPlan.status === 'trial' && subscriptionPlan.trial_end_date
                              ? new Date(subscriptionPlan.trial_end_date).toLocaleDateString('it-IT')
                              : new Date(subscriptionPlan.end_date).toLocaleDateString('it-IT')}
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Inizio</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900">
                            {new Date(subscriptionPlan.start_date).toLocaleDateString('it-IT')}
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Pagamento</label>
                          <div className={`bg-white border rounded-lg px-4 py-2 text-sm font-medium flex items-center gap-1.5 ${subscriptionPlan.payment_method_added ? 'border-green-200 text-green-700' : 'border-gray-200 text-gray-500'}`}>
                            {subscriptionPlan.payment_method_added
                              ? <><CheckCircle className="w-4 h-4" />Metodo aggiunto</>
                              : <><Clock className="w-4 h-4" />Non ancora aggiunto</>}
                          </div>
                        </div>
                      </div>
                    ) : (
                      <p className="text-sm text-gray-500 text-center py-3">Nessun abbonamento attivo</p>
                    )}
                  </div>
                </div>
              )}

              {/* FORM BUSINESS */}
              {viewingUser.user_type === 'business' && (
                <div className="space-y-6">
                  {/* Dati Aziendali */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <h3 className="text-lg font-bold text-gray-900 mb-4">Dati Aziendali</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Ragione Sociale</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.company_name || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, company_name: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.company_name || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Partita IVA</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.vat_number || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, vat_number: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            maxLength={11}
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.vat_number || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Codice Univoco SDI</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.unique_code || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, unique_code: e.target.value.toUpperCase() })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                            maxLength={7}
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900 uppercase">
                            {viewingUser.unique_code || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Codice ATECO</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.ateco_code || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, ateco_code: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.ateco_code || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Email PEC</label>
                        {isEditing ? (
                          <input
                            type="email"
                            value={editedUser.pec_email || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, pec_email: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.pec_email || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Email</label>
                        {isEditing ? (
                          <input
                            type="email"
                            value={editedUser.email}
                            onChange={(e) => setEditedUser({ ...editedUser, email: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.email}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Telefono</label>
                        {isEditing ? (
                          <input
                            type="tel"
                            value={editedUser.phone || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, phone: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.phone || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Sito Web</label>
                        {isEditing ? (
                          <input
                            type="url"
                            value={editedUser.website_url || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, website_url: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.website_url || '—'}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1 flex items-center gap-1"><Tag className="w-3.5 h-3.5" />Categoria</label>
                        {isEditing ? (
                          <select
                            value={editedUser.category_id || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, category_id: e.target.value || undefined })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          >
                            <option value="">— Nessuna —</option>
                            {categories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                          </select>
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {categories.find(c => c.id === viewingUser.category_id)?.name || '—'}
                          </div>
                        )}
                      </div>
                      {/* Sede Legale inline in Dati Aziendali */}
                      <div className="md:col-span-2 mt-2">
                        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Sede Legale / Fatturazione</p>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Via</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.billing_street || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, billing_street: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.billing_street || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">N. Civico</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.billing_street_number || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, billing_street_number: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.billing_street_number || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">CAP</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.billing_postal_code || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, billing_postal_code: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                maxLength={5}
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.billing_postal_code || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Città</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.billing_city || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, billing_city: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.billing_city || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Provincia</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.billing_province || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, billing_province: e.target.value.toUpperCase() })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                                maxLength={2}
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900 uppercase">
                                {viewingUser.billing_province || '—'}
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                      {/* Sede Operativa inline */}
                      <div className="md:col-span-2 mt-2">
                        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Sede Operativa (Opzionale)</p>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Via</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.office_street || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, office_street: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.office_street || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">N. Civico</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.office_street_number || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, office_street_number: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.office_street_number || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">CAP</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.office_postal_code || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, office_postal_code: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                maxLength={5}
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.office_postal_code || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Città</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.office_city || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, office_city: e.target.value })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                                {viewingUser.office_city || '—'}
                              </div>
                            )}
                          </div>
                          <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Provincia</label>
                            {isEditing ? (
                              <input
                                type="text"
                                value={editedUser.office_province || ''}
                                onChange={(e) => setEditedUser({ ...editedUser, office_province: e.target.value.toUpperCase() })}
                                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                                maxLength={2}
                              />
                            ) : (
                              <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900 uppercase">
                                {viewingUser.office_province || '—'}
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                      <div className="md:col-span-2">
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Descrizione</label>
                        {isEditing ? (
                          <textarea
                            value={editedUser.description || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, description: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            rows={3}
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.description || '—'}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Abbonamento */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <div className="flex items-center gap-2 mb-4">
                      <CreditCard className="w-5 h-5 text-blue-600" />
                      <h3 className="text-lg font-bold text-gray-900">Abbonamento</h3>
                      {subscriptionPlan && (
                        <span className={`ml-auto inline-flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full ${
                          subscriptionPlan.status === 'trial' ? 'bg-yellow-100 text-yellow-800' :
                          subscriptionPlan.status === 'active' ? 'bg-green-100 text-green-800' :
                          subscriptionPlan.status === 'expired' ? 'bg-red-100 text-red-700' :
                          'bg-gray-100 text-gray-600'
                        }`}>
                          {subscriptionPlan.status === 'trial' ? <><Clock className="w-3 h-3" />In Prova</> :
                           subscriptionPlan.status === 'active' ? <><CheckCircle className="w-3 h-3" />Attivo</> :
                           subscriptionPlan.status === 'expired' ? <><AlertCircle className="w-3 h-3" />Scaduto</> :
                           subscriptionPlan.status}
                        </span>
                      )}
                    </div>
                    {subscriptionPlan ? (
                      <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <div className="md:col-span-2">
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Piano</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900 font-medium">{subscriptionPlan.name}</div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Fatturazione</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900">
                            {subscriptionPlan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Prezzo</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900 font-semibold">
                            €{parseFloat(subscriptionPlan.price?.toString() || '0').toFixed(2)}
                            <span className="text-xs text-gray-400 font-normal">/{subscriptionPlan.billing_period === 'monthly' ? 'mese' : 'anno'}</span>
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">
                            {subscriptionPlan.status === 'trial' ? 'Fine prova' : 'Scadenza'}
                          </label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900">
                            {subscriptionPlan.status === 'trial' && subscriptionPlan.trial_end_date
                              ? new Date(subscriptionPlan.trial_end_date).toLocaleDateString('it-IT')
                              : new Date(subscriptionPlan.end_date).toLocaleDateString('it-IT')}
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Inizio</label>
                          <div className="bg-white border border-gray-200 rounded-lg px-4 py-2 text-gray-900">
                            {new Date(subscriptionPlan.start_date).toLocaleDateString('it-IT')}
                          </div>
                        </div>
                        <div>
                          <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Pagamento</label>
                          <div className={`bg-white border rounded-lg px-4 py-2 text-sm font-medium flex items-center gap-1.5 ${subscriptionPlan.payment_method_added ? 'border-green-200 text-green-700' : 'border-gray-200 text-gray-500'}`}>
                            {subscriptionPlan.payment_method_added
                              ? <><CheckCircle className="w-4 h-4" />Metodo aggiunto</>
                              : <><Clock className="w-4 h-4" />Non ancora aggiunto</>}
                          </div>
                        </div>
                      </div>
                    ) : (
                      <p className="text-sm text-gray-500 text-center py-3">Nessun abbonamento attivo</p>
                    )}
                  </div>

                  {/* Sedi Business */}
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <div className="flex items-center gap-2 mb-4">
                      <MapPin className="w-6 h-6 text-indigo-600" />
                      <h3 className="text-lg font-bold text-gray-900">Sedi / Punti Vendita</h3>
                      <span className="ml-auto bg-indigo-600 text-white text-xs font-bold px-2 py-1 rounded-full">
                        {businessLocations.length}
                      </span>
                    </div>
                    {businessLocations.length === 0 ? (
                      <p className="text-gray-600 text-sm text-center py-4">Nessuna sede registrata</p>
                    ) : (
                      <div className="space-y-3">
                        {businessLocations.map((location) => {
                          const isEditingThisLocation = editingLocationId === location.id;
                          const displayLocation = isEditingThisLocation ? editedLocation! : location;

                          return (
                            <div key={location.id} className="bg-white rounded-lg p-4 border border-gray-200">
                              <div className="flex items-start justify-between gap-4">
                                <div className="flex-1 space-y-3">
                                  {/* Nome Sede */}
                                  <div>
                                    <label className="block text-xs font-semibold text-gray-600 mb-1">Nome Sede</label>
                                    {isEditingThisLocation ? (
                                      <input
                                        type="text"
                                        value={displayLocation.name}
                                        onChange={(e) => setEditedLocation({ ...displayLocation, name: e.target.value })}
                                        className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                      />
                                    ) : (
                                      <p className="font-semibold text-gray-900">{displayLocation.name}</p>
                                    )}
                                  </div>

                                  {/* Nome Interno */}
                                  <div>
                                    <label className="block text-xs font-semibold text-gray-600 mb-1">Nome Interno (opzionale)</label>
                                    {isEditingThisLocation ? (
                                      <input
                                        type="text"
                                        value={displayLocation.internal_name || ''}
                                        onChange={(e) => setEditedLocation({ ...displayLocation, internal_name: e.target.value })}
                                        className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                      />
                                    ) : (
                                      <p className="text-sm text-gray-700 italic">{displayLocation.internal_name || '—'}</p>
                                    )}
                                  </div>

                                  {/* Via e Numero Civico (separati) */}
                                  <div className="grid grid-cols-2 gap-3">
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Via</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="text"
                                          value={displayLocation.street || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, street: e.target.value, address: `${e.target.value} ${displayLocation.street_number || ''}`.trim() })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.street || '—'}</p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">N. Civico</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="text"
                                          value={displayLocation.street_number || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, street_number: e.target.value, address: `${displayLocation.street || ''} ${e.target.value}`.trim() })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.street_number || '—'}</p>
                                      )}
                                    </div>
                                  </div>

                                  {/* CAP, Città, Provincia */}
                                  <div className="grid grid-cols-3 gap-3">
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">CAP</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="text"
                                          value={displayLocation.postal_code || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, postal_code: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                          maxLength={5}
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.postal_code || '—'}</p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Città</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="text"
                                          value={displayLocation.city}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, city: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.city}</p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Provincia</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="text"
                                          value={displayLocation.province}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, province: e.target.value.toUpperCase() })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent uppercase"
                                          maxLength={2}
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700 uppercase">{displayLocation.province}</p>
                                      )}
                                    </div>
                                  </div>

                                  {/* Telefono ed Email */}
                                  <div className="grid grid-cols-2 gap-3">
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Telefono</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="tel"
                                          value={displayLocation.phone || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, phone: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.phone || '—'}</p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">Email</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="email"
                                          value={displayLocation.email || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, email: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.email || '—'}</p>
                                      )}
                                    </div>
                                  </div>

                                  {/* P.IVA Sede e Categoria */}
                                  <div className="grid grid-cols-2 gap-3">
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1">P.IVA Sede</label>
                                      {isEditingThisLocation ? (
                                        <input
                                          type="text"
                                          value={displayLocation.vat_number || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, vat_number: e.target.value })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                          maxLength={11}
                                        />
                                      ) : (
                                        <p className="text-sm text-gray-700">{displayLocation.vat_number || '—'}</p>
                                      )}
                                    </div>
                                    <div>
                                      <label className="block text-xs font-semibold text-gray-600 mb-1 flex items-center gap-1"><Tag className="w-3 h-3" />Categoria</label>
                                      {isEditingThisLocation ? (
                                        <select
                                          value={displayLocation.category_id || ''}
                                          onChange={(e) => setEditedLocation({ ...displayLocation, category_id: e.target.value || undefined })}
                                          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                        >
                                          <option value="">— Nessuna —</option>
                                          {categories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                                        </select>
                                      ) : (
                                        <p className="text-sm text-gray-700">{categories.find(c => c.id === displayLocation.category_id)?.name || '—'}</p>
                                      )}
                                    </div>
                                  </div>
                                </div>

                                {/* Pulsanti Azione */}
                                <div className="flex flex-col gap-2">
                                  {isEditingThisLocation ? (
                                    <>
                                      <button
                                        onClick={handleSaveLocation}
                                        className="px-3 py-1.5 bg-green-500 text-white rounded-lg text-sm font-semibold hover:bg-green-600 transition-colors flex items-center gap-1"
                                      >
                                        <Save className="w-4 h-4" />
                                        Salva
                                      </button>
                                      <button
                                        onClick={handleCancelEditLocation}
                                        className="px-3 py-1.5 bg-gray-200 text-gray-700 rounded-lg text-sm font-semibold hover:bg-gray-300 transition-colors"
                                      >
                                        Annulla
                                      </button>
                                    </>
                                  ) : (
                                    <button
                                      onClick={() => handleEditLocation(location)}
                                      className="px-3 py-1.5 bg-blue-500 text-white rounded-lg text-sm font-semibold hover:bg-blue-600 transition-colors flex items-center gap-1"
                                    >
                                      <Edit className="w-4 h-4" />
                                      Modifica
                                    </button>
                                  )}
                                </div>
                              </div>

                              {/* Foto caricate dalla sede */}
                              <div className="mt-4 pt-4 border-t border-gray-100">
                                <BusinessLocationPhotos locationId={location.id} readOnly />
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                </div>
              )}

              {/* FORM ADMIN */}
              {viewingUser.is_admin && (
                <div className="space-y-6">
                  <div className="bg-gray-50 rounded-xl border border-gray-100 p-6">
                    <h3 className="text-lg font-bold text-gray-900 mb-4">Dati Admin</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Nome Completo</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.full_name}
                            onChange={(e) => setEditedUser({ ...editedUser, full_name: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.full_name}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Email</label>
                        {isEditing ? (
                          <input
                            type="email"
                            value={editedUser.email}
                            onChange={(e) => setEditedUser({ ...editedUser, email: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.email}
                          </div>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">Nickname</label>
                        {isEditing ? (
                          <input
                            type="text"
                            value={editedUser.nickname || ''}
                            onChange={(e) => setEditedUser({ ...editedUser, nickname: e.target.value })}
                            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          />
                        ) : (
                          <div className="bg-white border border-gray-300 rounded-lg px-4 py-2 text-gray-900">
                            {viewingUser.nickname || '—'}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
