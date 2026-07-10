import { useState, useEffect } from 'react';
import { Users, FileEdit as Edit, Save, X, Plus, Trash2, TrendingUp, AlertTriangle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { FamilyMemberAvatarUpload } from './FamilyMemberAvatarUpload';
import { SearchableSelect } from '../common/SearchableSelect';
import { CategoryHierarchySelect } from '../common/CategoryHierarchySelect';
import { useToast } from '../common/Toast';

interface FamilyMember {
  id: string;
  first_name: string;
  last_name: string;
  nickname: string;
  relationship: string;
  date_of_birth: string;
  fiscal_code: string;
  avatar_url: string | null;
  resume_url: string | null;
  category_id: string | null;
}

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
}

interface EditFamilyMembersFormProps {
  customerId: string;
  onUpdate: () => void;
}

export function EditFamilyMembersForm({ customerId, onUpdate }: EditFamilyMembersFormProps) {
  const { showToast } = useToast();
  const [isEditing, setIsEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentSubscription, setCurrentSubscription] = useState<Subscription | null>(null);
  const [nextPlan, setNextPlan] = useState<SubscriptionPlan | null>(null);
  const [showUpgradePrompt, setShowUpgradePrompt] = useState(false);
  const [categories, setCategories] = useState<{ id: string; name: string; parent_id: string | null }[]>([]);

  useEffect(() => {
    loadFamilyMembers();
    loadSubscriptionData();
    supabase.from('business_categories').select('id, name, parent_id').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, [customerId]);

  const loadFamilyMembers = async () => {
    setLoading(true);
    const { data } = await supabase
      .from('customer_family_members')
      .select('*')
      .eq('customer_id', customerId)
      .order('created_at', { ascending: true });

    if (data) {
      setFamilyMembers(data);
    }
    setLoading(false);
  };

  const loadSubscriptionData = async () => {
    try {
      const { data: subscriptionData } = await supabase
        .from('subscriptions')
        .select('id, status, plan:subscription_plans(id, name, price, billing_period, max_persons)')
        .eq('customer_id', customerId)
        .in('status', ['active', 'trial'])
        .maybeSingle();

      if (subscriptionData) {
        setCurrentSubscription(subscriptionData as any);

        const currentMaxPersons = (subscriptionData.plan as any).max_persons;
        const billingPeriod = (subscriptionData.plan as any).billing_period;

        const { data: nextPlanData } = await supabase
          .from('subscription_plans')
          .select('*')
          .not('name', 'like', '%Business%')
          .eq('billing_period', billingPeriod)
          .gt('max_persons', currentMaxPersons)
          .order('max_persons', { ascending: true })
          .limit(1)
          .maybeSingle();

        if (nextPlanData) {
          setNextPlan(nextPlanData);
        }
      }
    } catch (error) {
      console.error('Error loading subscription data:', error);
    }
  };

  const handleAddMember = () => {
    if (!currentSubscription) return;

    const maxPersons = currentSubscription.plan.max_persons;
    const totalPersons = familyMembers.length + 1;

    if (totalPersons >= maxPersons) {
      setShowUpgradePrompt(true);
      return;
    }

    setFamilyMembers([
      ...familyMembers,
      {
        id: `new-${Date.now()}`,
        first_name: '',
        last_name: '',
        nickname: '',
        relationship: 'Coniuge',
        date_of_birth: '',
        fiscal_code: '',
        avatar_url: null,
        resume_url: null,
        category_id: null,
      },
    ]);
  };

  const updateSubscription = async (totalPersons: number) => {
    const { data: currentSub } = await supabase
      .from('subscriptions')
      .select('id, plan:subscription_plans(billing_period)')
      .eq('customer_id', customerId)
      .eq('status', 'active')
      .maybeSingle();

    if (!currentSub || !currentSub.plan) return;

    const billingPeriod = (currentSub.plan as any).billing_period;

    const personsKey = totalPersons > 4 ? 4 : totalPersons;

    const { data: newPlan } = await supabase
      .from('subscription_plans')
      .select('id, price')
      .eq('max_persons', personsKey)
      .eq('billing_period', billingPeriod)
      .not('name', 'like', '%Business%')
      .maybeSingle();

    if (newPlan) {
      const endDate = new Date();
      if (billingPeriod === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else {
        endDate.setFullYear(endDate.getFullYear() + 1);
      }

      await supabase
        .from('subscriptions')
        .update({
          plan_id: newPlan.id,
          end_date: endDate.toISOString(),
        })
        .eq('id', currentSub.id);

      await supabase
        .from('profiles')
        .update({
          subscription_expires_at: endDate.toISOString(),
        })
        .eq('id', customerId);
    }
  };

  const handleRemoveMember = async (id: string) => {
    if (id.startsWith('new-')) {
      setFamilyMembers(familyMembers.filter(m => m.id !== id));
    } else {
      if (!confirm('Sei sicuro di voler rimuovere questo membro?')) return;

      const { error } = await supabase
        .from('customer_family_members')
        .delete()
        .eq('id', id);

      if (error) {
        console.error('Error deleting family member:', error);
        showToast('Errore durante l\'eliminazione', 'error');
      } else {
        setFamilyMembers(familyMembers.filter(m => m.id !== id));
        const newTotal = familyMembers.filter(m => m.id !== id).length + 1;
        await updateSubscription(newTotal);
        await loadSubscriptionData(); // Ricarica la subscription aggiornata
        onUpdate();
      }
    }
  };

  const handleChange = (id: string, field: keyof FamilyMember, value: string) => {
    setFamilyMembers(familyMembers.map(member =>
      member.id === id ? { ...member, [field]: value } : member
    ));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      for (const member of familyMembers) {
        if (member.id.startsWith('new-')) {
          const { error } = await supabase
            .from('customer_family_members')
            .insert({
              customer_id: customerId,
              first_name: member.first_name,
              last_name: member.last_name,
              nickname: member.nickname,
              relationship: member.relationship,
              date_of_birth: member.date_of_birth,
              fiscal_code: member.fiscal_code,
              category_id: member.category_id || null,
            });

          if (error) throw error;
        } else {
          const { error } = await supabase
            .from('customer_family_members')
            .update({
              first_name: member.first_name,
              last_name: member.last_name,
              nickname: member.nickname,
              relationship: member.relationship,
              date_of_birth: member.date_of_birth,
              fiscal_code: member.fiscal_code,
              category_id: member.category_id || null,
            })
            .eq('id', member.id);

          if (error) throw error;
        }
      }

      const totalPersons = familyMembers.length + 1;
      await updateSubscription(totalPersons);

      setIsEditing(false);
      await loadFamilyMembers();
      await loadSubscriptionData(); // Ricarica la subscription aggiornata
      onUpdate();
    } catch (error) {
      console.error('Error updating family members:', error);
      showToast('Errore durante il salvataggio', 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = () => {
    loadFamilyMembers();
    setIsEditing(false);
  };

  const handleUpgradePlan = async () => {
    if (!nextPlan || !currentSubscription) return;

    try {
      const endDate = new Date();
      if (nextPlan.billing_period === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else {
        endDate.setFullYear(endDate.getFullYear() + 1);
      }

      const { error: updateError } = await supabase
        .from('subscriptions')
        .update({
          plan_id: nextPlan.id,
          end_date: endDate.toISOString(),
        })
        .eq('id', currentSubscription.id);

      if (updateError) throw updateError;

      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          subscription_expires_at: endDate.toISOString(),
        })
        .eq('id', customerId);

      if (profileError) throw profileError;

      showToast('Piano aggiornato con successo! La pagina verrà ricaricata.', 'success');
      window.location.reload();
    } catch (error) {
      console.error('Error upgrading plan:', error);
      showToast('Errore durante l\'aggiornamento del piano', 'error');
    }
  };

  if (loading) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8 mb-8">
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
        </div>
      </div>
    );
  }

  if (!isEditing) {
    const maxPersons = currentSubscription?.plan.max_persons || 1;
    const totalPersons = familyMembers.length + 1;
    const isAtLimit = totalPersons >= maxPersons;

    return (
      <div className="bg-white rounded-xl shadow-md p-8 mb-8">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <Users className="w-6 h-6 text-blue-600" />
            <div>
              <h2 className="text-2xl font-bold text-gray-900">Membri della Famiglia</h2>
              <p className="text-sm text-gray-600 mt-1">
                {familyMembers.length}/{maxPersons - 1} membri aggiunti
              </p>
              {currentSubscription && (
                <p className="text-xs text-gray-500 mt-1">
                  Piano: {currentSubscription.plan.name} (fino a {maxPersons} persone totali)
                </p>
              )}
            </div>
          </div>
          <button
            onClick={() => setIsEditing(true)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Edit className="w-4 h-4" />
            Modifica
          </button>
        </div>

        {isAtLimit && nextPlan && (
          <div className="mb-6 bg-gradient-to-br from-yellow-50 to-orange-50 border-2 border-yellow-400 rounded-xl p-6">
            <div className="flex items-start gap-4">
              <div className="flex-shrink-0">
                <div className="w-12 h-12 bg-yellow-500 rounded-full flex items-center justify-center">
                  <AlertTriangle className="w-6 h-6 text-white" />
                </div>
              </div>
              <div className="flex-1">
                <h3 className="text-lg font-bold text-gray-900 mb-2">
                  Limite Piano Raggiunto
                </h3>
                <p className="text-gray-700 mb-4">
                  Hai raggiunto il limite massimo di {maxPersons} persone totali per il tuo piano attuale.
                  Per aggiungere altri membri della famiglia, effettua l'upgrade al piano superiore.
                </p>
                <div className="bg-white rounded-lg p-4 mb-4 border border-yellow-200">
                  <div className="flex items-center justify-between mb-2">
                    <div>
                      <p className="font-bold text-gray-900">{nextPlan.name}</p>
                      <p className="text-sm text-gray-600">Fino a {nextPlan.max_persons} persone</p>
                    </div>
                    <div className="text-right">
                      <p className="text-2xl font-bold text-blue-600">€{nextPlan.price.toFixed(2)}</p>
                      <p className="text-xs text-gray-600">{nextPlan.billing_period === 'monthly' ? 'al mese' : 'all\'anno'}</p>
                    </div>
                  </div>
                </div>
                <button
                  onClick={handleUpgradePlan}
                  className="w-full flex items-center justify-center gap-2 bg-yellow-500 text-white px-6 py-3 rounded-lg hover:bg-yellow-600 transition-colors font-semibold"
                >
                  <TrendingUp className="w-5 h-5" />
                  Passa a {nextPlan.name}
                </button>
              </div>
            </div>
          </div>
        )}

        {familyMembers.length === 0 ? (
          <div className="text-center py-8">
            <p className="text-gray-600 mb-2">Nessun membro della famiglia aggiunto</p>
            <p className="text-sm text-gray-500">Puoi aggiungere fino a {maxPersons - 1} membri</p>
          </div>
        ) : (
          <div className="space-y-6">
            {familyMembers.map((member, index) => (
              <div key={member.id} className="border border-gray-200 rounded-lg p-6 bg-gray-50">
                <div className="flex items-start gap-6 mb-4">
                  <FamilyMemberAvatarUpload
                    memberId={member.id}
                    currentAvatarUrl={member.avatar_url}
                    onAvatarUpdate={loadFamilyMembers}
                  />
                  <div className="flex-1">
                    <h3 className="font-bold text-lg text-gray-900 mb-4">Membro {index + 1}</h3>
                  </div>
                </div>
                <div className="grid md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Nome</p>
                    <p className="text-lg font-semibold text-gray-900">{member.first_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Cognome</p>
                    <p className="text-lg font-semibold text-gray-900">{member.last_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Nickname</p>
                    <p className="text-lg font-semibold text-gray-900">{member.nickname}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Relazione</p>
                    <p className="text-lg font-semibold text-gray-900">{member.relationship || 'Familiare'}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Data di Nascita</p>
                    <p className="text-lg font-semibold text-gray-900">
                      {new Date(member.date_of_birth).toLocaleDateString('it-IT')}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Codice Fiscale</p>
                    <p className="text-lg font-semibold text-gray-900">{member.fiscal_code}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 mb-1">Categoria</p>
                    <p className="text-lg font-semibold text-gray-900">
                      {member.category_id
                        ? categories.find(c => c.id === member.category_id)?.name || '-'
                        : '-'}
                    </p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  const maxPersons = currentSubscription?.plan.max_persons || 1;
  const totalPersons = familyMembers.length + 1;
  const isAtLimit = totalPersons >= maxPersons;

  return (
    <div className="bg-white rounded-xl shadow-md p-8 mb-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Users className="w-6 h-6 text-blue-600" />
          <div>
            <h2 className="text-2xl font-bold text-gray-900">Modifica Membri della Famiglia</h2>
            {currentSubscription && (
              <p className="text-xs text-gray-500 mt-1">
                Piano: {currentSubscription.plan.name} (fino a {maxPersons} persone totali)
              </p>
            )}
          </div>
        </div>
        <button
          onClick={handleCancel}
          className="text-gray-600 hover:text-gray-800"
        >
          <X className="w-6 h-6" />
        </button>
      </div>

      {showUpgradePrompt && nextPlan && (
        <div className="mb-6 bg-gradient-to-br from-yellow-50 to-orange-50 border-2 border-yellow-400 rounded-xl p-6">
          <div className="flex items-start gap-4">
            <div className="flex-shrink-0">
              <div className="w-12 h-12 bg-yellow-500 rounded-full flex items-center justify-center">
                <AlertTriangle className="w-6 h-6 text-white" />
              </div>
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-bold text-gray-900 mb-2">
                Limite Piano Raggiunto
              </h3>
              <p className="text-gray-700 mb-4">
                Hai raggiunto il limite massimo di {maxPersons} persone totali per il tuo piano attuale.
                Per aggiungere altri membri della famiglia, effettua l'upgrade al piano superiore.
              </p>
              <div className="bg-white rounded-lg p-4 mb-4 border border-yellow-200">
                <div className="flex items-center justify-between mb-2">
                  <div>
                    <p className="font-bold text-gray-900">{nextPlan.name}</p>
                    <p className="text-sm text-gray-600">Fino a {nextPlan.max_persons} persone</p>
                  </div>
                  <div className="text-right">
                    <p className="text-2xl font-bold text-blue-600">€{nextPlan.price.toFixed(2)}</p>
                    <p className="text-xs text-gray-600">{nextPlan.billing_period === 'monthly' ? 'al mese' : 'all\'anno'}</p>
                  </div>
                </div>
              </div>
              <div className="flex gap-3">
                <button
                  type="button"
                  onClick={handleUpgradePlan}
                  className="flex-1 flex items-center justify-center gap-2 bg-yellow-500 text-white px-6 py-3 rounded-lg hover:bg-yellow-600 transition-colors font-semibold"
                >
                  <TrendingUp className="w-5 h-5" />
                  Passa a {nextPlan.name}
                </button>
                <button
                  type="button"
                  onClick={() => setShowUpgradePrompt(false)}
                  className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
                >
                  Chiudi
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div className="space-y-6 mb-6">
          {familyMembers.map((member, index) => (
            <div key={member.id} className="border-2 border-gray-200 rounded-lg p-6 bg-gray-50">
              <div className="flex items-start justify-between mb-6">
                <div className="flex items-start gap-6">
                  {!member.id.startsWith('new-') && (
                    <FamilyMemberAvatarUpload
                      memberId={member.id}
                      currentAvatarUrl={member.avatar_url}
                      onAvatarUpdate={loadFamilyMembers}
                    />
                  )}
                  <div>
                    <h3 className="font-bold text-lg text-gray-900">Membro {index + 1}</h3>
                    {member.id.startsWith('new-') && (
                      <p className="text-sm text-gray-600 mt-1">
                        Salva per poter caricare l'avatar
                      </p>
                    )}
                  </div>
                </div>
                <button
                  type="button"
                  onClick={() => handleRemoveMember(member.id)}
                  className="text-red-600 hover:text-red-700 flex items-center gap-1"
                >
                  <Trash2 className="w-4 h-4" />
                  Rimuovi
                </button>
              </div>

              <div className="grid md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Nome
                  </label>
                  <input
                    type="text"
                    value={member.first_name}
                    onChange={(e) => handleChange(member.id, 'first_name', e.target.value)}
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Cognome
                  </label>
                  <input
                    type="text"
                    value={member.last_name}
                    onChange={(e) => handleChange(member.id, 'last_name', e.target.value)}
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Nickname
                  </label>
                  <input
                    type="text"
                    value={member.nickname}
                    onChange={(e) => handleChange(member.id, 'nickname', e.target.value)}
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Relazione
                  </label>
                  <SearchableSelect
                    value={member.relationship}
                    onChange={(value) => handleChange(member.id, 'relationship', value)}
                    options={[
                      { value: 'Coniuge', label: 'Coniuge' },
                      { value: 'Figlio/a', label: 'Figlio/a' },
                      { value: 'Genitore', label: 'Genitore' },
                      { value: 'Fratello/Sorella', label: 'Fratello/Sorella' },
                      { value: 'Amico/a', label: 'Amico/a' },
                      { value: 'Altro', label: 'Altro familiare' },
                    ]}
                    placeholder="Seleziona relazione"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Data di Nascita
                  </label>
                  <input
                    type="date"
                    value={member.date_of_birth}
                    onChange={(e) => handleChange(member.id, 'date_of_birth', e.target.value)}
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Codice Fiscale
                  </label>
                  <input
                    type="text"
                    value={member.fiscal_code}
                    onChange={(e) => handleChange(member.id, 'fiscal_code', e.target.value.toUpperCase())}
                    required
                    maxLength={16}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Categoria
                  </label>
                  <CategoryHierarchySelect
                    value={member.category_id || ''}
                    onChange={(value) => handleChange(member.id, 'category_id', value)}
                    categories={categories}
                    placeholder="Seleziona la categoria"
                  />
                  <p className="text-xs text-gray-500 mt-1">Viene mostrata nelle attivita aggiunte da questo membro</p>
                </div>
              </div>
            </div>
          ))}
        </div>

        {!isAtLimit ? (
          <button
            type="button"
            onClick={handleAddMember}
            className="flex items-center gap-2 bg-gray-200 text-gray-700 px-6 py-3 rounded-lg hover:bg-gray-300 transition-colors font-semibold mb-6 w-full"
          >
            <Plus className="w-5 h-5" />
            Aggiungi Membro ({familyMembers.length}/{maxPersons - 1})
          </button>
        ) : (
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-6">
            <div className="flex items-center gap-3">
              <AlertTriangle className="w-5 h-5 text-yellow-600" />
              <div className="flex-1">
                <p className="text-yellow-800 font-semibold">
                  Limite piano raggiunto ({totalPersons}/{maxPersons} persone)
                </p>
                {nextPlan && (
                  <button
                    type="button"
                    onClick={() => setShowUpgradePrompt(true)}
                    className="text-sm text-blue-600 hover:text-blue-700 font-medium mt-1 underline"
                  >
                    Passa a {nextPlan.name} per aggiungere più membri
                  </button>
                )}
              </div>
            </div>
          </div>
        )}

        <div className="flex gap-3">
          <button
            type="submit"
            disabled={saving}
            className="flex items-center gap-2 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold disabled:opacity-50"
          >
            <Save className="w-5 h-5" />
            {saving ? 'Salvataggio...' : 'Salva Modifiche'}
          </button>
          <button
            type="button"
            onClick={handleCancel}
            className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
          >
            Annulla
          </button>
        </div>
      </form>
    </div>
  );
}
