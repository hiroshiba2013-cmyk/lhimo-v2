import React, { useState, useEffect, useRef } from 'react';
import {
  Plus, Star, Building, MessageSquare, Check, Shield, TrendingUp,
  Heart, Gift, Users as UsersIcon, Briefcase, Users,
  DollarSign, Trophy, Activity, Tag, ChevronDown, ChevronUp,
  User, Mail, Phone, MapPin, FileText, Globe, Pencil, Save, X, CreditCard, Hash, Building2,
  Lock, Gavel, LogOut
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { supabase, Business, Review, FamilyMember } from '../lib/supabase';
import { BusinessJobPostingForm } from '../components/business/BusinessJobPostingForm';
import { EditBusinessLocationsForm } from '../components/business/EditBusinessLocationsForm';
import { BusinessLocationPhotos } from '../components/business/BusinessLocationPhotos';
import { EditBusinessForm } from '../components/business/EditBusinessForm';
import { UserAddBusinessModal } from '../components/business/UserAddBusinessModal';
import { ReviewResponseForm } from '../components/reviews/ReviewResponseForm';
import { ReviewCard } from '../components/reviews/ReviewCard';
import { ImportBusinessesForm } from '../components/business/ImportBusinessesForm';
import { FavoritesSection } from '../components/favorites/FavoritesSection';
import TrialStatusBanner from '../components/subscription/TrialStatusBanner';
import TrialExpirationModal from '../components/subscription/TrialExpirationModal';
import { ActivityFeed } from '../components/activity/ActivityFeed';
import { UserAuctionsSection } from '../components/auctions/UserAuctionsSection';
import { ProfileClassifiedAdCard } from '../components/classifieds/ProfileClassifiedAdCard';
import { ClassifiedAdForm } from '../components/classifieds/ClassifiedAdForm';
import { PinSetup } from '../components/profile/PinSetup';
import { DeleteAccountButton } from '../components/profile/DeleteAccountButton';
import { JobSeekerForm } from '../components/jobs/JobSeekerForm';
import { JobSeekerCard } from '../components/jobs/JobSeekerCard';
import { ProfessionalProfileForm } from '../components/profile/ProfessionalProfileForm';
import { AvatarUpload } from '../components/profile/AvatarUpload';
import { useToast } from '../components/common/Toast';
import { CategoryHierarchySelect } from '../components/common/CategoryHierarchySelect';
import { ItalianCityProvinceSelect } from '../components/common/ItalianCityProvinceSelect';
import { useNavigate } from '../components/Router';
import { usePageCustomization } from '../hooks/usePageCustomization';

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  billing_period: 'monthly' | 'yearly';
  max_persons: number;
}

interface Subscription {
  id: string;
  plan: SubscriptionPlan;
  status: string;
  start_date: string;
  end_date: string;
  trial_end_date?: string;
}

interface JobPosting {
  id: string;
  business_id: string;
  location_id: string | null;
  title: string;
  created_at: string;
}

interface JobSeeker {
  id: string;
  user_id: string;
  title: string;
  description: string;
  category: string;
  city: string;
  province: string;
  created_at: string;
  profiles: { full_name: string; nickname: string | null; avatar_url: string | null };
}

interface SolidarityStats {
  total_revenue: number;
  charity_amount: number;
}

// ─── colour helper ───────────────────────────────────────────────────────────
const COLOR: Record<string, { on: string; off: string }> = {
  green:   { on: 'bg-green-600 text-white border-green-600',     off: 'bg-green-50 text-green-700 border-green-200 hover:bg-green-100' },
  blue:    { on: 'bg-blue-600 text-white border-blue-600',       off: 'bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-100' },
  amber:   { on: 'bg-amber-500 text-white border-amber-500',     off: 'bg-amber-50 text-amber-700 border-amber-200 hover:bg-amber-100' },
  orange:  { on: 'bg-orange-500 text-white border-orange-500',   off: 'bg-orange-50 text-orange-700 border-orange-200 hover:bg-orange-100' },
  red:     { on: 'bg-red-500 text-white border-red-500',         off: 'bg-red-50 text-red-700 border-red-200 hover:bg-red-100' },
  rose:    { on: 'bg-rose-500 text-white border-rose-500',       off: 'bg-rose-50 text-rose-700 border-rose-200 hover:bg-rose-100' },
  sky:     { on: 'bg-sky-500 text-white border-sky-500',         off: 'bg-sky-50 text-sky-700 border-sky-200 hover:bg-sky-100' },
  teal:    { on: 'bg-teal-600 text-white border-teal-600',       off: 'bg-teal-50 text-teal-700 border-teal-200 hover:bg-teal-100' },
  emerald: { on: 'bg-emerald-600 text-white border-emerald-600', off: 'bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-100' },
  slate:   { on: 'bg-slate-600 text-white border-slate-600',     off: 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100' },
  yellow:  { on: 'bg-yellow-500 text-white border-yellow-500',   off: 'bg-yellow-50 text-yellow-700 border-yellow-200 hover:bg-yellow-100' },
};

function BadgeBtn({
  id, label, icon: Icon, color, badge, active, onClick,
}: {
  id: string; label: string; icon: React.ElementType; color: string;
  badge?: string | null; active: boolean; onClick: () => void;
}) {
  const c = COLOR[color] ?? COLOR.blue;
  return (
    <button
      onClick={onClick}
      className={`inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border text-xs font-semibold transition-all ${active ? c.on : c.off}`}
    >
      <Icon className="w-3.5 h-3.5 flex-shrink-0" />
      <span>{label}</span>
      {badge && (
        <span className={`ml-0.5 min-w-[18px] h-[18px] flex items-center justify-center rounded-full text-[10px] font-bold px-1 ${active ? 'bg-white/30 text-white' : 'bg-white shadow-sm text-gray-700'}`}>
          {badge}
        </span>
      )}
    </button>
  );
}

// ─── ProfileDataSection ───────────────────────────────────────────────────────
interface ProfileDataSectionProps {
  profile: any;
  isBiz: boolean;
  registeredBusiness?: any;
  familyMembers?: any[];
  businessLocations?: any[];
  editing: boolean;
  form: Record<string, string>;
  saving: boolean;
  saveMsg: string;
  onEdit: () => void;
  onCancel: () => void;
  onSave: () => void;
  onChange: (key: string, value: string) => void;
  onFamilyMemberSave?: (id: string, data: Record<string, string>) => Promise<void>;
  onLocationSave?: (id: string, data: Record<string, string>) => Promise<void>;
  memberAvatars: Record<string, string>;
  locationAvatars: Record<string, string>;
  onMemberAvatarChange: (id: string, url: string) => void;
  onLocationAvatarChange: (id: string, url: string) => void;
  uploadAvatar: (bucket: string, path: string, file: File) => Promise<string>;
  showToast: (msg: string, type: 'success' | 'error') => void;
}

function Field({ label, value, icon: Icon, hideIfEmpty = false }: { label: string; value?: string | null; icon: React.ElementType; hideIfEmpty?: boolean }) {
  if (hideIfEmpty && !value) return null;
  return (
    <div className="flex items-start gap-3">
      <div className="w-7 h-7 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
        <Icon className="w-3.5 h-3.5 text-gray-500" />
      </div>
      <div>
        <p className="text-xs text-gray-400 mb-0.5">{label}</p>
        <p className={`text-sm font-medium ${value ? 'text-gray-900' : 'text-gray-300 italic'}`}>{value || 'Non inserito'}</p>
      </div>
    </div>
  );
}

function EditField({ label, fieldKey, form, icon: Icon, onChange, type = 'text' }: {
  label: string; fieldKey: string; form: Record<string, string>;
  icon: React.ElementType; onChange: (k: string, v: string) => void; type?: string;
}) {
  return (
    <div>
      <label className="flex items-center gap-1.5 text-xs font-medium text-gray-500 mb-1">
        <Icon className="w-3.5 h-3.5" />{label}
      </label>
      <input
        type={type}
        value={form[fieldKey] || ''}
        onChange={e => onChange(fieldKey, e.target.value)}
        className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      />
    </div>
  );
}

function EditTextarea({ label, fieldKey, form, icon: Icon, onChange }: {
  label: string; fieldKey: string; form: Record<string, string>;
  icon: React.ElementType; onChange: (k: string, v: string) => void;
}) {
  return (
    <div className="md:col-span-2">
      <label className="flex items-center gap-1.5 text-xs font-medium text-gray-500 mb-1">
        <Icon className="w-3.5 h-3.5" />{label}
      </label>
      <textarea
        rows={3}
        value={form[fieldKey] || ''}
        onChange={e => onChange(fieldKey, e.target.value)}
        className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
      />
    </div>
  );
}

function EditSelect({ label, fieldKey, form, icon: Icon, onChange, options }: {
  label: string; fieldKey: string; form: Record<string, string>;
  icon: React.ElementType; onChange: (k: string, v: string) => void;
  options: { value: string; label: string }[];
}) {
  return (
    <div>
      <label className="flex items-center gap-1.5 text-xs font-medium text-gray-500 mb-1">
        <Icon className="w-3.5 h-3.5" />{label}
      </label>
      <select
        value={form[fieldKey] || ''}
        onChange={e => onChange(fieldKey, e.target.value)}
        className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white"
      >
        <option value="">-- Nessuna categoria --</option>
        {options.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
      </select>
    </div>
  );
}

function ProfileDataSection({ profile, isBiz, registeredBusiness, familyMembers = [], businessLocations = [], editing, form, saving, saveMsg, onEdit, onCancel, onSave, onChange, onFamilyMemberSave, onLocationSave, memberAvatars, locationAvatars, onMemberAvatarChange, onLocationAvatarChange, uploadAvatar, showToast }: ProfileDataSectionProps) {
  const [categories, setCategories] = useState<{ id: string; name: string }[]>([]);
  useEffect(() => {
    supabase.from('business_categories').select('id, name').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, []);

  const [expandedMember, setExpandedMember] = useState<string | null>(null);
  const [expandedLocation, setExpandedLocation] = useState<string | null>(null);
  const [editingMemberId, setEditingMemberId] = useState<string | null>(null);
  const [memberForms, setMemberForms] = useState<Record<string, Record<string, string>>>({});
  const [memberSaving, setMemberSaving] = useState<string | null>(null);
  const [memberMsg, setMemberMsg] = useState<Record<string, string>>({});
  const [editingLocationId, setEditingLocationId] = useState<string | null>(null);
  const [showAddLocationForm, setShowAddLocationForm] = useState(false);
  const [newLocationForm, setNewLocationForm] = useState<Record<string, string>>({});
  const [addingLocation, setAddingLocation] = useState(false);
  const [locationForms, setLocationForms] = useState<Record<string, Record<string, string>>>({});
  const [locationSaving, setLocationSaving] = useState<string | null>(null);
  const [locationMsg, setLocationMsg] = useState<Record<string, string>>({});
  const [editingPassword, setEditingPassword] = useState(false);
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passwordSaving, setPasswordSaving] = useState(false);
  const [passwordMsg, setPasswordMsg] = useState('');
  const [editingEmail, setEditingEmail] = useState(false);
  const [newEmail, setNewEmail] = useState('');
  const [emailSaving, setEmailSaving] = useState(false);
  const [emailMsg, setEmailMsg] = useState('');
  const msgTimers = useRef<Record<string, ReturnType<typeof setTimeout>>>({});

  useEffect(() => {
    const timers = msgTimers.current;
    return () => { Object.values(timers).forEach(clearTimeout); };
  }, []);

  const savePassword = async () => {
    if (newPassword.length < 6) {
      setPasswordMsg('La password deve essere di almeno 6 caratteri');
      return;
    }
    if (newPassword !== confirmPassword) {
      setPasswordMsg('Le password non coincidono');
      return;
    }
    setPasswordSaving(true);
    setPasswordMsg('');
    const { error } = await supabase.auth.updateUser({ password: newPassword });
    setPasswordSaving(false);
    if (error) {
      setPasswordMsg('Errore: ' + error.message);
    } else {
      setPasswordMsg('ok');
      setNewPassword('');
      setConfirmPassword('');
      setEditingPassword(false);
    }
  };

  const saveEmail = async () => {
    if (!newEmail.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newEmail.trim())) {
      setEmailMsg('Inserisci un indirizzo email valido');
      return;
    }
    setEmailSaving(true);
    setEmailMsg('');
    const { error } = await supabase.auth.updateUser({ email: newEmail.trim() });
    setEmailSaving(false);
    if (error) {
      setEmailMsg('Errore: ' + error.message);
    } else {
      setEmailMsg('ok');
      setNewEmail('');
      setEditingEmail(false);
    }
  };

  const startEditMember = (fm: any) => {
    setMemberForms(prev => ({ ...prev, [fm.id]: {
      first_name: fm.first_name || '',
      last_name: fm.last_name || '',
      nickname: fm.nickname || '',
      relationship: fm.relationship || '',
      date_of_birth: fm.date_of_birth || '',
      fiscal_code: fm.fiscal_code || '',
      category_id: fm.category_id || '',
    }}));
    setEditingMemberId(fm.id);
    setMemberMsg(prev => ({ ...prev, [fm.id]: '' }));
  };

  const saveMember = async (id: string) => {
    if (!onFamilyMemberSave) return;
    setMemberSaving(id);
    try {
      const raw = memberForms[id] || {};
      const clean = { ...raw, category_id: raw.category_id || null };
      await onFamilyMemberSave(id, clean);
      setMemberMsg(prev => ({ ...prev, [id]: 'ok' }));
      setEditingMemberId(null);
      clearTimeout(msgTimers.current[`member_${id}`]);
      msgTimers.current[`member_${id}`] = setTimeout(() => setMemberMsg(prev => ({ ...prev, [id]: '' })), 2500);
    } catch {
      setMemberMsg(prev => ({ ...prev, [id]: 'err' }));
    } finally {
      setMemberSaving(null);
    }
  };

  const startEditLocation = (loc: any) => {
    // registered_business_locations usa 'street', business_locations usa 'address'
    const isReg = (loc._table || 'registered_business_locations') === 'registered_business_locations';
    setLocationForms(prev => ({
      ...prev,
      [loc.id]: {
        name: loc.name || '',
        internal_name: loc.internal_name || '',
        description: loc.description || '',
        street: isReg ? (loc.street || '') : (loc.address || ''),
        street_number: loc.street_number || '',
        postal_code: loc.postal_code || '',
        city: loc.city || '',
        province: loc.province || '',
        phone: loc.phone || '',
        email: loc.email || '',
        vat_number: (loc as any).vat_number || '',
        category_id: (loc as any).category_id || '',
        services: Array.isArray(loc.services) ? loc.services.join(', ') : (loc.services || ''),
        services_description: loc.services_description || '',
      },
    }));
    setEditingLocationId(loc.id);
    setLocationMsg(prev => ({ ...prev, [loc.id]: '' }));
  };

  const saveLocation = async (id: string) => {
    if (!onLocationSave) return;
    setLocationSaving(id);
    try {
      const loc = businessLocations.find(l => l.id === id);
      const isReg = ((loc as any)?._table || 'registered_business_locations') === 'registered_business_locations';
      const rawForm = locationForms[id] || {};
      // Mappa 'street' -> 'address' per business_locations
      const servicesStr = (rawForm.services || '').trim();
      const servicesArray = servicesStr.length > 0
        ? servicesStr.split(',').map((s: string) => s.trim()).filter((s: string) => s.length > 0)
        : null;
      const cleanForm = {
        ...rawForm,
        services: servicesArray,
        category_id: rawForm.category_id || null,
      };
      const saveData = isReg
        ? cleanForm
        : { ...cleanForm, address: rawForm.street, street: undefined };
      await onLocationSave(id, saveData);
      setLocationMsg(prev => ({ ...prev, [id]: 'ok' }));
      setEditingLocationId(null);
      clearTimeout(msgTimers.current[`loc_${id}`]);
      msgTimers.current[`loc_${id}`] = setTimeout(() => setLocationMsg(prev => ({ ...prev, [id]: '' })), 2500);
    } catch {
      setLocationMsg(prev => ({ ...prev, [id]: 'err' }));
    } finally {
      setLocationSaving(null);
    }
  };

  const p = profile as any;
  const rb = registeredBusiness as any;
  const bizData = isBiz && rb ? rb : p;
  const billingAddress = [bizData.billing_street, bizData.billing_street_number, bizData.billing_postal_code, bizData.billing_city, bizData.billing_province].filter(Boolean).join(', ');
  const officeAddress = isBiz ? [bizData.office_street, bizData.office_street_number, bizData.office_postal_code, bizData.office_city, bizData.office_province].filter(Boolean).join(', ') : '';

  return (
    <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
      {/* Header */}
      <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100 bg-gray-50/50">
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 bg-slate-100 rounded-xl flex items-center justify-center">
            <Building2 className="w-4.5 h-4.5 text-slate-600" />
          </div>
          <div>
            <span className="font-semibold text-gray-900 text-sm">I Tuoi Dati</span>
            <p className="text-xs text-gray-400">{isBiz ? 'Dati aziendali e sedi' : 'Profilo e famiglia'}</p>
          </div>
        </div>
        {!editing ? (
          <button onClick={onEdit} className="flex items-center gap-1.5 text-xs font-semibold text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 px-3 py-2 rounded-xl transition-colors">
            <Pencil className="w-3.5 h-3.5" />Modifica
          </button>
        ) : (
          <div className="flex items-center gap-2">
            <button onClick={onCancel} className="flex items-center gap-1.5 text-xs font-semibold text-gray-500 hover:text-gray-700 bg-gray-100 hover:bg-gray-200 px-3 py-2 rounded-xl transition-colors">
              <X className="w-3.5 h-3.5" />Annulla
            </button>
            <button onClick={onSave} disabled={saving} className="flex items-center gap-1.5 text-xs font-semibold text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-60 px-3 py-2 rounded-xl transition-colors">
              <Save className="w-3.5 h-3.5" />{saving ? 'Salvo...' : 'Salva'}
            </button>
          </div>
        )}
      </div>

      <div className="px-6 pb-6 pt-5 space-y-7">
        {saveMsg && (
          <div className={`px-4 py-3 rounded-xl text-sm font-medium flex items-center gap-2 ${saveMsg.includes('successo') ? 'bg-green-50 text-green-700 border border-green-200' : 'bg-red-50 text-red-700 border border-red-200'}`}>
            {saveMsg.includes('successo') ? <Check className="w-4 h-4 flex-shrink-0" /> : <X className="w-4 h-4 flex-shrink-0" />}
            {saveMsg}
          </div>
        )}

        {!editing ? (
          /* ── READ MODE ── */
          <div className="space-y-7">

            {/* Dati aziendali / personali */}
            <section>
              <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                <span className="w-5 h-px bg-gray-200 inline-block" />
                {isBiz ? 'Dati Aziendali' : 'Dati Personali'}
                <span className="flex-1 h-px bg-gray-200 inline-block" />
              </h3>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {isBiz ? (
                  <>
                    <Field label="Ragione Sociale" value={bizData.company_name || bizData.name} icon={Building2} />
                    <Field label="Partita IVA" value={bizData.vat_number} icon={CreditCard} />
                    <Field label="Codice Univoco" value={bizData.unique_code} icon={Hash} hideIfEmpty />
                    <Field label="Codice ATECO" value={bizData.ateco_code} icon={FileText} hideIfEmpty />
                    <Field label="Email PEC" value={bizData.pec_email} icon={Mail} hideIfEmpty />
                    <Field label="Telefono" value={bizData.phone} icon={Phone} hideIfEmpty />
                    <Field label="Sito Web" value={bizData.website_url || bizData.website} icon={Globe} hideIfEmpty />
                    <Field label="Categoria" value={categories.find(c => c.id === bizData.category_id)?.name || null} icon={Tag} />
                    {bizData.description && <div className="sm:col-span-2"><Field label="Descrizione" value={bizData.description} icon={FileText} /></div>}
                  </>
                ) : (
                  <>
                    <Field label="Nome Completo" value={p.full_name} icon={User} />
                    <Field label="Nickname" value={p.nickname} icon={User} hideIfEmpty />
                    <Field label="Telefono" value={p.phone} icon={Phone} hideIfEmpty />
                    <Field label="Codice Fiscale" value={p.fiscal_code} icon={CreditCard} hideIfEmpty />
                    {p.category_id && <Field label="Categoria" value={categories.find(c => c.id === p.category_id)?.name} icon={Tag} hideIfEmpty />}
                  </>
                )}
              </div>
            </section>

            {/* Indirizzi */}
            {(billingAddress || (isBiz && officeAddress)) && (
              <section>
                <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                  <span className="w-5 h-px bg-gray-200 inline-block" />
                  Indirizzi
                  <span className="flex-1 h-px bg-gray-200 inline-block" />
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {billingAddress && (
                    <div className="bg-gray-50 rounded-xl p-4">
                      <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Fatturazione</p>
                      <div className="flex items-start gap-2">
                        <MapPin className="w-3.5 h-3.5 text-gray-400 mt-0.5 flex-shrink-0" />
                        <p className="text-sm text-gray-700">{billingAddress}</p>
                      </div>
                    </div>
                  )}
                  {isBiz && officeAddress && (
                    <div className="bg-gray-50 rounded-xl p-4">
                      <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Sede Legale</p>
                      <div className="flex items-start gap-2">
                        <Building className="w-3.5 h-3.5 text-gray-400 mt-0.5 flex-shrink-0" />
                        <p className="text-sm text-gray-700">{officeAddress}</p>
                      </div>
                    </div>
                  )}
                </div>
              </section>
            )}

            {/* Email + Password account */}
            <section>
              <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                <span className="w-5 h-px bg-gray-200 inline-block" />
                Account
                <span className="flex-1 h-px bg-gray-200 inline-block" />
              </h3>
              <div className="space-y-3">
                <div className="flex items-start gap-3">
                  <div className="w-7 h-7 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Mail className="w-3.5 h-3.5 text-gray-500" />
                  </div>
                  <div className="flex-1">
                    <p className="text-xs text-gray-400 mb-0.5">Email di accesso</p>
                    <div className="flex items-center justify-between gap-2">
                      <p className="text-sm font-medium text-gray-900 truncate">{p.email}</p>
                      <button
                        onClick={() => { setEditingEmail(true); setNewEmail(p.email || ''); setEmailMsg(''); }}
                        className="flex items-center gap-1 text-xs font-semibold text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 px-2.5 py-1 rounded-lg transition-colors flex-shrink-0"
                      >
                        <Pencil className="w-3 h-3" />Modifica
                      </button>
                    </div>
                    {editingEmail && (
                      <div className="mt-3 space-y-2 border border-gray-100 rounded-xl p-3 bg-gray-50">
                        <div>
                          <label className="text-xs text-gray-500 mb-1 block">Nuova email</label>
                          <input
                            type="email"
                            value={newEmail}
                            onChange={e => setNewEmail(e.target.value)}
                            placeholder="nuova@email.com"
                            className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </div>
                        <p className="text-xs text-gray-400">Riceverai una email di conferma al nuovo indirizzo.</p>
                        {emailMsg && emailMsg !== 'ok' && (
                          <p className="text-xs text-red-600">{emailMsg}</p>
                        )}
                        <div className="flex gap-2 pt-1">
                          <button
                            onClick={saveEmail}
                            disabled={emailSaving}
                            className="flex items-center gap-1.5 text-xs font-semibold text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-60 px-3 py-1.5 rounded-lg transition-colors"
                          >
                            <Save className="w-3 h-3" />{emailSaving ? 'Salvo...' : 'Salva'}
                          </button>
                          <button
                            onClick={() => { setEditingEmail(false); setNewEmail(''); setEmailMsg(''); }}
                            className="text-xs font-semibold text-gray-500 hover:text-gray-700 bg-gray-100 hover:bg-gray-200 px-3 py-1.5 rounded-lg transition-colors"
                          >
                            Annulla
                          </button>
                        </div>
                      </div>
                    )}
                    {emailMsg === 'ok' && (
                      <p className="text-xs text-green-600 mt-1 flex items-center gap-1">
                        <Check className="w-3 h-3" />Controlla la tua email per confermare il cambio
                      </p>
                    )}
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-7 h-7 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Lock className="w-3.5 h-3.5 text-gray-500" />
                  </div>
                  <div className="flex-1">
                    <p className="text-xs text-gray-400 mb-0.5">Password</p>
                    <div className="flex items-center justify-between gap-2">
                      <p className="text-sm font-medium text-gray-900 tracking-widest">••••••••</p>
                      <button
                        onClick={() => { setEditingPassword(true); setPasswordMsg(''); }}
                        className="flex items-center gap-1 text-xs font-semibold text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 px-2.5 py-1 rounded-lg transition-colors"
                      >
                        <Pencil className="w-3 h-3" />Modifica
                      </button>
                    </div>
                    {editingPassword && (
                      <div className="mt-3 space-y-2 border border-gray-100 rounded-xl p-3 bg-gray-50">
                        <div>
                          <label className="text-xs text-gray-500 mb-1 block">Nuova password</label>
                          <input
                            type="password"
                            value={newPassword}
                            onChange={e => setNewPassword(e.target.value)}
                            placeholder="Minimo 6 caratteri"
                            className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </div>
                        <div>
                          <label className="text-xs text-gray-500 mb-1 block">Conferma password</label>
                          <input
                            type="password"
                            value={confirmPassword}
                            onChange={e => setConfirmPassword(e.target.value)}
                            placeholder="Ripeti la password"
                            className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </div>
                        {passwordMsg && passwordMsg !== 'ok' && (
                          <p className="text-xs text-red-600">{passwordMsg}</p>
                        )}
                        <div className="flex gap-2 pt-1">
                          <button
                            onClick={savePassword}
                            disabled={passwordSaving}
                            className="flex items-center gap-1.5 text-xs font-semibold text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-60 px-3 py-1.5 rounded-lg transition-colors"
                          >
                            <Save className="w-3 h-3" />{passwordSaving ? 'Salvo...' : 'Salva'}
                          </button>
                          <button
                            onClick={() => { setEditingPassword(false); setNewPassword(''); setConfirmPassword(''); setPasswordMsg(''); }}
                            className="text-xs font-semibold text-gray-500 hover:text-gray-700 bg-gray-100 hover:bg-gray-200 px-3 py-1.5 rounded-lg transition-colors"
                          >
                            Annulla
                          </button>
                        </div>
                      </div>
                    )}
                    {passwordMsg === 'ok' && (
                      <p className="text-xs text-green-600 mt-1 flex items-center gap-1">
                        <Check className="w-3 h-3" />Password aggiornata
                      </p>
                    )}
                  </div>
                </div>
              </div>
            </section>

            {/* Familiari (solo customer) */}
            {!isBiz && familyMembers.length > 0 && (
              <section>
                <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                  <span className="w-5 h-px bg-gray-200 inline-block" />
                  Membri della Famiglia
                  <span className="bg-gray-200 text-gray-600 text-[10px] font-bold px-2 py-0.5 rounded-full">{familyMembers.length}</span>
                  <span className="flex-1 h-px bg-gray-200 inline-block" />
                </h3>
                <div className="space-y-2">
                  {familyMembers.map(fm => {
                    const isEditingThis = editingMemberId === fm.id;
                    const mf = memberForms[fm.id] || {};
                    const isExpanded = expandedMember === fm.id || isEditingThis;
                    return (
                      <div key={fm.id} className="border border-gray-100 rounded-xl overflow-hidden hover:border-gray-200 transition-colors">
                        <div className="flex items-center justify-between px-4 py-3">
                          <div className="flex items-center gap-3 flex-1 min-w-0">
                            <div className="relative flex-shrink-0">
                              <div className="w-10 h-10 rounded-full overflow-hidden border-2 border-gray-100 bg-blue-50 flex items-center justify-center">
                                {(memberAvatars[fm.id] || fm.avatar_url) ? (
                                  <img src={memberAvatars[fm.id] || fm.avatar_url!} alt="" className="w-full h-full object-cover" />
                                ) : (
                                  <span className="text-sm font-bold text-blue-500">{fm.first_name?.[0]?.toUpperCase()}</span>
                                )}
                              </div>
                              <label htmlFor={`fm-avatar-${fm.id}`} className="absolute -bottom-1 -right-1 w-5 h-5 bg-blue-500 hover:bg-blue-600 rounded-full flex items-center justify-center cursor-pointer border-2 border-white transition-colors" title="Cambia foto">
                                <svg className="w-2.5 h-2.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" /><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
                                <input id={`fm-avatar-${fm.id}`} type="file" accept="image/*" className="sr-only" onChange={async (e) => {
                                  const file = e.target.files?.[0]; if (!file) return;
                                  try {
                                    const ext = file.name.split('.').pop();
                                    const url = await uploadAvatar('avatars', `family/${fm.id}/avatar.${ext}`, file);
                                    await supabase.from('customer_family_members').update({ avatar_url: url }).eq('id', fm.id);
                                    onMemberAvatarChange(fm.id, url);
                                    showToast('Foto aggiornata!', 'success');
                                  } catch { showToast('Errore durante il caricamento', 'error'); }
                                  e.target.value = '';
                                }} />
                              </label>
                            </div>
                            <button onClick={() => setExpandedMember(isExpanded && !isEditingThis ? null : fm.id)} className="flex-1 min-w-0 text-left">
                              <p className="text-sm font-semibold text-gray-900">{fm.first_name} {fm.last_name}</p>
                              <p className="text-xs text-gray-400">{fm.nickname ? `@${fm.nickname}` : fm.relationship || ''}</p>
                            </button>
                            {fm.relationship && <span className="text-xs bg-blue-50 text-blue-600 font-medium px-2.5 py-1 rounded-full flex-shrink-0">{fm.relationship}</span>}
                          </div>
                          <div className="flex items-center gap-1.5 ml-3 flex-shrink-0">
                            {memberMsg[fm.id] === 'ok' && <span className="text-xs text-green-600 font-medium">Salvato</span>}
                            {memberMsg[fm.id] === 'err' && <span className="text-xs text-red-600 font-medium">Errore</span>}
                            {isEditingThis ? (
                              <>
                                <button onClick={() => setEditingMemberId(null)} className="p-1.5 rounded-lg bg-gray-100 hover:bg-gray-200 transition-colors"><X className="w-3.5 h-3.5 text-gray-500" /></button>
                                <button onClick={() => saveMember(fm.id)} disabled={memberSaving === fm.id} className="p-1.5 rounded-lg bg-blue-600 hover:bg-blue-700 disabled:opacity-60 transition-colors"><Save className="w-3.5 h-3.5 text-white" /></button>
                              </>
                            ) : (
                              <button onClick={() => { setExpandedMember(fm.id); startEditMember(fm); }} className="p-1.5 rounded-lg hover:bg-blue-50 transition-colors"><Pencil className="w-3.5 h-3.5 text-gray-400 hover:text-blue-600" /></button>
                            )}
                            <ChevronDown onClick={() => setExpandedMember(isExpanded ? null : fm.id)} className={`w-4 h-4 text-gray-400 transition-transform cursor-pointer ${isExpanded ? 'rotate-180' : ''}`} />
                          </div>
                        </div>
                        {isExpanded && (
                          <div className="px-4 pb-4 pt-3 bg-gray-50/70 border-t border-gray-100">
                            {isEditingThis ? (
                              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <EditField label="Nome" fieldKey="first_name" form={mf} icon={User} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} />
                                <EditField label="Cognome" fieldKey="last_name" form={mf} icon={User} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} />
                                <EditField label="Nickname" fieldKey="nickname" form={mf} icon={User} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} />
                                <EditField label="Ruolo" fieldKey="relationship" form={mf} icon={UsersIcon} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} />
                                <EditField label="Data di Nascita" fieldKey="date_of_birth" form={mf} icon={FileText} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} type="date" />
                                <EditField label="Codice Fiscale" fieldKey="fiscal_code" form={mf} icon={CreditCard} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} />
                                <EditSelect label="Categoria" fieldKey="category_id" form={mf} icon={Tag} onChange={(k, v) => setMemberForms(prev => ({ ...prev, [fm.id]: { ...prev[fm.id], [k]: v } }))} options={categories.map(c => ({ value: c.id, label: c.name }))} />
                              </div>
                            ) : (
                              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <Field label="Nome" value={`${fm.first_name} ${fm.last_name}`} icon={User} />
                                {fm.nickname && <Field label="Nickname" value={fm.nickname} icon={User} />}
                                {fm.date_of_birth && <Field label="Data di Nascita" value={new Date(fm.date_of_birth).toLocaleDateString('it-IT')} icon={FileText} />}
                                {fm.fiscal_code && <Field label="Codice Fiscale" value={fm.fiscal_code} icon={CreditCard} />}
                                {fm.relationship && <Field label="Ruolo" value={fm.relationship} icon={UsersIcon} />}
                                {(fm as any).category_id && <Field label="Categoria" value={categories.find(c => c.id === (fm as any).category_id)?.name} icon={Tag} />}
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </section>
            )}

            {/* Sedi (solo business) */}
            {isBiz && businessLocations.length > 0 && (
              <section>
                <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                  <span className="w-5 h-px bg-gray-200 inline-block" />
                  Sedi
                  <span className="bg-gray-200 text-gray-600 text-[10px] font-bold px-2 py-0.5 rounded-full">{businessLocations.length}</span>
                  <span className="flex-1 h-px bg-gray-200 inline-block" />
                  <button onClick={() => setShowAddLocationForm(true)} className="text-blue-600 hover:text-blue-700 text-xs font-semibold flex items-center gap-1 transition-colors">
                    <Plus className="w-3.5 h-3.5" /> Aggiungi sede
                  </button>
                </h3>
                <div className="space-y-2">
                  {businessLocations.map((loc, idx) => {
                    const isEditingThis = editingLocationId === loc.id;
                    const lf = locationForms[loc.id] || {};
                    const isExpanded = expandedLocation === loc.id || isEditingThis;
                    const isReg = ((loc as any)._table || 'registered_business_locations') === 'registered_business_locations';
                    const streetVal = isReg ? loc.street : loc.address;
                    const locTable = isReg ? 'registered_business_locations' : 'business_locations';
                    const locAddress = [streetVal, loc.street_number, loc.postal_code, loc.city, loc.province].filter(Boolean).join(', ');
                    return (
                      <div key={loc.id} className="border border-gray-100 rounded-xl overflow-hidden hover:border-gray-200 transition-colors">
                        <div className="flex items-center justify-between px-4 py-3">
                          <div className="flex items-center gap-3 flex-1 min-w-0">
                            <div className="relative flex-shrink-0">
                              <div className="w-10 h-10 rounded-full overflow-hidden border-2 border-gray-100 bg-emerald-50 flex items-center justify-center">
                                {(locationAvatars[loc.id] || loc.avatar_url) ? (
                                  <img src={locationAvatars[loc.id] || loc.avatar_url!} alt="" className="w-full h-full object-cover" />
                                ) : (
                                  <span className="text-sm font-bold text-emerald-600">{(loc.internal_name || loc.name || String(idx + 1))[0]?.toUpperCase()}</span>
                                )}
                              </div>
                              <label htmlFor={`loc-avatar-${loc.id}`} className="absolute -bottom-1 -right-1 w-5 h-5 bg-emerald-500 hover:bg-emerald-600 rounded-full flex items-center justify-center cursor-pointer border-2 border-white transition-colors" title="Cambia foto sede">
                                <svg className="w-2.5 h-2.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" /><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
                                <input id={`loc-avatar-${loc.id}`} type="file" accept="image/*" className="sr-only" onChange={async (e) => {
                                  const file = e.target.files?.[0]; if (!file) return;
                                  try {
                                    const ext = file.name.split('.').pop();
                                    const url = await uploadAvatar('avatars', `locations/${loc.id}/avatar.${ext}`, file);
                                    await supabase.from(locTable).update({ avatar_url: url }).eq('id', loc.id);
                                    onLocationAvatarChange(loc.id, url);
                                    showToast('Foto sede aggiornata!', 'success');
                                  } catch { showToast('Errore durante il caricamento', 'error'); }
                                  e.target.value = '';
                                }} />
                              </label>
                            </div>
                            <button onClick={() => setExpandedLocation(isExpanded && !isEditingThis ? null : loc.id)} className="flex-1 min-w-0 text-left">
                              <p className="text-sm font-semibold text-gray-900">{loc.internal_name || loc.name || `Sede ${idx + 1}`}</p>
                              {loc.city && <p className="text-xs text-gray-400">{loc.city}{loc.province ? ` (${loc.province})` : ''}</p>}
                            </button>
                          </div>
                          <div className="flex items-center gap-1.5 ml-3 flex-shrink-0">
                            {locationMsg[loc.id] === 'ok' && <span className="text-xs text-green-600 font-medium">Salvato</span>}
                            {locationMsg[loc.id] === 'err' && <span className="text-xs text-red-600 font-medium">Errore</span>}
                            {isEditingThis ? (
                              <>
                                <button onClick={() => setEditingLocationId(null)} className="p-1.5 rounded-lg bg-gray-100 hover:bg-gray-200 transition-colors"><X className="w-3.5 h-3.5 text-gray-500" /></button>
                                <button onClick={() => saveLocation(loc.id)} disabled={locationSaving === loc.id} className="p-1.5 rounded-lg bg-blue-600 hover:bg-blue-700 disabled:opacity-60 transition-colors"><Save className="w-3.5 h-3.5 text-white" /></button>
                              </>
                            ) : (
                              <button onClick={() => { setExpandedLocation(loc.id); startEditLocation(loc); }} className="p-1.5 rounded-lg hover:bg-blue-50 transition-colors"><Pencil className="w-3.5 h-3.5 text-gray-400 hover:text-blue-600" /></button>
                            )}
                            <ChevronDown onClick={() => setExpandedLocation(isExpanded ? null : loc.id)} className={`w-4 h-4 text-gray-400 transition-transform cursor-pointer ${isExpanded ? 'rotate-180' : ''}`} />
                          </div>
                        </div>
                        {isExpanded && (
                          <div className="px-4 pb-4 pt-3 bg-gray-50/70 border-t border-gray-100">
                            {isEditingThis ? (
                              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <EditField label="Nome Sede" fieldKey="name" form={lf} icon={Building2} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="Nome Interno" fieldKey="internal_name" form={lf} icon={Building2} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="Via" fieldKey="street" form={lf} icon={MapPin} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="Civico" fieldKey="street_number" form={lf} icon={MapPin} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="CAP" fieldKey="postal_code" form={lf} icon={MapPin} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="Citta" fieldKey="city" form={lf} icon={MapPin} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="Provincia" fieldKey="province" form={lf} icon={MapPin} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditField label="Telefono" fieldKey="phone" form={lf} icon={Phone} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} type="tel" />
                                <EditField label="Email" fieldKey="email" form={lf} icon={Mail} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} type="email" />
                                <EditField label="P.IVA Sede" fieldKey="vat_number" form={lf} icon={CreditCard} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditSelect label="Categoria" fieldKey="category_id" form={lf} icon={Tag} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} options={categories.map(c => ({ value: c.id, label: c.name }))} />
                                <EditTextarea label="Descrizione" fieldKey="description" form={lf} icon={FileText} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                                <EditTextarea label="Servizi offerti" fieldKey="services_description" form={lf} icon={FileText} onChange={(k, v) => setLocationForms(prev => ({ ...prev, [loc.id]: { ...prev[loc.id], [k]: v } }))} />
                              </div>
                            ) : (
                              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                {locAddress && <div className="sm:col-span-2"><Field label="Indirizzo" value={locAddress} icon={MapPin} /></div>}
                                {loc.phone && <Field label="Telefono" value={loc.phone} icon={Phone} />}
                                {loc.email && <Field label="Email" value={loc.email} icon={Mail} />}
                                {loc.vat_number && <Field label="P.IVA Sede" value={loc.vat_number} icon={CreditCard} />}
                                {(loc as any).category_id && <Field label="Categoria" value={categories.find(c => c.id === (loc as any).category_id)?.name} icon={Tag} />}
                                {loc.description && <div className="sm:col-span-2"><Field label="Descrizione" value={loc.description} icon={FileText} /></div>}
                                {(loc.services_description || loc.services) && <div className="sm:col-span-2"><Field label="Servizi" value={loc.services_description || loc.services} icon={FileText} /></div>}
                                {loc.business_hours && (() => {
                                  const days: Record<string, string> = { monday: 'Lunedi', tuesday: 'Martedi', wednesday: 'Mercoledi', thursday: 'Giovedi', friday: 'Venerdi', saturday: 'Sabato', sunday: 'Domenica' };
                                  const hours = loc.business_hours as Record<string, any>;
                                  const lines = Object.entries(days).map(([k, label]) => {
                                    const d = hours[k];
                                    if (!d || d.closed) return `${label}: Chiuso`;
                                    return `${label}: ${d.open || '--'} - ${d.close || '--'}`;
                                  });
                                  return (
                                    <div className="sm:col-span-2 bg-white rounded-lg p-3 border border-gray-100">
                                      <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Orari</p>
                                      <div className="grid grid-cols-2 gap-x-4 gap-y-1">
                                        {lines.map(l => <p key={l} className="text-xs text-gray-700">{l}</p>)}
                                      </div>
                                    </div>
                                  );
                                })()}
                              </div>
                            )}

                            {/* Foto della sede */}
                            {!isEditingThis && (
                              <div className="mt-4 pt-4 border-t border-gray-100">
                                <BusinessLocationPhotos locationId={loc.id} />
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </section>
            )}

            {/* Empty state: business con 0 sedi */}
            {isBiz && businessLocations.length === 0 && !showAddLocationForm && (
              <section>
                <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                  <span className="w-5 h-px bg-gray-200 inline-block" />
                  Sedi
                  <span className="flex-1 h-px bg-gray-200 inline-block" />
                </h3>
                <div className="bg-white rounded-xl p-6 border border-dashed border-gray-200 text-center">
                  <MapPin className="w-8 h-8 text-gray-300 mx-auto mb-2" />
                  <p className="text-sm text-gray-500 mb-3">Nessuna sede registrata. Aggiungi la prima sede della tua attività.</p>
                  <button onClick={() => setShowAddLocationForm(true)} className="inline-flex items-center gap-1.5 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-semibold transition-colors">
                    <Plus className="w-4 h-4" /> Aggiungi sede
                  </button>
                </div>
              </section>
            )}

            {/* Form aggiungi sede */}
            {isBiz && showAddLocationForm && (() => {
              const table = isRegisteredBusiness ? 'registered_business_locations' : 'business_locations';
              return (
                <section>
                  <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-5 h-px bg-gray-200 inline-block" />
                    Nuova Sede
                    <span className="flex-1 h-px bg-gray-200 inline-block" />
                    <button onClick={() => { setShowAddLocationForm(false); setNewLocationForm({}); }} className="p-1.5 rounded-lg bg-gray-100 hover:bg-gray-200 transition-colors">
                      <X className="w-3.5 h-3.5 text-gray-500" />
                    </button>
                  </h3>
                  <div className="bg-white rounded-xl p-4 border border-gray-200 space-y-3">
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Nome sede</label>
                        <input type="text" value={newLocationForm.name || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, name: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" placeholder="Es. Sede principale" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Categoria</label>
                        <CategoryHierarchySelect value={newLocationForm.category_id || ''} onChange={(v) => setNewLocationForm({ ...newLocationForm, category_id: v })} />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Via</label>
                        <input type="text" value={newLocationForm.street || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, street: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" placeholder="Via" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">N. civico</label>
                        <input type="text" value={newLocationForm.street_number || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, street_number: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Città</label>
                        <ItalianCityProvinceSelect
                          city={newLocationForm.city || ''}
                          province={newLocationForm.province || ''}
                          onCityChange={(v) => setNewLocationForm({ ...newLocationForm, city: v })}
                          onProvinceChange={(v) => setNewLocationForm({ ...newLocationForm, province: v })}
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">CAP</label>
                        <input type="text" value={newLocationForm.postal_code || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, postal_code: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Telefono</label>
                        <input type="text" value={newLocationForm.phone || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, phone: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Email</label>
                        <input type="text" value={newLocationForm.email || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, email: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1">Sito web</label>
                        <input type="text" value={newLocationForm.website || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, website: e.target.value })} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" />
                      </div>
                      <div className="sm:col-span-2">
                        <label className="block text-xs font-medium text-gray-600 mb-1">Descrizione</label>
                        <textarea value={newLocationForm.description || ''} onChange={(e) => setNewLocationForm({ ...newLocationForm, description: e.target.value })} rows={2} className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none" placeholder="Descrizione della sede..." />
                      </div>
                    </div>
                    <div className="flex justify-end gap-2 pt-2">
                      <button onClick={() => { setShowAddLocationForm(false); setNewLocationForm({}); }} className="px-4 py-2 text-sm font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors">Annulla</button>
                      <button
                        onClick={async () => {
                          if (!profile) return;
                          setAddingLocation(true);
                          try {
                            // Ensure registered_businesses exists first
                            let bizId = businesses[0]?.id;
                            if (!bizId && profile.user_type === 'business') {
                              // Create registered_businesses record if missing
                              const { data: newBiz, error: bizErr } = await supabase.from('registered_businesses').insert({
                                owner_id: profile.id,
                                name: (profile as any).full_name || (profile as any).company_name || 'Attività',
                                category_id: (profile as any).category_id || null,
                              }).select('id').single();
                              if (bizErr) throw bizErr;
                              bizId = newBiz.id;
                              setIsRegisteredBusiness(true);
                              setBusinesses([newBiz]);
                            }
                            if (!bizId) throw new Error('Nessuna attività trovata');
                            const insertData: Record<string, any> = {
                              business_id: bizId,
                              name: newLocationForm.name || 'Sede principale',
                              street: newLocationForm.street || null,
                              street_number: newLocationForm.street_number || null,
                              city: newLocationForm.city || null,
                              province: newLocationForm.province || null,
                              postal_code: newLocationForm.postal_code || null,
                              phone: newLocationForm.phone || null,
                              email: newLocationForm.email || null,
                              website: newLocationForm.website || null,
                              description: newLocationForm.description || null,
                              category_id: newLocationForm.category_id || null,
                              is_primary: fullBusinessLocations.length === 0,
                            };
                            const { error: locErr } = await supabase.from('registered_business_locations').insert(insertData);
                            if (locErr) throw locErr;
                            setShowAddLocationForm(false);
                            setNewLocationForm({});
                            showToast?.('Sede aggiunta con successo!', 'success');
                            loadData();
                          } catch (err: any) {
                            showToast?.(err.message || 'Errore durante l\'aggiunta della sede', 'error');
                          } finally {
                            setAddingLocation(false);
                          }
                        }}
                        disabled={addingLocation}
                        className="px-4 py-2 text-sm font-semibold text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50 rounded-lg transition-colors"
                      >
                        {addingLocation ? 'Salvataggio...' : 'Salva sede'}
                      </button>
                    </div>
                  </div>
                </section>
              );
            })()}
          </div>
        ) : (
          /* ── EDIT MODE ── */
          <div className="space-y-7">
            {isBiz ? (
              <>
                <section>
                  <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-5 h-px bg-gray-200 inline-block" />Dati Aziendali<span className="flex-1 h-px bg-gray-200 inline-block" />
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <EditField label="Ragione Sociale" fieldKey="company_name" form={form} icon={Building2} onChange={onChange} />
                    <EditField label="Partita IVA" fieldKey="vat_number" form={form} icon={CreditCard} onChange={onChange} />
                    <EditField label="Codice Univoco" fieldKey="unique_code" form={form} icon={Hash} onChange={onChange} />
                    <EditField label="Codice ATECO" fieldKey="ateco_code" form={form} icon={FileText} onChange={onChange} />
                    <EditField label="Email PEC" fieldKey="pec_email" form={form} icon={Mail} onChange={onChange} type="email" />
                    <EditField label="Telefono" fieldKey="phone" form={form} icon={Phone} onChange={onChange} type="tel" />
                    <EditField label="Sito Web" fieldKey="website_url" form={form} icon={Globe} onChange={onChange} />
                    <EditSelect label="Categoria" fieldKey="category_id" form={form} icon={Tag} onChange={onChange} options={categories.map(c => ({ value: c.id, label: c.name }))} />
                    <EditTextarea label="Descrizione" fieldKey="description" form={form} icon={FileText} onChange={onChange} />
                  </div>
                </section>
                <section>
                  <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-5 h-px bg-gray-200 inline-block" />Indirizzo di Fatturazione<span className="flex-1 h-px bg-gray-200 inline-block" />
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <EditField label="Via" fieldKey="billing_street" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="Civico" fieldKey="billing_street_number" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="CAP" fieldKey="billing_postal_code" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="Citta" fieldKey="billing_city" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="Provincia" fieldKey="billing_province" form={form} icon={MapPin} onChange={onChange} />
                  </div>
                </section>
                <section>
                  <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-5 h-px bg-gray-200 inline-block" />Sede Legale / Ufficio<span className="flex-1 h-px bg-gray-200 inline-block" />
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <EditField label="Via" fieldKey="office_street" form={form} icon={Building} onChange={onChange} />
                    <EditField label="Civico" fieldKey="office_street_number" form={form} icon={Building} onChange={onChange} />
                    <EditField label="CAP" fieldKey="office_postal_code" form={form} icon={Building} onChange={onChange} />
                    <EditField label="Citta" fieldKey="office_city" form={form} icon={Building} onChange={onChange} />
                    <EditField label="Provincia" fieldKey="office_province" form={form} icon={Building} onChange={onChange} />
                  </div>
                </section>
              </>
            ) : (
              <>
                <section>
                  <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-5 h-px bg-gray-200 inline-block" />Dati Personali<span className="flex-1 h-px bg-gray-200 inline-block" />
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <EditField label="Nome Completo" fieldKey="full_name" form={form} icon={User} onChange={onChange} />
                    <EditField label="Nickname" fieldKey="nickname" form={form} icon={User} onChange={onChange} />
                    <EditField label="Telefono" fieldKey="phone" form={form} icon={Phone} onChange={onChange} type="tel" />
                    <EditField label="Codice Fiscale" fieldKey="fiscal_code" form={form} icon={CreditCard} onChange={onChange} />
                    <EditSelect label="Categoria" fieldKey="category_id" form={form} icon={Tag} onChange={onChange} options={categories.map(c => ({ value: c.id, label: c.name }))} />
                  </div>
                </section>
                <section>
                  <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-5 h-px bg-gray-200 inline-block" />Indirizzo di Fatturazione<span className="flex-1 h-px bg-gray-200 inline-block" />
                  </h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <EditField label="Via" fieldKey="billing_street" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="Civico" fieldKey="billing_street_number" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="CAP" fieldKey="billing_postal_code" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="Citta" fieldKey="billing_city" form={form} icon={MapPin} onChange={onChange} />
                    <EditField label="Provincia" fieldKey="billing_province" form={form} icon={MapPin} onChange={onChange} />
                  </div>
                </section>
              </>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export function DashboardPage() {
  const { user, profile, selectedBusinessLocationId, activeProfile, signOut, updateFamilyMemberAvatar } = useAuth();
  const { showToast } = useToast();
  const navigate = useNavigate();
  const customization = usePageCustomization(profile?.user_type === 'business' ? 'dashboard_business' : 'dashboard_private');

  const [businesses, setBusinesses] = useState<Business[]>([]);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [jobPostings, setJobPostings] = useState<JobPosting[]>([]);
  const [jobSeekers, setJobSeekers] = useState<JobSeeker[]>([]);
  const [solidarityStats, setSolidarityStats] = useState<SolidarityStats | null>(null);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [loading, setLoading] = useState(true);

  const [showCreateBusinessForm, setShowCreateBusinessForm] = useState(false);
  const [showResponseForm, setShowResponseForm] = useState<string | null>(null);
  const [businessClassifiedAds, setBusinessClassifiedAds] = useState<any[]>([]);
  const [showClassifiedAdForm, setShowClassifiedAdForm] = useState(false);
  const [editingClassifiedAdId, setEditingClassifiedAdId] = useState<string | undefined>(undefined);
  const [customerClassifiedAds, setCustomerClassifiedAds] = useState<any[]>([]);
  const [showCustomerAdForm, setShowCustomerAdForm] = useState(false);
  const [editingCustomerAdId, setEditingCustomerAdId] = useState<string | undefined>(undefined);
  const [selectedBusinessId, setSelectedBusinessId] = useState<string | null>(null);
  const [isRegisteredBusiness, setIsRegisteredBusiness] = useState(false);
  const [fullBusinessLocations, setFullBusinessLocations] = useState<any[]>([]);
  const [addedBusinesses, setAddedBusinesses] = useState<any[]>([]);
  const [myJobSeekers, setMyJobSeekers] = useState<any[]>([]);
  const [myAuctionsCount, setMyAuctionsCount] = useState(0);
  const [favBusinessesCount, setFavBusinessesCount] = useState(0);
  const [professionalProfile, setProfessionalProfile] = useState<any | null>(null);
  const [professionalProfileLoaded, setProfessionalProfileLoaded] = useState(false);
  const [showProfessionalProfileForm, setShowProfessionalProfileForm] = useState(false);
  const [showPinModal, setShowPinModal] = useState(false);
  const [showJobSeekerForm, setShowJobSeekerForm] = useState(false);
  const [currentSubscription, setCurrentSubscription] = useState<Subscription | null>(null);
  const [availablePlans, setAvailablePlans] = useState<SubscriptionPlan[]>([]);
  const [upgradeMessage, setUpgradeMessage] = useState('');
  const [userRank, setUserRank] = useState<{ points: number; rank: number; reviews_count: number } | null>(null);

  const [open, setOpen] = useState<Record<string, boolean>>({});
  const toggle = (key: string) => setOpen(prev => ({ ...prev, [key]: !prev[key] }));

  const [localAvatarUrl, setLocalAvatarUrl] = useState<string | null>(null);
  useEffect(() => {
    setLocalAvatarUrl(activeProfile?.avatarUrl ?? profile?.avatar_url ?? null);
  }, [activeProfile, profile]);

  // Avatar locali per family members e sedi
  const [memberAvatars, setMemberAvatars] = useState<Record<string, string>>({});
  const [locationAvatars, setLocationAvatars] = useState<Record<string, string>>({});

  const uploadAvatar = async (bucket: string, path: string, file: File): Promise<string> => {
    if (file.size > 5 * 1024 * 1024) throw new Error('Immagine troppo grande (max 5MB)');
    const { error } = await supabase.storage.from(bucket).upload(path, file, { upsert: true });
    if (error) throw error;
    const { data: { publicUrl } } = supabase.storage.from(bucket).getPublicUrl(path);
    return `${publicUrl}?t=${Date.now()}`;
  };

  // Resetta le sezioni aperte e il profilo professionale quando cambia il profilo attivo o la sede selezionata
  useEffect(() => {
    setOpen({});
    setProfessionalProfile(null);
    setProfessionalProfileLoaded(false);
    setShowProfessionalProfileForm(false);
  }, [activeProfile, selectedBusinessLocationId]);

  // Apri sezione dalla query string (?open=reviews)
  useEffect(() => {
    if (loading || !profile) return;
    const params = new URLSearchParams(window.location.search);
    const openParam = params.get('open');
    if (openParam === 'reviews') {
      const key = profile.user_type === 'business' ? 'biz_reviews' : 'cust_reviews';
      setOpen(prev => ({ ...prev, [key]: true }));
      setTimeout(() => {
        document.getElementById(key)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }, 100);
    }
  }, [loading, profile]);

  // ── profile edit state ─────────────────────────────────────────────────────
  const [editingProfile, setEditingProfile] = useState(false);
  const [profileForm, setProfileForm] = useState<Record<string, string>>({});
  const [profileSaving, setProfileSaving] = useState(false);
  const [profileSaveMsg, setProfileSaveMsg] = useState('');
  const profileSaveMsgTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const startEditProfile = () => {
    if (!profile) return;
    const rb = isRegisteredBusiness && businesses[0] ? businesses[0] as any : null;
    setProfileForm({
      full_name: profile.full_name || '',
      nickname: (profile as any).nickname || '',
      phone: rb ? (rb.phone || '') : ((profile as any).phone || ''),
      fiscal_code: (profile as any).fiscal_code || '',
      billing_street: rb ? (rb.billing_street || '') : ((profile as any).billing_street || ''),
      billing_street_number: rb ? (rb.billing_street_number || '') : ((profile as any).billing_street_number || ''),
      billing_postal_code: rb ? (rb.billing_postal_code || '') : ((profile as any).billing_postal_code || ''),
      billing_city: rb ? (rb.billing_city || '') : ((profile as any).billing_city || ''),
      billing_province: rb ? (rb.billing_province || '') : ((profile as any).billing_province || ''),
      // business-only (da registered_businesses se disponibile)
      company_name: rb ? (rb.name || '') : ((profile as any).company_name || ''),
      vat_number: rb ? (rb.vat_number || '') : ((profile as any).vat_number || ''),
      unique_code: rb ? (rb.unique_code || '') : ((profile as any).unique_code || ''),
      ateco_code: rb ? (rb.ateco_code || '') : ((profile as any).ateco_code || ''),
      pec_email: rb ? (rb.pec_email || '') : ((profile as any).pec_email || ''),
      website_url: rb ? (rb.website || '') : ((profile as any).website_url || ''),
      description: rb ? (rb.description || '') : ((profile as any).description || ''),
      category_id: rb ? (rb.category_id || '') : ((profile as any).category_id || ''),
      office_street: rb ? (rb.office_street || '') : ((profile as any).office_street || ''),
      office_street_number: rb ? (rb.office_street_number || '') : ((profile as any).office_street_number || ''),
      office_postal_code: rb ? (rb.office_postal_code || '') : ((profile as any).office_postal_code || ''),
      office_city: rb ? (rb.office_city || '') : ((profile as any).office_city || ''),
      office_province: rb ? (rb.office_province || '') : ((profile as any).office_province || ''),
    });
    setEditingProfile(true);
    setProfileSaveMsg('');
  };

  const saveProfile = async () => {
    if (!profile) return;
    setProfileSaving(true);
    setProfileSaveMsg('');
    try {
      if (isRegisteredBusiness && businesses[0]) {
        // Salva i dati aziendali su registered_businesses
        const rbUpdate = {
          name: profileForm.company_name,
          vat_number: profileForm.vat_number,
          unique_code: profileForm.unique_code,
          ateco_code: profileForm.ateco_code,
          pec_email: profileForm.pec_email,
          website: profileForm.website_url,
          description: profileForm.description,
          category_id: profileForm.category_id || null,
          phone: profileForm.phone,
          billing_street: profileForm.billing_street,
          billing_street_number: profileForm.billing_street_number,
          billing_postal_code: profileForm.billing_postal_code,
          billing_city: profileForm.billing_city,
          billing_province: profileForm.billing_province,
          office_street: profileForm.office_street,
          office_street_number: profileForm.office_street_number,
          office_postal_code: profileForm.office_postal_code,
          office_city: profileForm.office_city,
          office_province: profileForm.office_province,
        };
        const { error } = await supabase.from('registered_businesses').update(rbUpdate).eq('id', (businesses[0] as any).id);
        if (error) throw error;
        // Aggiorna il nome anche in profiles
        await supabase.from('profiles').update({ full_name: profileForm.company_name }).eq('id', profile.id);
        // Aggiorna lo stato locale
        setBusinesses(prev => prev.map((b, i) => i === 0 ? { ...b, ...rbUpdate, name: profileForm.company_name } : b));
      } else if (profile.user_type === 'business') {
        // Business user senza registered_businesses: crea il record ora
        const rbInsert = {
          owner_id: profile.id,
          name: profileForm.company_name,
          vat_number: profileForm.vat_number || null,
          unique_code: profileForm.unique_code || null,
          ateco_code: profileForm.ateco_code || null,
          pec_email: profileForm.pec_email || null,
          website: profileForm.website_url || null,
          description: profileForm.description || null,
          category_id: profileForm.category_id || null,
          phone: profileForm.phone || null,
          billing_street: profileForm.billing_street || null,
          billing_street_number: profileForm.billing_street_number || null,
          billing_postal_code: profileForm.billing_postal_code || null,
          billing_city: profileForm.billing_city || null,
          billing_province: profileForm.billing_province || null,
          office_street: profileForm.office_street || null,
          office_street_number: profileForm.office_street_number || null,
          office_postal_code: profileForm.office_postal_code || null,
          office_city: profileForm.office_city || null,
          office_province: profileForm.office_province || null,
        };
        const { data: insertedRb, error: insertErr } = await supabase.from('registered_businesses').insert(rbInsert).select().single();
        if (insertErr) throw insertErr;
        await supabase.from('profiles').update({ full_name: profileForm.company_name }).eq('id', profile.id);
        if (insertedRb) {
          setBusinesses([insertedRb]);
          setIsRegisteredBusiness(true);
          // Ricarica le sedi col nuovo business_id
          const { data: locs } = await supabase.from('registered_business_locations').select('*').eq('business_id', insertedRb.id);
          if (locs) setFullBusinessLocations(locs.map(l => ({ ...l, _table: 'registered_business_locations' })));
        }
      } else {
        const customerUpdate = { ...profileForm, category_id: profileForm.category_id || null };
        const { error } = await supabase.from('profiles').update(customerUpdate).eq('id', profile.id);
        if (error) throw error;
      }
      setProfileSaveMsg('Dati salvati con successo!');
      setEditingProfile(false);
      if (profileSaveMsgTimer.current) clearTimeout(profileSaveMsgTimer.current);
      profileSaveMsgTimer.current = setTimeout(() => setProfileSaveMsg(''), 3000);
    } catch {
      setProfileSaveMsg('Errore durante il salvataggio.');
    } finally {
      setProfileSaving(false);
    }
  };

  const saveFamilyMember = async (id: string, data: Record<string, string>) => {
    const { error } = await supabase.from('customer_family_members').update(data).eq('id', id);
    if (error) throw error;
    const { data: fm } = await supabase.from('customer_family_members').select('*').eq('customer_id', profile!.id).order('created_at', { ascending: true });
    if (fm) setFamilyMembers(fm);
  };

  const saveBusinessLocation = async (id: string, data: Record<string, string>) => {
    const table = isRegisteredBusiness ? 'registered_business_locations' : 'business_locations';
    const { error } = await supabase.from(table).update(data).eq('id', id);
    if (error) throw error;
    const bizIds = businesses.map((b: any) => b.id);
    const { data: locs } = await supabase.from(table).select('*').in('business_id', bizIds);
    if (locs) setFullBusinessLocations(locs.map(l => ({ ...l, _table: table })));
  };

  // ── data loading ───────────────────────────────────────────────────────────
  const loadAds = async () => {
    if (!profile) return;
    const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;
    if (profile.user_type === 'business') {
      const { data } = await supabase.from('classified_ads').select('*, classified_categories(name, icon)').eq('user_id', profile.id).order('created_at', { ascending: false });
      if (data) setBusinessClassifiedAds(data);
    } else {
      let q = supabase.from('classified_ads').select('*, classified_categories(name, icon)').eq('user_id', profile.id).order('created_at', { ascending: false });
      q = familyMemberId ? q.eq('family_member_id', familyMemberId) : q.is('family_member_id', null);
      const { data } = await q;
      if (data) setCustomerClassifiedAds(data);

      // Conteggio attività preferite
      const { data: favData } = await supabase
        .from('favorite_businesses')
        .select('id')
        .eq('user_id', profile.id);
      setFavBusinessesCount(favData?.length ?? 0);
    }
  };

  const deleteAd = async (adId: string) => {
    await supabase.from('classified_ads').delete().eq('id', adId);
    loadAds();
  };

  useEffect(() => {
    if (!profile) return;
    loadData();
    loadSubscription();
  }, [profile, selectedBusinessLocationId, activeProfile]);

  const loadData = async () => {
    if (!profile) return;
    setLoading(true);
    setReviews([]); setJobPostings([]); setJobSeekers([]);
    try {
      if (profile.user_type === 'business') {
        // job seekers (other people looking for work — shown in biz_seekers section)
        const { data: js } = await supabase.from('job_seekers').select('*, profiles!inner(full_name, nickname, avatar_url)').eq('status', 'active').order('created_at', { ascending: false }).limit(10);
        if (js) setJobSeekers(js);

        // own job seeker profiles (for biz_job_seeker section)
        const { data: myJs } = await supabase.from('job_seekers').select('*, profiles(full_name, nickname)').eq('user_id', profile.id).is('family_member_id', null).order('created_at', { ascending: false });
        if (myJs) setMyJobSeekers(myJs);

        // solidarity
        try {
          const { data: rev } = await supabase.rpc('get_total_revenue');
          if (rev !== null) setSolidarityStats({ total_revenue: rev, charity_amount: rev * 0.1 });
        } catch { /* non critico */ }

        // businesses
        let { data: regData } = await supabase.from('registered_businesses').select('*').eq('owner_id', profile.id);
        let isReg = false;
        let bizData: any[] | null = regData;
        if (!bizData || bizData.length === 0) {
          const { data: oldData } = await supabase.from('businesses').select('*').eq('owner_id', profile.id);
          bizData = oldData;
        } else { isReg = true; }
        // Fallback: if no business record exists at all, create a synthetic one from profile data
        if ((!bizData || bizData.length === 0) && profile.user_type === 'business') {
          bizData = [{
            id: profile.id,
            owner_id: profile.id,
            name: profile.full_name || profile.company_name || '',
            vat_number: (profile as any).vat_number || null,
            unique_code: (profile as any).unique_code || null,
            ateco_code: (profile as any).ateco_code || null,
            pec_email: (profile as any).pec_email || null,
            website: (profile as any).website_url || null,
            description: (profile as any).description || null,
            category_id: (profile as any).category_id || (profile as any).business_category_id || null,
            phone: (profile as any).phone || null,
            billing_street: (profile as any).billing_street || null,
            billing_street_number: (profile as any).billing_street_number || null,
            billing_postal_code: (profile as any).billing_postal_code || null,
            billing_city: (profile as any).billing_city || null,
            billing_province: (profile as any).billing_province || null,
            office_street: (profile as any).office_street || null,
            office_street_number: (profile as any).office_street_number || null,
            office_postal_code: (profile as any).office_postal_code || null,
            office_city: (profile as any).office_city || null,
            office_province: (profile as any).office_province || null,
            _synthetic: true,
          }];
          isReg = false;
        }
        setIsRegisteredBusiness(isReg);
        if (bizData) {
          setBusinesses(bizData);
          if (bizData.length > 0) setSelectedBusinessId(bizData[0].id);
          if (bizData.length > 0) {
            const ids = bizData.map((b: any) => b.id);
            if (isReg) {
              const { data: locs } = await supabase.from('registered_business_locations').select('*').in('business_id', ids);
              if (locs) setFullBusinessLocations(locs.map(l => ({ ...l, _table: 'registered_business_locations' })));
              const locIds = locs ? locs.map((l: any) => l.id) : [];
              // locs already set above
              if (locIds.length > 0) {
                const baseSelect = '*, customer:profiles!customer_id(full_name), responses:review_responses(*)';
                // Reviews linked via registered_business_location_id (new path)
                let q1 = supabase.from('reviews').select(baseSelect).in('registered_business_location_id', locIds).eq('review_status', 'approved').order('created_at', { ascending: false });
                // Reviews linked via business_location_id (legacy path)
                let q2 = supabase.from('reviews').select(baseSelect).in('business_location_id', locIds).eq('review_status', 'approved').order('created_at', { ascending: false });
                if (selectedBusinessLocationId) {
                  q1 = q1.eq('registered_business_location_id', selectedBusinessLocationId);
                  q2 = q2.eq('business_location_id', selectedBusinessLocationId);
                }
                const [{ data: rd1 }, { data: rd2 }] = await Promise.all([q1, q2]);
                const seen = new Set<string>();
                const combined = [...(rd1 || []), ...(rd2 || [])].filter(r => {
                  if (seen.has(r.id)) return false;
                  seen.add(r.id);
                  return true;
                }).sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
                setReviews(combined);
              }
            } else {
              let q = supabase.from('reviews').select('*, customer:profiles!customer_id(full_name), responses:review_responses(*), business_location:business_locations(address, city)').in('business_id', ids).eq('review_status', 'approved').order('created_at', { ascending: false });
              if (selectedBusinessLocationId) q = q.eq('business_location_id', selectedBusinessLocationId);
              const { data: rd } = await q;
              if (rd) setReviews(rd);
            }
            const [jpOld, jpNew] = await Promise.all([
              supabase.from('job_postings').select('*').in('business_id', ids).is('registered_business_id', null).then(r => r.data || []),
              supabase.from('job_postings').select('*').in('registered_business_id', ids).then(r => r.data || []),
            ]);
            let allJP = [...jpOld, ...jpNew];
            if (selectedBusinessLocationId) allJP = allJP.filter((jp: any) => jp.business_location_id === selectedBusinessLocationId || jp.registered_business_location_id === selectedBusinessLocationId);
            allJP.sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
            setJobPostings(allJP);
          }
        }
      } else {
        const { data: fm } = await supabase.from('customer_family_members').select('*').eq('customer_id', profile.id).order('created_at', { ascending: true });
        if (fm) setFamilyMembers(fm);
        const { data: rd } = await supabase.from('reviews').select(`
          *,
          business:businesses(name),
          unclaimed_business:unclaimed_business_locations!unclaimed_business_location_id(name),
          rbl:registered_business_locations!registered_business_location_id(name, rb:registered_businesses(name)),
          registered_business:registered_businesses!registered_business_id(name),
          family_member:customer_family_members(*)
        `).eq('customer_id', profile.id).order('created_at', { ascending: false });
        if (rd) setReviews(rd);
        const fmId = activeProfile?.isOwner === false ? activeProfile.id : null;
        const aq = supabase.from('user_activity').select('total_points, reviews_count').eq('user_id', profile.id);
        const { data: actData } = await (fmId ? aq.eq('family_member_id', fmId) : aq.is('family_member_id', null)).maybeSingle();
        const pts = actData?.total_points || 0;
        // Count owner rows (family_member_id IS NULL) with more points, excluding non-customer accounts
        const { count: ownerCount } = await supabase
          .from('user_activity')
          .select('user_id', { count: 'exact', head: true })
          .gt('total_points', pts)
          .is('family_member_id', null)
          .not('user_id', 'in', `(SELECT id FROM profiles WHERE user_type != 'customer')`);
        // Count family member rows with more points
        const { count: familyCount } = await supabase
          .from('user_activity')
          .select('family_member_id', { count: 'exact', head: true })
          .gt('total_points', pts)
          .not('family_member_id', 'is', null);
        setUserRank({ points: pts, rank: (ownerCount || 0) + (familyCount || 0) + 1, reviews_count: actData?.reviews_count || 0 });

        // Attività aggiunte: unclaimed businesses inseriti dall'utente (o membro famiglia attivo)
        const abSelect = 'id, name, city, province, created_at, approval_status, rejection_reason, phone, email, website, business_categories(name)';
        let abQuery = supabase.from('unclaimed_business_locations').select(abSelect).eq('added_by', profile.id).order('created_at', { ascending: false });
        if (fmId) {
          abQuery = supabase.from('unclaimed_business_locations').select(abSelect).eq('added_by', profile.id).eq('added_by_family_member_id', fmId).order('created_at', { ascending: false });
        } else {
          abQuery = supabase.from('unclaimed_business_locations').select(abSelect).eq('added_by', profile.id).is('added_by_family_member_id', null).order('created_at', { ascending: false });
        }
        const { data: ab } = await abQuery;
        if (ab) setAddedBusinesses(ab);

        // Profili cerco lavoro dell'utente (o membro famiglia attivo)
        let jsQuery = supabase.from('job_seekers').select('*, profiles(full_name, nickname)').eq('user_id', profile.id).order('created_at', { ascending: false });
        if (fmId) jsQuery = jsQuery.eq('family_member_id', fmId);
        else jsQuery = jsQuery.is('family_member_id', null);
        const { data: myJs } = await jsQuery;
        if (myJs) setMyJobSeekers(myJs);

        // Conteggio aste dell'utente (incluse pending)
        {
          let aqQuery = supabase.from('auctions').select('id', { count: 'exact', head: true }).eq('user_id', profile.id);
          if (fmId) aqQuery = aqQuery.eq('family_member_id', fmId);
          else aqQuery = aqQuery.is('family_member_id', null);
          const { count: aCount } = await aqQuery;
          setMyAuctionsCount(aCount || 0);
        }

        // Profilo professionale (owner o membro famiglia attivo)
        {
          let ppQuery = supabase.from('professional_profiles').select('*').eq('user_id', profile.id);
          if (fmId) ppQuery = ppQuery.eq('family_member_id', fmId);
          else ppQuery = ppQuery.is('family_member_id', null);
          const { data: pp } = await ppQuery.maybeSingle();
          setProfessionalProfile(pp || null);
          setProfessionalProfileLoaded(true);
        }
      }
      await loadAds();
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  const loadSubscription = async () => {
    if (!profile) return;
    const { data } = await supabase.from('subscriptions').select('id, status, start_date, end_date, trial_end_date, plan:subscription_plans(id, name, price, billing_period, max_persons)').eq('customer_id', profile.id).in('status', ['active', 'trial']).order('created_at', { ascending: false });
    if (data && data.length > 0) setCurrentSubscription(data[0] as any);
    const plansQ = profile.user_type === 'business'
      ? supabase.from('subscription_plans').select('*').like('name', '%Business%').order('billing_period').order('max_persons')
      : supabase.from('subscription_plans').select('*').not('name', 'like', '%Business%').order('max_persons').order('billing_period');
    const { data: plans } = await plansQ;
    if (plans) setAvailablePlans(plans);
  };

  const handleChangePlan = async (planId: string) => {
    if (!profile || !currentSubscription) return;
    setUpgradeMessage('');
    try {
      const plan = availablePlans.find(p => p.id === planId);
      if (!plan) throw new Error('Piano non trovato');
      const end = new Date();
      plan.billing_period === 'monthly' ? end.setMonth(end.getMonth() + 1) : end.setFullYear(end.getFullYear() + 1);
      await supabase.from('subscriptions').update({ plan_id: planId, end_date: end.toISOString(), status: 'active' }).eq('id', currentSubscription.id);
      await supabase.from('profiles').update({ subscription_type: plan.billing_period === 'monthly' ? 'monthly' : 'annual', subscription_status: 'active', subscription_expires_at: end.toISOString() }).eq('id', profile.id);
      setUpgradeMessage('Piano aggiornato con successo!');
      setTimeout(() => window.location.reload(), 1500);
    } catch (e) {
      setUpgradeMessage('Errore durante il cambio del piano');
    }
  };

  if (!profile) return <div className="min-h-screen bg-gray-50 flex items-center justify-center"><p className="text-gray-600">Caricamento profilo...</p></div>;

  if (profile.subscription_status !== 'active' && profile.subscription_status !== 'trial') {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center bg-white p-8 rounded-2xl shadow-lg max-w-md">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Abbonamento Necessario</h2>
          <p className="text-gray-600 mb-4">Per accedere alla dashboard attiva un abbonamento.</p>
          <p className="text-sm text-gray-400 mb-6">Stato: {profile.subscription_status || 'nessuno'}</p>
          <a href="/subscription" className="inline-block bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 transition-colors">Vedi Piani</a>
        </div>
      </div>
    );
  }

  const isBiz = profile.user_type === 'business';
  const displayName = activeProfile ? (activeProfile.nickname || activeProfile.name.split(' ')[0]) : (profile.full_name?.split(' ')[0] || 'Utente');

  // Single-location businesses don't need the location switch and always see all sections
  const isSingleLocation = isBiz && fullBusinessLocations.length <= 1;

  // Free plan: only search + limited dashboard sections
  const isFreePlan = currentSubscription?.plan?.price === 0;
  const bizAllowedKeys = isFreePlan ? new Set(['biz_dati', 'biz_reviews', 'biz_plans']) : null;
  const custAllowedKeys = isFreePlan ? new Set(['cust_reviews', 'cust_plans']) : null;

  // ── sections config ────────────────────────────────────────────────────────
  const bizBadges = [
    ...(isSingleLocation || !selectedBusinessLocationId ? [{ key: 'biz_dati', label: 'I Tuoi Dati', icon: User, color: 'slate', badge: null }] : []),
    { key: 'biz_ads',       label: 'I Miei Annunci',        icon: Tag,      color: 'green',   badge: businessClassifiedAds.length > 0 ? String(businessClassifiedAds.length) : null },
    { key: 'biz_jobs',      label: 'Offerte di Lavoro',     icon: Briefcase,color: 'blue',    badge: jobPostings.length > 0 ? String(jobPostings.length) : null },
    { key: 'biz_reviews',   label: 'Recensioni Ricevute',   icon: Star,     color: 'amber',   badge: reviews.length > 0 ? String(reviews.length) : null },
    { key: 'biz_auctions',  label: 'Le Mie Aste',           icon: Gavel,    color: 'orange',  badge: null },
    { key: 'biz_favorites', label: 'Preferiti',             icon: Heart,    color: 'red',     badge: null },
    ...(currentSubscription && availablePlans.length > 0 && (isSingleLocation || !selectedBusinessLocationId) ? [{ key: 'biz_plans', label: 'Cambia Piano', icon: Shield, color: 'slate', badge: currentSubscription.plan.name }] : []),
  ].filter(b => !bizAllowedKeys || bizAllowedKeys.has(b.key));

  const isOwnerProfile = !activeProfile || activeProfile.isOwner === true;

  const custBadges = [
    ...(isOwnerProfile ? [{ key: 'cust_dati', label: 'I Tuoi Dati', icon: User, color: 'slate', badge: null }] : []),
    { key: 'cust_prof', label: 'Profilo Professionale', icon: Briefcase, color: 'blue', badge: professionalProfile ? 'Attivo' : null },
    { key: 'cust_leaderboard', label: 'La Tua Classifica',      icon: Trophy,   color: 'yellow', badge: userRank ? `#${userRank.rank}` : null },
    { key: 'cust_activities',  label: 'Attivita Aggiunte',       icon: Activity, color: 'blue',   badge: addedBusinesses.length > 0 ? String(addedBusinesses.length) : null },
    { key: 'cust_jobs',        label: 'Annunci Cerco Lavoro',    icon: Briefcase,color: 'sky',    badge: myJobSeekers.length > 0 ? String(myJobSeekers.length) : null },
    { key: 'cust_reviews',     label: 'Le Tue Recensioni',       icon: Star,     color: 'amber',  badge: (() => { const fmId = activeProfile?.isOwner === false ? activeProfile.id : null; const mine = reviews.filter(r => fmId ? r.family_member_id === fmId : !r.family_member_id); return mine.length > 0 ? String(mine.length) : null; })() },
    { key: 'cust_ads',         label: 'I Tuoi Annunci',          icon: Tag,      color: 'green',  badge: customerClassifiedAds.length > 0 ? String(customerClassifiedAds.length) : null },
    { key: 'cust_auctions',    label: 'Le Mie Aste',             icon: Gavel,    color: 'orange', badge: myAuctionsCount > 0 ? String(myAuctionsCount) : null },
    { key: 'cust_fav_ads',     label: 'Annunci Preferiti',       icon: Heart,    color: 'red',    badge: null },
    { key: 'cust_fav_biz',     label: 'Attivita Preferite',      icon: Building, color: 'rose',   badge: favBusinessesCount > 0 ? String(favBusinessesCount) : null },
    ...(isOwnerProfile && currentSubscription && availablePlans.length > 0 ? [{ key: 'cust_plans', label: 'Cambia Piano', icon: Shield, color: 'slate', badge: currentSubscription.plan.name }] : []),
  ].filter(b => !custAllowedKeys || custAllowedKeys.has(b.key));

  return (
    <div className="min-h-screen bg-gray-50">
<TrialExpirationModal />
      {customization?.announcement_active && customization.announcement_text && (
        <div className="bg-slate-800 text-white text-sm font-medium text-center py-2 px-4">
          {customization.announcement_text}
        </div>
      )}

      {/* PIN Modal */}
      {showPinModal && profile && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden">
            <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-slate-100 rounded-xl flex items-center justify-center">
                  <Lock className="w-4 h-4 text-slate-600" />
                </div>
                <div>
                  <h2 className="font-bold text-gray-900 text-sm">PIN di Protezione</h2>
                  <p className="text-xs text-gray-400">Proteggi il tuo profilo con un PIN</p>
                </div>
              </div>
              <button onClick={() => setShowPinModal(false)} className="p-2 rounded-lg hover:bg-gray-100 transition-colors">
                <X className="w-4 h-4 text-gray-400" />
              </button>
            </div>
            <div className="p-5">
              <PinSetup
                profileId={activeProfile ? activeProfile.id : profile.id}
                profileName={displayName}
                isOwner={!activeProfile || activeProfile.isOwner}
                userType={profile.user_type as 'customer' | 'business'}
                onSuccess={() => setShowPinModal(false)}
              />
            </div>
          </div>
        </div>
      )}

      {/* Hero */}
      <section className="bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 border-b border-slate-700">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
            <div>
              <div className="inline-flex items-center gap-2 bg-white/10 text-white/80 text-xs font-semibold px-3 py-1.5 rounded-full mb-4 backdrop-blur">
                <div className="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-pulse" />
                {isBiz ? 'Account Business' : 'Account Privato'}
              </div>
              <div className="flex items-center gap-4 mb-1 flex-wrap">
                {/* Avatar upload — titolare */}
                {profile && (!activeProfile || activeProfile.isOwner) && (
                  <div className="relative flex-shrink-0">
                    <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-white/30 bg-slate-700 flex items-center justify-center">
                      {localAvatarUrl ? (
                        <img src={localAvatarUrl} alt={displayName} className="w-full h-full object-cover" />
                      ) : (
                        <span className="text-2xl font-bold text-white/70">
                          {displayName.charAt(0).toUpperCase()}
                        </span>
                      )}
                    </div>
                    <label
                      htmlFor="dashboard-avatar-upload"
                      className="absolute -bottom-1 -right-1 w-6 h-6 bg-blue-500 hover:bg-blue-400 rounded-full flex items-center justify-center cursor-pointer border-2 border-slate-800 transition-colors"
                      title="Cambia foto profilo"
                    >
                      <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      <input
                        id="dashboard-avatar-upload"
                        type="file"
                        accept="image/*"
                        className="sr-only"
                        onChange={async (e) => {
                          const file = e.target.files?.[0];
                          if (!file || !profile) return;
                          if (file.size > 5 * 1024 * 1024) { showToast('Immagine troppo grande (max 5MB)', 'error'); return; }
                          try {
                            const ext = file.name.split('.').pop();
                            const path = `${profile.id}/avatar.${ext}`;
                            const { error: upErr } = await supabase.storage.from('avatars').upload(path, file, { upsert: true });
                            if (upErr) throw upErr;
                            const { data: { publicUrl } } = supabase.storage.from('avatars').getPublicUrl(path);
                            const url = `${publicUrl}?t=${Date.now()}`;
                            await supabase.from('profiles').update({ avatar_url: url }).eq('id', profile.id);
                            setLocalAvatarUrl(url);
                            showToast('Foto profilo aggiornata!', 'success');
                          } catch { showToast('Errore durante il caricamento', 'error'); }
                          e.target.value = '';
                        }}
                      />
                    </label>
                  </div>
                )}
                {/* Avatar upload — membro famiglia attivo */}
                {profile && activeProfile && !activeProfile.isOwner && !isBiz && (() => {
                  const activeFm = familyMembers.find(fm => fm.id === activeProfile.id);
                  if (!activeFm) return null;
                  const currentAvatar = memberAvatars[activeFm.id] || activeFm.avatar_url;
                  return (
                    <div className="relative flex-shrink-0">
                      <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-white/30 bg-slate-700 flex items-center justify-center">
                        {currentAvatar ? (
                          <img src={currentAvatar} alt={displayName} className="w-full h-full object-cover" />
                        ) : (
                          <span className="text-2xl font-bold text-white/70">
                            {displayName.charAt(0).toUpperCase()}
                          </span>
                        )}
                      </div>
                      <label
                        htmlFor={`dashboard-fm-avatar-${activeFm.id}`}
                        className="absolute -bottom-1 -right-1 w-6 h-6 bg-blue-500 hover:bg-blue-400 rounded-full flex items-center justify-center cursor-pointer border-2 border-slate-800 transition-colors"
                        title="Cambia foto profilo"
                      >
                        <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <input
                          id={`dashboard-fm-avatar-${activeFm.id}`}
                          type="file"
                          accept="image/*"
                          className="sr-only"
                          onChange={async (e) => {
                            const file = e.target.files?.[0];
                            if (!file) return;
                            if (file.size > 5 * 1024 * 1024) { showToast('Immagine troppo grande (max 5MB)', 'error'); return; }
                            try {
                              const ext = file.name.split('.').pop();
                              const path = `family/${activeFm.id}/avatar.${ext}`;
                              const { error: upErr } = await supabase.storage.from('avatars').upload(path, file, { upsert: true });
                              if (upErr) throw upErr;
                              const { data: { publicUrl } } = supabase.storage.from('avatars').getPublicUrl(path);
                              const url = `${publicUrl}?t=${Date.now()}`;
                              await supabase.from('customer_family_members').update({ avatar_url: url }).eq('id', activeFm.id);
                              setMemberAvatars(prev => ({ ...prev, [activeFm.id]: url }));
                              updateFamilyMemberAvatar(activeFm.id, url);
                              showToast('Foto aggiornata!', 'success');
                            } catch { showToast('Errore durante il caricamento', 'error'); }
                            e.target.value = '';
                          }}
                        />
                      </label>
                    </div>
                  );
                })()}
                {/* Avatar upload — sede business attiva */}
                {profile && isBiz && activeProfile && !activeProfile.isOwner && (() => {
                  const activeLoc = fullBusinessLocations.find(l => l.id === activeProfile.id);
                  if (!activeLoc) return null;
                  const currentAvatar = locationAvatars[activeLoc.id] || activeLoc.avatar_url;
                  const locTable = (activeLoc._table || 'registered_business_locations') as 'registered_business_locations' | 'business_locations';
                  return (
                    <div className="relative flex-shrink-0">
                      <div className="w-16 h-16 rounded-full overflow-hidden border-2 border-white/30 bg-slate-700 flex items-center justify-center">
                        {currentAvatar ? (
                          <img src={currentAvatar} alt={displayName} className="w-full h-full object-cover" />
                        ) : (
                          <span className="text-2xl font-bold text-white/70">
                            {displayName.charAt(0).toUpperCase()}
                          </span>
                        )}
                      </div>
                      <label
                        htmlFor={`dashboard-loc-avatar-${activeLoc.id}`}
                        className="absolute -bottom-1 -right-1 w-6 h-6 bg-blue-500 hover:bg-blue-400 rounded-full flex items-center justify-center cursor-pointer border-2 border-slate-800 transition-colors"
                        title="Cambia foto sede"
                      >
                        <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <input
                          id={`dashboard-loc-avatar-${activeLoc.id}`}
                          type="file"
                          accept="image/*"
                          className="sr-only"
                          onChange={async (e) => {
                            const file = e.target.files?.[0];
                            if (!file) return;
                            if (file.size > 5 * 1024 * 1024) { showToast('Immagine troppo grande (max 5MB)', 'error'); return; }
                            try {
                              const ext = file.name.split('.').pop();
                              const path = `locations/${activeLoc.id}/avatar.${ext}`;
                              const { error: upErr } = await supabase.storage.from('avatars').upload(path, file, { upsert: true });
                              if (upErr) throw upErr;
                              const { data: { publicUrl } } = supabase.storage.from('avatars').getPublicUrl(path);
                              const url = `${publicUrl}?t=${Date.now()}`;
                              await supabase.from(locTable).update({ avatar_url: url }).eq('id', activeLoc.id);
                              setLocationAvatars(prev => ({ ...prev, [activeLoc.id]: url }));
                              showToast('Foto sede aggiornata!', 'success');
                            } catch { showToast('Errore durante il caricamento', 'error'); }
                            e.target.value = '';
                          }}
                        />
                      </label>
                    </div>
                  );
                })()}
                <h1 className="text-3xl md:text-4xl font-bold text-white leading-tight">Ciao, {displayName}</h1>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setShowPinModal(true)}
                    className="flex items-center gap-1.5 bg-white/10 hover:bg-white/20 border border-white/20 text-white/80 hover:text-white text-xs font-semibold px-3 py-1.5 rounded-full transition-all backdrop-blur"
                    title="Imposta PIN di protezione"
                  >
                    <Lock className="w-3.5 h-3.5" />PIN
                  </button>
                  <button
                    onClick={async () => { try { await signOut(); } catch {} }}
                    className="flex items-center gap-1.5 bg-white/10 hover:bg-red-500/30 border border-white/20 hover:border-red-400/40 text-white/80 hover:text-red-200 text-xs font-semibold px-3 py-1.5 rounded-full transition-all backdrop-blur"
                    title="Esci dall'account"
                  >
                    <LogOut className="w-3.5 h-3.5" />Esci
                  </button>
                </div>
              </div>
              <p className="text-slate-400 text-base">{isBiz ? 'Gestisci la tua attivita e le sedi' : 'Gestisci il tuo profilo e le attivita'}</p>
            </div>
            {currentSubscription && (
              <div className="bg-white/10 backdrop-blur border border-white/20 rounded-2xl px-5 py-4 flex items-center gap-4">
                <div>
                  <p className="text-xs text-slate-400 mb-0.5">Piano Attivo</p>
                  <p className="text-base font-bold text-white">{currentSubscription.plan.name}</p>
                  <p className="text-xs text-slate-400">{currentSubscription.plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}</p>
                </div>
                {currentSubscription.status === 'trial' && (
                  <span className="inline-flex items-center gap-1.5 text-xs font-semibold text-emerald-300 bg-emerald-500/20 border border-emerald-500/30 px-2.5 py-1 rounded-full">
                    <div className="w-1 h-1 bg-emerald-400 rounded-full animate-pulse" />Prova gratuita
                  </span>
                )}
              </div>
            )}
          </div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {isBiz && <TrialStatusBanner onUpgradeClick={() => navigate('/subscription')} />}

        {isFreePlan && (
          <div className="mb-4 bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 rounded-2xl p-5 flex items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-amber-100 rounded-xl flex items-center justify-center flex-shrink-0">
                <Lock className="w-5 h-5 text-amber-600" />
              </div>
              <div>
                <p className="text-sm font-bold text-amber-900">Piano Gratuito</p>
                <p className="text-xs text-amber-700">
                  {isBiz
                    ? 'Puoi cercare attività, leggere recensioni e modificare la tua scheda. Passa a un piano a pagamento per annunci, offerte di lavoro, aste e altro.'
                    : 'Puoi cercare attività e leggere/scrivere recensioni. Passa a un piano a pagamento per annunci, aste, classifica e altro.'}
                </p>
              </div>
            </div>
            <button onClick={() => navigate('/subscription')} className="bg-amber-600 hover:bg-amber-700 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-colors flex-shrink-0">
              Upgrade
            </button>
          </div>
        )}

        {loading ? (
          <div className="animate-pulse space-y-4 py-4" aria-busy="true" aria-label="Caricamento dashboard">
            <div className="h-8 bg-gray-200 rounded w-1/3"></div>
            <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {[...Array(6)].map((_, i) => (
                <div key={i} className="h-28 bg-gray-200 rounded-xl"></div>
              ))}
            </div>
            <div className="h-64 bg-gray-200 rounded-xl"></div>
            <div className="h-48 bg-gray-200 rounded-xl"></div>
          </div>
        ) : (
          <div className="space-y-4">

            {/* ── BUSINESS ── */}
            {isBiz ? (
              <>
                {/* Stats bar — visible for single-location or when a specific location is selected */}
                {(isSingleLocation || selectedBusinessLocationId) && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
                    <div className="grid grid-cols-2 gap-3">
                      <div className="text-center"><p className="text-2xl font-bold text-yellow-600">{reviews.length}</p><p className="text-xs text-gray-500 mt-0.5 flex items-center justify-center gap-1"><Star className="w-3 h-3" />Recensioni</p></div>
                      <div className="text-center border-l border-gray-100"><p className="text-2xl font-bold text-orange-600">{jobPostings.length}</p><p className="text-xs text-gray-500 mt-0.5 flex items-center justify-center gap-1"><Briefcase className="w-3 h-3" />Offerte</p></div>
                    </div>
                  </div>
                )}

                {/* Badge row */}
                <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
                  <div className="flex flex-wrap gap-2">
                    {bizBadges.map(b => (
                      <BadgeBtn key={b.key} id={b.key} label={b.label} icon={b.icon} color={b.color} badge={b.badge} active={!!open[b.key]} onClick={() => toggle(b.key)} />
                    ))}
                  </div>
                </div>

                {/* I Tuoi Dati - Business */}
                {open.biz_dati && (
                  <>
                    <ProfileDataSection
                      profile={profile}
                      isBiz={true}
                      registeredBusiness={isRegisteredBusiness && businesses[0] ? businesses[0] : undefined}
                      businessLocations={fullBusinessLocations}
                      editing={editingProfile}
                      form={profileForm}
                      saving={profileSaving}
                      saveMsg={profileSaveMsg}
                      onEdit={startEditProfile}
                      onCancel={() => setEditingProfile(false)}
                      onSave={saveProfile}
                      onChange={(k, v) => setProfileForm(prev => ({ ...prev, [k]: v }))}
                      onLocationSave={saveBusinessLocation}
                      memberAvatars={memberAvatars}
                      locationAvatars={locationAvatars}
                      onMemberAvatarChange={(id, url) => setMemberAvatars(prev => ({ ...prev, [id]: url }))}
                      onLocationAvatarChange={(id, url) => setLocationAvatars(prev => ({ ...prev, [id]: url }))}
                      uploadAvatar={uploadAvatar}
                      showToast={showToast}
                    />
                    <DeleteAccountButton onAccountDeleted={() => signOut()} />
                  </>
                )}

                {/* I Miei Annunci */}
                {open.biz_ads && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center"><Tag className="w-4 h-4 text-green-600" /></div>
                        <span className="font-semibold text-gray-900">I Miei Annunci</span>
                        {businessClassifiedAds.length > 0 && <span className="bg-green-100 text-green-700 text-xs font-bold px-2 py-0.5 rounded-full">{businessClassifiedAds.length}</span>}
                      </div>
                      <button onClick={() => { setEditingClassifiedAdId(undefined); setShowClassifiedAdForm(true); }} className="bg-green-600 hover:bg-green-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"><Plus className="w-3 h-3" />Nuovo</button>
                    </div>
                    <div className="px-5 pb-5">
                      {businessClassifiedAds.length === 0 ? (
                        <div className="text-center py-8">
                          <Tag className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-3">Nessun annuncio pubblicato</p>
                          <button onClick={() => { setEditingClassifiedAdId(undefined); setShowClassifiedAdForm(true); }} className="inline-flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-xl hover:bg-green-700 text-sm font-semibold"><Plus className="w-4 h-4" />Crea annuncio</button>
                        </div>
                      ) : (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pt-4">
                          {businessClassifiedAds.map(ad => (
                            <ProfileClassifiedAdCard key={ad.id} ad={{ ...ad, price: ad.price ? parseFloat(ad.price) : null, classified_categories: ad.classified_categories, profiles: { full_name: profile?.nickname || profile?.full_name || 'Utente', avatar_url: null } }} onEdit={(a) => { setEditingClassifiedAdId(a.id); setShowClassifiedAdForm(true); }} onDelete={deleteAd} />
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Offerte di Lavoro */}
                {open.biz_jobs && !loading && (selectedBusinessId || businesses[0]?.id) && (
                  <BusinessJobPostingForm key={`${selectedBusinessId || businesses[0]?.id}-${selectedBusinessLocationId || 'all'}`} businessId={(selectedBusinessId || businesses[0]?.id)!} isRegisteredBusiness={isRegisteredBusiness} selectedLocationId={selectedBusinessLocationId || undefined} />
                )}

                {/* Recensioni Ricevute */}
                {open.biz_reviews && (
                  <div id="biz_reviews" className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center"><Star className="w-4 h-4 text-amber-600" /></div>
                      <span className="font-semibold text-gray-900">{selectedBusinessLocationId ? 'Recensioni Sede' : 'Recensioni Ricevute'}</span>
                      {reviews.length > 0 && <span className="bg-amber-100 text-amber-700 text-xs font-bold px-2 py-0.5 rounded-full">{reviews.length}</span>}
                    </div>
                    <div className="px-5 pb-5">
                      {reviews.length === 0 ? (
                        <p className="text-gray-500 text-sm text-center py-6">Nessuna recensione</p>
                      ) : (
                        <div className="space-y-4 pt-4">
                          {reviews.map((review) => (
                            <div key={review.id}>
                              <ReviewCard review={review as any} hideProof={true} />
                              {(!review.responses || review.responses.length === 0) && (
                                <div className="mt-1 flex justify-end">
                                  <button onClick={() => setShowResponseForm(review.id)} className="text-blue-600 text-xs hover:text-blue-700 flex items-center gap-1"><MessageSquare className="w-3.5 h-3.5" />Rispondi</button>
                                </div>
                              )}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Le Mie Aste */}
                {open.biz_auctions && <UserAuctionsSection />}

                {/* Preferiti */}
                {open.biz_favorites && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center"><Heart className="w-4 h-4 text-red-500" /></div>
                      <span className="font-semibold text-gray-900">Preferiti</span>
                    </div>
                    <FavoritesSection />
                  </div>
                )}

                {/* Le Mie Attivita */}
                {/* Profili Cerco Lavoro */}
                {/* Cambia Piano Business */}
                {open.biz_plans && currentSubscription && availablePlans.length > 0 && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-slate-100 rounded-lg flex items-center justify-center"><Shield className="w-4 h-4 text-slate-600" /></div>
                      <span className="font-semibold text-gray-900">Cambia Piano</span>
                      <span className="bg-slate-100 text-slate-600 text-xs font-bold px-2 py-0.5 rounded-full">{currentSubscription.plan.name}</span>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {upgradeMessage && <div className={`mb-4 p-3 rounded-xl text-sm ${upgradeMessage.includes('successo') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>{upgradeMessage}</div>}
                      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-3">
                        {availablePlans.map((plan) => {
                          const monthly = availablePlans.find(p => p.max_persons === plan.max_persons && p.billing_period === 'monthly');
                          const savings = plan.billing_period === 'yearly' && monthly ? (monthly.price * 12) - plan.price : null;
                          const isCurrent = currentSubscription.plan.id === plan.id;
                          return (
                            <div key={plan.id} className={`rounded-xl p-4 border-2 relative ${isCurrent ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-blue-300'}`}>
                              {plan.billing_period === 'yearly' && !isCurrent && <span className="absolute -top-2.5 left-1/2 -translate-x-1/2 bg-green-500 text-white text-xs font-bold px-2.5 py-0.5 rounded-full">RISPARMIO</span>}
                              <h3 className="font-bold text-gray-900 text-sm mb-0.5">{plan.name}</h3>
                              <p className="text-xs text-gray-500 mb-2">{plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'} · {plan.max_persons} {plan.max_persons === 1 ? 'sede' : 'sedi'}</p>
                              <p className="text-xl font-bold text-blue-600 mb-0.5">€{Number(plan.price).toFixed(2)}</p>
                              <p className="text-xs text-gray-400 mb-2">+ IVA / {plan.billing_period === 'monthly' ? 'mese' : 'anno'}</p>
                              {savings && <p className="text-xs text-green-600 font-semibold mb-2">Risparmi €{savings.toFixed(2)}</p>}
                              {isCurrent ? <div className="w-full bg-blue-600 text-white py-1.5 rounded-lg text-xs font-semibold text-center">Piano Attuale</div> : <button onClick={() => handleChangePlan(plan.id)} className="w-full bg-gray-800 hover:bg-gray-900 text-white py-1.5 rounded-lg text-xs font-semibold transition-colors">Scegli Piano</button>}
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  </div>
                )}
              </>
            ) : (
              /* ── PRIVATO ── */
              <>
                {/* Badge row */}
                <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
                  <div className="flex flex-wrap gap-2">
                    {custBadges.map(b => (
                      <BadgeBtn key={b.key} id={b.key} label={b.label} icon={b.icon} color={b.color} badge={b.badge} active={!!open[b.key]} onClick={() => toggle(b.key)} />
                    ))}
                  </div>
                </div>

                {/* I Tuoi Dati - Customer */}
                {open.cust_dati && (
                  <>
                    <ProfileDataSection
                      profile={profile}
                      isBiz={false}
                      familyMembers={familyMembers}
                      editing={editingProfile}
                      form={profileForm}
                      saving={profileSaving}
                      saveMsg={profileSaveMsg}
                      onEdit={startEditProfile}
                      onCancel={() => setEditingProfile(false)}
                      onSave={saveProfile}
                      onChange={(k, v) => setProfileForm(prev => ({ ...prev, [k]: v }))}
                      onFamilyMemberSave={saveFamilyMember}
                      memberAvatars={memberAvatars}
                      locationAvatars={locationAvatars}
                      onMemberAvatarChange={(id, url) => setMemberAvatars(prev => ({ ...prev, [id]: url }))}
                      onLocationAvatarChange={(id, url) => setLocationAvatars(prev => ({ ...prev, [id]: url }))}
                      uploadAvatar={uploadAvatar}
                      showToast={showToast}
                    />
                    <DeleteAccountButton onAccountDeleted={() => signOut()} />
                  </>
                )}

                {/* Classifica */}
                {open.cust_leaderboard && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-yellow-100 rounded-lg flex items-center justify-center"><Trophy className="w-4 h-4 text-yellow-600" /></div>
                      <span className="font-semibold text-gray-900">La Tua Classifica</span>
                      {userRank && <span className="bg-yellow-100 text-yellow-700 text-xs font-bold px-2 py-0.5 rounded-full">#{userRank.rank} · {userRank.points} pt</span>}
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {userRank && (
                        <div className="bg-gradient-to-br from-yellow-50 to-orange-50 border border-yellow-200 rounded-xl p-4 mb-4">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-3">
                              <div className={`w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg shadow ${userRank.rank <= 3 ? 'bg-gradient-to-br from-yellow-400 to-amber-500 text-white' : 'bg-gradient-to-br from-blue-400 to-blue-500 text-white'}`}>#{userRank.rank}</div>
                              <div><p className="text-xs text-gray-500">La tua posizione</p><p className="font-bold text-gray-900">{activeProfile?.isOwner === false ? activeProfile.name : profile?.nickname || profile?.full_name}</p></div>
                            </div>
                            <div className="text-right"><p className="text-2xl font-bold text-gray-900">{userRank.points}</p><p className="text-xs text-gray-500">punti · {userRank.reviews_count} rec.</p></div>
                          </div>
                        </div>
                      )}
                      <div className="border-t border-gray-100 mt-4 pt-4">
                        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Storico Attivita</p>
                        <ActivityFeed />
                      </div>
                      <button onClick={() => navigate('/leaderboard')} className="w-full bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-4 py-2.5 rounded-xl hover:from-yellow-600 hover:to-orange-600 transition-all font-semibold text-sm text-center mt-3">Classifica Completa</button>
                    </div>
                  </div>
                )}

                {/* Attivita aggiunte */}
                {open.cust_activities && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center"><Activity className="w-4 h-4 text-blue-600" /></div>
                        <span className="font-semibold text-gray-900">Attivita Aggiunte</span>
                        {addedBusinesses.length > 0 && <span className="bg-blue-100 text-blue-700 text-xs font-bold px-2 py-0.5 rounded-full">{addedBusinesses.length}</span>}
                      </div>
                      <button onClick={() => setShowCreateBusinessForm(true)} className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1 transition-colors">
                        <Plus className="w-3 h-3" />Aggiungi
                      </button>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {addedBusinesses.length === 0 ? (
                        <div className="text-center py-8">
                          <Building className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-1">Non hai ancora aggiunto attivita.</p>
                          <p className="text-xs text-gray-400">Guadagna 10 o 25 punti per ogni attivita approvata.</p>
                        </div>
                      ) : (
                        <div className="space-y-2">
                          {addedBusinesses.map((biz: any) => {
                            const status = biz.approval_status;
                            const hasContact = !!(biz.phone || biz.email || biz.website);
                            return (
                              <div key={biz.id} className="p-3 border border-gray-100 rounded-xl hover:bg-gray-50 transition-colors">
                                <div className="flex items-start justify-between gap-2">
                                  <div className="flex items-center gap-3 min-w-0">
                                    <div className="w-9 h-9 bg-blue-100 rounded-xl flex items-center justify-center flex-shrink-0">
                                      <Building className="w-4 h-4 text-blue-600" />
                                    </div>
                                    <div className="min-w-0">
                                      <p className="text-sm font-semibold text-gray-900 truncate">{biz.name}</p>
                                      <p className="text-xs text-gray-400">{biz.city}{biz.province ? ` (${biz.province})` : ''}{biz.business_categories?.name ? ` · ${biz.business_categories.name}` : ''}</p>
                                    </div>
                                  </div>
                                  <div className="flex-shrink-0">
                                    {status === 'pending' && (
                                      <span className="inline-flex items-center gap-1 text-xs font-semibold bg-yellow-100 text-yellow-700 px-2 py-1 rounded-full">
                                        <span className="w-1.5 h-1.5 bg-yellow-500 rounded-full animate-pulse" />In attesa
                                      </span>
                                    )}
                                    {status === 'approved' && (
                                      <span className="inline-flex items-center gap-1 text-xs font-semibold bg-green-100 text-green-700 px-2 py-1 rounded-full">
                                        <Check className="w-3 h-3" />{hasContact ? '25 pt' : '10 pt'}
                                      </span>
                                    )}
                                    {status === 'rejected' && (
                                      <span className="inline-flex items-center gap-1 text-xs font-semibold bg-red-100 text-red-700 px-2 py-1 rounded-full">
                                        <X className="w-3 h-3" />Rifiutata
                                      </span>
                                    )}
                                  </div>
                                </div>
                                {status === 'rejected' && biz.rejection_reason && (
                                  <p className="text-xs text-red-600 mt-2 bg-red-50 px-2 py-1 rounded-lg">{biz.rejection_reason}</p>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Profilo Professionale */}
                {open.cust_prof && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center"><Briefcase className="w-4 h-4 text-blue-600" /></div>
                        <span className="font-semibold text-gray-900">Profilo Professionale</span>
                        {professionalProfile && <span className="bg-green-100 text-green-700 text-xs font-bold px-2 py-0.5 rounded-full">Attivo</span>}
                      </div>
                      {professionalProfile && !showProfessionalProfileForm && (
                        <button
                          onClick={() => setShowProfessionalProfileForm(true)}
                          className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"
                        >
                          <Pencil className="w-3 h-3" />Modifica
                        </button>
                      )}
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {showProfessionalProfileForm ? (
                        <ProfessionalProfileForm
                          existingProfile={professionalProfile}
                          familyMemberId={activeProfile?.isOwner === false ? activeProfile.id : null}
                          familyMemberName={activeProfile?.isOwner === false ? (activeProfile as any).nickname || (activeProfile as any).name : undefined}
                          onSaved={(saved) => {
                            setProfessionalProfile(saved);
                            setShowProfessionalProfileForm(false);
                          }}
                          onCancel={() => setShowProfessionalProfileForm(false)}
                        />
                      ) : professionalProfile ? (
                        <div className="space-y-4">
                          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <div className="bg-gray-50 rounded-xl px-4 py-3">
                              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Professione</p>
                              <p className="text-sm font-semibold text-gray-900">{professionalProfile.profession}</p>
                            </div>
                            <div className="bg-gray-50 rounded-xl px-4 py-3">
                              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Esperienza</p>
                              <p className="text-sm font-semibold text-gray-900">{professionalProfile.experience_years} {professionalProfile.experience_years === 1 ? 'anno' : 'anni'}</p>
                            </div>
                            {(professionalProfile.city || professionalProfile.region) && (
                              <div className="bg-gray-50 rounded-xl px-4 py-3">
                                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">Localita</p>
                                <p className="text-sm font-semibold text-gray-900">{[professionalProfile.city, professionalProfile.province, professionalProfile.region].filter(Boolean).join(', ')}</p>
                              </div>
                            )}
                          </div>
                          {professionalProfile.summary && (
                            <div>
                              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Descrizione</p>
                              <p className="text-sm text-gray-700 leading-relaxed">{professionalProfile.summary}</p>
                            </div>
                          )}
                          {professionalProfile.skills?.length > 0 && (
                            <div>
                              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Competenze</p>
                              <div className="flex flex-wrap gap-2">
                                {professionalProfile.skills.map((s: string) => (
                                  <span key={s} className="px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-100">{s}</span>
                                ))}
                              </div>
                            </div>
                          )}
                          <div className="pt-2 border-t border-gray-100">
                            <p className="text-xs text-gray-400">Visibile solo agli account business. Gli utenti business possono visualizzare il tuo profilo cliccando il tuo nome negli annunci cerco lavoro.</p>
                          </div>
                        </div>
                      ) : (
                        <div className="text-center py-8">
                          <Briefcase className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-1 font-medium">Nessun profilo professionale</p>
                          <p className="text-xs text-gray-400 mb-4 max-w-xs mx-auto">Il profilo e facoltativo, ma e richiesto per pubblicare annunci "Cerco Lavoro". Visibile solo agli utenti business.</p>
                          <button
                            onClick={() => setShowProfessionalProfileForm(true)}
                            className="bg-blue-600 text-white px-4 py-2 rounded-xl hover:bg-blue-700 transition-colors text-sm font-semibold"
                          >
                            Crea Profilo Professionale
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Cerco Lavoro */}
                {open.cust_jobs && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-sky-100 rounded-lg flex items-center justify-center"><Briefcase className="w-4 h-4 text-sky-600" /></div>
                        <span className="font-semibold text-gray-900">Annunci Cerco Lavoro</span>
                        {myJobSeekers.length > 0 && <span className="bg-sky-100 text-sky-700 text-xs font-bold px-2 py-0.5 rounded-full">{myJobSeekers.length}</span>}
                      </div>
                      <button
                        onClick={() => {
                          if (!professionalProfile) {
                            showToast('Devi prima creare un profilo professionale per pubblicare annunci cerco lavoro', 'info');
                            setOpen(prev => ({ ...prev, cust_prof: true }));
                          } else {
                            setShowJobSeekerForm(true);
                          }
                        }}
                        className="bg-sky-600 hover:bg-sky-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"
                      >
                        <Plus className="w-3 h-3" />Nuovo
                      </button>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {showJobSeekerForm && (
                        <div className="mb-4">
                          <JobSeekerForm
                            onSuccess={() => {
                              setShowJobSeekerForm(false);
                              const fmId = activeProfile?.isOwner === false ? activeProfile.id : null;
                              let q = supabase.from('job_seekers').select('*, profiles(full_name, nickname)').eq('user_id', profile!.id).order('created_at', { ascending: false });
                              if (fmId) q = q.eq('family_member_id', fmId);
                              else q = q.is('family_member_id', null);
                              q.then(({ data, error }) => {
                                if (error) console.error('Error reloading job seekers:', error);
                                else if (data) setMyJobSeekers(data);
                              });
                            }}
                            onCancel={() => setShowJobSeekerForm(false)}
                          />
                        </div>
                      )}
                      {myJobSeekers.length === 0 && !showJobSeekerForm ? (
                        <div className="text-center py-8">
                          <Briefcase className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-3">Non hai ancora pubblicato annunci cerco lavoro</p>
                          <button
                          onClick={() => {
                            if (!professionalProfile) {
                              showToast('Devi prima creare un profilo professionale per pubblicare annunci cerco lavoro', 'info');
                              setOpen(prev => ({ ...prev, cust_prof: true }));
                            } else {
                              setShowJobSeekerForm(true);
                            }
                          }}
                          className="bg-sky-600 text-white px-4 py-2 rounded-xl hover:bg-sky-700 transition-colors text-sm font-semibold"
                        >
                          Crea annuncio
                        </button>
                        </div>
                      ) : (
                        <div className="space-y-3">
                          {myJobSeekers.map(js => (
                            <JobSeekerCard key={js.id} jobSeeker={js} />
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Le Tue Recensioni */}
                {open.cust_reviews && (() => {
                  const activeFmId = activeProfile?.isOwner === false ? activeProfile.id : null;
                  const myReviews = reviews.filter(r => activeFmId ? r.family_member_id === activeFmId : !r.family_member_id);
                  return (
                    <div id="cust_reviews" className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                      <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                        <div className="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center"><Star className="w-4 h-4 text-amber-600" /></div>
                        <span className="font-semibold text-gray-900">Le Tue Recensioni</span>
                        {myReviews.length > 0 && <span className="bg-amber-100 text-amber-700 text-xs font-bold px-2 py-0.5 rounded-full">{myReviews.length}</span>}
                      </div>
                      <div className="px-5 pb-5">
                        {myReviews.length === 0 ? (
                          <p className="text-sm text-gray-500 text-center py-6">Non hai ancora scritto recensioni</p>
                        ) : (
                          <div className="space-y-4 pt-4">
                            {myReviews.map((review) => (
                              <div key={review.id}>
                                <ReviewCard review={review as any} />
                                {(review as any).review_status === 'pending' && (
                                  <p className="text-xs text-amber-600 mt-2 px-1 italic">La recensione è visibile al pubblico solo dopo l'approvazione dell'amministratore.</p>
                                )}
                                {(review as any).review_status === 'rejected' && (
                                  <p className="text-xs text-red-600 mt-2 px-1 italic">Questa recensione è stata rifiutata dall'amministratore.</p>
                                )}
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    </div>
                  );
                })()}

                {/* I Tuoi Annunci */}
                {open.cust_ads && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center"><Tag className="w-4 h-4 text-green-600" /></div>
                        <span className="font-semibold text-gray-900">I Tuoi Annunci</span>
                        {customerClassifiedAds.length > 0 && <span className="bg-green-100 text-green-700 text-xs font-bold px-2 py-0.5 rounded-full">{customerClassifiedAds.length}</span>}
                      </div>
                      <button onClick={() => { setEditingCustomerAdId(undefined); setShowCustomerAdForm(true); }} className="bg-green-600 hover:bg-green-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"><Plus className="w-3 h-3" />Nuovo</button>
                    </div>
                    <div className="px-5 pb-5">
                      {customerClassifiedAds.length === 0 ? (
                        <div className="text-center py-8">
                          <Tag className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-3">Nessun annuncio pubblicato</p>
                          <button onClick={() => { setEditingCustomerAdId(undefined); setShowCustomerAdForm(true); }} className="inline-flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-xl hover:bg-green-700 text-sm font-semibold"><Plus className="w-4 h-4" />Crea annuncio</button>
                        </div>
                      ) : (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pt-4">
                          {customerClassifiedAds.map(ad => (
                            <ProfileClassifiedAdCard key={ad.id} ad={{ ...ad, price: ad.price ? parseFloat(ad.price) : null, classified_categories: ad.classified_categories, profiles: { full_name: profile?.nickname || profile?.full_name || 'Utente', avatar_url: null } }} onEdit={(a) => { setEditingCustomerAdId(a.id); setShowCustomerAdForm(true); }} onDelete={deleteAd} />
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Le Mie Aste */}
                {open.cust_auctions && <UserAuctionsSection />}

                {/* Annunci Preferiti */}
                {open.cust_fav_ads && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center"><Heart className="w-4 h-4 text-red-500" /></div>
                      <span className="font-semibold text-gray-900">Annunci Preferiti</span>
                    </div>
                    <FavoritesSection />
                  </div>
                )}

                {/* Attivita Preferite */}
                {open.cust_fav_biz && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-rose-100 rounded-lg flex items-center justify-center"><Building className="w-4 h-4 text-rose-500" /></div>
                      <span className="font-semibold text-gray-900">Attivita Preferite</span>
                    </div>
                    <FavoritesSection />
                  </div>
                )}

                {/* Cambia Piano Privato */}
                {currentSubscription && availablePlans.length > 0 && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <button onClick={() => toggle('cust_plans')} className="w-full flex items-center justify-between px-5 py-4 hover:bg-gray-50 transition-colors">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center"><Shield className="w-4 h-4 text-gray-600" /></div>
                        <span className="font-semibold text-gray-900">Cambia Piano</span>
                        <span className="bg-gray-100 text-gray-600 text-xs font-bold px-2 py-0.5 rounded-full">{currentSubscription.plan.name}</span>
                      </div>
                      {open.cust_plans ? <ChevronUp className="w-4 h-4 text-gray-400" /> : <ChevronDown className="w-4 h-4 text-gray-400" />}
                    </button>
                    {open.cust_plans && (
                      <div className="px-5 pb-5 border-t border-gray-100 pt-4">
                        <div className="bg-gradient-to-br from-green-50 to-blue-50 border border-green-200 rounded-xl p-5 mb-4">
                          <div className="flex items-center gap-3 mb-3">
                            <div className="w-9 h-9 bg-green-500 rounded-full flex items-center justify-center"><Heart className="w-5 h-5 text-white" fill="currentColor" /></div>
                            <h3 className="font-bold text-gray-900">10% in Beneficenza</h3>
                          </div>
                          <p className="text-sm text-gray-700 mb-3">Ogni anno Lhimo dona il <strong>10% del fatturato</strong> ad associazioni di beneficenza.</p>
                          <div className="grid grid-cols-3 gap-2">
                            <div className="bg-white/80 rounded-lg p-2 text-center"><Gift className="w-4 h-4 text-green-600 mx-auto mb-1" /><p className="text-xs font-semibold text-gray-900">Trasparenza</p></div>
                            <div className="bg-white/80 rounded-lg p-2 text-center"><UsersIcon className="w-4 h-4 text-green-600 mx-auto mb-1" /><p className="text-xs font-semibold text-gray-900">Voti Utenti</p></div>
                            <div className="bg-white/80 rounded-lg p-2 text-center"><TrendingUp className="w-4 h-4 text-green-600 mx-auto mb-1" /><p className="text-xs font-semibold text-gray-900">Impatto Reale</p></div>
                          </div>
                        </div>
                        {upgradeMessage && <div className={`mb-4 p-3 rounded-xl text-sm ${upgradeMessage.includes('successo') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>{upgradeMessage}</div>}
                        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-3">
                          {availablePlans.map((plan) => {
                            const monthly = availablePlans.find(p => p.max_persons === plan.max_persons && p.billing_period === 'monthly');
                            const savings = plan.billing_period === 'yearly' && monthly ? (monthly.price * 12) - plan.price : null;
                            const isCurrent = currentSubscription.plan.id === plan.id;
                            return (
                              <div key={plan.id} className={`rounded-xl p-4 border-2 relative ${isCurrent ? 'border-yellow-500 bg-yellow-50' : plan.billing_period === 'yearly' ? 'border-green-400 ring-2 ring-green-100' : 'border-gray-200 hover:border-blue-400'}`}>
                                {plan.billing_period === 'yearly' && !isCurrent && <div className="absolute -top-2.5 left-1/2 -translate-x-1/2"><span className="inline-flex items-center gap-1 bg-green-500 text-white text-xs font-bold px-2.5 py-0.5 rounded-full"><Star className="w-2.5 h-2.5" fill="currentColor" />RISPARMIO</span></div>}
                                <h3 className="font-bold text-gray-900 text-sm mb-0.5">{plan.name}</h3>
                                <p className="text-xs text-gray-500 mb-3">{plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'} · {plan.max_persons} {plan.max_persons === 1 ? 'persona' : 'persone'}</p>
                                <p className="text-2xl font-bold text-blue-600 mb-0.5">€{Number(plan.price).toFixed(2)}</p>
                                <p className="text-xs text-gray-400 mb-2">/{plan.billing_period === 'monthly' ? 'mese' : 'anno'}</p>
                                {savings && <p className="text-xs text-green-600 font-semibold mb-3">Risparmi €{savings.toFixed(2)}</p>}
                                <div className="space-y-1 mb-3">
                                  {['Recensioni illimitate', 'Salva preferiti', 'Pubblica annunci'].map(f => (
                                    <div key={f} className="flex items-center gap-1.5 text-xs text-gray-600"><Check className="w-3 h-3 text-green-600 flex-shrink-0" />{f}</div>
                                  ))}
                                </div>
                                {isCurrent ? <div className="w-full bg-green-600 text-white py-2 rounded-lg text-xs font-semibold text-center">Piano Attuale</div> : <button onClick={() => handleChangePlan(plan.id)} className={`w-full py-2 rounded-lg text-xs font-semibold transition-colors ${plan.billing_period === 'yearly' ? 'bg-green-600 text-white hover:bg-green-700' : 'bg-blue-600 text-white hover:bg-blue-700'}`}>Cambia Piano</button>}
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    )}
                  </div>
                )}
              </>
            )}
          </div>
        )}

        {/* Modali */}
        {showCreateBusinessForm && user && (
          <UserAddBusinessModal
            userId={user.id}
            familyMemberId={activeProfile?.isOwner === false ? activeProfile.id : null}
            onSuccess={() => { setShowCreateBusinessForm(false); loadData(); }}
            onCancel={() => setShowCreateBusinessForm(false)}
          />
        )}
        {showClassifiedAdForm && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
              <ClassifiedAdForm adId={editingClassifiedAdId} onSuccess={() => { setShowClassifiedAdForm(false); loadAds(); }} onCancel={() => setShowClassifiedAdForm(false)} />
            </div>
          </div>
        )}
        {showCustomerAdForm && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
              <ClassifiedAdForm adId={editingCustomerAdId} onSuccess={() => { setShowCustomerAdForm(false); loadAds(); }} onCancel={() => setShowCustomerAdForm(false)} />
            </div>
          </div>
        )}
        {showResponseForm && (
          <ReviewResponseForm reviewId={showResponseForm} onClose={() => setShowResponseForm(null)} onSuccess={() => { setShowResponseForm(null); loadData(); }} />
        )}
      </div>
    </div>
  );
}
